Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CC73D9F62
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhG2IVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:21:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42630 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234256AbhG2IVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 04:21:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T8D4w7018527;
        Thu, 29 Jul 2021 08:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=JmYFd2SkDy71cpK/yYGspSNYr57o1yTyj2md/kLuwzk=;
 b=Axc0fZG3aT4YotmtMaFwCgJlyZCnXOtXgNTK1WuyF68vpT+G4Bh9pCTuVT798QWPUy2a
 rGElYsDwTbpCeyUbZ+kn0pRf7DAegmnXnnguz7/CslS0jvSLF0jkUuk2KiACEHoONPvq
 oLewMmtBLbvI8hNhB8Cik1AyPO+t5rNSEcqb2GKl0rOAn1Tl37pq8Cr92L9XWHl10Bxq
 D0vwgNnxRleEnP6LklNvrvfFhwAjj4b+QryaYTdMRszteK4/1P7py4bQaITC4QxeADYA
 0mT4WUHJX2fNplRSReEm71lH1KcLISZ40GtY75Wdj0LA2hB/OFqYBpRUtScdOB2L3PU7 NQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=JmYFd2SkDy71cpK/yYGspSNYr57o1yTyj2md/kLuwzk=;
 b=C+yXN9haD08t/nXmJ65j3U95L3GrOh8Gr+Fn9lr0JZYktjvBYQOWeO5CGTQF1NhVD8UY
 KI1nQEOuCggILZVHeaAc+q5azXoD3KCxiUV4ObVLn3MYb90vJ181nnZ7hUEcvUyu0JZ9
 RkkvajO4ooTKe7w2RlRBFEoMKvpBBI5LxabmqbMJux4uBv+cwjuPvnDolXUEwGVF4pvf
 THbgpno7x2NWP/NxwbB1Z3FRWwHVAp7P09/jrafrDTYt0wUKJYgQJrYlgH+NSaPM7VO5
 3z8nUvkKAoxXOXwrOWny9T34e17MVZK3mn5GGYzoK7ibEOV0yubSq5dQ4cfhuTgZbYey Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdps93c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 08:21:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T8Cah8085774;
        Thu, 29 Jul 2021 08:21:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 3a2350ekbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 08:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0zjCoLOas1Er++T+HxCruPcCWpOVgHtEkg6Gr6lvzz48KNUNn/Mcm36mun3mtuIZLoLisW3WL5fjcfcSultPUYT1uth1WVfKWKx/Qlmq0CSPXzR0GPeJSUP4rpp5LOYY7Zx+zDkFKKU6+JjdH422cZdUsTpJ3ueotxEUMf3phlkxgPTHqSIoadEV8AFdYPDc9sJgCz+LOs86Yj3G/kX1X46NuHepJYQogH2yO4YQU5aZTSjegZMT/+FvTNaFY5LVbDyprKzQ6wPyXJT7cBy5gyjl+vtNuQyB08+WT82lC4612A/TE2TsXXj9/HI9Aelxb+ksDmUr6x5gIjBzm446A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmYFd2SkDy71cpK/yYGspSNYr57o1yTyj2md/kLuwzk=;
 b=h79i88cs4lx3v25244yjzCCi1Qzjt+XonxO3PCvii5dxr+524ibWezikpI6otiJtyEOpJnLMw24pqd2dyvBGpZtd9m0LfEMsvOq3LK9+X9Wxb+mEdesegylWBhnim6oUhLHs95k8JiIvh8idKIIzXYNNqQsb6hafDzih+dVocV5/DyPQyASi5ZhjRaopK+CsmglkMpGvq6d5jSxZp2tb/Y3Um1EwJpgxcY+TUqZ5HMEre+fdBXuo4dVWFSis2HdDWnFPKXz3Pe5LE871wwbNOVEFTtqwVBCPf1ja77XZmGaDts4UXhkFqVC4FjpUwxQVHy0z2RgQnWak8wK4nTwx5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmYFd2SkDy71cpK/yYGspSNYr57o1yTyj2md/kLuwzk=;
 b=OTw92CJjnkEzXE1b60n6yjfSLZ7mShzRdVG3onRT5qkhXctM/wRAWoOsmkdrUijHDOTxx1I/tTErGIQGun8ZhIWbOIR7m6w5WTUkqCxf0pFimKG5xBvnWQLtb5gQSY130EdoD6uYhB1odPnNnmDF7Dl51tfOO8H7PUndSW3z9OQ=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4417.namprd10.prod.outlook.com
 (2603:10b6:303:93::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 29 Jul
 2021 08:21:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 08:21:15 +0000
Date:   Thu, 29 Jul 2021 11:20:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     dsterba@suse.cz, Bart Van Assche <bvanassche@acm.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210729082039.GX25548@kadam>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
 <20210728213730.GR5047@suse.cz>
 <YQJDCw01gSp1d1/M@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQJDCw01gSp1d1/M@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 08:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d7fafa5-18de-4410-b92b-08d95269d4b2
X-MS-TrafficTypeDiagnostic: CO1PR10MB4417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4417584082805B9BE4D8B36D8EEB9@CO1PR10MB4417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnOvkRHyrrxCcG4DwtTgbGfPbRQYX6A30EshiK50zxziXPZ4JPCaWkRUrxOsWlDBHkOf2Eu8wto1lPWZz01rQZ29E6WzahS5/8Krzoe6Aw/M5Z0J0tAxuVV3SsR2Egcfhzue+tmgX43nCZQ9REbgtYRcK1Ob+FwE0BiMNyvFZj6zqF049+26iKMsgJD0teTTyx4/jKImnzz7CusQ+dIBE317S7sFgwkxG1TvcYxtrKG4ft7GCYNW3XIhX3AMgAsKkBrgXd7Tx0ZqSjYRjlz8YgnKfWpXlwtYCUkDqnZMsa35CeUNU5KPUOgGdVi/9zXUMq0wvaljBASwzdNCLoefWEfSZkm5BU0wvXhyMqwNPfOZfswC+LklCdSX9yyq8zUSaEB/aWKyueT/3C7cbw0h5BL/nxF1FC3TdNjjdcGdjai/OJwOgyjdsleA8rZ8oQ+2jGqFo+lBFks5BiKV6HcqUkQIrJvKFEsR1lwq3hxqYSidH6dPW+v/0zaqRzTvT4LZGtAtw30EJvDNMeph1pJjh/lFsL6XSZuHviOxJMY1YB3bept1HJK31lnj3wBKdTCKdgqvtjmiyD3NK5BZ/rXp96OtPw3VZEO3P8cBghRZJ1LA8oz7RCSYUMlauxcxYMQv5V0Y3mUNu6+NaOb9YhUuT9/SGG8p8HGV3c2bAYAZk7PmJklY/lONlcyDwhwu8UjtTcyeoFH3cYV5Eqp8OK470ETJU48Q30euJODy81DPZqNWTNTnUexD+il0jZ1hUv5U47ekBFggxDkieIME0CrynvIlAOqYmWCD48dS3bT1/gdvqlZAAnTQB7RmT4jjNtSoPl0CuwvRFMXyzZh6JtVd8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(53546011)(6496006)(8676002)(6666004)(1076003)(52116002)(55016002)(4326008)(38100700002)(956004)(9686003)(26005)(83380400001)(38350700002)(9576002)(6916009)(966005)(66946007)(54906003)(44832011)(66476007)(66556008)(33716001)(2906002)(186003)(8936002)(316002)(508600001)(86362001)(33656002)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXdgRyUnu8MferQu9SDEl+SvbJZOrNM5lFDpV1S9uEPKQUKwLlGCTnOppV32?=
 =?us-ascii?Q?xXjPw3rb6pScc9ezgP4LxTOn9k3TN9m4hq7nN5ZN4hnsvWK5Q8DDtb8t2Wm8?=
 =?us-ascii?Q?afG8Wacp+gbZP96/auExv8Jsr/ABvZqKtLAFstw4up6s/0vg3AJaua5Z6deC?=
 =?us-ascii?Q?tgKn/5BHL685XqGnYJ7HuNjsfkXb/KlcM7Yo3KjZJCKqXVb4/hiUnqOjXgOJ?=
 =?us-ascii?Q?iyoCz0gam1KouzRC09OFBgAYlv1pUSlboMRWtDFi5PUHBM4arGKYKo4J29H6?=
 =?us-ascii?Q?yqgWM90cP8BmgKRgLMxBfH5csXeM0cPZmQPkX6cwbuFCKmzwP2/7sGUzNS+s?=
 =?us-ascii?Q?IIyXeKSt3NXuZoqRsHmTpS4kRXO0UDEAwRTL/sFkiiMSxwaNol8/F4GVGNJS?=
 =?us-ascii?Q?lJZA4F7eDj7MZszwzTBbALR4PaVYDDSx4pAfkX5P/wq4U2UkiVyT7MaBq8yP?=
 =?us-ascii?Q?I9E9FngPNmhWLEdOnUlIKD3O7j8061xr2uvsEG3kMCCyWgfCJc0og7V3L7hd?=
 =?us-ascii?Q?ExfUjwRJ+6HXPrUdVNMgMhB9h3ihUgpGjVSVyza99wn896f6Ya/kdfwSmvNW?=
 =?us-ascii?Q?5qOmFH1cMEAbureywQDgrBDUhg64ysTedK5JuquXM9GmHkINPJgdIZrHNRt1?=
 =?us-ascii?Q?7Hs2NnnphHRhuv6DLkJnaD29F+HS75jV+xjBHPK/YJzrwk3HfCKTTJvRzkqs?=
 =?us-ascii?Q?THcLFvvvyaDblDa5+gTxj08TKKkP+XccXiBrXoVzxWvMbwh9MUOktIx4UELI?=
 =?us-ascii?Q?vqkYI7eXvZLYUQrZWrDi26b3W+5Rley8tMqdrF1y3DYHIUKjzpCwo+dK1n5R?=
 =?us-ascii?Q?0zDesKy6SJcq1UqXaeMy/b803N3ZGuy1Z2Vih9jzsnVG4VRX/ud6TSy2rbyF?=
 =?us-ascii?Q?UpEKQ0c3hVftYHoRGUa9WjVAS3IeVROD5WjcP4kK0mbmLfO+1e4zfKnAiowX?=
 =?us-ascii?Q?BXZZ85p0z6KRp0L4AUSjbSvAWI8HB4qxtRpN9w8gCtINDVlbKI3XcT13l+RG?=
 =?us-ascii?Q?BPpx7tZ6qiIOAAEkh5ZTZ3YqvBd1/Eq6Q750h+tHAPmIMjzcQEUdkln/Szhk?=
 =?us-ascii?Q?r3wxvwRZdJvjwxa+WacnaI5usFcUhKpyLQxPkw8aWiOAZjTT3X0PktMzYvMD?=
 =?us-ascii?Q?10ISRT1tsrx3PYfqa72EaRoqijH9+G9pgsseQQNLPqNkIuJD0FgEJQY/64xf?=
 =?us-ascii?Q?1GjuwbrEgCfxolbq+OiBZdHTpK+Ughyf4YxE3UmvEDiGMRH+JkHYLXBYy84g?=
 =?us-ascii?Q?n5C/SolqyZALHB0g0aSpamRBlYCtahP1BcgBuEdqunkV9+7frsm+gFJ85pbH?=
 =?us-ascii?Q?Yb8lsRVKmkr6zxnXeF/ph9iY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7fafa5-18de-4410-b92b-08d95269d4b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 08:21:15.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOr9LvfAtIklxz6y8dAbsZ6qXbw4OG/JsYnPo9lvu8Gded/LHr1C4h/w9nftCCLEVU9AFxdSsXGjNulUpJdrXXilA7IN/XQH1sAq45rXL74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290054
X-Proofpoint-GUID: eUKBK8cjpQfGGAVtZFbayoKMkY_ygy1d
X-Proofpoint-ORIG-GUID: eUKBK8cjpQfGGAVtZFbayoKMkY_ygy1d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 07:56:27AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 28, 2021 at 11:37:30PM +0200, David Sterba wrote:
> > On Wed, Jul 28, 2021 at 02:37:20PM -0700, Bart Van Assche wrote:
> > > On 7/28/21 2:14 AM, Dan Carpenter wrote:
> > > > On Wed, Jul 28, 2021 at 10:59:22AM +0200, David Sterba wrote:
> > > >>>   drivers/media/platform/omap3isp/ispstat.c |  5 +--
> > > >>>   include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
> > > >>>   2 files changed, 36 insertions(+), 13 deletions(-)
> > > >>>
> > > >>> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> > > >>> index 5b9b57f4d9bf..ea8222fed38e 100644
> > > >>> --- a/drivers/media/platform/omap3isp/ispstat.c
> > > >>> +++ b/drivers/media/platform/omap3isp/ispstat.c
> > > >>> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
> > > >>>   int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> > > >>>   					struct omap3isp_stat_data_time32 *data)
> > > >>>   {
> > > >>> -	struct omap3isp_stat_data data64;
> > > >>> +	struct omap3isp_stat_data data64 = { };
> > > >>
> > > >> Should this be { 0 } ?
> > > >>
> > > >> We've seen patches trying to switch from { 0 } to {  } but the answer
> > > >> was that { 0 } is supposed to be used,
> > > >> http://www.ex-parrot.com/~chris/random/initialise.html 
> > > >>
> > > >> (from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/ )
> > > > 
> > > > In the kernel we don't care about portability so much.  Use the = { }
> > > > GCC extension.  If the first member of the struct is a pointer then
> > > > Sparse will complain about = { 0 }.
> > > 
> > > +1 for { }.
> > 
> > Oh, I thought the tendency is is to use { 0 } because that can also
> > intialize the compound members, by a "scalar 0" as it appears in the
> > code.
> > 
> 
> Holes in the structure might not be initialized to anything if you do
> either one of these as well.
> 
> Or did we finally prove that is not the case?  I can not remember
> anymore...

Yep.  The C11 spec says that struct holes are initialized.

https://lore.kernel.org/netdev/20200731140452.GE24045@ziepe.ca/

What doesn't initialize struct holes is assignments:

	struct foo foo = *bar;

regards,
dan carpenter
