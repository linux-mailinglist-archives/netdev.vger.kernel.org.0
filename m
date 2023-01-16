Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF766BAE3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAPJvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjAPJvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:51:25 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7BB14EA9;
        Mon, 16 Jan 2023 01:51:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdm3tpIujVVM5kO2HMTwhErpQ4RrJgdfJnk6Gw45sAuq6j+sQweneW5d6jg412J9lbADiFq7JtVDEkY4LdHEu8ewmFYwXok7Kzec0VXjUkV0X5nlDwzjVfNxmR8Lgi3FXHIfxmInWR+lMorkysaYnSkGLdd4Ma3JTdlWAC2fs60zMzfbyqxF+NSCW8AtJ81lGGQFbglOLakpkubdTVkqkdlzcS7Rn10h2L4JX1DrZQfLKNul70xTpUzBj1ruijfnzLdEx5wdUwnPURmPTZh2vT5jQW78P4brHAk8+4fChQ+0BZSjP1Eko2pYejWPMJu8Zs+q4FKh+aNCrb7qfGuXvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WF7vHq+JNZvO1KX61Hd5kyz3AeW31WuPHDdiRoS3Kpo=;
 b=hKotgXJL/0NqrjRJzUPdTQ/4w3kLQc+YjG464fOeLTp3mURWZ+pIfDKqICUoA6rBo9IuukAgh71l++9FK8GNFq2ucxRmAImssHywCOeGTlZTxeBshsoT+rkbk5PbTqcyFEqnbc4vy+Nzn5KwK9WsoGoAyiFnRuMJGsUY5YankDhRE+GcT1DyPBo1cCFQFfee4Gs4Y3Plqguc3dd54pIQDiVTM+rsbtwREIQHBVUduib5fr5cwYyShnhhiSMQejq9C7En3zmubOhAMNhtqv0zA1lwkCbNEhGZjBNJPvd+p8RM+9O9ZsE3WLgQjoof57vktzjCazdHlGBK8zSFu+ufQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF7vHq+JNZvO1KX61Hd5kyz3AeW31WuPHDdiRoS3Kpo=;
 b=QDaTewEljB5b4CMPx0K1dhZ//mj+RF0kh/0b+3G5cztgl9NmFk5QYmS59w2jRkOXT4D9Gun71hds9v+pLt2KFBQC8yRUm/ZKZgC2rm5SxaMzZ7ajLwmt7v1/hMpUgUkuWyHPvjcFubmAhZPaQcFaqCNEgV6AGxLBe5p1St3NpLphsNG1p2tDn3yjU6EohGiddpx9hFw0oI0U2i7QvuxE2RYr3z9vbGZGR8Jo7awnit/Hs+31t5w+s6p/49pJ/3VJJ7wl8GaJTS53ST4QghU58+5mdfItnX1EXTtIrwCTwiyrJ2rqIapQx6tTZqox9oYrg+Fl4Vnx9VKVu1J1tdLRrw==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by PAWPR08MB9855.eurprd08.prod.outlook.com (2603:10a6:102:2ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 09:51:20 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 09:51:20 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Lars-Peter Clausen <lars@metafoo.de>, Andrew Lunn <andrew@lunn.ch>
