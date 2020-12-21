Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066FC2E02F6
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgLUXmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:42:08 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:7277
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgLUXmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 18:42:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPXj7rLjIOwi9/VZz7kJBGeQaiZpA+yFNRU/3rG2AOlw8PPi4SMUTt6QZEumw1q6rRdX927DGsEzZW9XXFG2p3d6OQlSa30kBeO2verQ8HUfmJOA+bz+yXbGTxVWBwbxMHkv3Alf/uz0t7vskHCviy018PwqWgEysBpWI+0ocNesS6/aMMZnULvtPDRDl0ih+/E2HEZf20j1mWlfUWB8wN9Fibo1Zz5ErIZ0JZng8eukxVWjVQNYrdpZ6yZ1A81BOxfiVfk2vjq+KS3l5wSgeu3cqoXA7s3beDnV8d1JRPx0gS57+P153AujI8EhGZx9eGupeAUWzNVL3bw3IjT6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDbdR2Br1SkPurbci33L6W8DS7v6kU8wYC85/agy7h8=;
 b=Vc+lPvsdjGGyIOk8UYH0K0MYGnTQ+ccHB1MKwVIadeXC5tNzBR01Z5htrYXp0sHgchfqZflS2SSYa42p1NNFsQVzcLLTFB3HMgpBe5YhlwZkJj8W9fe2JsTMy3DNUt8kq0Gjnt0m8WQiXv2Qd/9Ta4y6o90caGhHS/JDfV8r9FEQ7+dTxA/fPpgtAZNHJg4BZpIYvu21y2SVCf1XX81ysYGxMpdUOlB1SbmElXp9j8UGWzZ4UpD5ehytyhTyjCt2p1XRgfjL6vrT8P0/70QwqTaHzNedMfRLT9LaczWqyBZzGX3+2s49hVUBdvEzgxaOzrKMLpuM91hwMZ9Q6GubTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDbdR2Br1SkPurbci33L6W8DS7v6kU8wYC85/agy7h8=;
 b=n0vMYEG+RgfLvYLSGjePZLtCny6tkFvgevfaYJoW1K3QXIoYAVmOiTlJSBEi4lofmgBeFhVnyXxJa+oxBLVx3/fsQ0T3xtScR9Z7kKg4e4sU2dfvz+Z6d8Qj6VpIbKvirQwUXGuBkBgrTcEMt8lRffwkF+zWntZD6uwKCFfzTJw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Mon, 21 Dec
 2020 23:41:18 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 23:41:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Topic: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Index: AQHW1Y6jUxjdnV3YQ0WXbdlAp0+0q6n9zjkAgACHJICAAqobAIABJ/cAgAAJOgCAAAMAAIAABseA
Date:   Mon, 21 Dec 2020 23:41:18 +0000
Message-ID: <20201221234117.m2jsyjz576hd47i5@skbuf>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
 <20201219121237.tq3pxquyaq4q547t@skbuf>
 <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
 <9bc9ff1c-13c5-f01c-ede2-b5cd21c09a38@gmail.com>
 <20201221230618.4pnwuil4qppoj6f5@skbuf>
 <b106399b-e341-2aa2-d92e-24f5a0c243c9@gmail.com>
