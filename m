Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE439AA09
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhFCSdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:33:52 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:54468 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFCSdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 14:33:52 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 73A4092009C; Thu,  3 Jun 2021 20:32:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 68E2692009B;
        Thu,  3 Jun 2021 20:32:06 +0200 (CEST)
Date:   Thu, 3 Jun 2021 20:32:06 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
cc:     Nikolai Zhubr <zhubr.2@gmail.com>, Arnd Bergmann <arnd@kernel.org>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
In-Reply-To: <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
Message-ID: <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021, Heiner Kallweit wrote:

> > Now I'd like to ask, is quality reliable fix still wanted in mainline or rather not? Because I'll personally do my best to create/find a good fix anyway, but if it is of zero interest for mainline, I'll probably not invest much time into communicating it. My understanding was that default rule is "if broken go fix it" but due to the age of both code and hardware, maybe it is considered frozen or some such (I'm just not aware really).
> > 
> Driver 8139too has no maintainer. And you refer to "mainline" like to a number of developers
> who are paid by somebody to maintain all drivers in the kernel. That's not the case in general.
> You provided valuable input, and if you'd contribute to improving 8139too and submit patches for
> fixing the issue you're facing, this would be much appreciated.

 It's an issue in x86 platform code, not the 8139too driver.  Any option 
card wired to PCI in this system somehow could suffer from it.  Depending 
on how you look at it you may or may not qualify it as a bug though, and 
any solution can be considered a workaround (for a BIOS misfeature) rather 
than a bug fix.

 The question is IMHO legitimate, and I can't speak for x86 platform 
maintainers.  If I were one, I'd accept a reasonable workaround and it 
does not appear to me it would be a very complex one to address this case: 
basically a PCI quirk to set "this southbridge has ELCR at the usual 
location" (if indeed it does; you don't want to blindly poke at random 
port I/O locations in generic code), and then a tweak to `pirq_enable_irq' 
or `pcibios_lookup_irq' as Arnd has suggested.

  Maciej
