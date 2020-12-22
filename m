Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787142E0E93
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 20:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgLVTMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 14:12:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35928 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgLVTMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 14:12:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BMJ9Q6N026320;
        Tue, 22 Dec 2020 11:11:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b/lGqYXKKymijj/lGIk5LD7J7B6cg6J8EX9wwtS5HXs=;
 b=cGsB0jk2XjEKQ4OvI+dF4rFLcgoy1zn5L9oCrRMgCkjHlXt7vILD1Cynuy5/yVlyoNpb
 yvRdAf3o7fyLeRwyIrw2LoG/eL0zU5Sbuodm0QQNoTI6+DJxVcHMwQxKsdzeQa8iHZww
 KQai6uN2tKkRU9GA3Ob1qFv0zELb7cQDkOc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0gcdygh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Dec 2020 11:11:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 11:11:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7HaGAc3ZEyKnR50D+wRT+yOJU831D4BwjvIxICwJ1q08Go/9oBLFUa3k9WbClpdPmtP3sf2YqHpBaVZRycHTZ10qoCIPNZZiDhzKlwhabSob3rgMhoLAvpYRJEGoyB9B0uIjkEqJxAaa/xbgfmY+AQrCaN6elfmNlydCFuDgV226ls2da29uhSbktv+6MdEkLrL2dyb4fqOLhLU3opsybXXsBTmhWbGCaPAUvfEVgC2Hs5O/Wzp1HgnHxRXpbxfIqlo3kza78ON9psOE65BX6SMuVopzailh2erUBSjxsy32J3Azb/czJ0sWLl/OiWRCfybQc2lKcEbyodnKpmC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/lGqYXKKymijj/lGIk5LD7J7B6cg6J8EX9wwtS5HXs=;
 b=a2mJbECvV07QKQUOiySuZ2UOPjd2R8mgGtiavCZbOFkCxk1ND33RISMUtPOVWD59eFAZX2wIwWT9rW7jJKEC22xCPPl3j+2v6J72rxVihyZMqSV5vF0naKsUptNFd4rr7f1kEKkBR76byLdyj7z3/MqH9xZaiqltrci8WENyvZQ7VHbaVwPnZdrYvwlP8pIPLwWt/Mn046KyLnane+0Q/5GksrblzRGnMQ/upHiC/YXXx0WhJCGgRSxcsLbt7xHKzDu+sxF4B6ju9Pvkx5tzB1Y9zsu/BNjLQyAh1K3wCNsR9Le7TcTXH5kmfqrYVnIZqv8Tu7L0P+2apwvipR3FwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/lGqYXKKymijj/lGIk5LD7J7B6cg6J8EX9wwtS5HXs=;
 b=HMkCRRuJ4OXhEhzPeud0DLdLaFjvmso7pknOgfeXTlv0G7CYqL6L80BtxGrk+Ng1SBtonGJZBJlTxYo3FNzqAkwRwKxEYkCGqK1USFHNFOBErHXwdyWI+dehQdNWV70pbpw1njPa8swJG7HAX42Juo2ulUN4jn5XfO/dsrozCWs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 19:11:14 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 19:11:14 +0000
Date:   Tue, 22 Dec 2020 11:11:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20201222191107.bbg6yafayxp4jx5i@kafai-mbp.dhcp.thefacebook.com>
References: <20201217172324.2121488-1-sdf@google.com>
 <20201217172324.2121488-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217172324.2121488-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:49ac]
