Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E43464955
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347889AbhLAIRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:17:00 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57947 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347809AbhLAIQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:52 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A25EC5C01E1;
        Wed,  1 Dec 2021 03:13:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 01 Dec 2021 03:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FM5rLV/E4gQgOWwyG/NDyaOlZc9DqdbwkqcAM80NCKM=; b=KPyadZVl
        +6VhDpJ7IomwDX4btXidKBGd6WmYosgE/pJmZNLwjt2Mm5CYeToR5NHJqSMFrmE7
        0IHWNNaVEmlq228Wy5qRqFPprToL3N223mY2zMOdEZF3KBhgJ9B1gOE92+u9QH+1
        dydSZ5Zsbys7Og2nQ9BAMzUFfGDZ7sDLUoj8vfVYEb16EL9TRubR+X9I7qodCdFd
        kApCiplARuTv1Xkwq1I0pS0/6L9iTTb7ZjsiBRNEPiUgNOehlw7GWptWOx1hMWte
        4SqKh/ysMVq8H6hem+ucJ3GJbOmo74RzZS/fcuurhIBHpm7mjOPsGOi0yvSKKlIr
        OMmVCrlSQKmHnQ==
X-ME-Sender: <xms:qy6nYUuINSFx-q93C61dqTCrhUlj1UWx50rCjQ3KW-iuHiZCNUmrQg>
    <xme:qy6nYReGWDMJFOe6vYN3m12Irv9KJZZPWdKJlkqFn-zdfgyTPVoaJeKzeCYSAtFLo
    QTtOGqiSX14CRQ>
X-ME-Received: <xmr:qy6nYfwZvut9qknTI4gxsh9EyuaDw2-JGqwww8Kbhccy9pXagFBdQNOiNzDGbqyvTSoUWq7lYK55abKyIup7pWdqSaRb1ZaK5u39j69Cp9o-BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qy6nYXPkfOwsJ-Pb095onrcDp5pvAJPsPukWEP-FIVLjAo4ToMvc0A>
    <xmx:qy6nYU9btHbhPRzUm68rA9ctotbvh_l608sdbKBD8ECMubX8Hp2WxA>
    <xmx:qy6nYfV2jsT5o5vNpV1mX4PjFxXhUhfg0TcxT6uGraqNGeSLjRAe6Q>
    <xmx:qy6nYYYoojt8k4v5T7n5mKWvBNC3-240pTCEAUQalYJ1hVDbtIScAQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: reg: Adjust PPCNT register to support local port 255
Date:   Wed,  1 Dec 2021 10:12:36 +0200
Message-Id: <20211201081240.3767366-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Local port 255 has a special meaning in PPCNT register, it is used to
refer to all local ports. This wild card ability is not currently used
by the driver.

Special casing local port 255 in Spectrum-4 systems where it is a valid
port is going to be a problem.

Work around this issue by adding and always setting the 'lp_gl' bit
which instructs the device's firmware to treat this local port like an
ordinary port.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8d4395a2171f..e908abb4b802 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4910,8 +4910,6 @@ MLXSW_ITEM32(reg, ppcnt, swid, 0x00, 24, 8);
 
 /* reg_ppcnt_local_port
  * Local port number.
- * 255 indicates all ports on the device, and is only allowed
- * for Set() operation.
  * Access: Index
  */
 MLXSW_ITEM32_LP(reg, ppcnt, 0x00, 16, 0x00, 12);
@@ -4963,6 +4961,14 @@ MLXSW_ITEM32(reg, ppcnt, grp, 0x00, 0, 6);
  */
 MLXSW_ITEM32(reg, ppcnt, clr, 0x04, 31, 1);
 
+/* reg_ppcnt_lp_gl
+ * Local port global variable.
+ * 0: local_port 255 = all ports of the device.
+ * 1: local_port indicates local port number for all ports.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, ppcnt, lp_gl, 0x04, 30, 1);
+
 /* reg_ppcnt_prio_tc
  * Priority for counter set that support per priority, valid values: 0-7.
  * Traffic class for counter set that support per traffic class,
@@ -5396,6 +5402,7 @@ static inline void mlxsw_reg_ppcnt_pack(char *payload, u8 local_port,
 	mlxsw_reg_ppcnt_pnat_set(payload, 0);
 	mlxsw_reg_ppcnt_grp_set(payload, grp);
 	mlxsw_reg_ppcnt_clr_set(payload, 0);
+	mlxsw_reg_ppcnt_lp_gl_set(payload, 1);
 	mlxsw_reg_ppcnt_prio_tc_set(payload, prio_tc);
 }
 
-- 
2.31.1

