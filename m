Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3044AE16B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385492AbiBHStM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbiBHStL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:49:11 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60123.outbound.protection.outlook.com [40.107.6.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57EDC0612C3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:49:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXF8HmkXUqfJzXkuKE6VSGE5Qt4TQLyIgJE3Kiq41OntF/kG0+CrpEQqKGgllfACdZCDho5rfgcb91NGt7wsgYJ3b+LU2MZQZgst3ehumzimvt32QzgsDh8frNlZn+wM3kAr/mZoV6puSrXjJPIK5L+bkVXuoOKtElgKVxORCRdAzPIUoQVnBB4XU3lFgHR7cSZUsARM7jK1gM1fqvjAq297h1rND5FWbK1k57SzvC3AXK18bJxq14ujmBrGVXw3t9MXZs1CcXR2JOGg64FWedaw8QPe1ZdcFl9jhRqBiiwu/GRKRJn4HrK58WwWGqm1xAIiBS8ksFZz9bH6muYBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBm4D1Is+gRnRz7yNlfdkmUsZ1joICSwWKriAp7g1Js=;
 b=ZGAfq0QnpR8gQwenjl4El4hksbI0TyASqnEwE+DCliS/9uLIUtO6Q40UO48hNwIozquTEtkyDjvUKGfYuqHyIWeGuiwOI1lVN74a3jBeuMwLRrgXe8v9EFB5FcOT7zj42BEioLrGKcnTY6thDdljadrAl1z2oqxmBJ9/rLiZYp3ZJgNzfefQLxqwTdAJ8smkLFeQMa8skXKnqMfsFENjpy8lw8bPjy5IjVjJktn4JLQtMWyKTUu++z0NXCAdY4AMc8q21/0WznvT7APPrwfFaCc4yAor6SItcvAmdME/9a5PP1xg2sI8VrfoJUquqDd7XdbDPStT6J66EQObIze2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBm4D1Is+gRnRz7yNlfdkmUsZ1joICSwWKriAp7g1Js=;
 b=XDwXEbHDd0JfgNyraQuB0MfG7S9yg4py4Y+P0Ui25NUJIktqAUQ0EoMpxCIXkx5BE6Z03V2UR40SxFy7HNnrCjkLXcdYn1EKde+6C/PiSVHir+aT937imddZrMXEnws4COaloGI/arNsvGVp/wQDhueYjWhwNkFbjW37+II/hG0IgRiMJOe0/1YdFt2wZknbayxMJ98A0y9pivKhLC9KYDEoBMk2jvbHJslpfL9KKfCWe/K6/jy98NmKhl5TTFfXngxafGKobispEyzpwnWdTMyuSPKkmkHghU1ylaFqC4YhmYlQxfJyhV+mrjH9YP15d5NCctTmr5VUI2dYHHGadg==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by DB9PR06MB7659.eurprd06.prod.outlook.com (2603:10a6:10:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 18:49:07 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:49:07 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHNCY2iBDkP/V5kmDjyhNSL6ySayJ0XwAgAAtW8A=
Date:   Tue, 8 Feb 2022 18:49:07 +0000
Message-ID: <AM0PR0602MB36665CE967134A8C8D999078F72D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
 <20220208170432.6578540b@thinkpad>
In-Reply-To: <20220208170432.6578540b@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e220e364-bd31-4071-9bbd-08d9eb33b008
x-ms-traffictypediagnostic: DB9PR06MB7659:EE_
x-microsoft-antispam-prvs: <DB9PR06MB7659E06D38B75A52CCA3143BF72D9@DB9PR06MB7659.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BCJjd5pLPgf1dFguk9UOdgfk0jWXy8nfIpbOCm/pg0mYTDDO43OcFwmDLDmYdLDQZEGv26OHbvhv7fBFXrO4LMJmX74cG73lfPUX/Um/tHsW6vFOWOcJsbzrbJ4fetrI8oi1eZWVXzt1q2aCSePbFKu5fuOjYt31wZ4WVKafCXi3r62kTjUH5PXmCmleTnQdf8oE63S/kgabjVrPAT4HcAkiXri77cDOzrxX2RTYua4wvmC9EeIXXSifP5q907FyWMWRZuLp8EmuNlkDsgtIe/2sWHEXP4Ip5p+xtXOoq49/8n3MdZkLsXtw5pzJIltzBp/EgpxbZ4JxGxc6RuU7Hjn9uAhQHRUbFADLbkFd8tNnDkKEiHbjPGRqBB5XpN/37KSoEvsb95djkBiDDh6JGp0279FFrZXNQzB8kOiNuThyOXmjkHQ+B0BXbcns/3ypRjKp6tu/E/WQAdPJhcTxSH/euzUQDtjpCfEI/dj9Lmv01iL5yoTv466jAO5/02zVv03iuiViNF87GMh5jBhX6SWcHFQ8xTCUL+JwG2HppmR0y1A84ZdqWwkas1qHQoissn0ZJhHg/EsqACcxVtbXTazSglxHDwptkSeDlh4ZFyqqXMgQawMF9aIjhNtm9wVBClzyIxE+s04FobdBNBjRnBriD1CZWQHvIzyy1OAKhWzfyfUQ0Z4F1kd5nIQQNs2StERznk6STIwDryZfO5B3ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(38100700002)(5660300002)(7696005)(6506007)(44832011)(9686003)(76116006)(66946007)(66446008)(8936002)(186003)(54906003)(2906002)(8676002)(52536014)(33656002)(26005)(71200400001)(508600001)(55016003)(38070700005)(82960400001)(6916009)(122000001)(86362001)(316002)(66476007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?i8ulHxMCi+yP4wVEl6wutpY83srn8IEHEejYcJH+zNpZ9pa9mObz7+Ln3K?=
 =?iso-8859-1?Q?7Q6oTk82GrPJrKhtpHte33RuGG3wKiLWtiWqtF9MwjNtrMxUUYx93cGvmi?=
 =?iso-8859-1?Q?VGnxn4XCgmDA1B6L7ssntYojK7Oar2ssFxSDnm0GTqadgRM+d4mkIClHje?=
 =?iso-8859-1?Q?VYJ51tUOq0I/DDtzn2nQvsrSg6lRwkIPLEFDGdO7vA7NnwyBgal9EU1uhx?=
 =?iso-8859-1?Q?oYFFcMLSJ4zlLlQi+LzNJmfvFOjXd3ezx8/kpdmEqQ/1RAh4c/T1f3yPof?=
 =?iso-8859-1?Q?M5d4de4Smq8BtBzDPAEI3h5lGIBi/CRFQn7SvTCBJYGIjRPBx4ah0edZvL?=
 =?iso-8859-1?Q?/jisAsBbEurLmgBOPEjJmLACzgGFSbZCQs11SJJDpZfKxYrGzXuk1fdNJx?=
 =?iso-8859-1?Q?r4RvBDXketJE11tPJe+LAkIGYLw0jsVI9nUZ9CPLQ0ZbORagfwvZrCo7DM?=
 =?iso-8859-1?Q?BqwfD7zweF/1YFhDGgHKj+81zt/0LX7LCh151A7UlvkvcaaQA5IF18+wm/?=
 =?iso-8859-1?Q?a+f+J1c/eipWMwfiJ1S6gLFZ0TTUEozzC1jab/mQNhDEz3Fsrl6K3iA80U?=
 =?iso-8859-1?Q?XFBo52d46yXsEag33yXnTByKm8rT6276fgTDH/BNZ4U/S7/lSg0d8ofvc4?=
 =?iso-8859-1?Q?Yd7aYQ3VBi0s5aLgKp7Lr5V57YXb8SBtRicCG0VNFvETtu5Zn6PMJ5Zyf5?=
 =?iso-8859-1?Q?VPZgL6wKho+1Pco6D+3M1/iPp0k2IKcd4BA0Fw+vidHuCWImI4hFhmRu0o?=
 =?iso-8859-1?Q?i5gdWHUUuOQuXMkhAF54r/eHT2+SDUQrYm54dHQ0lI6Y7GqruCMc0bavIk?=
 =?iso-8859-1?Q?d71SYLKLmv8G0S66RklSR1oLOP4WUsaOreBprTkz0GQgFqvl8/08EmUIVZ?=
 =?iso-8859-1?Q?ye7pDmyWxDAqmIlzm7z/lNwrGdSwF2PS//4A98wn1HvVPMiD190T9b8qPQ?=
 =?iso-8859-1?Q?5y7+IONXaZiBHAyf07YVm2DTOQFYns6CGMankjI3ukzL3cEdtWuRMQir+F?=
 =?iso-8859-1?Q?AFL2+irejn1kK9yN/T7TTioPNetuFXcHoSpJ5amIy8OM10CyvPBDE5v8hY?=
 =?iso-8859-1?Q?rGyqHwkMeIxVG9BJXjS8tE3AUstgC5bLbjwLNx8MErnCE9cznGrL48baKG?=
 =?iso-8859-1?Q?uo55KN5fMkWjhBHXbpaDGQs91wzfB3nq1wD+5s7MymsVbW3H83fjifPat8?=
 =?iso-8859-1?Q?3kY3rWDHKcm50GhSONBCafglwgAT5rGyFhWs9Mo/rhKME0FgEJG9sVEj5R?=
 =?iso-8859-1?Q?CteJhH89DYCvfO5GCNfr6d0ao2RHGQBMS4iLVVynAFyD1h05rrSIMzqMyi?=
 =?iso-8859-1?Q?46oI8bwS2IbzHS4MYsGypjXtAQdlt6yqeT24+IH7AYXAzLjK1cfntHcuYu?=
 =?iso-8859-1?Q?gTUmywEPr/W+z738pLSY3berIfHB9Ok+aW2MQYwrg7oL7CpBPzTNkImrDJ?=
 =?iso-8859-1?Q?5XdF4Ef8tYgi0US/r9g6/CGciWEfue+u7xbqlXe6CleI52L8bz++rxtxF9?=
 =?iso-8859-1?Q?2Vq1UoF7zEx+FppQCp6TKk0/Yt2k+MIzY0e2BcGdeN3VGK/s8aIOwUNPy7?=
 =?iso-8859-1?Q?w65K9RLLsU7WaT4Q5bsncpdbtC5n72C/hoaknfMT7gLkW6ufeNPtU7rkrl?=
 =?iso-8859-1?Q?+7sPd7gXboQbNdAsZ3HQKbnv+SAtbfCuppX377IGsBtniCEjkdcC3Vz81W?=
 =?iso-8859-1?Q?hJHl2bq3LDirtOLOU4nWcEe5rvMq8tGOeWMocOcR09+D4DN3xY1wvgqz6U?=
 =?iso-8859-1?Q?NSBA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e220e364-bd31-4071-9bbd-08d9eb33b008
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 18:49:07.8380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zFUJG3T8OXfghpgOxDaaaO/7+sUlKVAEzHGs7b2Ut0IOVA68yTjEo6wKU4+g+WL+z4fUQWzT0Pg4Tkgp9yxesF/o4EddUEmMi/177Wg9LZI=
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

> > @@ -3011,6 +3014,22 @@ static int mv88e6xxx_setup_port(struct
> mv88e6xxx_chip *chip, int port)
> >                       return err;
> >       }
> >
> > +     if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> > +             dp =3D dsa_to_port(ds, port);
> > +             if (dp)
> > +                     phy_handle =3D  of_parse_phandle(dp->dn, "phy-han=
dle", 0);
>=20
> two spaces after '=3D' operator, only one needed
>=20

ok

> > +             if (phy_handle &&
> > +                 !of_property_read_u32(phy_handle,
> > +                                       "tx-p2p-microvolt",
> > +                                       &tx_amp)) {
> > +                     err =3D mv88e6352_serdes_set_tx_p2p_amplitude(chi=
p, port,
> > +                                                                 tx_am=
p);
> > +                     if (err)
> > +                             return err;
> > +             }
>=20
> you need to decrease reference of the phy_handle you just got with
> of_parse_phandle:
>=20
>   if (phy_handle)
>     of_node_put(phy_handle);
>=20

ok

> > +     }
> > +
>=20
> > +struct mv88e6352_serdes_p2p_to_val {
> > +     int mv;
> > +     u16 regval;
> > +};
> > +
> > +static struct mv88e6352_serdes_p2p_to_val
> mv88e6352_serdes_p2p_to_val[] =3D {
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
>=20
> add spaces before ending '}'
>=20

hm, why didn't checkpatch complained?  Anyhow I need to do changes here any=
how.

Thanks
Holger

