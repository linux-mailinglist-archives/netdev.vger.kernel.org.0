Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2182068AB
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbgFWXwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:52:46 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:59813
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387546AbgFWXwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 19:52:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kczkzTfircPkSFfeZNGk4SQpdDVowmd7Tfm6Djt5sR9rpX00zzbo7QnG22WwykxbM7q6yHfUUeEkxgExCsuAKTyz57l5w0HktLsAQYRqzNDCvNNUYLpoG4GLQDBMupQCfE74Y+es4CtUQ9zihw5E7iJ5QtBTx240ZxeBPxZi7xxrk2r6jMg+6fkpvqO5igz5wM+57UjvmQtmC1XFcn0Suw3tK8C5Iz0E+DJqePy5bw+Y5nO/cNy/WTgMf8Whk2cQNWyew39nKV+LoY5/9n1aKL705ennNZuR8wl3xyr0EcLyNmysvUranucTRwJjlo9CPGNGMgAwKbA0MGzTedBIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMIUZfzeh7u0pZOwmHf8GYZKUNjMr+6CyFy8Pj4s0nI=;
 b=CyROfUeduGzY3a/U27xZb6JNazzRX7zyVMVAqAaMPKI7mSTJv+jSrqcl2p4cvBhrDEw8M0tUve9tcnuko3ul9CiYjmR/hs1cvH7fErpkNwTUWhM7leT/jYdKKekiJmMoi8mnVgSEzmPTx7WwILVN8KH92u667I9NyJ3WiC2DpLZqf3VG1HPoi/Wavyy2rtlxxiMNsgqJ9JO2yKBcYmMgKE1a/H336U3bTQS3J4PRwrh6+6FJ24D7DdvF8dj44WTbEGjTlJcW8NOpIVNrj/kaj/50jhceCCBvcyAoUjJBVYQNtYeoaWdv39A8wUDPXoHbNEpv6G29QnENAhijcNdc9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMIUZfzeh7u0pZOwmHf8GYZKUNjMr+6CyFy8Pj4s0nI=;
 b=IMAWcKqPVYDC+QYm8nrAROf/fzcelYAeJEnfL5dJ0UDfxvXUlazmPItdkUHtOVuVIyxQw3EC9FGYmGoxsk+djisBUKpzVMW1+sJr+F0k0P6LkhM3xzjQ41mx91/rn/olrNe+VA5w8RafYKk32Jkux1l3J93T+78mR17wFzzgAg8=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6733.eurprd04.prod.outlook.com (2603:10a6:803:11e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 23:52:40 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 23:52:40 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
Subject: RE:  Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZJs6PHvCIyKG/STfCN4JWFwwPAXw==
Date:   Tue, 23 Jun 2020 23:52:40 +0000
Message-ID: <VE1PR04MB6496AD2BE9868D72A475935492940@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d26e1c2f-75d6-4f07-47ec-08d817d083ec
x-ms-traffictypediagnostic: VE1PR04MB6733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6733B44080FF3A3E07D59DE592940@VE1PR04MB6733.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YtaXXTCfVThuO5+r9oGs2cueNH3wb3UXEqZ4nyZ5pCKF3BkevKw3kkc4iVuDltJeljC+otWK/hINP9PykNcYdkij9uxW0mTWxMfCQaS2RJCmoOGHSAcr/ag6puCvuquPCvehlQQwXLipm3P0Hcw3V8HCKIH7t07+YwvRZ/p9rN/WETGPqghzKA8YpSOAbGmHfv514AqYLxpIR2cvYpTpnaOvjOGyFGp7ZpiiP6iIGMAkoUukuVC+xMzQWP8iphu+G/G/DiiQo+G4UemrGO2beaLwzWFQKMpnPLpQ67SIu397Bivg/MF3xYLccWmq+9nrJYEbtuZG6e2axwKjh0NvJtDApCBufB9HIMDnwiVbtuv1vOoR+RRvIFG+fXyZEfWC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(52536014)(6506007)(53546011)(44832011)(86362001)(186003)(5660300002)(26005)(83380400001)(76116006)(66946007)(7416002)(66556008)(64756008)(66476007)(110136005)(66446008)(2906002)(33656002)(478600001)(71200400001)(7696005)(9686003)(4326008)(316002)(55016002)(8676002)(54906003)(8936002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NuNTcCFnbxBG2FFzs4jsedzBMFUQ85JuNjmReTlibA0LsvFRx3kNV/yfwvNnN25P6rJlYSaQTInf3qdOtz2W9MB9p3TYWQ4mOdLCQNgeAeU3BsGWuXsHflAGRKgxtoxsUuaLJ05zzsJINEmJ88jmgo9Z4Izh08E4EUDF7mwFMEkoaVmVjBMhr/qJ8pM2zllp4SBlgfb1dHBVgJ3Y3iLq8qALjivGQxncFZszQt7cQdZygJ74HTfDGgfpFNF4GbdXjFI/zWa0k7Teeoi1SDXLasghC76tmaAndgzF9+YXkozEYeSIvtWLf7VHJmrltfXexIrxkupE8wejujBr703EndBZ19VV+thF+zV6FyeJqco3c7KyfwsZrlVy5ar9oDlMDTQWpmpPwSv9r2jzpFIxei64r0AaAQj7v/TKXlgiL3tmvV0N951I3PDDtfuO4at93N5edt1IhjyaZNsBhcHTA/0WqgEQRnCAm6I7NVW5cjOXwd8wjyVmzR9lHOHm+IwI
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26e1c2f-75d6-4f07-47ec-08d817d083ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 23:52:40.4533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W/mJITu7Swf3zrrFj5ox4dbEB7SosjzViUHZeI+ExYk1d794lUMqUHu1G1MJU1Us
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1h
bCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPg0KPiBTZW50OiAyMDIw5bm0NuaciDIz5pel
IDIwOjE4DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGlkb3NjaEBpZG9zY2gub3JnDQo+IENjOiBqaXJpQHJlc251bGxpLnVzOyB2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb207IHZsYWRAYnVzbG92LmRldjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBu
eHAuY29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAu
Y29tPjsgbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsNCj4gdmlzaGFsQGNoZWxzaW8uY29tOyBz
YWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7DQo+IGppcmlAbWVsbGFub3guY29t
OyBpZG9zY2hAbWVsbGFub3guY29tOw0KPiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsg
VU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyB4aXlvdS53
YW5nY29uZ0BnbWFpbC5jb207DQo+IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOyBwYWJsb0Bu
ZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207
DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIu
b3JnOyBFZHdhcmQNCj4gQ3JlZSA8ZWNyZWVAc29sYXJmbGFyZS5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbdjEsbmV0LW5leHQgMy80XSBuZXQ6IHFvczogcG9saWNlIGFjdGlvbiBhZGQgaW5kZXggZm9y
IHRjDQo+IGZsb3dlciBvZmZsb2FkaW5nDQo+IA0KPiBPbiAyMDIwLTA2LTIzIDc6NTUgYS5tLiwg
UG8gTGl1IHdyb3RlOg0KPiANCj4gDQo+IFsuLl0NCj4gPj4gTXkgcXVlc3Rpb246IElzIHRoaXMg
YW55IGRpZmZlcmVudCBmcm9tIGhvdyBzdGF0cyBhcmUgc3RydWN0dXJlZD8NCj4gPg0KPiA+IEkg
ZG9uJ3Qga25vdyBJIGZ1bGx5IGNhdGNoIHRoZSBxdWVzdGlvbi4gQXJlIHlvdSB0cnlpbmcgdG8g
Z2V0IGhvdyBtYW55DQo+IGZyYW1lcyBmb3IgZWFjaCBmaWx0ZXIgY2hhaW4gcGFzc2luZyBvbmUg
aW5kZXggcG9saWNpbmcgYWN0aW9uPw0KPiA+IElmIG9uZSBpbmRleCBwb2xpY2UgYWN0aW9uIGJp
bmQgdG8gbXVsdGlwbGUgdGMgZmlsdGVyKHRoZXkgc2hvdWxkIGhhdmUNCj4gZGlmZmVybnQgY2hh
aW4gaW5kZXggKS4gQWxsIHRob3NlIGZpbHRlciBzaG91bGQgZ2V0IHNhbWUgaW5kZXggcG9saWNl
IGFjdGlvbg0KPiBzdGF0cyB2YWx1ZSBzaW5jZSB0aGV5IGFyZSBzaGFyaW5nIHRoZSBzYW1lIGhh
cmR3YXJlIGVudHJ5LiBCdXQgSSBkb24ndA0KPiB0aGluayB0aGlzIGlzIHRoZSBwcm9ibGVtLg0K
PiA+DQo+IA0KPiBUaGlzIGlzIGEgZ29vZCB0aGluZy4gV2hhdCBpcyBuaWNlIGlzIGkgY2FuIHVz
ZSB0aGUgc2FtZSBpbmRleCBmb3Igcy93IGFuZA0KPiBoL3cgKGFuZCBubyBuZWVkIGZvciBhIHRy
YW5zbGF0aW9uL3JlbWFwcGluZykuDQo+IA0KPiA+IFdpdGggaW5kZXggcHJvdmlkZSB0byBkZXZp
Y2UgZHJpdmVyKG1hcCB0aGUgcy93IGFjdGlvbiBpbmRleCB0byBhIGgvdw0KPiB0YWJsZSBpbmRl
eCApLCB1c2VyIGNvdWxkIGxpc3QgdGhlIHBvbGljZSBhY3Rpb25zIGxpc3QgYnkgY29tbWFuZDoN
Cj4gPiAjIHRjIGFjdGlvbnMgc2hvdyBhY3Rpb24gcG9saWNlDQo+ID4gU2hvd3MgdGhlIHBvbGlj
ZSBhY3Rpb24gdGFibGUgYnkgaW5kZXguDQo+IA0KPiBUaGlzIGlzIGFsc28gbmljZS4NCj4gDQo+
IE15IHF1ZXN0aW9uOiBXaHkgY2FudCB5b3UgYXBwbHkgdGhlIHNhbWUgc2VtYW50aWNzIGZvciB0
aGUgY291bnRlcnM/DQo+IERvZXMgeW91ciBoYXJkd2FyZSBoYXZlIGFuIGluZGV4ZWQgY291bnRl
ci9zdGF0cyB0YWJsZT8gSWYgeWVzIHRoZW4geW91DQoNClllcywgIGJ1dCBJIHRoaW5rIHRjIGZs
b3dlciBjYW4gb25seSBjYXJlIGFib3V0IHRoZSAgY291bnRlcnMgb2YgdGhhdCBjaGFpbi4gQW5k
IGFjdGlvbiBwb2xpY2UgY2FyZSBhYm91dCBob3cgbWFueSBmcmFtZXMgZm9yIGVhY2ggcG9saWNl
IGVudHJ5Lg0KDQo+IHNob3VsZCBiZSBhYmxlIHRvIGRvIHNpbWlsYXIgdGhpbmcgZm9yIGNvdW50
ZXJzIGFzIHlvdSBkbyBmb3IgcG9saWNlciAoaS5lDQo+IHVzZSBhbiBpbmRleCBhbmQgc2hhcmUg
Y291bnRlcnMgYWNyb3NzIGFjdGlvbnMpLiBTbyB3aGVuIGkgc2F5Og0KPiB0YyBhY3Rpb24gZHJv
cCBpbmRleCA1DQoNCkRvIHlvdSBtZWFuIHNvbWV0aGluZyBsaWtlICJ0YyB4eHggZmxvd2VyIGFj
dGlvbiBwb2xpY2UgaW5kZXggNSBkcm9wIiAgc2luY2UgJycgdGMgYWN0aW9uIGRyb3AgaW5kZXgg
NSIgaXMgbm90IGEgcHJvcGVyIGNvbW1hbmQ/ICh0aGVyZSBpcyAnYWN0aW9uIGRyb3AnICBmb2xs
b3cgdGhlIHRjIGZpbHRlciBjb21tYW5kIGJ1dCBub3Qgd2l0aCBpbmRleCBhc3NpZ25lZCkuIA0K
DQo+IGFuZA0KPiB0YyBhY3Rpb24gb2sgaW5kZXggNQ0KPiBpbmZhY3QgdGhleSB1c2UgdGhlIHNh
bWUgY291bnRlci4NCg0KTWF5YmUgeW91IGFyZSBzYXlpbmcgaWYgYWN0aW9uIHBvbGljZSBmb2xs
b3cgd2l0aCAnQ09OVFJPTCcgKHJlY2xhc3NpZnkgfCBwaXBlIHwgZHJvcCB8IGNvbnRpbnVlIHwg
b2spICB3aGVuIG9mZmxvYWRpbmcgdG8gaGFyZHdhcmUuIFdpdGggZGlmZmVyZW50ICdDT05UUk9M
JywgdGhlIGhhcmR3YXJlIGNvdW50ZXIgd29uJ3QgY2hhbmdlZCBzaW5jZSBoYXJkd2FyZSBuZXZl
ciBrbm93biB3aGF0IHRoZSAnQ09OVFJPTCcgaXMuIFRoaXMgaXMgc3RpbGwgc29mdHdhcmUgcGFy
dCBhbmQgd2lsbCBkbyBhdCBzb2Z0d2FyZSBwYXJ0KGFsdGhvdWdoIHNvZnR3YXJlIHNlZW1zIG5v
dCBkZWFsIHdpdGggdGhpcywgSSBhbHNvIHN1Z2dlc3QgdG8gYWZ0ZXIgb2ZmbG9hZGluZyBzaG91
bGQgYmFjayB0byB0Y2ZfcG9saWNlX2FjdCgpIGNvbnRpbnVlIHRoZSBhY3Rpb24pLiANCg0KV2hl
biBzZXQgdG8gYmUgb2ZmbG9hZGluZyBtb2RlLCB0aGUgY291bnRlcnMgb25seSBzaG93aW5nIHRo
ZSBoYXJkd2FyZSBjb3VudGVycyhldmVuIGRpZmZlcmVudCB2ZW5kb3IgY291bGQgc2V0IGRpZmZl
cmVudCBjb3VudGVyIHJlZ2lzdGVyLikuIEJ1dCBJIGRvbid0IHRoaW5rIHRoZSBpbmRleCBvZmZs
b2FkaW5nIGNvdWxkIGJyZWFrIGFueXRoaW5nLg0KDQo+IA0KPiANCj4gY2hlZXJzLA0KPiBqYW1h
bA0KDQoNCkJyLA0KUG8gTGl1DQo=
