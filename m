Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653574766CD
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhLPAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhLPAAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:00:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5520C061574;
        Wed, 15 Dec 2021 16:00:39 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so79626186eda.12;
        Wed, 15 Dec 2021 16:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=MwNsU4vuy1PLTYMBDfOak+X8drCHZ+rnd53fyKk6+s4=;
        b=qOIQMkNCGBRZZcaQf7oxV91r/PtoFdR0KxKYVIL1DWxhFw/1E+Ggv49R5NxgA7qUm+
         msPFHA2vUXHblPS46znWF5bK53Y6UDwo2b+31QIPBviQWwAfhqiQe42Mp71itpq7UtT0
         fNwXFPAsfxcexu5EaLaGEqxAjYmylALom4MItU5zqiXJPUMqAGOrNI5Vvd/sGBtArzqW
         m/zqmkV+FFjeKGaNTOPjZcRJYuQS9k97ft0hD15Q0jZs22IroZcnx6CmcyT3Ww0HipQq
         L1CmlqvYj73CMiObDe1IqnDQTgsE9A2Gzh/K4pVkuhLmmEtXQz4LY9UmLb5ACvB7+Ez9
         q/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=MwNsU4vuy1PLTYMBDfOak+X8drCHZ+rnd53fyKk6+s4=;
        b=qi7d+4L43MfNZKZK66mj0cfsyj5toMXSiIDhselGWHA+ssiDL+lBZdVO8RMjFHWkdl
         4d3nJaWk4zeXchhAYLSu+9YAamQRWqmf4la0fzABBiC30dxcoZd6S6pVN/VXc2ptAA2S
         xQSkHX1J0wzQ1Oy1B5gDm8FQO0WvCEY/cveHMEReqSjITj9U1LWZb3aEDMJx0EpH/La8
         xi/3yfm7VUkzS9r+Fpi2oyed6hGLbIwG7JSu3K9Zkh5V8QAPhzFJjbDBDzF76cfB91C6
         Cq+9ndgo7FivPbgO/5obLUYSU5WnwGvHOEJ9FJk2+uTkhKLejGoPr4n/kn3da80K8Qcp
         RxEQ==
X-Gm-Message-State: AOAM532Y8OWLRE5IBm0tWFsHnMWxGOwkNGPRtUD5rVdkRyWRdrIiYp2U
        Asq/NCwALsbdlFdetiHGico=
X-Google-Smtp-Source: ABdhPJz9V8YmaOGLVKnTMHbpExR5rLhBGNq3DW8NWylDLY98KK/UG6afVOZUL0gcEcA4f2RiLD6sEw==
X-Received: by 2002:a05:6402:2547:: with SMTP id l7mr17578300edb.301.1639612838377;
        Wed, 15 Dec 2021 16:00:38 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id oz20sm1161670ejc.60.2021.12.15.16.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 16:00:37 -0800 (PST)
Message-ID: <61ba81a5.1c69fb81.354b7.4b14@mx.google.com>
X-Google-Original-Message-ID: <YbqBoj/nn4WRLCRu@Ansuel-xps.>
Date:   Thu, 16 Dec 2021 01:00:34 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 11/16] net: dsa: qca8k: add tracking
 state of master port
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-12-ansuelsmth@gmail.com>
 <20211215095146.6awhx44lamojipoo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215095146.6awhx44lamojipoo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 11:51:46AM +0200, Vladimir Oltean wrote:
> On Tue, Dec 14, 2021 at 11:44:04PM +0100, Ansuel Smith wrote:
> > MDIO/MIB Ethernet require the master port and the tagger availabale to
> > correctly work. Use the new api master_state_change to track when master
> > is operational or not and set a bool in qca8k_priv.
> > We cache the first cached master available and we check if other cpu
> > port are operational when the cached one goes down.
> > This cached master will later be used by mdio read/write and mib request to
> > correctly use the working function.
> > 
> > qca8k implementation for MDIO/MIB Ethernet is bad. CPU port0 is the only
> > one that answers with the ack packet or sends MIB Ethernet packets. For
> > this reason the master_state_change ignore CPU port6 and checkes only
> > CPU port0 if it's operational and enables this mode.
> 
> CPU port 0 may not always be wired, it depends on board design, right?
> So the Ethernet management protocol may or may not be available to all users.
>

Out of 130 device we found only 2 device that had cpu 0 disconnected and
were Xiaomi device (so not really top of following standard and advised
config from qcom). Only qca833x supports the use of cpu port6 as an
alternative port. qca8327 doesn't work with cpu port6 as the only cpu
port and cpu0 port is mandatory.
I also tested out of curiosity if mac swap handle this case and no luck,
the switch still doesn't answer with ack packet.
(config I tested was declaring only port6 as cpu port, forcing mac swap
and test if this works. Every request timeouts. Normal connection works 
and the tagger correctly works.)

> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index ab4a417b25a9..6edd6adc3063 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -353,6 +353,7 @@ struct qca8k_priv {
> >  	struct dsa_switch_ops ops;
> >  	struct gpio_desc *reset_gpio;
> >  	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > +	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
> 
> Maybe "mgmt_master" would be a clearer naming scheme?
> 
> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.33.1
> > 
> 

-- 
	Ansuel
