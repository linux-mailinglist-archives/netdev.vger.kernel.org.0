Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14C3E9E15
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhHLFrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 01:47:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58338 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233072AbhHLFra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:47:30 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C5ik3V017332;
        Wed, 11 Aug 2021 22:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=a11bBt1cu+gnh5DWf+bc7FuCtVtM1Q4rWcSU2M82KQM=;
 b=abnarMVfA7QGwWFms8aZQwfP9bwdr/TUyFbk2kpQH7fnNvb8jM19PE/39QM7q8xS8LEe
 mpDaJ6qOaRS1cZf/wBt+lvJUjEC2iRLdQ9G+z3Fdsikpqm8pXuzSXJ+LK6wQIXzzmNME
 g1GxdDFqOg7z7WOTaRjYT1i8AMAyXmKCzAU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3abyc8j30g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Aug 2021 22:47:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 22:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ms3xxQvP5RbyFnmNix/hEKbw0dGsDApC3LEVd66Xz/yC6fgNnePGeHG0DmvNaV/2rG/7ytRF3/E/wP1VFhDTOnLvp8nPJb+d2EXxvZ7aHF55bv4cO7Syq7+4+nN7xGtuz2w+JHDSAncm7ZAt7gqlFt1W/n4QrWuv2jxeW+NhZjmHGNdDtzDQi8TD2bzMOtpfjerDIe12D2EoncRPFidUBXdygcWD2yDpCI3vaDJlr1KQevcE6tPJSP4aAD9pgYkzUcb4FHsGbDzDPY37x6HTvHLfNPKPr+Wg0LeEM/UYDXyTC5BES2XO1cFWVv6jEpziQYSYnx/zEgx5NaSwubYNvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a11bBt1cu+gnh5DWf+bc7FuCtVtM1Q4rWcSU2M82KQM=;
 b=JZOqrJqJwKtuPH8GvLtph+xhxpp3ehlvF434gkX8AlH3pk/Q+a4SMI32fxRk5MC2nZPz77xH2ClogxJ5rkf1hUgKewsx1/KUl1rvhSHunmBmHjc8bikxfXSEXYZ5lS7PYZxFn7FRLxSlcI6GTzk1YhxY3WSrQOC2/KLmn/INaYjKKL+Fjn8A0NN7+LuzkAJUc4L1rijDbk9TpovqyaioFE1cqzKe3JtTKrACUudR4LdEQThxdPUFPtVV4+BDzx7RjmQ7O7kwgYDbc0pSQST/Gp/so5ei1+xIPiSS646bqc3VzEuxomoNrIGC+fA0X0TLuD2eU7Yj9AwryhSKsUhqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4175.namprd15.prod.outlook.com (2603:10b6:806:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 05:46:56 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4415.016; Thu, 12 Aug 2021
 05:46:56 +0000
Date:   Wed, 11 Aug 2021 22:46:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint
 trace_ip_queue_xmit()
Message-ID: <20210812054654.2b6pp5c37kknwdpr@kafai-mbp>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com>
 <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
 <CAM_iQpUorOGfdthXe+wkAhFOv8i2zFhBgF0NUBQEBMkGYTavuw@mail.gmail.com>
 <20210811230827.24x5ovwqk6thqsan@kafai-mbp>
 <CAM_iQpV42D3HHESF62tmUHn=gB-a-6fqiRJGYaoVp0HyRH=xEA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpV42D3HHESF62tmUHn=gB-a-6fqiRJGYaoVp0HyRH=xEA@mail.gmail.com>
X-ClientProxiedBy: BY5PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:29ef) by BY5PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:1e0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Thu, 12 Aug 2021 05:46:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c40ee182-fd2e-4ac4-a870-08d95d549834
X-MS-TrafficTypeDiagnostic: SN7PR15MB4175:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4175F65D494CB61C131546BAD5F99@SN7PR15MB4175.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQEMR+zt31LShxgUl1pDUispOX2IE6peEUBTb28E9nvwwvfeWLu6iFGKSu5CKovJm8DcMxFW/xCnRaCEOAB+9cO8ISBuilYe+DR0AP/yjbBRcNuOz9T0xqFGDnQk7z3EykQapdmqLpn3VbEith7p9e8TraC8keQGnT9HPqEQrLgY0VE4s6DyhE+JjIYgiGtiieiN22zVUoV473u30tzwyu5fQB+HrOtjQtKsKQStU46r/oZ5dDLl5icTWP5ZhLI/zIIe9FmwmljnOuyymlC/HB+lHf2LM7nND3HXf+7hfHM4YdylGsly4LJFGvk5rvTK8YDRiu8BhDa/fz5hZ/dOwAsqV0ERYVkKOtsyvxB7g9QOiarFhkr2AUHyiUeyGo/xPVX5yOE2M2kJK3C8dS9RiYFtwE+fa/iFj52X0KtzyWb/A3yVianUFqeelXZmdE/BiaE31gISoy/uX3tpKTviPNoT0gJ2WRnkbRpl67pdKL3Gorh3vwJWmJvOw/2yg2hFK2Ua2qZwD88HN461eLw/m6Grohv12727f8QvdVR5iRn09UF88RsTC7ixjA32DPWajkqZDZAuvoCVPMMfON+rJEhNOTdcz1e27SEEow4RnATJEs9B51jU4US3wtbICN84+EI69nd8uffCm7zUDi8AXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(6916009)(8676002)(54906003)(316002)(1076003)(9686003)(186003)(8936002)(38100700002)(6496006)(478600001)(52116002)(53546011)(55016002)(66946007)(66556008)(66476007)(86362001)(5660300002)(4326008)(2906002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1VqNjH1a+7Haca7rjRrPXk0PeKL6HLhO/V1rkrqoTfxaNcfOMlb6N16eLVVN?=
 =?us-ascii?Q?VeM/a1+m7HMIztDzCkev4T1yjckhKCzYrAkvVoKcc8kIbigI1+Wq5IrSKd/s?=
 =?us-ascii?Q?rd3TcPoTRCr1xkFEZBIyR+A6m5rdHoFvBXduUTQ2AkqnY6o7iwOPabDtMVHC?=
 =?us-ascii?Q?Z6ZQZB6CAQFLnL5TlceM5JJIS2PEEqSSb1JLBxZkEk6lGVkFrMRXJ6DtOTU0?=
 =?us-ascii?Q?tFKZ057ZWJUtIs7J6SkPVeZ81WxJmrKjBLkBl/Sv2FnapXdhRzKbgjz7S3d/?=
 =?us-ascii?Q?Dbefr+hMPAy/u+iNUaO2Kt7i/ch70tPLDrvTpneJH/ifupw7PzSS7VGa3cln?=
 =?us-ascii?Q?97e+EYbW/+7aHbzEEJHP3oxy6O+IUWjcAojJ3oBwkPoWvj8v6L6hlx0ojf4E?=
 =?us-ascii?Q?pefq69dAtV4qqriYLeKwUt5Wyf6lJF1Hxs5u++DS6moTIBplVUmZfhA+8SQf?=
 =?us-ascii?Q?QllEcqz9idaj0dlcfS/jihC95VcaF0+Zke9lETPfbcxQ896hrSBNFHUB4NKj?=
 =?us-ascii?Q?LTgILyLg4ow6vKLxXN9webqQ17JO1XiqF8hWG71/BQiwPlcADojIGjQNNIzZ?=
 =?us-ascii?Q?//r3/uLiYTECnqWf/sRmLt70tmiTRIqo2egfP/xHJaQdf5vQTKFLKM5BJDu9?=
 =?us-ascii?Q?vVL1/jf4CCpFsAR3zOQ32NqL6R0WY05kY9cu6podY4Gw9zk5d4T49C0gpnm8?=
 =?us-ascii?Q?AdMGS0nb1dQFKX1WPWyUnZzm+fTTXLgSxu28fs2rHqqqzq7SgthND8DVdDkj?=
 =?us-ascii?Q?HCwDhA58YMr9BzknloUCM/iSR8XOjZ/4kbcmxDBpvHTCnrsIoMH8wBpOdsyN?=
 =?us-ascii?Q?9Jwnou4QTMCMSzynXPE6dcTJMTkQdtpgN8e0hlQnys3xy8wUpb5qr7teD9zu?=
 =?us-ascii?Q?wZDhEUwKHGcuY9zijdXLWxlGRMgpVG4bKPbC6JwobYko/7HoTd0dHi1FGfXH?=
 =?us-ascii?Q?MFdNaR+KhzdP+w38KAEkWO4dasDaNlgCv+TfC0RqhK98ufQyMTyowbGQVOxI?=
 =?us-ascii?Q?1IfnVKx4UfcEQBHWUA9kLfd3RNBIFBNhsbiZHk/A7StN6qUaVJicUlMw2Tpm?=
 =?us-ascii?Q?4xEjcQEpaKROLIlvTNkqMzPH2eXYdeBx6P41+q9Karn28rueez7I3VayXQ/0?=
 =?us-ascii?Q?boRVXnPbX0JSou0Po66OuMtkwu1NbhtRH0RijKXMmoUZ8AdmUnZT59PIsZwQ?=
 =?us-ascii?Q?0M6hzq6FBRbWoynuZ52hVzANEHNEuC38aSH/wNtryZy7XB9yIRtJU3yO1H7S?=
 =?us-ascii?Q?+ZReVp4UC/GFheMM1r1U/miYsHPgAJGyX8f5+jJbj5Y8bv4wMDx0dNKTL64l?=
 =?us-ascii?Q?igqoeKHYreh56aW7XMoQFewu5lGisZS7UIuEiG61YfmnTQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c40ee182-fd2e-4ac4-a870-08d95d549834
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 05:46:56.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /G+NsWOCphyS08kISNT9X5No8N5BFG1LHhmvww4QE6ye1ESB5TYd9/fpgJxCx55V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4175
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wHVEBtDvBjtdXcdZC3n56Kn_YauZO4Tn
X-Proofpoint-ORIG-GUID: wHVEBtDvBjtdXcdZC3n56Kn_YauZO4Tn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_01:2021-08-11,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=601 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 05:37:35PM -0700, Cong Wang wrote:
> On Wed, Aug 11, 2021 at 4:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > Some of the function names are hardly changed.
> 
> This is obviously wrong for two reasons:
> 
> 1. Kernel developers did change them. As a quick example,
> tcp_retransmit_skb() has been changed, we do have reasons to only trace
> __tcp_retransmit_skb() instead.
I did not say it has never changed.  how often?  I don't believe
it changed often enough.

> 2. Even if kernel developers never did, compilers can do inline too. For
> example, I see nothing to stop compiler to inline tcp_transmit_skb()
> which is static and only calls __tcp_transmit_skb(). You explicitly
> mark bpf_fentry_test1() as noinline, don't you?
Yes, correct, inline is a legit reason.

Another one is to track some local variables in the function stack.

However, how many functions that you need here are indeed inlined by
compiler or need to track the local variables?

> I understand you are eager to promote ebpf, however, please keep
> reasonable on facts.
Absolutely not.  There is no need.  There is enough scripts
using bpf that does network tracing doing useful stuff without
adding so many tracepoints in the fast path.

I am only exploring other options and trying to understand
why it does not work in your case before adding all of
them in the fast path.  It is sad that you take it
this way.
