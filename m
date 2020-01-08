Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A4B134421
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgAHNoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:44:03 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37196 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgAHNoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:44:02 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so1616904pga.4;
        Wed, 08 Jan 2020 05:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gmq+OYn2q2vGsfM0iTs4x3raT2eS8sck0M2TsL5zr/w=;
        b=WxYhqAW0LDM6dq7oo5G4VIPflo6uRiAjBhblX0puDGyW4xnq/8ivEYcT9bVSz6xxrE
         FR/XWh1F0bBBGJN55zLYpVNAJCu76npUZXsKDPBiS+1YpTJcWbfu+481eGiMWydBj3ri
         Nci4adeZCACFHxC3E+L4t5mnFT6sarelSITx+auPC7MfBTpQWyZDCEI0oZTuEzy166Ff
         JMDCExuR/+QiNMMgMI1lYEYVuoiFRFY7yWK1UBLRMh2vTwatsSedI07einwflhh7VInE
         KLVWdkAnYoqwmW+QjQSh2351/H+//ZwWKHcpjcGgSWjKNK5hFbDnE7xm45asJNmHFR54
         Fapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gmq+OYn2q2vGsfM0iTs4x3raT2eS8sck0M2TsL5zr/w=;
        b=cS6Rs3t9R3YYlq/hXnc1ASfVMjY3yyjSRRHhhmcgzPg22j0zpjzCwEFBMagS8PAUWj
         JGDs0xWAiyMcosJBdywYvzMClw0eychpEnzRp8+ZEdDLW6zhRb6XzYbcyOvtc3KBK12U
         doti3WDOzIM9IthsFw2LFu+Dgwj1hTfKzL5xtqYIwLdR15fou0+q968wowzrebD2cgd6
         FMWu3br2Ns5remZ/jLQn7dYm7BpJ1qBGXX6SFTLDN7/Yfs0JQLR3uM0DaM5Qb0xho5/c
         DEb5rJmYcIvxi2HYUw5+Z+rto1j9GwULzEdq3KbIUwAnE4ELCzByvhYrFegAEpyyr1RN
         e+lw==
X-Gm-Message-State: APjAAAWHFmWzu/+gWBjZ/V3r/twtXm59oGMIXeWgnMUcxoRdEfgSDPHe
        EHhwyjju2HwmD9Ge4krOK+s=
X-Google-Smtp-Source: APXvYqxyjp0TG2gDqFgwVwFZ3d4b7bobaDPhrkaSTx0R0mEy2MZXSHeB475CA+IzwA8FQge9svwPUw==
X-Received: by 2002:a63:2d44:: with SMTP id t65mr5578887pgt.112.1578491042039;
        Wed, 08 Jan 2020 05:44:02 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id z6sm3788961pfa.155.2020.01.08.05.44.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 05:44:01 -0800 (PST)
Date:   Wed, 8 Jan 2020 21:43:59 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] net: stmmac: remove useless code of phy_mask
Message-ID: <20200108134359.GA5909@nuc8i5>
References: <20200108072550.28613-1-zhengdejin5@gmail.com>
 <BN8PR12MB326627D0E1F17AE7515B78E4D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200108112652.GA5316@nuc8i5>
 <BN8PR12MB3266601BC7BA0F414BD60E19D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266601BC7BA0F414BD60E19D33E0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 01:25:21PM +0000, Jose Abreu wrote:
> From: Dejin Zheng <zhengdejin5@gmail.com>
> Date: Jan/08/2020, 11:26:52 (UTC+00:00)
> 
> > On Wed, Jan 08, 2020 at 07:57:14AM +0000, Jose Abreu wrote:
> > > From: Dejin Zheng <zhengdejin5@gmail.com>
> > > Date: Jan/08/2020, 07:25:48 (UTC+00:00)
> > > 
> > > > Changes since v1:
> > > > 	1, add a new commit for remove the useless member phy_mask.
> > > 
> > > No, this is not useless. It's an API for developers that need only 
> > > certain PHYs to be detected. Please do not remove this.
> > >
> > Hi Jose:
> > 
> > Okay, If you think it is a feature that needs to be retained, I will
> > abandon it. since I am a newbie, after that, Do I need to update the
> > other commit in this patchset for patch v3? Thanks!
> 
> Your first commit (1/2) looks okay so you can submit that stand-alone in 
> my opinion.
>
Jose, thanks for your suggestions, You are so nice! I will do it.
> ---
> Thanks,
> Jose Miguel Abreu
