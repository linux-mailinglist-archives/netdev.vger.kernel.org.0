Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD474F1AE0
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245477AbiDDVTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379526AbiDDRW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:22:59 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4081E3E9;
        Mon,  4 Apr 2022 10:21:02 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KXHYv3f92z67MtS;
        Tue,  5 Apr 2022 01:18:59 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 4 Apr 2022 19:20:59 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Mon, 4 Apr 2022 19:20:59 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Djalal Harouni <tixxdz@gmail.com>, KP Singh <kpsingh@kernel.org>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
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
Subject: RE: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Topic: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Index: AQHYQsxoL5kXhl8+JE6PJPNWV+NOTqzYppqAgABrSsCAAo7zgIAAEt0AgAOU8YCAALoz0A==
Date:   Mon, 4 Apr 2022 17:20:59 +0000
Message-ID: <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
 <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
 <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com>
In-Reply-To: <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.208.245]
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

PiBGcm9tOiBEamFsYWwgSGFyb3VuaSBbbWFpbHRvOnRpeHhkekBnbWFpbC5jb21dDQo+IFNlbnQ6
IE1vbmRheSwgQXByaWwgNCwgMjAyMiA5OjQ1IEFNDQo+IE9uIFN1biwgQXByIDMsIDIwMjIgYXQg
NTo0MiBQTSBLUCBTaW5naCA8a3BzaW5naEBrZXJuZWwub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9u
IFNhdCwgQXByIDIsIDIwMjIgYXQgMTo1NSBBTSBBbGV4ZWkgU3Rhcm92b2l0b3YNCj4gPiA8YWxl
eGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+IC4uLg0KPiA+ID4NCj4gPiA+ID4g
UGlubmluZw0KPiA+ID4gPiB0aGVtIHRvIHVucmVhY2hhYmxlIGlub2RlcyBpbnR1aXRpdmVseSBs
b29rZWQgdGhlDQo+ID4gPiA+IHdheSB0byBnbyBmb3IgYWNoaWV2aW5nIHRoZSBzdGF0ZWQgZ29h
bC4NCj4gPiA+DQo+ID4gPiBXZSBjYW4gY29uc2lkZXIgaW5vZGVzIGluIGJwZmZzIHRoYXQgYXJl
IG5vdCB1bmxpbmthYmxlIGJ5IHJvb3QNCj4gPiA+IGluIHRoZSBmdXR1cmUsIGJ1dCBjZXJ0YWlu
bHkgbm90IGZvciB0aGlzIHVzZSBjYXNlLg0KPiA+DQo+ID4gQ2FuIHRoaXMgbm90IGJlIGFscmVh
ZHkgZG9uZSBieSBhZGRpbmcgYSBCUEZfTFNNIHByb2dyYW0gdG8gdGhlDQo+ID4gaW5vZGVfdW5s
aW5rIExTTSBob29rPw0KPiA+DQo+IA0KPiBBbHNvLCBiZXNpZGUgb2YgdGhlIGlub2RlX3VubGlu
ay4uLiBhbmQgb3V0IG9mIGN1cmlvc2l0eTogbWFraW5nIHN5c2ZzL2JwZmZzLw0KPiByZWFkb25s
eSBhZnRlciBwaW5uaW5nLCB0aGVuIHVzaW5nIGJwZiBMU00gaG9va3MNCj4gc2JfbW91bnR8cmVt
b3VudHx1bm1vdW50Li4uDQo+IGZhbWlseSBjb21iaW5pbmcgYnBmKCkgTFNNIGhvb2suLi4gaXNu
J3QgdGhpcyBlbm91Z2ggdG86DQo+IDEuIFJlc3RyaWN0IHdobyBjYW4gcGluIHRvIGJwZmZzIHdp
dGhvdXQgdXNpbmcgYSBmdWxsIE1BQw0KPiAyLiBSZXN0cmljdCB3aG8gY2FuIGRlbGV0ZSBvciB1
bm1vdW50IGJwZiBmaWxlc3lzdGVtDQo+IA0KPiA/DQoNCkknbSB0aGlua2luZyB0byBpbXBsZW1l
bnQgc29tZXRoaW5nIGxpa2UgdGhpcy4NCg0KRmlyc3QsIEkgYWRkIGEgbmV3IHByb2dyYW0gZmxh
ZyBjYWxsZWQNCkJQRl9GX1NUT1BfT05DT05GSVJNLCB3aGljaCBjYXVzZXMgdGhlIHJlZiBjb3Vu
dA0Kb2YgdGhlIGxpbmsgdG8gaW5jcmVhc2UgdHdpY2UgYXQgY3JlYXRpb24gdGltZS4gSW4gdGhp
cyB3YXksDQp1c2VyIHNwYWNlIGNhbm5vdCBtYWtlIHRoZSBsaW5rIGRpc2FwcGVhciwgdW5sZXNz
IGENCmNvbmZpcm1hdGlvbiBpcyBleHBsaWNpdGx5IHNlbnQgdmlhIHRoZSBicGYoKSBzeXN0ZW0g
Y2FsbC4NCg0KQW5vdGhlciBhZHZhbnRhZ2UgaXMgdGhhdCBvdGhlciBMU01zIGNhbiBkZWNpZGUN
CndoZXRoZXIgb3Igbm90IHRoZXkgYWxsb3cgYSBwcm9ncmFtIHdpdGggdGhpcyBmbGFnDQooaW4g
dGhlIGJwZiBzZWN1cml0eSBob29rKS4NCg0KVGhpcyB3b3VsZCB3b3JrIHJlZ2FyZGxlc3Mgb2Yg
dGhlIG1ldGhvZCB1c2VkIHRvDQpsb2FkIHRoZSBlQlBGIHByb2dyYW0gKHVzZXIgc3BhY2Ugb3Ig
a2VybmVsIHNwYWNlKS4NCg0KU2Vjb25kLCBJIGV4dGVuZCB0aGUgYnBmKCkgc3lzdGVtIGNhbGwg
d2l0aCBhIG5ldw0Kc3ViY29tbWFuZCwgQlBGX0xJTktfQ09ORklSTV9TVE9QLCB3aGljaA0KZGVj
cmVhc2VzIHRoZSByZWYgY291bnQgZm9yIHRoZSBsaW5rIG9mIHRoZSBwcm9ncmFtcw0Kd2l0aCB0
aGUgQlBGX0ZfU1RPUF9PTkNPTkZJUk0gZmxhZy4gSSB3aWxsIGFsc28NCmludHJvZHVjZSBhIG5l
dyBzZWN1cml0eSBob29rIChzb21ldGhpbmcgbGlrZQ0Kc2VjdXJpdHlfbGlua19jb25maXJtX3N0
b3ApLCBzbyB0aGF0IGFuIExTTSBoYXMgdGhlDQpvcHBvcnR1bml0eSB0byBkZW55IHRoZSBzdG9w
ICh0aGUgYnBmIHNlY3VyaXR5IGhvb2sNCndvdWxkIG5vdCBiZSBzdWZmaWNpZW50IHRvIGRldGVy
bWluZSBleGFjdGx5IGZvcg0Kd2hpY2ggbGluayB0aGUgY29uZmlybWF0aW9uIGlzIGdpdmVuLCBh
biBMU00gc2hvdWxkDQpiZSBhYmxlIHRvIGRlbnkgdGhlIHN0b3AgZm9yIGl0cyBvd24gcHJvZ3Jh
bXMpLg0KDQpXaGF0IGRvIHlvdSB0aGluaz8NCg0KVGhhbmtzDQoNClJvYmVydG8NCg0KSFVBV0VJ
IFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERpcmVj
dG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQo=
