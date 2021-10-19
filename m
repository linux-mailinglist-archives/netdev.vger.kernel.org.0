Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF37433EA3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhJSSl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:41:56 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:59040
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234961AbhJSSlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVbgPC4tsQsxq+fQXpI7j1lTnbTIdy3UEEVapLtzbVrDwBpu+bEkAAQ806eUOMCgcSchorvWQ62PS42TQPNzZ0VcB71UufZQyAxeqYY2iTQBz8mIN4ffbuQOS3YuQM9iuMIA0PFthgiBbsDELQaQsL1QqQZw10hntaQlqAJqHkMVsackCWagXlSLx8gKRGZ27r1MEmCgn9R9U9PJhh8AYBn4C8ewvkx5HSIcxdtNx+mcTggIT5ktdSFXCatVyBDisSMaixSfFl1ROM+cyGTMWsny5Y4DdwbVSTPbRM8eMOwrpM3jfLBMDp9MWWrSqhJKE3Pj9HTnL3cmwtnF84+/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqQlDrMqtQhk+Z3BceRn+OI6jAtZOdU3jWzx3gDgQ9E=;
 b=idkcWXKgGzs0xq6wZCGHebAf15Q6pEjp8YusbbLQ4z4ai5E0sf6Xo/C7kQHC01lBTVV8A3V2nX/LqyVJyRKlkkVmOxpphtOLyuhhm7T37nyoCfwMO++BxsS3CRYNH28uaz/amWpOQd9r9qBG513HfCH4M6GCWTNhzGmFVM5Gb/96tT+X0T4rWwuKC/yjtckE3CP6UpjxGO6lEXa/PFHw6n0JaUIjPDWbLcMX83qZXvbaWaY4gNSpmQp58GjXwSJWzo+EBNg9+tUMZR2J99+iEzSnKpPA7KQ3g75FUGUNuMFKAAuXXTkCnZ1Aqmghp0VFEn0OccezKQW9eXBGfaT+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqQlDrMqtQhk+Z3BceRn+OI6jAtZOdU3jWzx3gDgQ9E=;
 b=UAEOyDYx6WmnbmbwEZsSXWBYx8XRoJirFS3nms4e1Mj1nj90Z2ZeWmgibJtrn7sH/He7qYcI6BUsBijXOTaekwpxvkN54wetTeHcsRo82U7F7+/HH/jBAHUNTvXVKTzjwm2IvLzyBBODcVcVQKBgU7G90ZsM0VZqZ6skSE3gIQg=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7267.eurprd04.prod.outlook.com
 (2603:10a6:20b:1df::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 18:39:40 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 18:39:40 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Tim Gardner <tim.gardner@canonical.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <Roy.Pledge@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2][net-next] soc: fsl: dpio: Unsigned compared against 0
 in qbman_swp_set_irq_coalescing()
Thread-Topic: [PATCH v2][net-next] soc: fsl: dpio: Unsigned compared against 0
 in qbman_swp_set_irq_coalescing()
