Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919E73450E3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhCVUd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:33:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48074 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhCVUdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:33:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MKTvMD163568;
        Mon, 22 Mar 2021 20:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DadPhUsG78/arcldR9QrUnLYM3AX3ULyx3WqnulTRmY=;
 b=ZH/TrQ3ekgEvfHDlbuQiIvjR8HdhZvJUN1KDujUXahlWjiu1M7cXDg9sCL4tk/TiVBlX
 YN5CnTemGveaRMp0q7i7bg3mboywswT8B6ALL3WSEDws9XOxwm5FKdTh/0NYxYMPXk6T
 Hdbt7J95t9jMDOF4BpnzS5bZDk+Qamc2DVLyH9E57nesI0L3AA0KLco/19bXasgI+gyG
 e16iII+y4sc4G7zFVMWCQM0KDUzgrV5wkAvLfSoZohHAYKealFVP6xF0xCkawiXAQHPw
 IcBhXZvfHZ5T4X6T87nWcDJUEUt+uPaeJG//E/zCChf9E6qbA8rHSpHrv9PPAQVN/ErP 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pmvr9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 20:32:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MKUMS1121353;
        Mon, 22 Mar 2021 20:32:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3020.oracle.com with ESMTP id 37dtxxdes4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 20:32:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDUT1684S+K5Z9dPeICs1poDtVzCwQm0nWtlr0NKI44Zd+t3wNTnVWFyo+2WkHRJvalACTzyt2qv7f5hHBp7KWwrCl8qWboEpfHZmpjXXKZJCxvtqP1zG64FOi6CYAm5+V4mIbUGFAFlJjMsDt42VnRKL0CSYoyDM/9V3VW/RLAf0q3fZKMHRAxCFtc/gBNFFdeDCEIfIuoCv3oMnA6lgGCzqH5yD/myjCQypo84H97gzV6WIX5bQMvMWlPfaumNp69eaxT79dZu3uliIItRivnf02qe3h6h8JKe8t8jww77SOt2Yp6qX+bmY+II5wzKTnDFChCg1JXCpj4oS+7SIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DadPhUsG78/arcldR9QrUnLYM3AX3ULyx3WqnulTRmY=;
 b=HmMnBdgcAsb6AcnJ5AGE1UbRRO+OmvPclonRbaEiKR+V+wpTumZwr/VmnovDzxVzGwJsZEXlxwjiXQdOFcysCeu9nsvSQss78BZWPky+FYsHsZMnnoNRGXXonh97WMdy6cRc7YuuPVPkTppcV0PdSw6Dwx5uC16jT+ZZ1JxYPs4SHslZCeWDM3u83aYKYALVoJ9ExDvt3GpWWThJG8OFUJJJloUiusau51WIsTuAqIlkYrKMxyrtCIvk4qWfZpuRR9ykSenArYrvOUVSSHrIANX64YRz5XIVbAzu3rjbzxD5q8RrHu12iFj/wtDqDuCKtSrXdxONkI3A2wibLsp1gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DadPhUsG78/arcldR9QrUnLYM3AX3ULyx3WqnulTRmY=;
 b=yIadbls4O0OuOg1A6D+8MTmDJML7thktdw7CrXglB0VsN2zeN7Ch3G/NmZPTM7gPp07tCbHmYo2YKUjZixFLAVWFA0tgO33zlsJjtAJvJHNPpFrgutdBUNv+TS49LHBxKT7o3wyifBCfD70Dwi/NY6REbBwYqwT7TDYm919DL2c=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3192.namprd10.prod.outlook.com (2603:10b6:a03:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 20:32:54 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 20:32:54 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Thread-Topic: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Thread-Index: AQHXHvxh39vYR/ByH0SHQRVYSjGN/KqQU18AgAAXrwCAAAwKgA==
Date:   Mon, 22 Mar 2021 20:32:54 +0000
Message-ID: <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
 <20210322194948.GI3697@techsingularity.net>
In-Reply-To: <20210322194948.GI3697@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daf9740a-f994-4d2c-550d-08d8ed71abc0
x-ms-traffictypediagnostic: BYAPR10MB3192:
x-microsoft-antispam-prvs: <BYAPR10MB3192F793867397F79DEACC1493659@BYAPR10MB3192.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rtk5q6D962fPFskkQ1M3fPINdvYhvPU0Xq3ZDRQX1ut/FXEYTDMyo3UgxRLAd+fFr845og5m1fP1oGppKbBn/ITIGvNM7EmVMQseRBEMyXSrkfRP1Dg493JROWydFprAT5ec3rosHWKne2Yelks5nL25dFP3Tgx8Ho4dWNa0nyYriF/YGYxjsHBT/GqFdpDRqf2ZZhritAMr4LnaUi+8Qn7slkQ4Oi1mV85082PSWqn3AB6tHM5mTiQ5IwZrFXJqzg4kq/6eJmERtS0Q6KSRHyzp1j3fusxaZ+ty4m8yQGaIfpcqgGPhD981slV2tE2+H+3Ee4+it4T7lzzSyMIWHuVaBGc058hG454lyyRjnCF0YATUX4R6s1RGW1b40TQ4lVmzVLsjvVvNAkQz5wWwzC0ZHB8RYF/o+cp40Qq5wkcuHN4sZYRVtqaegEm3HBpsX1B7KaCoYfDemOfrexQcy0e+yFKu6ZSFfYBLnyZPimkLL8KDvqRDRcmx6P7GWGKhkUJmy/bifDYGtTl7MyBGZt4bsU+lO3DpcK/lJSBVoxjPsb7/1InvNiCu/pQ1cqFaG0ngWn2r6qWnw/CNFIVAuYdywKU9t1/gbBRtGF/Eov2bjwHVzsivePMHUeh6b4MjQq6wenm8oPOnXLEwY0Z7Zw6lNcBwdTzHpIoLfwWC41rfJjF4oW98tqKnRraD3XQ/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(83380400001)(8936002)(66476007)(66556008)(66446008)(33656002)(2616005)(64756008)(6486002)(86362001)(4326008)(2906002)(66946007)(38100700001)(7416002)(71200400001)(6506007)(5660300002)(36756003)(53546011)(76116006)(478600001)(91956017)(316002)(186003)(6916009)(6512007)(26005)(54906003)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kqaDKejMXPTitpi244e9Tu59Ryp6xyMJMyQSHpz9G1/3ulFyWvPMsu04UHcO?=
 =?us-ascii?Q?3wtLXzKaQSCbAmGu6U9W3YBsQfH1QayXaHtmGgFxZGBNAhbQSK0y2x9/O4Gj?=
 =?us-ascii?Q?TdG3GGm8H9sWNaSeSVgdNN4o+isPJQGQhistRy6OEcQe7O+hWcBzsMEoopto?=
 =?us-ascii?Q?rfC4TA9RCml+joi94CV7eoqDgL96faCRkADKbeBJwxG6BfXek/wT67QA9HWI?=
 =?us-ascii?Q?ucoqKuwLTnz3ZrL8T1H5Rgd2rjCMLxWfjFsJM+nqyirFRlCVqeccMwCtj7Z3?=
 =?us-ascii?Q?w92U7NUgf2RQn22yiNLivQG35kfxVtW2z/ItxfTjbFcUN/a/6C50Fbpefu1+?=
 =?us-ascii?Q?Z6l0fFVrMKi7v1CIgpAvAw/sLJKvIt2igIXoTHZYojkxxmJNiglgisUybjKs?=
 =?us-ascii?Q?4l/br2X++Zksjus6QVk0ueLEEf8S2gUU8lakZB/nNivTgusHXVXfE2hN+e8K?=
 =?us-ascii?Q?wC5xC60Mrj3KvJ13cdOzZbRMoBeZ+zWTw1K6R6diupNP+agxy1NQNtgCd6Vb?=
 =?us-ascii?Q?407wtamsS9F7UeyxvBnVtaQkE5Iv3UX+eHb1TDEHfVprP/g7UQzT+IwX3Wyf?=
 =?us-ascii?Q?h5eBV9DwYGnqqO7XvWcuhodLEgqk2K33nd4obn5OAiSLiVpMglrCGxTxaNFl?=
 =?us-ascii?Q?IPJ6DvChuohVzhKfMylgWMKgK1Hh1OxWdiqc7bs2Ds20P4rO3/dc3qJSXHAh?=
 =?us-ascii?Q?Xy6cIfTLwUzcXWUnrV8t7GGPydOAfiZa01Akg2J3L1KvBctQeGthutod4UC8?=
 =?us-ascii?Q?ooe4YeHmGtLvNrEZ4I29xRrWgxNYsGqX552R2tA0kIppepTpb+9tPuP2kPbO?=
 =?us-ascii?Q?CeB+j8QT/sonsJ0LYwv6K96Kqz6lU5QaUdAGnNig6nQBnoN3KFaZKoUEBHBa?=
 =?us-ascii?Q?jJTEu6wRbiwdlUFPCkj9R0+7qtNu7/9AusarWqCbmZ70FWGrt7k+fc3ZI+Vk?=
 =?us-ascii?Q?dtHzPsGFnsn6/JN/Iuv1Na9vr9aldG9DPbfmzSoy/0D+ZqaHuzrD+Zn/fXZQ?=
 =?us-ascii?Q?ps78WpSD4MIWqYcnva+v8GaxF80uAN4hulLjw4t8L57fXm4vcFmiHwCpc5lf?=
 =?us-ascii?Q?fEaRNuz0YtgWp4XoP2wl5yaNi84xi8cDFJh8S8wAyA1twG1kYSfq14/MGn+9?=
 =?us-ascii?Q?U98r7ugCIoC7LwDLHHRICGW97t+Y67R3JK7MwuXatcW7yW/jNngaLB+252Oq?=
 =?us-ascii?Q?cNPOttL0rPkiotYyGW5ElWWwZZSWKCWXej3BRsRqZrZGOJhX0YnCkvIjeMs8?=
 =?us-ascii?Q?NvExKUKN4tNr+dBvNW8217+Zb0mx4HxqQOB5t+OMHkOs/XX6ocqmGoG8oIbg?=
 =?us-ascii?Q?SXj35IvslBOA5joO70GhLjZY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BDEFB7EE67A0D246B1DE1E3EB8B41F17@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daf9740a-f994-4d2c-550d-08d8ed71abc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 20:32:54.0654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6AbMfvNhIpC2tWFN4k/CalasaYtbEnBeFHOPu1JG0MY64KfQ50YC1hL4/xGpemI0WdY1TG5iQti4ynvm84RoLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3192
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220151
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 22, 2021, at 3:49 PM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> On Mon, Mar 22, 2021 at 06:25:03PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Mar 22, 2021, at 5:18 AM, Mel Gorman <mgorman@techsingularity.net> w=
rote:
>>>=20
>>> This series is based on top of Matthew Wilcox's series "Rationalise
>>> __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
>>> test and are not using Andrew's tree as a baseline, I suggest using the
>>> following git tree
>>>=20
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-reb=
ase-v5r9
>>>=20
>>> The users of the API have been dropped in this version as the callers
>>> need to check whether they prefer an array or list interface (whether
>>> preference is based on convenience or performance).
>>=20
>> I now have a consumer implementation that uses the array
>> API. If I understand the contract correctly, the return
>> value is the last array index that __alloc_pages_bulk()
>> visits. My consumer uses the return value to determine
>> if it needs to call the allocator again.
>>=20
>=20
> For either arrays or lists, the return value is the number of valid
> pages. For arrays, the pattern is expected to be
>=20
> nr_pages =3D alloc_pages_bulk(gfp, nr_requested, page_array);
> for (i =3D 0; i < nr_pages; i++) {
> 	do something with page_array[i]=20
> }
>=20
> There *could* be populated valid elements on and after nr_pages but the
> implementation did not visit those elements. The implementation can abort
> early if the array looks like this
>=20
> PPP....PPP
>=20
> Where P is a page and . is NULL. The implementation would skip the
> first three pages, allocate four pages and then abort when a new page
> was encountered. This is an implementation detail around how I handled
> prep_new_page. It could be addressed if many callers expect to pass in
> an array that has holes in the middle.
>=20
>> It is returning some confusing (to me) results. I'd like
>> to get these resolved before posting any benchmark
>> results.
>>=20
>> 1. When it has visited every array element, it returns the
>> same value as was passed in @nr_pages. That's the N + 1th
>> array element, which shouldn't be touched. Should the
>> allocator return nr_pages - 1 in the fully successful case?
>> Or should the documentation describe the return value as
>> "the number of elements visited" ?
>>=20
>=20
> I phrased it as "the known number of populated elements in the
> page_array".

The comment you added states:

+ * For lists, nr_pages is the number of pages that should be allocated.
+ *
+ * For arrays, only NULL elements are populated with pages and nr_pages
+ * is the maximum number of pages that will be stored in the array.
+ *
+ * Returns the number of pages added to the page_list or the index of the
+ * last known populated element of page_array.


> I did not want to write it as "the number of valid elements
> in the array" because that is not necessarily the case if an array is
> passed in with holes in the middle. I'm open to any suggestions on how
> the __alloc_pages_bulk description can be improved.

The comments states that, for the array case, a /count/ of
pages is passed in, and an /index/ is returned. If you want
to return the same type for lists and arrays, it should be
documented as a count in both cases, to match @nr_pages.
Consumers will want to compare @nr_pages with the return
value to see if they need to call again.

Comparing a count to an index is a notorious source of
off-by-one errors.


> The definition of the return value as-is makes sense for either a list
> or an array. Returning "nr_pages - 1" suits an array because it's the
> last valid index but it makes less sense when returning a list.
>=20
>> 2. Frequently the allocator returns a number smaller than
>> the total number of elements. As you may recall, sunrpc
>> will delay a bit (via a call to schedule_timeout) then call
>> again. This is supposed to be a rare event, and the delay
>> is substantial. But with the array-based API, a not-fully-
>> successful allocator call seems to happen more than half
>> the time. Is that expected? I'm calling with GFP_KERNEL,
>> seems like the allocator should be trying harder.
>>=20
>=20
> It's not expected that the array implementation would be worse *unless*
> you are passing in arrays with holes in the middle. Otherwise, the succes=
s
> rate should be similar.

Essentially, sunrpc will always pass an array with a hole.
Each RPC consumes the first N elements in the rq_pages array.
Sometimes N =3D=3D ARRAY_SIZE(rq_pages). AFAIK sunrpc will not
pass in an array with more than one hole. Typically:

.....PPPP

My results show that, because svc_alloc_arg() ends up calling
__alloc_pages_bulk() twice in this case, it ends up being
twice as expensive as the list case, on average, for the same
workload.


>> 3. Is the current design intended so that if the consumer
>> does call again, is it supposed to pass in the array address
>> + the returned index (and @nr_pages reduced by the returned
>> index) ?
>>=20
>=20
> The caller does not have to pass in array address + returned index but
> it's more efficient if it does.
>=20
> If you are passing in arrays with holes in the middle then the following
> might work (not tested)
>=20
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c83d38dfe936..4dc38516a5bd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5002,6 +5002,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 	gfp_t alloc_gfp;
> 	unsigned int alloc_flags;
> 	int nr_populated =3D 0, prep_index =3D 0;
> +	bool hole =3D false;
>=20
> 	if (WARN_ON_ONCE(nr_pages <=3D 0))
> 		return 0;
> @@ -5057,6 +5058,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 	if (!zone)
> 		goto failed;
>=20
> +retry_hole:
> 	/* Attempt the batch allocation */
> 	local_irq_save(flags);
> 	pcp =3D &this_cpu_ptr(zone->pageset)->pcp;
> @@ -5069,6 +5071,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 		 * IRQs are enabled.
> 		 */
> 		if (page_array && page_array[nr_populated]) {
> +			hole =3D true;
> 			nr_populated++;
> 			break;
> 		}
> @@ -5109,6 +5112,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid=
,
> 			prep_new_page(page_array[prep_index++], 0, gfp, 0);
> 	}
>=20
> +	if (hole && nr_populated < nr_pages && hole)
> +		goto retry_hole;
> +
> 	return nr_populated;
>=20
> failed_irq:
>=20
> --=20
> Mel Gorman
> SUSE Labs

If a local_irq_save() is done more than once in this case, I don't
expect that the result will be much better.

To make the array API as performant as the list API, the sunrpc
consumer will have to check if the N + 1th element is populated,
upon return, rather than checking the return value against
@nr_pages.

--
Chuck Lever



