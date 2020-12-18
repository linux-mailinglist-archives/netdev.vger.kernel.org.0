Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB172DEA88
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgLRUxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgLRUxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:53:04 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAFFC0617A7;
        Fri, 18 Dec 2020 12:52:24 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx16so5096153ejb.10;
        Fri, 18 Dec 2020 12:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+8c1rIvZTzQ8Bs3HQBKl/eE71ZRjG3qZxpWx6FA9GKo=;
        b=PoNzKMOoSgQCx5msjP2UYyPa7AZ6EsUmMu1WdNvaTlRosmAuYsSUbYKQ35ZL0W7waT
         rnSnf/78EwTQdDeMtTPTcxu+j+i2U78rOMrs6EO+KhDVPegXPQqmkL5onRfL9f+kZEa+
         ZO7RtXQxdU66Zo1xFcWqOa7M+V47HN7qd3Wk9DdBmfmfsP4b0neH4T0g8MPs3qvLWxq0
         5tYp2Cc2rLu2Vo7ky+QE4UPtW5z3K6TDYWRLsFYC9+ouaMClKYfeWBRT+DpwYqJ5sRkR
         rfS8Sj5dOUApt995alfwf53QAOBP2ET9akheRZTnRDtvCPcOajCnNhhrdmUiEPhcMw4G
         Omlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8c1rIvZTzQ8Bs3HQBKl/eE71ZRjG3qZxpWx6FA9GKo=;
        b=qs2v5F/IKFbNqHbRDfL9lhPeC8uebULairR8tLAsfHKhcd3VU/9SdSb2kVpJnWOG16
         rvJFSz8i0RrDr7q+F5MWEWbSKPTJyysZGYWR5rcLAUdkUiQ6Q7Z0WzgZU6LNP3MAuReV
         2oT39yTuha4Tlwj9Qzj7V+KihA2+RxBBxyEFGffxFg/4AwJcoc7EsCniBxYEJ0COUZ1Y
         vginu0Ei7/eMaZ3vP74jkUS5BBxv5Hc4nhWcaVANMXNI/o9DIY1kfytpGJ7xe9bpqlis
         MTJu18pKHyJ6SvI+BXUeuvMmgVXnodVomwVirJFQlpvCCJmmXKNBODyI27KliAAR6DmE
         JfnQ==
X-Gm-Message-State: AOAM530qn4Vj7kNV3ukftKqUujzLww+aqZq7uSK/FuFte3NNilSefcxk
        Usi7cOndpIACcEKkoSiYQ5M=
X-Google-Smtp-Source: ABdhPJxKpmw2JIjGGJF5hBqwImpSO+0Fk2j4us96ccbT7QWDarWxpHRL7BNxU6Yqj6LBRwi6MPaE4g==
X-Received: by 2002:a17:906:3b8b:: with SMTP id u11mr5701651ejf.489.1608324742967;
        Fri, 18 Dec 2020 12:52:22 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id h12sm5770441eja.113.2020.12.18.12.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 12:52:22 -0800 (PST)
Date:   Fri, 18 Dec 2020 22:52:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
Message-ID: <20201218205220.jb3kh7v23gtpymmx@skbuf>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 12:30:20PM -0800, Florian Fainelli wrote:
> On 12/18/20 12:24 PM, Vladimir Oltean wrote:
> > Hi Florian,
> > 
> > On Fri, Dec 18, 2020 at 09:38:43AM -0800, Florian Fainelli wrote:
> >> The driver is already allocating receive buffers of 2KiB and the
> >> Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.
> >>
> >> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >>  drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> >> index 0fdd19d99d99..b1ae9eb8f247 100644
> >> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> >> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> >> @@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
> >>  			 NETIF_F_HW_VLAN_CTAG_TX;
> >>  	dev->hw_features |= dev->features;
> >>  	dev->vlan_features |= dev->features;
> >> +	dev->max_mtu = UMAC_MAX_MTU_SIZE;
> >>  
> >>  	/* Request the WOL interrupt and advertise suspend if available */
> >>  	priv->wol_irq_disabled = 1;
> >> -- 
> >> 2.25.1
> >>
> > 
> > Do you want to treat the SYSTEMPORT Lite differently?
> > 
> > 	/* Set maximum frame length */
> > 	if (!priv->is_lite)
> > 		umac_writel(priv, UMAC_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
> > 	else
> > 		gib_set_pad_extension(priv);
> 
> SYSTEMPORT Lite does not actually validate the frame length, so setting
> a maximum number to the buffer size we allocate could work, but I don't
> see a reason to differentiate the two types of MACs here.

And if the Lite doesn't validate the frame length, then shouldn't it
report a max_mtu equal to the max_mtu of the attached DSA switch, plus
the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
