Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0085B9AEA
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIOMhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIOMhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:37:04 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605CD80EBA
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 05:36:56 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSxS66v83z14QSw;
        Thu, 15 Sep 2022 20:32:54 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 20:36:53 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Thu, 15 Sep 2022 20:36:53 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] tun: Check tun device queue status in
 tun_chr_write_iter
Thread-Topic: [PATCH net] tun: Check tun device queue status in
 tun_chr_write_iter
Thread-Index: AQHYwlYzi3o+UBXzd0mYDSUCVpZVsK3fz8KAgACp6wA=
Date:   Thu, 15 Sep 2022 12:36:53 +0000
Message-ID: <5250ce0c385c4985b92161abe96f853c@huawei.com>
References: <20220907010942.10096-1-liujian56@huawei.com>
 <7b630516987883ece2d02e26c4a20311c390c173.camel@redhat.com>
In-Reply-To: <7b630516987883ece2d02e26c4a20311c390c173.camel@redhat.com>
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
aWx0bzpwYWJlbmlAcmVkaGF0LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAxNSwg
MjAyMiA2OjI0IFBNDQo+IFRvOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29tPjsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwu
b3JnOyBhc3RAa2VybmVsLm9yZzsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGhhd2tAa2VybmVs
Lm9yZzsgam9obi5mYXN0YWJlbmRAZ21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSB0dW46IENoZWNrIHR1biBkZXZpY2UgcXVldWUg
c3RhdHVzIGluDQo+IHR1bl9jaHJfd3JpdGVfaXRlcg0KPiANCj4gSGVsbG8sDQo+IA0KPiBPbiBX
ZWQsIDIwMjItMDktMDcgYXQgMDk6MDkgKzA4MDAsIExpdSBKaWFuIHdyb3RlOg0KPiA+IHN5emJv
dCBmb3VuZCBiZWxvdyB3YXJuaW5nOg0KPiA+DQo+ID4gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBd
LS0tLS0tLS0tLS0tDQo+ID4gZ2VuZXZlMCByZWNlaXZlZCBwYWNrZXQgb24gcXVldWUgMywgYnV0
IG51bWJlciBvZiBSWCBxdWV1ZXMgaXMgMw0KPiA+IFdBUk5JTkc6IENQVTogMSBQSUQ6IDI5NzM0
IGF0IG5ldC9jb3JlL2Rldi5jOjQ2MTEgbmV0aWZfZ2V0X3J4cXVldWUNCj4gPiBuZXQvY29yZS9k
ZXYuYzo0NjExIFtpbmxpbmVdDQo+ID4gV0FSTklORzogQ1BVOiAxIFBJRDogMjk3MzQgYXQgbmV0
L2NvcmUvZGV2LmM6NDYxMQ0KPiA+IG5ldGlmX3JlY2VpdmVfZ2VuZXJpY194ZHArMHhiMTAvMHhi
NTAgbmV0L2NvcmUvZGV2LmM6NDY4MyBNb2R1bGVzDQo+IGxpbmtlZCBpbjoNCj4gPiBDUFU6IDEg
UElEOiAyOTczNCBDb21tOiBzeXotZXhlY3V0b3IuMCBOb3QgdGFpbnRlZCA1LjEwLjAgIzUgSGFy
ZHdhcmUNCj4gPiBuYW1lOiBsaW51eCxkdW1teS12aXJ0IChEVCkNCj4gPiBwc3RhdGU6IDYwNDAw
MDA1IChuWkN2IGRhaWYgK1BBTiAtVUFPIC1UQ08gQlRZUEU9LS0pIHBjIDoNCj4gPiBuZXRpZl9n
ZXRfcnhxdWV1ZSBuZXQvY29yZS9kZXYuYzo0NjExIFtpbmxpbmVdIHBjIDoNCj4gPiBuZXRpZl9y
ZWNlaXZlX2dlbmVyaWNfeGRwKzB4YjEwLzB4YjUwIG5ldC9jb3JlL2Rldi5jOjQ2ODMgbHIgOg0K
PiA+IG5ldGlmX2dldF9yeHF1ZXVlIG5ldC9jb3JlL2Rldi5jOjQ2MTEgW2lubGluZV0gbHIgOg0K
PiA+IG5ldGlmX3JlY2VpdmVfZ2VuZXJpY194ZHArMHhiMTAvMHhiNTAgbmV0L2NvcmUvZGV2LmM6
NDY4MyBzcCA6DQo+ID4gZmZmZmEwMDAxNjEyNzc3MA0KPiA+IHgyOTogZmZmZmEwMDAxNjEyNzc3
MCB4Mjg6IGZmZmYzZjQ2MDdkNmFjYjQNCj4gPiB4Mjc6IGZmZmYzZjQ2MDdkNmFjYjAgeDI2OiBm
ZmZmM2Y0NjA3ZDZhZDIwDQo+ID4geDI1OiBmZmZmM2Y0NjFkZTNjMDAwIHgyNDogZmZmZjNmNDYw
N2Q2YWQyOA0KPiA+IHgyMzogZmZmZmEwMDAxMDA1OTAwMCB4MjI6IGZmZmYzZjQ2MDg3MTkxMDAN
Cj4gPiB4MjE6IDAwMDAwMDAwMDAwMDAwMDMgeDIwOiBmZmZmYTAwMDE2MTI3OGEwDQo+ID4geDE5
OiBmZmZmM2Y0NjA3ZDZhYzQwIHgxODogMDAwMDAwMDAwMDAwMDAwMA0KPiA+IHgxNzogMDAwMDAw
MDAwMDAwMDAwMCB4MTY6IDAwMDAwMDAwZjJmMmYyMDQNCj4gPiB4MTU6IDAwMDAwMDAwZjJmMjAw
MDAgeDE0OiA2NDY1NzY2OTY1NjM2NTcyDQo+ID4geDEzOiAyMDMwNjU3NjY1NmU2NTY3IHgxMjog
ZmZmZjk4YjhlZDNiOTI0ZA0KPiA+IHgxMTogMWZmZmY4YjhlZDNiOTI0YyB4MTA6IGZmZmY5OGI4
ZWQzYjkyNGMNCj4gPiB4OSA6IGZmZmZjNWM3NjUyNWM5YzQgeDggOiAwMDAwMDAwMDAwMDAwMDAw
DQo+ID4geDcgOiAwMDAwMDAwMDAwMDAwMDAxIHg2IDogZmZmZjk4YjhlZDNiOTI0Yw0KPiA+IHg1
IDogZmZmZjNmNDYwZjNiMjljMCB4NCA6IGRmZmZhMDAwMDAwMDAwMDANCj4gPiB4MyA6IGZmZmZj
NWM3NjUwMDAwMDAgeDIgOiAwMDAwMDAwMDAwMDAwMDAwDQo+ID4geDEgOiAwMDAwMDAwMDAwMDAw
MDAwIHgwIDogZmZmZjNmNDYwZjNiMjljMCBDYWxsIHRyYWNlOg0KPiA+ICBuZXRpZl9nZXRfcnhx
dWV1ZSBuZXQvY29yZS9kZXYuYzo0NjExIFtpbmxpbmVdDQo+ID4gIG5ldGlmX3JlY2VpdmVfZ2Vu
ZXJpY194ZHArMHhiMTAvMHhiNTAgbmV0L2NvcmUvZGV2LmM6NDY4Mw0KPiA+IGRvX3hkcF9nZW5l
cmljIG5ldC9jb3JlL2Rldi5jOjQ3NzcgW2lubGluZV0NCj4gPiAgZG9feGRwX2dlbmVyaWMrMHg5
Yy8weDE5MCBuZXQvY29yZS9kZXYuYzo0NzcwDQo+ID4gIHR1bl9nZXRfdXNlcisweGQ5NC8weDIw
MTAgZHJpdmVycy9uZXQvdHVuLmM6MTkzOA0KPiA+ICB0dW5fY2hyX3dyaXRlX2l0ZXIrMHg5OC8w
eDEwMCBkcml2ZXJzL25ldC90dW4uYzoyMDM2ICBjYWxsX3dyaXRlX2l0ZXINCj4gPiBpbmNsdWRl
L2xpbnV4L2ZzLmg6MTk2MCBbaW5saW5lXQ0KPiA+ICBuZXdfc3luY193cml0ZSsweDI2MC8weDM3
MCBmcy9yZWFkX3dyaXRlLmM6NTE1ICB2ZnNfd3JpdGUrMHg1MWMvMHg2MWMNCj4gPiBmcy9yZWFk
X3dyaXRlLmM6NjAyDQo+ID4gIGtzeXNfd3JpdGUrMHhmYy8weDIwMCBmcy9yZWFkX3dyaXRlLmM6
NjU1ICBfX2RvX3N5c193cml0ZQ0KPiA+IGZzL3JlYWRfd3JpdGUuYzo2NjcgW2lubGluZV0gIF9f
c2Vfc3lzX3dyaXRlIGZzL3JlYWRfd3JpdGUuYzo2NjQNCj4gPiBbaW5saW5lXQ0KPiA+ICBfX2Fy
bTY0X3N5c193cml0ZSsweDUwLzB4NjAgZnMvcmVhZF93cml0ZS5jOjY2NCAgX19pbnZva2Vfc3lz
Y2FsbA0KPiA+IGFyY2gvYXJtNjQva2VybmVsL3N5c2NhbGwuYzozNiBbaW5saW5lXSAgaW52b2tl
X3N5c2NhbGwNCj4gPiBhcmNoL2FybTY0L2tlcm5lbC9zeXNjYWxsLmM6NDggW2lubGluZV0NCj4g
PiAgZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjArMHhmNC8weDQxNCBhcmNoL2FybTY0L2tlcm5l
bC9zeXNjYWxsLmM6MTU1DQo+ID4gZG9fZWwwX3N2YysweDUwLzB4MTFjIGFyY2gvYXJtNjQva2Vy
bmVsL3N5c2NhbGwuYzoyMTcNCj4gPiAgZWwwX3N2YysweDIwLzB4MzAgYXJjaC9hcm02NC9rZXJu
ZWwvZW50cnktY29tbW9uLmM6MzUzDQo+ID4gIGVsMF9zeW5jX2hhbmRsZXIrMHhlNC8weDFlMCBh
cmNoL2FybTY0L2tlcm5lbC9lbnRyeS1jb21tb24uYzozNjkNCj4gPiAgZWwwX3N5bmMrMHgxNDgv
MHgxODAgYXJjaC9hcm02NC9rZXJuZWwvZW50cnkuUzo2ODMNCj4gPg0KPiA+IFRoaXMgaXMgYmVj
YXVzZSB0aGUgZGV0YWNoZWQgcXVldWUgaXMgdXNlZCB0byBzZW5kIGRhdGEuIFRoZXJlZm9yZSwg
d2UNCj4gPiBuZWVkIHRvIGNoZWNrIHRoZSBxdWV1ZSBzdGF0dXMgaW4gdGhlIHR1bl9jaHJfd3Jp
dGVfaXRlciBmdW5jdGlvbi4NCj4gPg0KPiANCj4gU29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5LiBX
ZSBuZWVkIGEgc3VpdGFibGUgZml4ZXMgdGFnIHBvaW50aW5nIHRvIHRoZSBjb21taXQNCj4gaW50
cm9kdWNpbmcgdGhlIGlzc3VlLg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3IGFuZCByZW1p
bmRlci4NCg0KPiBXaGlsZSBhdCB0aGF0LCBwbGVhc2UgYWxzbyBzcGVjaWZ5IHRoZSB0YXJnZXQg
dHJlZSBpbiB0aGUgc3ViaiAoLW5ldCkNCj4gDQo+IFRoYW5rcyENCj4gDQo+IFBhb2xvDQoNCg==
