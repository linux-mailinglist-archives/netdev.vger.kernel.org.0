Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE530F92C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhBDRIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:08:30 -0500
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:55745
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238008AbhBDRHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:07:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhlydCV31u7+WBeFeIMK49DR9uBQNyVal2vziF3C840BlWSaDbd/qD8JzgbmIAifOBWaCodafvGS94YOYeJ8GWT7w+ZSIeJv6Yt6Oy0e2MqELC+8jX4MeSJsOIiG82rSZPbbc6BgvMKJHmjUFSEeQRlfZ0TvY+XIn2hUmatbSqLdw1FR8KF5+sKfkonQeFc0X21LC8iIVCOkWwFSnLGoz0AmSAgO7jjf30up1nF170eYrkAR2WKKm2BDKQMBdmenia3PFZwzDoFRoPnCCWIeVBDtjKoWj+cCeJB8sD9OxolvWI2h/tC8BgXvvob7932OunZdlOOuBGsUm5jeqTcCNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNo3smyReqyAt1Pm8W3om0uO16TucrIKlTCtR1F6TFo=;
 b=IN80kBxXIcs+3nA21luuGlb6MdijOoOUXR5/DlCAwcm5Ji6dqpiIoiqfK2XDzVS/WBu+k0hT7JGBpr5eAj7/fMYaDXl3ZfZvaK4FRcZdhrUhYLHU54l/ESEOSuYPwatu5XD/oi5eYKAzia0G/boy1o7b+GGMbXOUWpjQNYUhIYrrwEDtHOf+MpVIMrg+UrpeQBsnPguCeKXy7RVfcpkLZy8tK5mZce2Q2+UhTuAbtkGo6II2PqwMnPlQO3vsA5tZR61VBbkrxiHt+T7RuEXsTrckjb2a07GAzzCImVf1C89QPcAp/04H5wkLSwEE2xx1f9xbdrOX7x6j2T736vtzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNo3smyReqyAt1Pm8W3om0uO16TucrIKlTCtR1F6TFo=;
 b=XSvhj04cMf7yfwgn6PncABKF2WnfVe33mfhymyjT8/l6xUdiNJ1EM9mRMbL/S2avcUx9Jkb52+68hOJC0qu0liuewnRRh0WmTHVumAefCfI+qmiIZRusH0CxYBjH4lL6Nj6oBPAC4eqz19bmLE7IzGBcmbnMbyd2GowJxL9JLsk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 17:06:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 17:06:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: call teardown method on probe failure
Thread-Topic: [PATCH net] net: dsa: call teardown method on probe failure
Thread-Index: AQHW+xOMMjstSd9IoUWMIQxabSM2+6pIOFAAgAABnwA=
Date:   Thu, 4 Feb 2021 17:06:15 +0000
Message-ID: <20210204170614.zutxxuufsx53lcgg@skbuf>
References: <20210204163351.2929670-1-vladimir.oltean@nxp.com>
 <YBwoKiRlOmi3my5G@lunn.ch>
