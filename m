Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D42588EC6
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiHCOmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiHCOmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:42:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D7410FC1;
        Wed,  3 Aug 2022 07:42:06 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273DRWt1022039;
        Wed, 3 Aug 2022 14:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G+4gwFaBfRWlzF1t/Etc6wyzJAx1XTpOpbbt3XD6cB8=;
 b=kDWC+HIs/do++MxRfnOf5CNaQgZ7grwI7RFUJTgxkYxuJqrlCVR+YZKhZSAgYJPHT9Ps
 wpVMTsKqM4dARWQLV2CQJeIvxqsjngwAVct9jnCNYJMurpfg0d2zGwinaoT7jYjRvjJY
 yi4jgWo/J0YLVGp156orGB1l3oakux4e7pn94+vTJAzj9D2wL54x+7JZRyeu3pR5eBIv
 OQ4PrtlaEM5aGWt1guSw1WHfSMFV5xwJN612ikxYiauS3v74DMaXmVIJXUjMzZBY3Cuu
 B7an7QbQlFRu/LnRtBFoyKfIymgEgVnA4w4jIpiX/y+VXAj6FXMrnflhJItPA9H/Wo6i gw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqr6ay5e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:41:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273EZaZC005474;
        Wed, 3 Aug 2022 14:41:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hmv98w1fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:41:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273EdZP033423820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 14:39:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56491A404D;
        Wed,  3 Aug 2022 14:41:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 074CBA4040;
        Wed,  3 Aug 2022 14:41:51 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.145.20.221])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 14:41:50 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 0/2] s390/qeth: cache link_info for ethtool
Date:   Wed,  3 Aug 2022 16:40:13 +0200
Message-Id: <20220803144015.52946-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 66cEcaXUSjN4DDSDnuYwsZOWFbUjKoDU
X-Proofpoint-GUID: 66cEcaXUSjN4DDSDnuYwsZOWFbUjKoDU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=818
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cache the link info and keep it up to date, so ethtool's 
get_link_ksettings doesn't have to go down to the hardware.
Debug data has shown that this can actually solve a recovery
problem. 

Alexandra Winter (2):
  s390/qeth: update cached link_info for ethtool
  s390/qeth: use cached link_info for ethtool

 drivers/s390/net/qeth_core_main.c | 169 +++++++++---------------------
 drivers/s390/net/qeth_ethtool.c   |  12 +--
 2 files changed, 49 insertions(+), 132 deletions(-)

-- 
2.24.3 (Apple Git-128)

