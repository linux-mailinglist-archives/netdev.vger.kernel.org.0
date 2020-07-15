Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D01220725
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgGOI2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50397 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbgGOI2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A12B5C00D7;
        Wed, 15 Jul 2020 04:28:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nZP3AZymar/ggdI744MFVaAW7sYv77qcDAXO9symfIY=; b=V41IRkg0
        2/uvRLt0iY8Cskv4QqMc41NSjB3k3eSZyHkJwzje/6cXDFjf1koZlWNX2UGUSt/H
        EEHEuudjcWyCA0RrFpIZW2JRQtrktk6HQzG+fjxxFJpMoYDKlHInTMrSV5ACqMXz
        fzgg9ORk9uUyUNqDDJkfdMfBkSz4+McwYtlgGum5oXmppgOI5VG0m8bLoZlcCbS6
        zB4hfE4ZpADp/6zsol9RMDLRYTPmwFGMGedx1qtMOJaKM4sH7WBjtdcCkBmZev2W
        Ie+W7cw5Lo/BUHtlJq+pBKeoDu4xd/DNCI11odfwwNaSTY4B7WEfgkmhxx8h8a0b
        ZAYrLL8DtnxERw==
X-ME-Sender: <xms:Fr4OX42qRHY59YSXrn7s7DW4zJkDn11VVH8ENaO1z3d_Cx5Aej0G4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Fr4OXzFoadT5k8wMdne6Y5dWZNR-Xz9AhwuTMUlknWVnV08OPUGzKA>
    <xmx:Fr4OXw67CaegodaWtmKwXd_MvS2Narof_8ixLwKF7WSC37nc-LR8vw>
    <xmx:Fr4OXx2l_rbazlbE5JgKqppcb8-QJWkuz3IvYeVXFT2Q2ON94BkhEg>
    <xmx:Fr4OXwQSV9QMnHJa9rCQoIHhAAdhTttgjZ9b_bMHTgrtZJTF__RHhA>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 209D43280064;
        Wed, 15 Jul 2020 04:28:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/11] mlxsw: resources: Add resource identifier for global policers
Date:   Wed, 15 Jul 2020 11:27:24 +0300
Message-Id: <20200715082733.429610-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add a resource identifier for maximum global policers so that it could
be later used to query the information from firmware.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index d62496ef299c..a56c9e19a390 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -47,6 +47,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_ACL_ERPT_ENTRIES_8KB,
 	MLXSW_RES_ID_ACL_ERPT_ENTRIES_12KB,
 	MLXSW_RES_ID_ACL_MAX_BF_LOG,
+	MLXSW_RES_ID_MAX_GLOBAL_POLICERS,
 	MLXSW_RES_ID_MAX_CPU_POLICERS,
 	MLXSW_RES_ID_MAX_VRS,
 	MLXSW_RES_ID_MAX_RIFS,
@@ -105,6 +106,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_ACL_ERPT_ENTRIES_8KB] = 0x2952,
 	[MLXSW_RES_ID_ACL_ERPT_ENTRIES_12KB] = 0x2953,
 	[MLXSW_RES_ID_ACL_MAX_BF_LOG] = 0x2960,
+	[MLXSW_RES_ID_MAX_GLOBAL_POLICERS] = 0x2A10,
 	[MLXSW_RES_ID_MAX_CPU_POLICERS] = 0x2A13,
 	[MLXSW_RES_ID_MAX_VRS] = 0x2C01,
 	[MLXSW_RES_ID_MAX_RIFS] = 0x2C02,
-- 
2.26.2

