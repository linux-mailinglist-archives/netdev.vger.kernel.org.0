Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9639B4F961C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiDHMu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiDHMux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:50:53 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140077.outbound.protection.outlook.com [40.107.14.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AB3996A3;
        Fri,  8 Apr 2022 05:48:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8t7mYOKh4Gxs58FmK43/vGXBcaXL6Q56mALbdrnMLqhR7Qr2+ChU/bTJr3KgDbc3F9qYqfRml63JlsnRs75wTKgf6i1N/QuKVIH9Sxzgbqq7Cha+cyvKWfudkxh997UfQfFP3KTAXX0Vw0BxAxDRdbiHhXFImAWu4b2vGQiKXlyoqIEPNztnzA1j7Qzo8W7BFHpqW2qf/98U2B6wTST+KAWZ3HNO4IE3PJJHzxHrRti6W7mbq0F6vK/N7anoim9CrnFfy+ljHLhXMEXCjD940ELZ7dN4IptMOXZuZGpQ3yYHbdzDgUheDfceDplye2QKsvjYFYvDgSFSTl7swKFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/6D5RxLNpSNxg9wMQ/i1u1j/a5rQqspgCgdDfC2/7E=;
 b=AL7B4BxqdFPwAb9BI6zy7fwO6tL/tfb0wXELCd4sKGMl+PNfWBVk1U5QiqXxpxvyzj6g6KTpbxlxhtGpKde9gONrLVeANz5Jo7ZcqpPVM4o/KEHIxATJ5oOH7yB/6CuxtbRPFjVMJ+FSuRKiPUjyEhUGoayXVaNJoFUTiu5e69OMl0we9LFL5Oe8mXuPmaHyGyhbFNYcy6bZx2/fEdIULK2r7rcY7xJsGvE0+CE2paUhmqbKIIk65BJ8LtC5d5aUiEMEAxI5MMwzCXWPZafjlusPyIIb/kRgyYTLuw2nRFIir4cdUtX7G2ohvuIVOcKTOu3ns0fZ4JIzOw2dbDkqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/6D5RxLNpSNxg9wMQ/i1u1j/a5rQqspgCgdDfC2/7E=;
 b=m83433u4h8Td5//LdgoiM2oQYe/b1oczWPBGTPO2JCleBEGB8ghCRcaO6K3m+JXeOoJGTUjwnclZF19JcPY3OkXviMykRUinuIuYr6/hZ+rOkaETfz+H4btY5W6OCSs6s4I25wYi4+VP3TidABE2gfnSs0zjnlobMJQ4WoK3oII=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 12:48:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 12:48:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 1/1] net: mdio: mscc-miim: add local dev
 variable to cleanup probe function
Thread-Topic: [PATCH v2 net-next 1/1] net: mdio: mscc-miim: add local dev
 variable to cleanup probe function
Thread-Index: AQHYStmBfKpjw0kok0qtTUik7cmjGKzl+EaA
Date:   Fri, 8 Apr 2022 12:48:48 +0000
Message-ID: <20220408124847.zmbk2umwyxsxsr7n@skbuf>
References: <20220407234445.114585-1-colin.foster@in-advantage.com>
 <20220407234445.114585-2-colin.foster@in-advantage.com>
In-Reply-To: <20220407234445.114585-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 817b4db2-a68b-4dc7-6dd0-08da195e2047
x-ms-traffictypediagnostic: VE1PR04MB7453:EE_
x-microsoft-antispam-prvs: <VE1PR04MB74530DFCCD0CEF68778741EEE0E99@VE1PR04MB7453.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykOKlUEGb/mH9l62y0AJJ2D1n5sAFPrT5vEhw89kcRGOuJszSaPls4CdZi/QSVopOORFdJ85tdPXkDTHuJHsiz2lSz4hrT+To/c4RWlAPBUzJnAcZmWwEH3JMCtkJWfFA/FUptxMtmGIJ5tY7Fri1eiWu4WnjbLbb0JJqoYQjA8ViA7OMjZCtbqN5B4r4O2wntewqeZREOu8Q4yn/mcU0ngZynq6sMtrEUvAUiimVIe3/2Lw2uNdgNQ8oUwDQlXFkzC+rSE9K+uo2YDLbzt1xVmvsf62yeyrRuThp8ydFva9yJ8HkAxYBl+LLkkMfgTqmTxILN1BjPIi5Vz4nVGdAR5tKCQCbFL8KY/BVl4kvDRHDh/fq3gSl77NP4+YdFxdimsLjgzsCQ7t8HQMQDknhaUHtBPXwJhEPVL7DPeYjLVZlMKqg76G7KrGSzQPuyqZSl3QFoCQJ09TA17iKPhjpXPizYfDxxmbNqSDEyqR8XRzpvUZHHgkMLYn+764v5Jr5Hpvk6TS+bfLQr5vb0tdNjn8ZWHWdIirz7X18uLg2ejXPTEb3Me+U0ZbgE0zQcdeSgL4Z2mrkXhPajpOa2j4kGThH5hGt6j3kOrF9o26PFEdORvKTk/iptD17X1McIR9hqxDUjd7269U1aOtsxa6yPMojkz9Z0X1fBLPxwXjyOFGuA0ABj3JRZ1VeP65y0xkRMHMKUX2Sa70KPqQK9mh1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(5660300002)(6506007)(7416002)(186003)(38070700005)(26005)(66556008)(66476007)(9686003)(6512007)(316002)(38100700002)(44832011)(64756008)(66446008)(76116006)(86362001)(8676002)(4326008)(71200400001)(66946007)(8936002)(1076003)(83380400001)(6916009)(54906003)(6486002)(558084003)(91956017)(508600001)(33716001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lTT+qk1VcBv+/Ovjgek+DwGx2BrcMaj0zCWrcCJohw957/fFDlnx9wDNh035?=
 =?us-ascii?Q?O6FciLwh3XGAm9FKkKCMEns1lhmGl73bIYqNjG+aL692n0E2SGRbx4NkQUIS?=
 =?us-ascii?Q?xCEzkCmUWgdJk3zXph0qsmSywAgGp6PBA5U2UPvBHOAnMcNC5XDtf2AYMNZr?=
 =?us-ascii?Q?DeyaaBxCGeRcfHL6iBFT6eWHW6geJ4LmIOL9jSqxK3NTR0pyHSGHLH6V+YvY?=
 =?us-ascii?Q?NmRgmMUcKdvdLSztv5EROMNZRgA7eff3a5CnCPuPUbAe+ARUVShIlHcNQETd?=
 =?us-ascii?Q?kOlsUgZnXejnqwkb8lm5p+FQ9F4BuJfDEZnROE2KdFDAfAEujJdyniPfCStT?=
 =?us-ascii?Q?DCWYcBjOCZ03D77gJEzw4hF9MNMan2jyyU7Y92nP9Se82tNP+HdAglT5A7xg?=
 =?us-ascii?Q?ycDNRvfJLXF95JKMY37jqYFLmkj+QSgdnb09nr088PlWtlXogq2sga9Yry2W?=
 =?us-ascii?Q?F+cIG/EGGHewIWYNXC0eOvBb46UIE0XdXMKxFdcZ192ZxMI+eOvRMHUWYTcv?=
 =?us-ascii?Q?x2uonqC6J6IrxOfZusOFlGRb19pZZTWungoTdcgNr28xJc2yua7JpRYcbZTT?=
 =?us-ascii?Q?oDJ6/bYB066f3gSOkzEQ6389gA8XzUXD93sQFAxrPufkDHeUQS648f9aTffi?=
 =?us-ascii?Q?VNOBWPznKW9ST3fpw9GDcr6ucL56RSqi+fhNT9SpaH2LkelE7Fxjv1d+cOIA?=
 =?us-ascii?Q?OI3Gd23gZMxVlRIWWTymi/wQnN2WxGUMZBvq4k0dgRNoyFMrFsZ1UtZSa8xJ?=
 =?us-ascii?Q?zchKhJ+qynVJ+quQ8xX2N8dt+P3aw0gz5VqoU0JchBl3m9BKMHKH902NJ6/E?=
 =?us-ascii?Q?7cGDeeQ5YbwEmmMy5ggQbhtrhyA+iL7xlklRDD9gpMz51nkDBKXZLgmImbKs?=
 =?us-ascii?Q?WFYVWTYhdN3K7NNGG7CNSc77DGT/0fCuz961E8LY3wi1lyNUC52ryWKO/bZL?=
 =?us-ascii?Q?Jvr7bGHM4mc7EqRFxRxRXP0l55RkvsVMc/JUKosAcNCf4StUxu4l2jPJpHPH?=
 =?us-ascii?Q?sVSys4fR8l7zKmGYCi7/2DojwLvFbD+9HnvKMEDip2dioYitxsr71/gpOiVa?=
 =?us-ascii?Q?1uyQ8r0xR4mvIk+0TTwaLUsAZBwehWnGOX+Ly4BN1lUpsBuQ/+8I4ENcRViR?=
 =?us-ascii?Q?ItK4raPAku16lSKgPkVrnUjMU7VURzEDACBwamkaokQFxitl6hfRhjYPR8Oq?=
 =?us-ascii?Q?xHisdXonoYziknbtDgUKjHH36yBVhpqSsovTvHCppvo0uBt5dsMKSYQ4ILft?=
 =?us-ascii?Q?aPZkbqsuMWB+N2ZjihQWU6bKMSGa1k50GRqmZ2JEfKjLbQak55ZoWsMJZR7z?=
 =?us-ascii?Q?dYgRin1GUPmm+/nS7Gg9qQeeM78DoBbaGTwRMFCaTlMACAknPMioDT7D/S2n?=
 =?us-ascii?Q?69v307wRBSIXu/yhiU/3Ki1cWNW11+DlFbwXB3TREYJYX5Yy71RoCa5AxA+6?=
 =?us-ascii?Q?LCjV9tN0YCygiKPG6zPvv7Jjs/ZM3A1+plwWgbayjw8mnCqBR1Yv3xPkCPNp?=
 =?us-ascii?Q?Z0MM8kq6ZQb+pL/iYz0a41o9BBkUIyO6p9N3tzVXVTC163fbCLGgVDxq1tZa?=
 =?us-ascii?Q?SXXF0ddhUGLj1/L+45gP7SZKTyVjFD8vNR+4KLryoSThX2XQH9raO6UAU1Np?=
 =?us-ascii?Q?4btBlIqojL09jnzr/Gq8MT98v2+xFpGcJ0hXdcpVI9iZDjvXvvPvwRMDOXAa?=
 =?us-ascii?Q?cvtoiFajObmYz4/P0XgTTY8+KahJN09+d4hDM7IpQm0ZCSqPWwoMkoMpdb2L?=
 =?us-ascii?Q?3hJmCOa4ZQp416Lsk831a+o2HbGtW70=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16917EE6E641DE43B8FCB4436849A3AD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817b4db2-a68b-4dc7-6dd0-08da195e2047
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 12:48:48.4737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmsmAqc/NQ7jipzCXTY6bg8mAZv8st8ipnGZx6NuLqZU9tC3gp92xufoUYPgm/450iyoBf+Zd3keDZR0CmxASQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:44:45PM -0700, Colin Foster wrote:
> Create a local device *dev in order to not dereference the platform_devic=
e
> several times throughout the probe function.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
