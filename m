Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202B23B05C5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFVN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFVN1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 09:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017DA6102A
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624368316;
        bh=hB1/TGIJKn1vgmhSjWYV0Dh8RFDDR81gbSs9JMWDEhQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gHYMBDT+sw6v1hDScJ2avWsASU9xsbR3w+sXj+xvyur0TdGknPMAOZRxEFJNlYePC
         EVnXeJInLtieaKog08BYrkb2bUFb5UPLaFCkgBQeC+PtNB7o7R/1jjjT01TJqgZuwP
         Phl9fZXaE/eC6ATz1zbgkZt3FbTj0od8SyLGIBN0hE1594Tvi/0sLWkaoiAaAOmXpu
         Mj0hjquk4lQ5jhCqIFZPTdHYr+cCMHAkZ47I58gvFrHBJlqbI4cWNP+hqU14Ih1K7H
         hzWiHyH+1FVpSTiND1F35ns+6w0yS3X9jnXbMc83iCe7R9tdDmk4ZerBS8f0Uh2wxn
         /p73a9IDdeA5w==
Received: by mail-wm1-f41.google.com with SMTP id m41-20020a05600c3b29b02901dcd3733f24so1764021wms.1
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:25:15 -0700 (PDT)
X-Gm-Message-State: AOAM531q15rKNW8v4WxqzqDucUsPRNvssPGh0TZdgUumwIE8JSz3TLOo
        A2lKXnRHxc6XBrGd58/xZJlQ4TSxhtuir12no8c=
X-Google-Smtp-Source: ABdhPJwj40yuXVFBjODysme3PQ1I3BtSpfl3QdB8opzmnPFhL6UhaW24rs/pd9xvEwfnjTCY4KebbmIdbzVnpkz4NqA=
X-Received: by 2002:a1c:28a:: with SMTP id 132mr4542141wmc.120.1624368314645;
 Tue, 22 Jun 2021 06:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com>
In-Reply-To: <60D1DAC1.9060200@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 22 Jun 2021 15:22:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
Message-ID: <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
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

On Tue, Jun 22, 2021 at 2:32 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> 21.06.2021 14:22, Arnd Bergmann:
> [...]
> > I looked some more through the git history and found at least one time
> > that the per-chipset ELCR fixup came up for discussion[1], and this
> > appears to have resulted in generalizing an ALI specific fixup into
> > common code into common code[2], so we should already be doing
> > exactly this in many cases. If Nikolai can boot the system with debugging
> > enabled for arch/x86/pci/irq.c, we should be able to see exactly
> > which code path is his in his case, and why it doesn't go through
> > setting that register at the moment.
>
> Here is my dmesg with debugging (hopefully) added to irq.c:
>
> https://pastebin.com/tnC2rRDM

Ok, so it's getting roughly through the right code path:

        dev_dbg(&dev->dev, "PCI INT %c -> PIRQ %02x, mask %04x, excl %04x",
                'A' + pin - 1, pirq, mask, pirq_table->exclusive_irqs);
...
        dev_dbg(&dev->dev, "PCI INT %c -> newirq %d", 'A' + pin - 1, newirq);

        /* Check if it is hardcoded */
        if ((pirq & 0xf0) == 0xf0) {
                irq = pirq & 0xf;
                msg = "hardcoded";
        } else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
        ((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
                msg = "found";
                elcr_set_level_irq(irq);
        } else if (newirq && r->set &&
                (dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
                if (r->set(pirq_router_dev, dev, pirq, newirq)) {
                        elcr_set_level_irq(newirq);
                        msg = "assigned";
                        irq = newirq;
                }
        }

        if (!irq) {
                if (newirq && mask == (1 << newirq)) {
                        msg = "guessed";
                        irq = newirq;
                } else {
                        dev_dbg(&dev->dev, "can't route interrupt\n");
                        return 0;
                }
        }
        dev_info(&dev->dev, "%s PCI INT %c -> IRQ %d\n", msg, 'A' +
pin - 1, irq);

with the corresponding output from that one being

[    0.761546] 8139too 0000:00:0d.0: runtime IRQ mapping not provided by arch
[    0.761546] 8139too: 8139too Fast Ethernet driver 0.9.28
[    0.761546] 8139too 0000:00:0d.0: PCI INT A -> PIRQ 02, mask 1eb8, excl 0001
[    0.765817] 8139too 0000:00:0d.0: PCI INT A -> newirq 9
[    0.765817] 8139too 0000:00:0d.0: can't route interrupt
[    0.777546] 8139too 0000:00:0d.0 eth0: RealTek RTL8139 at
0xc4804000, 00:11:6b:32:85:74, IRQ 9

From what I can tell, this means that there is no chipset specific
get/set function,
the irq is not hardcoded but the 'mask' value in the irq_info table (0x1eb8)
lists a number of options.

In this case, the function gives up with the  "can't route interrupt\n"
output and does not call elcr_set_level_irq(newirq). Adding the call
to elcr_set_level_irq() in that code path as well probably makes it
set the irq to level mode:

--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -984,6 +984,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev,
int assign)
                        irq = newirq;
                } else {
                        dev_dbg(&dev->dev, "can't route interrupt\n");
+                       elcr_set_level_irq(newirq);
                        return 0;
                }
        }

No idea if doing this is a good idea though, in particular I have no clue
about whether this is a common scenario or not.

        Arnd
