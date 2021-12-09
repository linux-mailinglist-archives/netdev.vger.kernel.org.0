Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067DA46F29F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbhLISA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:00:56 -0500
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:51326
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237566AbhLISA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 13:00:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlffkobDOx/X5VXmAhOF8NiMWXD34iOmXo2HCL1ZuQUjFFdiz86L0NVw4lhNX3tst7wGCxjvcwwIAh0//Fq5+pfOUW+MaKtzh+9UZvrcLYveeMGRoQkcrC1Ag+4RYKSh9VPhXVfa9isD/3rx9jMOy8K6gugN8edntnQE6nVP7Mt6DsGJQS4Hz6QcX9ffFqKOhrCZgiptTriQa4MnGQyfL73uMAPoKLrtmhy3fofqOxpl+vXnGHuL/WYcIu6rPzDkF+XFsCS4ZWqlVtAURkBT4Q9BjukH1fBGBmvNgzkgqLPUEU+NHrjL4Q2pvv6nYzRij/K9byzTzyI7KKE+2Vgd+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKRpTW7kVRa7VmeZ0lzB/un5o4mYMeQp23kfkNGQE1k=;
 b=LhsSYO9QNjNkhJA/FDYbTuzyebY20lU1IM8I4pNFXcF8iVUc/MD18kRRe8dgdENZzdpwXk3LEzACS2Hf9t/WRYvujeTnds0uVlVmIBXZmFY7FE61/VTWr/grm3RpP4kV0h3jab53sJNVQfFIBNEa8urIqWl8PBDB+jx1pqRdQb6n0J+R8uIr9cX0nB2cYR7O6K4VyjXfayZpIRd/lIBBQSWL/9xof+gBPen03/RM0DhOGMD6NU3YxvcTTjuaF76tD5MbXxeekcwrWt1oH9KEpzPZZ8RWj7hIMMMdDPnQyPhCj7pBkr3dZUjzCySXtUpwwdx0mTU8Ui+wouV2Bwq0UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKRpTW7kVRa7VmeZ0lzB/un5o4mYMeQp23kfkNGQE1k=;
 b=HPAbHzoILTGGylsDoIw9vo6XSJmmH1V5hRuNDJYU3dYir1WfJGXzw+fz1p5QH4ZyCtkWZZc3eH2CZYf7aR5ICB6zI7/LZJ6g/MpnfD0Jmr2LMNC56TvvmWiqgE4fp2+++aBnnjJdZp5elwfsMvr4H3rP8q+EBgOJRHnJxH14Eik=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 9 Dec
 2021 17:57:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:57:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Topic: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Index: AQHX7IOEQ9VmgGohuU2xLWeadphC86wpelqAgAC+sQCAAARmAIAALzoAgAADLQCAAAOMAA==
Date:   Thu, 9 Dec 2021 17:57:20 +0000
Message-ID: <20211209175720.cpifrbibghapm7eo@skbuf>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
 <20211209142830.yh3j6gv7kskfif5w@skbuf>
 <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
 <20211209173316.qkm5kuroli7nmtwd@skbuf>
 <61b24089.1c69fb81.c8040.164b@mx.google.com>
