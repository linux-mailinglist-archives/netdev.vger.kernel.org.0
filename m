Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E107368E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387602AbfGXS2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:28:21 -0400
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:38882
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387457AbfGXS2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 14:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBQBATGZgR9MsGys5wMI30ICiEb9wSLY2ldfaOU3Q04TQcL8Q5llxMzA8rn0NM+JVlhWBx3TKMIV0XkKXqfdJV84kOXC6WaZvCxUzOK+tj7yg24Fszna8TRyM6djkJWtBttmMSwzMvoDzH/IrNuZ4e7e4XWRZcKHGZjbpewdNINWtozvrjLfBw8sl8p3ENb0zrzYSp5P02ueA+J3SkIgTOc+gfCOjepcJn6VzUZJCqCLcHjC+rA1qTaNyxvzS9a4d89wBzeSQeeW68CBS5/VpyF+uzxwZ5Mb/ngzFPiV3j2lQSDcSnaPBQF5ZieMEEHZQENsA18KocLzGIw7h98qUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ml47vXl5Jzb4mvqWGKNPO0NrHzgtAh4hAc0oq7khqRw=;
 b=GzoKtXv6539sosD0kpHybwJrzU92yPpZX6u1yNHledo9D5ToFsq9jEYAS5UTQyZUtnnuKEycz3mtswsXklEhRMicWJMt95mMcBHHNU97d+G6LrLRi9/tl7lGotI8uDohuB4UKGX0dhPy5CAp+vRUmVaAreelnJWtKvxXYPyXvRatprELFhJ5k4sjCHR/QTmSFOu/W/duiFKWSa5mI9ovZoyG01iakxcylEGTWXeVtyC1iORTMmoh2B/iv9cPtTWVRdiVLrvmnYtenUKxhGt+dur/6n2+jjW7FcitvcNZIdUjOqCfKQCHPROcYL9AGkJCdW/eWFE+Qx0doxk81ApxJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ml47vXl5Jzb4mvqWGKNPO0NrHzgtAh4hAc0oq7khqRw=;
 b=jghycSNjyGcHs1IEv/O6DxBqqh5FTIYqrjmr7pkj/KEbzmG7bsCTIgdyXrHdidVBRLQFMAHR6OlmNizOjagbv5HPhaLI53jkets4NGzNHhLJJdUf/qt5bJx6vbqo/dYBA68rfeHFHZBCFF5lt9EO7U5ArQousR4uIHyyl0YCvmU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 18:28:16 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 18:28:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>
Subject: Re: [PATCH net-next 04/11] net: hns3: fix mis-counting IRQ vector
 numbers issue
Thread-Topic: [PATCH net-next 04/11] net: hns3: fix mis-counting IRQ vector
 numbers issue
