Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8822450B90
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbfFXNNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:13:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfFXNNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 09:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w71H7qbKzheuPjLTSksNNI0MO2TJKsefOHajDzNwZgs=; b=39ByeK7qX2ak7a7iM7z8+DWROE
        KFDEQzjJaWASnQiIZ2oZU7hW5oKBH3vw5ic18SbPnO8IpKNSZ8JhOGkJAXtSIoJxj+hqb9Z+2XP6t
        ZSwePeCn44vuBv9RYayRq4GJ5odIldzQZZiA9G4KqoN7/QaexM0h6H9yh0XchlMfXkME=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfOmR-0004ll-Ta; Mon, 24 Jun 2019 15:13:07 +0200
Date:   Mon, 24 Jun 2019 15:13:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v4 4/5] net: macb: add support for high speed interface
Message-ID: <20190624131307.GA17872@lunn.ch>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281806-13991-1-git-send-email-pthombar@cadence.com>
 <20190623150902.GB28942@lunn.ch>
 <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 06:52:51AM +0000, Parshuram Raju Thombare wrote:
> Hi Andrew,
> 
> >> +enum {
> >> +	MACB_SERDES_RATE_5_PT_15625Gbps = 5,
> >> +	MACB_SERDES_RATE_10_PT_3125Gbps = 10,
> >> +};
> >What do the units mean here? Why would you clock the SERDES at 15Tbps,
> >or 3Tbps? 3.125Mbps would give you 2.5Gbps when using 8b/10b encoding.
> >
> MACB_SERDES_RATE_5_PT_15625Gbps is for 5.15625Gbps, I think this should be just
> MACB_SERDES_RATE_5_Gbps and MACB_SERDES_RATE_10_Gbps. I will do it in next patch set.
 
OK.

> >Xilinx documentation:
> >https://urldefense.proofpoint.com/v2/url?u=https-
> >3A__www.xilinx.com_support_documentation_ip-5Fdocumentation_usxgmii_v1-
> >5F1_pg251-
> >2Dusxgmii.pdf&d=DwIBAg&c=aUq983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-
> >_haXqY&r=GTefrem3hiBCnsjCOqAuapQHRN8-rKC1FRbk0it-
> >LDs&m=6V8fNIg49czRjfvVtDJ5BbR28p9UPlLLyB7fah7ypcw&s=LsDphgLBe1VDpM
> >_K9pkuyal873WeKqHDv64NDRUWy1Q&e=
> >seems to suggest USXGMII uses a fixed rate of 10.3125Gb/s. So why do
> >you need to change the rate?
> For USXGMII, Cadence MAC need to be correctly programmed for external serdes rate.

What i'm saying is that the USXGMII rate is fixed. So why do you need
a device tree property for the SERDES rate?

     Andrew
