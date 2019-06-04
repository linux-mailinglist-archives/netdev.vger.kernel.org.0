Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C07333D7D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFDDUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:20:11 -0400
Received: from mail-eopbgr740132.outbound.protection.outlook.com ([40.107.74.132]:18028
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbfFDDUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNXUryDC5/jRDyB9c9G/dcBrqMwMiy0Ofom+daPOpik=;
 b=X40ZqPpSOFlISKnsxQvCocddF7AXVJAE+cMTSOl/mBFcYD5do1eIlNHLt1wmk9Pjel3D/fCBjwsOiHtJKJZo78Mb7xhbGEEllXVyCD2HrILyijdFpll47jAaOZ6JMlFk1ReQ5GWHNMSpnGAWsPZKQdH/9lU5rKcK3D4p203oL/g=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB6144.namprd06.prod.outlook.com (20.178.247.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Tue, 4 Jun 2019 03:20:00 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::ed06:32fa:24bc:cbb8]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::ed06:32fa:24bc:cbb8%7]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 03:20:00 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Doug Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Double Lo <Double.Lo@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for
 BRCM 4354
Thread-Topic: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for
 BRCM 4354
Thread-Index: AQHVDQOHQAH0fc1bJEKX/x86/JpDHKaAwJxWgAAEwgCAAAB8AIAKKNOA
Date:   Tue, 4 Jun 2019 03:20:00 +0000
Message-ID: <40587a64-490b-8b1e-8a11-1e1aebdab2f3@cypress.com>
References: <20190517225420.176893-2-dianders@chromium.org>
 <20190528121833.7D3A460A00@smtp.codeaurora.org>
 <CAD=FV=VtxdEeFQsdF=U7-_7R+TXfVmA2_JMB_-WYidGHTLDgLw@mail.gmail.com>
 <16aff33f3e0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <16aff358a20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <16aff358a20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TY1PR01CA0135.jpnprd01.prod.outlook.com
 (2603:1096:402:1::11) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ccdd0ba-c847-4009-3f24-08d6e89b86a5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB6144;
