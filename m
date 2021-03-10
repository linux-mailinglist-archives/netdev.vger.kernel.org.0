Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4401333C62
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhCJMQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhCJMPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCDBC061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w9so27667390edc.11
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FCzdhfFeLuimC7tMP6ktlzTOBwPmQ7o6+J5v8sj8Djc=;
        b=XxCHuPWxyLwiZdltBmvsKQZUq+eSvzlwVyTLugKrEYPqWZu+OMPoLqGXR1G2UwvFgv
         rcpiaS5Msg7W3Ik+AA+vboX4fkJTcxMWTEK3+HNdYy/tWI8ljIvSdtDd5BN344GjWp4x
         gCdsKj5rFRLxNky+kQ+W60Yrv5qlzsGPotYq4Id+7aTvdwCobD1/Aoz7lm4vhcSKESC2
         kgHabIW1zuv7tCKUmMfo9vH4hI1jyPUdgNjO+Em6Y/sdfgSPGEUWk3xIRlZMybTxiJ9Q
         8HxJkwJGZyHRzOOPtBOJhIc3TlC4raFeuWL2dYvL8VjnE2Xz+74QPuV/ZKXWctftiEfn
         8JCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FCzdhfFeLuimC7tMP6ktlzTOBwPmQ7o6+J5v8sj8Djc=;
        b=m9AnTCdVokRQ4s5PfFFOWUKMxr1w24jEDEouFDpilrTT0wxW72G5hzx90o42HNqBtx
         YjAkZvP5NXHfg31IVoF2x2hzyyJBYCRu86Tf7N7UzUy5hbvaYOEgSbSjJi04F98KZC2k
         /c2/0HmY2PBRV/4oP/aOve8DRGhCF6SnO5pYM+yaV+MMkJVyUMYqbKOUX8k5BK3UAoYO
         H9X6rn/MEqULqz21bpMeul2iLuj2snDWzQIQlm9C5Ylnl6XlA/N8f+IisT2Q6ZlS/dX5
         FAhB4V3i0xDeozL9XU+L1+ns0SmYXQ7CPsN9fE851xl39ASt96qRj5ucR2uS9w+A5U1y
         SH9A==
X-Gm-Message-State: AOAM533HrSpMn7yxHZaF0cpH0Vh9CcoVxnQiU9+MdFRHkRsW0yfXWifG
        Ycgo5umvqhqL1yerSPXcGsI=
X-Google-Smtp-Source: ABdhPJzXEA9KluvSQCHk+TcQjXpLDkHl6801sAQNm3nGcOn0G/yv2j2H/5Z/1HIAjkvRr7f8CKJYLQ==
X-Received: by 2002:aa7:c9d1:: with SMTP id i17mr2861653edt.46.1615378532221;
        Wed, 10 Mar 2021 04:15:32 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:31 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/15] staging: dpaa2-switch: remove obsolete .ndo_fdb_{add|del} callbacks
Date:   Wed, 10 Mar 2021 14:14:40 +0200
Message-Id: <20210310121452.552070-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Since the dpaa2-switch already listens for SWITCHDEV_FDB_ADD_TO_DEVICE /
SWITCHDEV_FDB_DEL_TO_DEVICE events emitted by the bridge, we don't need
the bridge bypass operations, and now is a good time to delete them. All
'bridge fdb' commands need the 'master' flag specified now.

In fact, having the obsolete .ndo_fdb_{add|del} callbacks would even
complicate the bridge leave/join procedures without any real benefit.
Every FDB entry is installed in an FDB ID as far as the hardware is
concerned, and the dpaa2-switch ports change their FDB ID when they join
or leave a bridge. So we would need to manually delete these FDB entries
when the FDB ID changes. That's because, unlike FDB entries added
through switchdev, where the bridge automatically deletes those on
leave, there isn't anybody who will remove the static FDB entries
installed via the bridge bypass operations upon a change in the upper
device.

Note that we still need .ndo_fdb_dump though. The dpaa2-switch does not
emit any interrupts when a new address is learnt, so we cannot keep the
bridge FDB in sync with the hardware FDB. Therefore, we need this
callback to get a chance to print the FDB entries that were dynamically
learnt by our hardware.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 27 -------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index fa0ec54b49fa..3067289a15a1 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -295,31 +295,6 @@ static int dpaa2_switch_port_fdb_del_mc(struct ethsw_port_priv *port_priv,
 	return err;
 }
 
-static int dpaa2_switch_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-				     struct net_device *dev, const unsigned char *addr,
-				     u16 vid, u16 flags,
-				     struct netlink_ext_ack *extack)
-{
-	if (is_unicast_ether_addr(addr))
-		return dpaa2_switch_port_fdb_add_uc(netdev_priv(dev),
-						    addr);
-	else
-		return dpaa2_switch_port_fdb_add_mc(netdev_priv(dev),
-						    addr);
-}
-
-static int dpaa2_switch_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-				     struct net_device *dev,
-				     const unsigned char *addr, u16 vid)
-{
-	if (is_unicast_ether_addr(addr))
-		return dpaa2_switch_port_fdb_del_uc(netdev_priv(dev),
-						    addr);
-	else
-		return dpaa2_switch_port_fdb_del_mc(netdev_priv(dev),
-						    addr);
-}
-
 static void dpaa2_switch_port_get_stats(struct net_device *netdev,
 					struct rtnl_link_stats64 *stats)
 {
@@ -726,8 +701,6 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_change_mtu		= dpaa2_switch_port_change_mtu,
 	.ndo_has_offload_stats	= dpaa2_switch_port_has_offload_stats,
 	.ndo_get_offload_stats	= dpaa2_switch_port_get_offload_stats,
-	.ndo_fdb_add		= dpaa2_switch_port_fdb_add,
-	.ndo_fdb_del		= dpaa2_switch_port_fdb_del,
 	.ndo_fdb_dump		= dpaa2_switch_port_fdb_dump,
 
 	.ndo_start_xmit		= dpaa2_switch_port_dropframe,
-- 
2.30.0

