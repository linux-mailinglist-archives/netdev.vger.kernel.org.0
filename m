Return-Path: <netdev+bounces-9144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E4B72778D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 410811C20AFC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB73D63B8;
	Thu,  8 Jun 2023 06:45:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC10628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:45:20 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117AB2688;
	Wed,  7 Jun 2023 23:45:18 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id 5291C32002E2;
	Thu,  8 Jun 2023 02:45:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Jun 2023 02:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1686206716; x=1686293116; bh=WraTAWRIoJ
	lEuzvCd9vVHpuOSFjr8/vh4GpgMoUHTF8=; b=AZUWFCkMpStl8ZEtBObdwGGS+j
	wrhjX5YrgboeNJ8BPrZru9V8v6Ip7Uvur+YwQVf8N7nvTvqIBJwNH7CGfsgP9y6n
	6uUraY3tqj1lKtJn0dMjqOgzbuFqfvIxtjSMvgs041wY9Y73JVbBz5E16frEZHpq
	2vKy3A8/95xBKHs5EGCXHeLuBDQdjD8ieYPtTWty0wTIogLZvEIc3IpBW7OWc4pV
	phKI0nBX0KJHebkhaXZjf2EaDu1mT4GmUOpAcmS6fzXD2oPeIJp4FOdAAMgOrvvu
	U0gFK/3k89sTED75FZAxGWyItY4xkZbnZR43mSY5aUU5SJZJ0h23kEbkRb4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686206716; x=1686293116; bh=WraTAWRIoJlEu
	zvCd9vVHpuOSFjr8/vh4GpgMoUHTF8=; b=RBj6DoydqjlpF02pdbUcroxdy/k7C
	pUQweQFTmGRqED/UXPA1TwamNbLSAd/vM42z6pTGCzyOAY6+hcAr32nIUi4zw9un
	PQfUxOvF3IMMfDxhdaNapGDWENylSy3Ek3NyvBTdDDK91xbDTTDxyRiB8CgrFH1b
	+woAqobM8gZEUvCfgTTr1SnarhIqsWc2Trc+TUHkcKaXH6NBQxZXYTKEL/eIBpof
	ZS8xxkYRyvd1AEuKnL9RRGd5HSi9IBGvMjid6eqaIqXD6GEEGKh5WI6p+iuq22SQ
	GAwdHHD6ct/Q1qxL6aTjLhcdSUVqTbG6grDs5Njb3HNJaS5h8FPC8VnqQ==
X-ME-Sender: <xms:_HiBZGAKqzbVJuggcdFaONnyrCYbLRzIwkOvzNL7VEdj1xZQzEp0UQ>
    <xme:_HiBZAjHmwpnKTzjXzpuCWS-KzWsueugRWFDNK-sQ-fIsHDDMw7gTiGvr-koQmwqp
    K3wE26SOIgb1bM5LjE>
X-ME-Received: <xmr:_HiBZJlG5dufbLJm1mmGWquj4hE3Ux9VnKO2fgmqUgen_xD7bgnqtiq1bRSA4qedL83BJovLuSE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedthedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepgghlrgguihhmihhrucfpihhk
    ihhshhhkihhnuceovhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrf
    grthhtvghrnhepgffhvdffheehveffheelleeiudetheefhfeftdfgteetkedvueegvdef
    teejheejnecuffhomhgrihhnpehtrggsshdrthhoohhlshdpthgvshhtvhiglhgrnhhnoh
    hlohgtrghlsgihphgrshhsrdhshhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:_HiBZEzx-6V1UO454EpbVWJB8-bBfjPyDTt87viWfdjN2B6kgpm6_w>
    <xmx:_HiBZLTJY52kfIwDzKqI1XMS7vC7qL_FgJb4XQ4w5gquqptrcitaaw>
    <xmx:_HiBZPY1izXMKB6cpLZys0OjhflcdNnPEetMnGKevBGjSABVyF3hxg>
    <xmx:_HiBZHqindj9JP2p5hHKeu9SuC7w3uoGfh2iin26xTDG0y66NchPMw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 02:45:12 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	stephen@networkplumber.org,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v2] selftests: net: vxlan: Fix selftest regression after changes in iproute2.
Date: Thu,  8 Jun 2023 14:44:48 +0800
Message-Id: <20230608064448.2437-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The iproute2 output that eventually landed upstream is different than
the one used in this test, resulting in failures. Fix by adjusting the
test to use iproute2's JSON output, which is more stable than regular
output.

Fixes: 305c04189997 ("selftests: net: vxlan: Add tests for vxlan nolocalbypass option.")
Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
v1=>v2: Fix indentation by tabs.

 tools/testing/selftests/net/test_vxlan_nolocalbypass.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
index 46067db53068..f75212bf142c 100755
--- a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -130,7 +130,7 @@ nolocalbypass()
 	run_cmd "tc -n ns1 qdisc add dev lo clsact"
 	run_cmd "tc -n ns1 filter add dev lo ingress pref 1 handle 101 proto ip flower ip_proto udp dst_port 4790 action drop"
 
-	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+	run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
 	log_test $? 0 "localbypass enabled"
 
 	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
@@ -140,7 +140,7 @@ nolocalbypass()
 
 	run_cmd "ip -n ns1 link set dev vx0 type vxlan nolocalbypass"
 
-	run_cmd "ip -n ns1 -d link show dev vx0 | grep 'nolocalbypass'"
+	run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == false'"
 	log_test $? 0 "localbypass disabled"
 
 	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
@@ -150,7 +150,7 @@ nolocalbypass()
 
 	run_cmd "ip -n ns1 link set dev vx0 type vxlan localbypass"
 
-	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+	run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
 	log_test $? 0 "localbypass enabled"
 
 	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
-- 
2.35.8

--
Fastmail.


