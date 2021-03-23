Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B74834682B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhCWSyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:54:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhCWSyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:54:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIjeAx050129;
        Tue, 23 Mar 2021 18:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hiYr2Ddg4oPBNqutd42WXBEVz/3+kW38H6OWf2o1824=;
 b=ZPBGUgQfcVuJOdE5uy84HMGSZMKktTphUYJJBdPtM7o4UXygIBy8IJH/N9xdpkilsZuK
 2+0ss5C8LcHAGbCOEzIo28igND0ZiFZZyysOErgozWAhHGux1IWt2JQMcyLBdwR9VJY9
 eAG4OuIpikOGCRNsk0qMGl1SxcCfgSw7it18C1nQbJukTSvxY5lIY6FU0ZNOTK6L101L
 CiKQjSynDWgicO5rMMpooaPdiMi9btrGEK11yYVAm/TDIiAcmjdQTA8+4CIEIT1VDmq9
 jC/ZMEQ0zqH5BblY3+lh5qDHk3G3ZdnmQ77ac8e2G89nw9X6ZE1WMzTiamgcKWButXX/ vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mg80c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:52:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIkA6Y113190;
        Tue, 23 Mar 2021 18:52:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 37dttsb3nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:52:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVQ+fVl6uaU1MDrrGNNiPw4S/+zOjinsOaV+AXSm/QnZ1gBoBP+SPZ7f+AIwwy65LqeCYkBYfPvTUFZAlP8HgHP5EzdNXqfIOW7HWDj8uQMoVYllud+FbDb31kdbFMvkzTc0SU+8VyVNfPDDmH5PXQwTYzou9zT0IUdmSAAFz8oVqcLBnPmL63xoneyC8z6RZyn9AT3pMpD9u+fCKn4Ad0GvZdQrCPIca1s+ZFdZymbjc5hyWTM+nqohS0DJsFptPOqtbTRcxz06Bqq1mp+PMRvBAgyLpVJ5KMRP1WKPkX/0bi+7omsZHVhG87QWo+VbmNbJ2lx0WhNQuHmTVn0XxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiYr2Ddg4oPBNqutd42WXBEVz/3+kW38H6OWf2o1824=;
 b=jkNScJrd6vgOSwlJPGeYTOVYM4m88JlZqtlzmw0hMgvfgtreqsV9ThJ0Q/EDjjRiyAWxiwAyQEnOwriAskppcUdzlWC5IoeApncz5xOyq3WUWDBw+aFmx7G1OkgGSh438/MtirIiG+ejvcOtzRRXxmArAEwJj/4AwU3EA/qy5kUAuUmdQnx6XwYBymurNPVUBTh3OVCNU9ZcmN4zMfp9PRPXHQDG6JRafj1+CoBN4y/II8gSbqGj4CKId9c9Tr8KrCui0f/P1dRe9rHYNSn5YMwi2MAPKz4FX3/MmyaLKeLtMP5dOwi4tkdSW8tbhjVdPr8v1fTUVtxkt6dwstdliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiYr2Ddg4oPBNqutd42WXBEVz/3+kW38H6OWf2o1824=;
 b=K+bA9A2vE23D77968ckEqN9bUu9m7HNAx2Eo6ya31qkP4TBW1nV5mpiuGC6MuB/ZWe+ySXAqu3cAaiwvW1VRH96fLrTjh65xHcLhHfKqjv6YBJNFGXQx64GJiMSQhkhO+TMHoL513RLesRRN0Yed6nA7tQhtst8I4RnwPO9D+JQ=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3110.namprd10.prod.outlook.com (2603:10b6:a03:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Tue, 23 Mar
 2021 18:52:35 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 18:52:34 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Thread-Topic: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Thread-Index: AQHXHvxh39vYR/ByH0SHQRVYSjGN/KqQU18AgAAXrwCAAAwKgIAAByWAgADtmYCAADyVgIAARPsA
Date:   Tue, 23 Mar 2021 18:52:34 +0000
Message-ID: <AD267230-8422-4AE4-A315-82C8DE00AA46@oracle.com>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
 <20210322194948.GI3697@techsingularity.net>
 <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
 <20210322205827.GJ3697@techsingularity.net> <20210323120851.18d430cf@carbon>
 <20210323144541.GL3697@techsingularity.net>
In-Reply-To: <20210323144541.GL3697@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89b85105-2c6a-4e97-0eac-08d8ee2cd277
x-ms-traffictypediagnostic: BYAPR10MB3110:
x-microsoft-antispam-prvs: <BYAPR10MB31102D0AB46DAECD653D071493649@BYAPR10MB3110.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kgp/V5a6ovfqvbWLYV5qAMIhI50E+4ljyt9nxeyGBuBSFBNcWywYtTEloVxewe2KLk4L1f70xkjU1d8/YaspUBfVhOKtXztcNqR65dtjqPWMPD1ATMnb/GKaXBeTgc7FhAS6YMzygJhS83g0aH+TyAaCldBAUz7pYNCCw9+KtnyNsjCzGdmliHjasZyZClRARwj7vGjX9jItMPwBtvr3NXpEn+VYf9Scu8Q5xr5ZJ1E9va+x8sJSeF++Sh+qCOEXCUISLw6qilhR/q8qR1J/gCm77Dhgh+zkbhFXzCaqRJfnkbxaCyTGLeeYf1yAjBvh+OHTSyeljcsHucy2vx/F/T6hogOkj+aS/MIu+yYKsWGarZvPCwrpzj2EX72plyjs9FsE6SUWgGiLi1oowqwGPs8GHVQtNVXZ1sv3tYbTBSdJtVpMSe+RlDJcNbKxGQs2Q3eMm6XuVmz24fEuYD7nayUfKYtnHzHm7OZmBF7ZTcCQndeRLzHLx1suXv83Apl4pI6OE9MDTRD2fUGOIosMwaM/a1JrfKHjCwihjOeOQchn+KJfjM77CPrdAbiZH15w940awo/2qPsk2taIiu0ndvKuJoJeb7Zo84meJD3hYPT46W87Y2KxCrWL0WPDRNmCvmVC+PkDHpMrvGuISjqqlUpcQMm2yIYURbSNaqsqbc1eQNuiFJEDQtbe/bQv/u8y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(366004)(396003)(136003)(6506007)(71200400001)(38100700001)(6486002)(83380400001)(53546011)(26005)(8936002)(86362001)(316002)(186003)(33656002)(54906003)(5660300002)(7416002)(4326008)(36756003)(91956017)(66946007)(76116006)(2616005)(6916009)(478600001)(66556008)(6512007)(8676002)(64756008)(66446008)(66476007)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6TNdFWp0S5q8wROGjq3uyq2gFNmty/rIyUHhOJFNduWPXpczvPxpAmHxBouR?=
 =?us-ascii?Q?MM7kAgayWK4yPA6mTJitxaA6DrBP/HmztpuDoPlDWj2srK81m5Un2NwSbXBB?=
 =?us-ascii?Q?va4cAmA0syZttHvmfjuMqxMJ6FDPaw/kiF9397kmB/S8j05NdCqN9ndFs0P5?=
 =?us-ascii?Q?+twtyQ148h6B2mTiKcuhFPTA5SYFWQAeQbC3pBrRajiNLfViwOh3zEZl1Iav?=
 =?us-ascii?Q?TvXabp3mT6LLKPUtUmo3n0NPehB9ERyWP6NMfhctZwhXv3o3l5DuYsgs6GeR?=
 =?us-ascii?Q?OVK//e/AG8q+l7zcDuV5vYo+8F5UG0+ZcLwMPkA3w6/mkR/JYBfO/zsZTAnL?=
 =?us-ascii?Q?eelP0DO3XCVTetafn1GRH6LEBDJ2dOUBVz1QBDzqZD4NhFpEfQUFSapHM45+?=
 =?us-ascii?Q?zn0eeSHwAvPmutLVy1LHEyBH0IWhNgGIHUrQHQ/6e45BwQm5Oon5aeze1WJx?=
 =?us-ascii?Q?m+WMCujr18mOFNm9g23zkReKXuLf/mVPSps8lpinhlZaK7rB4I6CiVEaSSt+?=
 =?us-ascii?Q?DR84K35WfLm87SkzgYquTVcnCjtdvushSjjNNkKSEWjmIw/d4s7oOnHzNWIC?=
 =?us-ascii?Q?nUPivKwqQxZmjltrJGDgK1QOTuI4DdG2kapW7Iw1QmZuYEMGdhd25OlA0qwK?=
 =?us-ascii?Q?MGXoQCr48QB9989FkKu38m2KbHi9j3BpYzf9MTw+hduuKTbikPcu7gR8d2AH?=
 =?us-ascii?Q?6458eXt52MI9JaPd5pzSZRcb5aS/F1tCwbpqm87L7bPgEun3wE04oGhfUWYv?=
 =?us-ascii?Q?ZoCAx4AmYhypJ6iVYDToEWlnoUt2ezTsBQTyGJ0vgQrC1KZ95e+2LsfJT5jg?=
 =?us-ascii?Q?9cdmRie0C8kbU1PTlgUD7Cvopi8gHLRjmBhqPGROqCdk6ZAuHmh5yU/h4dDf?=
 =?us-ascii?Q?VTSN1twSn0/nCrfIAUUCH6gStWl+jV67tzBUezUEc7dFkoAEINl6DHc3huM+?=
 =?us-ascii?Q?keVrjZXlx7qATlzncnq9niKQkGKGTpS2bcwXk29MwKYWWXbK4O7lHIFYdgGV?=
 =?us-ascii?Q?ZWLkbnntGTaggTQ1lyYGTTZTcJKu8lkwFDozXQamfoHPfPQqcSAfCvCIBjir?=
 =?us-ascii?Q?+OotMtaR+Ol1wsb+Q1RYZ/SN3Sa1rh4bhPKspjjxb/MWfqG25YOxuL+QDkSi?=
 =?us-ascii?Q?eeu7QJbBdoDUzzXRPDr2BE/Xp9PswroyltmKxb7x1jPCFu5cyU5q1EyovCGG?=
 =?us-ascii?Q?kWB8VYRBTWdEAkAQ1pVGN2hUf8/sxIjx4BPM+MuJn+r0VE9s5iBVMwEr3En6?=
 =?us-ascii?Q?d/x0KFjr/fRbNoioL6QGxXETVZJ4a/NbTnc8Qk3XSlNeS9wOCd/HaeVrB2wg?=
 =?us-ascii?Q?zp0POo60k4PPn4F6KUpMBC15?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41A98A0644136B48A8B6546D31C06902@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b85105-2c6a-4e97-0eac-08d8ee2cd277
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 18:52:34.9436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y757Trml1rqqZwNyOxLkMvDZ0MvRimDJmQzfzB3ApBt7OICo5eaoL4UlBxVij9T4E/dbWfNW6fECg1fRQ04odw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3110
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 23, 2021, at 10:45 AM, Mel Gorman <mgorman@techsingularity.net> wr=
ote:
>=20
> On Tue, Mar 23, 2021 at 12:08:51PM +0100, Jesper Dangaard Brouer wrote:
>>>> <SNIP>
>>>> My results show that, because svc_alloc_arg() ends up calling
>>>> __alloc_pages_bulk() twice in this case, it ends up being
>>>> twice as expensive as the list case, on average, for the same
>>>> workload.
>>>>=20
>>>=20
>>> Ok, so in this case the caller knows that holes are always at the
>>> start. If the API returns an index that is a valid index and populated,
>>> it can check the next index and if it is valid then the whole array
>>> must be populated.
>>>=20
>>> <SNIP>
>>=20
>> I do know that I suggested moving prep_new_page() out of the
>> IRQ-disabled loop, but maybe was a bad idea, for several reasons.
>>=20
>> All prep_new_page does is to write into struct page, unless some
>> debugging stuff (like kasan) is enabled. This cache-line is hot as
>> LRU-list update just wrote into this cache-line.  As the bulk size goes
>> up, as Matthew pointed out, this cache-line might be pushed into
>> L2-cache, and then need to be accessed again when prep_new_page() is
>> called.
>>=20
>> Another observation is that moving prep_new_page() into loop reduced
>> function size with 253 bytes (which affect I-cache).
>>=20
>>   ./scripts/bloat-o-meter mm/page_alloc.o-prep_new_page-outside mm/page_=
alloc.o-prep_new_page-inside
>>    add/remove: 18/18 grow/shrink: 0/1 up/down: 144/-397 (-253)
>>    Function                                     old     new   delta
>>    __alloc_pages_bulk                          1965    1712    -253
>>    Total: Before=3D60799, After=3D60546, chg -0.42%
>>=20
>> Maybe it is better to keep prep_new_page() inside the loop.  This also
>> allows list vs array variant to share the call.  And it should simplify
>> the array variant code.
>>=20
>=20
> I agree. I did not like the level of complexity it incurred for arrays
> or the fact it required that a list to be empty when alloc_pages_bulk()
> is called. I thought the concern for calling prep_new_page() with IRQs
> disabled was a little overblown but did not feel strongly enough to push
> back on it hard given that we've had problems with IRQs being disabled
> for long periods before. At worst, at some point in the future we'll have
> to cap the number of pages that can be requested or enable/disable IRQs
> every X pages.
>=20
> New candidate
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebas=
e-v6r4

I have rebased the SUNRPC patches to v6r4. Testing has shown a
minor functional regression, which I'm chasing down. But
performance is in the same ballpark. FYI


> Interface is still the same so a rebase should be trivial. Diff between
> v6r2 and v6r4 is as follows. I like the diffstat if nothing else :P
>=20
>=20
> mm/page_alloc.c | 54 +++++++++++++---------------------------------------=
--
> 1 file changed, 13 insertions(+), 41 deletions(-)
>=20
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 547a84f11310..be1e33a4df39 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4999,25 +4999,20 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_n=
id,
> 	struct alloc_context ac;
> 	gfp_t alloc_gfp;
> 	unsigned int alloc_flags;
> -	int nr_populated =3D 0, prep_index =3D 0;
> -	bool hole =3D false;
> +	int nr_populated =3D 0;
>=20
> 	if (WARN_ON_ONCE(nr_pages <=3D 0))
> 		return 0;
>=20
> -	if (WARN_ON_ONCE(page_list && !list_empty(page_list)))
> -		return 0;
> -
> -	/* Skip populated array elements. */
> -	if (page_array) {
> -		while (nr_populated < nr_pages && page_array[nr_populated])
> -			nr_populated++;
> -		if (nr_populated =3D=3D nr_pages)
> -			return nr_populated;
> -		prep_index =3D nr_populated;
> -	}
> +	/*
> +	 * Skip populated array elements to determine if any pages need
> +	 * to be allocated before disabling IRQs.
> +	 */
> +	while (page_array && page_array[nr_populated] && nr_populated < nr_page=
s)
> +		nr_populated++;
>=20
> -	if (nr_pages =3D=3D 1)
> +	/* Use the single page allocator for one page. */
> +	if (nr_pages - nr_populated =3D=3D 1)
> 		goto failed;
>=20
> 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> @@ -5056,22 +5051,17 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_n=
id,
> 	if (!zone)
> 		goto failed;
>=20
> -retry_hole:
> 	/* Attempt the batch allocation */
> 	local_irq_save(flags);
> 	pcp =3D &this_cpu_ptr(zone->pageset)->pcp;
> 	pcp_list =3D &pcp->lists[ac.migratetype];
>=20
> 	while (nr_populated < nr_pages) {
> -		/*
> -		 * Stop allocating if the next index has a populated
> -		 * page or the page will be prepared a second time when
> -		 * IRQs are enabled.
> -		 */
> +
> +		/* Skip existing pages */
> 		if (page_array && page_array[nr_populated]) {
> -			hole =3D true;
> 			nr_populated++;
> -			break;
> +			continue;
> 		}
>=20
> 		page =3D __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> @@ -5092,6 +5082,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 		__count_zid_vm_events(PGALLOC, zone_idx(zone), 1);
> 		zone_statistics(ac.preferred_zoneref->zone, zone);
>=20
> +		prep_new_page(page, 0, gfp, 0);
> 		if (page_list)
> 			list_add(&page->lru, page_list);
> 		else
> @@ -5101,25 +5092,6 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_ni=
d,
>=20
> 	local_irq_restore(flags);
>=20
> -	/* Prep pages with IRQs enabled. */
> -	if (page_list) {
> -		list_for_each_entry(page, page_list, lru)
> -			prep_new_page(page, 0, gfp, 0);
> -	} else {
> -		while (prep_index < nr_populated)
> -			prep_new_page(page_array[prep_index++], 0, gfp, 0);
> -
> -		/*
> -		 * If the array is sparse, check whether the array is
> -		 * now fully populated. Continue allocations if
> -		 * necessary.
> -		 */
> -		while (nr_populated < nr_pages && page_array[nr_populated])
> -			nr_populated++;
> -		if (hole && nr_populated < nr_pages)
> -			goto retry_hole;
> -	}
> -
> 	return nr_populated;
>=20
> failed_irq:
>=20
> --=20
> Mel Gorman
> SUSE Labs

--
Chuck Lever



