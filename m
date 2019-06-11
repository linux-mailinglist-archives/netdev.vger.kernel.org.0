Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59123C4DE
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404291AbfFKHUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54895 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404224AbfFKHUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7EB83224BB;
        Tue, 11 Jun 2019 03:20:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OkAlf0wzj2P65vyS1xiIcPMoMz4/0gsR6rR85UneUeg=; b=HNFAQ0Ah
        91loX8Cs/k2IN5K0cQGUdj31J64BEaF+oM3S3K9VLVejuH+/GB2oAvp5Zc3uj5r9
        fiEuy6d7RQnacSQs7s+6Pga+9ilFQZZ+7UD5xzs8QxALOz/Jf4OArEUsrZp3Mvmh
        1/NXieQDIW6Npvy0/66WVDgCfiDn7dnMf5fa6v1V+I+suUWz2ebvcCBysikojy4y
        4DzBXMgrDNKSZPEQdsO5zZWVUPQAN8VfD+p3TIaWhr9CFPmzRSdpIf24nmixCggh
        2DaYGc1y7VNjqokUtvAzyDP/jeLjVBE8RJWAQnZxNOag91ncJHtYliB2A8moW928
        OBfJmfQzCE34Zw==
X-ME-Sender: <xms:MVb_XLNdG6jNgHTbra3Ub2aqPIhQ25XdBid9QUCeIc7NYHhSse5HEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:MVb_XNHo-Devtu8YDdyZuRW_rTCG1aIPKaFpmVw7LF_fMP0GgPgENA>
    <xmx:MVb_XMpjrUQgZp3D30LQvqBP_L_MdFSTYxew0KyJLuN9_YAHZPFRqg>
    <xmx:MVb_XJbjEu3OMFRvcZaFSJfApXJ3APIlig8oqkpVy58giRuRgtTejA>
    <xmx:MVb_XJb4u9fbz7gOiWOIBCR7SU6Me0XdEPIkRtWpTpDV4RdvM4ALOw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9BA87380088;
        Tue, 11 Jun 2019 03:20:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 4/7] mlxsw: spectrum_flower: Fix TOS matching
Date:   Tue, 11 Jun 2019 10:19:43 +0300
Message-Id: <20190611071946.11089-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The TOS value was not extracted correctly. Fix it.

Fixes: 87996f91f739 ("mlxsw: spectrum_flower: Add support for ip tos")
Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 15f804453cd6..96b23c856f4d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -247,8 +247,8 @@ static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 				       match.mask->tos & 0x3);
 
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_IP_DSCP,
-				       match.key->tos >> 6,
-				       match.mask->tos >> 6);
+				       match.key->tos >> 2,
+				       match.mask->tos >> 2);
 
 	return 0;
 }
-- 
2.20.1

