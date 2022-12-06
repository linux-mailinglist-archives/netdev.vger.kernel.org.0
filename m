Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B06644ED6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 23:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLFW6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 17:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLFW6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 17:58:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666273C6D7;
        Tue,  6 Dec 2022 14:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670367518; x=1701903518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ht/rZYuSS8f6RnDOvHrWqxob6Ym8r1N6Mor3H3UOvg=;
  b=0dUnD66PvdcnGbPGa6w6855je+aIpJpKUFvI9hGyPQ3JE0eQGg8v4RtM
   O4YQQiLMAS0lM3G5IYMpAFeNXauqluZubAASCaySeiJ/wRmoTMxQDtxlg
   csG2yhSv7CPmifUaai1Fa8wp64YIKsi1id2i1LMLv4HHym38QCnekhBqZ
   yxrj5mWfV6gWKJpo8q9H2oux5ym/J1rl5bMlYCLNHml4SJgpME0zaQLFn
   njZG5XOfheKRu1XUJL8UGAkcVDEPr3eiDyv1GO2u9e4aO22iD6i0C2FVV
   OzrEHOEemaxmJNA4zHrprwJ9BHGqnj2NBrL1glwFSmUcdfVwka4NG2PgM
   g==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="190367408"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 15:58:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 15:58:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 15:58:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVfEeMKJ+LC6akmdBScF6uAc/jjAy3BTe3hnsZGuTsu3o910vWBOBjvmpHQimse/x7jvJsP+CssnACc9YJuo2Gf0Nw9L69cCsRNmNX65kHhdcRPbI7ef8/VMyfZl0n4NCJWOtHDDgWxYTto6V/0tpjYeV7G2T9+z8h5tJ8vFjCWcn72p1fqBZYLvaTrRAgzM8BCb80ORyPdrxVKo4wOjMgJFy3xVozxf6gw2JDUVg8Wm0kx4GMxqig47CG49EEEXHgKp9f74MqCvZH2wEISKJ653aNd61h67PX0rhYuKfg0bXi4mhmegqcrattH2OL3SaZz+kTMzdAYq5/qFYqXWMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wybtnkuk3thH8W53vatx6LGEPZlZfPsYffnLv0ScWwM=;
 b=baE1zP61FEN9Y1ZwLcInNF6LGfma/ozv1TnJAtx+xtZeOgAR5grquWgubH0VtG1Qkkmi/ptQmm1u9c0alKes1YxYRqJPCZvuqG7JCLLc7gp/YthsbYBWmRNVFXErMA8Wb88xgnAWDnImeFEYGEsmnct2iKR2F1vG+nYo3zA0Z9NFRK9/En0NOhOuSVnW0sSTcQFrX6xDPkqwBBJdEPUcL9Hx6aQVDT+2n6tHb3rAOq4MAwlag2nLfkw6q6bKdTk1EXGQ48ftmEct4Iz19U1T0I/Uaezp35OCrc0zWsUhqDVxaCQaoXvpLqucIWb1P4eZ3RqJ6S17759TR2eLSI/ujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wybtnkuk3thH8W53vatx6LGEPZlZfPsYffnLv0ScWwM=;
 b=sn5CRNbq7q9eEzHpMD/59klqCacgSHLEa5WO8kfLh9qX7OsXH9IVkOMQ0hH67LUZ3ktwu6Zj8P4Vpw4vVzsp/D11fBwN+U5l6SAySMkaOKJVAnzD6ros9aX6ytiu/zygwfIxUAhdCy2JdY6DDU/JPgf36ANSHVciI6C1FZXZtnw=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 22:58:25 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 22:58:25 +0000
From:   <Jerry.Ray@microchip.com>
To:     <linux@armlinux.org.uk>, <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Thread-Topic: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Thread-Index: AQHZCaGINo+jcYxyBkCe7T6HFT6Y065hP+WKgAAadQCAAB4zwA==
Date:   Tue, 6 Dec 2022 22:58:25 +0000
Message-ID: <MWHPR11MB1693565E49EAB189C2084C58EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206193224.f3obnsjtphbxole4@skbuf>
 <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
