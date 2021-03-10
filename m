Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27145333AFE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhCJLEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:04:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33025 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232715AbhCJLDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B30FF5C00B2;
        Wed, 10 Mar 2021 06:03:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5duoNmiHFaIQUxOTkI8LME87DnZUjHvafM41SYInvNk=; b=loXuoyMn
        kjr/0/dZlHszqfeYuCR9Fh6Kok9Emc/b6vPG7NSZd/ozmOZaTYTlvzWN8zP2j3ft
        ycdLsI5R9raGSsI1UDmLWhfEZzi4GKRyrL9Ql9gzXmLKityFAzR65EvXEU6zs7aQ
        u3pbYd5TT4NV21w8i+04aFnscsVX4f6zGZAErF7GdFOpDa3wyGFet0EOPFlDIG4d
        vpCDldYal4dcCSQJAkphpYqb9vC3j+RM/TEOvLNW110wgrFfvwLPm3xFN5kMdKPo
        K5mer/CUXwtKrBuagLAq7OxAvEKdeko0KaH+OOAFxNLYlLnvGD8vzF3zvXUQ/I9G
        HClaQSgGkgG1Rg==
X-ME-Sender: <xms:kadIYFQDhJOhO30eektfSxvRD1Dv7F-bRofDflSMRPsd30gB16di-g>
    <xme:kadIYOz-mJvWF2p7oJHrcKHi3v-tK3CYf6xTDNBSiX4m5Y_omXQXTFZx6aW3WHdrv
    5Pa9n0yAovaMis>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kadIYK3qHFav44tDagi5liO8DIcrnIhBg-JFojGV3Fak79FUeq4GFw>
    <xmx:kadIYNDFhkeyi-2QzdPcU55TnaxYi8qHqT4KMRCQbuexpzhyRjOUTQ>
    <xmx:kadIYOjdHoKvkxHmKVU3jS466ohKv5M1WMTtrhadEp8GQ_o4qFYggg>
    <xmx:kadIYAZOnPAvdNEAz3wdvGD7DderoXfVu8i8EnhAQf3LqqPW4WgW1A>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7E5C1080066;
        Wed, 10 Mar 2021 06:03:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: Adjust some MFDE fields shift and size to fw implementation
Date:   Wed, 10 Mar 2021 13:02:20 +0200
Message-Id: <20210310110220.2534350-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

MFDE.irisc_id and MFDE.event_id were adjusted according to what is
actually implemented in firmware.

Adjust the shift and size of these fields in mlxsw as well.

Note that the displacement of the first field is not a regression.
It was always incorrect and therefore reported "0".

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index c53461ac4e10..7e9a7cb31720 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1728,7 +1728,7 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 		return err;
 
 	event_id = mlxsw_reg_mfde_event_id_get(mfde_pl);
-	err = devlink_fmsg_u8_pair_put(fmsg, "id", event_id);
+	err = devlink_fmsg_u32_pair_put(fmsg, "id", event_id);
 	if (err)
 		return err;
 	switch (event_id) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index a042ff79d306..2f7f691f85ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10919,7 +10919,7 @@ MLXSW_REG_DEFINE(mfde, MLXSW_REG_MFDE_ID, MLXSW_REG_MFDE_LEN);
  * Which irisc triggered the event
  * Access: RO
  */
-MLXSW_ITEM32(reg, mfde, irisc_id, 0x00, 8, 4);
+MLXSW_ITEM32(reg, mfde, irisc_id, 0x00, 24, 8);
 
 enum mlxsw_reg_mfde_event_id {
 	MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO = 1,
@@ -10930,7 +10930,7 @@ enum mlxsw_reg_mfde_event_id {
 /* reg_mfde_event_id
  * Access: RO
  */
-MLXSW_ITEM32(reg, mfde, event_id, 0x00, 0, 8);
+MLXSW_ITEM32(reg, mfde, event_id, 0x00, 0, 16);
 
 enum mlxsw_reg_mfde_method {
 	MLXSW_REG_MFDE_METHOD_QUERY,
-- 
2.29.2

