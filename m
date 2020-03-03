Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B91176CE6
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgCCCri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgCCCrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE77F24697;
        Tue,  3 Mar 2020 02:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203656;
        bh=vOSBD3sjHzK6riGbNN96CcuhfOs6Oto3eXhPhUlUcHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjtH5PL8mPZnm4EgwH1GU5HIuHafOHqhNE7KOhTS3bP7NIrydHRqGhuJ6XWIh40kk
         70FZjxABSfGS1+eLOr3hh3kw9IMuOfl5S2KOI6chguwBeFL+pyWUmjBcTjh2+EHUWg
         lQzBzoJDXZRozqFz6Shs7k9HPEGZ4B5e0KG5I+B4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 66/66] selftests: forwarding: vxlan_bridge_1d: use more proper tos value
Date:   Mon,  2 Mar 2020 21:46:15 -0500
Message-Id: <20200303024615.8889-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 9b64208f74fbd0e920475ecfe9326f8443fdc3a5 ]

0x11 and 0x12 set the ECN bits based on RFC2474, it would be better to avoid
that. 0x14 and 0x18 would be better and works as well.

Reported-by: Petr Machata <petrm@mellanox.com>
Fixes: 4e867c9a50ff ("selftests: forwarding: vxlan_bridge_1d: fix tos value")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index 353613fc19475..ce6bea9675c07 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x11 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
+		flower ip_tos 0x14 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x14" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x18" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.20.1

