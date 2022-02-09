Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC6C4AFEDE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiBIVCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:02:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbiBIVC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:02:29 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CD1C03648A;
        Wed,  9 Feb 2022 13:02:31 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219HJedD009754;
        Wed, 9 Feb 2022 13:02:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8xd/ob1Ypjb0jK77Joby0GsQr74W6NMs2w2jVda+iCw=;
 b=PaLVvVp4LWwSD8jyGbsDVexnCMT8N1KcCLZR4/L1o7DCUyjSgFIYoXrDLJibBoxMikEO
 DJ5SJKzOugygnphEOKlSAuoenNCYQa8Q8lJueo/c0rElppjkLAxLxzoiSbpefUpfedqQ
 kwLAgu4ksDFICxONIyw/TEWFumQTl/JHFBE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e46735v2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 13:02:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 13:02:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9vLuRpnXUxcsA2WWMLIz8Q/CwnnJXM4tRCBEovJLzP+86wqImtApizZp9Qz3PgOg48lEOLzafQkUoLux4mkBv3oAHAy78HTQ5q5iXoaU5CSn+1qvL7KmofLXZ1GWIgI7oCtZGle9lJSIwijJ+aUqozLLka2noeLVkiCHIrxbEbU0P5WmEcDzGK4DDQXxnO/liQe0Tv5WGhchUgKHwgMBe1nqAUjTTRZyy6wBhAA7tRnXAC3UH8wOCwox4XEM6q3LzHYQFdeurpTEETD7SGaAgYquh1TtcSvtxdWrfWoMZSMsEC8HCr8oTW065GhOipVlVybQQH9QCyhsg8e1SI+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xd/ob1Ypjb0jK77Joby0GsQr74W6NMs2w2jVda+iCw=;
 b=a8OcuJy0fDxPQijGQld1SjfPb2m6Ytx2Gxfv7oXS+9LgQC+F4yQRonL0t18B6YQg6++g5yDDGs6zbPniNk6hSd1+08tP7BNE6FV7TPeP6Utf5jMue4hXMsxmouQJuerLYk2VY3oBq4qRjwuF55bVE+omvNdsHOPTt2auHBn03z/6pqZQVzJdsIHjUcJNEbxY+0+rFPRmTIGiwCFaQm20IEY9mGVv2/MbqVTO2FmE8PseFWmznMQIK+5gD0n/x0KKFq/3TEikd8a+C26CJTidODGqx6UmO7XFtTl/IAxDg/HUS/fPUzlfb2ZSnJJ6jMctkfqtUuNmjpqY3hM0EPG6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH0PR15MB4149.namprd15.prod.outlook.com (2603:10b6:510:1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 21:02:11 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%7]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:02:11 +0000
