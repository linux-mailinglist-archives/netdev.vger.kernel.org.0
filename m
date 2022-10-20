Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD186060DF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJTNCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJTNCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:02:34 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD458051;
        Thu, 20 Oct 2022 06:02:33 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l22so29791938edj.5;
        Thu, 20 Oct 2022 06:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lUJaqu0J8uHiOqGzROFev5mvIptXzWIUlXDpg3Z7v8=;
        b=OMAxspufhBThmNShqa9UUDLPIBfzy7SZQc9dTZqpHU9Nlnt4O9ljoooqZkbDyQd5Wn
         gzIYe/LUJPI+ct8FN0Hi+S81HlfU7bPbcI0jAPSx43zoBQA7RP3DT1NUiRp0BipoagMe
         WM3BmOW+ag3j6MR7sNwwjfrrO6SQgW2CZxNW29anlb5TXwu8T542j57m+tr8sau23fD2
         kxdCniKunD5niZy3zxJkYdspCehbofu9E4eXyD9AJp+4tZDE7xEMSqpAMCdFj0BFxKXF
         nl0p/5bDAgJzZtUFKR+Qc2N0DnlSLU/UBg7ArX+2Ozcm8hbjyJ+w6M5zkFwbGKhOicd6
         R0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lUJaqu0J8uHiOqGzROFev5mvIptXzWIUlXDpg3Z7v8=;
        b=TK2/QwE1H0Nl7qBHskN7T+1JBywSxq1DnmY4qGRc4R3B3a6kGjjrjknz2MDQ3EXWjf
         ddiR/N9uGpYgsMLDozkHJkiSRNxAj8zKERDix2swp6K3KqzzHXqJqry4yZn3q9lFEHFR
         ca/NFCwz7Iyoj3EsfET9dMjgBx4WqqrIWY6nY4eiVdIiaErV5Rg4UoZuRKkdJ54zIgG0
         Qkw0Uvspk2T0alleGCQRyeDc25arjj+VgityCg2qKJwIFTLu5npCCMrQvG0QGa3TKjcx
         e0Fq0d53kRYfACPp0gTvrYM/MONE9cSfeQh6RCqtyVGNN1SBPSKOJ+5Y24MwgWzMR/wD
         0LPQ==
X-Gm-Message-State: ACrzQf02g3oEXL2ErN/OAi4CoDfOlhKq7iDcskKjjHeMOt/y9GOs6FBT
        vXHJxjer1usk2eGuJdxqvUo=
X-Google-Smtp-Source: AMsMyM4+6PM374Gyj2DQv2/S/zfoLY99XPugKikNwQJG38eZyHqATg8FtfwMPB9B1Y+1v9AuCZinNA==
X-Received: by 2002:a05:6402:1e8e:b0:45c:af84:63dd with SMTP id f14-20020a0564021e8e00b0045caf8463ddmr12189234edf.190.1666270950925;
        Thu, 20 Oct 2022 06:02:30 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g16-20020a056402115000b004575085bf18sm11938026edw.74.2022.10.20.06.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 06:02:28 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:02:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <20221020130224.6ralzvteoxfdwseb@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
