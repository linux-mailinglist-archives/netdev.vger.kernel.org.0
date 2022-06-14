Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFBE54A887
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiFNFCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiFNFCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:02:46 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963C6220C7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655182965; x=1686718965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tkrUAPK/YoSGl+QBJ9FtwlvwlbE8T2LZhxW9lzJW1bI=;
  b=E9JwVNZz+mR4kX5tpfdQcue0EEhPVllIs7hLub65Z0SuPvt/XKYtnxsS
   VMcCcl0i9pkpYb8FYGccYIuIjUvOCHBvO8CCLQKjpG5HP5OYKQ7RgDl5P
   6UXVf5CDfm4DUH2GDDJyGSOlxE9irwvlQx/r+Yc2A7xsH3Fwt8h95iglv
   w=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 13 Jun 2022 22:02:44 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:02:44 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:44 -0700
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:43 -0700
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <sbrivio@redhat.com>
CC:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>
Subject: [PATCH net v2 2/2] tools: selftests: Update tests for new IPv6 route MTU behavior
Date:   Mon, 13 Jun 2022 23:01:55 -0600
Message-ID: <1655182915-12897-3-git-send-email-quic_subashab@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv6 route MTU no longer increases in case the interface MTU is
increased. Update the tests pmtu_ipv6_exception and  pmtu_vti6_exception
to account for this behavior.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
v2: New patch added to the series

 tools/testing/selftests/net/pmtu.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 736e358..dac2101 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1067,11 +1067,15 @@ test_pmtu_ipvX() {
 	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
 	check_pmtu_value "1500" "${pmtu_2}" "changing local MTU on a link not on this path" || return 1
 
-	# Increase MTU, check for PMTU increase in route exception
+	# Increase MTU, check for PMTU increase in route exception for IPv4 only
 	mtu "${ns_a}"  veth_A-R1 1700
 	mtu "${ns_r1}" veth_R1-A 1700
 	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
-	check_pmtu_value "1700" "${pmtu_1}" "increasing local MTU" || return 1
+	if [ ${family} -eq 4 ]; then
+		check_pmtu_value "1700" "${pmtu_1}" "increasing local MTU" || return 1
+	else
+		check_pmtu_value "1300" "${pmtu_1}" "no change in local MTU" || return 1
+	fi
 	# Second exception shouldn't be modified
 	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
 	check_pmtu_value "1500" "${pmtu_2}" "changing local MTU on a link not on this path" || return 1
@@ -1637,10 +1641,10 @@ test_pmtu_vti6_exception() {
 	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
 	check_pmtu_value "3000" "${pmtu}" "decreasing tunnel MTU" || fail=1
 
-	# Increase tunnel MTU, check for PMTU increase in route exception
+	# Increase tunnel MTU, confirm no PMTU increase in route exception
 	mtu "${ns_a}" vti6_a 9000
 	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${tunnel6_b_addr})"
-	check_pmtu_value "9000" "${pmtu}" "increasing tunnel MTU" || fail=1
+	check_pmtu_value "3000" "${pmtu}" "no change in tunnel MTU" || fail=1
 
 	return ${fail}
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

