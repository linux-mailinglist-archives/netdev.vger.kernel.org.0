Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50664416D00
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244442AbhIXHpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:45:19 -0400
Received: from mail-eopbgr1410108.outbound.protection.outlook.com ([40.107.141.108]:21632
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235134AbhIXHpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 03:45:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vpp+qKfdPlb0jZuWtlOFKTFlYwb/XeAEj1NdYIVLsoP/jp+PNiEcz2p62uNfQwkS0um/llB3JWqDW571PhxdrhIzxdvMyFWBf1+t5EVYJ+9Sn50MKqVvBycX7KbxVq4tiOHS0tEs+/4VbAi42NcicR6pKSW7ykBPJPGlq9qzmApSsNuBUavhq59XVZfc+G+vj4qHk8/Nt3W6QpG7cNsTt9ZbKQRzb93bW3zAKnQuvLRAOqxMRD3GJQwEXNsibqg2iNTl21VUFDpMWQi0SFIUtEx1ZfiBLDZQBhEKYrAb7dT6Qlu2ro3SgURnpq50PVA4iAYPPA3hltTNiNX9s+qg6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VV2Cfgwc6zUfmyR+bal7Uk1nWnDF42U/r1hlSb1vBGU=;
 b=UIcGTffVs9YLayArWI3SmvY3MlPaDodxfY7lQ9pZquvVZsu7n6ITw+F+MxJ3wn++xKNtXOk5KeROqVOwzxICX3yIvUY/9ECvAYBzRd+1OOK5tSiiruCBTpZaM7s/8BiDBJmRXfaDSfZeMH+wdJ8lCPtajbz5/enp93v0Py9BRrEfxqzZ6txgn15T7WAvCualPWdxHPS8rnzhpeuKCbK9u+6Y8Pi1S+x+AI8asVr22udEFIxNuFNZ1RkEoTXp/hGsuSy71UMnlx9ydoH7YfZfnPJrA1fZOMvILzE8+G4LC9nQTDh9NCf84lKpqehK4d+Kwnhm57y2RmlmYslbx2ttHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV2Cfgwc6zUfmyR+bal7Uk1nWnDF42U/r1hlSb1vBGU=;
 b=oDTHEtwclUufnJ1LB8YNAGkJl94xNLYtVdXvrIpBlEYZYodUUCCGcqAnvU+G0/zQCXYDxXdjZfCnVbOE/7qk1HQy4GU6OWW9mjrwR9DxBn5t4tqQtarq4VeUveeQ7465uZb8+MZGd7mLxZGCY5Kb3qya/KYn1G2A84Dmn3h92NM=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB1978.jpnprd01.prod.outlook.com (2603:1096:404:b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Fri, 24 Sep
 2021 07:43:43 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::5885:70e3:e339:dd7a]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::5885:70e3:e339:dd7a%5]) with mapi id 15.20.4523.018; Fri, 24 Sep 2021
 07:43:42 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Simon Horman <horms@kernel.org>, Ulrich Hecht <uli@fpond.eu>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Subject: RE: [PATCH] can: rcar_can: Fix suspend/resume
Thread-Topic: [PATCH] can: rcar_can: Fix suspend/resume
Thread-Index: AQHXrqkWdgnp1V2zg0S23I5ecLpaz6uuTDyAgAHiEQCAAqPZgA==
Date:   Fri, 24 Sep 2021 07:43:42 +0000
Message-ID: <TY2PR01MB3692A6660AF5B4C8B602F0B7D8A49@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
 <1020394138.1395460.1632220693209@webmail.strato.com>
 <20210922152336.GA26223@kernel.org>
