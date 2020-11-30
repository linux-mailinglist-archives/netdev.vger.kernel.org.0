Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE1A2C88EC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgK3QFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:05:30 -0500
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:4960
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbgK3QF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 11:05:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Sp+aGGvQ8Ep/SOrkw2TEDbfVTk/Skppot3aUhR6q5XAgseX6qnqpUjMvx2ApXzb+zg3p4Ivm2nLmrM/bL5EdKUAHvPWL4KlJYVKJbau23VJL9h4XbFIq+UhPc5x6rWVRz3wAJbjFOw6ILidgUNvQDjs39r7proaT2yW035NeCegZPEnGWb1crXRVCqlvPn4imKg/GrtxBXf8a9k84Sz0J4L7o7gELHfN/ZXG6B5QT7ZI1u3XxxuD0kdiUnupZOLNcdL/W51gs+aITEvGKU2DcztziJBU9+EfLwjhml2n3yezeOuP/d1HcFtpVBbdHp3vx41Zi6m33v2KOQDvNnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6yQLMmKHI1neRaHA1++2Uy2zdjzdnpwmBR/7vK5dw0=;
 b=V1EXBMFfPZ/QlFHrTclqQ8Jz5Sdr7nvQNdHxbTwHGypdzdeU5qUi+riEF3ImIXQA64+LTOn7R1pwl6sbTb+93eaflB9zb23vGOTtvC7o1j8LnEygJKoYRkl3PEH3IxMMIk1GRZW9TWtVZ/CpjHIZLs/vaGr5rxIptZ4Sa5e/8xz7CKRvAsK0GQWE8T6BAz1E5CWhtXKHp23CSsYrC56eB2i/EuxDtbsHEObOzfsRfM6IuNBZKAhxgv7W7hm0W+jBAX2i1q5Xkit9PT2gatkb/uuSuKaiONs8pCv40ZjABAN/JjLRk/9Ia+SXKKZnN+zBSe1Nn8R6yCrf2Wo43kM58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6yQLMmKHI1neRaHA1++2Uy2zdjzdnpwmBR/7vK5dw0=;
 b=hpWXnQWBdKut/4ssNvt2H2RJzwqVx1r1ergzpTapY5tdIYTatNy/7CoXyhiJ3lkJ7GiWg/6fz2qm1MnN1xKu34thWNp1Z69pvLIMmagDcdzxwR8UHGXMDuXyyEHISez7fVuuPhxiA7jnFuoTibYAwkU7OatO1F8K0caYVJQ/BSs=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Mon, 30 Nov
 2020 16:04:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 16:04:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: warnings from MTU setting on switch ports
