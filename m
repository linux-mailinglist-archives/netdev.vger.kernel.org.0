Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE0028E1C5
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgJNN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:58:15 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:15872
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388444AbgJNN6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:58:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHc7VUtdMgYPpy7U9ZCegiEOvdhfVqgcVkmHlFYCQ9ag4s3egV98ANAXc5hmMe+CKCdP3Kd2L36m/zHg0Sp9kDPblmAFnMCrjjsFYz+cG6i9qJeUaXp2CaezKCDvbUxglRq5vjpzM2spOK+MMsC2O8UHDiRpi36SuLJfoynZneVpKtQiH7EV3IrzOeIWjQB80OSAtd6nGySmW0fTxDZAQ51RVjugH3QXhqOLo5d6kGPcl42SMYpiKTwu8yZDLe1iwAjMaIBRGRRxBXkvUwokd0fwiAXyRfHO2rXxXbKNrVS5yBUrN/3K7OvYKnP6c9HOElBAzWpjZI4ve7mqYmr/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9210rEELRwFN/9WBPmniDncCXi+mYulGl75x+B4tuko=;
 b=lLL3Rj5VDaJqUIHs9UokiN0tUmGY8oYEsQ3/d/A421wDsZNK7BXqeufSZVSipNDuFHTqscBHgEAkBxla5FPJueK9i0sSHvCvVBkEIBAQ49z/gYfF40GcYn4cP0SfiIptgYuvQFOOS35ZhnHzafRLW5D+uusPeaU9mmtDwxQ9zs5s7wZTt7cDH/dmBuOFEZVOYWeoI9GRScpCIgKha+7uFa584uhx/TBCf7KAMXoYxQ0mMt9LOCZCfQ4k0JuLTJy3iDK9k3nj/WbNBIZMTWijVTw+YURXJW9K6LEKvqqF0iz/b+7YNw3aaQnei2902Jksk2wCSp5BfMczvhwMI7cMKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9210rEELRwFN/9WBPmniDncCXi+mYulGl75x+B4tuko=;
 b=AHQiEiUlIwJUY5D3sNmddSPDl7GVURT+AqHD8DqS2U66OA4fqMUGAbG2ukbT8He1v71LURQRZqlOdDoOPeI1sVwcjSaipheM8bGKJBx+c+cxbXb/SgBuR4kRMgnEZ1Xhylo9qe0W1BzRg7MXN7E0Bshx1lZ28oaAfXpaEsFkXn8=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 14 Oct
 2020 13:58:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Wed, 14 Oct 2020
 13:58:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/1] net: dsa: seville: the packet buffer is 2
 megabits, not megabytes
Thread-Topic: [PATCH v2 1/1] net: dsa: seville: the packet buffer is 2
 megabits, not megabytes
Thread-Index: AQHWoi3Ko2m6fEVxK0KPUmFZzJEPtKmXH7sA
Date:   Wed, 14 Oct 2020 13:58:09 +0000
Message-ID: <20201014135808.xrwwgioex4we6cmt@skbuf>
References: <20201014132743.277619-1-fido_max@inbox.ru>
In-Reply-To: <20201014132743.277619-1-fido_max@inbox.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: inbox.ru; dkim=none (message not signed)
 header.d=none;inbox.ru; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c4c9266-4d86-4dfe-faee-08d870492f17
x-ms-traffictypediagnostic: VI1PR04MB7119:
x-microsoft-antispam-prvs: <VI1PR04MB7119280D3FC0EFA87889F47DE0050@VI1PR04MB7119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mqE8urAKLFyCHdta1QoBGQdHkpdWaXtbOi9c6J8wdjdeA3nB2x9VkezksO3KzhBTFlimB8FyT2xP+s985fnsZxQHfJc5nJWd/L2eHNPYFIdFEpXuYwGOIA0IdSeB/aVlRKmTRq33UTNafRK67TuvtPRdnHXgDvJ84ADK1ePOU1sVtbFsRx6AlbO/31tHyVmanoEakAY7TQoEqcKB9NVSEPwHIqYeXflBwuYT3XEOy3KwstEWZ2ieESTq0oieAkV3rTu+Aigj0NKd4B0GO2vat14rJV4YasXttbr5c0klHwk/Q6qc8qcN9mXuKneyESGq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(346002)(366004)(136003)(39860400002)(86362001)(2906002)(4326008)(110136005)(8676002)(4744005)(54906003)(8936002)(1076003)(6506007)(44832011)(186003)(26005)(6486002)(71200400001)(33716001)(76116006)(6512007)(478600001)(9686003)(66446008)(5660300002)(66556008)(66946007)(66476007)(91956017)(316002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TRJgxIvtEReCRmM3gB2hOJVbdlgKtkv7xzb8S3kFlQ2AoIriMV/hWYrjEv5ephTUCgENQMHQywSYebOtM3UbmY/WnKXg+ZnpBQwdvRw1iKFCqC8HtEe9iZb/TfaxYzeTzOBuraHfZp+9ZZdR4bY+sSpEpODJ6wX0dzR/+RYPwEMsnL6AaNFIhD0fOx2ZpDv5+t6ogz2Hj0HYOUxz5tXtPkZ6MBD74sDkbdM19fokmqVQ+C7kDtVulSaSyQu287s6Zm8znboc/SKIUAAG3gQb+jFUfRc1h5vbwzbBnLSzbGxRVihL8OAMV9b+kPJZOywj0HAndoz4Wxx6gkmkdRnJXQKlb4+sI1zYF6FM4K+RYj0MV23AMeSiBUjzWwG2MlYz96vZJ8dIE7yFtTcw9vjYQR/M8zpFV+0hHDCfyUVZzurc0EIoZrE67Y1rGLtjksLmdaLuIVMr6CwEwEMgLF0DSj6tWDkiWK66N2dnCpeVzNxT0uUsyxcgk+xzZpVqQMPlQzQUygqfpN2jwddC/7a4WB9I6xnQQxe7O7bnBrjgxkUIb42IdohzlnAk/C1StRSeFuGABGA9BcMwTzuTvWTl9hRAWjy6VGtcp92SqOXBCkkRe8/bn1afC+yxHYacc7zqVa4mksbjyrVABvpBxzTv4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6511DFA10A6FC94E9E6EF20BA8DCDA6F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4c9266-4d86-4dfe-faee-08d870492f17
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 13:58:09.6890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzHI9Run1Hhu769iH2i4EAoDoBOxiWJOhwmd86R0UbLcLnUmJijW0nSD9l0GBDRgSI8cJyGCRVe7BD7PwfgRPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 04:27:43PM +0300, Maxim Kochetkov wrote:
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
> 2 megabits is (2048 / 8) * 1024 =3D 256 * 1024.
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue sys=
tem")
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This should go to "net".=
