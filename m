Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7605D189D4C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCRNtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49485 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbgCRNtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A4F15C019D;
        Wed, 18 Mar 2020 09:49:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8Yq4G1GzPhZ3obUK1Buvjx4n8YQ4EMuPZUCX9hlvIXo=; b=gw9ukIuu
        JqSi5bI7FZD8fg2FY/tIU9bA8uXXa7unTvvjWew/emf2KesXlpnR9eAjrEvM1yVQ
        ojctQ3EHnL2z+JUzRQtn9c/d0rVWmMW/Cmh4GCN5yleAPGR/kVkCPoxZUzI/L8VH
        4MSo+vPDTGqT4IQuGZdylNBN2CNkYnU6VLWv8ov0tV7dkxcJ3NlrSx2aK3czwKTh
        432oFWIXQ2bw0EYyvT9i5bHs5FrWgevwcrnKF2LzROQYrf3wdwP2UwSSPijc6pXK
        ev6Pla/SuvR86WabS1zKKTXzv+R7ErIphskjG+lZbCjK8sfH4FN2GgbLYOhTUXrU
        /d+vdiBl61eayA==
X-ME-Sender: <xms:9yZyXv1gOfRMgyYpFy9zwIh1I_81797tB2fwSwaeLOamdISRfoNggQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:9yZyXuVObyO1dxjUHz7gtodEBhk4qh7I4MVGLrSXsflPxV8zkNZ7Cw>
    <xmx:9yZyXowIkeKT3vmv6oBV-pADnNiaPpeFJ5sfIsAWwzFLK7DeRN2jbQ>
    <xmx:9yZyXotQ7EAKAPmbO9P_NVnsytRYhv7f3KuiL9uPGxub4xIEqRYo5g>
    <xmx:-CZyXiF_rUN5HXkg_g87M2IZsRbKHi_wZ3pI7hvpOeOgq1fZW7I0fQ>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA0FE30624CC;
        Wed, 18 Mar 2020 09:49:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] selftests: spectrum-2: Adjust tc_flower_scale limit according to current counter count
Date:   Wed, 18 Mar 2020 15:48:50 +0200
Message-Id: <20200318134857.1003018-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

With the change that made the code to query counter bank size from device
instead of using hard-coded value, the number of available counters
changed for Spectrum-2. Adjust the limit in the selftests.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
index a0795227216e..efd798a85931 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
@@ -8,9 +8,9 @@ tc_flower_get_target()
 	# The driver associates a counter with each tc filter, which means the
 	# number of supported filters is bounded by the number of available
 	# counters.
-	# Currently, the driver supports 12K (12,288) flow counters and six of
+	# Currently, the driver supports 30K (30,720) flow counters and six of
 	# these are used for multicast routing.
-	local target=12282
+	local target=30714
 
 	if ((! should_fail)); then
 		echo $target
-- 
2.24.1

