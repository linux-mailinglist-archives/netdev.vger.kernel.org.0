Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4FB428E78
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhJKNrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:47:01 -0400
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:10048
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233144AbhJKNq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQGhbxTFB4b3fru3yuYkyYba6zWI5RXBHcoOCUbI9ql9vCwUtMBODsltto77tjyEWjDidffQEkwbOxpVo5ONlbWHMpHj45b/EmdKlUj2rupLhzTW/z2TFaYfkzuxVIXueTcSF1tTxIgpeJ5nu7iigvwbOT9Agu3lN0dW0wfLhlMWnA90Abb/t8DCy8on+LczDuXhuwgAyhlG1HO+z9rHeEcVclFLBvirDNAcB7mlTFCQO9DgR1QWNMqxhmhiopPn/IOFlVIK2X/G370eRpWPeU1+KI49rsUAxTeAiSRkjXD1HQDylyhsHPojA0Tueu/GVXmzpfyoixdA8WpBBxJ6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqjEB4c5xwliGb7k3fV0qgdcRD9qIFGuHG5xXz/f0xg=;
 b=XPHqp8ZurMVMFXo0OAbHXVZAhkrdXiTs9FptY6JuKqhFqfssmybdCly4oe+VNup3cV/Y7JnlqFb2RBAz+XozgeGzWFDVn9FZsW6m+LMrRjXH6YcItqUg2Q7t+bgDJDNTJPJz08Qx7KxCdsYkznLEcIJ8O7zSzGo4V+pOF48CnFAUNZQfdfYf+zxbNknlgvJ6psmY/J4iTsYVymVn5gkhqpljhRm22x7TMVxjZMHI49r0qm5bqX7Lzu5JH0BzyTWCQC2MSziygrrgPu7Bi9H5aQ8eX3gD2Bnu5GixH49jysFbSw9mygxuSHbmubTyL2vJk7A81gf+PMoV0EMK15e3Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqjEB4c5xwliGb7k3fV0qgdcRD9qIFGuHG5xXz/f0xg=;
 b=sB1OO87L+I7VECugaPoiMdfCveGaUs7dUeb7QxDDsJ3iPTsiRhPdmo7/UCaGwbbOUW4Xjdc7B+gIbCPg8pje4Y3Dspe3YENCSQ42LMrz5mcuKq4Q7XdCwHTnK2N7AqVmXeayj3U6xCbU4CVmx9bJxKgm4Aiv59ytOXAjpd0tX1M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Mon, 11 Oct
 2021 13:44:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 13:44:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kael_w@yeah.net" <kael_w@yeah.net>
