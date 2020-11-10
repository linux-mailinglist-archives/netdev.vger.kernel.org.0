Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9012AD2CA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbgKJJue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:34 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58379 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730209AbgKJJu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 3D059367;
        Tue, 10 Nov 2020 04:50:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WX8TTHzfn7/3Du+CegiBZNCEhgUtAn42m3f7rwrvKto=; b=dnbES88h
        3WdLpViaV5msR8rb15znrDhTj94I2492wXeUlBXWherqKoFQEEVm5KvtOQ6f1q0Z
        59K4AWxeKw+nMKk3Jw0cS5nBUc52aDOkEknO1ESfmZwGqAWWo2MRb8sM3oc2Pepu
        JD3D7QuhwT+94L/PxrL68UkF5qnvt6uect3ZxgVDR0tIx+3HbBe2lqhIR9QereiE
        79j/yeauH9PimvgqMPbOZHoDdDXqW6+eOddSQR5qnewF5DTwf5JQ3udW4whPK63R
        KDXc64i/Iw0vIpsilSs8vJBICdSzttuJbl/1aupVP6LFeLcx0F6vfRZ3cbXeOIYc
        Ndn7UHqbfIp3tA==
X-ME-Sender: <xms:Y2KqX-VRGEI41TrVuHff6_IAvHliuBwvS3wrtFuEubm0p84_bBalcg>
    <xme:Y2KqX6m4AFtccVR-MtPsaQukZuSgw5-gEaB7wMDKTxWivQFecAqfgy924AiF34e85
    iXCPNZzBqbWv9I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Y2KqXybOYiaNr6ppuUU4vTQZnG8Lph_A6mC3mmM2yY3-sOAh8D3gUQ>
    <xmx:Y2KqX1VWM2FMvb05vJYOmf2vYtTxbV8nMO6xC-AgQRLvhot8P3WVnA>
    <xmx:Y2KqX4nkCwuyueF_ddYgryu7CsB4AF__ousVikjC6ZiQ4HUoKOlNtg>
    <xmx:Y2KqX9yZEaviRpEowg3QBR_Upu0s3WIDHosk2c2r9EHRWupMU5ukdg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id A900C3280066;
        Tue, 10 Nov 2020 04:50:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/15] mlxsw: reg: Allow to pass NULL pointer to mlxsw_reg_ralue_pack4/6()
Date:   Tue, 10 Nov 2020 11:48:53 +0200
Message-Id: <20201110094900.1920158-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In preparation for the change that is going to be done in the next
patch, allow to pass NULL pointer to mlxsw_reg_ralue_pack4() and
mlxsw_reg_ralue_pack6() helpers.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0da9f7e1eb9b..fcf9095b3f55 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -7282,7 +7282,8 @@ static inline void mlxsw_reg_ralue_pack4(char *payload,
 					 u32 *dip)
 {
 	mlxsw_reg_ralue_pack(payload, protocol, op, virtual_router, prefix_len);
-	mlxsw_reg_ralue_dip4_set(payload, *dip);
+	if (dip)
+		mlxsw_reg_ralue_dip4_set(payload, *dip);
 }
 
 static inline void mlxsw_reg_ralue_pack6(char *payload,
@@ -7292,7 +7293,8 @@ static inline void mlxsw_reg_ralue_pack6(char *payload,
 					 const void *dip)
 {
 	mlxsw_reg_ralue_pack(payload, protocol, op, virtual_router, prefix_len);
-	mlxsw_reg_ralue_dip6_memcpy_to(payload, dip);
+	if (dip)
+		mlxsw_reg_ralue_dip6_memcpy_to(payload, dip);
 }
 
 static inline void
-- 
2.26.2

