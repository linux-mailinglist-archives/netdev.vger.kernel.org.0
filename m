Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA43B0D3
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbfFJIlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:41:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38887 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387979AbfFJIll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:41:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2745A21FAD;
        Mon, 10 Jun 2019 04:41:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 04:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0ef4Asu6naH+Oy56nstKNrHcHOCZKw99rnP/4hUj9WM=; b=wZm5z8y0
        ZfhQJFSw9tOhWOe1g1h2H00omZMav52p6l98LV/xTEJPaciXunDfhT0JnMiSpHip
        /wL5gsS3jGF92umbVYDwUYD/VSpmDcHgvYqwCQheoSTZhEuahjr7urrRvfKM7Sfk
        cTmoJ8Wy0mIfLvJnk15qEEbZk6luKiPk5RF/jDE7ZeI8dzYs9tw7fhMI0iH1Z2Bv
        Ub2PV6TP7eQrASWgrBAFgTH1Yo0LK6r/JttsnybBs82FyhE35nv1Wiqy+ZhVnv5z
        gfCA2B8aHwbzduRq/Zgg2MKvQVRBNhPxGf6WVnVTsthV1e0fKpWkQnDDlC3NnWWz
        rSp1S5ZpqzzJ5A==
X-ME-Sender: <xms:wxf-XBWmsEQvScs1pplvYN4TkOo4RSnmaCfWSlxk5GJ1RZGNlhJ74g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:wxf-XLUsFOV9faXzYaLU8SGt5teawC04ejNkfNbEqX1mJ3BAT5QxcA>
    <xmx:wxf-XKWab2xCFd6Uao_NAcd14byZc-2f5-_fXNmLqye2a5Hxo4kZcA>
    <xmx:wxf-XFQTwTAayiitMR0lO2xevR_YW4Of5ral-QZUK9eAHeQrt1dd0w>
    <xmx:xBf-XLf7Xzq_vEtrqDuPZgcV6CqzKiN7LDM4dqA6-hSukLVTEt41EA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0BEC80063;
        Mon, 10 Jun 2019 04:41:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] selftests: mlxsw: lib.sh: Add wait for dev with timeout
Date:   Mon, 10 Jun 2019 11:40:44 +0300
Message-Id: <20190610084045.6029-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610084045.6029-1-idosch@idosch.org>
References: <20190610084045.6029-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add a function that waits for device with maximum number of iterations.
It enables to limit the waiting and prevent infinite loop.

This will be used by the subsequent patch which will set two ports to
different speeds in order to make sure they cannot negotiate a link.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 28 +++++++++++++++++--
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 9385dc971269..cd362d14d6c6 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -18,6 +18,7 @@ NETIF_CREATE=${NETIF_CREATE:=yes}
 MCD=${MCD:=smcrouted}
 MC_CLI=${MC_CLI:=smcroutectl}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
+WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -226,24 +227,45 @@ log_info()
 setup_wait_dev()
 {
 	local dev=$1; shift
+	local wait_time=${1:-$WAIT_TIME}; shift
 
-	while true; do
+	setup_wait_dev_with_timeout "$dev" 600 $wait_time
+
+	if (($?)); then
+		check_err 1
+		log_test setup_wait_dev ": Interface $dev does not come up."
+		exit 0
+	fi
+}
+
+setup_wait_dev_with_timeout()
+{
+	local dev=$1; shift
+	local max_iterations=${1:-$WAIT_TIMEOUT}; shift
+	local wait_time=${1:-$WAIT_TIME}; shift
+	local i
+
+	for ((i = 1; i <= $max_iterations; ++i)); do
 		ip link show dev $dev up \
 			| grep 'state UP' &> /dev/null
 		if [[ $? -ne 0 ]]; then
 			sleep 1
 		else
-			break
+			sleep $wait_time
+			return 0
 		fi
 	done
+
+	return 1
 }
 
 setup_wait()
 {
 	local num_netifs=${1:-$NUM_NETIFS}
+	local i
 
 	for ((i = 1; i <= num_netifs; ++i)); do
-		setup_wait_dev ${NETIFS[p$i]}
+		setup_wait_dev ${NETIFS[p$i]} 0
 	done
 
 	# Make sure links are ready.
-- 
2.20.1

