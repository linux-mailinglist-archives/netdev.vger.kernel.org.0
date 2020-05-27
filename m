Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7961E4FC4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgE0VDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:03:37 -0400
X-Greylist: delayed 1988 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 May 2020 14:03:37 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C4DC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:03:37 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RKTB3Q028322;
        Wed, 27 May 2020 21:30:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=huY5KS++g9eSySYIT3LS8ZUrsEZYhUK/1+aCFQZ7d+A=;
 b=VLt7LKWzvMgF89WHVdufv0WBtvDOp0dXDgJdlUkJKlbIOo/5JDeDtgEfy7c4FTtW8ym0
 eaAJfuQ2ACVFcGByuDjKscJnGMNzupFYshTw7W9g8LBs1O9ETlXugMZLybqNp2ExABGZ
 oP6NWTbOFm8zvmgE4KAintPAQt8n1ryrIBVm8FENL+bSHM0xCB6VDHUbxX4jlRXUhl9Z
 TNVPXlsiasNOEfxzjf/CBj+ml7N6DbrMyua7sB3S1nlLDI6V7u5dWPUZCA/gBZ/WlO/a
 mjgiNTwfiG+RzM+RaJW3UmLyVeqVmyFbfb6TrxAyQOYO7SsW6BcgfgV2WaE1vZNtr002 Kw== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 316ug52hem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 21:30:44 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 04RK2KbY030147;
        Wed, 27 May 2020 16:30:43 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint4.akamai.com with ESMTP id 316y5vcmcw-1;
        Wed, 27 May 2020 16:30:43 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id A9B5F60152;
        Wed, 27 May 2020 20:30:42 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: [net-next 2/2] selftests: tc_flower: add destination port tests
Date:   Wed, 27 May 2020 16:25:30 -0400
Message-Id: <1590611130-19146-3-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
References: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2004280000 definitions=main-2005270153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that tc flower can match on destination port for
udp/tcp for both non-fragment and first fragment cases.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 .../testing/selftests/net/forwarding/tc_flower.sh  | 73 +++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 058c746..6424084 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
-	match_ip_tos_test match_indev_test"
+	match_ip_tos_test match_indev_test match_dst_port_tcp_test \
+	match_dst_port_udp_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -334,6 +335,76 @@ match_indev_test()
 	log_test "indev match ($tcflags)"
 }
 
+match_dst_port_test_helper()
+{
+	RET=0
+	proto="$1"
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags ip_proto $proto dst_port 80 action drop
+	tc filter add dev $h2 ingress protocol ip pref 2 handle 102 flower \
+		$tcflags action drop
+
+	# port match, no fragment
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t $proto dp=80 -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_fail $? "Matched on a wrong filter"
+
+	# port mis-match, no fragment
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t $proto dp=81 -q
+
+	tc_check_packets "dev $h2 ingress" 101 2
+	check_fail $? "Matched on a wrong filter"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter"
+
+	# port match, first fragment
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t $proto dp=80,frag=0,mf -q
+
+	tc_check_packets "dev $h2 ingress" 101 2
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter"
+
+	# port match, non-first fragment
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t $proto dp=80,frag=2,mf -q
+
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_fail $? "Matched on a wrong filter"
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_err $? "Did not match on correct filter"
+
+	tc filter del dev $h2 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+}
+
+match_dst_port_tcp_test()
+{
+	RET=0
+
+	match_dst_port_test_helper "tcp"
+	log_test "dst_port_tcp match ($tcflags)"
+}
+
+match_dst_port_udp_test()
+{
+	RET=0
+
+	match_dst_port_test_helper "udp"
+	log_test "dst_port_udp match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.7.4

