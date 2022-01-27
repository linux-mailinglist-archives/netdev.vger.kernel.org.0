Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2071549D7F4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiA0CUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:20:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53850 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231582AbiA0CUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:20:34 -0500
X-UUID: 311ddb002ece4225a4ff8e7d350586b6-20220127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=zv6kHK8XcIu/9fbhvtq0nRCaxzxKlIOUazyYdUv8qM4=;
        b=TjhS2njcPmWcFJ0Q279D9hKa+q+uaHuqx1skB80XpWT0IWnKb3MJ6ZexwdSc6+xZiioP3BM2wYslv4i+VjOdu0rFkR1LngUNsn0uaE5418xiL1TKkxqZ/dJgiFSmIwZLG3lcP3I/IWbBIe2sr7wB2jQEru8PN2V3Q65KBTX2Puc=;
X-UUID: 311ddb002ece4225a4ff8e7d350586b6-20220127
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1660428893; Thu, 27 Jan 2022 10:20:31 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 27 Jan 2022 10:20:29 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 10:20:29 +0800
Subject: Re: [PATCH net-next v2 6/9] net: ethernet: mtk-star-emac: add timing
 adjustment support
To:     Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Fabien Parent" <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
 <20220127015857.9868-7-biao.huang@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
Message-ID: <ca39f3b3-7c61-bcdd-d072-d441612855d2@mediatek.com>
Date:   Thu, 27 Jan 2022 10:20:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220127015857.9868-7-biao.huang@mediatek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzI3LzIyIDk6NTggQU0sIEJpYW8gSHVhbmcgd3JvdGU6DQo+IEFkZCBzaW1wbGUgY2xv
Y2sgaW52ZXJzaW9uIGZvciB0aW1pbmcgYWRqdXN0bWVudCBpbiBkcml2ZXIuDQo+IEFkZCBwcm9w
ZXJ0eSAibWVkaWF0ZWssdHhjLWludmVyc2UiIG9yICJtZWRpYXRlayxyeGMtaW52ZXJzZSIgdG8N
Cj4gZGV2aWNlIG5vZGUgd2hlbiBuZWNlc3NhcnkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaWFv
IEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWluZ2h1
YSBQYW4gPG90X3lpbmdodWEucGFuQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jIHwgMzQgKysrKysrKysrKysrKysr
KysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jDQo+IGluZGV4IGQ2OWY3
NTY2MWU3NS4uZDVlOTc0ZTBkYjZkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWRpYXRlay9tdGtfc3Rhcl9lbWFjLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVkaWF0ZWsvbXRrX3N0YXJfZW1hYy5jDQo+IEBAIC0xMzEsNiArMTMxLDExIEBAIHN0YXRpYyBj
b25zdCBjaGFyICpjb25zdCBtdGtfc3Rhcl9jbGtfbmFtZXNbXSA9IHsgImNvcmUiLCAicmVnIiwg
InRyYW5zIiB9Ow0KPiAgICNkZWZpbmUgTVRLX1NUQVJfUkVHX0lOVF9NQVNLCQkJMHgwMDU0DQo+
ICAgI2RlZmluZSBNVEtfU1RBUl9CSVRfSU5UX01BU0tfRk5SQwkJQklUKDYpDQo+ICAgDQo+ICsv
KiBEZWxheS1NYWNybyBSZWdpc3RlciAqLw0KPiArI2RlZmluZSBNVEtfU1RBUl9SRUdfVEVTVDAJ
CQkweDAwNTgNCj4gKyNkZWZpbmUgTVRLX1NUQVJfQklUX0lOVl9SWF9DTEsJCQlCSVQoMzApDQo+
ICsjZGVmaW5lIE1US19TVEFSX0JJVF9JTlZfVFhfQ0xLCQkJQklUKDMxKQ0KPiArDQo+ICAgLyog
TWlzYy4gQ29uZmlnIFJlZ2lzdGVyICovDQo+ICAgI2RlZmluZSBNVEtfU1RBUl9SRUdfVEVTVDEJ
CQkweDAwNWMNCj4gICAjZGVmaW5lIE1US19TVEFSX0JJVF9URVNUMV9SU1RfSEFTSF9NQklTVAlC
SVQoMzEpDQo+IEBAIC0yNjgsNiArMjczLDggQEAgc3RydWN0IG10a19zdGFyX3ByaXYgew0KPiAg
IAlpbnQgZHVwbGV4Ow0KPiAgIAlpbnQgcGF1c2U7DQo+ICAgCWJvb2wgcm1paV9yeGM7DQo+ICsJ
Ym9vbCByeF9pbnY7DQo+ICsJYm9vbCB0eF9pbnY7DQo+ICAgDQo+ICAgCWNvbnN0IHN0cnVjdCBt
dGtfc3Rhcl9jb21wYXQgKmNvbXBhdF9kYXRhOw0KPiAgIA0KPiBAQCAtMTQ1MCw2ICsxNDU3LDI1
IEBAIHN0YXRpYyB2b2lkIG10a19zdGFyX2Nsa19kaXNhYmxlX3VucHJlcGFyZSh2b2lkICpkYXRh
KQ0KPiAgIAljbGtfYnVsa19kaXNhYmxlX3VucHJlcGFyZShNVEtfU1RBUl9OQ0xLUywgcHJpdi0+
Y2xrcyk7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCBtdGtfc3Rhcl9zZXRfdGltaW5nKHN0
cnVjdCBtdGtfc3Rhcl9wcml2ICpwcml2KQ0KPiArew0KPiArCXN0cnVjdCBkZXZpY2UgKmRldiA9
IG10a19zdGFyX2dldF9kZXYocHJpdik7DQo+ICsJdW5zaWduZWQgaW50IGRlbGF5X3ZhbCA9IDA7
DQo+ICsNCj4gKwlzd2l0Y2ggKHByaXYtPnBoeV9pbnRmKSB7DQo+ICsJY2FzZSBQSFlfSU5URVJG
QUNFX01PREVfUk1JSToNCj4gKwkJZGVsYXlfdmFsIHw9IEZJRUxEX1BSRVAoTVRLX1NUQVJfQklU
X0lOVl9SWF9DTEssIHByaXYtPnJ4X2ludik7DQo+ICsJCWRlbGF5X3ZhbCB8PSBGSUVMRF9QUkVQ
KE1US19TVEFSX0JJVF9JTlZfVFhfQ0xLLCBwcml2LT50eF9pbnYpOw0KPiArCQlicmVhazsNCj4g
KwlkZWZhdWx0Og0KPiArCQlkZXZfZXJyKGRldiwgIlRoaXMgaW50ZXJmYWNlIG5vdCBzdXBwb3J0
ZWRcbiIpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlyZWdtYXBfd3Jp
dGUocHJpdi0+cmVncywgTVRLX1NUQVJfUkVHX1RFU1QwLCBkZWxheV92YWwpOw0KPiArDQo+ICsJ
cmV0dXJuIDA7DQo+ICt9DQo+ICAgc3RhdGljIGludCBtdGtfc3Rhcl9wcm9iZShzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIHsNCj4gICAJc3RydWN0IGRldmljZV9ub2RlICpvZl9u
b2RlOw0KPiBAQCAtMTUzMiw2ICsxNTU4LDggQEAgc3RhdGljIGludCBtdGtfc3Rhcl9wcm9iZShz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAl9DQo+ICAgDQo+ICAgCXByaXYtPnJt
aWlfcnhjID0gb2ZfcHJvcGVydHlfcmVhZF9ib29sKG9mX25vZGUsICJtZWRpYXRlayxybWlpLXJ4
YyIpOw0KPiArCXByaXYtPnJ4X2ludiA9IG9mX3Byb3BlcnR5X3JlYWRfYm9vbChvZl9ub2RlLCAi
bWVkaWF0ZWsscnhjLWludmVyc2UiKTsNCj4gKwlwcml2LT50eF9pbnYgPSBvZl9wcm9wZXJ0eV9y
ZWFkX2Jvb2wob2Zfbm9kZSwgIm1lZGlhdGVrLHR4Yy1pbnZlcnNlIik7DQo+ICAgDQo+ICAgCWlm
IChwcml2LT5jb21wYXRfZGF0YS0+c2V0X2ludGVyZmFjZV9tb2RlKSB7DQo+ICAgCQlyZXQgPSBw
cml2LT5jb21wYXRfZGF0YS0+c2V0X2ludGVyZmFjZV9tb2RlKG5kZXYpOw0KPiBAQCAtMTU0MSw2
ICsxNTY5LDEyIEBAIHN0YXRpYyBpbnQgbXRrX3N0YXJfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqcGRldikNCj4gICAJCX0NCj4gICAJfQ0KPiAgIA0KPiArCXJldCA9IG10a19zdGFyX3Nl
dF90aW1pbmcocHJpdik7DQo+ICsJaWYgKHJldCkgew0KPiArCQlkZXZfZXJyKGRldiwgIkZhaWxl
ZCB0byBzZXQgdGltaW5nLCBlcnIgPSAlZFxuIiwgcmV0KTsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsJfQ0KPiArDQo+ICAgCXJldCA9IGRtYV9zZXRfbWFza19hbmRfY29oZXJlbnQoZGV2LCBE
TUFfQklUX01BU0soMzIpKTsNCj4gICAJaWYgKHJldCkgew0KPiAgIAkJZGV2X2VycihkZXYsICJ1
bnN1cHBvcnRlZCBETUEgbWFza1xuIik7DQo+IA0KDQpSZXZpZXdlZC1ieTogTWFjcGF1bCBMaW4g
PG1hY3BhdWwubGluQG1lZGlhdGVrLmNvbT4NCg0KUmVnYXJkcywNCk1hY3BhdWwgTGlu