X-ClientProxiedBy: MWHPR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:301:4b::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:49ac) by MWHPR1401CA0024.namprd14.prod.outlook.com (2603:10b6:301:4b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Tue, 22 Dec 2020 19:11:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 756e05e1-df64-4d7b-e5c1-08d8a6ad5a3d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566B82BD75127E476983029D5DF0@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQYBOLnW72JSdkTj6FG9rCCPAJm0XUW6wyJTTDjEnqAQl9dSuqNwRp6lh1dg66orZaIKSVgMD6VaQMQazfD9H1csYFJUQGt0Vb5Kb8TuRLyk2Zx41VC2Lm71E74bViKWgNko582yra+Fj8NQD7txzrGsF64svAz695NvXQKdaYGV72dni2PFVnQnKy1xckOPvpRBuK/BNYq6W/YWUDHbuJhX0VeFGnoo5ZOJXNPQ2nwFjgGtaxuRB37HzQJGt3TwEMKk918cMKEkZNbqV3Twqmv+uI89NWm1J7C/l4lmZxI5+Y+S2s1wmFi9bKkMl0blWBGSnoZ26atMA+IWaD105f0sG1Gn6wED72AVmRPEiHu6VVhpwiroYpY4zVzZ0XTd3hWAiEgrC5AJD+H6ELzHbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(9686003)(186003)(55016002)(16526019)(6916009)(316002)(66946007)(4326008)(8676002)(478600001)(5660300002)(83380400001)(1076003)(6666004)(7696005)(86362001)(6506007)(8936002)(66556008)(52116002)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ThLv5Xb2NaH30i2VxJkYcUJtd9cHRHr4eJByHcdzLBL62zD2jLgWGtn+2Nub?=
 =?us-ascii?Q?cfTJyDJgEoAfMFeyedwt+BDKZZs+gcRfj931fXF6moZTeWitYjZ+O6EweAJn?=
 =?us-ascii?Q?drNIPxW3+ZI8LVceCcnZXmE6tSwkLzlJmy/VF+/uWWn2hx0yrIU5cgmSxs2g?=
 =?us-ascii?Q?98N6UXMc7APNsUBuYfU9AzdTw2xhvZFrLawFGVQcbdqmDQZoNb0Ok/6OzylR?=
 =?us-ascii?Q?Clv37uSk8v2C4+gnr21V+dBO2/3cLUm2wWGj37nbUg26sdNZ4VRfyf1RpGXc?=
 =?us-ascii?Q?r5yn6UqqY71DW5b8hlkpdZFBYUN8Xpj1KGZW2J3xVD8TGzuYDOx8Wrz0rT0q?=
 =?us-ascii?Q?jhZOYXANNvxxVtQyLgmPhuCXcc2fMtPpMiHW+t7bI3xxMDhngxDb8pZIUWNU?=
 =?us-ascii?Q?pZCBWBPP5RxiBI3Ly1fcQRK5/gMokxOgDRpIoj2EcYlGDaSp9fugoMXMGiqd?=
 =?us-ascii?Q?dab9SygqF6oDw+hrXTjYz/H8+VXddY80NMyXUgJoNBz7KWeXlMRQ71AgDo4f?=
 =?us-ascii?Q?jVXo+zVS/AuZU3eg0BzS3n8sBvWeQAcR5mzps2CtxeCSmrKTr1upR6PDU0rJ?=
 =?us-ascii?Q?hT14nHxZqy3mQe8o9G2kX/SmfQhMgHOzmViA2Jy67qQ92EtQtrZ4REkbagm8?=
 =?us-ascii?Q?9aQIi+lg/VDbw4YdcE/Ip0YqpRXj5uZlApEaTGJ+/SZ432MzJAt4+iNHwL+L?=
 =?us-ascii?Q?uKzLpINWvvAMiM9dQeebkBugISi2jotHkf2AyVd4Acp6w3c+JD845RExisTP?=
 =?us-ascii?Q?Fa97F6U8ScfEFb3A+/e5lLp6X2Y6pY/GYiHpMkFK1XT04ZmwMo4jLfd9QgOx?=
 =?us-ascii?Q?5Zr0fYRSnvWahWGHB5XUbi85V57YakroxPePmvwvc+zEDRkrZfIwZQPFnLAj?=
 =?us-ascii?Q?YNK+U7v1S6lnHAGqxrhX54dL6CJ9QXEOZA2W/AEpDo4MlnJok099nZd8G2fw?=
 =?us-ascii?Q?7Ji8kdHP1ZLdaoTXai5T8znuq9BNcabFjBgVP6XMYQdR/HFCvOpt1WdJ/O+x?=
 =?us-ascii?Q?mwssBFturFSwXGHWzcsw7CQieQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 19:11:14.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 756e05e1-df64-4d7b-e5c1-08d8a6ad5a3d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ny4I9pkNLCG0QD6Vw2zYS5KG3U2KKz/yrwk14Ac/dgREAkgKEYhKs/wEOc3A/dXZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_10:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012220139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 09:23:23AM -0800, Stanislav Fomichev wrote:
> When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> syscall starts incurring kzalloc/kfree cost. While, in general, it's
> not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> fastpath for incoming TCP, we don't want to have extra allocations in
> there.
> 
> Let add a small buffer on the stack and use it for small (majority)
> {s,g}etsockopt values. I've started with 128 bytes to cover
> the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> currently, with some planned extension to 64 + some headroom
> for the future).
> 
> It seems natural to do the same for setsockopt, but it's a bit more
> involved when the BPF program modifies the data (where we have to
> kmalloc). The assumption is that for the majority of setsockopt
> calls (which are doing pure BPF options or apply policy) this
> will bring some benefit as well.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/filter.h |  3 +++
>  kernel/bpf/cgroup.c    | 41 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 29c27656165b..362eb0d7af5d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
>  	u64 tmp_reg;
>  };
>  
> +#define BPF_SOCKOPT_KERN_BUF_SIZE	128
Since these 128 bytes (which then needs to be zero-ed) is modeled after
the TCP_ZEROCOPY_RECEIVE use case, it will be useful to explain
a use case on how the bpf prog will interact with
getsockopt(TCP_ZEROCOPY_RECEIVE).
