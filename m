Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE531D8D9
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhBQLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:52:24 -0500
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:62945
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232090AbhBQLv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 06:51:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y99PMaR0zVt4OLk5reYPHNaVtv0QZ+8cCDtsW8mRzy2vG/sXXLLJbmhDxTX32lAa2w38Bzcm81GguWhVwEQ1066xn6kykSLhZ/9jsRgx06SOEc/rhFyENq6dyGA7Aow+ycxwP42aN1Kbgjm6WAsiPEpjV6tZkM3nZLQV4RffZDjV0XpY5BTv42zdRmdGhZkHVufXW+HzT6CgVHBK+NjRqeAWrykCn0dG7W6GnZ6ZFYV2ILQ0ggOQVXvyBkrneEh6OnQJHEyxHhcmq8KDSpP/3IhsRZPd86+yJarBr4u92Q9CGEyEnZQPDHcH+ASPVIS49hGL2tQZnTOybhkMCxE6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oR7dkSH4Yy0tg+88h53zFKxZ4MHXz5Dyew/uRzfNLmU=;
 b=SU1zgwMS9iFRW/usuYMHvCgbcUhBK6O/eUzUZFAx1Ktgc1Zi1IA4/TnzEdscchTOnevTUU3mertyOyF//1Q9SqCnUZmeyfH3yVJKrUt5DJvz4Lf1uSTncnSP5IyEhGJF8J/703mMOakSD76SZ52OBPALtPn+AcVKnvt03omN/d+pp/mvkiQR3vKMcdSlEsWv5orPwueoG4p9UZ+c/18onGJnyd4U0epSdVYP/3nkndiNX6Glq883XZGWTrfNzibBTgSaaHREQSmx2cd2D9PziDLs1O9hRrwHbXJUNwVXAF6vE/KSpXeiiiEZInl4TTJibpWyqbnD5q4aTRJkdZxtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oR7dkSH4Yy0tg+88h53zFKxZ4MHXz5Dyew/uRzfNLmU=;
 b=lSkU7IE+n56Xyvt4/9QZXJ/qMjR0rmhzF3VgKGGmfbFf8IYslNC8+tjguWHG5xDSSRdNWI1qTB8HCA5Mu/PQVsMZ+Onflj/okWU484H4lIbDJOlJZDQQV2xGAbgWqDs4rGfCR08DMMlonDq5QAG34I/D9Rhb97Y8AkGHXznpXP8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Wed, 17 Feb
 2021 11:51:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 11:51:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 6/8] net: mscc: ocelot: Add support for MRP
