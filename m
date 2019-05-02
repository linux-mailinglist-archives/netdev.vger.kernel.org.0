Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B841180B
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfEBLNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:13:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40753 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfEBLNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 07:13:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 89C7F25AA4;
        Thu,  2 May 2019 07:13:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 May 2019 07:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Gm4jmvd+DXW/DAKp6famFtms1XJ9idMgfEIwZKnr9vM=; b=ZMKUSeio
        qoRxmq/kCPMr87HlWTmB3rsqigrMyc+Y8GbXoPPIfAU096EJs2zniMDAFtnYK/l8
        AQuI3KCfCDzwcluPCJBvHqsa+vszTyxMKEDrlm/wa1Zl4bt6MYUnHB50ypa/ZOBO
        Kk2i+Q+uGhILysnZ1nLBULiMdcY7oJqmgrZ0t5qBeb2oo+IM4LNFX8H6WbYl3vRg
        4a8VHP/oTgozPQKHkfduF9vSA8IE65Cve+2AmpuGxzz0waHN5v4PVqWRTqGQrsil
        yK0J2INuR9+GSg0VSZSv9PNnVIFvTPRsn9FBYw1nwn/6nsVVYRwCX5jNQjaWyEQn
        6sGyXIcRmNJiwg==
X-ME-Sender: <xms:7tDKXBP4Niwa7ZtgLIV1L-Szuq96uiSiNNKifbmES-DZ33Up3AAqBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7tDKXDg6Lm6mUrF4SHIS4zMf2AjOlnhh85FV5nDFRNMqzFlNT4fQqw>
    <xmx:7tDKXECU5cWIhEpbBN7sCCLbhHb-utkwFlS8j4C5MffyC_8JaLvN_Q>
    <xmx:7tDKXCLWEq7ibGUJpUaiC75TdtT7QtLvfnDxddXOf6qP2xlpzQi5ag>
    <xmx:7tDKXJRx1s0LyIe0B46l4dqTX0Px_dfxXEPk7eR6-Kj4HeVMnJ-IfQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 221E3E4173;
        Thu,  2 May 2019 07:13:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: resources: Add local_ports_in_{1x, 2x}
Date:   Thu,  2 May 2019 14:13:08 +0300
Message-Id: <20190502111309.6590-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502111309.6590-1-idosch@idosch.org>
References: <20190502111309.6590-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Since the number of local ports in 4x changed between SPC and SPC-2,
firmware expose new resources that the driver can query.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index 773ef7fdb285..33a9fc9ef6a4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -24,6 +24,8 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_MAX_SYSTEM_PORT,
 	MLXSW_RES_ID_MAX_LAG,
 	MLXSW_RES_ID_MAX_LAG_MEMBERS,
+	MLXSW_RES_ID_LOCAL_PORTS_IN_1X,
+	MLXSW_RES_ID_LOCAL_PORTS_IN_2X,
 	MLXSW_RES_ID_MAX_BUFFER_SIZE,
 	MLXSW_RES_ID_CELL_SIZE,
 	MLXSW_RES_ID_MAX_HEADROOM_SIZE,
@@ -78,6 +80,8 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_MAX_SYSTEM_PORT] = 0x2502,
 	[MLXSW_RES_ID_MAX_LAG] = 0x2520,
 	[MLXSW_RES_ID_MAX_LAG_MEMBERS] = 0x2521,
+	[MLXSW_RES_ID_LOCAL_PORTS_IN_1X] = 0x2610,
+	[MLXSW_RES_ID_LOCAL_PORTS_IN_2X] = 0x2611,
 	[MLXSW_RES_ID_MAX_BUFFER_SIZE] = 0x2802,	/* Bytes */
 	[MLXSW_RES_ID_CELL_SIZE] = 0x2803,	/* Bytes */
 	[MLXSW_RES_ID_MAX_HEADROOM_SIZE] = 0x2811,	/* Bytes */
-- 
2.20.1

