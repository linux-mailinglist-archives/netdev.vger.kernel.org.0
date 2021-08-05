Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05923E1654
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbhHEOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:05:28 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:56964
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241873AbhHEOFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ/qdzL5dgV1xCeLkBaNebVXa1sg8oDe0ZZstd3g3017CWmBHL348XmrlnT3gjDEgbc0GOJbZlaZDqSzu69WgJ81RNjJTvTCZ9uRQv52AoUs4yopUSZlyAzEXG/c4XQuvquzqRdayK/t3IttBytl+ZGWXc0ERHDJ7pXrig/5hyKSv6PZgxcLzqPzsLQPIUHVeAByTv0q6NQlyWFZvPba2wzGHVkGdyEhf734cHUR6TFJI3eEcCz0nGDK0CM0YrvT/t7D+O7XTHTncz2hP+vHrTMy7QPdwktkiS7Ovxyrvmn6FX1kUbcEGWvX8wDs5X+0zUaccrXo7cw0nHEt9rnHAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC7KvyksEK8ewN1olec7rC/EVs1OWvxZFMevdAnCgHg=;
 b=RmtaCR8+sZJ8L38OLa9FMSIG9DnvqDB21nQaAkeGvBwhMelR2YuvCy3g5kSgKbvFN35WVyJh7SI+4HjsxFivO+5LxBAmjYD+lqZJruDInymnGnrexUqBZOcZ1pXjoDcJ6XHI2JfqwmlVKZMvV2aQV6I5K0rCF1fmz/EQY5CEfCplugfTifsit+eM9y5eKqPwa5QAHnChv52Z4DuBPQgi9wG0i2o456BKqspNR8Awlxo8UTGUf5SCKqL7ryb+0vYmduhZ4e2Uz+9NJPdjv9aLKh63RrZFp1jvsQLmcZT2QKkA6ZoucyN/kkDvGKuWaJpmFIx2QeVuAGuv056deW9u/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC7KvyksEK8ewN1olec7rC/EVs1OWvxZFMevdAnCgHg=;
 b=M6d7Bn0ni/TpkGEaSGDX7K7E7mJ4N0o2YWQkHACYPMfOGeP0OIUM0m9yZLclmwZ9XRNyn+zYch8AG0QsYIwgLYhMbOosRaczxxA2hzB7XzlXoi4xyloOkcEXIY63c3M4wJUYDLXF+fKoE0HLh/VJnCv7ePbp7PWwc6aC/y2PtGg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Thu, 5 Aug
 2021 14:05:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 14:05:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net 0/3] Always flood multicast to the DSA CPU port
