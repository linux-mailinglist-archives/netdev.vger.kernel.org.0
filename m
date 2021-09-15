Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7286C40CD77
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhIOTwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhIOTwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 15:52:01 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C34C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:50:42 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x27so8879925lfu.5
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nI3oXjB5y7fgBDUAfkrt5Qjrdw7kij1HF6V7usZScd0=;
        b=dDkQ2iIzDzvrHagUv0HQt/yEqNuVlVfROtNamlO02CizTu2FICtXWd210Bes/CwlqB
         vjF/fdxzFxIz7v0M5Mc4QD77K9x8ec18TENbGfCqGbSG3HiLnbhqoA4lCtQEqvSsm3+w
         v6hYS+kH7FyOqPuDkRIGswKh56YqlIWBTmiYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nI3oXjB5y7fgBDUAfkrt5Qjrdw7kij1HF6V7usZScd0=;
        b=kX09mJCk6fZU8BtDsIy2ElH3uDTEo0QRiZC+exinRGRxE0tAMNG+c7KOJYZgFjJdKE
         IrXubNkGhJte/eA8FRc76cz6FxODinT1Ger8q1/Ceg5i28/KlGCXD+6aqZaMRl8Zyo25
         MzfekSl1BguBRh6JVLBI/ZhCwBS0lonr5M5GhFKIM4sj6TCXf3JF3ygZjvJq4hJVwtT4
         nSFOkxiNdMi8vF5tRagzlqoyAVWei/+wgqw28Q9pfbKAIQc2mxj922MrCriqA+KPAxtn
         LymbWajbP/NYH29Cg0B79AiDgfDEn76/gt3fZMAKXN35GqYPt6aF1tLYfC6xPyPwGyt0
         kjcg==
X-Gm-Message-State: AOAM532fWtgyujvv6RBlH04R/cnScs3H8z4zKqrsO9201QLJjvGh+p71
        BHqX7Q9nesNIhxhQDrcyW5why/gKGFeaD9chwdo=
X-Google-Smtp-Source: ABdhPJzsJxI4dm5FDYATPnhj0MfhjRm45Pk3hRWPEY+/n57ouEIDHXhyPsIlNzMtXiBjQxIeu/kCiA==
X-Received: by 2002:a05:6512:1308:: with SMTP id x8mr1243081lfu.161.1631735440385;
        Wed, 15 Sep 2021 12:50:40 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id v27sm72286lfp.0.2021.09.15.12.50.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 12:50:39 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id p29so8801793lfa.11
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:50:38 -0700 (PDT)
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr1268421lfu.280.1631735438424;
 Wed, 15 Sep 2021 12:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net> <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
 <47fcc9cc-7d2e-bc79-122b-8eccfe00d8f3@roeck-us.net> <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
In-Reply-To: <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Sep 2021 12:50:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSkMh9mc7+OSBZZvpoEEJmS6qY7kX3qixEXTLKGc=wgw@mail.gmail.com>
Message-ID: <CAHk-=whSkMh9mc7+OSBZZvpoEEJmS6qY7kX3qixEXTLKGc=wgw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 12:47 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> What other notable issues end up being still live? I sent out that one
> patch for sparc, but didn't get any response to it. I'm inclined to
> just apply it (the 'struct mdesc_hdr' pointer misuse one).

Oh, I forgot about the qnx4 one. That happens on sparc, possibly
others, but not on x86-64.

I'll go look at that patch too.

          Linus
