Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FDF5FA12A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJJPef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJJPed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:34:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F22B6EF06
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 08:34:29 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-30-qZZPPUTDMaCpoudlwyzcJw-1; Mon, 10 Oct 2022 16:34:26 +0100
X-MC-Unique: qZZPPUTDMaCpoudlwyzcJw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 10 Oct
 2022 16:34:25 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Mon, 10 Oct 2022 16:34:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paul Moore' <paul@paul-moore.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
Subject: RE: SO_PEERSEC protections in sk_getsockopt()?
Thread-Topic: SO_PEERSEC protections in sk_getsockopt()?
Thread-Index: AQHY2peNL0l8xeG/wU6MBAmpwQpDnq4HlZFQ///6VQCAADOmEA==
Date:   Mon, 10 Oct 2022 15:34:24 +0000
Message-ID: <ffe2b21ce6e04b07891261641b4d1f5b@AcuMS.aculab.com>
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
 <df4df4eb70594d65b40865ca00ecad09@AcuMS.aculab.com>
 <CAHC9VhQRywim8vKGUM+=US0nq_fqZH7MShaV2tC14gw5xUrSDA@mail.gmail.com>
In-Reply-To: <CAHC9VhQRywim8vKGUM+=US0nq_fqZH7MShaV2tC14gw5xUrSDA@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGF1bCBNb29yZQ0KPiBTZW50OiAxMCBPY3RvYmVyIDIwMjIgMTQ6MTkNCi4uLi4NCj4g
PiBJdCBpc24ndCByZWFsbHkgaWRlYWwgZm9yIHRoZSBidWZmZXIgcG9pbnRlciBlaXRoZXIuDQo+
ID4gVGhhdCBzdGFydGVkIGFzIGEgc2luZ2xlIGZpZWxkIChhc3N1bWluZyB0aGUgY2FsbGVyDQo+
ID4gaGFzIHZlcmlmaWVkIHRoZSB1c2VyL2tlcm5lbCBzdGF0dXMpLCB0aGVuIHRoZSBpc19rZXJu
ZWwNCj4gPiBmaWVsZCB3YXMgYWRkZWQgZm9yIGFyY2hpdGVjdHVyZXMgd2hlcmUgdXNlci9rZXJu
ZWwNCj4gPiBhZGRyZXNzZXMgdXNlIHRoZSBzYW1lIHZhbHVlcy4NCj4gPiBUaGVuIGEgaG9ycmlk
IGJ1ZyAoZm9yZ290dGVuIHdoZXJlKSBmb3JjZWQgdGhlIGlzX2tlcm5lbA0KPiA+IGZpZWxkIGJl
IHVzZWQgZXZlcnl3aGVyZS4NCj4gPiBBZ2FpbiBhIHN0cnVjdHVyZSB3aXRoIHR3byBwb2ludGVy
cyB3b3VsZCBiZSBtdWNoIHNhZmVyLg0KPiANCj4gQW55IGNoYW5jZSB5b3UgaGF2ZSBwbGFucyB0
byB3b3JrIG9uIHRoaXMgRGF2aWQ/DQoNCkknZCBvbmx5IHNwZW5kIGFueSBzaWduaWZpY2FudCB0
aW1lIG9uIGl0IGlmIHRoZXJlDQppcyBhIHJlYXNvbmFibGUgY2hhbmNlIG9mIHRoZSBwYXRjaGVz
IGJlaW5nIGFjY2VwdGVkLg0KDQpNeSB1c2Ugd291bGQgYmUgYW4gb3V0LW9mLXRyZWUgbm9uLUdQ
TCBtb2R1bGUgY2FsbGluZw0Ka2VybmVsX2dldHNvY2tvcHQoKS4NClRoZSBtYWluIGluLXRyZWUg
dXNlciBpcyBicGYgLSB3aGljaCBzZWVtcyB0byBuZWVkIGFuDQpldmVyLWluY3JlYXNpbmcgbnVt
YmVyIG9mIHNvY2tldCBvcHRpb25zLCBidXQgc3VwcG9ydCBoYXMNCmJlZW4gYWRkZWQgb25lIGJ5
IG9uZS4NCg0KV2hpbGUgbW9zdCBnZXRzb2Nrb3B0KCkgY2FsbHMganVzdCByZXR1cm4gc2V0IHZh
bHVlcywgU0NUUA0KdXNlcyBzb21lIHRvIHJldHJpZXZlIHRoZSByZXN1bHQgb2YgdmFsdWVzIG5l
Z290aWF0ZWQgd2l0aA0KdGhlIHBlZXIuIFRoZSBudW1iZXIgb2YgdmFsaWQgZGF0YSBzdHJlYW1z
IGlzIG5lZWRlZCBmb3INCmV2ZW4gdHJpdmlhbCBTQ1RQIGFwcGxpY2F0aW9ucy4NCkhvd2V2ZXIg
SSd2ZSBhIHdvcmthcm91bmQgZm9yIGEgYnVnIGluIDUuMSB0byA1LjggdGhhdA0KcmV0dXJuZWQg
dGhlIHdyb25nIHZhbHVlcyAobXkgdGVzdHMgZGlkbid0IGNoZWNrIG5lZ290aWF0aW9uKQ0KdGhh
dCBhbHNvIG9idGFpbnMgdGhlIHZhbHVlcyBvbiBsYXRlciBrZXJuZWxzLg0KU28gSSdtIG5vdCAo
eWV0KSBpbiBhIGh1cnJ5IQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

