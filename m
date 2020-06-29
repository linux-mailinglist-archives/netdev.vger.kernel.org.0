Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3803A20E099
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389819AbgF2Urp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:45 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39033 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389814AbgF2Urn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8B5605800BF;
        Mon, 29 Jun 2020 16:47:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mljNvV3oG1DaCe0k46F/gN0Vv4e2dxyPVYyWWVcp/EU=; b=fX1zoSih
        ICQwqIRRLKW5qmRutMHcORBQaQsp9OYnQmZ+V9dJNHfpzL6E/gyaq5vKUsgD464z
        2GO81EzBXiOE+7rU4L7h+DuMJd4+JxFlvjdrlD1rVKy1nms8b/b9QKcXc4s3uL/O
        FTqUo+UKvaHjDqlLA6ph1nxF+6wPHPHP1DscA9TZ7kjc5M+0HuNUGu+miQRmbEL4
        OZmubEBcRT4q5508hUlseFEIka4xg2V/oI8j6AQY5EkTpoSPD83WULrB0JU6u4pp
        IdZOSRW89bM8t0HM1TdpR2l+ieS3JHBA3OrNF6AeupZQr0vMU6mUpoO79FwuybU/
        9Qchw8pP3AkscQ==
X-ME-Sender: <xms:blP6XpSRzXW0Ocx3icXss43rsJXlJRobm44aUKRMvM-N85MYuvU4-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:blP6XiwQuK2Y9C13g2gqeomQiozFqlY36_Labr3SBsSSoZ9A0P4fbg>
    <xmx:blP6Xu3C1l16Tl3VD5CEyMcumCvpcR7jgJ65pRACr4gLrsDsPeue_w>
    <xmx:blP6XhBZ8WTEg6b_kuqgnoow0OVWCZ7C6pYA5aqLriU26uzJy0o8VQ>
    <xmx:blP6XrVAIOxP1I-g0YhtJZmTF4I8nTJUAY8cR_3KDJQME4Rz36K74Q>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D878328005A;
        Mon, 29 Jun 2020 16:47:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/10] selftests: forwarding: ethtool: Move different_speeds_get() to ethtool_lib
Date:   Mon, 29 Jun 2020 23:46:19 +0300
Message-Id: <20200629204621.377239-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Currently different_speeds_get() is used only by ethtool.sh tests.
The function can be useful for another tests that check ethtool
configurations.

Move the function to ethtool_lib in order to allow other tests to use
it.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/net/forwarding/ethtool.sh | 17 -----------------
 .../selftests/net/forwarding/ethtool_lib.sh     | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool.sh b/tools/testing/selftests/net/forwarding/ethtool.sh
index eb8e2a23bbb4..ea7a11a9f788 100755
--- a/tools/testing/selftests/net/forwarding/ethtool.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool.sh
@@ -50,23 +50,6 @@ cleanup()
 	h1_destroy
 }
 
-different_speeds_get()
-{
-	local dev1=$1; shift
-	local dev2=$1; shift
-	local with_mode=$1; shift
-	local adver=$1; shift
-
-	local -a speeds_arr
-
-	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode $adver))
-	if [[ ${#speeds_arr[@]} < 2 ]]; then
-		check_err 1 "cannot check different speeds. There are not enough speeds"
-	fi
-
-	echo ${speeds_arr[0]} ${speeds_arr[1]}
-}
-
 same_speeds_autoneg_off()
 {
 	# Check that when each of the reported speeds is forced, the links come
diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
index 925d229a59d8..9188e624dec0 100644
--- a/tools/testing/selftests/net/forwarding/ethtool_lib.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -67,3 +67,20 @@ common_speeds_get()
 		<(printf '%s\n' "${dev1_speeds[@]}" | sort -u) \
 		<(printf '%s\n' "${dev2_speeds[@]}" | sort -u)
 }
+
+different_speeds_get()
+{
+	local dev1=$1; shift
+	local dev2=$1; shift
+	local with_mode=$1; shift
+	local adver=$1; shift
+
+	local -a speeds_arr
+
+	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode $adver))
+	if [[ ${#speeds_arr[@]} < 2 ]]; then
+		check_err 1 "cannot check different speeds. There are not enough speeds"
+	fi
+
+	echo ${speeds_arr[0]} ${speeds_arr[1]}
+}
-- 
2.26.2

