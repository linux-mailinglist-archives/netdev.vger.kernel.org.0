Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936B34AE17A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353540AbiBHSvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353563AbiBHSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:51:23 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20126.outbound.protection.outlook.com [40.107.2.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4968C0612C1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:51:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPMxw91Qn3EuyGSL4s4bBnmpGFsvFLuh43ZHv+7bPImVPoLiqmGF2o1Ddy4gxIj5FeG/FDKQNDrsdQOy3p+7qY2WuCUd/aa61KRfZZZPWIQuQ/qliOzRdqPQXkBJi7u/UiAHh5IVqyZx8AWdCGCybDgX5CepNSNws8PgvnP527YioxDdfWix/+e2OHRQ5m3Z0oHO8bBLtzxnMy4UAKmAee3dPAA5ulU7sHiyYmU2px5lTqgRBp8WWJUNQSe9wtrMjWtfuyHJGYIJqpYoMQmNavEAEx/hYKlkNpolgsxdWLEFhZG+YJVWFC7ubkpIGJYTS//md9lLMrKLU65IEngI8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZm6p4k5YsYbS85nQrixmDW9u9U1Ju8vijxoUtVUGgE=;
 b=A+uBs/AOhsu3gR0cPYF0So0g139E8O/dgXAH/eUL2QGMM0MGm682ClwCiw0jXHr/r6PVWxeaJmixEtdtQ3u+htln+tsEPL7d8/uAI6wQ0Rm6uSj39+TzOvqB2zJ2fiqllMDapIwPChZ0EzU25zHfi1I9iz+PICDq4WyUHEQEdQEOC3rg9kxd6u2xSwQt2R4/aAIjpTlH0qVsXz8aZuMfY9DURQkBluAsaOIvj1+yhiANse2zkg9Pn2IIyhchBuAKGD6Sr0HYyaa5ACfyoL+2bXS/3yKLrNP13Ba6JGrFMLkKCnDMI6sy7vyHmpgr0pOpSsoBm7R09aOwM+vekV/c8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZm6p4k5YsYbS85nQrixmDW9u9U1Ju8vijxoUtVUGgE=;
 b=E6KmUUOhawjOUN8gzd2XhSYn489UY/SqusdSCBnkOZYj3KsEpRTIUrFmlpuOgnYwrPWuMF1eeRyNnRNxtl3hwV83epcjcf02BvE9MVdnnuH3Zv5usiWTdOrTilKukNz0x8EayHC/cDQVpP3SoM4SVk5jb+cXKDvvzBdakbwPT9AqURLpzl/HIjCvTACovN2lafH2EdxKRXnnsnN6zD+qS50dPbysURKi56R5AKk4Rj3BDGUIrlFrBw/CelxsgOzH1qpHYx3sa3GSMpzw7+M2XKMUGcxjCofW+WnjhRnPT782wts2wUCWP2av8iCDcWiMhCMiL8vUmJEChw1lLlLAAw==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by DB9PR06MB7659.eurprd06.prod.outlook.com (2603:10a6:10:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 18:51:20 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:51:20 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
Subject: RE: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHNCY2iBDkP/V5kmDjyhNSL6ySayJq1iAgABULuA=
Date:   Tue, 8 Feb 2022 18:51:20 +0000
Message-ID: <AM0PR0602MB3666FD73A000A3839C83E514F72D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
 <YgJ0kexWU4FROzNJ@lunn.ch>
In-Reply-To: <YgJ0kexWU4FROzNJ@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe238370-6ca9-4065-9c36-08d9eb33ff30
x-ms-traffictypediagnostic: DB9PR06MB7659:EE_
x-microsoft-antispam-prvs: <DB9PR06MB76593429100E6B416DE276F0F72D9@DB9PR06MB7659.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 22PKSqQEsoFLe0h/fBaFMvxGBpVKIE6JhOrv6CEGlXLzbYxzL31KmHU8btKa2r4lVKy9y98TXQl0v32MUm/28tP4vhBabrzLz+hO1xN7WRRBC6V3Oz84BVp6fEKoF/yZDbZm7mwlC1ihh90XZHq0D3nN3MZ+TmNEAmfSqzCwal8q6il3jG/ONHp3rxFx5WsXb7yu4nEfqAFYJhbdSerAU4NKxFZCnDsRUbgLIcIZdVegF2/b/MmNfpUL4g2giBY+Q9e/s1/0A0UvQBKfuZASKgg7ukAvLex0TYr8UpWuSA8I016nzBHD3JbYhq+i309MLoEenfNA9Zm1S0BSHQ9CMxc5IGYUxG+v3VBK4snbx/Ua5H0U7JLV0JSBa2gHwqei60heTDn6XLEBkySbGG4UDntyUHuHnfjYpAoYs8VLv+h1Zs3M0TpUeo2VIm72T0WoGtgnR+vnu0q+8P7tGvjT9H+B7JLKfW14B4ht3yXLlxKyH2G5XNDql+ivxqonN3M0Sfop+w4PqM8dK/8SD/hxL4mi0ig4C6IVMZWpru4shLvOl3823orQv6av94BeOp5v7zMVMyfgvMvbMbYePIW7fPl6JnTrUa9D2o0cOxj0CCk02iyRr+GXubotrj6g960Z91YTTj7txr1KUL9DXw1TWhgDHiIWgU9mQLq3hFn66oJgjlm6YNWaUNbGDP99I/FIjLR4nDgShut76cAWrpv7vA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(83380400001)(38100700002)(5660300002)(7696005)(6506007)(44832011)(9686003)(76116006)(66946007)(66446008)(8936002)(186003)(54906003)(2906002)(8676002)(52536014)(33656002)(26005)(71200400001)(508600001)(55016003)(38070700005)(82960400001)(6916009)(122000001)(86362001)(316002)(66476007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YAaWdsFid8x1hIXw+Ah+LiAYZFEt3HMF0Q1k/qzFbhpJFzS1IvmNn0UD2F?=
 =?iso-8859-1?Q?Cn/+mU9q3OFjCggCUW2FdVsP/d3TJJSJNcPF7XjLSlSHMgftnk6l+H+A7N?=
 =?iso-8859-1?Q?LjBg+q2oTP1xbErG0o/5BCIUiYLL8wWqglrcwSeA2tDE0ot+glMNfnSAwF?=
 =?iso-8859-1?Q?RqO7y1Ysrv+8LC8QWntJ7ExsArIJMVV+Qky9XXDdWn1mJQ4chHSan9QnF5?=
 =?iso-8859-1?Q?LkHJEjlp8co7vaQiIfTufnAh4b75/hznIs+naNIIOWDosFWyRXgf8udzlL?=
 =?iso-8859-1?Q?l6uRzBf0EUGDfXt4GegHg4mDMcUFW/lPT9cnKkFAQWHrgjnMrKgR4fQkFQ?=
 =?iso-8859-1?Q?5Q6/Qm0d4qqGBvwsxUaNYh1CUdjaN8OjwFBWGDThpFqouolxlO6DfW6Vwz?=
 =?iso-8859-1?Q?uqPBzMmzUShge2N3y2rKvK4amGt7opvs/vnhBA67nwe1IJdVD0AQU7PcA4?=
 =?iso-8859-1?Q?kWyZ8YnyzxaWI0V9L1LL7GVikq1fvX4jOGbog6qM5Z2Ln5l29baW0p0Ln+?=
 =?iso-8859-1?Q?5qQOrX0Axs7vwdXdxXqu9wUMf3Cmd3G1ATEl+KMRbh5oP60h3LLdx6/xEK?=
 =?iso-8859-1?Q?Kk0M9glKS/cqN5hyJBLp04Xuvyugk+WUn6MdjnatpbDHfYzbEQrkc931VG?=
 =?iso-8859-1?Q?GlTr4cdiTmvQHh85A/8z8Fm0ixA8wvtuMpDkvLlNziX6wOaGiZgty3kpW7?=
 =?iso-8859-1?Q?CXLj9hPoMnWgSSayvBrg8eJHYwz4a+5FKDf7ro/YVz9MCcBV+CUxkUwn+U?=
 =?iso-8859-1?Q?GP6uzYt2E8X+hdZVQChfhBKCyr17AHUs4dkvBR1rrsHUn0ayz2+z1Gp5is?=
 =?iso-8859-1?Q?gwdIVkFLtxhXg+lVh1B//dk2gxysjvwFP+H7VSADNCmjAUgDYrk1cJI2su?=
 =?iso-8859-1?Q?Gvi933MtBp1LaqejEdY1LzXi8ioEmYF4Z2pNqX1n3FHknhr6CpleM/jwwM?=
 =?iso-8859-1?Q?HkkfwMTbWTX340q/6IuUK17GukYy4daIxiyFnOwcAimKd/FgbzrO8v9e59?=
 =?iso-8859-1?Q?ylTQpSVpS411ogQ5wmEEz0hMGLieSCkBpWvexUa5VWyMUBKSk2g8UiJaRv?=
 =?iso-8859-1?Q?YsQbFEZGDaA6IQOmOhlE2XPSqMZl9WEeVBR3OtqHkflfCk6msM6Y21IztF?=
 =?iso-8859-1?Q?BVH2/LNI5gsQhRi7/yPNpkpciQdcONLxSaHv387Dq6hLO+85cOEGO4K4zF?=
 =?iso-8859-1?Q?1VO0u/tABVrPxAwYBIuxwNcH9qn+6cncs05NpwKKhJrJC2K8ZTXPKy0noD?=
 =?iso-8859-1?Q?vnlqCdq5Ap9L+ODTFqeJ42k23DUNGqowMWtfb0SC0uF5hxUKKY08uLMavT?=
 =?iso-8859-1?Q?NW02uSTJdR0ht3a+hJF7wmAeAzM6ADQdjWNqKZdFfI5zGkA8lvSiJVcqJc?=
 =?iso-8859-1?Q?s4qRYR1bnuGBstWv10BS1HxPBjSaGvi5Ux+EUpnCwz3IvriwKr6WORULg2?=
 =?iso-8859-1?Q?cF7WeOokwMG9UJ1ifaWqfe2iFCd37c/1eEUVdJHLYLSfPAHMmGey0M4hz1?=
 =?iso-8859-1?Q?Qfm3vxj5b0J3VPR18W481hHDiNy0yo+Ym242sr3p9eVejcktI4ZjgTfh2L?=
 =?iso-8859-1?Q?7VTEszguNqBMGPsfb65og5U1ci3g4v1U/PSGRN5Jw7Qy7SfdFlm8ykoBYt?=
 =?iso-8859-1?Q?ax2FspNwMJAnKoMJuBqQV5jVBFcXzpSIKfwVC7vStjX+t+nANVQvYCjVxG?=
 =?iso-8859-1?Q?7hxnGOdKuROEMvGKVL1b/6FjZMhJ3ZkzM7bcTnpuFjmFD77+Gh5qzsUHN9?=
 =?iso-8859-1?Q?XRPg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe238370-6ca9-4065-9c36-08d9eb33ff30
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 18:51:20.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bH9NfsFxQaRto8TBgRNNEBNNfxlxhZMq/Cu4B5wkcMzio4NN6qPIzbVWOcWxA9IrNlwyYDeDqHOII7H7OxBpd6zRVQXQlaXp+Dntijl6a8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> > +static struct mv88e6352_serdes_p2p_to_val
> > +mv88e6352_serdes_p2p_to_val[] =3D {
>=20
> Please add a const to this. It will make the memory usage a little smalle=
r and
> help protect from overwrite.
>

ok
=20
> > +     /* Mapping of configurable mikrovolt values to the register value=
 */
> > +     { 14000, 0},
> > +     { 112000, 1},
> > +     { 210000, 2},
> > +     { 308000, 3},
> > +     { 406000, 4},
> > +     { 504000, 5},
> > +     { 602000, 6},
> > +     { 700000, 7},
> > +};
> > +
> > +int mv88e6352_serdes_set_tx_p2p_amplitude(struct mv88e6xxx_chip *chip,
> int port,
> > +                                       int val) {
> > +     bool found =3D false;
> > +     u16 reg;
> > +     int err;
> > +     int i;
> > +
> > +     if (!mv88e6352_port_has_serdes(chip, port))
> > +             return -EOPNOTSUPP;
>=20
> Russell just reworked this call. Did you take that into account?
>=20

no I was not aware of this. Thanks for pointing out. I will base my
changes then on his patch series.

> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(mv88e6352_serdes_p2p_to_val); ++i) {
> > +             if (mv88e6352_serdes_p2p_to_val[i].mv =3D=3D val) {
> > +                     reg =3D mv88e6352_serdes_p2p_to_val[i].regval;
>=20
> i has the same value as mv88e6352_serdes_p2p_to_val[i].regval, so you can
> drop it and just use i.
>=20

ok

Best regards
Holger

