Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ACC368A0E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhDWAxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhDWAxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:53:46 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA7EC061574;
        Thu, 22 Apr 2021 17:53:10 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bx20so54479140edb.12;
        Thu, 22 Apr 2021 17:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ks1uW4TsJ3ZwYPwFK3x+RKWO8sV8NPeu0lKhg7RGxMc=;
        b=KROsPbra7Y/3zLz6xWLefkQcjCRO3c8jNbQeaNQqk9GtopNlmlYMKqG9qddT6GrEhO
         TB8/IhH5IRXRGoOiduHvcwXaQqLLG6a5zUsA9RamAO63Qd55Q4uNZ8uf5opuafzSJ3wU
         4EoSA51mdiUpeJOiEB3DyDi/7BuofwVGQxkZEOV6A41akp0f+ZQbYiLwVyMXFascI5hX
         5jc7KuhbiRsr6Pni301JCPTLhg7vYqgUwEpTA8gdaMNs4hef4oaB547nF9xAmxHrLS4S
         jOm/Z0HtnAZT8RHzTdWyU9h897sJO7KhGdB2W1YUZtHUMTjnQrFieynpYMiNRPRArOu2
         QuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ks1uW4TsJ3ZwYPwFK3x+RKWO8sV8NPeu0lKhg7RGxMc=;
        b=jpDflzqhhippzd8SQ/91ccRZQY6i3UFYsO+zxfv2t7U9nDpvkY28/Va/rzizCfq/iv
         IyaTOFghfhX427HBJ2tbx7hem30qtgQurZ+mVLT4lr+Hk30kFkyXQeed9PdkVQcKUm03
         3nBzjHsyPbSx8fFOyyw+MK3v6Tl/kBLwQbaSr7HbwyezZ7D6toGc4FIQvhjwaER7DI8/
         o1IXWdc/YU8l317ozMiLCQmaJA/EBI2RKH5HPr+q90Akw8Ve7EKugwz0epBrTtPMY7Dr
         hVoYtlPozcVdYSn5iBUVhEKcbxguACa9kk1UVJvSOE3jj04E7BnTQoRQghWtDTmfO2DA
         3D4A==
X-Gm-Message-State: AOAM531M47fBpVINTHbMJ/oQckb6RPRXCPI5f8Sa/LTv6fKItQxyx1LD
        IIAmWUVt2yxxjIW0BvfPwMg=
X-Google-Smtp-Source: ABdhPJx7jLShVmGoeYKwf2yxHLO3Fyxxi8sd+xsztnxHS670UXmGsB6P9TFiuCk8zyonxIAxU4jvpg==
X-Received: by 2002:aa7:d78a:: with SMTP id s10mr1375841edq.310.1619139189674;
        Thu, 22 Apr 2021 17:53:09 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s5sm2807574ejq.52.2021.04.22.17.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:53:09 -0700 (PDT)
Date:   Fri, 23 Apr 2021 03:53:08 +0300
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
Message-ID: <20210423005308.wnhpxryw6emgohaa@skbuf>
References: <20210422230645.23736-1-mohammad.athari.ismail@intel.com>
 <20210422235317.erltirtrxnva5o2d@skbuf>
 <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771A73442ECD81BEC2F1F04D5459@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 12:45:25AM +0000, Ismail, Mohammad Athari wrote:
> Hi Vladimir,
> 
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Friday, April 23, 2021 7:53 AM
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
> > Hi Mohammad,
> > 
> > On Fri, Apr 23, 2021 at 07:06:45AM +0800, mohammad.athari.ismail@intel.com
> > wrote:
> > > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> > >
> > > Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet for
> > > 10/100Mbps by default. This setting doesn`t impact pre-emption
> > > capability for other speeds.
> > >
> > > Signed-off-by: Mohammad Athari Bin Ismail
> > > <mohammad.athari.ismail@intel.com>
> > > ---
> > 
> > What is a "pre-emption packet"?
> 
> In IEEE 802.1 Qbu (Frame Preemption), pre-emption packet is used to
> differentiate between MAC Frame packet, Express Packet, Non-fragmented
> Normal Frame Packet, First Fragment of Preemptable Packet,
> Intermediate Fragment of Preemptable Packet and Last Fragment of
> Preemptable Packet. 

Citation needed, which clause are you referring to?

> 
> This bit "VR_MII_DIG_CTRL1 bit-6(PRE_EMP)" defined in DesignWare Cores
> Ethernet PCS Databook is to allow the IP to properly receive/transmit
> pre-emption packets in SGMII 10M/100M Modes.

Shouldn't everything be handled at the MAC merge sublayer? What business
does the PCS have in frame preemption?

Also, I know it's easy to forget, but Vinicius' patch series for
supporting frame preemption via ethtool wasn't accepted yet. How are you
testing this?
