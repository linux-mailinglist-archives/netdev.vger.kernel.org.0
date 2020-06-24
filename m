Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2738206EE4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390416AbgFXIUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:49 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49975 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390408AbgFXIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4C33A580519;
        Wed, 24 Jun 2020 04:20:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mljNvV3oG1DaCe0k46F/gN0Vv4e2dxyPVYyWWVcp/EU=; b=U9Wpa2rP
        IahlsbllQyHO8uFb883O0vE5ecHRALXCcoNmCzoi8UY1WiawUxkTfC1PF4Qy17E8
        K9V3MwaWxh/fNCzpR60irRWgeRh9ypy6XYMmuY9B14sJoA0t47KlyMLESjUx1YH+
        lRsMYHAo3F8piqIvVAXJ8uSz80ky2h4ZgjJJuuJiD1cofChYH0cMBLVarErhsvOJ
        QQag8SzjSfyf9q3cYgJdDw8RAG1v3DyRb617b9wpmdsiFncdS5+4JKo7XUPb+o3Q
        viCuinbNGHj23+gWfmeOwZC1/Ie/Q7rnxUU4zrTr8w3xCqNE9fdTVU56DJQr4hUn
        S+/umJZzQM+MVA==
X-ME-Sender: <xms:2gzzXkqIXFhI68N7bZu9DO1P-3K3XwJa1NfGW2ysd4Lkt2DRfDlHSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2gzzXqqfBtq8V6OBNldxTgR0x5epyHzX-F5Is888G5aWdgkKj9avFg>
    <xmx:2gzzXpMPXVwexGJq8eFIjyVy4X9oMfLsaQyLHMRRNX1NWIdw8zo6GQ>
    <xmx:2gzzXr4fBQoLbUmPTYyhimt7a6OI70hncvNqmh0Vu-zycnmEVjukyg>
    <xmx:2gzzXtsCC5QPcpJcKBZvHwvlCVzD7C5LRdJf1h2zXsGwRs41pjV9SQ>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E02530675F9;
        Wed, 24 Jun 2020 04:20:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/10] selftests: forwarding: ethtool: Move different_speeds_get() to ethtool_lib
Date:   Wed, 24 Jun 2020 11:19:21 +0300
Message-Id: <20200624081923.89483-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
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

