Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C857425A78
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243489AbhJGSQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:16:32 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:22595
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233774AbhJGSQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:16:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaBvf5oD/IFLQB8i3wSoOt9nbwqhb3NPhhT+7MNTkJSUfgqTTI/UasZkZlL0eT/Z4k6DjOGcxF2V04RzpZnYN3Nc0kVI7/Ytc+uNplj9hPRJ4IC1mwd9TjcJh9GkeDxldzGLIp48/N2VCmc7IXYTalIKkPqGFPNPi3FozYNEMRxhBAJJ7eqjR4ESXl3motlyUCGkjr3jFB8nn5Upebh+lmnx5HnXt+95dD5xRx+yF83CowHq/11nTXhBaFZWI+DR9Nj2K/qIP0KMRIBgvIiyFWBSkVjRN4lhd8+kSk4F1uXwYz6ZODw7vNxGLMzsosladulUrIoLaLgpxqi8GOJ4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejsFULbsbqI/u4QGQtBt02GlEXysYOCD8sq0+s9FcuY=;
 b=T2D1AcFjJe26Ji/Bzgbe7iu/5LWpm7ozWawb2YUxB2emm8HOPkbswa7ttmyazBedh1jmB6zb7N3RTexDBhxabSl4QkB7JqTJkAQdJFiK6+XUYRcANqV84o63NMYDiYgFQkaOfw5NbxzOQhhFtPrh4HFyC3xgulodLxyGN8CyI5zHCxLgkeXiBpZt1M7uvRQC2spKjlwufkfUB7zuwGhHkQ/iPA/hUYseMGyqHdzPSddqbt1GZDoBaP/u5tEMreZEtmUZxpaMCPe+w5J8IEQELvNBTXo1ry14Jw6o7p4D4HdtO5+el7Y6/KfBD8ehejmmvxeb+RW3PyuA4QUMW5dQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejsFULbsbqI/u4QGQtBt02GlEXysYOCD8sq0+s9FcuY=;
 b=GVTMhojtaOy9PAn8V7q72yKI36dCvJd4JuKSWHreMZ2uTnzgRs5x4XSsLNM7lTISh02BVPlhOcInyn6BblMuvw+HUVkni3v8dLt8gvPW+LDXfoMgYcbHNbDJM8Y0LMWpUI8xQfS08X94w2m8bME03460GQ4UsPr2C493ZzG1bWk=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB6884.eurprd04.prod.outlook.com (2603:10a6:208:183::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 18:14:36 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%6]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 18:14:36 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXu5Bn9Uwlk3DvGkCX+9s3BY+eT6vH1tBA
Date:   Thu, 7 Oct 2021 18:14:35 +0000
Message-ID: <AM9PR04MB83979D5442EC78B8BA67B04B96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
 <20211007153043.2675008-3-ioana.ciornei@nxp.com>
