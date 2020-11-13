Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136EE2B21E7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKMRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:18:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33466 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgKMRSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:18:50 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADHDnQu021429;
        Fri, 13 Nov 2020 09:18:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hygVj9no6G5a2gjxRTwDsSvyueWTARtjGRlJm+0DoAE=;
 b=TVVQN449gbZ/hpRDjDgK2apw3Chkj33iShJgoIdhM08MGj2afjsRaamjmn/eRmlFxDUK
 GYGpVq9kLDQLeEbAKRQOEXtBdzVlhASG4+f8mpiCm6kSDHZ8ckxysx9ZESDwFdjnk2Xm
 R17bDReREEpSX24cfv9ZT9cWzgaLkFo+TUE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34s7gey3rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 09:18:32 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 09:18:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UawCmf4WPQVcZSiGXpjkaoaooyuzxJLPeW9PBvCj3LFiROen03OAZdf0KXFbWCUTY2CltYmYIJEzdIaC0zeEspb5Fqi43ho+H4gjBHdI/Zf1Kt4CjH/t68N5yDFXtpTSm+e3P3AzqBJHM5/sKXANJ7SZXzwN8wsmdb+Qho132kHL1tScJi5E7exQl147FJbImDV3qheDNSEeHs4MSLUCjNiWHCuc5+1Y+A27mv+FIVr7pYgaYqCZg8NWgVItq7EfzP7LHeUcptCOsoDqcpaSTfCw/QHZS8hQ2pKp5/C9nOiZf2sYkq46dgM9rfMWanBMe8CzJRzav6FvW0xMrt7QcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hygVj9no6G5a2gjxRTwDsSvyueWTARtjGRlJm+0DoAE=;
 b=obpZQeXtZQlHqg+sx8Kte03lQXyoKqbmS/mjW+wm7Gf0JIKgAJd8IbBKeFWzP9U1IUPKrt4MKhAwvNkgyov6AG0b7i6hj/LUPBF+GFCof+Eyd/L89t/YvWC2EpZfB3DE3qXP//O0g4ZNMyihzWhXMs883FkehfqSsNPf8D/bCSHMufstTAFAjD1rA2cJEZCMvHE2I5v5Rry//BuSmXb/fdkW7tPzCRv1zIfDIZrYfNDTy/vYtGekGL3PV8H7AGEK7JjEQO5s8wDTX4EKx91qexhocpxEJZvJWl5ElBF89Swwt0o7rwbKhy1fuX72+IZUomqhQhrp/xmLFLg6A5lZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hygVj9no6G5a2gjxRTwDsSvyueWTARtjGRlJm+0DoAE=;
 b=eFakGUhwdlj9V3nLBq6jVMu1NgbOvmulPMVW6EoIIsScQ2CCXnnFevchRUhAA2WEQxP7pquKGRHwESbfq++i2WH0bjcMHgXuSxroQ+duGVPyViWrOFNRBaREIPPUHqSlW0pJ/UuhEnmum4WlkYzSlVylSTXVjVdbS0diev5KGKs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN7PR15MB4208.namprd15.prod.outlook.com
 (2603:10b6:806:106::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 17:18:28 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 17:18:28 +0000
Date:   Fri, 13 Nov 2020 09:18:22 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-ID: <20201113171822.GB2955309@carbon.dhcp.thefacebook.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au>
 <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
 <20201113030456.drdswcndp65zmt2u@ast-mbp>
 <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
 <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com>
 <20201113040151.GA2955309@carbon.dhcp.thefacebook.com>
 <CALvZod5QtfNgtoTq2owEDvnEG4EfciNo14QYkdhembo9783nCA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5QtfNgtoTq2owEDvnEG4EfciNo14QYkdhembo9783nCA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:4191]
