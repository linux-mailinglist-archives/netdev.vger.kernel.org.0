Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61A43F8EC7
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243462AbhHZTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:38:27 -0400
Received: from mail-eopbgr1400112.outbound.protection.outlook.com ([40.107.140.112]:49824
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhHZTi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 15:38:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkwNQZD0EjB5qKImJu5mAakRP8wMLHQ+vEwz56VKjjp2UZs0G0khn+tlOgxkQmNa7ADQ0j6WCkf2k72Dg8Yl1aavcW9pvSiRhcdj1uIi2aKQvA1zJWWKVIyagcOfoBlkaBMneNHBbRwdpx7ZMY6XzvHPLMQR8nxgLOFXCkFhRhlI28IBV36liU7KVx1oKS8MDri4f5o7k1SebNZhJpKzLlmFq0Mbr+0/t9sxJV7ummHKx/W6eRkfJa+JRpqWMWuuWOoBbs9EWdy0xCOd+dMO7Ynh4bB/hdZZMCAAiLkPErXhthRiBHZ1nLBn9+mlHg7pfyPUvUkRMUaA+IzlsggPEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZFUYGwo6tukNP0YU4p+Xi7LnhqQJXKJMM/pyGuhcl0=;
 b=GbfbtwkY9Nh/ELhcKBXBeRWQewOnYD1/JOtWNO/pGq4YsZPktpr797qZXqoltuWIT+aSpD7dqvTtewJ7jw4TTyCnZqtEcsgD0Xv2R/qFugHppXtoD9K6r0MxoGWMgxpPYTx7TpD6hNJHZCxDpSc+RxHEjuUCGR2E8hqrZWdyRd2mLp8EkZP4zB+WB0OwCoVzBBMSXLkDu16K6SzlKox0x+QV2yg3luexhyILgnCp7a8sBQ7XghLWn3zOELtFIgzNEFop72Om8oH2HITHGJKKuxUwJStk9NL9Miix8MPgVtTLy5TIn5+QTYdQP8M4KuS9U/yoRxf0sGss/HZnuJPcBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZFUYGwo6tukNP0YU4p+Xi7LnhqQJXKJMM/pyGuhcl0=;
 b=fT/nMz7HMvk00vLP1+uxpxIB7Tp1Epy4W7iCtJ1/xsR9PkzSkLdTgcjpg6/sKp17URQ9waikaoVCDeJ/FYg4eC6I7m8fPHGUcTJAVxcRrLOciwYKvFWRInmY0Yd8ZwXnOz2soDtntUWwzvT+0kgeh7o9yRQqWjuIO8gvn4nrtCI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2135.jpnprd01.prod.outlook.com (2603:1096:603:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 19:37:34 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 19:37:33 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>, Sergey Shtylyov <s.shtylyov@omp.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBCAAEagAIAAAOMggAACgwCAAAEbsIAAeyUAgAAONACAAAFFgIAAAhaAgAAHRlA=
Date:   Thu, 26 Aug 2021 19:37:33 +0000
Message-ID: <OS0PR01MB5922871679124DA36EAEF31F86C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com> <YSfkHtWLyVpCoG7C@lunn.ch>
 <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru> <YSfm7zKz5BTNUXDz@lunn.ch>
In-Reply-To: <YSfm7zKz5BTNUXDz@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f647815-5922-4c43-33af-08d968c8f391
x-ms-traffictypediagnostic: OSBPR01MB2135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2135DB7EA6FDF67FB339535E86C79@OSBPR01MB2135.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BJ9VZFbhe0MiM4gv44FhjVxfDk/4pZg7JsJbYyBMS9PeK9vharMaUTuGpnSfPPwmmS8uONWpLYGIycKc4fp+hSIPdmtV34bBeDTHlWxYgWT87V1aKberJ4/2mf78agNJo33Vfg8Ei1u3O4bFV0wVoL1DCpk9bMS14/SmOHHPTOekszGMfRLN2E4tglZCcQPiuTTO8iUPTofLhW+04yhyiqvgGHOvCnCLQbtx0MCc4G8+7kLiep9jLAzVJOaql7XD5zA9dpIbIFaVy1C5lVLcVjFot7IZnIcpqb4txG7noXVIREOBFHz61UeBSVJHaWvT5XsMTvNov8Gg3j+m3HRlKlw9ietCOnj7+Hw3lmzXRLhz71Bh8Wh/EgBk5SXkURxyQN8nzQlkm4aeeTCL0Uw7AL3ocvrJubTbvbGU8B/d8QVgv7gq3ZlFcwPpGaHeo7i0BoKK+dzuaVXDQ1ZhIYmfm1IabSmpq61dlJL8b8ktg2W65+jeQ5su+dbhqAszY77BbH+WM4u7PUg82ndqrjjQiR6+uv6b+lm79jFIGJpKUtNGno2BhHmpc5u6AhMRNJ9eVvfmcJDExnVN+3W/zC7VWc8cxQ1M7vMYXokFiCpNvvuNcispeQwbEMN0hmPONo1ga92hly3jhOSJv8J//4/r+KujQf+NlAooM3dpAdIMTZhD5h+6LCUNpQiGzgsWsRfGtJhmTwUtthbVLagjLnot3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39850400004)(8676002)(478600001)(52536014)(8936002)(7696005)(2906002)(4326008)(5660300002)(33656002)(76116006)(316002)(71200400001)(55016002)(110136005)(54906003)(86362001)(9686003)(38100700002)(6506007)(66446008)(38070700005)(66476007)(64756008)(66556008)(53546011)(26005)(186003)(122000001)(107886003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g7+D6+AkdMorMvwpSJOI2Enfiw8qZWX6Wm2YjZaVj4Ku4lCYRCgH0/1uf0KV?=
 =?us-ascii?Q?fB0IfB91ZdFwcHvw3hjpYWB4GZpbjeiW1lZIOOYXxG9DgNRoVTDPmGQsilhP?=
 =?us-ascii?Q?7VWnZocNVysmgMMPkk9CsP27iprgrV8gCQvf2KvgeEYpYP1y9xDYCQhIeszd?=
 =?us-ascii?Q?T3MpaZL9e46GAp0xuFwO1Pj5PTi2EplbcMMMtL7/zutsgOwhaZkHwFWM5XCu?=
 =?us-ascii?Q?QMuCzz8wTj3/K9W5EGxh47ZFRwH7fV88EcYUQuRTJ3T4YZ1P3QvTyNw4r26W?=
 =?us-ascii?Q?Z9bBC2QT1jytIVF4OQW7Ni0Rsi1rEBd9X2NvM60PBi1yzU67Z2Eujp0OC63z?=
 =?us-ascii?Q?qlxcf+aUuxBC90lJe4yefZl1HaRUG1Bo2o2BE8ys2zeIeUcpEU+XnAXTVp3D?=
 =?us-ascii?Q?KrtOilMZZAzqhJCLSRgzE+yi/J4WF5WcAEs6AusQNTH2NAXA+nW5+5faGL3t?=
 =?us-ascii?Q?5IQ8p+9uZQW9BqkYfHOBNvRp+jYj2O8E/MvgXyYxiLnabzXkxDvz7bPC97tU?=
 =?us-ascii?Q?ubKkfEiKg4Uh/CjpYfrxRu86TtLujmiwjB+a3asSIWsQNsIVJl/EWnHnURSi?=
 =?us-ascii?Q?806+Wcn2jGOhFCmruHcz2UnnXCe9uf420TWhgxlHjvjGHZlwHq00ZPRJkbPM?=
 =?us-ascii?Q?e2UGFtnOvsnm/xBZvQOFI8M6ukNGAw9fYH1QwptE/QgQCsJ1w7pAlL5hpMz8?=
 =?us-ascii?Q?7Vng5Z6HvQKS67zTza6MWbFOeHvwWsTTHHxjTHzwrXMfQ+SzY3gaeupVW9tD?=
 =?us-ascii?Q?Dk69nFexdff++T3dsJrzXQS2l+nL9bgiTMcnx1k4kTvwhiLS4gaSOO8y+smv?=
 =?us-ascii?Q?um4hLiE3/UBNzty8e2qTGLrgIKsNmtHwNHvrDgYrX+T4ch+WUAw7AgQ6mB+Z?=
 =?us-ascii?Q?4UaUuyluqwiXgzFObPtKB1zuozL7RPf7FP5u3fsnPEhWdhf39c2BCkbpKh5G?=
 =?us-ascii?Q?bFqN9sgGzIhLoQjqK93X3+zPhFjmyUV7ZInI2aIeIpGy7BhcFJ02hpOzgiyl?=
 =?us-ascii?Q?OeJlnUh5vuUPw0ID/Uu5S+mVd3+7TWLaoMMWrdQVcqk2VShcyYjDgvALNosQ?=
 =?us-ascii?Q?O5xpdABooHqvSd1PomXU1I5633aGELb0/M/8XUZuZyovZSgzRrLGvp6o8uFd?=
 =?us-ascii?Q?EogICh+KtNrM23rwHxxuQ7vb2CKKXEAw54PrnpxFJVaGbCaPIHu+1EJLEzy9?=
 =?us-ascii?Q?VDntuIVNq7OYfn7hKcjPNLTMeFLRFCZIjheJLy8LnRrMA/W6r4y4H6fgWGPk?=
 =?us-ascii?Q?kIHYmU+2URQ4MlOQKm/+4x23RAOhPn121XLOeqrJVVk5zo6vpcpKD/3f4hJp?=
 =?us-ascii?Q?PKM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f647815-5922-4c43-33af-08d968c8f391
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 19:37:33.3277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nOBy38cycwbfMkGrkAqH1x4x+XCuJFVQJgdtorLfbijDloSJ92go7rGw7lZOwlVnGz/7rkwE465FDClIu+pvgml3MAxuJTjFfD/m/dvJc/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for the feedback.

> Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
> ravb_hw_info
>=20
> On Thu, Aug 26, 2021 at 10:02:07PM +0300, Sergey Shtylyov wrote:
> > On 8/26/21 9:57 PM, Andrew Lunn wrote:
> >
> > >>> Do you agree GAC register(gPTP active in Config) bit in AVB-DMAC
> mode register(CCC) present only in R-Car Gen3?
> > >>
> > >>    Yes.
> > >>    But you feature naming is totally misguiding, nevertheless...
> > >
> > > It can still be changed.
> >
> >     Thank goodness, yea!
>=20
> We have to live with the first version of this in the git history, but we
> can add more patches fixing up whatever is broken in the unreviewed code
> which got merged.
>=20
> > > Just suggest a new name.
> >
> >     I'd prolly go with 'gptp' for the gPTP support and 'ccc_gac' for
> > the gPTP working also in CONFIG mode (CCC.GAC controls this feature).
>=20
> Biju, please could you work on a couple of patches to change the names.

Yes. Will work on the patches to change the names as suggested.=20

>=20
> I also suggest you post further refactoring patches as RFC. We might get =
a
> chance to review them then.

Agreed.

Cheers,
Biju

