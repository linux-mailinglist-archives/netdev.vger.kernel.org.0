Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44E258D6A4
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237410AbiHIJmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiHIJmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:42:18 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B955A222BD;
        Tue,  9 Aug 2022 02:42:16 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M27Nd2ZKbz1HBZg;
        Tue,  9 Aug 2022 17:40:49 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 9 Aug 2022 17:42:13 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.024;
 Tue, 9 Aug 2022 17:42:13 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf-next] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
Thread-Topic: [PATCH bpf-next] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
Thread-Index: AQHYooefJdbPZND6h0qkP6/zCqrW/62lr4qAgACxgvA=
Date:   Tue, 9 Aug 2022 09:42:13 +0000
Message-ID: <7cad8810806f46d8b982cafd98671691@huawei.com>
References: <20220728134435.99469-1-liujian56@huawei.com>
 <62f2057561774_46f04208e3@john.notmuch>
In-Reply-To: <62f2057561774_46f04208e3@john.notmuch>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3Vz
dCA5LCAyMDIyIDI6NTggUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5j
b20+OyBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207DQo+IGpha3ViQGNsb3VkZmxhcmUuY29tOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5v
cmc7IHBhYmVuaUByZWRoYXQuY29tOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsNCj4gYW5kcmlpQGtl
cm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJFOiBb
UEFUQ0ggYnBmLW5leHRdIHNrbXNnOiBGaXggd3JvbmcgbGFzdCBzZyBjaGVjayBpbg0KPiBza19t
c2dfcmVjdm1zZygpDQo+IA0KPiBMaXUgSmlhbiB3cm90ZToNCj4gPiBGaXggb25lIGtlcm5lbCBO
VUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXMgYmVsb3c6DQo+ID4NCj4gPiBbICAyMjQuNDYyMzM0
XSBDYWxsIFRyYWNlOg0KPiA+IFsgIDIyNC40NjIzOTRdICBfX3RjcF9icGZfcmVjdm1zZysweGQz
LzB4MzgwIFsgIDIyNC40NjI0NDFdICA/DQo+ID4gc29ja19oYXNfcGVybSsweDc4LzB4YTAgWyAg
MjI0LjQ2MjQ2M10gIHRjcF9icGZfcmVjdm1zZysweDEyZS8weDIyMCBbDQo+ID4gMjI0LjQ2MjQ5
NF0gIGluZXRfcmVjdm1zZysweDViLzB4ZDAgWyAgMjI0LjQ2MjUzNF0NCj4gPiBfX3N5c19yZWN2
ZnJvbSsweGM4LzB4MTMwIFsgIDIyNC40NjI1NzRdICA/DQo+ID4gc3lzY2FsbF90cmFjZV9lbnRl
cisweDFkZi8weDJlMCBbICAyMjQuNDYyNjA2XSAgPw0KPiA+IF9fZG9fcGFnZV9mYXVsdCsweDJk
ZS8weDUwMCBbICAyMjQuNDYyNjM1XQ0KPiA+IF9feDY0X3N5c19yZWN2ZnJvbSsweDI0LzB4MzAg
WyAgMjI0LjQ2MjY2MF0gIGRvX3N5c2NhbGxfNjQrMHg1ZC8weDFkMA0KPiA+IFsgIDIyNC40NjI3
MDldICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg2NS8weGNhDQo+ID4NCj4gPiBJ
biBjb21taXQgNzMwMzUyNGUwNGFmICgic2ttc2c6IExvc2Ugb2Zmc2V0IGluZm8gaW4NCj4gPiBz
a19wc29ja19za2JfaW5ncmVzcyIpLCB3ZSBjaGFuZ2UgbGFzdCBzZyBjaGVjayB0byBzZ19pc19s
YXN0KCksIGJ1dA0KPiA+IGluIHNvY2ttYXAgcmVkaXJlY3Rpb24gY2FzZSAod2l0aG91dA0KPiA+
IHN0cmVhbV9wYXJzZXIvc3RyZWFtX3ZlcmRpY3Qvc2tiX3ZlcmRpY3QpLCB3ZSBkaWQgbm90IG1h
cmsgdGhlIGVuZCBvZg0KPiA+IHRoZSBzY2F0dGVybGlzdC4gQ2hlY2sgdGhlIHNrX21zZ19hbGxv
Yywgc2tfbXNnX3BhZ2VfYWRkLCBhbmQNCj4gPiBicGZfbXNnX3B1c2hfZGF0YSBmdW5jdGlvbnMs
IHRoZXkgYWxsIGRvIG5vdCBtYXJrIHRoZSBlbmQgb2Ygc2cuIFRoZXkNCj4gPiBhcmUgZXhwZWN0
ZWQgdG8gdXNlIHNnLmVuZCBmb3IgZW5kIGp1ZGdtZW50LiBTbyB0aGUganVkZ21lbnQgb2YgJyhp
ICE9DQo+IG1zZ19yeC0+c2cuZW5kKScgaXMgYWRkZWQgYmFjayBoZXJlLg0KPiA+DQo+ID4gRml4
ZXM6IDczMDM1MjRlMDRhZiAoInNrbXNnOiBMb3NlIG9mZnNldCBpbmZvIGluDQo+ID4gc2tfcHNv
Y2tfc2tiX2luZ3Jlc3MiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBKaWFuIDxsaXVqaWFuNTZA
aHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gDQo+IFRoaXMgaXMgdGhlIHdyb25nIGZpeGVzIHRhZyB0
aG91Z2ggcmlnaHQ/IFdlIHNob3VsZCBoYXZlLA0KDQpJIGFtIHNvcnJ5IGZvciB0aGlzLCBhbmQg
d2lsbCBzZW5kIHYyIHRvIHVwZGF0ZSB0aGUgZml4IHRhZy4NCg0KPiANCj4gOTk3NGQzN2VhNzVm
MCAoInNrbXNnOiBGaXggaW52YWxpZCBsYXN0IHNnIGNoZWNrIGluIHNrX21zZ19yZWN2bXNnKCki
KQ0KPiANCj4gRml4IGxvb2tzIE9LIHRob3VnaCBhbHRob3VnaCBpdHMgbm90IGdyZWF0IHdlIGhh
dmUgdHdvIHdheXMgdG8gZmluZCB0aGUgbGFzdA0KPiBmcmFnIG5vdy4gSSdtIGdvaW5nIHRvIGxv
b2sgYXQgZ2V0dGluZyBzb21lIGJldHRlciB0ZXN0aW5nIGluIHBsYWNlIGFuZCB0aGVuDQo+IHNl
ZSBpZiB3ZSBjYW4gZ2V0IHRvIGp1c3Qgb25lIGNoZWNrLg0KPiANCj4gQXNzdW1pbmcgSSdtIHJp
Z2h0IG9uIHRoZSBmaXhlcyB0YWcgcGxlYXNlIHVwZGF0ZSB0aGF0Lg0KPiANCj4gPiAgbmV0L2Nv
cmUvc2ttc2cuYyB8IDQgKystLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NrbXNnLmMg
Yi9uZXQvY29yZS9za21zZy5jIGluZGV4DQo+ID4gODE2Mjc4OTJiZGQ0Li4zODVhZTIzNTgwYTUg
MTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2NvcmUvc2ttc2cuYw0KPiA+ICsrKyBiL25ldC9jb3JlL3Nr
bXNnLmMNCj4gPiBAQCAtNDYyLDcgKzQ2Miw3IEBAIGludCBza19tc2dfcmVjdm1zZyhzdHJ1Y3Qg
c29jayAqc2ssIHN0cnVjdA0KPiA+IHNrX3Bzb2NrICpwc29jaywgc3RydWN0IG1zZ2hkciAqbXNn
LA0KPiA+DQo+ID4gIAkJCWlmIChjb3BpZWQgPT0gbGVuKQ0KPiA+ICAJCQkJYnJlYWs7DQo+ID4g
LQkJfSB3aGlsZSAoIXNnX2lzX2xhc3Qoc2dlKSk7DQo+ID4gKwkJfSB3aGlsZSAoKGkgIT0gbXNn
X3J4LT5zZy5lbmQpICYmICFzZ19pc19sYXN0KHNnZSkpOw0KPiA+DQo+ID4gIAkJaWYgKHVubGlr
ZWx5KHBlZWspKSB7DQo+ID4gIAkJCW1zZ19yeCA9IHNrX3Bzb2NrX25leHRfbXNnKHBzb2NrLCBt
c2dfcngpOyBAQCAtDQo+IDQ3Miw3ICs0NzIsNyBAQCBpbnQNCj4gPiBza19tc2dfcmVjdm1zZyhz
dHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19wc29jayAqcHNvY2ssIHN0cnVjdCBtc2doZHINCj4g
Km1zZywNCj4gPiAgCQl9DQo+ID4NCj4gPiAgCQltc2dfcngtPnNnLnN0YXJ0ID0gaTsNCj4gPiAt
CQlpZiAoIXNnZS0+bGVuZ3RoICYmIHNnX2lzX2xhc3Qoc2dlKSkgew0KPiA+ICsJCWlmICghc2dl
LT5sZW5ndGggJiYgKGkgPT0gbXNnX3J4LT5zZy5lbmQgfHwgc2dfaXNfbGFzdChzZ2UpKSkNCj4g
ew0KPiA+ICAJCQltc2dfcnggPSBza19wc29ja19kZXF1ZXVlX21zZyhwc29jayk7DQo+ID4gIAkJ
CWtmcmVlX3NrX21zZyhtc2dfcngpOw0KPiA+ICAJCX0NCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+
DQo+IA0KDQo=
