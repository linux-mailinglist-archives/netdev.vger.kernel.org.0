Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6E2B14FB
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 05:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgKMECf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 23:02:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51040 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbgKMECc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 23:02:32 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3wtW3012529;
        Thu, 12 Nov 2020 20:02:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Yaup/lWfmjKG8Xt6z17B9vJIghyJUAHViFYDNKkQ6CQ=;
 b=cqvNENomdOLuaezu4Zzx9wz1YJYLzVJcft1BGZcAJGzRiWm5dcjp/bYec2fcg9+wFVj0
 9mrU5ADTP+ULsf7pHs/xQFT7+FISoxgDnGlPgL3MATGRY/RiHbhaVcgRQUt0HaO4VA3j
 fJQjFIUSQix4CRRz+FnY1tg+3mInvmxekPs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34seqp90a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Nov 2020 20:02:02 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 20:02:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiOF74x5J4RJ9eE2i+AAvHrsoL4Lc6PUENhgOjZuzlW46PibWgFE6kclYJ931UuuL2/vjMtu+IRDd3a5WR2lBjAfqcgTIy9V4yjruq/JCQj5aVmnHe4oN6WB7e5r8etl16Qeo6hBwSdkVntg2dWnJJ+YNquZHYoU52bCWcpK72SNWelG7HoFG8KiSmOr2lxaISxjQ8ocbgYP8h/5cQMF5tYYCquH+ZaBhlWcCbRbeTtbz7SeLt6PQ/YE1gm9nK+GoPdgTgsczSdzHwx8hd3HFRcBoXkXq75cZJl3OKXTiZxmtYBG35y2Ng7jzapUVu5xC7j+Ytus797fLdc/wCl1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yaup/lWfmjKG8Xt6z17B9vJIghyJUAHViFYDNKkQ6CQ=;
 b=U0lT5fX5eXKBBOU6vKHIjX+ZExz6DsJZIaZB28yGVGhkXL1qNyrROXAGjKIBo5oqMCsb3ip/AKk2czTyCGQQCeXJKIop/H2rFLss9YZLZZFh1XY/MaM4IljrJmXdqyM6fbtU+fc4aq4pQi5PjaR1YJK6r7cL/Ca2hdi6dtUKESK0lQ6IVL+ITGmMvwK0yRQDjrWXLPiC2EwTRnvXdZRaHZn9ntX9y82LRs4FHsMslgbivKuU8gVERVKnsStol25sQ2Fq+HAc2nbNixTj8ds4tBiaY2YZ4itzpAe3Waakc+9Q93XQMhvDqXMUNzKA8vESYXnj6YUbrLioMMX75NLBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yaup/lWfmjKG8Xt6z17B9vJIghyJUAHViFYDNKkQ6CQ=;
 b=RKgfKAmBHXe0mA9vUbTLVfQvFT2l4qokAmwovNfOqMohrpNw68yV4cPlNJ/FXKFnfEm6Ai9lp/wtqTU0WDF0bBlHEw4pkS8GmIWIKLmKMoMKWgogtY6GYyEB5qzc9fxRTx85bvjVNFXKn6yzFBSj7U1iIMIQHsS0VwD65PIzihw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3142.namprd15.prod.outlook.com (2603:10b6:a03:b1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Fri, 13 Nov
 2020 04:01:56 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 04:01:56 +0000
Date:   Thu, 12 Nov 2020 20:01:51 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-ID: <20201113040151.GA2955309@carbon.dhcp.thefacebook.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au>
 <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
 <20201113030456.drdswcndp65zmt2u@ast-mbp>
 <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
 <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:9b7e]
