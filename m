Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F09F6EAA
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKKGvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:51:43 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:48916 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbfKKGvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:51:43 -0500
X-UUID: d08ea3988874412c902909e8163314be-20191111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=qynSAl3x/VKKJ0ZHs5xhmevf9UQ9FCm09E5Yqh7E/2A=;
        b=lcSBSZ8sDEl/en6EXHmRXDhqKN8UIdGXWWI9Nr/uvsuJF5awNFuqxiel/Uz0irD4KKZ1Cmp8SqcKtTQP50Hlm6PRZ+3QGJYECUz27DZkz/VgIe5RBPdnm5x1dy1oKDfbUQErhmRDX2Ew2o1CtpXrGv4mZMWvXtk+q9I5wR1rDn8=;
X-UUID: d08ea3988874412c902909e8163314be-20191111
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1344096099; Mon, 11 Nov 2019 14:51:39 +0800
Received: from mtkmbs05dr.mediatek.inc (172.21.101.97) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 11 Nov 2019 14:51:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05dr.mediatek.inc (172.21.101.97) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 11 Nov 2019 14:51:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 11 Nov 2019 14:51:28 +0800
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
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v2 1/3] net: ethernet: mediatek: Integrate GDM/PSE setup operations
Date:   Mon, 11 Nov 2019 14:51:27 +0800
Message-ID: <20191111065129.30078-2-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
References: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
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
IGluc3RlYWQgb2YgYSBtYWdpYyBjb25zdGFudA0KDQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jIHwgMzcgKysrKysrKysrKysrKy0tLS0tLS0tDQogZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuaCB8ICAxICsNCiAyIGZpbGVz
IGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMNCmluZGV4IDcwM2FkYjk2NDI5ZS4u
NmU3YTdmZWEyZjUyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsv
bXRrX2V0aF9zb2MuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0
aF9zb2MuYw0KQEAgLTIxODAsNiArMjE4MCwyOCBAQCBzdGF0aWMgaW50IG10a19zdGFydF9kbWEo
c3RydWN0IG10a19ldGggKmV0aCkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIG10
a19nZG1fY29uZmlnKHN0cnVjdCBtdGtfZXRoICpldGgsIHUzMiBjb25maWcpDQorew0KKwlpbnQg
aTsNCisNCisJZm9yIChpID0gMDsgaSA8IE1US19NQUNfQ09VTlQ7IGkrKykgew0KKwkJdTMyIHZh
bCA9IG10a19yMzIoZXRoLCBNVEtfR0RNQV9GV0RfQ0ZHKGkpKTsNCisNCisJCS8qIGRlZmF1bHQg
c2V0dXAgdGhlIGZvcndhcmQgcG9ydCB0byBzZW5kIGZyYW1lIHRvIFBETUEgKi8NCisJCXZhbCAm
PSB+MHhmZmZmOw0KKw0KKwkJLyogRW5hYmxlIFJYIGNoZWNrc3VtICovDQorCQl2YWwgfD0gTVRL
X0dETUFfSUNTX0VOIHwgTVRLX0dETUFfVENTX0VOIHwgTVRLX0dETUFfVUNTX0VOOw0KKw0KKwkJ
dmFsIHw9IGNvbmZpZzsNCisNCisJCW10a193MzIoZXRoLCB2YWwsIE1US19HRE1BX0ZXRF9DRkco
aSkpOw0KKwl9DQorCS8qUmVzZXQgYW5kIGVuYWJsZSBQU0UqLw0KKwltdGtfdzMyKGV0aCwgUlNU
X0dMX1BTRSwgTVRLX1JTVF9HTCk7DQorCW10a193MzIoZXRoLCAwLCBNVEtfUlNUX0dMKTsNCit9
DQorDQogc3RhdGljIGludCBtdGtfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCiAJ
c3RydWN0IG10a19tYWMgKm1hYyA9IG5ldGRldl9wcml2KGRldik7DQpAQCAtMjM3NSw4ICsyMzk3
LDYgQEAgc3RhdGljIGludCBtdGtfaHdfaW5pdChzdHJ1Y3QgbXRrX2V0aCAqZXRoKQ0KIAltdGtf
dzMyKGV0aCwgMCwgTVRLX1FETUFfREVMQVlfSU5UKTsNCiAJbXRrX3R4X2lycV9kaXNhYmxlKGV0
aCwgfjApOw0KIAltdGtfcnhfaXJxX2Rpc2FibGUoZXRoLCB+MCk7DQotCW10a193MzIoZXRoLCBS
U1RfR0xfUFNFLCBNVEtfUlNUX0dMKTsNCi0JbXRrX3czMihldGgsIDAsIE1US19SU1RfR0wpOw0K
IA0KIAkvKiBGRSBpbnQgZ3JvdXBpbmcgKi8NCiAJbXRrX3czMihldGgsIE1US19UWF9ET05FX0lO
VCwgTVRLX1BETUFfSU5UX0dSUDEpOw0KQEAgLTIzODUsMTggKzI0MDUsNyBAQCBzdGF0aWMgaW50
IG10a19od19pbml0KHN0cnVjdCBtdGtfZXRoICpldGgpDQogCW10a193MzIoZXRoLCBNVEtfUlhf
RE9ORV9JTlQsIE1US19RRE1BX0lOVF9HUlAyKTsNCiAJbXRrX3czMihldGgsIDB4MjEwMjEwMDAs
IE1US19GRV9JTlRfR1JQKTsNCiANCi0JZm9yIChpID0gMDsgaSA8IE1US19NQUNfQ09VTlQ7IGkr
Kykgew0KLQkJdTMyIHZhbCA9IG10a19yMzIoZXRoLCBNVEtfR0RNQV9GV0RfQ0ZHKGkpKTsNCi0N
Ci0JCS8qIHNldHVwIHRoZSBmb3J3YXJkIHBvcnQgdG8gc2VuZCBmcmFtZSB0byBQRE1BICovDQot
CQl2YWwgJj0gfjB4ZmZmZjsNCi0NCi0JCS8qIEVuYWJsZSBSWCBjaGVja3N1bSAqLw0KLQkJdmFs
IHw9IE1US19HRE1BX0lDU19FTiB8IE1US19HRE1BX1RDU19FTiB8IE1US19HRE1BX1VDU19FTjsN
Ci0NCi0JCS8qIHNldHVwIHRoZSBtYWMgZG1hICovDQotCQltdGtfdzMyKGV0aCwgdmFsLCBNVEtf
R0RNQV9GV0RfQ0ZHKGkpKTsNCi0JfQ0KKwltdGtfZ2RtX2NvbmZpZyhldGgsIE1US19HRE1BX1RP
X1BETUEpOw0KIA0KIAlyZXR1cm4gMDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0
ZWsvbXRrX2V0aF9zb2MuaA0KaW5kZXggNzZiZDEyY2I4MTUwLi5iMTZkOGQ5YjE5NmEgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oDQorKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oDQpAQCAtODQsNiAr
ODQsNyBAQA0KICNkZWZpbmUgTVRLX0dETUFfSUNTX0VOCQlCSVQoMjIpDQogI2RlZmluZSBNVEtf
R0RNQV9UQ1NfRU4JCUJJVCgyMSkNCiAjZGVmaW5lIE1US19HRE1BX1VDU19FTgkJQklUKDIwKQ0K
KyNkZWZpbmUgTVRLX0dETUFfVE9fUERNQQkweDANCiANCiAvKiBVbmljYXN0IEZpbHRlciBNQUMg
QWRkcmVzcyBSZWdpc3RlciAtIExvdyAqLw0KICNkZWZpbmUgTVRLX0dETUFfTUFDX0FEUkwoeCkJ
KDB4NTA4ICsgKHggKiAweDEwMDApKQ0KLS0gDQoyLjE3LjENCg==

