Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9C39ECC5
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFHDLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:11:21 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:20227
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230351AbhFHDLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:11:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCC4YCG6W03ho1IJv3egbcX8S4VTZUIJBINNH4EIyvcfkz8QmWLBbtub6F+heKQz6lXA+yS0OdgPjyAQ+gxNW6+9RjF/Ov4lpQrL0BrTUUTEnDKybGDbYBIG+mtOh8A/7bv4hagyIm7yJbMakGumf78/etjeKWT29bDaIp/IhXPkgDH7mrrTDPHrgNPIFFXXmgXAll6+eCEyQ5M2Vja9cJXWgMRUTVinsfjvYkxjW/lJSu7hawDrf/KKSDz8NLRNE5qM2zK0xG5Huw1oquwrwIkCcVO4XSW0CSSTczw3LOxUnRWhVaYZbmixBSGtRlKJ6eN79SKytZlKyUozC5m0+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0ADrBefv/2tqiPmh5YTPJB9Ek5YtOIHjFo/5sg3aM8=;
 b=fBAmwp3a2Ts7pwbE1NR+JL72DTzwsddhtaAvUlaaFsnmvC0fpjQJTgAl9M6ZrwoJ5c2gXX2o5WORWrq0+jLR3QZtY+8NoO7pMsBlB9RUgQtD9MkgGn6DI1SrHZxD95qlTEOGuWkobEBHpXM0/Glad94CcxRm4pschg1XzTpw4w/6yMcz/eykMl/j0AnQVFUekJGA8j3oDSrOBEVTVHy6lLneZS7XMXvYP74Pb4Y5Sb8/ah9vxTd1ztRUIgzvOa5GtB1smtoP+GU3Qr+9fqlprvhgVIQnvZ87+0oLd6nRH8EyWGdjGF1SrU47TObygdQk5YkDWrCTdoKK11NTw1MbIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0ADrBefv/2tqiPmh5YTPJB9Ek5YtOIHjFo/5sg3aM8=;
 b=dW53U1cOuFlep8f1lux6A+oYP3d1rL+JCytqVQMYS57TQNhO0kItbCzW+CzghGqT3DE9qeMGF26GgaJjYREMbkJISh2bBdbLjXMIDwktNs15LRuOLkm1oJFFMh50rUSuWd6/ov6KJkFbTdH3zEwx+Oi3c3dHluEwbinDHd1GqLU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:09:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:09:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 0/4] net: phy: add dt property for realtek phy
Thread-Topic: [PATCH V2 net-next 0/4] net: phy: add dt property for realtek
 phy