CC:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66fthyAgABQ/YCAACCdgIAAKNoAgAB9T1k=
Date:   Mon, 16 Jan 2023 09:51:20 +0000
Message-ID: <AM6PR08MB4376669AFBED3CF8E75097D1FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch> <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
In-Reply-To: <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|PAWPR08MB9855:EE_
x-ms-office365-filtering-correlation-id: d157187e-c560-48e6-db7b-08daf7a73895
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ju+ISvRcswsea2x3DGMmH9eqo0NZLBdJSdbd6BrkwlFbq7OScHZ3xY1GNK4PP6ymyz9bQiuR2gDE2Ti4u9kO4U/B9xOAmDBSa1xp/4IPGkiyO3uvT4c3PazLPwYIJ9TmzHFuz90sfK1xGBxo8w8XjdZwgszNHsJmSLCexcQkuQVgfxInVWIi16OzFLj1zFF1vmUktKVutQQvXdK7Av6seGj9FbEHx/u4R2SLeE7qlSkrQxCR4ccH8ThBxhdrStq5fDqgeBdx1/6M/sXICpU/x02gRT19VQ1tY6aAL1/ITHiWs9TLOtvqIou9JkLY7AdwyN5Auzah/qEbXG6lZL/X+Lc4iGB2XmDfxhkc6tGZaaCUhuoJR2raQD01cY2pw2ihlLQEhzIVCPsa6hGGqUulr2Ut/3ofCdbvhkDQWI9ftobq2O0j/jQopy1+XNqsEkpNsb+4115VMupSYEkPA1USZOCSCNcukEVF0ZGJ6pLSaL9OtsqsR77dWcngnFWFohNxDStR8USj2ED3zMP05ZZW95+2yusigTkik8Lscl/6v/tZRy7qSVTXcueXyGH7bkwsbsH0CJ85VTmnJpQBeritpKcQ6veX2K+8PG1vSNfVvchVWpalG+9k31Ps0rhFoUcdt/Pbd1UnFipP5Wu98mU4tTWaA6SiW35oW8g+Ad2g1tNg1RLbo5NS8yPPs2qD6C47cwyN2kEJQzARYSsCxaVO3TYGl1qZuA0dVVehnwg+9jM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(136003)(396003)(376002)(346002)(451199015)(122000001)(38100700002)(54906003)(107886003)(110136005)(26005)(186003)(55016003)(7696005)(9686003)(86362001)(71200400001)(966005)(33656002)(478600001)(38070700005)(5660300002)(7416002)(4326008)(41300700001)(8936002)(52536014)(83380400001)(2906002)(316002)(53546011)(6506007)(91956017)(8676002)(76116006)(66946007)(66556008)(64756008)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UrUZ5WmSpTFNrt8FUNMMHSgF/yJwoVB43Skx/KeALeD+WYxXIMdLF3bA+L?=
 =?iso-8859-1?Q?a5F7ZwKRS0lOlpGvSWVqIbyA99ctsSb/kXuRxNcVU5Zy2AN9d9MK6LFiJf?=
 =?iso-8859-1?Q?VlmzuTzvQjgULsQzCwOmWXUhkXjrSagZrEtuBns9smt70aSAJaMVwZL/gn?=
 =?iso-8859-1?Q?tfO4/+7fdGQNiv1bBtr79HjZcc4FCSqD+RxYt4l0AYqu2GXwOV0WubKCMy?=
 =?iso-8859-1?Q?7GaOxbzK8fEyyIaz92olgVgmyf8ntLIIdyamG3MY3MoPAPwpgINrrmnV8r?=
 =?iso-8859-1?Q?UWU8TG9JBOIUMdog0ZGjJKTOXphQbbP4D73bdVk2MOG29tcPOV8r1JqdDf?=
 =?iso-8859-1?Q?65zRgWn+G1gBK9Zi8SO+vT3VCzqJzmufKDJ0n2nRkVr7lknFFbVlFtMym1?=
 =?iso-8859-1?Q?m/v4PiE74HvJxgF66y+20PbOy16ENXkZM/X6t5/6AYtq0/wGZ4mYxlE4Gg?=
 =?iso-8859-1?Q?mO/tYLEfkVpNRzakN3reqrFAgJ1dhLdNRSpBcVy9/2XMi0s+WHq6sj8HbF?=
 =?iso-8859-1?Q?7FmtXDoY2SbWxNNLhmpJw/itPTGSKuJeGpPwaVSjyqV4ExFMDHHkDuzM/G?=
 =?iso-8859-1?Q?aujFrS8ULZ3lgqfEZpksn70qKzFSepEHDfeW13mA/f3D+urs4mnwX+ULlS?=
 =?iso-8859-1?Q?otli3yzfxEGuKLGLCJ2O4pG3ttf5fn9xEGoX0c1ZATG7Xi4rapavC0aC1Y?=
 =?iso-8859-1?Q?IrgPR81Q3JtU3WUi5yGmkY1THcmWA/C2oTRvYdmGgd8Yjap4/nesKqmboA?=
 =?iso-8859-1?Q?RK6LNgHXIvDq07lNzIWDYmsdoN3/slGxDDXPCwdhR690atKb7MvhLQMR6P?=
 =?iso-8859-1?Q?h1pTTylePFgHAb3S4CmeabvS8yb7JA3HrrcXmHwy/dhMtTJ3bjbaL0H1I3?=
 =?iso-8859-1?Q?IRHaBuhOG8/tqJgVMLrs1Tb8H8qwtmPxuUWbqi4N/TNH9hwrp9VNzKR34s?=
 =?iso-8859-1?Q?o7ltFfwPQWpgfiFx8cnJSSEuRVG/3rN50mekMq4QvtgQGQJy+TMAN9SUwn?=
 =?iso-8859-1?Q?W3KyAbDIk83VxnoY1SYuvhqnkTGEL6zRCeWBoIUaql6sXSVKzY6KXpzJ/Z?=
 =?iso-8859-1?Q?ng84uhY9wODlz4CK0QWSSvM5ItThBD9PsYiguqdcZtCQu/XNpjfpkoGIRD?=
 =?iso-8859-1?Q?nFIfYi+wY3QJpaVaFtOuhm8ifdintoS3ngu1Ng7c21egRsQ8RYLdFqVAjH?=
 =?iso-8859-1?Q?j0sYqQFGWYx1xPnlonDY/mH9xa8smR4hFHoHowlLXgSwApSf/GZ7yrhbKi?=
 =?iso-8859-1?Q?0ImIQE3iD7HkCuZ5ajOcDXDr52X9KgOwmnFZ9qepslFxdpKlFEW/SnaZ1X?=
 =?iso-8859-1?Q?IjaR5+ASs0QMFvrvr4czyFsAGpU9M+uNHeOwRWzKwIA47TaXOJPVkXHLff?=
 =?iso-8859-1?Q?eSm0HPx0SXk7ArxtJvXM54Vnelpjny09Vdn1lVaGM7gK/is86vlg2oZC6i?=
 =?iso-8859-1?Q?aeJeCCf7SuSKvP69BJBtU5dwhDhWExWwnfiYkcbY39Gasmw4wlLTiA4JQq?=
 =?iso-8859-1?Q?w8v8Obie7l7ShOOu9NRelJy5nGJDho7IbOMlZpnrNfaBsw3LfPeJelQSPw?=
 =?iso-8859-1?Q?W3LqWyHWdzqyQRF31eDeseZCCuKAWSiqXpkwWk1O/n8HuGii04alcYbaq4?=
 =?iso-8859-1?Q?z7nQP5OSTUfY4a+60bciOafMSxpk6CKyVk?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d157187e-c560-48e6-db7b-08daf7a73895
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 09:51:20.6822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0sckEb6r6e/22m0kNZBjfBeegvq4DYFxa1qFje4XrSbteLdq/GWx5pGJuEuU4zdUzbQ4W4fQ3db7A93FLd87/tKkUR6KbULg3sYQjRQr420=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9855
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 3:41 AM Lars-Peter Clausen <lars@metafoo.de> wrote:=
=0A=
> On 1/15/23 15:55, Andrew Lunn wrote:=0A=
> >> Specifying the ID as part of the compatible string works for clause 22=
 PHYs,=0A=
