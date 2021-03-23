Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1B346973
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhCWUAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 16:00:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53932 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhCWUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 16:00:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NJxVTG033086;
        Tue, 23 Mar 2021 19:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=s/NMiO3PpFXJVWoQpx/9uDoZMNHJaL62udpPqW5GyX0=;
 b=xCgmu5b3hqoSxRhhiuC0AAJ5WPWzz2agMiV3XeUJ67WRDG+NfHi3+Fa/Ls/EgvRCK9FU
 A6Lwh82lRtwFfrEty78tUp8b1C0EbD/11rt+zF3sfVtKGOKxL4Ke8CIghjeFfs2UgYg9
 Qnk1yAWhKAnQBqhoR0MhNNfMP5IPUDR4l0eL0R1pWaODuhG3kfXqcF9bMiiLZh4cB+JX
 AjFBsKvpx3Z3tYsFHwrtWebxyPBKQ4kqfierJ2HSHQ8Rs1KwzhmYC2fnVwcambRiOImN
 1F32MDeeTF/YqxYgYHAVv67UEawV4zhd4xhuBRax1IbQb5H1x9DkSsyvGKF0dbW0KdwT UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37d8fr8g58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 19:59:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NJt8fx142098;
        Tue, 23 Mar 2021 19:59:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 37dtmpxmp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 19:59:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky8NcFpjk3vTDqy/H4IEloYDNIpkjyg4eVTfsucDOqorxBQvqIAVxdRke5tMAsenx7gf+3JFz93RjUSg4nYj7U51+2M3zHSzfLEdjdWEtAxzyDYZdF8u3at9oDnPXPYmFjqqVPQKb1xmEAd1ZHvLypQQ3Q4uGCdyC4yCGF2gdxzX2M0p6APn7EP97sd0AIpOkA5oSqMzyZrIkWvGufz2YZ57gxqhFcLN1+oI7tXvNVWQpBo35qqH11Pb23i5H772+SBc2Zr1sAFrzq/vWN3ReWPQApth8Db6pART18A8VlyPFEFkuAqALghwNX+ezNZinyOGpWNBVhQA4kfgS/BBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/NMiO3PpFXJVWoQpx/9uDoZMNHJaL62udpPqW5GyX0=;
 b=WiHW58UJ2IYEwi/V2KEfZyzA0KXVySo5eggOBF8TxCy0EYTbIQ0M9SdhG+f4G24Tt1Ske5P7iWp2KPRY8ri0QbMTXyurl1dVCAUuXG1NIL43C3WEUdkuvyeVw9Ok32N6dS/hlN09jBmJdaNUuyUTgLLYrs8FARxAyGvagn/0TkgCb1xa1nKEg/2XFz1SrKcYCtDNuVTHLwLjnL+0n6OJDTw4n5y15PZmXtdUUGOiP0+XT3n0MOt5LLLVoagHCvm4ytv/3xoGAqtczlvC/TxhJpyyPVR1PBi+17jI8Nd3QL9EZzYPqDEMk2ZWTRvXYH7otimHKu804Jc9kK/6JKBG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/NMiO3PpFXJVWoQpx/9uDoZMNHJaL62udpPqW5GyX0=;
 b=PMwqVHqh/7UI5RPl0UpbjJkcViKcG5R9pjvcEDc6OeKJB05dX39j/MtM0x31aawhMb3Y/ivXL1sPWM5NDecWpkj7ZJcrpQkAKjBFMLR31Gkm6MSZD/XLwxAgVzE0WsmPirb5zRctS9CvfqwAJJw/X+yXyweu5Goj0lhkuK8hWwg=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3607.namprd10.prod.outlook.com (2603:10b6:a03:121::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Tue, 23 Mar
 2021 19:59:38 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 19:59:38 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Mel Gorman <mgorman@techsingularity.net>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Topic: [PATCH 2/2] SUNRPC: Refresh rq_pages using a bulk page allocator
Thread-Index: AQHXH/a/7ehAyOJY6kGzf05nn0oKmKqR/SwAgAABAYA=
Date:   Tue, 23 Mar 2021 19:59:38 +0000
Message-ID: <B7E23AB6-BD77-4B0C-9C10-8BE9B975025C@oracle.com>
References: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
 <161651220579.3977.8959177746864957646.stgit@klimt.1015granger.net>
 <20210323195602.GO3697@techsingularity.net>
In-Reply-To: <20210323195602.GO3697@techsingularity.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: techsingularity.net; dkim=none (message not signed)
 header.d=none;techsingularity.net; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36ab2ee9-51ee-473f-f95c-08d8ee3630b6
x-ms-traffictypediagnostic: BYAPR10MB3607:
x-microsoft-antispam-prvs: <BYAPR10MB3607E58062EA6C763FD8608C93649@BYAPR10MB3607.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mWbeznry93xUHV1We1hPmfPds8Phs8hLo0V0igsTowuBMiAXIBEY6Zt8MVqO84+Rg9UDwvkQIvAppgWVVy+gBdLa5dXjIj8qj4Jdf7IDBgpULPkWavWcJ5o5v3jwFvrL2GkagfCgRnjmAIaHBw4TR3BqSaobNncPED9kkULWxOtTGCvJ5MU+7WhYKv/ZB7+HoguoOO2pago82sMcI73+Ucjd2bdWriVspU0zD7gMPiTvPh2er5fG0BrtBvatLFBlujG7RWibzAqzNsXQiIbUSIWLhRs4YYsT4kls5jOTsSG250rlJ2Ynin15uefmPAT9yAXWaQLK0KkU0xwZFLHN/SkJbDPcPf4DgGxow27sjarLeUZ2ihJPN3JRVeXlakCvCAWFESLSdDieEhqwvECW4fkQGrTqsjZGzWCvLPkC0R5LtmC9UzxYQl0tNWXH3Dhpx5tqMuacmR/fkpBAM77sZyaEhY124FmiuwIoU8JaNEsczvckYTnXHAKGL0faA9qw2+IfaG/j9LKNQPfRn3iShM28+ZnySMTrEambCPB2nOStAJMY9UwQ5GD/gLBA5UHVlkFFF9jdy/HkpgNTCocs/VskAodN/D2zYc3454LM1xhPvIMJoVVXe+SswLogbiQchYtePhzn1vLmdeHzCzKRNMQ2UvvkFyJQyvHfho/7QPWFYwWH4SaZXjcYKdf6XC/x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(8676002)(33656002)(478600001)(38100700001)(8936002)(71200400001)(86362001)(2906002)(6916009)(5660300002)(316002)(54906003)(2616005)(91956017)(66556008)(66446008)(6486002)(186003)(7416002)(66946007)(6506007)(4326008)(66476007)(53546011)(64756008)(26005)(76116006)(6512007)(83380400001)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pOP/PzVU8eV5wmON1tNOgHZJqE3XrQLzcEHgLnKZfV/RusxYlE5y/OlZJWW0?=
 =?us-ascii?Q?2GYVHoflM6bLJhenacNG4HNxcGwsi1F1FkPqXx93PLE0CKb5z2vEUfDiceUl?=
 =?us-ascii?Q?rUj36l13uoHhC5HC0fyJNhu2jMZkffDBDj13qPzySHoYAmdzyxMilrHXjjVE?=
 =?us-ascii?Q?m7wU6vuN7UEnEPvZ9S5uaoLYaLI6cp3OSbBLk0o6LBqqDZdCUcVDRmpLmBLD?=
 =?us-ascii?Q?u6d57A5UqTHK1PtIOOK7bxrISOV0NSge3YUleWlLrGkH+WmBz5e98ZFZIxNq?=
 =?us-ascii?Q?+V8/WRC24itZCw48TG85zG35X9CMcwr+/VPkUKi25ZKG1d/ogY07Jyd2mZbs?=
 =?us-ascii?Q?4uEOYnpHoWD71Tqcn7LPq0OMguTgQXWRUEwmYUw+yV7TGSNTU6yLw6jf4aTd?=
 =?us-ascii?Q?wBaetZ+KWAuWg3t4R12M0YZGOqdNctKJWx2x5Ab3G2uK6l4ICZoN6Aq2HFH9?=
 =?us-ascii?Q?t0dDRXoyCuQv4kaDdPXf1oL97W7jYib09jWtiuBZMva6b73rk68bg/s6qxCr?=
 =?us-ascii?Q?leijSyLoTObfPbQQG7JMFvooRKNaz40f5dkLL1chqW4vNsDa1HEzEXgr6EXH?=
 =?us-ascii?Q?y+BfwguwGeY6s1gmFWUWfWquR2DX79wT+mO0UcUjs6BZWyTJ9Gi684CLCYio?=
 =?us-ascii?Q?iga4eHmSZ1gNPc42GLRmNtS73PX7jF4kW19OQra+89OUXeRpQxOUn76yd8Gb?=
 =?us-ascii?Q?7jtLytfq9W/iWt5unUd0wFrmC8121haMhR9z/8rztt3iuWMbTPoPYaQwUrWt?=
 =?us-ascii?Q?smkr60BX+/JEBLHH1qPBwMcDoosiizViWpjq5bGAXVdqMLUFjTk99Ga5CwYa?=
 =?us-ascii?Q?/otGC+yeJPDIuhXjxvWnJsKdiNvTzGHUeDR79RQttHHvsEJWBNKrbPIagWRw?=
 =?us-ascii?Q?88CZiSh5GJxluOdFvfcOv2RaseX1gFVBDcqUSeGGX3z/CNflm/6dWS6JtTvI?=
 =?us-ascii?Q?4qH7ZzGhbbFl5ruZvPdHmyVfvXquvwlqcrHuMcCWsa8RHEFFfkSGNL8AZMT1?=
 =?us-ascii?Q?IVsnSNgPtIHLh4htvYC85qLYne3ajocm68RDVTte5x7fqdfYveaPryPbmV+n?=
 =?us-ascii?Q?PlbadSYXdqiJwRidO6qrzbrza6qxg1bQe749EIrYbwTIRPZNHM8BD09yiR2b?=
 =?us-ascii?Q?EaNmfsUYjp6L2O+1dp71AJlmoUjFmOd36tWI5hNLf+Mx9xSzdom+2HEBVlzJ?=
 =?us-ascii?Q?ETG1Mss3n/WQ6qWZW3lcAPciUSyiMnoDwbX2++9+MJnos1EtdOyCUCcdWqtW?=
 =?us-ascii?Q?HvQzEMPPvSgu0Ka5V4QgAFlEZ1bGQiH5h1x6yujXDN/dNL/7x/R0jXlje+Bk?=
 =?us-ascii?Q?RxmSHt+lIYwsmQzfH3wibAMTrOJYwsWe5RGv4mA3pK4BrQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8CB0F079581AE646B2B215C06A35B560@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ab2ee9-51ee-473f-f95c-08d8ee3630b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 19:59:38.4822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OvlpR3WTHRrktunj9nRgt/xISetfR6wMvUsQWz5MChRi5/LBeXwObC008w6MMBTYmJydD8G7GCF2yB/0BmzHOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3607
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 23, 2021, at 3:56 PM, Mel Gorman <mgorman@techsingularity.net> wro=
te:
>=20
> On Tue, Mar 23, 2021 at 11:10:05AM -0400, Chuck Lever wrote:
>> Reduce the rate at which nfsd threads hammer on the page allocator.
>> This improves throughput scalability by enabling the threads to run
>> more independently of each other.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>=20
> I've picked up the series and merged the leader with the first patch
> because I think the array vs list data is interesting but I did change
> the patch.
>=20
>> +	for (;;) {
>> +		filled =3D alloc_pages_bulk_array(GFP_KERNEL, pages,
>> +						rqstp->rq_pages);
>> +		/* We assume that if the next array element is populated,
>> +		 * all the following elements are as well, thus we're done. */
>> +		if (filled =3D=3D pages || rqstp->rq_pages[filled])
>> +			break;
>> +
>=20
> I altered this check because the implementation now returns a useful
> index. I know I had concerns about this but while the implementation
> cost is higher, the caller needs less knowledge of alloc_bulk_pages
> implementation. It might be unfortunate if new users all had to have
> their own optimisations around hole management so lets keep it simpler
> to start with.

Agreed! Your version below looks like what I'm testing now --
the "rq_pages[filled]" test and the comment have been removed.


> Version current in my tree is below but also available in=20
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebas=
e-v6r5
>=20
> ---8<---
> SUNRPC: Refresh rq_pages using a bulk page allocator
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> Reduce the rate at which nfsd threads hammer on the page allocator.
> This improves throughput scalability by enabling the threads to run
> more independently of each other.
>=20
> [mgorman: Update interpretation of alloc_pages_bulk return value]
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
> net/sunrpc/svc_xprt.c | 31 +++++++++++++++----------------
> 1 file changed, 15 insertions(+), 16 deletions(-)
>=20
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index 609bda97d4ae..0c27c3291ca1 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -643,30 +643,29 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
> {
> 	struct svc_serv *serv =3D rqstp->rq_server;
> 	struct xdr_buf *arg =3D &rqstp->rq_arg;
> -	int pages;
> -	int i;
> +	unsigned long pages, filled;
>=20
> -	/* now allocate needed pages.  If we get a failure, sleep briefly */
> 	pages =3D (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
> 	if (pages > RPCSVC_MAXPAGES) {
> -		pr_warn_once("svc: warning: pages=3D%u > RPCSVC_MAXPAGES=3D%lu\n",
> +		pr_warn_once("svc: warning: pages=3D%lu > RPCSVC_MAXPAGES=3D%lu\n",
> 			     pages, RPCSVC_MAXPAGES);
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
> -			}
> -			rqstp->rq_pages[i] =3D p;
> +
> +	for (;;) {
> +		filled =3D alloc_pages_bulk_array(GFP_KERNEL, pages,
> +						rqstp->rq_pages);
> +		if (filled =3D=3D pages)
> +			break;
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (signalled() || kthread_should_stop()) {
> +			set_current_state(TASK_RUNNING);
> +			return -EINTR;
> 		}
> +		schedule_timeout(msecs_to_jiffies(500));
> +	}
> 	rqstp->rq_page_end =3D &rqstp->rq_pages[pages];
> 	rqstp->rq_pages[pages] =3D NULL; /* this might be seen in nfsd_splice_ac=
tor() */
>=20

--
Chuck Lever



