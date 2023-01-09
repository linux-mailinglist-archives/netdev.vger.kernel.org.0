Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1381662384
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjAIKyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbjAIKyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:54:14 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C73EE2E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:54:12 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3096F9m8013646;
        Mon, 9 Jan 2023 10:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=l57aKw8qPwmP+fK4FnOQHgvU2UgN8oTzovje+cH5DkA=;
 b=OnhLMTvS8JsJ4aYmi4dqBlfALUwc1wO5W46YAa1weFh1sAYKvn5hne3PMPQCq2xJU9sB
 Z5M1apCTEeEqXu2efmaFlY58BoPAM7aNt2rcElBUYLUCnwLzRhvZMcTugAUlcpuD71EM
 VDvGiezyllHGffVuhODMEPZzXn/vDGXc1ZIPPW8f5MLquaOui/l5cxby0KT/hD3zk2ZX
 IW+5z0imVkbWGyvzfehqifJkl184PbJRA+LC/mh7X681uoC9D6LLGgKV+HKL/dleppwm
 NZFx6D+aZvM0Q+imYWp9VC2ecZur24nBpvs0mbn2vUk1WBF1ukWPq4QWH/DJmJmeHfVg oA== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3my0vgkp0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 10:54:11 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 309AqaVE015404;
        Mon, 9 Jan 2023 02:54:10 -0800
Received: from email.msg.corp.akamai.com ([172.27.91.24])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3my7m1wk4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 02:54:09 -0800
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.221.201) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Mon, 9 Jan 2023 05:54:09 -0500
From:   Max Tottenham <mtottenh@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <johunt@akamai.com>, <stephen@networkplumber.org>,
        Max Tottenham <mtottenh@akamai.com>
Subject: [PATCH v2 iproute2 0/1] tc: Add JSON output to tc-class
Date:   Mon, 9 Jan 2023 05:53:15 -0500
Message-ID: <20230109105316.204902-1-mtottenh@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.221.201]
X-ClientProxiedBy: usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_04,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=513 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090077
X-Proofpoint-GUID: 8T-QoPmFlzARG1OMvK_ShhwU545l74nM
X-Proofpoint-ORIG-GUID: 8T-QoPmFlzARG1OMvK_ShhwU545l74nM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_04,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxlogscore=504 clxscore=1011
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090077
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address comments from Stephen's review. 

Max Tottenham (1):
  tc: Add JSON output to tc-class

 tc/q_htb.c    | 36 ++++++++++++++++++++----------------
 tc/tc_class.c | 28 +++++++++++++++++-----------
 2 files changed, 37 insertions(+), 27 deletions(-)

-- 
2.17.1

