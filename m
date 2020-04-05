Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977D519EE52
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 23:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgDEVnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 17:43:11 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57599 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726887AbgDEVnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 17:43:11 -0400
X-UUID: 5a9b77c3b4a34741ba45ff9529a91eae-20200406
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ykXJOg+MvDEO7S3FZP+B/VvjET2n99Rmo5Cho9/ZgpU=;
        b=gRTssLRKXrFy0OgrWpjs8H26qsP0+ZTDpbOcTyDRX/5Z2LfivujVghPTcEjH4155zYsovdKMJ0O+R/u5rfji7IGyckyuAQzspBiJ/GCde3KPmMm+tZS93LHwOuwBEGsSo/o62C/XVBgriqFQ8MZYONu7v6cgIZa5VFxPMgrwYus=;
X-UUID: 5a9b77c3b4a34741ba45ff9529a91eae-20200406
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 600928693; Mon, 06 Apr 2020 05:43:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 6 Apr 2020 05:42:54 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Apr 2020 05:42:54 +0800
From:   <sean.wang@mediatek.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <Mark-MC.Lee@mediatek.com>,
        <john@phrozen.org>
CC:     <Landen.Chao@mediatek.com>, <steven.liu@mediatek.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH v2 net 2/2] net: ethernet: mediatek: move mt7623 settings out off the mt7530
Date:   Mon, 6 Apr 2020 05:42:54 +0800
Message-ID: <1586122974-22125-2-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1586122974-22125-1-git-send-email-sean.wang@mediatek.com>
References: <1586122974-22125-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmVuw6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3JzdC5jb20+DQoNCk1vdmluZyBt
dDc2MjMgbG9naWMgb3V0IG9mZiBtdDc1MzAsIGlzIHJlcXVpcmVkIHRvIG1ha2UgaGFyZHdhcmUg
c2V0dGluZw0KY29uc2lzdGVudCBhZnRlciB3ZSBpbnRyb2R1Y2UgcGh5bGluayB0byBtdGsgZHJp
dmVyLg0KDQpGaXhlczogYjhmYzlmMzA4MjFlICgibmV0OiBldGhlcm5ldDogbWVkaWF0ZWs6IEFk
ZCBiYXNpYyBQSFlMSU5LIHN1cHBvcnQiKQ0KUmV2aWV3ZWQtYnk6IFNlYW4gV2FuZyA8c2Vhbi53
YW5nQG1lZGlhdGVrLmNvbT4NClRlc3RlZC1ieTogU2VhbiBXYW5nIDxzZWFuLndhbmdAbWVkaWF0
ZWsuY29tPg0KU2lnbmVkLW9mZi1ieTogUmVuw6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3Jz
dC5jb20+DQotLS0NCnYxIC0+IHYyOiBzcGxpdCBvdXQgbG9naWMgY2hhbmdpbmcgbXRrX2dtYWMw
X3JnbWlpX2FkanVzdCB0aGF0IHNob3VsZCBiZQ0KCSAgcmVmaW5lZCBmdXJ0aGVyIGFuZCBhY3R1
YWx5IGJlbG9uZ2VkIHRvIHNlcGFyYXRlIHBhdGNoLg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYyB8IDI0ICsrKysrKysrKysrKysrKysrKysrLQ0KIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmggfCAgOCArKysrKysrDQog
MiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYw0KaW5kZXggOGQyOGY5MGFj
ZmU3Li4wOTA0NzEwOWQwZGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRp
YXRlay9tdGtfZXRoX3NvYy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9t
dGtfZXRoX3NvYy5jDQpAQCAtNjUsNiArNjUsMTcgQEAgdTMyIG10a19yMzIoc3RydWN0IG10a19l
dGggKmV0aCwgdW5zaWduZWQgcmVnKQ0KIAlyZXR1cm4gX19yYXdfcmVhZGwoZXRoLT5iYXNlICsg
cmVnKTsNCiB9DQogDQordTMyIG10a19tMzIoc3RydWN0IG10a19ldGggKmV0aCwgdTMyIG1hc2ss
IHUzMiBzZXQsIHVuc2lnbmVkIHJlZykNCit7DQorCXUzMiB2YWw7DQorDQorCXZhbCA9IG10a19y
MzIoZXRoLCByZWcpOw0KKwl2YWwgJj0gfm1hc2s7DQorCXZhbCB8PSBzZXQ7DQorCW10a193MzIo
ZXRoLCB2YWwsIHJlZyk7DQorCXJldHVybiByZWc7DQorfQ0KKw0KIHN0YXRpYyBpbnQgbXRrX21k
aW9fYnVzeV93YWl0KHN0cnVjdCBtdGtfZXRoICpldGgpDQogew0KIAl1bnNpZ25lZCBsb25nIHRf
c3RhcnQgPSBqaWZmaWVzOw0KQEAgLTE5Myw3ICsyMDQsNyBAQCBzdGF0aWMgdm9pZCBtdGtfbWFj
X2NvbmZpZyhzdHJ1Y3QgcGh5bGlua19jb25maWcgKmNvbmZpZywgdW5zaWduZWQgaW50IG1vZGUs
DQogCXN0cnVjdCBtdGtfbWFjICptYWMgPSBjb250YWluZXJfb2YoY29uZmlnLCBzdHJ1Y3QgbXRr
X21hYywNCiAJCQkJCSAgIHBoeWxpbmtfY29uZmlnKTsNCiAJc3RydWN0IG10a19ldGggKmV0aCA9
IG1hYy0+aHc7DQotCXUzMiBtY3JfY3VyLCBtY3JfbmV3LCBzaWQ7DQorCXUzMiBtY3JfY3VyLCBt
Y3JfbmV3LCBzaWQsIGk7DQogCWludCB2YWwsIGdlX21vZGUsIGVycjsNCiANCiAJLyogTVQ3Nng4
IGhhcyBubyBoYXJkd2FyZSBzZXR0aW5ncyBiZXR3ZWVuIGZvciB0aGUgTUFDICovDQpAQCAtMjU1
LDYgKzI2NiwxNyBAQCBzdGF0aWMgdm9pZCBtdGtfbWFjX2NvbmZpZyhzdHJ1Y3QgcGh5bGlua19j
b25maWcgKmNvbmZpZywgdW5zaWduZWQgaW50IG1vZGUsDQogCQkJCSAgICBQSFlfSU5URVJGQUNF
X01PREVfVFJHTUlJKQ0KIAkJCQkJbXRrX2dtYWMwX3JnbWlpX2FkanVzdChtYWMtPmh3LA0KIAkJ
CQkJCQkgICAgICAgc3RhdGUtPnNwZWVkKTsNCisNCisJCQkJLyogbXQ3NjIzX3BhZF9jbGtfc2V0
dXAgKi8NCisJCQkJZm9yIChpID0gMCA7IGkgPCBOVU1fVFJHTUlJX0NUUkw7IGkrKykNCisJCQkJ
CW10a193MzIobWFjLT5odywNCisJCQkJCQlURF9ETV9EUlZQKDgpIHwgVERfRE1fRFJWTig4KSwN
CisJCQkJCQlUUkdNSUlfVERfT0RUKGkpKTsNCisNCisJCQkJLyogQXNzZXJ0L3JlbGVhc2UgTVQ3
NjIzIFJYQyByZXNldCAqLw0KKwkJCQltdGtfbTMyKG1hYy0+aHcsIDAsIFJYQ19SU1QgfCBSWENf
RFFTSVNFTCwNCisJCQkJCVRSR01JSV9SQ0tfQ1RSTCk7DQorCQkJCW10a19tMzIobWFjLT5odywg
UlhDX1JTVCwgMCwgVFJHTUlJX1JDS19DVFJMKTsNCiAJCQl9DQogCQl9DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuaCBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmgNCmluZGV4IDg1ODMwZmUxNGExYi4u
NDU0Y2ZjZDQ2NWZkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsv
bXRrX2V0aF9zb2MuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0
aF9zb2MuaA0KQEAgLTM1MiwxMCArMzUyLDEzIEBADQogI2RlZmluZSBEUVNJMCh4KQkJKCh4IDw8
IDApICYgR0VOTUFTSyg2LCAwKSkNCiAjZGVmaW5lIERRU0kxKHgpCQkoKHggPDwgOCkgJiBHRU5N
QVNLKDE0LCA4KSkNCiAjZGVmaW5lIFJYQ1RMX0RNV1RMQVQoeCkJKCh4IDw8IDE2KSAmIEdFTk1B
U0soMTgsIDE2KSkNCisjZGVmaW5lIFJYQ19SU1QJCQlCSVQoMzEpDQogI2RlZmluZSBSWENfRFFT
SVNFTAkJQklUKDMwKQ0KICNkZWZpbmUgUkNLX0NUUkxfUkdNSUlfMTAwMAkoUlhDX0RRU0lTRUwg
fCBSWENUTF9ETVdUTEFUKDIpIHwgRFFTSTEoMTYpKQ0KICNkZWZpbmUgUkNLX0NUUkxfUkdNSUlf
MTBfMTAwCVJYQ1RMX0RNV1RMQVQoMikNCiANCisjZGVmaW5lIE5VTV9UUkdNSUlfQ1RSTAkJNQ0K
Kw0KIC8qIFRSR01JSSBSWEMgY29udHJvbCByZWdpc3RlciAqLw0KICNkZWZpbmUgVFJHTUlJX1RD
S19DVFJMCQkweDEwMzQwDQogI2RlZmluZSBUWENUTF9ETVdUTEFUKHgpCSgoeCA8PCAxNikgJiBH
RU5NQVNLKDE4LCAxNikpDQpAQCAtMzYzLDYgKzM2NiwxMSBAQA0KICNkZWZpbmUgVENLX0NUUkxf
UkdNSUlfMTAwMAlUWENUTF9ETVdUTEFUKDIpDQogI2RlZmluZSBUQ0tfQ1RSTF9SR01JSV8xMF8x
MDAJKFRYQ19JTlYgfCBUWENUTF9ETVdUTEFUKDIpKQ0KIA0KKy8qIFRSR01JSSBUWCBEcml2ZSBT
dHJlbmd0aCAqLw0KKyNkZWZpbmUgVFJHTUlJX1REX09EVChpKQkoMHgxMDM1NCArIDggKiAoaSkp
DQorI2RlZmluZSAgVERfRE1fRFJWUCh4KQkJKCh4KSAmIDB4ZikNCisjZGVmaW5lICBURF9ETV9E
UlZOKHgpCQkoKCh4KSAmIDB4ZikgPDwgNCkNCisNCiAvKiBUUkdNSUkgSW50ZXJmYWNlIG1vZGUg
cmVnaXN0ZXIgKi8NCiAjZGVmaW5lIElOVEZfTU9ERQkJMHgxMDM5MA0KICNkZWZpbmUgVFJHTUlJ
X0lOVEZfRElTCQlCSVQoMCkNCi0tIA0KMi4yNS4xDQo=

