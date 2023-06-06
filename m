Return-Path: <netdev+bounces-8345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33769723C69
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CD161C20CD6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6FC28C07;
	Tue,  6 Jun 2023 08:59:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A6B3D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:59:27 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2137.outbound.protection.outlook.com [40.107.114.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B14E49;
	Tue,  6 Jun 2023 01:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1vxuBGrVMf3rELs7XuWUPPeOun0tFAVSCgjrYfXMawPb+S7yxULBMi0tLJ6F4Py5L2+BGTVtKXVjW+dgQtVHKJFJD09YDhN6U/u77AlkrU19QTk8GycgQaWqrAxld/9PTpzL3kewhyvEDP2Sq1hVD2dpzHi+LDpFxZtb0lOhoaP+EpgAu1xydaOhVYf5AnV1OHb3C1MTL5DuYp1YSA9bZnW/qpc5hBzJtV0Ai4up0GeH1nftx56Hy8G/FOjCyEdRMDRm4iMFfGAPgY+ZWMlz0F5TqsAeAmN3PuCSyW5MPxYviy44KHPpbApk0NoAihyb0dbPCZ3PQ0t5H0YxvaV9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmQA9EYFeoVP4XzA0QbzFGKzSAYFgJ0ijPCcwpqKOog=;
 b=F7bquGKD5mkwNEssRg1MxCzkJJuz1Uyo4PPQs0KRFzzUyF+S/RWYC8v9/mj0OKF7BckgX3XuXVK9w8h2It2JinvExMQUvXk6n47zqs9DL1nfd9nFg0T8H6WMh2QjnnLPyms1KGKoFLmYSD5q6zGOTR47tHQmg5b0aWDAo1M/hlmAfSlBCZw6XwRV2S5kt4GX5821hSZhFQ+qPvVjo4Bx6PL5L8UAgG2KSEyRBAi3nZJb6pcZlEKMUmf9H3A/WElOS6SJBbSHF4fMIwQJERifiho0KbsvHMFz2LZrbKdhsXk/ASf30rflSlQR9nRBd44om2pCP1i08/ZS7QbajLupcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmQA9EYFeoVP4XzA0QbzFGKzSAYFgJ0ijPCcwpqKOog=;
 b=Z1+FWmjbVCzUHibsmK2HZL8ZBQa0M3NymUo7ZnfK/dvFS3Y28MNioe0Rvb/nxcGIkM7wzEvfM86mMIL14swmyoczAYVDP8fi7164ZSaMHMwElsav/XEfZYWzzpI99B/1dvH3tLZUzwzo9FFolsh2VRGg46B/Q/N5ocqMCFejZas=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8613.jpnprd01.prod.outlook.com
 (2603:1096:400:152::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:59:22 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:59:22 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate
 limiter
Thread-Topic: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate
 limiter
Thread-Index: AQHZkgTPigbr2NDJIU2hZvqbiDJN569zNgeAgApPegA=
Date: Tue, 6 Jun 2023 08:59:21 +0000
Message-ID:
 <TYBPR01MB5341ED437E01EBC646BCC85FD852A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-6-yoshihiro.shimoda.uh@renesas.com>
 <ZHZOkTChN5pAl417@corigine.com>
In-Reply-To: <ZHZOkTChN5pAl417@corigine.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8613:EE_
x-ms-office365-filtering-correlation-id: 96b2e917-cabf-413c-5a13-08db666c51f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Tia5pb5ZnM30zakXgRPWLNxJKBZeagQaWwdd5vhYj+KjYVhe6dbdBPwJKrAfKyf2K7LEjowD0yDiktdVa8DK2ehDjdQN11l22EnNfthr5/5jjmOrUcYStcR/DVo7jImc0zn4BvRH7bGjPW8mZvxIPjcrJLiLMM+hsfnmLh5F1okqcZhWJs/uSiX6Q1rwmzEKaqu1AbMUjeUiDTvO2lLyiA0gIykDQEQG+/0mRTw2AITIXTCSCnyhFrt1hUzK0OD8M0WcCEFfBbf1Ri0aMQhsP90YblHtTC36eovgN9N9jMzCVvJM3mBknn7rKUySDNHBIdHqTa7W9eM1N2UGXrlz9j8tvsiybLaSOdRCDSptWQzwEmv4l6qVBPtX+IcxTPavdXLbeTLrNbJPq+U//WYY8mbk3XUtHAmKw4F9LGLu4AaJGLHsvs4C8owQ3E72bJ0zx3iaU3/LzVy3AC0CCM2CAiMSCOV535s2YZhprDUB6t7pzTCXyaSWtptrplqVWOdxwZQSw6Wqn/BiC/fzFWOUv8SxR8tAVDaOFrgDS7Yiq6jU1N72sXMhtrdlvMeDZEqXn5/3+C50SdcL/tIjukT6F7wiupY3teUw6uQaBJZJ2nA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199021)(6506007)(9686003)(38100700002)(41300700001)(83380400001)(966005)(186003)(7696005)(71200400001)(478600001)(54906003)(55016003)(64756008)(122000001)(66446008)(66556008)(66476007)(4326008)(316002)(52536014)(66946007)(76116006)(6916009)(7416002)(5660300002)(8676002)(33656002)(86362001)(8936002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AZ/+nBSxmcMrKxiihXfOAvsTLSeE9dvBTjBsFpujJNPuZ2AXhdrUsi/9wEPY?=
 =?us-ascii?Q?kILz2x4PpPIEQ7etJcOg1r9vNG7HOXd77bgDoWI3cMF6fe5ar0jxU73cHGnq?=
 =?us-ascii?Q?yPbN8t2XX/1AfQ7CbobduupZ2gbzKlNYWjRCkDwYpT9al7aZRsIvGUtBIoTV?=
 =?us-ascii?Q?jS7uPzpGNqxt6edgq8DHa6A4VbIxtPHfzFXJ+pNaQOnuwHg1l4HbIoQF72hP?=
 =?us-ascii?Q?joHDtk/f+6fpVeauCxw85USPc7Rn1nbXo62+hiZeYlN5/Cod07raLDneqe8x?=
 =?us-ascii?Q?1IGOz8/ayWBJfvaQ7j5amTsT8u5scrAkXxYsnqsq89Nxu8nODaz7pgp+hKgv?=
 =?us-ascii?Q?MlbCTENKSN3pPUMhRkSou8tMgTk9H99KI7UdIPwam9qbApcEKxBXwJMQhohk?=
 =?us-ascii?Q?jdMC1+PBfRFPFg3henECNYl5lxfg8QKgvMnAaPlcfzUESkR5MqBsx86yhxvb?=
 =?us-ascii?Q?bN+ny32VK++y8HHHELZt+Yojpfv+mLiyEq2/RmXaxmS+CPQnVBrHQ64SBsTs?=
 =?us-ascii?Q?bvaemfENYMtSDtb2+PFwITLbJxOH+PYnYbr3p/OaTAZnCV+H/VD92WdCRmJy?=
 =?us-ascii?Q?cHtyZEZ8fzd6r+/PaQzqiOHINhhhO1jNGm9e54+0vRm/GbYgx8NQaPfnabUU?=
 =?us-ascii?Q?+piaOoWv5eGLRljxRC0Vtg7TU4acQZFmlB8cWO5RAt97ozRBx4E73aCUg/Nv?=
 =?us-ascii?Q?IsCMKBOOMEV5h3WI5ifOa0UUMdfzmaD1nH2bm8PBDoYo6C0srwvXnWD/j8ql?=
 =?us-ascii?Q?FjzciGRMqt8pbMvYGfBjZ7s1xHf2DCGwBns3+j2G6CX6lIX0RWJKDe5buDK9?=
 =?us-ascii?Q?dkSHqz/A2/c6GItBko3F4CbicJ/6Wp0HNIU2E11TS3CS6iuuVujsgWJcsXTr?=
 =?us-ascii?Q?qzwsDJ32C+isLgMV6xeion0XQ5+6JXt61Fw+lEqWVJx0c9eruY+4ikAVP3/y?=
 =?us-ascii?Q?4Ro4A2zmp9WEHW7ymTNkOGpCAQ4I0vJpwUOMwo9oAdKQomXHmc8ST/fjPIDP?=
 =?us-ascii?Q?Hoa9VcLk4q6e7pib/3E0XTICMk3b24FLXeJlC/lsPuKsEpJEMDUT10FrCnzq?=
 =?us-ascii?Q?iKPvkQD/Limvk2dIgaNa7SlICqwlyWrlqVvdiv6tpmaU8J5jvm4QeQjA5yVj?=
 =?us-ascii?Q?Ri29xo6Rk8wrUlrXgB+VxhFgsXbzTGl/mmIgEGaaRo9hK6qwV9TDwU5yPRVj?=
 =?us-ascii?Q?LdclhKpqmQng5+pFTr3jxIeWZfbba7+hvgkR5277Yk1q8N+WWwmvJLIb6bke?=
 =?us-ascii?Q?e3xZN00/HDwZ7IM+UUD7+LjaK+DLr0bkhLnYgMx4dSarkoxkEjT+3o1kxacT?=
 =?us-ascii?Q?qL/PppSps0IRpBr2kU4bLNQAeE2WaTxYUx5uLXfbKVCsWG4QmEBCeEQbrzuE?=
 =?us-ascii?Q?qbztHj5hNaID0fiJKsjKe884EYwMTP0rlATugvhWkuLAtrqxkk0uy7qB3+bY?=
 =?us-ascii?Q?/VBnfs2sDDOhc6NkPDyq4uKB1RwJOA2YaNE+dZOoWC686CuNxCCE5VUbHErx?=
 =?us-ascii?Q?AV7m/72U7iYO0TVd1TiRjEF+Uiio5lgQBmJkGfiHpC8sGvSCG/pFL6ZZgMy6?=
 =?us-ascii?Q?v7hcQeX46/j/g2hVwR/w+WBRv6IJuxbD4+37YcJgqRXv8y6wUIwVifD3JNjj?=
 =?us-ascii?Q?ZIosCt69QvgW8jySQPO2QKRYgMCFUDDDplHAVlfc3pKVJRUBAXaiomNg2ojr?=
 =?us-ascii?Q?VlYfbQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b2e917-cabf-413c-5a13-08db666c51f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 08:59:22.0268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WjN4MNe4RxdSZ/y5AUN1Wv/FDEW5Q04CWvMvjU56Xna4vp1TNecBAxJReFrB6SgwSYdQnrqsV8UFV822rvCHVaYHZpbFAeWjaHEPMemc1sYCvvJz8odvRsT25Wp0VOOk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8613
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon-san,

> From: Simon Horman, Sent: Wednesday, May 31, 2023 4:29 AM
>=20
> On Mon, May 29, 2023 at 05:08:40PM +0900, Yoshihiro Shimoda wrote:
> > Use per-queue rate limiter instead of global rate limiter. Otherwise
> > TX performance will be low when we use multiple ports at the same time.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 51 +++++++++++++++++---------
> >  drivers/net/ethernet/renesas/rswitch.h | 15 +++++++-
> >  2 files changed, 47 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index 4ae34b0206cd..a7195625a2c7 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -156,22 +156,31 @@ static int rswitch_gwca_axi_ram_reset(struct rswi=
tch_private *priv)
> >  	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR=
);
> >  }
> >
> > -static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, =
int rate)
> > +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv,
> > +					struct rswitch_gwca_queue *txq)
> >  {
> > -	u32 gwgrlulc, gwgrlc;
> > +	u64 period_ps;
> > +	unsigned long rate;
> > +	u32 gwrlc;
>=20
> Hi Shimoda-san,
>=20
> a minor not from my side: please use reverse xmas tree order - longest li=
ne
> to shortest - for local variable declarations in networking code.
>=20
> 	unsigned long rate;
> 	u64 period_ps;
> 	u32 gwrlc;

Thank you for your comment! I completely forgot that network driver should =
use
reverse xmas tree order...

JFYI, I found another way to improve the performance. So, I dropped this pa=
tch on v2 [1].

[1] https://lore.kernel.org/all/20230606085558.1708766-1-yoshihiro.shimoda.=
uh@renesas.com/

Best regards,
Yoshihiro Shimoda

> --
> pw-bot: cr


