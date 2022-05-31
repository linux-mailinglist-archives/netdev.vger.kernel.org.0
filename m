Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AEB53905A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbiEaMKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 08:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbiEaMKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 08:10:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883858AE74;
        Tue, 31 May 2022 05:10:36 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VBE6BT021152;
        Tue, 31 May 2022 12:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=sEovGwsQnO6W5ORmc1c585pKpxqgCrV1SCPB8VMD61g=;
 b=CAXV5T7kiOkdyquFLyZcCRWMZ6hjcfjwjnpHZ65GdcB9+aEaO8AEm4CrxF+3dgkOYQ/t
 CUUm/bJIad/P9/5KjJkQkYVeoLuDOu3RMdK0WQAleq4wY3mcz0tPiJTGq9npMsVUB3BV
 pqpNQst7qu3XuUYaMbNZqjGDXeCIQ+mVgdvWFqFY4ZHmdUk9/sJeCH5uJ+AfHNtHAigj
 Fe9ENp6crIJLtI0HRIAFJWt5RMpAs+U6mtb7TcXw7mYl52EjUI3kDLmnjCmbGHB2Ealw
 UxZLX1h6A4ugx37JgZM3fJh1QlQcmIoaBjCVLa+eDCbsZGhhAqhuzxnlQX/NhXRwGayq Xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7kmssc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 12:10:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24VC6Akb024955;
        Tue, 31 May 2022 12:10:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hv2qdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 12:10:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2EXXTzLRoh92uBuoCgbETz4FR3M9A5odrXahKguhPMjd9qMNEis21nQWBz2QoznSGeHRRl6uXF26jx+sN1ptb0J/DaIy4bT2mQcSOiymjsIpFMrSGmQ4xlOfG9LWKe4qETDa6y661GcTwd/0ZAUFga8Lf8xTjR0tX29o9qRhBr5KLWg5uouomtL0ZzssseAerX1XRPaw2ZwPKYKPk37X2/QOoONH9RfuOZ1+t0od1XGrKi70WQL3AJBK999pQpn8auCJCJmFzu/00DXitPtBPkCkP9+d4H746IIYzVbA6ErLSZREJnyeuhLB4ZQ4ABlHYlrDaUrD6A742NEdFwRMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEovGwsQnO6W5ORmc1c585pKpxqgCrV1SCPB8VMD61g=;
 b=TQJNsqlPu98+fVWpdTzKTrHvREE+H1scz3rxT4MsBeylpTKAklWgsK952a4m8/IHdO1do/jlaic+lK2CZMgtZdeTOcVtp5MPZTHwWlSWX06u64DWmj7EJ6LoAb01r03y87jTWmFeRbqUd3A55HEigf2n9Ywh4uRSizsEjE3xa9SfY4UVmkMnc/mWgAGfJFCVJ/mjLGTdlZiC5aaL6qG1ZxVQkmWtNYUHhzRaJBSNdqg4tG4BaLPN+aKkSPkeEEUpipf0N35LzToCSFR6ntWtyXTRgRInVyNcOiY5GHvuidZQLahY+ZT3QEY9IWgxnw8t3flbGNhrmBG76Yb+SYtY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEovGwsQnO6W5ORmc1c585pKpxqgCrV1SCPB8VMD61g=;
 b=JE7veAVrk2gsRZaSzgz785tacpUpmwVKx6NoEQFHvTPfhN2p44OxkSdJqkB3seMuTFKwO1ET96HcM2c3b+kObsH40/OIGeB6qzxp/WL5UMDduZzVsjS0nQ3arxjwZw8sO0fchZ4JOv2uCyyhbtyrwQXmgNYJ4qH1rgE5Pz3+Wm4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5386.namprd10.prod.outlook.com
 (2603:10b6:610:dd::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 12:10:18 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 12:10:18 +0000
Date:   Tue, 31 May 2022 15:10:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/sched: act_api: fix error code in
 tcf_ct_flow_table_fill_tuple_ipv6()
Message-ID: <YpYFnbDxFl6tQ3Bn@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16511fb7-e581-457c-d0ab-08da42fe86d8
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5386608BE2B9E82121E60DC58EDC9@CH0PR10MB5386.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xZuwBDx/GViZ6lLplr8ct+Gkkf6ZtQVON/XwNWyz37Bibd5GCKQ4xCoQlmgfjV6aTURzXAqSqAasa0LtpfGSkfqoHfPa3D0bhyvc3WEnclSgj+03/e/yGGCJR6ddgmmcD/wYDa27YbTtz+2IL7aIUZLOalqO2qjXchzogrhAmorQNCAJi4CVEo0P88jiZyGwFblPBgtYu9Bnoocu0OwBmkU7FWxJ5OYbdZ9Q8BOm1xtO4vkqhWvQvkodJPuKDx1pqPZXuLB+ZW3EQ0vFTufV61PDGFeXPoZ/WsmMESFFBfNNgNNdntzBFL96oTZZ/1rexw2J6pRQ0KS/SXGUpwWtsAX2+jmJF7l8WGTrOOan1NTormAyHIvpwNTCxR3CNyJGV62qJZ/Vm1s839SZajh7DFK/A/AA2gRb9DK6pCv+jS+dC4/bwiipDoS9K7diGppr4qCc4o6el3cNWmhsl03fhiO4bbZ03ie1NSfAwIen8x72O/P4zhny/O39jZ7B3yxKzkHjR00EVY2INSZ8YKbVcKN97UeIiLlz17w/mFKmTX7G70Yjc8tWt6T+Nj4XwQJmGgoUkwISNNMS94N6uKFuk7u+fHcOSEPmoBR57frSw0/8fQ/DYEKvqmhX6MNt6zkhFdFen6wxAOO4X4yWogZzU2Kq6Q3wCdQLm0WuZWHQ+sP2+zc8qLUD4AWVeEYB2/N0sPYev9BZ/oNxxK3jA9+85A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(44832011)(4744005)(7416002)(5660300002)(83380400001)(6506007)(38350700002)(38100700002)(66556008)(66476007)(66946007)(4326008)(8936002)(508600001)(186003)(316002)(2906002)(52116002)(6666004)(86362001)(54906003)(26005)(6486002)(9686003)(6512007)(110136005)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9j+OyMf7VQvplDeqlDU1/rNFOl03lqiFfEB5nyWRpJ1lV2kFDyKYkozrgru4?=
 =?us-ascii?Q?zcmiIRObpQJBocwZnN2/NxujpKf8g3uIVc1hW2rXfKKxzwXXUBn4Ht6XheqG?=
 =?us-ascii?Q?uNA69E0KJJuq7pH5gM0Wakl59EsGY2kHc7cVBfvpKtzMjGPXN3BUvWudtkXC?=
 =?us-ascii?Q?13RRpYNQ9UxAqiKs3jb+42PS6Vr8RrLRp47bgux4qrgkGX/2N1UwElbH56x2?=
 =?us-ascii?Q?WC6fS5Tufn+MaNusNKp117Y/0B6kZvxQTTS/Og51IB1qZvkA83BYildRKuNI?=
 =?us-ascii?Q?aAEaijKK+YnTNxqyRY7UZW6syMmve/TUU/yie3qBoLxnJqQC/3WNgPxFOlX+?=
 =?us-ascii?Q?fqTFm9bUx5h0YI4dkpTi4J4567BtodVzbjQBhLitMIlMkxipqtd7NBHWLjXN?=
 =?us-ascii?Q?t7O9je0DFQ6+90nSC4ALZpZuq5OyicpBL/pvXxg24M1tBaQO8uL5uAMkIExt?=
 =?us-ascii?Q?1Vlr3IO0EnuQhCuRwIEBhJD2QT25nZAAA9LZv7JHNttiVNLqv7ew2I9Q5PVG?=
 =?us-ascii?Q?hnCLVVAryswusHD+8+U6horH4J2yB5pY0o7RI2l1PytzkDs6OJ1X7OpF9t+D?=
 =?us-ascii?Q?a4k99paqbp/HKQ2poLnx6KCEhkIM1Sft9tfNRcrEX2gOYXmULTZDb9BWNN+y?=
 =?us-ascii?Q?5cyPzSfKZTnBeXZ6syxJcBVfkRmXn20I+gv4WpmljyTHF6l1xbhUG59kd7pF?=
 =?us-ascii?Q?C6k08wGZ4Ai7mLbGuNzU/b2JfTcnQZYvs7whCcHVVTNs8UaY/jCAQePg3xHc?=
 =?us-ascii?Q?QEt4akPDnoH9MA0L2ssM/VYr51vu/GHe5nrsR57BpbMM+stwdU9kMCaTXFSS?=
 =?us-ascii?Q?ngrwWBAWIx/qIlNUZeswUi4fOP0vWDIDzr810ofQqYkaPjT6v3cMb8oakzzE?=
 =?us-ascii?Q?6v2YMjhCAbqMxqoG6jk56McoiH35rQl3qqEg3a5CWa4qnpm1ntw8dnNkaIvF?=
 =?us-ascii?Q?vCByVO4iC8SYSKnYvnrBSpI8YID/AUd55zwgvHAal0oHM/zcCFBwwUnGoU+n?=
 =?us-ascii?Q?IGokUagam9QkMLB33AMbn7ammEgjFgZQDpzf5M1wdLWaEs+jFyEjSQ5NNytD?=
 =?us-ascii?Q?TDAzOarMjox0lmKstcHdZPNU5hRSUbrJ0UODyHvrSp26ZaWzP9Ye8Lk4nKAq?=
 =?us-ascii?Q?G4cPzSD3E9Y5zSwFbqCF/qIBJSkFrvVCRzHWSVkTiGRbfDbyRZ0wu5t2q/OI?=
 =?us-ascii?Q?nGPtT7joKTEXtTZbyZyglO7nLdaxUEhQwWlRcibiklqbBAUgawPTPxR+YSKm?=
 =?us-ascii?Q?hJ7Q9amYRbXt+UFHoOOdrWAQVGlnA/qJbVEdeukpx1j+vGuOJc2yHlai+TGj?=
 =?us-ascii?Q?HxZ7KCKVAQHrqB8wM7p/TjVttHH+nC4ZKk/0LgzuyWFLmssmMu3D+xMXPlDP?=
 =?us-ascii?Q?Fmt8+cGttwqmXJWE3Y8M9pixTExofnRM84SFPcsLT8MVI97J92YEi0ErmMoy?=
 =?us-ascii?Q?iowSRNr17WPUVaXfrHxv8IGE3H2wkEshBngM0swQCpB2zThv7hjWNcbyXtcG?=
 =?us-ascii?Q?5YViPY0oVNhwZbsTQdYwYvKeLLRQx/Kmhu+e2jBO2JfTzuKAuV8qyA1i52ws?=
 =?us-ascii?Q?zAhg1Mu0D5ytbEj6IR7SeyofUdLPafQalxGPTsCFOIh3Nb/m/6EEyetRQdYT?=
 =?us-ascii?Q?1LRtZWmrUXZDJum/z+qbn62XmWR96YyHIVTD5ONH81m5L/nzoZ90lUArZHLo?=
 =?us-ascii?Q?8cSixhHEtGlfLamBOgT+7PP/y/pn+xf5f99GslB8L2/w2cA6imA85ScWO+Ox?=
 =?us-ascii?Q?R7Rte8hf1bUSaAj/T8zUwD5f4DV/fzI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16511fb7-e581-457c-d0ab-08da42fe86d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 12:10:18.0953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2cj2cnzAnwY/0CoCBd/1L3VLYBb/EOFLsvuNz4NpfRh8wUlg1LzkQgGvbko7vIsPGOWrP3eCmWHewARDdw3V01kbY3akF9ZT/Ui8/VM/Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_04:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205310063
X-Proofpoint-GUID: JuXqlgsCVWeCd6G5CNf2zdoPhtyy0lkp
X-Proofpoint-ORIG-GUID: JuXqlgsCVWeCd6G5CNf2zdoPhtyy0lkp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcf_ct_flow_table_fill_tuple_ipv6() function is supposed to return
false on failure.  It should not return negatives because that means
succes/true.

Fixes: fcb6aa86532c ("act_ct: Support GRE offload")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 8af9d6e5ba61..e013253b10d1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -548,7 +548,7 @@ tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
 		break;
 #endif
 	default:
-		return -1;
+		return false;
 	}
 
 	if (ip6h->hop_limit <= 1)
-- 
2.35.1

