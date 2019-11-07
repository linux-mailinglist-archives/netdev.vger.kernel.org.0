Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487BBF34DF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfKGQnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:33 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44791 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389651AbfKGQn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E47221B55;
        Thu,  7 Nov 2019 11:43:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=eMM42M2V4twxtji0Z0tHuhPj2oGAyw94c3O8WnUwyk0=; b=lmEG7T4L
        y28hfk91nsaETwE1TdZQj0vVbeEnYwFmkBF5lSXVkb02fMHfn1pB38QL7p9RrDVx
        xbmgbd+t69DPjnAzEqEKqt5OsRkAtvuATZaHDwYPf1TtrkFo5d0bAwNvxWAUK1hq
        SpY7G6pOWiyWp2KxZTjvDKmBi5uxpqK0BLNF1kMRjPndg3B5v3xJnbpZTwO7LmWv
        hcviHuwwGJYiS8SUy500DX3fp+d1twnBXDYhHPZSDPEHxKESXeg9KU8cw9+GHqiB
        jmJc1vyKig2q/hrE1lOul9woB5xd/yI7NDZmX0VKBM4zl/Yv9EQfEFBL9zBfpc8j
        hdXfBqCKH03Jyg==
X-ME-Sender: <xms:sUnEXdiEwsNVbK1X8WR2sJaKl7F6QgHcNxUo-ETWfagnccI1lcFu2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:sUnEXd0_E5GEfRpQSK1srNrIm8uQUMupIMM1guJoWjHXKyJK1Nfdiw>
    <xmx:sUnEXTjjtbG_yKK4AHYma4zrMlTPLLNzIezIyuunEc1YCXyRhAJgTQ>
    <xmx:sUnEXe8TYbDf7-zjlaNVL4GdQzXlUnLu7V8o0ZEOnFdec2NaFygrbA>
    <xmx:sUnEXTkPuVuFVPRQCz-zrL3Yz5FZzNUq4ql8002jNNKjV488ioHSpA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 971F180059;
        Thu,  7 Nov 2019 11:43:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/12] selftests: forwarding: tc_common: Add hitting check
Date:   Thu,  7 Nov 2019 18:42:19 +0200
Message-Id: <20191107164220.20526-12-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add an option to check that packets hit the tc filter without providing
the exact number of packets that should hit it.

It is useful while sending many packets in background and checking that
at least one of them hit the tc filter.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/tc_common.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/tc_common.sh b/tools/testing/selftests/net/forwarding/tc_common.sh
index 315e934358d4..d93589bd4d1d 100644
--- a/tools/testing/selftests/net/forwarding/tc_common.sh
+++ b/tools/testing/selftests/net/forwarding/tc_common.sh
@@ -14,3 +14,14 @@ tc_check_packets()
 	              select(.options.actions[0].stats.packets == $count)" \
 	       &> /dev/null
 }
+
+tc_check_packets_hitting()
+{
+	local id=$1
+	local handle=$2
+
+	cmd_jq "tc -j -s filter show $id" \
+	       ".[] | select(.options.handle == $handle) | \
+		      select(.options.actions[0].stats.packets > 0)" \
+	       &> /dev/null
+}
-- 
2.21.0

