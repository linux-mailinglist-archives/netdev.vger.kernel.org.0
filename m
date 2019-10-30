Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF73E993E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfJ3JfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:35:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59077 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfJ3JfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:35:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0494621EAF;
        Wed, 30 Oct 2019 05:35:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Gk8RA+BKrayVDsXKxOQqJqan7U2g5Qt8f3D+tJr1kJA=; b=QLk+jSqE
        yDs6k50iuNwr2PfvqJACuLYj3zTvbR51ew7UJ48rSD9lrTHAurvThppGJITKmWmj
        VJvCoq5GaEckgjD2RZY8H7L9jmyLZamTXIK/Q0Nyo+s38o6ktQLYDcqpYrwsChvW
        r5Hoz8D2PGIDqvwUlinqDt4GsVG8dtSpep9Citkw01aqzICl5ZH8DU0BGsRlTp8h
        g+o3UqZ4FZaKRqsIGwh1g5tkaxbNOeP2L5W92mrEDxCe2F2AZqvr7kbrsmqvy692
        wILyVThLJrPh5MzVQGFmOCasgNoRz4uX9Av9V5N0R3CvbQUVRQrLMNPVrRWxzEPO
        QFtim5U8sW1eMA==
X-ME-Sender: <xms:S1m5XRCEWQVvqXhe9BQDfXedjWVIYzwXo-Y3uBW7PPT6606l_YaHTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:S1m5XWzo-hm8df9ojA0E-MisO70fu791Gxt44oBIeThc8F5iyvPKCQ>
    <xmx:S1m5XXdFtpgkWcK7RwMsyjAE3__S_8BT_CYMQHQEXgICCsmMRRqyyw>
    <xmx:S1m5XbsFIyPYn_OtKqNn6e18Bfi1EHT31xs8zXtDXhOmWMwAvdtb4g>
    <xmx:S1m5XUssnGY_FxH9mEZVyqJ-Edmc3jBEPUeuzvj5OB8VFA95Xjzu6g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D57AD3060065;
        Wed, 30 Oct 2019 05:35:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 4/4] mlxsw: Enforce firmware version for Spectrum-2
Date:   Wed, 30 Oct 2019 11:34:51 +0200
Message-Id: <20191030093451.26325-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030093451.26325-1-idosch@idosch.org>
References: <20191030093451.26325-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to Spectrum-1, enforce a specific firmware version
for Spectrum-2 so that the driver and firmware are always in sync with
regards to new features.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8a797fad2d56..97be4bc9a02f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -63,6 +63,21 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	"." __stringify(MLXSW_SP1_FWREV_MINOR) \
 	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
 
+#define MLXSW_SP2_FWREV_MAJOR 29
+#define MLXSW_SP2_FWREV_MINOR 2000
+#define MLXSW_SP2_FWREV_SUBMINOR 2308
+
+static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
+	.major = MLXSW_SP2_FWREV_MAJOR,
+	.minor = MLXSW_SP2_FWREV_MINOR,
+	.subminor = MLXSW_SP2_FWREV_SUBMINOR,
+};
+
+#define MLXSW_SP2_FW_FILENAME \
+	"mellanox/mlxsw_spectrum2-" __stringify(MLXSW_SP2_FWREV_MAJOR) \
+	"." __stringify(MLXSW_SP2_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
+
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
@@ -4988,6 +5003,8 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->req_rev = &mlxsw_sp2_fw_rev;
+	mlxsw_sp->fw_filename = MLXSW_SP2_FW_FILENAME;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -6649,3 +6666,4 @@ MODULE_DEVICE_TABLE(pci, mlxsw_sp1_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp2_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp3_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
+MODULE_FIRMWARE(MLXSW_SP2_FW_FILENAME);
-- 
2.21.0

