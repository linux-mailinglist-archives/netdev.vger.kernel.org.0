Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBF4948E5
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbiATHwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:52:06 -0500
Received: from mail-vi1eur05on2136.outbound.protection.outlook.com ([40.107.21.136]:60609
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230405AbiATHwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 02:52:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp/lgT1sAkUeocuSyV1rUH1x7V7XVwWS5wU5cEVTLrjcUC/72h7AJ2J2HKf4JJaYKE4ejVyzToItw8Pz5pEBFnR0WXZpyyZOPR00hlEgTByl0XP2GdZRClapqr0O+wTSWpasqfow+lYl5+j40NWakJjM0yoBFwmxsOLE+8IcSDzFXJZDlE6kkx7fPyFKe+d/4g7OYfUajUD9h30DfuquDXLoXCtAsLMuDmyRiXkkLnfVO2tJvwVOKU/Zc8AwZEst563K6/pYaDSVyqgsl9P4kwxJ4mlWfQHEQxs/wDqeYBRmbJLTWeqPjs/1MQowu1X5JaxT2EwJwUBscBvlDf7I6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuGkSNucJzMRmxvbiPvR33VpbcPCnf7/dD73mbpGTKw=;
 b=HT1YmCh13eVvGCboYVShvWMZZEn1G4CvLW+1f0fxLe8a93TPSAwlFrT8cPnW+sz0307JuTX0TLmfn1EJBPttIMSmGE9MeZy10h+i597rZuI0wPRLkyh+EZbRsM5oArEzY3RqQqNSUzlJJaoCwOCdhwJppgn/rXZdUUJ7EG+j13CealUnPattqZEoxXJpCJHDiWnDLnbJ62iQOzq+zCKGcYFIL1KlVzNe1JMwh9+xbRibz8wXoNZ8d11DrjMFQZtMHa8d+KtMK/I5crk7Kf0iGlehdGxE0mEIAlWo38F4cWg4UBOWiwBncyf6I6QCoeFj27MZvE8Xhuo2V0vn1S8z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuGkSNucJzMRmxvbiPvR33VpbcPCnf7/dD73mbpGTKw=;
 b=iPDw2aaHZWcmiLa1KRACKpO2A8i/q9ioTnlXpgFxvJCtElxmeIoWVc2ceA6fLn8tHuOjR4bQSzVVucZn/kum2AC3G5lulurfcecFOT6sN2R4HV+7JuIsvJqBl94Hi8e4P3snPPzlMOxTJ4X2Jgmnpr8BSgS50M7wVaqfmgPEAwPza/I+veXXJyT5M/DWKoQCcUy0Tv3F3yETfb3fW5jMnlScm3iY99PhmXjhxnk9qoM+z2DWwzNbIyBBFp38D50CggWlKCUUrMoF6BHseo2FlPc6nDitGyqe96AAsQF1YbhQOMI7Q5fMHfW+xAvHBwJoZ3VO6DmIEhKfr3LHNpzHzw==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by VI1PR06MB4255.eurprd06.prod.outlook.com (2603:10a6:803:6d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 07:52:01 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::4146:af1b:a4f1:5185]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::4146:af1b:a4f1:5185%6]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 07:52:01 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude
 configurable
Thread-Topic: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Index: AQHX6525E9BoIskIRkqx58mIW7K4x6wnabuAgAEYVdCAADdQAIAAAK4wgAAM3QCAAAvxgIAABI6AgAF6ciCACcKhAIA2tXtg
Date:   Thu, 20 Jan 2022 07:52:01 +0000
Message-ID: <AM0PR0602MB36663B72C5574E30DF7A6805F75A9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>      <YbDkldWhZNDRkZDO@lunn.ch>
        <20211208181623.6cf39e15@thinkpad>
        <AM0PR0602MB366630C33E7F36499BCD1C40F7769@AM0PR0602MB3666.eurprd06.prod.outlook.com>
 <20211215215350.7a8b353a@thinkpad>
