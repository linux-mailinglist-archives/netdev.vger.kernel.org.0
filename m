Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E72C4FB3F2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245054AbiDKGqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbiDKGqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:46:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD64A62E3;
        Sun, 10 Apr 2022 23:44:06 -0700 (PDT)
Received: from kwepemi100007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KcK601WsSzgYbf;
        Mon, 11 Apr 2022 14:42:16 +0800 (CST)
Received: from dggpeml500001.china.huawei.com (7.185.36.227) by
 kwepemi100007.china.huawei.com (7.221.188.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 14:44:04 +0800
Received: from dggpeml500001.china.huawei.com ([7.185.36.227]) by
 dggpeml500001.china.huawei.com ([7.185.36.227]) with mapi id 15.01.2375.024;
 Mon, 11 Apr 2022 14:44:03 +0800
From:   "kongweibin (A)" <kongweibin2@huawei.com>
To:     Eric Dumazet <edumazet@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        liaichun <liaichun@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0XSBpcHY2OiBmaXggcGFuaWMgd2hlbiBmb3J3?=
 =?utf-8?Q?arding_a_pkt_with_no_in6_dev?=
Thread-Topic: [PATCH net] ipv6: fix panic when forwarding a pkt with no in6
 dev
Thread-Index: AQHYS1GFP5ZHyMlOhU6tOD3A4UEJUazmEHeAgAQvdFA=
Date:   Mon, 11 Apr 2022 06:44:03 +0000
Message-ID: <01f85507886e435e97cc86f19abf0661@huawei.com>
References: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
 <20220408140342.19311-1-nicolas.dichtel@6wind.com>
 <85da2373-d8ec-0049-bd3d-6b8f4b044edc@gmail.com>
In-Reply-To: <85da2373-d8ec-0049-bd3d-6b8f4b044edc@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.250]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBrb25nd2VpYmluLCBjb3VsZCB5b3UgdGVzdCB0aGlzIHBhdGNoIHdpdGggeW91ciBzZXR1cD8N
Cj4NCj4gVGhhbmtzLA0KPiBOaWNvbGFzDQo+DQo+ICAgbmV0L2lwdjYvaXA2X291dHB1dC5jIHwg
MiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
Pg0KPiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X291dHB1dC5jIGIvbmV0L2lwdjYvaXA2X291
dHB1dC5jIGluZGV4IA0KPiBlMjNmMDU4MTY2YWYuLmZhNjNlZjJiZDk5YyAxMDA2NDQNCj4gLS0t
IGEvbmV0L2lwdjYvaXA2X291dHB1dC5jDQo+ICsrKyBiL25ldC9pcHY2L2lwNl9vdXRwdXQuYw0K
PiBAQCAtNDg1LDcgKzQ4NSw3IEBAIGludCBpcDZfZm9yd2FyZChzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KQ0KPiAgIAkJZ290byBkcm9wOw0KPiAgIA0KPiAgIAlpZiAoIW5ldC0+aXB2Ni5kZXZjb25mX2Fs
bC0+ZGlzYWJsZV9wb2xpY3kgJiYNCj4gLQkgICAgIWlkZXYtPmNuZi5kaXNhYmxlX3BvbGljeSAm
Jg0KPiArCSAgICAoIWlkZXYgfHwgIWlkZXYtPmNuZi5kaXNhYmxlX3BvbGljeSkgJiYNCj4gICAJ
ICAgICF4ZnJtNl9wb2xpY3lfY2hlY2soTlVMTCwgWEZSTV9QT0xJQ1lfRldELCBza2IpKSB7DQo+
ICAgCQlfX0lQNl9JTkNfU1RBVFMobmV0LCBpZGV2LCBJUFNUQVRTX01JQl9JTkRJU0NBUkRTKTsN
Cj4gICAJCWdvdG8gZHJvcDsNCg0KSSBoYXZlIHRlc3QgdGhlIHBhdGNoIHdpdGggbXkgc2V0dXAs
IGl0IGlzIE9LLg0KDQoNCg0KPj4ga29uZ3dlaWJpbiByZXBvcnRlZCBhIGtlcm5lbCBwYW5pYyBp
biBpcDZfZm9yd2FyZCgpIHdoZW4gaW5wdXQgDQo+PiBpbnRlcmZhY2UgaGFzIG5vIGluNiBkZXYg
YXNzb2NpYXRlZC4NCj4+DQo+PiBUaGUgZm9sbG93aW5nIHRjIGNvbW1hbmRzIHdlcmUgdXNlZCB0
byByZXByb2R1Y2UgdGhpcyBwYW5pYzoNCj4+IHRjIHFkaXNjIGRlbCBkZXYgdnhsYW4xMDAgcm9v
dA0KPj4gdGMgcWRpc2MgYWRkIGRldiB2eGxhbjEwMCByb290IG5ldGVtIGNvcnJ1cHQgNSUNCj4N
Cj5Ob3Qgc3VyZSBJIHVuZGVyc3RhbmQgaG93IHRoZXNlIHFkaXNjIGNoYW5nZXMgY2FuIHRyaWdn
ZXIgYSBOVUxMIGlkZXYgPw0KPg0KPkRvIHdlIGhhdmUgYW5vdGhlciBidWcsIGxpa2Ugc2tiLT5j
YltdIGNvbnRlbnQgYmVpbmcgbWFuZ2xlZCA/DQo+DQoNCkFzIGZvciB3aHkgcWRpc2MgbWFrZXMg
dGhlIGlkZXYgbnVsbCwgSSB0cmFja2VkIHdoZXJlIHRoZSBpaWYgYXNzaWduZWQgaW4gaXA2X3Jj
dl9jb3JlLA0KdGhlcmUgaXMgbm8gcHJvYmxlbSB0aGVyZS4NCg0KTm90IHN1cmUgd2hhdCBoYXMg
Y2hhbmdlZCB0aGF0IG1ha2VzIHRoZSBpaWYgdmFsdWUgd3JvbmcuDQoNCg0K
