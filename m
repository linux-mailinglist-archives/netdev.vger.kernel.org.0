Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8ED247F24
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHRHOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:14:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:28056 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgHRHOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:40 -0400
X-UUID: 3edb63222b664cd2959fbbbc336488aa-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=CFlnd0+R5J44EHcLRuNKecydHJE56Rdw6NgXCJMSKEs=;
        b=bfy7L3DOZs3D0QwGtzFCSubNqofNvfx70MBeQrGCHyy9PapvehtihZIFUDP0AeU7nQslVjOBZuUj7nHTSIZneCkvrKb6AY5d/vGguZucsMv/P8yqTL+K/ZLFH1JNDqXhXGH+0lXT5F0RXHLNEEwRUNWHEq7XmPXUUk320m9X25Q=;
X-UUID: 3edb63222b664cd2959fbbbc336488aa-20200818
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 481455462; Tue, 18 Aug 2020 15:14:37 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:35 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next v2 2/7] net: dsa: mt7530: support full-duplex gigabit only
Date:   Tue, 18 Aug 2020 15:14:07 +0800
Message-ID: <56f9cfec4d337c57e1cb1ea512a2fb404004757a.1597729692.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1597729692.git.landen.chao@mediatek.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIDEwMDBiYXNlVF9IYWxmIHRvIGFkdmVydGlzZSBjb3JyZWN0IGhhcmR3YXJlIGNhcGFi
aWxpdHkgaW4NCnBoeWxpbmtfdmFsaWRhdGUoKSBjYWxsYmFjayBmdW5jdGlvbi4NCg0KU2lnbmVk
LW9mZi1ieTogTGFuZGVuIENoYW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRy
aXZlcnMvbmV0L2RzYS9tdDc1MzAuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1
MzAuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KaW5kZXggOGRjYjhhNDlhYjY3Li4wZmQ1
MDc5OGFhNDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KQEAgLTE1MDEsNyArMTUwMSw3IEBAIHN0YXRpYyB2b2lk
IG10NzUzMF9waHlsaW5rX3ZhbGlkYXRlKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQs
DQogCQlwaHlsaW5rX3NldChtYXNrLCAxMDBiYXNlVF9GdWxsKTsNCiANCiAJCWlmIChzdGF0ZS0+
aW50ZXJmYWNlICE9IFBIWV9JTlRFUkZBQ0VfTU9ERV9NSUkpIHsNCi0JCQlwaHlsaW5rX3NldCht
YXNrLCAxMDAwYmFzZVRfSGFsZik7DQorCQkJLyogTVQ3NTMwIGFuZCBNVDc1MzEgb25seSBzdXBw
b3J0IDFHIGZ1bGwtZHVwbGV4LiAqLw0KIAkJCXBoeWxpbmtfc2V0KG1hc2ssIDEwMDBiYXNlVF9G
dWxsKTsNCiAJCQlpZiAocG9ydCA9PSA1KQ0KIAkJCQlwaHlsaW5rX3NldChtYXNrLCAxMDAwYmFz
ZVhfRnVsbCk7DQotLSANCjIuMTcuMQ0K

