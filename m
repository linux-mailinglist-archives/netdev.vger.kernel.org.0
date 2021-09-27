Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E81C419785
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhI0PQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:16:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25232 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234972AbhI0PQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:16:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18REjPl3030088;
        Mon, 27 Sep 2021 15:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Naa14Vfuwhw59TzI5P+UOGrsc4gkaIjJSJ1f9cuG+cU=;
 b=xt0HE6G2f/QvkHgOyA0jkcY/HfGrC+W63ZUWmyAQbf299GHVGsFOm0gDFGeDyOek66Jd
 haSc80phaniPxDR18ngbY3EM0JI5mOupmOkzxKAY0e37A+Qrg9bjQ9ktOyWmJgCpBgA9
 zxElMQDOams7ck/Pxtd/dVr9+UWkfDXl3D/Bu94ix/HrzB7kZwBzFpyP5B30KNkGXRrg
 IE8xCifRiXi18GxYjTdiBDvCb5pKurDHlg7pvSWdenLyDec70Siw6S9+RDIil0x+JDVQ
 bHvl5OAkRDEGPCFv4lfUxM63ge0nnK7GryIsgyqy2VK3/cEzL1TuCKmKHKA4JbZ8gBED 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbeje9dm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:14:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RFAL2W140612;
        Mon, 27 Sep 2021 15:13:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3badhr5aby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 15:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHXvhUazK20oTl7XJzaZkWPjaC+r1tcZLTdizFLyR5+qSUrmYAiPDO7HVTfFO9Ss+0jBO1lRTZnRkUHZbd1Ot/VZFU8ERmF/11EZvdQ6k7su3uWXqPLk7SaoMv2GV68Yp+bhHfouOxWjSds6cIYyp/INN0U73w22r+EzObh+eVeulOAjs0acNgcpm0DEGABQpGuVpTOHJoy4IjfWCGPqs6mR8aIe2JpHs95AnE7Tys3QrhKImJadOQUdl7TwpGexT7DKjYNsv6hPnEr2T33JwdfI5SGsCFqDt23yydcrX8p9tqdjFufGU9GFsItPXv8cniRfpX61f/0GgFs0H1l93g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Naa14Vfuwhw59TzI5P+UOGrsc4gkaIjJSJ1f9cuG+cU=;
 b=EdKviQX0nyYtFSrm+Imdc4wRBQBzbJ0IvYgFu+bOXD8U4vrS5wqCNUkl74Lnh/zSHDz/XIu4LLHcqKpKX4vCGDKm4JSDJaQmh5+GEJ0UhXhpGr9LeGfHGJaWtOeTup+WZrNmlkEDsWs9wkSIhHb0qqPg6echV9enMlBT7Hk/BmsbTRgsQqXjlWgrtsj1+BVN0RQesXWvH4cgt1jfO7YkDZAW5cjdcemPibVY5uQsAjpejvVQSubxOP953SRGo0oPokOWOukKKkDJ8TP0h0zHgXsknN2P49A0TOb1ykfHhIifIbmogKQQZBNURLmdvRJk9K7oTyyUMemRlCEgy5uuzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Naa14Vfuwhw59TzI5P+UOGrsc4gkaIjJSJ1f9cuG+cU=;
 b=WMy2BcLXwDQtoWttBMI0pAH5q1XCNXVd0jAFv1PEoI55sdeabEuMNUnWyXlE/lhj+8tQDOQN8hEpynseNGovUJUapfD2fjMYSOX3eYJveTjrk7hLKKVA+ucV8ltB+XYqWf0U3mEuTMsew3nJsxcOJfxc6m5QJZmyWkgZXN/P6QE=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5570.namprd10.prod.outlook.com
 (2603:10b6:303:145::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 15:13:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:13:53 +0000
Date:   Mon, 27 Sep 2021 18:13:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210927151325.GJ2083@kadam>
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
 <20210923122220.GB2083@kadam>
 <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
 <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
 <20210927072605.45291daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1af270c3-8a4f-6c62-bb6c-b454a507f443@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1af270c3-8a4f-6c62-bb6c-b454a507f443@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0056.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0056.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 15:13:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43f1ca7-1280-4629-5c80-08d981c96a07
X-MS-TrafficTypeDiagnostic: CO6PR10MB5570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5570404E9623F5BE7305194B8EA79@CO6PR10MB5570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysRR2B4L0Ofug/wuufOz/KUORIwZDcZ1GX6bPCLWlvlFmBwN9Em2iiPNn0EnpIUUYclBxu1UPnXIOyQAnKiQ39R+LU6IoD++MMvBYrYRdUEA6K2HZwAok31HWkdRfmdbzfUpYGIrprukbEkcPABLUOXsfvL2nC5lUvLbVlkVmPSQJyZSKPR67+DCydt+jOGHfD2IaRM2Rgr0a5C8w1LxfAzCkCzR7ijKmgwjyu/nC1ytkVHLbnMzCyQ2PGd+PgaA2YIQ18XYEadhit4FrITtx4JJifD+u/TJYVN6/8swWe2yBHiQ8ds3T31gfzdV8smlAGKNsmzneYMkF9qAyYcC27781LZAXuuuKYJYRQqaIKmnZgpBVjFM/Vbp0j1n2E+wCzeEqeuzEjFd42UuA0m6ISy56yZc1FrMI1ZZFn5BfUlXinAnvMqzwX4JqtvYFg0AKQo1qdg0SCeEn9+/7LoXQWjBe+07dt9YlejCY42ISIRs5p0fPwxBEIxAmDHhFuYrKISsGBMY3kgvt2L/1odePXyfhcolQUkiczbp/rAok9w2il78R0l2xDv2/ebWoPVonwQksh6OvM78RhxqxNLpKfC61HY/l/vC89YFUee3Z5MPH5y/qbTMJeyjMFskFNV0EfjnB+fg6wxudSsTMMCbafac/pJDmmoIOCSL068EUTG75xCi8+7PXVO9G0bVhm9NItWRkWOmIlt8aCI1fTIFez1y/VW5v/otJmlK2f17zw3RH/MuduxMKdAo/Ymlj+j2n0pHviadEYss6IqxhDwzotGRvB+8BWwWyH807QkWF2U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(316002)(6916009)(38350700002)(33656002)(44832011)(6496006)(33716001)(2906002)(4326008)(5660300002)(9686003)(66946007)(6666004)(52116002)(55016002)(54906003)(38100700002)(508600001)(8676002)(26005)(66476007)(956004)(86362001)(9576002)(53546011)(66556008)(8936002)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bV1L2vcoWKDcfSl+jE5B5e8R6QugUH9ff2AspnridTb5aW4tZbjcFlzfuRWe?=
 =?us-ascii?Q?wYKd4C2i3Io8I3T9z7zAl9n0HqjW4bXDjCPc50kpd+ml9+3eP1Z1S0I2ym2s?=
 =?us-ascii?Q?W9012mBkxa8SSCbHdaOx9mIcCMTGmKYPrshBofyvRwj3Q1EtFwf0hUyB2YCG?=
 =?us-ascii?Q?QDqUMeqQWy7vvzprpQabGWIp4nVurm3zcHDX/RKteVmStDBRZl0gPxRfvHqr?=
 =?us-ascii?Q?v3bzuke5oKUi/e4gx+yTtdGSuDpEyQnY/wsFg19OoWF2Sn6MhUd1pPV4FCf5?=
 =?us-ascii?Q?vuPoFxgg0FPeZT2RuudaUCitMgCQcOhkior2w2L0tuFL8dt8NB+7XnM2yAhc?=
 =?us-ascii?Q?IkHtzVoLDOPGZR2+MNbHae/qXhSqnzOssqMp1Sf0d8G5VG7VyldteJgxKMz0?=
 =?us-ascii?Q?H/WqryhY6+6o0K+C1dSMxQP8VsMtCHFuxUuVm5WG+NYq1hyt/ToOPl7SP+I0?=
 =?us-ascii?Q?JEu6yP38KVcq9b2vvoaRqPI/oMKhAUqjUtD54AnisAiLRq4JM7tWEnKtZE8b?=
 =?us-ascii?Q?SVgWPj7KJioYXFiMeEwcmB47IxyD2jPw33gaiGZXgNB3LVgoBn4kFhyv4Kk7?=
 =?us-ascii?Q?joJqxJbSKB/SrblQTKj9K7JQPWjhvZnXG6wrYDrtLvwqKOrTUL48E5NV4L7q?=
 =?us-ascii?Q?vjQRo2bp9nUhFLciJ7gpszI/1pSdYGRwd1CdAX2qhn1o5u1J6s6ESkX/wgSD?=
 =?us-ascii?Q?vqb6bvBaHNMqmAVlm9tQaNu7Jl0n45SFv9eolSI1nXspteXkt+OTOSHytObB?=
 =?us-ascii?Q?9MmYr67uT8y/nx/e8OuUcqkenPcfvWbkgTvwAEyYniSZjIetnObOyOYZZCwC?=
 =?us-ascii?Q?nA5AlYL54n8Cn1IlSwok8/QHNol2NGMfh3ZcKS/bRnzcfLsCt871txYBrjOO?=
 =?us-ascii?Q?Ds0Ms4y0xRpICBNH9PQkqnc3HTTOcErlt7Cjyvk+KQBW+VvkzJhhS2ceTXRI?=
 =?us-ascii?Q?AwwRjOkc7KJGfRdLKgMKYq/0zBxIraYnYqLQBHx195GuOhWqqKqXv53IcA8f?=
 =?us-ascii?Q?+Qu3Tu5CCGy2hDN89/Odm/1fpR3V5i9OuzRIFWljQtd1B6ljUExxnyPsO7YE?=
 =?us-ascii?Q?Pmy7zJsjPsvN8DB+6tNA63x5s3lQwdzvor83FyZsm3uuf5zALEyvatHBxTDd?=
 =?us-ascii?Q?OS4OhHr0/3L1tet7VYyZNGloxMb8MIkXw/ni/4e23QGBV8xxLs6Q5olDRGRW?=
 =?us-ascii?Q?pRD1yB+85smHQAKywA8luEyn8qdiZnkbheBr3sWfo1JomIE4R3v9fmocnsnV?=
 =?us-ascii?Q?7LdbPjftP61GwiLrceZoHD4wlN3kka9VKAZEZKTXuiZcMKjCNlfq/FXqu8QR?=
 =?us-ascii?Q?FMYbn0ukD1w/CPrHATUSSywW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43f1ca7-1280-4629-5c80-08d981c96a07
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 15:13:52.8725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X29v4KaJ1NnRw2m+Ku8vFNx+TmvJ2ZJpwpJm4m/wNpJ8o+x5kI1VH0wS1cXsk7qUUIo1OdqN7WXLDG4lIf2+s/of2ZTURnBsSO8JIN/PvOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=945 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270104
X-Proofpoint-GUID: XV2WxNfYwYViJ-Zn-l-CdL4N4q4FkIHr
X-Proofpoint-ORIG-GUID: XV2WxNfYwYViJ-Zn-l-CdL4N4q4FkIHr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 04:58:45PM +0200, Krzysztof Kozlowski wrote:
> On 27/09/2021 16:26, Jakub Kicinski wrote:
> > On Mon, 27 Sep 2021 09:44:08 +0200 Krzysztof Kozlowski wrote:
> >> On 24/09/2021 22:14, Jakub Kicinski wrote:
> >>> On Fri, 24 Sep 2021 10:21:33 +0200 Krzysztof Kozlowski wrote:  
> >>>> Indeed. The code looks reasonable, though, so even if race is not really
> >>>> reproducible:
> >>>>
> >>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>  
> >>>
> >>> Would you mind making a call if this is net (which will mean stable) or
> >>> net-next material (without the Fixes tags) and reposting? Thanks! :)  
> >>
> >> Hi Jakub,
> >>
> >> Material is net-next. However I don't understand why it should be
> >> without "Fixes" in such case?
> >>
> >> The material going to current release (RC, so I understood: net), should
> >> fix only issues introduced in current merge window. Linus made it clear
> >> several times.
> > 
> > Oh, really? I've never heard about this rule, would you be able to dig
> > up references?
> 
> Not that easy to go through thousands of emails, but I'll try:
> 
> "One thing that does bother him is developers who send him fixes in the
> -rc2 or -rc3 time frame for things that never worked in the first place.
> If something never worked, then the fact that it doesn't work now is not
> a regression, so the fixes should just wait for the next merge window.
> Those fixes are, after all, essentially development work."
> https://lwn.net/Articles/705245/ 

Yes.  He's talking about fixes to new features which don't work at all.

I once discovered a module that had a bug in probe() and it had never
once been able to probe without crashing.  It had been in the kernel for
ten years.  The developer was like, "Yeah.  We knew it was crap and
wanted to delete it but that was before git and Linus lost the patch."

Anyway, this is a security bug (DoS at the minimum) so it should be
merged into net and set to stable.

regards,
dan carpenter