Thread-Index: AQHXxOOfZYpKtOnMkEOYlsQsmv2J5qvap5GA
Date:   Tue, 19 Oct 2021 18:39:40 +0000
Message-ID: <20211019183939.bfgpcewtyrutfsky@skbuf>
References: <20211019121925.8910-1-tim.gardner@canonical.com>
In-Reply-To: <20211019121925.8910-1-tim.gardner@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcd25832-cb1a-4a95-bd71-08d9932fcf8c
x-ms-traffictypediagnostic: AM8PR04MB7267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM8PR04MB72671C3274158AEBF0BEBB34E0BD9@AM8PR04MB7267.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SStZcinfi6jpqL4RQhyOEeQ9la4M8f/xfpy2jfww+mIVE5/YK7m63EoWlaLTtRghesF6TqOICqHWvJRD+j2SKFTsarAmUIG8eiTRtS9KYp0ncdc7qkDOyyln6BckiHStc3w9SirRt5mqHlmPO/1dzSIO2Sphp+uqHJGeRRExA9p6gnfYLq/a7PM9TnOLYctKzNgqvt4z3k3p0ZEv60mbXI0X8UO8ZZdHIJ85IeC78gKiR6wMfPjkFV/VI0ITj+5uKVKXiNiLBmunYwLst1Jxj7JcE7HnHbTlc5+PXyVZ55+dzWp9gqjFG2qnbDTd6RZK7X09xrgTCcXkMw3Lm9XTUw8+LkMoGeOo8P2C+mX5sFuMqPaX2IL639KkMn9kK+GlORMS2wdiAOhOxanVP3MqDlMj+1lC3S1zEKX35xRDf5bx6O+hXAccLIRiwkuPXo4KNtYU1mop7QGwre+K2P1gzJGBGS/T51EQBTUqSIBxf0hMUkJHnBAjmmCZl29o/XmqU77sztLwpeefAvdbPvr5dYO9bBS8FQsMA/WRxGT8b2bpAfGxGfX08QVOPzWkdPDlddLo57vFprAjOMxgcvZKwl7xg6UkwMqkbfkxxNWqKK7UYwjU0Y6w/zqAIAkiUndgpwcceq0g9DRrCEsFd9lwdP8cBYiVTx5YIf8WhYEWX4kqIqQtmE9WH4WINPqNMDBGbObXIWeWnbdSi+VdCDVkrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(54906003)(6916009)(83380400001)(8676002)(86362001)(8936002)(66446008)(66946007)(6506007)(1076003)(33716001)(122000001)(38070700005)(4326008)(66556008)(66476007)(3716004)(38100700002)(44832011)(64756008)(6486002)(71200400001)(2906002)(26005)(5660300002)(9686003)(76116006)(508600001)(91956017)(186003)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6rUcs6ZeVH+8789LhBsyZrrjgl6CCFV2V0ZdleAN+1+8r8bdAvr5DpEuK/00?=
 =?us-ascii?Q?hOi56yqlnS6BGROwGoFaLnExAaCLh6QcPj2x+/7oYuTJTIlxtEClTV7SikCr?=
 =?us-ascii?Q?6tAaJnNKNi8+mkI7ZUcTCPABnIU0Z6dNnxXp8vllp07SbnpBy5wD0vzJPIQ/?=
 =?us-ascii?Q?SmQ1rPdBm1wtIvJLlgoMXufjrbfbJK5IzhcBvL8hy7sh6tUACpUszR6yGJEv?=
 =?us-ascii?Q?AKVM9jhwqUgkebLw/C5esYiOV2s/gzsY7bzO8Z1HjwIViThTWwg3flE0t9wp?=
 =?us-ascii?Q?8Dlkf4JNTS3oX2zAmXIOGTNZ/CsCpKLcoVza/4GvP6vNpdt/0HnYYYbFWxiv?=
 =?us-ascii?Q?YQ0ZrYvCpHbz4HAPBGYsVbhPAkMRojd3/YoHfYhnEYrEfTCUVJGgPhQQUv8q?=
 =?us-ascii?Q?YKJdFbHO15/ItlouDlLBexAFMuYAxvTQeo7nZ6gIua47j2DjW/YfSbWfyppj?=
 =?us-ascii?Q?FQlkHEgUpFFNBWiV9odEzbVSnWsY06+xP7XIo1utDxUMeXwNWghMcePvnWCy?=
 =?us-ascii?Q?6fcl0d0Se0xniHfnoYIELg9e82ipUrtvx78OkDy0Z1pXm6N+jnbWKoL3WFai?=
 =?us-ascii?Q?/jTqmxoRVYdbM8CRtbFatNRCehQ3sJrSLiI0FqqT1FbujiVkHuWT8ASJ0aE7?=
 =?us-ascii?Q?pimWbyqo3EQR6AnloddxpF4Fe9V9nWTAp7YSAcT6eW4PP55wRI3epcIyMcOU?=
 =?us-ascii?Q?zwpJIXvAyGRcDMO2w6FwrHLGPjQ9JjPAAxLSNeS1MEKADtgGb8+43JZkzXfQ?=
 =?us-ascii?Q?Se3NwLMHDgAhEJXkZpm+M3T/WDcHNPj+eKAanA8KFEO9LT8jtXLomYBWurO7?=
 =?us-ascii?Q?XiUJU+PNW3T3+vIM/RZglHdQvVdiVJ7HLUnRRnR0C+ZI8kM4AazYDARPBl82?=
 =?us-ascii?Q?6xG9HnqE7+louRsSiiXqMUeNP0VsH5wIqjvOsCRx1eLAovYmEzUjp2veviJ0?=
 =?us-ascii?Q?/gbhVB91wdiDbjodEJ2muq4KLkiSWVl+I6DNMtw5O49W0Ue9HvbNJNbqKWOS?=
 =?us-ascii?Q?eeESRwmRdCXKHIyS9+rW9TmC/8FTMIeSZpIfV1fo1AUP1H5FohVWD8fCZRdZ?=
 =?us-ascii?Q?pA+cqvsKCOEq4k/yPQYo4p/juWE+NqA0p2Kayh5gN2NvXwKTN/TEb44elnTy?=
 =?us-ascii?Q?Zpi34pjk0AFJcbUjUnxRwT0xMgYr1h2zpy0swazqh5CCQHhlS/mwf0K8QDHC?=
 =?us-ascii?Q?t6fPSxP/iTWBhPcc9hmd97nkEoaYqulCOBarEfQ/zRhGIqBbGMiuMK9rBhDF?=
 =?us-ascii?Q?tg5pQVMaCQ+mqZ17ZYy1Iv9ujoJpRlfY8iTeStJKC41pyaqx3CwF+Lqled+Z?=
 =?us-ascii?Q?xIBUyhbPdy7sluMagIwWG6UF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <798AC0193565D344ACA7244DF1D0E979@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd25832-cb1a-4a95-bd71-08d9932fcf8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 18:39:40.3529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caF6euLqSsusMXfBHHiWF5hJDEdjoN/GhrBk6XZ+pAj0NqVju7iFAy8tHN7t2YQnWR03xX9HXfCbRaNHCHJ8sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 06:19:25AM -0600, Tim Gardner wrote:
