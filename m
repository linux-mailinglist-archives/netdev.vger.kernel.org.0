Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCAC56B96D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbiGHMMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiGHMMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:12:31 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E9C9CE16;
        Fri,  8 Jul 2022 05:12:28 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LfXC54ys4z67bmq;
        Fri,  8 Jul 2022 20:09:37 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 14:12:26 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 8 Jul 2022 14:12:26 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "dhowells@redhat.com" <dhowells@redhat.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Subject: RE: [PATCH v6 4/5] bpf: Add bpf_verify_pkcs7_signature() helper
Thread-Topic: [PATCH v6 4/5] bpf: Add bpf_verify_pkcs7_signature() helper
Thread-Index: AQHYiuqGDtlDO2qp4UmZ/vpVUoStkK1xbJmAgACCGICAANf/YIABpDPw
Date:   Fri, 8 Jul 2022 12:12:25 +0000
Message-ID: <2be48d62b0c141799f0c54cbe63f6dc3@huawei.com>
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
 <20220628122750.1895107-5-roberto.sassu@huawei.com>
 <903b1b6c-b0fd-d624-a24b-5983d8d661b7@iogearbox.net>
 <CACYkzJ4iR=FurW2UZdgycTdu54kNoFrw4uvmDrpTd3xuvpvVTw@mail.gmail.com>
 <52aa81c8037640a7935cdfd6f363a07d@huawei.com>
