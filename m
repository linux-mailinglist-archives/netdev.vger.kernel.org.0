Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CD22558E9
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgH1Kw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:52:58 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:46331 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728362AbgH1Kww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:52:52 -0400
X-UUID: 9b16ef4c94214323863de48c3da9b76b-20200828
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=FZ0PPk8gVzEhQ1IFGUZY31/TpdulCQ+QsyJk9Jc/ChY=;
        b=WCKrcph+tb8D24tBlts4SXbaR4ff+/OYPgQj43iu1m8ha6oLVsWDeC8lPNe77WH/WAQfqIcJMN/3SyvCBIFqTNXxoU8vgNZs3F6ot2bYoegHrweVLaCSRgiwGpKq7t2AhbsaF1hry3YlX6iDE9A8NfNiOheXF6SMOqfs1Kt5jt0=;
X-UUID: 9b16ef4c94214323863de48c3da9b76b-20200828
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1714428886; Fri, 28 Aug 2020 18:52:48 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 Aug 2020 18:52:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 Aug 2020 18:52:45 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     <opensource@vdorst.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <frank-w@public-files.de>,
        <dqfext@gmail.com>, Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net v2] net: dsa: mt7530: fix advertising unsupported 1000baseT_Half
Date:   Fri, 28 Aug 2020 18:52:44 +0800
Message-ID: <20200828105244.9839-1-landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIDEwMDBiYXNlVF9IYWxmIHRvIGFkdmVydGlzZSBjb3JyZWN0IGhhcmR3YXJlIGNhcGFi
aWxpdHkgaW4NCnBoeWxpbmtfdmFsaWRhdGUoKSBjYWxsYmFjayBmdW5jdGlvbi4NCg0KRml4ZXM6
IDM4Zjc5MGE4MDU2MCAoIm5ldDogZHNhOiBtdDc1MzA6IEFkZCBzdXBwb3J0IGZvciBwb3J0IDUi
KQ0KU2lnbmVkLW9mZi1ieTogTGFuZGVuIENoYW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4N
ClJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQpSZXZpZXdlZC1ieTog
RmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQotLS0NCnYxLT52Mg0KICAt
IGZpeCB0aGUgY29tbWl0IHN1YmplY3Qgc3BpbGxlZCBpbnRvIHRoZSBjb21taXQgbWVzc2FnZQ0K
LS0tDQogZHJpdmVycy9uZXQvZHNhL210NzUzMC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZHNhL210NzUzMC5jIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQppbmRleCA4ZGNiOGE0OWFi
NjcuLjIzODQxN2RiMjZmOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0K
KysrIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQpAQCAtMTUwMSw3ICsxNTAxLDcgQEAgc3Rh
dGljIHZvaWQgbXQ3NTMwX3BoeWxpbmtfdmFsaWRhdGUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBp
bnQgcG9ydCwNCiAJCXBoeWxpbmtfc2V0KG1hc2ssIDEwMGJhc2VUX0Z1bGwpOw0KIA0KIAkJaWYg
KHN0YXRlLT5pbnRlcmZhY2UgIT0gUEhZX0lOVEVSRkFDRV9NT0RFX01JSSkgew0KLQkJCXBoeWxp
bmtfc2V0KG1hc2ssIDEwMDBiYXNlVF9IYWxmKTsNCisJCQkvKiBUaGlzIHN3aXRjaCBvbmx5IHN1
cHBvcnRzIDFHIGZ1bGwtZHVwbGV4LiAqLw0KIAkJCXBoeWxpbmtfc2V0KG1hc2ssIDEwMDBiYXNl
VF9GdWxsKTsNCiAJCQlpZiAocG9ydCA9PSA1KQ0KIAkJCQlwaHlsaW5rX3NldChtYXNrLCAxMDAw
YmFzZVhfRnVsbCk7DQotLSANCjIuMTcuMQ0K

