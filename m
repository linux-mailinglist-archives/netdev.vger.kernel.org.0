Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE26A20F3C7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 13:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgF3Lse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 07:48:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgF3Lse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 07:48:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UBgPfe196081;
        Tue, 30 Jun 2020 11:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=uxq/cKx519UunETtqtXYq6fCE8XXU5EvXIx0epdZCQQ=;
 b=0PNp5hsOdKn/2ZW4WNcy+g0QBDBJFtgNvFg2QdwkyrVFYC00HITHoZC2+Ru7jzyzpjj7
 02TYcGSIw8YNNP1HxahgRhEJBFUxJSeW/rpv0flsj56YnPmokDRU8D5QF6DTPCYlUk3Z
 QBTTwpF6ERCpZDJDVhUqs20Ej0M4L9GTQM095rcvjsSpnxmzgrwcRnj7BK0JLoSIu169
 YfW9wautb92/9mRca/RpT8MJJVz1Ij41RQ7o3A/cP8pjoehGwc2ebpct8Nh+3aZK9gJc
 Gh+YJN2WGtDIvQyeX5HHQ9rsRBj34qHzQf+WMCGFb9QWo/Ucx/8vcw64EgeGaStGyfkV Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1dru06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 11:48:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UBgYO4189853;
        Tue, 30 Jun 2020 11:46:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52hrqxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 11:46:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UBkMau003808;
        Tue, 30 Jun 2020 11:46:23 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 11:46:22 +0000
Date:   Tue, 30 Jun 2020 14:46:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Wang Wenhu <wenhu.wang@vivo.com>,
        Wen Gong <wgong@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH net] net: qrtr: Fix an out of bounds read qrtr_endpoint_post()
Message-ID: <20200630114615.GA21891@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200628104623.GA3357@Mani-XPS-13-9360>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code assumes that the user passed in enough data for a
qrtr_hdr_v1 or qrtr_hdr_v2 struct, but it's not necessarily true.  If
the buffer is too small then it will read beyond the end.

Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reported-by: syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com
Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/qrtr/qrtr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 2d8d6131bc5f..7eccbbf6f8ad 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -427,7 +427,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	unsigned int ver;
 	size_t hdrlen;
 
-	if (len & 3)
+	if (len == 0 || len & 3)
 		return -EINVAL;
 
 	skb = netdev_alloc_skb(NULL, len);
@@ -441,6 +441,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	switch (ver) {
 	case QRTR_PROTO_VER_1:
+		if (len < sizeof(*v1))
+			goto err;
 		v1 = data;
 		hdrlen = sizeof(*v1);
 
@@ -454,6 +456,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		size = le32_to_cpu(v1->size);
 		break;
 	case QRTR_PROTO_VER_2:
+		if (len < sizeof(*v2))
+			goto err;
 		v2 = data;
 		hdrlen = sizeof(*v2) + v2->optlen;
 
-- 
2.27.0