> Add a new u16 for fdb flags to propagate through the DSA layer towards the
> fdb add and del functions of the drivers.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  include/net/dsa.h  |  2 ++
>  net/dsa/dsa_priv.h |  6 ++++--
>  net/dsa/port.c     | 10 ++++++----
>  net/dsa/slave.c    | 10 ++++++++--
>  net/dsa/switch.c   | 16 ++++++++--------
>  5 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index ee369670e20e..e4b641b20713 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -821,6 +821,8 @@ static inline bool dsa_port_tree_same(const struct dsa_port *a,
>  	return a->ds->dst == b->ds->dst;
>  }
>  
> +#define DSA_FDB_FLAG_LOCKED		(1 << 0)
> +
>  typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
>  			      bool is_static, void *data);
>  struct dsa_switch_ops {
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 6e65c7ffd6f3..c943e8934063 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -65,6 +65,7 @@ struct dsa_notifier_fdb_info {
>  	const struct dsa_port *dp;
>  	const unsigned char *addr;
>  	u16 vid;
> +	u16 fdb_flags;
>  	struct dsa_db db;
>  };
>  
> @@ -131,6 +132,7 @@ struct dsa_switchdev_event_work {
>  	 */
>  	unsigned char addr[ETH_ALEN];
>  	u16 vid;
> +	u16 fdb_flags;
>  	bool host_addr;
>  };
>  
> @@ -241,9 +243,9 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
>  		       const struct switchdev_vlan_msti *msti);
>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
> -		     u16 vid);
> +		     u16 vid, u16 fdb_flags);
>  int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
> -		     u16 vid);
> +		     u16 vid, u16 fdb_flags);
>  int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
>  				     const unsigned char *addr, u16 vid);
>  int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 208168276995..ff4f66f14d39 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
>  					 struct netlink_ext_ack *extack)
>  {
>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
> +				   BR_BCAST_FLOOD;
>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	int flag, err;
>  
> @@ -328,7 +328,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
>  {
>  	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
> +				   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB;

Why does the mask of cleared brport flags differ from the one of set
brport flags, and what/where is the explanation for this change?

>  	int flag, err;
>  
>  	for_each_set_bit(flag, &mask, 32) {
> @@ -956,12 +956,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
>  }
>  
>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
> -		     u16 vid)
> +		     u16 vid, u16 fdb_flags)
>  {
>  	struct dsa_notifier_fdb_info info = {
>  		.dp = dp,
>  		.addr = addr,
>  		.vid = vid,
> +		.fdb_flags = fdb_flags,
>  		.db = {
>  			.type = DSA_DB_BRIDGE,
>  			.bridge = *dp->bridge,
> @@ -979,12 +980,13 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
>  }
>  
>  int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
> -		     u16 vid)
> +		     u16 vid, u16 fdb_flags)
>  {
>  	struct dsa_notifier_fdb_info info = {
>  		.dp = dp,
>  		.addr = addr,
>  		.vid = vid,
> +		.fdb_flags = fdb_flags,
>  		.db = {
>  			.type = DSA_DB_BRIDGE,
>  			.bridge = *dp->bridge,
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 1a59918d3b30..65f0c578ef44 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -3246,6 +3246,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  		container_of(work, struct dsa_switchdev_event_work, work);
>  	const unsigned char *addr = switchdev_work->addr;
>  	struct net_device *dev = switchdev_work->dev;
> +	u16 fdb_flags = switchdev_work->fdb_flags;
>  	u16 vid = switchdev_work->vid;
>  	struct dsa_switch *ds;
>  	struct dsa_port *dp;
> @@ -3261,7 +3262,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  		else if (dp->lag)
>  			err = dsa_port_lag_fdb_add(dp, addr, vid);
>  		else
> -			err = dsa_port_fdb_add(dp, addr, vid);
> +			err = dsa_port_fdb_add(dp, addr, vid, fdb_flags);
>  		if (err) {
>  			dev_err(ds->dev,
>  				"port %d failed to add %pM vid %d to fdb: %d\n",
> @@ -3277,7 +3278,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  		else if (dp->lag)
>  			err = dsa_port_lag_fdb_del(dp, addr, vid);
>  		else
> -			err = dsa_port_fdb_del(dp, addr, vid);
> +			err = dsa_port_fdb_del(dp, addr, vid, fdb_flags);
>  		if (err) {
>  			dev_err(ds->dev,
>  				"port %d failed to delete %pM vid %d from fdb: %d\n",
> @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	bool host_addr = fdb_info->is_local;
>  	struct dsa_switch *ds = dp->ds;
> +	u16 fdb_flags = 0;
>  
>  	if (ctx && ctx != dp)
>  		return 0;
> @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
>  		   host_addr ? " as host address" : "");
>  
> +	if (fdb_info->locked)
> +		fdb_flags |= DSA_FDB_FLAG_LOCKED;

This is the bridge->driver direction. In which of the changes up until
now/through which mechanism will the bridge emit a
SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?

Don't the other switchdev drivers except DSA (search for SWITCHDEV_FDB_EVENT_TO_DEVICE
in the drivers/ folder) need to handle this new flag too, even if to reject it?

When other drivers will want to look at fdb_info->locked, they'll have
the surprise that it's impossible to maintain backwards compatibility,
because they didn't use to treat the flag at all in the past (so either
locked or unlocked, they did the same thing).

> +
>  	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
>  	switchdev_work->event = event;
>  	switchdev_work->dev = dev;
> @@ -3369,6 +3374,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
>  	switchdev_work->vid = fdb_info->vid;
>  	switchdev_work->host_addr = host_addr;
> +	switchdev_work->fdb_flags = fdb_flags;
