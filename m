Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0A32D3FD
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbhCDNPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:15:31 -0500
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:63545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241179AbhCDNPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 08:15:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFOocUdGYhDtsxzcbKBDEyJVNRTWFlM+WZznoh2amNumtaVMElJ3WPKhFPxs8QuFjB7uNmS0W5gEP1fQRMzoqSNMkLtKImHsOWzgxFafOV6oP3YRAqqoZRXU5FRopl/jKiSwHy+npi4OLQqBqdEjJYF7fhgWhR6CKyHVv0cdOa7/a0VcEYZwM3v1SVlrV1IkaTtqlbbxRQIu4U1S+iE/hS+AYJC9pDSRXK2eYkMTZO960nh9bDC3iHFOtMOmUq/i7iFbZ7bUxOUmiWic6ho/ImO56W83Gndx6RaktOXrwnnFtU4Jfp7SlXupgz1OqDNdFEVDX2vKxvhl+PfLRUP/YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUdb7kDGq2SsdBVgMK8QHkXcCjusnzHBO/G6LO9JUm0=;
 b=MakNfGkHlGEOb8wCALdfVzOt2YD+pMLWs/3dBAbirgdFKMeWsfX/gN8g5pfiZFGM+hibOOHkPW7n61JhXwQltJwZQkakm2qAGQjbkyxeGlz2fhWx6B7W9M6Fw+11dGl8y5AmA0AikqeQltqpJ4a6PPDVezHH96rVOkcMj1W9uCwvKkrD8T8eiwdY3MQT9tK/1wzsE+I1CVrndA6j4Nn5dICX2/Am4VMQ8CrB6C8FFeFrqyYLYaqgWa5U5LAuGCGy+p1Vf8afrbF1OOOJtNUKYsve8yEu1Ibw+KPeUHOCsGuSz9dtPuPqYwUaiIVZipgt+qgqJ0+pmgKjmvgZOaX2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUdb7kDGq2SsdBVgMK8QHkXcCjusnzHBO/G6LO9JUm0=;
 b=CPc81mrWdQ4602F/B8mZwul1cim2gtUHxe6qPYWYwd8N6LVjINqh/2LYbeXfXwKsWU9gVYyvXPJz/JZW7I+/HJrA7O5BsiJtVFGx9Fujqhbp1pclwPDJbQVlIS40kWndbq2lPfcNizvY4kTiWOA8xnFWWJblGtLiYtHSvBfk4lU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5130.eurprd04.prod.outlook.com (2603:10a6:10:14::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 4 Mar
 2021 13:14:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Thu, 4 Mar 2021
 13:14:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: stmmac driver timeout issue
Thread-Topic: stmmac driver timeout issue
Thread-Index: AdcQ9/Umlq/KuFvES3u+uwMRD4Mb7w==
Date:   Thu, 4 Mar 2021 13:14:31 +0000
Message-ID: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: da60d543-eaa0-4fc7-b174-08d8df0f727d
x-ms-traffictypediagnostic: DB7PR04MB5130:
x-microsoft-antispam-prvs: <DB7PR04MB51301A8D1B29EDD579BFFA83E6979@DB7PR04MB5130.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zr+1PEMoi8TpdxOJOWbyUBEq2ql+26jeL3MhcziyZcjdycD+wjE8dFdbNrRFsE3e8PCmLYv8jsgNok/uj5PHfsWEdgVo58CqTCQ8Oe2w1kmdcO+ABhQLIoRdXWGz6k6VHfvjsSt1JlUtUBDew3m7lYnVr7x0bUdX5K4OzwLaW/RnxPTA+TT07R1RUiM1yPOCq6lNnPyqSXrc7bsjMxHjJ4lkxd3D0webTw7dYC7btRiITFvVTqUGUvXHWQwQnpSBoktnUWdw6s5KT2+/RADlLw1VVWDFmPXi+nl3z4PQzyOOXt5y52XsLUCkJsN5PQqL38gxFuzWPQ3efXdM97a+/DARdjjcBH8ehafNCjivYAyToH+O5t46d2cpG6VJFvLvfFsSee894tk8srBn9ns0fOeba6Gq/pUZ9+vSuU77Iq1Ev7GWbR7l1wphgO4q+JqFD9B+N/ibHUQN8cerrNqcSKqZ9P15my7xn6G801g4a0u/om6Z5+G8VYqTqOqhPOa2Pmq0hFyD5qH3Ky/dYVASKutc8rewXJ209Yuvy0OxyIjAKCw+/8GRFA99PTUHio5TdABfZEfBpBSRDWIPJNWVPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(366004)(346002)(8676002)(3480700007)(110136005)(26005)(6506007)(186003)(5660300002)(64756008)(66446008)(83380400001)(66556008)(66476007)(86362001)(478600001)(8936002)(52536014)(9686003)(76116006)(2906002)(33656002)(71200400001)(55016002)(4326008)(66946007)(316002)(7696005)(158833001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YUuDLucjMOc3EUnjo9Ifh8a5/f2Prb3uoQKE+UJY1Xl+fFLr0VsVnGcvdqT8?=
 =?us-ascii?Q?+ULFJTo045uWcuGXEPpA34ppxnSZwcVtEsrBpszr+E21hMcPpcr+6L2tWChs?=
 =?us-ascii?Q?MA4quFkYANArY6VRXoVhMphsk3ncmq/t0bT5x5VXF3S+Zq3LJZTQVK8QsWid?=
 =?us-ascii?Q?YAWY34ONr70G3bYa+aNULCVydHVyi5wxMgXWfSWm2MNqiaI+eVRvXEYFHst0?=
 =?us-ascii?Q?z+g/1qVq4FUOplmdWLr7RaRUnNUTogq6B7/4P2YnzkDf31rpfnJlfrTxigIw?=
 =?us-ascii?Q?TZAhEP3gdXmBoOzZvRNh6JoB8DVO5lmYR1excnurZ8ceFgzoeU4PCVlVMH+D?=
 =?us-ascii?Q?ZY9hUlfHEEleFvv5C3BGp5yhqwmyZ7tdSoVqTDf3NFD8Ala65p/UPZWkAMuQ?=
 =?us-ascii?Q?aKPzuQ0UQn61YC8dVb/6b95Mu5MpY5iJibjdekBwNW1zRlSF0qKQBsFXtrUO?=
 =?us-ascii?Q?HK83+Guu+M+aOWjOm9zFcZVbKi2T+yWi/jO/BMa6ZtkyyIjVojKsSfFGHz+v?=
 =?us-ascii?Q?iF3ejxaxa+EeUtfH0KsmQZiLFdCQaIghO1DSpyMdg+Wq74msgqpclxYiDfKC?=
 =?us-ascii?Q?gpyC5eSELHysd5izFpDcUaKxpE9wdtF+jagr8GJWNW+jknVkhfEuoD0vUQSd?=
 =?us-ascii?Q?a4NOUY0482JUbhc3QJ1XA//cEmJdcNEK5a/FlGu/j2Uz4EmezTZVbs6z49Xr?=
 =?us-ascii?Q?qOcauxQj72VaITCtKMLcfROe0FJmiYZjTtfXWTxqPVkpjK8RUfDxz1ZtkVIP?=
 =?us-ascii?Q?z+RT9DDrBt4KlXZ9YlkHfhM3s8lIRyajL/OhkZL7dUHY+oPE919zNo8Ujkw1?=
 =?us-ascii?Q?umnFZ+/W6RV60AUJ9kaAk52bMfilu3YXxeWsDlhG4+5kqeGiBtx+gBLNWBB6?=
 =?us-ascii?Q?MFFQ9za/CN8R4FfoyKPJmEC1ro7MdwSAq6PlE7ojfR0Pma6fMcC45XjUynVd?=
 =?us-ascii?Q?+ArpCg4XRG8PBplErn5Nha6zryqmxzVChmG95AYAah+NpkgC+zvWUtnccUyS?=
 =?us-ascii?Q?qhNeVvFnGxrzqgYS9N23w2XXqf9wHAlmegXssjJgYjYVeXG434z7saNtXMXv?=
 =?us-ascii?Q?XVnsd/gl+vpKsqUpJ92RObA48PUvV4d6XqWBffmHhwR2RHa2SCCeOUmr8JLL?=
 =?us-ascii?Q?SaW75Jm9dFQBBix3oabFWPLX5kNeYX0kUHxFNBFffY9zutzknrOI6V7hnufR?=
 =?us-ascii?Q?0qMQElNIX1nMhdeoW6ye/ALlXEXBn9RM20OcCyQ9wTnzVzBgp9AAEV/zSFf4?=
 =?us-ascii?Q?KiTEi29MDs6Kv5XeijKpTyVFLbnto5w88bByZIH8C6Qp+YwTaCbhZk+s5jDt?=
 =?us-ascii?Q?ccs+Y3rKInctDmhAZtN1gXLj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da60d543-eaa0-4fc7-b174-08d8df0f727d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 13:14:31.0492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NvHSF4x5nw4/IDOoxm/OSrXIot9sxRkA4YxgId/Cf9YQIxeq8oeBFM2gfUEUrxy4vfCmf/aAFBa1eC9Yjaa9jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Andrew, Hello Jakub,

You may can give some suggestions based on your great networking knowledge,=
 thanks in advance!

I found that add vlan id hw filter (stmmac_vlan_rx_add_vid) have possibilit=
y timeout when accessing VLAN Filter registers during ifup/ifdown stress te=
st, and restore vlan id hw filter (stmmac_restore_hw_vlan_rx_fltr) always t=
imeout when access VLAN Filter registers.=20

My hardware is i.MX8MP (drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c, RG=
MII interface, RTL8211FDI-CG PHY), it needs fix mac speed(imx_dwmac_fix_spe=
ed), it indirectly involved in phylink_link_up. After debugging, if phylink=
_link_up is called later than adding vlan id hw filter, it will report time=
out, so I guess we need fix mac speed before accessing VLAN Filter register=
s. Error like below:
	[  106.389879] 8021q: adding VLAN 0 to HW filter on device eth1
	[  106.395644] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLA=
N_Tag_Filter
	[  108.160734] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full=
 - flow control rx/tx   ->->-> which means accessing VLAN Filter registers =
before phylink_link_up is called.

Same case when system resume back,=20
	[ 1763.842294] imx-dwmac 30bf0000.ethernet eth1: configuring for phy/rgmii=
-id link mode
	[ 1763.853084] imx-dwmac 30bf0000.ethernet eth1: No Safety Features suppor=
t found
	[ 1763.853186] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLA=
N_Tag_Filter
	[ 1763.873465] usb usb1: root hub lost power or was reset
	[ 1763.873469] usb usb2: root hub lost power or was reset
	[ 1764.090321] PM: resume devices took 0.248 seconds
	[ 1764.257381] OOM killer enabled.
	[ 1764.260518] Restarting tasks ... done.
	[ 1764.265229] PM: suspend exit
	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
	suspend 12 times
	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
	[ 1765.887915] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full=
 - flow control rx/tx  ->->-> which means accessing VLAN Filter registers b=
efore phylink_link_up is called.

My question is that some MAC controllers need RXC clock from RGMII interfac=
e to reset DAM or access to some registers. If there is any way to ensure p=
hylink_link_up is invoked synchronously when we need it. I am not sure this=
 timeout caused by a fix mac speed is needed before accessing VLAN Filter r=
egisters, is there ang hints, thanks a lot! We have another board i.MX8DXL =
which don't need fix mac speed attach to AR8031 PHY, can't reproduce this i=
ssue.

Best Regards,
Joakim Zhang