Thread-Topic: [PATCH net 0/3] Always flood multicast to the DSA CPU port
Thread-Index: AQHXifOppilgAUOQ3U24qGAF1GtPlqtk8doA
Date:   Thu, 5 Aug 2021 14:05:01 +0000
Message-ID: <20210805140500.wfxotyqitq2zzpcb@skbuf>
References: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5d78bb3-d2a3-4d3c-f0ad-08d9581a047f
x-ms-traffictypediagnostic: VE1PR04MB7341:
x-microsoft-antispam-prvs: <VE1PR04MB73416A60E688A5583959F5C5E0F29@VE1PR04MB7341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0DnAj884EGrJrKDOfmm5IQ9Pdh7nvPowPtIifn9GJEK1YrtEloY974+Usi9jI2yauJZi7B6l2JJhF+4FZHeE+08WosRZEkOxJoRPv+5bRS0Lv+eCbmYpN+v36sJXJ3n7v+lNw6FLkaXTOdhrF4SeBJxMtGer4zMFH5tYF7zitVABjgC6uMFWX++9WMSISqcjlwqpIIA3mG+wzCGAim8CJM6S+ANjqSYxXEPsTw3ZS4JVGrX8GVHvTGd0af2Q71FTTbu/WyX6VDrX/rK27thlAgtsIo7zCMv4g1aeCmdK4ANhe0Nlj5aA/KbmwuErLLjWxby5bR1S5DG3/UXZjAxsqI8zXn48/telYky7puhU+b5CrBqkFNqZMCXIwUZVfSU78ConigCVtaTM0F6lwQb7UhyIjn8opMiib2tnpx4Gm+Ou4Jqq2P004brWZH4CN5bRrWGeRX8A9fAUI7p6FCN1mhK8lK/2XOPtiOwz2ArW5pi28ay4EfotjuPkrW5TDid7sVD0DZQ2PWJ9wj+FKj/j5yk8ZOTo0LtUQ9vJl8iSSLbomKw9Y3zWJeRUGPR5sG2MAZjETF2YwTcLGCQwkcvhy6ZDGNIGbTcWcsywewrL6uWFx85FiYiCUogDRCOyzRwj0ez/TCrolA/n3sR93cvW6J3rKOCaHK6JI6DzGEY20VrWrl27w3E0HnlSpc9/+qXbOklhSLdRg9epak2Tky/xKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(376002)(39850400004)(366004)(396003)(346002)(66946007)(9686003)(38100700002)(6512007)(66476007)(1076003)(2906002)(66556008)(122000001)(66446008)(83380400001)(91956017)(76116006)(6486002)(71200400001)(33716001)(44832011)(5660300002)(64756008)(478600001)(8676002)(558084003)(6506007)(26005)(186003)(54906003)(4326008)(8936002)(38070700005)(86362001)(110136005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O93sAnO1K1f4x+v0ppLJapFYmztW5U7kB/pfzBOBE4YrIGYY3w1agJM9EdF6?=
 =?us-ascii?Q?jfUklMTRKjeTq8kdND7fTUqrK1IowEKy9sDdtWbJcDh0R4mOLNisBFlNQRKt?=
 =?us-ascii?Q?3Flm81KB0yYR6SpVlxKcLVm3KFFjOom+evwtn8dQwR21d5UNXcPBgdcNAOtE?=
 =?us-ascii?Q?3lhbabCNrzmT5nV2pMtmmtFQiRFbsYBnwdVvo9VKpOagBR3VW+0GQsQbuWGN?=
 =?us-ascii?Q?q22gQ1i0FHX0n2NimXldl5zkU8UVkPrXFGd4UDXKNyTX25Kz96/irVskw8GQ?=
 =?us-ascii?Q?cqtnURbUXpHGf3glN95dQsx3Z1u2vRrUg6/DxeQsGhY55QYBqMxzKxkkuSBO?=
 =?us-ascii?Q?4dLzhptQcMevdVes/jLCUXfF9c83KLPMfbgRbQcA+UpR3L1OFhgbxYl8P2mb?=
 =?us-ascii?Q?ZOXhlQDTaFIjz39QQjv7hqrpjrpYYb7nvnLEwCwrR1zxW6ewAhu0AojkfB5Z?=
 =?us-ascii?Q?FoYpnzL/C+p0gP9+2q+bG2r3oWZiC0YpqKwZV8ZAr1N9NlXlGWCF6jASUOZL?=
 =?us-ascii?Q?KKI7w1tLedgMynxDk5OW7bkbCJzQLNKbGFmTDqHraPaC1izvUt+oFrQrG9oC?=
 =?us-ascii?Q?+Zj9QAp9xFtsuVKb4oKZsIARB7CaQqta+g7/pu+tGiFBzodr4NUR/qrNl4g/?=
 =?us-ascii?Q?QaA6N+Ix4kW17b+eYJpL73/Jn3i17MDrWB/jyHOcqk+AH1oEubbjpO8Z8yjF?=
 =?us-ascii?Q?UIyLrsqNoTpSr7jcFJYIIowdQtNn3MjZJP3ioL7scDnENN8zkhAfcfLTjQAk?=
 =?us-ascii?Q?X30HXnFL82ekwvK6HdfY2fVQtugbP8N6sVOcw8M64PlLchKUHYhw1FvcjCoW?=
 =?us-ascii?Q?1H3H7hEUWxALMxW16/ccAIIbSbx0QQIkNakVIu/BzDcC0Vmf+lVmsn9xOsIH?=
 =?us-ascii?Q?U+VzOp5pLYmkYEJXwByxpsjTR34iBQWr65gAIbYjKhlHHja6wviFgiV7Mjox?=
 =?us-ascii?Q?OPdzXlceIvXhzbnJlSCJtOSx/jLNNsIpU5HBtvrduPSRbqLWzxzwoPKwWeTL?=
 =?us-ascii?Q?pZY3YW/zzziEJxqMT+4VyAvvxM0CVCYueVvJ9LJRMPbDXcHGeb7j8PVOIYQT?=
 =?us-ascii?Q?7YBsSznqsiNI7h1Fg6ASbrtSjfn+0WAWEpno946my1+wQegcj/ncWjPecSDv?=
 =?us-ascii?Q?EmCVSbLZp3AAXL8TyqJ6/GHYIiVQOz8n75CHihVRkwcD1smCDZYEhM4AMF+6?=
 =?us-ascii?Q?VExZBpkfw2npd19acros+DUXsp3Bknw00PoEXiwCc6XtPKaud74U7xfI9bI9?=
 =?us-ascii?Q?1eET02QNVfzWeEhGoPFgzjsjJWcXe4sohyfAjGFG4xFHKS1h6kchvtQVVpj5?=
 =?us-ascii?Q?gYPTXOZfCHiqTtdP06aOHn6d?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0831BF39C742054DA5C9A4A61C551648@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d78bb3-d2a3-4d3c-f0ad-08d9581a047f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 14:05:01.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HBUse08gMBz5abbOtmwlqK8NUWpeO5pIgbZNQq7taYWJ43XBFewS3Ln12PkvL6jo67S9vvV6//f+n8SIRNFzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please allow me to send a v2, I forgot to delete the function prototype
for b53_set_mrouter() and now it sticks out like a sore thumb.=
