Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E016435E12
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhJUJjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:39:42 -0400
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:57270
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231513AbhJUJjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 05:39:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvwG5McbMXNuUGQr5nSOuzk2QCWvQmroUTIB38CqmC6SeeE4aJ9D/Tak6qKzPBsb12NAukW5s4HyyznuQYDwskQAz6bF4czFi+Y1pBhWBK0KIPa2nbgAm2/iwpuy1CwHk7p2Ig2SzVCc0WXOVVaiH68NAP1c23dtE6X/7YOyy5CGUXV5b7//F8IHJbZgZAPt/VPxADyiJ7PyWhjUFbC2EC8GWAuwReNHVSm5ze2A9ANgAVOxL/gSmdP1ZPenqcvjEqAz0hL8pZdwSijLzjXvAWD+wdoxIf9aIFgKyIHfFUyZDMrdHCnbhxyVYoC23GuFvs4Jln6ODiJxdODlTRrDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkkDpq8rtfh1F82ynRKbJ32+Wn3DNGR+WvCBTgMtwAA=;
 b=Z8OmgpVo6CcJwpDoqYd7lzrOej0qPmrEIaBv41vPYaF1QOPif125ev65rrsJ2ZSPdoOX291Z6s1fwEM9LvcsAPWZhhglWqcvddSDBM1QiM3aTre5Ck3BLPLAyH5ZNcxx9TrMnPYGPeejomnkognKhhjPbYrMsVmM7N538skvMqVInWeIMtEaTs6U4NDLU8VGcbjVZg2ueQ8DOj28EhnLi3rMjCjBqVvSZph6lAMJkKmrgfxHgCYfEbp0SPlUbPDOxcn/Er/Udmigi5vNlWyRYBhCCSyQTGQ9rJca9ZqeqlbmNFiX6C9hyXsLtfvDjctaAgrXKpEEq6ZmbEsnSu2e/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkkDpq8rtfh1F82ynRKbJ32+Wn3DNGR+WvCBTgMtwAA=;
 b=hMtMZoDL0qxdbxX5DqnIS0Bs1/vXPloQR4488mLNmsR0swIHMSvHRYMsPYRUUCYAH+UUkx3cJRO7aOUgO8t/G1jxnub0JMcCU+8nEVnIMrU+AOKLE9K81qL+SxMV9HUfSfNS7ppGRfiGqYc1v1boC9lhRzwDqHPSxlzEqTB0LAc=
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com (2603:10a6:10:247::15)
 by DB3PR0402MB3673.eurprd04.prod.outlook.com (2603:10a6:8:c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 09:37:22 +0000
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e]) by DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e%7]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 09:37:21 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Richie Pearn <richard.pearn@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: RE: [PATCH net] net: enetc: make sure all traffic classes can send
 large frames
Thread-Topic: [PATCH net] net: enetc: make sure all traffic classes can send
 large frames
