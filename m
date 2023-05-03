Return-Path: <netdev+bounces-207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8676F5DE0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 011A91C20FD1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A33CDF51;
	Wed,  3 May 2023 18:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3229A8
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:27:15 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A3D468B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:27:13 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343FLu4C021069
	for <netdev@vger.kernel.org>; Wed, 3 May 2023 11:27:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=VQJAAADROTJ6o1NWXep/1yME+D2rMhZ9YQF1nUaC8hQ=;
 b=V1N4/tb6Sk4KKIAd5piuPNZoudxRy2OMGrdCI4HOePjr5dtm67TsMrVOqNrFGPA1VRN4
 vPr1A+YUa5VRpMNYV+UKMHVt/hThsGluWkT6GF+sreOL2uJo8goZOSjDtvr6Y5KwCUAl
 aSoe8SPSK8k116SyuB1QyY3FtM37jZ0svcGqBrIOz3pHMQSrZrk2oYw5Q4nQoAM7fRpz
 mURODuxa46qwxsjiUvaXuJ9GZxwe8CcyE3L4wfC9zdNloHAQMzTbgB4l0plGihffq10+
 S//50KgiWH6awsdF7tDfaptESYfQ2yJGl64nSGvHmk+5eBhNlLhASjzjGPDlQhA76j8E Wg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qbjd04e7s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netdev@vger.kernel.org>; Wed, 03 May 2023 11:27:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVXYs4AlNAUayZwHrzfMMXAzMOFhIl+iZI89juJsq1jVGvJsScLFAnTGBh005baLbP37NZi/ndwXTR5nqTmkB3SYauF2b9uCxzj4fpsiyPn4mL9rjGVQuV1R4eySLq/G45r4LZWL3T/5XrD/E1KW7V2Ha0PrfAv0q+66JcfSgQj3+zWA3qooLQ2dd2hAPmYA1RJioJjEZXuLhwOhzkf6dZsuFa7Wta98uV2X8KzXOaNfuDIDNROJVAx6o+cTaVK2/9JJMoFhEJ+bKKRkBEjvbLt8GkXPgrkQ72+HPAcLpYdbc2kgQdHfUzUD1A+dvJlg8FKmjg+KZAlGVMb1FRVe+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sb8l3kImjtwPnwM/hZP3oAtu/a7ArXqzPJJ2kKKaE/A=;
 b=PzECHvejcYe5OBFdEV9cJsZaZygdOvDHnklMMfnNNEkakn7w+nXBhBmCf9OqrTIxYmfcnLz+FWwMT0HN4b/o+Mt5kLtusSLLRRMgXDFh5st+oTFs1ytZ1TuUkpGfm9hryG0/aWr2hYWJOhWDAfRc49beGI5e23ftsIxlshwEZq1SMmA95MhY2q64GNr3VXcOloa08fTp6KtKEbx9exmj2N0wXvEWZOCYnr4R0YssF/nYlbxrwl37zi7zf4tTMqsVPkREmR7/1ECEQWaXz/x1IWGu9A7ViqL8L91WcAOYYoJm2v/3M9m4ng0zFJRyuTHTBLEyH4MchWzAM8Tk1fq62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10)
 by PH0PR15MB4637.namprd15.prod.outlook.com (2603:10b6:510:89::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 18:27:09 +0000
Received: from MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b538:61d6:dcc3:dc46]) by MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b538:61d6:dcc3:dc46%8]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 18:27:09 +0000
From: Alexander Duyck <alexanderduyck@meta.com>
To: David Ahern <dsahern@kernel.org>, "mkubecek@suse.cz" <mkubecek@suse.cz>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH ethtool] rxclass: Fix return code in rxclass_rule_ins
Thread-Topic: [PATCH ethtool] rxclass: Fix return code in rxclass_rule_ins
Thread-Index: AQHZfd+F+wHXJHJ4FUGLOqj6TbzYtK9I3avg
Date: Wed, 3 May 2023 18:27:08 +0000
Message-ID: 
 <MW5PR15MB5121DA8AFDF937B9DCEBCCFFA46C9@MW5PR15MB5121.namprd15.prod.outlook.com>
