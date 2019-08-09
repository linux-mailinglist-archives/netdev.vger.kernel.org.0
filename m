Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1990C87A3C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406374AbfHIMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:34:58 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13330 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfHIMe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:34:58 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79CXElu018725;
        Fri, 9 Aug 2019 08:34:49 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2053.outbound.protection.outlook.com [104.47.48.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmpmxts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:34:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUwpuLlVH119gfMi9e7G5N2jjrewQc7tIQO4SdpTiP2xkJ7kAZRYfagSk+A/mQtpjGzFVTuaP1zNt1doorMXEM4mGDRDD9K+bi/4GoLdD/CugeZzLgUJ5kTmbNZVAQ8MUp3TFe7Syv1R0arb6Boy32ORuaLSLasjJlYVXqhDNIWivlU5zyK82Ac16vg42uIb1L4nq72GvSpMz3zyTNt9pJ8AMn7nKwM2zJrbFAEJCYJ1nMSXreOFk7C91f6lkpsdJ+AbN2B4gW+lbmdm53pnMQ7moRxbeCToBMgOCDU93pqcS+HdEhhXMoNI66o63RWxVpQVPD7rhI6bJv4EHG/rag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3LAx8AQUMGFvtqGiGuvGxau2gcLE3qSe4pUOHxiId8=;
 b=WPi9+P3o3DZXFi7FPF/FSW0Aprp9V9OShUSkLHLcxD85XSGa11RuTqa5Fv3uUVTcWs1V+/Ak+oet+t7qhvOOEoujqxJ7v4rA+0yLlpTqJ1h7jumX0coHWoajJ1OX+KhyDElcTVL3x4L4MG6S+Yowx0nFqeTFO4p/93HPT0pqpr4ZRlTY1Tp9N1fFsLrEBFpEy5EoSte65QseLMEoas9UOAR0yL1QRj9SCiUO2L8YnmM/aK396N9RSrlyP/HL4Fa8KzyiVr6uoS6dUeo8/2S/8soDb9G4jg+5eGQgH6yFPjlAijksl73Rc03ghN2Z3CwNnllcN7u0OndYkduk/PSC2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3LAx8AQUMGFvtqGiGuvGxau2gcLE3qSe4pUOHxiId8=;
 b=0uzMGH2DuomushXZeE8Pty3T6hTfZW4uAfSbolXwyccNjC2DBzGNGT9Cux0sgxqyH+ac1oEaxpKYHP5Ctxkz9uouXAv561AOBH4FYr9k6ZSmwrIaHjJF9UQM3lA9GcelcXr+KEdIxczC4KbqySvSB8bc1emBPNysgN2upskjLWE=
Received: from BY5PR03MB4965.namprd03.prod.outlook.com (52.133.251.17) by
 BY5PR03MB5014.namprd03.prod.outlook.com (52.133.248.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Fri, 9 Aug 2019 12:34:47 +0000
Received: from BY5PR03MB4965.namprd03.prod.outlook.com
 ([fe80::a1ef:88a5:c1e5:a264]) by BY5PR03MB4965.namprd03.prod.outlook.com
 ([fe80::a1ef:88a5:c1e5:a264%2]) with mapi id 15.20.2157.015; Fri, 9 Aug 2019
 12:34:47 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Harry Morris <h.morris@cascoda.com>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: RE: [PATCH v2 17/17] ieee802154: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH v2 17/17] ieee802154: no need to check return value of
 debugfs_create functions
Thread-Index: AQHVTq5pqJtjSHKl4kG/jdRCATZhCabywA6A
Date:   Fri, 9 Aug 2019 12:34:46 +0000
Message-ID: <BY5PR03MB49656ECC2BAA0CB2B63E01F28ED60@BY5PR03MB4965.namprd03.prod.outlook.com>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
 <20190809123108.27065-18-gregkh@linuxfoundation.org>
In-Reply-To: <20190809123108.27065-18-gregkh@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWhlbm5lcmlc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0xMGNiODEyYi1iYWEyLTExZTktOGY2My00ODg5?=
 =?us-ascii?Q?ZTc3Y2RkZWZcYW1lLXRlc3RcMTBjYjgxMmQtYmFhMi0xMWU5LThmNjMtNDg4?=
 =?us-ascii?Q?OWU3N2NkZGVmYm9keS50eHQiIHN6PSI1MjkyIiB0PSIxMzIwOTgyNzY4NTI4?=
 =?us-ascii?Q?MjcyMTIiIGg9IlpuQlBJbkZqVmZTVnpEbENrN1JPOWlodVRqVT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUt3QkFB?=
 =?us-ascii?Q?Qk1CRUhUcms3VkFhTFNyTnpURU12dW90S3MzTk1ReSs0Q0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUE4QVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBTjlrNEN3QUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
 =?us-ascii?Q?UUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QUc4QWFnQmxBR01BZEFCekFG?=
 =?us-ascii?Q?OEFkQUJwQUdVQWNnQXhBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0VBWkFCcEFGOEFjd0JsQUdNQWRR?=
 =?us-ascii?Q?QnlBR1VBWHdCd0FISUFid0JxQUdVQVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURJ?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUE9Ii8+PC9tZXRhPg=3D=3D?=
x-dg-rorf: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb5f31be-ba49-48b8-3766-08d71cc5f6c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BY5PR03MB5014;
x-ms-traffictypediagnostic: BY5PR03MB5014:
x-microsoft-antispam-prvs: <BY5PR03MB50142D429426F0CB976836D68ED60@BY5PR03MB5014.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(396003)(366004)(189003)(199004)(13464003)(52536014)(2501003)(81166006)(53546011)(4326008)(6506007)(81156014)(446003)(11346002)(25786009)(3846002)(99286004)(5660300002)(14454004)(7696005)(2906002)(256004)(476003)(76176011)(486006)(6246003)(64756008)(66556008)(76116006)(102836004)(66476007)(66446008)(66946007)(186003)(8936002)(6116002)(6436002)(316002)(86362001)(33656002)(110136005)(478600001)(54906003)(74316002)(26005)(66066001)(71200400001)(305945005)(55016002)(9686003)(71190400001)(53936002)(8676002)(7736002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR03MB5014;H:BY5PR03MB4965.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Vw2f23k2qewubw55gzuJjQ655SsyzLl4E14qUBzWDE92GVs902DY3bFR19zrmtz0rqcnUwU++0KW5/Y2ajyuSA9Fgqe59s7uVLlPjd98IjyYQoJ6bTP/XJfou1gxJEewmUzGYzpXlD51DOgFS4rjWhkEVPPSg9YRc+QRUAzSn9ECLNEme8ACHmdGdtEGuMPrvtZ3DSz417C2RQdKa61nn2uYs5UDxcPvDILzRPw3pWr4KltsAQGSQgINHfIQQXMOEbs+TmsRrTESg9RSScG3J0tKnto8V9GwK1wWJFPWKlQWLSLbldWeCRWEDQuEMY0kGHqIN9Mugrm8+E5s1GKDh4jKa9ho9DFhGLgLXFRLIthOCcLuabb79u83cwCCreTZuntYGW3O7AR2qMSD9j7zI+0W1livQLDZ90/CqHOogNo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5f31be-ba49-48b8-3766-08d71cc5f6c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 12:34:46.8407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrVdhd2CgI9Xaki+7eVqb0fdJx4lFQrqzUENV8laX9EJf4GOCJ7cunpzTPi4QDNKrkjAGauNh0y4w3mM1V9Z7xIsY0d/qXJWblN0nYkCW4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5014
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Freitag, 9. August 2019 14:31
> To: netdev@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Hennerich, Michael
> <Michael.Hennerich@analog.com>; Alexander Aring <alex.aring@gmail.com>;
> David S. Miller <davem@davemloft.net>; Harry Morris
> <h.morris@cascoda.com>; linux-wpan@vger.kernel.org; Stefan Schmidt
> <stefan@datenfreihafen.org>
> Subject: [PATCH v2 17/17] ieee802154: no need to check return value of
> debugfs_create functions
>=20
> When calling debugfs functions, there is no need to ever check the return=
 value.
> The function can work or not, but the code logic should never do somethin=
g
> different based on this.
>=20
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Harry Morris <h.morris@cascoda.com>
> Cc: linux-wpan@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/net/ieee802154/adf7242.c   | 13 +++----------
>  drivers/net/ieee802154/at86rf230.c | 20 +++++---------------
>  drivers/net/ieee802154/ca8210.c    |  9 +--------
>  3 files changed, 9 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c
> b/drivers/net/ieee802154/adf7242.c
> index c9392d70e639..5a37514e4234 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1158,23 +1158,16 @@ static int adf7242_stats_show(struct seq_file
> *file, void *offset)
>  	return 0;
>  }
>=20
> -static int adf7242_debugfs_init(struct adf7242_local *lp)
> +static void adf7242_debugfs_init(struct adf7242_local *lp)
>  {
>  	char debugfs_dir_name[DNAME_INLINE_LEN + 1] =3D "adf7242-";
> -	struct dentry *stats;
>=20
>  	strncat(debugfs_dir_name, dev_name(&lp->spi->dev),
> DNAME_INLINE_LEN);
>=20
>  	lp->debugfs_root =3D debugfs_create_dir(debugfs_dir_name, NULL);
> -	if (IS_ERR_OR_NULL(lp->debugfs_root))
> -		return PTR_ERR_OR_ZERO(lp->debugfs_root);
>=20
> -	stats =3D debugfs_create_devm_seqfile(&lp->spi->dev, "status",
> -					    lp->debugfs_root,
> -					    adf7242_stats_show);
> -	return PTR_ERR_OR_ZERO(stats);
> -
> -	return 0;
> +	debugfs_create_devm_seqfile(&lp->spi->dev, "status", lp-
> >debugfs_root,
> +				    adf7242_stats_show);
>  }
>=20
>  static const s32 adf7242_powers[] =3D {
> diff --git a/drivers/net/ieee802154/at86rf230.c
> b/drivers/net/ieee802154/at86rf230.c
> index 595cf7e2a651..7d67f41387f5 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -1626,24 +1626,16 @@ static int at86rf230_stats_show(struct seq_file
> *file, void *offset)  }  DEFINE_SHOW_ATTRIBUTE(at86rf230_stats);
>=20
> -static int at86rf230_debugfs_init(struct at86rf230_local *lp)
> +static void at86rf230_debugfs_init(struct at86rf230_local *lp)
>  {
>  	char debugfs_dir_name[DNAME_INLINE_LEN + 1] =3D "at86rf230-";
> -	struct dentry *stats;
>=20
>  	strncat(debugfs_dir_name, dev_name(&lp->spi->dev),
> DNAME_INLINE_LEN);
>=20
>  	at86rf230_debugfs_root =3D debugfs_create_dir(debugfs_dir_name,
> NULL);
> -	if (!at86rf230_debugfs_root)
> -		return -ENOMEM;
> -
> -	stats =3D debugfs_create_file("trac_stats", 0444,
> -				    at86rf230_debugfs_root, lp,
> -				    &at86rf230_stats_fops);
> -	if (!stats)
> -		return -ENOMEM;
>=20
> -	return 0;
> +	debugfs_create_file("trac_stats", 0444, at86rf230_debugfs_root, lp,
> +			    &at86rf230_stats_fops);
>  }
>=20
>  static void at86rf230_debugfs_remove(void) @@ -1651,7 +1643,7 @@ static
> void at86rf230_debugfs_remove(void)
>  	debugfs_remove_recursive(at86rf230_debugfs_root);
>  }
>  #else
> -static int at86rf230_debugfs_init(struct at86rf230_local *lp) { return 0=
; }
> +static void at86rf230_debugfs_init(struct at86rf230_local *lp) { }
>  static void at86rf230_debugfs_remove(void) { }  #endif
>=20
> @@ -1751,9 +1743,7 @@ static int at86rf230_probe(struct spi_device *spi)
>  	/* going into sleep by default */
>  	at86rf230_sleep(lp);
>=20
> -	rc =3D at86rf230_debugfs_init(lp);
> -	if (rc)
> -		goto free_dev;
> +	at86rf230_debugfs_init(lp);
>=20
>  	rc =3D ieee802154_register_hw(lp->hw);
>  	if (rc)
> diff --git a/drivers/net/ieee802154/ca8210.c
> b/drivers/net/ieee802154/ca8210.c index b188fce3f641..11402dc347db
> 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -3019,14 +3019,7 @@ static int ca8210_test_interface_init(struct
> ca8210_priv *priv)
>  		priv,
>  		&test_int_fops
>  	);
> -	if (IS_ERR(test->ca8210_dfs_spi_int)) {
> -		dev_err(
> -			&priv->spi->dev,
> -			"Error %ld when creating debugfs node\n",
> -			PTR_ERR(test->ca8210_dfs_spi_int)
> -		);
> -		return PTR_ERR(test->ca8210_dfs_spi_int);
> -	}
> +
>  	debugfs_create_symlink("ca8210", NULL, node_name);
>  	init_waitqueue_head(&test->readq);
>  	return kfifo_alloc(
> --
> 2.22.0

