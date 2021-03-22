Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13082344E87
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCVS0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:26:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhCVSZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:25:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIOGLR158440;
        Mon, 22 Mar 2021 18:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z2dk7K7T9DAppWx/xHWRtkZuAUvhZOoYyufY6yoM9pk=;
 b=YAgg9HmRIzgAZg88AtEh91JXhGsbdf0kfGAskLxHHYgbnD/sL2etP7ANV1m1vXiH2pDG
 iqjCkB/uL5sY08wVLplHhyCiHM90UCLZYEjMZOLtyKWiMCh+VgcJqqoFNU5of7iS26TC
 acTaaV37MWPsDoU4MaB+sqOcA8LrpPV2hMzgu878iZZPunNYQIMohOSCVlLjMxrisTBq
 pO0EB//9xUGHXZ4RyGQ507A65MOLyH4qJOIMaGPj74jQf+5FY9eUJrL15jtRhhmThFi4
 ++EpX762dOfVxWaO70Fl4mzqBsvVswGpbDEJNYNAISVDCq3TnbSjfYBdmN4gKqt6iuBe nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pmvd6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:25:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIA8Lk187091;
        Mon, 22 Mar 2021 18:25:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 37dttqwx5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:25:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jE/OhS0t0bxbly7qivKCMymQPAd5GtyuWFQSS8B5DW2JohDPuylVC+/3blgCo+y57/1qYfuEodkYpy490LpVpyGdCiDfFZMAfHuk7kdvkpjHlWcfquNeQoi/vtkYQ15pcFXa06i2iTfnRE1Tu3Tv3SMSnRBljBfBTvuLkuWIomIeZZYTl0QSSjWu59MSbpwOfmkPjN6xL9q8rPoP6XvXvzWyYIFxgCdAwrEc2daxgdiGt7UGAhDSQ6G6z4+C1n1OVeQQImOuMh2+6jvDDUIlgJqBCrCbRQ29REF7cUKVkhHMKdGeGn+QqYUU1jkYaJpl7IXizvFm8afmAxcLDtCYkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2dk7K7T9DAppWx/xHWRtkZuAUvhZOoYyufY6yoM9pk=;
 b=LupkM5j0F6UKzNEJDcNXzpPgJphMBs/IaQTj1T5beWCtLFxqD54MCKv9PqieNxXX8+2kkwundn4a9XligzRKjzV3OV5YeewdZ/u6QSYfWghQ0ORZfMRfW/f+xthanEpRE+OOV0nBXx56SYFAXhXvPOtjOfG2cBnRJ+KvMQNAp7uPHjKmtLxMnIJVF82XUuBLHrFJCYDsk4ykCIKbnZxmSoFMreMbnI/4iIu6ENYiC6wyzK/DUefu5hLLr60kysPOm1Kj7uzrepRXzIQVGbjCY8Xn1EosQw7ch9AAhYkac5CzVToCNtlJFVj/sIA8fnIf9Qew81l8dAbrtKZVcCTFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2dk7K7T9DAppWx/xHWRtkZuAUvhZOoYyufY6yoM9pk=;
 b=bwwiNZ0p7NTkbkIuh9dx/T4PsUIj4dAmDg56zyL2qvXY9+DPDhAyOLmax2AWv6TqI+idkgUfQfKR+t+A23XnJfpH4B4eQW+XwkPl1pqM5GyjPzmF6k5dm/hPo4Hm3o0itU24MtIliTYGZVOuOydEFhIXFb3G7F6aNGmPnAR+01Y=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BY5PR10MB4034.namprd10.prod.outlook.com (2603:10b6:a03:1b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:25:04 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 18:25:04 +0000
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
Thread-Index: AQHXHvxh39vYR/ByH0SHQRVYSjGN/KqQU18A
Date:   Mon, 22 Mar 2021 18:25:03 +0000
Message-ID: <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
In-Reply-To: <20210322091845.16437-1-mgorman@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c986b3ef-c477-49a1-3b67-08d8ed5fcffd
x-ms-traffictypediagnostic: BY5PR10MB4034:
x-microsoft-antispam-prvs: <BY5PR10MB403405E19A0247784AD37DEE93659@BY5PR10MB4034.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcicPTytUdJGLyA57TLfs4Ljmb2YUheBsMH84w4OSqS1ntpLHtKfuRqF0Xs/biPD4mzffOPugw7FrkkScLQCqL8fnxnH4IWZXc6QU1Jil2gycUDrn/FZpmUP0bDvYkp56oxpuk0gUMBF3hBxgRIl43qBf9CXk+5ITSdVmpcH/DsGUfK/MLxySSUwi95VoI3W6nT/CIsobnFE7tJRm2QLo+nRR7M/VgtBF+zY0WK1Fyf8tMHTxWv8ScORuK6pIHKKx5Chu/EPvqBZ0J1RDT/G/C0S1L2IRlC+T9ZWiET98Yhuqf68o0W5xsijb2STdr2nJraXF94kkbylphbmXAlRjJ9RZBMQACsW+52ZPJPlbxlvi5DICV5ouiQ4/uwlBFXwWj6T2kQcc1louymFltv4JPhpVtdYt2ybvJGTTi7713qKd8oia37DwdOFjI1AP13FO3T+wTeDIxyQvFX1RyVOUXc84AR4p9gwFs1Lbzesiqr63ADJFotUZGn2lU2GSwKew4yf5ZXatfZq7SA6gsezXGTC8uPTImyWAAvE2HD4+RqS6cuUXKRr2lXmUd5bggJGusnzYbHsYmKvUTKh05J49oE3QWGI3gOrtO/jvwYn1cZjmWzDYM/OmGw4YsN3FLAoPbftZHN7KN/EbXAPAHwJDunPTpj6HH2bhQacjrsdUjt/tavvdFsagtbbVY0d9NIl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(136003)(376002)(7416002)(8676002)(8936002)(83380400001)(6486002)(86362001)(478600001)(2906002)(6916009)(66946007)(66556008)(38100700001)(64756008)(66446008)(76116006)(91956017)(66476007)(54906003)(316002)(5660300002)(6506007)(53546011)(71200400001)(33656002)(36756003)(2616005)(4326008)(6512007)(26005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?d2pXZS+ZgXYbU+Ry3kwiI+gmj+hXwQhZ9dYL8EOUyCv3fNheifB2UdXjhFT6?=
 =?us-ascii?Q?PEPwU+1kndjJdnBCkgQpp907foxGZZxGZDzuTyq/wQe4YTXlgJzS+aG+xLuI?=
 =?us-ascii?Q?IJ27yN0hYKiw/MI3iK85p7zsLuYwPOEKF+aFAFQNVUsaNOUrOO65Vsb5eIES?=
 =?us-ascii?Q?KIJn1cFsKnjZwB/CrvTx1Pk4rwpAQ+Ux4MBKCXHpyqrpZQ9peaWsNTXl2bui?=
 =?us-ascii?Q?1DJ4//i3ZkbCYrOeZWu7GjLcuVlR8hyhe+xdFROCtqePmSrSHfYLyYNX4gEF?=
 =?us-ascii?Q?f4f0d37UoJcytothDdDPh+jBvhUtjAbI49U4yuyjyDJAIEPtTh8PWagjH9+k?=
 =?us-ascii?Q?x6nOFOSl5GPv29UOdt8SbokKM0EwTY33ztj9w94/qr4p7Kb/gJKHaqPp7cBd?=
 =?us-ascii?Q?eIH1WqINPaL/rr7BaYLZ3F6vUzhXg1g7fV1n+Bxf791caCEjsCSf6spkYMAd?=
 =?us-ascii?Q?AFaxGTYNz1IIptCg1VqttrfYU2HkO6SXR0fRykj7M+8BfX9+0ZbBdtTD/Av/?=
 =?us-ascii?Q?E6UiluHbE1NL+ZiIi60FM1WgknpKYhHgq9LRIBNMHHiFzGItlQYHLTUNmIdw?=
 =?us-ascii?Q?ZKIU4eoIN441jvB+olZoKWhPxt2dsWsuFLHhzZAPR52WOX9Ft3Df4DUPuTyV?=
 =?us-ascii?Q?9g3zFBWxkR9YjMZn3lMgqMkAt36VbDPgn35prP8TaAlkSupADQ7k+GUTq+hq?=
 =?us-ascii?Q?UlBpDBAJ9QKZCEq2DZqcYwMco53LO8n9lJIypxAfBgapUdaoXgmXazBCGd6x?=
 =?us-ascii?Q?mQ7VyBi8Hc8qY2edFBuqRFI6VUUyJ3PrtM7GnrhPft3ogBDAfOZRkrJg75ys?=
 =?us-ascii?Q?X21zX3bf65is41Xx3bkqkS4QOPhyUs/vgc/j04yV1Rhfn6ovfR8+eOk6jQws?=
 =?us-ascii?Q?HkJikNVvzdCxt8+TTPIX4w4FslRAjg9etMMZNaqN/ExIsFhfl6M4w3wmKzqC?=
 =?us-ascii?Q?aiLTkD1SkQzOKm1tMat4hQdAZd4DDDTku/0TaX7oJhzlnNd2dKAHcA7v1ldK?=
 =?us-ascii?Q?LbGMHbmkZYzyGxc5XhJrOSLSZYLq3Pla4Dk2UTlqTyDVWMlq9RsfMsWRPMhE?=
 =?us-ascii?Q?wEKQeXW1u108NJFxqj/I2U42NsZlGW5Xc3y9ZW0HBywn123t1sR82sInxh6p?=
 =?us-ascii?Q?ILVAm9qZHueGnB3kEZNIL/YgPyrynkHElHSri7iWdO+TRcn5aa62OzpxMysJ?=
 =?us-ascii?Q?33b6NcGkhD93WSe0WDy+RYx26YOMpElTNZQe3y3uL+7ib0numZwgySW3CLtD?=
 =?us-ascii?Q?63+I2A0OKk2IZkx5CybC1lFSbJBZxjgzfapgXLObMzqVgGtZL10XpBjLayri?=
 =?us-ascii?Q?8O4mICAn0An1zNLQXnSDgcnw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <605D5AD6155EF3448FBD4206E1189DD6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c986b3ef-c477-49a1-3b67-08d8ed5fcffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 18:25:03.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oq0gDaNaYLFXqo1xQYEY/Kn012n8JtgGg44TamRvQAoHpSTHgtNH8ug7m6GSTEzt0t0wDHeR9t8cMdzjxz+hOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4034
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1011 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 22, 2021, at 5:18 AM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> This series is based on top of Matthew Wilcox's series "Rationalise
> __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> test and are not using Andrew's tree as a baseline, I suggest using the
> following git tree
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebas=
e-v5r9
>=20
> The users of the API have been dropped in this version as the callers
> need to check whether they prefer an array or list interface (whether
> preference is based on convenience or performance).

I now have a consumer implementation that uses the array
API. If I understand the contract correctly, the return
value is the last array index that __alloc_pages_bulk()
visits. My consumer uses the return value to determine
if it needs to call the allocator again.

It is returning some confusing (to me) results. I'd like
to get these resolved before posting any benchmark
results.

1. When it has visited every array element, it returns the
same value as was passed in @nr_pages. That's the N + 1th
array element, which shouldn't be touched. Should the
allocator return nr_pages - 1 in the fully successful case?
Or should the documentation describe the return value as
"the number of elements visited" ?

2. Frequently the allocator returns a number smaller than
the total number of elements. As you may recall, sunrpc
will delay a bit (via a call to schedule_timeout) then call
again. This is supposed to be a rare event, and the delay
is substantial. But with the array-based API, a not-fully-
successful allocator call seems to happen more than half
the time. Is that expected? I'm calling with GFP_KERNEL,
seems like the allocator should be trying harder.

3. Is the current design intended so that if the consumer
does call again, is it supposed to pass in the array address
+ the returned index (and @nr_pages reduced by the returned
index) ?

Thanks for all your hard work, Mel.


> Changelog since v4
> o Drop users of the API
> o Remove free_pages_bulk interface, no users
> o Add array interface
> o Allocate single page if watermark checks on local zones fail
>=20
> Changelog since v3
> o Rebase on top of Matthew's series consolidating the alloc_pages API
> o Rename alloced to allocated
> o Split out preparation patch for prepare_alloc_pages
> o Defensive check for bulk allocation or <=3D 0 pages
> o Call single page allocation path only if no pages were allocated
> o Minor cosmetic cleanups
> o Reorder patch dependencies by subsystem. As this is a cross-subsystem
>  series, the mm patches have to be merged before the sunrpc and net
>  users.
>=20
> Changelog since v2
> o Prep new pages with IRQs enabled
> o Minor documentation update
>=20
> Changelog since v1
> o Parenthesise binary and boolean comparisons
> o Add reviewed-bys
> o Rebase to 5.12-rc2
>=20
> This series introduces a bulk order-0 page allocator with the
> intent that sunrpc and the network page pool become the first users.
> The implementation is not particularly efficient and the intention is to
> iron out what the semantics of the API should have for users. Despite
> that, this is a performance-related enhancement for users that require
> multiple pages for an operation without multiple round-trips to the page
> allocator. Quoting the last patch for the prototype high-speed networking
> use-case.
>=20
>    For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
>    redirecting xdp_frame packets into a veth, that does XDP_PASS to
>    create an SKB from the xdp_frame, which then cannot return the page
>    to the page_pool. In this case, we saw[1] an improvement of 18.8%
>    from using the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
>=20
> Both potential users in this series are corner cases (NFS and high-speed
> networks) so it is unlikely that most users will see any benefit in the
> short term. Other potential other users are batch allocations for page
> cache readahead, fault around and SLUB allocations when high-order pages
> are unavailable. It's unknown how much benefit would be seen by convertin=
g
> multiple page allocation calls to a single batch or what difference it ma=
y
> make to headline performance. It's a chicken and egg problem given that
> the potential benefit cannot be investigated without an implementation
> to test against.
>=20
> Light testing passed, I'm relying on Chuck and Jesper to test their
> implementations, choose whether to use lists or arrays and document
> performance gains/losses in the changelogs.
>=20
> Patch 1 renames a variable name that is particularly unpopular
>=20
> Patch 2 adds a bulk page allocator
>=20
> Patch 3 adds an array-based version of the bulk allocator
>=20
> include/linux/gfp.h |  18 +++++
> mm/page_alloc.c     | 171 ++++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 185 insertions(+), 4 deletions(-)
>=20
> --=20
> 2.26.2
>=20

--
Chuck Lever



