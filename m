Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED1C49B713
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354720AbiAYPA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389535AbiAYOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:55:04 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D45C06177E;
        Tue, 25 Jan 2022 06:55:03 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j2so63483875edj.8;
        Tue, 25 Jan 2022 06:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=crjTrd9M4g5zqsW74dFKakrug7DzFaLfnMg4MjXrRx8=;
        b=OkeHIVkUI+kDuOi08W9mmLxcCt4SssENj2H86BPf4gX41g9Ft6F8AOpLtj9NN2BTNx
         u0T/7jjXF/shLXDkYHcEltqcYgrm8cl0UYpgVuDEroTLv4VV2uAPyQR3JPZO+ffauw2d
         eKIGdbMwrAEJRWyzckIbM78Yh3LIrGEde5qWjdxiriMGvb6ycQNuS1MBlylV5K8TaKlj
         xcg/BK7ZT2MY1VE/sNoC1IPD88QfSrl8BlFbWAsi3A7iBwrFqoqILwctO09evMIS5qVn
         x1JMoS2DtiB7tHpy41Lug+NrFYV0sWO193RaYNHCt3dVbYrMU2TUpEgkvUF7k7GHAx2a
         LiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=crjTrd9M4g5zqsW74dFKakrug7DzFaLfnMg4MjXrRx8=;
        b=B0BXVkANIM8TaYJmGetj5DFx+g8dOpJ88WBYmW9RS+FifeU1XDD8cIgsyKOnq5+xOJ
         PEJHgue18zHubDDlkGQTc+C7NHSrU+nZ14T9Yi9+6RkNAxc2Sr0rIq8xC7ByOACwt99E
         aXmlfMHNcGUkSGDJjCCzzVEJefbEcqsk7S2uotkPZVfV0GrvdL63sfPzzP2y6ucbEhU4
         OK5bjdpXZd8hc7PgfXlJiJgNUm7GzpF7Ip+/YhBSn3C3h0wayd6bxHTr4CjDZGoAn99q
         FD4rO+GJKJ48NvhwHIQPtSAZKbul+fdnSuehr7f6ZECHlna6eZNLcH76+FPjXwB4MGVT
         buKA==
X-Gm-Message-State: AOAM530f5ofg6mXQZIg/TUgxkV/1pnjpPjiZyyn8vPnR3QAYOG689yID
        bfApB6rnOJ5+M0f+D1l7ddo=
X-Google-Smtp-Source: ABdhPJzwhdabE8nC7yZQt+5/HALdGY85/mMFI0g3jfXE3fgr1eDv5aLPQyGIre4+hrsqITZZ63Zueg==
X-Received: by 2002:a17:907:60cd:: with SMTP id hv13mr1235585ejc.368.1643122501489;
        Tue, 25 Jan 2022 06:55:01 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id v3sm7732423edy.21.2022.01.25.06.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:55:00 -0800 (PST)
Date:   Tue, 25 Jan 2022 16:54:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 10/16] net: dsa: qca8k: add support for mgmt
 read/write in Ethernet packet
Message-ID: <20220125145459.i5jedxm225q5n5aq@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-11-ansuelsmth@gmail.com>
 <20220124163236.yrrjn32jylc2kx6o@skbuf>
 <61eed861.1c69fb81.d14ad.62cf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61eed861.1c69fb81.d14ad.62cf@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 05:48:32PM +0100, Ansuel Smith wrote:
> > > +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> > > +{
> > > +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> > > +	struct sk_buff *skb;
> > > +	bool ack;
> > > +	int ret;
> > > +
> > > +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> > > +	if (!skb)
> > > +		return -ENOMEM;
> > > +
> > > +	mutex_lock(&mgmt_hdr_data->mutex);
> > > +
> > > +	/* Recheck mgmt_master under lock to make sure it's operational */
> > > +	if (!priv->mgmt_master)
> > 
> > mutex_unlock and kfree_skb
> > 
> > Also, why "recheck under lock"? Why not check just under lock?
> >
> 
> Tell me if the logic is wrong.
> We use the mgmt_master (outside lock) to understand if the eth mgmt is
> available. Then to make sure it's actually usable when the operation is
> actually done (and to prevent any panic if the master is dropped or for
> whatever reason mgmt_master is not available anymore) we do the check
> another time under lock.
> 
> It's really just to save extra lock when mgmt_master is not available.
> The check under lock is to handle case when the mgmt_master is removed
> while a mgmt eth is pending (corner case but still worth checking).
> 
> If you have suggestions on how to handle this corner case without
> introducing an extra lock in the read/write function, I would really
> appreaciate it.
> Now that I think about it, considering eth mgmt will be the main way and
> mdio as a fallback... wonder if the extra lock is acceptable anyway.
> In the near future ipq40xx will use qca8k, but will have his own regmap
> functions so we they won't be affected by these extra locking.
> 
> Don't know what is worst. Extra locking when mgmt_master is not
> avaialable or double check. (I assume for a cleaner code the extra lock
> is preferred)

I don't think there's a hidden bug in the code (other than the one I
mentioned, which is that you don't unlock or free resources at all on
the error path, which is quite severe), but also, I don't know if this
is such a performance-sensitive operation to justify a gratuitous
"optimization".
As you mention, if the Ethernet management will be the main I/O access
method, then the common case will take a single lock. You aren't really
saving much.