Thread-Index: AQHVQc72nLGYBxjpckW1H3I719D/4abaF34A
Date:   Wed, 24 Jul 2019 18:28:16 +0000
Message-ID: <ad63b46dfb7e36d63d95866a023ef181af40aa76.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
         <1563938327-9865-5-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1563938327-9865-5-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 778e746b-017f-4d3b-7a4f-08d71064b213
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB221673B70E96AF87A377BED7BEC60@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(189003)(199004)(54906003)(3846002)(6116002)(81156014)(81166006)(316002)(256004)(5660300002)(110136005)(4326008)(2906002)(6246003)(58126008)(446003)(7736002)(11346002)(305945005)(8676002)(186003)(8936002)(53936002)(25786009)(14454004)(118296001)(476003)(2501003)(2616005)(66066001)(66476007)(76176011)(64756008)(66556008)(66446008)(91956017)(36756003)(76116006)(71200400001)(71190400001)(6486002)(478600001)(99286004)(102836004)(86362001)(26005)(6512007)(6436002)(6506007)(229853002)(66946007)(486006)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JOob6rrAiTn7qwETu63IKOXmfno2rbUsir3US1GvGrQ1m54uRvGpr5UwO+VO+Er4HcgBzs5aZZS9265HR6RNN8KWpseBZO+rdAHWBGPN1Zczxx42GsC3d/PLk+954fR9rOSmQuQ2JRH7sPl6a5fxMqrQ1e/8IUiTXnkPjvNxKsBLsLng0qBuSV/ZCeZiLylqX96+50lEZs9G+rO7iNs5rygRxMn4nKca9dU32636uZPg0bjMtGGvqPUiqOhw92rG2KCFka3l6FXDlnWZjTLA7LAQDOlV2QJlwTqdBkRIaeY3fJ27XdCYNiw9GcRbRMwKHl/akobMBrLNUWQbFtPU2Sqe4AEwYBr90DQLQ5bYXjZdOYgLguSs6LqbavzLiEsL8N6XNSdIGl/9LZgcXYn8mYewSTa1b3Z4c83ijPx3kfk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7550FD708C620240BBD2106205BEFD72@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778e746b-017f-4d3b-7a4f-08d71064b213
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 18:28:16.4590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDExOjE4ICswODAwLCBIdWF6aG9uZyBUYW4gd3JvdGU6DQo+
IEZyb206IFlvbmdsb25nIExpdSA8bGl1eW9uZ2xvbmdAaHVhd2VpLmNvbT4NCj4gDQo+IFRoZSBu
dW1fbXNpX2xlZnQgbWVhbnMgdGhlIHZlY3RvciBudW1iZXJzIG9mIE5JQywgYnV0IGlmIHRoZQ0K
PiBQRiBzdXBwb3J0ZWQgUm9DRSwgaXQgY29udGFpbnMgdGhlIHZlY3RvciBudW1iZXJzIG9mIE5J
QyBhbmQNCj4gUm9DRShOb3QgZXhwZWN0ZWQpLg0KPiANCj4gVGhpcyBtYXkgY2F1c2UgaW50ZXJy
dXB0cyBsb3N0IGluIHNvbWUgY2FzZSwgYmVjYXVzZSBvZiB0aGUNCj4gTklDIG1vZHVsZSB1c2Vk
IHRoZSB2ZWN0b3IgcmVzb3VyY2VzIHdoaWNoIGJlbG9uZ3MgdG8gUm9DRS4NCj4gDQo+IFRoaXMg
cGF0Y2ggY29ycmVjdHMgdGhlIHZhbHVlIG9mIG51bV9tc2lfbGVmdCB0byBiZSBlcXVhbHMgdG8N
Cj4gdGhlIHZlY3RvciBudW1iZXJzIG9mIE5JQywgYW5kIGFkanVzdCB0aGUgZGVmYXVsdCB0cXAg
bnVtYmVycw0KPiBhY2NvcmRpbmcgdG8gdGhlIHZhbHVlIG9mIG51bV9tc2lfbGVmdC4NCj4gDQo+
IEZpeGVzOiA0NmEzZGY5Zjk3MTggKCJuZXQ6IGhuczM6IEFkZCBITlMzIEFjY2VsZXJhdGlvbiBF
bmdpbmUgJg0KPiBDb21wYXRpYmlsaXR5IExheWVyIFN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5
OiBZb25nbG9uZyBMaXUgPGxpdXlvbmdsb25nQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFBlbmcgTGkgPGxpcGVuZzMyMUBodWF3ZWkuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIdWF6aG9u
ZyBUYW4gPHRhbmh1YXpob25nQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM3BmL2hjbGdlX21haW4uYyAgIHwgIDUgKysrKy0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczN2Zi9oY2xnZXZmX21haW4u
YyB8IDEyDQo+ICsrKysrKysrKystLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzcGYvaGNsZ2VfbWFpbi5jDQo+IGluZGV4IDNjNjRk
NzAuLmE1OWQxM2YgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNv
bi9obnMzL2huczNwZi9oY2xnZV9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aGlzaWxpY29uL2huczMvaG5zM3BmL2hjbGdlX21haW4uYw0KPiBAQCAtMTQ3MCwxMyArMTQ3MCwx
NiBAQCBzdGF0aWMgaW50IGhjbGdlX3Zwb3J0X3NldHVwKHN0cnVjdA0KPiBoY2xnZV92cG9ydCAq
dnBvcnQsIHUxNiBudW1fdHFwcykNCj4gIHsNCj4gIAlzdHJ1Y3QgaG5hZTNfaGFuZGxlICpuaWMg
PSAmdnBvcnQtPm5pYzsNCj4gIAlzdHJ1Y3QgaGNsZ2VfZGV2ICpoZGV2ID0gdnBvcnQtPmJhY2s7
DQo+ICsJdTE2IGFsbG9jX3RxcHM7DQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCW5pYy0+cGRldiA9
IGhkZXYtPnBkZXY7DQo+ICAJbmljLT5hZV9hbGdvID0gJmFlX2FsZ287DQo+ICAJbmljLT5udW1h
X25vZGVfbWFzayA9IGhkZXYtPm51bWFfbm9kZV9tYXNrOw0KPiAgDQo+IC0JcmV0ID0gaGNsZ2Vf
a25pY19zZXR1cCh2cG9ydCwgbnVtX3RxcHMsDQo+ICsJYWxsb2NfdHFwcyA9IG1pbl90KHUxNiwg
aGRldi0+cm9jZV9iYXNlX21zaXhfb2Zmc2V0IC0gMSwgDQoNCg0KV2h5IGRvIHlvdSBuZWVkIHRo
ZSBleHRyYSBhbGxvY190cXBzID8ganVzdCBvdmVyd3JpdGUgbnVtX3RxcHMsIHRoZQ0Kb3JpZ2lu
YWwgdmFsdWUgaXMgbm90IG5lZWRlZCBhZnRlcndhcmRzLg0KDQo+IG51bV90cXBzKTsNCj4gKw0K
PiArCXJldCA9IGhjbGdlX2tuaWNfc2V0dXAodnBvcnQsIGFsbG9jX3RxcHMsDQo+ICAJCQkgICAg
ICAgaGRldi0+bnVtX3R4X2Rlc2MsIGhkZXYtPm51bV9yeF9kZXNjKTsNCj4gIAlpZiAocmV0KQ0K
PiAgCQlkZXZfZXJyKCZoZGV2LT5wZGV2LT5kZXYsICJrbmljIHNldHVwIGZhaWxlZCAlZFxuIiwN
Cj4gcmV0KTsNCj4gDQo=
