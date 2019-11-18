Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730C0FFFC8
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfKRHuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43415 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbfKRHuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5DFEE22431;
        Mon, 18 Nov 2019 02:50:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=uCgYK7YxlBIYOmQhHxKR5hq/WLBplvB2/Ty39D5aFUs=; b=d/hTZs/y
        S1YnX6wYQvr7QLux1t0iH4CcfS2JckLZtC7NiJEiHp1kBNDHDppGyDunv3zz8STp
        p+CKyIxRtaI3zvrP12/3rDUE1UMMRCMGk6GN+2L2AxxBRotIErjM0ZRgaOoHqIRr
        SIExfaJYjSEXpiiY+pLnQZM3vfiwLL5rsYmrONhii9ol78tnFyTTza/tZkSKYdfd
        /sdiqYJpBHUubyqPJjoNoFZCQwQ1uHAOW9tO32DmdpJcWYnGMcUwZgaDxfhTR8Jx
        esw6UfrbaL9Z361JnAmB509510e+HtPmJ0WjnrJ7A2auSJ4Dh+S22lz0OSnlibv9
        o+AOkXzwVn/6Rw==
X-ME-Sender: <xms:Tk3SXZd3hyDyWMIfBdCSj07zFONDdMUn8kZPhLuXTFUx1qigit_qkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Tk3SXbeKeGF8PA7dDuWG9hMfY3vQwxoUrS8WcwR-Q1hfQMJfmmWxIw>
    <xmx:Tk3SXdhmUiEoj96D5UIAj1Uq-Ic-DE3GvIgoGkY27rfQZXmkJzH7Mw>
    <xmx:Tk3SXXTjmmagxDH5HbLYE9m1dWxEqVGZWWybEKfNHzwgwReCyn2Mmw>
    <xmx:Tk3SXRtIMQelVYYxYg3yi5Ublipy3tflItHtSUKjxhqkcPUsNeZfvg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC99E3060060;
        Mon, 18 Nov 2019 02:50:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] selftests: forwarding: Add ethtool_lib.sh
Date:   Mon, 18 Nov 2019 09:50:00 +0200
Message-Id: <20191118075002.1699-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Functions:
1. speeds_arr_get
	The function returns an array of speed values from
        /usr/include/linux/ethtool.h The array looks as follows:
	[10baseT/Half] = 0,
	[10baseT/Full] = 1,
	...

2. ethtool_set:
	params: cmd
	The function runs ethtool by cmd (ethtool -s cmd) and checks if
	there was an error in configuration

3. dev_speeds_get:
	params: dev, with_mode (0 or 1), adver (0 or 1)
	return value: Array of supported/Advertised link modes
	with/without mode

	* Example 1:
	speeds_get swp1 0 0
	return: 1000 10000 40000
	* Example 2:
	speeds_get swp1 1 1
	return: 1000baseKX/Full 10000baseKR/Full 40000baseCR4/Full

4. common_speeds_get:
	params: dev1, dev2, with_mode (0 or 1), adver (0 or 1)
	return value: Array of common speeds of dev1 and dev2

	* Example:
	common_speeds_get swp1 swp2 0 0
	return: 1000 10000
	Assuming that swp1 supports 1000 10000 40000 and swp2 supports
	1000 10000

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/ethtool_lib.sh   | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
new file mode 100755
index 000000000000..925d229a59d8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -0,0 +1,69 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+speeds_arr_get()
+{
+	cmd='/ETHTOOL_LINK_MODE_[^[:space:]]*_BIT[[:space:]]+=[[:space:]]+/ \
+		{sub(/,$/, "") \
+		sub(/ETHTOOL_LINK_MODE_/,"") \
+		sub(/_BIT/,"") \
+		sub(/_Full/,"/Full") \
+		sub(/_Half/,"/Half");\
+		print "["$1"]="$3}'
+
+	awk "${cmd}" /usr/include/linux/ethtool.h
+}
+
+ethtool_set()
+{
+	local cmd="$@"
+	local out=$(ethtool -s $cmd 2>&1 | wc -l)
+
+	check_err $out "error in configuration. $cmd"
+}
+
+dev_speeds_get()
+{
+	local dev=$1; shift
+	local with_mode=$1; shift
+	local adver=$1; shift
+	local speeds_str
+
+	if (($adver)); then
+		mode="Advertised link modes"
+	else
+		mode="Supported link modes"
+	fi
+
+	speeds_str=$(ethtool "$dev" | \
+		# Snip everything before the link modes section.
+		sed -n '/'"$mode"':/,$p' | \
+		# Quit processing the rest at the start of the next section.
+		# When checking, skip the header of this section (hence the 2,).
+		sed -n '2,${/^[\t][^ \t]/q};p' | \
+		# Drop the section header of the current section.
+		cut -d':' -f2)
+
+	local -a speeds_arr=($speeds_str)
+	if [[ $with_mode -eq 0 ]]; then
+		for ((i=0; i<${#speeds_arr[@]}; i++)); do
+			speeds_arr[$i]=${speeds_arr[$i]%base*}
+		done
+	fi
+	echo ${speeds_arr[@]}
+}
+
+common_speeds_get()
+{
+	dev1=$1; shift
+	dev2=$1; shift
+	with_mode=$1; shift
+	adver=$1; shift
+
+	local -a dev1_speeds=($(dev_speeds_get $dev1 $with_mode $adver))
+	local -a dev2_speeds=($(dev_speeds_get $dev2 $with_mode $adver))
+
+	comm -12 \
+		<(printf '%s\n' "${dev1_speeds[@]}" | sort -u) \
+		<(printf '%s\n' "${dev2_speeds[@]}" | sort -u)
+}
-- 
2.21.0

