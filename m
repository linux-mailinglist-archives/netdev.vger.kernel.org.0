Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7049FB05
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiA1Nqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:46:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:31240 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiA1Nqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643377595; x=1674913595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bDfnqX6+hpeWXzc/AVZDL/trniYBTrCP/mQvXnxNfqA=;
  b=xsQELTyMVxSXjrD1qcE4OeMxiLAh1jmqhsAQvQaAyhmO0ZN1PjKDDitj
   ZwFuppTI6xRNohCrOOsf/MXU8sPuy6cJV2Zb3XxFaCLUhzba2MtDpE9Gg
   G9gUOoBwzkCZ3U9c9aJB1x6FRNF7ucQFh11nX8bGGNYQTenqYMdkQQeG3
   uKmt4M3Zlf/8tzy5puYQ6ePP09gqv8lPMMNl4+H6VCu6cdGcwie2mz3CA
   TxLhVSsWFmZMopKDRpbeILHpKjPd9F+iE6gjpvmLphJrMsVM409ILtO/S
   FBbrjhYSDtRw1e6M8xnfufJOlAAk2ZlPmVbOuTEnvxyYXRBy/Q2Imkemv
   Q==;
IronPort-SDR: nJPr/vSfiDznuhXmEXxXslXnyXVkInzIZj2A8v/gsVBTl2+FQdWhjTue5MdpAl14NYsrMgB/FT
 VGxm2RtdJn9HPAj1O2BEj4vweUFzIF22gOG4NRir4+HflqGdIaM3JSCQbRSny+OGb0SvVeiYMw
 3KQmuIEyVqKB7xN7qUm+CK9lOYvRymCcdQP9IxjLWgQBuO8DSpTuMSc+Z6yLp9M435wUK9Cw2L
 sLvaoDUBnqTpJ5HcLAPxZkdeBYCG/XKznOlGP+Hua2eznIvf9+i6kIWiwS84yv0biBhBtktBdn
 0NiYonrsoAx296smfr8n4gGr
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="84004966"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2022 06:46:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 28 Jan 2022 06:46:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 28 Jan 2022 06:46:28 -0700
Date:   Fri, 28 Jan 2022 14:48:55 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>
Subject: Re: [PATCH net-next 3/7] net: lan966x: Add support for ptp clocks
Message-ID: <20220128134855.cewcsuk77di6kahz@soft-dev3-1.localhost>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-4-horatiu.vultur@microchip.com>
 <20220127152841.GC20642@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220127152841.GC20642@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/27/2022 07:28, Richard Cochran wrote:
> 
> On Thu, Jan 27, 2022 at 11:23:29AM +0100, Horatiu Vultur wrote:
> 
> > +static int lan966x_ptp_phc_init(struct lan966x *lan966x,
> > +                             int index,
> > +                             struct ptp_clock_info *clock_info)
> > +{
> > +     struct lan966x_phc *phc = &lan966x->phc[index];
> > +
> > +     phc->info = *clock_info;
> > +     phc->clock = ptp_clock_register(&phc->info, lan966x->dev);
> > +     if (IS_ERR(phc->clock))
> > +             return PTR_ERR(phc->clock);
> > +
> > +     phc->index = index;
> > +     phc->lan966x = lan966x;
> > +
> > +     /* PTP Rx stamping is always enabled.  */
> > +     phc->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> 
> Not true -- you allow it to be disabled in the next patch!

Actually the other patch is wrong. The HW will timestamp all the frames.
I will update the other patch in the next version.

> 
> Thanks,
> Richard
> 
> 
> > +
> > +     return 0;
> > +}

-- 
/Horatiu
