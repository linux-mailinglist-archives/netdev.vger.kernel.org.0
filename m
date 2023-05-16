Return-Path: <netdev+bounces-3087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D03705683
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81E4D1C20BAC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AC5290EF;
	Tue, 16 May 2023 19:01:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C97187E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:01:40 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6542CC;
	Tue, 16 May 2023 12:01:20 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GGUL45023819;
	Tue, 16 May 2023 19:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=W55gsDJDxGC36KP+ew95zXjJMunDNjR7NGSLRYYGnsQ=;
 b=j9srbSrIXXQZIprvpJi8A/jB5eRIiSRUs2hy0kkptH58I78u0KbFTvU3ZmjyWdCNB8Y4
 m2G8hfnZs2KSlpIp06y/wR4+bcf24k8nTiKG5j66QIweRx4oskrBvJf8OlAEVkLczAXA
 yNz2FNGEEuI+vFuIcciggH37Opq5BcVsrsqr+Qjc9bPD0WA48UHIkHCW7wB+XjR5x8HA
 69LEy4P5MjIR/K6ExTGt80t1pvnzVjVrI9nEH9dmtWS1h9/3StYUwE63+ZlJceWRJxsu
 a6S5676M6VHIo3ayl6+2K4VaZibG/iTtn0sB26Uo/LmJbE6edRt+/sWYpYfwxGct2inX NQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qj1h8u5kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 19:01:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2Np7XMQflJY6kMe8MfvNdcTs29ShYOT+QzE8t7UNCg0zPeevjxKvqcjswZi8WT06YBuqY6WJIfGoNMXdwg45ukhuSCJCNc6FNWDeO8giicjgdNrkd7s9wcLnDafEX+1BKA11TuzvYkdZPGNjE3akBORqZeauHqId4tDWS/jUTa4jkrB3S2EctS6b23jB3lCTpNQLyYHRt2dx7RExS05MnSoA9ePqF5k2/UAIlNEH9+WCOYlCLrA2llTFEmxFnHdwDoAmUG1bhia1ZJfpZ1gJ6QnRM98vekJ4vbXEn/7uceF3Y9GDsdGfYXWTPWHWZ0ggf0RUacd4D/NXrNYR/YWfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W55gsDJDxGC36KP+ew95zXjJMunDNjR7NGSLRYYGnsQ=;
 b=IZ/F9bbso3wQN/3S/8MMMsQ1aVoFsK+YzHV08BmHzdk7vME29LBIDERPIjut8rrvkmh0KMy/LvCmnOOBwgoIoZG41BwA6Vr7YAytV3Tsi+ezLIhApkkb2jiCAl5hSfthzAWrhgw1Zdd21rskFrT7vD8V+e+x0rCN1MTpzqQdEnIDIN6rBwx5v3sbG4dV9Q6/S3HZOaQM5pYaGaYcug4BkaXy5MG1Uh7Bppg9h6DgBH2I4vnutbYzQnX446y3n8atujvnPBWxLRReHtdLlBIjja7L8tu627c2ygrqW9XmdH3xo0ZSVpJSHlDo24FgWQnxrfghZ+Fs3AtW0pkHfnRUvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH8PR11MB6706.namprd11.prod.outlook.com (2603:10b6:510:1c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 19:01:01 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 19:01:00 +0000
From: Dragos-Marian Panait <dragos.panait@windriver.com>
To: stable@vger.kernel.org
Cc: wenxu <wenxu@ucloud.cn>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, William Zhao <wizhao@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 5.10 0/3] Fix for CVE-2022-4269
Date: Tue, 16 May 2023 22:00:37 +0300
Message-Id: <20230516190040.636627-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|PH8PR11MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: ae20d9fd-e68c-43f5-4e75-08db563fe2f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	L+HTAz1anOeHqfkUh+6QYYsPHOQHzAGnP4gyl1q2ha8QbGsBKFaX5UTIXMb+TQA5BxbwJXazbLD+CYyUnxj3e3KNZlMZjR0UNftRr6hoKWHDn8WvCyiCNNal9qiIkriNZ0HQbV5q39WnC9Fd2MQ148V11cJjwxAJ3PVrYiEiXPd06MsJMWT7nnjQc0XwM8sGWCNf8A6RWLVaMkI2jH1X0wJVlfnFdIRiEtnQPSfHtcgVNgBbtWc0Eg5wNhcg+3DogSfgzNgrykUavVGbQZ7KD67ttKZEZzU8woKrclzyCcVPt1EFCfv+Z9xajuC7en16DCo3fkfDLrTam7tbrXHpgGpma7Y2A2U3BZmgrCQTuxqljV4vdWhHMY5usfOvFWqfoXk+gX9QpBQOmMiN52zg/e7H1yIHO9vXbDtfWbhkg6zA4AoZ6nzEK1Jbbwgw6emYnclnRJIchFoS+w9eBWxTouUEFZUsWkV3M6V8e9bE541vfGkUOH62eYOKfmdo+JVW6edLZN4oWX+7L0JJkoWxpnryg8sdkrTZylj16GzZKMs4LjYaFSs75SEvl9zTljvx0njXl20VJTP+hjIb3KrDqISXWLflS79PTadCILckH4u1eO5dVvBZCwZDq9sa7ABZ2rSVqdSKIx1fAN+13VcBKw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(451199021)(66476007)(66556008)(4326008)(66946007)(478600001)(54906003)(6916009)(6512007)(6506007)(186003)(38100700002)(36756003)(83380400001)(2616005)(38350700002)(8936002)(8676002)(6486002)(52116002)(316002)(6666004)(966005)(2906002)(41300700001)(86362001)(5660300002)(26005)(1076003)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?pVnrOGkQRYkOONotnvZM6EEwE6yUyUFb5lNAJiALHsV4nk8ehWs7wK9AloPN?=
 =?us-ascii?Q?EhyYTgCToo20WZQyfhq2h5ezETflKg2Fayt8n1GO9jRjlIzBt+12XJlblI8M?=
 =?us-ascii?Q?wBbcnOEm5BByTkoLLzHu6nMP7Qx0Zx8BLOVvxJxPd9h4drQFqDXOv/ZjOFws?=
 =?us-ascii?Q?IYZr/fSj9MQAeayoT9ludLAnummbcTx8K4cei042gfYoNjTZNXeljUpmvEo6?=
 =?us-ascii?Q?tWo4XKSwppLQ3nYyBNHvu1UngPeNizoHsW5oJ7EUe1XrmTxm6EEFFVLEgQ5a?=
 =?us-ascii?Q?mrfL+IcNeUsFNPTiP5PuKoqQXlTsiHvnkw58wFDJ/kPF9Bt0rkYl7iisa36s?=
 =?us-ascii?Q?gW2YFK/p15iAVu77SNfy3VQDixVzqYqw3+PK65EmQNTWH26nDvUD0xKdLT4R?=
 =?us-ascii?Q?wuHA8ZqR2b53ACx+4mR7HPzcUKv3RVgr8etVS575mUlSzmuzcie8EQL2tBjT?=
 =?us-ascii?Q?+BA3tZq/Fxb/xeNASLTAOncWPAyhPV3CD2Gs7BabQfTeX8EqieKRpMY2VWYS?=
 =?us-ascii?Q?QgilWr1dmkipkcR93suKK/XAeRI4igYq54p+S1SFBfPrIWOzMSqIKPWeXZyk?=
 =?us-ascii?Q?SLxpAgDuU5bbR3pQx07986dB8aJ8zRHNeR/SA4okfUK2tcKSHEvh8viPPaHf?=
 =?us-ascii?Q?Smc+SEkAiqi88xOjSSlqRDUuzbJ4vpbv3mzqjbyId/hs7K6TDzwcI7DExYca?=
 =?us-ascii?Q?ouNJBDbeoKKix2uMkGjAv9JsJUS03g0MdOsO6eN+6zn51GaiQAe4juOaIRoU?=
 =?us-ascii?Q?IEN/ZwYmrd0x+uwE4xSOIFEhs/4wiXqmpXzXM55A+aT/sxw3PL/hTxQr9GBX?=
 =?us-ascii?Q?DH3SoqFyGAW4AQDbJM2CCMPFps8K7+E81Y0QEdqOOAjJMURpYH5E4A1xVBcb?=
 =?us-ascii?Q?zBVvVmRXZWkhSeHQ8OiszZ+4gfbM92pQ/n19LzSa9zK8bLHXvYrFjcyxg/59?=
 =?us-ascii?Q?U9Jx3kt3uR19ms30afCsh5xz0WoefeoiKW5iSXkRpP2YcUqot0tcYiSZ+2ku?=
 =?us-ascii?Q?a8ijyVBZaKL6zqtOXu9NTAuAnh9bHifU1gwL2sRhs5m3MWJ1IKtH1MM/R6Ev?=
 =?us-ascii?Q?J4JseYXM9fCeqYX1et2uuSYtoRXhBexrwv1SqxnlB7jPNwtL2lHVjOKCeBmU?=
 =?us-ascii?Q?nIfsdjFjlRk+8yiAubzAplx2LZOL+DAWSuSvEgXcHLB9PjOiA+yOsGUgMJ3P?=
 =?us-ascii?Q?RWj1aaTrtfoidfWZR3/LOIJq5yGgesbXZPSLx2TlMPp/wA63Ibtoe58G7AxG?=
 =?us-ascii?Q?ejx8LpWt3Orqa2O31Pxenrma77p03wLRoUcL3xey+wQYYC7yEd/Hn+Bh6QqF?=
 =?us-ascii?Q?jdLqbKWzcKkkOYthWwkv5mL+t/QQTzDdTG5HblI6RIcY8lf+7fC6PEm8/Nct?=
 =?us-ascii?Q?CDfR2qlFJLrGab/STNQUA9V0FWxTI36yM1ZDloYqT4rFuDJQVyKGX6nffYnI?=
 =?us-ascii?Q?AZII6pQv3S7+idyWDbJXrxnEeVA6Ah80JzAQYzcfEjloQzNIpHYQjUIIuB0K?=
 =?us-ascii?Q?CCo8+TRt8R7Wai5vAxY8HKvYSK7R1IK15H1EeKdAocWdg/AperlQ35BDeshm?=
 =?us-ascii?Q?jTeVI2DgkwfJqTn87pGYGEpB3IKXuvyu0hdkkgH+hWs6ZVNXQ4GmWm1pEPqM?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae20d9fd-e68c-43f5-4e75-08db563fe2f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 19:01:00.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvYYsIq6vBzZXmZCMlRxwYUpvgPPQaae6cjOxY3dnNOCTDtKHUyVuNx2vDFn/o2QCVDbq852quzwrmK+Ak9tzs8CAaJsoYVsOO6ozDYH9M0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6706
X-Proofpoint-GUID: aRzob6Cfi5PRGC9-eG_vDFudtpd5BNV1
X-Proofpoint-ORIG-GUID: aRzob6Cfi5PRGC9-eG_vDFudtpd5BNV1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_10,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=552 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305160159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commits are needed to fix CVE-2022-4269:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fa6d639930ee5cd3f932cc314f3407f07a06582d
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=78dcdffe0418ac8f3f057f26fe71ccf4d8ed851f
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640

Davide Caratti (2):
  net/sched: act_mirred: better wording on protection against excessive
    stack growth
  act_mirred: use the backlog for nested calls to mirred ingress

wenxu (1):
  net/sched: act_mirred: refactor the handle of xmit

 include/net/sch_generic.h                     |  5 --
 net/sched/act_mirred.c                        | 44 +++++++++++------
 .../selftests/net/forwarding/tc_actions.sh    | 48 ++++++++++++++++++-
 3 files changed, 77 insertions(+), 20 deletions(-)


base-commit: f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb
-- 
2.40.1


