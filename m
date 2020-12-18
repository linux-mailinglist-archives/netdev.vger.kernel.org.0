Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F952DEAD7
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLRVPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLRVPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:15:19 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFA2C0617A7;
        Fri, 18 Dec 2020 13:14:38 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id lt17so5217442ejb.3;
        Fri, 18 Dec 2020 13:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJi4jtdQuDqGEt07PwiKJC5d4j2By/gmdsJ1oEq9SmE=;
        b=X96lW4YyddkMCGcpnFVQcxHKWJpRXLQGtNfY0KeuG9rZ7WidgjVPDjQJcPVREzwhgt
         kaERPrOoXOsUW4vPLIwudaBt4ZnfQ9mOolzG3XosMDehPQ7771mZIckJQfW/yPQp2JH0
         qriaLwmBtGLbg9GXJWUlOvwQXi7XOX6WEmumypasBSffHY2pzshRG6Cp+PB1OhbwTXoJ
         xj1wqeWzNPpgYVhnBgquGGFBOUWdbxUTLgo4Phk1e9nJJBTOL8HCybL3qtIfR1zekEk5
         eJ8kOgD/4ZezvN6PRS7unp6GG/blfNzz/y8L6FaQ+qa/cg8vhZTldb+OH928fYg2FkaW
         9IFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJi4jtdQuDqGEt07PwiKJC5d4j2By/gmdsJ1oEq9SmE=;
        b=M1WXPVbgkVaZ9LTS6rLtrEU3Q6uqz1nwJO1yzMgQfmt3auVsGhBDazz1NMcZB9zP54
         is33Sx15ub5rawW5A4hvstC+/dmAqHiTSBuBncpJ+PJfypS+1N9xQjeTiB5bd1sI3iZG
         2oCLLTos7MAXcPY8FbPECr82RTRmmiw8iSnFhpqHy8Q99MPSTimjnaZ5agePWLwoD9Fa
         o02i/nm3i6koVP19UrW3+Gy/7lLXnQ3C57cjAXEskpO7A9fCvWa+qUr40p5+Jx0pp6CA
         mk2a+PiudKuxO3JdO0zzzHm4QL75VrqXTgTDCis0WeH8Z8BfHnEajMbzhEsJVZ1pRttW
         Fp5A==
X-Gm-Message-State: AOAM5313+8WTVIN1GJX9n36c4oJOKTuUc4p58caPMN7baqvXR4e16tif
        Cx1x8RgF8ZksHv+hYw8OJGA=
X-Google-Smtp-Source: ABdhPJw6cfqLcNBFKhfsYZ7y4u4m6Y8S+FxO1GoYiHTXIqCkoJN6PZtOEFwdWXFR7Ntz69Kzy0/D/Q==
X-Received: by 2002:a17:906:ae4e:: with SMTP id lf14mr6058062ejb.310.1608326077264;
        Fri, 18 Dec 2020 13:14:37 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id g10sm25455239edu.97.2020.12.18.13.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 13:14:36 -0800 (PST)
Date:   Fri, 18 Dec 2020 23:14:35 +0200
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
Message-ID: <20201218211435.mjdknhltolu4gvqr@skbuf>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
 <20201218205220.jb3kh7v23gtpymmx@skbuf>
 <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
 <20201218210250.owahylqnagtssbsw@skbuf>
 <cf2daa3c-8f64-0f58-5a42-2182cec5ba4a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf2daa3c-8f64-0f58-5a42-2182cec5ba4a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 01:08:58PM -0800, Florian Fainelli wrote:
> On 12/18/20 1:02 PM, Vladimir Oltean wrote:
> > On Fri, Dec 18, 2020 at 12:54:33PM -0800, Florian Fainelli wrote:
> >> On 12/18/20 12:52 PM, Vladimir Oltean wrote:
> >>> On Fri, Dec 18, 2020 at 12:30:20PM -0800, Florian Fainelli wrote:
> >>>> On 12/18/20 12:24 PM, Vladimir Oltean wrote:
> >>>>> Hi Florian,
> >>>>>
> >>>>> On Fri, Dec 18, 2020 at 09:38:43AM -0800, Florian Fainelli wrote:
> >>>>>> The driver is already allocating receive buffers of 2KiB and the
> >>>>>> Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.
> >>>>>>
> >>>>>> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> >>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>>>>> ---
> >>>>>>  drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
> >>>>>>  1 file changed, 1 insertion(+)
> >>>>>>
> >>>>>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>>>> index 0fdd19d99d99..b1ae9eb8f247 100644
> >>>>>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>>>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>>>> @@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
> >>>>>>  			 NETIF_F_HW_VLAN_CTAG_TX;
> >>>>>>  	dev->hw_features |= dev->features;
> >>>>>>  	dev->vlan_features |= dev->features;
> >>>>>> +	dev->max_mtu = UMAC_MAX_MTU_SIZE;
> >>>>>>  
> >>>>>>  	/* Request the WOL interrupt and advertise suspend if available */
> >>>>>>  	priv->wol_irq_disabled = 1;
> >>>>>> -- 
> >>>>>> 2.25.1
> >>>>>>
> >>>>>
> >>>>> Do you want to treat the SYSTEMPORT Lite differently?
> >>>>>
> >>>>> 	/* Set maximum frame length */
> >>>>> 	if (!priv->is_lite)
> >>>>> 		umac_writel(priv, UMAC_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
> >>>>> 	else
> >>>>> 		gib_set_pad_extension(priv);
> >>>>
> >>>> SYSTEMPORT Lite does not actually validate the frame length, so setting
> >>>> a maximum number to the buffer size we allocate could work, but I don't
> >>>> see a reason to differentiate the two types of MACs here.
> >>>
> >>> And if the Lite doesn't validate the frame length, then shouldn't it
> >>> report a max_mtu equal to the max_mtu of the attached DSA switch, plus
> >>> the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
> >>
> >> And how would I do that without create a horrible layering violation in
> >> either the systemport driver or DSA? Yes the b53 driver supports jumbo
> >> frames.
> > 
> > Sorry, I don't understand where is the layering violation (maybe it doesn't
> > help me either that I'm not familiar with Broadcom architectures).
> > 
> > Is the SYSTEMPORT Lite always used as a DSA master, or could it also be
> > used standalone? What would be the issue with hardcoding a max_mtu value
> > which is large enough for b53 to use jumbo frames?
> 
> SYSTEMPORT Lite is always used as a DSA master AFAICT given its GMII
> Integration Block (GIB) was specifically designed with another MAC and
> particularly that of a switch on the other side.
> 
> The layering violation I am concerned with is that we do not know ahead
> of time which b53 switch we are going to be interfaced with, and they
> have various limitations on the sizes they support. Right now b53 only
> concerns itself with returning JMS_MAX_SIZE, but I am fairly positive
> this needs fixing given the existing switches supported by the driver.

Maybe we don't need to over-engineer this. As long as you report a large
enough max_mtu in the SYSTEMPORT Lite driver to accomodate for all
possible revisions of embedded switches, and the max_mtu of the switch
itself is still accurate and representative of the switch revision limits,
I think that's good enough.
