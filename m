Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2CF14F390
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgAaVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 16:07:18 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:39024 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgAaVHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 16:07:17 -0500
Received: by mail-lj1-f180.google.com with SMTP id o15so2983875ljg.6
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 13:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pxJROTyzT1jYxa/uxoScWfBiu6dpk9l0ypZI0WlHElE=;
        b=Uy3tV2J2BamqsqPl3OjfFMuPDQw1a7LvD1NegqJHrZKqw2pDUpBwIALE7PWnkpdtjM
         wuW1b49rvHSCuYNQTAL97eOkQcnhhTDSSv+yl0niZqmRr0uSi2kzPSoIK/Y3qQPCfoou
         bnzaZtIP05jjNLSSsdHzkdYc3mT2Ju03Dhar8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pxJROTyzT1jYxa/uxoScWfBiu6dpk9l0ypZI0WlHElE=;
        b=TWf2DJ0sIv9y5xCkALt5qSq0o7oPvuP5KaFoD4ZfXFHuOTbT8oDlzVczHcPi3VcWLV
         Za0pLkx4hjco9JMqE25HVUAyZA+NhLs+yhY1V1TlIBgCcTgOex7p8p/ACkl8/JhACPAc
         0Eu3SbdJNnqVkAFh6sRPNjXpUu31OSlLv+F8jaLSHvNFAJmRJLsisWeW/+GSe+iqFEtm
         68ejebvl9/n2v9i4lqaXmq8tSLrzJwxufVt2e5ICf6ms7ZIP7yaL3Cydd9+xYeVFHe71
         FMW+YpHuld9k7D+egfJp0qkmh2njRwn/k7IAO+z1dcZL8rBXKeZpCOfvUiVBg6wvjiyC
         q5gQ==
X-Gm-Message-State: APjAAAUyTvCENwk4EVTm2e4zMK1WwtOrRObuvicWTokUjznNAAPFc9LV
        BEhq1iUSjS8zmsWu/HZaM1r4bob5djg=
X-Google-Smtp-Source: APXvYqwjCcMGGVRGy2tl2/8953WdbPWoZonc2JO/raJrZpc05TD9aRKcLlAYIM4Ih4528pi4ucW9KQ==
X-Received: by 2002:a2e:574d:: with SMTP id r13mr6876774ljd.63.1580504834222;
        Fri, 31 Jan 2020 13:07:14 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id t9sm5134326lfl.51.2020.01.31.13.07.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 13:07:13 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id x14so8463761ljd.13
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 13:07:13 -0800 (PST)
X-Received: by 2002:a2e:580c:: with SMTP id m12mr7090112ljb.150.1580504832773;
 Fri, 31 Jan 2020 13:07:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd68d0059c74a1db@google.com> <000000000000ed3a48059d17277e@google.com>
 <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com> <CAM_iQpUO2s2j0gbjYp8J3Q7J-peLChxL71+tzR0d6SphMZ7Aiw@mail.gmail.com>
In-Reply-To: <CAM_iQpUO2s2j0gbjYp8J3Q7J-peLChxL71+tzR0d6SphMZ7Aiw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 31 Jan 2020 13:06:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4Vc-SVMzFE5fKy5AP1P0GTozP_vmDOCJuspcu9wxpjg@mail.gmail.com>
Message-ID: <CAHk-=wg4Vc-SVMzFE5fKy5AP1P0GTozP_vmDOCJuspcu9wxpjg@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Marco Elver <elver@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        jeremy@azazel.net, Kate Stewart <kstewart@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 1:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> It is supposed to be fixed by commit 32c72165dbd0

Ahh, thanks, I missed that. I actually looked at the current code and
saw the bitmap_zalloc() and it all looked fine, and assumed there was
some other bug in the elements calculation.

I didn't realize that it looked fine because it had already been fixed.

Thanks,
             Linus