X-ClientProxiedBy: MWHPR12CA0031.namprd12.prod.outlook.com
 (2603:10b6:301:2::17) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:9b7e) by MWHPR12CA0031.namprd12.prod.outlook.com (2603:10b6:301:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Fri, 13 Nov 2020 04:01:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bd5df92-faab-491a-f7fa-08d88788dc9a
X-MS-TrafficTypeDiagnostic: BYAPR15MB3142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3142D01B47499FA5C0FB3331BEE60@BYAPR15MB3142.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ApuPA9C5Wcl9KdkXDD0LiITpcms5p/yUkoiwzsqimARLCjjRhBv2ot0bBmf68KM13QU+BColAibP7LHOE5UPZz3oq2SyIUODraVzp5dIRTpwJ6k+I+7dRq2KrK5+tJjgOZ3BwhkJeWy/9A8e7n1hEuJJUoNDmO/AsKvPxhaKvD8OrwTIUNCRbQK+jg7RIWmaQlZqI+4aiaDujd06sAWrIlSanuPWFDirQxqxUhcp3D+El0+JdSawKVgPLLLdn3UC85A1co9xliQP/jJqg9j9vhwyVHLxQBOoPU5JaPNfn9vCwwzwc8QJ2Ier8exrkkxFbfs9fYykQQwbvBRAu2XBFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(376002)(396003)(5660300002)(66946007)(7416002)(6916009)(16526019)(478600001)(8676002)(2906002)(1076003)(6506007)(53546011)(66556008)(316002)(54906003)(8936002)(52116002)(4326008)(83380400001)(6666004)(186003)(7696005)(33656002)(55016002)(9686003)(66476007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 51CLZkDX+8PNwW1zVzT5chJK6BN/BT99aFNsclwfZSaxEDKa/AEfKMzpNIxOoB2A+Jr1J/yNu9SxiXDfF34+254gGo+RcRR9VX7PU/r7ECeEyXpweUBDjF1gdixLcCZOCve1SdOvx4GEHJDylHgkEaClUd2I5BJ5Yb7+oRYixJwSowtBebR9V/xcacpFcAAbpCcxEP1B8pge1rzhOlLq8v7+UfTW4p1U0B+8gjqfDlrkFempz//KtIQCcWUPkXFnZX75t3VrVQ/OQXP2N2D50uC8nDHdsfbnxRqJ3HFaMkC1t2yPcmopqFU6MsDC+l6vuTGqOmOmkBEigbBBuJ3YU6vweKRP5+0deupwT55rSfxZ83ilLUuIViYR7nX4R3rZPmNwCiL3SLo/l3lZujYQCN4ZkGm806WA1dWZQH2ZFJBfqCKpnUYMZI3Sq2GASbsNGRbjwcXwz8ZYToTtzdw78shgp21lD91jmnNunBfWqw2S9EdgR/8AiQDm+U7sC9xzSpdYNo+bcHESiJ2SWY4uAjLbaMK40jcag0NEFunCCKs1Yz527+wNWiPFNWblfKTjOHA1z8v2CraJB9Mw48tNbSZ60Vz49TShaJtZELSNFIn0FBvTDGxYA27sPFVyuVPsLuAlvrBhskigFJtXeiam871OHoCup3o+i64G2Bq5pu8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd5df92-faab-491a-f7fa-08d88788dc9a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 04:01:56.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+7ZPSLZZjGqIpI8uaF5OUrl8Uz+J+VdMK25rXhW7/SloUpXbYsDnwIHnori6CxV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3142
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_03:2020-11-12,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1011 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 07:25:48PM -0800, Alexei Starovoitov wrote:
> On Thu, Nov 12, 2020 at 7:18 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 12 Nov 2020 19:04:56 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> > > >
> > > > These patches are not intended to be merged through the bpf tree.
> > > > They are included into the patchset to make bpf selftests pass and for
> > > > informational purposes.
> > > > It's written in the cover letter.
> > > ...
> > > > Maybe I had to just list their titles in the cover letter. Idk what's
> > > > the best option for such cross-subsystem dependencies.
> > >
> > > We had several situations in the past releases where dependent patches
> > > were merged into multiple trees. For that to happen cleanly from git pov
> > > one of the maintainers need to create a stable branch/tag and let other
> > > maintainers pull that branch into different trees. This way the sha-s
> > > stay the same and no conflicts arise during the merge window.
> > > In this case sounds like the first 4 patches are in mm tree already.
> > > Is there a branch/tag I can pull to get the first 4 into bpf-next?
> >
> > Not really, at present.  This is largely by design, although it does cause
> > this problem once or twice a year.
> >
> > These four patches:
> >
> > mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
> > mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
> > mm-introduce-page-memcg-flags.patch
> > mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
> >
> > are sufficiently reviewed - please pull them into the bpf tree when
> > convenient.  Once they hit linux-next, I'll drop the -mm copies and the
> > bpf tree maintainers will then be responsible for whether & when they
> > get upstream.
> 
> That's certainly an option if they don't depend on other patches in the mm tree.
> Roman probably knows best ?

Yes, they are self-contained and don't depend on any patches in the mm tree.

Thanks!