x-ms-traffictypediagnostic: MN2PR06MB6144:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR06MB6144EB06FFE23F98286A63F7FB150@MN2PR06MB6144.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(396003)(39860400002)(346002)(189003)(199004)(66946007)(66446008)(66556008)(64756008)(66476007)(73956011)(6116002)(3846002)(8936002)(53936002)(31686004)(6246003)(6512007)(6306002)(6436002)(6486002)(25786009)(7416002)(4326008)(81156014)(81166006)(8676002)(2906002)(229853002)(305945005)(7736002)(52116002)(99286004)(102836004)(53546011)(6506007)(386003)(76176011)(110136005)(86362001)(54906003)(36756003)(31696002)(256004)(478600001)(14444005)(486006)(26005)(186003)(5660300002)(71200400001)(71190400001)(2616005)(476003)(11346002)(446003)(316002)(966005)(66066001)(68736007)(14454004)(72206003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB6144;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UrQauiDSyKejAaWxsWs3wDdlOWxh/fd0KHbg2k+Xfih5Z9Cxqe71kyu5wkJA3v78H7yI5nmdErPht84S5/BrFPtpMg3ObfXqlvF+HoBkfRy8xZ/JwZ7w1J4zY3lKY1Jeq8yNKJ+wgL8gnEqTC2xeJatI1A3FbSVa8PVAadAm+5t4xQlT+C06zVWt/936hR+20Qy7xFZ4pQkp6V5V/5DukvNhSljFjZAXKr5zisPe+YQIFiCFifICzklQewMoDe9q9QAYhZXKdc+SzsdBabHP6EF0a+JIb2ZadW7NfbXyKfAt1hGHunhlj/X8F/lXJim6scqDr4CKwA+PfnRLrReQOkCAWI7CTnbiDRMv98u1NtgJzMsToeHy35JKOaEPVhc6BlrkLE+wkyBnZpby2/PHhsNyJgnsmSTZV6NFPtUu1F0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA48026D1287C44BBA84E634C7975622@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccdd0ba-c847-4009-3f24-08d6e89b86a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 03:20:00.0962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wefe@cypress.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTkvNS8yOSDkuIrljYggMTI6MTEsIEFyZW5kIFZhbiBTcHJpZWwgd3JvdGU6DQo+
IE9uIE1heSAyOCwgMjAxOSA2OjA5OjIxIFBNIEFyZW5kIFZhbiBTcHJpZWwgDQo+IDxhcmVuZC52
YW5zcHJpZWxAYnJvYWRjb20uY29tPiB3cm90ZToNCj4gDQo+PiBPbiBNYXkgMjgsIDIwMTkgNTo1
MjoxMCBQTSBEb3VnIEFuZGVyc29uIDxkaWFuZGVyc0BjaHJvbWl1bS5vcmc+IHdyb3RlOg0KPj4N
Cj4+PiBIaSwNCj4+Pg0KPj4+IE9uIFR1ZSwgTWF5IDI4LCAyMDE5IGF0IDU6MTggQU0gS2FsbGUg
VmFsbyA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+IHdyb3RlOg0KPj4+Pg0KPj4+PiBEb3VnbGFzIEFu
ZGVyc29uIDxkaWFuZGVyc0BjaHJvbWl1bS5vcmc+IHdyb3RlOg0KPj4+Pg0KPj4+PiA+IEluIGNv
bW1pdCAyOWY2NTg5MTQwYTEgKCJicmNtZm1hYzogZGlzYWJsZSBjb21tYW5kIGRlY29kZSBpbg0K
Pj4+PiA+IHNkaW9fYW9zIikgd2UgZGlzYWJsZWQgc29tZXRoaW5nIGNhbGxlZCAiY29tbWFuZCBk
ZWNvZGUgaW4gc2Rpb19hb3MiDQo+Pj4+ID4gZm9yIGEgd2hvbGUgYnVuY2ggb2YgQnJvYWRjb20g
U0RJTyBXaUZpIHBhcnRzLg0KPj4+PiA+DQo+Pj4+ID4gQWZ0ZXIgdGhhdCBwYXRjaCBsYW5kZWQg
SSBmaW5kIHRoYXQgbXkga2VybmVsIGxvZyBvbg0KPj4+PiA+IHJrMzI4OC12ZXlyb24tbWlubmll
IGFuZCByazMyODgtdmV5cm9uLXNwZWVkeSBpcyBmaWxsZWQgd2l0aDoNCj4+Pj4gPsKgwqAgYnJj
bWZtYWM6IGJyY21mX3NkaW9fYnVzX3NsZWVwOiBlcnJvciB3aGlsZSBjaGFuZ2luZyBidXMgc2xl
ZXAgDQo+Pj4+IHN0YXRlIC0xMTANCj4+Pj4gPg0KPj4+PiA+IFRoaXMgc2VlbXMgdG8gaGFwcGVu
IGV2ZXJ5IHRpbWUgdGhlIEJyb2FkY29tIFdpRmkgdHJhbnNpdGlvbnMgb3V0IG9mDQo+Pj4+ID4g
c2xlZXAgbW9kZS7CoCBSZXZlcnRpbmcgdGhlIHBhcnQgb2YgdGhlIGNvbW1pdCB0aGF0IGFmZmVj
dHMgdGhlIA0KPj4+PiBXaUZpIG9uDQo+Pj4+ID4gbXkgYm9hcmRzIGZpeGVzIHRoZSBwcm9ibGVt
IGZvciBtZSwgc28gdGhhdCdzIHdoYXQgdGhpcyBwYXRjaCBkb2VzLg0KPj4+PiA+DQo+Pj4+ID4g
Tm90ZSB0aGF0LCBpbiBnZW5lcmFsLCB0aGUganVzdGlmaWNhdGlvbiBpbiB0aGUgb3JpZ2luYWwg
Y29tbWl0IA0KPj4+PiBzZWVtZWQNCj4+Pj4gPiBhIGxpdHRsZSB3ZWFrLsKgIEl0IGxvb2tlZCBs
aWtlIHNvbWVvbmUgd2FzIHRlc3Rpbmcgb24gYSBTRCBjYXJkDQo+Pj4+ID4gY29udHJvbGxlciB0
aGF0IHdvdWxkIHNvbWV0aW1lcyBkaWUgaWYgdGhlcmUgd2VyZSBDUkMgZXJyb3JzIG9uIHRoZQ0K
Pj4+PiA+IGJ1cy7CoCBUaGlzIHVzZWQgdG8gaGFwcGVuIGJhY2sgaW4gZWFybHkgZGF5cyBvZiBk
d19tbWMgKHRoZSANCj4+Pj4gY29udHJvbGxlcg0KPj4+PiA+IG9uIG15IGJvYXJkcyksIGJ1dCB3
ZSBmaXhlZCBpdC7CoCBEaXNhYmxpbmcgYSBmZWF0dXJlIG9uIGFsbCBib2FyZHMNCj4+Pj4gPiBq
dXN0IGJlY2F1c2Ugb25lIFNEIGNhcmQgY29udHJvbGxlciBpcyBicm9rZW4gc2VlbXMgYmFkLsKg
IC4uLnNvDQo+Pj4+ID4gaW5zdGVhZCBvZiBqdXN0IHRoaXMgcGF0Y2ggcG9zc2libHkgdGhlIHJp
Z2h0IHRoaW5nIHRvIGRvIGlzIHRvIGZ1bGx5DQo+Pj4+ID4gcmV2ZXJ0IHRoZSBvcmlnaW5hbCBj
b21taXQuDQo+Pj4+ID4NClNpbmNlIHRoZSBjb21taXQgMjlmNjU4OTE0MGExICgiYnJjbWZtYWM6
IGRpc2FibGUgY29tbWFuZCBkZWNvZGUgaW4gDQpzZGlvX2FvcyIpIGNhdXNlcyB0aGUgcmVncmVz
c2lvbiBvbiBvdGhlciBTRCBjYXJkIGNvbnRyb2xsZXIsIGl0IGlzIA0KYmV0dGVyIHRvIHJldmVy
dCBpdCBhcyB5b3UgbWVudGlvbmVkLg0KQWN0dWFsbHksIHdpdGhvdXQgdGhlIGNvbW1pdCwgd2Ug
aGl0IE1NQyB0aW1lb3V0KC0xMTApIGFuZCBoYW5nZWQgDQppbnN0ZWFkIG9mIENSQyBlcnJvciBp
biBvdXIgdGVzdC4gV291bGQgeW91IHBsZWFzZSBzaGFyZSB0aGUgYW5hbHlzaXMgb2YgDQpkd19t
bWMgaXNzdWUgd2hpY2ggeW91IGZpeGVkPyBXZSdkIGxpa2UgdG8gY29tcGFyZSB3aGV0aGVyIHdl
IGdvdCB0aGUgDQpzYW1lIGlzc3VlLg0KDQpSZWdhcmRzLA0KV3JpZ2h0DQoNCj4+Pj4gPiBGaXhl
czogMjlmNjU4OTE0MGExICgiYnJjbWZtYWM6IGRpc2FibGUgY29tbWFuZCBkZWNvZGUgaW4gc2Rp
b19hb3MiKQ0KPj4+PiA+IFNpZ25lZC1vZmYtYnk6IERvdWdsYXMgQW5kZXJzb24gPGRpYW5kZXJz
QGNocm9taXVtLm9yZz4NCj4+Pj4NCj4+Pj4gSSBkb24ndCBzZWUgcGF0Y2ggMiBpbiBwYXRjaHdv
cmsgYW5kIEkgYXNzdW1lIGRpc2N1c3Npb24gY29udGludWVzLg0KPj4+DQo+Pj4gQXBvbG9naWVz
LsKgIEkgbWFkZSBzdXJlIHRvIENDIHlvdSBpbmRpdmlkdWFsbHkgb24gYWxsIHRoZSBwYXRjaGVz
IGJ1dA0KPj4+IGRpZG4ndCB0aGluayBhYm91dCB0aGUgZmFjdCB0aGF0IHlvdSB1c2UgcGF0Y2h3
b3JrIHRvIG1hbmFnZSBhbmQgc28NCj4+PiBkaWRuJ3QgZW5zdXJlIGFsbCBwYXRjaGVzIG1hZGUg
aXQgdG8gYWxsIGxpc3RzIChieSBkZWZhdWx0IGVhY2ggcGF0Y2gNCj4+PiBnZXRzIHJlY2lwaWVu
dHMgaW5kaXZpZHVhbGx5IGZyb20gZ2V0X21haW50YWluZXIpLsKgIEknbGwgbWFrZSBzdXJlIHRv
DQo+Pj4gZml4IGZvciBwYXRjaCBzZXQgIzIuwqAgSWYgeW91IHdhbnQgdG8gc2VlIGFsbCB0aGUg
cGF0Y2hlcywgeW91IGNhbiBhdA0KPj4+IGxlYXN0IGZpbmQgdGhlbSBvbiBsb3JlLmtlcm5lbC5v
cmcgbGlua2VkIGZyb20gdGhlIGNvdmVyOg0KPj4+DQo+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvcGF0Y2h3b3JrL2NvdmVyLzEwNzUzNzMvDQo+Pj4NCj4+Pg0KPj4+PiBQbGVhc2UgcmVzZW5k
IGlmL3doZW4gSSBuZWVkIHRvIGFwcGx5IHNvbWV0aGluZy4NCj4+Pj4NCj4+Pj4gMiBwYXRjaGVz
IHNldCB0byBDaGFuZ2VzIFJlcXVlc3RlZC4NCj4+Pj4NCj4+Pj4gMTA5NDg3ODUgWzEvM10gYnJj
bWZtYWM6IHJlLWVuYWJsZSBjb21tYW5kIGRlY29kZSBpbiBzZGlvX2FvcyBmb3IgDQo+Pj4+IEJS
Q00gNDM1NA0KPj4+DQo+Pj4gQXMgcGVyIEFyZW5kIEknbGwgY2hhbmdlIHBhdGNoICMxIHRvIGEg
ZnVsbCByZXZlcnQgaW5zdGVhZCBvZiBhDQo+Pj4gcGFydGlhbCByZXZlcnQuwqAgQXJlbmQ6IHBs
ZWFzZSB5ZWxsIGlmIHlvdSB3YW50IG90aGVyd2lzZS4NCj4+DQo+PiBObyB5ZWxsaW5nIGhlcmUu
IElmIGFueSBpdCBpcyBleHBlY3RlZCBmcm9tIEN5cHJlc3MuIE1heWJlIGdvb2QgdG8gYWRkIA0K
Pj4gdGhlbQ0KPj4gc3BlY2lmaWNhbGx5IGluIENjOg0KPiANCj4gT2YgdGhlIHJldmVydCBwYXRj
aCB0aGF0IGlzLg0KPiANCj4gR3IuIEF2Uw0KPiANCj4gDQo=
