Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28E71B7A60
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgDXPoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46395 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbgDXPoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0146A5C080A;
        Fri, 24 Apr 2020 11:44:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=h0S9656j/kiOrSznh4T7fFcHJi/L0O0GzfTV82V+STE=; b=s1aPKpC/
        8h+efXIdlDp+oOhwGrM0iQ9/FplXVYIz/sMlA/GlboMWAFxNhgCaFxd13W9dFhFZ
        6gRdyIdVHCSV726mZqroIc4/mSxVHHsg++ysn7WyE8n7j1ZLtBDBcc1ftAqh2pmx
        m2zEyjdwFJLlllmqzQuGTbcm/O73x7BEW6IiXgyYZiTUmxiPHgSDpyeQb8IiFesN
        vYSE6EhZSYE3WTK40ovyd8N8ZeVSaaYqozsHjB7nLjNefaKA6K/pHrh8hAn1x789
        S/y/3FX0hNJ+zzU1O9xF7Q/jFz752WzqMIMRG3bbzR6hqgiJvuLVdxbhpGKWEr1Q
        8acdQ0gPU2UccQ==
X-ME-Sender: <xms:TQmjXlS-J3PVxgvUY6mpV0X0cQo09o_3GjlJy-XeUhw5z5CiuCsrGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:TQmjXlhsu8fHp5NbFfuvkNGXqyeTM9m4n23cMkWoW6VRIVXRO2lyFA>
    <xmx:TQmjXi8m9oTA3LSqXmAP9aIuHFCwpz3dDtPdQbvwH3lDOcuEWPpUKg>
    <xmx:TQmjXt2h7B7uOKNAftaYArfe2tnQEwkgLk4K6qaqDs2ovIQOHwURUg>
    <xmx:TQmjXjVEoSjp0VMXfycIAopuRUpnK2TLaWXA1NK0-6zyQxFKG8wFTQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA9393065DA4;
        Fri, 24 Apr 2020 11:44:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] mlxsw: spectrum_span: Reduce nesting in mlxsw_sp_span_entry_configure()
Date:   Fri, 24 Apr 2020 18:43:41 +0300
Message-Id: <20200424154345.3677009-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424154345.3677009-1-idosch@idosch.org>
References: <20200424154345.3677009-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Use early return to avoid unnecessary nesting.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 29 ++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 9fb2e9d93929..e7be1bfe7f75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -622,18 +622,27 @@ mlxsw_sp_span_entry_configure(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_span_entry *span_entry,
 			      struct mlxsw_sp_span_parms sparms)
 {
-	if (sparms.dest_port) {
-		if (sparms.dest_port->mlxsw_sp != mlxsw_sp) {
-			netdev_err(span_entry->to_dev, "Cannot mirror to %s, which belongs to a different mlxsw instance",
-				   sparms.dest_port->dev->name);
-			sparms.dest_port = NULL;
-		} else if (span_entry->ops->configure(span_entry, sparms)) {
-			netdev_err(span_entry->to_dev, "Failed to offload mirror to %s",
-				   sparms.dest_port->dev->name);
-			sparms.dest_port = NULL;
-		}
+	int err;
+
+	if (!sparms.dest_port)
+		goto set_parms;
+
+	if (sparms.dest_port->mlxsw_sp != mlxsw_sp) {
+		netdev_err(span_entry->to_dev, "Cannot mirror to %s, which belongs to a different mlxsw instance",
+			   sparms.dest_port->dev->name);
+		sparms.dest_port = NULL;
+		goto set_parms;
+	}
+
+	err = span_entry->ops->configure(span_entry, sparms);
+	if (err) {
+		netdev_err(span_entry->to_dev, "Failed to offload mirror to %s",
+			   sparms.dest_port->dev->name);
+		sparms.dest_port = NULL;
+		goto set_parms;
 	}
 
+set_parms:
 	span_entry->parms = sparms;
 }
 
-- 
2.24.1

