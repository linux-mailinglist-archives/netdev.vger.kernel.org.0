Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700943814BB
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhEOAs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:48:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhEOAs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 20:48:57 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F0TjN6003588;
        Fri, 14 May 2021 17:47:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0ko76980fOC88iGei4j+IuQme+e34kbfRYxZs3v3Ips=;
 b=abpi73bpzCWw5QjjQrFQGUNvweAqPAmPuPeHRV2h/R3+xEOWrDhbzOWIfqg7E+aRTHdO
 7YYFOVITwdvkC7lTW/3E/1wxhhmGF7Oap7pZnIhY/8gl+Jz7haz+4/8TxwsUrzY/HMlm
 Z4jEtmR20qyeFKQx2R8GSfKcSPZyPGnBtyA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38hvbktevn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 17:47:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 17:47:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8cC5j+/xg5+40j3KUFfRN/E9BBmGf6owSwm3GF98r2cgNa4rmN+IhcfIEvAfTI6+bjGPE7P5/QUGnEBPLQ0Pfs2pHXz5xNl7fLRLxzbehoXwSpJzbfYu/PZa1Dj4jvW8xpxUO073a4Rn/3jRXYzKryslc58PxDcM+SgOlqtj0A7mX5WSP26LxCLm670E6Cc3fGCSuYIpMwgvyCxmoB61suU7yrXUq8Bxf0akQ30JOzWIyg/lwYqMfxhgVZw/EDjDZozD9YPBo9AcBNG1Tv1OA12TXIgvg0jSj5ten2QtzkhjMcV5rtgFh9kwHnkw00to/aFnNqhSdXFxceigv5pHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ko76980fOC88iGei4j+IuQme+e34kbfRYxZs3v3Ips=;
 b=m7KNc6/eXoGAIokKZOsMhw7yMLtheP6YwWc6DLGElFt8fHRpGOmcLsaeG2/daBOv1PWbscvuuoQQmrymmi3+FYLPTKiDAu5F2cV+4mXs4Oq4wgrDF/6GCPAtjK/0/7pGtFDvRhYU6OtR00GhGIR6o248f+VRrt1lCwXvoXKQ+2NGHtpsdPRAhVy4fvKimiRfkgEkO2xPEp9FN1Pm7EAIhs4jx+fo48lyBsZF7hOrRh5/v7ArDkDfAPHcngsPerRPwHdaE39GfZp3NcGdSEBejU1bqUgVT5GIjbySs6A7UFWKojQeb5hmpqC5l2+AcwTtHkk9bW37LOGDgIcrU25S8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 00:47:24 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 00:47:24 +0000
Date:   Fri, 14 May 2021 17:47:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 01/11] net: Introduce
 net.ipv4.tcp_migrate_req.
