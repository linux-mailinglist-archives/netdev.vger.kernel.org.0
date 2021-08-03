Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9859D3DF689
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhHCUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:43:46 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:5249
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230290AbhHCUno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 16:43:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVlKwnl54Ah2Cp7w3VpP1Zb+GHFxHeUV6RxjZTm0cDOu0FSHjGvtntnVekK/fLBvyROgTHel8ruBhr6+NjfGOaMEgLmmjez9QZlH6kB1TXlQ1drx5VmyqRN7Vm9R1IG3XY36B1Lbk51larfr38tGeSGcKANjk46NP6JEhagidgA0MoWM4yq9J7ObseejI0PalDdhzBpSyTg9O4IsDgzxa/YO+M2QbAp6wvCB/orxkJzpKzpzSZW5KihvQBtcPgrXPShe2CzRLPi+3N9MUPMyiD5my46GpNKeb3npoLbbwD4aImKJTXQI1BqGL2wqAxOLWOZ9Zii6hn1z3wJAdY1cXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naiLnK5Z8Oi+Ea1QkJfEpIzr9B1/OLmKcdpkiIqCX8E=;
 b=lDcTd45Vz5y6J87MPkoL6itIjjpgzjeyOKisBOTmGr/mylNHzlwaJGs7iDs7R1RjGAJIOGCMcqz/l3mFwQ8FVsd8Vv5f1sRYcU4OhV1EXOd1188YYggGwKjq82TncZvaAW+FHoTvo5tuTgJLWwWUCKYdXKhoUhU8PSM2SOibH6X0IMqu76n68GVO9el9UXMIkXL9yHcP2XhPii2lo+7WJU4N64w9IwEQLSLEPBKDuyHEJ/yjaf1x1e8TceG8jtBPBZm7dmYFoP++JUVby/X3IoJ+EZyg3Mes5UBmH062/ioqsNUqkauuhugw8IrA7NCiLM4jm2yf42TugfhM++WrSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naiLnK5Z8Oi+Ea1QkJfEpIzr9B1/OLmKcdpkiIqCX8E=;
 b=ULzfQzbIjDTJmuwYSshczugyMyO0FA7c4WaXprZuMrIG+Tg+Bof4r9AjtZ5VTrDT1UAwOq4KxA3NjOD8rrzOpNbTWKIl92yoxUnW3Sj/rKXXWjdVqsoCu6VNcuOBIR1q/rMhsStBZQZnIx/EaA9lWgwhmMtUxMZzqZJV/PN8W6I=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4562.eurprd04.prod.outlook.com (2603:10a6:208:72::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 20:43:30 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 20:43:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] Convert
 switchdev_bridge_port_{,un}offload to notifiers
Thread-Topic: [PATCH v2 net-next 0/2] Convert
 switchdev_bridge_port_{,un}offload to notifiers