Date:   Wed, 9 Feb 2022 13:02:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: Override default socket policy per cgroup
Message-ID: <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
References: <YgPz8akQ4+qBz7nf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YgPz8akQ4+qBz7nf@google.com>
X-ClientProxiedBy: MWHPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:300:116::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b3e0119-a525-45da-297b-08d9ec0f70ce
X-MS-TrafficTypeDiagnostic: PH0PR15MB4149:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4149A07690F2E19523B79794D52E9@PH0PR15MB4149.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ogmW8nHW/U9StcuOa3RMiFmlNNCls8+EkeHf6T5AevCy7kLeEbBYnhs3585+JrKVdzZYtZViJBO1aYSk4/Bi02XzqhYv7L4AVqwViFkDdhnB7jMk1i1+jOaw1j0ftyQUeeU3XUtDwxmMEXvZIxHxaRkjVNxcA+iub3m8V9ywfzz663c8nidEAx9o1x+q07aOH9Qs9vmMEEv551lH0TNkKyihQ27Vk6nmU8LwX5C10d2twSaRId62AcnlHzWCP+YabbEkCldI+BIdCwv/piq4rNxKcgThY0g2X4SzlSeNHMmrYAfC5jKrZ2IGB0xPylsxqd1c1Zo2UR0+8Z+4g/S2ieWhji5qOAa6T91/Uanim4VyN63Zgk55UO7a4kpO7JCUr2TObzFXm8BUDspT/xLtjFc7q7pgrA9ZvLHdRoGzRAI8MkUo/AxUOdoLRXf6QYQ0cys7iulm4ykXZqHIBgGJ1ANhMlDBJP2HSq5G8/eeGv8XVaFgzPKjZUjxwqOCQPPew6TWeMtW0s+PjExQRsbbErfdL1Lqv1Ln2+FtTXcuzdZgWzXwQDfrtYIrp6SGwEPce5wo1/qvGaoi6N2Baa9+/kDiS+qBaUdF5aOzQ5tEHi8KN3iAvdHKCBduRp4EHuPPn6OK74rWv2Ypp36Skhv4Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(186003)(4326008)(8676002)(83380400001)(2906002)(86362001)(38100700002)(5660300002)(6512007)(6506007)(316002)(6666004)(52116002)(8936002)(6486002)(6916009)(1076003)(9686003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jg3e9pAdnN87fQd5MgpwuK7qe+REBPKSLsp+POJQ7DQEdLObt0Ptw0T/8YXl?=
 =?us-ascii?Q?YcV5q/dG5XMBxDR6rnTb1hTdw76iKZ0diLOSEZSIpvfbDsqjBsQd91jwniwf?=
 =?us-ascii?Q?shrYuSKZk2go33fY8QVVYUKq5BdxqSheF3QxLdB1t6iR3SdnVtSPXXoSWmQY?=
 =?us-ascii?Q?62ALq97yXB95U2VyqP5Kd1rY7xhnD7L3Ntl5vCqL0Sp6arppmV/I3Ql1cyKW?=
 =?us-ascii?Q?pvrE0aJSmO/LPVvHhndAoZANuRJ0hkWxcKxg5JcpndD1hSasz2DaFAIBfhXf?=
 =?us-ascii?Q?C5nIpKplJ0LWW+xb9OyqaDp6GBjkpnxT7P6KZSOtRA12mAZfWpME9ZabuRb6?=
 =?us-ascii?Q?teb5z6YIMbJIbRxjoBQ8pus7oK7vTwfKOg3kb3LkOzwbIz+ONcn0vG00SHpq?=
 =?us-ascii?Q?w5hvBk3dKuULWlsZXDcMIq0qGejtGAjHLylc3+enf8QXGgqu/fMeNQEMsofO?=
 =?us-ascii?Q?aoKlTZCdiqwPP1Zlg6Rt6eHaTg3eeXMbaQDT82ztO9Lk9zBnp0bASG0WruZG?=
 =?us-ascii?Q?Nhe+ToHUK2/d3YNLqx0nCyK3ujt7BuSPFFP7p5/1uuO3gUGN+NjI3cQf12PY?=
 =?us-ascii?Q?7OK/7Ng7KGFx6V5RQjgl2i8a+/yoLHbqwSv0tWoscWZflKBcz6I/d1SDK6TY?=
 =?us-ascii?Q?p4YVJhuE3oEfw4hfJDliXTR/VhDCWEBwzEMn6eLKsPCh32jdLijCmVTaDpyB?=
 =?us-ascii?Q?lXDeB9fO+/EO4p+Yk5rX2CrVhhDAWJEhDQatiXVBHIZ4NIjqCEb7xHZsJ3wY?=
 =?us-ascii?Q?9Ws3mWGkml8C+v7Durng9f2fmg6w75GSwDogCdZ5Tt/qfpgZgzKoikMHf2Sn?=
 =?us-ascii?Q?7O51YV1y02pZ9nEFH5JMa3msXI4/ajA7mrVn9e0rzJFEw8VP2Lo9yvqFwJWE?=
 =?us-ascii?Q?7BMJZynq0npCDL3gUNMsmbn8g0cT9mAgoEOSMtJg1tYgKTK7ZESNTy44zYUE?=
 =?us-ascii?Q?zPrc51mbylkoZzBGTnyjHphoKal5vzOeI3fHraqnWPy36QpuxbO48s8M5fae?=
 =?us-ascii?Q?ErkwGJ8C94uVcI38/b7q48lm2/NJpjdm86hLXbwdmZDvygAdxL4/EmTTA/VY?=
 =?us-ascii?Q?PRPjd7ffhNmkG/+HKZuPNnTp/gKhm3esPGnv7A5EXFDI4iqJVKEHmfJXrmLI?=
 =?us-ascii?Q?gDquiDeQs4NVrMW679H/IyWHTjn3ylhzUdVGqSJDA7Tc0t3C1uCT8RAdBMh7?=
 =?us-ascii?Q?YCXD0e/T6XUV5cwkXUi6JNJjf+/iFZwm0+jV4aHyd3zf/zTbWEbIWr/D7+vj?=
 =?us-ascii?Q?xt+3x7rfB/R5O4udWolYza0+galu/lsFInHPSdunQBPL7FAyjM7tIjfXMKa6?=
 =?us-ascii?Q?hPNTYD/Vev82SoGog4KzqdY/kra5QyxLT4HQICLhdEjphu/nTnI73ulQzab5?=
 =?us-ascii?Q?9nGZTNnH3nLrKK1q7kUmXYJeyNPaQCy2XY/KnUg77bOu+En52oxpTQx9XYBu?=
 =?us-ascii?Q?Gx+K4X7dDMJwPEIgbjnVohFYMNsvsAG8njJtqVxtyjPFhNmLsm0TrLFd44jN?=
 =?us-ascii?Q?pj9216qa50a4rVzoowxGy79kaLd3hIY6pKf04H+2w+DoSQNAf79AhFc/kRlt?=
 =?us-ascii?Q?QXGE2uDM0v7DSfRSeXeJGF7np/q9cIcWMnedZXP/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3e0119-a525-45da-297b-08d9ec0f70ce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:02:11.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDNWP/0sESFx+UGcwFLhm5ZxCYH06nXQkmhi090DSayS58E7cnRCHIfK8kUlB4sJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4149
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: U9pun4m-EBX6udvt9iGsQTYds3Ui0t8P
X-Proofpoint-ORIG-GUID: U9pun4m-EBX6udvt9iGsQTYds3Ui0t8P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_11,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090110
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 09:03:45AM -0800, sdf@google.com wrote:
> Let's say I want to set some default sk_priority for all sockets in a
> specific cgroup. I can do it right now using cgroup/sock_create, but it
> applies only to AF_INET{,6} sockets. I'd like to do the same for raw
> (AF_PACKET) sockets and cgroup/sock_create doesn't trigger for them :-(
Other than AF_PACKET and INET[6], do you have use cases for other families?

> (1) My naive approach would be to add another cgroup/sock_post_create
> which runs late from __sock_create and triggers on everything.
> 
> (2) Another approach might be to move BPF_CGROUP_RUN_PROG_INET_SOCK and
> make it work with AF_PACKET. This might be not 100% backwards compatible
> but I'd assume that most users should look at the socket family before
> doing anything. (in this case it feels like we can extend
> sock_bind/release for af_packets as well, just for accounting purposes,
> without any way to override the target ifindex).
If adding a hook at __sock_create, I think having a new CGROUP_POST_SOCK_CREATE
may be better instead of messing with the current inet assumption
in CGROUP_'INET'_SOCK_CREATE.  Running all CGROUP_*_SOCK_CREATE at
__sock_create could be a nice cleanup such that a few lines can be
removed from inet[6]_create but an extra family check will be needed.

The bpf prog has both bpf_sock->family and bpf_sock->protocol field to
check with, so it should be able to decide the sk type if it is run
at __sock_create.  All bpf_sock fields should make sense or at least 0
to all families (?), please check.

For af_packet bind, the ip[46]/port probably won't be useful?  What
the bpf prog will need?
