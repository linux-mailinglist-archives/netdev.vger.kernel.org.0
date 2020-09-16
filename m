Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7D26C189
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 12:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgIPKNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 06:13:31 -0400
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:44642
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726571AbgIPKNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 06:13:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjyEr9lHggnpHkIfiYnYixC9ZlyzuYLPcWUsKvYXa71qOSTV4eMs+/r5JME2+umgHIb8Ba+FzfzK+l6ynt8Y99Jh/3ebHR6Qvp6YeVgxO87l5z4YxP4yjaZ4YwlLnSXfD10qrz2CTndwWoQmZrGfR21Dsep9USgH7IBJDPEFVfgqCpFpxNlSSq3/nIUVnHM6UAqHkA4Ncqa5MAue8FuenuwTAhmTLOLeENXotfv3dHekQ4TbiGbmwuBEOfrw/KuSf7tluPr/AjvAfddUHeFPpC6RifsaMCTiuJu+6AMVQAXx3/fXO5ynvN49p4/jSm9xuFCtgVGNzklBd2c4vXRnfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DcK5H3Qv/jiLFJYxgIZnu5hYgm2lXZJSyjFczJaL/Y=;
 b=MTo9r4eOXaJ1+jaizm8Za85xXX2ZFin6pDWie7tOcInZ8SndPSDWyfIYBpB7VUUmVnhNNOzfZVera6YV58TturZc2VF7r2HjUsrDrXUvNsMUzO35tBNLxmAJEDb9gxxTCreqKHyjdPcKr/tHZbhuY2fHWoAj0uqsAiGxwmIP8jM+GqgQU0L02WjDvDxxLjIKwiveWzTV5KNLiakzjAC+oGAJgwoisQ/yNutpj3EC3fvN6rx8uZJWccRizGC9Aow3Zfa/JXEgxGDySQvHBq2ZrPM4+zdg1/WsuOFZnT2JzFekInfRz0YKEE17xhg5AAnwBDvT1VZDtHh53PnpPHqIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DcK5H3Qv/jiLFJYxgIZnu5hYgm2lXZJSyjFczJaL/Y=;
 b=QaaLAeo186Y+skDG0f4bfBSfI1sRDPzshY4vNk/45klprF2pHgptcOTHFYqLOmraEp7/7RyBNUA+lsKZX747MTpj3RlpTjqcd+AuMURYz3eLgDraaKQBVIDbmy+rSm62zXrQlr55jO4s4H8tIWCin3EzOsJEOKThQJwE7SO9QME=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB4182.eurprd04.prod.outlook.com (2603:10a6:209:44::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 10:12:59 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 10:12:59 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH 1/5] dpaa2-eth: add APIs of 1588 single step timestamping
Thread-Topic: [PATCH 1/5] dpaa2-eth: add APIs of 1588 single step timestamping
Thread-Index: AQHWh1dadUlk4RHq9k+La9YzigmOealh8ekAgAkjJwA=
Date:   Wed, 16 Sep 2020 10:12:58 +0000
Message-ID: <AM7PR04MB688591B8AD3DB523AE289608F8210@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-2-yangbo.lu@nxp.com>
 <20200910074016.2c4060a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910074016.2c4060a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 793f6473-e6b2-4349-c980-08d85a29167c
x-ms-traffictypediagnostic: AM6PR04MB4182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4182CF900722D15806D00FEBF8210@AM6PR04MB4182.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:166;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +jP2xDoMav7LxrugpbAW7VbSFwtflk0uFbTk52PMJqSGk30VIYtam2GHy2FGtS/PBpGirlAP9RwMxtln4MqHREvNoidt9c5+puvhpzzRnTuV7oJbJe4pyVQ6h5XRk64OOt2emftJY0JJmq3PUic0heqNMMcIAPSlJYg39affs6TdXq3Nh1E9kcaXmIt954YfeD7oPf01KMO5X++pRsFKq2FJQeZJu0mAaeNFFnqq6KjBEUBLlcSbtuBx3cliNtTPG/ESBeBXNzUv7+cGHjyVALHIED6pbhdKHVXGFkt1EFPhnjiQmY11LhW2cupg6190
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39850400004)(376002)(55016002)(186003)(4326008)(478600001)(9686003)(52536014)(7696005)(5660300002)(316002)(6916009)(33656002)(86362001)(76116006)(66446008)(66946007)(64756008)(71200400001)(66476007)(66556008)(54906003)(6506007)(2906002)(8936002)(26005)(83380400001)(53546011)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SZ5LBCzFQfQsQkpTZTJTg/dZzCfAq2r6c58HkqQCyx4oTjNce9Is+k1nQjuDsfiPw1+PGXbMThZ8FrdRuurzLjK7QG4vA8zYUeDDUkJJcLReodrRAglqDkKms18vnBWQKztwKfxwlz8HEc6MgDtkQEPHJ0kcQs1PWcv6PErQgxSWCPhau+MEZE2RT0sx1y/2v30FcBiLabr+aoyj/OkiY7JbkKDXkMODFJKIayhrUyMJ/+CSh9UVoxoPDgZr1kVObIEThl9J7Br5vx5WXUfZySbklvLXhjJy7fp7N9ygVu6loS/NeXOFU0/rFjM5Mfm4MbC53TpkAsF8emGWJ33okWcejLwn2qOXgi71Oh47bGqdbn4FkJejCEF+js18PSefhZBWNQZwvs1yawRAlBYQeNx5HDoxen0nR9r2kKxZG2BqfUQOSdmA+x+2gIKJNRkE/4oADBjYIU4qq2NfmyaYM9x5Om2xmtz51nHLXRuSgiZ/uhGThaCulPHyftQwmOxil6Eetd54zysje0zlIYaJOfG5q+khI6UM7QQdI7xX/lk/oKN2q3WeUkTH2hdvVgZu500QK/WoZ6KRiX+Ou33xP20DFiZxh8efAgKdLA+hna3KLvvwzTU06aPGAjq+07WY15NnF5ShQa4EGwdmrfEilw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793f6473-e6b2-4349-c980-08d85a29167c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 10:12:58.9634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EIpWBtGuiWdW8IDw9yyOrB1W3BuffM3a1Se7SgQufJxQolGfe+ZreGl3sg/Yhr0Bse+SaAg5yF0N+GieJf1hTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 10, 2020 10:40 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>; Ioana
> Ciornei <ioana.ciornei@nxp.com>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH 1/5] dpaa2-eth: add APIs of 1588 single step
> timestamping
>=20
> On Thu, 10 Sep 2020 17:38:31 +0800 Yangbo Lu wrote:
> > This patch is to add APIs of 1588 single step timestamping.
> >
> > - dpni_set_single_step_cfg
> > - dpni_get_single_step_cfg
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
>=20
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2035:23: warning: restricted
> __le16 degrades to integer
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2036:30: warning: restricted
> __le16 degrades to integer
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9: warning: invalid
> assignment: |=3D
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9:    left side has type
> restricted __le16
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9:    right side has typ=
e
> unsigned long
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9: warning: invalid
> assignment: |=3D
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9:    left side has type
> restricted __le16
> drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9:    right side has typ=
e
> unsigned long


Sorry for the trouble. I will fix all sparse issues in next version.
Thanks.
