Return-Path: <netdev+bounces-2019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D2B6FFFAD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CD591C210FB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E1C81D;
	Fri, 12 May 2023 04:36:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEF7F5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:36:28 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEB3172D;
	Thu, 11 May 2023 21:36:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do5AB0obkJelgYGgwMQAnTNGOvlQcZa1cNo0BLiWdetdQERPE0SNIEQ5ZVgHU1kmfZtSZVkNb72a9VBZxFnlVqXPOu8ThV8pdE46uu4nEYEYeLwt+ixbTffwQnXJm8Fy5+J0o2XzK5eoZIaf153Pbyr2bEc8dTDo/qjPEAOnyHv7XORGTEgpYzr+aws6g/3OipRP7a+O5RGPmjuEuI4MEBr3+p6n326p7QXNVajhVmm0Z0+K9jCh1ppzmqOeDCZC47v5bEcVqhJPelC9giVBrWFcl9sxDHdv/eHBErwQ4YUV7au7x7LBOdC/EN2caz+ddhmab3CdID18cMTn3rCOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmeKQwmF/YsDLKVDbyIV4XyUoSTPvOi7rdpmL+iye7o=;
 b=QwTYVhlDUxwA96oVLqWF8WAKQxQajO5wJpTxfDDqB3X+ewDgsXlObf5D5SAiGZAdXhJ9jPAO2KwcVtxKB6+8/RG/TktlZlh3sLrvzk0knhSuvljDz29n34RpADECJgaKGstZz8I9IDSkxV0lHC5/YtZiOhHynhg94/qFaYCKD6FJ2BCaiqUeO96Tb0Y4LaU5BbFiQ6AAdRwHcZlU2KoE4IzWaJzQs+WMqedScGYI49LnDLu8PcDd48Ort2j2GS2mxf5XXyHORabhfYkWuHAmfoFzpy+cTZUlRXdiD0r5MTSoO/tsWQ357N0cK3SSLUbA3hGgtsaKQPByLLEW3aF15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmeKQwmF/YsDLKVDbyIV4XyUoSTPvOi7rdpmL+iye7o=;
 b=cP+3RZWZsQdgel2ZF1x1J13EWd/+ts4/BNeggQVYlQSrnS9rh/6JWQoaCw4sgyELuab9Vl7XHohi7kuB/o+4sWVrFK4HWFxnmPlCWeS0P77aOKbopWEoc/09cCfsEdoG6TrStOqfNGJbFwpKmbKgeofo8YLjTMgST7iQZiHs1ck=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 04:36:22 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 04:36:21 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "Simek, Michal"
	<michal.simek@amd.com>, "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [EXT] [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
 support
