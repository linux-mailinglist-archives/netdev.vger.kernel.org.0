Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D429A461AB2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhK2PWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:22:23 -0500
Received: from mail-am6eur05on2052.outbound.protection.outlook.com ([40.107.22.52]:5600
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229441AbhK2PUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 10:20:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i435ffxsRpt80SMqgmCMFBw1QNUWkO95jkBCu7CU8iX/Jhp9G8ygic1EU/P6phufOLBz4AeB+ThIaOS9hWA4XYFYLPmo0fd0kCCZuxSUqtKjxGpFn8LjAuLlzLRRlsZlNNcepruSZ6RywG7E0K+4YH8zw6nvn8xucPu5KNPpMk2jubkBnucPrlvulqk3Eq6QBa3hdK/dsesO5jME8NV8+RHAnoOSjQRVvrj4mUlL8pN0iqeFlYippCziCuBc7dtS+bqfo46N/76BJc5i1dGd9VK/lDnUVx8Fw5fDfW71KBzRO8BmX16AWhgVtLae8OFb6TvyLw7z505RNRozZzNkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp37rV28GGAWqMHd4tJLjrMAWYqON0m4Qg0ZzxV5sbQ=;
 b=KtXIvouJsOUJbuKDX7UICHZJQGKVULX5FX9sl6VyO2UhCeWvDWOoUZx3yq8VnRb4+AOxlir8ToNli9GBvF5BabdWDHyf5g/9D1fnIQ8SVvvfKAaQgzbY+f3XPbFJITmEQ5ttDLwxQLpcHjl1V/+RA0ootCO4LiIQUClQDtjvYNJ0Eker28z+i5nJlza4+K9bbq7LwPMeFhc1K61pZHkUQFOJHqITb0eaxNIvHzydS2H9VIDBF6VQwG/ARKGxOSkkNmkg1GJeVQtOG/bdKixOXwTM+7mlvCexMsYBx0TMni6Z1T8saHHWI9ItvMw2+uzVuj3QsfwtgyWiFC3SBHvkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp37rV28GGAWqMHd4tJLjrMAWYqON0m4Qg0ZzxV5sbQ=;
 b=CQz4frjzfzh0/8wfwt7iE+M4ASON/CDOa81FYG1xVGU/xXv+ciOziS905nfNm83oszB9B6q/6b11vOPO1brIl1pe3PcwRc1BwjLRaBOIi5v199H6L4mjDpgyLv9KYQD57VgSnvON4cemtdH5u02SgmBONioqt+E8kvWMm/XT+Hw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 15:17:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 15:17:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix missing unlock on error
 in ocelot_hwstamp_set()
Thread-Topic: [PATCH net-next] net: mscc: ocelot: fix missing unlock on error
 in ocelot_hwstamp_set()
Thread-Index: AQHX5TJVP7iE//hxUEyluc5NJq2aW6wane0A
Date:   Mon, 29 Nov 2021 15:17:02 +0000
Message-ID: <20211129151702.5sx4xfsl6khhal67@skbuf>
References: <20211129151652.1165433-1-weiyongjun1@huawei.com>
In-Reply-To: <20211129151652.1165433-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7e3270e-f8c0-4efa-0682-08d9b34b4c19
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB550150116FF3223A64BFBF53E0669@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: izP2PiQEXcqXhIp87ZYKte7xHUnTpuRUTHfbqyIVXEXMexY5GSYzKKBvcJ/z8D4z6yE3lD8ZJjzlaVv0qdLIEnJNm6P4cCetsF0BmB9SoO2qqEQYazolNdhix+txv/2BM2FJQAUrnFH59ilJWpBaOgZVB7fy2WIK87+PVSI2EkGX8ERKdONvXLteprwdprEQQ41Nd/WWhrSQ/yu+rjKmCZoCULN1gPRyR1qd1OPweQvLZKuBgTDAMEwVA4ZdqRpkrkobbntL9Xej+ts8aWjdwJCpiBEAtXq9URVDE+0SbVHXl00VDcc0hF7y+nPgZwqKB9gZMwgOZzqEG9qRE+zR5k3Q11SDnjf9HP2KJE6tbCED61nVN29EUxr6P38v0z4ysenxlG7LYsupYxk6wuDElyF3OW97hnm5Ogvc0/2W9AMdxsGDSiC85jLng8SgnpWhjI8ZDHobfmc6oWxdRwtTJCG5p1U6XofaOZihlgm0Xyt5ov13lG+2GkK19HEIhklqDHw67ZXu5vdqT6WQhkRUTE/t6ay/PhdMewT7rA5xTxotvrVkAjV0gN9AoDp56bajKzHE/hH26GVqN0Aw/7N0OrMx0ztcVnonlCO3aTY3ALhs80OjGNh59pS13FuQC1R5xRd0SnRYY4sdrUeSK/t56kBW65/yCu1DXyPMuNFwFmHBYrid5Oi3CytsHt/oyjmFfLG3/xSKrde/pllfZTPpdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(186003)(71200400001)(91956017)(76116006)(6486002)(66476007)(66556008)(9686003)(6512007)(64756008)(86362001)(33716001)(5660300002)(66946007)(66446008)(38070700005)(26005)(54906003)(1076003)(122000001)(4326008)(6506007)(83380400001)(6916009)(508600001)(8936002)(316002)(44832011)(2906002)(4744005)(38100700002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q2uxbUnwa/6Nc3IZ+7MKDc97BRQ0AFPIMNZI1gV/veEzSUbK2YWQtk+RPfgx?=
 =?us-ascii?Q?dis7VLeL8n21xSOdiGkZuXPiS1z7YD0u9bG0sYRMzEoGP64csPRbONlZSi83?=
 =?us-ascii?Q?Gj7dzCfuwWcBlEGoMKVomiomWxwk4Jq/XpLaFFUlzsyA0x6QZDAq5ckWUMbB?=
 =?us-ascii?Q?8lcJVlGaazHcbKSVNHw+DFW0O1gQUl1qrhnIYpU8RSxczInA4EkYxMFlh9zE?=
 =?us-ascii?Q?8hGHEkDe1asfwuXhWFVQiAa2qGpB1dvxGqkFiG+3HrMHq8ZsytYxvBLSe1Yl?=
 =?us-ascii?Q?2FfeLF1BCPCq6YOwasV6rU+kuSCbn5FzVxMog+OuSv+Pu7zbv5DI0qssKQSF?=
 =?us-ascii?Q?lLLn5eX8/DnlHwMpicCbhP0PXL1HRpF36tL9eA6NhcvvokThs6h0OrTlDTgd?=
 =?us-ascii?Q?QSavzDpHF0bwwBL7TIc2nKBJ2IPv6UNcV54ZfEKkY+M3AI+wIalQVUDT3rq+?=
 =?us-ascii?Q?M9/bf58u1iewknWGVUb1YBPFWGEbcsY2RsZoLnG+L8ljilGH2KYPmUF0qDOL?=
 =?us-ascii?Q?7Tn3egKxqj86wD9vKhmH+8n1LDa7eha86pQ9tpe2Gnzf9UAi/jlaSW2Qe8Qa?=
 =?us-ascii?Q?Ty7iNwfwuKiPUBGdF22E7P0GP9iKhR0o3iMc3TpPWG8f7cZ+szgkOzs53IFO?=
 =?us-ascii?Q?T6IGuJNoIY7XixKYtL+OyIENGTn+CBJYQVsoMnLt0BwB1A/y+KUxYJZef0wk?=
 =?us-ascii?Q?ZptXBNSYb9YwxkuEPrjwUto1KzMCnkg+3ySsX/9RZeECXfvWFMF6Zys0m86N?=
 =?us-ascii?Q?FaHySr/tj63QGdOO2oMaF6c+wf03eO8HpDirwk8J26SigSJIYlSBpPi30RTr?=
 =?us-ascii?Q?MbPuKnrg2Oxx7vzDAZiTV6BLsZsePxuvk4Jkl6lyTvAeTefuAwCzPnfg75qZ?=
 =?us-ascii?Q?2ocCHNPOjPFFB7bnkM/Xfn5My6Z3RkVVODckVTV+KpcwvwyjVC1aAb2QObDh?=
 =?us-ascii?Q?vOiXyAYusNLLpK/rR7zZIwWZxkxY4BUgbBkmiZzcgq3gcaEfbCPn9jDXWC8W?=
 =?us-ascii?Q?dZWkmujyUTCJFwvXtk6K7cqZ1qPjV8W2HoCw8kJnykjyEkNLwR+6VA3uphiw?=
 =?us-ascii?Q?73TjM9CVao1yOs7aVQLGLBiupuLy/6aCMBJ+Q4PnRlU6CaSNrLtA9vfN7MDY?=
 =?us-ascii?Q?e9l36+nK4E68FijMa6gunsIfy0FHtKnq9D+68CZ4ACBMzRLkMeRnKuFi2zFr?=
 =?us-ascii?Q?0/F7LbH+V/LIyFoLlLXr5yH81DIMc7uGSazXyh1XaGLJ79rbqP8GJFlms4fu?=
 =?us-ascii?Q?71aE7XBcCcub4v8vexsHWil2y61FCQui6Dh//YN+OJaZR7bciOt2FpmZFoyo?=
 =?us-ascii?Q?JmpUPsyTBGcd7NRs2taBg97EHNCxvHe/XiwN+327yxIFvWWX+Z0yOAONeKbJ?=
 =?us-ascii?Q?tSaWgvN+bBmwuAOtKWs33Zu5d8Wyw8mQoImd9t346UAH1qhYbilTtMeOTwyt?=
 =?us-ascii?Q?3orEJE1MDCtGgKxJnx2T6aNNph5OveeFc51c7pqvZopWv0kTN5ziQt290lha?=
 =?us-ascii?Q?shlV5BqWvVh6kPdfRGJsSse/1DYqYCABJ07DJwIVPzpGsSjfU2ir7DcDGq8c?=
 =?us-ascii?Q?QSAirzbYsSpUKlAd2hVnLYb1oQFaXe2FQI0rKfg96VMbTfuM7mkTm2wt9tmn?=
 =?us-ascii?Q?/T0qD0s9Y/asdkZZs0UBnSM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED961CC991B0C946B863550A5A840EF9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e3270e-f8c0-4efa-0682-08d9b34b4c19
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 15:17:02.8874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KxWpj9xzZ+VwWB84j84uwfC/5K93YXvNtsFzvsgd4YH/YxJ4QpBAJe0V9m+CbXP98pI6AMlRHBcBUZGtSjZtvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 03:16:52PM +0000, Wei Yongjun wrote:
> Add the missing mutex_unlock before return from function
> ocelot_hwstamp_set() in the ocelot_setup_ptp_traps() error
> handling case.
>=20
> Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
