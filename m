Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB5C285D9D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgJGKy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:54:28 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:46215
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgJGKy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:54:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYh5Z4EwcC9fvLXjrIFfU79ELEHOKR+nXcjrnhZUUKr0a08p9vGjCoGMdmYPqNxrOiPlKEhEVihfDldvkCDior4nAUA9ECR8Y1WM0xhjf8vlNotFxrcZ5tCTEuPd4AsSHHNJwv2Ioc4uGkGI6iht0DP6k+O9KwtJ4XDHX/A42RYZFXZ+tF4cEIODTnuiqXXfqMl4UBLR8C3FPB9l8pqEPr9IlGs8WAhjfrdo2d551PNpbJPtniiYfw946kPpBoZeeWT84ZWZwFJ93MRGiAA/jxoshIaXxtDZ7CahP16jE3ME5tLSL6r4G9qoJnB144s9o+P1ZHmulOvo60JpzM/fvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZordUYyaR9GTNnwhEo538qYCpRp30BUJqNpdkJrO2k=;
 b=e53nWzg01P6ACu94DNjmkSDpJEXjRsdo/jzEmLbvMT/6jJM0QjHENWgxo+RTucEEdolK2s4Ae5JIJC8I0DMtRoqfBfjmpLpiCzy9zzsyCYQiNRkm+7GRF+OO/yBzN/1Kw6wXhsS/2FRMg1wawu2fMG4TM2CYyFl/wdRlJfYM2BKR7sK71LU+eZEq7nr1ytxGNHCb7aAga01SaFlejxF1ofEavnNnI3kVEs357pwo2GsIXvuoZNbYk3XOn5aUBL5Ml0L8EnUYM6evWE7K/LUirO2HHsQn9t911xLkz4ovvALCOYui3LFr8tZnAHGTxMINZ3zwF4wkSEwtWfthlZD+Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZordUYyaR9GTNnwhEo538qYCpRp30BUJqNpdkJrO2k=;
 b=OsqUOkTslqYR8C6qA27/QbUIQZingKvTYp9/v3ll9T6yVnFHYD6aGy0lWiyBgXwckzXDT6CBv1zWXGwgOIADoY8YkwOGOvRASrJLm2buBcjvDHJCqveetm/Z4S7eZkhezoyFigL54OCXIyc82A0YvUpjjriF3yYog2eMfEC1GtI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3472.eurprd04.prod.outlook.com
 (2603:10a6:803:a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 10:54:24 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:54:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Topic: [PATCH net-next v2 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Index: AQHWnI8JlRbBT0/t00aiVt9R4aXcyqmL908A
Date:   Wed, 7 Oct 2020 10:54:24 +0000
Message-ID: <20201007105422.kycju4574wafhbhv@skbuf>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
 <20201007094823.6960-5-claudiu.manoil@nxp.com>
In-Reply-To: <20201007094823.6960-5-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2058a81-0896-4148-9152-08d86aaf5a64
x-ms-traffictypediagnostic: VI1PR0402MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3472A863AD1F5A28D3B95D12E00A0@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jwhtzLJXoqDqNmVdbfeVInWKv/jykrbKQABnWA6lo2Aujx9n4gnB86w0pZ0tcpcUMe+TLGhMy1DRinJjT9u4zDtA01pUn62BYPMBf7Hw9MxYTexPYA3/rJqau5FR64Nei67/4qgBpMBeYj3o0ERN10veU7nuMG8WUV2yJfrSLs7H4KINmtWDo8ge2Kcp+vmCBHzNH+Tbj7U0aUXG1STaZAqo6rm0Y97BkTjx+2Em0b4slVHg2W98OfetfUeI/0g8hLzio6vxKn8Y1GB6Jgy+tKQikAt4uhGn+D1lz6BeNJRCvbfT+i8kgdwDdMbmZpfR6008pxzaccs6cw+QymE3/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(8676002)(186003)(64756008)(5660300002)(26005)(66946007)(66556008)(71200400001)(91956017)(76116006)(66446008)(66476007)(33716001)(44832011)(6506007)(316002)(4744005)(9686003)(6512007)(478600001)(6636002)(2906002)(86362001)(1076003)(6486002)(54906003)(4326008)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6MDbEDoPQwFtM+z/60Ct84Zt82/QBqE3pFux5BNscdo41kHKk4TozkI5GQPJ8XyEKgD5RRO//JbhRerZ4uY6XWByHgjhFJU0Hc064DfIhsKuTjl/TRbHZyXaoXW3RZXThlofHgprMdpISbNtBNkulLpxQV5XYjF2JycJ1vjcn9oY1OOxqRlZ+NhlE9pDQGOc62nGsZijil47ITl8eMZdTSO+E0D/22Q1ziVYX8E50uMMVATRywzv+FCqwjDG6qcD/AQk/xSBcXb6JC0mpBdqpXHmRM3kSK70nTFEl9/hVIXtrVqgH6AKgwMWbuhshy8CSK7hh5KrNAI49iiUwyuK6hSVtjtJtG7wSip9uHd/hAvUtbJtF9lDb/J6AgswwNLxXO3f88FafrXiIbAhz3fj6bBg5tZih3L9D6L8YGGKSk7Np/cRCED+So5tkqVLIhXUaSa8dMu2OZgm+Y/gQIMyULWiIJ3hiUaWDWhhrDohDxZTv6pBJkfLe5dMZKAcraJmGYpKp/IVzyWc9w/vkUNx9/dfcAnyBvcfGBiYGtMkq0WRba5g/3fpLn35vy25DsYyPJUHC8jXKTE35Q+H20TUf+GlmDLfML10StMKLZirgwucsisrCUi6PqKI5UrGwyMJaQ/WPwkwa783rHygvSt4Mg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA6073334D01F048892C110321F66371@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2058a81-0896-4148-9152-08d86aaf5a64
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:54:24.0267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32XnAjdTIiGhvFoNdtTe4PVqNMHJCEzsBQmGWSXR6y5U7VYRZB+j5BQdkSRHPUjXLNH2d6fr/fwbJjfLOxtxQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:48:23PM +0300, Claudiu Manoil wrote:
> This is a methodical transition of the driver from phylib
> to phylink, following the guidelines from sfp-phylink.rst.
> The MAC register configurations based on interface mode
> were moved from the probing path to the mac_config() hook.
> MAC enable and disable commands (enabling Rx and Tx paths
> at MAC level) were also extracted and assigned to their
> corresponding phylink hooks.
> As part of the migration to phylink, the serdes configuration
> from the driver was offloaded to the PCS_LYNX module,
> introduced in commit 0da4c3d393e4 ("net: phy: add Lynx PCS module"),
> the PCS_LYNX module being a mandatory component required to
> make the enetc driver work with phylink.
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.cionei@nxp.com>

