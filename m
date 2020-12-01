Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECAE2C94C1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbgLABiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgLABiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 20:38:00 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F958C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 17:37:19 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id y4so592518edy.5
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 17:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BdnpVxJhsNGRrEOXccHIyzxbm/33axXGrjYkeiZTVSU=;
        b=dVddugL5FkUgPv0Fx37qFdFn8migTta5MlDHC4fanwQpByFB1ve8EAaQQod8V2si3k
         NdtO+FRxpRxwnKSCXssSVuUoRwaLSckkajWk3FvhOR+7QEkHpGQ7Syv/cqFgwUTCr1AH
         chKqwznu708er4kpKp6lZj20EpCZQrVafdMkzvgysFuwcTA/rTwGxZAkUV1l9esKxIqa
         0h/6T8d6ndUjETfk+0bI8vVYtIKBVhoEEDBumEGhCU4EWMWylo3Ji+qRYnG853Uh44w0
         ut7AC9Ee0wE1gzLaTo9PeSSW3wcGk4f0/WAsGoZqNmz7gw3F++k6Zyp/esqX6nY6Kpdj
         NhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BdnpVxJhsNGRrEOXccHIyzxbm/33axXGrjYkeiZTVSU=;
        b=MshWwRAZzwAoowyFbEn9S/EOMwjZqRDzZI/4KgiLtv0WCykWcFqduguK/+oVzeIzcU
         vVNH6H850VBzMh9L/1VoLzsr0oa1SYRsco/hOrLJAH16BPz/KxuWNfvXT8JeZ4MV8Czw
         pin/Xy9/+fMMOEEIhECFHHI09PqTv8bGU0XKoRQdI/15rb0yTzhIhTj8nQtM6cQG2Qt0
         8/XuDkGD/UKpkk4OVG/Q1qn3C2zEoQQBPtugaAI998/sbo+TRJAt62u6+1iU7jA68OiN
         cmuGBuA7Grc6BDgv+jIZJGVm9fwYewWDeOR9vEEIs3HLxEmQwG23ZXp7dXxNVw8JhSvP
         dQZQ==
X-Gm-Message-State: AOAM5308Mp2AXWcoru3TovHlu15BZW28SocPtdtyzqliYnImumoqk8or
        Wy6dCh1lYFo1qRi13HUA+oJBD92IoPQ=
X-Google-Smtp-Source: ABdhPJz+pnHx+3J99kxMUGSArZv1lZyVA6xXgsCOFuz6bp+PMJagjkJbdB4twOlkitXXUrS6P3pSTw==
X-Received: by 2002:a50:8a8e:: with SMTP id j14mr620221edj.87.1606786628039;
        Mon, 30 Nov 2020 17:37:08 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id r7sm62115eda.23.2020.11.30.17.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 17:37:07 -0800 (PST)
Date:   Tue, 1 Dec 2020 03:37:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201201013706.6clgrx2tnapywgxf@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130140610.4018-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and
> from each associated port.
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  97 +++++++++++++++++++++++++++++++
>  net/dsa/dsa2.c     |  51 ++++++++++++++++
>  net/dsa/dsa_priv.h |  31 ++++++++++
>  net/dsa/port.c     | 141 +++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/slave.c    |  83 ++++++++++++++++++++++++--
>  net/dsa/switch.c   |  49 ++++++++++++++++
>  6 files changed, 446 insertions(+), 6 deletions(-)
> 
> +static inline struct dsa_lag *dsa_lag_by_id(struct dsa_switch_tree *dst, int id)
> +{
> +	if (!test_bit(id, dst->lags.busy))
> +		return NULL;
> +
> +	return &dst->lags.pool[id];
> +}
> +
> +static inline struct net_device *dsa_lag_dev_by_id(struct dsa_switch_tree *dst,
> +						   int id)
> +{
> +	struct dsa_lag *lag = dsa_lag_by_id(dst, id);
> +
> +	return lag ? rcu_dereference(lag->dev) : NULL;
> +}
> +
> +static inline struct dsa_lag *dsa_lag_by_dev(struct dsa_switch_tree *dst,
> +					     struct net_device *dev)
> +{
> +	struct dsa_lag *lag;
> +	int id;
> +
> +	dsa_lag_foreach(id, dst) {
> +		lag = dsa_lag_by_id(dst, id);
> +
> +		if (rtnl_dereference(lag->dev) == dev)
> +			return lag;
> +	}
> +
> +	return NULL;
> +}
>  
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 73569c9af3cc..c2332ee5f5c7 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -193,6 +193,147 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
>  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
>  }
>  
> +static struct dsa_lag *dsa_lag_get(struct dsa_switch_tree *dst,
> +				   struct net_device *dev)
> +{
> +	struct dsa_lag *lag;
> +	int id;
> +
> +	lag = dsa_lag_by_dev(dst, dev);
> +	if (lag) {
> +		kref_get(&lag->refcount);
> +		return lag;
> +	}
> +
> +	id = find_first_zero_bit(dst->lags.busy, dst->lags.num);
> +	if (id >= dst->lags.num) {
> +		WARN(1, "No LAGs available");
> +		return NULL;
> +	}
> +
> +	set_bit(id, dst->lags.busy);
> +
> +	lag = &dst->lags.pool[id];
> +	kref_init(&lag->refcount);
> +	lag->id = id;
> +	INIT_LIST_HEAD(&lag->ports);
> +	INIT_LIST_HEAD(&lag->tx_ports);
> +
> +	rcu_assign_pointer(lag->dev, dev);
> +	return lag;
> +}
> +
> +static void dsa_lag_release(struct kref *refcount)
> +{
> +	struct dsa_lag *lag = container_of(refcount, struct dsa_lag, refcount);
> +
> +	rcu_assign_pointer(lag->dev, NULL);
> +	synchronize_rcu();
> +	memset(lag, 0, sizeof(*lag));
> +}

What difference does it make if lag->dev is set to NULL right away or
after a grace period? Squeezing one last packet from that bonding interface?
Pointer updates are atomic operations on all architectures that the
kernel supports, and, as long as you use WRITE_ONCE and READ_ONCE memory
barriers, there should be no reason for RCU protection that I can see.
And unlike typical uses of RCU, you do not free lag->dev, because you do
not own lag->dev. Instead, the bonding interface pointed to by lag->dev
is going to be freed (in case of a deletion using ip link) after an RCU
grace period anyway. And the receive data path is under an RCU read-side
critical section anyway. So even if you set lag->dev to NULL using
WRITE_ONCE, the existing in-flight readers from the RX data path that
had called dsa_lag_dev_by_id() will still hold a reference to a valid
bonding interface.
