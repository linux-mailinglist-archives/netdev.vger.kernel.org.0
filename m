Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8246BD06
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhLGN7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:59:39 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:52382
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231280AbhLGN7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 08:59:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsGNVEEgZoZRFv8MFpYuMTHCNt73ILcdqBOaYU9oQdITxuUmIeh5dKOLPpPjaOPXsQftnlVPTEKeRxrFsv0fjmrz1nGlT78PsaoP1HR67cVlEnz4/lMs9QlVBlS4X3P/01NjjZRO1c2VFQMoUSgyZPh4tVi23FztLChcGEa3RXdB2l2xUFxnUbShi3GlzTRS4yEQA2XqTuDtXTr5qggxTpKM8EkldHCUe9SawCTwaU+Cowf4zvwFEYb1v4VwF9yIPdYJFbw11TkJSdwk41PrIqJPx1RnU9pHw9kIIbSBVf8hBHCatxYPAYkxHZ/GvimpNebK6MhVOraWZyGwwDpxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aGu+U+Z+ETLCk6ssqvuYMEKCc4vrWwb6B3uvWvZNEo=;
 b=dQ3F2zo1QwihkWV2sS+MIHFn56PQYsHTxLVjpb5zHZbMDrKjzpy7CzU1naZZl82hS9YTXRuKe61FT2I8bXnV3eg2lsFIWTMxVumNAZz0RtEbMKIP+y20/XPiEcDJBgkiiRCcPAU5eBOc0s/Guh/F9wcH38GNWfqbJOE9bpYRQOlWow7D/fsTOsefxtB80ecVA6wXCyd54rQmPj81gqly/vrdxywxmuZtbXR/GXy9qE7NOwo+DFzUsqK64zykp09FjU68STMObAuXgCGt/oUb36Qt8qV8ipjxIEEP1CV4JCBI40O5h5vnScxAcQUv22HCh01Ljt9uCM4HMNC+WQR41Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aGu+U+Z+ETLCk6ssqvuYMEKCc4vrWwb6B3uvWvZNEo=;
 b=fup/FmwMjSgKaExKEAUaRUiq/0jcK3V3nPVT1bWMJUOBgfjCHPmoe87CBecBo+MBcCtw3dxt/6nTgrFVVXvz7r/ixbMfpdN/rlikvebyz7GptaOUQlLpur5P9xJmWdtb+1GBBABJmeFbe78ktNoqaezDUKcqLUOmRPXi0MvyBIU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 13:56:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 13:56:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Yihao Han <hanyihao@vivo.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@vivo.com" <kernel@vivo.com>
Subject: Re: [PATCH] net: dsa: felix: use kmemdup() to replace kmalloc +
 memcpy
Thread-Topic: [PATCH] net: dsa: felix: use kmemdup() to replace kmalloc +
 memcpy
