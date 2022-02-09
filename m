Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2574AEC6D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbiBIIbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:31:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiBIIbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:31:18 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150075.outbound.protection.outlook.com [40.107.15.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB86C05CB8C;
        Wed,  9 Feb 2022 00:31:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/zWSA0sUVnrjVck0NgojMdQZzaqJwYzGZaI81THgIuS3Al9Y89n/w8bbOLlBRbv47tPaw62UjJaoxRWqeKf1cOzDrrYoyqmLBZPCTFqm/DUtS79aC3sGHqE8zqp8gOIvSIFNmioZqFbd2G6KijtrnU7htSoWVryTQiEdL/2h/NnhoJD53yQh4v5ZXs2B16GlevQ7W5xTructdXYZ6F7/6iSWXgOaSyJAdUPOr/giTZPvCJ+DqBUiOfrQVFQJ0zfSUW4LE5ETRIuPMOcLn4z1xyF34TWSFx8EoMItAQ/UQ17OwKniW1JrE0t3ThI//VQshVo33aC+JVM1vnAWY4DMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/hfW5qmo5VchVIKtpl8d1rDuydBQjUvO4U6+b+z/6s=;
 b=TLt1ckEpNRXSXH/gTdQ9uGBCzN4VsCbmNnT9r+syTiz7y7P5Ns4k4wDpVbPTkcjPEv6crx3qhv9azJ8hZnZyz7dtitu2S5h6vXqJsqU68AwEP6fbcvSG9LLNuF0C3QIN03pwsMtnEIdjKkHgOInrKyXe2OYOvKbpuMkEeiEcI4bh4eR+qd2hv4r46XzVU40NPgiHIWUyEpaI0H4PbpAaP87ZltbbF8Pl8Ir48FE2XrPxvLgEiTumnXPijBpR4YBEl/kpQkKyWwa8iJ3Asoz5bMGftNM+hADEj8Mm+CcR8JWlaoPsmobYWktcRkQUAJaBdjjj9b0Z/XGRw65RcVr1mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/hfW5qmo5VchVIKtpl8d1rDuydBQjUvO4U6+b+z/6s=;
 b=NuWXyJFdQqDU+IdNi3/rwIdN+RbgJavdIHRqiIErli/N9Pltl5uVVu89P1nqi6/QGgGHD8rkpj3j/LWtPkpmzGn/Ck9v74u6iXimM4R23unMmOB7JRfyQdnI379FeI90iuCXgvkXixvGsMHCclzaxGPW6oHdM7yYujkI5YTiF0Q=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by VE1PR04MB7438.eurprd04.prod.outlook.com (2603:10a6:800:1a0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 08:31:20 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908%6]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:31:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: [v1,net-next 1/3] net:enetc: allocate CBD ring data memory using
 DMA coherent methods
Thread-Topic: [v1,net-next 1/3] net:enetc: allocate CBD ring data memory using
 DMA coherent methods
Thread-Index: AQHYHXjwDD6u9tqMqEactPGiVOG/iqyK43JA
Date:   Wed, 9 Feb 2022 08:31:19 +0000
Message-ID: <AM9PR04MB8397047CA8818F0E9B113007962E9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
In-Reply-To: <20220209054929.10266-1-po.liu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2364385-2dde-4ea6-ed3a-08d9eba68c4f
x-ms-traffictypediagnostic: VE1PR04MB7438:EE_
x-microsoft-antispam-prvs: <VE1PR04MB743802BC2752B4B60A3753AA962E9@VE1PR04MB7438.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZgjIJjCHSmHfsIimDa5+I5M+YaKfNAjuMRmGq/pEjK5/B6c2ozaKHOC34pDfJPmfVgGrNEnAy9jH/L9bvqZgp6243i6wHI3siA99swQENhrAkMRHEGOKK5ho7+BKH0z19jF0+DFEwVw/OcqpEB2osEb03HawARuNTXFq8ngA2olrzKEoSrfii3a9GTQlCTFBolszBRM3NICSS7Xk4DbDE7jSj2mZNX+C5u+Ai2EqvnBkx56nmsIAvPjaE6v7LUIRI2xtCwAF2Z9AByt4QBgHQyiCYLW+S08TE8qjpJhOHioFMQA4kIZwGidyR3Hc2LwN4RDn/lVYo5f0wxFRSFN4Ept+/w8YTY3zI97J+Ij1yp5KC7XjqNTgZGZW+FCoro+VunjoK1Ly2H7NP8Ja7tOR4Wagms0Y8uIOd2iyLm8XiOwDwyM3R7UrYDgc3fGwIS1JRbQN7cS/h3U4Ubpls1OW5oBwDonWK4PMYaB5dfJUVnEw4xOKauBUY3JKckxLY+bZJNjKL6gks60LQQqm1MJV1VlZXrf54s0cqBq+tJuRgPYqYLTieO4EfZrhd/CCTmv9ok0pmeegIRjsmJHEp6/B3KSGc2MAcX8FKHkdDHYe66/47DOkFW+QKGFgv3Ll90GDgbcA/qtaYd2z8/I2LISkTfSWwdZl1p2e5Y7FnZVnAg1BrXOPd0z91QUwUbZWzOz/TNYuURQ7vPfA8gv3Ny5R7dZ68fIG+Pz2a99WVL4XGeqN03pv16NwQ64uWHuk2UDTrOemsmZY+6uEQRZK85mpQeWuzqtRktvSWz3ce0nN4DI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(186003)(38100700002)(26005)(110136005)(76116006)(8936002)(52536014)(4744005)(316002)(6636002)(44832011)(5660300002)(38070700005)(86362001)(2906002)(8676002)(64756008)(4326008)(66476007)(66946007)(66446008)(66556008)(9686003)(83380400001)(508600001)(966005)(71200400001)(7696005)(6506007)(45080400002)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LsW7g338OwFDM0ZwHLpSNhDkVsURluYkFppw+j2b/4jj4CX7GKj8Zs5TNExm?=
 =?us-ascii?Q?FDaPxPldiOiEfQ2F/KOE5QlzuTbCkGNgcb95ubDcDcafPwToIBK04MALSPia?=
 =?us-ascii?Q?3zkOFptocEq6S25kdG0rdkJw72b2hkIjNK5pyniKuVGwB58n+o9uCL9qdipu?=
 =?us-ascii?Q?+WWoAE4yQtJMWW0yLXQW/PKrz3BbfcK8U6/7nPunViI2zGB2WfdAhixN++4I?=
 =?us-ascii?Q?seNKWfMNYSWh0n8Cg410epYB7LuGgetNFJAH01S1QthUf+EpyKX2J8KlSz49?=
 =?us-ascii?Q?nizxQZPT2tgr30lIRWjVx1WRJ0kwgoYviuRDsoWTCMGHxHOPCVm9QCqdloPc?=
 =?us-ascii?Q?1F2PpjMQPo8fpHw0zOA6HsMWepcq7fVvT0s+B8jBTrRL3RIuYtikZDHKtnnd?=
 =?us-ascii?Q?V+lecWgiftMDGvW2BTnTzUHwHjyUetRWmOjQ3w9OIcwhsESr9S089ux/F8ZC?=
 =?us-ascii?Q?gadODnuXnoPtF9lFrpZL7TciYktaJXMN04eDDqPxM8WArg3Q1msPxpI7maoe?=
 =?us-ascii?Q?v99PX7qqUqF1/rnrh6glibFtcGB2dI8r0T8aysvusUiy7NjLdj/5t3C7aYOH?=
 =?us-ascii?Q?37PdpJsCnNKazTSmeL4ppkg/WCTendLm7bPTj5USjOalVSIrmwZ+MewRzgDJ?=
 =?us-ascii?Q?Xaagnf9nxCp045u790BVesDWILspGCS4W1mRx+Tv3z70xl4UtkA/oLKtBJs5?=
 =?us-ascii?Q?/3Fai+VMCG5av/hiYCP4/ss+qrgGfSv2s/SEg+sMnOqQY5GC27o0MKQcO0mt?=
 =?us-ascii?Q?HnGMqFJrFVOmbmKQ6qoJX+JQo564imUQQA4u6fjAdeL4UipwBFvnSdtvFENr?=
 =?us-ascii?Q?dh0gqSFIKKVxvm0tlSJP0rYG2tR+c749sSORVgjDRtCLrUM3Dc7Z97NNmxzt?=
 =?us-ascii?Q?gNkcmLcmZ+0kxakwTclMFzjbUwwbYerhNXplCgDHQcv5TgzDGyiJFDWTTuNE?=
 =?us-ascii?Q?T7MEJ9ffGhqDjddxle4VLovbK2QXBdou+J1d3k0siS5Vn5HqRZkmCFT4KOz+?=
 =?us-ascii?Q?5lKEZny2RjQVU/5s2a64Yxmf7DEPOw5D4LlxIjtv1bkRZEbZ4Qx3JUrdfLuU?=
 =?us-ascii?Q?ICjWnUHOYcFNZZyz/LaezaaDg1CVzcl3TGRMNZbvPmuoGNICLeOHyqBi+FN+?=
 =?us-ascii?Q?fdmyU8ewa+R6Pri1EUaixD3r/eOjRoZiz075SB83oS2ey9kKfBDi/yu8by+V?=
 =?us-ascii?Q?6L83QAs9sreHBJO3V8+AKkUYt3skrJYoervI+wTRnuQtu757XOwxzYscJ+u6?=
 =?us-ascii?Q?YQm1UDJfRQCwTB6ERXOZXA9Bx8z4bUM4/0vATSBSqoVR94mrDSIiI/iPWT9g?=
 =?us-ascii?Q?dc9auFYrrttencE1iGSuxosT7JflbQs6ci1jDpHUtT6wuUBmwcy9RBfC3amx?=
 =?us-ascii?Q?Ijco6s+zjie3Gs4nKBNFsaXKhkn8IgaOQxYWDNI45JDup7Q2MIFYxUkQHn3h?=
 =?us-ascii?Q?+bRXLlloZRAzKkxeyWeniwq9dUabCr56gpTRX19ouhcaCDPdy+i2irihYEhK?=
 =?us-ascii?Q?Q23HtjPWvFz6SfZB2BteYIRhugNYidK4TKGVrdgrcYfp0Vu/ECarcspflER9?=
 =?us-ascii?Q?Pfa2Mz75dEbhgr5ri/JhASj5HSJdrWtHK2crw83/V0ioEbjuchxaPqJWVheE?=
 =?us-ascii?Q?ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2364385-2dde-4ea6-ed3a-08d9eba68c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:31:19.9987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fD/mP5UO6ZstJdaf+P2/9XzA6tlW1f4PbVgjYM8Qz2Ex6YbreHVNJPwwh8hI3BNxtb8wEXi9gCLJuKYb3KWlSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Po Liu <po.liu@nxp.com>
[...]
> Subject: [v1,net-next 1/3] net:enetc: allocate CBD ring data memory using
> DMA coherent methods
>=20
> To replace the dma_map_single() stream DMA mapping with DMA coherent
> method dma_alloc_coherent() which is more simple.
>=20
> dma_map_single() found by Tim Gardner not proper. Suggested by Claudiu
> Manoil and Jakub Kicinski to use dma_alloc_coherent(). Discussion at:
>=20
> https://lore.kernel.org/netdev/AM9PR04MB8397F300DECD3C44D2EBD07796
> BD9@AM9PR04MB8397.eurprd04.prod.outlook.com/t/
>=20
> Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
> cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Reported-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Po Liu <po.liu@nxp.com>

Thanks, Po.

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
