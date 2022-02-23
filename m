Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325E54C0F45
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiBWJeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiBWJeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:34:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F6953B6F;
        Wed, 23 Feb 2022 01:33:42 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CmIm026299;
        Wed, 23 Feb 2022 09:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BZ7vZUp4/nUrIxseodxlFW1Wju76qhL99ZhEM8pUqmU=;
 b=CyE0tz7hazhKsCddONqkLtXpXu3XOQsP/7Q8glJ3xIXBOYzkwz8lgxi0WJ2KyltrPnMP
 10gzLYh6mQi7fnm1IzXC+K5vK911BKD5qXcuIbP6+W/qwBGbrkLK80EOJc21VWYGToxn
 1shYhNkQljo8/NgkVx0Qo0GVhTQPTwFnEPSqHcbg/gGFMxpmqlg7Y1KaZ1+f8R62A64Y
 1scyp4KAn5KPfPDBuWzdCdIT43SuCN8KxgRpvoPEYHFe5hclh9o3L4QhOb3jzylGSJUa
 Vr1qDtHjUo2rF57NgX6xqpZRGapxLvoCMoNEURSOEGfKD7MX+Zx2aqfm/3TNBgepn9KK nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6euerb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:33:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N9GsNE052373;
        Wed, 23 Feb 2022 09:33:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by aserp3030.oracle.com with ESMTP id 3eapkh7qbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlaql42md7GDcDgRjsKO7MBNi693ZfZ2TqBT4K/wYBwQChxSwlQL962xeGouaHPig3ms4NrV3EC6Tq9SGThDLZzztsBpNoDt/IYlQgLyLk3rBbxnAlPfeRTOi15vqcoV6BE/jJGwSMto+yVE+dmlLBANvYw/I6OhMeWhyGxkXSYZU51iRooRyB698bFjgaJEq6x08UW46XI9qWtL9WeMU0wOLZf8OgcWg0SUQcN3HI4RjvC5qwKEM4SQnBYN1Et4OJq6t7DuKtBFBJG+S9dawrF3F3/Hho/jgrE/bwhUpD10RYbIGYT6kh04yiRZKC04L0EfF5g4UqSKId0nlBw9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZ7vZUp4/nUrIxseodxlFW1Wju76qhL99ZhEM8pUqmU=;
 b=Q1fLULLBZFd4i8jly0YDtghO8zFsKjfJGY6bn/+nkVe5IUJP9MM++kWpqQHVDi3hYP9ASsFJ97WOZWBQ9JZPGUPsCzA7MvqKhmT2EEJaSIIMQJGyrGPS4OmLKj+WaWmJZmQXNSjaGlxZnwXk8H1Cm4SJQdu3Z/Su6ZGYBlle3Wmn0vwQTqwvbzzQAxYnWBIAm2zvEEJnU0Va+A2kMpVyrSyR35ivTsTPOndqTVXQB290zmkBTu+IaYv10N3JqQnIWe8GV8BXSHeZTyjmKGvi86XI1izuulw47X3XKYygoYddFvYo3woreN6iqZffABtiuE0B+KDVgQS3BWvswQmkiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZ7vZUp4/nUrIxseodxlFW1Wju76qhL99ZhEM8pUqmU=;
 b=HjlUv3qS1DNqWl4PFErtSnbHmdJ52f4jnxu04Bk0INB/BAARpLsnU2dxFC8ELz628yexvYhm3PG0gSha8qMPNWPc21p8Cp2AHZKQLVPaINbWeFXKTQEPezBY/23xW27AuUqFr8HiK15+FTOoPI5PYpQap3tASFS19WdEbOwdUFY=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CY4PR1001MB2101.namprd10.prod.outlook.com (2603:10b6:910:40::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Wed, 23 Feb
 2022 09:33:19 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 09:33:19 +0000
Date:   Wed, 23 Feb 2022 09:32:46 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter.home
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
In-Reply-To: <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2202230924001.26488@MyRouter.home>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-3-git-send-email-alan.maguire@oracle.com> <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e35ec54-957a-44c1-b9de-08d9f6af86c4
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2101:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB210133D2E435B4B57BBDFECCEF3C9@CY4PR1001MB2101.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvhFkPm+e3BBVpOpIF2DCA7+Cq599S2xtHVtf6FwlMV7pO/dwibWS09v4YtLN9Rf5vKbbUAOtsSqs2h3Rv1yG1auPHef7uzhAxWSrwAbxCkeupfdVxOCPzB2goTuzdl/kIFyf77gvxgLveJfd53yeh8RIiftGTR7mzTGm1OwZ9EMEHz60mgw4111saSJ2Hm+DdKC92VVlB0IqJ0cN4R8MjivR/d6nDwwhNWyWOeurKajaFYFhthWc9Fkvq0r/2dBoHI09Zv8wvPR5gRxj1wqni9iddL5om+Jy8/7255c6WmAAkwxFjJJZe2w4BaUrFUakuHyVhzDPRrbV183gkMLN4ofIUR7Nho70v3ucucIckYUBWLITwfnwu/OIW5/JwFYVfQffC6jG7s4SQtoZWO9a9AoggnvfMCCHebZaMgdnzPan1O+OleEZxHXxOf5M7A5vsdd+DsCKnFRCzHw5sZrh3d9fjG9kxmTku+xqx9gTtM+5+q2V+9LApWnD9X26GiqpYFRQyGs3YTW3NcRi/wHCn19hIWzkSK7bvG/13s4Ozdp4MBRcUOL/8r/YHARVtUJ7H/VltYhWmC167om8S1uDytUyRAQCwoNEC5ggKOagHSs8SfjC1UwiBMOqF7Z6EE7uoVdTXAhWGQRYszhZ8lO3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(8676002)(4326008)(66946007)(66476007)(44832011)(7416002)(5660300002)(52116002)(6506007)(6512007)(9686003)(53546011)(66556008)(38100700002)(86362001)(6666004)(8936002)(36756003)(54906003)(6916009)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HszR7MTCfRr4JbOZgD3s34IOxwvQfnRRnMu80PoU/Yam/2+cfU0hlKdOAdHm?=
 =?us-ascii?Q?kYzAn6NfdLeFd9aIpRqETAJ0auNvEL8RNuDjd9dV3dstxBGrj83058T4wu4k?=
 =?us-ascii?Q?ckbYonZB/jQ7AS6FPeZNWZk5/z25EN5cQKk9mLOK/JfXp+Gy4AqrbVaYlQQi?=
 =?us-ascii?Q?CzSWRzImtYwC7D8CZ0QEU2ZwJsHnbYWutWFqOjTdM3vMIn5XSnke8OB5HDoA?=
 =?us-ascii?Q?FoMxJ9PNwHtJIJev3jbbXOtZF9s3kNEdVN2hsfR7x8TPVUYDYmpEYDXEjGOf?=
 =?us-ascii?Q?0FgIBhTtNJAbQ6xG/ALt98BKzvS7gHMH6/CwXPEhkQxWsk/c5QGrMBW90msa?=
 =?us-ascii?Q?5XdqsPvQkZKL2Dg5vmalaU7+yWf7G2dflmOsNrT1WuEEBajLtOkOPTZp4+RF?=
 =?us-ascii?Q?ABuUQlGt5bEb3/aoxzX1+LZHjZePEcH1hzmEQYR4ICn2ReP5EVeLrmnALXEE?=
 =?us-ascii?Q?YL0ZnCgh73xiHQN8bopG+KhL47oNaDZ9Q2bNfwonBgdsG0E2beZKXVe4xxsl?=
 =?us-ascii?Q?B+Nz8wyxP602P2L4hH+JbNPi8AMue/qYYzmCIzc1IBufSzY2k9VsuZOgQZda?=
 =?us-ascii?Q?/thfA9uWlyaW0DpOvIVRUlZUKvueTT2dpUx+z1bhEWMzVNDi8OD695tG/qcH?=
 =?us-ascii?Q?HL05z5HqD68bxtapS724dXobm6IpyKzmz/2HsfGtlQmCve5+rsr7/HiVqnao?=
 =?us-ascii?Q?IFWP/BtoK0YLo6u1hnhCo+Bgv1UI3mX+9Pxa7xJ543yE/YA9IrbvxqDN1RP7?=
 =?us-ascii?Q?Y36BgVvisJGOCsZoqoPNwOMwLo+nr7pu7u5liRCZLVz57HUu1EKkPtcoYIHp?=
 =?us-ascii?Q?W7yW5JCC+mkGWlOpKf+X3YH1HJC4K3qlQbidnABO5Lh9ThHYs2yyEZlVRWxd?=
 =?us-ascii?Q?zytSBMFUVEMc/4Y9TUCMxMWWv04bKIAgMGZ4aOrI2O31z2Z4zojx5qrIBrbB?=
 =?us-ascii?Q?o2s4qD4IiSbo8fyMi3ky+lL4mILLUKaajkQS8RyXLpV7yWdA0qxTyDigEj1n?=
 =?us-ascii?Q?7YMylFhNqA5i31/TQgkghnc4GElrJo9r+EAD7XJGx6Hy4yhcWrN/bZzsoq8P?=
 =?us-ascii?Q?gzzy+uNlXACImCEFZdJGpAUA9Z8YcQPPO0/RczOprMrD7rUkOf4+lpEF6RfC?=
 =?us-ascii?Q?ReCQ2BNXVB+Ylc0pI99k85oGxcxa+0ZpdzFQ4hvoN04Dtc3/BLOHeh0/Dujf?=
 =?us-ascii?Q?kaqTu0Fjiw2tkmw4r0V9bEyP+uTbiItQ8cpkmIkw27XJh8o6byRwqIbe4wbh?=
 =?us-ascii?Q?JQuX/2txylHM5zkJxcTqv+29m5PYTTVghY8AmKkXWOTAA6PInH9BCbdPQjEA?=
 =?us-ascii?Q?VtEAR0pheRVuj7jwuSmzMDYR8qIquOZMgfrygN7LeK+5kAsSQ+9HrZiYEgor?=
 =?us-ascii?Q?sLGCK1KDRAsidWLWQ2VAkzQoiBQHxGSvp7JhxgcQW60c625zB6UlEGt6jvcZ?=
 =?us-ascii?Q?HzrrBhxy91FYepWZ3JhHcl1mYqOVtkZyYCD4Gre0sipHurIk3PUfstOX+DLl?=
 =?us-ascii?Q?R89e7qH8dX7pEpwar0CHPl/oAFLAINmpOMT1ktc1j/zeeYTTW0/g/uTNgUdf?=
 =?us-ascii?Q?Tdvc8YxLr7wcSZbrILpg+vWS4gJCTKipfny1TKE7hIFYaNmQccjh/7E9r7M4?=
 =?us-ascii?Q?V68mydtlHWVulzuGoC7AgmDXHhnYnzU+uebEbBpkCNe/naNVuRmqD37KO99K?=
 =?us-ascii?Q?pAq5sZ9cfv59a6neCbYPzfrnNu4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e35ec54-957a-44c1-b9de-08d9f6af86c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 09:33:19.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGlKy5XmAEmNRWTYaqSnAHLc4OzgvIFcJKodgy41W86OEHLGZ17PppclelNq2Z1I6QhOpBFD2gywdQQvG1CKEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2101
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230051
X-Proofpoint-GUID: B4HQ5ScOm7a0uMkmHiBZTSRrR2Ka7FnZ
X-Proofpoint-ORIG-GUID: B4HQ5ScOm7a0uMkmHiBZTSRrR2Ka7FnZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022, Andrii Nakryiko wrote:

> On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Now that u[ret]probes can use name-based specification, it makes
> > sense to add support for auto-attach based on SEC() definition.
> > The format proposed is
> >
> >         SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")
> >
> > For example, to trace malloc() in libc:
> >
> >         SEC("uprobe//usr/lib64/libc.so.6:malloc")
> 
> I assume that path to library can be relative path as well, right?
> 
> Also, should be look at trying to locate library in the system if it's
> specified as "libc"? Or if the binary is "bash", for example. Just
> bringing this up, because I think it came up before in the context of
> one of libbpf-tools.
>

This is a great suggestion for usability, but I'm trying to puzzle
out how to carry out the location search for cases where the path 
specified is not a relative or absolute path.

A few things we can can do - use search paths from PATH and
LD_LIBRARY_PATH, with an appended set of standard locations
such as /usr/bin, /usr/sbin for cases where those environment
variables are missing or incomplete.

However, when it comes to libraries, do we search in /usr/lib64 or 
/usr/lib? We could use whether the version of libbpf is 64-bit or not I 
suppose, but it's at least conceivable that the user might want to 
instrument a 32-bit library from a 64-bit libbpf.  Do you think that
approach is sufficient, or are there other things we should do? Thanks!

Alan
