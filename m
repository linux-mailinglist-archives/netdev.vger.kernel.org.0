Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67967B540
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbjAYO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjAYO7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:59:04 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2074.outbound.protection.outlook.com [40.107.13.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7F62CFC9;
        Wed, 25 Jan 2023 06:59:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7hUtfigmJ9liYndAXuVD1qEX6xFwzkx7HQvcTCcEOzpN2DN7e2I3XXJQQQrH4Lx6+jFZLuCr6Bqmg2oDRZU/Ggnu2QlcgdoInYuikdhVlUdH2RAq3/q5wJCyzEZ9ccVtPZP04dc9znVnaJkmi4EW6UJsvEqJqRmP3gVw5lf6k/P0OtLtSo1iCfSxY+vUSYc358SxED/LCW8+wCstprYu+I5OZQ+lzHK/5ZKk4OjHx5HJl6kO/amVMKiIhNhwOVLOkRfo6t1VrqcT2Qa5XHMaQwyLkfSjg4TPyCEH8sOqIWq0ksH7tLAXQ11sr2p2Tz4FYKV8F05mAGrDVxXI6Iz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUgYT9b0WX1CbjFmmAbAO1YxCnIMElcV9VzCCCTphXw=;
 b=PBBZtGqBnuq5EoSckRMYrO4B7VHRHPa5H1uwG0z9k5orEUZRFl7G85hPjl0EmnXS+EkFZV5dXmlImyanEVQEkwyWon8P1p9LiBLxs9Ffp9/eUT2t5RMEG/55Z2Eb1sfEMyP3uCpapnRvIFEMXXbqgWL3zyIwmwBqfisAaHjJLApv6jNxUlaswahBecC4REdVa81b+pSvITg7/5b7qwrBJNFGzPWOjaV9jhhroxL1sjvPg+ukl6E3SILIlXDWWo1Ns+IPvijfuxpw2CGOHjlcetWvYHvfiuZqwfu0G2PkgIqRybuKJQYwW/u9F4vqTu4TLVAr2xpLbEs6I17jHnwnGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUgYT9b0WX1CbjFmmAbAO1YxCnIMElcV9VzCCCTphXw=;
 b=FlUXPwib0WOU47ffB7G96uuKpBXwaJS2VLkajHicMMEOtPdi+8mlpPc27++gV8Fbi7agTSVR6xFIFRoy/dbLYQeXQO9hE750g2DeESiIB4dMuz58OkXE3W9CfyF/NOQ9E4kAa97i6AJcO41iksriMkJfSDqLN7upWI/+GVhR4m8=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6878.eurprd04.prod.outlook.com (2603:10a6:803:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 14:58:57 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::471d:5b0f:363c:5d60]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::471d:5b0f:363c:5d60%5]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 14:58:56 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "manishc@marvell.com" <manishc@marvell.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net v2 4/5] dpaa_eth: execute xdp_do_flush() before
 napi_complete_done()
Thread-Topic: [PATCH net v2 4/5] dpaa_eth: execute xdp_do_flush() before
 napi_complete_done()
Thread-Index: AQHZMJGNeUJQ6yAy/ESOIYM3G1Q81K6vOQ3w
Date:   Wed, 25 Jan 2023 14:58:56 +0000
Message-ID: <VI1PR04MB58072AA61FA976FE67EA0511F2CE9@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
 <20230125074901.2737-5-magnus.karlsson@gmail.com>
