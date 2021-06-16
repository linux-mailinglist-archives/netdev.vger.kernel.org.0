Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078A83AA727
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhFPXDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:03:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhFPXDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 19:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ftU/ga994Pq7LCkheRHkKJ35z9kbEUB3wqRR/UtxPvM=; b=ts
        6eZiGUQCSi0hEipq1OOAR7njlHaQrgu4dmeYB/BvIFqbFREHR3IiOL2laK+zwBzvO2Oju86TFLaL4
        xukXRAE3FDcsWJymZzDiQJRswNroZIpsSz05EykumxiPNIWWcbJYTfkA0Xs9yLKBnLoDr8NdM0SRX
        2DNN3Eg8yyzCADM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lteXP-009nI5-3R; Thu, 17 Jun 2021 01:01:35 +0200
Date:   Thu, 17 Jun 2021 01:01:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v2 5/7] net: mvmdio: add ACPI support
Message-ID: <YMqCz0j7/Gdgtf+5@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-6-mw@semihalf.com>
 <YMpWJ79VF7HmjumQ@lunn.ch>
 <CAPv3WKfwe9sm5mQCEo4tAubLDTUCeeeLeuB2FQaoWA8qyz+CqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKfwe9sm5mQCEo4tAubLDTUCeeeLeuB2FQaoWA8qyz+CqQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 12:37:06AM +0200, Marcin Wojtas wrote:
> śr., 16 cze 2021 o 21:51 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > On Wed, Jun 16, 2021 at 09:07:57PM +0200, Marcin Wojtas wrote:
> > > This patch introducing ACPI support for the mvmdio driver by adding
> > > acpi_match_table with two entries:
> > >
> > > * "MRVL0100" for the SMI operation
> > > * "MRVL0101" for the XSMI mode
> > >
> > > Also clk enabling is skipped, because the tables do not contain
> > > such data and clock maintenance relies on the firmware.
> >
> > This last part seems to be no longer true.
> >
> 
> Well, it is still relies on firmware (no clocks are passed via ACPI),
> but skipping this enablement is hidden in the internals of
> devm_clk_bulk_get_optional() and clk_bulk_prepare_enable().

A quick grep in driver/clk does not reveal any ACPI code. Nor did i
spot any generic clock code in drivers/acpi. So even if you did add
clocks to the tables, i don't see how they would be used.

       Andrew
