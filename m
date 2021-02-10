Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D86D31722E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhBJVSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:18:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47336 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232166AbhBJVSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:18:39 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11ALBplp012296;
        Wed, 10 Feb 2021 13:17:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CiQcdCNCySkNI/rtQRtbu3L0uPtZqSbJo9s5FYKY6Vk=;
 b=GrKxn0oX+xtqZO4KMocDlHwy+k2A76CKgyTQlZaR39FRv4siB/tosh8Lf68vrk7n4sV1
 Yc1UfXQ4diYyPv+IkxekvqWceR7gH0/UusTnivMy+7KefkQo8+OK1ux2FOfr8egVtGMU
 Sbvu0VEmQCytWF5BZjIQg+DH8Ierx80tYWg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 36mcakkt46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 13:17:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 13:17:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLsfbndQgXZIkPqFv2aSXWu0zZ/Qcu9i5DPHOFjJsRyRZSxel+2ZFJLwvc0dZPJ+OBWK2Mo1hQJsLOnAa0I7YfEg/VsSB6AYffUQMCfaB4sP06lbTCUdrJNac9w1LvyiTAWb4dLnkzrpsYOzKOIlAewZt1lnkVUIj6TTnRYU6losKjYjFR2Nyhvi4TqcLVJSfTp9BMgDtrPf3KfAB9vD+LqfAchc7Pmy8vdNM8PYod7JIH+1b09G85XDnFoXdTof/U0Snga0UfxDIXWGZJLWcY1q7EbOxYLfBeMBCT7wmxjHKYNl2rw2pGc3dcI8wO3K/iTsD44zFIwrKanSc3h/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiQcdCNCySkNI/rtQRtbu3L0uPtZqSbJo9s5FYKY6Vk=;
 b=Pxzoyuwnom1CJEcF9xtIi64dw4wPTQodtjRTIXJhRePrNnjfgtYttA7sXZDy54YO7+7t5x/o8u7057egljSQ4EV7PPxNRSWm+gZoZ10zbbBidCTt61/LXccugCbyD2SWoofneeAKigQeUVwM26LpPe+0ZyfCVqr6uQMEuYTaA0OE5OzFybuDwWWA7K0zTv7OlZXP9wSiMU30iWa+arzGBDNOfOqnuNxPT9+7cLh3xG7uCiRZuI5kxLUNu3rN4/UTdb7VLmNYMIpQs/0uInxyShdule7dxd2bTTp1KRy9LT/Ce38iKm/O//kFAfr4ZNEfNmFOUp+52KkLztZ3ZQwdUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 21:17:40 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 21:17:40 +0000
Date:   Wed, 10 Feb 2021 13:17:35 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to
 struct_ops
Message-ID: <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
References: <20210209193105.1752743-1-kafai@fb.com>
 <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:c10c]
