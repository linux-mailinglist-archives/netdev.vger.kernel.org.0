Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ACA223714
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgGQIdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:33:02 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:64184 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgGQIdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 04:33:01 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06H8P1kV009467;
        Fri, 17 Jul 2020 04:32:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-00128a01.pphosted.com with ESMTP id 32as9htar3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 04:32:52 -0400
Received: from m0167091.ppops.net (m0167091.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06H8VS7B017937;
        Fri, 17 Jul 2020 04:32:51 -0400
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0b-00128a01.pphosted.com with ESMTP id 32as9htar2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 04:32:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQmfbXqO2LpSSUAuYjiDehOIzNkZCFgPtPcOGwL3IxVRk1ZlqhnhqfYTuWfxc7IYClA+Qybs3MYz3SrAJW5XUcRO2T94eruBHCcUtsWrLF9f5EmMNEQeGDhjyD1abk7285dbl5CGzKQB6kESZXHCjynYVdQgA5WglAeujLHjCgdjVv9PEdleQkd7nIjalCNWScZ3CspjNHKxWOQDO7KJ3yA5+jsr0BJOBITb9nJyKWXNaACzoYymhMXUILzSZyxif0eOajCy5Z1icICpWTE33Axj5JD3LxvG1uXvVlI2HvgDMHoylb7/CDUscfHYPCyNiPfzs/CMZKulHs2Ogbh8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=256vFFzHr4pvcxzKK055OgsPVA6a6syBMc1LmH6+kMU=;
 b=c30JTLAMXufbNR0omeqpjm+h7gNLos570+fwWAhRtdAft5/eH5ts+SFOicYFkmME2xjwxbM6HFVOrUhlV6TMyXVtbsvXxPBDOy9WEO5TKlNBjcFCM4ZC/8acZo1N3gKxi1algpDWtHEd26gwnwKHvRv2wWOBLzxCbrBnrtKpNzbW5hpdaayxUzKpevTlollaKVUtSiZroj3vDlDPvxNAZBK/cRsrqukLaWh+dEgwhKulkWmfhxuO/RdXJnWLpKyvKqn/KbPmJf550sUcSTC2krKbTnfOHz7511G2jtmEY8unTXyWCxid2tvCPl7VG10u5yS2+uAlbqPY7f7hagq4/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=256vFFzHr4pvcxzKK055OgsPVA6a6syBMc1LmH6+kMU=;
 b=KO1H/OROYQ8RnGoL6OwdxG/Lg4k/RMA2wMrZrFocj5RtSTK3rOx7VUQa9q0XYZPzhcYNa89xXL+gGy7+afnx5cxzp/l/xAAyifuuhIl8yFcn2C9TDWULOoPdFwcN+jTaBsoKYl30ZHw0twCQ+ahy+SQn9V8Vu/30rjXRu5lFmmY=
Received: from BN6PR03MB2596.namprd03.prod.outlook.com (2603:10b6:404:56::13)
 by BN7PR03MB3937.namprd03.prod.outlook.com (2603:10b6:408:2c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 08:32:50 +0000
Received: from BN6PR03MB2596.namprd03.prod.outlook.com
 ([fe80::7ddb:b5e3:4dd0:dcc9]) by BN6PR03MB2596.namprd03.prod.outlook.com
 ([fe80::7ddb:b5e3:4dd0:dcc9%8]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 08:32:50 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     Liu Jian <liujian56@huawei.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, "kjlu@umn.edu" <kjlu@umn.edu>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] ieee802154: fix one possible memleak in
 adf7242_probe
Thread-Topic: [PATCH net-next] ieee802154: fix one possible memleak in
 adf7242_probe
Thread-Index: AQHWXBLJ3CNtoWvAxUy5HggfS5YIUqkLcXxQ
Date:   Fri, 17 Jul 2020 08:32:50 +0000
Message-ID: <BN6PR03MB2596B2FDB890D6B9044F5AB58E7C0@BN6PR03MB2596.namprd03.prod.outlook.com>
References: <20200717090121.2143-1-liujian56@huawei.com>
In-Reply-To: <20200717090121.2143-1-liujian56@huawei.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWhlbm5lcmlc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0xODIwMTI4ZS1jODA4LTExZWEtOTAzMy00ODg5?=
 =?us-ascii?Q?ZTc3Y2RkZWNcYW1lLXRlc3RcMTgyMDEyOTAtYzgwOC0xMWVhLTkwMzMtNDg4?=
 =?us-ascii?Q?OWU3N2NkZGVjYm9keS50eHQiIHN6PSIxNjA5IiB0PSIxMzIzOTQ0ODM2ODg0?=
 =?us-ascii?Q?MzkyNzQiIGg9IldVczlTR2lWUEZsWjJybWN4a3g1a1V2c0ZjTT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?RHFmWGphRkZ6V0FmcmNiczBBbkUyKyt0eHV6UUNjVGI0REFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBYVBTNzl3QUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
 =?us-ascii?Q?UUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QUc4QWFnQmxBR01BZEFCekFG?=
 =?us-ascii?Q?OEFaZ0JoQUd3QWN3QmxBRjhBWmdCdkFITUFhUUIwQUdrQWRnQmxBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0VBWkFCcEFGOEFjd0JsQUdNQWRR?=
 =?us-ascii?Q?QnlBR1VBWHdCd0FISUFid0JxQUdVQVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURF?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVlRQmtBR2tBWHdCekFHVUFZd0IxQUhJQVpRQmZBSEFBY2dC?=
 =?us-ascii?Q?dkFHb0FaUUJqQUhRQWN3QmZBSFFBYVFCbEFISUFNZ0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21l?=
 =?us-ascii?Q?dGE+?=
x-dg-rorf: true
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=analog.com;
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d8a5723-049e-4f38-47f5-08d82a2bfe05
x-ms-traffictypediagnostic: BN7PR03MB3937:
x-microsoft-antispam-prvs: <BN7PR03MB3937474527108B654E9B650F8E7C0@BN7PR03MB3937.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:133;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mPlE7yq+a7SseGTueb5Mnjn430naPmdDFSWpAxExCuEpp7y5ium47CyqsIxk05SlwsCqOxXOkJTx6ZWkWQrLhLdf3JDg8KoIcg4JmSufY1aCGZbAANSZ+Kup4dDdRw0SuvPHpLkt0e2JQOVUI6ZnQnYyLBa61EGMcRroWZBtlwH5Dmjf7PNDDVJUkUp0LBBOkmsWCuefAb9aQsTnJuEJZi1757O3ac3L3ffKItqgPfLyDuVBbJSkPndJWd1gxQIhnmBVPBUlhhqIjV9cJ/mIRNVntc7bs6hmrTLt88eSpxRJ92nPRLbugz4HGYqoebnkjtnx5YQk0P9gYpfMCFcRyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR03MB2596.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(64756008)(186003)(76116006)(52536014)(26005)(66946007)(86362001)(66446008)(110136005)(8936002)(478600001)(316002)(71200400001)(5660300002)(9686003)(2906002)(55016002)(6506007)(33656002)(53546011)(66476007)(7696005)(66556008)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qmaINuoBHCWkKstx8DspYekEanO70d4hqeYMmaUjyAbLEpdJOwGd5UfIyiatIZKbiUmlIiXC2HJtI3JXmgfSe7rN8hCrnvycRC72CHnIJjkTgATBGVvOTb63IKuXtKhX7FBM96iyamEiNH5CAeF7leM5F7aUk+XKDNeZBeGHMUtOl9s6G/HoPdpWdUu0GlDyX7v+d2fpDHCgW4zavrfzrCVideKfSRd2yLmvEJL9OwtTHEaMzqYdmCixYTNyHcZBM/LtLk1f9/SKpLBjvWcbQk1xlTsvf3vDxyMOjiYp5Z56VCeV//B8615SISnfbI6KWXHeOYl00J6MPxdAduqzHXbOxWKNvowto43Fl4tIeosjv3zmWIosloO1ztoRUOAeELrknziDwLr/W0MjR9qMZr34Z0c36nNORKRW3JCQ90dUvLU/eTaXwZ/eKma2FqotxARvq+ga1QCN2efwa/0mdnZTT2B8XjC4oFKNvK4g2D0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR03MB2596.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8a5723-049e-4f38-47f5-08d82a2bfe05
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 08:32:50.4965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qB8LHXNWHDMXAiKxrMjVmTgkwdu/KylCkvOlOtThjh/i30vuA3BpjcmU0b72h/6FtXHB3xUvf9hednNfIk72rl50b4nLwP2uVyIs4Wdt4d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3937
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_04:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Liu Jian <liujian56@huawei.com>
> Sent: Freitag, 17. Juli 2020 11:01
> To: Hennerich, Michael <Michael.Hennerich@analog.com>;
> alex.aring@gmail.com; stefan@datenfreihafen.org; davem@davemloft.net;
> kuba@kernel.org; kjlu@umn.edu; linux-wpan@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: [PATCH net-next] ieee802154: fix one possible memleak in
> adf7242_probe
>=20
> When probe fail, we should destroy the workqueue.
>=20
> Fixes: 2795e8c25161 ("net: ieee802154: fix a potential NULL pointer
> dereference")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c
> b/drivers/net/ieee802154/adf7242.c
> index 5a37514e4234..8dbccec6ac86 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1262,7 +1262,7 @@ static int adf7242_probe(struct spi_device *spi)
>  					     WQ_MEM_RECLAIM);
>  	if (unlikely(!lp->wqueue)) {
>  		ret =3D -ENOMEM;
> -		goto err_hw_init;
> +		goto err_alloc_wq;
>  	}
>=20
>  	ret =3D adf7242_hw_init(lp);
> @@ -1294,6 +1294,8 @@ static int adf7242_probe(struct spi_device *spi)
>  	return ret;
>=20
>  err_hw_init:
> +	destroy_workqueue(lp->wqueue);
> +err_alloc_wq:
>  	mutex_destroy(&lp->bmux);
>  	ieee802154_free_hw(lp->hw);
>=20
> --
> 2.17.1

