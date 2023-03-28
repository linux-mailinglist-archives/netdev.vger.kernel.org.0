Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7E6CBFD0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjC1MxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjC1Mwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:52:42 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA31EAD1F;
        Tue, 28 Mar 2023 05:52:14 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SC1dRw012758;
        Tue, 28 Mar 2023 12:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=oAibxR0l1iQiDpMwE27uVcR0pOQwDK7dExTJErWS+xk=;
 b=SbnfNuDzJTgEvztXw99TJnATmpBp82lfxn2PO2daZ7KxH9vtYficR0zRZsKswAPfsuUX
 l1HaBH70Xj8lR1CQ7ul0k0yPJfJ6dnUyM4QderMmQOZc8o8sj5iDnaC5eq/0fGaaiPew
 HVjVhiP7qN5jKFgx2fp37ZWKZ0BZCn/9IeMpnbicqFgHieUR3bYirraajsAMEzXBsjDZ
 yI0NlehI1NAWlxDDKORyVn5O8osazijCtySzGwtzE3IufEiTSD9oAx21dQYtAWlcDzve
 mP6aO6M3ZytaDVp1WwwcRntnWFWTcNYStBHoUrTB+waiThZ4NVKdWOeDDUweQa+JAIkJ ZA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3php6439q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 12:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4ei1b7nwgwFkyADHHeCqIPhsPjQC2r3FVEjxsraDh6LS9L6zpJzAhbQoVTPEKNiYTm/yUXmybVTpftTPgEr2Nderb0KH7ERXxSg9Q4lb059EYKCxO/lEu1PCxAbP3NJnJIWh+4Jdq/Gwcy/RbN42G8Nl3mJykCDzYArsSfe69PLv6k4Km82W8VnDVXdZnL8xdd++HBB4XnuwMtKJGz1A/33cbi1BK0JHIaxgZWE1LDOlYM8KUcEJC14ZN/25sRDhjktmEdAtRRF6OiTsIz1G0JvDleNE0LmDs77DZ55LlQzsBS9XZ5UOO+v5buuJC4bHhk5D1E+u41dEIe5PuHDXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAibxR0l1iQiDpMwE27uVcR0pOQwDK7dExTJErWS+xk=;
 b=ilOILQA4MnT9A/noCSV1WISkFUhi0pgakjj2sddnowOwT/rsMrn1mTK2NGsjYtZcucAnoH2uGJDV0hgOQoZllCmPIBtG1CAVXUtxEDomWDuWr3lhetYQPX6S13NcNQCXx/b12cl9g1WkBll1yo0VChsvICq2/7dCdTarZ5bgMQlViDFalOahgIyR2GW+RsT1Zc4rUTUphUoEX1E4tseUeHJJQA3wK/mlKsxDfksZWXlMmtzGxYhDLmlVTNXTgfkYRDsCmjFLf/OVTryy1ixq2YMqG0Rwgeh6Mt5TGATds1NkYmMdwqkXsvE63jkKEyKyGCm6iSsBViIefcC8VxHJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 12:51:21 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 12:51:21 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 0/1] tun: avoid double free in tun_free_netdev
