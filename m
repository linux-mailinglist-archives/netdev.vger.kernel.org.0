Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E204B5B5D
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiBNUps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:45:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiBNUp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:45:29 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10051.outbound.protection.outlook.com [40.107.1.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC581242873
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:42:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mukv6E2QuGT2UifMT0QzzKtKTB1ipaVJjVqTwEJB01sn/h4XZnuk2oVjUBr/JZ597K19dC4lzsv6V1CclngLWWZwoLUZBbpOVkM0473D6moQGBtidaYjbBWZTovdNw/jF4vn1UAhz38EacLCgvXT60g5w0xEZ2oxCGPT2/JTC4QbAQwGsHodyK9ZkJavXqYFK20yQGpMWZSYd745is6qytvBLwOGSJbSvdGGrxjXAPR8Mh0nBI4z5ZuaG0KaDZE1M0ns9QWdwlFb0PgPvGH904bFuQpGnZ8YLGPFZ/z0areGsmaDiZSJ/I9SMJvG7SqKV0vz9W2p8zBZT64sL3WPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yaouOZgKZclUW8Lmzelkrb3ghoE2wc43Mom4CyyZoCE=;
 b=jmLylAhLIZzYyAlat5Hnm7op1YlDJJfzWaeezFlLZ47um4fPugTDsezNbG4vxhxKfDuYspqxDMuo2AeyZRfPMHsKW6yU3y4BilK5LRlstjPiKioIRX1Mw53i0aVthDTiOratR7fKUBrxKg5IzxWEnvs2v697cowDA6vnR3IUQI/A7jCNlxYR4yG3i6eIWw7cgdhC8vivxQJqkU59v6q6MsTAukuPCauIDgFzqw8TA8TRuaaA74Yw/Dc8FihVbN612w/S1zbOZAnYCPiPmJuIe0cWg7iIksnV3+1XzWNMLiSVDQCAIVYh+JIoJ6YARKGLZvC/6T/0Y35mx/+Ze0OS9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yaouOZgKZclUW8Lmzelkrb3ghoE2wc43Mom4CyyZoCE=;
 b=T6arPPSiWzp1LVfmePb64JcAaD7GMQICBJbshjySp9jBJ+nXhhIy5Zh2pu+ESokKny8vLjb30MBVZoJJz99GRK02I2qLIYntZTjwgkQxWxdsA4hzc345rjkPoOdOdPmB5rnGoR2452bJL9ZhMIrJ0pM+q4AkHk0Q53qzQnsrCQ8=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5549.eurprd04.prod.outlook.com (2603:10a6:803:d3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Mon, 14 Feb
 2022 19:17:02 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%8]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 19:17:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Radu-Andrei Bulie <radu-andrei.bulie@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.B. Lu" <yangbo.lu@nxp.com>
Subject: Re: [PATCH net] dpaa2-eth: Initialize mutex used in one step
 timestamping path
Thread-Topic: [PATCH net] dpaa2-eth: Initialize mutex used in one step
 timestamping path
Thread-Index: AQHYIcrQE7+o835p1EiaY1pmjdshvKyTa0yA
Date:   Mon, 14 Feb 2022 19:17:01 +0000
Message-ID: <20220214191701.4vlzqfbng4s22wlf@skbuf>
References: <20220214174534.1051-1-radu-andrei.bulie@nxp.com>
In-Reply-To: <20220214174534.1051-1-radu-andrei.bulie@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34afe9df-7630-4b7f-f752-08d9efee946a
x-ms-traffictypediagnostic: VI1PR04MB5549:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5549A19EAA3E232DB23B72A1E0339@VI1PR04MB5549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K2bmDJA0l+e5y5N5ZHSlIyyRV0G1/mm0u2pJtsSvVrGBNYidopnd6sPS4aDxZsdc7S5jHpwxMiP13Vfv6igY2X33XBBDuBjKIaoe85RKsvE7OdY2JexHhbC+tLG45OxS79M/mfE3KksmCFImUQgB+F3xwpBIR/945o6kkGNpj4WL28lft3kZITmHvx4n3DvoBm6DXm5g6c0QHExr80bvkloJr/4Csk868mo4Tb8hxJBA1dHNBSsrMqdNgZMJnTJL1KiW58PVguWOefNAPcjcV4fYPIJI7+1fTwWqu28v43H7ntcZk7WedxcBrT4niKTmY6+IHB53c8Z82i3FrBWzH/KYccdE1/Hba6e/A4MkySvXUioduPJK7oBslduBr/IEn4Qy17IYkllomHF2Nn4wzk82c3jAhZg/wGXW0ryep+x+14I1FX0qLcDLk/lCuhlSp7dOkOxttPovwXsLY3FGttC5Gr8IGLJJMQfWmUttlOUFZNkTEPdO2peo2L26gNArrMicII4VGo8w7eVowRnhIhByWBC/d9saaj2FNyoUYyFT+qFC+z6VXUHidntJlqnrk9aoBom0ygbZeNoUfxq7OX8F2h1rQxJSIUNe6vNfiK+j21qK3watqbh64hc/An+KdZNyo+kJDGCKAj3uiB7004y7WGb4Lx4R6jJKSXpC1KIeyTd59BnA6+EbVhzBq6lT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(9686003)(86362001)(83380400001)(54906003)(2906002)(6512007)(1076003)(8676002)(5660300002)(6506007)(186003)(26005)(71200400001)(6862004)(122000001)(4326008)(66946007)(66556008)(8936002)(6636002)(66446008)(6486002)(33716001)(38070700005)(38100700002)(316002)(44832011)(76116006)(66476007)(64756008)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KUya8swI8qKTFhhKQa0ESy9hOVDjJsz3e1EW7NDWApZPiRUKn9xxn/y9IQJG?=
 =?us-ascii?Q?pZKr5zhHxoAaatZ+bHoyD1q3614niWdLN9xyzN4n8jYA/Gz2DlvjV5F4pCay?=
 =?us-ascii?Q?ZCvMASGVQUsmpGwXVfNvH7O3OTnSBFA6hkG1aptvn7G0jhYFT9yc8MGT5eQV?=
 =?us-ascii?Q?LKWw0pYKFbx8IsJz0KrdqFTpGVof0PUse9aW55BoQ6KNcJxKidu0/zXJLECq?=
 =?us-ascii?Q?CgQzsVHS20UUFx+JFZ43lK5dwqw0oW8pdQSM/U07giPWL5Sfcb8A2HsUDMTC?=
 =?us-ascii?Q?NCXe6r7zQdrF+fpvjZUgkl34PvNlKiEGsLD8wu89P/DCpwTHcgKqgCk4ehbj?=
 =?us-ascii?Q?zPagUaOI77dEa+JX0qLG8dk0vDh8mdfX4GD74cDOtbpQqFPWztEnNSaX9yki?=
 =?us-ascii?Q?WlJAk1ED/0YMD27ShucOse4x5WcmCP8hPevc8CP9YlJ2pfk+MYWOsrU/6ely?=
 =?us-ascii?Q?YTPY81LOqbKs/kQHon6BpNYlfKnAEgZJvRUn4H2ZJY+PPJPRhbA536Dlwcih?=
 =?us-ascii?Q?1DV55OyDWwSCKCR4tlJGS6U5YauVqE/cT2sGevS6kTG+HnonTZI5Z3BSYLAC?=
 =?us-ascii?Q?+HZZz6FUYCk/H+dxt1rCTQpn6OEcpkGnmxHYfScZrmLb/X8oSJ+cEDBjSDDv?=
 =?us-ascii?Q?GHC/clliWWHtVC3y5fyq23l9lefMhINoWqUaFVlL37/WfRJ5IVuOCSQWOiTV?=
 =?us-ascii?Q?hVk389cLiN4VNEZT7kevo1Xz8wrK90lGscxte8whkNmaG5zsWt0WJ6akQj8A?=
 =?us-ascii?Q?+c8Ua/kpHqdz8OzLym0tRZhWUKxDB8OvhBTFp6wY1ymm/7dtRUnV1qQ7NZc2?=
 =?us-ascii?Q?7FvMhaSFdMZRU7zxFQYtAMXiwIdHIXYPrTbvx1xh+V6pISNq5Sn7FlwiW0We?=
 =?us-ascii?Q?1eeq+PonSEXzbHCsBFaw8JZoEMobHVBInaLkhRa0kfcLIrabo5A/UGsZld0X?=
 =?us-ascii?Q?2S3ctko3Ddwy4UMygTov7dffekFNA1W9rk+mkYai150fD2gn2pZ28p/pXdir?=
 =?us-ascii?Q?QGSskX79pqlQukmFpY3VgFqif3P2aquu+/S0Ro81cjFtnr6kmCS2adREyQYp?=
 =?us-ascii?Q?Lzpi6cnXmq6M59iFVSdW+qNNJRjOwcU8OWFzlL38N4zcY0QttAaM81Ia4MuX?=
 =?us-ascii?Q?zNkoKi2RnnmZn0quXF00NScgN5iuaNypY5B/vJgSPu3fCqq/kNbAGn/CGdm0?=
 =?us-ascii?Q?5q9Ne/7Epzz3pkEPQtImfySLA2gF9x68fTmpdh2WM3h1Zpxmh+d7HVpulNvq?=
 =?us-ascii?Q?HbFYl/hDSuoQ44u5Av/YHiPSwhoCOC1YCcEZrM1daoMbwFotpVSAnw966yOv?=
 =?us-ascii?Q?ak0WWQFn+rfKoVisV6P1Dok7Gp7BtyOlgdeHKFbaRzjn3Vlb0YuQdGoYLaEd?=
 =?us-ascii?Q?WGfWXRs6hdpm0P7YU2I30DH0QO5oI23HL92Eo3gZR3icH5T4mW5/BQKO7FLV?=
 =?us-ascii?Q?+zMaEdILEnTXLMv+IdFq/EVZIl0BgfFW+MwQTILyrw0H2aYdcbJfNZ57lXHf?=
 =?us-ascii?Q?NGofSjgJmDZbQ80bQkpy9inmLZcAH6fAbgDVamrIJo919wTBBvBYsK6dPPyl?=
 =?us-ascii?Q?WXZtK/qPFkFFS+9BIjnrPk3uwu3qYNZ6VySQkGqo9QFJ/L/fw/lC+bJ28lgS?=
 =?us-ascii?Q?X3PxK+56ZTr+PnAB4pEWwMc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <57BE0F952EF83B49B476580EF7EBD526@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34afe9df-7630-4b7f-f752-08d9efee946a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 19:17:01.9961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DuLEMWyS6YhTEZJdnXFzxuIf2a8Q3ocFcRlisHbmLkZ4O2i8jPmDJPX9UUUoqU6PvIWDiJPKYcSbwlb1lCOyrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 07:45:34PM +0200, Radu Bulie wrote:
> 1588 Single Step Timestamping code path uses a mutex to
> enforce atomicity for two events:
> - update of ptp single step register
> - transmit ptp event packet
>=20
> Before this patch the mutex was not initialized. This
> caused unexpected crashes in the Tx function.
>=20
> Fixes: c55211892f463 ("dpaa2-eth: support PTP Sync packet one-step timest=
amping")
> Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c
> index dd9385d15f6b..0f90d2d5bb60 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -4338,7 +4338,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dp=
ni_dev)
>  	}
> =20
>  	INIT_WORK(&priv->tx_onestep_tstamp, dpaa2_eth_tx_onestep_tstamp);
> -
> +	mutex_init(&priv->onestep_tstamp_lock);
>  	skb_queue_head_init(&priv->tx_skbs);
> =20
>  	priv->rx_copybreak =3D DPAA2_ETH_DEFAULT_COPYBREAK;
> --=20
> 2.17.1
> =
