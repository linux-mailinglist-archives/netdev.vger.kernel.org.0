Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5358506A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiG2NIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiG2NHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:07:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED0786C3B;
        Fri, 29 Jul 2022 06:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR21z+uqrAykFItjTLwr4mgQZ3BscMmT8gboRWzo+FxvR/R/UOiATdvA4M8nMMBTIgZAz5e6uInuqdACdS2pNhpZoxQ/BcApBY7ceq5+KdU/XaDVLpLRJLJmyOCHeuRMtKZBPqhcFDJ7hFnmZiV1RW35hlXQr8g72+vDhMwTyUhtKwzsllNntsjw3PZGgqxDjJBANCTvbUla/wf7mQlr6qcJGdwRGRaToByN1wan2RWojZ4pv+9YAFTUAk/8RKWJiPs3xeV+TlxmVbIprVE3+s0IZeMzgzxHZpKagzDKxEd31Tb5ljouf24L9VZ/9z/9ui1TPCszqJHlTSOoeLF9pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNecRRVEOgpOvQCFrsnZXE7kfD4QGhDdo5ezv9J8q1w=;
 b=dxu0BtQDvqSafoZlvS1B2Z0xblutE+8lwqTH1mfONoL8CWIFFziEv2VRNJYme5HvbklhwCRFmeQOjVm4NNE9lhVfBNy8jTb8VL1VEHbNsKZtf4cniXplFKS78vkEOqjgJhqlZXAG1e0dWWE7jn3lBrwIofKS1/MszxBhAYhPXEFkz/9d3H9ac/hV+u9AF6JuaIGBQfdO95kP4gothYXfAfv/VEg68jzlvUb5AEcsSFpQgNUyp9pQ5peENnt61KNWRaI9ISzLEhig7BFKPRVAAg9LU7oBy5AgABbZOWlyjxll5LyKVnxGksliJpfOf0o74rUAmVNIc+AqzZbK93LQ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNecRRVEOgpOvQCFrsnZXE7kfD4QGhDdo5ezv9J8q1w=;
 b=NpkqrWks/V5fkorlR5wuqmdl2pBcJs25D9FiBtofv26P+uSBWIaS7T56/SOK5tJLJKD95dRAlTy2ATA2/Yzyz145Pw43L1YXAuWyt0XW4lXtFJ6Pc00WZ+T4E1fnBpWWBfs32FktXx+ikyMvlVECw0N3popMTw5lyTiZx3hcnKU=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AS8PR04MB8449.eurprd04.prod.outlook.com (2603:10a6:20b:344::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Fri, 29 Jul
 2022 13:05:31 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::c42c:36b0:a8d0:be41]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::c42c:36b0:a8d0:be41%6]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 13:05:31 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 00/25] net: dpaa: Cleanups in preparation for phylink
 conversion
Thread-Topic: [PATCH v4 00/25] net: dpaa: Cleanups in preparation for phylink
 conversion
