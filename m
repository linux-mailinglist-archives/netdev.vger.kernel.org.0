Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1366CFA69D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfKMCix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:38:53 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:46451 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727077AbfKMCix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:38:53 -0500
X-UUID: 83eda557620c437bb945218c99a06319-20191113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=+FkK1iCNCZ5mbqNEG+dK1JRhB0qOI3mgu4fpv9haJ5A=;
        b=Prlhh6GWfSTm3Q7qUu1xmtjE6bn56CvpBeDIDiwkbJWcm5aAKFkJ095PbTG9l0rOo/iglGjkzyOZ4L8kq9foblSIbcB/U8uNTnGZC/FUUfwD51zLguy4/CvLoX8n5N9F3zkxh2CmmmGwEKu1RaTftTq7b/J2PoO9Q3WTQnlo0O8=;
X-UUID: 83eda557620c437bb945218c99a06319-20191113
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 761743743; Wed, 13 Nov 2019 10:38:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Nov 2019 10:38:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 13 Nov 2019 10:38:44 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v3 2/3] net: ethernet: mediatek: Refine the timing of GDM/PSE setup
Date:   Wed, 13 Nov 2019 10:38:43 +0800
Message-ID: <20191113023844.17800-3-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
References: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVmaW5lIHRoZSB0aW1pbmcgb2YgR0RNL1BTRSBzZXR1cCwgbW92ZSBpdCBmcm9tIG10a19od19p
bml0IA0KdG8gbXRrX29wZW4uIFRoaXMgaXMgcmVjb21tZW5kZWQgYnkgdGhlIG10NzYyeCBIVyBk
ZXNpZ24gdG8gDQpkbyBHRE0vUFNFIHNldHVwIG9ubHkgYWZ0ZXIgUERNQSBoYXMgYmVlbiBzdGFy
dGVkLg0KDQpXZSBleGNsdWRlIG10NzYyOCBpbiBtdGtfZ2RtX2NvbmZpZyBmdW5jdGlvbiBzaW5j
ZSBpdCBpcyBhIG9sZCBJUCANCmFuZCB0aGVyZSBpcyBubyBHRE0vUFNFIGJsb2NrIG9uIGl0Lg0K
DQpTaWduZWQtb2ZmLWJ5OiBNYXJrTGVlIDxNYXJrLU1DLkxlZUBtZWRpYXRlay5jb20+DQotLQ0K
djEtPnYyOg0KKiBubyBjaGFuZ2UNCnYyLT52MzoNCiogbm8gY2hhbmdlDQoNCi0tLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMgfCA3ICsrKysrLS0NCiAxIGZp
bGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMNCmluZGV4IDZlN2E3ZmVhMmY1Mi4u
YjE0N2FiMGU0NGNlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsv
bXRrX2V0aF9zb2MuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0
aF9zb2MuYw0KQEAgLTIxODQsNiArMjE4NCw5IEBAIHN0YXRpYyB2b2lkIG10a19nZG1fY29uZmln
KHN0cnVjdCBtdGtfZXRoICpldGgsIHUzMiBjb25maWcpDQogew0KIAlpbnQgaTsNCiANCisJaWYg
KE1US19IQVNfQ0FQUyhldGgtPnNvYy0+Y2FwcywgTVRLX1NPQ19NVDc2MjgpKQ0KKwkJcmV0dXJu
Ow0KKw0KIAlmb3IgKGkgPSAwOyBpIDwgTVRLX01BQ19DT1VOVDsgaSsrKSB7DQogCQl1MzIgdmFs
ID0gbXRrX3IzMihldGgsIE1US19HRE1BX0ZXRF9DRkcoaSkpOw0KIA0KQEAgLTIyMjIsNiArMjIy
NSw4IEBAIHN0YXRpYyBpbnQgbXRrX29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJCWlm
IChlcnIpDQogCQkJcmV0dXJuIGVycjsNCiANCisJCW10a19nZG1fY29uZmlnKGV0aCwgTVRLX0dE
TUFfVE9fUERNQSk7DQorDQogCQluYXBpX2VuYWJsZSgmZXRoLT50eF9uYXBpKTsNCiAJCW5hcGlf
ZW5hYmxlKCZldGgtPnJ4X25hcGkpOw0KIAkJbXRrX3R4X2lycV9lbmFibGUoZXRoLCBNVEtfVFhf
RE9ORV9JTlQpOw0KQEAgLTI0MDUsOCArMjQxMCw2IEBAIHN0YXRpYyBpbnQgbXRrX2h3X2luaXQo
c3RydWN0IG10a19ldGggKmV0aCkNCiAJbXRrX3czMihldGgsIE1US19SWF9ET05FX0lOVCwgTVRL
X1FETUFfSU5UX0dSUDIpOw0KIAltdGtfdzMyKGV0aCwgMHgyMTAyMTAwMCwgTVRLX0ZFX0lOVF9H
UlApOw0KIA0KLQltdGtfZ2RtX2NvbmZpZyhldGgsIE1US19HRE1BX1RPX1BETUEpOw0KLQ0KIAly
ZXR1cm4gMDsNCiANCiBlcnJfZGlzYWJsZV9wbToNCi0tIA0KMi4xNy4xDQo=

