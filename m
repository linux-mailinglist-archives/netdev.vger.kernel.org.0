Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0456E2350
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjDNMch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjDNMcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:32:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858929EDC
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 05:32:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-185-VqRPGaRUPQWesYHLYOoMpg-1; Fri, 14 Apr 2023 13:32:30 +0100
X-MC-Unique: VqRPGaRUPQWesYHLYOoMpg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Apr
 2023 13:32:27 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 14 Apr 2023 13:32:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Song, Yoong Siang'" <yoong.siang.song@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "Andre Guedes" <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbnY42u7Gz9ET40eYzbfYWKvVVq8qkCGAgAAQJMCAABqMIA==
Date:   Fri, 14 Apr 2023 12:32:27 +0000
Message-ID: <4dc9ea6c77ff49138a49d7f73f7301fd@AcuMS.aculab.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
 <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
 <PH0PR11MB5830D3F9144B61A6959A4A0FD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5830D3F9144B61A6959A4A0FD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU29uZywgWW9vbmcgU2lhbmcNCj4gU2VudDogMTQgQXByaWwgMjAyMyAxMjoxNg0KLi4u
DQo+ID5JIGhhdmUgY2hlY2tlZCBGb3h2aWxsZSBtYW51YWwgZm9yIFNSUkNUTCAoU3BsaXQgYW5k
IFJlcGxpY2F0aW9uIFJlY2VpdmUNCj4gPkNvbnRyb2wpIHJlZ2lzdGVyIGFuZCBiZWxvdyBHRU5N
QVNLcyBsb29rcyBjb3JyZWN0Lg0KPiA+DQo+ID4+IC0jZGVmaW5lIElHQ19TUlJDVExfQlNJWkVQ
S1RfU0hJRlQJCTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4gPj4gLSNkZWZpbmUgSUdDX1NSUkNU
TF9CU0laRUhEUlNJWkVfU0hJRlQJCTIgIC8qIFNoaWZ0IF9sZWZ0XyAqLw0KPiA+PiArI2RlZmlu
ZSBJR0NfU1JSQ1RMX0JTSVpFUEtUX01BU0sJR0VOTUFTSyg2LCAwKQ0KPiA+PiArI2RlZmluZSBJ
R0NfU1JSQ1RMX0JTSVpFUEtUX1NISUZUCTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4gPg0KPiA+
U2hpZnQgZHVlIHRvIDEgS0IgcmVzb2x1dGlvbiBvZiBCU0laRVBLVCAobWFudWFsIGZpZWxkIEJT
SVpFUEFDS0VUKQ0KPiANCj4gWWEsIDFLID0gQklUKDEwKSwgc28gbmVlZCB0byBzaGlmdCByaWdo
dCAxMCBiaXRzLg0KDQpJIGJldCB0aGUgY29kZSB3b3VsZCBiZSBlYXNpZXIgdG8gcmVhZCBpZiBp
dCBkaWQgJ3ZhbHVlIC8gMTAyNHUnLg0KVGhlIG9iamVjdCBjb2RlIHdpbGwgYmUgKG11Y2gpIHRo
ZSBzYW1lLg0KDQo+ID4+ICsjZGVmaW5lIElHQ19TUlJDVExfQlNJWkVIRFJTSVpFX01BU0sJR0VO
TUFTSygxMywgOCkNCj4gPj4gKyNkZWZpbmUgSUdDX1NSUkNUTF9CU0laRUhEUlNJWkVfU0hJRlQJ
MiAgLyogU2hpZnQgX2xlZnRfICovDQo+ID4NCj4gPlRoaXMgc2hpZnQgaXMgc3VzcGljaW91cywg
YnV0IGFzIHlvdSBpbmhlcml0ZWQgaXQgSSBndWVzcyBpdCB3b3Jrcy4NCj4gPkkgZGlkIHRoZSBt
YXRoLCBhbmQgaXQgaGFwcGVucyB0byB3b3JrLCBrbm93aW5nIChmcm9tIG1hbnVhbCkgdmFsdWUg
aXMgaW4gNjQgYnl0ZXMNCj4gPnJlc29sdXRpb24uDQo+IA0KPiBJdCBpcyBpbiA2NCA9IEJJVCg2
KSByZXNvbHV0aW9uLCBzbyBuZWVkIHRvIHNoaWZ0IHJpZ2h0IDYgYml0cy4NCj4gQnV0IGl0IHN0
YXJ0IG9uIDh0aCBiaXQsIHNvIG5lZWQgdG8gc2hpZnQgbGVmdCA4IGJpdHMuDQo+IFRodXMsIHRv
dGFsID0gc2hpZnQgbGVmdCAyIGJpdHMuDQo+IA0KPiBJIGRpbnQgcHV0IHRoZSBleHBsYW5hdGlv
biBpbnRvIHRoZSBoZWFkZXIgZmlsZSBiZWNhdXNlIGl0IGlzIHRvbyBsZW5ndGh5DQo+IGFuZCB1
c2VyIGNhbiBrbm93IGZyb20gZGF0YWJvb2suDQo+IA0KPiBIb3cgZG8geW91IGZlZWwgb24gdGhl
IG5lY2Vzc2FyeSBvZiBleHBsYWluaW5nIHRoZSBzaGlmdGluZyBsb2dpYz8NCg0KTm90IGV2ZXJ5
b25lIHRyeWluZyB0byBncm9rIHRoZSBjb2RlIHdpbGwgaGF2ZSB0aGUgbWFudWFsLg0KRXZlbiB3
cml0aW5nICg4IC0gNikgd2lsbCBoZWxwLg0KT3IgKEkgdGhpbmspIGlmIHRoZSB2YWx1ZSBpcyBp
biBiaXRzIDEzLTggaW4gdW5pdHMgb2YgNjQgdGhlbiBqdXN0Og0KCSgodmFsdWUgPj4gOCkgJiAw
eDFmKSAqIDY0DQpnY2Mgd2lsbCBkbyBhIHNpbmdsZSBzaGlmdCByaWdodCBhbmQgYSBtYXNrIDlh
dCBzb21lIHBvaW50KS4NCllvdSBtaWdodCB3YW50IHNvbWUgZGVmaW5lcywgYnV0IGlmIHRoZXkg
YXJlbid0IHVzZWQgbXVjaA0KanVzdCBjb21tZW50cyB0aGF0IHJlZmVyIHRvIHRoZSBuYW1lcyBp
biB0aGUgbWFudWFsL2RhdGFzaGVldA0KY2FuIGJlIGVub3VnaC4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

