Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A893B1136
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 03:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFWBHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 21:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 21:07:15 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 055E0C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 18:04:58 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 93C6B92009C; Wed, 23 Jun 2021 03:04:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 8C2E492009B;
        Wed, 23 Jun 2021 03:04:56 +0200 (CEST)
Date:   Wed, 23 Jun 2021 03:04:56 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     Nikolai Zhubr <zhubr.2@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2106230244460.37803@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
 <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com>
 <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021, Arnd Bergmann wrote:

> > This fix looks really nice. Maybe it is right thing to do.
> 
> I'll leave that up to Thomas and Maciej to decide, they should have the
> best idea of why the x86 pci-irq code looks the way it does today and
> what the possible risk with my patch is.

 Ah, so this is the SiS 85C496/497 chipset; another one that does not have 
its southbridge visible in the PCI configuration space, perhaps because it 
doesn't put the southbridge on PCI in the first place, and instead it maps 
its configuration registers in the upper half of the northbridge's space.  
Oh, the joys of early attempts!

 It does PCI interrupt steering, it has the ELCR, but we don't have a PIRQ 
router implemented for it.  I have a datasheet, so this should be fairly 
trivial to do, and hopefully things will then work automagically, no need 
for hacks.

 It's very late tonight here, so let me come back with something tomorrow.

  Maciej
