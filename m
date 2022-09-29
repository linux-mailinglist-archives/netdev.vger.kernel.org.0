Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9905EF6BD
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiI2NiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiI2NiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:38:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2041857A8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:38:07 -0700 (PDT)
Received: from canpemm100010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MdZ7w13TTz1P6ms;
        Thu, 29 Sep 2022 21:33:48 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100010.china.huawei.com (7.192.104.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 21:38:05 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Thu, 29 Sep 2022 21:38:05 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: Add helper function to parse netlink
 msg of ip_tunnel_parm
Thread-Topic: [PATCH net-next v2 2/2] net: Add helper function to parse
 netlink msg of ip_tunnel_parm
Thread-Index: AQHY0uq75rodT4GRiU6g1H8OZoThuK3133uAgACLheA=
Date:   Thu, 29 Sep 2022 13:38:05 +0000
Message-ID: <577e7f43f2a54ac597d23739822d8674@huawei.com>
References: <20220928033917.281937-1-liujian56@huawei.com>
        <20220928033917.281937-3-liujian56@huawei.com>
 <432c0ab0943320affa092d93868973c7c9b060b8.camel@redhat.com>
In-Reply-To: <432c0ab0943320affa092d93868973c7c9b060b8.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgW21h
aWx0bzpwYWJlbmlAcmVkaGF0LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAyOSwg
MjAyMiA5OjE3IFBNDQo+IFRvOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29tPjsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4geW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7IGRzYWhlcm5A
a2VybmVsLm9yZzsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgMi8y
XSBuZXQ6IEFkZCBoZWxwZXIgZnVuY3Rpb24gdG8gcGFyc2UNCj4gbmV0bGluayBtc2cgb2YgaXBf
dHVubmVsX3Bhcm0NCj4gDQo+IE9uIFdlZCwgMjAyMi0wOS0yOCBhdCAxMTozOSArMDgwMCwgTGl1
IEppYW4gd3JvdGU6DQo+ID4gQWRkIGlwX3R1bm5lbF9uZXRsaW5rX3Bhcm1zIHRvIHBhcnNlIG5l
dGxpbmsgbXNnIG9mIGlwX3R1bm5lbF9wYXJtLg0KPiA+IFJlZHVjZXMgZHVwbGljYXRlIGNvZGUs
IG5vIGFjdHVhbCBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBM
aXUgSmlhbiA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gdjEtPnYyOiBNb3Zl
IHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgaGVscGVyIGZ1bmN0aW9uIHRvDQo+ID4gdjEtPmlw
X3R1bm5lbF9jb3JlLmMNCj4gPiAgaW5jbHVkZS9uZXQvaXBfdHVubmVscy5oICB8ICAzICsrKw0K
PiA+ICBuZXQvaXB2NC9pcF90dW5uZWxfY29yZS5jIHwgMzIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gPiAgbmV0L2lwdjQvaXBpcC5jICAgICAgICAgICB8IDI0ICstLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBuZXQvaXB2Ni9zaXQuYyAgICAgICAgICAgIHwgMjcgKy0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgMzcgaW5zZXJ0
aW9ucygrKSwgNDkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9u
ZXQvaXBfdHVubmVscy5oIGIvaW5jbHVkZS9uZXQvaXBfdHVubmVscy5oIGluZGV4DQo+ID4gNTFk
YTI5NTdjZjQ4Li5mY2EzNTc2Nzk4MTYgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9uZXQvaXBf
dHVubmVscy5oDQo+ID4gKysrIGIvaW5jbHVkZS9uZXQvaXBfdHVubmVscy5oDQo+ID4gQEAgLTMw
NSw2ICszMDUsOSBAQCB2b2lkIGlwX3R1bm5lbF9zZXR1cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2
LA0KPiA+IHVuc2lnbmVkIGludCBuZXRfaWQpOyAgYm9vbCBpcF90dW5uZWxfbmV0bGlua19lbmNh
cF9wYXJtcyhzdHJ1Y3QgbmxhdHRyDQo+ICpkYXRhW10sDQo+ID4gIAkJCQkgICBzdHJ1Y3QgaXBf
dHVubmVsX2VuY2FwICplbmNhcCk7DQo+ID4NCj4gPiArdm9pZCBpcF90dW5uZWxfbmV0bGlua19w
YXJtcyhzdHJ1Y3QgbmxhdHRyICpkYXRhW10sDQo+ID4gKwkJCSAgICAgc3RydWN0IGlwX3R1bm5l
bF9wYXJtICpwYXJtcyk7DQo+ID4gKw0KPiA+ICBleHRlcm4gY29uc3Qgc3RydWN0IGhlYWRlcl9v
cHMgaXBfdHVubmVsX2hlYWRlcl9vcHM7DQo+ID4gIF9fYmUxNiBpcF90dW5uZWxfcGFyc2VfcHJv
dG9jb2woY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYik7DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvaXBfdHVubmVsX2NvcmUuYyBiL25ldC9pcHY0L2lwX3R1bm5lbF9jb3JlLmMNCj4g
PiBpbmRleCA1MjZlNmE1MmE5NzMuLjFlMTIxN2U4Nzg4NSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQv
aXB2NC9pcF90dW5uZWxfY29yZS5jDQo+ID4gKysrIGIvbmV0L2lwdjQvaXBfdHVubmVsX2NvcmUu
Yw0KPiA+IEBAIC0xMTE0LDMgKzExMTQsMzUgQEAgYm9vbCBpcF90dW5uZWxfbmV0bGlua19lbmNh
cF9wYXJtcyhzdHJ1Y3QNCj4gbmxhdHRyICpkYXRhW10sDQo+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+
ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0woaXBfdHVubmVsX25ldGxpbmtfZW5jYXBfcGFybXMpOw0K
PiA+ICsNCj4gPiArdm9pZCBpcF90dW5uZWxfbmV0bGlua19wYXJtcyhzdHJ1Y3QgbmxhdHRyICpk
YXRhW10sDQo+ID4gKwkJCSAgICAgc3RydWN0IGlwX3R1bm5lbF9wYXJtICpwYXJtcykgew0KPiA+
ICsJaWYgKGRhdGFbSUZMQV9JUFRVTl9MSU5LXSkNCj4gPiArCQlwYXJtcy0+bGluayA9IG5sYV9n
ZXRfdTMyKGRhdGFbSUZMQV9JUFRVTl9MSU5LXSk7DQo+ID4gKw0KPiA+ICsJaWYgKGRhdGFbSUZM
QV9JUFRVTl9MT0NBTF0pDQo+ID4gKwkJcGFybXMtPmlwaC5zYWRkciA9IG5sYV9nZXRfYmUzMihk
YXRhW0lGTEFfSVBUVU5fTE9DQUxdKTsNCj4gPiArDQo+ID4gKwlpZiAoZGF0YVtJRkxBX0lQVFVO
X1JFTU9URV0pDQo+ID4gKwkJcGFybXMtPmlwaC5kYWRkciA9DQo+IG5sYV9nZXRfYmUzMihkYXRh
W0lGTEFfSVBUVU5fUkVNT1RFXSk7DQo+ID4gKw0KPiA+ICsJaWYgKGRhdGFbSUZMQV9JUFRVTl9U
VExdKSB7DQo+ID4gKwkJcGFybXMtPmlwaC50dGwgPSBubGFfZ2V0X3U4KGRhdGFbSUZMQV9JUFRV
Tl9UVExdKTsNCj4gPiArCQlpZiAocGFybXMtPmlwaC50dGwpDQo+ID4gKwkJCXBhcm1zLT5pcGgu
ZnJhZ19vZmYgPSBodG9ucyhJUF9ERik7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYgKGRhdGFb
SUZMQV9JUFRVTl9UT1NdKQ0KPiA+ICsJCXBhcm1zLT5pcGgudG9zID0gbmxhX2dldF91OChkYXRh
W0lGTEFfSVBUVU5fVE9TXSk7DQo+ID4gKw0KPiA+ICsJaWYgKCFkYXRhW0lGTEFfSVBUVU5fUE1U
VURJU0NdIHx8DQo+IG5sYV9nZXRfdTgoZGF0YVtJRkxBX0lQVFVOX1BNVFVESVNDXSkpDQo+ID4g
KwkJcGFybXMtPmlwaC5mcmFnX29mZiA9IGh0b25zKElQX0RGKTsNCj4gPiArDQo+ID4gKwlpZiAo
ZGF0YVtJRkxBX0lQVFVOX0ZMQUdTXSkNCj4gPiArCQlwYXJtcy0+aV9mbGFncyA9IG5sYV9nZXRf
YmUxNihkYXRhW0lGTEFfSVBUVU5fRkxBR1NdKTsNCj4gPiArDQo+ID4gKwlpZiAoZGF0YVtJRkxB
X0lQVFVOX1BST1RPXSkNCj4gPiArCQlwYXJtcy0+aXBoLnByb3RvY29sID0NCj4gbmxhX2dldF91
OChkYXRhW0lGTEFfSVBUVU5fUFJPVE9dKTsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MKGlw
X3R1bm5lbF9uZXRsaW5rX3Bhcm1zKTsNCj4gDQo+IFRoZSBzYW1lIGhlcmUsIEkgdGhpbmsgaXQg
c2hvdWxkIGJlIEVYUE9SVF9TWU1CT0xfR1BMKCkNCk9LLCB0aGFua3MgZm9yIHlvdXIgcmV2aWV3
LCBJIHdpbGwgc2VuZCB2MyBmb3IgdGhpcy4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IFBhb2xvDQo+
IA0KDQo=
