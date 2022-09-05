Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FCA5AD82C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiIERNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiIERNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:13:07 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2046.outbound.protection.outlook.com [40.107.105.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871FD1EAFC;
        Mon,  5 Sep 2022 10:13:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ML6rvo/oVVixylof+x4wVRLMMhb/2rx19bH9GFw9b3irFmuK4VUL2DdtDMC9Vq6312m9Qc5mcV+y621mImBKEmDyU0TpEUd1eGKaJ2ypPCg/+VXXSCVBw86ex6MrSnJ0Juvp9bXkdzySJsou82N8Bm/t4M+j83xIxxpsOBDXjWzY+dPlkIcNm2ueNanX9r1ESPNL1m01rugi8DeaSUoxr6P1O9h/s/O5CvoxgDgvToANQrZx7DywukC6gTxHF3T6RHFVE2Pjq/VvKGjoVTJRJ4gZ69/RaFPvLm148g6m6hzEeYESqtxqJVvH0S9BHuoi8fbicENJR2MBpS7P5Fl5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLW21lTwhlOkxLzRLdJ1D2xOMmi6hl2iC7ukZGUn2GY=;
 b=Sc6G7A/cNLRNV8+KvOzRQQ2v1r/GLFIzqzGt3AB+CNLTGZeMsaL+a2ideBSWoXTyawNlqNPjwC9VrCbgdJ6I4sKCaVHeSmvxr0XZXddB7CsBJBsH+il6/pD10DPJoZawnm4NRe0Z0fCBTGMSF6MSW8Q7lLhXHQTjfWAniRxMhICrathGOSm6zwdUftJzxada7jXCiBzd923PShmeMydgDkKl9c6OcuoQCKFpTMPtETguxwuL6SbJnNQbq9tBAiNLXnBAq0ebFvJd+N2ulg4ifuZThbZyYCHXDWsu9oaMZqEeU6dj5Sv2irc3S78PU/93oXZBgG4s81gAOm+6VFA2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLW21lTwhlOkxLzRLdJ1D2xOMmi6hl2iC7ukZGUn2GY=;
 b=p3F/VamE8+O6JcEA3T7txZJ4q7xzg2zJ4s5KD5V1yuFBM/Z1GyhClhz/NOdj66TCbgBeYxd4d/kGwT9VwSF1WlJZI1AxxCRSXR7e1bjzHXa03VR+j/ksLjkKb4Qh1GtN9DC+LtP4qS46dOjEaew8xz5LCAS4BMORZ9r6FnnoBZw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 17:13:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 17:13:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 0/3] Fixes for Felix DSA driver calculation of
 tc-taprio guard bands
Thread-Topic: [PATCH net 0/3] Fixes for Felix DSA driver calculation of
 tc-taprio guard bands