Thread-Index: AQHXiKbyhpFkUdec2Uq1lsCmG7pc1atiPyCA
Date:   Tue, 3 Aug 2021 20:43:30 +0000
Message-ID: <20210803204329.534dpqxrlk64kqqi@skbuf>
References: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a4088e8-3676-4c06-ac89-08d956bf5aa1
x-ms-traffictypediagnostic: AM0PR04MB4562:
x-microsoft-antispam-prvs: <AM0PR04MB45625C7482EEDD92265AB4F8E0F09@AM0PR04MB4562.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JeS3yoGJUqj/dmXhDDXxlQiqf5T4e/P6eJjBpz9ulVDPOpBNnv10jAE+RnXs6tmf5i/cun3ODizJzorO940U0DUbWw3l8M65ZjsjHWAGcAPUVEXrpVMkxxPGSXwog0RElcN7lEqYD9GhQSMSAcZ7PxuKUQtz4aE9daPjGGNjCTaOGckq4nVitpktVepslulA15Mk/ipONnlwe+A53PxVxy4dSxXlgNPV8D2CECMxTrPAjEIfZYzCx6pGhjWzz03c8vjrLDHk0U3Jge5wgzGpJ03gU4oqE0HNG68Tzb2TtQU4YOtZSZ70Disbm/WUTh3ek/60UtvWYeVGHCHylkESdl5vp5C6M0Yo3q7H05A5s0ffkqcn3HgYpym1QD0H26tz+OlvroeDIdT8YCeX3goyGi18mNV6RCluMUkBgklNxLx7i0xF0z+ad+rpVQHYzYxgd1Esyz4oOEUk2dcjmLhQntx6VrOtXUJyPUt5BapbaHHUqMyg3TS9RK0NH1OODfwpdJJECi0yGZCTPVmR0n84wvPpfDDUyPPjnGzVGMSJ+ccq9ok8zf5G1nPVWOkrpd3GSLKC0ONB3PmSkj+su/i+MsbPN/DC9r0b6Q8xHlmEpuWCdnDIc0K/dt65eZjZWl1Uhky1wEV6fl0J8JdzN8OrTi1WvuRy8qAzU06YiR4ehaprZ42J2+zbQ6rVL3fNEnWSS+3JFzLS8x8h/zT2z4rZkeUYw9inxB85MhyJWAuPUJX910G3QzNweNLC96K2NUmvKY496EOvhjotyjgpgSCv9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(64756008)(122000001)(66446008)(76116006)(38100700002)(4326008)(71200400001)(2906002)(7416002)(5660300002)(44832011)(6486002)(66946007)(6512007)(9686003)(1076003)(8676002)(316002)(66476007)(66556008)(186003)(38070700005)(8936002)(508600001)(26005)(110136005)(54906003)(558084003)(966005)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?INlxL6WsJWpMyh/u9Nb/fdYHJbjll1bcCPwuI9HECePQSiwSH0lk6Ei+ZlxS?=
 =?us-ascii?Q?PZLDLONwiIT/b7GcM1hYiEMeWjaByOaOgUyMW2OiQ5gsAykLgKN2a8+Unaix?=
 =?us-ascii?Q?qy5MoINHSmmgurfB/Ltw65+n9kLQ8YBCREcEGwjT7PmCHZFKliRqihdHEuLV?=
 =?us-ascii?Q?QMtvtBPbI8fKN7qTva9u3AjY+wXZs5R1nQZPe8V2NEhp3DaKEY2rKPcpchb4?=
 =?us-ascii?Q?UZOs5tnkzeaE9i3Lw6xxLAoaT95eiUs1VvhClJoMs05e3ZfTj8Qa7t60pZf8?=
 =?us-ascii?Q?2LYvxOp50eTwJVCJnfljf3RhuG/0mXFmVgU4OhIKSsP2SXDnBSCQTmKgeDqi?=
 =?us-ascii?Q?n2xmgzKg/FNGslxKV/WIps8MlPk5+44x0FH2x/YU9rhRDBl/OBlVTMBBN3vm?=
 =?us-ascii?Q?GeYAk4Xpxtczs+gZNg23Sa3YCBmKqbMWjfhb2LTmCkiGpkZJmuz28V7Dt6Ku?=
 =?us-ascii?Q?U450umchSyoCVn5hZJGCCNGJPYeVC8wepBsK7Pu8RkcWIW8uO97FCQp9y0Tm?=
 =?us-ascii?Q?FLHcp/uuoPd79vd6SIc7oRTeqfoS2+CQ0wUY2C/6Ic1r3iKY5DkDhaPY4kyf?=
 =?us-ascii?Q?4FITcMR7N8UYe86X2xmjdKwsqt8+tMY4C2B6dc88dlfviL1N7UvV7WFGb8Rf?=
 =?us-ascii?Q?WTrXWuAxKtnJCkI6NEU2bEfUonm+I/nuWcWeOqaTn37J/xx4+JQ8nIzYiotb?=
 =?us-ascii?Q?yMiPdYm4up1j4L0Capm605nr+ycCfJEZuU2y3RJI7btJdf9JXdAS+jEVOgHm?=
 =?us-ascii?Q?6OFAdidSBM55kGurWlXaiftnSJC8bao/CZrwc2uAn8qFMWnMUKo1U2vvEEsr?=
 =?us-ascii?Q?l6sXjTRUAxWme/0D3+Ae9sHb7IwAvHEBw17PjeE5jrYL44cdQMMMLachHIzk?=
 =?us-ascii?Q?/5aTI3zDjRWbCr3qTJMTxGp/gndu3ASpjgQ4zFOHe1q/migeCHPpJEaDEhT0?=
 =?us-ascii?Q?UUUnT3vUPe4qTBs7ziEXlKybom6/SF4fbvaWYUpsl6p0iUV32J49arh2wCjh?=
 =?us-ascii?Q?GduLgfa4r6mFnalAhzoqElsJfdreTTDVYmZXenyw960Y1xCJHroqC/4ZszkY?=
 =?us-ascii?Q?MlkSQdWLUbaDNSnradwjEI6ZmGwJGYiEV/86uwDXwZqBMadN6ONeb57uucWw?=
 =?us-ascii?Q?gtzSNQRO0RIkUBIgRb5CUxmczLUaHpZ50vVGVIM8gU9pX8ql1M2IbbBEoE+c?=
 =?us-ascii?Q?nj1VkVdblhhvgPuMpZph9ji5VmFMga4YPG+Eh88IW0zYMUG+dSoW6zRl/7Lh?=
 =?us-ascii?Q?VUYGiezUOueDhT97YF08Pc6juVjyqma4bdNFa63YF9DGsyGyDjBWs/+Zvr/H?=
 =?us-ascii?Q?EVuFiW2tP/df//3J/bOvTLjh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A898D30362C4784185316C9888DBA9D7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4088e8-3676-4c06-ac89-08d956bf5aa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 20:43:30.7343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CE8GepLc9XmXVfWtxyMWDfVl8xgIzxY+7tytmZpATX0mb+btF9HF+HYe7bTVCQ9DdcSK8sb+B/UQiDLJH/XzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obsoleted by v2:
https://patchwork.kernel.org/project/netdevbpf/cover/20210803203409.1274807=
-1-vladimir.oltean@nxp.com/=