References: <20230503165106.9584-1-dsahern@kernel.org>
In-Reply-To: <20230503165106.9584-1-dsahern@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR15MB5121:EE_|PH0PR15MB4637:EE_
x-ms-office365-filtering-correlation-id: 027cec5e-c827-44c2-c8ec-08db4c04016a
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 cydW1pCgi+rumaXj5JxXgRjosSYXgs44I2kCf08seZmU6eSZUX0jUa7/L9lt1X1cDMlGeadVvLVyDbK1XHmfStluxPyHWzDEzjfarp9zYSCm8z1Lk7gx4hYsyf1tYVt3/AmFDsKmZhL0tzQJ4IJ5gJLuBUJCNMpROexJ8NubZRqb/6VCZC5AWpKcCk6KNQOVbDbOcx22w3gkeqttyqFy5qmCQqJggkcO5wjrrrovaSVZqwu4gJ6gClurmUoMrgE4mX7amKxwoKt1sDId4fBWo8NlJRlki52zpsYwtvrqFsFHPiNVEXKsxXS0i0xA2AfFvHZeIpY6ZYhbhjq9d0mIC3kfjocz5/QjLOOKNjkkmUcnjWD4B1hBy4FKWuQnCP15lGthrT/SNURPVPEP3nG6zlB8w3Ve9wE64upvJzmhJPaHMzvRkG50eUqfiHG+0CC5/zY7VxPcupKWbxHIJii8TeGFY1Bn4Z6OGujPPW2KuzYc75ofExP1VCdf4FXwY89EtezK277LDHXUUxlHcIfP8+23+mo0KLroB2ctaV8MqZXKrx1INkrl3B58da1XDnjv/wUG7TUXZ5qXLJOO7op2ZCp07wmDgoPhayvtzcK1LdOShqf7d6banrf1EyoL8kvi
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR15MB5121.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(83380400001)(110136005)(86362001)(7696005)(186003)(38070700005)(9686003)(2906002)(53546011)(6506007)(5660300002)(52536014)(76116006)(33656002)(64756008)(66476007)(66556008)(66446008)(71200400001)(38100700002)(66946007)(4326008)(8676002)(8936002)(55016003)(478600001)(316002)(122000001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?EtHe/SKjLby94ulgQ9FZxxNxarOY5OXRnfBsbA5x1ohku7NhOmX71gj9FEFW?=
 =?us-ascii?Q?IN597BitWAhfQkhvs/DFls7qbKRFMDjnzPzSHxpCVRt4PoSmZm65S4QVXruu?=
 =?us-ascii?Q?rj6LO4AqEK5qmv9SyNd0XynnMLsMLCVJG+O3DhCKDxkYGtsqIkFaOdRVtseo?=
 =?us-ascii?Q?+CdHKzwkWWn2Ko6R1s8ITT1ds7g7f+1OXjhcRdhWdm6ApdOFyOvjWNgZInxv?=
 =?us-ascii?Q?ZzItgAqbOXCmlZx121GbXA9FBaKYKDIYRQcdyp0Yj2fhUFyI7a6/4o3aqcuu?=
 =?us-ascii?Q?pnsskei3K3TRSh6NUaISimWvd9iR/gi+b7yu1TZj/9uytQt3o1oCh9dF92ks?=
 =?us-ascii?Q?Sko6UsEQQnL2ojUjxWmBABY801dqrtPG3JD3GvyYt2GXtcHdzT/NfVJLB53v?=
 =?us-ascii?Q?M1FPuBxB6+957KnLjCdJ9280jySn4waijdUpb0A0xC1gIvwO07U08vM/+7bT?=
 =?us-ascii?Q?an8Bd9WPGccgn6eHxRlMvE1vdVNvAQf5uacVrbpPG/dw1ZvN4x+8RvaJYOjM?=
 =?us-ascii?Q?0+KXR3wt0qhgVPgmF/s4qOasllOuNv5k15Nz/sP2qA4PeMDAxrTE+rpo8CaH?=
 =?us-ascii?Q?nnwkiOoCSJrhbV7NAc+VPRfGDTOAH/U9gJY3Er7gGmFLL5o8/y3ro/uxl8Nd?=
 =?us-ascii?Q?bQWcSMeG96PU8aKoxFPum91SsTPuAtBCBwqUP2VwrYCbUYlATD7rwtsBVT8n?=
 =?us-ascii?Q?V5tAsus9FG13BDD3ix3vDhrLcOIfqDejQj8/55pdlBcGMm+h3VaV+C0pzpzI?=
 =?us-ascii?Q?GeJY9TpC+cPtMEYP+s1AlaNyguPem3R+LRkEB0aRvB9n6Vr0yBd1giNeSj5Z?=
 =?us-ascii?Q?Iy8u/OS6Y4S9+9ll2OWgCD0hFY9Wrv9ssATtGqm9r0U6H+AmDmxYxt6xj97Y?=
 =?us-ascii?Q?lO8s+nHXG2yU/ksN7L8hI8AbGhoi6IChDMsyT/uD4TuuGVWOXGWZ1lXCvS18?=
 =?us-ascii?Q?1zR7hNvhSAQ27x1wrLEMtmpkbeBszen3rIVbDLdUkiV1hiQRZ7MfjBSGxPeE?=
 =?us-ascii?Q?eUXT6fninBN9tyZPEVbFRuDaZLuxWjipBAWXdGRObf1pORyS7UDYLmjwoOTw?=
 =?us-ascii?Q?RGGyJSOdArslU2X8rvs55THb2kbTqJ/HVj1I8xVZk2LuSnjfqZKMLrT3Nm+t?=
 =?us-ascii?Q?0Uoa7V7q4RkUYBqyhvQ9kDDsrvXkHHikj/NrTNpNXnIHNcEY945E1Uv4xh7n?=
 =?us-ascii?Q?/5k68ImmdzMq5pISaIHVHaLUYfpjbq5SReeXMWMz/BIzQurnpoMzkABJ7BCE?=
 =?us-ascii?Q?2BJH9v4DEixsasuaC1RxVcJ8p2YZQgob3HKC6q1ci3Jrf9jnwR+8FFSj2egT?=
 =?us-ascii?Q?AK3u5hBJBA0f4hJQIkU0fX/QTfu1m53SbBufuLTFhG8WfwrSnLG8PTGh75+N?=
 =?us-ascii?Q?kLNbju+CiTWTBnGE4nIvhvBpdq2O+uZTG2Eo6ColNMlGtQwgvx5jMv40O800?=
 =?us-ascii?Q?R+32CLjcleAxC6g171xYgnTQEC3Jw0+T41191uSLlUujKH7kqrergNgNdZ3s?=
 =?us-ascii?Q?6Z5nDRIT9WeqTrgZ15K0nXuPHr6kdGC5Q5kSmXmFu2niZPcKwY0hXLRljTjU?=
 =?us-ascii?Q?ISFdh8cY0Esho4aQzNDBobF9kgJIb+HgtSPnz7QlfQINCfUsyOXIjvIwA+cM?=
 =?us-ascii?Q?3g=3D=3D?=
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR15MB5121.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 027cec5e-c827-44c2-c8ec-08db4c04016a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 18:27:08.9865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HFLPdMJSbHMGVt+V8Azx4tCumHdG7Uf+8bkZ9betunlR07N5D5HG5VCRqeSwVqjQ+b9chckX4b2fuq9OFY1sgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4637
X-Proofpoint-GUID: MgZ5XaSmHLUzUL5hNjMEF86FG2mDLbTJ
X-Proofpoint-ORIG-GUID: MgZ5XaSmHLUzUL5hNjMEF86FG2mDLbTJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_12,2023-05-03_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: David Ahern <dsahern@kernel.org>
> Sent: Wednesday, May 3, 2023 9:51 AM
> To: mkubecek@suse.cz
> Cc: netdev@vger.kernel.org; David Ahern <dsahern@kernel.org>; Alexander
> Duyck <alexanderduyck@meta.com>
> Subject: [PATCH ethtool] rxclass: Fix return code in rxclass_rule_ins
>=20
> >=20
> ethtool is not exiting non-0 when -N fails. e.g.,
>=20
> $ sudo ethtool -N eth0 flow-type tcp4 src-ip 1.2.3.4 action 3 loc 1023
> rmgr: Cannot insert RX class rule: No such device $ echo $?
> 0
>=20
> Update rxclass_rule_ins to return err.
>=20
> Fixes: 8d63f72ccdcb ("Add RX packet classification interface")
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  rxclass.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rxclass.c b/rxclass.c
> index 6cf81fdafc85..66cf00ba7728 100644
> --- a/rxclass.c
> +++ b/rxclass.c
> @@ -598,7 +598,7 @@ int rxclass_rule_ins(struct cmd_context *ctx,
>  	else if (loc & RX_CLS_LOC_SPECIAL)
>  		printf("Added rule with ID %d\n", nfccmd.fs.location);
>=20
> -	return 0;
> +	return err;
>  }
>=20
>  int rxclass_rule_del(struct cmd_context *ctx, __u32 loc)
> --
> 2.25.1

Yeah, looks like it was a brain-o on my part that I just went straight to r=
eturn 0.

Acked-by: Alexander Duyck <alexanderduyck@fb.com>


