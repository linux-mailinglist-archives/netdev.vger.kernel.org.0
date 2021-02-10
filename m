Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7EB3162C2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBJJwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBJJui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:50:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA19C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:49:58 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id w2so2897760ejk.13
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Q5bQyQ8IS37wv39ZHRPDAzN4fI8/qzVcd35DG9rFLY=;
        b=lJ1TnOkrZv/1PfykX+h78rns7ux6llFRy8IwvtH/wbr3R8iuIU4gYBkYvUtUxtkVK9
         iisEND+aeMgCY4aRc8+SJNPFvVGgrOxXgVUPEBkWX+MhXyxODFcg7/XBvG6rHznez7Jv
         iH+n9A5gj6hAvZ13nryx0jGwzsxcazTDeFUMFYTNMZc9F8uMqLUGyaf2kefOT4p3cBbb
         76SCLgzJzxhANT4+H4PwvFjIMGb5BWRDKD7V8ijf8iUPppTfP1GhO2sjSwIGdVuDqqIm
         3S/rgPCm84Jdtlfm0OIDkweWahEmyEsqNkH32Bkx8smwbhZONpsf9Jdt9EtXdcezVWVO
         T1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Q5bQyQ8IS37wv39ZHRPDAzN4fI8/qzVcd35DG9rFLY=;
        b=htsVR2oC6sSrpcFUt+t2S7E0dSkkWLWLiVecw8sf+zO6HhEMQdknslQyh42hYOJnGE
         Jnkr4iX02OLK9juHVkBInPCAFyz2kCv7GyMWygUT/wm0vZNx/a/K4feGva7MNUCBxzED
         qzgowhGtiJpnDE4iqLA6O9T7XQo7KKeFFPRd40LkYAAeeTnkfflBAn5SkOr+Rj5fE2Na
         0fFzcElfXmrcCaZ9el9C53eant/ROxeeeSEvJ1aofd3Yf01bivtNaDDOGnuZPPvaKP09
         LiICc7jpEJqhH+cZa+P0/LrbLAJPiUBDX2fPTxhncNTWy86LyxSK5jPXSxjLVcyig8rH
         WQug==
X-Gm-Message-State: AOAM531qcKvKySfWBJYkBIrZXGW96T1Tpjl6GeyaW8dfagYIHpcpusX0
        53uS2EUMgcGGykXbTNs+sp4=
X-Google-Smtp-Source: ABdhPJyEpTpEfiMAQYkJMkg0ICQkU7f3uCVRI5Rp1fNAbFTw4K0okj1lONBleNoqq/aYLAIAZ3ygOw==
X-Received: by 2002:a17:906:46ce:: with SMTP id k14mr2187697ejs.480.1612950596784;
        Wed, 10 Feb 2021 01:49:56 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm740824eja.81.2021.02.10.01.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:49:55 -0800 (PST)
Date:   Wed, 10 Feb 2021 11:49:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: dsa: xrs700x: add HSR offloading
 support
Message-ID: <20210210094954.7fi4bhh6dboa6s5i@skbuf>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-5-george.mccollister@gmail.com>
 <f5b361ec-c8a1-22b7-42b3-94fbe4387525@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b361ec-c8a1-22b7-42b3-94fbe4387525@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 08:11:15PM -0800, Florian Fainelli wrote:
> 
> 
> On 2/9/2021 5:02 PM, George McCollister wrote:
> > Add offloading for HSR/PRP (IEC 62439-3) tag insertion, tag removal
> > forwarding and duplication supported by the xrs7000 series switches.
> > 
> > Only HSR v1 and PRP v1 are supported by the xrs7000 series switches (HSR
> > v0 is not).
> > 
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
> [snip]
> > +	val &= ~BIT(dsa_upstream_port(ds, port));
> > +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
> > +	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
> > +
> > +	regmap_fields_write(priv->ps_forward, partner->index,
> > +			    XRS_PORT_FORWARDING);
> > +	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> > +
> > +	hsr_pair[0] = port;
> > +	hsr_pair[1] = partner->index;
> > +	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> > +		slave = dsa_to_port(ds, hsr_pair[i])->slave;
> > +		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;
> 
> It's a bit weird to change the supported features while joining, usually
> you set them ahead of time to indicate what you are capable of doing and
> those can get toggled by user-space to enable/disable said feature, I
> suppose the goal here is to influence the HSR data path's decisions to
> insert or not tags so this may be okay. This does beg several questions:
> 
> - should slave->vlan_features also include that feature set somehow (can
> I have a VLAN upper?)

hsr_check_dev_ok:
	if (is_vlan_dev(dev)) {
		NL_SET_ERR_MSG_MOD(extack, "HSR on top of VLAN is not yet supported in this driver.");
		return -EINVAL;
	}

> - should there be a notifier running to advertise NETDEV_FEAT_CHANGE?

I felt it's a bit weird too to toggle the netdev flags just like that
instead of just enabling them at probe time or something (or have DSA
set them in dsa_slave_create(), just as it currently checks
ds->ops->port_vlan_add), but since there's no need for anyone to process
that notification, and there don't appear to be any strict guidelines, I
didn't say anything. I guess the current code is just fine for what is
needed at the moment.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
