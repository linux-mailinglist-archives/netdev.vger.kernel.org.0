Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79629333AFC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhCJLD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:03:59 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42513 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231880AbhCJLDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5DC525C00BC;
        Wed, 10 Mar 2021 06:03:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=cEV5GKyJYzccFaweFLMIG69m0/23IbCO0gEDhMvSFxk=; b=NJCqV7b6
        fMCgANWR2MOagKDU7DLOwIqWOe83SaDa+TCFKYKTP0w40lTtW05byQH1anpgvJjo
        XA1NSHjJ8fIKz8LCqAhp+gsLeOlkjBvrHlQ/tGK3cDV6nAemLhFUGt8/AMA7JSwM
        h4fy5wBXYpnCRlFL4GT+0F9+UtDe1G7sGe8unBtudbu44m2I6MYxTed05geeDUwp
        26slkb6JpYvF7HZDXy9QF2I57vur7CkwQbGbz6gJCS0RelxuObV20ImRxRHAvPqI
        BpHgn7tWtVqclKjI16+3LBr1B9sGGKsKm+J/E7u14vq1b2iPe9agHuNUBtN6wzaE
        v0x0hNZsbp1cNw==
X-ME-Sender: <xms:jadIYAZOxRED57Vrz-s9GT-wZmBzTsmTus3zr6u9qOXiioamOzicrw>
    <xme:jadIYLa4mT4v8bsh-Px_13HmWI0lfO7stLXM3t4DqLu7Pz9pKLnnxaDDnddF3GovU
    sdHQvaXI7ckxRc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jadIYK-Bj9Ynj0Wf6qlUSff5B5xfa721erAlGhd6XpaWeHY4e1DHxw>
    <xmx:jadIYKrd1N1tn0FJOa0bnRh1AtB2KdF-FqY_ug7QD14sP8rn-t879A>
    <xmx:jadIYLrhxLNr262sp2Wzii0v6eWF9MkS5sDwPpy9l4N5peDls4uI9Q>
    <xmx:jadIYMD-nxAneDkqTbPepQOhSYzseNoyjn8W1pi4jsCwFqdI7WZ2mQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D33B1080059;
        Wed, 10 Mar 2021 06:03:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: reg: Extend MFDE register with new log_ip field
Date:   Wed, 10 Mar 2021 13:02:18 +0200
Message-Id: <20210310110220.2534350-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Extend MFDE (Monitoring FW Debug) register with new field specifying the
instruction pointer that triggered the CR space timeout.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index afd42907092f..a042ff79d306 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10979,6 +10979,13 @@ MLXSW_ITEM32(reg, mfde, log_address, 0x10, 0, 32);
  */
 MLXSW_ITEM32(reg, mfde, log_id, 0x14, 0, 4);
 
+/* reg_mfde_log_ip
+ * IP (instruction pointer) that triggered the timeout.
+ * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, mfde, log_ip, 0x18, 0, 64);
+
 /* reg_mfde_pipes_mask
  * Bit per kvh pipe.
  * Access: RO
-- 
2.29.2

