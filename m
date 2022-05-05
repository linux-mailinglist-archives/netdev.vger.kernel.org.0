Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85BB51BDAB
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356428AbiEELHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356393AbiEELHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:07:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CF04CD41;
        Thu,  5 May 2022 04:03:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24588rkI025194;
        Thu, 5 May 2022 11:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=FVDCRtFLx+ncmiIhtjvug3b2+/Y54UVhrpHxIGbqiSg=;
 b=d0J0U+B7mSt4LjbKkZxSlmxsCz50e2X47W5/PpPijd8T1k3aj5d7QspRzltfaL4NO+0n
 smaS8WlARZX72ZL/yEPfsiXOFMQQxVbcqibzTB/nzTIStbgs7xDaboE4YftW1CYbiGTj
 szHRdpL2IyT2yyCH7vJI4mEajFhNhBihRcg5YUyDUUoBOlGvDSnvS+YCO+ioJTeVq47u
 8RSq/C4rBJOPM/YHEGWrGfj+wn/reHs6BCG0bMxFxLlgSpzRmpgS8NLjza+GGH8Sy9zq
 ET6SJDkAOG6ThJaUb9FFKKz7CfW7X/dVy0cv/Wp4y3z3VEPkj/JAQDOU+pUMPTshjdvP yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2k00n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 11:03:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245B0rpJ030397;
        Thu, 5 May 2022 11:03:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj4f2v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 11:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVw9GZWjpcCNYaA2Pj7jVMjW1dqgGMjE0rblWl+MqbhJSQq99rEhJKEZBrouiWgRsQJrADSLCJbhFtFzDbMSqeKb7gkyGTm9S9lbt3QDTa/S/ZB60PVtY0Zp2iddQk+egyApj0t3APuQpmWpwXkSxZDplaSZt+xq6qFHtmSGLUm0AIqJ8+VuhYhONZOJM0pUTuBj5OBKy5lsBb9bM8Lf5VkHyJo5y0L4jgnlfV0DUiW4cHrf7ddRIh1/SVyIh9q8PPH0d301JiLVyHbbgtX7zNleG5bsZVkl9HMd8WDsDE3yrnw8ofYsAcFdqk+/WFLhi8Of07fJ5PfssVw2S3MSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVDCRtFLx+ncmiIhtjvug3b2+/Y54UVhrpHxIGbqiSg=;
 b=Cf2lLMxFGe8oRrEMQAGnHi8a1khxf7HZJhbhHKCDj5nb+IatGuV4tKPcvWx9TTF+EquMGUS8xc0SDe8fAA1ldA3MIRaAQe8dee1mkym/IWs5RNmTVyTJ3SiD1cTzrh36YKAWH6XKL72bY4Qxp3r+P5OGUMwTZdSdY96mdQ+A/YjPhxSTuIS3blxQWUx/SY1q7Y6tFxaIsVOd3B8D93f6yRQGtFg0ICaICYjTZuCraqersG7HZiLZrobH3X6fqXOQyUDQb/qvAfDReaN4d1wuybqpDKPxEpSE0J8sUGZXw2hGbN3CEz0E1tAm0JG+ilsVzoEo2BvtQNHVrhgx+3QGkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVDCRtFLx+ncmiIhtjvug3b2+/Y54UVhrpHxIGbqiSg=;
 b=tA6drEeUwXMNKDrTUq+lj9+ho6u9q8gpLg/tfjQLN1Ln6cywwRjlw2vGeR1DvCeq04h084WubejHlRF41GJUKCRAvzFNLXZSgrv/NKM/2Pm4FfnL//NJySjmnV7C/8Bnam6hvTqNdVMdOtz5v5m1jaW8AATqU0PKdSfde1ts/So=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by SJ0PR10MB4815.namprd10.prod.outlook.com
 (2603:10b6:a03:2da::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 11:03:15 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 11:03:15 +0000
Date:   Thu, 5 May 2022 14:03:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] mptcp: fix deadlock in mptcp_close()
Message-ID: <YnOu5xlGgE2Ln7lj@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28ead3b-7694-482d-c77b-08da2e86da6b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4815:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB481506483E0EA96822D628A88EC29@SJ0PR10MB4815.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFkkPIOVzfuRQc+7Z7bdbN0J4m/Y7kDNabok/tT7eD/+HDJRuaOK5VuGhgbA5o1hS5Mqg9A4+O4QrFycqpTvpI/rQZARR0XYbq6BfdNpMbh9oFyFiGBarbj7Gxy4gsH8cHA1CghCpuATTRLaW+6R5BunogWoxoTtorUgyXoAMU312i12cjMKZjUtlPqYFvCdEkRmHl07lIhblpwv+vTzou77WTqztI7bdE1xOT1XOUaxfKM7oxl8Bujx4aR78uzyIbI4UiB/FepfSEXWurytIlRUvoT2RU1ONgPYlKUcBy1KSOaVtvPuHB+3UZLUK19i1H3/bhi38Hoa0yePIcXvyPiVGTuRwHkVGrRYnw3yNMwcGF3VmHOBA/KqGphl6RzeZltXlhPn86X9zUmI7w+Hss84IhDWVcT0wLK6Ya/sgWKc6z4XYWFXxzMtrI1A4SP5KQqfHnS7hZPTIZ8Dad1Us70AS/vyiU7XUFILTLz9yz/sasjN5H5EvlhJ4YJWi/r3fX9m+nVj1wzf5EAfwqbK7j/x/67No87iafpF8akoUwxAfsevlp3A8eXUPfRTTaWlak7SMf2BobQ7FtJHaMGjl8Mx/M0RQEUfqH3iqL+Zrn9P/RVZC2ge2ZADAaAsTOjzQb/m1XjEZNDIxwKYpuUB4EGfmgHMaw67imob6WVjUj4/C8iJOScQ46XvRPdSduDTT1bRZuVvufUQNC7wHjpmuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6666004)(9686003)(6512007)(66946007)(52116002)(6506007)(26005)(508600001)(33716001)(186003)(86362001)(38350700002)(38100700002)(4744005)(2906002)(44832011)(4326008)(8676002)(8936002)(7416002)(5660300002)(66556008)(66476007)(110136005)(54906003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7f2F/7398zZd7v3ndMM8VWZYzMUW7OO8SqNP9eOGLQJQDjq9qfTBu7rfwIw3?=
 =?us-ascii?Q?au8j0lZYtVD+fTM/t7s7FblZ3IeDfiEZfRSgNqwGF5ihTTNv1SGRSVzs84g5?=
 =?us-ascii?Q?PEMcdP2Y5t/XyAwEf4ZPVLPHjnIveJDnh2P2rjG9fntn0TjEGEDVdmCePyTJ?=
 =?us-ascii?Q?8k0Pn1PiBSc50vy+8bgPV+8iS4c19cEt4U/e8ghrG+gxdLJPH8fw7HN1wd1L?=
 =?us-ascii?Q?PykVuUFoetgCmZssXlscbEFimZCQUlxeMDi22A87F6NKTHzt2ZHgFaSs0yzG?=
 =?us-ascii?Q?5uRxWcLfS15ZOUN+uzomOdC8W9fVZvpIxtUZMk0zB+RGeTPXb2Vhq/bjNulH?=
 =?us-ascii?Q?wwnr9u4HfWrVCb3P2WK2Z+YhUeikBM3OAybODswnjcCCaKk4kq+EfAlRMDvh?=
 =?us-ascii?Q?gwh96dL38GfABI1YI1I7tDI5jDARMh/UpGqX3u57ncMV2GfbLBi8ikD2POyZ?=
 =?us-ascii?Q?s2Hnfb7ed8RXWQqj5qOWltTO/2ZZAbMrxGYwCESfAcpLEhaE6FS/bEeY6110?=
 =?us-ascii?Q?+PksKnUqpDFJ+Xgc2wBLjpLNmZpEYyLBoNMCuyFWA9gVZyLlzK71Yj3kK0hs?=
 =?us-ascii?Q?UhTvQsdK8MWsv3Qsjd/bejet8oGr80n7s4WsppfqH3uhSNOkZyplsL7Ve4FW?=
 =?us-ascii?Q?tXQi49NE3/D3XAjht/Krr2KN+bfChFhg5kOxo5f9jJi6TrN/R+lYH36EWfXW?=
 =?us-ascii?Q?umWBNx1ngU4LDQLsyQ2o7JqazHOeXJRZ3+gZkT126Ft/LgzSf4Z5aM3Pm1iF?=
 =?us-ascii?Q?hyIZ6X8hR2RmlpQprA9PKY/BYbXY9Cxclt/sT89dtr72EGctRPSbUXdUw1k5?=
 =?us-ascii?Q?giWIm4IsUg7XTPTtIHai0oAD8yYXZu8lI85HRiFAcjSUmj9V2DHGquiulupD?=
 =?us-ascii?Q?PkC6KEGL4bshir9DLS9vVcSYeeWmMMe0RWxZxm0iDNlaFZqpgO+qIqnkiuLM?=
 =?us-ascii?Q?LFSkeXzLKP5OS7/TX7zzIEytXqzKyDunbOlxLvd6fA3Q3qnfU33Pi6lW27OR?=
 =?us-ascii?Q?L+DLFJfvzKLeS5SzMMyCuDOHN5+ireknRVbzbUPSmdQ7sKCVz+SLKrZmUHIY?=
 =?us-ascii?Q?HRuSNKCjBsfUkhJ9czDSzxpc4C1PZ7Ak2oWF8CTSC9gJJQCsSXztcoGBR/Tf?=
 =?us-ascii?Q?mEf00KoVn9xUfxlYhKEoqDHDAxrlv3pJadZjDn79lo3OfeLVVJcrfHEoXZeF?=
 =?us-ascii?Q?Wg9Rs9ZfcImG6Jp25bz8IZX9x1hglssNx4Sd4iifzRHOlORufoCPLt3lnS4V?=
 =?us-ascii?Q?iDIyIHqMq2saDrNycPEHfgGOsuXnhrlfj9POApR0LVNTmR+Ki886QQzQNQ/q?=
 =?us-ascii?Q?O8JpKtGjbox2Q23IShIgkARQFtmKRty3MaP5obd8c9KuWfVI0C1Hg7/q+ajr?=
 =?us-ascii?Q?Fp9+ZFSpHrBxoocoUsGUyQ1smKW2SiEXv5nNnowfzmvrfmuObokAMa/+mCxb?=
 =?us-ascii?Q?wi2J2XUbA9JamgRhOwfPDHO7PPjt1oY19HivHT8l7Oabn5rQI7zurRkeYEup?=
 =?us-ascii?Q?fkQXEgW/g6K76OcF1xk1i8KZ2fAsvLZH/y3FZCzahAWL+wR5vifbHCT6xBbp?=
 =?us-ascii?Q?i0OIAYObAQJPFs16Z7aKlfdWM2pHt3SnGMuQ8mgmDt/OLomm9RhNUrbQkW+F?=
 =?us-ascii?Q?T+qnXMOAfQTUwI3iVaIB6iksdrBBeD2ddxSPJ9wEYBHpfREKirrkhdi6+eTU?=
 =?us-ascii?Q?A8wqw9SiyG9jNvRg73WvYXcm8ZpZowp4LgSfS6jYQlTENvTsiqcAT4KNoyxV?=
 =?us-ascii?Q?G+flnAlijun8Q4jG/3nZx756uVPLvSA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d28ead3b-7694-482d-c77b-08da2e86da6b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 11:03:15.4463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bB2RB8Cdg/2HlCLwGmzY2CZxpot8Qs9U1ujdDJsensJ+Hq9areKaBp9WvLw7N+hr9Djuh9FgLck278vltBKJG7fdutkH7VSooMXpfdiZM+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4815
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050079
X-Proofpoint-GUID: YvJQc0YQ7PmMexWHm7aHycEGdknB77gO
X-Proofpoint-ORIG-GUID: YvJQc0YQ7PmMexWHm7aHycEGdknB77gO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp_data_lock/unlock(sk) functions are taking the same spin lock
as the lock_sock()/release_sock() functions.  So we're already holding
the lock at this point and taking it again will lead to a deadlock.

Fixes: 4293248c6704 ("mptcp: add data lock for sk timers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
From static analysis.  Not tested.

 net/mptcp/protocol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a5d466e6b538..eef4673dae3a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2872,9 +2872,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 		__mptcp_destroy_sock(sk);
 		do_cancel_work = true;
 	} else {
-		mptcp_data_lock(sk);
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + TCP_TIMEWAIT_LEN);
-		mptcp_data_unlock(sk);
 	}
 	release_sock(sk);
 	if (do_cancel_work)
-- 
2.35.1

