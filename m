Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4645B81A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhKXKOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:14:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59507 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhKXKOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:14:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A4535C0170;
        Wed, 24 Nov 2021 05:11:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Nov 2021 05:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JEFWLNaq+OfFX3mgf
        1knwf0nj1Dz490zDBQw2w/ypQs=; b=mXQ/8z5cKM82YklPnlLfcpfss8eHiBbBc
        i6xRHaWNUEnaKxuMFlfPHO35mR2WESCmGlDLa76ntbG30mlCYEueXOlyWLQtr0pF
        A6wobEZ0rQH6l1xSIM2c7h5g+0ER0E32V6NjiCCx2w4uzlGflzQtN5E2KZTB+bVC
        dZDS9LLYIdXC4MV3+ikx31MDsfPMaEk/vrPcrP0MkEqeCev2/hSDd3yXhFvTVu4U
        8FDkBu9MgK+F1xBFXfm2hJis/BvQCzGqPW9vAoSniz4y0QxxY3CYJgCH2pg15NQo
        R9sFSotDP6qr218SpXu+MMcV4MO64UiWVivaJ2ardCXf1fSxaJtSQ==
X-ME-Sender: <xms:4A-eYUO2zRX5az9Z6i_KMAlrQlRK384tpsZRFi6xj1lrsxuQogwTXQ>
    <xme:4A-eYa_oEIIkZAGSBQBvbuQ1FO5p9P6R8yiqxJWNQATxTxI-EjUfeDvWkqfarW2ft
    PIGiRiTu7Z2GOg>
X-ME-Received: <xmr:4A-eYbSk9MyCWS3ZF7dTT9k-LdxZlqyCuottP19HB7if0l-spvNh-5IFWBtRRhAJW0l2sAHu0k6ioD5kQjYg-DmaIt3keU4i5_W9baiwU5_xxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeekgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4A-eYctE90I9iYW2ugeO6Cd7CNHImB0mx5_oVJQLK-tqlZ_-R54fGA>
    <xmx:4A-eYcdwflwyC3TzMXS_LIADRjyYzM_9U-Nelq9mtDLcU92FAZp-1g>
    <xmx:4A-eYQ1rgwXIdRcrYu-6gDZQUAAfvkOjvCK1CFZOvhYkDqWFbj1DLQ>
    <xmx:4A-eYUQycYZ9I-c7fkP0u5zifI0_4coPUczjpWvctj6XJHTEkYA58w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Nov 2021 05:11:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@nvidia.com,
        roopa@nvidia.com, bernard@vivo.com, David.Laight@ACULAB.COM,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
Date:   Wed, 24 Nov 2021 12:11:22 +0200
Message-Id: <20211124101122.3321496-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit converted simple_strtoul() to kstrtoul() as suggested by
the former's documentation. However, it also forced all the inputs to be
decimal resulting in user space breakage.

Fix by setting the base to '0' so that the base is automatically
detected.

Before:

 # ip link add name br0 type bridge vlan_filtering 1
 # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
 bash: echo: write error: Invalid argument

After:

 # ip link add name br0 type bridge vlan_filtering 1
 # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
 # echo $?
 0

Fixes: 520fbdf7fb19 ("net/bridge: replace simple_strtoul to kstrtol")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_sysfs_br.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 11c490694296..159590d5c2af 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -41,7 +41,7 @@ static ssize_t store_bridge_parm(struct device *d,
 	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = kstrtoul(buf, 10, &val);
+	err = kstrtoul(buf, 0, &val);
 	if (err != 0)
 		return err;
 
-- 
2.31.1

