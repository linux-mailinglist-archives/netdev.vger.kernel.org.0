Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BDE2167D4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgGGHx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:53:58 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:36122
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgGGHx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 03:53:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4pyivyty2rp801+noXgj2CAz2fZz2Xxgk48VlE1NIxpM2ye2YY6upX1z3xQdzgMqnEeq1FUReQAvAjyW0D86VOLbajR53bV8z8wm5F3Q0sq2oj20mBH+9nWAJAI+JRs2NzuQeUGENEmrmcMfFnKKIsm81eSZTQIWEG/qllGBTgLvlFcsIj/oSJ32763JXOjODr5Jqs53jArnb/UK/XzusAPHngQB8feuZvO8dCjjMVx2FqLT2NFXkvD49R6ehP/Uhg7y9tp5IrlW8I+jpahlpd+EV1FGNFbhNf+pJWm7LUxHfYwtjDN6+1ITacfJ9kgoKQMKK3uVah+SfivFMy5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHweeRCmoOcJB+WjGk8RrK5FzD7DSuXAgSjbuxXpm0A=;
 b=PZ99a6QxSl7y2P+6PRnyG0jJwDID9+u88Us3twx+/hs/atcIYIfUGF2FC6NPQejbmTHu/aiv16hwYK7MjXLZ4taHxsDaGJqQ7/YUxxSgICPvWPaX5HDzLUPiKqPrGWlModw4W6vRXeXitV2LuQAqd2mRc5LxUqaJSYL32sQ0Be2D0GXAGt+iLzG7NFUKW2S0FX46ANByCrZnm64OnSqhPH4wEjBqKb3sR4wDCyEgily/FVgcHww9+VYJk9eYbrVwjmQHUvWVJrbxDajBBHxvskgmT2CJTPR6OITtsBTpqXtsZ/QL17tYxKSrrVN8PDU7F814fPfGqzbdjM1ixeKDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHweeRCmoOcJB+WjGk8RrK5FzD7DSuXAgSjbuxXpm0A=;
 b=d5jXKY0rbeGWuJItwZIXkQMw/IRxef6KYszlA4lk7LhoumE8T33YrnB019PSmMd3CNz5XEs6nnTbqeNa7/onVPKfwi+3XVSxmnLOLeykQNkAgKfqDmC/4x39NqsCtc0ZlKATX6EUPGE06DZxn2ZmdWwIFd/3W/vh26iJmwnas7U=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 7 Jul
 2020 07:53:54 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987%3]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 07:53:54 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v4 2/3] net: enetc: Initialize SerDes for SGMII
 and USXGMII protocols
Thread-Topic: [PATCH net-next v4 2/3] net: enetc: Initialize SerDes for SGMII
 and USXGMII protocols
Thread-Index: AQHWU+E9FWRJOkbrqUWzPMt++F8GBqj7vtLw
Date:   Tue, 7 Jul 2020 07:53:54 +0000
Message-ID: <AM0PR04MB67543C11443FC2AD56E9095696660@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20200706220255.14738-1-michael@walle.cc>
 <20200706220255.14738-3-michael@walle.cc>
In-Reply-To: <20200706220255.14738-3-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e04250a-233e-4fa8-c38c-08d8224ae592
x-ms-traffictypediagnostic: AM0PR04MB6324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6324612021AF021E6ED18C7F96660@AM0PR04MB6324.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YzcfyAxHs9mpbOxSrkAI4udpkKbdgFgiCmBlINtW0Djx983t8VWM0DRoyXMNA3ewwKgstuPnUiAdhlPWxOHZHrO+l/Gh13KL1L/ZAW0JDran7Fq6w2Ge+J/WlkwfWi+opmmybSpiOtkgCHmySCYEk27P6iV44iX7y1DsIMzdBsEvxtS1wmwaFUdkIQKLeqGByaOzL6xOdVKfjE9sY8V7U3e4vWvVdeVdeWdaog/RJvN5Rte0tjUbNM+AaCRQ/Mc2JbHCv6hvDWa3qdkUnmZSZri5dac7tmup81vYVGxk+y3vJn/lonvF2GmY3drvbJ5V7QlgNaeAi7mr3Zt3WadVtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(66446008)(64756008)(478600001)(26005)(6506007)(66946007)(66556008)(66476007)(4326008)(186003)(83380400001)(2906002)(110136005)(54906003)(9686003)(316002)(55016002)(76116006)(44832011)(4744005)(86362001)(5660300002)(8936002)(8676002)(52536014)(33656002)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +S+BeObyH/rhM+PDo6sIjpaGpXeXi3UaGR5kaJGHMOF+1nERiWNCZ0iE+2/xflF5Qj0saiLlZ0mjt7+/j2FoBxl3kKIeInyQqVi8YdfDODVZYwizhMpX4Ff4qn9Kvwjh0WULiTvyM1m4JVJp5xNaAmsYOSb+0b+TO5tRh/HCw1afdo0X/eNEi6+gTN6JcX88FKiivGIVJinIXi4PM+dZicYI6aX4hCh4D367TZmY53lqITjumOndiUD3b4VIO0mBAozMdzQybKJ266YUA04IZiSz/93K/ZVF3N7UFtwsLMhnmlWoCZnuRaxPB0wFQe4VpLErDT3ZtDNJc0CObe9/8Q8bliokon9wmG1KxPJ7DS3rr4cdB0YMEjgsZDh+LhbwUM6HavYI8oQOWAjQ5rRZhvnPkDudvgmu+fe6why30NA14MWeF027B8iTt1wDVwV823v8VKHNsZAXs/x9mRfYncpI79HMijzPQeSEhG9sgE8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e04250a-233e-4fa8-c38c-08d8224ae592
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 07:53:54.6710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NT7iFQweBhF4qNW1Zj9zUcatCCsxI/BM9VqoCGB4X/FPpgwbIPXZY0nB+lNjYTgIIltgoVEi1xP1hTQ+DCaYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Michael Walle <michael@walle.cc>
>Sent: Tuesday, July 7, 2020 1:03 AM
[...]
>Subject: [PATCH net-next v4 2/3] net: enetc: Initialize SerDes for SGMII a=
nd
>USXGMII protocols
>
>ENETC has ethernet MACs capable of SGMII, 2500BaseX and USXGMII. But in
>order to use these protocols some SerDes configurations need to be
>performed. The SerDes is configurable via an internal PCS PHY which is
>connected to an internal MDIO bus at address 0.
>
>This patch basically removes the dependency on bootloader regarding
>SerDes initialization.
>
>Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
