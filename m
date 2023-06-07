Return-Path: <netdev+bounces-8850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D216C726082
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88CB3280F5D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E9F1426E;
	Wed,  7 Jun 2023 13:07:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4AF139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:07:12 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26419F;
	Wed,  7 Jun 2023 06:07:09 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id 1E51F3200077;
	Wed,  7 Jun 2023 09:07:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 07 Jun 2023 09:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm1; t=1686143226; x=1686229626; bh=Q0+fHTdMVf
	AdpfjXdX6NHbBZTNDb/w5eycRyzL6Ps7o=; b=JlCESFmqz3wZRmQae6KW3/o+US
	Sh0qj/YNJVvWi0YlA8u6PDlNWMVWpRnwRDDJziYHwg+jhsAFfBAwtPzXjBaqWldP
	jB/bXe+8EaspMeA4eqVrM9r297Pz3FunLGAVLGthYHIY9eyhX8J110K7eqe+oE9c
	Mu7AjSu6NtwOfsR1ZyXijvwC1o4/EI7cJZH5UsKUKfXZcmD+HGeUXzAEBOlsfnN3
	07/uzNql/8liVUiYSOGhdxFH0KjiEpLUzw+gfRvZJVt1HxYY8N285urswjIpHG77
	2I8Pt/+3mXQU4vcnIvenaj1kfzXRg88dDOGcCXNlumIw8GwiTEr50Ya4FcCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1686143226; x=1686229626; bh=Q0+fHTdMVfAdp
	fjXdX6NHbBZTNDb/w5eycRyzL6Ps7o=; b=aAm0eMCjR3UkPuFmlGGgWWBO99Pr/
	iKBNhLBg7p9gZ1CWrD0vZRzd2F6YSwaGskDByotCT/ZOOFXVRY7K22XYaf58vZ+k
	bLQIKq6dCmhY1w4fxEHoZRj8HSXWmmWa8Z9pp69iEPvpsSm5p5TDsIUxkIB2kpew
	msvwhCG1IvyuaAXTRBWaulkRYV2mHSN3jsvzkxJq+CvXk79/x8N8lJPuYGZQOECz
	dgzdWrKwkNU52ypO3eR3ukUZNFBihexxKjc2ZOacqgNuBM8Psy5AZ2J0Czx42Iax
	hvY4zPqBYuqC6uzZ9+nMw5zT7vs2lEFeDeV+NVraiuus0f600u1Pe+kgw==
X-ME-Sender: <xms:-oCAZCpo3GmqPShNfTXPhJG5zTuHBSP4vz5jHk7B1JRgv2uuj8xLVw>
    <xme:-oCAZAoyHNPpNKsy5kzJzgur2Cmy2GysHY79RWdu6u-2675PfrM9f71znq9IK_Vnh
    5-b9kxK8UxABWeVLsU>
X-ME-Received: <xmr:-oCAZHOijvxGhEuSPBxyqsfiaiMhBpV-o6scAjpFUAbNUX3pHSeBTMGm_TR_2UHR011J6jKYC_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeefteejhfejleetfffghfejteelvdetteevlefggfffuedvhedutdegtefh
    hfejgeenucffohhmrghinheprggttggvphhtvggurdhtohholhhspdhtvghsthhvgihlrg
    hnnhholhhotggrlhgshihprghsshdrshhhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:-oCAZB7plW-Fre-_u4MWcO22giLLXNOoUCPRYG_lKGTiDhkCcpbbjQ>
    <xmx:-oCAZB76MFpexW8F8tMM48B0-UxIxVKoJRqQvCjdeqDTGCEoqL57ag>
    <xmx:-oCAZBgPIIA0l4sAOIRhaRtHKHz9xL9lnVbXGdKpzD2i7mhR4dLndg>
    <xmx:-oCAZASG8hqRNLVsZrxswaULKoNVYUKj1ZgE9q3GI6ARw2WxSX3zEw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jun 2023 09:07:00 -0400 (EDT)
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
Subject: [PATCH net-next] selftests: net: vxlan: Fix selftest after changes in iproute2.
Date: Wed,  7 Jun 2023 21:06:21 +0800
Message-Id: <20230607130620.32599-1-vladimir@nikishkin.pw>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

1. Make test_vxlan_nolocalbypass.sh uses ip -j JSON output.
2. Make sure that vxlan nolocalbypass tests pass with the upstream iproute2.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---

This is version 0. As suggested in the mailing list, fix tests
after the change to iproute2 is accepted.

 tools/testing/selftests/net/test_vxlan_nolocalbypass.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
index 46067db53068..1189842c188b 100755
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
+        run_cmd "ip -n ns1 -d -j link show dev vx0 | jq -e '.[][\"linkinfo\"][\"info_data\"][\"localbypass\"] == true'"
 	log_test $? 0 "localbypass enabled"
 
 	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
-- 
2.35.8

--
Fastmail.


