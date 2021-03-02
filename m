Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92B632A329
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382002AbhCBIsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1575991AbhCBD7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:59:05 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1223sP17021771;
        Mon, 1 Mar 2021 19:58:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1anEYPlXeCA8QVDJWhWrL7Jesrjov7VMWN5N28YTCOg=;
 b=XAPWDmlLUoJX5jDl2d7KacxV6G/fAF8Fy3uQdSpPBsP295FNUAgCzup5l45sLRSQ7OY2
 aO4j6vrIH7NZfPB76jVWLEFcb4dvmbNcRYfGmq8oAqHqnEGA3rlhSq5FMJDDFyNRMi3G
 VpDeJPZeHYArFXt1zEIHelTX7DdcxG8ys3s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37074517c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Mar 2021 19:58:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Mar 2021 19:58:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcfKZ8FI1si46yqJDG8P0TBJvAkvQ5KDh5+6acAvR5ZXRirxExSMpdnC1RzIBjmrsG2qKjieeEW4bFSjxIi2dgpozm53poD/8xBcVTVu3d72GABXqjuc6gCNPzYzN/ycltBbB9ephHxdg4lPGk8TqKbtgK250FsVjgrEcy6uw08e9e9r3eQkYG4rMtEVVozfJnXvWXbQrkqXwLPUmgeerKF7VXbXuumAb0GhUKHbH3HfuDwmgwvHFlT+HkG6GoJbrIFn8PBdGk5ufM+KReBkJk6Knv+jBSI2myhu9cOlTqwBZLJhxPalNvtzb8Qpb1E3hivkcxwJkSqyVx3tWKf3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1anEYPlXeCA8QVDJWhWrL7Jesrjov7VMWN5N28YTCOg=;
 b=eWJPta165k2ak6SrFl8Cm9MF74qOjUPast9wiNe/vyYXIeTughGlShGSg6V2r/l8WrVeGPGjQVp2A5N87bDOjxv9eApMmPuoPH95OGNd46ldflliB8p5GADWJ5LTVV5cXgpHVXbeYW/4IEyIcgcqZ3CCKdiT7FGcKr5b+k1jJaYUKQ3dTzrG3qC8628D89IejCw4TMvSRe3U9KFdslVJhzVryZD9mEoBF5kWksMSD7wN3xYdLCfEYHURJAuqHL5166Tsl4EHmLBTtazNdhxritOrQlkd4vtYV6fqrd3aQzLEg5NR+7WNgtxttwFh6fOyb0uKDiMcWe0ipRHOseAkRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by SJ0PR15MB4359.namprd15.prod.outlook.com (2603:10b6:a03:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 03:58:11 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 03:58:11 +0000
Date:   Mon, 1 Mar 2021 19:58:06 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <esyr@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to
 CONFIG_MEMCG_KMEM
Message-ID: <YD23zlVg+1sKJYvy@carbon.DHCP.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com>
 <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
 <CALvZod4rWvMJdnbfMm4SGtj0WyqDzvH8RY9G32y=NLNCZqJ2Gg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALvZod4rWvMJdnbfMm4SGtj0WyqDzvH8RY9G32y=NLNCZqJ2Gg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1a5a]
