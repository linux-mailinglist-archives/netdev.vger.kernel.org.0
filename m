Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFEC296256
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509975AbgJVQH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509549AbgJVQH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 12:07:26 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D179C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 09:07:25 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 09MG6Kbr083350;
        Thu, 22 Oct 2020 18:06:20 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 09MG6Kbh004044;
        Thu, 22 Oct 2020 18:06:20 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 09MG6K7J004041;
        Thu, 22 Oct 2020 18:06:20 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v6 5/6] can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
Date:   Thu, 22 Oct 2020 18:06:19 +0200
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
        Drew Fustini <pdp7pdp7@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <2a90e1a7d57f0fec42604cd399acf25af5689148.1603354744.git.pisa@cmp.felk.cvut.cz> <20201022114306.GA31933@duo.ucw.cz>
In-Reply-To: <20201022114306.GA31933@duo.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202010221806.19253.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 09MG6Kbr083350
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.099, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00,
        URIBL_BLOCKED 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1603987585.63094@DauQioNUM05pHvR5CIXLhA
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel,

thanks for review.

On Thursday 22 of October 2020 13:43:06 Pavel Machek wrote:
> Hi!
>
> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
> >  	  PCIe board with PiKRON.com designed transceiver riser shield is
> > available at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> >
> > +config CAN_CTUCANFD_PLATFORM
> > +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> > +	depends on OF || COMPILE_TEST
> > +	help
>
> This is likely wrong, as it can enable config of CAN_CTUCANFD=M,
> CAN_CTUCANFD_PLATFORM=y, right?

My original code has not || COMPILE_TEST alternative.

But I have been asked to add it

On Sunday 16 of August 2020 01:28:13 Randy Dunlap wrote:
> Can this be
>         depends on OF || COMPILE_TEST
> ?

I have send discussion later that I am not sure if it is right
but followed suggestion. If there is no other reply now,
I would drop || COMPILE_TEST. I believe that then it is correct
for regular use. I ma not sure about all consequences of COMPILE_TEST
missing.

> > @@ -8,3 +8,6 @@ ctucanfd-y := ctu_can_fd.o ctu_can_fd_hw.o
> >
> >  obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
> >  ctucanfd_pci-y := ctu_can_fd_pci.o
> > +
> > +obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
> > +ctucanfd_platform-y += ctu_can_fd_platform.o
>
> Can you simply add right object files directly?

This is more tough question. We have kept sources
as ctu_can_fd.c, ctu_can_fd_hw.c etc. to produce
final ctucanfd.ko which matches device tree entry etc.
after name simplification now...
So we move from underscores to ctucanfd on more places.
So yes, we can rename ctu_can_fd.c to ctucanfd_drv.c + others
keep final ctucanfd.ko and change to single file based objects
ctucanfd_platform.c and ctucanfd_pci.c

If you think that it worth to be redone, I would do that.
It would disrupt sources history, may it be blames, merging
etc... but I would invest effort into it if asked for. 

Best wishes,

                Pavel
