Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD15337599
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhCKOY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:24:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhCKOYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 09:24:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BEIuXr138017;
        Thu, 11 Mar 2021 14:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wBvGh0zhwelsUreG1OZibGpyGAkgIn+cl8MC0A+dMKk=;
 b=beMZnKO9PhzRl//r18ZEDQYigOv5Y4Lse9Pb5YQs26IL6+PpwzgA2o8TWDhU5MLVNxth
 UwFmN24pDugal5Jy8ZNDOE9HVDKK9H1wKkpiqQE4rhDYXAcAd6lr2pSjvrfLEDqPiDRn
 0YgYdkQWNUvc6mVTd9m3d25HRIaieKb+q0WCZKkj+CrnT0F9VxU9LsI9AGw3AJ3Xj5Uy
 /wCg9atY3rbRt3NQchoK6Ny+R7A28dU0w1akc2fgYn2P3PmisE4dLCSOjqkiS4P64gqg
 TDG2D0+EkzteNWiT9FHXOjOokCO38SzImDXtBCe/FkLSDL+5AleH8Mhkx3L+LIZfJxTG ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pmpqvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 14:23:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BEJWgs086771;
        Thu, 11 Mar 2021 14:23:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3030.oracle.com with ESMTP id 374kp11aea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 14:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geuVFNYw7u7Ud2VRZ4OxRefIy6acUo0rx2+ohlZee9zZ4XmP9zunsVGVyyPjEQb18p2nXBqmrxLW2e3Di7L2MveGvrVlbpDoJ3j0Ecd4QZrNjJRH+55pX7ToocN/8stAeAbIYDMMtwnNyZ4cGrqzX8ho80edM4fv0xVNpVAieiHmlpUz9ALUKn/WWzt3AgLQ+fAVofW6/f3Mg+q5JszAWA3QmFLe8EfUKjgtl2y5RWa7f7bGigUf2JjC7DR7TiF/phUB7guoiyfeRTxJQU74ds/hZTcgzNXL9SBYXzPDmAf8WBjk+6wF9NwhM7QqF2sB3lz1+LpVGPtWLBEd90ixJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBvGh0zhwelsUreG1OZibGpyGAkgIn+cl8MC0A+dMKk=;
 b=CACh981tOZgG6cxr8lPQUN9eSHVCo3BRJwmU+v8CKDj1ykHJ+pntcvkT7tFVi09pfSeGErtoeEQqaopTOmyS69/DeABqtQb2eDs5p/QG0g4yvz++yL/9YO705tdwBvhRrCQjhMvPZs34lU2fnq1oNV6pxx5R5WBwd2U0mjCTaaU1JVFqcp8aNFGOmkGDQAoOoG1Sb+tLebGei45kRIQThmZUSBUyLAPG46QmFgtH0MaoSQguhOox2dXPkLtwWXGoxiLYpu9zJRlnHatAPZY+EaI0ZW57x2CFUPBhtXC45evssy2Lz2PCpy99QFuugD2XQwWx9nNONfch/ie1qCcPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBvGh0zhwelsUreG1OZibGpyGAkgIn+cl8MC0A+dMKk=;
 b=oFd4UOa+M3bcLA8CFmNO48ZPWXsbG4GZ/MwcnNMX0w4vf7hXVoWU4u6+Jm3n6W/6RUecg0MvYXwH3rwOwyUKKDJyWZx5hYjuiOmNDbWdxuXPduhPHUY6zdaju4RJtQ6IQH3gX++/CSa0Cciosq1/nCfWFAzz/DFT/SUxRJIKskw=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4608.namprd10.prod.outlook.com (2603:10b6:a03:2d4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 14:23:54 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b%4]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 14:23:53 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 3/5] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Topic: [PATCH 3/5] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Index: AQHXFmygcjHo9VnTG0yxtwtZKdm64Kp+13mA
Date:   Thu, 11 Mar 2021 14:23:53 +0000
Message-ID: <8F34578A-A5AC-4D6A-BF32-1578B14FDE45@oracle.com>
References: <20210311114935.11379-1-mgorman@techsingularity.net>
 <20210311114935.11379-4-mgorman@techsingularity.net>
