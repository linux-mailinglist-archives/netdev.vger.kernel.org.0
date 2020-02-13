Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0645115C707
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgBMQGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:06:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBMQGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 11:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f6ASfmJVxGEvM+jXLF73jujXjl0eUoIgR0CJj33tca8=; b=oTHAvbhoglfahvB5HP6GYguAe2
        T5/pPjprZD7pz7TTT2WhFMIVNuwooe5LHxYS5xE5zBD/tLzZzwuQcvp9Xbp4MTHGI1KTFbov2IpGu
        9Kr2EJjPj0tHly0hr3M+qmCDYKk82v2AokVuHNB9c6pH/Hj0pCRPcmS9kG+7WiQpRLxA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2H0G-0003oK-AS; Thu, 13 Feb 2020 17:06:12 +0100
Date:   Thu, 13 Feb 2020 17:06:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200213160612.GD31084@lunn.ch>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Correct me if I'm wrong, but if the lack of fixed-link specifier for
> CPU and DSA ports was not a problem before, but has suddenly started
> to become a problem with that patch, then simply reverting to the old
> "legacy" logic from dsa_port_link_register_of() should restore the
> behavior for those device tree blobs that don't specify an explicit
> fixed-link?

DSA defines that the DSA driver should initialize CPU ports and DSA
ports to their maximum speed. You only need fixed-link properties when
you need to slow the port down, e.g. the SoC on the other end is
slower. That does not happen very often, so most boards don't have
fixed-link properties.

It just happens that most of the boards i test with, have a Fast
Ethernet SoC port, so do have fixed-link properties, and i missed the
issue for a long time.

	   Andrew
