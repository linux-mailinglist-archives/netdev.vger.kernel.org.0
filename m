Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019FC2FC254
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbhASV2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:28:15 -0500
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:35297
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727414AbhASSnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 13:43:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+wus6BqVRIUJzhVrhZBjFKC/hpu6OzgCZFS3sNSVhJq8yVS21DXd4haXEM/Wuv8rbjQ4uZ6zFWXylwyS/W8jU30njf6gL79K+tMzBNXiA8FR97vh/qbMi0OviPb5Q6/GMGrcXP4UK8QIjXxZiSPkpjPCpaSHsWkKDYCb2ZDgadj8tjh6c9ASDq2aoO4TuCPkqCQCWI7tre04xmZC1cqvGScDDnNet3Q/JEeWrs82PVMd0m7GrpIifob4AonWVZnKdH/iUueHN05CnFqgG37tvMPUnRhPmvlVjxohYrXJj00xkAqOibsyrFlGbQpitgTS8yWXLF9FVrHSHMvk+T+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms2j7uklyI5rgqr0jDLyDPAqCu2Me5Qa/W/GzRP6LL0=;
 b=a+MZND/qxPOmL8+Ap1N3laZIqPUodVoR3NpU34IVDgYIN3h5RVyzN/McHAbhTO0+oJQmF7bipvTgfemqL/VtMbgfMLMIATw3VOgzbGttRxpDd3coI7fxJBOUh+0mQjH/utjZl2Jd2pCLwK6prtyIcNQUhjDrWyvi+V2r80LS+cF80TQMm0Ss0q3VHcmCozZHgn/yCJZMo7qjf37ED42a9Z8h2fEdmVwotSsks4nuRSSGcSwxxVuPDy+V8hBOVZxwWv83Uxf6AVuQHZqRuSWTRRGet+yZXwj56KYYxNDFZ6a4D5ddbW0ta4mdU+nDiD1758dk237kMMZ+zc4lG8VhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms2j7uklyI5rgqr0jDLyDPAqCu2Me5Qa/W/GzRP6LL0=;
 b=hD48a5JnB4iiPWXxjSZ++rp1xjqqCdNDLo07vYwQDF2HkIzVqFWv6SoX/kBEVEaSUD3YoKYxKzyw44gbZq3Dv93nwFBzVHv9tDcBxo5mX+BJMz3COwY7iysa0vET3iGLbuISY8WYTeJCbEXRzOF3Gs6uCWz4MWNk8RnpaIferKk=
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com (2603:10a6:803:121::30)
 by VE1PR04MB6736.eurprd04.prod.outlook.com (2603:10a6:803:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 18:42:23 +0000
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::e9ab:4d78:5b38:aa3c]) by VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::e9ab:4d78:5b38:aa3c%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 18:42:23 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        "jocke@infinera.com" <joakim.tjernlund@infinera.com>
Subject: RE: [PATCH net-next v2 02/17] soc: fsl: qe: make cpm_muram_offset
 take a const void* argument
Thread-Topic: [PATCH net-next v2 02/17] soc: fsl: qe: make cpm_muram_offset
 take a const void* argument
