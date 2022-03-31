Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB014EDDA3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbiCaPoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiCaPnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:43:07 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CF0223238;
        Thu, 31 Mar 2022 08:37:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgks6YmlwhIqw3wFXXW68eg+JjER0957SzWbFjfj7h1I+eJXo/J5s40pyKy6Xw5x1A21XC8HZteOEFM7uAk9MRgm8cDQYlkk7j/1ZSizNJQkUDLHM3If8kkYzOBsOMxZbblOX17UETWFUNBIEGNetWhTNWKNzTuN7NeVhG2C7H+JImkxuqltVSLfAl4e3A84Ror4EtGwQuVZcosJrl6b1wzlKJDMVBhcUX/xOA4gIkFGzSWgCmS+8Q/pAedh6yoev/NoNx0aMz0Iw63oRMkzt00vx/dGiN2qeI4kbaLnGrPMfp1fRNESNc4NCpG7meYyyRsDEPNwvA3ucHBKqRSPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lyDuyVoAvf+/86SexwFAd2vOBHEwWq9HonE+mAwlro=;
 b=gmQ88W7wiQkA1dc7zhn3XuPS8XUhNpXMIwASH3l1dx5rY31yZ3eARJDdSVA5zIDlC0OUm2DvpiHDjfr7Ralie569ohIAmmCpzb6THkWJiocqmSziQ0Tf3sw11oKGMHokaGsm2YK+ZLa0nYeH6tYnTalCYYlQiwNLJA2ltrc+/2noDOXD32cFJBi0go+kDgNxL3JxKrN++Tkdy33lN+C3VtDuPQLu/VSZSj7Fl1cPr47ry8b68EL888Gf/kNk9J/RJPXcloPkDO9Yf6L5yEjZq7n52XBtCMTr1942srHJ1A9C8a8LTQAna3fiEQUgi3o7/9WzU5kXGSw75kp5EUow9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lyDuyVoAvf+/86SexwFAd2vOBHEwWq9HonE+mAwlro=;
 b=E5IAcFthd3jw44axYoVBOrjPpZoaLCqJhhdeL3w+5lcXo+i9Tax9ac9EVZcPhmNSEZHP6rKDBnuWIm4aMFensmgWen68WF2/O0ncx+0nu7MZmQhnSUXAqHR67ZUAERJ18CC5Ga7sbBKT4XRvtnCkOGnrLa5nWqFTDmUCgHHB5Xc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3746.eurprd04.prod.outlook.com (2603:10a6:208:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Thu, 31 Mar
 2022 15:37:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e%3]) with mapi id 15.20.5102.022; Thu, 31 Mar 2022
 15:37:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] arm64: dts: ls1028a: sl28: use ocelot-8021q tagging by
 default
Thread-Topic: [PATCH] arm64: dts: ls1028a: sl28: use ocelot-8021q tagging by
 default
