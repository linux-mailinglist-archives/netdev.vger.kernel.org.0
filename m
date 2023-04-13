Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479846E1662
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjDMVT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDMVT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:19:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0BB8A52
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:19:53 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-178-S4iCgMItMLWsvBD8stFdOw-1; Thu, 13 Apr 2023 22:19:51 +0100
X-MC-Unique: S4iCgMItMLWsvBD8stFdOw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 13 Apr
 2023 22:19:49 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 13 Apr 2023 22:19:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jacob Keller' <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] igc: Avoid transmit queue timeout for XDP
Thread-Topic: [PATCH net-next] igc: Avoid transmit queue timeout for XDP
Thread-Index: AQHZbiakwvsvL10nUEK6fgXm9Mv0Na8pvMgA
Date:   Thu, 13 Apr 2023 21:19:48 +0000
Message-ID: <05bd675ff1e3438888ea1387df5110d1@AcuMS.aculab.com>
References: <20230412073611.62942-1-kurt@linutronix.de>
 <1809a34d-dcf4-4b54-089a-a7be3f4c23e1@intel.com>
 <20230413090344.20796001@kernel.org>
 <5076f138-2090-921c-7f01-32211f27d400@intel.com>
In-Reply-To: <5076f138-2090-921c-7f01-32211f27d400@intel.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFjb2IgS2VsbGVyDQo+IFNlbnQ6IDEzIEFwcmlsIDIwMjMgMTc6NDANCj4gDQo+IE9u
IDQvMTMvMjAyMyA5OjAzIEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBPbiBXZWQsIDEy
IEFwciAyMDIzIDE1OjMwOjM4IC0wNzAwIEphY29iIEtlbGxlciB3cm90ZToNCj4gPj4gSXMgbW9z
dCBkcml2ZXIncyBYRFAgaW1wbGVtZW50YXRpb24gYnJva2VuPyBUaGVyZSdzIGFsc28NCj4gPj4g
bmV0aWZfdHJhbnNfdXBkYXRlIGJ1dCB0aGlzIGlzIGNhbGxlZCBvdXQgYXMgYSBsZWdhY3kgb25s
eSBmdW5jdGlvbi4gRmFyDQo+ID4+IG1vcmUgZHJpdmVycyBjYWxsIHRoaXMgYnV0IEkgZG9uJ3Qg
c2VlIGVpdGhlciBjYWxsIG9yIGEgZGlyZWN0IHVwZGF0ZSB0bw0KPiA+PiB0cmFuc19zdGFydCBp
biBtYW55IFhEUCBpbXBsZW1lbnRhdGlvbnMuLi4NCj4gPj4NCj4gPj4gQW0gSSBtaXNzaW5nIHNv
bWV0aGluZyBvciBhcmUgYSBidW5jaCBvZiBvdGhlciBYRFAgaW1wbGVtZW50YXRpb25zIGFsc28N
Cj4gPj4gd3Jvbmc/DQo+ID4NCj4gPiBPbmx5IGRyaXZlcnMgd2hpY2ggdXNlIHRoZSBzYW1lIFR4
IHF1ZXVlcyBmb3IgdGhlIHN0YWNrIGFuZCBYRFAgbmVlZA0KPiA+IHRoaXMuDQo+IA0KPiBPayB0
aGF0IGV4cGxhaW5zIGl0LiBpZ2MgaGFzIGZldyBlbm91Z2ggcXVldWVzIHRoZXkgbmVlZCB0byBi
ZSBzaGFyZWQsDQo+IGJ1dCBvdGhlciBkZXZpY2VzIGhhdmUgbW9yZSBxdWV1ZXMgYW5kIGNhbiB1
c2UgZGVkaWNhdGVkIHF1ZXVlcy4NCg0KQXJlbid0IHRoZXJlIHNvbWUgZ2VuZXJpYyBwcm9ibGVt
cyB3aXRoIG11bHRpcGxlIHRyYW5zbWl0IHF1ZXVlcz8NClRoZSB0ZzMgZHJpdmVyIG9ubHkgdXNl
cyBhIHNpbmdsZSB0eCBxdWV1ZSBiZWNhdXNlIHNlbmRpbmcgZW5vdWdoDQpsYXJnZSBwYWNrZXRz
IHRvIHNhdHVyYXRlIHRoZSBuZXR3b3JrIHRocm91Z2ggb25lIHF1ZXVlIGhhcyB0aGUNCmVmZmVj
dCBvZiBzaWduaWZpY2FudGx5IGRlbGF5aW5nIHBhY2tldHMgb24gb3RoZXIgcXVldWVzIGJlY2F1
c2UNCm9mIHRoZSAncm91bmQgcm9iaW4nIGFsZ29yaXRobSB1c2VkIGJ5IHRoZSBoYXJkd2FyZS4N
Cg0KVHJhbnNtaXQgcHJvY2Vzc2luZyBpcyBhbHNvIGEgbG90IGxlc3MgZGVtYW5kaW5nIHRoYW4g
dGhlIHJlY2VpdmUNCnByb2Nlc3NpbmcuDQpTbyB5b3UgbWF5IHdhbnQgdG8gc3BsaXQgdGhlIHJl
Y2VpdmUgdHJhZmZpYyBpbnRvIG11bHRpcGxlDQpxdWV1ZXMgKHdpdGggdGhlIHByb2Nlc3Npbmcg
aGFwcGVuaW5nIG9uIG11bHRpcGxlIGNwdSkgYnV0DQprZWVwIHRoZSB0cmFuc21pdCBwcm9jZXNz
aW5nICh3aGljaCBpcyBtdWNoIGxlc3MgY3JpdGljYWwpDQpvbmx5IHJ1bm5pbmcgb24gYSBzaW5n
bGUgY3B1IC0gc28gd2l0aCBhIHNpbmdsZSBxdWV1ZS4NCihUcnlpbmcgdG8gcHJvY2VzcyAxMDAw
MCBSVFAgc3RyZWFtcyBnZXRzICdpbnRlcmVzdGluZycuKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