In-Reply-To: <61b24089.1c69fb81.c8040.164b@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d44df3c4-b63e-40d7-29be-08d9bb3d58f6
x-ms-traffictypediagnostic: VI1PR04MB6125:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6125459DF791C927FF30B713E0709@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c5i2jpRWEVBxdY1Atyqeg7ATdo7URdc7qIFmJI1Wp42KynyTM08mvKcjnh86053Lg4YdLzyb1fwwAc+j4nSVTMvnqFdaNbVElvRbuEkUt1qMOKx1QjxYkpBoYVPDfWmzNekDgZEyW1lxcNLXavQuzXHHkzqQH2M+5sPW7LGnP6GESgRWXwtv53ahJVRPUjtcsvSmHbgbOAT5AMItp25QebN3NQOI6Sg+JXJM6oyjhpyeiEcnC2rycSyHbnk2eDbd4wN8jI52ZZfvQ2xm2sNAPDLEFGk6RSTigLo86/zTd7dE0KgLJ3UbzadfjCx/x3FGR6PJRFRNCwPjSq+yU6SSRQGG4MRr9X5fleP99PCkGAsc93GJO9uA0+AclVmlY8gfYkJWIwPRxKxGh6v4YQrPxX6OUFWBguihnz0NW7sdTfeT4tmBE5BEBwHsHlPnCkVt8Zz4rK4OX17qjZa7sK7CaW22r0ESV4HIiQlRfq+0OmNumL+J2PlSe/ZQPZ9Ad3wBVlI4mQIKIBRYDN+fqaUSHcuFQNfDUcAkuyG4Aw7YJfIuQveHhHqiiR1K3BhrmV1OmQ9z56y6XssomxwzVXVdKm/RueihWd40HvznIaSi1tQSLpIFVR5LlaS7sSZq6niCNTaCtlAtiEes0/J+eCQQl9VxEs4pEQRbjjtvJ5To2/pPgN9LO2ANkDmhMfrPOz6pQpzB14neePqSaj0ngV36tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(66556008)(6916009)(66946007)(26005)(64756008)(1076003)(8936002)(66476007)(86362001)(38070700005)(6506007)(66446008)(186003)(5660300002)(122000001)(8676002)(4326008)(6512007)(9686003)(38100700002)(558084003)(44832011)(76116006)(508600001)(6486002)(71200400001)(2906002)(54906003)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OJjg4n2a9XpVBnwKo428VuROLQa3mLWFBCwUVqNL5zPiHUOxZT18dKU41M9r?=
 =?us-ascii?Q?578cO2xBh8Al3PG73LkAuiDTSKz89Qaz1I/NV90jzVE3Kg9MllgByEWe4m0T?=
 =?us-ascii?Q?ZxjChVo6LcCc454svHBDr4g+yrtTeT3Seilrxr6VgosynoGS1N3ScqBlWMT/?=
 =?us-ascii?Q?fagSOKyo1WAL6YQ471kqTa4QZM1pbBHqKDOHSPJnxg6nPP0gb650H9BdnWFc?=
 =?us-ascii?Q?E4kMjldmcwvND6aI+WVAGM/8VawICULqpn2AYAQwpDAJngzfnLJ4dbjYF1Dj?=
 =?us-ascii?Q?cjDbcVqEv7SB4XwI+a1T2TLmzS1AQWK1IDJ60lXqgNSHKS0LL0c7S/0HN/m0?=
 =?us-ascii?Q?LWOMTKQaXmvfB4qtt1r5QTyxYVOoxtpFGkXKYElF44lT4xUZeWBKUlKc3dUB?=
 =?us-ascii?Q?zSnZk1Sygf04JLgZBKKIJMKWC9M6dWsumcb007Tffh9C1dyLUcDypoBX94vR?=
 =?us-ascii?Q?Cxc3UkYcBWTVlxWLEXTj/bSCF/PWIaI6gj593QMgQ+hn6WC2TkmNm4mvThiI?=
 =?us-ascii?Q?/XiJeFz8INgUSHE3noeKpvyaEsIbA28S2nQnt2c1tT0PZMeHwqVklKLlGWiM?=
 =?us-ascii?Q?6hNpgfI6kqiglT9DCiYUaz13ycrmI+Op+AQ7O+4IkDCbnfO6dWCQyTv47zjN?=
 =?us-ascii?Q?dKcShtE5eVMJYZDby4A+XjrKVa0RyImyoRGdlBWbTdxEeRSd066N7xbdelSS?=
 =?us-ascii?Q?K+ymncjbQUfWQuY4kYakGHN8oD5aOivBPvW8xhp3ICOJ5T/DP/LWBWsgOXVF?=
 =?us-ascii?Q?yyWzkuJ/oFxzMNwwDp/VMbZN+6xYXG6xrewdxG0R6a+JrAZw+V584QcuRMKC?=
 =?us-ascii?Q?Q+5g3rVNn1JsOZ/YzfUHpDRuXjQoKtdQ9vtqa0Ilf7ifLP8kkp5mEwkEqDGc?=
 =?us-ascii?Q?ygGFGVvO5dAwZCKjovrWP65pJpSMaYyTP4NZfx4qJICsxDc3xp7GFZXFfGsA?=
 =?us-ascii?Q?Vul2aCCvPfqkwiR9/ZHD7aQ0ss9WEKMnz/AiFeeb6c3h2nQosEKew9hBeRyu?=
 =?us-ascii?Q?E8Pef2szyKCTyyPbiF3+Qq+DOcihEUJ6K40qs1+dLMb/3nDR0tkh0Qhqd8TF?=
 =?us-ascii?Q?k5K08eN2HYOIBgmxv+er/HJ9JR33CzgE+9bpu26WL1/ECSC9tX6X34rQYWL/?=
 =?us-ascii?Q?VXwJzz570Sp28BuOx5B9m8mLT6dizWCRlBBIS/37VdJvlXcDR74E+ab17qZr?=
 =?us-ascii?Q?ahoazZh8pK79tUGfbBsssCf7KnuhAPbFTpVJH6L3tFWfjBRYly3m/LO6BJDK?=
 =?us-ascii?Q?7lXPdAt7O7DQZbzf8v7C7doPIfSQBfmOQZstSKrIAqxuPW/onwUxVm39KsZS?=
 =?us-ascii?Q?qJqdwWu9u7wLs2L2QO7qY0QBFuKu+Sci5BX6PJWKWFnYrMCzlMH/Q4q8E9nP?=
 =?us-ascii?Q?2VoGyLr4A26YmgPSa3b1ccxNlT/tFq7oHy5xPDVV6whG0bTAi2SNLruBP+HS?=
 =?us-ascii?Q?Tf/EF41W6XjBAnxHht8tolhYInIL20Q85JL27J5sQOwfqqJOiRQ16vsrYz1s?=
 =?us-ascii?Q?tQEcPrH0VOAaXbU0zFiJeLbaGZ5jKmQF3M6Jl4dplqQ8y517vALAEoy3+m+a?=
 =?us-ascii?Q?Q2Ra8uszZMU4mtgnma22BUoEh5erwdoEzpW0pkGY/zQDYLoq40dBlH+fiost?=
 =?us-ascii?Q?MeRpl4HgnhTQ7kbjaG8zC5c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C236EE9F9DBCEA44B4FFD4EC71263AFC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44df3c4-b63e-40d7-29be-08d9bb3d58f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 17:57:20.8312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I7vD3LszRiupw5qAIfIokbhb2iybQ726mfUkmJ8Myh34YV0arOVhEp297Sy293l2SoTKzBhAPXpGJ2vdeWAj2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:44:38PM +0100, Ansuel Smith wrote:
> Ok will send a pcap. Any preferred way to send it?

Email attachment should be fine.=
