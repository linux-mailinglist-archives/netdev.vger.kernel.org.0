Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628745FF06B
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiJNOfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJNOfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:35:45 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80081.outbound.protection.outlook.com [40.107.8.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E94CB5161
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9wZESrc9nqLYEqK/bJ/HDIlaBMMTW90EJzGQLYSi9B0IsL0v3Os5YdNBU+GPO6Fge4M5QyZSD7H/rgmr3qYG7qoRInnbnu0IyLnEIGe8+NdK0iHjfJQEbedGoap/dDGE3zCFi6WJpzUhUq7Ic6+XyQmVWeCgqYoL+hLO6st/3CjKl8t6n+nlsXanIPTbp3QDWW/UuQLMLfSTantnjNFG30bYkU4P23fdZ01qpm36CPX4AtGOtEiMgtAYcAKB5edNSq7gfy1bQQojd33MCWTA/9ludLy3iFQUw60v1bl96DBOyPLVTBToIV845CTvSx7ltiUej3cRu2wBFx1U91B8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YaRtWA14DSi1o1oS62s+NcCDYkuanw4QmZ2a/e3WQY=;
 b=NSVFy0Qljwe4XTSvNRP0ccS2mOz1+bNWJYmQgzLhxiodBhgXNdQ1jdKbsuWW9WDAeA8UPRuWlhENRlJ1qwre3kGeMrhbMXmdnh7Z0pEUHgLeoa/lFXXKMJp6OTTdgcc1ZuzY+jYdgR1oe+6015yeM7APAPzCvftFWhMrVPfwljPGzjIKWj6lyBihDhU0qJxMJd9cZfYP2iI/ehFb2uMCBiFe4S8mjsrm6HpQX87hIeGP+5ko9bjGDPe1dHT3/6zI26VHCdZKtDILpYRYh+mNzUXBdRQXOqur+D3rnCROjdAM24T7zM0jr62m4VptQc19n3H4JZwVIzgqR+nD3xVFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YaRtWA14DSi1o1oS62s+NcCDYkuanw4QmZ2a/e3WQY=;
 b=NW6wEIoUwFWi6knpyZiQInDuoxvtwBDhLCDHUvm7hyDhETEOuuhs+7HV2iWzlBMg71Cfe5FtnY4eThKjoXQvlhYUOkCREOvZdm0wNu+AzstRTGRcSolm5SBvHXTK9D2XB51FYe3Xi74J6J+nw3g4DHziHnCvpVVQqrCeuCi2mPs=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU2PR04MB8631.eurprd04.prod.outlook.com (2603:10a6:10:2de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 14:35:40 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 14:35:39 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "\"linux-stm32@st-md-mailman.stormreply.com\"" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "\" linux-arm-kernel@lists.infradead.org\"" 
        <linux-arm-kernel@lists.infradead.org>,
        "\" imx@lists.linux.dev \"" <imx@lists.linux.dev>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: RE: [EXT] Re: [PATCH v5 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Topic: [EXT] Re: [PATCH v5 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Index: AQHY3wk+RdYbjETnMUqpkhkADdfnU64MqomAgAAKk7CAAD9ZgIABAG7g
Date:   Fri, 14 Oct 2022 14:35:36 +0000
Message-ID: <PAXPR04MB918555BBE1A4B12736785BCD89249@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
        <20221013133904.978802-2-shenwei.wang@nxp.com>
        <2c861748-b881-f464-abd1-1a1588e2a330@gmail.com>
        <PAXPR04MB9185C63C94CE032DCEE60AE689259@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221013161229.73471c88@kernel.org>
In-Reply-To: <20221013161229.73471c88@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DU2PR04MB8631:EE_
x-ms-office365-filtering-correlation-id: afa5993a-7cc5-4dfa-e01a-08daadf15d52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXPwy6MRyhvM5cs//j1jiFwbCfQV6bdyhrJiwGH1k4CYGm2cMsVhCDbyo9lxarqsfxVvx5Qe8clo3U6sETi3PgKVnGpBHVKYRDgyRrIkelLvKRpMW6zAVqgKbubFQlm6fLiZKYkvfV7FvGHYmKXLh3VIMje/y2LcxzArIXpkxI+VaKpASQq1qqU5TI4Cobc7R5Cph2OoF1gD4clxlmL+p1jjl3SKCGOEs4zdzRD9Q67NSh8PJFghCoDSk6vSb62HAllegyFhpYigSgCMBF3BBGG3KC22I6tkDv884fUzUBkw4Nt7pf8ma7nbNmX0/ccyc2ucCHpKAbRsI2GXAN6Pl0+GRAkQOEg8nuqlF2EpXYISvUwShNs1ovuQQM+P00KSlGu961oujI+9xU+0j6R/5XqqbaY78feWZRuzgeWy0D9AoRfzNCyhtpFs1uTjBE43BMXiSjb+Yt8TDDy7rZ6mYNacVQARgd8zS9g64liMxHn0UN62JWb0rMfrtN+75XUMUbUV7R1IaeMKy/zE0j6mQZBbI2FvNQXD8zVVi7FpCarsDdS5ZiS8aCzibOL3zqGrIYoHhKhTTlG1L+IfxMkfmd3aKeBcTWXxDayaHXYFs0iBUMzGQb7PoBElzIv6i7xP8ix+ljP19uclMiOXxYNWNix87vV0XbsYXcbmRrggDjPWExST9vmrFL05MERob87FkfmAtW85K8qd6HECMt4f2vrg433otoaqfA/x8zqQFSfOW34GI7/3DmTSrmnQ34pNU3qCBCWgNNJLtmhr+aAxFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(38100700002)(38070700005)(86362001)(76116006)(26005)(7696005)(6506007)(9686003)(71200400001)(55236004)(53546011)(41300700001)(186003)(8676002)(64756008)(66446008)(66476007)(66556008)(4326008)(66946007)(478600001)(316002)(122000001)(6666004)(6916009)(2906002)(5660300002)(52536014)(8936002)(83380400001)(44832011)(7416002)(4744005)(54906003)(55016003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xS0yDrgyd0cbyGpY5qsgMpXi4hLtAj+aB0SN6FtTO3gu8u1+9XoDq207tEPK?=
 =?us-ascii?Q?bZyUagx/gqRYCgqbFldh38/uAikHi/8/KVQMpJZpCxWSHlgih847A6agfkiu?=
 =?us-ascii?Q?LdQ09OO2cQ8s7AcmLYJX/1VZIVuOjqhpGgSq6UzeXP7Q8yVL4nVTYhGT3ZqB?=
 =?us-ascii?Q?7re8FACykmtcmjA+F3YUlvsGyV7QlDxvcOMyHpttqMC16hzzHek98I3YFfV/?=
 =?us-ascii?Q?FhnBndL+arXKQt2WXBO/DzUK+96fCLD9ZzQVSbjmHc30lqo0aDTgImmxNU2C?=
 =?us-ascii?Q?QT7MiuQIeeb12l7YvskcP4S9+TnwFa2xrrG66h3qcToKK+BC7hjz+qRkRb7J?=
 =?us-ascii?Q?5QjhHiP+vWLCYB9FV/C1snYHbKRyiCJkHN3FsmnmKuSwU/Gb6FYuiRhB0GFa?=
 =?us-ascii?Q?48mewINn3gGwZGQYmsvyJA5/r9hECQTDOXSprMyyl2sB7kV1gWkZEFEmpNhu?=
 =?us-ascii?Q?fnzllrJ1FP0yAnVn2VaTteFlW1Wpt6udVB6L51CS378ZkcwyftUGlsfafJet?=
 =?us-ascii?Q?dru/C/pEBri48PERt/TROqj1Jp1L8w2Gqqw0CA5AYvSUi/WXcgStdewLMaxY?=
 =?us-ascii?Q?HedmKgdRDgSqKj2O2sK3X04VpNKdHDxrIvvxCDbm0Q9e2S0gM42Kf4g0Bv0B?=
 =?us-ascii?Q?FBh9mF4c3Q09WmnzKKAy3bfHqkbO48NUV4/djXrPZZFIhxHNQWWqsjMYUQHe?=
 =?us-ascii?Q?+7IXhGkNKgp7QpyS0NtvKOi2eUAIhwNUTdXDtweBRPG8iGUwDVGj7aiTnvan?=
 =?us-ascii?Q?J0trLOI1K8jD3Qv76jMwJaTv84+i0wTJXpbwpQ+00QyoX/PnJ31vse/l2wBs?=
 =?us-ascii?Q?r4G87L5BRHuA19tqYxXPTH1iPo+pEgwCVBD5wWrgEZ9tQtNrJSFS2LOgyPhy?=
 =?us-ascii?Q?kaLHE92HFbYOLPhWnnZ1ANqeFACdmfZt8lV304XMkelRoZZmYZ2cvW4BH21s?=
 =?us-ascii?Q?N0CkxaJ00vc7qpi8G6RAXLqH440hWu5bgfQzs6N5psNpaaQ/WIWSpp5YUO/h?=
 =?us-ascii?Q?fSwEjTM9Z6JrMSuj3hRtaHUP2BMceyIHBB8NeFJxALHG7Kk7/mao4BawW4Os?=
 =?us-ascii?Q?4jqw4SKaS3SGOMoIy293sf7hPyu6+hAHBgWwQCx9nEF7loBdCEA5gBU8/wf4?=
 =?us-ascii?Q?WtP3zk3K3kv43XHYEy90CcxEuR5RxqP7a7H+hT2AtlNMxkTZONonP9wwcYqC?=
 =?us-ascii?Q?Qi+VEMWv0BmuS7UdrC0vHwcqa7VjYE9bI7gNk4Jf0cF3d787erkmHa15aVdM?=
 =?us-ascii?Q?RS+lb8mmSBWpnlIBkDXjgGms5obeThi3VFSEV6F06xuRU2uv8p36wHKOY6NG?=
 =?us-ascii?Q?ObWj5uIc6Q2Nm8aREQ0kLgWOpv5Xj/aoijfEarm4aXt99XxMSUvBIHLePM/z?=
 =?us-ascii?Q?t2Qo0zb/aG4i8Ji1Fmv8gqrlOGAk+CzlVY3izrhd3LE2vba4cwu5oHbX8fNO?=
 =?us-ascii?Q?xHmPjH9y1TWt/TffHLrDsiMN6Zf0oS/P/f1Q8/vH9zQwE1HOw3P+oLP0RH7A?=
 =?us-ascii?Q?bFRm6koQmo8yhSFhQLaD8a7A618Oz2EoM1PzIsJPD0pd0H1io5g4An7Rh6vo?=
 =?us-ascii?Q?ZyyQ5or4UmTUrB7zI0PZX2zV0YlJwHGGLe843d28?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa5993a-7cc5-4dfa-e01a-08daadf15d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 14:35:38.8751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4D/XkTg9tAeX7Vzz28gbQDb/tZGJLs1+cMMdzk+UddKM1cTVVBuOG6odKmUkZIsFL5g1Ve6wdqejKIGoM1Nxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8631
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


RESEND because some recipients' mail address were somehow corrupted.

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, October 13, 2022 6:12 PM
> To: Shenwei Wang <shenwei.wang@nxp.com> On Thu, 13 Oct 2022 19:28:45=20
> +0000 Shenwei Wang wrote:
> > > Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect
> > > mdio_bus_phy_resume() state"
> > >
> >
> > That was my original format. But it met the following warning when=20
> > ran
> checkpatch.pl script:
> >
> > ./scripts/checkpatch.pl
> > 0001-net-phylink-add-mac_managed_pm-in-phylink_config-str.patch
> > WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1>=20
> > ("<title
> line>")' - ie: 'Fixes: e6a39ffcfe22 ("net: stmmac: Enable=20
> line>mac_managed_pm
> phylink config")'
> > #20:
> > Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect
> >
> > That's why I changed to the current tag format.
>=20
> It needs to be all on one line:
>=20
> Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect=20
> mdio_bus_phy_resume()
> state")
>=20

En, that's the tricky.  Seems the rule of size limit is not applied for thi=
s use case.

> But I don't see 47ac7b2f6a1f in my trees, are you sure that's the=20
> upstream commit id?

Just had a check again, and commit id on the upstream changed to=20

commit 744d23c71af39c7dc77ac7c3cac87ae86a181a85 upstream

Will post a new patches to fix the tag.

Thanks,
Shenwei