Thread-Topic: warnings from MTU setting on switch ports
Thread-Index: AQHWxyVq1gSWQepkuUGwM5Q0zFNrPqng1riA
Date:   Mon, 30 Nov 2020 16:04:39 +0000
Message-ID: <20201130160439.a7kxzaptt5m3jfyn@skbuf>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
In-Reply-To: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd5d6745-bd11-4afd-30c2-08d89549a47b
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB5501E54E27B50DE68A3F7B73E0F50@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PX9ZrH2k8UgxvJpgXV0dNY7rKbsapA0salyZV1PFDPadBnpokZpcSKn+RZj+M1ipFOjMsydhQYnpDBHmryC5zqPF5FBPYLZu3NKI00aJwEW7Rhsjag38ZC8bJNK3Fhj4+a6D8FqofdCkFhHi48Z6umxP7+wia3evVOC2ZNz9W456ADQ6d7rUDsrGN6IfjXIBGACyLgfSK471loQ257AVVrsKJU2IySnOovsKX0aCZIBpwAQVW4cAes1oT4yawtL6VyvihvYf9Z8L7amrMo3x4l4CT1jKbH+2t8QS9B2uHtbPTvvAywVMcFxMzWDEFBLWZcIWqyeUw2snOWH54ox//A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(346002)(376002)(396003)(39860400002)(366004)(6506007)(26005)(6916009)(186003)(44832011)(83380400001)(33716001)(5660300002)(2906002)(71200400001)(86362001)(4326008)(1076003)(8676002)(316002)(6486002)(8936002)(54906003)(478600001)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(9686003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KeqVxsTshUTqHtPNzvj768MeSMzpyexxlacO2OMqWaRVTVZ+JxlFufRih2he?=
 =?us-ascii?Q?QAJST5htg1QLmC+9XIIRiWu8t5SEzaRuK2Q8jhc0BQVVSXTSEJVbSyIaQHNm?=
 =?us-ascii?Q?2/16necLucaDS9yyvbLDX5OXTVSuSg4vaiPhH5OXUDfhnUkNc2gTVrZgDREV?=
 =?us-ascii?Q?HYZXnLSBpqzLNdePF/dg34sVcf4ywiHGIF13D0V9TJnzAKPLjSbknlZCvVar?=
 =?us-ascii?Q?jMaK5J33F3bbYlzli8lOPmG3aGd/dnXeIJMcDNSDY/Gv/Yf5uXw/jNxSig4w?=
 =?us-ascii?Q?DvxkI4elLS7LmxvQIb4LxUgTYn6/LdPoYcJc12Cc24/0YbHC24rC06hfjNTO?=
 =?us-ascii?Q?91p9Zjk791l9hf43wmmsiflPG/1ZQIvlKqm27JkhegsYASAcJS9Ivuygy0jd?=
 =?us-ascii?Q?s78ub+497awhopvNyFbafPhDto7RmETn5MOK3ocRHPDL28TvxA9fB+Tgdy2Q?=
 =?us-ascii?Q?6TnlFNe9t6rqRlkyLc6yPwyEpzS7QBGkSv/Nq54XAA2e6d5usH8NrxnFvm21?=
 =?us-ascii?Q?3S8MQeefgYQdM6q62mq+hnXXzOXulFdanMGOtwpPayPG+vfjfapJSTokOktl?=
 =?us-ascii?Q?3II4pi33Y+p/Luem0/NaZ+51jd0pRPIg9cDhz5osg6ywv82G4IQTCaHjWMF1?=
 =?us-ascii?Q?JhJDRkEjgH2rSNFUrA09MKSFYB3ehPg9rd4nFdCPJJWPVLPDAgEA1pPUrxAX?=
 =?us-ascii?Q?IOHZ5UHg427UOTpGNdmP20EasawkI593B+X5ugPPJCzT1JzAgoGGVB/JpNC5?=
 =?us-ascii?Q?QvMi9eoaWzapGljr8A5r7PmHayIpJbZ5UPpO5WCBSdiWhrLnIZsYXCmllu55?=
 =?us-ascii?Q?Wkvps+hUeW1Al3EVAphE9Vb1Y/KEHj6lWCkhyYNqk5VutN78V9UodytiWWsg?=
 =?us-ascii?Q?Kc/Q48ZGckxR5bnUH5J28tt1gjex4mEkc9FpWzQmo+xP7ENyFHc5ElIYjp03?=
 =?us-ascii?Q?4mOgPhDC0Sms0tIFZBUiMKI76XWSDPfHHAK4x4Bi9U9mH1d3jZdbxU7nwno/?=
 =?us-ascii?Q?jBz1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79A93939B9195E44BD1EC22F310BD8DE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5d6745-bd11-4afd-30c2-08d89549a47b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 16:04:39.6593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iyj/CanV1XILBAoeV+HUbx2puoZU+PNawiBaKg4W/kJk5HSOZKjOp9ukzgpyPZ3LQat69D+QAilNrax/p7tOxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, Nov 30, 2020 at 03:30:50PM +0100, Rasmus Villemoes wrote:
> Hi,
>
> Updating our mpc8309 board to 5.9, we're starting to get
>
> [    0.709832] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU=
 on port 0
> [    0.720721] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU=
 on port 1
> [    0.731002] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU=
 on port 2
> [    0.741333] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU=
 on port 3
> [    0.752220] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU=
 on port 4
> [    0.764231] eth1: mtu greater than device maximum
> [    0.769022] ucc_geth e0102000.ethernet eth1: error -22 setting MTU to =
include DSA overhead
>
> So it does say "nonfatal", but do we have to live with those warnings on
> every boot going forward, or is there something that we could do to
> silence it?
>
> It's a mv88e6250 switch with cpu port connected to a ucc_geth interface;
> the ucc_geth driver indeed does not implement ndo_change_mtu and has
> ->max_mtu set to the default of 1500.

To suppress the warning:

commit 4349abdb409b04a5ed4ca4d2c1df7ef0cc16f6bd
Author: Vladimir Oltean <olteanv@gmail.com>
Date:   Tue Sep 8 02:25:56 2020 +0300

    net: dsa: don't print non-fatal MTU error if not supported

    Commit 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set
    the MTU") changed, for some reason, the "err && err !=3D -EOPNOTSUPP"
    check into a simple "err". This causes the MTU warning to be printed
    even for drivers that don't have the MTU operations implemented.
    Fix that.

    Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
    Reviewed-by: Andrew Lunn <andrew@lunn.ch>
    Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>

But you might also want to look into adding .ndo_change_mtu for
ucc_geth. If you are able to pass MTU-sized traffic through your
mv88e6085, then it is probably the case that the mpc8309 already
supports larger packets than 1500 bytes, and it is simply a matter of
letting the stack know about that. The warning is there to give people a
clue for the reason why MTU-sized traffic might not work over DSA.=
