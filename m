Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590924F5B94
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiDFKer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344608AbiDFKeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:34:00 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD25491D9B;
        Tue,  5 Apr 2022 23:55:54 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KYFbx609Tz67VyR;
        Wed,  6 Apr 2022 14:54:05 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Apr 2022 08:55:52 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 6 Apr 2022 08:55:52 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [POC][USER SPACE][PATCH] Introduce LSM to protect pinned objects
Thread-Topic: [POC][USER SPACE][PATCH] Introduce LSM to protect pinned objects
Thread-Index: AQHYSO6qHvGxtTZjlkOpBqG6raB3mazhyt4AgACodAA=
Date:   Wed, 6 Apr 2022 06:55:51 +0000
Message-ID: <5ed9f7c8fab7426daf400756b2d8ea89@huawei.com>
References: <CACYkzJ7ZVbL2MG7ugmDEfogSPAHkYYMCHxRO_eBCJJmBZyn6Rw@mail.gmail.com>
        <20220405131116.3810418-1-roberto.sassu@huawei.com>
 <5ce85845-824c-32fb-3807-6f9ab95ad6fe@schaufler-ca.com>
In-Reply-To: <5ce85845-824c-32fb-3807-6f9ab95ad6fe@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.215.171]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBDYXNleSBTY2hhdWZsZXIgW21haWx0bzpjYXNleUBzY2hhdWZsZXItY2EuY29tXQ0K
PiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDYsIDIwMjIgMTI6NDggQU0NCj4gT24gNC81LzIwMjIg
NjoxMSBBTSwgUm9iZXJ0byBTYXNzdSB3cm90ZToNCj4gPiBJbnRyb2R1Y2UgYSBuZXcgTFNNIHRv
IHByb3RlY3QgcGlubmVkIG9iamVjdHMgaW4gYSBicGYgZmlsZXN5c3RlbQ0KPiANCj4gVGhpcyBp
cyAqbm90IGFuIExTTSouIERvIG5vdCBjYWxsIGl0IGFuIExTTS4gSXQgaXMgYSBzZXQgb2YNCj4g
ZUJQRiBwcm9ncmFtcy4gV2UgaGF2ZSBhbGwgdGhlIG9wcG9ydHVuaXRpZXMgZm9yIGNvbmZ1c2lv
bg0KPiB0aGF0IHdlIG5lZWQuIEkgc3VnZ2VzdGVkIHRoYXQgeW91IGNhbGwgdGhpcyBhIEJQRiBz
ZWN1cml0eQ0KPiBtb2R1bGUgKEJTTSkgZWFybGllciB0b2RheS4gWW91IGhhdmUgYW55IG51bWJl
ciBvZiB0aGluZ3MNCj4geW91IGNhbiBjYWxsIHRoaXMgdGhhdCB3b24ndCBiZSBvYmplY3Rpb25h
YmxlLg0KPiANCj4gPiBpbnN0YW5jZS4gVGhpcyBpcyB1c2VmdWwgZm9yIGV4YW1wbGUgdG8gZW5z
dXJlIHRoYXQgYW4gTFNNIHdpbGwgYWx3YXlzDQo+ID4gZW5mb3JjZSBpdHMgcG9saWN5LCBldmVu
IGRlc3BpdGUgcm9vdCB0cmllcyB0byB1bmxvYWQgdGhlIGNvcnJlc3BvbmRpbmcNCj4gPiBlQlBG
IHByb2dyYW0uDQo+IA0KPiBIb3cgaXMgdGhpcyBnb2luZyB0byBlbnN1cmUgdGhhdCBTRUxpbnV4
IGVuZm9yY2VzIGl0cyBwb2xpY3k/DQoNCkkgc2hvdWxkIGhhdmUgc2FpZCBhYm92ZTogdGhhdCBh
biBMU00gaW1wbGVtZW50ZWQgd2l0aCBlQlBGLg0KQnVpbHQtaW4gTFNNcyBhcmUgbm90IGFmZmVj
dGVkIGJ5IHRoaXMgY2hhbmdlLg0KDQpPaywgbmV4dCB0aW1lIEkgY2FsbCBpdCBCU00uDQoNClRo
YW5rcw0KDQpSb2JlcnRvDQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwg
SFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQ0KDQo+
IEFwcEFybW9yIGhhcyBubyBlQlBGIHByb2dyYW0gdGhhdCBjb3JyZXNwb25kcyB0byBpdHMgcG9s
aWN5LA0KPiBuZWl0aGVyIGRvZXMgYW55IG90aGVyIGV4aXN0aW5nIExTTSwgc2F2ZSBCUEYuIFlv
dXIgY2xhaW0gaXMNCj4gbm9uc2Vuc2ljYWwgaW4gdGhlIGZhY2Ugb2YgTFNNIGJlaGF2aW9yLg0K
PiANCj4gPiBBY2hpZXZlIHRoZSBwcm90ZWN0aW9uIGJ5IGRlbnlpbmcgaW5vZGUgdW5saW5rIGFu
ZCB1bm1vdW50IG9mIHRoZQ0KPiA+IHByb3RlY3RlZCBicGYgZmlsZXN5c3RlbSBpbnN0YW5jZS4g
U2luY2UgcHJvdGVjdGVkIGlub2RlcyBob2xkIGENCj4gPiByZWZlcmVuY2Ugb2YgdGhlIGxpbmsg
b2YgbG9hZGVkIHByb2dyYW1zIChlLmcuIExTTSBob29rcyksIGRlbnlpbmcNCj4gPiBvcGVyYXRp
b25zIG9uIHRoZW0gd2lsbCBwcmV2ZW50IHRoZSByZWYgY291bnQgb2YgdGhlIGxpbmtzIGZyb20g
cmVhY2hpbmcNCj4gPiB6ZXJvLCBlbnN1cmluZyB0aGF0IHRoZSBwcm9ncmFtcyByZW1haW4gYWx3
YXlzIGFjdGl2ZS4NCj4gPg0KPiA+IEVuYWJsZSB0aGUgcHJvdGVjdGlvbiBvbmx5IGZvciB0aGUg
aW5zdGFuY2UgY3JlYXRlZCBieSB0aGUgdXNlciBzcGFjZQ0KPiA+IGNvdW50ZXJwYXJ0IG9mIHRo
ZSBMU00sIGFuZCBkb24ndCBpbnRlcmZlcmUgd2l0aCBvdGhlciBpbnN0YW5jZXMsIHNvDQo+ID4g
dGhhdCB0aGVpciBiZWhhdmlvciByZW1haW5zIHVuY2hhbmdlZC4NCj4gPg0KPiA+IFN1Z2dlc3Rl
ZC1ieTogRGphbGFsIEhhcm91bmkgPHRpeHhkekBnbWFpbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+
ICAgLmdpdGlnbm9yZSAgICAgICB8ICA0ICsrKw0KPiA+ICAgTWFrZWZpbGUgICAgICAgICB8IDE4
ICsrKysrKysrKysrKysrDQo+ID4gICBicGZmc19sc21fa2Vybi5jIHwgNjMNCj4gKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gICBicGZmc19sc21f
dXNlci5jIHwgNjANCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gICA0IGZpbGVzIGNoYW5nZWQsIDE0NSBpbnNlcnRpb25zKCspDQo+ID4gICBjcmVh
dGUgbW9kZSAxMDA2NDQgLmdpdGlnbm9yZQ0KPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IE1ha2Vm
aWxlDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgYnBmZnNfbHNtX2tlcm4uYw0KPiA+ICAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IGJwZmZzX2xzbV91c2VyLmMNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS8u
Z2l0aWdub3JlIGIvLmdpdGlnbm9yZQ0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5k
ZXggMDAwMDAwMDAwMDAwLi43ZmEwMjk2NGYxZGMNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysr
IGIvLmdpdGlnbm9yZQ0KPiA+IEBAIC0wLDAgKzEsNCBAQA0KPiA+ICsqLm8NCj4gPiArdm1saW51
eC5oDQo+ID4gK2JwZmZzX2xzbV9rZXJuLnNrZWwuaA0KPiA+ICticGZmc19sc21fdXNlcg0KPiA+
IGRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmMzZDgwNTc1OWRiMw0KPiA+IC0tLSAvZGV2L251
bGwNCj4gPiArKysgYi9NYWtlZmlsZQ0KPiA+IEBAIC0wLDAgKzEsMTggQEANCj4gPiArIyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+ICthbGw6IGJwZmZzX2xzbV91c2VyDQo+
ID4gKw0KPiA+ICtjbGVhbjoNCj4gPiArCXJtIC1yZiBicGZmc19sc20uc2tlbC5oIHZtbGludXgu
aCBicGZmc19sc21fa2Vybi5vIGJwZmZzX2xzbV91c2VyDQo+ID4gKw0KPiA+ICt2bWxpbnV4Lmg6
DQo+ID4gKwkvdXNyL3NiaW4vYnBmdG9vbCBidGYgZHVtcCBmaWxlIC9zeXMva2VybmVsL2J0Zi92
bWxpbnV4IGZvcm1hdCBjID4gXA0KPiA+ICsJCQkgIHZtbGludXguaA0KPiA+ICsNCj4gPiArYnBm
ZnNfbHNtX2tlcm4uc2tlbC5oOiBicGZmc19sc21fa2Vybi5vDQo+ID4gKwlicGZ0b29sIGdlbiBz
a2VsZXRvbiAkPCA+ICRADQo+ID4gKw0KPiA+ICticGZmc19sc21fa2Vybi5vOiBicGZmc19sc21f
a2Vybi5jIHZtbGludXguaA0KPiA+ICsJY2xhbmcgLVdhbGwgLVdlcnJvciAtZyAtTzIgLXRhcmdl
dCBicGYgLWMgJDwgLW8gJEANCj4gPiArDQo+ID4gK2JwZmZzX2xzbV91c2VyOiBicGZmc19sc21f
dXNlci5jIGJwZmZzX2xzbV9rZXJuLnNrZWwuaA0KPiBicGZmc19sc21fa2Vybi5vDQo+ID4gKwlj
YyAtV2FsbCAtV2Vycm9yIC1nIC1vICRAICQ8IC1sYnBmDQo+ID4gZGlmZiAtLWdpdCBhL2JwZmZz
X2xzbV9rZXJuLmMgYi9icGZmc19sc21fa2Vybi5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmIzY2NiMmE3NWM5NQ0KPiA+IC0tLSAvZGV2L251bGwN
Cj4gPiArKysgYi9icGZmc19sc21fa2Vybi5jDQo+ID4gQEAgLTAsMCArMSw2MyBAQA0KPiA+ICsv
LyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+ICsvKg0KPiA+ICsgKiBDb3B5
cmlnaHQgKEMpIDIwMjIgSHVhd2VpIFRlY2hub2xvZ2llcyBEdWVzc2VsZG9yZiBHbWJIDQo+ID4g
KyAqDQo+ID4gKyAqIEF1dGhvcnM6DQo+ID4gKyAqIFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fz
c3VAaHVhd2VpLmNvbT4NCj4gPiArICoNCj4gPiArICogSW1wbGVtZW50IGFuIExTTSB0byBwcm90
ZWN0IGEgYnBmIGZpbGVzeXN0ZW0gaW5zdGFuY2UuDQo+ID4gKyAqLw0KPiA+ICsNCj4gPiArI2lu
Y2x1ZGUgInZtbGludXguaCINCj4gPiArI2luY2x1ZGUgPGVycm5vLmg+DQo+ID4gKyNpbmNsdWRl
IDxicGYvYnBmX2hlbHBlcnMuaD4NCj4gPiArI2luY2x1ZGUgPGJwZi9icGZfdHJhY2luZy5oPg0K
PiA+ICsjaW5jbHVkZSA8YnBmL2JwZl9jb3JlX3JlYWQuaD4NCj4gPiArDQo+ID4gK2NoYXIgX2xp
Y2Vuc2VbXSBTRUMoImxpY2Vuc2UiKSA9ICJHUEwiOw0KPiA+ICsNCj4gPiArdWludDMyX3QgbW9u
aXRvcmVkX3BpZCA9IDA7DQo+ID4gKw0KPiA+ICtzdHJ1Y3Qgew0KPiA+ICsJX191aW50KHR5cGUs
IEJQRl9NQVBfVFlQRV9JTk9ERV9TVE9SQUdFKTsNCj4gPiArCV9fdWludChtYXBfZmxhZ3MsIEJQ
Rl9GX05PX1BSRUFMTE9DKTsNCj4gPiArCV9fdHlwZShrZXksIGludCk7DQo+ID4gKwlfX3R5cGUo
dmFsdWUsIHNpemVvZih1aW50OF90KSk7DQo+ID4gK30gaW5vZGVfc3RvcmFnZV9tYXAgU0VDKCIu
bWFwcyIpOw0KPiA+ICsNCj4gPiArU0VDKCJsc20vc2Jfc2V0X21udF9vcHRzIikNCj4gPiAraW50
IEJQRl9QUk9HKHNiX3NldF9tbnRfb3B0cywgc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgdm9pZA0K
PiAqbW50X29wdHMsDQo+ID4gKwkgICAgIHVuc2lnbmVkIGxvbmcga2Vybl9mbGFncywgdW5zaWdu
ZWQgbG9uZyAqc2V0X2tlcm5fZmxhZ3MpDQo+ID4gK3sNCj4gPiArCXUzMiBwaWQ7DQo+ID4gKw0K
PiA+ICsJcGlkID0gYnBmX2dldF9jdXJyZW50X3BpZF90Z2lkKCkgPj4gMzI7DQo+ID4gKwlpZiAo
cGlkICE9IG1vbml0b3JlZF9waWQpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJaWYg
KCFicGZfaW5vZGVfc3RvcmFnZV9nZXQoJmlub2RlX3N0b3JhZ2VfbWFwLCBzYi0+c19yb290LQ0K
PiA+ZF9pbm9kZSwgMCwNCj4gPiArCQkJCSAgIEJQRl9MT0NBTF9TVE9SQUdFX0dFVF9GX0NSRUFU
RSkpDQo+ID4gKwkJcmV0dXJuIC1FUEVSTTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiArU0VDKCJsc20vaW5vZGVfdW5saW5rIikNCj4gPiAraW50IEJQRl9QUk9H
KGlub2RlX3VubGluaywgc3RydWN0IGlub2RlICpkaXIsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkN
Cj4gPiArew0KPiA+ICsJaWYgKGJwZl9pbm9kZV9zdG9yYWdlX2dldCgmaW5vZGVfc3RvcmFnZV9t
YXAsDQo+ID4gKwkJCQkgIGRpci0+aV9zYi0+c19yb290LT5kX2lub2RlLCAwLCAwKSkNCj4gPiAr
CQlyZXR1cm4gLUVQRVJNOw0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0K
PiA+ICtTRUMoImxzbS9zYl91bW91bnQiKQ0KPiA+ICtpbnQgQlBGX1BST0coc2JfdW1vdW50LCBz
dHJ1Y3QgdmZzbW91bnQgKm1udCwgaW50IGZsYWdzKQ0KPiA+ICt7DQo+ID4gKwlpZiAoYnBmX2lu
b2RlX3N0b3JhZ2VfZ2V0KCZpbm9kZV9zdG9yYWdlX21hcCwNCj4gPiArCQkJCSAgbW50LT5tbnRf
c2ItPnNfcm9vdC0+ZF9pbm9kZSwgMCwgMCkpDQo+ID4gKwkJcmV0dXJuIC1FUEVSTTsNCj4gPiAr
DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+IGRpZmYgLS1naXQgYS9icGZmc19sc21fdXNl
ci5jIGIvYnBmZnNfbHNtX3VzZXIuYw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5k
ZXggMDAwMDAwMDAwMDAwLi5lMjAxODBjYzVkYjkNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysr
IGIvYnBmZnNfbHNtX3VzZXIuYw0KPiA+IEBAIC0wLDAgKzEsNjAgQEANCj4gPiArLy8gU1BEWC1M
aWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gPiArLyoNCj4gPiArICogQ29weXJpZ2h0IChD
KSAyMDIyIEh1YXdlaSBUZWNobm9sb2dpZXMgRHVlc3NlbGRvcmYgR21iSA0KPiA+ICsgKg0KPiA+
ICsgKiBBdXRob3I6IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4NCj4g
PiArICoNCj4gPiArICogSW1wbGVtZW50IHRoZSB1c2VyIHNwYWNlIHNpZGUgb2YgdGhlIExTTSBm
b3IgYnBmZnMuDQo+ID4gKyAqLw0KPiA+ICsNCj4gPiArI2luY2x1ZGUgPGZjbnRsLmg+DQo+ID4g
KyNpbmNsdWRlIDx1bmlzdGQuaD4NCj4gPiArI2luY2x1ZGUgPHN0ZGlvLmg+DQo+ID4gKyNpbmNs
dWRlIDxlcnJuby5oPg0KPiA+ICsjaW5jbHVkZSA8c3RkbGliLmg+DQo+ID4gKyNpbmNsdWRlIDx1
bmlzdGQuaD4NCj4gPiArI2luY2x1ZGUgPGxpbWl0cy5oPg0KPiA+ICsjaW5jbHVkZSA8c3lzL21v
dW50Lmg+DQo+ID4gKyNpbmNsdWRlIDxzeXMvc3RhdC5oPg0KPiA+ICsNCj4gPiArI2luY2x1ZGUg
ImJwZmZzX2xzbV9rZXJuLnNrZWwuaCINCj4gPiArDQo+ID4gKyNkZWZpbmUgTU9VTlRfRkxBR1Mg
KE1TX05PU1VJRCB8IE1TX05PREVWIHwgTVNfTk9FWEVDIHwNCj4gTVNfUkVMQVRJTUUpDQo+ID4g
Kw0KPiA+ICtpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKQ0KPiA+ICt7DQo+ID4gKwlj
aGFyIG1udHBvaW50W10gPSAiL3RtcC9icGZfcHJpdmF0ZV9tb3VudFhYWFhYWCI7DQo+ID4gKwlj
aGFyIHBhdGhbUEFUSF9NQVhdOw0KPiA+ICsJc3RydWN0IGJwZmZzX2xzbV9rZXJuICpza2VsOw0K
PiA+ICsJaW50IHJldCwgaTsNCj4gPiArDQo+ID4gKwlza2VsID0gYnBmZnNfbHNtX2tlcm5fX29w
ZW5fYW5kX2xvYWQoKTsNCj4gPiArCWlmICghc2tlbCkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gPiArDQo+ID4gKwlyZXQgPSBicGZmc19sc21fa2Vybl9fYXR0YWNoKHNrZWwpOw0KPiA+ICsJ
aWYgKHJldCA8IDApDQo+ID4gKwkJZ290byBvdXRfZGVzdHJveTsNCj4gPiArDQo+ID4gKwlta2R0
ZW1wKG1udHBvaW50KTsNCj4gPiArDQo+ID4gKwlza2VsLT5ic3MtPm1vbml0b3JlZF9waWQgPSBn
ZXRwaWQoKTsNCj4gPiArCXJldCA9IG1vdW50KG1udHBvaW50LCBtbnRwb2ludCwgImJwZiIsIE1P
VU5UX0ZMQUdTLCBOVUxMKTsNCj4gPiArCXNrZWwtPmJzcy0+bW9uaXRvcmVkX3BpZCA9IDA7DQo+
ID4gKw0KPiA+ICsJaWYgKHJldCA8IDApDQo+ID4gKwkJZ290byBvdXRfZGVzdHJveTsNCj4gPiAr
DQo+ID4gKwlmb3IgKGkgPSAwOyBpIDwgc2tlbC0+c2tlbGV0b24tPnByb2dfY250OyBpKyspIHsN
Cj4gPiArCQlzbnByaW50ZihwYXRoLCBzaXplb2YocGF0aCksICIlcy8lcyIsIG1udHBvaW50LA0K
PiA+ICsJCQkgc2tlbC0+c2tlbGV0b24tPnByb2dzW2ldLm5hbWUpOw0KPiA+ICsJCXJldCA9IGJw
Zl9saW5rX19waW4oKnNrZWwtPnNrZWxldG9uLT5wcm9nc1tpXS5saW5rLCBwYXRoKTsNCj4gPiAr
CQlpZiAocmV0IDwgMCkNCj4gPiArCQkJZ290byBvdXRfZGVzdHJveTsNCj4gPiArCX0NCj4gPiAr
DQo+ID4gKwlyZXQgPSAwOw0KPiA+ICtvdXRfZGVzdHJveToNCj4gPiArCWJwZmZzX2xzbV9rZXJu
X19kZXN0cm95KHNrZWwpOw0KPiA+ICsJcmV0dXJuIHJldDsNCj4gPiArfQ0KDQo=
