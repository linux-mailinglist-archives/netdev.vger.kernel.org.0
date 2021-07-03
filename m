Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98C3BA801
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 11:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhGCJNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 05:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhGCJNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 05:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7A161352
        for <netdev@vger.kernel.org>; Sat,  3 Jul 2021 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625303441;
        bh=AI0R4dARGwpgMuy7x46i+CJdYEsKCzocXYwQDBMQpUg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EoUZhPH30Qh7ef/TX0sIXBih1Lwq4ueAj55UkmPTGTRj3mEx1d6R3NSw57gNP4tjU
         0F9iVkuacYQKc9hUcpdBTMnWFw4v8SgVMDuRG+vADO6/ZGeHPAkv20Vk+N4TLqc8W3
         Yghs74im5qnI9DfHvJp/aqvRVGIkkw1m8TJUfLtHXtkPmrueNPILGSzPYqNySBrbfT
         eKYarTEEZIi8a1emqxlE4QqC+XtnkZYb5ZbTalgsDll40Dw5oZWI4ITbpJGgqWWHPm
         lQpeMNei4Ek6+EjyAsJ30ws42ePdHnFnWtipWxSiSoaleEfEjSmy0ZTmfb95qA5Qn4
         PmSwWU7sB3KnA==
Received: by mail-wr1-f52.google.com with SMTP id t6so5593427wrm.9
        for <netdev@vger.kernel.org>; Sat, 03 Jul 2021 02:10:41 -0700 (PDT)
X-Gm-Message-State: AOAM530Qbow/21ePnsPPFbskYKqbm8coo1KsyFIKQJMEG40XgvRmt57E
        Z2AxbW8n5T2Vs+dD5BbZbsS44cGDbvtWaSPmcG8=
X-Google-Smtp-Source: ABdhPJwJi03jgH+axgghJgZehsiJD9XbwGA1m3/MxeFd0xe0FJNlQVFPd7C5xs3rG08C4S3MbkyVHstqijyMTUfrYXs=
X-Received: by 2002:adf:e107:: with SMTP id t7mr4316492wrz.165.1625303439929;
 Sat, 03 Jul 2021 02:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B560A8.8000800@gmail.com>
 <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
 <60D361FF.70905@gmail.com> <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
 <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com> <60DF62DA.6030508@gmail.com>
In-Reply-To: <60DF62DA.6030508@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 3 Jul 2021 11:10:24 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
Message-ID: <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 8:53 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> 24.06.2021 11:28, Arnd Bergmann:
> > Right, I forgot you saw that one WARN_ON trigger. If you enable KALLSYMS
> > and BUGVERBOSE, it should become obvious what that one is about.
>
> Here is new log with a better backtrace:
>
> https://pastebin.com/DP3dSE4w

Ok, I think the generic code changed a bit, but it does confirm that the
problem is doing the RX handing with IRQs disabled.

> The respective diff against regular 8139too.c is here:
>
> https://pastebin.com/v8kA7ZmX
>
> (Basically the same as you proposed initially, just slight difference
> might be as a remainder of my various previous testing)

The simplest workaround would be to just move the
"spin_lock_irqsave(&tp->lock, flags);" a few lines down, below the rx
processing. This keeps the locking rules exactly how they were before
your patch, and anything beyond that could be done as a follow-up
cleanup, if someone wants to think this through more.

        Arnd
