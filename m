Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27869296D8B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462908AbgJWLWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:22:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462778AbgJWLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 07:22:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBJ1NW008646;
        Fri, 23 Oct 2020 11:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Ij3kbeYHmjUPJ1In5uZ/O+jWnMmXyszv3wHt8UYtJRE=;
 b=knRh3c/Mg+yybdbvRMpoQm+glM7jOQUMan1Ua3F5jiGwbBTBk0ykXhR2p+dg5uUaf+UK
 IX9JW66QVXAkhs5fMN2B8bRvYcHKEYTSrvqCSoM8KHNIo198rN0bB5NygGlBiB+7xeNc
 iL1V2Nfmjy7FoGzs5DSC9n4NFqC2wMf9hGASXLVuJJcahMnoDpTQAEDmRfuJ8BlzCwRO
 Icom4LhPAO2MctXDsMzyBMeHK1bOkCz3epPK4faxlQqdhOxVey7EeUoqWSyO1i08jui3
 A9eWLL5Z7cC1XlYiS+OLacDEUl1Osh6m1VTtn+3G8DYi4ix+quDlFBdmbvZ2fgwl3fFF Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 347p4baqr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 11:22:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBKED5099291;
        Fri, 23 Oct 2020 11:22:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6rndyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 11:22:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09NBMKrO005923;
        Fri, 23 Oct 2020 11:22:20 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 04:22:20 -0700
Date:   Fri, 23 Oct 2020 14:22:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>
Cc:     Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: hns3: clean up a return in hclge_tm_bp_setup()
Message-ID: <20201023112212.GA282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that "ret" might be uninitialized if we don't enter
the loop.  We do always enter the loop so it's a false positive, but
it's cleaner to just return a literal zero and that silences the
warning as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 15f69fa86323..e8495f58a1a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1373,7 +1373,7 @@ static int hclge_tm_bp_setup(struct hclge_dev *hdev)
 			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 int hclge_pause_setup_hw(struct hclge_dev *hdev, bool init)
-- 
2.28.0

