Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9053F1CD4
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhHSPc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:32:59 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:36118
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238643AbhHSPc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 11:32:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpG9meHsg+AAFKmJD/JkM2XnDIF+SsLRyU7KbhaMUFMoSEnjg8vEYYPJqJ1z2HB4BNrKiZcCIdO8/D++UjHsZxwGInw8nseS8CnLszRjNxUgCpSSKNrpgeaCv3ysPhNpygtml13OqLToHrFibFZLS6/bUCznqG3L781iEwNFoOSut+V93fxjBeGhasW7ywAqxlpXg1viFuXMwHlc9r23us1FRfhLthjjirl/LQrRgXqwYix6KcHtiI2S5YInFrxhaqMUlJk0FbSfHtfMhwXVqCAP6c+YqOF8LpUUxXOVpKJ+Lx+pPduSVdMzkmu7oeDrEGupZz2R58EFYjemXBljSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsUnzajzVFVoXzAOuVuZjfCq4JFIgY+p95ayCxx4yqg=;
 b=j+uGOBIMe/VGPRRBJ1JvjmoRtPclcTZWhbBjc569KkZk3V2GCpYsNxRmUORgndY6TGZFVPSSTXDlWpujXwsbg3O+2Beurx1k8avIM6BXYLxgOawNQ9KGJB1R8T7DSK7SbzN1cFeJx5Pn5AlWAh+xh2dmiRVytMxm7gNwnWk3QwBgqf+4RVxzHUy6vlAkw3X528WXBQMHrld1p421MxqqRu1C7NkvFw7QghZFqMm5cRMsHCvmFa+1pyU+HejeJJd1kfrefm9z6zXFnYezlw4KMctR7J3J3NPObsbbpVBA8DALvvNV94pd7UuVB2CAnLywKHZNlQMqEgs5DFFS+oJJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsUnzajzVFVoXzAOuVuZjfCq4JFIgY+p95ayCxx4yqg=;
 b=Nn9COWpZMzkbLMMKwS7KECxuidKvHyuxLy9cS1NcHOXd8c1nE+fkd+TMaJycV2wV6kAXPck+lClOzJ4cObELA4Stgh6bnYi8SMr0a9YWr35bdj2gurnvR+b6tfDBsc3AGy3fCWG4enNpI5nOJOKpBKOJy1PBfHyGqb1JlIllDpI=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8193.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 15:32:18 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 15:32:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] net: dpaa2-switch: call
 dpaa2_switch_port_disconnect_mac on probe error path
Thread-Topic: [PATCH net-next 2/2] net: dpaa2-switch: call
 dpaa2_switch_port_disconnect_mac on probe error path
Thread-Index: AQHXlQgpnXKgh1JcC0mlGSpEo7E6I6t69LiA
Date:   Thu, 19 Aug 2021 15:32:17 +0000
Message-ID: <20210819153217.l3vag7huy3n3fknz@skbuf>
References: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
 <20210819144019.2013052-3-vladimir.oltean@nxp.com>
