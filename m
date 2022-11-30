Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098AD63DAAC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiK3Qa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiK3Qay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:30:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6881886A14;
        Wed, 30 Nov 2022 08:30:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgS23VoXFQ/jYg2N6+xkW7xPv/fGxZ7FqkDh9g1+Wvs6CklQUFCAY1DsSYb1nQWzSRJ4ery2mGctOyrCoRzuPxzc7iscpS4dMyik+4ygRIvMnznGrjGt/f++rDkG5y1tOJtmLr882aRjd3iIooMebRMchSEbYY9/iBI9AUpD1+zEk0lCGc2CZjP6UYRr6QOybMG3vf5ODKfAueHuf4+4R3wvcauBB83WtfDaa4V64IUuhhtMpKYGQ/yXkRgVgY4jMr7eZtQOLZrtgMQqsEYxFbEQ24lMtTcBVjwD9VElvflf0dRFpcpysHyP+co1ImQFkrD+nCI108CKE1zma3eH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+t237TRY4dynb6+fJRLckfJTThy2NkaNg2GqCTrGnTo=;
 b=IcEGj5i7BS3gnklBhhV+aJ6kfzOyrymC/9Vg43qcCxWrWkLqhpRt3ZHjQWFPjpofjpUXjS7b6IUYB5xdNWtkNU0JzcG5fszTi0BaZpEFVMGhW4ctlv2Ph/Y2iFIqYWgniyqpi4aFjL5ayDDcDTXQkTCGNxacbckKaWjHWm0kP1EoVSJrIYKLW9F2XKjLTL7oc2lAqk4V4R7YvpUEp50yTFL9Zi5lb9J4fgxPDfm406mFSeWEQQqt9swrxxzEw6nueuoKxtXkX96C64e9sQvljPWtia8rornVq0/hocDbjX04dMQ57EU0OUdWH0csechkBjxwSf4QzMMz8OH/KLX+RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+t237TRY4dynb6+fJRLckfJTThy2NkaNg2GqCTrGnTo=;
 b=rJkA3PChKTE5s00fdJDuPYZk8M5ay9pD38YhKCNJoPw6KTRSFogsFZVyaVjgpK7ZLi+Ny0QURrcB/o2CKowyIm2sKjyFRbSiQvMU5iVT68JVnCoe9+uHEwYNa0X5xNGhGdl2fuk//WlkBYUBB0PnqxGmQ3gOLO3QWCW6LxO8nrU=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PAXPR04MB9230.eurprd04.prod.outlook.com (2603:10a6:102:2bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 16:30:42 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::e936:d70e:e239:803c]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::e936:d70e:e239:803c%3]) with mapi id 15.20.5813.018; Wed, 30 Nov 2022
 16:30:42 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 00/12] Fix rtnl_mutex deadlock with DPAA2 and SFP
 modules
Thread-Topic: [PATCH net-next 00/12] Fix rtnl_mutex deadlock with DPAA2 and
 SFP modules
