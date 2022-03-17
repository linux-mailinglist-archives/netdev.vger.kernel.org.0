Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF404DC862
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiCQOJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiCQOJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:09:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F8103D9D;
        Thu, 17 Mar 2022 07:08:09 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KK87d00YczCqkF;
        Thu, 17 Mar 2022 22:06:04 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 22:08:04 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2308.021;
 Thu, 17 Mar 2022 22:08:04 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Topic: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Index: AQHYOGk2O/XwDW4Ml0q7jRHCigZ/yqzAVx0AgADbdhD//6smgIABGg3Q//+g3wCAAgQ9QA==
Date:   Thu, 17 Mar 2022 14:08:04 +0000
Message-ID: <ed30a1fb4f8245568bb8f5c02cc19860@huawei.com>
References: <20220315123916.110409-1-liujian56@huawei.com>
 <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
 <4f937ace70a3458580c6242fa68ea549@huawei.com>
 <623160c966680_94df20819@john.notmuch>
 <5cee2fb729624f168415d303cff4ee8f@huawei.com>
 <CAKH8qBuBoyJqSEBX+2iG4b7C7tXPZUtVX6qZysrwddT3LE9ieg@mail.gmail.com>
In-Reply-To: <CAKH8qBuBoyJqSEBX+2iG4b7C7tXPZUtVX6qZysrwddT3LE9ieg@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RhbmlzbGF2IEZvbWlj
aGV2IFttYWlsdG86c2RmQGdvb2dsZS5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMTYs
IDIwMjIgMTE6MDkgUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+
DQo+IENjOiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPjsgTWFydGlu
IEthRmFpIExhdQ0KPiA8a2FmYWlAZmIuY29tPjsgYXN0QGtlcm5lbC5vcmc7IGRhbmllbEBpb2dl
YXJib3gubmV0OyBhbmRyaWlAa2VybmVsLm9yZzsNCj4gc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5
aHNAZmIuY29tOyBrcHNpbmdoQGtlcm5lbC5vcmc7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1
YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gYnBmQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGJwZi1uZXh0XSBuZXQ6IFVzZSBza2ItPmxlbiB0
byBjaGVjayB0aGUgdmFsaWRpdHkgb2YgdGhlDQo+IHBhcmFtZXRlcnMgaW4gYnBmX3NrYl9sb2Fk
X2J5dGVzDQo+IA0KPiBPbiBXZWQsIE1hciAxNiwgMjAyMiBhdCA2OjA4IEFNIGxpdWppYW4gKENF
KSA8bGl1amlhbjU2QGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+DQo+ID4NCj4gPg0KPiA+ID4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IEpvaG4gRmFzdGFiZW5kIFttYWls
dG86am9obi5mYXN0YWJlbmRAZ21haWwuY29tXQ0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJj
aCAxNiwgMjAyMiAxMjowMCBQTQ0KPiA+ID4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1
YXdlaS5jb20+OyBNYXJ0aW4gS2FGYWkgTGF1DQo+ID4gPiA8a2FmYWlAZmIuY29tPg0KPiA+ID4g
Q2M6IGFzdEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgYW5kcmlpQGtlcm5lbC5v
cmc7DQo+ID4gPiBzb25nbGl1YnJhdmluZ0BmYi5jb207IHloc0BmYi5jb207IGpvaG4uZmFzdGFi
ZW5kQGdtYWlsLmNvbTsNCj4gPiA+IGtwc2luZ2hAa2VybmVsLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiA+ID4gc2RmQGdvb2dsZS5jb207IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IFN1YmplY3Q6IFJFOiBbUEFU
Q0ggYnBmLW5leHRdIG5ldDogVXNlIHNrYi0+bGVuIHRvIGNoZWNrIHRoZQ0KPiA+ID4gdmFsaWRp
dHkgb2YgdGhlIHBhcmFtZXRlcnMgaW4gYnBmX3NrYl9sb2FkX2J5dGVzDQo+ID4gPg0KPiA+ID4g
bGl1amlhbiAoQ0UpIHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+ID4gRnJvbTogTWFydGluIEthRmFpIExhdSBbbWFp
bHRvOmthZmFpQGZiLmNvbV0NCj4gPiA+ID4gPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE2LCAy
MDIyIDM6NTggQU0NCj4gPiA+ID4gPiBUbzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVhd2Vp
LmNvbT4NCj4gPiA+ID4gPiBDYzogYXN0QGtlcm5lbC5vcmc7IGRhbmllbEBpb2dlYXJib3gubmV0
OyBhbmRyaWlAa2VybmVsLm9yZzsNCj4gPiA+ID4gPiBzb25nbGl1YnJhdmluZ0BmYi5jb207IHlo
c0BmYi5jb207IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsNCj4gPiA+ID4gPiBrcHNpbmdoQGtl
cm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gPiA+ID4g
PiBzZGZAZ29vZ2xlLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVs
Lm9yZw0KPiA+ID4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggYnBmLW5leHRdIG5ldDogVXNlIHNr
Yi0+bGVuIHRvIGNoZWNrIHRoZQ0KPiA+ID4gPiA+IHZhbGlkaXR5IG9mIHRoZSBwYXJhbWV0ZXJz
IGluIGJwZl9za2JfbG9hZF9ieXRlcw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24gVHVlLCBNYXIg
MTUsIDIwMjIgYXQgMDg6Mzk6MTZQTSArMDgwMCwgTGl1IEppYW4gd3JvdGU6DQo+ID4gPiA+ID4g
PiBUaGUgZGF0YSBsZW5ndGggb2Ygc2tiIGZyYWdzICsgZnJhZ19saXN0IG1heSBiZSBncmVhdGVy
IHRoYW4NCj4gPiA+ID4gPiA+IDB4ZmZmZiwgc28gaGVyZSB1c2Ugc2tiLT5sZW4gdG8gY2hlY2sg
dGhlIHZhbGlkaXR5IG9mIHRoZSBwYXJhbWV0ZXJzLg0KPiA+ID4gPiA+IFdoYXQgaXMgdGhlIHVz
ZSBjYXNlIHRoYXQgbmVlZHMgdG8gbG9vayBiZXlvbmQgMHhmZmZmID8NCj4gPiA+DQo+ID4gPiA+
IEkgdXNlIHNvY2ttYXAgd2l0aCBzdHJwYXJzZXIsIHRoZSBzdG0tPnN0cnAub2Zmc2V0ICh0aGUg
YmVnaW4gb2YNCj4gPiA+ID4gb25lIGFwcGxpY2F0aW9uIGxheWVyIHByb3RvY29sIG1lc3NhZ2Up
IG1heWJlIGJleW9uZCAweGZmZmYsIGJ1dCBpDQo+ID4gPiA+IG5lZWQgbG9hZCB0aGUgbWVzc2Fn
ZSBoZWFkIHRvIGRvIHNvbWV0aGluZy4NCj4gPiA+DQo+ID4gPiBUaGlzIHdvdWxkIGV4cGxhaW4g
c2tiX2xvYWRfYnl0ZXMgYnV0IG5vdCB0aGUgb3RoZXIgdHdvIHJpZ2h0PyBBbHNvDQo+ID4gPiBp
ZiB3ZQ0KPiA+IFllcywgSSBqdXN0IHNlZSB0aGF0IHRoZXNlIHR3byBmdW5jdGlvbnMgaGF2ZSB0
aGUgc2FtZSBqdWRnbWVudC4NCj4gPiA+IGFyZSBkb2luZyB0aGlzIHdoeSBub3QganVzdCByZW1v
dmUgdGhvc2UgdHdvIGNoZWNrcyBpbg0KPiA+ID4gZmxvd19kaXNzZWN0b3JfbG9hZCgpIEkgdGhp
bmsgc2tiX2hlYWRlcl9wb2ludGVyKCkgZG9lcyBkdXBsaWNhdGUNCj4gY2hlY2tzLg0KPiA+ID4g
UGxlYXNlIGNoZWNrLg0KPiA+IFllcywgc2tiX2hlYWRlcl9wb2ludGVyKCkgaGF2ZSBjaGVja2Vk
IGFzIGJlbG93LCBhbmQgSSB3aWxsIHNlbmQgdjIgdG8NCj4gcmVtb3ZlIDB4ZmZmZiBjaGVjay4N
Cj4gPiAtLS0tc2tiX2hlYWRlcl9wb2ludGVyDQo+ID4gLS0tLS0tLS0gX19za2JfaGVhZGVyX3Bv
aW50ZXINCj4gPiAtLS0tLS0tLS0tLS1za2JfY29weV9iaXRzDQo+ID4gLS0tLS0tLS0tLS0tLS0t
LSBpZiAob2Zmc2V0ID4gKGludClza2ItPmxlbiAtIGxlbikNCj4gPiAtLS0tLS0tLS0tLS0tLS0t
LS0tLWdvdG8gZmF1bHQ7DQo+ID4NCj4gPiBUaGFuayB5b3V+DQo+IA0KPiBEbyB3ZSBuZWVkIHRv
IGhhdmUgYXQgbGVhc3QgIm9mZnNldCA8PSAweDdmZmZmZmZmIiBjaGVjaz8gSU9XLCBkbyB3ZSBu
ZWVkDQo+IHRvIGVuZm9yY2UgdGhlIHVuc2lnbmVkbmVzcyBvZiB0aGUgb2Zmc2V0PyBPciBkb2Vz
IHNrYl9oZWFkZXJfcG9pbnRlciBldA0KPiBhbGwgcHJvcGVybHkgd29yayB3aXRoIHRoZSBuZWdh
dGl2ZSBvZmZzZXRzPw0KWWVzLCBza2JfaGVhZGVyX3BvaW50ZXIgY2FuIG5vdCBoYW5kbGUgdGhl
IG5lZ2F0aXZlIG9mZnNldC4NCkkgc2VudCBhIG5ldyBwYXRjaC4gUGxlYXNlIGhlbHAgcmV2aWV3
IGl0IGFnYWluLiBUaGFuayB5b3UuDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2pl
Y3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjIwMzE3MTM1OTQwLjM1ODc3NC0xLWxpdWppYW41NkBodWF3
ZWkuY29tLw0K