Thread-Index: AQHX6zXq4OZrHAZCPk65DiqXCDQSK6wnDeyA
Date:   Tue, 7 Dec 2021 13:56:04 +0000
Message-ID: <20211207135603.oluwulx3o32xlzih@skbuf>
References: <20211207064419.38632-1-hanyihao@vivo.com>
In-Reply-To: <20211207064419.38632-1-hanyihao@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4c12049-8c27-41e5-1664-08d9b9894f8e
x-ms-traffictypediagnostic: VI1PR0402MB3406:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3406957E03730FCDC570265FE06E9@VI1PR0402MB3406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SPu5kFVJ+vGTtvhhmup+7Eb9azQn0FzYUoL7NjWdgk03DRJez4Z+hUB7WYDJlpCdS4w3XokiSzVS/DI7VsYBcmzQwQk/AXgB1t7Meno3mS+8TnWwlg6V6/CEBlu5pAM0OqphQhAeGMG60vJCsNBPcOp8WhYIDmIMCBWeT/eCDzHR9W/r/6cfCvMUSICz36UjRnfpcoHZ6Sx5DZf9ioqEIGiuLQ6IKST043x8uMj8xDkb+SGcKpC2HYV29z4Yu7oSjySWy+Ot+cYlqjmaZK3BBHFRjjeth382hrHkGZxBcRC1+D4wnOiiGTWeJaohguob3OF8mdEGfG8z/6kUHvMAALzogvB4QTjDd/dr47hoyUSw2+U2WEswduz69EXEJldkDov2o7hRFzZoGwZhdcfJw4t558SjMT1FZhDsoeu+TvB63dSiVJ7zqMf4zn5ZhkqyH1UUpnvqPAIK01haZrWNEPsAAm5RgkPRWNt/YHIPPRUteu4eORzvoQDH5dVfS9iTmglKFaOaZch8xekSyzKgux425L7L451nUXgTYMmqH5mXQWtknPzmKiKJxv49AJMz/Aj6azdDTmaOEGyBfVLWLdfVwRzxUt+myssvHJvntKWf59AUBIbfLuIACaNgf0TIWa/VoqSWzCZSzLaqjDGfKe6BcAlRlEGm8ParIQCTBjhv7v0YDAJtab8KoJQkOwLeH2R7dbDdBbbc3tOBCMotkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(66446008)(64756008)(33716001)(66556008)(66476007)(9686003)(38100700002)(316002)(6916009)(76116006)(1076003)(6486002)(8676002)(91956017)(508600001)(4744005)(66946007)(6512007)(71200400001)(7416002)(2906002)(86362001)(6506007)(38070700005)(5660300002)(4326008)(83380400001)(186003)(54906003)(8936002)(26005)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g4YozD6GfaNcHIgRJwQBCX5U0ZV4661Hk9UhJ9P+L+2ItX3lhw+p/6FSaD8t?=
 =?us-ascii?Q?k+2j3XOlggLoDsiI4YAbd3o9R5+WQN4KbX9kELABg7WS+e6mj413iegvvUQY?=
 =?us-ascii?Q?rlUJzbwCFx+YqHZXrvR4htyH6d45c56OIqWmM5YAmeJlCf5ATaIGQufWAKdj?=
 =?us-ascii?Q?/RNsiOrJ2hOlkVYk6pIqRgV9X2aaJJK4o1vlvAXyudp/Uq6TJu2JytHBKuR3?=
 =?us-ascii?Q?u+zrAxpWoE55fj0FdZf78J6SsSO2IZDMizUNt6AiwNLMF6DuhtPl+BOVL76O?=
 =?us-ascii?Q?vQ4519p179iWOiS6AdQStMhMP2WjkuFukgeCBUfYyH4vdWvmhtG5qKjGNqsc?=
 =?us-ascii?Q?8E2RRTbL9wLVqF9giPB3KErHsiJnCnwmxBXSA2Oa3ybJB5P4kROOsc8QT3Gj?=
 =?us-ascii?Q?Vi4J7ZWOshRW95HaWwbS/GKBOKtJbJLsW2gWwFHuRL3KjVMdq2DZRuBPf9Em?=
 =?us-ascii?Q?mrEsRPLKrTHHANcNa3vlZ6Nf/eLAomJ+3fbOtX3rzw4sJZad4Tt4voKWLI9g?=
 =?us-ascii?Q?C4VzQiBmH5ApoKMtcC/fcp6Np2XPg4C0jO/mV+JbPZ3mWkhEcDEmJwwbMFqY?=
 =?us-ascii?Q?XjnRw3jZCPu+B4S/61/ooD9UW1wAK2EpMd/mroA3kGiNrK70JjDcWIaIUTcj?=
 =?us-ascii?Q?NpQgUyFJnaJ1Fc6wmxGVTjpd3gqQU/HIoDMyOaOiY/gWogindY+90KnqgNFc?=
 =?us-ascii?Q?Lj6jntnD6zqWTuo85TTskfIrYCW06MSSbACaLj3niemiz/r/6b4Jqjr2NdfO?=
 =?us-ascii?Q?422zsS7jxAinCxRA/MBIoc6mQ1OB7Ti2ve69uHvZ34zKvxu/HR6xvGPdw/d+?=
 =?us-ascii?Q?OZenqB8AkP4ZHP9/FSIGTXeTgkO0DoPYbLhVax91RFhq7i3IY7s6Fy8FLK2S?=
 =?us-ascii?Q?RR50ZYWgFErAIfIC2CfErJpbY4avnAGKuCcXLnrzXJxt57oJmdJtpKTQdFX1?=
 =?us-ascii?Q?VIRUMFGhTeqnHJQYiQ0FNofDNuWD/YLleVdnThSXZWvPk7FXhLZxB9Tj9Fwl?=
 =?us-ascii?Q?O1dph1A638p2RcVwTlZ+ld8U6uOjJi5eggstYvtONGLilBWgRAmc2ANiflIp?=
 =?us-ascii?Q?BIYPCNm2105Jki2UT/PSGFR8jCcT0UVTZgKuLO8LF/t/zoLOTbRAAp/p84t+?=
 =?us-ascii?Q?VQFWFUNYZypYUZJS5deBxTbmaWrxDxOuKh7gaXftC9gBjaW4fJtobqEWg+L/?=
 =?us-ascii?Q?jiwkVRwJ+S9FMh1+tHizupAxcCPyCHUUFAy88WHIeu1lYdzoII2jUtcEd9ah?=
 =?us-ascii?Q?bif9PP3dOYD3jiLrCXWlXpg3dpXaqxR24lC2SJoGzyJVdEfZ5xiwHh0Bs+z6?=
 =?us-ascii?Q?+HspkV5lQvtDvYPIuJ93pykn+tWkW91YG3piltm2SMxjBILQYsuFzpejp0/R?=
 =?us-ascii?Q?103dTQkOxxHcGGQt/8b313KgVsYUFPHARIb8JFroIj0PfqwU8I28bKpo5mUj?=
 =?us-ascii?Q?Dfr3Md0602f5fqef7L1ExXaHYO6vxucM+cnRaRuqiOVzs+flJoys3wApmDkh?=
 =?us-ascii?Q?3tu6U7vdMpsebM03zKBOh7KbSbTmpUDCs3wP9tZ/4xLEz3f5TqPmeXEEdsNx?=
 =?us-ascii?Q?FNZiJnNICEHUlmP2qzkMBWfCSpHrBr8kV4ociYwruqnJsP4DRwz3un8QWLTk?=
 =?us-ascii?Q?NrZgDWuToh2Oz+sWqR+p/so=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69106F89798A40419866689F2637BF2A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c12049-8c27-41e5-1664-08d9b9894f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 13:56:04.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s39On9Efrx3LY2bSJoSs3MmUrs1MxWymXGbY860EftEsy8GiTJQhFmYIBFwbxmRImKmlqG/aWyLiXsZTEZp4EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:44:18PM -0800, Yihao Han wrote:
> Fix following coccicheck warning:
> /drivers/net/dsa/ocelot/felix_vsc9959.c:1627:13-20:
> WARNING opportunity for kmemdup
> /drivers/net/dsa/ocelot/felix_vsc9959.c:1506:16-23:
> WARNING opportunity for kmemdup
>=20
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
