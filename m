Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E28A458542
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbhKURMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:12:47 -0500
Received: from mail-eopbgr130080.outbound.protection.outlook.com ([40.107.13.80]:5184
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbhKURMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:12:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVmb+jJk0XD0nAT7WoLLYS7nbkkoq9dbTu3NerKX6DRpBVuwUw7pS8s839icof4qj/Jcv/bk9Wi8mzH696qkDKapwIHCQMe/ZMzjOjhDlkK16Vu8syl2BpFWQdBsyuuXQKe4fDbjC1I6QjfEt3AYbomY5r5lWYcZkKUzyEC8H1Kxt1uCYH69+M2ksqN9Ur+JkPPdmBHwSf1fbcUk3flsZDcYYk6I2UQXaWp17Ow6Jw+iYGqKmzhEDHuCidGz2Zrl3cC9zGmMcDshth+ndJmqzjB/+uXiO/bQZ3Bp4InjDihO4oW566VYcqfETKEq/3DXz4IBbTzkKvV/2YVCoIVNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JajpivTuTBDJvorWjP+Kw0E3eQDE5hQjC8+ghLeyb6w=;
 b=QbYTtGrXeNHa1FBNL8vkzq8jqzEIoUf1YM4W/mGifB45iG0ZnC9s9huZr4NaoZHnL3Tk2NnTYobw4Nt3b2KOipok6rbzhRrww80z30x5RlFTvGtoBujrOrm0NikZrolYaXfKMB3eJm2npCRN5vZ0NhmcD9y/ogt4noiQVbC3GHRtkU7GSCC11/OOeCg8xjl8/40+BOVZ2c4BnIJtpLfszpgVKrIH8EqXdMSZvBxQKcNtnEPx5x2ql4+ji7q+EYDcokDg90SZtgx4XzPVwF1Ai7XD1ZISdVBGg9PbKVcPg0UMn1w4ZjJ+sqtl4EfUVtWWd8DMKOgsvQ3GV2jdbfEgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JajpivTuTBDJvorWjP+Kw0E3eQDE5hQjC8+ghLeyb6w=;
 b=Xlo1ATdcxJo7ms/ctMdYt1wVThhyZgnVmLDANyY8ROClXtoNEXt+5b+qMrn1YQutJVVf5kMIwSA03LNyr2O2F0/1afr14INd4Bh4/psvduRg17mfObDSOcTgdT5kKIuSpLE1vYJxubG+YecR1g3Va8AL3q3c1jf7elbANYkF7So=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 17:09:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:09:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 5/6] net: mscc: ocelot: split register
 definitions to a separate file
Thread-Topic: [PATCH v1 net-next 5/6] net: mscc: ocelot: split register
 definitions to a separate file
