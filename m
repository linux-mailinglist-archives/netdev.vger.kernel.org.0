Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F971215230
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 07:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgGFFa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 01:30:28 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:17796
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728710AbgGFFa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 01:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+jcQet6eowQQ9tmNOqlidDdSyzvEITPHqoyyyYLOyVD/LZgVjfeecQA7knhGicpwmVPLAznEybkRrTCuY5aNgWjnWPcdD+4y159xVHGPT+lgsSTmL9VurqfZBdyqsJ+kE2dytgOuTa1f3flE5sMy0zbm9lyPhwXphJwanQu7gmEDS2L8yMzJOp51BJnO28jgCxVbgMCfXqwfdGuKO3AqntpnbsdUR1YK7pIzmUz6CdYd3QLsxRMgXzmiGzJMPhDr1wdDJpOaPnLUNVp34yU8PJeX2Hc6tHyFFWHTVLYYKWX05a3DxMUjRwf5P6hoCE+gfOae+0H0vmsNR5zufyFdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPwzg/o4ddIpO3h+b3ivGaKRz20ZwY0TbtZ2rVMiV3k=;
 b=YvP6kMNdTdLpw/ZB+3aKEoyI+skEVdtp1NcHsP0RjhTEzL7zrDJ0eVDXGBp771SqliOjwM6KErW5SXugE35wiGN4Er4JysVQlky3Xu4a3CEq67m/YX68RC5jSnPeWMZsBScEXnXUpV30eGA+yn6XpCQan3CLEtrlEKXeSZV1/B0rB7FOb8anK8NxoEB8W/BmDDJPDmBggn75TNzmSiMMCEikCoRsgcEIJ7bt+AnUqatzv3UPs6YoeQEHIZxaNsGRfl3kGkzN6WE24+oU9Tqk82A3llGO+ViEFon/5PHv4CU9XE3c/KKsOW9AD6ytcNab877+7fX6/keRE0FI+MGjwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPwzg/o4ddIpO3h+b3ivGaKRz20ZwY0TbtZ2rVMiV3k=;
 b=aJ4fbwn0IL1X7toMugJGvn0445XU+NYMIrfCb6pvkzE7guVjb1KQYOel7oibI/14FL6ZNsXzF5aaXvHY9WxgZJM8Q5wnrKnFg9YcW3yI1HNu2FbonY0NuW5Sraf6NeXvFv2BS9XeYE+JLeo8fnBLK9dvqXyldXQiId0GcZaUCLg=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3829.eurprd04.prod.outlook.com
 (2603:10a6:209:1b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Mon, 6 Jul
 2020 05:30:22 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 05:30:22 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
CC:     Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Topic: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Index: AQHWUMBIY0/PmQIJzUKZXhlXPuzWDKj3d74AgAGaMECAABAPAIAA5FDQ
Date:   Mon, 6 Jul 2020 05:30:22 +0000
Message-ID: <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200702175352.19223-1-TheSven73@gmail.com>
 <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
 <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com>
In-Reply-To: <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51b0b5be-97ed-4851-6b2d-08d8216dae15
x-ms-traffictypediagnostic: AM6PR0402MB3829:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB38290DC8D0EDB407387BDC75FF690@AM6PR0402MB3829.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eu55lN1tOW75CEGs7Qa4oHaiCJW5V2rtQy+3rPEqwrfhNBPF/VAtTBXCpEAwNxX+/g6xLoy4T6tdJcAKswUONNhnvfNDuO7WQumEi+aKxA3tr/YOp3Og5WK3XPx89+Tvhtoqnm01gF8w7c8BJ3/8K5juC9Io3TukPh4BAmluef8HHmxMmBpJOom4wVwTnkDf4KQ2OmyZIuWBwbnyAVb0uOatwILkkRKEN5pd4Zi/7jiYuIXl9RGvjvJ3JQ5ilgQanrchD6E1KeusiHn/8RMRSY/6l2qIxtPvGvYPF0dtwpWWVPuZ5t4++CYIKcbMT9zlWwjZVVwkmcVFmbJK/6p+AZv68Ew4T/UxoSF+AWISHsIp6v9ZQ/mBQgpH908PsjLz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(76116006)(5660300002)(9686003)(26005)(66946007)(83380400001)(6506007)(7696005)(66556008)(54906003)(186003)(316002)(6916009)(478600001)(86362001)(64756008)(66446008)(66476007)(33656002)(52536014)(55016002)(4744005)(8936002)(8676002)(4326008)(2906002)(71200400001)(7416002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0g8fhLUplEe5Slb7QBygZR2vTIq3tq6VZqqYnqwKjADMT0tDVt4Uca4Q9xmYGUwkuFom/DPtcRXXO7Xiqzv3zrSBxkw+w0kiuFuMBF8AVrPgkq1Th+SVixNNAFBSYcm5XKr3TfjcEuzk227EMshk4nfuqgQPjGVOmIK1ZeD/BhugHZZB20B5Fs94VmrrhAkj5twk11ws1pR8KZBuquN/7orJciJNOc+18qcfNDRwTpbcXaIBr8aI4O6ev2h2TDs8ZAWHCvcBioXgi19aYJtBtu61zZMjXlDwmjZtlOo0dasppIRWDqiPPNWjG4taWUnsy14nlTxNIpgHNqdcKrDP4c/r7ZdlhYvACmgg9Hvp1a3X8MPsN8WADE/faWTeoxqxAMJk8j9lkWbgvUKwn6gkYonITFeZ6rqQHxzXzj9WD63w8/8DSCBswQn3CUMn6ToZSJm3TbhQkrOi4DxLjUk/BQWHNWmFGjvqXvPxD6quADg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b0b5be-97ed-4851-6b2d-08d8216dae15
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 05:30:22.8196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t6+eF0YiHoiTjk2Ny30p7pIK0mZtRJ0IMK0oQV33jmfJMIECSOURDu2fDHg4WofQLIAxAtrQCr5RmDGqtxbP1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+IFNlbnQ6IFN1bmRh
eSwgSnVseSA1LCAyMDIwIDExOjM0IFBNDQo+IA0KPiAgIGV4dCBwaHktLS0tLS0tLS18IFwNCj4g
ICAgICAgICAgICAgICAgICAgfCAgfA0KPiAgIGVuZXRfcmVmLW8tLS0tLS18TSB8LS0tLXBhZC0t
LS0tLXwgXA0KPiAgICAgICAgICAgIHwgICAgICB8Xy8gICAgICAgICAgICAgIHwgIHwNCj4gICAg
ICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICB8TSB8LS0tLW1hY19ndHgNCj4gICAgICAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICB8ICB8DQo+ICAgICAgICAgICAgby0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tfF8vDQo+IA0KPiANCj4gSG93IGRvIHdlIHRlbGwgdGhlIGNsb2NrIGZy
YW1ld29yayB0aGF0IGNsa19wYWQgaGFzIGEgbXV4IHRoYXQgY2FuIGJlDQo+IGNvbm5lY3RlZCB0
byBfYW55XyBleHRlcm5hbCBjbG9jaz8gYW5kIGFsc28gZW5ldF9yZWY/DQoNClRoZSBjbG9jayBk
ZXBlbmRzIG9uIGJvYXJkIGRlc2lnbiwgSFcgcmVmZXIgZ3VpZGUgY2FuIGRlc2NyaWJlIHRoZSBj
bGsNCnVzYWdlIGluIGRldGFpbCBhbmQgY3VzdG9tZXIgc2VsZWN0IG9uZSBjbGsgcGF0aCBhcyB0
aGVpciBib2FyZCBkZXNpZ24uDQoNClRvIG1ha2UgdGhpbmcgc2ltcGxlLCB3ZSBjYW4ganVzdCBj
b250cm9sIHRoZSBzZWNvbmQgIk0iIHRoYXQgaXMgY29udHJvbGxlZA0KYnkgZ3ByIGJpdC4NCg0K
