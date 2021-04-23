Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438133698D9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhDWSMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWSMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:12:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DB8C061574;
        Fri, 23 Apr 2021 11:11:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f29so35710593pgm.8;
        Fri, 23 Apr 2021 11:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DiSw/qAMoONsSWQTcoaLe62+2sBX8B5LroHrtuiwM8c=;
        b=bDTi51ar5byMFgBynAmx36yDmvSgoC6xU7qp00TnYABbn+yIwd6i9amM1OdA52rmTl
         9JaF24In1ZNORbGtCDPgfHIfpz9oHsWgseP42yh36+jm0NU3CcDk/GdsLNRbNmKTQDIW
         naBdZpVcVHMAyxK67vWlSTb583sgGOuNLDPDFJ9cPO64S5/Qo0BwZ6bv8rbVAmZ73mxW
         XQP4gEJLfkpdEhMYCdObaWmN7JkNW8QcotThUw0UuxFi0mcFx4gc7faSlEjDEp4sYWS7
         Vr+Q4vvSEqqHTLXtCLT5M5jYRArbx2VqnZW6Q3JdJixGj+ZQS95SE6lMNhXpBSzxSNa2
         xtXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DiSw/qAMoONsSWQTcoaLe62+2sBX8B5LroHrtuiwM8c=;
        b=haXA0deYcRmDcKL6LLtrKcndOm0R3fn8bERqXWHQ2LHSkKm2b3nkKjjL8LZXDwu74s
         ZtjEVxYOjOioOIG4a8k7CxuusZBv6uR0vXfNzklB/86EG73Tsj83iTBsC5M6Ff/pUx3B
         9t6zv/KGtA9yh+lMACjzvGQegMn7AhICdR3BgCPavwmiOfMLONFTLK1C2kEDPbh6xMrs
         8lsaDnVCHRKFwJZc91IOCyHdSBYHfkCdOwqz6XjE2oPf038QT++ANCy509+XF4BQp/4v
         S7L2opOSrtsFHOKbKCki9RQpMO8XZNLvVSPSnxMKGznnZixOQkOlMcCAnfBb4wHZBy1h
         2n5w==
X-Gm-Message-State: AOAM532K6iWMWQYg15iYS+vJQwSRsdLWK0FofHEvkwurXV84RTfDZ8YQ
        kNTiLROWwKQTmPMl3AvlSegUSDCbgkV8jw==
X-Google-Smtp-Source: ABdhPJyLrjtulAK7Jya1YQZCBSYme2Xe70THzCV77evmc+viycLmYSqPPMX6k0Ihj3VCOJOaBgmnCA==
X-Received: by 2002:a63:1111:: with SMTP id g17mr4983947pgl.267.1619201505436;
        Fri, 23 Apr 2021 11:11:45 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id j10sm5402978pfn.207.2021.04.23.11.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 11:11:45 -0700 (PDT)
Date:   Fri, 23 Apr 2021 21:11:33 +0300
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
Message-ID: <20210423181133.cl5ooguhdm5rfbch@skbuf>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
 <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
 <20210423005308.wnhpxryw6emgohaa@skbuf>
 <CO1PR11MB47716991AAEA525773FEAFC8D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47716991AAEA525773FEAFC8D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 09:30:07AM +0000, Ismail, Mohammad Athari wrote:
> Hi Vladimir,
> 
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Friday, April 23, 2021 8:53 AM
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
> > On Fri, Apr 23, 2021 at 12:45:25AM +0000, Ismail, Mohammad Athari wrote:
> > > Hi Vladimir,
> > >
> > > > -----Original Message-----
> > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > Sent: Friday, April 23, 2021 7:53 AM
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
> > > > Hi Mohammad,
> > > >
> > > > On Fri, Apr 23, 2021 at 07:06:45AM +0800,
> > > > mohammad.athari.ismail@intel.com
> > > > wrote:
> > > > > From: Mohammad Athari Bin Ismail
> > > > > <mohammad.athari.ismail@intel.com>
> > > > >
> > > > > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet
> > > > > for 10/100Mbps by default. This setting doesn`t impact pre-emption
> > > > > capability for other speeds.
> > > > >
> > > > > Signed-off-by: Mohammad Athari Bin Ismail
> > > > > <mohammad.athari.ismail@intel.com>
> > > > > ---
> > > >
> > > > What is a "pre-emption packet"?
> > >
> > > In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used to
> > > differentiate between MAC Frame packet, Express Packet, Non-fragmented
> > > Normal Frame Packet, First Fragment of Preemptable Packet,
> > > Intermediate Fragment of Preemptable Packet and Last Fragment of
> > > Preemptable Packet.
> > 
> > Citation needed, which clause are you referring to?
> 
> Cited from IEEE802.3-2018 Clause 99.3.

Aha, you know that what you just said is not what's in the "MAC Merge
sublayer" clause, right? There is no such thing as "pre-emption packet"
in the standard, this is a made-up name, maybe preemptable packets, but
the definition of preemptable packets is not that, hence my question.

> > 
> > >
> > > This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare Cores
> > > Ethernet PCS Databook is to allow the IP to properly receive/transmit
> > > pre-emption packets in SGMII 10M/100M Modes.
> > 
> > Shouldn't everything be handled at the MAC merge sublayer? What business
> > does the PCS have in frame preemption?
> 
> There is no further detail explained in the databook w.r.t to
> VR_MII_DIG_CTRL1 bit-6(PRE_EMP). The only statement it mentions is
> "This bit should be set to 1 to allow the DWC_xpcs to properly
> receive/transmit pre-emption packets in SGMII 10M/100M Modes".

Correct, I see this too. I asked our hardware design team, and at least
on NXP LS1028A (no Synopsys PCS), the PCS layer has nothing to do with
frame preemption, as mentioned.

But indeed, I do see this obscure bit in the Digital Control 1 register
too, I've no idea what it does. I'll ask around. Odd anyway. If you have
to set it, you have to set it, I guess. But it is interesting to see why
is it even a configurable bit, why it is not enabled by default, what is
the drawback of enabling it?!

> > 
> > Also, I know it's easy to forget, but Vinicius' patch series for supporting frame
> > preemption via ethtool wasn't accepted yet. How are you testing this?
> 
> For stmmac Kernel driver, frame pre-emption capability is already
> supported. For iproute2 (tc command), we are using custom patch based
> on Vinicius patch.

Don't you want to help contributing the ethtool netlink support to the
mainline kernel though? :)
