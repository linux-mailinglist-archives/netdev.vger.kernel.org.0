Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDC01FA639
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 04:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFPCDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 22:03:31 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:65251
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbgFPCDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 22:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxHUumNzPTZcguSN+ouBSa+3a9/sELAlCBy9729C7ZXNQEI43XixAqyEz0FATaK/HE7KCzBnx8YWwjlD8QV6ic+leTOQQu3z0jh9Ez+V6Joz3J+LpeOs0ejNBAXuB0X8e0/0i4TgLycO4VL+o57TkEwpVnxeZ89Ci4lR7MzpmMuFvASkDT5sMwRWpQjqgTeypFBt8noDlEBOzmUvyIvG+sCOYB2yS1gZl81FKm+5IOlbhYzcRQsQKDrlLJpWr6NexeDZVroHQMk0RzpOZYEHypMDtWeRx5HQCw21w6b/ncyzTEhxc7J4Gge/QqAaq6nGe/yHwpOlv5iFdVNnK3EPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBrtIwJk9xX/rlXkt51Keq//76WwkjphXVdEqtjjOPo=;
 b=EHq/MyMz3HeBFYlf71un1K17yqY9Qz1xGHIvR5Kqw8UAkvdVaxpiXFLovEu0A72w5Abdz5+oki6ZS/8StbKzdgjbbrk0gn/IJardxQ+z1pkiiqL7nHkdcpYgjfWmJ0b+KdHMtuDLVtcjlWsbQqpU6AJGu1z8Mt4nvP3QPGmMGQT7qVRv7OtCdHLFSOUbx+pL+0lCccYeCIfqUO/y/wIku/tUpj0kA+2aBKJRmUfn2ST5cAxHWmn8cD4G5hVaw2cTMq/anuTF/12yFaN0jGTfK5QoOimCIoa/b5shl0T+4ZUrVJvGYcT0h92zC0i3eGi/xT9fSc6SleC5g1oixhWWUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBrtIwJk9xX/rlXkt51Keq//76WwkjphXVdEqtjjOPo=;
 b=na7Wx0MBk+l6o3qgffFbR16MlkDVrhGneRbQczM4QqoempNZXE8A0k+mHOb78ULZkpsg87U0ysPD6tGu0MhpTELMPenSgjIGH7Z7EmZQFX7ZKzQK6b+2xn3O4lfX2VETy5B310Qfy/Gt/oC8htr/lJmEppvoIfcmrv9o7Mg3Tqc=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3430.eurprd04.prod.outlook.com
 (2603:10a6:209:8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Tue, 16 Jun
 2020 02:03:26 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 02:03:26 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "navid.emamdoost@gmail.com" <navid.emamdoost@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "emamd001@umn.edu" <emamd001@umn.edu>,
        "wu000273@umn.edu" <wu000273@umn.edu>,
        "kjlu@umn.edu" <kjlu@umn.edu>,
        "mccamant@cs.umn.edu" <mccamant@cs.umn.edu>
Subject: RE: [EXT] Re: [PATCH] net: fec: fix ref count leaking when
 pm_runtime_get_sync fails
Thread-Topic: [EXT] Re: [PATCH] net: fec: fix ref count leaking when
 pm_runtime_get_sync fails
Thread-Index: AQHWQ1V3+vVzwdRR0UC91oL2FbKQiKjafRmA
Date:   Tue, 16 Jun 2020 02:03:25 +0000
Message-ID: <AM6PR0402MB3607327188F1F9178A7E5BFBFF9D0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200614053801.94112-1-navid.emamdoost@gmail.com>
 <20200615.134216.1492983787088475104.davem@davemloft.net>
In-Reply-To: <20200615.134216.1492983787088475104.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d597b26-cc42-4139-45f3-08d8119974da
x-ms-traffictypediagnostic: AM6PR0402MB3430:
x-microsoft-antispam-prvs: <AM6PR0402MB3430FAF97336F2A21971377EFF9D0@AM6PR0402MB3430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e9vva4c7Ir5IcnmwKujfTtTRvqhxbq/jYLqroQuAvMRzZbNJkyuLy3/J+xZb2OS/KYKMgtB52DyozN9bGGCgoRz9xmaUPFiedX/mlJRxwrjWVlOTUnKOgdGnLrMFJ8IsDtPjQ+baj6WSaP7J+WVudvNvXjZJ+J5aTJ7e5As+PzjlM2/SzYrXIO2xDhKVK3RArroa5T5wXTRLZEMi/26vwxM3GQ1V0ns6ZeVT1RAeAnUnOfOBXrRGJTc2qIUCNXBKYDDMUwiVrRHgRP4o91RhMYBr9jMINNZ1pGOq6avAzGh8zbRHfsLbQ312qHN9sbLkiYoAe6S9sl3N0281CPAowAJiOaisq6rBN0hs05SXKKqLMzq0DgwSlNEoCmgCrn2S7XkN39zGLzah0709g1Iwuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(54906003)(4744005)(7696005)(110136005)(71200400001)(316002)(5660300002)(52536014)(33656002)(186003)(66446008)(66556008)(76116006)(64756008)(4326008)(8676002)(966005)(8936002)(9686003)(83380400001)(66946007)(26005)(478600001)(6506007)(86362001)(66476007)(2906002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /9aMgB629G4OSIKiaviNmTe2fGcSW9bepLl8C5WRZj/0/DQ5Ce/PysnvCogFPBUkRQ7OE5ENcSElzjQqN+OL94r07/eWv0oFMHY4z7HVqM4fGIGX3jghO+xS9fm9gE02oJp6wn1ZJjA/T7rRBCvvcrgzkSRSOSGx6m6bm7g6yZ/7rVE1G27WdvtIKrG9i1NYprGwhkZhkmvABSD/nn/C6+Tfbfo9BIacisqzbbDTMjcogyo1+yj6GhEmDj/eJd10WaEiHB6PukvVqywdAAVfd7jvwhp0wCw7uzUYztkm/NW3AcOgQAaKHVgmxKPaI9IZw3HL387wGYf30DZ6BdoODyTwbTewgPj4+YH09Ov1Te1PAXHpIfbugxDGxtFtJJsctiLCXu/1Mv39Z9qu7Dp+DVOIPoXFwoKF6dD3ZLBYhsONjVqusiVgVhdU7mNqHEfVBHTN4I8hYsJRH5oQzddDHw5fdDtNtmWR2Ujilp4JsiE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d597b26-cc42-4139-45f3-08d8119974da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 02:03:26.0002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MFTm/1ua0Y7jEM5qvv4gk+2FWGqpwx6sYl9XUu2ehhJeRJ4Xm6ZMSHh4pJsrLuiIVHMnrocENEU0YRGmWKR2qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Tuesday, June 16, 2020 4:42 =
AM
> From: Navid Emamdoost <navid.emamdoost@gmail.com>
> Date: Sun, 14 Jun 2020 00:38:01 -0500
>=20
> > in fec_enet_mdio_read, fec_enet_mdio_write, fec_enet_get_regs,
> > fec_enet_open and fec_drv_remove, pm_runtime_get_sync is called which
> > increments the counter even in case of failure, leading to incorrect
> > ref count. In case of failure, decrement the ref count before returning=
.
> >
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
>=20
> This does not apply to the net tree.

Wolfram Sang wonder if such de-reference can be better handled by pm runtim=
e core code.
https://lkml.org/lkml/2020/6/14/76


