Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802B24AF4B6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiBIPE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiBIPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:04:56 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3BC06157B
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bw38fI/tDI80rP9IAUKsallwac0K5HljYUU68x60cpacEfOBGnxgG3RuFErwvgfxWjRbTwzribVbZYg9lUJDsBrUWPKPaF2Q4hHLaGoJt4fj03Gj9XMagCia/nmugnZWOR8flcEkYWl4WeYKEOvky7Go4w71u8d/9NfnuhO+IzoC4JNkf5L22QkCgdPPv23PryAWHmH4aGagdzk0mBlqWJA5DOlkYe15aUsUCvjhk4ssgKWz9qiTzeJs4W2HxzTBN2iSPQVoss7kMWTvRkM6AkUJu/8adWyOuZCsOI4Tmyh3X46hUwakkl51ujxbrNfWIfX3IqifH0wcgMCPAHFbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6pyJzNgLaRG12PLTz+/Jfz0QxkaFjCoConphl72c8M=;
 b=PvVgdtJrvdrRRA2T2gmf2MWsZfukG9PfqLhgSEvzyI/g2kUTGFIMYwtoaYqAS/EjjxL4onuYynJIA+D/4zcgCr2U6HA3ddZUQPQvfBma9ufjmu1TaC+lvngUr8+lV0CAw+CfeeCRmgqAHT2F8ObYZ4Hx6U1BWW63c/LzDoxPtwxg5dyraAhV2Z64OvR15aWq+keAENCEpnmjwb0pN8a7WfEhfoeETINFFmitQIzwF4H2ZpYVZ85oAfToEbKq3b6lAfHMDKU/jTyRe6zyQ7qlCMFm8hZ7mzHRpj06AwkcTsoVWsKOr1MKWCoV5GYH12H/BcS+rcwV8z1+q764mRorfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6pyJzNgLaRG12PLTz+/Jfz0QxkaFjCoConphl72c8M=;
 b=HDeYxUPaJm+ZXNCTgk7CEZnD6tb+yjXq2dPl2xEsr8Pejv5JRYSEYKFjSA6NY8EDpSDUZR+jZtHYpmM9lvU5jlrvg7cV+ZQP/3KHoFb0j0XJUpb1ywjAGafA/pIZgnuTtKF/UHRdbedR6jd8GL+B4/MUooiHP68rUV4goR369Q65mRkKY6XbNuXLnEX6ip1MFzs8WVKasBYGqtB/YLqKaynNhHI5HimHilF6JIlWBAu4nh+fGffdI74SBuHNMIF5L2c9+/SRaN1spXe+RDa4JtIUaoS1nff2g9/2/zVnhrwfWgMremUNG+e4aVu0fAnX+27NFIEyQUUdNu1BoPD52g==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by HE1PR0602MB3257.eurprd06.prod.outlook.com (2603:10a6:7:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Wed, 9 Feb
 2022 15:04:56 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 15:04:56 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
Subject: RE: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHZsKZlC/aBDBdUimD8mOlShuu6yLORcAgAAW8hA=
Date:   Wed, 9 Feb 2022 15:04:56 +0000
Message-ID: <AM0PR0602MB366602FD4AB9AF518A6FBEBCF72E9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
 <YgPDjGDeg6sbUy+X@lunn.ch>
In-Reply-To: <YgPDjGDeg6sbUy+X@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50637ff2-773a-4091-a75f-08d9ebdd88ae
x-ms-traffictypediagnostic: HE1PR0602MB3257:EE_
x-microsoft-antispam-prvs: <HE1PR0602MB32572F2A98CAD5C048AA0872F72E9@HE1PR0602MB3257.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bWuA9DQBMSxcK6cPrUSeqAF5wiGEYV5M4ymrsEtO0lPrEgvD4eYFlT6W3zHjqbZBcc7U8wdIqG+q7liHZME+lETj4J6SdOkheod8VlYJkolbMtxWvCrb4vuGbldjWzkpKGeO21V/fPZL85BZAG1Vu211d0j2nO6+D54tep67tNBjdQxeaBgdenbbbnE1kTWoHcjJ9TDbcQiLykHyJfqEn43p74H1YPx9Gpp45MiuQF964OnWgwfVo/RKT3c5thUSJGmv1q0BCe52p3D2oI0i7UO19dmgEnUBOGSOKf3AS7n5jEFR+hIxyMOsyU/InVV9lw3GnoR+uwsp7Qlxi7/NDR+uXDwYvcoqaqC0BRpVM2ulRELIIiscRfkFX8aRV9sn/cJuLaohXqxJxnoESz903kBKZtRijuWIbZ2QS0XPU3EN+EjGBlqlVBzttAfptUFoYHrxtEG4OvXAlU61sO8/KL/KY6t4rzH4Kqog98tYq9RjfkVynyEKmsQ3hVNBV2VBwLaQxkbjGJbf+c4Nu+e5XfJwb38B5UnSh4MApTZn2VkTClmT+R5nmW7tQMf/72QuPE0Ksu4HorpKR57RpGpp+6ufw3n5cXaZpN9AZ4CgGnLcIBehrkzeY5Lg7+RCiKrfksqy/UxqXdG9SJu7OkCmGgZdknKzVHkMQ8+EQXFEfkFGWCuIwXLO6sHkpZddpG8ubIeYhkzgAq7ApKn7bSB8bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(8676002)(4326008)(66476007)(5660300002)(66556008)(66446008)(64756008)(66946007)(54906003)(76116006)(8936002)(52536014)(6916009)(86362001)(7696005)(6506007)(316002)(508600001)(9686003)(186003)(122000001)(38100700002)(82960400001)(38070700005)(4744005)(26005)(33656002)(2906002)(44832011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?K4LZBlt2aMtvvvk0PJeLcWBxdQCd6DhOXeHYkeUJU3MvPK7eIfoK8B7vo2?=
 =?iso-8859-1?Q?LD/EMk00wFsmjpSjJDA4d8JMABrZj1Z8Hh1VdQ6I7tkcjYx5yLcSpzFar+?=
 =?iso-8859-1?Q?enbFC8e15os65d4rZu/iBcGJTLVRhB/wp5hQvkrtgrKoez1TQbtDg0+IEX?=
 =?iso-8859-1?Q?LAzhPEU+0HSxGTO8NHGeLZNjgB0T3NDWcwJo9P2NG/Z23qMJEGG31TvxkS?=
 =?iso-8859-1?Q?+FQBZ+EO/bCO70HevONKoM3U2QPZlDXTBuAS17IwSPk69fBEGei8VMrrI8?=
 =?iso-8859-1?Q?NgMi3K9E8jjJr7qPv6XlFPtSKLulzzNrrhG2LMFuEiUr3ZjnSCiso/PPd/?=
 =?iso-8859-1?Q?asPxsh18hqkIc9AxDJxksfMYfwNMDM6xZbQQBLsC1krJIN4WFFRAPUHP1N?=
 =?iso-8859-1?Q?uhJBAV8ZqPNZa6WQxQJZV6OX6yidsyqhiRHRavoe+inq5nJ/ilOkQ3J3dM?=
 =?iso-8859-1?Q?NYMZt/OjQXETUP70beZBRhXyj1LCajO7YImZwqHvUh6e9mryYdX7q6gILv?=
 =?iso-8859-1?Q?+PsE4gxp/TwhfO+oYKja1w+HWBHPKSGTKGFSCRTa0wy7CUmGZUS8omFXdW?=
 =?iso-8859-1?Q?RY6BJRtQrV0rVkAYr6bM6WJtLhJ22rlMZ3e1g0khE/bKTamuOL2MaWEVx2?=
 =?iso-8859-1?Q?FSfU9K5YvmSY5evvtCQYHLrIEa2qX+Gf9hPz0edxCy4qFRrNqvxlcGTDK2?=
 =?iso-8859-1?Q?CelKt5VcMqHnginEMs8r5qXryU0KjoPcLBplY1UjTMahKRYky0dwtfXPsb?=
 =?iso-8859-1?Q?84Cqenok43rZBwbINbQXgzZKcB50kTGKxEEm67S5iBEFUKLBmR2+ZAVvJV?=
 =?iso-8859-1?Q?JPyhNuLpdSi3YgxgVvbCHUA9YRCS39LLxE2eGDfVjg10av/u4zuPYGRRee?=
 =?iso-8859-1?Q?6Rac5WIV4AIaW/PJHegDvsAQgj93V5rfG3YyRR/0wSSQPpAmY8HP8WGnVc?=
 =?iso-8859-1?Q?D6AE8amtuJetNbn+fjlsDYLPCLOo4eoSso4uWmkxO/ytXDwLFtmVjJs7Vn?=
 =?iso-8859-1?Q?nW3rsooAFEUyE85fH9FD453JMaeVZU52s13m4KSTuXqH5fnFY+tDjI461S?=
 =?iso-8859-1?Q?vAmTLNpqcFi+g3JXzUF3m7Q+Iq4EjEYwq0DQaGwrq113aKejMoJ+JGi0F9?=
 =?iso-8859-1?Q?kRFM9T/fiu11zAY0/hMD21dcMIywdwvRJ/B0tudhpLMUUy9l+3HhNYHl8H?=
 =?iso-8859-1?Q?ZYl4a1+wf1d1U0tBakzC+6ZinKJudVYFNEntWCWlBH3YTa79sMwznWIpsD?=
 =?iso-8859-1?Q?XNNUwSkcQsX6pfAR1vEMIc9xOiMqerU6XoGAovrx10q1bHYW9laz+JMJ14?=
 =?iso-8859-1?Q?2u9nftsPX3ZeNmrad32SBT6bgFu0W6SIFvxNhnevpZieesAr/CyPwcvVB/?=
 =?iso-8859-1?Q?rwpgvCjkpqciXn2QwhK5B4pXOfeblYF/FX+Qi9T7mHzxaSPOOow0haLU80?=
 =?iso-8859-1?Q?PrCU54a2x02P2ZC7Q7hsU9UMbUGus4D2zQ0zXrR0H4dKlPSsvK4SjuRHDi?=
 =?iso-8859-1?Q?G4mJAORfZqgUM1U6hP5m/+9kFGMWuPCBijWB+bQQXhv1tBYvAfA/ZJwZaw?=
 =?iso-8859-1?Q?3d3Vu4YnJ0RSAHkit+WE15KMvMswJkuVFlOKudgYGQfAtziRG3ultaKj3X?=
 =?iso-8859-1?Q?EdfDAHmWB8GUe8g3/fOjQcssM9fyE2XWbAyEy4qUnrK+5zmFvv8Gn1Me8i?=
 =?iso-8859-1?Q?JImPk/Yahvb9Amv54BdCe2veLEnkjAsD9EHvx/SIth05ojFzZjCsbN5KXR?=
 =?iso-8859-1?Q?SNCQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50637ff2-773a-4091-a75f-08d9ebdd88ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 15:04:56.2458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RY5x7pLx+HtNzE9ep4n9s9LuFN99zfHORxE2FoKfPzrJaAOczEn7iJrDHNoRxu2Km34kEfq/R63xXEntpGRTJdL88xu2KgnYCg3z4wbDR8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3257
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> > +             dp =3D dsa_to_port(ds, port);
> > +             if (dp)
> > +                     phy_handle =3D of_parse_phandle(dp->dn, "phy-hand=
le", 0);
> > +
> > +             if (phy_handle && !of_property_read_u32(phy_handle,
> > +                                                     "tx-p2p-microvolt=
",
> > +                                                     &tx_amp)) {
> > +                     err =3D mv88e6352_serdes_set_tx_p2p_amplitude(chi=
p, port,
> > +                                                                 tx_am=
p);
> > +                     if (err) {
> > +                             of_node_put(phy_handle);
> > +                             return err;
> > +                     }
>=20
> You could move this test
>=20
> > +             }
> > +             if (phy_handle)
> > +                     of_node_put(phy_handle);
>=20
> to here, since you need to put the phy_handle anyway.
>=20

ok. I think I will also rename the ...set_tx_p2p_amplitude to ...set_tx_p2p=
 to
shorten the function names. Makes it easier to read.

Best regards
Holger

