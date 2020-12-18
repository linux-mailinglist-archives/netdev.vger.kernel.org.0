Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C373D2DEAB6
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgLRVDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgLRVDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:03:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA2BC0617B0;
        Fri, 18 Dec 2020 13:02:53 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j16so3769616edr.0;
        Fri, 18 Dec 2020 13:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mzct5htaiEux0x9rPO5sq+ILOG2h8DTokZY7C5lhKkg=;
        b=BCdINtKQLiA24DLJWFXMCfu1JUUFx6/f4n5yu+UBopNswmAxv/YeeRIN2QCueWboqR
         cd0KcpYSCh0qBNkyup0yexILujiXngAJJC+qXT/eLyc3y5XQ/VFiW/SgeF4fkjSIDCSu
         Cml9Rn28XDqWQq5Xn2LVaVWES1qzDmEkc4cTASvE9KJjTIJFTngn5+naCcHDQOTwEEDH
         kejOxYMzU0GCTssnuPimA0Ye1ce1fqn0zhIfl7QN4WArFoKleOuizh7jPzbhVFYYObcy
         s06YveS12GdZ/VMe2rk9gZLD3vpes5/BGSng81VIs/wZrQWmoqocqXW9KJIDQ2EX9rVD
         xOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mzct5htaiEux0x9rPO5sq+ILOG2h8DTokZY7C5lhKkg=;
        b=rsWT+PBNyW0EctaobrIuOuT0njMmuKeLPimG2XINzcdJJLyWizXpH0vO8/+gzxO5N8
         ncw4QKq9uVPQAmeAmkg8d0Je7r0SpgdiR+ajzlLknMNFRMDYk9+gFsb1rB+eUHVq+P0o
         HBtHalLQcwziOTOmxRFUAgI1HIDCOwqWDQIlV74jQpmp7EXx522DJVDkPxBWTuSUCC5B
         PCQlKh1M/YVN9AisFIWTUXhW+zEOAqPOAZX0LsLdJZVT0ERoLaPv49Kxq3HxiRP/YOaz
         v3QZ+t2lWi+uf0zjPWrcCvOKW5NtYWKa3dr+WyeJOl7cBo3ChKnYmEW6IM/zgnbAu2K3
         Ow8Q==
X-Gm-Message-State: AOAM531XpkB3Hjbr56XKTJwmrEoQ8k4l3yxx22z8oz+HDVb09o/m6681
        AjDe8hEme3M0Ll6tW/doJdY=
X-Google-Smtp-Source: ABdhPJyxJWD4Fo3smfSZgPoleK1imWoabQUl6UBIgTiStR84QFPZOnmgOBoAgDJHdYgvnkLOwRGGPQ==
X-Received: by 2002:aa7:c78c:: with SMTP id n12mr6347111eds.363.1608325372500;
        Fri, 18 Dec 2020 13:02:52 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id r1sm5901368eje.51.2020.12.18.13.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 13:02:51 -0800 (PST)
Date:   Fri, 18 Dec 2020 23:02:50 +0200
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
Message-ID: <20201218210250.owahylqnagtssbsw@skbuf>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
 <20201218205220.jb3kh7v23gtpymmx@skbuf>
 <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 12:54:33PM -0800, Florian Fainelli wrote:
> On 12/18/20 12:52 PM, Vladimir Oltean wrote:
> > On Fri, Dec 18, 2020 at 12:30:20PM -0800, Florian Fainelli wrote:
> >> On 12/18/20 12:24 PM, Vladimir Oltean wrote:
> >>> Hi Florian,
> >>>
> >>> On Fri, Dec 18, 2020 at 09:38:43AM -0800, Florian Fainelli wrote:
> >>>> The driver is already allocating receive buffers of 2KiB and the
> >>>> Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.
> >>>>
> >>>> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> >>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>>> ---
> >>>>  drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
> >>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>> index 0fdd19d99d99..b1ae9eb8f247 100644
> >>>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> >>>> @@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
> >>>>  			 NETIF_F_HW_VLAN_CTAG_TX;
> >>>>  	dev->hw_features |= dev->features;
> >>>>  	dev->vlan_features |= dev->features;
> >>>> +	dev->max_mtu = UMAC_MAX_MTU_SIZE;
> >>>>  
> >>>>  	/* Request the WOL interrupt and advertise suspend if available */
> >>>>  	priv->wol_irq_disabled = 1;
> >>>> -- 
> >>>> 2.25.1
> >>>>
> >>>
> >>> Do you want to treat the SYSTEMPORT Lite differently?
> >>>
> >>> 	/* Set maximum frame length */
> >>> 	if (!priv->is_lite)
> >>> 		umac_writel(priv, UMAC_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
> >>> 	else
> >>> 		gib_set_pad_extension(priv);
> >>
> >> SYSTEMPORT Lite does not actually validate the frame length, so setting
> >> a maximum number to the buffer size we allocate could work, but I don't
> >> see a reason to differentiate the two types of MACs here.
> > 
> > And if the Lite doesn't validate the frame length, then shouldn't it
> > report a max_mtu equal to the max_mtu of the attached DSA switch, plus
> > the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
> 
> And how would I do that without create a horrible layering violation in
> either the systemport driver or DSA? Yes the b53 driver supports jumbo
> frames.

Sorry, I don't understand where is the layering violation (maybe it doesn't
help me either that I'm not familiar with Broadcom architectures).

Is the SYSTEMPORT Lite always used as a DSA master, or could it also be
used standalone? What would be the issue with hardcoding a max_mtu value
which is large enough for b53 to use jumbo frames?