Message-ID: <20210515004720.avji2fdh75y2yqhy@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-2-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: MWHPR21CA0032.namprd21.prod.outlook.com
 (2603:10b6:300:129::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by MWHPR21CA0032.namprd21.prod.outlook.com (2603:10b6:300:129::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.2 via Frontend Transport; Sat, 15 May 2021 00:47:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3702f5ab-e1a8-462b-688f-08d9173b016a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-Microsoft-Antispam-PRVS: <BYAPR15MB220044E8328A0F1576808E11D52F9@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DClUXxQ1AXVGxEUD7WNnkZP+0ZFn2QZNVctFn+X1u28zfE2XRS4EfBRr0F7Z6c7hrv2zNIvoXpC3KZ3BQRAFY8iznD4FH5z2TFoBSBu9e2eA4L0ILau1HZISBMSYM+6sGGk0juGoHaYN77qeViDCg+WcGf4wIgQ449F26tqEkstZL6YnGOxgVMm5Lh8z16oTO1hlsQlgMkfl7FSdtDUOO32XVZJXwubKiGeU9ksET+ysi3W6qOiqbqfIiomql0QJiHVrWGVzijftfOKG7nCO+Rwd/6DwqRl+QT/eTa4pGpk6uZWoMSjUCOaFMUtQyqU4zSwSfT09pQ45NPnKlV7ndhCwDQnG8ftyqs8Blf177zLdMgy7Wr680E5XnXyLszzWf0pkYJwAShl6qfIjos8QGeGcun4Bu7b6cNM+FizdBY1Xd1V8aynDImv4etXI26cmgAo+Lb1o/7dcZSCmnzJbrvnpTRr5yCCN2Zkb8zhlTLmcuKH0KTfSMxkSoILn5UzYJaUXH36mO+W+qVJmnbwozXNaShBUPRkbCif7GRgWPDPo2yTZTyY8B6EmXg8rfhVVKeGC+FuDldTZVnHENxZRrqTPtX3R0jD0pMVXR6l9OCs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(478600001)(8676002)(6916009)(2906002)(1076003)(8936002)(6496006)(52116002)(54906003)(4326008)(5660300002)(86362001)(316002)(33716001)(66556008)(66476007)(16526019)(186003)(38100700002)(66946007)(9686003)(55016002)(83380400001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LnK1XxeQptiWKg013/adhUMu/jD9j+QFaZRDaKjIdFfUx9adKQO3yOALFV+J?=
 =?us-ascii?Q?8WDu+11Ezbjxu3fLKmNzdCFnlHrj+Jl1+VuL1hVZJtRtorlfxQSeYtk//Imn?=
 =?us-ascii?Q?O8EoYUPgL7y5+urZYn1l85BX7x+VmsGJSaeL6r+dV9cJ73m8OsWA2e26QAr7?=
 =?us-ascii?Q?1YkdGXXZOfhWirYRsIpRbSC3GHpNfJc49XCGttoTmBwVlk/9jpnPqBZycjhP?=
 =?us-ascii?Q?P67TBbo/cVT7AIOLIHO5V4aYIKlycAKsD/K6FfcwwgQgdCSiM5579uHDdEFz?=
 =?us-ascii?Q?QCZ72nYbu3oj4nLS8Ja7x3kCM4ypXis3rKuZiEN4PvHKurOIJZ82njq3n0aN?=
 =?us-ascii?Q?PIxHm2QqUoCwUsvbWArss+C9oBT0JBhnKDgZQ/9InnncUVWFs0GKG3PjvBK7?=
 =?us-ascii?Q?wXucjqHyNOaIfp3WObkUEcnb/N1S5xnqmYq1IC1/oQRTXKHaEMdVsfuvOOt1?=
 =?us-ascii?Q?InW25O7bKW5rRHenDWDEDs+rFo47F153bv2evMvzH5wdpZyY1sDnE687HPmo?=
 =?us-ascii?Q?jVyjWiJq+zAm5e+NkaF+3w/JohgkpN7dOrvidYVS9KwoPOADIvC20i9Q9aTo?=
 =?us-ascii?Q?8+Jfx+dfGY4SaZH8j7+kS17XSyTQnKBkOF3FYg8j1Fgi6Fu5+/PyH6RWrtXj?=
 =?us-ascii?Q?uM33aj2SuWv9FLtSnrwIuO4b5tec0dfhaRj0dzFIsQGaxD2JaNQ+5InnyHhk?=
 =?us-ascii?Q?AGPVAwHLrYypa5fu5rU8ANMr1DHfxaCwb+rSUudsBLrOA2NdJaH7PPnpGcm1?=
 =?us-ascii?Q?jyDp5ciaNH+T7it5HyY1gsPvzqc4MmHGOYqYZmRIQb9+iJQ8i8pVsuiSxOBu?=
 =?us-ascii?Q?UeMsU08o/sxai5YWJP3xOpVLCGSc4/kLpAdjuGKe2xVqXwugHfzUzbpO48F7?=
 =?us-ascii?Q?nQMKnaKw2yQv40YCOre2PvYih+jq9yAmYxifmXCCEHFyn0aLi20kJ5XItGkT?=
 =?us-ascii?Q?Y10+i9D2YYsbmADtrrdQiSG1gjaz27axyp/o3Rt0O+y3AIJHr3yg9yQsKtLk?=
 =?us-ascii?Q?fT+EguO7iFWPRO4UIQtBvWOh82EFmvJ6c/Fy+6OOSTQnATM/v/UuwUVE25kc?=
 =?us-ascii?Q?cGQZoLejuWfUNFcJHvtmdUI2c1aU3jhNG561vBciVsZ0l1viFkJoaMFCH3pz?=
 =?us-ascii?Q?22me7pdGFCyPk3JabM2EQB3YvbeF/CUhTsVS3TNg4mniWyj28+foZj+7HS1P?=
 =?us-ascii?Q?zh79Lqz2T73mG54tePskDNZ6VkB874NMLGZ5wm02TAuEOyAwyEryuuww0ikQ?=
 =?us-ascii?Q?vAlq0U0uKounYAM0jIzLchEzPgs1C4vUymVTMQubU9+lv3Gwi65jjdKwen9N?=
 =?us-ascii?Q?quseVRUhScSjvU6pEbIqpdh7WD6hIIzTpiJjTh1C3C6xlA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3702f5ab-e1a8-462b-688f-08d9173b016a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 00:47:24.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcl8d6sqwVAqYOGvT3/dCUGkD07ir8DO9pD4cXMbqhSAwJ9lmlmIe1aJ1GCYWNZK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: l5lDWFgNh_2AFExyptQMMXs2u2RoLPoW
X-Proofpoint-GUID: l5lDWFgNh_2AFExyptQMMXs2u2RoLPoW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:23PM +0900, Kuniyuki Iwashima wrote:
> This commit adds a new sysctl option: net.ipv4.tcp_migrate_req. If this
> option is enabled or eBPF program is attached, we will be able to migrate
> child sockets from a listener to another in the same reuseport group after
> close() or shutdown() syscalls.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 20 ++++++++++++++++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c2ecc9894fd0..8e92f9b28aad 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -732,6 +732,26 @@ tcp_syncookies - INTEGER
>  	network connections you can set this knob to 2 to enable
>  	unconditionally generation of syncookies.
>  
> +tcp_migrate_req - INTEGER
> +	The incoming connection is tied to a specific listening socket when
> +	the initial SYN packet is received during the three-way handshake.
> +	When a listener is closed, in-flight request sockets during the
> +	handshake and established sockets in the accept queue are aborted.
> +
> +	If the listener has SO_REUSEPORT enabled, other listeners on the
> +	same port should have been able to accept such connections. This
> +	option makes it possible to migrate such child sockets to another
> +	listener after close() or shutdown().
> +
> +	Default: 0
> +
> +	Note that the source and destination listeners MUST have the same
> +	settings at the socket API level. If different applications listen
It is a bit confusing on what "source and destination listeners" and
"same settings at the socket API level" mean.

Does it mean to say a bpf prog should usually be used to define the policy
to pick an alive listener.  If bpf prog is absence, the kernel will
randomly pick an alive listener only if this sysctl is enabled?

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +	on the same port, disable this option or attach the
> +	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE type of eBPF program to select
> +	the correct socket by bpf_sk_select_reuseport() or to cancel
> +	migration by returning SK_DROP.
> +