Subject: Re: [PATCH] net: mscc: ocelot: Fix dumplicated argument in ocelot
Thread-Topic: [PATCH] net: mscc: ocelot: Fix dumplicated argument in ocelot
Thread-Index: AQHXvkel1cfqSCX5gEejSBIt4etDmavNz8oA
Date:   Mon, 11 Oct 2021 13:44:57 +0000
Message-ID: <20211011134456.hll2x74shzov3nrh@skbuf>
References: <20211011022742.3211-1-wanjiabing@vivo.com>
In-Reply-To: <20211011022742.3211-1-wanjiabing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be4d24b4-cfbf-4b59-fa9a-08d98cbd50b4
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6941A9618C24F90768CB220FE0B59@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:519;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7rjnCuyeFAJeff9CMxvJdi7NiWXVDCMMeEObF/FvggIbRpWG6vOwYMmDo3CIL/n078Rgws2gfjlBkfca0FRbLXXjJi162M20Ob7jHk8T9hnM7mKwDSi3rrapIYDJ/wNgjmqrvU/4QIHNVOt5rFIbCkkodDgFvzDAqVCsq+QaWEkudtow01vj8rKhNwIcEupjYTlF3pUQEhsW9x08O7oG5g1hWKGz280be9NUNvxxM2Ed7HGVPQurVKRt5gjTllKsmT97RGHqu1t6SzJUqiT71B6rAaGQ0zVLYdYkiLJRKYjEXWBLnN73sSTnUBV45KqyJ2oQPiulH0D8M0LHz5y5jzPsGE5cHVgP9ZtnfU5OWh5qi23C/stMHDWOwZceOKWhknQthU3/NrGAzdm7onyCK0oRddmQUQ4JtAElvcVGvOVcTAIHKpu13Ad6s/X3Brjvsy7PS4BIwRk4LWF3tKKapS9EendqiXGpAhbrEn6mfg3NoNXVyol4aKgZcduaZX8TYne2hi1Lc0G5/xL3+X7qCD5KTsaP4kGYjPpcWjbE2GUtKRCPKjS/uKsDJpBEGZXCJIGOxGN9UX0hTD/8ZSR2U2Du4N2gPbwApOPFTIk+PkGmDJS0WztnprU2bhKny1vMIPWd7FvpaB/kW1NJey9hTkHpRGg54C8PXh0kMaHcdmGV2AST74Ii2ceGTTq89IsnNGdvZy0Jw7zWNWfta1yFsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(316002)(66476007)(66556008)(44832011)(6512007)(9686003)(66446008)(6916009)(64756008)(4744005)(4326008)(508600001)(71200400001)(54906003)(91956017)(26005)(186003)(66946007)(6506007)(76116006)(8936002)(33716001)(6486002)(38100700002)(38070700005)(1076003)(8676002)(122000001)(83380400001)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wkHHdLVmiYkt9roVCOyURToG4Lq6EQ+2ZhkDF176+BsBOYFkXDQPUKYlmsQT?=
 =?us-ascii?Q?CNS+4Bq8910USyddunP0/s1dZ6WWqPfOeDlVU7ZiL3SAAI6GqjVtWlIXL8Fo?=
 =?us-ascii?Q?di0tNHO1ZmJiOhLlUE3XJ18eoGRHJ/y4AHgjSS6GBXFLGv/Zcc5fR53whZgU?=
 =?us-ascii?Q?WCrpYi4hj6Jvb1tan1Eu2UShH/lgjZ7wPFT3TTH/KAQ2WCnC3qf6C2vUBqQv?=
 =?us-ascii?Q?fNZ5t0puXfkif8obojNQzOEPF0kGQeCs56i5tt6vOk5yCRfaHM+aV0gHDp74?=
 =?us-ascii?Q?6DNnXo7SHlSQWYaZsXNp99VeLQiHhXDKZxF0jYCDgU2zQDEq90fKWHS7fkik?=
 =?us-ascii?Q?S5BPqfOtUKzq80Nv+r5z3SddlYZTQ5JBo41l2K/3sHRdEp2jt1FSHs/3y+aZ?=
 =?us-ascii?Q?m3LGX1XG5Zt9d8X8B0+TwcmOyboguAioJOcUoH7Y+bXs4ezsqUmUC4DVaudr?=
 =?us-ascii?Q?ztO+Pe36Kfmb0tKNTbNa5jOEN9sfiz4Hko+6KcXAkhE4ndE0IFZBOkWbp5jA?=
 =?us-ascii?Q?FYJZl91r6gSb59ODL7TQncjWpGBCO7xwjYj8Nvf5y4fniQPgiJjBDL+RlXiV?=
 =?us-ascii?Q?vbaT4Ap6Yic0vfNol+gBmYl/OpQjGU8a0B1PmtgYDCjR8IJ0ruKZOd9Zz7Z4?=
 =?us-ascii?Q?V/h2jJxX5pbxfsprfgOf5HVqBjnCiszkRruQwFF4A/L1kpVU6zKSlM62XpwK?=
 =?us-ascii?Q?atje+fl10oHgZr2Z0d74dnqaLZF4Nwr+vbaFuRfJdDXAeRWwqBNbOG1KDGf3?=
 =?us-ascii?Q?Wh6CU9TTmVG2vhKuHPjj/UoAhbxkmyR6WhupmSXkexJSfkdFLbHiIJRDMwfE?=
 =?us-ascii?Q?2nLfB7YKS+fSkqjJg6TqNcGOCs+Uz4bWHgXAsvXCTVXF5TKtqTnYMcz5ZE0n?=
 =?us-ascii?Q?mGpnY7Mb0k/fTDP3MahXA7o35b9Q42ciqHeTmRumbUpSM0eEq/3z5d7RTBVL?=
 =?us-ascii?Q?+OpIvYtTWL18N0RhpeRSr1lG0vOGarjTYLz7TOjrhViF1jXFLn9C5xd5k0Qk?=
 =?us-ascii?Q?LUfoTarQTwd4jTiZa8rhJTJNLvKUehTkF+Q8Z8plscyxTOuTKxJPlNVKV3kB?=
 =?us-ascii?Q?ZrzRh1ltdFfikm4KiP4279iumLkDBHRNEcPFvPXb+e9xIYpUZepcqffxjaUM?=
 =?us-ascii?Q?baE4DHyZ5Fi66V1p8BmaHYSIZ+McmBHd06FiTiZRqrzA4ba9e3lySp8Q9BqB?=
 =?us-ascii?Q?En2PCAN4XWyy6Ezf7xigvsm7bNZuon39M7YrPhs+lQ9EIZTo2shFb5AppQyk?=
 =?us-ascii?Q?k/kd4tefCEoOSiT8yWMhX6Xto4DihpF4gXbR0WS/IqaIiMNmZVW4kZYHpAB4?=
 =?us-ascii?Q?Rt2khk8ItcTGcouB8dXbYT/x?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF3A17BEE4DBA44BAEBF9C567E0A2AE1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be4d24b4-cfbf-4b59-fa9a-08d98cbd50b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 13:44:57.8902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ATbpYRIWhZtX3BTBrO7kuCD3yCRwSVWBvDJ9jE+XOp+4eol4lBnQG56jgtneBMcEvHTPvTufjVlK8lv0rhxYgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 10:27:41AM +0800, Wan Jiabing wrote:
> Fix the following coccicheck warning:
> drivers/net/ethernet/mscc/ocelot.c:474:duplicated argument to & or |
> drivers/net/ethernet/mscc/ocelot.c:476:duplicated argument to & or |
> drivers/net/ethernet/mscc/ocelot_net.c:1627:duplicated argument=20
> to & or |
>=20
> These DEV_CLOCK_CFG_MAC_TX_RST are duplicate here.
> Here should be DEV_CLOCK_CFG_MAC_RX_RST.
>=20
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