X-ClientProxiedBy: MWHPR22CA0061.namprd22.prod.outlook.com
 (2603:10b6:300:12a::23) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:4191) by MWHPR22CA0061.namprd22.prod.outlook.com (2603:10b6:300:12a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Fri, 13 Nov 2020 17:18:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050b7dfe-6776-45d2-9a32-08d887f822c0
X-MS-TrafficTypeDiagnostic: SN7PR15MB4208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB420846A6E5A32D19731B4209BEE60@SN7PR15MB4208.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0iCZEuPcIo173yOCpjgaLhPZDSp4xoJgR7TUL8iy5IOQrcActpPXHlcX4n1iNDwNexSOh4afiJIeRm+W6J47QypKysgoa6P6VAijoj1AutubebzH0BDDVko9/RijwBHQkD8VpiRg0/IBK+a9IX2bYkAWQGHWGPoMNGEkmbBCCIWu28kqMYJkICmnjkeF13u5vWmeRGtn5epUqeKmwVL+GvcZekkL2xCmu21FrPxX5vly9+dXJvPnB0ja0iU+yCRR1Q196j0+YhcjbdGMPwT6PSAy84TfO+CyAnfoJxOfVyGUDWzT+dpGUSFsmfDyZozW1GyoZBZjElStzyXyMXnTdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(396003)(376002)(346002)(66556008)(83380400001)(52116002)(7696005)(1076003)(8676002)(4326008)(478600001)(53546011)(6506007)(186003)(8936002)(16526019)(5660300002)(6666004)(9686003)(33656002)(7416002)(316002)(55016002)(66476007)(2906002)(86362001)(66946007)(54906003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vcD48ixRK0wrQj3E28I7SrOIy3injF1MRSvy3wDfkrllDCrLaBz2Haq5H4WhW5jQ1KaezV3L5/LsvrMV2oFq/O+dv47ACj4pp17u5Jk9tVTkyVwkEyHfUSq1M+BaCbUnV/LtosCeq5kIQBwAog6Q2ViJTjqOW8gVh8uHwLRzdq3iQuxhYG2G4B4ebUK+NcgfSL4FElihrXW4M+WJp1bAlUVbf6A9sPkWEtc8umVY5sAVAVftI5Sjp7piW71gtOcrFEzH3lsgkhPYVKSPwn6TLk9juHx0GQay8JuxbKd9drIcPKEoVu8eDhnlx07D3JJNpeG8/rNOeX7KdRGAqabZieG79Bzi0JQVT8MCAv+q+XYJjlZ844+OQXLjksI357gUz4gzypRc1NoK10aDe1aQvNtiaAJE3Ew5fODAzPo8jtmFcZzWKxz8rLYKx+zp4e/4iTgrKCkr4Sf0oIzeS/fODLI9QyUUnktecPptJjaWg81yLiUJ8DcXgxixySJhvb887q4buWu9bbGFcDTFCYFu02NC9zap8O084jVkUWCOokAbl5/Nc363pTD/cX/jn82wlBbLM+LCCiIeJfqMKVl7vP+1gh5sN46xqYW+oHpmqhGwJy+h6ak42HXDEcYvZxIj2CoO/K17qydj0MzrBj4qBV/gc4159KoTfLKMafaNnG3YJ57u258mTrEDqSCWWeAi60Lwc119dv1IZuSafHDcJNBNuiD6oQtr7EeN+rN++kD62GzByn3i9qcFBeS3iq87bZMgw1w6bMevKrgYI9RYjaEBv4+xPBgatuNKno2qqD7QA6fBXB5cEHIJteura6S3PQEuno0izuoGTEVG6hAnopIa/BeYl6flRnBKCvN+8CDHGyUwBPAYVJLxIpDvP5btaxuzQHhMnEDzkp6yL1uApMWgOclcoC/oET2s9DsPbmk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 050b7dfe-6776-45d2-9a32-08d887f822c0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 17:18:28.0720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nz4rFFFLxFSLr5pRE/XHCQ6s3E6rcYIFWAHaM7QzRdTXn2UEjPBXi/SKDBOGc8HD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=1 impostorscore=0 malwarescore=0 phishscore=0 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 06:25:53AM -0800, Shakeel Butt wrote:
> On Thu, Nov 12, 2020 at 8:02 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Nov 12, 2020 at 07:25:48PM -0800, Alexei Starovoitov wrote:
> > > On Thu, Nov 12, 2020 at 7:18 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Thu, 12 Nov 2020 19:04:56 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > > On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> > > > > >
> > > > > > These patches are not intended to be merged through the bpf tree.
> > > > > > They are included into the patchset to make bpf selftests pass and for
> > > > > > informational purposes.
> > > > > > It's written in the cover letter.
> > > > > ...
> > > > > > Maybe I had to just list their titles in the cover letter. Idk what's
> > > > > > the best option for such cross-subsystem dependencies.
> > > > >
> > > > > We had several situations in the past releases where dependent patches
> > > > > were merged into multiple trees. For that to happen cleanly from git pov
> > > > > one of the maintainers need to create a stable branch/tag and let other
> > > > > maintainers pull that branch into different trees. This way the sha-s
> > > > > stay the same and no conflicts arise during the merge window.
> > > > > In this case sounds like the first 4 patches are in mm tree already.
> > > > > Is there a branch/tag I can pull to get the first 4 into bpf-next?
> > > >
> > > > Not really, at present.  This is largely by design, although it does cause
> > > > this problem once or twice a year.
> > > >
> > > > These four patches:
> > > >
> > > > mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
> > > > mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
> > > > mm-introduce-page-memcg-flags.patch
> > > > mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
> > > >
> > > > are sufficiently reviewed - please pull them into the bpf tree when
> > > > convenient.  Once they hit linux-next, I'll drop the -mm copies and the
> > > > bpf tree maintainers will then be responsible for whether & when they
> > > > get upstream.
> > >
> > > That's certainly an option if they don't depend on other patches in the mm tree.
> > > Roman probably knows best ?
> >
> > Yes, they are self-contained and don't depend on any patches in the mm tree.
> >
> 
> The patch "mm, kvm: account kvm_vcpu_mmap to kmemcg" in mm tree
> depends on that series.

True, and I believe there are (or will be) more dependencies like this.
But it should be fine, we only have to make sure that these 4 patches
will be merged first.

Thanks!
