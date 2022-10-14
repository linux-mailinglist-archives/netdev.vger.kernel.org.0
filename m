Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63CC5FF0CC
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJNPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJNPJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C231E1D441E;
        Fri, 14 Oct 2022 08:09:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EExKwK030591;
        Fri, 14 Oct 2022 15:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=x4x7ibcvPinofR/Uo7nn+d3uzZE0Yicr8+c7QRZuVzI=;
 b=P9LnYHYAcGfvM0g58EgVRf0AQAcAkYocE77g/Q238dQxN+JpcLLJehpnGGygUlpGwEzT
 +mi5QH9W+DASAMEqEGdPxZwImyUecqd6QXELRdQ4et3dkT5DxkjyF7Doculdrg2aSW1n
 VLTepym/35Nbhx3aWHAPN17Ea0vfux2dXcUxl4gX2BVJu96PhR0bF5su+cRQN7FhENPK
 1dtuN78fWdNCCwffpXNAyYHYyJha3YvDAiVTwlbGCmQCjdE8/Ch/XR4JTsoKZJYAsBre
 uioKC4qLkiOfLbpttecXsxWdM4M3S0h/UG4qzmgTKWcbmf+JCQRwU5Zx6zZrlPtsFD8l mA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6qw7jevd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 15:08:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29EEOBWW018094;
        Fri, 14 Oct 2022 15:08:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn7n4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 15:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiHPdJPOeLNAVQ66T7M7WgOYjEmCljyvEpbAlJdosClSs2ervJcoJmtn2kdFw+LHDQr9KW0IdfeX8oP9uyj5TLOBLcp8TVezWwP8igGJ98kInQwoAnFs/U07TtAKXh9/n2IkyEk6+aKNEAscaWSJpyDb/UZxUVAprGc14dDoZNxuHk0UQqk49dLIBtcPOpOgqvYpdZA1zekNg87KwwfQajNfm3UhIvx0LWaWfHl4A009Yr4Y8ZT0AlIRjEdmMAp3roB8Iwj5MipP+IdB/FkNSbw6VJkgxRJZnbuCOkBnyZd273y3kGN45ZCE3fIO1bj73pK9rrsPWcPjX/iEnKpekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4x7ibcvPinofR/Uo7nn+d3uzZE0Yicr8+c7QRZuVzI=;
 b=mzQKMxKEpX8zw8vrvGs3XboAYyQ9JJESfSZqzW58sG+BJOpW7Wbd/jOqt37aqx3ndkYHJWZssWe1Eq7YOHhXnIJ29f7dtnu3agXq+racXae2P+vw5gpmBvhUtyyz6EIa4Andu7PlcXQxGeSmFHgTpYSCpgwtpQ6sIxt1aeOBhoiQRBpuf+BNP1lnMgJ6GWURs+q2qud/BeFKcq3gaI8Fd38lmZw2V8lYaliUj4UV34K7XCr30FRbV+AuXSjyhO67fX4PnGl9taxZ8GDi1kocdCLaO03X3Sp9UvP2zNae+5/G2RqjQLrvxA+k13ohcFy97jpJTXbwmSrHyhJqX+5Zqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4x7ibcvPinofR/Uo7nn+d3uzZE0Yicr8+c7QRZuVzI=;
 b=U7kro57S3EkZLnmtNjyxELN6xq5m8p4dSl4YEkbKbZc8IkbgJFfRNzKcD6Af/d4lQorUw2afWznvXEHTddSwJkgEmTKwm080UynnYsAjUwjVhMa3aihJ4KsXBZweHPx4KzmwOctKaYkovHc9FF369kJnzijBZ9GS/Nety1lv2fU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH7PR10MB6130.namprd10.prod.outlook.com
 (2603:10b6:510:1f6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Fri, 14 Oct
 2022 15:08:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 15:08:47 +0000
Date:   Fri, 14 Oct 2022 18:08:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: dsa: uninitialized variable in
 dsa_slave_netdevice_event()
Message-ID: <Y0l7d6Kcs31oErzx@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: LO2P123CA0036.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b5a726-4a61-4052-d9f9-08daadf5fe2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FogJ9oU0Wt66ZrQRf8yYkjQld+sY/Q2NuPPyDZZAqub2AbDLPmIQdd0DHhRGTvMIXI1hd69QEBGI8x1wku0Fno91dY/15fP3YmYfq6pouBbHituL22DOqkW3wIOe8Gf92pZzmj5br5Tm7J89xZhMWHfsuVWnJHsHsAxduXm6h1Z/1bnJ34qWGImwxkQuVp9EUGK8bNt1Dbi/lTdnV1mciOnvsWJXpTRwyy0SNYg8q7aNhr6BlEQBGHXfNJvESQn/xWI0wdHbiFxfQ/4eEd5XEKK6o0dAjv8kAbiy8aHB1+KVfMYevbcFo5uRE74X6yigAWfuDUcJW9w84XQ31LM2BMkeid7aznynPamHX66zlICKueKkP+V5U46mPfX4WhURiGUSS7lAb+pqkp/fgZcnPV7TmK9OI98mNuE7D3TiA5tPLnI583/NIlzGg1lO5djB41WTT/5RfGf5NzYRJABboHJz1tAErV2K2/eO58PpGk8sNduPeILtZWJeiquY3IP5iHh8d3TEXj0v6dTEjeu5CkGDHcm5QX2xQMbzccgRqaLhufzDVGoTmDXhEMkFg5n9Mu89Hw1Gi5TR0AgswnVmdJoLW1Rrbnq5r3uhEJ93+X0Ey8wGy0G3FqGtzutSoPiKecIr1uDIWKO5TdrqbaGIkdXLTJyzhLLAKuqoFZZKHDsa9rsWZGi3rQTdrjkXND9r2zwAuH+6dCglKPeDiclcuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(2906002)(4326008)(7416002)(6506007)(6512007)(5660300002)(8936002)(41300700001)(44832011)(8676002)(66946007)(4744005)(9686003)(6666004)(33716001)(54906003)(38100700002)(26005)(86362001)(186003)(66556008)(83380400001)(6486002)(478600001)(66476007)(110136005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2eSRXE0c4a1dvQ1/y/Wv2UrDfdAp6nSBuAlikcHAetyBSpC2q3ahjJpZMhg?=
 =?us-ascii?Q?6PQJb2s2YuLZ/+/hErihNtz0vcqpL6C6cMXPyYUHwerIj2QRIdUKQb8zdubT?=
 =?us-ascii?Q?W3RuO9Qgg04+f5ibwnzamHK1DnKrGlNrPQLTxfWQ5Ebcy6EsWchev+thqrNt?=
 =?us-ascii?Q?AId7AtvgzQKSWVOoyymGC9Ma+eUY3qLWn3ngtCCxO1mykPniPQBWBTCwcW0x?=
 =?us-ascii?Q?N8cHbEk6Ge3B5Rh1h9SgM52CiocyWgGLSV/GTfr0JiHMbjM8aYNQPnUzy4wz?=
 =?us-ascii?Q?IYFLY/04duMhuzhpwLGZSjKhS47QiGo/yfTE7IO8vG5ivm9N8yGZID2ndeUz?=
 =?us-ascii?Q?7C9I8I2RtdaiciG5CH/+z6A/uKaXMH+KCmRntZrIJv1rmdbaOf2phdbEdqlM?=
 =?us-ascii?Q?2ueIt6/pKEyBUs6UFo5+aNxlR6m658ZeuSZeN4bpGGCEke8hjdo/YLH3xIyo?=
 =?us-ascii?Q?0XoxiEnM1/lENcbIszwRlE6dzSPyqRYVUZyTqZIl5IY4iz5IZp197QC0X6ga?=
 =?us-ascii?Q?up2VxIEPkV3luexUH1XDdPWUU61NL0zCPiuyXEuqXJvR80n7iu/j2raIAnUR?=
 =?us-ascii?Q?KagW304XJsZ/gNZl/I6xLF9aF2MRtbjZYASg7ZJc76XwYgNjRxQZiooBNmdh?=
 =?us-ascii?Q?Q5zrlJPV6oQCP5adUGzcO58u5d1qZUYxpZtbjbPi3QeOTCtD+JbA/ixG6+N4?=
 =?us-ascii?Q?nrsK29N6GwuanrzU28GH4M6XVySY06Q1TxSk2Lt/JNv0+uDur8RI2enz3X5z?=
 =?us-ascii?Q?sWWWrJAcbPQn4UQzt5vUqV3bE1JrMN4zrrvBaN2jTLi3nLmoo7MHQmY9Q9gC?=
 =?us-ascii?Q?w+BIyoJwpT1tjB9Z3s+dzw55zh9PoggCMvuPsKepIWQcM3fNNIVh+FYXTZt8?=
 =?us-ascii?Q?C/bLjgvRCxRuUPprSUmnAGBOP5qj+LKP7pe+22ruPtzRTreKEaLfMYKTspOX?=
 =?us-ascii?Q?vIvSvZKjVa5sI7neM6e3WDJ2oG5eLNLMgsAD2fNO6s+SWAeKhC8VTDvl49Zg?=
 =?us-ascii?Q?I1MBqQZS+tnRX3U/fe0O3646J+rJjNZ/mSETBP87PctVzURrzQ+4M5tqk6hp?=
 =?us-ascii?Q?HaJo4TLA3fYD63Iyd4kNwtp1AiWGIbdHYwAj8BZA591T7L6IVdowEs+Trh+M?=
 =?us-ascii?Q?xixSHE6x0Fkwd9XQqduUhL5JrDFmSqa6sGFqKa34BBJyjDie/J8LZdysYYm+?=
 =?us-ascii?Q?Tudz3XmwsGNSyUkzHX+tJzfV4meWTEfJr7CTpWJdDnUJKlJC0csFc3OTnQDV?=
 =?us-ascii?Q?HERe8WGzo7PpZD7BnjZrlpdTieKhQPXkaSK33b/8KZoS5I+2RjEftBqOgxpq?=
 =?us-ascii?Q?scuFqDPY/NygYFxRhtAo6XG9KT+LHH8sbsc7/0dNi9FZqg2ru1dgLZ/eGmzH?=
 =?us-ascii?Q?HjN9IGBuyEEzaoLh26Uf9YrZ4yvOmQF0dEMWUmbc22T+jQrMeObgmj2+AicH?=
 =?us-ascii?Q?p3yWbWg3+J2UaYD1Yr6ob+40W4Alq5nL6R+M4bXc3AWMNfcNDKfyNupmXssx?=
 =?us-ascii?Q?tc6Jnoht05lmwesFvRS7L+Pk/HNEwCgJFHMnDw+OVk9Z3pXkZAZ6UaMx4LS6?=
 =?us-ascii?Q?ksIVQKoFtku8UVQELl1Bx9Z4ETcLty03EuhsX9c+aluPzG0Z/h1iB2qMAvod?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b5a726-4a61-4052-d9f9-08daadf5fe2b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:08:47.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZCuwByp8TaqZMvqVQ+JdGy3tsssVT/dpKA0su/IoLJz0vNWu+ZzaPfwLgqmg60TWJO9gqSMpl7a3Dc6qlJFYO9Fgzbj7QupMFa5vuRDIiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_08,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140084
X-Proofpoint-ORIG-GUID: bl8reZV4cpoSc6KG-jAV3-6UVZ1k0Ap3
X-Proofpoint-GUID: bl8reZV4cpoSc6KG-jAV3-6UVZ1k0Ap3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return zero if both dsa_slave_dev_check() and netdev_uses_dsa() are false.

Fixes: acc43b7bf52a ("net: dsa: allow masters to join a LAG")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
(Vladimir helped me with this patch)

 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1a59918d3b30..a9fde48cffd4 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -3145,7 +3145,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-		int err;
+		int err = 0;
 
 		if (dsa_slave_dev_check(dev)) {
 			dp = dsa_slave_to_port(dev);
-- 
2.35.1

