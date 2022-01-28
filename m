Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52E49FA72
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244701AbiA1NRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:17:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:11003 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244893AbiA1NRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:17:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643375862; x=1674911862;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s5KRVYoT6Fz2ztRQO954cBVzN3w1HLC+0G8IEuAeMnc=;
  b=GqUBHeBNtq2XNLnpcvOW3ktIRvOiG7HvnnILPUp1eJshGCp6BwPeAXzB
   FcCEDii5J9KPlmdeoaO0O+24BlPOsgdH4nvrNhhxVLjZAEsgvEpc4V+lm
   5cDHJgwkF89SACz9Y4aypZEj5QT177M+3KoiEhhVmieYKNi3o30OJOX9h
   EtFzSDTmXSszG1oCNyjkx6+XdV7DgWHbudsr9f1sMHVasJFRd3wKvHHe2
   mmegVR7dahqycm0kDnby+xsAN3PO7bII0BeFBykQqvApEZeayKV7XU1kS
   QVlNxgpjcOpo4ULRTi+3vjqTSOoSmIXplbBhUg/aSEGG5OtspCIrgC05P
   A==;
IronPort-SDR: VLy1WWIWMEe00hLDg0kZtaL1NhW90OgWjrRyFhQI1Pu1xVne7K6/83ZQZn4mT8lwF32428bmbv
 RERWEYftAOfUbWjCJw3nsL0i92d1UwP1bzreFubmi58igLoRtKKimTdcVT292KzLts3ZdSeNVq
 ig4Y/HjRFWJmPqgSRbbFn6daumYNm3uPL3qz3e0Yfl70lh6ynKBR9z1KiTYBKG9s8tiuYzR95M
 HbNct8vHw3w0dh2Ipa0iMk9SaiGhDwT6oa+dZVhX4ix90ElJ4i6i+VyOc8gqi4NK7Ki0+vCtRk
 qO0NNV7CFNLT5tcXKb2LF8+p
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="160344153"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2022 06:17:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 28 Jan 2022 06:17:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 28 Jan 2022 06:17:41 -0700
Date:   Fri, 28 Jan 2022 14:20:08 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>
Subject: Re: [PATCH net-next 4/7] net: lan966x: Implement SIOCSHWTSTAMP and
 SIOCGHWTSTAMP
Message-ID: <20220128132008.x4z6ckfmhxnumsqm@soft-dev3-1.localhost>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-5-horatiu.vultur@microchip.com>
 <20220127215508.GA26514@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220127215508.GA26514@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/27/2022 13:55, Richard Cochran wrote:
> 
> On Thu, Jan 27, 2022 at 11:23:30AM +0100, Horatiu Vultur wrote:
> 
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > index 69d8f43e2b1b..9ff4d3fca5a1 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > @@ -35,6 +35,90 @@ static u64 lan966x_ptp_get_nominal_value(void)
> >       return res;
> >  }
> >
> > +int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool l2 = false, l4 = false;
> > +     struct hwtstamp_config cfg;
> > +     struct lan966x_phc *phc;
> > +
> > +     /* For now don't allow to run ptp on ports that are part of a bridge,
> > +      * because in case of transparent clock the HW will still forward the
> > +      * frames, so there would be duplicate frames
> > +      */
> > +     if (lan966x->bridge_mask & BIT(port->chip_port))
> > +             return -EINVAL;
> > +
> > +     if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +             return -EFAULT;
> > +
> > +     switch (cfg.tx_type) {
> > +     case HWTSTAMP_TX_ON:
> > +             port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
> > +             break;
> > +     case HWTSTAMP_TX_ONESTEP_SYNC:
> > +             port->ptp_cmd = IFH_REW_OP_ONE_STEP_PTP;
> > +             break;
> > +     case HWTSTAMP_TX_OFF:
> > +             port->ptp_cmd = IFH_REW_OP_NOOP;
> > +             break;
> > +     default:
> > +             return -ERANGE;
> > +     }
> > +
> > +     mutex_lock(&lan966x->ptp_lock);
> 
> No need to lock stack variables.  Move locking down to ...

Good catch, will do that.

> 
> > +     switch (cfg.rx_filter) {
> > +     case HWTSTAMP_FILTER_NONE:
> > +             break;
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> > +             l4 = true;
> > +             break;
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> > +             l2 = true;
> > +             break;
> > +     case HWTSTAMP_FILTER_PTP_V2_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> > +             l2 = true;
> > +             l4 = true;
> > +             break;
> > +     default:
> > +             mutex_unlock(&lan966x->ptp_lock);
> > +             return -ERANGE;
> > +     }
> > +
> > +     if (l2 && l4)
> > +             cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> > +     else if (l2)
> > +             cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> > +     else if (l4)
> > +             cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
> > +     else
> > +             cfg.rx_filter = HWTSTAMP_FILTER_NONE;
> > +
> > +     /* Commit back the result & save it */
> 
> ... here
> 
> > +     phc = &lan966x->phc[LAN966X_PHC_PORT];
> > +     memcpy(&phc->hwtstamp_config, &cfg, sizeof(cfg));
> > +     mutex_unlock(&lan966x->ptp_lock);
> > +
> > +     return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > +}
> 
> Thanks,
> Richard

-- 
/Horatiu
