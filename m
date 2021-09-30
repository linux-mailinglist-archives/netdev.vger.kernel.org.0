Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051F041D18E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 04:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbhI3CnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 22:43:21 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60830 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347886AbhI3CnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 22:43:20 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 18U2fJ811012331, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 18U2fJ811012331
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Sep 2021 10:41:19 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 30 Sep 2021 10:41:19 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 30 Sep 2021 10:41:18 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Thu, 30 Sep 2021 10:41:18 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jason-ch Chen <jason-ch.chen@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Topic: [PATCH] r8152: stop submitting rx for -EPROTO
Thread-Index: AQHXtPF6mRt31KuIqUSf0ySwz113xKu6nqYQ//+g0oCAAZuNgA==
Date:   Thu, 30 Sep 2021 02:41:18 +0000
Message-ID: <7dc4198f05784b6686973500150faca7@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
         <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
In-Reply-To: <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzkvMjkg5LiL5Y2IIDExOjI3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFzb24tY2ggQ2hlbiA8amFzb24tY2guY2hlbkBtZWRpYXRlay5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgU2VwdGVtYmVyIDI5LCAyMDIxIDU6NTMgUE0NClsuLi5dDQo+IEhpIEhheWVzLA0KPiAN
Cj4gU29tZXRpbWVzIFJ4IHN1Ym1pdHMgcmFwaWRseSBhbmQgdGhlIFVTQiBrZXJuZWwgZHJpdmVy
IG9mIG9wZW5zb3VyY2UNCj4gY2Fubm90IHJlY2VpdmUgYW55IGRpc2Nvbm5lY3QgZXZlbnQgZHVl
IHRvIENQVSBoZWF2eSBsb2FkaW5nLCB3aGljaA0KPiBmaW5hbGx5IGNhdXNlcyBhIHN5c3RlbSBj
cmFzaC4NCj4gRG8geW91IGhhdmUgYW55IHN1Z2dlc3Rpb25zIHRvIG1vZGlmeSB0aGUgcjgxNTIg
ZHJpdmVyIHRvIHByZXZlbnQgdGhpcw0KPiBzaXR1YXRpb24gaGFwcGVuZWQ/DQoNCkRvIHlvdSBt
aW5kIHRvIHRyeSB0aGUgZm9sbG93aW5nIHBhdGNoPw0KSXQgYXZvaWRzIHRvIHJlLXN1Ym1pdCBS
WCBpbW1lZGlhdGVseS4NCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9yODE1Mi5jIGIv
ZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMNCmluZGV4IDYwYmE5YjczNDA1NS4uYmZlMDBhZjgyODNm
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3VzYi9yODE1Mi5jDQpAQCAtNzY3LDYgKzc2Nyw3IEBAIGVudW0gcnRsODE1Ml9mbGFncyB7DQog
CVBIWV9SRVNFVCwNCiAJU0NIRURVTEVfVEFTS0xFVCwNCiAJR1JFRU5fRVRIRVJORVQsDQorCVND
SEVEVUxFX05BUEksDQogfTsNCiANCiAjZGVmaW5lIERFVklDRV9JRF9USElOS1BBRF9USFVOREVS
Qk9MVDNfRE9DS19HRU4yCTB4MzA4Mg0KQEAgLTE3NzAsNiArMTc3MSwxNCBAQCBzdGF0aWMgdm9p
ZCByZWFkX2J1bGtfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKQ0KIAkJcnRsX3NldF91bnBsdWco
dHApOw0KIAkJbmV0aWZfZGV2aWNlX2RldGFjaCh0cC0+bmV0ZGV2KTsNCiAJCXJldHVybjsNCisJ
Y2FzZSAtRVBST1RPOg0KKwkJdXJiLT5hY3R1YWxfbGVuZ3RoID0gMDsNCisJCXNwaW5fbG9ja19p
cnFzYXZlKCZ0cC0+cnhfbG9jaywgZmxhZ3MpOw0KKwkJbGlzdF9hZGRfdGFpbCgmYWdnLT5saXN0
LCAmdHAtPnJ4X2RvbmUpOw0KKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdHAtPnJ4X2xvY2ss
IGZsYWdzKTsNCisJCXNldF9iaXQoU0NIRURVTEVfTkFQSSwgJnRwLT5mbGFncyk7DQorCQlzY2hl
ZHVsZV9kZWxheWVkX3dvcmsoJnRwLT5zY2hlZHVsZSwgMSk7DQorCQlyZXR1cm47DQogCWNhc2Ug
LUVOT0VOVDoNCiAJCXJldHVybjsJLyogdGhlIHVyYiBpcyBpbiB1bmxpbmsgc3RhdGUgKi8NCiAJ
Y2FzZSAtRVRJTUU6DQpAQCAtMjQyNSw2ICsyNDM0LDcgQEAgc3RhdGljIGludCByeF9ib3R0b20o
c3RydWN0IHI4MTUyICp0cCwgaW50IGJ1ZGdldCkNCiAJaWYgKGxpc3RfZW1wdHkoJnRwLT5yeF9k
b25lKSkNCiAJCWdvdG8gb3V0MTsNCiANCisJY2xlYXJfYml0KFNDSEVEVUxFX05BUEksICZ0cC0+
ZmxhZ3MpOw0KIAlJTklUX0xJU1RfSEVBRCgmcnhfcXVldWUpOw0KIAlzcGluX2xvY2tfaXJxc2F2
ZSgmdHAtPnJ4X2xvY2ssIGZsYWdzKTsNCiAJbGlzdF9zcGxpY2VfaW5pdCgmdHAtPnJ4X2RvbmUs
ICZyeF9xdWV1ZSk7DQpAQCAtMjQ0MSw3ICsyNDUxLDcgQEAgc3RhdGljIGludCByeF9ib3R0b20o
c3RydWN0IHI4MTUyICp0cCwgaW50IGJ1ZGdldCkNCiANCiAJCWFnZyA9IGxpc3RfZW50cnkoY3Vy
c29yLCBzdHJ1Y3QgcnhfYWdnLCBsaXN0KTsNCiAJCXVyYiA9IGFnZy0+dXJiOw0KLQkJaWYgKHVy
Yi0+YWN0dWFsX2xlbmd0aCA8IEVUSF9aTEVOKQ0KKwkJaWYgKHVyYi0+c3RhdHVzICE9IDAgfHwg
dXJiLT5hY3R1YWxfbGVuZ3RoIDwgRVRIX1pMRU4pDQogCQkJZ290byBzdWJtaXQ7DQogDQogCQlh
Z2dfZnJlZSA9IHJ0bF9nZXRfZnJlZV9yeCh0cCwgR0ZQX0FUT01JQyk7DQpAQCAtNjY0Myw2ICs2
NjUzLDEwIEBAIHN0YXRpYyB2b2lkIHJ0bF93b3JrX2Z1bmNfdChzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQogCSAgICBuZXRpZl9jYXJyaWVyX29rKHRwLT5uZXRkZXYpKQ0KIAkJdGFza2xldF9z
Y2hlZHVsZSgmdHAtPnR4X3RsKTsNCiANCisJaWYgKHRlc3RfYW5kX2NsZWFyX2JpdChTQ0hFRFVM
RV9OQVBJLCAmdHAtPmZsYWdzKSAmJg0KKwkgICAgIWxpc3RfZW1wdHkoJnRwLT5yeF9kb25lKSkN
CisJCW5hcGlfc2NoZWR1bGUoJnRwLT5uYXBpKTsNCisNCiAJbXV0ZXhfdW5sb2NrKCZ0cC0+Y29u
dHJvbCk7DQogDQogb3V0MToNCg0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQo=