> >> but for clause 45 PHYs it does not work. The code always wants to read=
 the=0A=
> >> ID from the PHY itself. But I do not understand things well enough to =
tell=0A=
> >> whether that's a fundamental restriction of C45 or just our implementa=
tion=0A=
> >> and the implementation can be changed to fix it.=0A=
> >>=0A=
> >> Do you have some thoughts on this?=0A=
> > Do you have more details about what goes wrong? Which PHY driver is=0A=
> > it? What compatibles do you put into DT for the PHY?=0A=
> >=0A=
> > To some extent, the ID is only used to find the driver. A C45 device=0A=
> > has a lot of ID register, and all of them are used by phy_bus_match()=
=0A=
> > to see if a driver matches. So you need to be careful which ID you=0A=
> > pick, it needs to match the driver.=0A=
> >=0A=
> > It is the driver which decides to use C22 or C45 to talk to the PHY.=0A=
> > However, we do have:=0A=
> >=0A=
> > static int phy_probe(struct device *dev)=0A=
> > {=0A=
> > ...=0A=
> > =A0 =A0 =A0 =A0 =A0else if (phydev->is_c45)=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D genphy_c45_pma_read_abilitie=
s(phydev);=0A=
> > =A0 =A0 =A0 =A0 =A0else=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D genphy_read_abilities(phydev=
);=0A=
> >=0A=
> > so it could be a C45 PHY probed using an ID does not have=0A=
> > phydev->is_c45 set, and so it looks in the wrong place for the=0A=
> > capabilities. Make sure you also have the compatible=0A=
> > "ethernet-phy-ieee802.3-c45" which i think should cause is_c45 to be=0A=
> > set.=0A=
> >=0A=
> > There is no fundamental restriction that i know of here, it probably=0A=
> > just needs somebody to debug it and find where it goes wrong.=0A=
> >=0A=
> > Ah!=0A=
> >=0A=
> > int fwnode_mdiobus_register_phy(struct mii_bus *bus,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct fwnode_handle *child, u32 addr)=0A=
> > {=0A=
> > ...=0A=
> > =A0 =A0 =A0 =A0 =A0rc =3D fwnode_property_match_string(child, "compatib=
le",=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"ethernet-phy-ieee802.3-c45");=0A=
> > =A0 =A0 =A0 =A0 =A0if (rc >=3D 0)=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_c45 =3D true;=0A=
> >=0A=
> > =A0 =A0 =A0 =A0 =A0if (is_c45 || fwnode_get_phy_id(child, &phy_id))=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy =3D get_phy_device(bus, addr, is=
_c45);=0A=
> > =A0 =A0 =A0 =A0 =A0else=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy =3D phy_device_create(bus, addr,=
 phy_id, 0, NULL);=0A=
> >=0A=
> >=0A=
> > So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set=
=0A=
> > true. The if (is_c45 || is then true, so it does not need to call=0A=
> > fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and=
=0A=
> > asks the PHY.=0A=
> >=0A=
> > Try this, totally untested:=0A=
> >=0A=
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_m=
dio.c=0A=
> > index b782c35c4ac1..13be23f8ac97 100644=0A=
> > --- a/drivers/net/mdio/fwnode_mdio.c=0A=
> > +++ b/drivers/net/mdio/fwnode_mdio.c=0A=
> > @@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *b=
us,=0A=
> > =A0 =A0 =A0 =A0 =A0if (rc >=3D 0)=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_c45 =3D true;=0A=
> > =A0=0A=
> > - =A0 =A0 =A0 if (is_c45 || fwnode_get_phy_id(child, &phy_id))=0A=
> > + =A0 =A0 =A0 if (fwnode_get_phy_id (child, &phy_id))=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy =3D get_phy_device(bus, addr, is=
_c45);=0A=
> > =A0 =A0 =A0 =A0 =A0else=0A=
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy =3D phy_device_create(bus, addr, phy_=
id, 0, NULL);=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy =3D phy_device_create(bus, addr, phy_=
id, is_c45, NULL);=0A=
> > =A0 =A0 =A0 =A0 =A0if (IS_ERR(phy)) {=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(phy);=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto clean_mii_ts;=0A=
> >=0A=
> I think part of the problem is that for C45 there are a few other fields=
=0A=
> that get populated by the ID detection, such as devices_in_package and=0A=
> mmds_present. Is this something we can do after running the PHY drivers=
=0A=
> probe function? Or is it too late at that point?=0A=
>=0A=
Unfortunately the above doesn't change the condition: this problem=0A=
is not C45 specific.=0A=
The call fwnode_get_phy_id just parses the device tree and always=0A=
passes.=0A=
This is a sample device tree=0A=
https://github.com/varigit/linux-imx/blob/5.15-2.0.x-imx_var01/arch/arm64/b=
oot/dts/freescale/imx8qm-var-spear.dtsi#L168-L219=
