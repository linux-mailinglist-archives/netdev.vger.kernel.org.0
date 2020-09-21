Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58FF27327F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgIUTKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:10:13 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:34912
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727197AbgIUTKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 15:10:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJknqztpojcxySogxoMOpaO/5Zzc9UUM0actFJxTOkqDv/5EvyWC1gDxEx14SGYMMzrDbTqFYb3CxS2D29vfR+tW4xRHWd8wCI7VoEfXr+ZHRB0fcahAsWeCuCOY8rzZu+REe13XPHc3n3FsVTgttxzDgUNV0ENHMmDbjmXflaTjxMEgiOUp++bV79qdl7/ct0yRhigTurb3f8O2C/4/WybpRYrAhKh8WP0HyUT/omQ9SZvSHKeJhN3VJHDreHxAWYpQy2gUEJrwoFp4BjxEq14/6vrXhtxy3NbP30qpif+rhoqTgmtIkTjQobIHm8nxhIt6JAfldkL8JRrkWpek7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV+mdgg1pvCc6whtK0ozhPhkqgoZoh6aqv7DxQo45k0=;
 b=NLbcl8lSBwNatjrMdic1Yjq/K6LQW1wGHjrZUhK9Wcb7+jczsGveADNZDcxniGxvzAMuuEaLzoMqETpM6BmemtKeWss10HDE6GR6LaLyylVUNd4tnzI0AKSUwmEdx2aWolShommFPIuLbU6hBlnBeeDZgqLNFPGkBNnkV5PIoTnKz99nWiobyntgm8fIVztIWZJb4PeG4aRbN0vVPxrbYp7Rkj4YmKg6EQoYj5rt+5aTBcslixAjd/nnqfZiDRwhgEyq613HYREqKUSm7BofPCIYvInWYsRg+P7ePqo2dEhZ1q8dN/+S4/DaaJUNAfwyjdw8Xi7RapSkzJDHBZzpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV+mdgg1pvCc6whtK0ozhPhkqgoZoh6aqv7DxQo45k0=;
 b=A21+AhDzj0Wy94NMZPMnWrowbsJEgCY4MM7Gi64zScrL7Si4V3XbZtIRfaNR2YmIs+Qv7IgMHQnpx/n8WQRgMTD7ocNNpsbqR8vriMemYqBV8/kY7+f95oBm/8N3+Yrob8PXaEeeJe5pu02mYqhEIbXq2qVO8auvlbh3HwJuhyk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4687.eurprd04.prod.outlook.com (2603:10a6:803:72::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 19:10:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 19:10:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Topic: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Index: AQHWkDQ9QATQ1ChqX0Swkc7eW6HAIqlzVGAAgAAQswCAAAkMgIAABT6AgAAB3gA=
Date:   Mon, 21 Sep 2020 19:10:09 +0000
Message-ID: <20200921191008.urnhrb4iuk5hmzer@skbuf>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
 <20200921171232.GF3717417@lunn.ch> <20200921181218.7jui54ca3lywj4c2@skbuf>
 <df33c443-6a4c-537d-5c06-8e984ab3e0c7@gmail.com>
 <20200921190327.GG3717417@lunn.ch>
In-Reply-To: <20200921190327.GG3717417@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: db756f96-b1a1-41d7-0188-08d85e61f552
x-ms-traffictypediagnostic: VI1PR04MB4687:
x-microsoft-antispam-prvs: <VI1PR04MB46871ACCA3ECDEB6C6B60816E03A0@VI1PR04MB4687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FVkxgogODJEL0R15jF/TVNbbYA8DU88lHqDEo2HZ09zfDAgCXsfX3oM9mB0EzcPQ6wCKP1q9LWdOSrfZkDqNAEHQSj/P6orsTDLTjpq1svqTV5C9syLu3GgKXFPZNeN/qmnuq2P792cyvdeyI1bDTy6xtENQbbIbahp/HoFkay9bdkmL+zxT1JBcjOddqG6xWgMj/TNUeaPlW97IXXq8Zj7XbGJjUEbeYQAxosu+pbaidV5aTl2Iwm1EiDjY816jGVob4Z9UO6nlRmf0bL8VbLhujAhukWUiz7YQ/8RkoF9C60gxZv1TQsHhL2/VseVTjsi5xNqCWbnPjy6iatqQtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(6506007)(316002)(2906002)(44832011)(1076003)(54906003)(6512007)(478600001)(9686003)(86362001)(6916009)(5660300002)(8936002)(83380400001)(66446008)(64756008)(66556008)(66476007)(8676002)(186003)(558084003)(4326008)(66946007)(71200400001)(33716001)(76116006)(6486002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: K0uzVliXdnLHs3IVGlQwIpipYRq2BqHd5bro7uHRohOdtTmKFX6cu9AEJgXHWP+r364rf0XvZnzeSzTOzcIY+s46lQkrCSlkqy48jHOiqtxoE75OYMGCal7k1p53eim9N0/L0n6vjDtXTCOwEQ+uLKZ8l1i1wS/2/EghWaMRDeMLiUaT7Ve2IJ4kv63Lcy9M3EwxRZ+K51oVJ2usLdIH/U1XimaNeWUTjA0VYIn0kgRvrA8nmqO+QehJeUi1iLWTI+/PrMoV2bilt+AGxcXa7aeXGZfdkttmEHFDTUWtVXQaTvqtwosAxmhM+xlCUHamN7TjXeoA/BJAwMefQ+JX4Hpd8UT/ijLZFrPXw9uD1XRP4j08iM2jSxsSd8CYSKEBGX57bJz0qEXU0AH+wpTGY52cIrj8IHMaC8r17/GAlXAU6OepZlIabqGfzTtIH+HGOHmy9YGGIhXpORgx85H9Bx/ZuW0L+BwQgCGMZHme5IWJsLs26aDQgJbr/9oNTA8Pf/nLdReyd05FnA4s9vFenegDprR/WfoEYnkld8P9s8/LwbbHGd32H62JI3Y6V2mcugiC1bZDnRNyyUmeB9ZsWX2Y08yv+mcqodB20gy4dmaj48xfYx/ziUJJrqLO2jXCeNpjWqS78sfS0E3VV9krqg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D67205F901E0A478F68FD814C507B22@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db756f96-b1a1-41d7-0188-08d85e61f552
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 19:10:09.2146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bk5aAi82E2Ubxv7lsE88SXCm0C7k6izcXQNbP9z8JLtQcbKwLJ7o5U9LyLFLxtSjlBq6B02YyOWvyAaytwGfQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:03:27PM +0200, Andrew Lunn wrote:
> Vladimir, could you implement the devlink DEVLINK_CMD_INFO_GET request
> so we know what sort of device is exporting the regions, and hence
> which pretty printers are relevant.

Should I do that in this series or separately?=
