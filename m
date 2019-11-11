Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A240F6EB2
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKKGv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:51:56 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:4602 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726805AbfKKGvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:51:42 -0500
X-UUID: ebc816981ef245a2b83e6be5183770e4-20191111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8DZXC9OgCubLyvcHX6zcSZIiSemKV30qErQHPEzAXD4=;
        b=gd9eTsmHR5Bd8o/6qggdU/JXIYnJCbvdeZVtIoqWohI+VJ7WlsWcmE4Z9NVn7u8htn1nYVHa5zL+YY87DOm5HbNYWJIVWqQ/5t94Ic7llXU1LHNhcjvL8x3S8qr6ZVOim3mpUswi3f/QPQyrQ97nLtei+O8JHkkS1spdN9xw91U=;
X-UUID: ebc816981ef245a2b83e6be5183770e4-20191111
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1752179825; Mon, 11 Nov 2019 14:51:32 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
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
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v2 2/3] net: ethernet: mediatek: Refine the timing of GDM/PSE setup
Date:   Mon, 11 Nov 2019 14:51:28 +0800
Message-ID: <20191111065129.30078-3-Mark-MC.Lee@mediatek.com>
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

UmVmaW5lIHRoZSB0aW1pbmcgb2YgR0RNL1BTRSBzZXR1cCwgbW92ZSBpdCBmcm9tIG10a19od19p
bml0IA0KdG8gbXRrX29wZW4uIFRoaXMgaXMgcmVjb21tZW5kZWQgYnkgdGhlIG10NzYyeCBIVyBk
ZXNpZ24gdG8gDQpkbyBHRE0vUFNFIHNldHVwIG9ubHkgYWZ0ZXIgUERNQSBoYXMgYmVlbiBzdGFy
dGVkLg0KDQpXZSBleGNsdWRlIG10NzYyOCBpbiBtdGtfZ2RtX2NvbmZpZyBmdW5jdGlvbiBzaW5j
ZSBpdCBpcyBhIG9sZCBJUCANCmFuZCB0aGVyZSBpcyBubyBHRE0vUFNFIGJsb2NrIG9uIGl0Lg0K
DQpTaWduZWQtb2ZmLWJ5OiBNYXJrTGVlIDxNYXJrLU1DLkxlZUBtZWRpYXRlay5jb20+DQotLQ0K
djEtPnYyOg0KKiBubyBjaGFuZ2UNCg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0
ZWsvbXRrX2V0aF9zb2MuYyB8IDcgKysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsv
bXRrX2V0aF9zb2MuYw0KaW5kZXggNmU3YTdmZWEyZjUyLi5iMTQ3YWIwZTQ0Y2UgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jDQpAQCAtMjE4NCw2ICsy
MTg0LDkgQEAgc3RhdGljIHZvaWQgbXRrX2dkbV9jb25maWcoc3RydWN0IG10a19ldGggKmV0aCwg
dTMyIGNvbmZpZykNCiB7DQogCWludCBpOw0KIA0KKwlpZiAoTVRLX0hBU19DQVBTKGV0aC0+c29j
LT5jYXBzLCBNVEtfU09DX01UNzYyOCkpDQorCQlyZXR1cm47DQorDQogCWZvciAoaSA9IDA7IGkg
PCBNVEtfTUFDX0NPVU5UOyBpKyspIHsNCiAJCXUzMiB2YWwgPSBtdGtfcjMyKGV0aCwgTVRLX0dE
TUFfRldEX0NGRyhpKSk7DQogDQpAQCAtMjIyMiw2ICsyMjI1LDggQEAgc3RhdGljIGludCBtdGtf
b3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIAkJaWYgKGVycikNCiAJCQlyZXR1cm4gZXJy
Ow0KIA0KKwkJbXRrX2dkbV9jb25maWcoZXRoLCBNVEtfR0RNQV9UT19QRE1BKTsNCisNCiAJCW5h
cGlfZW5hYmxlKCZldGgtPnR4X25hcGkpOw0KIAkJbmFwaV9lbmFibGUoJmV0aC0+cnhfbmFwaSk7
DQogCQltdGtfdHhfaXJxX2VuYWJsZShldGgsIE1US19UWF9ET05FX0lOVCk7DQpAQCAtMjQwNSw4
ICsyNDEwLDYgQEAgc3RhdGljIGludCBtdGtfaHdfaW5pdChzdHJ1Y3QgbXRrX2V0aCAqZXRoKQ0K
IAltdGtfdzMyKGV0aCwgTVRLX1JYX0RPTkVfSU5ULCBNVEtfUURNQV9JTlRfR1JQMik7DQogCW10
a193MzIoZXRoLCAweDIxMDIxMDAwLCBNVEtfRkVfSU5UX0dSUCk7DQogDQotCW10a19nZG1fY29u
ZmlnKGV0aCwgTVRLX0dETUFfVE9fUERNQSk7DQotDQogCXJldHVybiAwOw0KIA0KIGVycl9kaXNh
YmxlX3BtOg0KLS0gDQoyLjE3LjENCg==

