Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3133E46A211
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbhLFRI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:29 -0500
Received: from mail-eopbgr20077.outbound.protection.outlook.com ([40.107.2.77]:57603
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236113AbhLFRIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:08:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkGApQKAVCl91TCTiFhzV7FnkZl9bY3V8KhqwIioSc0XQllvemidzA4//Bv7poyY2K3oM48xUo7koeQxV4tohnsA4q5sTkITaLoJmayIdfbbLtDtKeBggHX7ZWyL/a269pcZ1dQZY5pdab8sNQIprBlUck1tB8FZumalic0KLdYjlLcfWhwRFHswgIL4EQuiAckMVWcBcQvl5kQ/luMrsRupJ2GJVFP1IIb4aDowINoKe/DcZBvM53Lilyt+bYVbl3NPpVwzdZhnzBpnHVFtDPv/jWVWKN/zuZ0GOazA0adrwbh+dQNDqTkSnXDr46COap4ixFe0DlBJPP3rCJ+5mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gFE2odscspj0+8+jTZX+Ut3evh/fk0hHnFyhMO9znM=;
 b=MeHiPBJbkqzTOFG0F8ls+Qbqu0YEoYZmjrBPriPTW9L6uhiuvqUQC1bS7M/LAIWCTnVMUfI6UC24jHco1FUuxXowtpTk+Xf5IFhu3wO0o/u2HLnsGGWOrieW0IaLkNThRoMXeKkGMK2C6nx1430OOX7hp5VIqbYONsNHNEwBENz1+Iau32oxtOZmHk6nFCViWDeJk/phlHGmes0CNcxRMk0M0dzO0offXcub8XNEQUPixEPkpQ618HV7aJYThUxTNXaPol0asQTrTzJVLFPGIPAdmp/m60l/nNYge2UzAAvMUFzYJXqIKArGw297gbkGokNw7ydmoKeCa5oJc8Ww5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gFE2odscspj0+8+jTZX+Ut3evh/fk0hHnFyhMO9znM=;
 b=EHYCe+cjX0KinV4p/DTf76kYvEJvm3luMJMR9/+w+tGya+lcq/7XYnZtTfoe/xWuzpkH53xnmF5rnnQeD6H1GJvcqPWHggaygZZ5P5ShC1bmjqbQ9mzSU4xGhwMN3qGXPts+hXp59BWju4ilQzBGTRckzJbauA81KCGlupz+LUo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 17:04:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 17:04:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in
 pinctrl-ocelot
Thread-Topic: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in
 pinctrl-ocelot
Thread-Index: AQHX6IsIWtKLsGNWo0WEOaNOzBJHnawhmfaAgAL+RICAAR1dgA==
Date:   Mon, 6 Dec 2021 17:04:34 +0000
Message-ID: <20211206170433.rwvt3t2rllj5xlw2@skbuf>
References: <20211203211611.946658-1-colin.foster@in-advantage.com>
 <20211204022037.dkipkk42qet4u7go@skbuf> <20211206000311.GA1094021@euler>
In-Reply-To: <20211206000311.GA1094021@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a081bd4e-9017-4170-4ebb-08d9b8da7a99
x-ms-traffictypediagnostic: VE1PR04MB7216:EE_
x-microsoft-antispam-prvs: <VE1PR04MB72162784552E671DC51D23ACE06D9@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FRksOmUltY696sPPN8LYQDnAzrkKnXvs7mX57v/krV/OkwdR9O9uEhrdkSpAH2ETDWossaCs+aOMrKvXDjPqZx6SwruLwQPH93MESmKO9HLQLum+F8neov/IKVLefiPCvRjeBbnKL9/FMI9jE92dBNjPxSxK3qkwKPvYTXHdj+Y1u0ai8YMTAuLcB07UB+jEf/gY62oeFc9mf1y5dOfDpy45/m/8bKWcLKFmjva0qPvvDg2Yp0kT4Q7CrXEuh+pI2sni7hQTBa0n8PM3YazIbP5A5GFzbDzEv50MMZir45SRzKfcOoENrRMSBKcXGx/0o7NrxF0mj+yjRn+SxeT5tKFSCzdrOEhQgeppEPTq+D1UPBbb6ddTotiLCsrzdFOP3fACQ+XanX1xQH6MhIvUQ2wdp13dl/HMT7QnA4UwEZOXksi6M6Idpn7aBsejf6yVpuSitWiGmsRW0VtJoO6Y05H/FUiwuwrswYZhidK5atjlyfIMxmXR4BavHDaCI0v7fC/XqrTU0aD4BXkUYyhNqxPz/JevldE7+q6fb4eXIJ+wqDetx67xRAapG+ZU5wYb84a3yLlU21NPz7fyNwXjRy49t4V4cNBYZ1XscsPrsRv2Ze1xDAl/zaTx03qIdEzhcaZx5U1atbxqGDn+G4DxW8sXIb6KusfaZWTh/kGpNaSAl6VwUt28LTodeVO0HZLookjYKPlQLlVeXjJt65Fu2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(83380400001)(66946007)(8676002)(76116006)(1076003)(316002)(4326008)(66476007)(86362001)(66556008)(66446008)(64756008)(91956017)(38070700005)(26005)(44832011)(6486002)(6916009)(38100700002)(54906003)(508600001)(6506007)(5660300002)(122000001)(6512007)(8936002)(9686003)(33716001)(71200400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tGMsuimc7ujpiOEEgpHLTBIctRn2GJ+PhhBkYEb1zsN3qLq5S6uRLGvt1JFX?=
 =?us-ascii?Q?MJ4+cO2qm7XQPOVcD7eHyX5hYW7P++LQvNLrDAsgHt4vtv3MTZoaFOqOYsXB?=
 =?us-ascii?Q?sng+ZL5bqxmHuufdCZNhlqt/ImrGAUydlDyDpQLe/TOerthpg+ySQSXdDBf1?=
 =?us-ascii?Q?WBpGJyxiEZVs3jTcbKjP4yIWTrC3gq9QH0SiS/CP5Ydri/2wPoocHMtcfFAf?=
 =?us-ascii?Q?4HV4uziS43ssWXcGz89Q9Aef7ddTTkMchSZGDrGphUQUmRrtOjmuIeFWd5Yh?=
 =?us-ascii?Q?rDai/odbWX9KubZzeIgqi/tJoLLCcVTZPAK1Zd5MSSIA4cL+NMcZvOAIbl6T?=
 =?us-ascii?Q?ILDDCPEC6PquHALxHFAqiPVSmISS9IXalecKnQezcvhKi3ioq//BE2Ov7Y9I?=
 =?us-ascii?Q?Yo+3h2WXcQHZ1p6mKWzxKMYCZYtvuBCxJvIpmSiue9f52cnIgt03THpln9LL?=
 =?us-ascii?Q?V0U8fkhZTEu2a1XyD8IsMESOEfmmOVJf+VlPou7TW8rcWCcWaIdrqBmBQ5N9?=
 =?us-ascii?Q?Kdw8JtaUCPbwzoJzpGH8q9d7a4JM61gbQetgpPJ+gXVMCaHJTGfKb+rJpJjN?=
 =?us-ascii?Q?nQgayZds/cHnUs6aOaejhbzPPYaK5H1spfoqWLXIOwf15IhMu8dKPvemmyWq?=
 =?us-ascii?Q?yU8/I4kWgwkvYwn+E7F5DXK24drAlQm783RHnPCC2KQnp6U/oAUx/ycAid5B?=
 =?us-ascii?Q?+TjnjuF7q9bLY4282Sjccq/ybItFTnSh3P0PU/iFoqTS/OhkwUxICEGNeC9D?=
 =?us-ascii?Q?/5wUE5UwWcdEgxNdE0blWP80Ckbb3cSFBZmIVASc4nmn0J+LQRpn/RUwfGz5?=
 =?us-ascii?Q?14hpISXi33mJwaUXcmozh6vN/72++2MA8HJdHjWTSHK5hpu7fz29WmfFDn5T?=
 =?us-ascii?Q?GMUThAKacBc9fXNTg1Htes3eHytYDgrbH/fe5Ru2P1wOPxN0I9D5OJ2sAcZN?=
 =?us-ascii?Q?KzcER5gh5pgxzV2Uz1xzCQ0u6BS3NMupeiQejT1xIC7MQ6nGZVb/01YbX30c?=
 =?us-ascii?Q?/GZuivHm9KzTfDmqWUEN2GA8riiCGM39hYch5XYZionW5jniVOwSChS0q5vo?=
 =?us-ascii?Q?WOLzz/Rse8B+telFPUtZG23gWt9zyyjMHSyb2jCDjTkGwsFFzdBtAUWtxTms?=
 =?us-ascii?Q?ns4VstRbwggaELC1kMkbCFq3buCVDvrPriEOt+uws4C3VuP36JNY0xFOJY53?=
 =?us-ascii?Q?VVCR13SJyfkNCf+CpjsdxXKCDJflT37SeYJY1j4laDoCBRiD7eW8hDKlz45g?=
 =?us-ascii?Q?nbNcM9NmlInf3w/3v4Y/56XmJCF8rVi2eQyiAeSCA4Cnb1zXDUL7fQoiLrNa?=
 =?us-ascii?Q?mi1E31ZSP4U65gBejYQj/ZoZC5nv0qA7gD0Fot6K9xclKydCVZFIh3nWX0Wj?=
 =?us-ascii?Q?Ra1JnbBsPMzcnlKlrCYysGhaPS36oxwAFE9pZbYalY4Lfk/QNcNpXpD66txj?=
 =?us-ascii?Q?60hUBm8QOspP1mQD8Ibqh/6qnN2br797HaJSV5mJ++aS10kv+qXqhGJTJKbj?=
 =?us-ascii?Q?bwV1PefC1efbupk3i4HSwFTbxkhREBuX88X4GTZ6UWuANariJ/s1eb89ohFN?=
 =?us-ascii?Q?iivlniLTldcGXTVl+e1T3zDUVSQmTZArkYBl0WC1H7FMc7REoDOg3KvoIcAJ?=
 =?us-ascii?Q?5ryFhuh7SRnhqVPnPBX39Ck=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <05EEBF45F070BD4E9C94459256062359@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a081bd4e-9017-4170-4ebb-08d9b8da7a99
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 17:04:34.7478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: juv9qe85l4C7UgU4IINriCZUU0alvV/hxttMZ5i6ebWm18JfPmKuPQ4Ms9tTegD/Rg5Pm3b1GRtpjRrwBrF+0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 04:03:11PM -0800, Colin Foster wrote:
> I've started venturing down this path, and am already hitting a couple
> bumps... and they're bumps I've hit in the existing driver as well.
> Basically I couldn't use "ocelot_reg_write" before calling
> "dsa_register_switch". That's now a bigger issue with MFD.

By the way, it turns out that the comment above felix_setup() is bogus -
I didn't know at the time what the issue was, and it was solved by
Claudiu through commit b4024c9e5c57 ("felix: Fix initialization of
ioremap resources"). If it helps to move the ocelot_regmap_init() call
to the probe path, sure you can do that now.

> So the first thing I'll probably want to do in drivers/mfd/ocelot-spi
> is reset the device. The current implementation of this uses
> ocelot_field_write with GCB_SOFT_RST_CHIP_RST, and some SYS registers as
> well... I don't think those registers will be needed elsewhere, so can
> be defined and limited to ocelot-mfd-core.
>
> As I'm writing this though... that seems like it might be a good thing.
> ocelot_switch doesn't need to know about reset registers necessarily. If
> there are cases where register addresses need to be shared I'll cross
> that bridge when I get to it... but maybe I'll get lucky.
>
> (Sorry - I'm thinking out loud)

According to my documentation, DEVCPU_GCB triggers a chip-wide soft
reset, and that may affect more IP blocks than just the switching core.
On the other hand, the switching core is all that the NXP parts
integrate, so I wouldn't be able to tell you more than that...
I think it would make sense for you to split the reset sequence into a
part (for DEVCPU_GCB) that is done in the top-level mfd driver, and more
fine-grained ones in places such as your own ocelot->ops->reset()
implementation. Anyway, as mentioned above, this is orthogonal to the
regmap issue. I don't know why I realized just now that this is what
your problem was, sorry.=
