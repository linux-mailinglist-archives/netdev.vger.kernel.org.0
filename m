Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C51610E4B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJ1KV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJ1KV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:21:27 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2108.outbound.protection.outlook.com [40.107.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147F6726BE;
        Fri, 28 Oct 2022 03:21:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/sJ7WLjEBlj5VEwueXk6FuxmNddMnFrx/2UpB3l1oDQp70O/YvDCUAtDt/WvUIoOuX1jM9bpREIeqF7L+ts78mf9FiddDx94H7HUUTyDAluWRWfpgbKEOB9cumlzgeftk0OUSgHcT3Ko7KWFmwDzjewtWY1KS7xFJuIsoINShulDNuKl7z6DTIBbalb3geTwTlFstzx0jYagNckhg5xSl0jZgdvQ85Yt6yLCL33wb0jUc4IbN0HEMyTW0NiN7j42dWildzLVOUSCWQBk/+pcQHlIAqXGg9QRBY4HUZBLBU8Y02GzM7CmXn/t0c7YKy2zVjH94Sqz/TWalQf4BlmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0FT6mWWznLoK2D0OCs+xOqsg31zXJcC88+lgDAz7QQ=;
 b=lbxURdajmAXtMEf8oSvUzOx8Qami+rx8+YDshV2wLiM4XOG34U1/yun4Zbv9zfHD37zVrf3J1xeNO7KJ5Kw8TZj6zNQcU4kqnmhWl65hg10CcpeZpRAmeMvS9tWI9E8px28fEjRg/ChPQmoDyXeb0Bj3SLqBCd1lpF4QaDLvrXw71dpdXiCfVxtPwa0lMkHn4c3s/qLy2usArMdoLRqsnlFMwlxHR6iF0/Rpr5qeCiSJ5u6fEGGXYclbxsSlfBGJ6Zn4tvPSXMXuJqkvVEYjpPZMrIBMcQJUfyyEwyHXDaU7encGfMADpgcXK2zStz2VqXickRJ/Ga0MEOZvDodb9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0FT6mWWznLoK2D0OCs+xOqsg31zXJcC88+lgDAz7QQ=;
 b=th4+38gNlkBjSr1xnoa51ogyZRmBWzoSa0jsqEJYmuE+ZUeC9/5efDsY3+1p+L91iKvAX/NaWmwmT+Jd48wMzXlAiztVxwp85xNR7RIUBnC9fJTCGdlHBXoaAnB1CK0KyLNycRtVCdx12E206yOsTyLmJyPJfTD2ZUf43BWnFvk=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB10276.jpnprd01.prod.outlook.com (2603:1096:400:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 10:21:23 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 10:21:23 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Ulrich Hecht <uli+renesas@fpond.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
Thread-Topic: [PATCH] can: rcar_canfd: Add missing ECC error checks for
 channels 2-7
Thread-Index: AQHY6rWFaf/z+6SkH0edXwWQrfdnaa4jlgIQ
Date:   Fri, 28 Oct 2022 10:21:23 +0000
Message-ID: <OS0PR01MB59225354504558556683D35B86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
In-Reply-To: <4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB10276:EE_
x-ms-office365-filtering-correlation-id: 2cedda87-d108-4331-451a-08dab8ce2a3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eiz7xfsvubmvtACCh1tH5ho3T2CsCE809lHeS3Grjx/J7UGvlRhh+wLR9qgRvXXsj+sLDn3PIgfgSkDUYsvoOh9z/0SfWf4MXD5Zrg+lxuekbK0NfLEU2h92UmAlNI31vseaxZn0Q4y6VQJIyAGJn/x+pgbKPiuebjbUQ7kIFkeRjxlT2oTe61ptyQF2pCvuC2rqUA7HC4o86hiFobsnyH4ZZtsYd/uw4QgrHvXs4EiNWxOl00H2OeqBB+DnW0GsJ0NDTAp1HybtmkgoNOzISvf+Ydoi1+UGbp1EfOoyv4D5L1zbDN0uZpW1eD+ewUJupGc2IWANqTr7JF1zC8I7l7IhhyCQmSnxV2bl9bTkMLYzPDYonrGTRhDgbLkjj9SeEhmay5qJz6OfkZeR4nJbhKNmmqhgIZo+q9iFZtPkQFXlSXpGCM1SNpNGR1Aj5etl50F2w/gD/FIvVAnLNQj91PXTjEfh4MnJctVdZiTIHwevzMbfXheBSGIeWLRnp3E7wt5zFHDqaojWJWrOg3xb24dpDTaSu9Jk6KknlbsxNfpAGa2zXIJbtMrSBuAXclUr1iYW78iyLA30g+PVz7waiDFQ0QWae+o7AYVmnWKx4ds/rzzKNg68bT4JhtDf3079eT50eT48nm61BY1++jpFSrTtCJJN8Tv0aVU1TD5MbhyxBmM0gA495t2OXmO2cN1gnn4FKRTCvOfhJdi+DTjUVCyy4Bux8TTdu9XEWD4iqiYI0ZztJdmNH8Ck+hlryuETZa02r1UgmSyoXNZjxEF9DA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199015)(8936002)(71200400001)(478600001)(83380400001)(110136005)(38070700005)(33656002)(54906003)(52536014)(55016003)(8676002)(316002)(64756008)(4326008)(66446008)(66476007)(6506007)(66556008)(76116006)(38100700002)(66946007)(9686003)(2906002)(26005)(7696005)(122000001)(5660300002)(41300700001)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sO2mn+gA/I+M855r3m4kTUL+ljN3Z+FiQb3YBskA2EdOJ2SokyIVn7Z95JXu?=
 =?us-ascii?Q?eDUcfJZJDIom+DUVAZL4u8TA1x86KR68WiV1yVy5Onc1QpwlkuYXi/PsCk2f?=
 =?us-ascii?Q?5YklRpGJBEnA4EXLaxtLCnP4IHJY2+nvXETTZh4Tw872iI9UPRMAaKSoO2wW?=
 =?us-ascii?Q?BKaTu/12ukb4t/5ShaNkCuAhubv46Sjjzu18m0DOaKmhYgjR8JMNZwhXIeZs?=
 =?us-ascii?Q?tXfvLsqHFndYxpTeutNxEG8miOuzpzCkTEJA1gYLrlDHqvzhkxJlJfEqR5Rm?=
 =?us-ascii?Q?1wSOACJrvkCwhSI1t8yux8GqgSKUq6uugFIVgDRSvhV6CYj/kFwX15keHq1a?=
 =?us-ascii?Q?5LOVcRtz24KWULvSRtG9E6GO+GLZwaKgZLcXl9An+UQbJOd9deBQkGQiBIAB?=
 =?us-ascii?Q?ValBJHQBLUgByssJysMPIOIzpPg5+jNYi/VZjcWzVMHhVB4lEYnV/BVZ4die?=
 =?us-ascii?Q?cw1OEz32pregFD4Yy6OIByFx2FkuK5/wur50PyFmSsletJCvRNRZsHrdQRE/?=
 =?us-ascii?Q?ZTdcCbCJMtw/6rfophCyLxtxkTzB0bLIxk05xpLvr5LWxyd400Dk6+L80EKU?=
 =?us-ascii?Q?fdbfuhl7M1FgzvvTITmbbRefMi1xElTG6jQd9+92RpPn9Nhl+4BALnBQ/VT0?=
 =?us-ascii?Q?3J+Ux4plkKpb3oAUO52t+LPvCV8613NzXCudRCq8X4j/zdWif54OVotYlPrq?=
 =?us-ascii?Q?6S/lVfbhhepZBWLHBlpFysr5LJHQDunzkCJpm15RBls2W6ahukqQEXOWgjr6?=
 =?us-ascii?Q?mWLdyTf0PmtgsAWJvKGDwqgSB6L8jTVwN6hqZWoNhxxgnLLuWRB3M9IuoJMg?=
 =?us-ascii?Q?B+JuRFIMJdyWNMdsg+Eog6SNXdQaFKxuyCrCNIQAsOF6WOE6UfX8r8QAU5i5?=
 =?us-ascii?Q?vJdeEBQ2E/6eeoGLL9N0/XWWRrV4FE2sEgbyE8ijxbwLwyzv4LrQHpqMBtJo?=
 =?us-ascii?Q?90zFG8GaEPUyXJDm8SVgkk9Fh8dhNYjGvlhLXYEs2494ZCsczyafeh8VbYUM?=
 =?us-ascii?Q?DOnBz3SC3xD8qGwszdmEIONXy9n6BrP6Y4XRXUOhRm308rr4a5/8BqkA8lRJ?=
 =?us-ascii?Q?7XdOtYGcFlH0BCEN1MLA5w6SIc2M6NwXZFuMxB+Op857m6xIUdM5ff8oHPyS?=
 =?us-ascii?Q?kVZyvBd9INoLhaOJZjBEiJeCAYHyWUoms1eRqEMxOvTVGREF+c5mNxFonJzA?=
 =?us-ascii?Q?5s18NgvKzZtUjAjPsYXm7hhloNjq/LJ79MZuS9C2hmG5lVbH+JgiNnj31CxM?=
 =?us-ascii?Q?+CBDD+HCvBspr28ZO5DrMn+o+wzcyg0TTmmGm/eQ/RhNSE4y7l8Lg4yHM+n/?=
 =?us-ascii?Q?7kxIqxMEP2vW+p1MiY0Zg+qgUpdVcwekMhFtshPNaDFJ7bNMtlf66YMM+uJb?=
 =?us-ascii?Q?3hu7vtVIPryZkwH/Jza/39BNCtEggzh2aGSYwR1UjNkIQu41giNx9hThxWvp?=
 =?us-ascii?Q?ayCEtZT+CLFOkfHVYiS/8jwYgLpJ51hMSAsu4YZn1QNI5AoqWJVcnzTuLNRq?=
 =?us-ascii?Q?LoXyyCpGZhInuLgUzLvpo0Q8sbTf3TB6hTyML9p4dsFL0XjtpR0q15CV3yyT?=
 =?us-ascii?Q?/vQAAz+fKGK6Mqp+O8sNuQIOBR8wQ+9K/ZWLIJYgpHmvpEO+GFDJFJKjgyD2?=
 =?us-ascii?Q?rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cedda87-d108-4331-451a-08dab8ce2a3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 10:21:23.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0X+bwPV3TrktZkxJ4IGC78CGS2pLl0XzYvfyh5VeZPI8ykqwLd7dCGNmhd/rOR0YPTrqSlrMPSPQonBXLhxfSeb3A//sV0WWn9rUgApsuq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10276
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

> Subject: [PATCH] can: rcar_canfd: Add missing ECC error checks for
> channels 2-7
>=20
> When introducing support for R-Car V3U, which has 8 instead of 2
> channels, the ECC error bitmask was extended to take into account the
> extra channels, but rcar_canfd_global_error() was not updated to act
> upon the extra bits.
>=20
> Replace the RCANFD_GERFL_EEF[01] macros by a new macro that takes the
> channel number, fixing R-Car V3U while simplifying the code.
>=20
> Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0
> SoC")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Compile-tested only.
>=20
> This patch conflicts with "[PATCH v3 6/6] can: rcar_canfd: Add
> has_gerfl_eef to struct rcar_canfd_hw_info"[1].  Sorry for that.

Ok. I will add dependency on 6/6 with this patch.

Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Cheers,
Biju

>=20
> [1]
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/rcar_canfd.c
> b/drivers/net/can/rcar/rcar_canfd.c
> index 710bd0e9c3c08c02..7cca9b7507cc6805 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -81,8 +81,7 @@ enum rcanfd_chip_id {
>=20
>  /* RSCFDnCFDGERFL / RSCFDnGERFL */
>  #define RCANFD_GERFL_EEF0_7		GENMASK(23, 16)
> -#define RCANFD_GERFL_EEF1		BIT(17)
> -#define RCANFD_GERFL_EEF0		BIT(16)
> +#define RCANFD_GERFL_EEF(ch)		BIT(16 + (ch))
>  #define RCANFD_GERFL_CMPOF		BIT(3)	/* CAN FD only */
>  #define RCANFD_GERFL_THLES		BIT(2)
>  #define RCANFD_GERFL_MES		BIT(1)
> @@ -90,7 +89,7 @@ enum rcanfd_chip_id {
>=20
>  #define RCANFD_GERFL_ERR(gpriv, x) \
>  	((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
> -			RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1) | \
> +			RCANFD_GERFL_EEF(0) | RCANFD_GERFL_EEF(1)) | \
>  		RCANFD_GERFL_MES | \
>  		((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
>=20
> @@ -936,12 +935,8 @@ static void rcar_canfd_global_error(struct
> net_device *ndev)
>  	u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
>=20
>  	gerfl =3D rcar_canfd_read(priv->base, RCANFD_GERFL);
> -	if ((gerfl & RCANFD_GERFL_EEF0) && (ch =3D=3D 0)) {
> -		netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> -		stats->tx_dropped++;
> -	}
> -	if ((gerfl & RCANFD_GERFL_EEF1) && (ch =3D=3D 1)) {
> -		netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> +	if (gerfl & RCANFD_GERFL_EEF(ch)) {
> +		netdev_dbg(ndev, "Ch%u: ECC Error flag\n", ch);
>  		stats->tx_dropped++;
>  	}
>  	if (gerfl & RCANFD_GERFL_MES) {