Thread-Index: AQHW7nUH/5V4T85zIkmig9wR3lhPUqovP1UQ
Date:   Tue, 19 Jan 2021 18:42:23 +0000
Message-ID: <VE1PR04MB6687BE7DFB68D458E3E6106A8FA30@VE1PR04MB6687.eurprd04.prod.outlook.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-3-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210119150802.19997-3-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [136.49.1.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5012412-8651-4891-93eb-08d8bca9f60b
x-ms-traffictypediagnostic: VE1PR04MB6736:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB67363C99DBDCF1ADEB9806E08FA30@VE1PR04MB6736.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ropi4jh0wxAuGyWFHoVQMl6OZWM3InZ0ISsp97CcENcLs6kOCGTYORKbKBTUwYd//whhZA3NbLT83QYYT15y4/lIKMy2W75jbXpNoFC8XWoUUYip5TbO7oAL5S+TKRky9DNNNrVUL+uopo+UQ5FPr8uaT9CCntKu3T4A5JnyvBqJOzKh7hehgrZaKAlqNYC+TWVHxxBBTyg1WB0qz6Vtq250ltX7TqjxTJ52dq1qSo+j3lWuDjGwO0+6AzxhL8fixow+V20/IDkEucyjYAX7ttMhu4CAd1LIjTwyNCP/7jo730KdpeIR8EMp/joO8H7D7xZYoZTnywFARSv4BAX7TFDHadT7D73S81lRPFFk38+FO1uORn9IBgItIkc4leqkURmYuKW/gpP8BSyiGoQk7ZkDJrWD/leAjbAYfpRS4UmZuCXVzm7YcZ9Qj9Zwru0u0KgHZ5t+vZZSZNoY246ZjckEOYY6UBWCGbd2kaWOQ44MBdBskllCLFYAm4WwwoRMRiMboKyf9GtLCz5ScmtwJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6687.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(33656002)(52536014)(76116006)(66476007)(66946007)(71200400001)(66556008)(64756008)(83380400001)(186003)(478600001)(54906003)(110136005)(26005)(8676002)(86362001)(2906002)(5660300002)(8936002)(6506007)(9686003)(55016002)(66446008)(316002)(4326008)(7696005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3wGpr5OUrAgUqa5jiizBNS3s4Z6w8SQjqzsrMWRN5vwopIqWz6yyrpyIvSgS?=
 =?us-ascii?Q?imavzPT3UlsX5KY+9+RMQ9L9BC15oJ5zSvRpUTL01gp5Zxh1u2CZoB9ekzXY?=
 =?us-ascii?Q?pT09U7eEA7AiWRY/wSGuAkuC8EvlqfCbpMULTAQXgFnPTIESUGkxF5VRXYb6?=
 =?us-ascii?Q?i8craZd7st1SIMyb0YjHUXKwznUpilWDFaJDh0wJM+t4Nfyc03XpNKeLvEXb?=
 =?us-ascii?Q?i9OkhQvpCZNGKIGcWaXQrNpmr8CAnIrYO38y0j6g0cWfxtInEijMRyNiRWi4?=
 =?us-ascii?Q?QAmXn5tx+1OtBRoAJ5Z1m6ylCT+iiEuk0PlQkEY7SaMXFP/f8vksf1UXHWoY?=
 =?us-ascii?Q?L2Kg5VK2f4pzPTEOLnnzyHmCTymf2YP0rpXObmVEzSu67nVzDPQEOvD/Ol4Z?=
 =?us-ascii?Q?M/KwVGN6tsrW1WwuQTeFjsz9RvBL0qsH60B4wa69gFx1CBibD/csAVICUv43?=
 =?us-ascii?Q?Exu/Eg91XdGakpEF+5eNm36/C8NJOKGZSd2vKahrA98UvDi+3FpiP4S/ZVS5?=
 =?us-ascii?Q?klrQtRWwU+9EB2XZTK5Ij15GWm6XOz0x3XOgwumcmlkiaUI1Q8VGlIYgRxGD?=
 =?us-ascii?Q?h4ehojg1qNfiEoape/wSVTey2W/75RbcJfEN0Z7OpKolK4b1UW5ThpoqLrsT?=
 =?us-ascii?Q?h+C9tQP03L9meC7OZAQDjesSZ6jtZY99bYUfdg7ncK3urXjzjPenQIQ5lcx5?=
 =?us-ascii?Q?D7jQGF8VjQVXvPPNkrMLNtIPQsggFaZHE5+rZwbUB1VWvc4WZqc8swfwL8jH?=
 =?us-ascii?Q?j8/6XV7ocrpvWRMGRKRCYwjZxIFu2sRw2xOK3g61iAWOd9medXkMu6sJf/QZ?=
 =?us-ascii?Q?9iaP8NCBOZ6wgE+WmyTovRxngpFM6OqsLGu0AbLTTF2KE7NMnizJ/9ahQ9/r?=
 =?us-ascii?Q?UvVjzsetPA8JMtHv1H7mnJ0CAyqvVW/Fs2VTAlckg8ZEPnUO8PvaZmoW99VP?=
 =?us-ascii?Q?80doF9/FJKSmPQqZWTF6zXkf68s1aQKNizXMZMe+W6U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6687.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5012412-8651-4891-93eb-08d8bca9f60b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 18:42:23.4964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eomliKgPMRzDW+vfufTxUmwVxYdVDRs9QOl1208zbOyQLFTxWSJMEEg9SwxbnwbcwvU6H1jjen2///Q9O8QOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6736
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Sent: Tuesday, January 19, 2021 9:08 AM
> To: netdev@vger.kernel.org
> Cc: Leo Li <leoyang.li@nxp.com>; David S . Miller <davem@davemloft.net>;
> Qiang Zhao <qiang.zhao@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Christophe Leroy <christophe.leroy@csgroup.eu>; Jakub Kicinski
> <kuba@kernel.org>; jocke@infinera.com <joakim.tjernlund@infinera.com>;
> Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Subject: [PATCH net-next v2 02/17] soc: fsl: qe: make cpm_muram_offset
> take a const void* argument
>=20
> Allow passing const-qualified pointers without requiring a cast in the
> caller.

Acked-by: Li Yang <leoyang.li@nxp.com>

>=20
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  drivers/soc/fsl/qe/qe_common.c | 2 +-
>  include/soc/fsl/qe/qe.h        | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/soc/fsl/qe/qe_common.c
> b/drivers/soc/fsl/qe/qe_common.c
> index 75075591f630..0fbdc965c4cb 100644
> --- a/drivers/soc/fsl/qe/qe_common.c
> +++ b/drivers/soc/fsl/qe/qe_common.c
> @@ -223,7 +223,7 @@ void __iomem *cpm_muram_addr(unsigned long
> offset)
>  }
>  EXPORT_SYMBOL(cpm_muram_addr);
>=20
> -unsigned long cpm_muram_offset(void __iomem *addr)
> +unsigned long cpm_muram_offset(const void __iomem *addr)
>  {
>  	return addr - (void __iomem *)muram_vbase;
>  }
> diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
> index 3feddfec9f87..8ee3747433c0 100644
> --- a/include/soc/fsl/qe/qe.h
> +++ b/include/soc/fsl/qe/qe.h
> @@ -102,7 +102,7 @@ s32 cpm_muram_alloc(unsigned long size, unsigned
> long align);
>  void cpm_muram_free(s32 offset);
>  s32 cpm_muram_alloc_fixed(unsigned long offset, unsigned long size);
>  void __iomem *cpm_muram_addr(unsigned long offset);
> -unsigned long cpm_muram_offset(void __iomem *addr);
> +unsigned long cpm_muram_offset(const void __iomem *addr);
>  dma_addr_t cpm_muram_dma(void __iomem *addr);
>  #else
>  static inline s32 cpm_muram_alloc(unsigned long size,
> @@ -126,7 +126,7 @@ static inline void __iomem
> *cpm_muram_addr(unsigned long offset)
>  	return NULL;
>  }
>=20
> -static inline unsigned long cpm_muram_offset(void __iomem *addr)
> +static inline unsigned long cpm_muram_offset(const void __iomem *addr)
>  {
>  	return -ENOSYS;
>  }
> --
> 2.23.0

