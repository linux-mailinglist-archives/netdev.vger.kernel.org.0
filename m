Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E751A3C15B0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhGHPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:11:27 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:42674 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229592AbhGHPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:11:24 -0400
X-UUID: 3c85a5a83be84b6ea866ee9c0a6f44be-20210708
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=rmy3vTKrj+13anpiQhZfLEyONls/y6wLF5zWGoxVdF8=;
        b=hD+qqujji0r8m3P9PDI2pnMaDxCMqpZ2iA7j9kUXLS7Bm41FTMOTTzpROgvrgPodbTxI7zxg2oo1FOLcMcwYXhexU7yj6uPtnpQSDxCXNRy2sadtBPP35cEdUTZFQrUfRZond4eqtm9BT5pLUTEbCse8EbAIynqlYzbCZn3SOTA=;
X-UUID: 3c85a5a83be84b6ea866ee9c0a6f44be-20210708
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1688495760; Thu, 08 Jul 2021 23:08:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 8 Jul 2021 23:08:30 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Jul 2021 23:08:30 +0800
Message-ID: <1eaab818ef2478b115e1387dcca7427f633cc217.camel@mediatek.com>
Subject: Re: [PATCH] mt76: mt7921: continue to probe driver when fw already
 downloaded
From:   Deren Wu <deren.wu@mediatek.com>
To:     Aaron Ma <aaron.ma@canonical.com>, <nbd@nbd.name>,
        <lorenzo.bianconi83@gmail.com>, <ryder.lee@mediatek.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <sean.wang@mediatek.com>,
        <Soul.Huang@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 8 Jul 2021 23:08:30 +0800
In-Reply-To: <20210708131710.695595-1-aaron.ma@canonical.com>
References: <20210708131710.695595-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWFyb24sDQoNClRoYW5rcyBmb3IgdGhpcyBwYXRjaC4gV2UgdmVyaWZpZWQgdGhpcyBpcyBn
b29kIGhlcmUuDQoNCkNvdWxkIHlvdSBwbGVhc2UgYWRkIGZpeCB0YWcgYXMgd2VsbD8gSXQncyBi
ZXR0ZXIgdG8gYmFja3BvcnQgdGhpcw0KcGF0Y2guDQoNCkZpeGVzOiAxYzA5OWFiNDQ3MjdjICgi
bXQ3NjogbXQ3OTIxOiBhZGQgTUNVIHN1cHBvcnQiKQ0KDQoNClRoYW5rcywNCkRlcmVuDQoNCg0K
T24gVGh1LCAyMDIxLTA3LTA4IGF0IDIxOjE3ICswODAwLCBBYXJvbiBNYSB3cm90ZToNCj4gV2hl
biByZWJvb3Qgc3lzdGVtLCBubyBwb3dlciBjeWNsZXMsIGZpcm13YXJlIGlzIGFscmVhZHkgZG93
bmxvYWRlZCwNCj4gcmV0dXJuIC1FSU8gd2lsbCBicmVhayBkcml2ZXIgYXMgZXJyb3I6DQo+IG10
NzkyMWU6IHByb2JlIG9mIDAwMDA6MDM6MDAuMCBmYWlsZWQgd2l0aCBlcnJvciAtNQ0KPiANCj4g
U2tpcCBmaXJtd2FyZSBkb3dubG9hZCBhbmQgY29udGludWUgdG8gcHJvYmUuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBBYXJvbiBNYSA8YWFyb24ubWFAY2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkyMS9tY3UuYyB8IDMgKystDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MjEvbWN1
LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkyMS9tY3UuYw0K
PiBpbmRleCBjMmM0ZGMxOTY4MDIuLmNkNjkwYzY0ZjY1YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MjEvbWN1LmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MjEvbWN1LmMNCj4gQEAgLTkzMSw3ICs5
MzEsNyBAQCBzdGF0aWMgaW50IG10NzkyMV9sb2FkX2Zpcm13YXJlKHN0cnVjdCBtdDc5MjFfZGV2
DQo+ICpkZXYpDQo+ICAJcmV0ID0gbXQ3Nl9nZXRfZmllbGQoZGV2LCBNVF9DT05OX09OX01JU0Ms
DQo+IE1UX1RPUF9NSVNDMl9GV19OOV9SRFkpOw0KPiAgCWlmIChyZXQpIHsNCj4gIAkJZGV2X2Ri
ZyhkZXYtPm10NzYuZGV2LCAiRmlybXdhcmUgaXMgYWxyZWFkeQ0KPiBkb3dubG9hZFxuIik7DQo+
IC0JCXJldHVybiAtRUlPOw0KPiArCQlnb3RvIGZ3X2xvYWRlZDsNCj4gIAl9DQo+ICANCj4gIAly
ZXQgPSBtdDc5MjFfbG9hZF9wYXRjaChkZXYpOw0KPiBAQCAtOTQ5LDYgKzk0OSw3IEBAIHN0YXRp
YyBpbnQgbXQ3OTIxX2xvYWRfZmlybXdhcmUoc3RydWN0IG10NzkyMV9kZXYNCj4gKmRldikNCj4g
IAkJcmV0dXJuIC1FSU87DQo+ICAJfQ0KPiAgDQo+ICtmd19sb2FkZWQ6DQo+ICAJbXQ3Nl9xdWV1
ZV90eF9jbGVhbnVwKGRldiwgZGV2LT5tdDc2LnFfbWN1W01UX01DVVFfRldETF0sDQo+IGZhbHNl
KTsNCj4gIA0KPiAgI2lmZGVmIENPTkZJR19QTQ0K

