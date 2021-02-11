Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E684A31835D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 03:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBKB74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:59:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16696 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229969AbhBKB4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:56:30 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B1tCB0023422;
        Wed, 10 Feb 2021 17:55:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UKI/kYECJ/4kwhbcDFKxcMH8xP7IgNsrgA6y9Jz/n2Q=;
 b=EVQACXqf4OZ0ROMcRUxLm40LW3iAWZLn8G29cX5PDCrSqrg7BrOwBSxXUV/+dp6k/jwp
 wU0YE8MfN4rg9YT9KjidBg4IodPjJWdD8m+QpUx45hXFqD5WOXhKKZiBmhTLgUjSM/fy
 pIRLWUXOGlRDkcqkhA+GDMwdA2XmwEY+zp8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36m5hyemrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 17:55:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 17:55:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUstKe7OO0qVKvU63ehdzJDkmU/4181/aCzlgs4Wo9Pny/p8yAkPqG/tMf/0mdNBKDC//ZmXXaaowzquw7+JQ1ij7ydRW1SliXkY0NEqobKeQ9kH0KKjYgA/iuzwzrJaD/Ybh3a91YUYgKv/Ubi2cvEj9TmS8hK1GnUvVDteDNlrtwUHngCw15fikK68R7YGCN+THFSYxR98qaALj3ZbNLgQMSNpPrDgqANI1LutLduZACYNDFA3ep0gaLxtD7y1l4Nai4qGn34ywAEhIztH/rDmBMOZscvIsojIJ0wWmqq4fwV379MqgAvcYUxDLapU9m1JhwfE4owgw3hJU6lAOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKI/kYECJ/4kwhbcDFKxcMH8xP7IgNsrgA6y9Jz/n2Q=;
 b=dwN1GOdcA8yFKAmM8hTngtRGEW6/AW4TCIdDcj3RS0HMAUGFfZPhlJuCM0eHzUQxdgSIaxgUaGt+1nf7MV/SD6IUNGLTzW9WDnLZrBl63UqbHYL8IztL8QV2EKci/Eo9+ity51fP9mf3PLiewqdvn5lX3ghlywDwzG7hBh0hyOPbf6G6o+Hu37YX8U3EucpmTj/fHHPQgs6DW2PaShrx1Q0M4gnjwg/q2aXJPtgiZQWFZMEYo9ekq/K2i/A2fEz82/jrMWvj/6oRjXa0JVi/Hx3zrvA2sZUCfdu8D8yVVnH7QF5eJKLf9iHHvoiAmU/CqLnkizyM9JvXwjslwkBRRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3048.namprd15.prod.outlook.com (2603:10b6:a03:fc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Thu, 11 Feb
 2021 01:55:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 01:55:17 +0000
Date:   Wed, 10 Feb 2021 17:55:10 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to
 struct_ops
Message-ID: <20210211015510.zd7tn6efiimfel3v@kafai-mbp.dhcp.thefacebook.com>
References: <20210209193105.1752743-1-kafai@fb.com>
 <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
 <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3dd9]
