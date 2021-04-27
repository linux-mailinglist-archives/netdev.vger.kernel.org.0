Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8D36C854
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhD0PJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbhD0PJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 11:09:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05ECC061574;
        Tue, 27 Apr 2021 08:08:29 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d124so41530653pfa.13;
        Tue, 27 Apr 2021 08:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hpPaaeNnDQDzXenK2DRxqA8fQ/9qhGhVcGouqEQ3NOg=;
        b=mu33WPcsU+Tt1pVw/xbsCSUJVgwDtghadn4anGynXS2Auxr7JH2pvxbY7c5v9Bzld/
         YM4F3K0M644FMpjdVzMdiLUHJIxtSTrtKbQHCjxQ16GyYfPUrL9k0wt5+i5i5xMMwqmU
         q9WrjFiB8I9FxN4+ZCArk3VS+NKr0ZKG43sP02yKr9KDENtPZhocrNUQOnRjrfqzpil+
         V7nb/Vusilf0e5X9o0HVdiZ99i4os8yPisDYXLq4xtRTbR0KarmKYawAYpEqXMssT4+4
         v4rLJ8enWjQ3N/86eS+UuOVoFslrIKb1sQeSvtdrAqjJv8N8peYCtHym02XN2RBrLi1A
         aDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hpPaaeNnDQDzXenK2DRxqA8fQ/9qhGhVcGouqEQ3NOg=;
        b=OjU26ip4OND20yQ5U9qSsGtUYCSCprsnOCGAg1uTOauDUtR8dkriykLDGbr7mfh4np
         eOWJes6vHCvJJ/ZDmYAcsiQE6UfN/zyRiYs1hWi+7L0f+p66YUhKRSVpGsVNtFcBSB9q
         jiR1Gk7/KAgVLpvlzph9foKIPbImUz8v09+ADRyiukaRq551jPKwhI48JJ7xQGdfr2AE
         bm5y5VJNRmekDsCDVbF7pxDWenVBwTKHEHGaQwELL2v5s0AniuNtSEWXCB91dronBuCh
         ZV52EmslchzdGCJ2CP0fBlXwkMqeYyIjVDv9A48AEoBEMpa0JLhs+52rDkGgRwVGc6VZ
         ga3w==
X-Gm-Message-State: AOAM531Mn0PVLsot2Q4IZ++zEWE6v2mdz8ESHcnLYUThKOMt+897Z2We
        SlBUY4O3gEuyvTuT/LK0ujyIt5zh6v0=
X-Google-Smtp-Source: ABdhPJy2HIHSNUpYnQVE71je2Rfi5wTXzy80Oai/kyAu3IZ5o0cOgyq/x/jSEnKqeV9sB9FldmBkuA==
X-Received: by 2002:a63:7703:: with SMTP id s3mr3125657pgc.339.1619536109238;
        Tue, 27 Apr 2021 08:08:29 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id br10sm2551511pjb.13.2021.04.27.08.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:08:28 -0700 (PDT)
Date:   Tue, 27 Apr 2021 18:08:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
 10/100Mbps
Message-ID: <20210427150816.5lro2zawucnxu6xq@skbuf>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
 <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423005308.wnhpxryw6emgohaa@skbuf>
 <CO1PR11MB47716991AAEA525773FEAFC8D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423181133.cl5ooguhdm5rfbch@skbuf>
 <CO1PR11MB4771248BAF7FF5EF4331F688D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771248BAF7FF5EF4331F688D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ismail,

