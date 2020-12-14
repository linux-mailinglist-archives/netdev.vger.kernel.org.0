Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CB2D9E45
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502435AbgLNRzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:55:00 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:10534
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406668AbgLNRyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 12:54:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaPSZfQejrcwLSsDSB/sI9MbAxGc4AOsTPrc/b595W5tgdepglIQiublaZaq44QhUvNfEOxSMAM4tS0dXVIhfuFxL/5hLHHa9NSAsMS5Z5JlELG5nK5hjzggy2cR+bjqo08vZavMt0so/CfGBzXdZai8hOHVcO5YCXQPTxo2zR+Ik2nSWZGu1ruQ7MDr1EaGpl1mo7QYLQDnZvtkAVyUwKgXkG0wqWsOnNLxe9qtuHbootCt641NbpKHlRJ2EKpG8GSqNeLhIRF2/BjzrA17Md3TOBckfSHwPEH3f/FXeHAdaitpF7Oyx9+vD67Orxgu3Lc/yshFC3Z6I1dxa5GaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BP8QP8mJssRYP8bG+bZEvaEvhqMJDbkWEzZAJ5nwZnI=;
 b=alfKixHEd8BNNHM+1ev4QvR6/1vTZNHnex2ONICzehiwpi1gm+Kgn9SpmxlfvBeSGohx7at+8GRcFqmJvLYRTxC6VbW2My6osp2JA1qLquKJv8V3bdLsSxU8/08WaRBGLVBYYSYA2hmX8Ik1CqO07FqS60ZgXkZB8FZB/urxja5oGhVCypaChFZr8DChKB180fTA0G59rAHyZqjyooST26SecNiwYed5b/nbWKHybOFHCvzcw2QLFgl21Xj0JYxW/4bq2+Y+D+b0QNQLkDQ4KHrJFP8XqWha5upDfp0+118c4yKpoqHo4a6RoYV4WoHjTFhNg7yv6hLbscIqpp2YAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BP8QP8mJssRYP8bG+bZEvaEvhqMJDbkWEzZAJ5nwZnI=;
 b=WpFa/ZVqc+Je/KOh4sn8iTH7vkm8/P0vvEaQMvvHY2ytX8WLXWVefNmAfJHXqYWLE4Tot1AQRVAE7pYFvZcd7bqIiK2UwWwUMtwKFu7vLxijMZW5dXjU8UM4t3TbQoCfJmZrJ39YauNopcdwqeYkAVcfjRMRN15qOyuHAg2Xwn8=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3454.eurprd04.prod.outlook.com (2603:10a6:803:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Mon, 14 Dec
 2020 17:53:54 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 17:53:54 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "saeed@kernel.org" <saeed@kernel.org>
Subject: RE: [PATCH v3 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Thread-Topic: [PATCH v3 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Thread-Index: AQHW0K58fhXR2ZVqX0yJid90gGFHYKn24ddQ
Date:   Mon, 14 Dec 2020 17:53:53 +0000
Message-ID: <VI1PR04MB5807521D3A620F73B0032A98F2C70@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1607794551.git.lorenzo@kernel.org>
In-Reply-To: <cover.1607794551.git.lorenzo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a9f7348-44c5-4aa6-6a3f-08d8a05938f7
x-ms-traffictypediagnostic: VI1PR0402MB3454:
x-microsoft-antispam-prvs: <VI1PR0402MB34542B60F487F9B700136520F2C70@VI1PR0402MB3454.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b86Mywx+yUw3P/SK5cbJH/y5lsDMk3M9UW03sq4ZkO2idF1SjL+wf1+H9o2tIot0vIGvhdZvTLg0ez+zwy9HIFAug/AE6/XKayp3JBFfF8tswJICJCtAKiX85AftpUYGhe2s8MVzB6bK038Jn22a95sTEEtLaVY/eK1mWoCN52hN8Qlh+9rdJtrseja50dV7Z+vhS4iCybgKTg/rUA/cOWXNSCqYpLrvSyejFMJUchqTCUVAhhzMjm4Q6fYGBypJogFql+H2nEVwomPGQISzyhiJNfmucVtYzjan63mN+/FqHk2cSETVR8/dTDYrJMWF2tQAxcCRGPT36uF7iNwppg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(396003)(136003)(376002)(52536014)(2906002)(5660300002)(7416002)(55016002)(6506007)(9686003)(7696005)(71200400001)(53546011)(66556008)(26005)(66476007)(316002)(4326008)(66946007)(76116006)(64756008)(478600001)(8676002)(86362001)(186003)(8936002)(66446008)(83380400001)(54906003)(33656002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cTnVka7VcRSFpa8eI2GFMgF7V8x5A7iLwb+yJvEQZDXsqgJ2Rbb313LlTBl6?=
 =?us-ascii?Q?U6zoxIMLHK/E9btNZEeDKHcdkvmbmsdRCdh5sZgP+aOELDuPDnuksZsFT5YI?=
 =?us-ascii?Q?pX0iX7qdCW3c5ySAHXTKx1jRVgYPb+pjdgoPcKpUVHnnOKFiTQS1it8/ekid?=
 =?us-ascii?Q?MrIUUA8V5CTrq7eoVA2EuEhbcQQTT3+l2s2ncHFVoHPmphdIDXnDuKV+0Ijq?=
 =?us-ascii?Q?jli8X3ZtmT2LjFnm3bf/w2z10XSxSY0/J07mTxmyvJH53WDUQKN1C9Yp7Zwl?=
 =?us-ascii?Q?QBZMKRiYTrr+tNgJ6uX/UaIYmBq87aKQXKq2u8MHIP/PVs9QsFJPqs8C+Ik4?=
 =?us-ascii?Q?EVS0EptsnGc1DneaGEshHBWaJG9Nmalnj5VGXwLeqUp9ZvN7TwX87XDelwq7?=
 =?us-ascii?Q?WhJmg8wAnZwyBHGYgBCiyQm9OZV5XvlozK41Axlv0HoLImVpeiW/G0H8GRwO?=
 =?us-ascii?Q?Hk92zJGzHYa9gD7TLxoChaCUXx4joVHOrL3wuCzT8PY0K8kK1MFMlJaMBz72?=
 =?us-ascii?Q?NS8QleDO+8J3fFPA4fTe617zHi1kOmj9foAcSWVrVvkypsa+6u2AzmeZ6yPV?=
 =?us-ascii?Q?oOWgDlxg13rBg9W8mql1p8hijl/Hu8To4chLf0SLYdj9ECShjCb52aAyD1n8?=
 =?us-ascii?Q?DymHS+q7SS/Fm+leshTe/NVUHhkCOwpmDMy/mVTZnT5JCW6L4UsFfW1JvN2Z?=
 =?us-ascii?Q?NK+VSP2PEGtY6oyePsg0rRQyiBCGVIFpEJqIYJ1xJc7l4nJApy1y6bTu/qxh?=
 =?us-ascii?Q?VQ5y+Hmwm0BfmW/V0/snMtlePHDnW9nykTgktcIqpWf+Ba/YphO5s2QYH7Th?=
 =?us-ascii?Q?BkAVildGYVPPpjbqKlATCY1zSB9q2zKeSooe32m7lymr1hRyCVKKy0ipiSCN?=
 =?us-ascii?Q?FSjsHq+SntECdAKKYjqdKd0HZZk1XRn+APzWAtw9Pi+xjePyDzdaf5Ttglw8?=
 =?us-ascii?Q?e0Um+Hw4dmRhwwu8Zwt6gfjlXFf2+b8T18n+/ZUsnhM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9f7348-44c5-4aa6-6a3f-08d8a05938f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 17:53:54.0567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ufoWxlMH0OsCD1CkDOheINPV5zZIznHgy9G3K7qpHjXejxvo8+ulWHDHQKuDf2ZS6d429AVfNAmgbo/X9Zc4Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Sent: Saturday, December 12, 2020 19:42
> To: bpf@vger.kernel.org; netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; ast@kernel.org;
> daniel@iogearbox.net; brouer@redhat.com; lorenzo.bianconi@redhat.com;
> alexander.duyck@gmail.com; maciej.fijalkowski@intel.com;
> saeed@kernel.org
> Subject: [PATCH v3 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
>=20
> Introduce xdp_init_buff and xdp_prepare_buff utility routines to initiali=
ze
> xdp_buff data structure and remove duplicated code in all XDP capable
> drivers.
>=20
> Changes since v2:
> - precompute xdp->data as hard_start + headroom and save it in a local
>   variable to reuse it for xdp->data_end and xdp->data_meta in
>   xdp_prepare_buff()
>=20
> Changes since v1:
> - introduce xdp_prepare_buff utility routine
>=20
> Lorenzo Bianconi (2):
>   net: xdp: introduce xdp_init_buff utility routine
>   net: xdp: introduce xdp_prepare_buff utility routine

For the drivers/net/ethernet/freescale/dpaa changes:
Acked-by: Camelia Groza <camelia.groza@nxp.com>

>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  8 +++-----
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 ++-----
>  .../net/ethernet/cavium/thunder/nicvf_main.c  | 11 ++++++-----
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 13 +++++--------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 +++++++++---------
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 17 +++++++++--------
>  drivers/net/ethernet/intel/igb/igb_main.c     | 18 +++++++++---------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 +++++++++----------
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 +++++++++----------
>  drivers/net/ethernet/marvell/mvneta.c         |  9 +++------
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++++------
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +++-----
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 ++-----
>  .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    |  7 ++-----
>  drivers/net/ethernet/sfc/rx.c                 |  9 +++------
>  drivers/net/ethernet/socionext/netsec.c       |  8 +++-----
>  drivers/net/ethernet/ti/cpsw.c                | 17 ++++++-----------
>  drivers/net/ethernet/ti/cpsw_new.c            | 17 ++++++-----------
>  drivers/net/hyperv/netvsc_bpf.c               |  7 ++-----
>  drivers/net/tun.c                             | 11 ++++-------
>  drivers/net/veth.c                            | 14 +++++---------
>  drivers/net/virtio_net.c                      | 18 ++++++------------
>  drivers/net/xen-netfront.c                    |  8 +++-----
>  include/net/xdp.h                             | 19 +++++++++++++++++++
>  net/bpf/test_run.c                            |  9 +++------
>  net/core/dev.c                                | 18 ++++++++----------
>  28 files changed, 156 insertions(+), 195 deletions(-)
>=20
> --
> 2.29.2