X-ClientProxiedBy: MWHPR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:301:4c::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3dd9) by MWHPR15CA0063.namprd15.prod.outlook.com (2603:10b6:301:4c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 01:55:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e744d380-dc8c-4a45-7fd8-08d8ce301408
X-MS-TrafficTypeDiagnostic: BYAPR15MB3048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3048FD2CDBB7C1B84E67BA35D58C9@BYAPR15MB3048.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4mn+YVgv8TeSmTJQ22V7rlOA0vGuWs16SMgmI8h3n0fsh3WA1AkWgSiY5faxfBp313Sa/Flbt9q/iy5FVAtMe7r4+2TdVPvx/JCUc8K/dO8qIGfVL8F4uaMTMLUAaQ67lRHr6slklpZLYy5ZTIOAHRF8lSL+57x88jeu1Bwk5FYqZGt839f96s98mRUm8uBnE7b9quwqCdfAxRBmrTb9HNcdZN6iBPBoXejExZbl0qjN///ELzTXMN4/9nSjJj7RUePjFw4SDnFD3IcCjFd5vomahqoz2GgxPm6ZYk6TMyqZPWp9lLa1dDDyevzSdAn+BqDpZQ6/eOOd8JHhlIXZJiuUUK1hyX74imJa0cnkzNYRnWimD8twasS+BM0EAKjG9ZJr8G2I75dxPsSVyJSM7S1JiXrMFDt3bh3V2dUuQ6LSb+NHafyPtWGA7n3hCa2c+Z1YG4GOEiqwE6FpBOLcfVor92HoD8GW7Hh6eY707t597q0EUa56mYcs0GBo7eiknUIXZgYpcJyA2QBY5BcQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(396003)(376002)(316002)(4326008)(16526019)(8936002)(186003)(478600001)(54906003)(8676002)(7696005)(66556008)(5660300002)(1076003)(9686003)(6506007)(86362001)(55016002)(53546011)(6916009)(6666004)(66476007)(83380400001)(2906002)(52116002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QcXUq2gtwDyqYT30SSW/Tij/VDIQLPPWEVWoWb5direEQyLR82b9w0rUbPfY?=
 =?us-ascii?Q?JzO072RYyp0gnm1Re8Z0ALOUS4VMMnNXBzR/bfDgyukc7EkpMPOzNN68LU3g?=
 =?us-ascii?Q?dnf+34L8kPTBLmrHMdbp/P/8XvoLDIGvxh1nidZKhYUqhVCozkfZWePLP0vy?=
 =?us-ascii?Q?iUObIroInKpc2xHgZakcxQYfpKBo67/jm/VZxJkvgB2DvL3C9U72wzv0Uy2/?=
 =?us-ascii?Q?kERlzl65dxn6Ayc3ttus/rEVX++7lNWWcZrpvmtu1pY9L7kA93MaUoMRMpMC?=
 =?us-ascii?Q?9imufvDK00Rwg4pvpTF1Zo8MMwMK303PP5DKSGhH9nIGSolcB17hRZ6X8bQp?=
 =?us-ascii?Q?VSGX5wh1YiFj9Zs1oyoVRbkIw6H809CgCfFcn3ibQIoftJkOIacWP4bAQHo6?=
 =?us-ascii?Q?9khTCBetGL3y9xatuTqyxDVLkRPkpmg/KO21ziM5TrRU5pfaQTAI2COGrWPX?=
 =?us-ascii?Q?659qM7WDC+qM4rqAGJnqIeeHujGBiiu+thSMaoD47d4EpOG5vSowXFhitzAA?=
 =?us-ascii?Q?XGVk8XvuKe8WegfiHF5nGx9M1Y5SLHQ9BRK3I5jy49PReZbckaH998yto/qp?=
 =?us-ascii?Q?6EwN334I9X861Q/S6Aq1RvwXwu7X1S9gInDyG17wbBo49hMn34ltMHIMsHoj?=
 =?us-ascii?Q?qV1l/eOhHGcC5WdVJ+pkk6SjijHUvFbgnoTcVLe0eYJf1Lsrhzuq+Qffy6bn?=
 =?us-ascii?Q?G0BsqNOg1ED/3chBbPXrmlu+KxvLDIi45tHxKS4YFQP9p7MC7TvZ708VF9nN?=
 =?us-ascii?Q?GHndlNGjJzpX4ckAvHkDfIORbTlKR8upwntEUKEPsoL/psjsf9tM3mc+X3OF?=
 =?us-ascii?Q?BxlysYjAmSzz7GTOIsYNwFE2R4xRWac1Tx3I6XCJmw3hZ38Mdjam0p1Sc7ZI?=
 =?us-ascii?Q?0idK2Tnvpy6XMlkC3FK8b4lHA5JWl15O5dsVRr+DVN6dEVo9zX2KXKgR2L2e?=
 =?us-ascii?Q?SH+kTKKpu/LWJDyo1p4V6DRK4W42G7vzBu/hqdK1N8XNmzENTzFiAxAGeFRj?=
 =?us-ascii?Q?1UBrVkciafY2O/eZiXDdicCo2Sme8Fhf3bmm1CXYPt0+SkEl2eDSqZ4fGENw?=
 =?us-ascii?Q?dRKHoGyBkKKzVvNApsp0H223RJfPcndifiwKFXQNVXoX1FoIrew/FQ0y0V8o?=
 =?us-ascii?Q?JGZfw+1xMQpdwdJy97egdy8aKbco6VwSCM+0yiPMgJojIsGtf0Aae3uNSt3H?=
 =?us-ascii?Q?jSnFiOWdf9Et7153kgB+iPjbFUi6kk3vHWWG+HrYp5OrShKdgHJRc898IAco?=
 =?us-ascii?Q?oD0DxnRh7RzrwkhXKesulFqn0OP+dEH7VH5+GfDP0n7wp3dMGUBVmgUV7v1t?=
 =?us-ascii?Q?zYLk4UMMlXqFbJIqB3xYAtUa6EW5h6rCGLMvGIvj32Nhmw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e744d380-dc8c-4a45-7fd8-08d8ce301408
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 01:55:17.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRmD2enK3DNZcx9pSnE9grSOgfLd/PC4IB2Fj8BSIMt1PPvo4OcnzFsEiBlusGsY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3048
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=617 clxscore=1015
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102110009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:54:40PM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 10, 2021 at 1:17 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > This patch adds a "void *owner" member.  The existing
> > > > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > > > can be loaded.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > >
> > > What will happen if BPF code initializes such non-func ptr member?
> > > Will libbpf complain or just ignore those values? Ignoring initialized
> > > members isn't great.
> > The latter. libbpf will ignore non-func ptr member.  The non-func ptr
> > member stays zero when it is passed to the kernel.
> >
> > libbpf can be changed to copy this non-func ptr value.
> > The kernel will decide what to do with it.  It will
> > then be consistent with int/array member like ".name"
> > and ".flags" where the kernel will verify the value.
> > I can spin v2 to do that.
> 
> I was thinking about erroring out on non-zero fields, but if you think
> it's useful to pass through values, it could be done, but will require
> more and careful code, probably. So, basically, don't feel obligated
> to do this in this patch set.
You meant it needs different handling in copying ptr value
than copying int/char[]?