Thread-Index: AQHXXBKTte8wXkM9pkSUCkO0aEHdiasJbnFw
Date:   Tue, 8 Jun 2021 03:09:17 +0000
Message-ID: <DB8PR04MB6795910502B23313565F909CE6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c645f305-5d61-4773-5609-08d92a2acd83
x-ms-traffictypediagnostic: DBBPR04MB6139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB613942926C8CF6F54CD6F35FE6379@DBBPR04MB6139.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ycbDCXyEGf8iNk6Bd2/boJ4alLZoiJetwVr9Uzd+DVcoAdnbhSOwxXXAMnS1qJP5/+j5H8KOThqy9YhclnfK6C05B5iK6TuD9J9gpeD/3QgpHa0GgVBEsDcnsy+31OOEHh+YShxiASPqa4dXXrSApdnakhT+eLG73c2SyQfsuig1iA9MKWXycWqm7nqJ2XywsmbvKxD9a8Gu/GbodTLzXsInnBrxvrRZPc75nNTDDxugYXEE3Wpjats69jdxQaRyQguxOdCdCSBAAwQU1LTArUDqs+rJowcqwmlVQl60cFxVUWti4NUh+b/ivXI6yISI4axpS3YGy6vGWuVzqx5fFaLXRN5NdOBelgGpZ/41qNSXeVxpHZ82uFUM0TCSBhZ/wKm1nrfXkkM9zD2RQOWHAKkwdWr4VgsVhkrQOprHVP8GmMWg+o0zS820sUjZdVm2AwIVeTlCyHw/xDVU8ib/+rQ1xVJnadTHsxeN7iRNWYzy4E12QO+z4E9oEmQO06e5WjOjRu+y6USeMbWi2VEqUtRfwE9m8AweRwVMSk6sQhP+vJOMIQDwvETDh4TcRvgoBaUengvlF/kdzN5Byh/dQRQeETEIabevlL/AF/N05uI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(186003)(33656002)(7416002)(26005)(316002)(110136005)(2906002)(4326008)(53546011)(478600001)(7696005)(52536014)(83380400001)(64756008)(66946007)(38100700002)(55016002)(66446008)(66476007)(66556008)(71200400001)(8676002)(5660300002)(122000001)(6506007)(86362001)(76116006)(9686003)(8936002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?ZWxsOFp6d2NReUlXOTVGOXdqTHA5aEw4Um1HakZCMDNvQnl2NEoxU3VSNmxh?=
 =?gb2312?B?dkdNNm9QNmE4TVJWS3QwRUxocVplQ2ozLzVQQXdsQ25jd2RLZ0d6bWVYdzdS?=
 =?gb2312?B?aXZwR045bDYwcDhrb1lFSnFFQlY0S2R1YkdYdytlVG4wU0RqNy9Xa1AyZ3NC?=
 =?gb2312?B?QTBiQkpFU3BMcENmS2hvZEU5by9hc3lhK1EzNlNURXZpMzVGWVhyYmZWeVRW?=
 =?gb2312?B?OFZtc3ZnWUtHdW1aSjBkUE1yMWVmUTJVVlNCVzdQVTNJbVBCWTNITisxeEVC?=
 =?gb2312?B?aTk4c1dqKy9GNHdHaThDR2Y4dlRweVRHOVM2dVVSa29YTXRmZWxDT3lWRnpQ?=
 =?gb2312?B?T0NHYXNrOXNiLzhMVExZcG1kc3lRMzdNM2ttNU9FMTNCdHBiUytZVkYzZkRW?=
 =?gb2312?B?RHUwUHhvVmZLMUthRXRQMzV5RUNENUIvWEFSRHZVUGRMNFVxZUY0RXVDMlBP?=
 =?gb2312?B?eUY5Ry9lYVVHZlljaDc0RWIzMUF2THF6cjZCRlpsanZFdjluOGp0ZkV3NWZQ?=
 =?gb2312?B?RmxTZW5lNkE0ZzlKR3hzT2RSdmZsZSt0OUdMOEo3R0xzZUMrUjBCT2NpQ1lV?=
 =?gb2312?B?VUtHMHRUMzlLNGlhSno0S0lnMjByVEZYVXV4akI0aklXRHBGTTV1OVZyVERW?=
 =?gb2312?B?K2Z1SHJzMklNM3BQeTFWZ1FlYnNJMTRwMHQ0d0tiSngyUjZXZk4xaVljQlUw?=
 =?gb2312?B?bTFYcUZURWN2bmo4Z1A5NjRic0h3Zk4wOVlsdjdjK216dDlMK1lZYnRhdXhu?=
 =?gb2312?B?Y2c1eEFKUTVYNCt6Q3ZRSmk2Qm52c0hkV05xcmJ1aU9lcnhNeU55ZStmQmVG?=
 =?gb2312?B?QURhazE3QUtmRkNMdVRtN3NwNGkwTWl4QWN0V3RTUHhlK0tFU2E1emR6MStt?=
 =?gb2312?B?Sks5RTBXajMzVDJxOXNaVEpVOGtTcmVuR1NrZjZ6RHhsdDM4azFCRDkzTnFJ?=
 =?gb2312?B?a011YVEvUGNPbnE3VHlhaGtHLzFFM1Z1MUh5RWVrRGFueUhqbG9NZHNxRS8v?=
 =?gb2312?B?dTk0bGxHQ2NnL2RhT3VZeHgzMGl0K0trS1VOY3FxVTRzNUoyQ3pqVmFJVmtu?=
 =?gb2312?B?NW04czg0OUZ5ckhTNmVCZUxnaEJQbytoVlNIbGdMeEVHdHBrTm1JSVRjNXNC?=
 =?gb2312?B?eDZ1eUlrNXpVbUt4cGdkdWF2V0E0Nm9STFJQMEZDaDhEWi9qWUliWjVTYjd5?=
 =?gb2312?B?dGhqeG1BZlRYcmdVUm5zVFVhdGV0bHVEdklCRzFNSDdPM01ZQmphWlh0bmEy?=
 =?gb2312?B?QUxvcmtwM2luM0k2amY5bHpsUTYrSDh0TE9Ub2s1NktzVlhhQkc0amsyTGFp?=
 =?gb2312?B?Ry9rL0ZQa1pYUVNaalJxeDNFakRKbzlNcitrU3paZytod2ZDazdDU0N4Qy9x?=
 =?gb2312?B?VUUxZFpFT1l2ejE3Y3ZCaE9iSVNobVNqeklCeGhQek5Ka0pFd1NJYmR5Y0Rz?=
 =?gb2312?B?QnJRbG9CN2FkSDYvczFrcjhxbFE1MnFaeVpzWmU4cUE0Si83VWFqeUpQWU5h?=
 =?gb2312?B?VnRQNGgvUXNXbGFHeUNPVXRBVDZNQW9ZQzIwTENTSWlTWi9mZmVlbUFndUtR?=
 =?gb2312?B?VHNDZ1RnSGEzWUNzWFNnTU1ZRFJCT2RlS0JtWGdQMk1DdEh4eHQ1SWN3MUxQ?=
 =?gb2312?B?UXZ2SWw1K25nWnpkR3dkVk1HOWZFdFV5Q2Y1ZGlHV1pDRkRhUEF1V243RWFq?=
 =?gb2312?B?UjVTT2NHbXQwUlpIOUNCYWxJNnpPeGhOcnpRWWo4dWQySkg5c3lNYXYzNVFI?=
 =?gb2312?Q?ayfVaN3WNNl91n2PXc=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c645f305-5d61-4773-5609-08d92a2acd83
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 03:09:17.3062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eKViF4lRUUSPnVCwNXmvAe5Joll3AKFdG7xm4Avq7pGdr+jh98rmg1lf5EEpcFjxuNIqWXYDQcC8/v5iSl8+sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwNCg0KUGxlYXNlIGlnbm9yZSB0aGlzIHBhdGNoIHNldCwgSSB3aWxsIHJlc2VuZCBpdCwg
c2luY2UgSSBmb3VuZCBhIGlzc3VlIGluIHRoZSBjb21taXQgdGl0bGUuIFNvcnJ5Lg0KDQpCZXN0
IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTZW50OiAy
MDIxxOo21MI4yNUgMTE6MDENCj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBhbmRyZXdAbHVubi5jaDsgaGthbGx3ZWl0MUBn
bWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsNCj4gZi5mYWluZWxsaUBnbWFpbC5jb207
IEppc2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbQ0KPiBDYzogZGwtbGludXgtaW14IDxsaW51eC1p
bXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRD
SCBWMiBuZXQtbmV4dCAwLzRdIG5ldDogcGh5OiBhZGQgZHQgcHJvcGVydHkgZm9yIHJlYWx0ZWsg
cGh5DQo+IA0KPiBBZGQgZHQgcHJvcGVydHkgZm9yIHJlYWx0ZWsgcGh5Lg0KPiANCj4gLS0tDQo+
IENoYW5nZUxvZ3M6DQo+IFYxLT5WMjoNCj4gCSogc3RvcmUgdGhlIGRlc2lyZWQgUEhZQ1IxLzIg
cmVnaXN0ZXIgdmFsdWUgaW4gInByaXYiIHJhdGhlciB0aGFuDQo+IAl1c2luZyAicXVpcmtzIiwg
cGVyIFJ1c3NlbGwgS2luZyBzdWdnZXN0aW9uLCBhcyB3ZWxsIGFzIGNhbg0KPiAJY292ZXIgdGhl
IGJvb3Rsb2FkZXIgc2V0dGluZy4NCj4gCSogY2hhbmdlIHRoZSBiZWhhdmlvciBvZiBBTERQUyBt
b2RlLCBkZWZhdWx0IGlzIGRpc2FibGVkLCBhZGQgZHQNCj4gCXByb3BlcnR5IGZvciB1c2VycyB0
byBlbmFibGUgaXQuDQo+IAkqIGZpeCBkdCBiaW5kaW5nIHlhbWwgYnVpbGQgaXNzdWVzLg0KPiAN
Cj4gSm9ha2ltIFpoYW5nICg0KToNCj4gICBkdC1iaW5kaW5nczogbmV0OiBhZGQgZHQgYmluZGlu
ZyBmb3IgcmVhbHRlayBydGw4Mnh4IHBoeQ0KPiAgIG5ldDogcGh5OiByZWFsdGVrOiBhZGQgZHQg
cHJvcGVydHkgdG8gZGlzYWJsZSBDTEtPVVQgY2xvY2sNCj4gICBuZXQ6IHBoeTogcmVhbHRlazog
YWRkIGR0IHByb3BlcnR5IHRvIGRpc2FibGUgQUxEUFMgbW9kZQ0KPiAgIG5ldDogcGh5OiByZWFs
dGVrOiBhZGQgZGVsYXkgdG8gZml4IFJYQyBnZW5lcmF0aW9uIGlzc3VlDQo+IA0KPiAgLi4uL2Jp
bmRpbmdzL25ldC9yZWFsdGVrLHJ0bDgyeHgueWFtbCAgICAgICAgIHwgNDUgKysrKysrKysrKysN
Cj4gIGRyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMgICAgICAgICAgICAgICAgICAgICB8IDc1DQo+
ICsrKysrKysrKysrKysrKysrKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTE2IGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9yZWFsdGVrLHJ0bDgyeHgueWFtbA0KPiANCj4gLS0NCj4g
Mi4xNy4xDQoNCg==
