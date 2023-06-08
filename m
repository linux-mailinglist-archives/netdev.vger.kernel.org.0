Return-Path: <netdev+bounces-9101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFA87273F2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E92A9281570
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C782810;
	Thu,  8 Jun 2023 01:05:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF227F6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:05:10 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CD72115;
	Wed,  7 Jun 2023 18:05:09 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 0398F5C01C1;
	Wed,  7 Jun 2023 21:05:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 07 Jun 2023 21:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1686186305; x=1686272705; bh=5bBEe0GLjb
	aVn4rHmIVTM0XdFdXFWe1qA/2vtDozbkE=; b=G87mFfNmCgyVNGCRBB/ZB/msgR
	9JzsONBr/2QBSoi9Oka1zKzyG3BYIFjG7pZyeqQL6NnCOgPn0uEQwmidzGGYPzLh
	zdRSoFukUsWGb2/hnNtnx7eHLFxNhubg3GJeSopodiB1sc8aZfH9stFOOAhX8mzo
	oT29F7ZNeVQ2rLcO62b9oFgYL5SH1RYkSL/7/wtyw7AwhBV718y9TZBv/vj0vycu
	RV6FwmWO7XYViZCyuHCL3EdiQk3GRWOlbjjFvSAeFdY59HXgPRS8WYZxshMjz0wK
	2axJUVDMoD/85Q6Mdy7afFvX22SLXX8JwcHW6HafNT6k7QwixGSL/hqm9Aeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686186305; x=1686272705; bh=5bBEe0GLjbaVn
	4rHmIVTM0XdFdXFWe1qA/2vtDozbkE=; b=NIZtki5vdypFuIOFWNgmEnAJWtklg
	UCAHVUD9BtyQLF1wd6/5ybTUaBd/IGVzfKektdtjn23eUfEVCerhYjVXm3iO48AD
	/8KoSM3E4t00X3YKPDp1HzyiA4EqLo5t3ICPg8x3/iXPTSkB8r81X7ckK3yzkaRQ
	J+vyuUrGiitlH70witBSlfWTxWSqOTXv9zk0bxLDe5mKR8O71ecQCEuIBOgPu5fc
	vLdMRrqa6KexGl5wgRaJ7+euFS6jNyXg20tUFn6+GgqveUY9Qp6sXtYLY/Tq20kV
	kKbS5LpSpc030CcnU7NTfzZ+FVuo1LKUc8syu30Bml4arAe/9fDIiiKJg==
X-ME-Sender: <xms:QSmBZNOZQej5zlJlhqXQ5UxP-dbhd01FrEH6537xKFFQoI7lmBWcfw>
    <xme:QSmBZP8snORl42tTAH1-RGGpqcx2vFkZGPrRXOab20MxtN96TTu14VbYEthKNSiAQ
    26PdcboBBkgoAnrDzI>
X-ME-Received: <xmr:QSmBZMSaYDu73p5ybZkmSO29hx_AP9ZQ2zVYDV_PE8Ft6Nt4xNsaNi8FY5kZSBN-6C2x4DC8qzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedthedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpefgheegleetjeffveehhfffudejfeffhefhleelgfejtddtieeivddtleev
    veevieenucffohhmrghinhepmhgvshhsrghgvgdrthhoohhlshdpthgvshhtvhiglhgrnh
    hnohhlohgtrghlsgihphgrshhsrdhshhenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:QSmBZJtpwfwu_VsuktXGyBqV-NdmflqoGYR2jAhnl5GKf86V-BhrTw>
    <xmx:QSmBZFf9YmTnSy3gK2etYd4ma42Qqk1cqj17LZSDromdWkMu9E_Rlw>
    <xmx:QSmBZF2k3CxLiBZ8BZuAOXsXbIa_6A91AbB2xQtER9j0WMpB1QaPAQ>
    <xmx:QSmBZA3oKTi3VK4LncJW_kX09248SLuH7BSTxMh9oR7iIVhdxdx-Ew>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 21:05:00 -0400 (EDT)
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
Subject: [PATCH net-next v1] selftests: net: vxlan: Fix selftest regression after changes in iproute2.
Date: Thu,  8 Jun 2023 09:04:00 +0800
Message-Id: <20230608010400.30115-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The iproute2 output that eventually landed upstream is different than
the one used in this test, resulting in failures. Fix by adjusting the
test to use iproute2's JSON output, which is more stable than regular
output.

Fixes: 305c04189997 ("selftests: net: vxlan: Add tests for vxlan nolocalbypass option.")
Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
v0=>v1: Fix spaces in indentation. Correct commit message.

tools/testing/selftests/net/test_vxlan_nolocalbypass.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
index 46067db53068..3ce630e4a18b 100755
--- a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -130,7 +130,7 @@ nolocalbypass()
 	run_cmd "tc -n ns1 qdisc add dev lo clsact"
 	run_cmd "tc -n ns1 filter add dev lo ingress pref 1 handle 101 proto ip flower ip_proto udp dst_port 4790 action drop"
 
-	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+        run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
 	log_test $? 0 "localbypass enabled"
 
 	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
@@ -140,7 +140,7 @@ nolocalbypass()
 
 	run_cmd "ip -n ns1 link set dev vx0 type vxlan nolocalbypass"
 
-	run_cmd "ip -n ns1 -d link show dev vx0 | grep 'nolocalbypass'"
+        run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == false'"
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