In-Reply-To: <20210922152336.GA26223@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11c02b26-dcba-4417-a565-08d97f2f084d
x-ms-traffictypediagnostic: TY2PR01MB1978:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB197846EDCE9536B6B96C3D0DD8A49@TY2PR01MB1978.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 40VqgMDQiMcfW0E2Bz+/K1j5LcfaRd3PaS5/IPdmNAobnF4zcnHq4vhR/sVR0vqhG7Y30E2vTgKLa71HvZ4TW2EdipiEeXRA3uK4gc5v21ZgBUUp+SMslYZ0XbBtpNUZlFImUjYZxRglzDk8pDOaDHFoR6kLGmGH3jMewNiqrJ/1FqgOWXK0FQ29WfC3qqxW41L1qXkf6xW5aCnziw3ZzfCQqPJgWsezih9RpMdiVixaNIWZeRM7gcZIw6vFb4uWPcOFdeXm2SdbEMuGhv+1jARW4zfvwAiVMrOgLTMhUsMI40bLqSKHOmWIHCV2b9sT9z9KFYeAdvZ1Kex2p7wkR4zOmCXJ11kDK8w4unCTXvgtXzzgqSBxpOw/jHvqOM+nJGRLMaCQufUNiF0PD6WderoI2GjkZyT8gBKWgQGsYqRH6SKJoYN2C0SG+t5j/8FwJ/axz9Jiqrh7dvByxnp6HaMbzf9dookYmfawdGy0boyTIH/fmLF98K86Dc8lPOcuwsuAEofMDEr5dR+F4T/6G0pZVesTgoGctyqFml9m19evmAmLdY4hHc/Y6q6qBqie5DCdJrdThkR1jRRYOa1gZDqJ4HlfpmSVvxeghaExOrYTQCPL9TDNIrpq1xKyOAPj6/rAxK3/lnpBWc82XCHv+Q2uHxfYunJsvPRYGN037BTGkGrrK1ouxHRZKWlzan7iuSDfbjoNJrNi+uKMF2q2kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(508600001)(110136005)(54906003)(52536014)(66476007)(26005)(8676002)(66556008)(122000001)(7696005)(9686003)(86362001)(55236004)(4326008)(66446008)(6506007)(33656002)(66946007)(2906002)(186003)(76116006)(5660300002)(55016002)(316002)(8936002)(71200400001)(64756008)(38070700005)(38100700002)(107886003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9zITY5Y8oFSEE9behjnuMu9N20tpxW4a9ufI+c3PMczwtXitiVV/593UNrog?=
 =?us-ascii?Q?RvDv4EUrUa72aGmOUQU/+Dm5chkd/D5JhArZZu8ARHQJN/ou+Qs3hm22JXUz?=
 =?us-ascii?Q?4A5gdzth+SGWQ+8u29lRwQD/ZMeQOxewU11SUR9C8ckjjFqJyRJyhSQOmreY?=
 =?us-ascii?Q?Qz1hhhX0Qqe5uNB8mBTaVOzqamMRq5PE0NKVailcd9om3lv49ByyMOdfE1ZQ?=
 =?us-ascii?Q?OntegTF9MREiwcdMeVSx5K+GEHugUIuzKEOuJmRTP1R9bYzEX5dTZvTJYxZF?=
 =?us-ascii?Q?P1hTONniSh2DHGP705XJ+nh7UliRgidYQKsV/Baf06wse9YUYB/yLkv6cyur?=
 =?us-ascii?Q?jFlVQ1waSd1S0/DxuSOkRZVZwvhnu79Ox59zfUrtXyiN2+1MjK0jzL9a6MCg?=
 =?us-ascii?Q?mZlYnkGo4bnFhqzvUv/NDMM1HHkL/p6EBC/BeKLvmR9T/2E3bTe5/7jxZh6w?=
 =?us-ascii?Q?00mZCi8qnFv6G8qceHNCPMUU8blwenqEH7DUT+Rc0Gl7aew3Kj0NtAQdqUBw?=
 =?us-ascii?Q?xJNuuyO6loOwavvQ8JQqbK49L5mgqFkvZzLHzwHtEGC6x7HFOchatsgjGHd9?=
 =?us-ascii?Q?vy5uKWgRNuC7zOkPZoHlYNY1cAXfZxvXEvSDjeskW00H/W3soZnbqlrNfotE?=
 =?us-ascii?Q?eTNX11B+0nEqNzlZ6xagYi0Axoc+nTEPh96VIvEXQPWTsvJLYI9bDpD0CcbC?=
 =?us-ascii?Q?Dou1XE8JxxNKIKbfS1DJZ/cgoLuIqmdUCUySonoURbDxmcc9KgJUgasaf/6H?=
 =?us-ascii?Q?dLx9aaqDiaoLt9cmn07hMvM0x0PbAxXosjxXs8DKGSgWM4l2h7qzpt2xTrYU?=
 =?us-ascii?Q?Q9IvkV1qMX5UYD+hLFFuI4ipBBmhE0LIvaxP07YD36zxNi9OorIWiWqHtJWG?=
 =?us-ascii?Q?hc/LtSc74jy9CExDJaF7scMCnXXFD3m3PBGAvCfpA20moeOGHzCSEhuO7MUM?=
 =?us-ascii?Q?QH0gHiBodB+Cv64CqHZfoDnib03bN8DLDimCBUh9ox82XnOuI8RN7JWtWOZq?=
 =?us-ascii?Q?PvB5Q/OQBb8Zp55b7lvyI89bqqCOG9UdRQmieJXi/mpn6a1/uUvOLZJB/7KQ?=
 =?us-ascii?Q?/cJNWbbBpBSqTLDKQGlVhkFhzq4cffnqrpwkvKPzfQXnneJ68n2XqQPP2a39?=
 =?us-ascii?Q?PAuS0ih5j58BF5CKYv8TOJFKVR7sb7Cg3U84DYIeORghunu05uRvHKadcVbf?=
 =?us-ascii?Q?/NtJ2qG3SUWLDXtF3Fb+8GN6sOGKQj19icVmiZvoPPDd7VcmvuJ4LMJ2TfgU?=
 =?us-ascii?Q?mznaGeqk7DcifxFiMLNO29c/TxN87w/uBtyYflBNAqMw33f6PDY8WG8RZL50?=
 =?us-ascii?Q?tgg28LmiyiA6eZLASp7ERlA5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c02b26-dcba-4417-a565-08d97f2f084d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 07:43:42.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: layUfjCEkt4MLM71edsF6Dee2sXfZtpdPFkKjzOEh2VRds/eaKCcoFrpg3to2HeIU0EREqqAfxmRU4OPVmDhJRz/OaJ2hKSSjlAW2GwuFx5VQta2GRaJFINjO8wQK9t8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB1978
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon-san,

> From: Simon Horman, Sent: Thursday, September 23, 2021 12:24 AM
>=20
> On Tue, Sep 21, 2021 at 12:38:13PM +0200, Ulrich Hecht wrote:
> >
> > > On 09/21/2021 7:19 AM Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas=
.com> wrote:
> > >
> > >
> > > If the driver was not opened, rcar_can_suspend() should not call
> > > clk_disable() because the clock was not enabled.
> > >
> > > Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
> > > ---
> > >  drivers/net/can/rcar/rcar_can.c | 21 +++++++++++++--------
> > >  1 file changed, 13 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/r=
car_can.c
> > > index 00e4533c8bdd..6b4eefb03044 100644
> > > --- a/drivers/net/can/rcar/rcar_can.c
> > > +++ b/drivers/net/can/rcar/rcar_can.c
>=20
> ...
>=20
> > > @@ -858,6 +860,7 @@ static int __maybe_unused rcar_can_suspend(struct=
 device *dev)
> > >  	priv->can.state =3D CAN_STATE_SLEEPING;
> > >
> > >  	clk_disable(priv->clk);
> > > +
> > >  	return 0;
> > >  }
> > >
>=20
> nit: this hunk seems unrelated to the rest of the patch

Thank you for your comment! I'll remove this.

Best regards,
Yoshihiro Shimda

> ...