X-ClientProxiedBy: SJ0PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:c10c) by SJ0PR03CA0345.namprd03.prod.outlook.com (2603:10b6:a03:39c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 21:17:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ac34e0-fa71-43d5-1f66-08d8ce094c36
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3569AAC77EB40D534540776DD58D9@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwUH8COPE0z20FYtbiKsDo3G0rK3Oe9343u5svqWgICTA0Pi9w1jQfhtEIUC2CawCORyI/vK/4YgCt2ty25ecK3v4TNR6RA+2WDya8AcUYY2GvdS7PGXiChanOFOc1MquSDiZ0Uf6KayPAFf3pq6xVrlc/7/uAwcSC/ChIGXG4Vrmd3MUj16xFeT/eV/sG00LhG1qG1+jylXFCuYU6BdCOdeQYS75k4wqQmH0oa1Wk7uJnXGi9QnTMG7jmtBWuN4lgeYayRmo7+NDv/SedchXFh9hSxN3VkclfVfNv5y+WWhd4l9DYaEa1cJWgkQfEXbrstfh1YqNXjt7m3RetKtta2mZhu/OLQv+bkQsaHQ3hQwszi02UgKv2/NG4Mnjmo8gtWlzB0cZ6kjOmWfwcPzMDH7hTtWU6fX0UlucHM6GcadBPxZVxykDF60KpF5PLjgyvnFJclvVc2u/BlP8Kpt5+BcTDkJHinXjlSBfnL3bCYPBpTvfJfy/xag4Jk18aaFffLrI6rG8O0G9h+pZRESbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(7696005)(5660300002)(86362001)(478600001)(52116002)(1076003)(186003)(16526019)(9686003)(6916009)(8936002)(55016002)(66946007)(316002)(54906003)(66476007)(6506007)(53546011)(8676002)(2906002)(4326008)(6666004)(66556008)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Nnb9hkrOH5o2a9o/BPIOKMMsskEK5qHUWEUa2W+GmHe8h3dxhfafzdDZEwmI?=
 =?us-ascii?Q?GubtfWe+vFJl+s3hGwJlrS/Zs7gSFVJFJC5MMMBs7RK2J23mK1MIYQzEaDa8?=
 =?us-ascii?Q?QOqiYwltqg3Qum3PkU8ZJei+qLVttmg3epH0ioURvGF8yyee1CuQq82F3PeQ?=
 =?us-ascii?Q?78m2HJA8mjRhAYLBJNsWoXyduCcksWTZ1TMOjoofn7N1yqBkk0xgBIf9NFuD?=
 =?us-ascii?Q?sIDVdOENlr6Oi0lydxG+cYipws1q7OmHn3uuJxn07OUibfOtKrxQTam74quX?=
 =?us-ascii?Q?VqosAJNdGdQGi8kBD6fbugx6iDQnVmXAI2awFACM4zjsNr1JLKQrfk6S9Nka?=
 =?us-ascii?Q?zSHPw29qjyqmHJXrQtSPVFDpI6JfduzlaK0rwko89xLRy++lz7Dg1Q/2DQ1p?=
 =?us-ascii?Q?QZlHTKBk8WLjuaeI5TqlpywQMmbSxssZsaDYZHG9vbvs7v1ZFVEJv9kLhawY?=
 =?us-ascii?Q?2XgHNAAP4Vcr/dXgaTGpf64O2mM9o/coWcSVGmfr6IuvRl8HcdGFCgBTp3Sp?=
 =?us-ascii?Q?s9gPPBt2laoo7yPC+TIrttDornJJyzkCcWkglicyohDx980KinlzCCL7nEcM?=
 =?us-ascii?Q?4OzWhizY1m4nrah97M0I+zujTig4fhqFnj/sQYU+NQyMQMMnC/yDRgbgSNcH?=
 =?us-ascii?Q?sKrJ1ZDNgA1L+jODuy8LLGQQ1JoP3jXPKHN+66SQX0nIYsFXYapdrurUGsUd?=
 =?us-ascii?Q?DqUtPsRibzVzyNk0zFleAsfDq4ewRh1BZMH6/y0Y4W5mp8my+IVt7wC1q+wK?=
 =?us-ascii?Q?Fxn4lLNG5sFTCfMZy2diiG0a0aXN2I+YyFRMrHLmv5FLJyi/8RLVG1YiNV63?=
 =?us-ascii?Q?n2q2f6yETDijv0QgjPvKo0rc7SVhLvS2fhYPnEOmSKSXnIj3SiIONABRGnoS?=
 =?us-ascii?Q?VjF2DwJ2kIGEf5WmhJsEI99pSE+QSYzZhrjAUxrh0Qu2RxpqtgwpfiagQL+6?=
 =?us-ascii?Q?cyCBFydW9yMm6TBcGMuIL2VZu4K3WWDi0/NeyeHst+XuUNxX6fXUuH9+fnyi?=
 =?us-ascii?Q?2pcqO5UwufkpYYYuZAc+YVm2wOFjxrTLxbZiJ2EVa2EL8IEfd57y9eKlICxg?=
 =?us-ascii?Q?YNYbFl4wbMtyZ3sW4ppnKhnLcWYImNYowtcy4ooWcRjHUl1zUcau2YOWCjZ+?=
 =?us-ascii?Q?ziR7Y7ZPW3mblfk2V098fZiBMZNhfQ4wwiM+Ux0VbcAj/Z1Q/Ff//g91qp4r?=
 =?us-ascii?Q?BJbBcdgzyayf5HpPg10XWljX8hLSnXvgMqHOH+4lf3p2SlREmGNS6cEl+efL?=
 =?us-ascii?Q?Cn2seyx1XZSZtgsDXwtzHOcy7G1iwHXko1hH7yWKgXjtMErca7FcH7e3SsaQ?=
 =?us-ascii?Q?z4V0szB1Sx/gwcGbrp41dG7c+B9oSDWasfMoMXiwzKOJwg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ac34e0-fa71-43d5-1f66-08d8ce094c36
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 21:17:40.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyWhdDX/mnN9GIoJnUIu2k0Rq9fxGHQ5stgrVkJnAfueeRFVt83mmwHVtIVGBGMl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=957 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100187
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds a "void *owner" member.  The existing
> > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > can be loaded.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> What will happen if BPF code initializes such non-func ptr member?
> Will libbpf complain or just ignore those values? Ignoring initialized
> members isn't great.
The latter. libbpf will ignore non-func ptr member.  The non-func ptr
member stays zero when it is passed to the kernel.

libbpf can be changed to copy this non-func ptr value.
The kernel will decide what to do with it.  It will
then be consistent with int/array member like ".name"
and ".flags" where the kernel will verify the value.
I can spin v2 to do that.

> 
> >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > index 6a9053162cf2..91f0fac632f4 100644
> > --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > @@ -177,6 +177,7 @@ struct tcp_congestion_ops {
> >          * after all the ca_state processing. (optional)
> >          */
> >         void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
> > +       void *owner;
> >  };
> >
> >  #define min(a, b) ((a) < (b) ? (a) : (b))
> > --
> > 2.24.1
> >