Date:   Tue, 28 Mar 2023 15:50:43 +0300
Message-Id: <20230328125044.1649906-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0020.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::30) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|MN0PR11MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7a719b-1ea5-4cd9-8622-08db2f8b2137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxnqF3xRyzIqCiCvRiDjkOphm52aIdGfHOiBipz2eij6MEAPT50KUeNae1cmUYw3TvUU9pFf0bMUx9moiJiqKPUoKptid00Njb4i33/9fcuTcyyrCpttltNwGuteyaI4W9QtHBiDMqqjXzS3IVR7WhiPdWDXL0plaAN72Egdm97wHFU3kf9l8vHYuxA8s5m2606mhIi8waU3ECoW+mpuy+Ll8AQtg0Zbhy5OjExUTy4pDJbbT50RxjQOnjYh6BsguXjxMnmf8qVNr1yI2Fmhb5IeMFUtyCRIauTjuF89T5NlZetzxDAhoqZ/E18LSmqM5tR42HCuaE62crbwUM3UK1sKk1aV0svcBaaYtg2xdRkFAk2Fln8+xG8a8lVtGjkUaej/YSp5IN4Tu7j3AKxiZY8gF8S0fTngpK+qgtLc8mnarU5cHbo9bBf2Hz1eO+CKnp/fo+T7ynWqOaICPIdTbldcITFZi2fqtNl6v8Ns/Buv3VoZCkuexq0+qqf37u/ueI0sy+pk6P7dOTU9oESN7mZTm86/VpQ4sNTTEX4uDNiUk6FD3qyuglD5gGJin3IFfce/pRWQQmW8FDRipJyw/XoyaLQUUEpwjdGQWU33AJY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(451199021)(6486002)(52116002)(966005)(4326008)(66476007)(6916009)(8676002)(66946007)(66556008)(41300700001)(36756003)(2906002)(86362001)(5660300002)(8936002)(4744005)(38350700002)(38100700002)(478600001)(316002)(54906003)(6506007)(1076003)(6512007)(26005)(186003)(6666004)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/jOwp7n3A7a2lDlMQxS3aPfXfsfQRcH/hWBKZdx8AkgIUy6fytIAXOxEeeTs?=
 =?us-ascii?Q?TDVB27BswqC6t/mkvjwn0J6XKDNr8Gtq+HL0Zl0dgMYxYCImWKGKZt1Q0ucs?=
 =?us-ascii?Q?GP4fWAwmesqg7njMiTpuPyKzmdmeq3Q7LSlJ8Z0631/X4iNrxiALQhvpaCx0?=
 =?us-ascii?Q?LvSD0q+iZa6YFwHl1QzDl12RK5thleiyH6A6pTH7bKE6QpenIYcf1ILDShpI?=
 =?us-ascii?Q?OX/roXUfOCFCJSpBYKK5sjVamfh647rXIAWTqhYRBfqwkEijBmfRJT57GbzU?=
 =?us-ascii?Q?qmXrhWu9EubYRTlS5HEkAUC9vFG121TBmzzZK8RlJFcQPLSXY9TomVRNXEqi?=
 =?us-ascii?Q?ioS/KGggDq1dapYo0LFoREJUV9OwhQdFBMu5L26NrlAdv1LSuPMPZWq6xZF3?=
 =?us-ascii?Q?pRFPxHQFhTt57quQEr2uLDUp2r/YGl+1GdC5SQ/ClmO64Lix7wQqb0qQrbNe?=
 =?us-ascii?Q?PJ7GwIz9sYtVPEyFl3b6iNA2+iG4DjD+ilaRzcuozjK23zojQVCuyZ7K2Em4?=
 =?us-ascii?Q?GQnWCyD5ZBhzCV0FjqOLnUm8rrkvJOM0T09CwsXBFuuw431FZ75QPzfpH4cn?=
 =?us-ascii?Q?wYvw8qe7eEM00TbcKJaImUFX4yNK0vL6IssT0w6KhyB+Jgt39NqpjjX/nSMx?=
 =?us-ascii?Q?/yz5qiNtXAB0o6za/cGe3G+WRBrQLZcPqyIuxKE+JV3QDOgxwFuHgkS3/eyM?=
 =?us-ascii?Q?gPOvvTH5adX9wWwnWjSTfQspTuOwSbLhZllQZWCBooe+jR9wH42yx6VYAwgH?=
 =?us-ascii?Q?492rg0I2AJbPR89U99nhUkhelqD1AWVJ4sYH39OVvXQBOj2Bjoc+23KRjQYH?=
 =?us-ascii?Q?KOWl3sJAeDN6wF0y+5oVYE/M9z2VoQ5Pp1QeUc6PPNNH6qpzhmEvY4m4B6jh?=
 =?us-ascii?Q?jLAev8SG9uZfLs8BLC0gxJmjxgJt8btamUYH70p/tuvdnSBbGymXlKzfw/lb?=
 =?us-ascii?Q?rnQglCnAjKXMUO56qsMlLe4mdaAsVFxgMohY0OmWikCJ1JJNvYJVUZ1+cVAS?=
 =?us-ascii?Q?oui0jxbF2iRPib+QDyB/Iv8AnbXnbEBAnjMC2f+ozsVQ88WPyo4zsehaGuZT?=
 =?us-ascii?Q?K98nH5nI9REYQS4MmYmTB7jTHASS6jIIQdGif4a1+K5xcIjNwa5fsSoJcX9N?=
 =?us-ascii?Q?aVZsBjr/1wc8O5qOJvdxY9hqd1TuF1saAIALeiTOTvY/0/sBrVDDzckQxI40?=
 =?us-ascii?Q?Pl3CMkAVqojw1C+mEaVp6BisUAYvX4l4CbJV3ZUYsimy/b1Ry2if6PhfvqWM?=
 =?us-ascii?Q?cKWvNkfvKv4eNNX9FOY5FOsX90X/STUtfqyeUjrvlQCGN0NFiFxHZmmaTrSJ?=
 =?us-ascii?Q?yCakfebPNchTaW+eU/1YIKOydbsrxJfOIrjFgNbk/EXb8ksWTiSSCAAS1BCk?=
 =?us-ascii?Q?Pea+xMKCgnzA8NT/16mdDwj7PbnPbA2UalN5KdvPgQiOangrSGbpQKCmpMV7?=
 =?us-ascii?Q?b/lUhsxsePKEYpmTtPPxKQ9tmuF++Rmd/i8k7N2YoYh10JD0bC/Z3nxDv/Yl?=
 =?us-ascii?Q?S3dEKGmG63z53WnX7NbCLVHgbW/8viyo5TlIY6X/tBcdCoTjgoZ8Vmuf76AX?=
 =?us-ascii?Q?YxbcgyUez8YJE59owjV1L9XPab0VOnem0jJ0Qk0O9BYNK4u2cXUzqq+EhWuU?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7a719b-1ea5-4cd9-8622-08db2f8b2137
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:51:21.0725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDQBuwBfsZ3tzRSvHPgM0+e0GT6mR2+yOqo//t7us7BMBybw1oiQJbh9a6jEmKD9+6KDH8wO2FIlwifrqODrIcctpmionJVADsDwb8jhOC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-Proofpoint-ORIG-GUID: Q1AxBaQkcocszJP3EYkjfGyN0UZ462GS
X-Proofpoint-GUID: Q1AxBaQkcocszJP3EYkjfGyN0UZ462GS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 malwarescore=0 suspectscore=0
 phishscore=0 spamscore=1 bulkscore=0 mlxlogscore=217 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxscore=1 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280102
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit is needed to fix CVE-2022-4744:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=158b515f703e75e7d68289bf4d98c664e1d632df

George Kennedy (1):
  tun: avoid double free in tun_free_netdev

 drivers/net/tun.c | 109 +++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)


base-commit: 30baa0923a27fb9a04444a29562344e0573992e4
-- 
2.39.1