In-Reply-To: <20210819144019.2013052-3-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e02506d-3084-41ae-991d-08d96326875b
x-ms-traffictypediagnostic: AM9PR04MB8193:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB819304F9765EA1AEFA563F38E0C09@AM9PR04MB8193.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aQ0aA5iGYqDM8UTKPP9LYVyRDofjTF380sZG7Pz4i2LywPLwmcAdIAhcR2tk6sxj6B4cR6WeLVoQe+EAsbqIUN0EKomc51lBrzwdWmJOAOIF5VPAfAOuVHrSlxs/23vcffnaAX2ZEbYcPxRo3Q6j4DlCI/MOEpuD/4vEaEBdu/+TJwY1OuFDgNDxOaZoYMy6pOfv2QAGjYCxgvwB67khnwogFnsVXKiWOS+5dENx6HjAS9fWbzsyfXRRzt/kteQSrMeM9G1mvpFsn3pPTjIVBv3oxexppehQK3N2VNMpO6cNGbNiPCDh8AqbOhuEp6UDx8xaLFh+EE3Etb8R0CyFhftU8TiKRlOoqopbm71ahyFUvmHC3S+VXAhCoZaQqkZuqM70oiMPlHzhGs758Brw5l5cAoaBgdYmERZMcoA/rj/tz7zAei72fGQst1nBCfqbMroK4CfHo5IlRWFIEHpiiIIcDvoi6npmANMM+/pQmHyVd3WYhW0y/TTsn/8zDisicUg8Xh2SY2CL9mm7GWaQ5ncLDZdJekFSXS/aWS5SCtNE6GPFnOqlKSJRea5wYtR7IcK0AXn3f4tpDioZhmGwQE/bPD9aicnbp/NWcmeTces/KCgEmdzeriRx4rgxcjWFAzWK0Vry4veQmaXtSMIGcUkF2gkouOtxd3q5Uoepq1HxMCNjbUSCQdoSkvEtGTcI4FF7q4gOD9Bmz/cUtkVhVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(136003)(366004)(39850400004)(376002)(478600001)(66556008)(66476007)(8676002)(76116006)(186003)(2906002)(26005)(66946007)(54906003)(9686003)(6506007)(6636002)(71200400001)(38070700005)(66446008)(5660300002)(33716001)(122000001)(38100700002)(6512007)(44832011)(64756008)(6486002)(316002)(1076003)(6862004)(86362001)(8936002)(4326008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AabOUtlJiRXB6AtlMMVG9Nl+IXWV8lnZAvo6Q0FzOQiwrUC+iG8H3C2fYEua?=
 =?us-ascii?Q?ljvPEnhcCxjyZGXhegOkHof6zMWycG8nl3WQJdFWe+ukOnJyDIhZ4XjHYQJq?=
 =?us-ascii?Q?Jkjq0ZlxOQ4ConxiRBgmyv7WJ3QrljLPKM6AEO2kHa2mhXZMjUQXhmRiRszy?=
 =?us-ascii?Q?wl0t0saoSLGgXT1TXl2ZSjnMDCp2IAm4NP3G1dH6ZL/xwIN4XCtv4WTccArV?=
 =?us-ascii?Q?x9ET6J04kFRQBJMRDlxtOYui4LEIzuRjkRh93MziO+1UQoZ0nHlD4cvabrBz?=
 =?us-ascii?Q?0fD2fx2gV3VxzqNmHVRJOQ+wbQ8jozSg4mfZkrBXrFl0OHDg5FYnc26WFn8g?=
 =?us-ascii?Q?ty5DPiXQ/rb7TvF9iVQG5EKp71H/E9xIYL54uH2bpdXtwqVpj0JaHwure1jc?=
 =?us-ascii?Q?iXetTSVRLxR+lXbL1QLn2+zeBEJ452U08jA01L5VeEMTgMtkzDMXHqb3sdNt?=
 =?us-ascii?Q?DF9Jda5pZWvz2SMDyZIUetRwssO8Rg+cBLAx9BD8nPLHogVXRu7yCjrdgxCv?=
 =?us-ascii?Q?HzM6zR/igJxUlsxdxhsqkd7EPts5p+BpkuPDZFumAb6oYwmDxTFPPj+9b1/a?=
 =?us-ascii?Q?c18f6BolLSUStMg23u39uNlrGcnFAUGmjxRMZV93SaX4p4XaXMM+rBCDMrQM?=
 =?us-ascii?Q?f2geo8GaU7+Ofa9M/cmz3n1S66ZaGhUzoAg59NVbQZ6HZuWZhpJwtAM4WcJa?=
 =?us-ascii?Q?cx7al1SC3uuf7yCG6lhshOZcYmTt2I7lrMwWu+OYhigTsaDe70kUftjT2Q2S?=
 =?us-ascii?Q?/3ZxQ748rGfBEqmHAJVtu60/mvlpUOfBijCId26hMyyiAqSPXim2j2d7LMfl?=
 =?us-ascii?Q?iUc3Kgv7iZFBtvUg/n2dW+3EgU0g07WPhfgJCpbDtjA6X+4jPOj4qODRxki9?=
 =?us-ascii?Q?SObXSbL5oFSEzi7afmtS9+POVTIHiU2Jw/6k96/jMFMzJ8jfkkIX3VLicTjv?=
 =?us-ascii?Q?7bnuFmqbjiBWvpykohkQqOUTQKVLWMM6PZ/5e2ysIQXIPjqit5b0psivQNWk?=
 =?us-ascii?Q?fqrbO3LsTVDMreszpYn7xaZXZBZQtoAooacrieIF9Ii4S2q4v+Z9RsdVTuec?=
 =?us-ascii?Q?m/eQN9NQ7HrvuAaSKAHKp1vrk0X6L8jPL8br7Kuntjn9O/sfSJJRZzyKyy4u?=
 =?us-ascii?Q?pvJKmiYGJurQSSWs9MLdGb+GHnQ/iMYASSFdrCAfldnDJV1gmE+FC4N3qZZ+?=
 =?us-ascii?Q?B+grFlMAVz7UMY4HuhuKCS5VWJV+KSqPnznOzF5vegSPPZ7sh4t481y9tnNi?=
 =?us-ascii?Q?85OqfvWFBFyVQ2tovONeWtE/3LJUSM16hx0a9NKR8OZ1BuAOd9RKlqfTIurt?=
 =?us-ascii?Q?2Q1RsCzr7VcpD+PX+bxZwB8a?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67360D091F204642A817A47B596BAC0F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e02506d-3084-41ae-991d-08d96326875b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 15:32:17.8750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owilCFy7KJVEbT/Fz8UrOCvAOw3aX8gSxEkR1gLklLRjyQyH1DfCqVIb39wt5tT4WbGkOnZfyZP5jxFeErLN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 05:40:19PM +0300, Vladimir Oltean wrote:
> Currently when probing returns an error, the netdev is freed but
> phylink_disconnect is not called.
>=20
> Create a common function between the unbind path and the error path,
> call it the opposite of dpaa2_switch_probe_port: dpaa2_switch_remove_port=
,
> and call it from both the unbind and the error path.
>=20
> Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