In-Reply-To: <20211007153043.2675008-3-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e3b2410-9626-4da4-0ceb-08d989be51e9
x-ms-traffictypediagnostic: AM0PR04MB6884:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6884EDAB19AC852E21D1617796B19@AM0PR04MB6884.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +66m/WdjAE/7FPnrVw24IQCfDzHpf3NF1RljMpumaR7a+1KWZTbRmXQFEEE05Cm1evUlas0zTgjk7Vb4kMuEMFluAHBUFNTkM3PuVg08sXkn1idMkzu74hZaBK17Z1sfTKiyYPF53ct6FeTLNDMdbqlZI1Wv7DNX55A9iBhUtY7ZpuhHQDnATCusXb1i68kzcpV5mESEgLYnZPkQPNmD9+3meeT4BGYWumy04lRMO+hXU7InMNNwovnihEQO3WnbOPUpQabRN+QroWULU1TnP7U/VA7+0MLza/8y9k+pGOraPYNQbOn4rGPSGXzde4Ib5RKsISIbggG0WefUNQLEd4YemaKEnVp7NXXX3r9ES6DSxBTmriXztoPoU7LKU61ndGZ5nBb1dyHDugADX6fg19TIXseNOv5VBDn+7cU3D23+pnPqCgtBKm6cZrR4StwMtOqVIVO3WkSL1xSwei+v/vWjI73Rk4cV5Eu7nudVmOV7/D6DX3ynNsdqN37kvvkh6QhwimDotU7XXqDAqPZ7Z6FvCIuBJZ5u0EWiwVjsOLtmnp/oGxf3pg5XZaXD7pDWTdAqqGv8L5sMvX1v3IDHkzzrP4cbdZxRBkHtU/tpMbLxM46jzrB0bxrebH7yy5E9vlTP2jaUOaMOgBk7W2sdjf6cglncvw2MtbTP/SvtkUtxpfa3SRn26FikstRDB4c2FhgcFXl5XQWLD2VuE4yFWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(54906003)(122000001)(316002)(110136005)(4326008)(508600001)(71200400001)(38100700002)(6506007)(7696005)(8676002)(53546011)(26005)(33656002)(83380400001)(9686003)(55016002)(2906002)(52536014)(5660300002)(44832011)(64756008)(66446008)(66556008)(66476007)(66946007)(186003)(86362001)(38070700005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ryFb00/kVUXl0LrzhaNccRXgAOJOcs1zQ3+ioCQXW6ZcGU89i+RtuxxWPOL+?=
 =?us-ascii?Q?VKCTH6MZ6NDfEIRtTATlUKwDmnoaf5eZAXKefio7SEoVCEa4Z9z3L6bcjDUw?=
 =?us-ascii?Q?/7D0/KjhwEZXmePWLpcBajRsqT6ChXgWJJYitucl3wBjAW5D9VM8tG1YcSxB?=
 =?us-ascii?Q?8o6rW36Gz6p3/b9RU+6KdywBgMBeeKsYZOzT6fZw9Xl43Y/zU5Ti/caOm7/o?=
 =?us-ascii?Q?mB4tz9pBipQAUP0bhFtuBxviu7KggVsLyrfW+GVDC+iQDG+doOdkryT5Dw4A?=
 =?us-ascii?Q?5N/UCMN7N/oBcjOWxYYmmGwh+PO7OA4e1pHApMpToxalQlWcSlmv0FsODsqo?=
 =?us-ascii?Q?u9ypRaObdgJTfZZxVBZGaA/p+3OSXrShgPpLvAkPspJr30Pl2s1pkPhEo56x?=
 =?us-ascii?Q?mXYwqqQIA+XujJI98rvJX2T5ERYBO2isThzBs5vn+ZGkM2FP+YRKzG1livUS?=
 =?us-ascii?Q?JYKEFOnqU5kk6LRqBM2UTMH4mHQRuyRXRVbOyK1oFVfg9lFb8e8GGcF+56Zd?=
 =?us-ascii?Q?u9pJsmrNlk3d8Ci6QM9KcfB/v992PcgrUlE3YVTcy3rcn6nfl4zvbtRJnNXU?=
 =?us-ascii?Q?5tPq+Y8Qxz4qjX1D1rlCRAPmC1j0FKOCbNJnXcdoJOH7W+glP6djWOiPDIIJ?=
 =?us-ascii?Q?ETMvguWN/YF4AXv30RxDck2Kio76EjNxLUVCjFCtlw7UKLS8j2gBf8quLbZM?=
 =?us-ascii?Q?/Xs9CVdmit9zAsSDFOxHn3wHlaAho7ihsFyK8Wzk5HEhIJHZkY0ijlFw+ZSP?=
 =?us-ascii?Q?q7NaR2PGpjQY8oaGW3wonIjoBXWSN206YfcmfTIykbnQ9/k2qQwg/8IbRLuC?=
 =?us-ascii?Q?1rLW8S6tTQQem0x6Tw8uME8rwgcjo5P2Pt3KXfLG/5iGJhWvfwDJV9MfEFLt?=
 =?us-ascii?Q?DeVGmHu87A3HidJYVGIlBcY/Fx2hrO7ubCgbV5g/1ZC5gUQLdk4JAIMvyyuj?=
 =?us-ascii?Q?g2m1twOCrB738KDUi84W6TOUOGMyoxhtzOxPpGkni2i6zEV/uxCRuL90Gq9S?=
 =?us-ascii?Q?N1MT8C1E+A5T96GhI23bRDgwkan0+GGNxpLW6WGEwsZcXQm+81dIMH8KMNk3?=
 =?us-ascii?Q?Bu0+dZDrmdfbH8ochfp1TNQjSo2h6KhNp2c06GFcHWH20w/kToQU+Nff5otL?=
 =?us-ascii?Q?8YaHoe8/Nk/rLOiVbOxE63df+FdSQb76f5gweITzVi43PiN/HwLkE42QgNCL?=
 =?us-ascii?Q?ieFQ+VWAWqcjC2G6Qd5jbq28WnO8HGNvk/Jc8OJwz0rXWxgdouXVxaYTYhdn?=
 =?us-ascii?Q?duVoa7kf4chFeiPjQ1WWA1WeQf5L9w9ZCiSHBozwSEGAcjnemcB4t0Xg7XlU?=
 =?us-ascii?Q?h2w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3b2410-9626-4da4-0ceb-08d989be51e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 18:14:35.9579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npRD6CeFEHuLJfbGobu2wQWs5jNwQMdYUuAyivHUymMv19jxHpnp9KydzC439F/1IpWB60rIV6oCnwxObGIiRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Thursday, October 7, 2021 6:31 PM
[...]
> Subject: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
>=20
> This patch adds support for driver level TSO in the enetc driver using
> the TSO API.
>=20
> Beside using the usual tso_build_hdr(), tso_build_data() this specific
> implementation also has to compute the checksum, both IP and L4, for
> each resulted segment. This is because the ENETC controller does not
> support Tx checksum offload which is needed in order to take advantage
> of TSO.
>=20
> With the workaround for the ENETC MDIO erratum in place the Tx path of
> the driver is forced to lock/unlock for each skb sent. This is why, even
> though we are computing the checksum by hand we see the following
> improvement in TCP termination on the LS1028A SoC, on a single A72 core
> running at 1.3GHz:
>=20
> before: 1.63 Gbits/sec
> after:  2.34 Gbits/sec
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - add support for TSO over IPv6 (NETIF_F_TSO6 and csum compute)
>=20

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
