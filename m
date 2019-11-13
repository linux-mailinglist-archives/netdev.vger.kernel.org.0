Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F47FA6A4
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfKMCix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:38:53 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:4659 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727100AbfKMCiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:38:52 -0500
X-UUID: d6be83bb4be841549548a861ab62b3ec-20191113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1NPMi5s0B7PLycleggl/Ct6ul55hyyE2HzaKv33AkXA=;
        b=EDn7Q97SYGe/ISn7VL40J628+hoVivlbsz1L2h9kC6FgazP0cjWcyDbn3c1pvtq//nSzxCMNLrl6IQGXa7Eptlkt8wNqTZiBcSTY2G9xKgZELPaS5XmFEJqoXE2EqYxdxZ5v1GvUH2PWo3MQAwltPWQ3YjPa95xHB4adVhkbaAc=;
X-UUID: d6be83bb4be841549548a861ab62b3ec-20191113
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1318690175; Wed, 13 Nov 2019 10:38:48 +0800
Received: from mtkmbs05dr.mediatek.inc (172.21.101.97) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Nov 2019 10:38:44 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05dr.mediatek.inc (172.21.101.97) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Nov 2019 10:38:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 13 Nov 2019 10:38:43 +0800
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
Subject: [PATCH net,v3 0/3]  Rework mt762x GDM setup flow
Date:   Wed, 13 Nov 2019 10:38:41 +0800
Message-ID: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-TM-SNTS-SMTP: 32640BFCC71B67AE68BCB7C85E4EA964955D4B64C5431A75173FF7830C9226DE2000:8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIG10NzYyeCBHRE0gYmxvY2sgaXMgbWFpbmx5IHVzZWQgdG8gc2V0dXAgdGhlIEhXIGludGVy
bmFsDQpyeCBwYXRoIGZyb20gR01BQyB0byBSWCBETUEgZW5naW5lKFBETUEpIGFuZCB0aGUgcGFj
a2V0DQpzd2l0Y2hpbmcgZW5naW5lKFBTRSkgaXMgcmVzcG9uc2VkIHRvIGRvIHRoZSBkYXRhIGZv
cndhcmQNCmZvbGxvd2luZyB0aGUgR0RNIGNvbmZpZ3VyYXRpb24uDQoNClRoaXMgcGF0Y2ggc2V0
IGhhdmUgdGhyZWUgZ29hbHMgOg0KDQoxLiBJbnRlZ3JhdGUgR0RNL1BTRSBzZXR1cCBvcGVyYXRp
b25zIGludG8gc2luZ2xlIGZ1bmN0aW9uICJtdGtfZ2RtX2NvbmZpZyINCg0KMi4gUmVmaW5lIHRo
ZSB0aW1pbmcgb2YgR0RNL1BTRSBzZXR1cCwgbW92ZSBpdCBmcm9tIG10a19od19pbml0IA0KICAg
dG8gbXRrX29wZW4NCg0KMy4gRW5hYmxlIEdETSBHRE1BX0RST1BfQUxMIG1vZGUgdG8gZHJvcCBh
bGwgcGFja2V0IGR1cmluZyB0aGUgDQogICBzdG9wIG9wZXJhdGlvbg0KDQpNYXJrTGVlICgzKToN
CiAgbmV0OiBldGhlcm5ldDogbWVkaWF0ZWs6IEludGVncmF0ZSBHRE0vUFNFIHNldHVwIG9wZXJh
dGlvbnMNCiAgbmV0OiBldGhlcm5ldDogbWVkaWF0ZWs6IFJlZmluZSB0aGUgdGltaW5nIG9mIEdE
TS9QU0Ugc2V0dXANCiAgbmV0OiBldGhlcm5ldDogbWVkaWF0ZWs6IEVuYWJsZSBHRE0gR0RNQV9E
Uk9QX0FMTCBtb2RlDQoNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3Nv
Yy5jIHwgNDQgKysrKysrKysrKysrKystLS0tLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVk
aWF0ZWsvbXRrX2V0aF9zb2MuaCB8ICAyICsNCiAyIGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlv
bnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTcuMQ0K

