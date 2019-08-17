Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A7F91093
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfHQNbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:31:03 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44451 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfHQNbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:31:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 606E62121;
        Sat, 17 Aug 2019 09:31:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YR8XboF4AOWUDw/CRQY65tZ75Ku9nOdQg+FkSPBs0Tk=; b=H/M2sMf4
        gkKY8MVjv8R6dEF3brtc0XZLMEiRqXBblB3RMQEdPwmxEKEQOnMUFeGIwLDeTSfG
        9LoB6JhA6G+W/LeYfteXjFszMQYLLnvskba/ktwrZuK1tECULs6Mjyye2pLFcASj
        Xb6vOjIbEKZfvuR8WS+J6XCwFmOF+Vm5WziK8jzbUXe1RNmzWuQuw4hHNlVTiS2f
        XO0Aa1oAn+zBmIKHDbJ0Jl+xVBRHr8YUDWXFXvCtSuW547DJ+tBJbZXRXCNliPcm
        8zsZfXiHFm/py0S/9w+8UG2W/u6m0A7QH99Xq00OY7ob5T3aJ+KKxK8lEtjg5Tnn
        CAL0iiH8g5L8xg==
X-ME-Sender: <xms:lgFYXaBTUmcgvmS5GWpnZMnn7nxQUT8_f1KVWbnlq7aL6026qFjwJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddu
X-ME-Proxy: <xmx:lgFYXeKSkZLJno7GBKmFvlucHRgtXkXvxoyuAD3aYbmNAxCbiR5ygQ>
    <xmx:lgFYXaRpDiZz7NMg684IrCTerL9XMLCxKZwHR0GeUUFv7zZYyUNTbA>
    <xmx:lgFYXaQSbQVOdnQnpO7p-AupYczx4eJK7nuAgpNWssO-6OzNv6YA-Q>
    <xmx:lgFYXdQ5XhmX4lpcPQ3t_w67tQuE-SKawnW_NHpal14XdgIQIEi03w>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5FB4C80059;
        Sat, 17 Aug 2019 09:30:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 13/16] selftests: forwarding: devlink_lib: Allow tests to define devlink device
Date:   Sat, 17 Aug 2019 16:28:22 +0300
Message-Id: <20190817132825.29790-14-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

For tests that create their network interfaces dynamically or do not use
interfaces at all (as with netdevsim) it is useful to define their own
devlink device instead of deriving it from the first network interface.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 8553a67a2322..2b9296f6aa07 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -4,19 +4,21 @@
 ##############################################################################
 # Defines
 
-DEVLINK_DEV=$(devlink port show "${NETIFS[p1]}" -j \
-		     | jq -r '.port | keys[]' | cut -d/ -f-2)
-if [ -z "$DEVLINK_DEV" ]; then
-	echo "SKIP: ${NETIFS[p1]} has no devlink device registered for it"
-	exit 1
-fi
-if [[ "$(echo $DEVLINK_DEV | grep -c pci)" -eq 0 ]]; then
-	echo "SKIP: devlink device's bus is not PCI"
-	exit 1
-fi
+if [[ ! -v DEVLINK_DEV ]]; then
+	DEVLINK_DEV=$(devlink port show "${NETIFS[p1]}" -j \
+			     | jq -r '.port | keys[]' | cut -d/ -f-2)
+	if [ -z "$DEVLINK_DEV" ]; then
+		echo "SKIP: ${NETIFS[p1]} has no devlink device registered for it"
+		exit 1
+	fi
+	if [[ "$(echo $DEVLINK_DEV | grep -c pci)" -eq 0 ]]; then
+		echo "SKIP: devlink device's bus is not PCI"
+		exit 1
+	fi
 
-DEVLINK_VIDDID=$(lspci -s $(echo $DEVLINK_DEV | cut -d"/" -f2) \
-		 -n | cut -d" " -f3)
+	DEVLINK_VIDDID=$(lspci -s $(echo $DEVLINK_DEV | cut -d"/" -f2) \
+			 -n | cut -d" " -f3)
+fi
 
 ##############################################################################
 # Sanity checks
-- 
2.21.0

