Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85013E9B20
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhHKXJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:09:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232434AbhHKXI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 19:08:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BN04nX002286;
        Wed, 11 Aug 2021 16:08:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/Tf+Sb+7AQDCNbRpAeFwF+95xf/6ci6mVTNr0cz3TeY=;
 b=HbuuXIAnc3PEnfQMsf1hnp+g2NFTfGQZcC7RU4CYifMMHbbiSsUv3J/veZgz9TWg/uuJ
 1rLvCBgjbswDHiC3YEZ6ZJ1IWRCAiASBH8Xj66lgDtld8aZ2fPEVP+6x2nkcs3oJJHfK
 QKxosdxPLOqEKg98q8Qh6i9tfDA9biLqYNw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aby5vgqr9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Aug 2021 16:08:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 16:08:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=linI3AOYdshO6dZmy/nd1m4Kl2iHQWjTDUBLYklFIfsOF4JhM9c2IogrRTa5aPdY70oHPGgKoBtobKvaIBw26R1g8BAudu+e52GzV68OIVvjpFcwQ9UdLCiUjlZARSlCiCINaAhRxT761sVmmkb0uNm/f23B8Q3tzykpOsoRD+/m08+TRad/2rJSXYo7id6n7T0f8pFdit0PGSYirlY8urJIsVa6LX6HAv0mtC/qIXscbBRJwvVdLP2fdzk0wgTMxRQlmd64VlE54LH99X+jQP+OqodiaRpxt5+XOYoNljre3vN4c4u2gWKDFfK+64z/PGDOFeW7SwRRwbO/R/zBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Tf+Sb+7AQDCNbRpAeFwF+95xf/6ci6mVTNr0cz3TeY=;
 b=eD/vj227umNsweX+6MxDq/Nexpt8K2uyfh0O9s4rOJ3ACQ5vnpMVPxfljrEfKuwKaDkr9NvOOrlAraz3GlPdCszYlD2jAOprSKPJbQJbDTdIr6pqSSLsrjzg9jlsPuB+OqXsKtSbliHIGzPiHAwRmcrEikXMrLfWOv/f3k4E5hwKHPVMZMw2YoGut1jIwW9bv8J6RckVcIWYVd40nt/k5cfZCqHQy0K4ByZ0kgnrCK4k+T/10YdBer1OPlHkLQJr36Jp0LouKHnKYesyNf5aHSTIXX+M1caSRz16k/iAIqPUgRlf0L2ZXG+Hy0dLJa3hJZk+95QcLG9+PEOcIv273g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4355.namprd15.prod.outlook.com (2603:10b6:806:1ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Wed, 11 Aug
 2021 23:08:30 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 23:08:30 +0000
Date:   Wed, 11 Aug 2021 16:08:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint
 trace_ip_queue_xmit()
Message-ID: <20210811230827.24x5ovwqk6thqsan@kafai-mbp>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com>
 <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
 <CAM_iQpUorOGfdthXe+wkAhFOv8i2zFhBgF0NUBQEBMkGYTavuw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpUorOGfdthXe+wkAhFOv8i2zFhBgF0NUBQEBMkGYTavuw@mail.gmail.com>
X-ClientProxiedBy: BY5PR17CA0013.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ba88) by BY5PR17CA0013.namprd17.prod.outlook.com (2603:10b6:a03:1b8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Wed, 11 Aug 2021 23:08:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ab9e24d-d970-4416-f548-08d95d1cef07
X-MS-TrafficTypeDiagnostic: SA1PR15MB4355:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4355865E1404128EA9BBECB0D5F89@SA1PR15MB4355.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7uYxXWoC2ALZvUdWBpX5a3dH6ZXlR2+q1PAsEbCMJT9yIiEgQ+vc5s3O4P9N3JPQocUKmZZeJnUENUsU87WKBjh8oNJ89umgKq3kD+NxEIOYdwE7VaR8RuuF31DOKK9bPQTNZpVjL5vXRXP7zsQM34ALwZ98yyTxW6TtglWQ8OCHajb2t+jR9yqEk7RpanRjDaeordO8hCX1VAJxI+R54XaBRDPcz0vxpWeKlZiOdg81lGARQgQsBbkGW1kV9hFflWy1y0Tj+cginlsO+8Zog6u732wPwznCkcrwg6TbCD2SHYJmNTYom6XkDU3si9RcYmCIV7iwMiLe8YGMaJhHyxbsXCP/jfzbQi0aTa84hj/kfALEHdm7yNswd4FsK1OkUURiz9OoqNA4p7+lj4VL6aNoDLzRscQJ2qxOFrucmviXaH7pIl9kVXit+2P+PmXq9qhB8vFGiy3qqGP20V+i6cd41TTJ8dwkSn4l0jLWp9jusC+f8taih0MWPLA2snVwI/XRnLB5/MHaiIWZoH4P1cqsmV12xKfN9dPWyVeW13f6o+lZELDpAyUnWvZdgn0cQM25pCPuG3SZ/GxPrt6tEl+xlAbrmQ9781JZ4eaIF3NSmWqfjnSk+dRXpiJus+5RV0IXdySPQUTF5ZNAeo4fQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(83380400001)(53546011)(4326008)(54906003)(478600001)(52116002)(6916009)(86362001)(5660300002)(4744005)(2906002)(316002)(1076003)(38100700002)(8936002)(9686003)(8676002)(33716001)(66556008)(66476007)(6496006)(66946007)(55016002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BKm/LQA/UByKBmkmxFASpXin7hULqSVsOr5tF3mVt8poPnExBsEyYdtH/bb2?=
 =?us-ascii?Q?IQDeTXit6qCAVt3/QVbyoJrdG8lxqpflJhn+hFhSGV4Rqe3NK+aN/X64Nit+?=
 =?us-ascii?Q?8zcnLti6/IegpjKNy6ligYz8DII4UhxeZijH96at8rjpfM4It8DOTbYKkyFj?=
 =?us-ascii?Q?wy0l9GsonsOfClNzxrC33A2uB71v0p5d1lI6YFJUIuV1JzuRLH7PIqmR4kQu?=
 =?us-ascii?Q?zlJxIPXDVIK0ETEeDRV0MvECHckdZVa0EbQnKensszNvmhTc3u1As5yiIIr4?=
 =?us-ascii?Q?pneyD5H9AfdKCbT6U9oqYMmnYjBsQAC5JtVEK+UrvQfqUlrkdWAtC+LT2RoC?=
 =?us-ascii?Q?KFdtkP+XvVjoL7oe1Vni/sxFOV33DuwXGlnhwC3TaIFTXz2SNnR/PEMXojs+?=
 =?us-ascii?Q?oxoQ7Lx1Xne6MsS7AfAKxYjMnLGWK19lBvUnlngI5mYsBEl7mg3sCQaJQPnF?=
 =?us-ascii?Q?Kbt4KSTq1lmzLLtQs/oULn5AcIqIuqvyE9oDZfe3UKSmpG3RvSV8eWdDQo76?=
 =?us-ascii?Q?AC9EY+8uGkGOmhqsVcXhcY6g83j/5fLIyh7nCUPSxdHn3LoYMXZXsXtzTneW?=
 =?us-ascii?Q?sLeiYjGKm0TD77mvd8Xben7Zs6pVKihA33SNIuwxE8Rb3i0QYpp90QFjziVN?=
 =?us-ascii?Q?U3BUU4gmLRahPYDp20PR0/CSZG84tPXdVfatoSXAoMukuzXon1M4O5Rn0KRm?=
 =?us-ascii?Q?iIj6yqidYjNYvATpTXzwN1/8PVDk7fxfVEDwarwjDloc38NWW/FCL9mR4efX?=
 =?us-ascii?Q?WKyz8yF3QtQ5yIB4UnUa4FKdR/8prqOFqIVmQ2k+54xVn7lvPXB6OtyfY61K?=
 =?us-ascii?Q?kXvnFFHb3X9IEHcXTLwGWEOPfHMYZs3qxI1NoW6D+qHdYDVi7AIs3Rvw8WxT?=
 =?us-ascii?Q?F8KsHK6G/4EgVpr80MzujDzWCIRhcqw8GbXJDlKfRh6KZW1RJQZsK3oMQXIb?=
 =?us-ascii?Q?Gl5yl/ViykWQI0033dmSTTxFTQoucjRIOexso6pbsFNPOQDXZpwFhaYrB5HM?=
 =?us-ascii?Q?MLeYiZe+AY+GaJdHww2oAF+UPbOpT+uLzxBiIOumVSuRGvpqOSSaTqEsWAS7?=
 =?us-ascii?Q?CyaYzWQT0bTSpR2/GrN50uqv98JNzE5cNjEhwtt1fmGcvC1g96t5IJFAauWb?=
 =?us-ascii?Q?jnshvJuf1ZRma50nBCN2iuUDTlmnvnbhQ8LTcVjd5d4+mtx7/YJ+r/SRMBL7?=
 =?us-ascii?Q?iYvvZOb1I9qf40DxjuV12I5WzEVZSbcSiCBQZ/1digbYRKpplNeqkI8Jm+qf?=
 =?us-ascii?Q?XCd5PXiHY8kSFTJ+oP+VmTZ4P35Ug3UwrbxKIk4usnSztmgSrWbci3l4eBvX?=
 =?us-ascii?Q?g+uWaKJs2Xw4vTrmwgHiT+L5Kk0QX9v9RWbTlvK7tLHAqA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab9e24d-d970-4416-f548-08d95d1cef07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 23:08:30.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EqHXAPZHIGcgTdJsAD9Agn00DyDHl3f2txWH7yckF7+OczaUS+MljPQoP3ubDfT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4355
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: fZkg83hhcOKsMMMB591B0IdSn3CyLmmw
X-Proofpoint-ORIG-GUID: fZkg83hhcOKsMMMB591B0IdSn3CyLmmw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_08:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=984 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110157
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 03:48:36PM -0700, Cong Wang wrote:
> On Wed, Aug 11, 2021 at 2:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > Instead of adding tracepoints, the bpf fexit prog can be used here and
> > the bpf prog will have the sk, skb, and ret available (example in fexit_test.c).
> > Some tracepoints in this set can also be done with bpf fentry/fexit.
> > Does bpf fentry/fexit work for your use case?
> 
> Well, kprobe works too in this perspective. The problem with kprobe
> or fexit is that there is no guarantee the function still exists in kernel
> during iteration. Kernel is free to delete or rename it. With tracepoint,
> even if ip_queue_xmit() were renamed, the same tracepoint must
> remain in the kernel.
Some of the function names are hardly changed.  Considering it is
not always cost free based on another thread, this is not a strong
enough reason to add so many tracepoints while other options
are available.