Thread-Index: AQHYoDi/0FyeCMejy0mOPXZmSS1cz62VVleQ
Date:   Fri, 29 Jul 2022 13:05:31 +0000
Message-ID: <VI1PR04MB5807DB400C6DDDD31FF21746F2999@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4381cf4-75c6-428a-2840-08da71630482
x-ms-traffictypediagnostic: AS8PR04MB8449:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1scJI51C9GatZn8UORJiho9URydesel9LJuIOZYwh8xCnBtx/C+kAN5A1ZGMBnal1Je94X3Xg8sEQpO5ZC68rGutNIJCnvvWwoA4Uu6YTo0Uxv4vAE3AA3/gwfxrBF59Ui8MFdbL74Ct+bvV9I7QVxPMfxoSYjKyCRO8OfA2UPU8G5u2dscWQ8uaFHYCOKrlqHTjg/ggT55cnOCSznwVxCjt8Xm2vhDhkvdxIy5tmCnxWvIBEKl4QPRkNzC8AMCTxhmoKRSQuWZJcrEBQGXknR270IggoyBSGeQrpyQYIL/ShJJZEOUOVfYEeZIQVccJ8lICLYyKLoKLVcKv/cLKvd99Fd7/E4C6USZEfxpRSrgfdylEsxnuegKKe4zMlLZTmY1mixo938I9AtEiKy92wEikw62idX/+6o+27j6/WIrmGTxWraKSx0cUsRlSQb1OpGjJLN1JdffnfzgFBb2whm9mNgJW6XuSJY0/VJdDCLuXo0EdDWQXBLVBKZI3qJDt88530Dewf1hxCwGdMi5cvihMflL9d4WmAAANeB3BqNiPU23cdomJnujKzIcVG8LZ0/wEW0lQ42J0bsCTaiQAQw96pTlhY1+N9OCyEmTqPlHmpoTM3W3K1SHAz22bxb6wuM2JBBKaQ1FwglFO7QS7LEl9GW+AUF5YGZtsf1JhV1iQlHyLg48+ismAZlIX/2qrvoUlRLfFhI1hG2hbSFA8b2718vNz6EWVBVJfAQDl8IeT5Vz4GezkXuD5iuCOM16Wotr6nWkmfdo2qxIthOnk1f6TRtVe2ROgoh2fiReB2Yni1iryhtUqg2POlszKBA7c/zgYS8JMAN6Mf3rME+Dntw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(66946007)(64756008)(186003)(55016003)(66446008)(71200400001)(76116006)(54906003)(110136005)(7696005)(478600001)(4326008)(83380400001)(2906002)(66476007)(66556008)(8676002)(6506007)(53546011)(41300700001)(26005)(38070700005)(86362001)(33656002)(122000001)(966005)(38100700002)(5660300002)(7416002)(8936002)(316002)(52536014)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NGe1fH3n3m8EjRaXa+lAjMe0Tb75m4qXIuR1HvtIffz642AGDmYTV5hql7gD?=
 =?us-ascii?Q?XzugXKeZfe7v1rAYfROLdEmAcK6dkwB7BmtZy4uJA2rZOKie7J1w9nHIKzN2?=
 =?us-ascii?Q?j9DdaDwtMSkEC+Ngp1psA0WRi5CuXTzkhDid5WVVbVfO2qwZPWZ/jF7+yZgf?=
 =?us-ascii?Q?E0DtEzLtze3AM+w7Z3RXqM6D9hCSJGk5RNODBfn7NNA1F7XDZ1/8yrgSkD6o?=
 =?us-ascii?Q?1ASWKSaOxN4Pj++elnDHQnt+4HNdPhfE1kfikaOKY89yVkfFiD9CJ5Vb062H?=
 =?us-ascii?Q?zmFzAXCox5IZeczrrpkhmiDUQV0jq9eRIVLAPxF8D9hGXyz1kHUsUXokTryz?=
 =?us-ascii?Q?A28Onc1VGWcc0KYTnNkZt8nj0Dra+peSVSXQt+DrP1tdBTGbXX+dWnEeqxzp?=
 =?us-ascii?Q?kF+wbQa7j2GHOcMUhzOeUC4RH7EzlmtfOCTIT2hcasoY9Gk74z6QU94hO31Z?=
 =?us-ascii?Q?4ry2dxIQjeueuhVcJlMxSOJKjR8CdDt4+YOTMHHOm0/6mKdHcB16jgbAZKNS?=
 =?us-ascii?Q?d4PY2Nzf3Ugwf74NAAHmSdA5mcCBoJJ0kxqOdxCg+qQi/X2S0FYOYwIVgLbM?=
 =?us-ascii?Q?KYvTaLktLdD7+AOSS9X0y6rPF48+h4Bxf4rpqOPuZhP0Z0cUj2SabkPBMFY+?=
 =?us-ascii?Q?2vkMTkqhRpVDouRvdcbHDcSH/WsAcfHHvzeL0FaBg+7vyUpYfVmbj5Gtmcz7?=
 =?us-ascii?Q?XWYUnl/kGVptOSsNafflLY5o6vYEoId0wczbHHa73XowX1y2ozpu8PblWtjt?=
 =?us-ascii?Q?I1SXjEb3joRHoad9zmzrGVdymw50ns4icJm65GcSvP+0D6UmhTIONGHh+0up?=
 =?us-ascii?Q?236R7L+fvit0fq4UmqMRAeOgXru1/VJaH4+RHO0pdspC9V33Ua7aM/Wjk2xa?=
 =?us-ascii?Q?GH3+17L1p3bDNB+moNaMd3MRm75sLcvtfUEFXIEP1h/8tAi6TMXrqrqmya+j?=
 =?us-ascii?Q?u47BP5hhmEuQZGVa9q1nDXWQFpkYuI+WORFTkeZSKnRAQuJCETwZvNbTvGUW?=
 =?us-ascii?Q?W/lxyz5gwsGMBHFy5IcY8ji/1DGJqYRkOExDOzCNyQE+UO/RIzaumVALKU6K?=
 =?us-ascii?Q?uMRq6heqUJVf+snYDG0Z4/iqNGbvx12QNT0Ix5oJUCbIUjVJsXuNU3xn1qRH?=
 =?us-ascii?Q?d8dtfeBLBzbZeDZ0kNDNugmzSzZh0PkhRlr9qCkG3PwXifofbLmAiJve9GXG?=
 =?us-ascii?Q?i/cwfjJN53Loi3EgELbYD7RyICNBc5rDTKNZm0BNVrgjmUg+nRUMljR3ZXan?=
 =?us-ascii?Q?jpztP+USPRrlHT19mduLklSlmx6HeF2k2oAYutyN5qtn4KYbxAq0DpRixysr?=
 =?us-ascii?Q?eytMnl3lIwgkIg6r0qYIS2Apw+H3zaEqmtF0eofHth+0uUL4dqQ+MlXhyUE/?=
 =?us-ascii?Q?9To/DFPsltGe1vFR/2TV81VbD410nhrECx8AVuIedcR7hxGY3ykF4WXk/AlB?=
 =?us-ascii?Q?LpnJyLbMaOyM6hiVLwR8lgYlJA4Bcm0nniOVM0cTCaorlIAI2mlEjlPZAcfi?=
 =?us-ascii?Q?E60rXWLjgATb3Lpnrl8OBWL35d8sjzdWZB7DVJ62MIfzr3MovfmLui5OZdxi?=
 =?us-ascii?Q?oa4mrDBZTbnpw1dzGRDQczNKlQBo0oAhjQgTtKY6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4381cf4-75c6-428a-2840-08da71630482
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 13:05:31.7373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NghgMrmu6WBuZgZ0CMc8RbdDF+LHbP/A+nr48YfDPGjowAO/SQBNlhst08oskmfrjz8gOhFEJPxFujCtFStYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8449
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Monday, July 25, 2022 18:10
> To: David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org; Camelia Alexandra Groza
> <camelia.groza@nxp.com>; open list <linux-kernel@vger.kernel.org>;
> Madalin Bucur <madalin.bucur@nxp.com>; linux-arm-
> kernel@lists.infradead.org; Sean Anderson <sean.anderson@seco.com>;
> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
> <leoyang.li@nxp.com>; Rob Herring <robh+dt@kernel.org>;
> devicetree@vger.kernel.org
> Subject: [PATCH v4 00/25] net: dpaa: Cleanups in preparation for phylink
> conversion
>=20
> This series contains several cleanup patches for dpaa/fman. While they
> are intended to prepare for a phylink conversion, they stand on their
> own. This series was originally submitted as part of [1].
>=20
> [1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson=
@seco.com=20

For the series:
Acked-by: Camelia Groza <camelia.groza@nxp.com>
=20
> Changes in v4:
> - Clarify commit message
> - weer -> were
> - tricy -> tricky
> - Use mac_dev for calling change_addr
> - qman_cgr_create -> qman_create_cgr
>=20
> Changes in v3:
> - Incorperate some minor changes into the first FMan binding commit
>=20
> Changes in v2:
> - Convert FMan MAC bindings to yaml
> - Remove some unused variables
> - Fix prototype for dtsec_initialization
> - Fix warning if sizeof(void *) !=3D sizeof(resource_size_t)
> - Specify type of mac_dev for exception_cb
> - Add helper for sanity checking cgr ops
> - Add CGR update function
> - Adjust queue depth on rate change
>=20
> Sean Anderson (25):
>   dt-bindings: net: Convert FMan MAC bindings to yaml
>   net: fman: Convert to SPDX identifiers
>   net: fman: Don't pass comm_mode to enable/disable
>   net: fman: Store en/disable in mac_device instead of mac_priv_s
>   net: fman: dtsec: Always gracefully stop/start
>   net: fman: Get PCS node in per-mac init
>   net: fman: Store initialization function in match data
>   net: fman: Move struct dev to mac_device
>   net: fman: Configure fixed link in memac_initialization
>   net: fman: Export/rename some common functions
>   net: fman: memac: Use params instead of priv for max_speed
>   net: fman: Move initialization to mac-specific files
>   net: fman: Mark mac methods static
>   net: fman: Inline several functions into initialization
>   net: fman: Remove internal_phy_node from params
>   net: fman: Map the base address once
>   net: fman: Pass params directly to mac init
>   net: fman: Use mac_dev for some params
>   net: fman: Specify type of mac_dev for exception_cb
>   net: fman: Clean up error handling
>   net: fman: Change return type of disable to void
>   net: dpaa: Use mac_dev variable in dpaa_netdev_init
>   soc: fsl: qbman: Add helper for sanity checking cgr ops
>   soc: fsl: qbman: Add CGR update function
>   net: dpaa: Adjust queue depth on rate change
>=20
>  .../bindings/net/fsl,fman-dtsec.yaml          | 145 +++++
>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +----
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  59 ++-
>  .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |   2 +-
>  drivers/net/ethernet/freescale/fman/fman.c    |  31 +-
>  drivers/net/ethernet/freescale/fman/fman.h    |  31 +-
>  .../net/ethernet/freescale/fman/fman_dtsec.c  | 325 ++++++------
>  .../net/ethernet/freescale/fman/fman_dtsec.h  |  58 +-
>  .../net/ethernet/freescale/fman/fman_keygen.c |  29 +-
>  .../net/ethernet/freescale/fman/fman_keygen.h |  29 +-
>  .../net/ethernet/freescale/fman/fman_mac.h    |  24 +-
>  .../net/ethernet/freescale/fman/fman_memac.c  | 240 +++++----
>  .../net/ethernet/freescale/fman/fman_memac.h  |  57 +-
>  .../net/ethernet/freescale/fman/fman_muram.c  |  31 +-
>  .../net/ethernet/freescale/fman/fman_muram.h  |  32 +-
>  .../net/ethernet/freescale/fman/fman_port.c   |  29 +-
>  .../net/ethernet/freescale/fman/fman_port.h   |  29 +-
>  drivers/net/ethernet/freescale/fman/fman_sp.c |  29 +-
>  drivers/net/ethernet/freescale/fman/fman_sp.h |  28 +-
>  .../net/ethernet/freescale/fman/fman_tgec.c   | 163 +++---
>  .../net/ethernet/freescale/fman/fman_tgec.h   |  54 +-
>  drivers/net/ethernet/freescale/fman/mac.c     | 497 ++----------------
>  drivers/net/ethernet/freescale/fman/mac.h     |  45 +-
>  drivers/soc/fsl/qbman/qman.c                  |  76 ++-
>  include/soc/fsl/qman.h                        |   9 +
>  25 files changed, 739 insertions(+), 1441 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-
> dtsec.yaml
>=20
> --
> 2.35.1.1320.gc452695387.dirty

