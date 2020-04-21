Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C721B2AA2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgDUPFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgDUPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:05:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8928C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 08:05:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so4063879wmh.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpIJLsr9bZ+2IGvleHCYucpY1N64xZA2s6HmCEOagDw=;
        b=CMHax4rAaBkAoXiBHqbHpkDJoVlC3mEFPzXOIpWzBWO5EzAEectXPk8W8/2w9XQd24
         ywFYBB5n+DvdvRZTaf9QIGv3d3EgixROLaMXA9Dqgk/BN0ku5DWZZOjlycyyeRtnxO1R
         McEZ5Td7ltJkaRAXGKXwaCwxpF58JucgQFY3ZZSa/3ojiZVHwkC9sw3fXfxFzns7UZq8
         LMDRGQqannVHOqtCZPAOmY1q3L7TsSxqD2LzWxksIzsfpMNMsWQhljF19zyueceaFE2j
         x2NM0x9qm8xp7nK0EpixDoEO2Utn/LDG223JiFt4lyGZkPsLata+oBdf1Bb44sCD70NL
         5llg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpIJLsr9bZ+2IGvleHCYucpY1N64xZA2s6HmCEOagDw=;
        b=BLaK72uCqbBHr3qS5v37BZtPwLCrF2ILcCTGp2yHpbbKXkFeI5FxMmum+8SzfVluOQ
         hc2CDSqoIpQKz39fispBKydjLZc+DKp3NXdUEqdC691Mc//4m7sbN5SguXUc3+Kjr+YA
         3abbr3Iu0QAZ1ISj9tWUxZIKj6cEZjZ4vmRsgLU9VdncgKwO31ejazFBImJLEGqMaE53
         yR+5/4lC33vzR493flt2LlYVW2Pu6Dsn7+p+2eqGUYYYQu2Zx93IkQHilyjko4Wra0JD
         /F35yXLj32X1IJKAOvjvLwI+Up4PJor2mtoPYA/QBcBijKlF/Ob8iX4+kl0EUhxS3Oeg
         aK2g==
X-Gm-Message-State: AGi0PuY/4T42s8H0oVrGRTXgG7vpYbJR67hMo8gvc2WcM9Jcjo/RQRf2
        b+H89Gd45rl/fMGV11b3ljax1Q==
X-Google-Smtp-Source: APiQypIKmLfkQoEmQyKRrqksobd6vTSmfWiFWwo0lo/MTP7n+xmz0rYPOdO662eu4iSk6LJDUINPgA==
X-Received: by 2002:a1c:4085:: with SMTP id n127mr5661751wma.163.1587481505650;
        Tue, 21 Apr 2020 08:05:05 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k133sm4126151wma.0.2020.04.21.08.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 08:05:05 -0700 (PDT)
Date:   Tue, 21 Apr 2020 17:05:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V3 mlx5-next 01/15] net/core: Introduce
 master_get_xmit_slave
Message-ID: <20200421150504.GZ6581@nanopsycho.orion>
References: <20200421102844.23640-1-maorg@mellanox.com>
 <20200421102844.23640-2-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421102844.23640-2-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 21, 2020 at 12:28:30PM CEST, maorg@mellanox.com wrote:
>Add new ndo to get the xmit slave of master device.
>User should release the slave when it's not longer needed.

"User" is a bit misleading.
Perhaps "Caller should call dev_put() when it no longer works with slave
netdevice". "


>When slave selection method is based on hash, then the user can ask to
>get the xmit slave assume all the slaves can transmit.

This is not specific for selection method.


>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> include/linux/netdevice.h | 33 +++++++++++++++++++++++++++++++++
> 1 file changed, 33 insertions(+)
>
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index 130a668049ab..ab324a2b04c8 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -1389,6 +1389,9 @@ struct net_device_ops {
> 						 struct netlink_ext_ack *extack);
> 	int			(*ndo_del_slave)(struct net_device *dev,
> 						 struct net_device *slave_dev);
>+	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
>+						      struct sk_buff *skb,
>+						      bool all_slaves);
> 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
> 						    netdev_features_t features);
> 	int			(*ndo_set_features)(struct net_device *dev,
>@@ -4676,6 +4679,36 @@ static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
> 	skb->mac_len = mac_len;
> }
> 
>+/**
>+ * master_get_xmit_slave - Get the xmit slave of master device
>+ * @skb: The packet
>+ * @all_slaves: assume all the slaves are active
>+ *
>+ * This can be called from any context and does its own locking.
>+ * The returned handle has the usage count incremented and the caller must
>+ * use dev_put() to release it when it is no longer needed.
>+ * %NULL is returned if no slave is found.
>+ */
>+
>+static inline
>+struct net_device *master_get_xmit_slave(struct net_device *dev,
>+					 struct sk_buff *skb,
>+					 bool all_slaves)

1) this function is a bit too big to be inline. Conside moving it to
dev.c
2) Please rename the function to contain netdev_ prefix preferably:
netdev_get_xmit_slave()
the ndo does not contain "master", don't have it here.


>+{
>+	const struct net_device_ops *ops = dev->netdev_ops;
>+	struct net_device *slave_dev;
>+
>+	if (!ops->ndo_get_xmit_slave)
>+		return NULL;
>+
>+	rcu_read_lock();
>+	slave_dev = ops->ndo_get_xmit_slave(dev, skb, all_slaves);
>+	if (slave_dev)
>+		dev_hold(slave_dev);
>+	rcu_read_unlock();
>+	return slave_dev;
>+}
>+
> static inline bool netif_is_macsec(const struct net_device *dev)
> {
> 	return dev->priv_flags & IFF_MACSEC;
>-- 
>2.17.2
>