Thread-Index: AQHZA/yhHlTTL/78G0iCnnvGqd2h965Xqi0A
Date:   Wed, 30 Nov 2022 16:30:41 +0000
Message-ID: <20221130163036.hjlqub7oh4oppij6@NXL49225.wbi.nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR04MB9055:EE_|PAXPR04MB9230:EE_
x-ms-office365-filtering-correlation-id: 6af95b13-b7b9-439d-0af6-08dad2f038bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1N2Brx8OV88T+f21p0k36QQko9TVqnPhH7cldBvX1L3T7h9VacrtVnBabUTV4XNBlRmeowLc3utIy3aghBw8m1fPN9Xn5wN/zJlFzwbk1OMQrjnLOOUg8HdC+FQA7VgRbMCKCH8/AewuOHMCu89bWNaFp2J3Flc1y/cRwjCFi/kXjQi+dModI8yt52nofZXgYoDkSxXMN7acJ7OLFtK8uGh0pg3fuNh8Xv1YP2dSaI6qSp9F9A3IUq3WUDVrslRJdYynuUANSTRaOr2sjiFArSozX6TfMyIC3i6FzLWKTG7zFgjkSb2e0QD3yMuJ7Zs2cVzqZc0IkMBTmHmvIbm/crKGAEQ9ELOGORDv3LE3dPBu7PAM0ztqvarWHlE9V7ljz1KIpwCieOjL4zL5JMdnCZZgMkpA/w6esj57FLH4IuP6WzRnXIxYq19W4nb2WNvTKmnhegEV12XlDjo4XTyDkEx4nx5ta7w0ZU3qn4/p6dTxhvueVg0kBBbsEFwu6okuY9E4gmOGmttiBEjUjOwD/bjuAcR8oqOHNyoDq1MQIvvBvg27hbT+ZgAibtN+NvmVwrekuvjoWSbWuFHQVOMHPMDWWzk0UUDjVyBjiCCDpvgMfzshsCXuDLVD6TD7VBFL/kqgBPOpT9aRR6rwfBpvkwPihj9233L6afV0c2MUCiX2uj7/rQtd+1OsvnlMnjflluyaR/LhCj7pLoUobLwxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(41300700001)(8676002)(2906002)(86362001)(5660300002)(66556008)(8936002)(6862004)(66476007)(44832011)(6506007)(64756008)(4326008)(6512007)(83380400001)(1076003)(26005)(186003)(38070700005)(54906003)(6486002)(91956017)(66946007)(76116006)(66446008)(6636002)(478600001)(316002)(38100700002)(122000001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z0agrtKSj4S7l/E7YwkMUaIfuzRGYujjXC8WkVo26ID220IE6DBATf54tE/f?=
 =?us-ascii?Q?w2zQAqe58zDSjXn09vAHHwX3/CE6Sln7CjLoMLs7LsNbp9aq1oEzBCJP9Gfu?=
 =?us-ascii?Q?aZ9tTSqdyCRBORd4u4WY/NKoZqooKq8Y2gBAMU+QWHyc73UwYcYyZVTA0WIp?=
 =?us-ascii?Q?Vd3xKQ7x1Jnt9EptR8oVQt4QPbJgKeC+G4WdBCP+HNG79+wnunk0qBLU0LT/?=
 =?us-ascii?Q?s7RQ/KMgR8e5j9Dc+2zFpy0P/ko2vFlX+h6xiS941KZhXu5kgei6lU4ts8WR?=
 =?us-ascii?Q?qNv8H7ZmZYKz0P5/DnN0big+I4nYDZ72bFeH6xIz0xHyqf0jAG97HT2hdLYI?=
 =?us-ascii?Q?sjGx3BDYrZ7JKRVLquSBfvqxyScvXJrQOfFAjxfpvwwZFVkimSRSIIyEb26b?=
 =?us-ascii?Q?bbFo6v7Ol33KHX7wtx68X8J8dBVTgtHX2amSO0KzKmS7mdZeBmFHwU4EGuUk?=
 =?us-ascii?Q?Pc6zT9BvgF19wi5/fnaR/EpL+OrUGwL/gpyaOzId1uF/HA98MZFE69UJukOn?=
 =?us-ascii?Q?XiV94dwQi7uWzOHvzYKl4m1b2soaAsb6pjCWA9i8c0WNU+0X6HxmABjpl96H?=
 =?us-ascii?Q?ZiPT8Fqcg2ol+wVeTuA9EUMvr4Ym7KI26ebu38qnkk0Ex25Xt9tZCZBc5XzE?=
 =?us-ascii?Q?MymHcVTu2ku4uXJVfmHV8mTjcRYYOkarrtqfxaWUzo5sg69wcU5KzVaooKW1?=
 =?us-ascii?Q?hFUMMfkGzY1MAsR2RBcyFjjdtMBEFaLmuSxplqIqQyA7ieRDc1ZMn6y8HC2Z?=
 =?us-ascii?Q?fJM0pxn/kLJ00QtcPpEsbuTjFYcCFKi6Y+rbQz2xUzfZU4m11+klbgVMG4UQ?=
 =?us-ascii?Q?h8/u26oHV2ew0Lg0t/zHBdu8pNKjpVL0NiHxaC7PbOINGdPKa9KCFN//yoys?=
 =?us-ascii?Q?7QujOKm1sZA5MgNG8NVZ7ymnzZnQTNlswONyu21EU2u8Mf4o1u/XfhFB2xt/?=
 =?us-ascii?Q?8J7yttbpEwtSh00M7V4qSqaVtInNDq2E/nzQ4oVuDHS18NIsy0tJMlXMvrwn?=
 =?us-ascii?Q?gRP7DYFRuZMmTXSSP/tNKU2BE8vOBV/pX4yWpp/DwrOkSEoKb9YlcZ/nrdSB?=
 =?us-ascii?Q?XuCxuIThZtKez4XZ8OPfGKRyVDYDwcDJAt4Fk8DHviDUNVekLJzx9UU5S9SE?=
 =?us-ascii?Q?FzL/YqpoqgcnYJCfyvHjGnIEnDPn+PBzfbGm98ikDEZQe624doRK0h5t7n1Z?=
 =?us-ascii?Q?NC81yhdh1BbAbxCFfRKi58J8SJRNR9ZdD6E26Y2TkhzQ9zIwovA3eVZf478V?=
 =?us-ascii?Q?CEAAMna0BnQrUE7vDrKRWAKpmB49sXT3N8NrVsvsWdUVKwaLWA8aNjodm9Xd?=
 =?us-ascii?Q?F1dgT8TSvw++tiixZNkhS7FgkV1e/kwJYmS7ePimvZ3OoUbD/7ETambpLrH/?=
 =?us-ascii?Q?d6SyTHjwQlARYzTn1VBcASGh45dU2uZ57UNaCH1bHFsgMePjGKagWlzCT9YV?=
 =?us-ascii?Q?I9Ar4ZjeyO/2hBgkRcOtXSdTpOylrLjc9vu6rnSlDN/6Vxca8c5AkkOWKatm?=
 =?us-ascii?Q?uNiC19q00oMf/xUcxhvnOWVspNyC0rIyZMK4ptMNxxEgKFEd7wkUwUzRosCk?=
 =?us-ascii?Q?nQcT9oFCxqP8qaXwDjEaYYWKsUMa2YWEyqe2BdDc/YJ/tMpIrDdVyQWfUS8Q?=
 =?us-ascii?Q?/w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0980D7A14E7C6444AE90A6B000CABF77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af95b13-b7b9-439d-0af6-08dad2f038bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 16:30:41.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TfRFF5SxbquBI3kPgkdZY5T/q6s8f3i8AZgUYNWp/mwOB+/te+GIitJDvNYbNelevZen/zw44HjaTerZ1a6+Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9230
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:12:09PM +0200, Vladimir Oltean wrote:
> This patch set deliberately targets net-next and lacks Fixes: tags due
> to caution on my part.
>=20
> While testing some SFP modules on the Solidrun Honeycomb LX2K platform,
> I noticed that rebooting causes a deadlock:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> 6.1.0-rc5-07010-ga9b9500ffaac-dirty #656 Not tainted
> --------------------------------------------
> systemd-shutdow/1 is trying to acquire lock:
> ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
>=20
> but task is already holding lock:
> ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
>=20
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>=20
>        CPU0
>        ----
>   lock(rtnl_mutex);
>   lock(rtnl_mutex);
>=20
>  *** DEADLOCK ***
>=20
>  May be due to missing lock nesting notation
>=20
> 6 locks held by systemd-shutdow/1:
>  #0: ffffa62db6863c70 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys=
_reboot+0xd4/0x260
>  #1: ffff2f2b0176f100 (&dev->mutex){....}-{4:4}, at: device_shutdown+0xf4=
/0x260
>  #2: ffff2f2b017be900 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x10=
4/0x260
>  #3: ffff2f2b017680f0 (&dev->mutex){....}-{4:4}, at: device_release_drive=
r_internal+0x40/0x260
>  #4: ffff2f2b0e1608f0 (&dev->mutex){....}-{4:4}, at: device_release_drive=
r_internal+0x40/0x260
>  #5: ffffa62db6cf42f0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
>=20
> stack backtrace:
> CPU: 6 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-rc5-07010-ga9b9500f=
faac-dirty #656
> Hardware name: SolidRun LX2160A Honeycomb (DT)
> Call trace:
>  lock_acquire+0x68/0x84
>  __mutex_lock+0x98/0x460
>  mutex_lock_nested+0x2c/0x40
>  rtnl_lock+0x1c/0x30
>  sfp_bus_del_upstream+0x1c/0xac
>  phylink_destroy+0x1c/0x50
>  dpaa2_mac_disconnect+0x28/0x70
>  dpaa2_eth_remove+0x1dc/0x1f0
>  fsl_mc_driver_remove+0x24/0x60
>  device_remove+0x70/0x80
>  device_release_driver_internal+0x1f0/0x260
>  device_links_unbind_consumers+0xe0/0x110
>  device_release_driver_internal+0x138/0x260
>  device_release_driver+0x18/0x24
>  bus_remove_device+0x12c/0x13c
>  device_del+0x16c/0x424
>  fsl_mc_device_remove+0x28/0x40
>  __fsl_mc_device_remove+0x10/0x20
>  device_for_each_child+0x5c/0xac
>  dprc_remove+0x94/0xb4
>  fsl_mc_driver_remove+0x24/0x60
>  device_remove+0x70/0x80
>  device_release_driver_internal+0x1f0/0x260
>  device_release_driver+0x18/0x24
>  bus_remove_device+0x12c/0x13c
>  device_del+0x16c/0x424
>  fsl_mc_bus_remove+0x8c/0x10c
>  fsl_mc_bus_shutdown+0x10/0x20
>  platform_shutdown+0x24/0x3c
>  device_shutdown+0x15c/0x260
>  kernel_restart+0x40/0xa4
>  __do_sys_reboot+0x1e4/0x260
>  __arm64_sys_reboot+0x24/0x30
>=20
> But fixing this appears to be not so simple. The patch set represents my
> attempt to address it.
>=20
> In short, the problem is that dpaa2_mac_connect() and dpaa2_mac_disconnec=
t()
> call 2 phylink functions in a row, one takes rtnl_lock() itself -
> phylink_create(), and one which requires rtnl_lock() to be held by the
> caller - phylink_fwnode_phy_connect(). The existing approach in the
> drivers is too simple. We take rtnl_lock() when calling dpaa2_mac_connect=
(),
> which is what results in the deadlock.
>=20
> Fixing just that creates another problem. The drivers make use of
> rtnl_lock() for serializing with other code paths too. I think I've
> found all those code paths, and established other mechanisms for
> serializing with them.
>=20
> Vladimir Oltean (12):
>   net: dpaa2-eth: don't use -ENOTSUPP error code
>   net: dpaa2: replace dpaa2_mac_is_type_fixed() with
>     dpaa2_mac_is_type_phy()
>   net: dpaa2-mac: absorb phylink_start() call into dpaa2_mac_start()
>   net: dpaa2-mac: remove defensive check in dpaa2_mac_disconnect()
>   net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
>   net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect()
>     call
>   net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
>   net: dpaa2-switch replace direct MAC access with
>     dpaa2_switch_port_has_mac()
>   net: dpaa2-eth: connect to MAC before requesting the "endpoint
>     changed" IRQ
>   net: dpaa2-eth: serialize changes to priv->mac with a mutex
>   net: dpaa2-switch: serialize changes to priv->mac with a mutex
>   net: dpaa2-mac: move rtnl_lock() only around
>     phylink_{,dis}connect_phy()
>=20
>  .../freescale/dpaa2/mac-phy-support.rst       |  9 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 87 ++++++++++++-------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 11 +--
>  .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 70 ++++++++++-----
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 16 +++-
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  | 10 ++-
>  .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 45 ++++++----
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 59 +++++++++----
>  .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  9 +-
>  9 files changed, 212 insertions(+), 104 deletions(-)

For the entire patch set:

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
