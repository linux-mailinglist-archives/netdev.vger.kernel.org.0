Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDDFA69B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfKMCi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:38:56 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:4659 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727290AbfKMCiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:38:55 -0500
X-UUID: 8d99cfb1549144af845b27c7120d995d-20191113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=c0lf9YoTwyET62YRCT3bvlbcE7Psq0UHusE+Kdc19RM=;
        b=UQA66f4IIzFMixiw5U/TcGXFcc0XWD05OJ99LVi/jvFE0bwgyaJiJxDHW/wWx5xEwX0TRxJc4HYTmSQq4fR6TETcllDxC+s9rFJ9mebutPhs4q1BgRsO6LbRKekiayXibFI1PFttbF7xLHOPAQWnPayjOKNSG3rFSKIoKDZvEjo=;
X-UUID: 8d99cfb1549144af845b27c7120d995d-20191113
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 844890864; Wed, 13 Nov 2019 10:38:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
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
Subject: [PATCH net,v3 1/3] net: ethernet: mediatek: Integrate GDM/PSE setup operations
Date:   Wed, 13 Nov 2019 10:38:42 +0800
Message-ID: <20191113023844.17800-2-Mark-MC.Lee@mediatek.com>
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

SW50ZWdyYXRlIEdETS9QU0Ugc2V0dXAgb3BlcmF0aW9ucyBpbnRvIHNpbmdsZSBmdW5jdGlvbiAi
bXRrX2dkbV9jb25maWciDQoNClNpZ25lZC1vZmYtYnk6IE1hcmtMZWUgPE1hcmstTUMuTGVlQG1l
ZGlhdGVrLmNvbT4NCi0tDQp2MS0+djI6DQoqIFVzZSB0aGUgbWFjcm8gIk1US19NQUNfQ09VTlQi
IGluc3RlYWQgb2YgYSBtYWdpYyBjb25zdGFudA0KdjItPnYzOg0KKiBQdXQgc3BhY2VzIGJlZm9y
ZSBhbmQgYWZ0ZXIgdGhlIGNvbW1lbnQgc2VudGVuY2UNCg0KLS0tDQogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYyB8IDM3ICsrKysrKysrKysrKystLS0tLS0tLQ0K
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmggfCAgMSArDQogMiBm
aWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jDQppbmRleCA3MDNhZGI5NjQy
OWUuLjZlN2E3ZmVhMmY1MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlh
dGVrL210a19ldGhfc29jLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210
a19ldGhfc29jLmMNCkBAIC0yMTgwLDYgKzIxODAsMjggQEAgc3RhdGljIGludCBtdGtfc3RhcnRf
ZG1hKHN0cnVjdCBtdGtfZXRoICpldGgpDQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdm9p
ZCBtdGtfZ2RtX2NvbmZpZyhzdHJ1Y3QgbXRrX2V0aCAqZXRoLCB1MzIgY29uZmlnKQ0KK3sNCisJ
aW50IGk7DQorDQorCWZvciAoaSA9IDA7IGkgPCBNVEtfTUFDX0NPVU5UOyBpKyspIHsNCisJCXUz
MiB2YWwgPSBtdGtfcjMyKGV0aCwgTVRLX0dETUFfRldEX0NGRyhpKSk7DQorDQorCQkvKiBkZWZh
dWx0IHNldHVwIHRoZSBmb3J3YXJkIHBvcnQgdG8gc2VuZCBmcmFtZSB0byBQRE1BICovDQorCQl2
YWwgJj0gfjB4ZmZmZjsNCisNCisJCS8qIEVuYWJsZSBSWCBjaGVja3N1bSAqLw0KKwkJdmFsIHw9
IE1US19HRE1BX0lDU19FTiB8IE1US19HRE1BX1RDU19FTiB8IE1US19HRE1BX1VDU19FTjsNCisN
CisJCXZhbCB8PSBjb25maWc7DQorDQorCQltdGtfdzMyKGV0aCwgdmFsLCBNVEtfR0RNQV9GV0Rf
Q0ZHKGkpKTsNCisJfQ0KKwkvKiBSZXNldCBhbmQgZW5hYmxlIFBTRSAqLw0KKwltdGtfdzMyKGV0
aCwgUlNUX0dMX1BTRSwgTVRLX1JTVF9HTCk7DQorCW10a193MzIoZXRoLCAwLCBNVEtfUlNUX0dM
KTsNCit9DQorDQogc3RhdGljIGludCBtdGtfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0K
IHsNCiAJc3RydWN0IG10a19tYWMgKm1hYyA9IG5ldGRldl9wcml2KGRldik7DQpAQCAtMjM3NSw4
ICsyMzk3LDYgQEAgc3RhdGljIGludCBtdGtfaHdfaW5pdChzdHJ1Y3QgbXRrX2V0aCAqZXRoKQ0K
IAltdGtfdzMyKGV0aCwgMCwgTVRLX1FETUFfREVMQVlfSU5UKTsNCiAJbXRrX3R4X2lycV9kaXNh
YmxlKGV0aCwgfjApOw0KIAltdGtfcnhfaXJxX2Rpc2FibGUoZXRoLCB+MCk7DQotCW10a193MzIo
ZXRoLCBSU1RfR0xfUFNFLCBNVEtfUlNUX0dMKTsNCi0JbXRrX3czMihldGgsIDAsIE1US19SU1Rf
R0wpOw0KIA0KIAkvKiBGRSBpbnQgZ3JvdXBpbmcgKi8NCiAJbXRrX3czMihldGgsIE1US19UWF9E
T05FX0lOVCwgTVRLX1BETUFfSU5UX0dSUDEpOw0KQEAgLTIzODUsMTggKzI0MDUsNyBAQCBzdGF0
aWMgaW50IG10a19od19pbml0KHN0cnVjdCBtdGtfZXRoICpldGgpDQogCW10a193MzIoZXRoLCBN
VEtfUlhfRE9ORV9JTlQsIE1US19RRE1BX0lOVF9HUlAyKTsNCiAJbXRrX3czMihldGgsIDB4MjEw
MjEwMDAsIE1US19GRV9JTlRfR1JQKTsNCiANCi0JZm9yIChpID0gMDsgaSA8IE1US19NQUNfQ09V
TlQ7IGkrKykgew0KLQkJdTMyIHZhbCA9IG10a19yMzIoZXRoLCBNVEtfR0RNQV9GV0RfQ0ZHKGkp
KTsNCi0NCi0JCS8qIHNldHVwIHRoZSBmb3J3YXJkIHBvcnQgdG8gc2VuZCBmcmFtZSB0byBQRE1B
ICovDQotCQl2YWwgJj0gfjB4ZmZmZjsNCi0NCi0JCS8qIEVuYWJsZSBSWCBjaGVja3N1bSAqLw0K
LQkJdmFsIHw9IE1US19HRE1BX0lDU19FTiB8IE1US19HRE1BX1RDU19FTiB8IE1US19HRE1BX1VD
U19FTjsNCi0NCi0JCS8qIHNldHVwIHRoZSBtYWMgZG1hICovDQotCQltdGtfdzMyKGV0aCwgdmFs
LCBNVEtfR0RNQV9GV0RfQ0ZHKGkpKTsNCi0JfQ0KKwltdGtfZ2RtX2NvbmZpZyhldGgsIE1US19H
RE1BX1RPX1BETUEpOw0KIA0KIAlyZXR1cm4gMDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVkaWF0ZWsvbXRrX2V0aF9zb2MuaA0KaW5kZXggNzZiZDEyY2I4MTUwLi5iMTZkOGQ5YjE5NmEg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5o
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oDQpAQCAt
ODQsNiArODQsNyBAQA0KICNkZWZpbmUgTVRLX0dETUFfSUNTX0VOCQlCSVQoMjIpDQogI2RlZmlu
ZSBNVEtfR0RNQV9UQ1NfRU4JCUJJVCgyMSkNCiAjZGVmaW5lIE1US19HRE1BX1VDU19FTgkJQklU
KDIwKQ0KKyNkZWZpbmUgTVRLX0dETUFfVE9fUERNQQkweDANCiANCiAvKiBVbmljYXN0IEZpbHRl
ciBNQUMgQWRkcmVzcyBSZWdpc3RlciAtIExvdyAqLw0KICNkZWZpbmUgTVRLX0dETUFfTUFDX0FE
UkwoeCkJKDB4NTA4ICsgKHggKiAweDEwMDApKQ0KLS0gDQoyLjE3LjENCg==