Thread-Index: AQHYvxb28/qM7TJw1kq6G5TAZWP7l63RF1WA
Date:   Mon, 5 Sep 2022 17:13:03 +0000
Message-ID: <20220905171303.tdphogp6odtzpxnn@skbuf>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0abacd28-c5b5-4386-085c-08da8f61e4c6
x-ms-traffictypediagnostic: HE1PR0402MB3481:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9pSrQ1tVGvUqG6J6QT0hQvxAy4+HeHVjjP7pu0s+4v+AZEMS4ZhuAPXdf2Cl7aqMTndbK5UYm4yTsslDl7KKWNkIscA18hODOxxyeKCBiDx6WI9Z1fxULbnMxpp3R2e8JSJb6lK5HsGRpVlyzttChoxplrx0RfdCUkrRphAhfUZjQyXZ0IkBdv9ckuUy1iSdeInjJvxHh52+Dirr/f+mYDUk5P1AmSvXwyFblyGtDvGeTDPg+Z016f6pCN4AKblsahjE0uvgjbmePkoXykqyTwC6AbpKcBEw4cFGYiCZJ2shVOg8cDDESaiGfntsdDU7HXkRY4k0+zdGERK/Uwt7Hk3T7zQ4D0SEf1d9rBEjIjVjsydSjpqfc/L65xEj5HdkiVtxJB3cuinwOwZkmGSsExTFYYN2Xy/IFrkkhfpoadwJ+f8Cgfgd1iflrf1rFynX9s2Zsab+ndKvFITh/RDhsv+kYlTKwnb1VHXjIV5qtWS3l2ZVa2owtdsY3uJBa77h6sk2eV/pgm4u1maXYY2GvLIzIbHNhKFFcdpdv8MfvxfLeZLv7HlE0YnuilMKCepfCf6Efo4JgJWMG3SHH0zhF/YlQ8Y3EGFd0d7zE+62xdCd95QR7wef1+Gjk7+1p5H0KnxvhVwTj5P/Gsdu960+cmJVcOVUh1rPua4Ea3o0cL2g5gVkQptMRgbWzJ3UW0mPl8TariJ+DEjHkLdRopSGm2ErmXQszL6E5Z2vH6jbRr3QTEi7wkkpN3D03Kk/Z82WiTOE1Rx67xF6slQgv+VAH/UhY+7bIDk3JFXIqTy427I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(136003)(376002)(39860400002)(366004)(478600001)(41300700001)(8676002)(71200400001)(26005)(6512007)(9686003)(6506007)(33716001)(66556008)(4744005)(66476007)(64756008)(66946007)(4326008)(66446008)(2906002)(316002)(966005)(38070700005)(76116006)(86362001)(54906003)(6916009)(6486002)(1076003)(122000001)(38100700002)(186003)(44832011)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XnjYPq//8qeLYfoUJk856igjGX5HY9Ity6/omExg6smLvE+JqMD2AG0Yq2eo?=
 =?us-ascii?Q?5HHNfZmr7KEovRN/JhsuLar1TB5tdLV6b/DNHwCi6splTUmCi/2XMXX82Aqc?=
 =?us-ascii?Q?nXv87SgKwkDV4e+1jfcAnimRn9UmfNgDARFu5rCRdooWaOUbklnHbsh76hha?=
 =?us-ascii?Q?7lx/DPv4v0v3gXOVvaJrVTsZiYEMNZpMyRq9JXuw5ZgEdz2QugfKq81qDVxK?=
 =?us-ascii?Q?MAcPaQZKnGp1y7t0H7DPzB87iZMrxm1A1yQXNt1m0U9WOxX+RoB1SCQYRCzX?=
 =?us-ascii?Q?xYahL/kpZZU+dkS3SUQdDGcs85m1h0Hf+Uvv/B/yIDDXSpyKaT9yekg1d4ym?=
 =?us-ascii?Q?Xj0M3ZW8x1FezTZhgoic6g2XpbrIQ8Vw6iBFnRYaP+zrlJeNKlE+FzzA+MPJ?=
 =?us-ascii?Q?RdsQd9334F83ICAcFQGQLQ4/XubCsn/57fw3H/AzAAs6ARpQYJdau8YwSszK?=
 =?us-ascii?Q?icPnpK5VyMnOkC/Gydg/rke/eB0Hpklio1iv6SYCh+2NgVZfjJQHEPuTt5FT?=
 =?us-ascii?Q?hqwsQEyGWTLZEgZf1ErUv7r33JnRnPF1XUBETTiHAZGzeQRkgrn8Qrvynhk9?=
 =?us-ascii?Q?cqiJXqu5lTTsQQwCGCgLDH8CSj5++XQz4BDx++cJPJWwK6Q06xs/7/YVSnfp?=
 =?us-ascii?Q?yLEQoWExhiQLQbG/UMprELtqilnI8/BE6X1AFuR972U0vfB673JwraqUWdgW?=
 =?us-ascii?Q?183L4b5Py70IDjFxY05so3S+rVTvHHWfIF3FnFLPT+H47FSxXgifkCTalQCW?=
 =?us-ascii?Q?0bI7IifpPSMAYurbpgAOD2v00tW957fI/2Xp6XSvaEB685ctS1ja7u75Qblr?=
 =?us-ascii?Q?k37D5zUDHy5ujHtwkI97cNjZNW7XyWgvtNzzDGAG+YfKSOiBvwn2Yul+4Rjq?=
 =?us-ascii?Q?VFMumj0rd8U63t91dUvuxHZKZ6B2nb2FUUUfrAzNBwBsKTkklegrEu+l7jAS?=
 =?us-ascii?Q?1hH7syP00/7wlNNAU8IvDiLO0Kjr1mBKFVUNiq92iZ1bHfn/vYqh12NNYmcz?=
 =?us-ascii?Q?JBpbEerNSZiieMy3a1Eovii9a5UajPJ+Ch4X2d4nuo8UCHaYB0hrZp9WBYpm?=
 =?us-ascii?Q?LLCUN8O/WC4Di8aKkeReBwCELGsguQm81Xb1EWkieGQnudmMoS8wDonCv0aP?=
 =?us-ascii?Q?xJHH2NnoTeddOr0TGY/dRKDjgnzsi5F8Dm/xDG/ufFtPEHbH/fOuRf2YliZs?=
 =?us-ascii?Q?GV53pIW1ygOwQWGPl4xyoILtqRUP98WHvUo0wDXwJUM4yR8u0Gt0btLE5aHJ?=
 =?us-ascii?Q?TCy5fzxgYlxkQrxWOJJ0kL3Zm4b2b0svev1pPHPAsm0hjHMXfRmsFRC1M/Es?=
 =?us-ascii?Q?kN5fypRPcyHBydsK2WIHd3SoYjP96PuS69jiLiJQGkT59OqmRwveHLj7wt16?=
 =?us-ascii?Q?y/R27NHT6KCyQGRXzhpwXCe/PrVmfR7A7yMGiQFeUJaxOCjpQc4jI687QvXL?=
 =?us-ascii?Q?RJDCHN4AJDu14HRTil41NIzGD2a7AiKTDDwc2E+7T465RuBbnoXQH+coQ9Er?=
 =?us-ascii?Q?Ucj3ZVv3ij8ALU4SDmBiTSBBkY55P2XKi7o/L2aJDoSju7BlAABReKXoC/tp?=
 =?us-ascii?Q?zc6ptzOeUfBwUFcuXhWFFzS2Z4xPKPvemb9rfenOxbHq5Tfd1pRXY7zHdfTN?=
 =?us-ascii?Q?sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C244F2FCD2F14478CC5579CEF868BFC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abacd28-c5b5-4386-085c-08da8f61e4c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 17:13:03.8817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXqrn5Umtq5Mh2WMtBIHLamhBLXHxkIX0hVQKBL0le+EIcJMfaCm4jDykkMphHs2XyziJPjuMHaZFIpIqr5+bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 03, 2022 at 12:56:59AM +0300, Vladimir Oltean wrote:
> This series fixes some bugs which are not quite new, but date from v5.13
> when static guard bands were enabled by Michael Walle to prevent
> tc-taprio overruns.

Please discard this patch set, I've sent v2 here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220905170125.1269498=
-1-vladimir.oltean@nxp.com/=