Thread-Topic: [PATCH net-next v4 6/8] net: mscc: ocelot: Add support for MRP
Thread-Index: AQHXBKzGJ1Wg4iFy80u6LZWFFkYv5KpcPP8A
Date:   Wed, 17 Feb 2021 11:51:07 +0000
Message-ID: <20210217115106.dgyn6c52xe4rvrsi@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-7-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-7-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 58f0c393-613a-423e-0863-08d8d33a4fc8
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6637B1FEE1A56945AA582B95E0869@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c+hVrRWs5FSyBetpMS6dAttxRFAlTFk/HJ9v+HhULqrPj4jpBLFQiNJpc4T9hjyea3spHmP3XtELdy+M7/l165Yw7/6mTXnbwtt2Cfdth4OhPap4SFchGwbtqWF1E5PdtEX2PBIH2MOmfCSweccmOf2Jd9aXFD4CwEvb6dYShq0vxP97s11QZBUNDzljdq048NnMuH8VxWkkaoqIbb60E9/JJInMBrua/IUwY2CdxQ4Exx/9kQG6EwHaKYhCxyPidnvg3Y2H8k+teKU9W704FVqAlvqtOMSahBl724DtUJ35u+96mdPenuL4xLZW0cUppYUoXYeuxwz6m7pcQPOBlLtrrbAcrqZbOBNTdo2DniWvTy4BpCdDhBtS7TkqF1xuxH8xyNwOvkXjXdxMbTaF//Czn1dxJgMVQ3mE3Lt3UHfYz4DlUWKfeSv+YvVTq4djBUZX3+ugCk38ugRPCPvPT5GXfY9up/+iE/Rjx1kbzcmwhpicZEQJYAX5H1EmSVOEfzRa/P2tkBl0EODxP7NX/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6916009)(44832011)(64756008)(6486002)(558084003)(91956017)(66946007)(71200400001)(66476007)(33716001)(1076003)(66556008)(316002)(76116006)(66446008)(186003)(26005)(7416002)(54906003)(6512007)(6506007)(9686003)(2906002)(4326008)(5660300002)(8676002)(8936002)(86362001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8pTBuXTezUyegia+hkVTwSTBkgV9cu1W10MOlScnjh7frECNB5v/u7hKcWa4?=
 =?us-ascii?Q?/nCm0GQsehrv/0+RBRQNUU38eRxSzbQXYv48j5cYCk79XEWuR3ZImplAkRUy?=
 =?us-ascii?Q?KgDaUOYOqgWQ/v517CCQ5N/XNP5170r72qhhRMqagkyh7r118vARMIIqozhl?=
 =?us-ascii?Q?NGl3ZoMqgfSKd+gyCYGuDxzVwcnneYNxrWNqheVVIQBPb2fBfDYNIUOKYRQ3?=
 =?us-ascii?Q?iZKI7nFIealA/qrw1e84LT5nTXeYVA9qgfY9nDVWYlhAet4Owm+teHOGaexp?=
 =?us-ascii?Q?dhjQJDs5UtrAUxgMR5MSB6FCGwCJaB6Gl+iGn7CGRL/6szb33LRWaHvw7Qnp?=
 =?us-ascii?Q?uZR22eOsrHg1tK2dEUn9q1og4KUH2SJYFWuLl1AJs93e+aE7PWBWOrrM0A0A?=
 =?us-ascii?Q?vQi3eJQR2vpvfEWDbGiykrKy7pcWrg6BKRoSJic2lSL6iNTs1/laqNy7E9lR?=
 =?us-ascii?Q?N26i+kXW9jK+eijr50m5ObnReQh+dY4R3/QutABH3fcDncm3YGRZOfdIYLeT?=
 =?us-ascii?Q?kyQu60u9aPnO6vAm/vmwPZKvCwLDAat9l7HcGNMsQkluPx5+lyAseUldbRKD?=
 =?us-ascii?Q?kVAJ1iPbD6Ezq58XvdJa7KoHYe6+bq8Ls7fU5u3YBhhjYrIYjK981Ed+dr9k?=
 =?us-ascii?Q?E+GFbKBTu334yxVf1SjJ3rJ+LitofQMkIPBFecur7QJGnjl+yEWFRF8uzkRy?=
 =?us-ascii?Q?CEt+5y1gaZBdxMlqVu7lGMlwshIDO2cZv4VeEifLg699qSmkWtLtoWEGvaCe?=
 =?us-ascii?Q?EVj/qerYAaDSBUTYvRqmwOWw2gdw6cDRTafSKAoGNxD+yPa5tG3QoUnsuIi3?=
 =?us-ascii?Q?wM/OMc31ecpSf7i20LuIwNIiiYGZOEwVx8o1LAAf19atAEv4JnAEOz5l5exn?=
 =?us-ascii?Q?JCKs7vhCQG+MEn4fkQXDfVkMzs7mTvlXLxSO8xuiNy0kFI6pIzRDFInppKPn?=
 =?us-ascii?Q?45f4VzAvItELYv7ejMUR7YaiJniTVJGl9ORy0BbTeFC7i2E5y4KN5R656hiD?=
 =?us-ascii?Q?8l1OaVmgHDMk1+Qxd15A0TRpgDeNMftTMwj3n819P4K5ZKp/Gb3iEFi/Msjp?=
 =?us-ascii?Q?K/l9lVX5PzZUryJ2SgU/m4va8iKJ6cSHEcsaJISqzrlvyCPVRf6zjRwznr7M?=
 =?us-ascii?Q?npze0H9WmacZk6+yxeD1xQN4Np06AxGGeqQocm5aYYcpItOL8XGZmSs9fCbh?=
 =?us-ascii?Q?BLpGB4Jh4waDrvGV4VJtz8M+ZKB2Wa9caQR0/w7jI/Z3kyr24VwjU5fw0khW?=
 =?us-ascii?Q?eHf9mrJxOvgG4FVdXOQ6N634HuBBBiSuXLnV0XqJyT5gs6LxIIAKsy1StCBf?=
 =?us-ascii?Q?eFW8M8Nbu7ulEE3a/k7nJxvo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E8BCF8E2E79044280D67B40FFAD527A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f0c393-613a-423e-0863-08d8d33a4fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 11:51:07.1659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIKg2RZsiafl+kroVZipKyh/UyWyTmB06bNxHY4+VRqHltUPNSUEVfcGOF2D/H6HQGqDCr3eddlUzfVPTr+wMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:03PM +0100, Horatiu Vultur wrote:
> +static inline void ocelot_xfh_get_cpuq(void *extraction, u64 *cpuq)
> +{
> +	packing(extraction, cpuq, 28, 20, OCELOT_TAG_LEN, UNPACK, 0);
> +}
> +

The 8 bits I count for CPUQ are from 27 to 20.
This is spilling over into LRN_FLAGS.=