In-Reply-To: <20210311114935.11379-4-mgorman@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a284d03-8179-4dae-af5b-08d8e4994ca0
x-ms-traffictypediagnostic: SJ0PR10MB4608:
x-microsoft-antispam-prvs: <SJ0PR10MB4608638CD4BF20128C4D675C93909@SJ0PR10MB4608.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1uKpr40sefA57bV6WXnQfxCl0pwOFny6NGa+lhOASKhWbphczKcBaohOy4hfqUrEC3Scwvl6WI1ihv//M6ZWQpWqG3AXiV4wlFNJeo8SuroZnL0yMeXZvyog55xTKO0SMLoWGtzdUC3R7Wyns/2DqJTt5UVrrhdpzni0RDp8Zd0Pn+ccBtLc9tcVyNcfeHAmtluUTlo5PNNM5mks/l6ueHpiJM283M4YSU2UbudtkFEgdmwYBEawsaoVAm65z1s99iM0skQc4Gd+syavGaWuobIQlWU9H8FAJZGZG+u/UD52Kvaz8PtxcovLL8Pq5QWzzsTXV2DConasPbzCNYDRqRi3d69QUsPK5soPhmz7ekFuxalYNGtxA1u+RFC/TjNkUJduzfSdp2uFNaj0IZZgWSetB9C+baLTDshbADeg4qcaIhrk18s4dOSa0dmJUJij1w3nww7s78uXGZSlbT7Kw+seDLEMccWK3jPOcNAoa2J7j0Jq8l++jMshP2O8UNxE3Ksh54y/NYAGjDYQy+IAzheZgPiVcb7UeBI1Jzb+Nk0jIaTiEF+KBUercGHyNCo1HX+7mpQvk3EGcWxLxChUvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(396003)(366004)(376002)(6512007)(2616005)(6486002)(6916009)(4326008)(66476007)(76116006)(2906002)(83380400001)(66556008)(478600001)(71200400001)(36756003)(54906003)(86362001)(8936002)(6506007)(53546011)(33656002)(66946007)(5660300002)(91956017)(8676002)(66446008)(316002)(64756008)(26005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MtZydzWb5GU7UjD409k+Tg/f9CCvkLGfHdfUXqWpQJ6NtoViEZWWFwQzu4vZ?=
 =?us-ascii?Q?/Fi72sJLnoW/N5+IzVqKQsIQ9WCjsV8jwZaJk69JPVLuLxKlgG0yZSzY1LTF?=
 =?us-ascii?Q?fXBsnAlqKLvbv6prhlYXdRpBvRfu/YA5toltV3hb2aAtAoOZll2NijZMxfjd?=
 =?us-ascii?Q?VyP9SN1PECbLf0Dy0QsquG14i4x4BR0XL0XngN2ArhGVlhl136e9/7nPEx6k?=
 =?us-ascii?Q?ZqhS0YMsc33ilYVvxGIV++kMLLosQyi5QgFDo4hTC16wM/LkZ2IP1fkLwu3t?=
 =?us-ascii?Q?auWWwg/gJVlsMkjw4XxGLqQxRjROYHZEiu5gw7QWgCD4JBz/zS9Puas2edvf?=
 =?us-ascii?Q?th2284w4VRR7Z6tRe+zSuWYwGHe4xVR3/kxvX9tIZg65kIyc5NAbaaAD+WND?=
 =?us-ascii?Q?eeBHiv+Le1u5rKdTmoBplhnj5V5hA9rLTcn2KBSCtM/3SN4g0Kq469D5V9Mk?=
 =?us-ascii?Q?HYH/qjDYvmYSwDU4SEfJlQSvF/r1Mhj7LAHo6ZVK27WTqWW1f3W5cvpZaepj?=
 =?us-ascii?Q?YfyccO2WKvXfGRGU/oCbRor5rg3AOpRUMt7zoTK98vJ2ec8lkcfmH1Vp65G7?=
 =?us-ascii?Q?39zqsm/nh6kJLRs7RLOfgxL3PQugEYA/vVB8uoULP7LlWAX4PyLhPNwbtFp7?=
 =?us-ascii?Q?Co6V26Pur6LYpnoGLPM7+83cba7y3xplYc5n0cVjOLe/9Nt0t23ukeWgwvmF?=
 =?us-ascii?Q?LyJoo/M6x9tYrdtx9n2Vm+6AgpBPbF4Pa3YIqBCKZsadcQ/I4AGUSR6o6CIX?=
 =?us-ascii?Q?VGekkLEUtNMngzNGJMLnDUXyDo2Nsf2e9Aw8wbmFWd10OQgqDkhH4Uvyj97M?=
 =?us-ascii?Q?lnWmTbvujWwJNI3FT71bSVAptfZq71yVdVUCoJXxBZC1tVdBzU3X3vGnOQKc?=
 =?us-ascii?Q?6HdHRoeqf3YTtRa4ejT5v0mn3Uxa+ZeAnvbgvw3OvM4Hb4KV/TeQXHCOeWmm?=
 =?us-ascii?Q?gVSznmFXPasIWoLHrlpAfDuxglIA/ZIlDKNGJjIWQwmTkVmj/d3RxVJ56nfT?=
 =?us-ascii?Q?2lApcbsuawnkCSOq131cg226MgKN000lactNhx74D+SVNFM1cndlumb9kipX?=
 =?us-ascii?Q?GoHiDw7TMJSAYJfKEe/Li2HU1YbCo6vLQtQJp2aU3d0mplF0KQwBFkicWXzK?=
 =?us-ascii?Q?zW7B+ftJPqkJDifNTQtQdXxAin4ZO5GHfsjUFzKzTYSnXaUHumO6U7vxYJT8?=
 =?us-ascii?Q?sMZByE9tfdEidcFML8fBmJ4rUV/kRFZh7fkXH//rtmq0OPxBwRO55kpCl8Gz?=
 =?us-ascii?Q?rAIRrRorV1mtNVnZCPns0eIjVAmGYD7YWesDAQPPk0OH/ICViqJFkX5HAiL+?=
 =?us-ascii?Q?puqBXB3n80m/ec/+tEei7Spe?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <054189F63B037747BBEF5A1408F536B3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a284d03-8179-4dae-af5b-08d8e4994ca0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 14:23:53.8508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ecgx/pBtkRNvtkCd2cIUjtv1YfbE2V3UaE8lS4kkutRRjFUshZGKydtbFau8JRApr7GXBa4FQlOhxU8CRHPOJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4608
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110078
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 11, 2021, at 6:49 AM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> Reduce the rate at which nfsd threads hammer on the page allocator.
> This improve throughput scalability by enabling the threads to run
> more independently of each other.