On Fri, Apr 23, 2021 at 10:03:58PM +0000, Ismail, Mohammad Athari wrote:
> Hi Vladimir,
> 
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Saturday, April 24, 2021 2:12 AM
> > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> > <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; Ong, Boon
> > Leong <boon.leong.ong@intel.com>; Voon, Weifeng
> > <weifeng.voon@intel.com>; Wong, Vee Khee <vee.khee.wong@intel.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet for
> > 10/100Mbps
> > 
> > On Fri, Apr 23, 2021 at 09:30:07AM +0000, Ismail, Mohammad Athari wrote:
> > > Hi Vladimir,
> > >
> > > > -----Original Message-----
> > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > Sent: Friday, April 23, 2021 8:53 AM
> > > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > > > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > > > Jakub Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > > > Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > > > <linux@armlinux.org.uk>; Ong, Boon Leong <boon.leong.ong@intel.com>;
> > > > Voon, Weifeng <weifeng.voon@intel.com>; Wong, Vee Khee
> > > > <vee.khee.wong@intel.com>; netdev@vger.kernel.org;
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption packet
> > > > for 10/100Mbps
> > > >
> > > > On Fri, Apr 23, 2021 at 12:45:25AM +0000, Ismail, Mohammad Athari wrote:
> > > > > Hi Vladimir,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > > > Sent: Friday, April 23, 2021 7:53 AM
> > > > > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > > > > Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > > > > > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > > > > > Jakub Kicinski <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > > > > > Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> > > > > > <linux@armlinux.org.uk>; Ong, Boon Leong
> > > > > > <boon.leong.ong@intel.com>; Voon, Weifeng
> > > > > > <weifeng.voon@intel.com>; Wong, Vee Khee
> > > > > > <vee.khee.wong@intel.com>; netdev@vger.kernel.org;
> > > > > > linux-kernel@vger.kernel.org
> > > > > > Subject: Re: [PATCH v2 net-next] net: pcs: Enable pre-emption
> > > > > > packet for 10/100Mbps
> > > > > >
> > > > > > Hi Mohammad,
> > > > > >
> > > > > > On Fri, Apr 23, 2021 at 07:06:45AM +0800,
> > > > > > mohammad.athari.ismail@intel.com
> > > > > > wrote:
> > > > > > > From: Mohammad Athari Bin Ismail
> > > > > > > <mohammad.athari.ismail@intel.com>
> > > > > > >
> > > > > > > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption
> > > > > > > packet for 10/100Mbps by default. This setting doesn`t impact
> > > > > > > pre-emption capability for other speeds.
> > > > > > >
> > > > > > > Signed-off-by: Mohammad Athari Bin Ismail
> > > > > > > <mohammad.athari.ismail@intel.com>
> > > > > > > ---
> > > > > >
> > > > > > What is a "pre-emption packet"?
> > > > >
> > > > > In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used
> > > > > to differentiate between MAC Frame packet, Express Packet,
> > > > > Non-fragmented Normal Frame Packet, First Fragment of Preemptable
> > > > > Packet, Intermediate Fragment of Preemptable Packet and Last
> > > > > Fragment of Preemptable Packet.
> > > >
> > > > Citation needed, which clause are you referring to?
> > >
> > > Cited from IEEE802.3-2018 Clause 99.3.
> > 
> > Aha, you know that what you just said is not what's in the "MAC Merge sublayer"
> > clause, right? There is no such thing as "pre-emption packet"
> > in the standard, this is a made-up name, maybe preemptable packets, but the
> > definition of preemptable packets is not that, hence my question.
> > 
> 
> Thank you for the knowledge sharing. My guess, this "pre-emption
> packet" might be referring to "preamble" byte in Ethernet frame. 
> 
> > > >
> > > > >
> > > > > This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare
> > > > > Cores Ethernet PCS Databook is to allow the IP to properly
> > > > > receive/transmit pre-emption packets in SGMII 10M/100M Modes.
> > > >
> > > > Shouldn't everything be handled at the MAC merge sublayer? What
> > > > business does the PCS have in frame preemption?
> > >
> > > There is no further detail explained in the databook w.r.t to
> > > VR_MII_DIG_CTRL1 bit-6(PRE_EMP). The only statement it mentions is
> > > "This bit should be set to 1 to allow the DWC_xpcs to properly
> > > receive/transmit pre-emption packets in SGMII 10M/100M Modes".
> > 
> > Correct, I see this too. I asked our hardware design team, and at least on NXP
> > LS1028A (no Synopsys PCS), the PCS layer has nothing to do with frame
> > preemption, as mentioned.
> > 
> > But indeed, I do see this obscure bit in the Digital Control 1 register too, I've no
> > idea what it does. I'll ask around. Odd anyway. If you have to set it, you have to
> > set it, I guess. But it is interesting to see why is it even a configurable bit, why it
> > is not enabled by default, what is the drawback of enabling it?!
> 
> The databook states that the default value is 0. We don`t see any
> drawback of enabling it. As the databook mentions that, enabling the
> bit will allow SGMII 10/100M to receive/transmit preamble properly, so
> I think it is recommended to enable it for IP that support SGMII
> 10/100M speed.

Why do you need this patch, exactly? Is there anything that doesn't work
if you don't make the change? For example, if you leave the PRE_EMP bit
in the PCS set to zero, you set the link to 100 Mbps, configure all
queues to go to the pMAC and stress the interface with some iperf3
traffic for a while, do you see any issues at all?
