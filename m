Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A4C1B0DA0
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgDTOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729055AbgDTOBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:01:23 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83A4C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:01:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so12278783wrv.10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3vSFuictiXaH6DTHu7ZG1ytuLG8BYZy4W0CQuxmGYs8=;
        b=tOb745zS5TEEe0RI6MG40EcpZ2e0YDjeI4tcBRazKqgW9b05jceB+8bWT6NL+vjvME
         rvDTR+Ypc+OjwtlP5YlYSH7jGdmBbaVgNxWV10TeikynNfoUqh07OzxC2uiCf/cayhpV
         MKv0J79CD9Y4FEgzumG1Bt13lLHytInG39uX+qjyN7AGsXo1HQDE/88bVFhDJyl/FPFm
         6sZo4ZvqUX8UkQLzET6tjq0cLTjvBuDSr2F8kvfhGeTee0yjyt1TKsbXoX1i920wnH9/
         D6PLgwzp2adrSx8eTljTAbf8NeD0VfDvyIKvd+lbfOlBE4axFZghWtszc03HaHcs51Dp
         eP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3vSFuictiXaH6DTHu7ZG1ytuLG8BYZy4W0CQuxmGYs8=;
        b=Wvv1bvYAqvvdZzves/i/YcbvOEVqJ1KYPm4t2DB1whPtx1otD3CIjW1+VuKenWYGA4
         gs3x+Efn7U1jdPmswbyzLglqDYPsWtZqZJZ11bHUf1OHKSZKdsbkjm1fmCCVv9sNqev6
         eyrQaTNrRQXQ7zzmfUOorJZqbSOO5JZ1KyMsQOZg1rM2mkmwwDdAGD33BgUnoGyHm5cA
         Bst1MH/nHsYnqocZKWW7pmoQphxLYoWyMo09LfvnBkj7BmpVt8ZWl+UbJB/jPjZb3Wu6
         JyO/AvkKThZVw8O6X0XRBeTbifYsuso+tuDosOlOBz95pokDk5/781WgEmBAn2yM5j7I
         4wPA==
X-Gm-Message-State: AGi0PuaGrpC10j4x+uFHajbjaaoQhSDKfVkftOinIJO6iXicz00DQ4Jl
        RW/J4xSVEXGG1WyOHBLgnl0TOg==
X-Google-Smtp-Source: APiQypI1i3OBkNY85OHtJAVy/MKsMr7pD6uqP5IhPCPyUl24ZnXaNs4STsSyn6JmvDssY+dK7WCG7g==
X-Received: by 2002:a5d:5085:: with SMTP id a5mr20425454wrt.394.1587391280517;
        Mon, 20 Apr 2020 07:01:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i5sm1301926wrw.77.2020.04.20.07.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:01:19 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:01:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200420140118.GJ6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420075426.31462-2-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 09:54:17AM CEST, maorg@mellanox.com wrote:
>Add new ndo to get the xmit slave of master device.
>User should release the slave when it's not longer needed.
>When slave selection method is based on hash, then the user can ask to
>get the xmit slave assume all the slaves can transmit by setting the
>LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> include/linux/netdevice.h |  3 +++
> include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
> 2 files changed, 35 insertions(+)
>
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index 130a668049ab..e8852f3ad0b6 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -1389,6 +1389,9 @@ struct net_device_ops {
> 						 struct netlink_ext_ack *extack);
> 	int			(*ndo_del_slave)(struct net_device *dev,
> 						 struct net_device *slave_dev);
>+	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
>+						      struct sk_buff *skb,
>+						      u16 flags);

Please adjust the name to:
ndo_get_lag_xmit_slave



> 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
> 						    netdev_features_t features);
> 	int			(*ndo_set_features)(struct net_device *dev,
>diff --git a/include/net/lag.h b/include/net/lag.h
>index 95b880e6fdde..c43b035989c4 100644
>--- a/include/net/lag.h
>+++ b/include/net/lag.h
>@@ -6,6 +6,38 @@
> #include <linux/if_team.h>
> #include <net/bonding.h>
> 
>+enum lag_get_slaves_flags {
>+	LAG_FLAGS_HASH_ALL_SLAVES = 1<<0

Enum name and the values should be in sync. Also sync with the ndo name.

Why exactly do you need these flags? Do you anticipate more of them?
A simple bool arg to the ndo would do I believe. Can be changed later if
needed.



>+};
>+
>+/**
>+ * master_xmit_slave_get - Get the xmit slave of master device
>+ * @skb: The packet
>+ * @flags: lag_get_slaves_flags
>+ *
>+ * This can be called from any context and does its own locking.
>+ * The returned handle has the usage count incremented and the caller must
>+ * use dev_put() to release it when it is no longer needed.
>+ * %NULL is returned if no slave is found.
>+ */
>+
>+static inline
>+struct net_device *master_xmit_get_slave(struct net_device *master_dev,

Please honor the namespace:
net_lag_get_xmit_slave

Also, just "struct net_device *dev" would be enough.



>+					 struct sk_buff *skb,
>+					 u16 flags)
>+{
>+	const struct net_device_ops *ops = master_dev->netdev_ops;
>+	struct net_device *slave = NULL;

"slave_dev" please.

Just check the ndo here and return NULL if it is not defined. That way
you avoid unnecessary NULL initialization and rcu lock.


>+
>+	rcu_read_lock();
>+	if (ops->ndo_xmit_get_slave)
>+		slave = ops->ndo_xmit_get_slave(master_dev, skb, flags);
>+	if (slave)
>+		dev_hold(slave);
>+	rcu_read_unlock();
>+	return slave;
>+}
>+
> static inline bool net_lag_port_dev_txable(const struct net_device *port_dev)
> {
> 	if (netif_is_team_port(port_dev))
>-- 
>2.17.2
>