In-Reply-To: <52aa81c8037640a7935cdfd6f363a07d@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBSb2JlcnRvIFNhc3N1IFttYWlsdG86cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tXQ0K
PiBTZW50OiBUaHVyc2RheSwgSnVseSA3LCAyMDIyIDE6MDEgUE0NCj4gPiBGcm9tOiBLUCBTaW5n
aCBbbWFpbHRvOmtwc2luZ2hAa2VybmVsLm9yZ10NCj4gPiBTZW50OiBUaHVyc2RheSwgSnVseSA3
LCAyMDIyIDE6NDkgQU0NCj4gPiBPbiBXZWQsIEp1bCA2LCAyMDIyIGF0IDY6MDQgUE0gRGFuaWVs
IEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4gPiB3cm90ZToNCg0KWy4uLl0NCg0K
PiA+ID4gbml0OiB3aGVuIGJvdGggdHJ1c3RlZF9rZXlyaW5nX3NlcmlhbCBhbmQgdHJ1c3RlZF9r
ZXlyaW5nX2lkIGFyZSBwYXNzZWQgdG8NCj4gdGhlDQo+ID4gPiBoZWxwZXIsIHRoZW4gdGhpcyBz
aG91bGQgYmUgcmVqZWN0ZWQgYXMgaW52YWxpZCBhcmd1bWVudD8gKEtpbmQgb2YgZmVlbHMgYSBi
aXQNCj4gPiA+IGxpa2Ugd2UncmUgY3JhbW1pbmcgdHdvIHRoaW5ncyBpbiBvbmUgaGVscGVyLi4g
S1AsIHRob3VnaHRzPyA6KSkNCj4gPg0KPiA+IEVJTlZBTCB3aGVuIGJvdGggYXJlIHBhc3NlZCBz
ZWVtcyByZWFzb25hYmxlLiBUaGUgc2lnbmF0dXJlIChwdW4/KSBvZiB0aGUNCj4gPiBkb2VzIHNl
ZW0gdG8gZ2V0IGJsb2F0ZWQsIGJ1dCBJIGFtIG5vdCBzdXJlIGlmIGl0J3Mgd29ydGggYWRkaW5n
IHR3bw0KPiA+IGhlbHBlcnMgaGVyZS4NCj4gDQo+IE9rIGZvciBFSU5WQUwuIFNob3VsZCBJIGNo
YW5nZSB0aGUgdHJ1c3RlZF9rZXlyaW5nX2lkIHR5cGUgdG8gc2lnbmVkLA0KPiBhbmQgdXNlIC0x
IHdoZW4gaXQgc2hvdWxkIG5vdCBiZSBzcGVjaWZpZWQ/DQoNCkkgc3RpbGwgaGF2ZSB0aGUgaW1w
cmVzc2lvbiB0aGF0IGEgaGVscGVyIGZvciBsb29rdXBfdXNlcl9rZXkoKSBpcyB0aGUNCnByZWZl
cnJlZCBzb2x1dGlvbiwgZGVzcGl0ZSB0aGUgYWNjZXNzIGNvbnRyb2wgY29uY2Vybi4NCg0KRGF2
aWQsIG1heSBhc2sgaWYgdGhpcyBpcyB0aGUgY29ycmVjdCB3YXkgdG8gdXNlIHRoZSBrZXkgc3Vi
c3lzdGVtDQpBUEkgd2hlbiBwZXJtaXNzaW9uIGNoZWNrIGlzIGRlZmVycmVkPyBrZXlfcGVybWlz
c2lvbigpIGlzIGN1cnJlbnRseQ0Kbm90IGRlZmluZWQgb3V0c2lkZSB0aGUga2V5IHN1YnN5c3Rl
bS4NCg0KVGhlIGZpcnN0IHRocmVlIGZ1bmN0aW9ucyB3aWxsIGJlIGV4cG9zZWQgYnkgdGhlIGtl
cm5lbCB0byBlQlBGIHByb2dyYW1zDQphbmQgY2FuIGJlIGNhbGxlZCBhdCBhbnkgdGltZS4gYnBm
XzxrZXlfaGVscGVyPiBpcyBhIGdlbmVyaWMgaGVscGVyDQpkZWFsaW5nIHdpdGggYSBrZXkuDQoN
CkJQRl9DQUxMXzIoYnBmX2xvb2t1cF91c2VyX2tleSwgdTMyLCBzZXJpYWwsIHVuc2lnbmVkIGxv
bmcsIGZsYWdzKQ0Kew0KLi4uDQogICAgICAgIGtleV9yZWYgPSBsb29rdXBfdXNlcl9rZXkoc2Vy
aWFsLCBmbGFncywgS0VZX0RFRkVSX1BFUk1fQ0hFQ0spOw0KLi4uDQogICAgICAgIHJldHVybiAo
dW5zaWduZWQgbG9uZylrZXlfcmVmX3RvX3B0cihrZXlfcmVmKTsNCn0NCg0KQlBGX0NBTExfWChi
cGZfPGtleV9oZWxwZXI+LCBzdHJ1Y3Qga2V5LCAqa2V5LCAuLi4pDQp7DQogICAgICAgIHJldCA9
IGtleV9yZWFkX3N0YXRlKGtleSk7DQouLi4NCiAgICAgICAgcmV0ID0ga2V5X3ZhbGlkYXRlKGtl
eSk7DQouLi4NCiAgICAgICAgcmV0ID0ga2V5X3Blcm1pc3Npb24oa2V5X3JlZiwgPGtleSBoZWxw
ZXItc3BlY2lmaWMgcGVybWlzc2lvbj4pOw0KLi4uDQp9DQoNCkJQRl9DQUxMXzEoYnBmX2tleV9w
dXQsIHN0cnVjdCBrZXkgKiwga2V5KQ0Kew0KICAgICAgICBrZXlfcHV0KGtleSk7DQogICAgICAg
IHJldHVybiAwOw0KfQ0KDQpBbiBlQlBGIHByb2dyYW0gd291bGQgZG8gZm9yIGV4YW1wbGU6DQoN
ClNFQygibHNtLnMvYnBmIikNCmludCBCUEZfUFJPRyhicGYsIGludCBjbWQsIHVuaW9uIGJwZl9h
dHRyICphdHRyLCB1bnNpZ25lZCBpbnQgc2l6ZSkNCnsNCiAgICAgICAgc3RydWN0IGtleSAqa2V5
Ow0KLi4uDQogICAgICAgIGtleSA9IGJwZl9sb29rdXBfdXNlcl9rZXkoc2VyaWFsLCBmbGFncyk7
DQouLi4NCiAgICAgICAgcmV0ID0gYnBmX2tleV9oZWxwZXIoa2V5LCAuLi4pOw0KLi4uDQogICAg
ICAgIGtleV9wdXQoa2V5KTsNCn0NCg0KVGhhbmtzDQoNClJvYmVydG8NCg==