Mel, if you should repost this series: ^improve^improves


> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
> net/sunrpc/svc_xprt.c | 43 +++++++++++++++++++++++++++++++------------
> 1 file changed, 31 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index cfa7e4776d0e..38a8d6283801 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -642,11 +642,12 @@ static void svc_check_conn_limits(struct svc_serv *=
serv)
> static int svc_alloc_arg(struct svc_rqst *rqstp)
> {
> 	struct svc_serv *serv =3D rqstp->rq_server;
> +	unsigned long needed;
> 	struct xdr_buf *arg;
> +	struct page *page;
> 	int pages;
> 	int i;
>=20
> -	/* now allocate needed pages.  If we get a failure, sleep briefly */
> 	pages =3D (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
> 	if (pages > RPCSVC_MAXPAGES) {
> 		pr_warn_once("svc: warning: pages=3D%u > RPCSVC_MAXPAGES=3D%lu\n",
> @@ -654,19 +655,28 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
> 		/* use as many pages as possible */
> 		pages =3D RPCSVC_MAXPAGES;
> 	}
> -	for (i =3D 0; i < pages ; i++)
> -		while (rqstp->rq_pages[i] =3D=3D NULL) {
> -			struct page *p =3D alloc_page(GFP_KERNEL);
> -			if (!p) {
> -				set_current_state(TASK_INTERRUPTIBLE);
> -				if (signalled() || kthread_should_stop()) {
> -					set_current_state(TASK_RUNNING);
> -					return -EINTR;
> -				}
> -				schedule_timeout(msecs_to_jiffies(500));
> +
> +	for (needed =3D 0, i =3D 0; i < pages ; i++)
> +		if (!rqstp->rq_pages[i])
> +			needed++;
> +	if (needed) {
> +		LIST_HEAD(list);
> +
> +retry:
> +		alloc_pages_bulk(GFP_KERNEL, needed, &list);
> +		for (i =3D 0; i < pages; i++) {
> +			if (!rqstp->rq_pages[i]) {
> +				page =3D list_first_entry_or_null(&list,
> +								struct page,
> +								lru);
> +				if (unlikely(!page))
> +					goto empty_list;
> +				list_del(&page->lru);
> +				rqstp->rq_pages[i] =3D page;
> +				needed--;
> 			}
> -			rqstp->rq_pages[i] =3D p;
> 		}
> +	}
> 	rqstp->rq_page_end =3D &rqstp->rq_pages[pages];
> 	rqstp->rq_pages[pages] =3D NULL; /* this might be seen in nfsd_splice_ac=
tor() */
>=20
> @@ -681,6 +691,15 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
> 	arg->len =3D (pages-1)*PAGE_SIZE;
> 	arg->tail[0].iov_len =3D 0;
> 	return 0;
> +
> +empty_list:
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	if (signalled() || kthread_should_stop()) {
> +		set_current_state(TASK_RUNNING);
> +		return -EINTR;
> +	}
> +	schedule_timeout(msecs_to_jiffies(500));
> +	goto retry;
> }
>=20
> static bool
> --=20
> 2.26.2
>=20

--
Chuck Lever