Thread-Index: AQHYRCoAL8rMZDh2bU+SVqWLbFGm0azZojgA
Date:   Thu, 31 Mar 2022 15:37:49 +0000
Message-ID: <20220331153748.pkzqops4h2orgpu2@skbuf>
References: <20220330113329.3402438-1-michael@walle.cc>
In-Reply-To: <20220330113329.3402438-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 478e8efb-a3e7-4443-9cf8-08da132c693f
x-ms-traffictypediagnostic: AM0PR0402MB3746:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB37467AC82DCBF3FE63D28150E0E19@AM0PR0402MB3746.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 67WVb0C5YMQMYw8jvELTe69sQxo9jjmCRQ6ag/m0UFJMDzyOwg76l9zCkyuX7u6jBdLB2y2Yfmk4vdkqWKFk3PCNiKAXHfVpsQj4Dk8p5pyRhkzhwCOdNYoCmOaBIFlR+BTEqPnUoldbXm/rYd45ewPsvsKa7Epa5urNbIIrOldl3XqwBKY12gO6VWj6L/bx67cPMbFmMNUz6nBQ2UEZU/cEQYP2sE58tLOHKYveBocI9nQdKa4GnRlXhuYjqG4zFgtVlRtN8ugD0tU0ahVV0fSTEQh0DB/gpUPE56LPNQjRQTdmbi0Ej7cPDhKWdmybAoHkP5aK4YoN800Xq+FsgjzGYD9mpKXBEIrqtGX5mZi+XRkihNZA2GgHgy025Kv2mVB01BlnqdBetRIeoYMEWHj7pZLEUwW4hQ55gvMLaF4gg88zMZPjm9FA7B+f2m6p3MV2Ok71RJQO6prKVhr70ZqcaySAJ+r6Qiw0oushzt9FWGKJZQ9czH0Mjfve1e4idpFilTEmW2MkjFL/ynaiMV4cDNu+37xxWrRhnXEBBffAksiUiDtNImi0v6LNkFgZwR9K8NOGf3ERXmqYFdQj0xLX9R/K/1b9ofAE6bAprtv4+MCfAjjRkJS+u9JhW3fFjwEiePHsXewaO9KmFAVnO0V0KEBbJ8eC8q5Ck9rT7d1q9fKLSfplhbdOea0gNeQ7Bx+X+yCHT6ZBs/VXjCKvew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(66946007)(76116006)(8676002)(66446008)(66476007)(66556008)(2906002)(122000001)(64756008)(508600001)(6512007)(9686003)(6486002)(71200400001)(4326008)(33716001)(6916009)(54906003)(186003)(1076003)(26005)(38100700002)(8936002)(38070700005)(86362001)(316002)(5660300002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bDMeOwUa8uKVGNCLiXiesA2NOV/TBWb+nKQ3DBGksKvzUa4bodl20NEv/+bu?=
 =?us-ascii?Q?guIQNBvZaSJWtRSifsmkTF0tB+bYI+8XpAqqQUAQsdZfvQb3GVZRZlY/G93w?=
 =?us-ascii?Q?hVVeYAyOvWnQmWXcBhs4oG4f3sULorvKE9UjnVzHGIz0dQpBXicNswrAWjLR?=
 =?us-ascii?Q?SKWXATpIWCrhjsEWpRBR5dMGxuDEUxHJ0vrNZs8wY/gBDNZPd0/yBhDai4q9?=
 =?us-ascii?Q?4HlBZXKNW7PAmoigJ67i7WeXPCxzZygoc+PPG+fqKrmjzYeIioj6beAnqPM1?=
 =?us-ascii?Q?QwFWg2ykws3UBN2xsP+hZ/UgKDMZKWb/4tkAiU75TPUU9mef3GqJN+sfNsSj?=
 =?us-ascii?Q?XMX3/tDWbeDgHkVAkBY2KH313PtIIW4ruYHvKAtbNwzKqlXI5cornv01sDQN?=
 =?us-ascii?Q?KdnS3GpvHDIYD8GAl9TeVmcXaJFxHxXOyjgY5Z6e3T6TgnaUjXbVNMIJk92H?=
 =?us-ascii?Q?kQJ2XPU/SDeD0eMUASM238RjXM7XJfZOoHnK6enAluQ234AfIuwdr1ss47Fm?=
 =?us-ascii?Q?+dSbb/7roZ4YdjvWtaDp+TD86FLjCmBsOt3k83YkZHEfp+f2eOYuGP43P7vi?=
 =?us-ascii?Q?Hyy+WRdubxMOJKz2qzFOwEPod98lXqmMDkwP0RHT74I2BW64EsRMd8hWVSYb?=
 =?us-ascii?Q?Q5Dwb72cwCWtufUrhenS4lPqfBPFHW6eJO8AiveZzI3mTSdPurooTlLqCLmS?=
 =?us-ascii?Q?ZlfNLi43l9+RR1pqN+o1gnF6hRFBg0PSqGCO2BwHiaF/TKCwUX/BJyZgeDT6?=
 =?us-ascii?Q?hiIdxi16XtbpqXvZ0PNrdOXBkDxHTtznigPtYlh0ATH/wowNQiseXrJFpmwd?=
 =?us-ascii?Q?gbEKA3zoWvtDz2DGIrEss/6K44bqtev+AoYleSeqNPAcTFjjGpaCn48HtK6J?=
 =?us-ascii?Q?z/VkUxhFMjSDzbmhCukfovEHPNbdwFu0eEXAe1UHr5gcehJtlQpoCpZLRUHU?=
 =?us-ascii?Q?EEAWHHV17ZrgFl1Io7ECJtlVq7l6+weS4/A7IDxzv2m81M9xvlL3RUv9rGmd?=
 =?us-ascii?Q?3B+cmDTL6FZrG+f8DUfs1NUJiUheysP0GA+wnQM254JXe9LhrxaJM5nTwOkp?=
 =?us-ascii?Q?6SE/iPcwuuSjKDDAKIn91VwaxjBiBTXe4yQuONyZ9sYFMCXl3Q1940fc3y9R?=
 =?us-ascii?Q?0RviK8J8Ix7ARYKEzUHUsAoy6wf7qFu+Ghu5fQzVIVHZRyIXY8C+4Oc1lwe9?=
 =?us-ascii?Q?0qmssHFnYB8IWcvH9dvKg+qNyZtWZ/1x4cZCg6dJD6QmThnB+FtCQhbiawSm?=
 =?us-ascii?Q?TcO7f/dW7ffeyqaQCuIOuHqLdQTFVaS8NOg/Mo5rKrfNtpGAW5NcYEwGn7lR?=
 =?us-ascii?Q?AlPawHmGQkfn1CQoai51kzKUnLFBTfwUoFTi4p0l2DAV4jRQK7VjMlbs8eGB?=
 =?us-ascii?Q?z4hinZWG3efCaDpSjVSP1FT9xTI5a91n73Ga5DQezlb03YdfLerd4W/UVYvT?=
 =?us-ascii?Q?oGA/dniwLQZ+NUM/b+mQMroSpHb6S/hbBPvnlm9VdrP3QEK4ln7LjTV+fc+J?=
 =?us-ascii?Q?M5ql6Bdzobu904+QgCaR7daPD581/J3s0mfBUBRkqr2JjGzqsKmrEDtbEGK9?=
 =?us-ascii?Q?13f28/TjQHR09zzGL8uvUTHkIiH/6WqUUugYMajnTwd6sGExyeE/bGEPmnYD?=
 =?us-ascii?Q?dZ09dipwqxVGa42xP9W2vGxs6T8oy4DUTPa5BVd5oTulvAvkzO4UUKJuqUVz?=
 =?us-ascii?Q?NMBtswPKrNUoKMWLF2Oti87K9G46P/+ZeUbA768wWufmcfRtkAnvOWHFo0BS?=
 =?us-ascii?Q?1wXW+XZVBshk+jOEkuoY8XEThTQK7sw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <476A80644D170B4C88D34C855D84F80B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478e8efb-a3e7-4443-9cf8-08da132c693f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 15:37:49.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMrBu5h0x6o4alTKqXMOeSGcSacW7FmOx37EfyOJhBbToSO0sN8F9W+SkCGWh4QHrLKyF23VPnsr4UeeC5AURw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 01:33:29PM +0200, Michael Walle wrote:
> Enable the ocelot-8021q tagger by default which supports ethernet flow
> control.
>=20
> The new default is set in the common board dtsi. The actual switch
> node is enabled on a per board variant basis. Because of this we
> set the new tagger default for both internal ports and a particular
> variant is free to choose among the two port.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  .../arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts b=
/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
> index 7ef47b80e343..68d11a9c67f3 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
> @@ -328,6 +328,14 @@ &lpuart1 {
>  	status =3D "okay";
>  };
> =20
> +&mscc_felix_port4 {
> +	dsa-tag-protocol =3D "ocelot-8021q";
> +};
> +
> +&mscc_felix_port5 {
> +	dsa-tag-protocol =3D "ocelot-8021q";
> +};
> +
>  &usb0 {
>  	status =3D "okay";
>  };
> --=20
> 2.30.2
>=
