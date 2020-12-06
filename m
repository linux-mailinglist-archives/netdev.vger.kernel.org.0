Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC11B2D019D
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgLFIYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:04 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34603 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B1A0FC8B;
        Sun,  6 Dec 2020 03:22:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Dec 2020 03:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=K9XUF9tvL2J/6CekBRLwOCgdvtbPn4LaPC+Z0hFjZ54=; b=ojcYCj+3
        GZDcZlDfQa/bteOveSenxg4dEfA8ILR5peWMrypCsOslemwEpNDx1oOmrEsShmoE
        l0QUfF4h8DVEd1Cs/EQhs8vItJXnab1HsQ663UXyo01Ek9QsVv2eTVWRN7nNHtXD
        Q8daUGeVn9KC/XFAmfhOBlF/kv4v2Z6WDY8EQcvmvXnal8KcTX1HRhhGRs1B0r7R
        wT7jS9Lv5rruMbPSZ+t5miUG4IzHL/wgpzj39jTVbTJPFw53GcthqIZoDcPohDkV
        cA0NbRhfsZhvGayMIU4UV3tevvuqudCVVwEksl8CfxxLAwx+57/a+hLN3eoFVgSk
        owdHnmdM0TFJ2Q==
X-ME-Sender: <xms:4ZTMXwZIBJM4cclXRd9ATt4t7PNUhBlW6v1iEYsfOoE0M_5GDo6h4Q>
    <xme:4ZTMX26hIq6ppYWmkyBmSBxPRKY5p2886VPlxkEmP_H2MdGCk9s3_O4y7-HxWcviu
    if5RnJQi-L-wFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4ZTMXxa60PwuQjF8vAzS8GA6p2XbEokd9N_A4FZhOLEmK99fUsQTCQ>
    <xmx:4ZTMX1i8bAH3ReDgc6mcLD4CkIqQgzd-13g-m8-hKi-nXvdutppPPw>
    <xmx:4ZTMXy-bn0FcW1HiE_GZa-2znFEQWkbWis94uoBUV5CK1f1PpJAm7w>
    <xmx:4ZTMXxuFfZsXV5EPFV7MtICL5HEuNatA5ZBS_eSW0x74Yfu4OZyjjg>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AE31108005B;
        Sun,  6 Dec 2020 03:22:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] mlxsw: spectrum_mr: Use flexible-array member instead of zero-length array
Date:   Sun,  6 Dec 2020 10:22:24 +0200
Message-Id: <20201206082227.1857042-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Suppresses the following coccinelle warning:

drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c:18:15-19: WARNING use flexible-array member instead

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 47eb751a2570..7846a21555ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -15,7 +15,7 @@ struct mlxsw_sp_mr {
 	struct list_head table_list;
 	struct mutex table_list_lock; /* Protects table_list */
 #define MLXSW_SP_MR_ROUTES_COUNTER_UPDATE_INTERVAL 5000 /* ms */
-	unsigned long priv[0];
+	unsigned long priv[];
 	/* priv has to be always the last item */
 };
 
-- 
2.28.0