X-ClientProxiedBy: CO1PR15CA0076.namprd15.prod.outlook.com
 (2603:10b6:101:20::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:1a5a) by CO1PR15CA0076.namprd15.prod.outlook.com (2603:10b6:101:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28 via Frontend Transport; Tue, 2 Mar 2021 03:58:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6eea462-d530-405b-06da-08d8dd2f65a4
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4359:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB43599AE463C1A5B4DE56F9BDBE999@SJ0PR15MB4359.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGXWjp9yBhxgbcKotL5jhta+f4k5P6zeNeX6TNgprlqElFbQtOeWBzAGS+DfpJ7f6srx39gOkEdFBzMaaXKaoF/IshyR9ua3FhsEm1Lq9wS2UTK+F2h7KTbyDEGWVySVSGd6niXhcOKJJ+D+bDSOypsCjQDo2+RXufTvY5PrX0xc0cRd5lDHC1Z7SDkbocl1K/wGAl7irlFUqAA7sLfY06aoHn2Bf/Yn6Z5Z3VimC+cZQuLrcK8TqTEIwAxZiW/neaIh2EBamNUbME/qr7zDlV0/AYBVBILywSFalwPcVhB0iEb7IoUFLPWoIXENTb0yBauleDx8UJ4sC3YsUTnR1LJQ4o5Epi0CQ5+lEhcTxf6eU/d4hBL7qrBlcWhCo+rnPDV6dg03XbDm8P2Q4cKaMdpjBhRzXxFQuX0bIYbNAnivsAb4y1sFwGLHJ86TKKqRY9R9lfA6wjHRgz7t65sUGl9AD0eC1lya4gZJaLSHwML9j/J5skit5ymo8mE43QzXmCDEt91Y0JnWWXM2VnHua5Ntt23wbL/XOQMgQqlFuFAstw8l2wVd1xE1kC4Rkcg/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(478600001)(4326008)(54906003)(186003)(16526019)(86362001)(8676002)(66946007)(8936002)(4744005)(9686003)(6666004)(53546011)(6916009)(6506007)(5660300002)(52116002)(55016002)(2906002)(66476007)(7696005)(66556008)(316002)(7416002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6HVgPOVR8BZY2wCuMqxRPQEQRkQ6PBIl4PpKAnBmnq+AvICZAlU2Xb5Snqyy?=
 =?us-ascii?Q?F8g+mq5LuZlGUuzoi3l/ept0hVG1iK46WvS/czmkbM9saky+JGD8D5VrBgvD?=
 =?us-ascii?Q?+mV9kL10RHN+eM9t/4Ef1rHh8YtCFKlS5PEGkgUTWDjbdZ2Pzde1kA8dajy7?=
 =?us-ascii?Q?kRfUJfjmtlMi/sVNeVI3A21XQIEN8Mn8brIrkAiO+RtXpTQu/ZtuotFHX9Gx?=
 =?us-ascii?Q?MzkF4oiESrKdPyoL7LTLY+VfQD+2/mn34tvZ641CB6TNsgNV/mQW/roP4fDu?=
 =?us-ascii?Q?oCfdltgiWYIlZOeE/WVbBjz2UIpv7gvQXFKy81uVCu9dZN5nZ59tY6ydtIll?=
 =?us-ascii?Q?XhTzb9PMuAu7h0vvhQ1Iht8eLXcBxL/fCkRPrVmwivyo3iWAzU1qKIovkexA?=
 =?us-ascii?Q?CpAEMpw4pevDEwDxgbkiOyiTFcTGaR3daIiaqEHZfcFplR7PoGQtpHd37rIl?=
 =?us-ascii?Q?RyhBOMVfH83Sw+6H3zc1ufWP4BPXYuu7ETz19zBcb8iWosPOgg3sVJVLD3Dd?=
 =?us-ascii?Q?4SLPwVViva5y6TL+hxp4Sl/HOSSBQFvskYuIr64A/Zj7zDQUZ4zY7qW+3bVp?=
 =?us-ascii?Q?qRneS/P1rWFgOKIRSe6ldwRNGxFajyPR/bFl+iAwD8zATleTrc7AM2yrz/Sn?=
 =?us-ascii?Q?XyuDROHnZIdfflG77S5cE0UkHWzGL2wqoCP7FTOuU8XNG2RzfrBXn8NZXw+9?=
 =?us-ascii?Q?p49Fx2T/5LjyKuTaDdIypGGE+62N+BmpLvlazF22jmea2/6QlRxd1eevOJtr?=
 =?us-ascii?Q?yQgHJ499mCsxpyFBo+7NAGBtxTZI1q9tTvFNYhhq68BWSE1W541qrj4N4CFZ?=
 =?us-ascii?Q?inCWruXtfiM1grB1kXraFsLCeR4tcBvv8jsDRHtUNRxNwVg5Xd/BADfs1Lor?=
 =?us-ascii?Q?mgneP9XpTVQ4BFj5OTN86VFbBCc69f/zy8mxNzqNCqmH4j1TzN6QsMG18sXL?=
 =?us-ascii?Q?mxq/z84TC8HKKR5O+pgqTQm5+3jex5aYzGoMckvoGYbq6YONHNl5bjDaA9Mc?=
 =?us-ascii?Q?+woNFBaJZSAsiWyNyYznmxjy/Qh0vslpPBLoRw0f7vwQDzTtQUQUC2mS96Uj?=
 =?us-ascii?Q?DyxPzNPkKpVzwhFEkIdACklaq+hqb9DwAX6vLZgjkCJvGYDEK2f9l5q/QykE?=
 =?us-ascii?Q?W4k06pUsD7JEk8yqkMKUoK9Q2TDgf+TMNIlv1lcq1ZwHgXNuTe3lIdGVxezX?=
 =?us-ascii?Q?h9VzqRADq4D5d3V2LAxh7KcPdFOrEoZOK5sQ36W4I+7LRaFolJHBcRh/J1bj?=
 =?us-ascii?Q?M59cBVVqi+O5/6S+LZmRd3a9Qb+ptLIrLXrMsFHUFQyFFNtPmt2WebL7E5FU?=
 =?us-ascii?Q?JNPJgd2FcD4CBH71Jh9+L6+8lMv5a1GC3MxX7oiw6IHjzg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6eea462-d530-405b-06da-08d8dd2f65a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 03:58:11.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSPTQruSAVYKAksNvLqdXsJtyPseaOGueo8uoktOSfkoFgs53KGVisGP0yjaww0l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4359
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_15:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020028
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 07:43:27PM -0800, Shakeel Butt wrote:
> On Mon, Mar 1, 2021 at 5:16 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> > > The remote memcg charing APIs is a mechanism to charge kernel memory
> > > to a given memcg. So we can move the infrastructure to the scope of
> > > the CONFIG_MEMCG_KMEM.
> >
> > This is not a good idea, because there is nothing kmem-specific
> > in the idea of remote charging, and we definitely will see cases
> > when user memory is charged to the process different from the current.
> >
> 
> Indeed and which remind me: what happened to the "Charge loop device
> i/o to issuing cgroup" series? That series was doing remote charging
> for user pages.

Yeah, this is exactly what I minded. We're using it internally, and as I
remember there were no obstacles to upstream it too.
I'll ping Dan when after the merge window.

Thanks!
