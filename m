Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B694296290
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901623AbgJVQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901602AbgJVQUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 12:20:52 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDE6FC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 09:20:51 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 09MGJuHh083783;
        Thu, 22 Oct 2020 18:19:56 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 09MGJtlF005960;
        Thu, 22 Oct 2020 18:19:55 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 09MGJtY1005958;
        Thu, 22 Oct 2020 18:19:55 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 4/6] can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
Date:   Thu, 22 Oct 2020 18:19:55 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <9783a6d0a3e79ca4106cf1794aa06c8436700137.1603354744.git.pisa@cmp.felk.cvut.cz> <20201022113952.GC30566@duo.ucw.cz>
In-Reply-To: <20201022113952.GC30566@duo.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202010221819.55087.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 09MGJuHh083783
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.099, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00,
        URIBL_BLOCKED 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1603988397.44586@OFvO2wL68sLNnqNSsO0ziw
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel,

thanks for review.

On Thursday 22 of October 2020 13:39:52 Pavel Machek wrote:
> Hi!
>
> > @@ -12,4 +12,13 @@ config CAN_CTUCANFD
> >
> >  if CAN_CTUCANFD
> >
> > +config CAN_CTUCANFD_PCI
> > +	tristate "CTU CAN-FD IP core PCI/PCIe driver"
> > +	depends on PCI
> > +	help
> > +	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
> > +	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
> > +	  PCIe board with PiKRON.com designed transceiver riser shield is
> > available +	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> > +
> >  endif
>
> Ok, now the if in the first patch makes sense. It can stay.
>
> And it is separate module, so EXPORT_SYMBOLs make sense. Ok.

Great.

> > +#ifndef PCI_VENDOR_ID_TEDIA
> > +#define PCI_VENDOR_ID_TEDIA 0x1760
> > +#endif
> >
> > +#define PCI_DEVICE_ID_ALTERA_CTUCAN_TEST  0xCAFD
> > +#define PCI_DEVICE_ID_TEDIA_CTUCAN_VER21 0xff00
>
> These should go elsewhere.

They should propagate somehow from

https://pci-ids.ucw.cz/read/PC/1760/ff00

We have registered them long time ago.
I am not sure what is right mechanism.

> > +#ifndef PCI_VENDOR_ID_TEDIA
> > +#define PCI_VENDOR_ID_TEDIA 0x1760
> > +#endif

So this one should be known to kernel globally, but I would
be happy if driver build even if global process to introduce
define did not proceed end even backports would be required
for long time until kernel including CTU CAN FD propagates
into distributions, and industrial systems distributions
lag often a lot

> > +#define PCI_DEVICE_ID_ALTERA_CTUCAN_TEST  0xCAFD

We drop this, I hope we have no system running old test
version of the core integration before Tedia offered us
to reserve some IDs (promissed that they would never use them
in future) for us.

> > +#define PCI_DEVICE_ID_TEDIA_CTUCAN_VER21 0xff00

This should propagate into kernel from registry or at least
match registry.

> > +static bool use_msi = 1;
> > +static bool pci_use_second = 1;
>
> true?

Done

Best wishes,

                Pavel
