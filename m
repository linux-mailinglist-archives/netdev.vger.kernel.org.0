Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9158A4C3009
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiBXPlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236455AbiBXPlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:41:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037881BE4CF;
        Thu, 24 Feb 2022 07:40:32 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFOql6016939;
        Thu, 24 Feb 2022 15:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=57qKFPMEHqYK/1Oc3xr/qZ3h5dkGDhyzWUT/rdRWDe0=;
 b=yDpEtKfBPmIXcHoAsJ0Bs7io2df4VlYMY2/ti9j0PMzfhmlNrmKA4rT+iDM0SFGbSiie
 85uOyC23mJDTL/ckEFTFaKjvPfbu31eHB2Vutx3s8ipJvWee8Q8cVQSd8YsllYvmAPeQ
 tegbYmlxt7X5JxDaoV1d7vi8fZT/RB3NHrksqAbyW2gZvFZn2ydNpJ+cN/a9Pf9IbuyZ
 cuGe1nBH/YR6c6pJHvvKxBNO8Z6ya5JWVRoSDRv1lXnXna4ZhbCuRBMB7zZ780zqrGBE
 dn9Lmg6QA/Q3Ughy67XUn11oD/24yT42k0zSh4qUDIOfJF//Ym8qHj52PFNlzvUu/IGB yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cqj81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:40:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OFaxCg065314;
        Thu, 24 Feb 2022 15:40:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3030.oracle.com with ESMTP id 3eapkkbk86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:40:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXyFWYJ4Dsmf5GFqphpzWZ3x2MWjKUhqw6aXCT4p4OyK+G5p3qHqpoE11ar88dJ8SfcgFKy+vP3iZa8awb+3MvjaitXXt15SXnvVSSeABRGh3dK6Gi/KJpGp5qZyeiQ9lXpfls6GFPY+KLsha672dNlhoEiNjzvoFsUsmLJqQq7W+mXjnlRev4NjIrisIWGM/YDA8xetlZ8xqeFqNZgJeLjl5LQLEhvYVaVZGohU0+RnhNU2Z2polYzfsBSPgTAjiw61FeVUHakmNkx+GBlmQVkq202wMZQpWfuzUqGepLe/Kv8mnWtNrnXe6ggzUmLhYkj87HK8JxiuGJgMgOC2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57qKFPMEHqYK/1Oc3xr/qZ3h5dkGDhyzWUT/rdRWDe0=;
 b=OrRfUzZkSJ1erKkvmao14CN7lFXkDTgPMEEd6g4oXJhI0seFPNYNnp6yd9rJVk/KDIpxZIdi+IYq36RPgStagrxFjzxblCQbNf0tlPM18lBxDwQy4bkjOxRueo0enO4TkYFS3hcG5ti3LgdCjrocIQeMvv3cVNNFh3LFshrPvMCgDsvw4pM3HoO4urcYufh7aLBZaMpeYM84F0xmJTA1pVzuRtHExEYSd9nu/Lc3nl6i3YBIRYn3qP+vLJFolmyu/ffv0I9o7xVgBSX5i5H+FXWWY7P5+AsQwx/bJpJ03me1QHw+/HOrTCyT6PnDd73YG1wU7FoqsVhix2uRmnZ7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57qKFPMEHqYK/1Oc3xr/qZ3h5dkGDhyzWUT/rdRWDe0=;
 b=WJPfHGq9/deByxxJ34bacOZdmuBbPlG6x2yIpBOz+YXypGtSY+/u8NPlvEQS5Z/N22Ih3uN15t35NjSCuCwMGJIOfPDi3G8JVXGVHW6aIKwWYrEm4eOIKHKDnsy4uv8Uc8Hos4Owi8Z7LyAEx5ib8oBen+/k/h2iwd6uMFj2EX4=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN6PR1001MB2276.namprd10.prod.outlook.com (2603:10b6:405:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 15:40:10 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 15:40:10 +0000
Date:   Thu, 24 Feb 2022 15:39:33 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add auto-attach for uprobes
 based on section name
In-Reply-To: <CAEf4BzYzgc8GndgC9GKYaTLK-04BqNOrD3BjdKJ8ko+ShzUXvQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2202241532540.26734@MyRouter>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-3-git-send-email-alan.maguire@oracle.com> <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com> <alpine.LRH.2.23.451.2202230924001.26488@MyRouter.home>
 <CAEf4BzYzgc8GndgC9GKYaTLK-04BqNOrD3BjdKJ8ko+ShzUXvQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 629af500-bc22-4d07-8c4d-08d9f7abf07c
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2276:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB22769664F629104444788D9FEF3D9@BN6PR1001MB2276.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OH61Pb52CdDROa7lh9Mz6wgWPdzrfKqEElESm8WSujL99nt82mUQDXR26O8SyG3R/to1um7SxbLV/U8xD7F+Sq1EZyHNQ5iwxflbKoGoz4EsLJ/dApMu/bTNEa+DnW2oQaIfVJpFQf2MMtvdMZM/iyVDVgIvvE/bhNk9ExQp1wqpfjJ6v3Zd/XBG9g61BrQ7QXbl/2YFYUioih/MBtGrurQ7GW2N9+E3ta+aXUCCdcyIWGzwA4+sEJvT+yvA4bPVx63g/CcXzQHlmYpf7ogxEwNg8XWQvMukiXXGwdd7EPddpODKBvh8tUGuVYY8UhB/vjOBpN0272C/lmOEdHZovhkDhMmmyDI0HMuiAsBBN1Kan7DfX5/mWp1Fe5w+xNfIQ2pJSIzcCFMBB5LuZVjhjdxIkzNM6YOa85iNKyVyDU7kKUu9INbRQfbUIUEXAEIceMizcJT2PTLiZRrKcUAptudVCij6ozaklMiMH18hYokBuCALo/cu50HJGOFsrvYcT44GNE5TlrPsop5tGSFGxuN8yTGLSLebEpzorfz2TE/nBRhGvg2Gek6rPoLSjbPzhrLt0Pd9h5Bf2vjRufjXPNJU/RCJcuJ9bR6tPtAYr/X1y2Bklne09uV8MkcVe/gKpJttvUocXzZwrnmtBwahoH14R8PJBQlwS43FOMpaGSVItQ4sKOhZS4foIHVpfVHxDJUgyxCIVa5vvA7gZ6mWoLi4RPbMPRg8eNRBrwiL/+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(44832011)(186003)(6916009)(316002)(2906002)(54906003)(4326008)(38100700002)(86362001)(52116002)(53546011)(9686003)(5660300002)(8676002)(6666004)(966005)(6486002)(7416002)(66946007)(33716001)(508600001)(6512007)(6506007)(66556008)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tnwn/eTgyTxXjDz2M/mRYiUQONj0KmUr3f0Q12FiZb3keEoIOqmqCclDBXFn?=
 =?us-ascii?Q?vwmF+01fs8tInKGaYpp0VCqmM15xaWcELeHuCmoqTFHXpT+bvzy1yyKbyrpT?=
 =?us-ascii?Q?gmdB8nsFWcqkh3GOGsECoay9nFxKI/GNx0V5S6wlAZ9b2zKG0E4E0XAM0l3r?=
 =?us-ascii?Q?HHguiMY7LqucrcXTCIRO1cMYvx8ES1w9hlXD79LwkIxwymHS2oRh6dIUz4IB?=
 =?us-ascii?Q?VJIS5XjZUc/lBH90JyQVc5X9Z36i9+GT72pEb3ErZ2/MLjS6uJci8KRakPeI?=
 =?us-ascii?Q?Ehzp/VYnOUwCUD3f0sy5lu/ibVOCUI+bhoPxtBZ0nCJQ1/QlggPlAdJExgKb?=
 =?us-ascii?Q?M0GmLdOn80Ou6i/IF1hRypVDcfVB2PJKTcuik6CnkqDEF1jdQwDtauVesZIV?=
 =?us-ascii?Q?Z+1MZ055OoAlQC+E2/+HVmB9SKM5BH3sZTg9PTbpF63DHb1D1AhOcjQU4PRn?=
 =?us-ascii?Q?6RV8h78+mQ5RQ4cTp9uXvNc98O3kPypdndiHUZc2BOvbQR36tnShI0cPrH73?=
 =?us-ascii?Q?1r0swb01XzBrtAjjTo+f5A1/7slukp4+STfx5mWDzn87YvdJBH1TQngVzK41?=
 =?us-ascii?Q?MWWCN+dDpIzGvuQLAuCBPiCdzfyEYvB2+LRW3i9wtjK6ch35Tg9iK69eKEVK?=
 =?us-ascii?Q?vL36BYf69NUyOPbF08C4YdYSAyrX98N2ZK5ihpoIw813LpDltHAy3pJLGIpY?=
 =?us-ascii?Q?Cr87HbDkB9ksDnnShWxtRXJ7upJPsyHrUp70BA54hnrIvXl0hGnz3clZ2OPS?=
 =?us-ascii?Q?h5j6zSAvLQKoENz4cp4NGKYRzNVNpa8kHPUJtqo6IzzaemLFAujHQucIX7+6?=
 =?us-ascii?Q?0dDwKIzkMAlSXp/tw78RSn/8cpuVoALfeRGx29LK5hYRbMQ+WLleZRsfQR7w?=
 =?us-ascii?Q?SHkHi2txBtnUqlP+r/g641nq6RZCKOLIvE6A4RSygLRsQk24JjygQTBM1MkU?=
 =?us-ascii?Q?wddGGQqKd8IBRNINvf/q6ZDrmlpjJlOd64KMPpVKIKDP6tnXTqbNE+iV5odX?=
 =?us-ascii?Q?+GnqqVzlsDE0EO97BG4922Kx5wpGbv8pBn61pr2XDyqSyla1Qpv8BJG9FrPO?=
 =?us-ascii?Q?Mt5HkMurQEYBqbU7opcx/DBt9LWEIqmPspMtk1w4LFnh+gBbf+gX0zG2tm84?=
 =?us-ascii?Q?lH4GUZ3n1MaafiOa5hB8aJ5uTg4VpYzq8ysCCN/Pi72bywTCBEjVWai3ENBD?=
 =?us-ascii?Q?2hr64zCzlSQS5iaIQ32H7grhawu+AYW9OUvWxxGn6SjJihcc/+6aJBaSFeV6?=
 =?us-ascii?Q?higOtMWRXHkudb0CUvWL1R5sXosL330y1j1i9TLehPSNWdulbOcwEyiAbS8A?=
 =?us-ascii?Q?PVbjwSCb1Wnl0UBKcINqJLxKm9z5drc9ATZCWImjX7qCyBeO+ioWiRPL1Y+v?=
 =?us-ascii?Q?lL6rv1/xeemtgiZaqOHAU3TwYUy2jpOTPyA6o5gPiz0vyGTVdnUHt4nTmUbi?=
 =?us-ascii?Q?/7gDhiIf213hQxCiLZbqwGTTrxWY6jMYIAA1//kqC9R85M3A5L4gL1F2eKqm?=
 =?us-ascii?Q?JevtLuAAmJiL6S1wCp8GQYsOe3ACEZHt8dHH3RaRv+MCdjYtm7FG/KAa3kKI?=
 =?us-ascii?Q?5LwwH0ukS8irXK4XZDzUGGYGOQiYj/8dmZpXX4BsZL7Kh1dYDq3ly7gt/od2?=
 =?us-ascii?Q?XTHJYHou6fdlLjBrE52KeTAuaGwiASgtkBME56pa8SYK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 629af500-bc22-4d07-8c4d-08d9f7abf07c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:40:09.9079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 117OOBPPdYHTZ4pFbmp6o3Dnun62bSMC4H3P7eIMdWvLBoywL3IlCXuDBSIjXiO+66trh/WfHYVcn0ipDP9fJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2276
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240093
X-Proofpoint-ORIG-GUID: nAtUddF87ceiIMccd06f4CNz3oR-VDV7
X-Proofpoint-GUID: nAtUddF87ceiIMccd06f4CNz3oR-VDV7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022, Andrii Nakryiko wrote:

> On Wed, Feb 23, 2022 at 1:33 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > On Fri, 4 Feb 2022, Andrii Nakryiko wrote:
> >
> > > On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > >
> > > > Now that u[ret]probes can use name-based specification, it makes
> > > > sense to add support for auto-attach based on SEC() definition.
> > > > The format proposed is
> > > >
> > > >         SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")
> > > >
> > > > For example, to trace malloc() in libc:
> > > >
> > > >         SEC("uprobe//usr/lib64/libc.so.6:malloc")
> > >
> > > I assume that path to library can be relative path as well, right?
> > >
> > > Also, should be look at trying to locate library in the system if it's
> > > specified as "libc"? Or if the binary is "bash", for example. Just
> > > bringing this up, because I think it came up before in the context of
> > > one of libbpf-tools.
> > >
> >
> > This is a great suggestion for usability, but I'm trying to puzzle
> > out how to carry out the location search for cases where the path
> > specified is not a relative or absolute path.
> >
> > A few things we can can do - use search paths from PATH and
> > LD_LIBRARY_PATH, with an appended set of standard locations
> > such as /usr/bin, /usr/sbin for cases where those environment
> > variables are missing or incomplete.
> >
> > However, when it comes to libraries, do we search in /usr/lib64 or
> > /usr/lib? We could use whether the version of libbpf is 64-bit or not I
> > suppose, but it's at least conceivable that the user might want to
> > instrument a 32-bit library from a 64-bit libbpf.  Do you think that
> > approach is sufficient, or are there other things we should do? Thanks!
> 
> How does dynamic linker do this? When I specify "libbpf.so", is there
> some documented algorithm for finding the library? If it's more or
> less codified, we could implement something like that. If not, well,
> too bad, we can do some useful heuristic, but ultimately there will be
> cases that won't be supported. Worst case user will have to specify an
> absolute path.
> 

There's a nice description in [1]:

       If filename is NULL, then the returned handle is for the main
       program.  If filename contains a slash ("/"), then it is
       interpreted as a (relative or absolute) pathname.  Otherwise, the
       dynamic linker searches for the object as follows (see ld.so(8)
       for further details):

       o   (ELF only) If the calling object (i.e., the shared library or
           executable from which dlopen() is called) contains a DT_RPATH
           tag, and does not contain a DT_RUNPATH tag, then the
           directories listed in the DT_RPATH tag are searched.

       o   If, at the time that the program was started, the environment
           variable LD_LIBRARY_PATH was defined to contain a colon-
           separated list of directories, then these are searched.  (As
           a security measure, this variable is ignored for set-user-ID
           and set-group-ID programs.)

       o   (ELF only) If the calling object contains a DT_RUNPATH tag,
           then the directories listed in that tag are searched.

       o   The cache file /etc/ld.so.cache (maintained by ldconfig(8))
           is checked to see whether it contains an entry for filename.

       o   The directories /lib and /usr/lib are searched (in that
           order).

Rather than re-inventing all of that however, we could use it
by dlopen()ing the file when it is a library (contains .so) and
is not a relative/absolute path, and then use dlinfo()'s
RTLD_DI_ORIGIN command to extract the path discovered, and then
dlclose() it. It would require linking libbpf with -ldl however.
What do you think?

Alan
 
[1] https://man7.org/linux/man-pages/man3/dlopen.3.html

> >
> > Alan
> 
