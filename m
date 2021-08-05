Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C468E3E1CBC
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242990AbhHETah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhHETae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:30:34 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37EC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 12:30:19 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p38so13337742lfa.0
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 12:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4/RddrnSiQlKYlUaXMtukJmyIUY69TH1cBRlEevecY0=;
        b=MCKUw5JBk9VC4LN6XLDfphfslksKy/gZOgkiN1zcwO4T+i+hYHKPj+9n1Hwiahdt9x
         EbNckV58u6O+VlvHLa6Fp1cv7gDFPdHlG08kDZhkYZJQr2i86HsKunPxGh3YKkhaFySL
         FSDFYbjak0pzDzB3CA3dBABzxXa4UOLUqeVC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4/RddrnSiQlKYlUaXMtukJmyIUY69TH1cBRlEevecY0=;
        b=MiEXkTJQYB44QRe02OMqiO+Ud26a0+TxxfGeKx+NSV/CymBuez4FU6v3lq8wqI9aRe
         SprPr7GTVAEkkbfw67xTBEqST2aBjWqoX0WS2Uq6+HQFaRx9/oUUOG0KtPY+KIRwqh7s
         EtsDoszaruI1QBDCgiK4lw32ldRrfL8HczIwAyrWLFQ7LYj+gvjQ58XGQ0DChqfVv7Z7
         2OwRHo9Yprq+0426eoHwh0G/TnvJ9qhErBlrq7JOU9WJO1lhSIeMHNraub6wEyMr+T1D
         14UcQKplo3jRwvFLDTz6CBA9g76pUsuy917rL83cHYNGCUX4Nuy1nbp7SJlRU8UJKsfZ
         9rRQ==
X-Gm-Message-State: AOAM533LpAiRzf+u+m+73L5uT96HCZse+mIURYK14LRTuC1p8r1j439a
        NPmRy5zBZnpQqgsztxbsKa1awfcfJTKTsdTgOzM=
X-Google-Smtp-Source: ABdhPJyqgKv2AnBFrYWy6q6xcR5XqgsymF8V4Q9wjyay/aNJM9GCOps0vn7PbHdYrARb06+sYun6gw==
X-Received: by 2002:a05:6512:1329:: with SMTP id x41mr3906946lfu.327.1628191817372;
        Thu, 05 Aug 2021 12:30:17 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id br38sm598614lfb.106.2021.08.05.12.30.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 12:30:16 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id f42so13196701lfv.7
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 12:30:16 -0700 (PDT)
X-Received: by 2002:a19:fc06:: with SMTP id a6mr4662858lfi.377.1628191816465;
 Thu, 05 Aug 2021 12:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210805154335.1070064-1-kuba@kernel.org>
In-Reply-To: <20210805154335.1070064-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Aug 2021 12:30:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
Message-ID: <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.14-rc5
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 8:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Small PR this week, maybe it's cucumber time, maybe just bad
> timing vs subtree PRs, maybe both.

"Cucumber time"?

Google informs me about this concept, but I'd never heard that term before.

           Linus
