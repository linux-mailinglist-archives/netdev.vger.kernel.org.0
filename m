Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C1D60FFC0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiJ0SDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiJ0SCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:02:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2089.outbound.protection.outlook.com [40.107.20.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5181C6952;
        Thu, 27 Oct 2022 11:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA/9gvj2njTvs4NUsbKX2RTlOfGjFwwkZ80IRM+XvNyUZfqzTZvOS3YZBvxAIWPeCpEZcxJJ/pStgnKYG3SGjoWIaIXC9rvmCfP71ZSZDKvzUeA+Rg8Z5bFJ+R94ThoArJfst5gEiNWrSLHGXbGhJzO73RHIP5p/R5LenPNpivaPjQpNZ9n97CRgSn6uFYS1apjodwkIrJzvSj7cMDvKFirRpvHKJgli/hcfPonBIwLTSDNAEX9wYjaC0jixWv1UfE1KEsiODHkb2DXt7ll9IqMUKxrUGqXVJYccm/XpCyfZYdo9d1TYVyBsT76acPhXyfayv4omkNGHufWkp6GG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNtVPhlGJ+YP1MHWMNsWZnVcZs6bL4WNYlgOcRTRL/U=;
 b=dbqOEt27M82bDNDxjcVUizixK3KwnjT6cYCgJxyXpu0oabe2xqDR7Q7kvvdffeQKRqvbDH9dkfic1qgvP2GXR/J5FdykBuKyt46ffk/Q0bh6vIn9gcG7+a6UfmonV+WkGNHEqG3QQk1BH2AgPFJ1AEq60k6tR0rKfLI7y6PTchMF1/lN0XWPXrOKsed8M/Wjnys1KoPjKmqQjPO5s6rCXpDrTQAWelegBFicyWBiWXLX/p9bIoFFHWnwu0Xtq9AYy8sZSJg8F7tKkq9ZBFEVXVWpUcgOzEDJYGaQSZ3AOeq3e9pL+G/4ZaAgyAeGLEuKvLZbLf8F7Z/9qEdbWHS4bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNtVPhlGJ+YP1MHWMNsWZnVcZs6bL4WNYlgOcRTRL/U=;
 b=eEdgii/BGa4qmuUbWvyMtWE90QYvfIzkEm7NB2LBGA3ku+PFZc7p1IhWQJg8zW7UOasXDQU4Wcm96wnij0g3WXm+7OcFdmUbbqJ8Ehi2EBmh1KEXDaQQmpdg/POEoPteWtrEJjykTEkSJSROcVKPReBiMzqYiCKTGzwwlLKBcEw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8648.eurprd04.prod.outlook.com (2603:10a6:10:2df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 18:02:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 18:02:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Topic: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Index: AQHY6TRiZQ8LCqV8m0qJGRg70aV0FK4iiQEAgAABDIA=
Date:   Thu, 27 Oct 2022 18:02:09 +0000
Message-ID: <20221027180209.qunyi4bdikbtqfho@skbuf>
References: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
 <20221027105824.1c2157a2@kernel.org>
In-Reply-To: <20221027105824.1c2157a2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8648:EE_
x-ms-office365-filtering-correlation-id: 89fd1111-f7fa-48eb-7a75-08dab8455e3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s+GWRqQgUJ+j5DmhFRsfWcdzer8JRtVw2FYoOWImBtS+o/Dy0bPFe2m7YKJTXb10OOupquaNjKT2DiTWffKuKSEL3az63NAv04ZxOPFAYdK1WZGWOwMhurlkhCF97Jyf3ujhhz/Gj1tmmJY0WdUODW38Qkd4sVMaqkEm1j4GLAABgtlD387Oir0nwckbI44RFG89MPrjMev7/upDuZzGe6v2rQT4s3BE/XNZCqYSUMIcJBPzXjyFuEaH/BVyFqR8+wqTRUCcwYY0xixs9B354m8WQcLuuwkspRlZn256uT8jVbe852Kfg9A47RY014hyNLZkpPFgdfBFcKVQplgPP6da8KgJ0eVFAKh3rUJItwFZeVcybOhJyOeT42jIrRV135Sw/8UC8CTsvpfaXRkZv07srottwLlEeaMBzmx3591ib34JKIpAdxqSbwac/gY8/pUwy2MlkaAq/hCjxz5IWG+sbCrGzU/yYYVelhTaqCpYAhfBaZxp1LHiLQxhS6DjHVawg7diV0DOOpjAe5W1vjyg0x8Qz3JlNaIIiM6XifA2KZ5br0MmgaKCrsPfluF5baIopfb0IxBDUsgRvAX09l/EYy4W/P2cBhK34Gnw7Q+b2TnTYPntMLXI9Oq74JvCfXwqgsmWfIm1Fh0CcaDz1oWYrjBvft2FhHRioVFWRV8IvSw2Bgb6v4avgoQ/LmBj2s2bjQorwFjT7zZDM0gLgJKAb6LHQ9Qo9eA36QxXjEGniRvejMlMU5YJQaj1yU5JBw+JLgDTUs+/OZB0LJKSGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(66946007)(66446008)(8936002)(8676002)(4326008)(6506007)(76116006)(66476007)(66556008)(64756008)(26005)(9686003)(6512007)(41300700001)(1076003)(86362001)(33716001)(186003)(2906002)(5660300002)(4744005)(44832011)(38100700002)(122000001)(38070700005)(71200400001)(478600001)(6486002)(316002)(6916009)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UuH8bnZDSSv+DsnMNMwEBAxzWE/4KZGVSSkwU5QoBpryzbZl76nihK85kJ4b?=
 =?us-ascii?Q?PL6NimzwZ4jsNb+wc92+w8+sgzE/BFpf7l/xyI2h1GfrCJP52t6JpS3ov+Ei?=
 =?us-ascii?Q?CNCnndVDWBQrWQR6hmwI5SMLb8acxW+rzfgiw4xk/TYOjN9dkjI0kepm9VeB?=
 =?us-ascii?Q?+Dsv7MkeSfi/gzqKhCxOWsJ7zeJHXYw4Rg+sIZ302oVemZTOwnoVK0aUnYed?=
 =?us-ascii?Q?qYFY+4/IFJT2wcNmxc3+ArPtitUAQRDyAPTC9XkaQZYvomPBU5QZlE+CsS9V?=
 =?us-ascii?Q?YNNrpf1DT43O+2z1xgN+aVa+/klSzADWISfXhVnvZvKQeMcVXPHavetLFsRT?=
 =?us-ascii?Q?zfOZRG+Naw+lTzNDfILX6uVrxYJJRKoi7pVGblPmsYAfq0qG+pvwuByXulUo?=
 =?us-ascii?Q?5ZnvsKDVkyP1ram4U6CqzBsjF+7bURKTn+sxBemDwQSOgrUGBY5+mReqrY/E?=
 =?us-ascii?Q?jYnKxpCRojIX4aokPP/Urwzy9TZtcofzcwL6lGnjogt1uqtv8mvKQlP8FxaW?=
 =?us-ascii?Q?EXvIiSHslrRRqJGtHW1RE3UMQUvhuvcRR/1MK8aMY6atlxMy145vrb6oEeo+?=
 =?us-ascii?Q?SJcjKa8ak6km7RjO2yrNkgsvB4Cw6ECTKR3P0Mi+adomJIiG511pfIKGkVpB?=
 =?us-ascii?Q?5eZoemvlo3YFK0jquTiRfUgG6B1CckHG6D6HNP9T9LLvlYnjy270dxomarX9?=
 =?us-ascii?Q?41KoiN4TFjecKo4+S3YySMpp60qAIqVHQRN0PD02/zLguSNvtYwyMN+MFte0?=
 =?us-ascii?Q?LVgBDZkwVtaGe5JG2S4Z9mY7AUUAaMKF48S0zkkV+QKVeYYjoxIVGCX9Alh4?=
 =?us-ascii?Q?1Z3D0M72d7k7D22SwiOHHsg7nVzFF7ao9lNLcM3K4Uua6rUPDHiE6qHT/4D+?=
 =?us-ascii?Q?DiZ/47BkgJzAqidNahL36kIisNhlwOGjpwHA3atPnrA+nC4uYjkZREgnTrVt?=
 =?us-ascii?Q?2VLsQGTxvdtDsHTOETrXqZms+E3GQJ/IH1iMNPWxp8PN+ZkkFjQoBQuHRaQj?=
 =?us-ascii?Q?aRlP+geMJnMs/5gZtVbg2ph59gRHFuBHtkJCnO/FcUG2d2xNkAoZcXI5Keey?=
 =?us-ascii?Q?x1y+MPISFA7FYnr4XWhlgQeDk0zk03EMQDYdYbqSuXpyCDjf599dWlwfDUwe?=
 =?us-ascii?Q?xKATZwXGVbycvSIhJvVbB9eAdvz+XyCyRM9vHIfPxjKfXzN4WMKnZ6HkYQoi?=
 =?us-ascii?Q?scvpofVT4w/R9it83E9DTFvFlOtKcyT4IEcztqKZXExtuoNpZ2CjTgqJO4dY?=
 =?us-ascii?Q?ON+u2P9TdURfqsHsfM5oA6b5HhUJ/Y/ciyH82P696ylKaVTYxSLKCbrlaLZm?=
 =?us-ascii?Q?kIdtaCQ/bymK3KBvrEEibOlRDnDV/N56umnN58s4cCvqOZPqj0TRhhc8AL6w?=
 =?us-ascii?Q?gCLrKOF7i02Y4+X7f66Cr9R64FSMvTFtS/6zvPFg+PncXoxeMwDMh7MCPg2l?=
 =?us-ascii?Q?xPFOVxUAUxodlWLkBQOJQ8TUqmkKpNUqw6fYEAV/WJyz2e5C6IwhrTcJiEMx?=
 =?us-ascii?Q?i84yu1oB5e7PTV77SjiX4fFLemCEE8sAkhEehd0yz6PEoiQuf2R60n7NaBKT?=
 =?us-ascii?Q?uDAnMgL/0x/PURSpBls02oIckN3RWSfxNE6cd48QCNSzZXJJfhxIlp3CT9yS?=
 =?us-ascii?Q?UQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95573D1A1420B5469A7DEEF9B791C6E1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89fd1111-f7fa-48eb-7a75-08dab8455e3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 18:02:09.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxKMoauaUDbVgWgP3rKlz4pYdAZC6tSJWjSC2PauOUhYzBO9zzO10jcugdri4bKhhd2hVhaICZpQwXYKyIPteA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 10:58:24AM -0700, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 15:13:30 +0300 Vladimir Oltean wrote:
> > To fix this problem, memset the DMA coherent area used for RX buffer
> > descriptors in enetc_dma_alloc_bdr(). This makes all BDs be "not ready"
> > by default, which makes enetc_clean_rx_ring() exit early from the BD
> > processing loop when there is no valid buffer available.
>=20
> IIRC dma_alloc_coherent() always zeros, and I'd guess there is a cocci
> script that checks this judging but the number of "fixes" we got for
> this in the past.
>=20
> scripts/coccinelle/api/alloc/zalloc-simple.cocci ?

Yeah, ok, fair, I guess only the producer/consumer indices were the problem=
,
then. The "junk" I was seeing in the buffer descriptors was the "Ready"
bit caused by the hardware thinking it owns all BDs when in fact it
owned none of them.

Is there a chance the patch makes it for this week's PR if I amend it
really quick?=