In-Reply-To: <b106399b-e341-2aa2-d92e-24f5a0c243c9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37b27f4d-181e-4e48-64d9-08d8a609e9e9
x-ms-traffictypediagnostic: VI1PR04MB6943:
x-microsoft-antispam-prvs: <VI1PR04MB6943A3F849B400EED969BF15E0C00@VI1PR04MB6943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5N0IbOmAolpGBDbZt55DQjyLnDSv+279MacTcnq4TH8hQNUvz//WSltxUYpYZDVS73pekH1V0OjPjKuLWgSMUUywx/YM6oIgxpgCMFiW4yK/tv1H4NJGr9DXqXPetFgiYiwKDGhCIA/5UmqFPfyo+jw9BN6+6MO3VpNVcRVBAUxNDcY/sYM1W/HVxINgPmk0pSO5JQugdPNvQqYSNEvmYHfEgEV1Dj0HAIdMc9fbx5Ulu9CsVH5kb9oCkHvE5XpH3mVbEPhrt/XqmHhz0z0pqChGPADe40iCLRFMVVNSXbnAfLEd8lmCkNoDb4R5m8xfDdlUeLYIM3igJLrHsRBpZysZz7Hi83zrdtTAtO2aR2blO7TciW5zxEz4rmpcFCTVvGybahn2g+Yjw8KaBWW1Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(4326008)(1076003)(33716001)(66946007)(5660300002)(66446008)(66556008)(83380400001)(6916009)(8676002)(91956017)(8936002)(186003)(64756008)(26005)(6506007)(2906002)(76116006)(66476007)(316002)(71200400001)(478600001)(6486002)(44832011)(86362001)(9686003)(6512007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WhsmK4NS4Q92Pab9KbHPEkXhGespe7DzcLIQYbISsc3DTMAOZeBitmfZ45UR?=
 =?us-ascii?Q?Otw8yiV8GkOBB2SXpPkdmT2vzyOopYVHASaCAioI9TF8k/GP/2KbqdC80Yys?=
 =?us-ascii?Q?7J+xYnsDKFm+3phOH5HISUaE5Fv0h9fCv5hrN0cIyiYZ4pzrs73KPmghP7sg?=
 =?us-ascii?Q?3k32SnmTtWbLW4QtLLP5ulxbd0MS/p02Mv3RftiyrHXdaKItAFquCNZ/IX0w?=
 =?us-ascii?Q?y1KhoT9etkKjtl16V44dcwqncve6Ual0U/l/ahQi8ld0drlg/w+fRKFFwz8J?=
 =?us-ascii?Q?Jw8XdeXU5cUFL8KB/Egp/Oz8zgS4sW5DSUK7Wt9Es2EGXnHgkml8qXJGb9G9?=
 =?us-ascii?Q?KSnWEHqN0KCTxBzYoMODTjaz1W4JQAq1mKuxWz/F+8Id1VBSzl0q5CEx0d0e?=
 =?us-ascii?Q?ePSCDfZnvtgwcoS/FFG5hCcIcs9udoImdxXUgConx2Lwx0AJJ/TL68LLtLeG?=
 =?us-ascii?Q?qrkzkX+oN6FYt1AwHzufRYt5VH04CyaFTwTcCRg1xrDhUv2DLI41HEW4ACWu?=
 =?us-ascii?Q?ky1b7DAw48eBuyUstPzMkn1p43PAYTvVv1pAkeTWxzPG6tQAA8bxqQ8WI7Eh?=
 =?us-ascii?Q?pzABM7t56EyAROswA+ZzNEyoiL5fpOhNB4fxy8aP1L1fPMCljNWFpp9S4KDG?=
 =?us-ascii?Q?ow/n3MUC4zN+jmpJyD+b3dcJDp2vxA5CJooVRlY5waUwrxwHCXkS0HVwqcRj?=
 =?us-ascii?Q?dfkimDivnt4sW6m2tLj/UUdKbj9ev2zp/+hZ2lS104/u6yGn6duzPEwhuYQ2?=
 =?us-ascii?Q?GqRnjFhp8L9dRTWh9CMxQDr/i3JXxO2Snd3Re8ITrmRfVet1pnD/0OJmyZgI?=
 =?us-ascii?Q?aXCVYCxRHBrHBIW0OjB5a1GhJVWWZPe8zoq0mUcDQjwyznFznXTLdiYwKykP?=
 =?us-ascii?Q?qNqbNodenbj+aD5uf9tAQQd2YqWEcRnLkePJwqJshbhp83XlDQTuSlC93rA5?=
 =?us-ascii?Q?rIHzf5NGnJaKXtTGqmT6AJFl0dtcU94YejItgl44icLVGfuhLAUWh9H2USva?=
 =?us-ascii?Q?SMM2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FEFC07C82DFC834F804EC02C2BC3B55D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b27f4d-181e-4e48-64d9-08d8a609e9e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 23:41:18.1679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtMDAdLK8JtqI2UQ0NDCGg3YXyi1d2f3S6KFwsUcnvKoRfOfcMzsPehp0icdChVSYGASdfPei/lTzWtWdislqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 03:17:02PM -0800, Florian Fainelli wrote:
> > Do you think we need some getters for dp->index and dp->ds->index, to p=
reserve
> > some sort of data structure encapsulation from the outside world (altho=
ugh it's
> > not as if the members of struct dsa_switch and struct dsa_port still co=
uldn't
> > be accessed directly)?
> >
> > But then, there's the other aspect. We would have some shiny accessors =
for DSA
> > properties, but we're resetting the net_device's number of TX queues.
> > So much for data encapsulation.
>
> If we move the dsa_port structure definition to be more private, and say
> within dsa_priv.h, we will have to create quite some bit of churn within
> the DSA driver to make them use getters and setters. Russell did a nice
> job with the encapsulation with phylink and that would really be a good
> model to follow, however this was a clean slate. It seems to me for now
> that this is not worth the trouble.

We could make include/net/dsa.h a semi-private ("friend") header that
the DSA drivers could keep including, but the non-DSA world wouldn't.
Then we could create a new one in its place, with just the stuff that
the outside world needs: netdev_uses_dsa, etc.

> Despite accessing the TX queues directly, the original DSA notifier was
> trying to provide all the necessary data to the recipient of the
> notification without having to know too much about what a DSA device is

I know. Personally, accessing dp->cpu_dp->master directly is where I was
going to draw the line and say that it's better to just keep the code as
is. What motivated me to make the change in the first place was the
realization that we now have the linkage visible from the outside world.

> but the amount of code eliminated is of superior value IMHO.

It's still a compromise, really. The atomic DSA notifier was ok, but if
we could do without it, why not...=