In-Reply-To: <20211215215350.7a8b353a@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93b588be-eb8c-42e1-323f-08d9dbe9be49
x-ms-traffictypediagnostic: VI1PR06MB4255:EE_
x-microsoft-antispam-prvs: <VI1PR06MB425527BF7B1FBCB536A85A8CF75A9@VI1PR06MB4255.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tRPkgdiezZ86p99ezxjMn5rRyQZIyw6RAGlz8mNuW5GWcEGqVQzBmqGtf7ij/Us+TYaPWSjQ7JDQZHWcsra/tfGLsXb7RQPnp6SnrjSKEBGmaC5gPSTN3PMveWtxeoZ0rc7LY+pcYYosInmBWm7gMRFwu5wMCC9NoRTnxruew88nI1rvQxvBMv3yYYMbvp6zEZs92OJJ4/gi3wwB8sS4KYw4wmL1on8IeiV1y8JBroG2gj4hRBz4OCwliKab756zlpgBHJfpww9YzoSq2qHOKyUqtN6BM1gRcyDnEfgcrUI5R9TOb0sRRr+MWPz0sugjRBy+UExJ99YidVq+xxWGTxB6Gaeg2BW0UxGuKFzpYrEabHIxa2/w/b6NF2mS5uKnIzrxlQ6oMzg0jsuD5n7uVRVih0IVE6l3EwaimGHO5UkFGyhC+DUlJ5FdkthbrdLuNvykvyEh/xuMlbRiWJEmL2QZ9L3HMReJIWqWm+Zrm9xzTbRBLelNLdD/g7fpmIf6Bf/yJT1qMWVQ7v6QNcNYUqx8/Tuz+WsqcauRvUd/1xVcErlkGYNIG9l/htaLbRJqRgmDzGy29O0crh8Rp71nOWdD2Nx2TxKCEy+/D8KKvXd1J5OojWciq8yX/HzNC3OQZyNL5Js2OXtFmo3LUDpXTB7WEx/myLhPwLuy9g3BauMfBso8NSLl6lcOp5ZCtNQ/G2nw7ZeOOhE9D478xayz8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(38100700002)(66476007)(44832011)(2906002)(71200400001)(52536014)(55016003)(7696005)(186003)(8676002)(82960400001)(33656002)(122000001)(4326008)(54906003)(6916009)(316002)(66446008)(86362001)(64756008)(66556008)(5660300002)(66946007)(6506007)(9686003)(8936002)(26005)(38070700005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Kj18P/dYfesks0ulJopJY7W3t9W1WbHXXRpH9TSx94H67xVlb5iiAdBOVQ?=
 =?iso-8859-1?Q?tJoGi4fGyk9oWSZ61bm8TLO7oOq5Bs5JlsZCwQnLP5aUajrNAnK18wlbBr?=
 =?iso-8859-1?Q?A0OazBqt9rbscXzP1G9npnhSQFG1/0zGONVcytyxL78Io6fXFE7EbBQfQL?=
 =?iso-8859-1?Q?h5N+oTnkp/juY4fMZdBr4ChG4DzA7JXUuKVytHV4BIbOed/Goy8E1ati05?=
 =?iso-8859-1?Q?rSVqPqD+z28tvQcUThKAMB1JoGb4KKo3o5PQq3dTU0XeTg4s9EiLu8Y+dj?=
 =?iso-8859-1?Q?WL6XB8nkwc3zgbRmTDtK2CMp4H1/tmnHmTpxy0YAb9K7UWwahFMXo+UH9o?=
 =?iso-8859-1?Q?E1cU1FNa+81kjnzyV58smf6alJwmvD7WhEsn5+Rq8glZPq7rzdPC+clZ9t?=
 =?iso-8859-1?Q?gECgaiGYonwDzvAeNtT2anz3et9C1jJXS9Kxh66IKF8daQnO3UHWPFT/f/?=
 =?iso-8859-1?Q?2Z8YPUQsH6kKH17bdbmFw4z2o6kNbloDDLHM0jebUof3gB4pb3VjFEa24d?=
 =?iso-8859-1?Q?lTBXcyfwcILZEcdYXXV68cZjgJ7j3uSqj1gwDApiPpB8GU4eKvOp3M0Ur+?=
 =?iso-8859-1?Q?yKHr+GD4y6ZGPpGV7p4RasyUgzSyaUJ9fJXEfRD7XZ6RObk/+yc1IzrytE?=
 =?iso-8859-1?Q?8cZ3Jq1XgxnydwXdRU+snTI+T8RI1/CJmYq88EnNKDqZLu5bhdcQTH6dZn?=
 =?iso-8859-1?Q?hmEv6l4JFoV06OG9WxO1c5dPOEBR3eM5So2IDbVzwRlNk6Ttr41IKHxBLP?=
 =?iso-8859-1?Q?ttPNVbPMPJqbNhZPHSImh3iExl/ysONcx8CCOeTk6zipMIkqjPrbWJc57F?=
 =?iso-8859-1?Q?obH2jxNOAe3EqGOgakeKZgFPVdz8nMw2tMMTiX6uKJ5ePQdE7TEBhmz8s3?=
 =?iso-8859-1?Q?qdMUEgSzWCJnaAjsITy+k71LqJ3gkE7HyfN1Q5BGpfJU7cjvEFn2IGwuQh?=
 =?iso-8859-1?Q?4t6v/NsYP/RHMiyPJqpcv2+eJc/HpcnXkCx75SjbgG7MjZJGO2ftPn4YQ5?=
 =?iso-8859-1?Q?LoirbXfqQTLL4GXRvpS6PE8qdImoNPGCBYob3N0Ht4AD29y2Gn3SiTkTvO?=
 =?iso-8859-1?Q?scv4VizghK9VYgAuUAQoB+0NcBzcBLDwYHzi54yR6Rlgq2V907cGi2T/8R?=
 =?iso-8859-1?Q?8YYmMLobG918r+20nzP/jl1k/Tkm8klqfKFYHAqRoVqQTv2yh5HS5OhV87?=
 =?iso-8859-1?Q?0eMFdAi7AldfP1QV8fZlH53qV/7bQLtzKayVB9qbsgE/lDV9Df5RnL0ocR?=
 =?iso-8859-1?Q?1PkH0AT1ZZnBcnRpGKhD3D6qQrdFnSvIPfXIAuD6bJzTQRKXllFMltcBEU?=
 =?iso-8859-1?Q?6vrO+TZdGVAX3b05mFV67Jxy6f7QDEzTS/vRMPWPHtyiTn5hNfgsGKe8tj?=
 =?iso-8859-1?Q?9qKirmBAEbyocmZk6weC0mgMx2bDJbTMUW9VwhZI2JlUp07v1mcvInbHcR?=
 =?iso-8859-1?Q?hTzBL1MC52gyMKLqWu7ekqqwyPrFgVsxGkkPDyJ+QT3oT/HqcpIUw6JhQx?=
 =?iso-8859-1?Q?0IAaWRqISraxfiQVcGneuylX2HaSaQWvqpP7Ee6+5zSayYPTbhtnTLXYIs?=
 =?iso-8859-1?Q?N6uf8aZvsg/Fh7oOnBBs2sJvi9oDO54xrWa+PmqqAIVBSFgKY1cGbSsk7O?=
 =?iso-8859-1?Q?16KqHLmyE/rkVj03DlKGR+vVvxBDQZrhuZLrL48aiZxd+OMrFf3QMDT3Ws?=
 =?iso-8859-1?Q?TWZc1kmNNBP6A4UA050O/XeWp5vR5BrKTsND0xS0gHQIWSMBuh9Vb6AfTO?=
 =?iso-8859-1?Q?uPEQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b588be-eb8c-42e1-323f-08d9dbe9be49
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 07:52:01.3310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxnFnRgGIy03iVCbsRFI2gMXPa+TpNo7DLWtXXqwATIrBU3BeYcLtEo9w1wgIz92NheDu2T0IySXVWjPvr9kFedtX5oRpxxmsgwW6lPI+5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB4255
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> >
> > > > This gets interesting when PCIe and USB needs to use this
> > > > property, what names are used, and if it is possible to combine
> > > > two different lists?
> > >
> > > I don't think it is possible, I tried that once and couldn't get it t=
o work.
> > >
> > > I am going to try write the proposal. But unfortunately PHY binding
> > > is not converted to YAML yet :(
> > >
> >
> > I saw you recent patches to convert this. Thanks!
> >
> > This make my serdes.yaml obsolete then, correct? Should I then only
> > re-post my driver code, once your patches are accepted?
>=20
> Yes, please let's do it this way. It may take some time for Rob to review=
 this,
> though, and he may require some changes.
>=20

I saw your v3 patch for the bindings and I would adapt then my patch
accordingly to tx-p2p-microvolt.=20

> Also I was thinking whether it wouldn't be better to put the property int=
o a
> separate SerDes PHY node, i.e.
>=20
>   switch {
>     compatible =3D "marvell,mv88e6085";
>     ...
>=20
>     ports {
>       port@6 {
>         reg =3D <0x6>;
>         phy-handle =3D <&switch_serdes_phy>;
>       };
>=20
>       ...
>     };
>=20
>     mdio {
>       switch_serdes_phy: ethernet-phy@f {
>         reg =3D <0xf>;
>         tx-amplitude-microvolt =3D <1234567>;
>       };
>=20
>       ...
>     };
>   };

this would mean in regard to my patch instead of checking directly for the
property in mv88e6xxx_setup_port  I would parse for the phy-handle first
and then for the property?=20

Should I wait until your patch is accepted and merged?

Best regards
Holger