Thread-Index: AQHX3ZbjHD/GouZ3AE2RZ2NU3aQGnqwOOfSA
Date:   Sun, 21 Nov 2021 17:09:39 +0000
Message-ID: <20211121170939.rwvqxsiruhc2edze@skbuf>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-6-colin.foster@in-advantage.com>
In-Reply-To: <20211119224313.2803941-6-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94afc5e4-7d14-4f97-0d13-08d9ad11b43f
x-ms-traffictypediagnostic: VI1PR04MB6943:
x-microsoft-antispam-prvs: <VI1PR04MB6943A1C2EF5CEEDE1AC1D8EEE09E9@VI1PR04MB6943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ox+8ZIFIu72lZ9hFbzlaIEZ1zt8VOicOydyu2/rvMT2dCT4ikVXc3kCq7YH7HnZySWM0YxFcHX42IaJENrqqBbjQ/4w46QtgyZIZ8tVTiUkYYR0296jCbN08oAOa8N5jrl9Q6PbY+9kbmpRBrgCL3oBreT1fAPKnOteNxpZCxMaLXycY/Bxngm+nC8on1mepbrGA1K9athk9cMqKG1jmAKHEi1Mslo1BMsYtP/VozbCiShXIFCoHmxy8lU6eosPM0LCbp8ZXFi07X7b7d8YGvTg2HiL0W4j2wciMmfv2NSHJ2SYMox7+lX4YH01ivxgBsR1kj0NcHez0PsB0VkwX4iz6UoC60p4x9E3XoJIqrmODDoSASdmo5phH2hzRHk5hfuX5JJgPvV9whIYCeTZQahOYGcZYXeQBNEQ+wnqoFdy3aa0f52UWaXxGuwBLq5tAJMTJuw2lDliYeGMhdZnGfZYUZ+2dAnEwLWYBH6JpCYeQmd3hHsxtaVArK/6iJ2Yai2vz9uuV76H2LlQWRPp+EuufttF6foormSuCpj+RFMBK9p1nLyzUrRy9BmpSlw3pfYM7nUNBiP70/3ugJFkceZLEXx+M0T2XaF1tDgXLreK4/Pc1z8hewOmjm7occ/OUPflR6JRkwrh2R+Mu6QyU75MWoLNlewLEZnADa6ABSvm+u6wtr6/tB9rYHkNLwMT7BLg5j7WUm6EnTrJY26gz7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(76116006)(508600001)(44832011)(4326008)(26005)(6916009)(8936002)(6506007)(54906003)(38070700005)(86362001)(8676002)(2906002)(1076003)(66446008)(66476007)(38100700002)(66556008)(33716001)(6486002)(6512007)(9686003)(7416002)(66946007)(186003)(71200400001)(316002)(122000001)(64756008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dQk3ggBTuK3zzf7K4egChF1b6QGpgCagMxK4uaLvZBULb3IOYJ+gmJcLmPDw?=
 =?us-ascii?Q?xxDj2nNwj7lZvb9jHEEQvpHJAZhYO3ePmqmPqsSFGweIDYltDcU/TusZ6mMZ?=
 =?us-ascii?Q?w4WHGxISzgSn0swLMbMN74JizHs7KCsvcY637GhK7NAqsdPeXQTvZUMKrlBb?=
 =?us-ascii?Q?56LR37nnTVKA/N8PIuahum/jspmoZOmGdXsmM3kxjrmu9s1k0MrLidSFhPYZ?=
 =?us-ascii?Q?de2+nC2Fha7bFbwZHa8JmnTR4NViJugH/wQa8svtk8tQH+hFtctjgXReakR8?=
 =?us-ascii?Q?QX2mby1tmqsguYzvFPqQT/eqAetSaaPZ269LHoKeUe57NmTZfaJSVBs4syas?=
 =?us-ascii?Q?rPMx/xsXET1TlYxAuH0AET2QtG8ql6XXeYzJ3E721z806889t+ikq1pYWWwG?=
 =?us-ascii?Q?P0kWpzBOYNPd+XQQY4PHJRZmi2Tvx9GdaywBB1Xst4sw30PVzOrRlJnBzXiZ?=
 =?us-ascii?Q?28pB9Qd0dGaOvZMAEppgTKiJh/NhwlrHAFJUQCRA8Q8sPhXj7YfC/7aRVW/B?=
 =?us-ascii?Q?JSQ3BFqDlx8MKjs3dQr+Maat733q5agLTXefwjHvU0zfBFujC9gOcyLez7yB?=
 =?us-ascii?Q?ErTFvmjRWXNKtOTzXM5rPZkt55jGtANxMi4Ru4KebKsk2zne9pSRFmJxV2vW?=
 =?us-ascii?Q?rFtuYLAI2w6EZP5sl5Dc+jHdNcNRImQeI4ALZseiEY1mKKGS+MBmQ0bA09Gs?=
 =?us-ascii?Q?agShsMM5MIpLIjlJndAPKDt3p3rwYkWjuxVMi7zQkjujNNlO/wJZaa5Bl4T0?=
 =?us-ascii?Q?r9R3WY2tNFEDNGJRzagdc4WVGUZdF0l5DlP3DlmeCkwAFhgX9A3HDiCHwnDS?=
 =?us-ascii?Q?Z+lM3PeZ6vp3a9Wbwfnu04XuYBSggGSduOfr9dJ6QUJBTkbpxkxuCmh1zdGY?=
 =?us-ascii?Q?EitKxcdt2UEfAH5b2oAbqUpmcQ5F4joMf8BlCl/f1OXzPgPep7FdogM+g2yf?=
 =?us-ascii?Q?XF/lLOrsmPkO599xLIOZtI1HLmAeEP7PKXwlHANNMpi8g1q08nH1tTNPQLu2?=
 =?us-ascii?Q?bveUegNmaKYyZM2ibDG0ZE5W7N4hpNHQhcxciSanlIT6pE6Ku/beX26lCXtx?=
 =?us-ascii?Q?uILlBh+pPa3j7gcvRBVhMhK7zN3SpyIgJBFQJFMl3xgzKbX27FnwKEuW5aKl?=
 =?us-ascii?Q?ww8+N7WSYCi5eHBjIQKKlMkdd7yeUxG87yjLsGXX9iNPrJEs3si0uBfAID/o?=
 =?us-ascii?Q?68crDJnPwMDvvD1mxY5TD/0fqUJmljNZ0ixAHtwq4A0fOHm6JA8JS/8ofOpR?=
 =?us-ascii?Q?Freg9bS7ZtOZxff6HfDFXEYmJmwXUq4wr+BXj43lv8uIM5dwvFnGUPp2iroC?=
 =?us-ascii?Q?HUGWYgaG+PcEVyYCH0T7VKO1ZoD4aQ47OBZMVgs8xpY38AJOl/Y3LCLqPgKy?=
 =?us-ascii?Q?l5m3dgEm1DAXBiHYi0x3sVwNwN4fclnu7Z7c3hlGv55B32QZRQ7C2fGZZ0D6?=
 =?us-ascii?Q?5HOHdRNaV8EveMnOA+27OCVJIfPcojl6eldXDWQi7F3OIhSk+VGpquUBa+8a?=
 =?us-ascii?Q?V/mebtYUeguVgFNHNx+nC2qcsSorww+DUhXCaowpJfhIFq+6yoKKLb2TUw9E?=
 =?us-ascii?Q?SCTQoWD9R5V+5QkFpRvkdlL97hzSbWnQDn7Z4btf5m6J7OdR1Tq0H1AlRuB1?=
 =?us-ascii?Q?LD6iaRMjI/gIuZ9Ol3flYJc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D45B77EE05626344BE0F0FDC200F4D60@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94afc5e4-7d14-4f97-0d13-08d9ad11b43f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:09:39.8636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bdlnh1Pd87vyHpkzOm8xLkaE20QJrlV2AJEJz9z0zzeioroQmmHrc1OJHdyi2HvNHXVkZFWaKaXFzbU1mmRlCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:43:12PM -0800, Colin Foster wrote:
> Move these to a separate file will allow them to be shared to other
> drivers.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
...
> -static const u32 ocelot_ana_regmap[] =3D {
...
> +const u32 vsc7514_ana_regmap[] =3D {
...
> diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_r=
egs.h
> new file mode 100644
> index 000000000000..c39f64079a0f
> --- /dev/null
> +++ b/include/soc/mscc/vsc7514_regs.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Microsemi Ocelot Switch driver
> + *
> + * Copyright (c) 2021 Innovative Advantage Inc.
> + */
> +
> +#ifndef VSC7514_REGS_H
> +#define VSC7514_REGS_H
> +
> +extern const u32 ocelot_ana_regmap[];
> +extern const u32 ocelot_qs_regmap[];
> +extern const u32 ocelot_qsys_regmap[];
> +extern const u32 ocelot_rew_regmap[];
> +extern const u32 ocelot_sys_regmap[];
> +extern const u32 ocelot_vcap_regmap[];
> +extern const u32 ocelot_ptp_regmap[];
> +extern const u32 ocelot_dev_gmii_regmap[];

I have a vague impression that you forgot to rename these.

> +
> +extern const struct vcap_field vsc7514_vcap_es0_keys[];
> +extern const struct vcap_field vsc7514_vcap_es0_actions[];
> +extern const struct vcap_field vsc7514_vcap_is1_keys[];
> +extern const struct vcap_field vsc7514_vcap_is1_actions[];
> +extern const struct vcap_field vsc7514_vcap_is2_keys[];
> +extern const struct vcap_field vsc7514_vcap_is2_actions[];
> +
> +#endif
> --=20
> 2.25.1
>=