In-Reply-To: <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|MW4PR11MB5800:EE_
x-ms-office365-filtering-correlation-id: 289ed66a-e3d1-4be4-7b43-08dad7dd61a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XDkJTQxALQ2tUb7jvhPvFIa/tmQJjq7cArhyvkb3fv8TGrbnnW5Vz8IV2+OJII5fyrydzV+wxy2DGm4ELJBaYP9IDLG+LNX9R73aaZrij3YBi/wPQ76/I46AmD0T3JoLNO4+E2ro0DFcCPlp6uCJAaS6kbG5w9kz4pYtGQsVvDUqxpmp1AHovgiKec6aUS0HCOrd1zLGVeFnL9t5cZeetKG2va3F8qn69ccrDyRHQQjCoWvQq7Qjh+rR9zgGJsn8aa02bazNsrRuQlKVWENDjtmU6T85H/wwCDfaOVsFKqOgBtD/sPuXmExKPHdZK9f2JPP9T/evxnhQ6t8Gcp0eI3OkIBfRt/GVpLAcbxac9AUrAJzK7U14eMWBZlunP3wUK4Wa5ciZao2q+dM3/eDbjul131V4m8mkNiZbeQCtdIl8RsheL4Xvxcs1DdQbWRBDhZJCrq3UAnd30fgPoxpMUjAB1FxVFfYJ7Z8q1O5gQszRQPa06KLAsTXSlJhjHReQtyrMSFqzd22Jo6LuByuUpg2uqB0M4PfawVp8RkSilYqYqQ6KuDLK85vkAKEkJbt2OtMS5lM56t7M+y28VyzJQ1A4ulEzvppYo8Vq+hVPLBjbTpPpRE/3Rlz7PKl8b/z5XQtUF+yjfyvO907fnxKVgST7sWQwpC+Lsv7o6U9aotPaQLDof0qVB/y7IdSTHpIzlrgaI1mwEtZjPrl53HYepw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199015)(26005)(186003)(9686003)(7696005)(6506007)(478600001)(4326008)(316002)(38100700002)(76116006)(54906003)(41300700001)(110136005)(8936002)(71200400001)(8676002)(2906002)(66556008)(66446008)(66476007)(66946007)(64756008)(122000001)(7416002)(33656002)(38070700005)(5660300002)(86362001)(52536014)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/exvHGzSrxT1+ro9cN9CQ8WTSH9b7Ji13sdluWekRnAf7IUw+TWGri87okTu?=
 =?us-ascii?Q?kxqqiyoCU6bCnuUbsKQ2UTYAfg4g6ibPT2bdJMosGSDH+eHY1+1Dc0BYhS76?=
 =?us-ascii?Q?gzU2aHzd0fSGuuuNzutKFxGDGisAvvgO5015FF805ncZ0t55YEALO6H/qaOE?=
 =?us-ascii?Q?JuQI/XYm2UNvO+8l8a/dDmZYaLTkOyL2Nbyl4yVLiMqj1yqv/QGUFTw1mT05?=
 =?us-ascii?Q?2U9knck2zXQLItE1ju5e6a4YPqpRIU/8/UcbnLICVzMlNzv7rEWutJM6wwnf?=
 =?us-ascii?Q?L2hR55Kwe+9QebqVCTUfKftbjzdJlEEIpFfmSny1tUraiC66Ex8/A/xN7XY1?=
 =?us-ascii?Q?ClhlWlbm0cdMnB+bXpjGGsUcmTA+vlushWpAkOwPpz9tRQqHpqJAVzh8KOL/?=
 =?us-ascii?Q?mbtlu0Jk76uinlA4PUIC9TP3srbTBr63qOJCH7eLSRbFbYv38INEKXLcEFQT?=
 =?us-ascii?Q?okCUa5fR7OdWAvppA/1OUL+GyFyDtEWfIQZIX0qCtWctksuLPGQaZitRarLm?=
 =?us-ascii?Q?h4Yd+z7vKFfxA2wFJ1pxko8gm/Coa4Xqa3KuKKxCi3uS2d3JdM0Zub+x7Q2X?=
 =?us-ascii?Q?dYC9bJbFVZTeke8fKDZn9FNWgzKejkGWCPzZmzczJq9DZsVgQ7kJoRat64iO?=
 =?us-ascii?Q?y8NoKnDxMGBNwCrlmMp4CFERKmRCdjbL6+D8qf+0e+gRZiQh+S2SwsN1Twxo?=
 =?us-ascii?Q?IJoXQ2Z3A7ERMfCag4uqevVatZwSr4PH8nLAhS2FpCOnIaa324h5DwdUZvou?=
 =?us-ascii?Q?5N5gWVV2PXx3bAXD1cKfOOl2GBd6anvZdDtE7vD+96q0wH9ymNM/lZnz91rv?=
 =?us-ascii?Q?HpQeneeIdkLEqlJyvOAVx7Qs9iph+HQ2MHTrt2NJHNKG6Pxp2i5JDvNb6m9m?=
 =?us-ascii?Q?e+q+Uh2+FxNmV6sVnnIRU/WUzsZ+B1K7ZrnRmd5veCzR0q41VqbPvmhAGU/e?=
 =?us-ascii?Q?BS32zVl+ujhbXOV/bK0ZsinAX1nKM0R0ZMdXa2T0+rZ1s57aEbkhlYKhwelh?=
 =?us-ascii?Q?vN74f05gRfZxHl05f2AFSCMazTcioN+uwpjimLnA+DnfLLm7t0p+I2lH8Emp?=
 =?us-ascii?Q?/ObCQkgpg1ES6j9SGrhx2BYUPUtA8DM98tPltaO+1iPZqtJ1P7t+JY0aO1Bm?=
 =?us-ascii?Q?dctWEv2hnond/XbXwle6qvpB6Pg3E2j0PRi8aG92XeI1oecqeWgwXwYqsLoU?=
 =?us-ascii?Q?eB0cA+fvh3+OdtvP8UB/m7Tg8WmE7Wo+pYvSSiJgTpEBZqN6obFjqN1Ljrt+?=
 =?us-ascii?Q?x9yuX8/NiNUpS2fI3N8XFCPpEhC4GSJhoPsJyAnEvEQ6V2gPH8WG9OEc9lrv?=
 =?us-ascii?Q?TFHPUE6VjQ4c0SYSmQa8U5dGJiTlu+mBzaQsJYEvSK+e0ET5YGuUo6yrNykr?=
 =?us-ascii?Q?DmramEyo/WuRfX87ErjY5Df4ZwICiFAg2Yka04uoFgcCuOcG65xFuhNzJ483?=
 =?us-ascii?Q?y7m+ndkhMP/7OT5R/QV2a+fPkxzciog6sTxZdx+FoZ+dSDUk56xGlPsZqg9t?=
 =?us-ascii?Q?nxw5lh3UCZzdrGQvrrcQnZHasRdNwIT4QVc+SNla53B9093JiJEF4xcxE1ko?=
 =?us-ascii?Q?P3mPY4viU0JUSyNK6lWMpL+Uu3jShpCgIH/JL7Jc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289ed66a-e3d1-4be4-7b43-08dad7dd61a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 22:58:25.2103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qbTXixxsbA55i286LQsftBuobFdm5LUemSI9sAlQHP1GGFgT3yXOB5rLQnRjZob5Tx21UYh6h/F0eGAvklqCDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5800
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > This patch replaces the .adjust_link api with the .phylink_get_caps a=
pi.
> >
> > Am I supposed to read this commit description and understand what the
> > change does?
> >
> > You can't "replace" adjust_link with phylink_get_caps, since they don't
> > do the same thing. The equivalent set of operations are roughly
> > phylink_mac_config and phylink_mac_link_up, probably just the latter in
> > your case.
> >
> > By deleting adjust_link and not replacing with any of the above, the
> > change is telling me that nothing from adjust_link was needed?
>=20
> ...
>=20
> > > -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> > > -                           struct phy_device *phydev)
> > > -{
> > > -   struct lan9303 *chip =3D ds->priv;
> > > -   int ctl;
> > > -
> > > -   if (!phy_is_pseudo_fixed_link(phydev))
> > > -           return;
>=20
> If this is a not a fixed link, adjust_link does nothing.
>=20
> > > -
> > > -   ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> > > -
> > > -   ctl &=3D ~BMCR_ANENABLE;
> > > -
> > > -   if (phydev->speed =3D=3D SPEED_100)
> > > -           ctl |=3D BMCR_SPEED100;
> > > -   else if (phydev->speed =3D=3D SPEED_10)
> > > -           ctl &=3D ~BMCR_SPEED100;
> > > -   else
> > > -           dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed=
);
> > > -
> > > -   if (phydev->duplex =3D=3D DUPLEX_FULL)
> > > -           ctl |=3D BMCR_FULLDPLX;
> > > -   else
> > > -           ctl &=3D ~BMCR_FULLDPLX;
> > > -
> > > -   lan9303_phy_write(ds, port, MII_BMCR, ctl);
> >
> > Are you going to explain why modifying this register is no longer neede=
d?
>=20
> ... otherwise it is a fixed link, so the PHY is configured for the fixed
> link setting - which I think would end up writing to the an emulation of
> the PHY, and would end up writing the same settings back to the PHY as
> the PHY was already configured.
>=20
> So, I don't think adjust_link does anything useful, and I think this is
> an entirely appropriate change.
>=20
>=20

I, too, thought I would need phylink_mac_config and phylink_mac_link_up to
completely migrate away from PHYLIB to PHYLINK.  But it seems as though the
phylink layer is now taking care of the speed / duplex / etc settings of th=
e
phy registers.  There is no DSA driver housecleaning needed at these other
phylink_ api hook functions.  At least, that's my current level of
understanding...
