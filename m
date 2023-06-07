Return-Path: <netdev+bounces-8653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF48672514F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF59F1C20C76
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944EC620;
	Wed,  7 Jun 2023 01:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814267C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:00:33 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2106.outbound.protection.outlook.com [40.107.113.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2481726;
	Tue,  6 Jun 2023 18:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQFrx1ExU2bDxVRR+U2mkKk+3v1MlqvrtDWFstLRuZjIYuoBFEXMHdjcn7OaR5b16SGNxeXtWXsxpFhlWhVPmo55fLVo+mAbpi74oH/zUyRV5sY18flynkEw8P2OmBze9F7p5Wgase2vYUGIpYG77Gh/G4HoSPKp/SNwgghc4SqLfpfaml1BdvUwgpciBSBg3wZ9CAMODK4qCvSE0oZzkb1hunSMZIOBXvdWmTO01By/SoI1uc7cVzHcNvTD/4+D7CVCihBO6h5Ca2TqxdZJ5uPr9co7xSOhkrNd0UfWPSQXyJCtJo40lMi2xyne+oG2PeOtPXapVfvenMzcqOz27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFkSNoh3V2bGO7x5zUf350k1B/V/MzWhvJF5EyCF7dU=;
 b=Co4Ozr4ubeHnHzz8lV31M4mx1/veGGCClRv+NEW27P+htPG1iyiebKW7TJ0zZ9zymE56NecF2cPM+b0/FNC6BXj/osGC9idk2puxDqia/Lx0LVZ3ZDXFMkmpsSKRrmOGVpvIC+MX4xn8BCObylPAOIOqD4pQ2sco4Lp3i7+CvhVrchlMAhBuLMhn7bWkmsZF3ra38g2W2cFlSWTumK92u6D72kpwHUe8cyCS99p1I987YY0/LAwJlMzDUbV6tMiUIl74pZSD3ApCNUTuBzRLunTGeRWmum8od7AxjFEK3ORBCN5sNu+fvon/K3DMD58zZ6RApvOiHy/kb6g7rHWR2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFkSNoh3V2bGO7x5zUf350k1B/V/MzWhvJF5EyCF7dU=;
 b=Hq770poWRYMOwjpjhyOFmRBg+BMjZpQRkKEm9fFIgctkzxaYqUafGQhM7+uiPU/aeo17Mplr4JCfPR+hWTwM6cqyC9hMSNXEkFyIJbvVC3MQeZgPa8/WYqdBwdNuFzNuojnQvUoIBfWfqDOzk3RzxBOn19lvt15Gfe7SamR0/Nc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8310.jpnprd01.prod.outlook.com
 (2603:1096:400:15a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 01:00:24 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 01:00:24 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/2] net: renesas: rswitch: Use
 napi_gro_receive() in RX
Thread-Topic: [PATCH net-next v2 1/2] net: renesas: rswitch: Use
 napi_gro_receive() in RX
Thread-Index: AQHZmFS7Sdd3ylQBTEmaqfZYx2YEbq9+DjIAgABz+tA=
Date: Wed, 7 Jun 2023 01:00:24 +0000
Message-ID:
 <TYBPR01MB53412831A2701480452BC240D853A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com>
 <20230606085558.1708766-2-yoshihiro.shimoda.uh@renesas.com>
 <ZH9x+qhVtqd+q3VM@boxer>
In-Reply-To: <ZH9x+qhVtqd+q3VM@boxer>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8310:EE_
x-ms-office365-filtering-correlation-id: 957c0ffe-f734-4803-d010-08db66f29362
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 3Wzjojc2NmzYnX3o0DFgD8kM7qXxfvxK+4acCh65dL8CKcEFzbGH3aqfUshgnlT2FijFlNhpW+xluTuTsQDk9muITLnvhlujoyrYcFr8cGDHJY3KbT+vXf9pgtOHcY0FD1T029PdyrFJuZlONBOXt9o2ZiEd69lzuXUogV5XHEEtmSbkuhnY0atTYLAmGN1+FvevL0jGMsbQKxWPjls5lL8t9b6Y9aiI5A8Dj8NIWWSk8FZ11PdsGwLbeeNriKC5WqCYfro1ITxouNz2RjqZLKC2BG5qinMIjBhzJwTOMPrrs5TX/h+wIGfT3mmGFmlZtlOetXjxAAH4npS3JGVCNEazn4SOa1zECfiLHkoL9GE5BqouI3Vm/HsWgeO2obL9ENssX1oEtNLZhf0KxhoF8Jrj36B7suW5JETYS7rU+OGLc4CpIVIM4E3dY3nz448v4i6b52ZPOWWYkyOAmQG4N30fLfcsgAlhSOAXoLlN810SCpy+7v1B7DydGYzWWhu4GjnGXo1aOCWpIBZtKfTAn3J2P+wmGNwjxtgV8olhiM2hJeNWlQxnUQBAnjMJQ6fFUb2A6jc8yAoHPDfCZpqBn4JMms+N0VwaTCC4tt027oBNRyiDsYvtn8oJLGQoR3CxlSMooZgRyHjgJH+Fk2Sjgw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(55016003)(86362001)(2906002)(54906003)(41300700001)(38100700002)(33656002)(52536014)(8676002)(8936002)(5660300002)(4326008)(316002)(122000001)(64756008)(66476007)(66556008)(76116006)(6916009)(7696005)(66446008)(66946007)(71200400001)(38070700005)(478600001)(186003)(83380400001)(6506007)(9686003)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oii4TOTaXlb5USlkAMN5olxwYmzf/sHfxbFyToLcGhqNbYnMSXzabStrBV19?=
 =?us-ascii?Q?Iw7rt+9EL0cnizog427b/XR3k7d8NEs2LulkeIcIuarivjp1RA7woav3upc4?=
 =?us-ascii?Q?gRo8ju9wsEf1Wc5gWLe4tNxalIGbtX98wA+gnVbaOxRCVDrca/OgHtBLPLh8?=
 =?us-ascii?Q?9Hiiu6y20S2FnFOI3OAjIw++awsaJTRdu/w1JQ92pgERtwlTjdA82Yj7/kMW?=
 =?us-ascii?Q?p5CQJ05DcJuyXBOKpE46T2JMMHyMPMhdKvI9AnUEhqabv/ry815sb/DcVgY4?=
 =?us-ascii?Q?rQil37/zgRPqdNCYm8YruOYU2Umsmb1BU73IDEjjb/NisEJJoUxh8OeC+xzK?=
 =?us-ascii?Q?psYnvqEAk4YT17Lc00aHNuc4R3KPy5huzb4Yc8crlk4rGDw5utLlYwQ5SsWZ?=
 =?us-ascii?Q?15zXKWgTIS30h5MXOdqwkv2b4mmkD74n6kUZEJlPHf4lSNTWiaShLVfo/liU?=
 =?us-ascii?Q?XJy1UvXZoedl+NhiPXuyoKtvfv3mLe4vO5ziWDV9pNLpWURB+52nqgQG4TGR?=
 =?us-ascii?Q?Gguy/LR0HKTgPkL9PMfAQMWxhUdfvT9+866+QwpnY/Dlj1ajna9eSpZCu7JZ?=
 =?us-ascii?Q?uKWLXeV+FUmFzoYUaMz1PO4U1R2K8YE62ntcAUnUlbxqqIXVOJAWtmSojkUa?=
 =?us-ascii?Q?DmaZyiRr5RZCl5LGaPt33HpifjLZ+UDdJt4aR9oRlzTGEU0pUe2BHWW1J1pt?=
 =?us-ascii?Q?PqGQKOG2uvkKjLgK3g+YUmlQSNbuQGx9lJXPghp8CatQdDJR2EKTIWzfS2+u?=
 =?us-ascii?Q?XNtouCwSGYMsNKRcHwXyXsxJ7FzYPxDewnW7HLY3bwwUw7kgJDgLsTBbvZN+?=
 =?us-ascii?Q?gjcFjLeUwuPYsk2wIyMcZtrTFKFk6wDcDiSRdhXz0GZv7Ixlz3SZ0pCb6mbv?=
 =?us-ascii?Q?YXkTGPOyT0ySwGFm3oXKMNNDqskRUMc8BGrMiND9+Czu7BcVDXFq6SPtsEjN?=
 =?us-ascii?Q?M78bvykL9YENwn6CfTuTeUz2jkm7et1+/iUghWgThoGEQVJyvGArCORzS6l/?=
 =?us-ascii?Q?49UhNzBpazPsHsjOmuO2GN0Z65elNvd9QfB++8TQxI1QDI+RpI2d7i+M/bTI?=
 =?us-ascii?Q?qj2gDXxvGf9JP5DehxfU6yQAhF27AvDc2MfpyxiVPyJ+6W0xTygk6zOyjnSv?=
 =?us-ascii?Q?bsLaUi7ucIICToommun9DKBq5TQYXvYOUGpcPO0/lPX+71Zb0EzX97xeyPgI?=
 =?us-ascii?Q?V+Tn8jIfOtCIBeuNmmBPlTVEbTYcodCyDhYxWtB6Y4WMq0KR2S690Q6UEYwQ?=
 =?us-ascii?Q?W/WkN+f1b6bszjUdiZJ1pwJnrgOcTl0UR5QWnRjPLl8vlIXDpGKDCDjffRSE?=
 =?us-ascii?Q?hDCSKR7gn/ae9ESC2kjgURZh+NQbq3S6yMhg6BoF4rqiC38wrRLeDo4zzimH?=
 =?us-ascii?Q?0X4hsTtXAA6lT0yf7P4LU1LOzOe4D29DXeyBwA5iz1SsRnw/qUG9e8rXjKUx?=
 =?us-ascii?Q?/Hq4LFBkdKdX8eXWlEl2tF147pmRFN69hNTBMCh/4Z50bXlcv+ipPAvY7dvc?=
 =?us-ascii?Q?xXWwlM3bRcWIw+zMmJJT34WYDw0pGFzRIepanYUPNb1YtRyKNPEhTvz6A4SD?=
 =?us-ascii?Q?+XMAYkzy77QqCUguOkMDH/klXzLzELj8PG0YhVILM54aa1hVJKzgudyOuMVA?=
 =?us-ascii?Q?8zjxQ7QetAKI52eeeozQrGqMF9Eat+J3Co/tFGB2BAaCyvMNYf6BoqIfTrBQ?=
 =?us-ascii?Q?srxNeA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 957c0ffe-f734-4803-d010-08db66f29362
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 01:00:24.3549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q4YyCvgZFvIg1EuxNB4NoiMMvfpwPASN1y4ivW2HtGv4q7aRPgkMQlFLlu8DDZwY8JA3dsZJw6eiNEK0Jv9kUztlD05v5WiaF71PAW3YGqHCS+cTUiak0qyzeccYouh1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8310
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Maciej,

> From: Maciej Fijalkowski, Sent: Wednesday, June 7, 2023 2:51 AM
>=20
> On Tue, Jun 06, 2023 at 05:55:57PM +0900, Yoshihiro Shimoda wrote:
> > This hardware can receive multiple frames so that using
> > napi_gro_receive() instead of netif_receive_skb() gets good
> > performance of RX.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>=20
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Thank you for your review!

> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index aace87139cea..7bb0a6d594a0 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -729,7 +729,7 @@ static bool rswitch_rx(struct net_device *ndev, int=
 *quota)
> >  		}
> >  		skb_put(skb, pkt_len);
> >  		skb->protocol =3D eth_type_trans(skb, ndev);
> > -		netif_receive_skb(skb);
> > +		napi_gro_receive(&rdev->napi, skb);
>=20
> Some other optmization which you could do later on is to improve
> rswitch_next_queue_index() as it is used on a per packet basis.

Thank you for your suggestion! I'll try this later.

Best regards,
Yoshihiro Shimoda

> >  		rdev->ndev->stats.rx_packets++;
> >  		rdev->ndev->stats.rx_bytes +=3D pkt_len;
> >
> > --
> > 2.25.1
> >
> >

