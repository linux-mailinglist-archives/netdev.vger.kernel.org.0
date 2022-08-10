Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95F58EA12
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiHJJwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHJJwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:52:53 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B736CF5A;
        Wed, 10 Aug 2022 02:52:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2bQRhw4Jbuu/Wz7xWuqg9Ub5i8+tJQOFTJ5J+bK2R0ZvcpumcGZj4RoOzsFDKGculPGgpFC85UZy5dMQfQET9Eqc1kWmU1/4ycIyfzcjoyIRMqa+fIngV2tfqcjVGOLaXjUrQm3ZjTEV4yup9yfLxppMEhQrL4u0WhvinD/Axg9bzj/XWoBq4JqSxHKsim32A2f5ZwV/J3ERUnIc0ox15nGWu+ExGPd9e+Jaouv2EFrSgEsLQODdfaaPEJTMipyOhUVGRG4CsNWIrToAPzd4G+Ap2+O67JRoaiyJJf5vAIgTi8ra/53xOpDy2rC4jI7C0iHxD0kFHz6m0ucj5uJTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywmXBNb0bWdIWMObeGAId6n/+zwZ6RPzpOtdmgBYILY=;
 b=Wk2GNY9e+OunP8p8jEu0EEiy5Ip5QWdd9cP4M0cQ57zOAZV39j+3Fk9VKDztQ3c9Vs8Je+HshiIv2LD3zqmK73RiJy0+S5A52zygEVJzgOI/moP/Kh58xIKfx/NNN2Ylw/JY3lBrsDDgg8u03QCVR1TWfUiavOn0ZLbPCi6f/1CNZWv+Otru5/zMvuGc9OV4coPK4xEMFv2AaNE5g2MrnrvRUrn3jFcNNr1HMnMw2BwFYgHPhlD/TsBoCbFT6eagRb7A2DJpGmm4T/7nfyEbXAEI809Dho9Ag6lAtwX9P0J63ExghNyiZQwE2e96S90wb30w3JFnvlyGHwbcg4cCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywmXBNb0bWdIWMObeGAId6n/+zwZ6RPzpOtdmgBYILY=;
 b=IdIP3fxu1XYCG+wDMQT2xP5G6RHA2G6p5YXfdejeNaVYSCDgINzXlRud+rHLht9OLSc6FRyNd88nAL+XPRr6wNGP86EuDRtp4GdfG6lu3UVXPoMtC6IlANllrN1tOLffoiGZ4GiOJ2x0J/cd+hACXxAWpvPcTrJCsrK2pjLvDLo=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4868.eurprd04.prod.outlook.com (2603:10a6:208:c7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Wed, 10 Aug
 2022 09:52:49 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::3906:f3db:ac86:bf5]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::3906:f3db:ac86:bf5%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 09:52:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [RFC PATCH v3 net-next 10/10] net: dsa: make phylink-related OF
 properties mandatory on DSA and CPU ports
Thread-Topic: [RFC PATCH v3 net-next 10/10] net: dsa: make phylink-related OF
 properties mandatory on DSA and CPU ports