In-Reply-To: <YBwoKiRlOmi3my5G@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2051f51-8e32-4322-f6ab-08d8c92f2e92
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB355218BC9832D4A25B7A320FE0B39@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HeVS8q/OU+/JcaP3euRvZS6yl+8h1Kbc1VsCSHf1rAUJM8CEe3XJEELGGcKZXeDGUi9PAXRnuSGcNww+xcIu3sqEWqOXnseVVvcKVY6GVgVjVA5Qqxrd95TGBivc/JYlN6qUHuscs20H+4iMVZnUSq22OiojTmbI4Jcg0xYCjunxnyumcIgKEMakyNEaxjccTzuZrxwHzDMqgqaYum4YYrqQB+2UB/U3qNVvQc3qZhy2NhWa+ObuTuDqeEb2o9LlrS7QFlF+lIuNowVPhkIj1FK6hnRIhzHSOfPGS2DpVqAz2K1vPuTNAskn8EDNHyoO1OI+YFPURUTRTzOx8/FdREpUbXoT2FRLpe4BE/cSavedWNh2S3kF7/OlUEccRVYSJtZDEYltp90mostyhCmqLuNr67hK67HEDSfz0L0m7/XDGRA+M1b6UIpsfn3etwI+Yy15sY+adX4lnjb4u5+lqzuIeaBzjfe+KiBcORN3DJUzZXIA6X0HrvHNhXLj0xXzhsRnM92V5n9rUvqn/VPlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(26005)(6506007)(478600001)(54906003)(2906002)(6486002)(6512007)(44832011)(8676002)(71200400001)(186003)(8936002)(9686003)(66476007)(86362001)(1076003)(91956017)(66946007)(76116006)(6916009)(316002)(4326008)(33716001)(66556008)(64756008)(5660300002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QqcYSvncpk/IUAJImoYXfSp/RUIcNQn7i1Y+SsbGfqjH2r6HRP+C+6/e2SSs?=
 =?us-ascii?Q?p2l/D/msNIomgA1a5B90TI1KNJLcwczZRKZCCoaPnPJdBSvQpmA+RqXNIhFR?=
 =?us-ascii?Q?qaifTLdoG6RTwx/XBBr8PFUSZToF7QZDo4HA5JjO5naYfXzpQhY73fs8Vxed?=
 =?us-ascii?Q?VZ+wSloq4r3+hbpykZHVonaD44PViT6li/CUOzt0MLdfl4DGtTagVpz3eY0S?=
 =?us-ascii?Q?kdofqg8eoCZ+wtffAcN4Ajw/TkA7fmrX8M4CSf59RGSLUa3lGin4NdbcL0E4?=
 =?us-ascii?Q?G5ez6F9WG3+DWxwJn8ggro1iIEsHX1fLH1wT7Lb3EeVGdNRhbRT7ASLGeKb6?=
 =?us-ascii?Q?rK5juFmbkaxrzQcTEw0TZLlftpIJum0F3CCnUGx8dDkDhhrMOyl9KJOi0WrM?=
 =?us-ascii?Q?FxCgTg93X0FO/aPy3FEcG2tJu7EwHWIun8D1OZn8cl0N2xG5JTdXq6xLQy+c?=
 =?us-ascii?Q?mJpeohnnUzXJ33ylDiFIHn080uBptZcH8ai7NYYORWJbo0BiwoEQt35GQhbZ?=
 =?us-ascii?Q?JMRSfyqu+p9RaTpWOqzzYD2hpREtq4rfDxZng48v1NHTsGT4wvWdInycv7zz?=
 =?us-ascii?Q?9wZDZRCEvla/tpyN6nxumi50SLghvytj0BnoMg65OBKLb+nIs7Qh3MGcvLR2?=
 =?us-ascii?Q?cdEwsX/ohzcNpLc/TCfkvuJHcW+khl5FaWieGezTMZDE5s3Ji/KbIjj7pr0Q?=
 =?us-ascii?Q?WvEm6aaIkpZrAUMivjg6IRpBXSieZxLJEhu6z3ErM6CVe/YIKq1iaeS3Rwd/?=
 =?us-ascii?Q?PFxX757PcTnDHtr8OQUOym8bKxBMMGxBsOaJYMJyaVnkTq+2vx+tdJLJJ+5H?=
 =?us-ascii?Q?lFxBm74LFNH/ynsEEIVBdhjWTZbPyTOitTwtQj/AEgVPtzcW4kzjpZc0tbnT?=
 =?us-ascii?Q?pMjgYkF3xhTnKrD3P2lJsk7SUJ5AFOmsXetgLqxKJdtBSKLWh0O6hPwqvAol?=
 =?us-ascii?Q?hlLqZh5QeWEyyXgfiGIpdTdpBV1IPawXe7tzFxo47l/zXTPvR7mu4XK/CFWE?=
 =?us-ascii?Q?ky4hyV054dgtO6dBuCzT3XjYQrhg3RdHskYDATR24lEv2TxXbFE6DyCXzjfG?=
 =?us-ascii?Q?lFBvP82E?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E86EF4086BA94D47B128612DD965BFB5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2051f51-8e32-4322-f6ab-08d8c92f2e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 17:06:15.3885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUJodGN8hsCrFe+y2Ox1JwjS9FO/Ccq3Av2xUNGTPsOyf/0O3nLSIFU7hM9AAk1uNPd6jNwGJ2N55RFpiPskrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 06:00:26PM +0100, Andrew Lunn wrote:
> On Thu, Feb 04, 2021 at 06:33:51PM +0200, Vladimir Oltean wrote:
> > Since teardown is supposed to undo the effects of the setup method, it
> > should be called in the error path for dsa_switch_setup, not just in
> > dsa_switch_teardown.
>=20
> I disagree with this. If setup failed, it should of cleaned itself up.
> That is the generally accepted way of doing things. If a function is
> going to exit with an error, it should first undo whatever it did
> before exiting.
>=20
> You are adding extra semantics to the teardown op. It can no longer
> assume setup was successful. So it needs to be very careful about what
> it tears down, it cannot assume everything has been setup. I doubt the
> existing implementations actually do that.

I'm sorry, I don't understand.
I write a driver, I implement .setup(). I allocate some memory, I expect
that I can deallocate it in .teardown().
Now dsa_switch_setup comes, calls my .setup() which succedes. But then
mdiobus_register(ds->slave_mii_bus) which comes right after .setup()
fails. Are you saying we shouldn't call the driver's .teardown()?
Why not?=
