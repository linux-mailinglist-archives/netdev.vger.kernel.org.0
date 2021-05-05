Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34C0373355
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhEEAwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEAwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:52:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399E1C061574;
        Tue,  4 May 2021 17:51:42 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gx5so200004ejb.11;
        Tue, 04 May 2021 17:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+2AlW1nUqipe9WL69Gi7y5Ykm86EtENDPa0V3j4eQXU=;
        b=CTyO63glI5obcp2ZjiZBcOLaecnfnQLZJwtGb86SacLOj9eQQaB/8/0WaYUm6caurR
         rLpTiGbqZItbvebg+NWMIMxsV+zXw285uN4qYn+4NaYdVaTfQ0w2VcVbEH0BAQuJuwF7
         AWD78KzsPy0k7ppcfYn63E+9zg0fapNdKfOatSA07QG1mZt0gU8TAR++vQSIh/MMZKc+
         pTdgHuCs+gcBzfgMgGDqDOQOoPxcnmqF45L5ZgVeqc7egAnMOgrMj5aYZ18TlaFiq/P2
         G3qRzHnDRO5CeqWp4L5nYUZQ87NM71pofuAU8iXlxaKjZPTRip+UE+LmTREpqF7YOj3f
         sR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+2AlW1nUqipe9WL69Gi7y5Ykm86EtENDPa0V3j4eQXU=;
        b=qbgcreQm2tPyBN23lgf4sfe9so4BWj/uRyvv/RnUu2a6+kJIhDXJvzc0ApLLvOMpmj
         EHgJGKGbpFV3RjHgexrPkHX3MyNhvlCToXyScnCynaLq3MeC54dWrQOPtxA5+TX9AM/v
         9mmnr5AjuF2ULSTA86xVWzc8ADuKuOnWVCYBLg50iHKLlXdxVVfu04HwtO5uNU+v6gPg
         rc2LOsdL0N1yuMVRQpSKybL3Dets7SLMC2dU13dMnpQzy472WUU/dzPUd0463D2qf5m2
         ZNHm3xqZdbKRvYLhg3xCB9QYcwH+ICZUbFaNdscwXnmF2v2RckjJ9oCVFhAp1pIiDXoS
         iTPg==
X-Gm-Message-State: AOAM533HtoKfcHkYaWCB3M/5CVUuFxpVr9a9fkPY08UGeMCpgkTUUV7V
        HX/PI/Tu5vvzmn5TvxPmsVI=
X-Google-Smtp-Source: ABdhPJyy8YNyaxPc3UHeFfZnI02T9xvjGeOeb5Gtox7TotjHXb/B3NeLd68Oy9CY2H1GhTF4GtLa9A==
X-Received: by 2002:a17:906:71d8:: with SMTP id i24mr24567374ejk.444.1620175900772;
        Tue, 04 May 2021 17:51:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id v14sm1498259edx.5.2021.05.04.17.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:51:40 -0700 (PDT)
Date:   Wed, 5 May 2021 02:51:43 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 07/20] net: dsa: qca8k: handle error with
 qca8k_rmw operation
Message-ID: <YJHsH6OgtCCUCGEo@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-7-ansuelsmth@gmail.com>
 <YJHq346ATRgV2BZp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHq346ATRgV2BZp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:46:23AM +0200, Andrew Lunn wrote:
> > -static void
> > +static int
> >  qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
> >  {
> > -	qca8k_rmw(priv, reg, 0, val);
> > +	int ret;
> > +
> > +	ret = qca8k_rmw(priv, reg, 0, val);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> 
> Maybe return qca8k_rmw(priv, reg, 0, val); ??
> 
> > -static void
> > +static int
> >  qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
> >  {
> > -	qca8k_rmw(priv, reg, val, 0);
> > +	int ret;
> > +
> > +	ret = qca8k_rmw(priv, reg, val, 0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> >  }
> 
> Maybe return qca8k_rmw(priv, reg, val, 0);
> 
> > @@ -1249,17 +1280,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
> >  		/* Add this port to the portvlan mask of the other ports
> >  		 * in the bridge
> >  		 */
> > -		qca8k_reg_set(priv,
> > -			      QCA8K_PORT_LOOKUP_CTRL(i),
> > -			      BIT(port));
> > +		ret = qca8k_reg_set(priv,
> > +				    QCA8K_PORT_LOOKUP_CTRL(i),
> > +				    BIT(port));
> > +		if (ret)
> > +			return ret;
> >  		if (i != port)
> >  			port_mask |= BIT(i);
> >  	}
> > +
> >  	/* Add all other ports to this ports portvlan mask */
> > -	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > -		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
> > +	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > +			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
> >  
> > -	return 0;
> > +	return ret < 0 ? ret : 0;
> 
> Can this is simplified to 
> 
> 	return  = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> 			    QCA8K_PORT_LOOKUP_MEMBER, port_mask);
> 
> > @@ -1396,18 +1430,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
> >  			  struct netlink_ext_ack *extack)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > +	int ret;
> >  
> >  	if (vlan_filtering) {
> > -		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > -			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> > -			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
> > +		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > +				QCA8K_PORT_LOOKUP_VLAN_MODE,
> > +				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
> >  	} else {
> > -		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > -			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> > -			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
> > +		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> > +				QCA8K_PORT_LOOKUP_VLAN_MODE,
> > +				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
> >  	}
> >  
> > -	return 0;
> > +	return ret < 0 ? ret : 0;
> 
> What does qca8k_rmw() actually return?
>
>      Andrew

qca8k_rmw in the original code returns the value read from the reg and
modified. So this is why all the strange checks. The idea is to not
change the original return values of the users so I check if every return
value is negative and return 0 in all the other cases.