In-Reply-To: <20230125074901.2737-5-magnus.karlsson@gmail.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5807:EE_|VI1PR04MB6878:EE_
x-ms-office365-filtering-correlation-id: 8da85ece-82b7-450e-8602-08dafee4aefb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c/koBWgb/f/faGcGy2/j7HwgrklTPTvOXaFhc71R60BT5DHcN1Pl+WO8ySZUUfxXbCZxOvvRtYolzAjW8+ZFgkC1SILMSb6SmA5JSocBBOs/7/5RvmY98V29GbthqmGaKyZhF7urimBSdasOL1kiGU8IhS/SOWN4IWkOcAaAOBxCbDgtdBIB0NeYqBmYNsf1S3cQQFhQ1atcZ/621W/rD0OnDYYzAX8SJCkFARIZsluqDJSFCPppXnA+uWzm05IG8nri3TOUg/RyBor59vc1x2gr7W3b9vqRt4vJZaPp2eUanvGhToT5g8+Z+3XL8KDceU31JzliCKdY8jEIDbzkFm4h4gWQtD7CUF9Pv9LZ63ss6A+dLuigN1afFLL+T6pXALJAeIkXVq3OlPItBXj+/vZJRCcY9vL2+Si6ZVJ2t6xHed7t6tgkvE6xHiDWBs4bA2VyU9JLyqr82r8it6tk/t+V76QGxTIpCHDDo0aRVwZID3lQ+6fqpJWDyRZneSHyxoBlRPEV+2utKuIfzmnO9jJsHDqgQCd4hw+AHEXua1AxhcbHe3wPQO718iFgh0NvZQCnbAp92NBg6h2fo0pstO7bBR9Od+PyoMAcQlNpYqWCxa14Zh3q7Z60Mtd0ID3eemmleuzPJhPY9U71T1NROlxw8lOQtA1q2GYGI8Aw3XOmMPeK+v6e0QCkRbBRci6tUEmkoxI6+Bw3CHCjV6rvSl+BGsxs2yBByGAfAHK0i2SxrWALgZlwh0iahDONW7BQNJK4lVlgAf9oQkSexGD5+Yq49ys22RS1gGGflVMU9XM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199018)(5660300002)(86362001)(33656002)(83380400001)(122000001)(186003)(66574015)(478600001)(316002)(110136005)(66946007)(6506007)(53546011)(8676002)(64756008)(26005)(71200400001)(38070700005)(76116006)(966005)(66476007)(6636002)(66556008)(7696005)(2906002)(7416002)(921005)(38100700002)(55016003)(55236004)(9686003)(66446008)(8936002)(52536014)(4326008)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Gb3TsOKk5Dz9WvpKi2avxvaKoUHvVX85oyivTZZjwyuzSHwLWNMGiGUnFo?=
 =?iso-8859-1?Q?zwBojkL5uOAt3NpRXDCM94VHInULt7QdL3GgK/dWeyiYf2LFzd9w70dKLg?=
 =?iso-8859-1?Q?A7XG9TO4fdJe5QQLouxAz0jDdAjItgZ8Oz88hl3NFaEg7rTtIbkDwY44uH?=
 =?iso-8859-1?Q?S2Czchg/ap+stzSAeXZ3+zhIzJFamZhoNGQeUNhdcoWRHyhbowLDHnUvvr?=
 =?iso-8859-1?Q?/85cUtp1vs2/88CW3bWUKwaRPYPv7OxBsF4zmEtGfNyKgAFZiQ+hjB9/nY?=
 =?iso-8859-1?Q?wewCMvLWORy/jAHMO3HGMAR4R+winiuYKOs9v4kPphMoYNXXVYjoxbp6VV?=
 =?iso-8859-1?Q?Kr4FIEX7GVQDZibr43x8vX66SyFNnWewcuw57HP0ZTKCgAzAscRsp5G/cj?=
 =?iso-8859-1?Q?FFAhGHayX8H6EtHCcKy8Ec0QXINFjU2MeNIeBc220BlNhF3gOO4uhA6FAk?=
 =?iso-8859-1?Q?kNn5hCB+4uGaxW4YoDpK0pUSuwAU+zJpszQU3unxrInBhZu7UjffXt0TY1?=
 =?iso-8859-1?Q?UN5ElyqUj8wDSRFlpMWHMQzuaXbwGIvQaoxn8UtP03WnzQod1MyNCK7yzf?=
 =?iso-8859-1?Q?5z4rFFjvoouS/x4m6hM6HSfVKn4GCetUwteaOiuKw0EToz82xh8Pi5eFJm?=
 =?iso-8859-1?Q?RCO84MHzuPAXquhlYuMT/S1aJjBDWuCyfvjH5ON1RmBGeVmx0mSG2Y9q+V?=
 =?iso-8859-1?Q?ssKKM3ey7nNfE+aIBBDSwrRdC00aGKqqML9dAnj5UAeBl1X253xRfQ1ZXS?=
 =?iso-8859-1?Q?68yZTDuhukGoFeIqJPVxqjfDB6MYV6mAub8z+3FEKrB/yhaH8de2813y4N?=
 =?iso-8859-1?Q?OCQkYZHpDn9oaKOVUDoBlOqP/i6AnNqg5RcGaCuHsRE3sYE3nmQ/L9HHfM?=
 =?iso-8859-1?Q?rgCDyNDzCr0LHC982waI+P6po9rmeKAQbv7JOgoScZo6q8JnZc6dmaThdu?=
 =?iso-8859-1?Q?uU3VaT42CIrWXTNb7flzrRJKLAdiJ8jb9eV51/D4GE5xC5u8bJTVMjXD64?=
 =?iso-8859-1?Q?Jo0NIDbp7iuDVDal2Y0txR10SYPf/KcmxWwZNS2DgSNgFNTXw2zT964mxS?=
 =?iso-8859-1?Q?jygCzGn6pMakNYJVkj8seVCpU6zi5Y0gLCjjVJesb2+OBX5C8GgCo6nKmG?=
 =?iso-8859-1?Q?vf0RVvQaGhI1LLTVt7myvnl/15Ux0RE+vStawjPRLQlxB+4DneiK90x/1C?=
 =?iso-8859-1?Q?dpxfMYsOMsqQBnUMkuZ00g5QHR04JKUqsAM/2vpPiE4oqc2H8pZwwuK5Ie?=
 =?iso-8859-1?Q?30X08CnsyAK2nFoSDVXZcO1ASiubFuZaEsWnD+0BAX6KtSerRIxHL496l7?=
 =?iso-8859-1?Q?ff/ViR4n/DdoPu+mfzEgBBXt4Mn/Ep43pPGKWcBAEUfIKlHrPjbM3QRV+i?=
 =?iso-8859-1?Q?5T309Ylnb99I2v+Z3y+6DokuEzMx1Fwg2ddhalHEBW8+gSyWVWqEoMZqIs?=
 =?iso-8859-1?Q?MoFHEcStL94M7FmP2us+REscX5dNUZcduuNlctSMGTPO+igCEpHkcFfWPS?=
 =?iso-8859-1?Q?PozqtAsBVEtdmKNUOHsojRjFWV3Q4R7BRM0s9+pwP/jPO98YlaTABZFbet?=
 =?iso-8859-1?Q?mQfe2GZRO4W2QgokK21lHjoOLgsVmUH+woRMaItS/PV62rEk+0GOO4rKm6?=
 =?iso-8859-1?Q?SW40LZsh9aXlO5uZnv0GNEu8vPr7wegWah?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da85ece-82b7-450e-8602-08dafee4aefb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 14:58:56.7908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hr1YsK/tlS2UWDpX4WuUn22hyUMIPkAa6k7LPkfr70JI7evveG3uMDKJLqRdkGvP31RJPxpRACAzQi3S1nbtmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6878
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
> From: Magnus Karlsson <magnus.karlsson@gmail.com>
> Sent: Wednesday, January 25, 2023 9:49
> To: magnus.karlsson@intel.com; bjorn@kernel.org; ast@kernel.org;
> daniel@iogearbox.net; netdev@vger.kernel.org;
> jonathan.lemon@gmail.com; maciej.fijalkowski@intel.com;
> kuba@kernel.org; toke@redhat.com; pabeni@redhat.com;
> davem@davemloft.net; aelior@marvell.com; manishc@marvell.com;
> horatiu.vultur@microchip.com; UNGLinuxDriver@microchip.com;
> mst@redhat.com; jasowang@redhat.com; Ioana Ciornei
> <ioana.ciornei@nxp.com>; Madalin Bucur <madalin.bucur@nxp.com>
> Cc: bpf@vger.kernel.org
> Subject: [PATCH net v2 4/5] dpaa_eth: execute xdp_do_flush() before
> napi_complete_done()
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be followed by a xdp_do_flush() from the
> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found following the first link below.
>=20
> The second reason is that the XDP_REDIRECT logic in itself relies on
> being inside a single NAPI instance through to the xdp_do_flush() call
> for RCU protection of all in-kernel data structures. Details can be
> found in the second link below.
>=20
> Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Acked-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudfla=
re.com
> Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com=
/
> ---

Acked-by: Camelia Groza <camelia.groza@nxp.com>

Thanks!

>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 3f8032947d86..027fff9f7db0 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2410,6 +2410,9 @@ static int dpaa_eth_poll(struct napi_struct *napi, =
int
> budget)
>=20
>  	cleaned =3D qman_p_poll_dqrr(np->p, budget);
>=20
> +	if (np->xdp_act & XDP_REDIRECT)
> +		xdp_do_flush();
> +
>  	if (cleaned < budget) {
>  		napi_complete_done(napi, cleaned);
>  		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
> @@ -2417,9 +2420,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, =
int
> budget)
>  		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
>  	}
>=20
> -	if (np->xdp_act & XDP_REDIRECT)
> -		xdp_do_flush();
> -
>  	return cleaned;
>  }
>=20
> --
> 2.34.1