Thread-Topic: [EXT] [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
 support
Thread-Index: AQHZgxyPRVvDiAnQN0uxcWVX7JqDua9ThMSAgAKJF8A=
Date: Fri, 12 May 2023 04:36:21 +0000
Message-ID:
 <MW5PR12MB5598B6DD3FE8C82FC5F8961187759@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
 <CO1PR18MB46668BFF80E186AA255D03F5A1779@CO1PR18MB4666.namprd18.prod.outlook.com>
In-Reply-To:
 <CO1PR18MB46668BFF80E186AA255D03F5A1779@CO1PR18MB4666.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|PH0PR12MB7957:EE_
x-ms-office365-filtering-correlation-id: 0699d7f0-d611-427c-e3ca-08db52a26faa
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Do0BhKCXR48CPiCNPRm/bq+cuRRJ7fpizLEtsOkUfaOV0889IFY0mXmniaJs8szk3mWbmSjOgYZ5Bka6WPMPo9cz6/LDNAtoNErLyWbS2klhV9pMlFE9zvME9v5G3gNJ5KLkFnZPOVwMOZXAE5PyYDnHGaqPKkGv5bwpOSEEEJtUEHU8XkuNXxEQKDCUxBGzz1xOqylSCkYK9z/c4RbGtcF29i0assSXCUxoCia/LJUkn9EGnYRmHsjzgRPSRfUt/4DOCci1SXVr313ySfc9zTCRYQLTBKGV7jCRYpS5xtdVocHU8XHeZottQK9UN/nDuUP4/OPHx+iFXBt0yPQWBApSQ2QZJMseIYwGZmPRNhjSIEHZvnng4z72Qs7WoUtEt4ne5EY1aBQO033VJy/JZ7dEm+S9K+pT6AzrBkyuW1NMv6ZIWci9lOz/OX9MRorS+IZqZRf2JCts1R9gKz94z2TzrSHPoGuezEUZQFjRNcWTJOEK3ypmg/owuNumtbM2cVnUb7xciqO6/IBg+VRR1/in9ob/uY/DIJ3kWtFW/m9ZNYcurO7Z2gH0X/tqfNqnOLLl3WNQ+CLXtWih7GMGsJNccSA6YsOdN+BJhxUUPBc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(316002)(110136005)(54906003)(478600001)(7416002)(7696005)(966005)(86362001)(4326008)(76116006)(66946007)(64756008)(66476007)(66556008)(66446008)(83380400001)(8676002)(41300700001)(122000001)(33656002)(8936002)(38100700002)(38070700005)(52536014)(55016003)(71200400001)(26005)(2906002)(30864003)(186003)(6506007)(9686003)(5660300002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2EOdcsi0KXPnDOqAIqc6V/fglCywo3w4ud2qHhm1kl/lDazwg9WyyYaErLG3?=
 =?us-ascii?Q?bD89pdqPhwX0IpY0wNrKSgB8D0wxz03q99zkpdLiKjnK8ctoknaWAisD10sP?=
 =?us-ascii?Q?sBCukungWTbqMSoG2aKRuQ4urMLbuavahwIF4pTmXpF4lBzXrOGKy631dLar?=
 =?us-ascii?Q?3WCQWhSZavvPG8NUx6yk4vVUehaLPRVI1KJwqfe3GupSKbmox5xusGcPJzR3?=
 =?us-ascii?Q?BeKKH6oHGulRhzVRmURMnwgfpDL5K7YbQBnelZ/i/IEM4V+j3Ee0Pc/0+CID?=
 =?us-ascii?Q?HZgn92JRF1gbbFWtyM0T4lTPSWKrCIIcUQFNUkzumiVizWDv4D/AqI4sGXHs?=
 =?us-ascii?Q?Ja72YRl9weVo8Sp1edA0LmumsR+pld7/r2v87ch0vjMen84YcHFlyffCXFxn?=
 =?us-ascii?Q?stydOTXFPif0SrDfA299GpgGBzFwm8qjTKYNgMEzttjSGNJwuL0xNzpGdaO6?=
 =?us-ascii?Q?PbFrQyHHNW3uBCttDnvwL7J06IR3QzDos6xAMEEcysvy8xKLKpMvcdTZbdgB?=
 =?us-ascii?Q?7IPH90v6u8ScFZ75Crmc8EoWsdisyz/LG/lXYkKsHZHgizye79HrdYeSO2dY?=
 =?us-ascii?Q?76Gno7LC4hERXFoVo5khkl0nyEMhcBgj9d21epoukgFPixFTlO27F3AJCTeG?=
 =?us-ascii?Q?S4+uy08g/bZJbf5Yhqo/RcEpPAuwLA9SPR3hqFEC7Wh3oDlGdJn5sm0HK1LZ?=
 =?us-ascii?Q?TSXOSjj6c2hvLT4BD0/5IxRpVb5ELlYu2vHImZ97uvaLdSlzlW8wjWhp646+?=
 =?us-ascii?Q?KFLt47I3akCUsqJC7ETJYHLlPi2gH0KdvLzcW5XZtFccmNIhmJbpwRUrAAam?=
 =?us-ascii?Q?QCJR0Ak5Qk4wxB2DWLEjGetX5mVtHAWedDlySS4OQMlaq1LQc3c44aJGLKfo?=
 =?us-ascii?Q?+TatSZJS6aNihemaxWq/aJJSUQ8pwQ+5aV96B2UiIKpHuSK/wvGmxk/uCyG1?=
 =?us-ascii?Q?e298S6W5QeHRoMk3WmBvwBRXOlVoi/TGptlOATVABDcK/BT2jn6YnsHwmIAb?=
 =?us-ascii?Q?pmsy7d/75waMNKAW+ZabbWM8dPoVNAkhWMXG+flJsHxgsdqcZAImAKloToqF?=
 =?us-ascii?Q?P4qvWoB7yq8Xrj0uwitOI6YHi7DAaCGOi8ghMhWbFfHu/A+YoJsU044QqDUh?=
 =?us-ascii?Q?WoPF/rHjuo3A5XIjQAsLQt4UdmUdmFd/BGIrN8oIWxbgAUDvI+/gzctly+ev?=
 =?us-ascii?Q?QGB44Gml4BF9VWS2hLs/MjasliJFmGVhC00KRMc9mIxY9Wufuu9kCZ4f9BAo?=
 =?us-ascii?Q?KJmjr7sP3zQ7UWcP66UhzJmnUfui+Xk13Gh8SKg7kBpvvnOdO5yHna37yf3h?=
 =?us-ascii?Q?VPs6VX366boPnQE7SCH5FjP5NHi0ypGq1hPXyMq2SrNzNerjZ/krS98v87E2?=
 =?us-ascii?Q?2Dd1WXuNvw+FUB/FFHpScGdKQigTBGvNUmfgZwscvE+Eq4kZ8onFrgXkzQNd?=
 =?us-ascii?Q?UqWqCo7nHO4e4u5lSKRMpl3CLCRBaTE8xC50Gqk9XU/EGj70jJU2Uv5JpZNH?=
 =?us-ascii?Q?hwKvAmiwbx4uXoQrFFpOLpGdVHuWjElEbMTeJEyKGG+CecKU7tNJJRN83GBG?=
 =?us-ascii?Q?4YlJ7XDG/We9ttw3KQQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0699d7f0-d611-427c-e3ca-08db52a26faa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 04:36:21.4417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tu3sU9VcyG3TurUfRiCKc5pyWKg1qsdK5PG76MZhnDIzcYD/6+y8VZELwBSthzNoA8GNI8bYhpKI1KtsrKvOrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7957
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Sent: Wednesday, May 10, 2023 7:14 PM
> To: Gaddam, Sarath Babu Naidu
> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
> Cc: linux@armlinux.org.uk; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
> Subject: RE: [EXT] [PATCH net-next V3 3/3] net: axienet: Introduce
> dmaengine support
>=20
> Hi,
>=20
> >-----Original Message-----
> >From: Sarath Babu Naidu Gaddam
> <sarath.babu.naidu.gaddam@amd.com>
> >Sent: Wednesday, May 10, 2023 2:21 PM
> >To: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> >pabeni@redhat.com; robh+dt@kernel.org;
> >krzysztof.kozlowski+dt@linaro.org
> >Cc: linux@armlinux.org.uk; michal.simek@amd.com;
> >radhey.shyam.pandey@amd.com; netdev@vger.kernel.org;
> >devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> >linux- kernel@vger.kernel.org; anirudha.sarangi@amd.com;
> >harini.katakam@amd.com; sarath.babu.naidu.gaddam@amd.com;
> git@amd.com
> >Subject: [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine
> >support
> >
> >Add dmaengine framework to communicate with the xilinx DMAengine
> >driver(AXIDMA).
> >
> >Axi ethernet driver uses separate channels for transmit and receive.
> >Add support for these channels to handle TX and RX with skb and
> >appropriate callbacks. Also add axi ethernet core interrupt for
> >dmaengine framework support.
> >
> >The dmaengine framework was extended for metadata API support
> during
> >the axidma RFC[1] discussion. However it still needs further
> >enhancements to make it well suited for ethernet usecases. The ethernet
> >features i.e ethtool set/get of DMA IP properties, ndo_poll_controller,
> >trigger reset of DMA IP from ethernet are not supported (mentioned in
> >TODO) and it requires follow-up discussion and dma framework
> enhancement.
> >
> >[1]: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> >3A__lore.kernel.org_lkml_1522665546-2D10035-2D1-2Dgit-2Dsend-
> 2Demail-
> >2D&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DwYboOaw70DU5hR
> M5HDwOR
> >Jx_MfD-
> hXXKii2eobNikgU&m=3DqvFFGXjULUP3IPFOil5aKySdkumrp8V0TYK4kQ-
> >yzsWPmRolFaQvfKMhaR11_dZv&s=3DbrEWb1Til18VCodb-
> H4tST0HOBXKIJtL-
> >2ztGmMZz_8&e=3D
> >radheys@xilinx.com
> >
> >Signed-off-by: Radhey Shyam Pandey
> <radhey.shyam.pandey@xilinx.com>
> >Signed-off-by: Sarath Babu Naidu Gaddam
> ><sarath.babu.naidu.gaddam@amd.com>
> >---
> >Performance numbers(Mbps):
> >
> >              | TCP | UDP |
> >         -----------------
> >         | Tx | 920 | 800 |
> >         -----------------
> >         | Rx | 620 | 910 |
> >
> >Changes in V3:
> >1) New patch for dmaengine framework support.
> >---
> > drivers/net/ethernet/xilinx/xilinx_axienet.h  |   6 +
> > .../net/ethernet/xilinx/xilinx_axienet_main.c | 331
> +++++++++++++++++-
> > 2 files changed, 335 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> >b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> >index 10917d997d27..fbe00c5390d5 100644
> >--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> >+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> >@@ -436,6 +436,9 @@ struct axidma_bd {
> >  * @coalesce_count_tx:	Store the irq coalesce on TX side.
> >  * @coalesce_usec_tx:	IRQ coalesce delay for TX
> >  * @has_dmas:	flag to check dmaengine framework usage.
> >+ * @tx_chan:	TX DMA channel.
> >+ * @rx_chan:	RX DMA channel.
> >+ * @skb_cache:	Custom skb slab allocator
> >  */
> > struct axienet_local {
> > 	struct net_device *ndev;
> >@@ -501,6 +504,9 @@ struct axienet_local {
> > 	u32 coalesce_count_tx;
> > 	u32 coalesce_usec_tx;
> > 	u8  has_dmas;
> >+	struct dma_chan *tx_chan;
> >+	struct dma_chan *rx_chan;
> >+	struct kmem_cache *skb_cache;
> > };
> >
> > /**
> >diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> >b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> >index 8678fc09245a..662c77ff0e99 100644
> >--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> >+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> >@@ -37,6 +37,9 @@
> > #include <linux/phy.h>
> > #include <linux/mii.h>
> > #include <linux/ethtool.h>
> >+#include <linux/dmaengine.h>
> >+#include <linux/dma-mapping.h>
> >+#include <linux/dma/xilinx_dma.h>
> >
> > #include "xilinx_axienet.h"
> >
> >@@ -46,6 +49,9 @@
> > #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
> > #define TX_BD_NUM_MAX			4096
> > #define RX_BD_NUM_MAX			4096
> >+#define DMA_NUM_APP_WORDS		5
> >+#define LEN_APP				4
> >+#define RX_BUF_NUM_DEFAULT		128
> >
> > /* Must be shorter than length of ethtool_drvinfo.driver field to fit *=
/
> > #define DRIVER_NAME		"xaxienet"
> >@@ -56,6 +62,16 @@
> >
> > #define AXIENET_USE_DMA(lp) ((lp)->has_dmas)
> >
> >+struct axi_skbuff {
> >+	struct scatterlist sgl[MAX_SKB_FRAGS + 1];
> >+	struct dma_async_tx_descriptor *desc;
> >+	dma_addr_t dma_address;
> >+	struct sk_buff *skb;
> >+	int sg_len;
> >+} __packed;
> >+
> >+static int axienet_rx_submit_desc(struct net_device *ndev);
> >+
> > /* Match table for of_platform binding */  static const struct
> >of_device_id axienet_of_match[] =3D {
> > 	{ .compatible =3D "xlnx,axi-ethernet-1.00.a", }, @@ -728,6
> +744,108 @@
> >static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
> > 	return 0;
> > }
> >
> >+/**
> >+ * axienet_dma_tx_cb - DMA engine callback for TX channel.
> >+ * @data:       Pointer to the axi_skbuff structure
> >+ * @result:     error reporting through dmaengine_result.
> >+ * This function is called by dmaengine driver for TX channel to
> >+notify
> >+ * that the transmit is done.
> >+ */
> >+static void axienet_dma_tx_cb(void *data, const struct
> >+dmaengine_result
> >*result)
> >+{
> >+	struct axi_skbuff *axi_skb =3D data;
> >+
> >+	struct net_device *netdev =3D axi_skb->skb->dev;
> >+	struct axienet_local *lp =3D netdev_priv(netdev);
> >+
> >+	u64_stats_update_begin(&lp->tx_stat_sync);
> >+	u64_stats_add(&lp->tx_bytes, axi_skb->skb->len);
> >+	u64_stats_add(&lp->tx_packets, 1);
> >+	u64_stats_update_end(&lp->tx_stat_sync);
> >+
> >+	dma_unmap_sg(lp->dev, axi_skb->sgl, axi_skb->sg_len,
> >DMA_MEM_TO_DEV);
> >+	dev_kfree_skb_any(axi_skb->skb);
> >+	kmem_cache_free(lp->skb_cache, axi_skb); }
> >+
> >+/**
> >+ * axienet_start_xmit_dmaengine - Starts the transmission.
> >+ * @skb:        sk_buff pointer that contains data to be Txed.
> >+ * @ndev:       Pointer to net_device structure.
> >+ *
> >+ * Return: NETDEV_TX_OK, on success
> >+ *          NETDEV_TX_BUSY, if any memory failure or SG error.
> >+ *
> >+ * This function is invoked from xmit to initiate transmission. The
> >+ * function sets the skbs , call back API, SG etc.
> >+ * Additionally if checksum offloading is supported,
> >+ * it populates AXI Stream Control fields with appropriate values.
> >+ */
> >+static netdev_tx_t
> >+axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device
> >+*ndev) {
> >+	struct dma_async_tx_descriptor *dma_tx_desc =3D NULL;
> >+	struct axienet_local *lp =3D netdev_priv(ndev);
> >+	u32 app[DMA_NUM_APP_WORDS] =3D {0};
> >+	struct axi_skbuff *axi_skb;
> >+	u32 csum_start_off;
> >+	u32 csum_index_off;
> >+	int sg_len;
> >+	int ret;
> >+
> >+	sg_len =3D skb_shinfo(skb)->nr_frags + 1;
> >+	axi_skb =3D kmem_cache_zalloc(lp->skb_cache, GFP_KERNEL);
> >+	if (!axi_skb)
> >+		return NETDEV_TX_BUSY;
> >+
> >+	sg_init_table(axi_skb->sgl, sg_len);
> >+	ret =3D skb_to_sgvec(skb, axi_skb->sgl, 0, skb->len);
> >+	if (unlikely(ret < 0))
> >+		goto xmit_error_skb_sgvec;
> >+
> >+	ret =3D dma_map_sg(lp->dev, axi_skb->sgl, sg_len,
> DMA_TO_DEVICE);
> >+	if (ret =3D=3D 0)
> >+		goto xmit_error_skb_sgvec;
> >+
> >+	/*Fill up app fields for checksum */
> >+	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
> >+		if (lp->features & XAE_FEATURE_FULL_TX_CSUM) {
> >+			/* Tx Full Checksum Offload Enabled */
> >+			app[0] |=3D 2;
> >+		} else if (lp->features &
> XAE_FEATURE_PARTIAL_RX_CSUM) {
> >+			csum_start_off =3D skb_transport_offset(skb);
> >+			csum_index_off =3D csum_start_off + skb-
> >csum_offset;
> >+			/* Tx Partial Checksum Offload Enabled */
> >+			app[0] |=3D 1;
> >+			app[1] =3D (csum_start_off << 16) |
> csum_index_off;
> >+		}
> >+	} else if (skb->ip_summed =3D=3D CHECKSUM_UNNECESSARY) {
> >+		app[0] |=3D 2; /* Tx Full Checksum Offload Enabled */
> >+	}
> >+
> >+	dma_tx_desc =3D lp->tx_chan->device->device_prep_slave_sg(lp-
> >tx_chan,
> >axi_skb->sgl,
> >+			sg_len, DMA_MEM_TO_DEV,
> >+			DMA_PREP_INTERRUPT, (void *)app);
> >+
> >+	if (!dma_tx_desc)
> >+		goto xmit_error_prep;
> >+
> >+	axi_skb->skb =3D skb;
> >+	axi_skb->sg_len =3D sg_len;
> >+	dma_tx_desc->callback_param =3D  axi_skb;
> >+	dma_tx_desc->callback_result =3D axienet_dma_tx_cb;
> >+	dmaengine_submit(dma_tx_desc);
> >+	dma_async_issue_pending(lp->tx_chan);
> >+
> >+	return NETDEV_TX_OK;
> >+
> >+xmit_error_prep:
> >+	dma_unmap_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
> >+xmit_error_skb_sgvec:
> >+	kmem_cache_free(lp->skb_cache, axi_skb);
> >+	return NETDEV_TX_BUSY;
> >+}
> >+
> > /**
> >  * axienet_tx_poll - Invoked once a transmit is completed by the
> >  * Axi DMA Tx channel.
> >@@ -912,7 +1030,42 @@ axienet_start_xmit(struct sk_buff *skb, struct
> >net_device *ndev)
> > 	if (!AXIENET_USE_DMA(lp))
> > 		return axienet_start_xmit_legacy(skb, ndev);
> > 	else
> >-		return NETDEV_TX_BUSY;
> >+		return axienet_start_xmit_dmaengine(skb, ndev);
>=20
> You can avoid this if else by
>  if (AXIENET_USE_DMA(lp))
>          return axienet_start_xmit_dmaengine(skb, ndev);
>=20
> and no need of defining axienet_start_xmit_legacy function in patch 2/3.
> _legacy may not be correct since you support both in-built dma or with
> dma engine just by turning on/off dt properties. Also does this driver ro=
ll
> back to using in-built dma if DMA_ENGINE is not compiled in?

We wanted to separate it to support future maintenance or deprecation=20
with a separate wrapper. It is only a preference and either approach is ok.

There is no fallback to built in DMA. The intention is to use dmaengine
as the preferred approach and eventually deprecate built-in dma.=20
If DMA_ENGINE is not present, the dma channel request fails through=20
the usual exit path.

Will address remaining review comments of 2/3 and 3/3 in the next
Version.

Thanks,
Sarath



