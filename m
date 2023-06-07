Return-Path: <netdev+bounces-8711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C007254EB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79758281070
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B916134;
	Wed,  7 Jun 2023 06:58:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B5647
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:58:02 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2095.outbound.protection.outlook.com [40.107.113.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535B81732;
	Tue,  6 Jun 2023 23:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDQz0RRrX52BKbhYQbPAyyYqQCCpRmtYPnEA4FIGWqrQZ3Xs8sKCsYNxRx7xPLUJyJMX5GocLzKGAMSxRg9Qth8fX9mLUNN3mrle7ihzJbS/UAS9CgrO1hUf+pvaBxba2100dx+Kttf7QemmLvsrYot0lzBsEMpIiuvj8KLLDYDXUVsXFwoNQzwviiVqZhiqc106MAkGUUzG84M8o0jb1QNZ9CobhAqPKAf5BA54FcVBLX+IExwjePWgrvoKlG677A6lBxh+RB6dTpAm17RqV37eVt3bA8NACPNEqmyGH1bHLz4iyX2icdNaE0iqB1M+1BFAckIDZAEC4d7Q6VdaCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXd3Xx9vViWUvYvwtATda5Pd9QlPYN6js4ijas2VwyY=;
 b=Ltu/CRWFwyTzxvXjZeNSxbvc7pa6k/PdwgO9VNmjUF2q4OvHAJl3w8xWbApBGCW0zVKYDfh6lJ0xLnpZE+NKJ2Z0xOGrajwkiXadhXFe0TeJcha7VIBeyQkT/0Z1QgCoOaQc14XJT+4M3YyPzBP0kDj7RSAg99Jv3BsNTSgFj+mi50XL4aPlNrEVsRU8vA/tgXXlM+mB31D2kzAFKFbCovLXO9bZvYTRJyq/XsoYEsZafSa8eZQUegFnNkins5okiaf6VLtU/YXpf98DVVCJA9UhSAzU4cut9H0WI1nqp6X58/zJYgX8xKcX3TZNBeftbRc1b7dhSw48cX579OWmqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXd3Xx9vViWUvYvwtATda5Pd9QlPYN6js4ijas2VwyY=;
 b=Ab6ThTkH6nRj4NgN11y/vLSIzEVxKOMsQ9N4UuhqX206i4ZGJjNb3uiefgNxEFh+PmZZIDvrVg2rG/aQhJ0jBBurzFnDScH68DN0ectUF6RlvxowIZpijERueZEFmwppzSt2ZNAi72s5satrPPea/fcOu1HMRFbmjiG/3qgDV3g=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB11053.jpnprd01.prod.outlook.com
 (2603:1096:400:3a7::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 06:57:57 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:57:57 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, "s.shtylyov@omp.ru"
	<s.shtylyov@omp.ru>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: RE: [PATCH net] net: renesas: rswitch: Fix timestamp feature after
 all descritors are used
Thread-Topic: [PATCH net] net: renesas: rswitch: Fix timestamp feature after
 all descritors are used
Thread-Index: AQHZmQt1gYLtO+dJWka5EN99taar2a9+6GXQ
Date: Wed, 7 Jun 2023 06:57:57 +0000
Message-ID:
 <TYBPR01MB5341020A7F0CB690C7469606D853A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230607064402.1795548-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230607064402.1795548-1-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB11053:EE_
x-ms-office365-filtering-correlation-id: fb31de2e-b6fc-4359-9445-08db67248641
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 cFI5kEF2rzpemNixkdEtm4Y4dScfiRL9Wzluts4KGGUwZmajihyhAso9k6uO6Kl75nyypg9/ecQcK1pAeeQGziMlvibs4cbaAS9l9aZa6oExg23oj/KjFr5w8HP63ylLMxhHtDLHSxk7xLUr5p6jDDL3bmBn/OsS6uAAH/e8pECeza24v1XF9A9kAUBYAMgikGPqAaA6crLrVzGufI4sIjZcI35XMmudwdlNrgdbOtLeFDrLwd5HhCCXqVAAFNdf6t2MEqCPLN18wuiyJi+yR1TCF7+0mNCm0Bua3+JF6XkxGAwADITzOLTZnbPDGABguLiqgPxdJrz9yzXPYvmEjC72QHM7F4e6zwWpNfgfXjbOq1+X2COIRncAgwk2yzLVtnbLwPGzCHU2qvII1kB+tcHmOjdXDdc9cnrVV+0sGEmY0ADB4IHDb4XXFcu557HJ/P4YZ+O/dm3DKfGW1Atx0sPBO3swhG7AQrRFX3HX1e7/IXwZcmjfLkNWjbG2Qmzi8/+q/f6+jvEF7qpF0be965YWROlC1XFXEd8uZFQaLkj7CNwydzJU16MwVzX4x7ETFyeJL7CZo+rzwxVDFrvWfbc8hFLSL6Lj6kg32LulInFsZz84dvydAWoR4O8pwPZ9
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(55016003)(86362001)(107886003)(2906002)(110136005)(54906003)(41300700001)(52536014)(38100700002)(33656002)(8936002)(8676002)(5660300002)(316002)(4326008)(122000001)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(7696005)(71200400001)(478600001)(38070700005)(186003)(83380400001)(53546011)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vxrrWW5ykYY5YhNS+oyYgU7/uqnpgmRAAn9ctIb6PAMMoOzkPZcD39l9uADw?=
 =?us-ascii?Q?be2dAefEPiKG6FZc75ISBKSGbDXwImue9RQ9XotAfnBFdcN3X7MSqUOQJHGz?=
 =?us-ascii?Q?AlNduk2lxE0y5wFUYzc9ZY3rM1644On4Dn89QkDGB8eUttcVlQ7hA4SJ3Ctu?=
 =?us-ascii?Q?rgEHs9a/kv51HCEMgjEoKUnvdJG+GTmAr744gxWDGR5pXNZkDXwmqj0Dx8cd?=
 =?us-ascii?Q?GIZmPx5aijqcSGjFfcVNTGzfAyFnLiAgIowEXNTL4OrCjcCb9vJMLJLUdrG6?=
 =?us-ascii?Q?mSA1Mkjf/a+AwEdWJkkKHTBf+ZmWro8MkSj05o6peWNXuk9sK3TUAzBT+ZLe?=
 =?us-ascii?Q?abF69GfYQfboBF4ycb5B/P4PUTtnyooPPo81ZDIXG/xHKnWueYEty73lEPbo?=
 =?us-ascii?Q?MGJfFNJOuaHufRib9s/piZA0jakNklL0TxSUAgdGHbf5xUzxJbntwdeFGJqj?=
 =?us-ascii?Q?i1QLGwsmlsYY9aElkzwVwpdWytqnza9cgW+x62NtbR3Z9xzF+M1G2KJqMSzZ?=
 =?us-ascii?Q?aOAfIALqgu+UuoZe99yGmo+xRwS/WFfFMb1oD/iLVShJQKgvCOtsiZ7u3ytj?=
 =?us-ascii?Q?+GI3EAQ2TtpOV3ZEvxVwRGCSAmLhOELODWJjdd3RJid89qnNA1A9p500C1My?=
 =?us-ascii?Q?cui1xma0mkuzrlfDCbrk4Fvi9fClrEwyl77QbRlLHZ0Uyp5wLT5kSAUkIFWl?=
 =?us-ascii?Q?Cj2jMqlPzW5EaIS+97z3a3kCZ2enwYEh2fYHsCOI83RDtfSMIgPAaS+Jbs1g?=
 =?us-ascii?Q?YhtfmmpyUBm8cwlBrcklXOIyPfzUYqGqCZjZwYz8Vn2+kdtqwFRksV5iduin?=
 =?us-ascii?Q?4d4mb2tVsukabyp/vHncNGNnpjbkBVsW/ZgThhsZvENsbO1TeL4MIoPJNHNd?=
 =?us-ascii?Q?aCvVhC1Vi7VZj+XjVcL0wrG44WKTRGymc7sCdxpd77t7T9OasSnPOUGPiun7?=
 =?us-ascii?Q?CcPywM+wgQxvZlToplHVjD3lImgDlYxlFSYYOoaeQsCp/+3ureaVd+n9o6NH?=
 =?us-ascii?Q?ZR1OL4NCoFU4pGDMX4+r3vybgu4eocdz8naUbP0NHZPe3tsMzt9uCGuJz00x?=
 =?us-ascii?Q?QBRbmYeqkFC3/Pu5G8f1OL0OjFbGLrzb/qW4V5xpH6FXV6AlFyDJn2JgiA8t?=
 =?us-ascii?Q?D6oIWBXXeXS/TP4P8hSjjd1FbbbAfic5Ttt3t7S4R5xPbTM6sMyucCJtns/w?=
 =?us-ascii?Q?y7T6+EacoIiBkktumh1yyk1N6TvB0+lzwP7IthffIlDAOCboHDecoJNrFD45?=
 =?us-ascii?Q?pnGgjsouS4QhZHsPDBYusJDdyYaCsqjr8hkhn9gmEwGM3EIk/T8+9hs5E1JP?=
 =?us-ascii?Q?oCiQcbI/OFaaTzSFBR6ytIjp/ABBPrwQykOSzmzyVnNfICiWGNf2F0/2faup?=
 =?us-ascii?Q?j1Lpqy02LMYRLvoueS08mT9htmExWtlXcT/tovH1QqzxDgJ8ap6BsCZQGYX4?=
 =?us-ascii?Q?BgDgVLt56uz8m6T2viyGH6MZCp7eZfPfooGbRWvvtvLsKdddAIE2yZPVdNdd?=
 =?us-ascii?Q?QVQiRAalqdN9idxX/nHrseUfSP/eu3GETNOViEtJtwCnfxZfYcniLZ52TXcg?=
 =?us-ascii?Q?f+npFPtC6nD/MmX1x1HBHcUTimajYFHjxhWZztNNe8Wvd2gQ7zggTOXijw7M?=
 =?us-ascii?Q?UUL4Srr2IOA+k/UL3btyac+rvTHHn9AumtxremORnPHy21VNrCpnDayaTNlD?=
 =?us-ascii?Q?x8ZBhg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb31de2e-b6fc-4359-9445-08db67248641
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:57:57.1939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0Ba6NpasM4AUNRvGjBvIkPnjlTmddKJ0oYKz7xroZt5Y6V+oH7a0aU6mePIyk+9yKoe3bp7/d75uUWGHJXWm3E59ml8MfP5TgAhW7ZAZpVNAXT5Qa6z0rJufPMB5ylK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB11053
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

> From: Yoshihiro Shimoda, Sent: Wednesday, June 7, 2023 3:44 PM
> Subject: [PATCH net] net: renesas: rswitch: Fix timestamp feature after a=
ll descritors are used

I'm afraid but this subject had typo... I'll submit v2 patch.

Best regards,
Yoshihiro Shimoda

> The timestamp descriptors were intended to act cyclically. Descriptors
> from index 0 through gq->ring_size - 1 contain actual information, and
> the last index (gq->ring_size) should have LINKFIX to indicate
> the first index 0 descriptor. However, thie LINKFIX value is missing,
> causing the timestamp feature to stop after all descriptors are used.
> To resolve this issue, set the LINKFIX to the timestamp descritors.
>=20
> Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
> Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accurac=
y")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  Since I got this report locally, I didn't add Closes: tag.
>=20
>  drivers/net/ethernet/renesas/rswitch.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/etherne=
t/renesas/rswitch.c
> index aace87139cea..049adbf5a642 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -420,7 +420,7 @@ static int rswitch_gwca_queue_format(struct net_devic=
e *ndev,
>  }
>=20
>  static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
> -				       int start_index, int num)
> +				       int start_index, int num, bool last)
>  {
>  	struct rswitch_gwca_queue *gq =3D &priv->gwca.ts_queue;
>  	struct rswitch_ts_desc *desc;
> @@ -431,6 +431,12 @@ static void rswitch_gwca_ts_queue_fill(struct rswitc=
h_private *priv,
>  		desc =3D &gq->ts_ring[index];
>  		desc->desc.die_dt =3D DT_FEMPTY_ND | DIE;
>  	}
> +
> +	if (last) {
> +		desc =3D &gq->ts_ring[gq->ring_size];
> +		rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
> +		desc->desc.die_dt =3D DT_LINKFIX;
> +	}
>  }
>=20
>  static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
> @@ -941,7 +947,7 @@ static void rswitch_ts(struct rswitch_private *priv)
>  	}
>=20
>  	num =3D rswitch_get_num_cur_queues(gq);
> -	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num);
> +	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num, false);
>  	gq->dirty =3D rswitch_next_queue_index(gq, false, num);
>  }
>=20
> @@ -1780,7 +1786,7 @@ static int rswitch_init(struct rswitch_private *pri=
v)
>  	if (err < 0)
>  		goto err_ts_queue_alloc;
>=20
> -	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
> +	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE, true);
>  	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
>=20
>  	for (i =3D 0; i < RSWITCH_NUM_PORTS; i++) {
> --
> 2.25.1


