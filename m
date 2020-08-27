Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B892541BD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgH0JQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:16:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51362 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726157AbgH0JQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:16:00 -0400
X-UUID: 520acdf6c46f4604939d6a7a13e5b330-20200827
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=V1FwTzdYmRJ/zoRfCUGYgxD7wn+pwTusye8m5DDKIDU=;
        b=olO2E455TEdjE8bfsj8k6SFXAGjtRFTGPnZfyBTjm+M3xaFcl5Cz84UEzN7bngu7dcTsCCJVmWDux0xnYoOpkFhTS2QIsdYf1Lhs7mEVBW6entY08IyHxwvDdtXEyTu6/cJOzcT7s8S21gUMEbIno6pBsSrC3xHHUl9RWtpYufk=;
X-UUID: 520acdf6c46f4604939d6a7a13e5b330-20200827
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 258634638; Thu, 27 Aug 2020 17:15:51 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 27 Aug 2020 17:15:48 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Aug 2020 17:15:49 +0800
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
Subject: [PATCH] net: dsa: mt7530: fix advertising unsupported
Date:   Thu, 27 Aug 2020 17:15:47 +0800
Message-ID: <20200827091547.21870-1-landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MTAwMGJhc2VUX0hhbGYNCg0KUmVtb3ZlIDEwMDBiYXNlVF9IYWxmIHRvIGFkdmVydGlzZSBjb3Jy
ZWN0IGhhcmR3YXJlIGNhcGFiaWxpdHkgaW4NCnBoeWxpbmtfdmFsaWRhdGUoKSBjYWxsYmFjayBm
dW5jdGlvbi4NCg0KRml4ZXM6IDM4Zjc5MGE4MDU2MCAoIm5ldDogZHNhOiBtdDc1MzA6IEFkZCBz
dXBwb3J0IGZvciBwb3J0IDUiKQ0KU2lnbmVkLW9mZi1ieTogTGFuZGVuIENoYW8gPGxhbmRlbi5j
aGFvQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYyB8IDIgKy0N
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAu
Yw0KaW5kZXggOGRjYjhhNDlhYjY3Li4yMzg0MTdkYjI2ZjkgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9kc2EvbXQ3NTMwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KQEAgLTE1
MDEsNyArMTUwMSw3IEBAIHN0YXRpYyB2b2lkIG10NzUzMF9waHlsaW5rX3ZhbGlkYXRlKHN0cnVj
dCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQogCQlwaHlsaW5rX3NldChtYXNrLCAxMDBiYXNl
VF9GdWxsKTsNCiANCiAJCWlmIChzdGF0ZS0+aW50ZXJmYWNlICE9IFBIWV9JTlRFUkZBQ0VfTU9E
RV9NSUkpIHsNCi0JCQlwaHlsaW5rX3NldChtYXNrLCAxMDAwYmFzZVRfSGFsZik7DQorCQkJLyog
VGhpcyBzd2l0Y2ggb25seSBzdXBwb3J0cyAxRyBmdWxsLWR1cGxleC4gKi8NCiAJCQlwaHlsaW5r
X3NldChtYXNrLCAxMDAwYmFzZVRfRnVsbCk7DQogCQkJaWYgKHBvcnQgPT0gNSkNCiAJCQkJcGh5
bGlua19zZXQobWFzaywgMTAwMGJhc2VYX0Z1bGwpOw0KLS0gDQoyLjE3LjENCg==

