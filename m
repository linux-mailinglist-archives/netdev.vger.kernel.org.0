Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B925C3DE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgICO75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:59:57 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47471 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728877AbgICOGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:06:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9660F580571;
        Thu,  3 Sep 2020 09:42:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 03 Sep 2020 09:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nsL9vwsAlYQbc2fPQQk4f0FA2ka9eiIMrA/dba1uV4c=; b=mIg2ZoQR
        OYjgGU/mibRm5DFZX4tagD6aXGPX4Duu4vvvKH/uyIjzfLVsKu9ijdGDnoTKLRhJ
        DFGXM9sS2oZIT9nnHftjDgHkE7oP5w8vOPrzL+xLop9bpSdC+jquO2+oNeb5Qoha
        /GX+zZzj0Q6h8cTmMOG5mgBlgDH/6fX5i7CNrdrSI0r5EZNojcx0vG/KC1rF4YJR
        df2fpC7GCeGbxTiZaYAIF+9c4/zV6knqxnCfZQqvh+BsDdup4CYsKjKayhurReVc
        TxljxBnTanIZMhRXBRopaB/cbyWqPy3wOLucfg6yD0QqTKJ4MHKw/an0gYGhBl9E
        6jmtQ/50KOdCxQ==
X-ME-Sender: <xms:xvJQX6Dv-nXu92AcuIjpCa-zBq7v7RDy_HpwFCYLUEOUop5HMT_YFg>
    <xme:xvJQX0jjl566NrLrsI3IS-bpsGQ2AdhlinqARsEwkSxalUp_r4krx_Au8xaOnTRyW
    jyJvP2Zzw0FrLc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeguddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucfkphepkeegrddvvdelrdefiedrjedunecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xvJQX9nNnupKjDl-BlyJwdzruZ3wWLiHRFZJDVsd_fPgGBB5ot81Ug>
    <xmx:xvJQX4wHfsllvtpwq6k-FZ7HLu_EJLo4O-5FiBm5ges-EHqFbtiiSg>
    <xmx:xvJQX_TCxJ5aMlqN82Fqk6wUVM_ejp1tX60U_rRUgwS0mZI25ixI7A>
    <xmx:xvJQX4TPYGOKTJjsRTOpSCwgREsKNdJndJu0EyWm8ZohrMFxpXMdyA>
Received: from shredder.mtl.com (igld-84-229-36-71.inter.net.il [84.229.36.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CA1B3280060;
        Thu,  3 Sep 2020 09:42:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, vadimp@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: core_hwmon: Calculate MLXSW_HWMON_ATTR_COUNT more accurately
Date:   Thu,  3 Sep 2020 16:41:45 +0300
Message-Id: <20200903134146.2166437-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903134146.2166437-1-idosch@idosch.org>
References: <20200903134146.2166437-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Currently the value of MLXSW_HWMON_ATTR_COUNT is calculated not really
accurate.

Add several defines to make the calculation clearer and easier to
change.

Calculate the precise high bound of number of attributes that may be
needed.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 3f1822535bc6..f1b0c176eaeb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -12,8 +12,17 @@
 #include "core.h"
 #include "core_env.h"
 
-#define MLXSW_HWMON_TEMP_SENSOR_MAX_COUNT 127
-#define MLXSW_HWMON_ATTR_COUNT (MLXSW_HWMON_TEMP_SENSOR_MAX_COUNT * 4 + \
+#define MLXSW_HWMON_SENSORS_MAX_COUNT 64
+#define MLXSW_HWMON_MODULES_MAX_COUNT 64
+#define MLXSW_HWMON_GEARBOXES_MAX_COUNT 32
+
+#define MLXSW_HWMON_ATTR_PER_SENSOR 3
+#define MLXSW_HWMON_ATTR_PER_MODULE 5
+#define MLXSW_HWMON_ATTR_PER_GEARBOX 4
+
+#define MLXSW_HWMON_ATTR_COUNT (MLXSW_HWMON_SENSORS_MAX_COUNT * MLXSW_HWMON_ATTR_PER_SENSOR + \
+				MLXSW_HWMON_MODULES_MAX_COUNT * MLXSW_HWMON_ATTR_PER_MODULE + \
+				MLXSW_HWMON_GEARBOXES_MAX_COUNT * MLXSW_HWMON_ATTR_PER_GEARBOX + \
 				MLXSW_MFCR_TACHOS_MAX + MLXSW_MFCR_PWMS_MAX)
 
 struct mlxsw_hwmon_attr {
-- 
2.26.2