Thread-Index: AQHXxdiwM145fO7xCUaQZ+1LiDD+H6vdMhXA
Date:   Thu, 21 Oct 2021 09:37:21 +0000
Message-ID: <DB9PR04MB8395E7370B07F8D36B10026896BF9@DB9PR04MB8395.eurprd04.prod.outlook.com>
References: <20211020173340.1089992-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020173340.1089992-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fcf4fe3-1752-418a-51f2-08d9947661ed
x-ms-traffictypediagnostic: DB3PR0402MB3673:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB367395BD216191E4FCAEDEEA96BF9@DB3PR0402MB3673.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fJNcRf7P73txskCBpRRnhg3Dz/13LYFuhd8PQmz0KMpRRQ+UaOou5rYymMzpTM/cpGUfCrxunG4SBsuB67luhZgvXcEBrk+phHnDzJYNagNnIBp8GFMJDHPCw0xrf2r8AIjX+7Q8O9rfyst0de5BzSOwEG0kZH7owK4vhXS8wostGjqXdsMcDHUo5kIkgg717wLUkjw0duC7JDxFtJB48XQmMR86lrtlcyKBvpsFQHls4mqaAuKAWY4qcE0nzb2Ri/+IIKPTwdVh2zRTTUwtTT+S0Aek+E02M5CbBFsU4gzpGQrGvkb1oENuWhlBd8bfmXq+XTHdZw9Yuh2w/B2/Lv4ZfdDKTfiOHJBCDaps6Ssi93HVtGZf2uB4Pp+Mt6qHWaOZQXSGL3rEPktXn9ddB7KcLvEaYRezpTMk+WMC3SbTlZXTrRCMzBpUOwHY3o/l2QLkzB6eDL4pNlKIpse8Kv1nuytxa0txbi8UytPjR86uMrmA5ZpYM8yHT5oXMuT4+CD0qN4WByBN4JAFhsM21gphlSrk5VSi8V6R2LkTYL1EKNfhSUYY57OiKWm1AyFu/uPi96hOuJf6s1oMCwL/Qj8chEU+UiMa7Yun3ujIFPKlsMAppXTyMLbAKVlfrUrYWJgEw8uWQJWML020k0FPZExIQGqeQrASAHrVrhr1hmidk9Fk2bETVZcbICpRw+GW4rxuSmOeGnkioV96Zt57JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(9686003)(122000001)(86362001)(8676002)(52536014)(54906003)(44832011)(66476007)(38100700002)(7696005)(316002)(66556008)(508600001)(55016002)(38070700005)(66946007)(4744005)(64756008)(53546011)(8936002)(83380400001)(33656002)(76116006)(5660300002)(6506007)(186003)(26005)(2906002)(110136005)(71200400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MIn/KD3Pc+MLhKLaCYEEzL4E4UjX28YprBYe5OksTMh1dvf8A64DMO6U4rty?=
 =?us-ascii?Q?jUViwO9eaZl15qTsGP1YMavq/5mUuqy8UiFcFsZQeWO2ShSpXdJebKdskZYk?=
 =?us-ascii?Q?uZt2YgjScz1q7P1EHAOUokg4pihrdea7DDDCHLG9TJhjgX/dW90Yd6zkKBS1?=
 =?us-ascii?Q?GX1h3Imo/bNnoUqVcly4DrO8C1Npq+zzPBcG16efMX6JDZ/f0lJ6JrRH9egb?=
 =?us-ascii?Q?o2THk4WpaF1zxS+VyJa8A0b4Nfsz6k+nDIkI+Qrb2Z3WLlxO3+TYkGDneupA?=
 =?us-ascii?Q?Kr5COlIuSg+GeUVZOD8HzVAGa8YiMy4TNzztcMPlBn/mJmJj0Vhrd2ZCeb/0?=
 =?us-ascii?Q?BQdLIAF9rDwP/+OfBFdySWpYXSUCCkvqUNCzlWdxamvzOfvlzgNt3z3ZXkI5?=
 =?us-ascii?Q?DgjW8A6Ph+D14CWyy/UoBa9VgiOXYHoYJHFlHN6etiNcwi/9GbL6eenQDceO?=
 =?us-ascii?Q?KuPDNrGpzqfz+/uWaBrz3JwDqOG9n+vQFsRoQkGv4uolCTn3zVBjnWgVeYkD?=
 =?us-ascii?Q?qU8ph52pMRddbJe180ZsDZrihyQ46ZOPKQZTNB3dU60ZlTbhmmu9DVr8D6yU?=
 =?us-ascii?Q?UfusTCGxGeqaa6RkXgvSMHn6pfhR3R++z03A7mI/Ub1VBM6DvtXVSGs90TJc?=
 =?us-ascii?Q?7PSIG4nD2ctleG1E14l5dPowyUXfpiI9P/ZlNwv/JtSeTF20i5/LqnXuIUQ4?=
 =?us-ascii?Q?s/MYwZZ4t+v2JUJs93bmgYOdZbe2pMrRPO9AyUaAndjr0Z8uhwsIcY+V+gut?=
 =?us-ascii?Q?ibMV5jBjf7eZO7E+L3Vu1gmd2CxM19vo70zq8aj6oa0lIIwJoDDaXbBMJrMW?=
 =?us-ascii?Q?aCPiqspCNqpipXjlE4IGCBjsMknKz+QReJY6duFpqCPHPKbFWleQR90GNUR/?=
 =?us-ascii?Q?iV1N6eO5U7GFFW+qWFnVhiOnw8wPrX3ZUlfwllhy9YZ9b1AUenr4ii4Ghvdp?=
 =?us-ascii?Q?MRjvPFyFLK1P+DzoBEA2k+b8T4m3hCBRNzH0j0wH6iMxpqURANUnrfviyaHV?=
 =?us-ascii?Q?MbqbPBvrGqKoxIoEIqV5j7avdZeVHg1gaguYKrwLfMVyJDWg1JIqYvsZC9Dy?=
 =?us-ascii?Q?26jKbh3OIn2FVpLKvdULsAiAATYi8FcybmdUvMxIZT7CY5FZ1Bpjz0ashf/q?=
 =?us-ascii?Q?0hL5rfgftT/MOo2wfxi9xy7bBi0ecbdcHtr+8+awG62FDlg4A6Prh4J8C96V?=
 =?us-ascii?Q?fsW8wEddu0xyuokJMsVVElrOFEJYLT/AHWjrQ4z5kxIQKFRycbWh39kSu6zu?=
 =?us-ascii?Q?csyniTzSr96Jpttd8h3GpAkI9BrqSGXUkNrZIkr59ieLChY2XL7GCBFaSCuy?=
 =?us-ascii?Q?5yI3lfIHaGR4yL9q7WJ3JIvW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcf4fe3-1752-418a-51f2-08d9947661ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 09:37:21.7181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, October 20, 2021 8:34 PM
[...]
> Subject: [PATCH net] net: enetc: make sure all traffic classes can send l=
arge
> frames
>=20
> The enetc driver does not implement .ndo_change_mtu, instead it
> configures the MAC register field PTC{Traffic Class}MSDUR[MAXSDU]
> statically to a large value during probe time.
>=20
> The driver used to configure only the max SDU for traffic class 0, and
> that was fine while the driver could only use traffic class 0. But with
> the introduction of mqprio, sending a large frame into any other TC than
> 0 is broken.
>=20
> This patch fixes that by replicating per traffic class the static
> configuration done in enetc_configure_port_mac().
>=20
> Fixes: cbe9e835946f ("enetc: Enable TC offloading with mqprio")
> Reported-by: Richie Pearn <richard.pearn@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: <Claudiu Manoil <claudiu.manoil@nxp.com>