> Coverity complains of unsigned compare against 0. There are 2 cases in
> this function:
>=20
> 1821        itp =3D (irq_holdoff * 1000) / p->desc->qman_256_cycles_per_n=
s;
>=20
> CID 121131 (#1 of 1): Unsigned compared against 0 (NO_EFFECT)
> unsigned_compare: This less-than-zero comparison of an unsigned value is =
never true. itp < 0U.
> 1822        if (itp < 0 || itp > 4096) {
> 1823                max_holdoff =3D (p->desc->qman_256_cycles_per_ns * 40=
96) / 1000;
> 1824                pr_err("irq_holdoff must be between 0..%dus\n", max_h=
oldoff);
> 1825                return -EINVAL;
> 1826        }
> 1827
>     	unsigned_compare: This less-than-zero comparison of an unsigned valu=
e is never true. irq_threshold < 0U.
> 1828        if (irq_threshold >=3D p->dqrr.dqrr_size || irq_threshold < 0=
) {
> 1829                pr_err("irq_threshold must be between 0..%d\n",
> 1830                       p->dqrr.dqrr_size - 1);
> 1831                return -EINVAL;
> 1832        }
>=20
> Fix this by removing the comparisons altogether as they are incorrect. Ze=
ro is
> a possible value in either case. Also fix a minor comment typo and update=
 the
> 2 pr_err() calls to use %u formatting as well as be more precise regardin=
g
> the exact error.
>=20
> Fixes: ed1d2143fee5 ("soc: fsl: dpio: add support for irq coalescing per =
software portal")
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: Roy Pledge <Roy.Pledge@nxp.com>
> Cc: Li Yang <leoyang.li@nxp.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks,

-Ioana=
