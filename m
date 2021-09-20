Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD9D4117D8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbhITPKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbhITPKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:10:21 -0400
X-Greylist: delayed 516 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Sep 2021 08:08:54 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A7EC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:08:54 -0700 (PDT)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KCk5mJ014016;
        Mon, 20 Sep 2021 16:00:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=jan2016.eng; bh=hhQbPMwcmJgmRIkBudZtpb385Xq0TgP2uCYZ+G1IAQc=;
 b=FrJqB+HefseuW+H2EXeXInc6BbICEhaXOBPulqJ2OLroEbywrYz20s8AgbU8hONp9XMO
 fxWJth9EenmD4Xfc31fPeso/QbmuqnGpziWoWXU0Bzp8YNeZ8qQMmMu+HQ5AF+Yew5Ez
 TH8vBIAvuJcwKh670KJZJ/4rsxo9v/tZKVKQR0oedck+Vwhra5q1BnpYUkqPNeSJR52r
 +QzSwIPgisKf8COCaAa5A36qKHptWloEwk2kHvLBzr+mHTV8epoUFj1Em9h5Hr6oN4hI
 UZurmNDivWHep8ctpTyNX7t2amJX4ecqt4qfMKdXSa2gGiu1ZajRSsFb0KeZIuYJKJhn +Q== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 3b6fa8rvp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 16:00:14 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 18KEns9T027277;
        Mon, 20 Sep 2021 11:00:03 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint3.akamai.com with ESMTP id 3b5wd78jqp-1;
        Mon, 20 Sep 2021 11:00:03 -0400
Received: from bos-mpr1x.145bw.corp.akamai.com (bos-mpr1x.bos01.corp.akamai.com [172.19.44.209])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 60822601E3;
        Mon, 20 Sep 2021 15:00:03 +0000 (GMT)
From:   Puneet Sharma <pusharma@akamai.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@kernel.org
Cc:     amritha.nambiar@intel.com
Subject: [PATCH iproute2] tc/f_flower: fix port range parsing
Date:   Mon, 20 Sep 2021 11:00:01 -0400
Message-Id: <20210920150001.40823-1-pusharma@akamai.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-20_07:2021-09-20,2021-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=2 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200095
X-Proofpoint-GUID: MEDqXjXvBigk0qn4JemeStUkiu2DJ7G7
X-Proofpoint-ORIG-GUID: MEDqXjXvBigk0qn4JemeStUkiu2DJ7G7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=1 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 clxscore=1031 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200096
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.31)
 smtp.mailfrom=pusharma@akamai.com smtp.helo=prod-mail-ppoint3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provided port range in tc rule are parsed incorrectly.
Even though range is passed as min-max. It throws an error.

$ tc filter add dev eth0 ingress handle 100 priority 10000 protocol ipv4 flower ip_proto tcp dst_port 10368-61000 action pass
max value should be greater than min value
Illegal "dst_port"

Fixes: 8930840e678b ("tc: flower: Classify packets based port ranges")
Signed-off-by: Puneet Sharma pusharma@akamai.com
---
 tc/f_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 53822a95..3af820a6 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -724,7 +724,7 @@ static int flower_parse_port(char *str, __u8 ip_proto,
 	if (min && max) {
 		__be16 min_port_type, max_port_type;
 
-		if (max <= min) {
+		if (ntohs(max) <= ntohs(min)) {
 			fprintf(stderr, "max value should be greater than min value\n");
 			return -1;
 		}
-- 
2.24.1 (Apple Git-126)

