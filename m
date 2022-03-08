Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA364D19FE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbiCHOHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiCHOHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:07:43 -0500
X-Greylist: delayed 962 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 06:06:47 PST
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 393B749F96;
        Tue,  8 Mar 2022 06:06:47 -0800 (PST)
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id 7B871BF1EFEB84AEFC6F;
        Tue,  8 Mar 2022 21:50:40 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 8 Mar 2022 21:50:40 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) by
 BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) with mapi id
 15.01.2308.020; Tue, 8 Mar 2022 21:50:40 +0800
From:   "Cai,Huoqing" <caihuoqing@baidu.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Jianglei Nie <niejianglei2021@163.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Thread-Topic: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Thread-Index: AQHYMt0Z8HFN3hFhWU29qEuTfsTlJqy0+PAAgACGxdA=
Date:   Tue, 8 Mar 2022 13:50:40 +0000
Message-ID: <a4c518cf3d5d4ad383ce0856d1641d4a@baidu.com>
References: <20220308111005.4953-1-niejianglei2021@163.com>
 <YiddVEBJvM81u1jJ@lunn.ch>
In-Reply-To: <YiddVEBJvM81u1jJ@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.18.80.106]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1
bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOoz1MI4yNUgMjE6NDMNCj4gVG86IEpp
YW5nbGVpIE5pZQ0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBD
YWksSHVvcWluZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IGFyY19lbWFjOiBGaXggdXNl
IGFmdGVyIGZyZWUgaW4gYXJjX21kaW9fcHJvYmUoKQ0KSWYgcmVzZW5kIGEgcGF0Y2gsICB5b3Ug
Y2FuIHVzZSBwcmVmaXggIltQQVRDSCB2Ml0iIGluIHN1YmplY3QuDQplLmcuICBnaXQgZm9ybWF0
LXBhdGNoIC0xIC12Mg0KPiANCj4gT24gVHVlLCBNYXIgMDgsIDIwMjIgYXQgMDc6MTA6MDVQTSAr
MDgwMCwgSmlhbmdsZWkgTmllIHdyb3RlOg0KPiA+IElmIGJ1cy0+c3RhdGUgaXMgZXF1YWwgdG8g
TURJT0JVU19BTExPQ0FURUQsIG1kaW9idXNfZnJlZShidXMpIHdpbGwNCj4gZnJlZQ0KPiA+IHRo
ZSAiYnVzIi4gQnV0IGJ1cy0+bmFtZSBpcyBzdGlsbCB1c2VkIGluIHRoZSBuZXh0IGxpbmUsIHdo
aWNoIHdpbGwgbGVhZA0KPiA+IHRvIGEgdXNlIGFmdGVyIGZyZWUuDQo+ID4NCj4gPiBXZSBjYW4g
Zml4IGl0IGJ5IHB1dHRpbmcgdGhlIGJ1cy0+bmFtZSBpbiBhIGxvY2FsIHZhcmlhYmxlIGFuZCB0
aGVuIHVzZQ0KPiA+IHRoZSBuYW1lIGluIHRoZSBlcnJvciBtZXNzYWdlIHdpdGhvdXQgcmVmZXJy
aW5nIHRvIGJ1cyB0byBhdm9pZCB0aGUgdWFmLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlh
bmdsZWkgTmllIDxuaWVqaWFuZ2xlaTIwMjFAMTYzLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXJjL2VtYWNfbWRpby5jIHwgNSArKystLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FyYy9lbWFjX21kaW8uYw0KPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FyYy9lbWFjX21kaW8uYw0KPiA+IGluZGV4IDlhY2Y1ODliMTE3OC4uMzNmZDYz
ZDIyN2VmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FyYy9lbWFjX21k
aW8uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FyYy9lbWFjX21kaW8uYw0KPiA+
IEBAIC0xMzQsNiArMTM0LDcgQEAgaW50IGFyY19tZGlvX3Byb2JlKHN0cnVjdCBhcmNfZW1hY19w
cml2ICpwcml2KQ0KPiA+ICAJc3RydWN0IGRldmljZV9ub2RlICpucCA9IHByaXYtPmRldi0+b2Zf
bm9kZTsNCj4gPiAgCXN0cnVjdCBtaWlfYnVzICpidXM7DQo+ID4gIAlpbnQgZXJyb3I7DQo+ID4g
Kwljb25zdCBjaGFyICpuYW1lID0gIlN5bm9wc3lzIE1JSSBCdXMiOw0KPiANCj4gTmV0ZGV2IHVz
ZXMgcmV2ZXJzZSBjaHJpc3RtYXNzIHRyZWUsIG1lYW5pbmcgeW91IG5lZWQgdG8gc29ydA0KPiB2
YXJpYWJsZXMgbG9uZ2VzdCB0byBzaG9ydGVzdC4NCj4gDQo+IEknbSBhbHNvIHdvbmRlcmluZyBh
Ym91dCB0aGUgbGlmZXRpbWUgb2YgbmFtZS4gbmFtZSBpdHNlbGYgaXMgYSBzdGFjaw0KPiB2YXJp
YWJsZSwgc28gaXQgd2lsbCBkaXNhcHBlYXIgYXMgc29vbiBhcyB0aGUgZnVuY3Rpb24gZXhpdHMu
IFRoZQ0KPiBzdHJpbmcgaXRzZWxmIGlzIGluIHRoZSByb2RhdGEgc2VjdGlvbi4gQnV0IGlzIGEg
Y29weSBtYWRlIG9udG8gdGhlDQo+IHN0YWNrLCBvciBkb2VzIGJ1cy0+bmFtZSBwb2ludCB0byB0
aGUgcm9kYXRhPw0KPiANCj4gICAgICAgIEFuZHJldw0KPiANCj4gPiAgCWJ1cyA9IG1kaW9idXNf
YWxsb2MoKTsNCj4gPiAgCWlmICghYnVzKQ0KPiA+IEBAIC0xNDIsNyArMTQzLDcgQEAgaW50IGFy
Y19tZGlvX3Byb2JlKHN0cnVjdCBhcmNfZW1hY19wcml2ICpwcml2KQ0KPiA+ICAJcHJpdi0+YnVz
ID0gYnVzOw0KPiA+ICAJYnVzLT5wcml2ID0gcHJpdjsNCj4gPiAgCWJ1cy0+cGFyZW50ID0gcHJp
di0+ZGV2Ow0KPiA+IC0JYnVzLT5uYW1lID0gIlN5bm9wc3lzIE1JSSBCdXMiOw0KPiA+ICsJYnVz
LT5uYW1lID0gbmFtZTsNCj4gPiAgCWJ1cy0+cmVhZCA9ICZhcmNfbWRpb19yZWFkOw0KPiA+ICAJ
YnVzLT53cml0ZSA9ICZhcmNfbWRpb193cml0ZTsNCj4gPiAgCWJ1cy0+cmVzZXQgPSAmYXJjX21k
aW9fcmVzZXQ7DQo+ID4gQEAgLTE2Nyw3ICsxNjgsNyBAQCBpbnQgYXJjX21kaW9fcHJvYmUoc3Ry
dWN0IGFyY19lbWFjX3ByaXYgKnByaXYpDQo+ID4gIAlpZiAoZXJyb3IpIHsNCj4gPiAgCQltZGlv
YnVzX2ZyZWUoYnVzKTsNCj4gPiAgCQlyZXR1cm4gZGV2X2Vycl9wcm9iZShwcml2LT5kZXYsIGVy
cm9yLA0KPiA+IC0JCQkJICAgICAiY2Fubm90IHJlZ2lzdGVyIE1ESU8gYnVzICVzXG4iLCBidXMt
DQo+ID5uYW1lKTsNCj4gPiArCQkJCSAgICAgImNhbm5vdCByZWdpc3RlciBNRElPIGJ1cyAlc1xu
IiwgbmFtZSk7DQo+ID4gIAl9DQo+ID4NCj4gPiAgCXJldHVybiAwOw0KPiA+IC0tDQo+ID4gMi4y
NS4xDQo+ID4NCg==
