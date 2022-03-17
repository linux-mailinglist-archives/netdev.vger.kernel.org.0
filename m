Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697F74DC950
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiCQOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiCQOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:55:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADFE1DE93A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:53:53 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-321-P6g7D78BM56_TDs4X2OSiw-1; Thu, 17 Mar 2022 14:53:50 +0000
X-MC-Unique: P6g7D78BM56_TDs4X2OSiw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 17 Mar 2022 14:53:50 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 17 Mar 2022 14:53:50 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "xeb@mail.ru" <xeb@mail.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "talalahmad@google.com" <talalahmad@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "flyingpeng@tencent.com" <flyingpeng@tencent.com>,
        "mengensun@tencent.com" <mengensun@tencent.com>,
        "dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "benbjiang@tencent.com" <benbjiang@tencent.com>
Subject: RE: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Thread-Topic: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Thread-Index: AQHYOg4fPu4cJYiuNkyikVGsIDB36azDqG8w
Date:   Thu, 17 Mar 2022 14:53:49 +0000
Message-ID: <b08e2dc3e0694068a1a9d698475f8992@AcuMS.aculab.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com>
 <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org>
 <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
In-Reply-To: <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMTcgTWFyY2ggMjAyMiAxNDo0OQ0KPiANCj4gT24g
My8xNi8yMiAxMDowNSBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gV2VkLCAxNiBN
YXIgMjAyMiAyMTozNTo0NyAtMDYwMCBEYXZpZCBBaGVybiB3cm90ZToNCj4gPj4gT24gMy8xNi8y
MiA5OjE4IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPj4+DQo+ID4+PiBJIGd1ZXNzIHRo
aXMgc2V0IHJhaXNlcyB0aGUgZm9sbG93IHVwIHF1ZXN0aW9uIHRvIERhdmUgaWYgYWRkaW5nDQo+
ID4+PiBkcm9wIHJlYXNvbnMgdG8gcGxhY2VzIHdpdGggTUlCIGV4Y2VwdGlvbiBzdGF0cyBtZWFu
cyBpbXByb3ZpbmcNCj4gPj4+IHRoZSBncmFudWxhcml0eSBvciBvbmUgTUlCIHN0YXQgPT0gb25l
IHJlYXNvbj8NCj4gPj4NCj4gPj4gVGhlcmUgYXJlIGEgZmV3IGV4YW1wbGVzIHdoZXJlIG11bHRp
cGxlIE1JQiBzdGF0cyBhcmUgYnVtcGVkIG9uIGEgZHJvcCwNCj4gPj4gYnV0IHRoZSByZWFzb24g
Y29kZSBzaG91bGQgYWx3YXlzIGJlIHNldCBiYXNlZCBvbiBmaXJzdCBmYWlsdXJlLiBEaWQgeW91
DQo+ID4+IG1lYW4gc29tZXRoaW5nIGVsc2Ugd2l0aCB5b3VyIHF1ZXN0aW9uPw0KPiA+DQo+ID4g
SSBtZWFudCB3aGV0aGVyIHdlIHdhbnQgdG8gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIFRZUEUsIGFu
ZCBCUk9BRENBU1Qgb3INCj4gPiB3aGF0ZXZlciBvdGhlciBwb3NzaWJsZSBpbnZhbGlkIHByb3Rv
Y29sIGNhc2VzIHdlIGNhbiBnZXQgaGVyZSBvciBqdXN0DQo+ID4gZHVtcCB0aGVtIGFsbCBpbnRv
IGEgc2luZ2xlIHByb3RvY29sIGVycm9yIGNvZGUuDQo+IA0KPiBJIHRoaW5rIGEgc2luZ2xlIG9u
ZSBpcyBhIGdvb2Qgc3RhcnRpbmcgcG9pbnQuDQoNCkkgcmVtZW1iZXIgbG9va2luZyBhdCAoSSB0
aGluaykgdGhlIHBhY2tldCBkcm9wIHN0YXRzIGEgd2hpbGUgYmFjay4NClR3byBtYWNoaW5lcyBv
biB0aGUgc2FtZSBMQU4gd2VyZSByZXBvcnRpbmcgcmF0aGVyIGRpZmZlcmVudCB2YWx1ZXMuDQpC
YXNpY2FsbHkgMCB2IHF1aXRlIGEgZmV3Lg0KDQpJdCB0dXJuZWQgb3V0IHRoYXQgcGFzc2luZyB0
aGUgcGFja2V0cyB0byBkaGNwIHdhcyBkZWVtZWQgZW5vdWdoDQp0byBzdG9wIHRoZW0gYmVpbmcg
cmVwb3J0ZWQgYXMgJ2Ryb3BwZWQnLg0KQW5kIEkgdGhpbmsgdGhhdCB2ZXJzaW9uIG9mIGRoY3Ag
ZmVkIGV2ZXJ5IHBhY2tlZCBpbnRvIGl0cyBCUEY/IGZpbHRlci4NCihJIG5ldmVyIGRpZCBkZWNp
ZGUgd2hldGhlciB0aGF0IGNhdXNlZCBldmVyeSBza2IgdG8gYmUgZHVwbGljYXRlZC4pDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

