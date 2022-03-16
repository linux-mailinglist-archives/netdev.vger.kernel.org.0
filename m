Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E14DB064
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 14:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355982AbiCPNJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 09:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiCPNJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 09:09:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB51CB19;
        Wed, 16 Mar 2022 06:08:26 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KJVsr50QczfYsf;
        Wed, 16 Mar 2022 21:06:56 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 21:08:24 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2308.021;
 Wed, 16 Mar 2022 21:08:24 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Topic: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Index: AQHYOGk2O/XwDW4Ml0q7jRHCigZ/yqzAVx0AgADbdhD//6smgIABGg3Q
Date:   Wed, 16 Mar 2022 13:08:24 +0000
Message-ID: <5cee2fb729624f168415d303cff4ee8f@huawei.com>
References: <20220315123916.110409-1-liujian56@huawei.com>
 <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
 <4f937ace70a3458580c6242fa68ea549@huawei.com>
 <623160c966680_94df20819@john.notmuch>
In-Reply-To: <623160c966680_94df20819@john.notmuch>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFy
Y2ggMTYsIDIwMjIgMTI6MDAgUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdl
aS5jb20+OyBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQo+IENjOiBhc3RAa2VybmVs
Lm9yZzsgZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGFuZHJpaUBrZXJuZWwub3JnOw0KPiBzb25nbGl1
YnJhdmluZ0BmYi5jb207IHloc0BmYi5jb207IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsNCj4g
a3BzaW5naEBrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7
DQo+IHNkZkBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggYnBmLW5leHRdIG5ldDogVXNlIHNrYi0+bGVu
IHRvIGNoZWNrIHRoZSB2YWxpZGl0eSBvZiB0aGUNCj4gcGFyYW1ldGVycyBpbiBicGZfc2tiX2xv
YWRfYnl0ZXMNCj4gDQo+IGxpdWppYW4gKENFKSB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogTWFydGluIEthRmFpIExhdSBbbWFp
bHRvOmthZmFpQGZiLmNvbV0NCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMTYsIDIwMjIg
Mzo1OCBBTQ0KPiA+ID4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+
ID4gPiBDYzogYXN0QGtlcm5lbC5vcmc7IGRhbmllbEBpb2dlYXJib3gubmV0OyBhbmRyaWlAa2Vy
bmVsLm9yZzsNCj4gPiA+IHNvbmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsgam9obi5m
YXN0YWJlbmRAZ21haWwuY29tOw0KPiA+ID4ga3BzaW5naEBrZXJuZWwub3JnOyBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7DQo+ID4gPiBzZGZAZ29vZ2xlLmNvbTsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6
IFtQQVRDSCBicGYtbmV4dF0gbmV0OiBVc2Ugc2tiLT5sZW4gdG8gY2hlY2sgdGhlDQo+ID4gPiB2
YWxpZGl0eSBvZiB0aGUgcGFyYW1ldGVycyBpbiBicGZfc2tiX2xvYWRfYnl0ZXMNCj4gPiA+DQo+
ID4gPiBPbiBUdWUsIE1hciAxNSwgMjAyMiBhdCAwODozOToxNlBNICswODAwLCBMaXUgSmlhbiB3
cm90ZToNCj4gPiA+ID4gVGhlIGRhdGEgbGVuZ3RoIG9mIHNrYiBmcmFncyArIGZyYWdfbGlzdCBt
YXkgYmUgZ3JlYXRlciB0aGFuDQo+ID4gPiA+IDB4ZmZmZiwgc28gaGVyZSB1c2Ugc2tiLT5sZW4g
dG8gY2hlY2sgdGhlIHZhbGlkaXR5IG9mIHRoZSBwYXJhbWV0ZXJzLg0KPiA+ID4gV2hhdCBpcyB0
aGUgdXNlIGNhc2UgdGhhdCBuZWVkcyB0byBsb29rIGJleW9uZCAweGZmZmYgPw0KPiANCj4gPiBJ
IHVzZSBzb2NrbWFwIHdpdGggc3RycGFyc2VyLCB0aGUgc3RtLT5zdHJwLm9mZnNldCAodGhlIGJl
Z2luIG9mIG9uZQ0KPiA+IGFwcGxpY2F0aW9uIGxheWVyIHByb3RvY29sIG1lc3NhZ2UpIG1heWJl
IGJleW9uZCAweGZmZmYsIGJ1dCBpIG5lZWQNCj4gPiBsb2FkIHRoZSBtZXNzYWdlIGhlYWQgdG8g
ZG8gc29tZXRoaW5nLg0KPiANCj4gVGhpcyB3b3VsZCBleHBsYWluIHNrYl9sb2FkX2J5dGVzIGJ1
dCBub3QgdGhlIG90aGVyIHR3byByaWdodD8gQWxzbyBpZiB3ZQ0KWWVzLCBJIGp1c3Qgc2VlIHRo
YXQgdGhlc2UgdHdvIGZ1bmN0aW9ucyBoYXZlIHRoZSBzYW1lIGp1ZGdtZW50Lg0KPiBhcmUgZG9p
bmcgdGhpcyB3aHkgbm90IGp1c3QgcmVtb3ZlIHRob3NlIHR3byBjaGVja3MgaW4NCj4gZmxvd19k
aXNzZWN0b3JfbG9hZCgpIEkgdGhpbmsgc2tiX2hlYWRlcl9wb2ludGVyKCkgZG9lcyBkdXBsaWNh
dGUgY2hlY2tzLg0KPiBQbGVhc2UgY2hlY2suDQpZZXMsIHNrYl9oZWFkZXJfcG9pbnRlcigpIGhh
dmUgY2hlY2tlZCBhcyBiZWxvdywgYW5kIEkgd2lsbCBzZW5kIHYyIHRvIHJlbW92ZSAweGZmZmYg
Y2hlY2suDQotLS0tc2tiX2hlYWRlcl9wb2ludGVyDQotLS0tLS0tLSBfX3NrYl9oZWFkZXJfcG9p
bnRlcg0KLS0tLS0tLS0tLS0tc2tiX2NvcHlfYml0cw0KLS0tLS0tLS0tLS0tLS0tLSBpZiAob2Zm
c2V0ID4gKGludClza2ItPmxlbiAtIGxlbikNCi0tLS0tLS0tLS0tLS0tLS0tLS0tZ290byBmYXVs
dDsNCg0KVGhhbmsgeW91fg0K