Thread-Index: AQHYqZ54b8s+4570x0K5qjk4GR3fPa2mP7aAgAGq8QA=
Date:   Wed, 10 Aug 2022 09:52:49 +0000
Message-ID: <20220810095248.bc7vwdsjt72k3c47@skbuf>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-11-vladimir.oltean@nxp.com> <87h72lx1ro.fsf@kurt>
In-Reply-To: <87h72lx1ro.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8df56ad4-cb59-4521-d087-08da7ab615aa
x-ms-traffictypediagnostic: AM0PR04MB4868:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4yYnNCG8HQs2dzaODsZ4tLYbTRaXk4vxLRNI6GKS5DIZ78QvT8WE06GfGyIboQv+UYW8rT0dMrqV8yCDZbB2zIz47PPu0L8fDK01QiyE/M6uJdn2n1ZZv2zM8A8G1aRVfRVk1sfdTp34JOazfpAvozGw9CWIn6cjB6c8ih+URTAxkNGFh1Gefmg2PsE6jfDwjJsaqlzfovdnNw7MMdqha3hmiSobBswSgigEtBFF3tLMnpIL8hOrIUf5H4PLI7bJf5mfUTc/LcplMPiFKtrDejHIqZbyWfkXpexPmSW7YHpvwBl7KmW0KVdvxRkYNU52wBxF7e+4/ngGsw0j22vfvNQAyTNwvBcrfmt2nIFSKsnx7RdqX2TKUGt5LSsmuHBF4FOYkuW1VYiA703UI5L+hjDaSdVcUXjl0pmn3WKvLOrVaOAGGXifaL55KfspYe5d94zXquOaJNNgKdlPMw6j8paS0ChasAoB4ypV5MdUNgm8A+Uccb62GsyWk+80dZdQ3LGtlNQvWY4OE5GpNaHYV+MoWNVbG34jQ6NL8g/WD8SCgmmwjf0Ww/xC9I7d3lgEzwnzeGHogZvJFLb/ARuDYrzheS8oTHkNWYPIHZ4CcNTnhyc0gtqbx/JrZ46InfDaENkJeVvOKXU6RsWiMcbiuNwA6DuAlzJ5wvZi93hcJmMMO5MCRosD9qPLjYiFQ70in6Pnp6kACkhK3F1Xr7ZaW1yFX1yfP2YPn7iQUvi8320YjqOmyev/NKjZnWDwZ88rCAHp4A0omdt4tw7KehKFcCX5VKp3jjHfY8VKNBpZqPk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(396003)(136003)(39860400002)(366004)(8676002)(76116006)(33716001)(4326008)(66446008)(64756008)(4744005)(66946007)(7416002)(66556008)(7406005)(66476007)(91956017)(2906002)(71200400001)(6486002)(6916009)(478600001)(316002)(54906003)(44832011)(38100700002)(38070700005)(122000001)(6512007)(41300700001)(6506007)(9686003)(86362001)(26005)(8936002)(5660300002)(1076003)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?A34hJW1p8snA0WBbQWwDSOsNIL5GhLjEsqLYuNp+1ytOF9err5DjebA9?=
 =?Windows-1252?Q?0dF0Dm2HwVXKwW8ySTzUxbSf5Y7Tp8DV02ztz2ps2T3AoZf6ddA8RGbj?=
 =?Windows-1252?Q?xuXArcZTkR/yuJnrlkH7kRMUdySBS+yqz6fvxCoZZu16Vu1yCSA+lkvA?=
 =?Windows-1252?Q?HmK/hyNtceJnKi9PwoqELlNo4yik2RBVjyDMBkvWdlCIG8iAAdBx7K0l?=
 =?Windows-1252?Q?P0j/LZeRRQRJdgqRfxd5unI4zDLMecG29RIC6imPGWs45VKVjsJivKfI?=
 =?Windows-1252?Q?Ikx1nyJrvqUIYIoNvep1Vzv5+DtMlZeVxOrgfabusWWjakRHIYxuWRbD?=
 =?Windows-1252?Q?KVLvoRPz1WgnkS1BtIVO8brez/0+YpWb7VkTf8Q3Fo0l6QvyUbKmdB3f?=
 =?Windows-1252?Q?XNbm4UrdUVNUsXF59MoUF5ulrLVBoxAFYP1TmH9w3k9VZ5mu22jpgDsi?=
 =?Windows-1252?Q?aK1CU58zoVfwUCpMJQgWtmeGedoRAH8B0YL/HUT3ac0DuZTHQq90Bjea?=
 =?Windows-1252?Q?/BZVTDgUdOciOkofTY2CIl6zHqkKIRh4DxNFmOMe2MpI3UaaC3XGOo/7?=
 =?Windows-1252?Q?G9TCNtWM9E0syRfB7MUKG4mdNC1TzHJdHWuH46MIGI88+QSDOlEdo5z0?=
 =?Windows-1252?Q?lmTSvCHCOeiDzaiwk/seRYdnKBg8Gd/9ECVLgVOrboP/1p7OsLBQApAA?=
 =?Windows-1252?Q?QKBWZthYyVl+GEPMMjUSgkUBHJGygXxceGzaPZZEa9Nqj8kEQSnOEyhT?=
 =?Windows-1252?Q?K4XkplydN7T23qO8Y25+7Ih7FMzoklyzv05SuwHcGkwBy5nN/GjUMPbX?=
 =?Windows-1252?Q?auTkF4P5kEWVgIrURrVX4oNxzunOCxGyLkktlWbRAHzp0YJ1ztht7Uj/?=
 =?Windows-1252?Q?d0OtAGaYXdsAB4eUH/IAllicGCA8+4e6/pXnjGEoJJAI/yLO7Qpnbx9R?=
 =?Windows-1252?Q?/PpqdAY084GUT+R2+VjqzNE+55SzyM2SCjHVD7kQ/VNGwkEOV+3/GBfA?=
 =?Windows-1252?Q?/ixmHfMrgk9FT+80/v+uXM1WLfQGDQqofbqTIphGSQDXjNhaJQGNdM4G?=
 =?Windows-1252?Q?vN6cPuOXvfpmdQkODqJ6WG0v3ldaY2QT5HY8tVEmGlHzuA+jDcLdrXSx?=
 =?Windows-1252?Q?Hc89MokGPjL4rDkrymcCiVNh2VJkN+K0v8HGvmBLrmZA3sjGfPGYXuv+?=
 =?Windows-1252?Q?7zJcJlGHGVkHeerxg3H/IoO9h9E0nfsU7dhSK2eQj47HQCYvRP1KfNa7?=
 =?Windows-1252?Q?N47BgkHu3AafPgpI2ppU7oapbuqfXWDFIoWHtq/wsdMpnFECiUMdJkLq?=
 =?Windows-1252?Q?ZupBkWj9PaVWtw3gbaRZt/Vp7rUAkjf0TlHVkAlOrk+/n61g3U8oNPSE?=
 =?Windows-1252?Q?gXj+nBfuVt/rC7TFmLe9ALYj8bBdCNfhrnGIq9iD0NRPYPOLzAMYhfcM?=
 =?Windows-1252?Q?FipxdDmHAe4ZfTDWoWzzYHLNdrQTIzvTk+Hq9LtHFTtK/JAJrDxiIKxs?=
 =?Windows-1252?Q?xanu43IejMLLEKsj2y6KapaTjApqr0luN2MicT8AGtlOc6bpBTZ008BF?=
 =?Windows-1252?Q?EnwCCrTHutF/dx642AkjmH+RdhxFocgOCugWbvCG509d+XRtM803kJ6W?=
 =?Windows-1252?Q?f7lgUeLa1Ndy3N70fN0Kr+9nFI27SRvd008om7BOM+h5IDRWVBYKZl8B?=
 =?Windows-1252?Q?sunFBcDTmiM4H4pMaoG8rB/MIZIDZyY3DnLWAdXnlyZwMf/IWRUfxA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <2264FE2EB14D4243B51D6728C3ECE17B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df56ad4-cb59-4521-d087-08da7ab615aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 09:52:49.2030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U05Z3MAKytLA3BLTSfiHCE1WraI1xnIlpneIvCFoEgs4Wa5rGtNroZB37W0jyOVcdTTkb6ATiJ8ZwocudrAjfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4868
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 10:24:43AM +0200, Kurt Kanzenbach wrote:
> On Sat Aug 06 2022, Vladimir Oltean wrote:
> [...]
> > +static const char * const dsa_switches_dont_enforce_validation[] =3D {
> > +#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
> > +	"hirschmann,hellcreek-de1soc-r1",
> > +#endif
>=20
> You can safely remove that one. I've updated all downstream DTS files acc=
ordingly.

Nice, thanks. I've removed hellcreek from the list of drivers relying on
workarounds, and probing will now fail if properties required by phylink
are found to be missing.=
