Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A159C66569F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbjAKI7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbjAKI6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:58:52 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B63210543
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673427531; x=1704963531;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=0gRZckzxKig1scliFkHAG+oLY/p3C3q0ICYjYgDl7gM=;
  b=l//szxmAO+5rIMbsL/4gExfDF1JIGdgFXPPe8uhMZZoMzDDItkNZ6AV+
   REsthSqA3GbIm120CcsZlHIx3UuLY1wC7xiJXB8O3jR9jz1yAplhT07fu
   SZ+q4VFgdz0cbY50gC/YeF7GtypFVeyFMkLNIsv5u7ioXRsTcX/p/ZYaV
   E=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="281621017"
Subject: RE: [PATCH V1 net-next 0/5] Add devlink support to ena
Thread-Topic: [PATCH V1 net-next 0/5] Add devlink support to ena
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 08:58:48 +0000
Received: from EX13D31EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-a65ebc6e.us-east-1.amazon.com (Postfix) with ESMTPS id B8C53614F7;
        Wed, 11 Jan 2023 08:58:47 +0000 (UTC)
Received: from EX19D028EUB004.ant.amazon.com (10.252.61.32) by
 EX13D31EUB001.ant.amazon.com (10.43.166.210) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 08:58:47 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB004.ant.amazon.com (10.252.61.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.7; Wed, 11 Jan 2023 08:58:46 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.020; Wed, 11 Jan 2023 08:58:46 +0000
From:   "Arinzon, David" <darinzon@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Thread-Index: AQHZJIzV+wAfc6WK6kuI0VjEEkTbvK6YFPoQgAAKigCAAKbkgA==
Date:   Wed, 11 Jan 2023 08:58:46 +0000
Message-ID: <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
 <20230110124418.76f4b1f8@kernel.org>
In-Reply-To: <20230110124418.76f4b1f8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.85.143.179]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBUdWUsIDEwIEphbiAyMDIzIDIwOjExOjIzICswMDAwIEFyaW56b24sIERhdmlkIHdyb3Rl
Og0KPiA+ID4gT24gU3VuLCA4IEphbiAyMDIzIDEwOjM1OjI4ICswMDAwIERhdmlkIEFyaW56b24g
d3JvdGU6DQo+ID4gPiA+IFRoaXMgcGF0Y2hzZXQgYWRkcyBkZXZsaW5rIHN1cHBvcnQgdG8gdGhl
IGVuYSBkcml2ZXIuDQo+ID4gPg0KPiA+ID4gV3JvbmcgcGxhY2UsIHBsZWFzZSB0YWtlIGEgbG9v
ayBhdA0KPiA+ID4NCj4gPiA+ICAgICAgICAgc3RydWN0IGtlcm5lbF9ldGh0b29sX3JpbmdwYXJh
bTo6dHhfcHVzaA0KPiA+ID4NCj4gPiA+IGFuZCBFVEhUT09MX0FfUklOR1NfVFhfUFVTSC4gSSB0
aGluayB5b3UganVzdCB3YW50IHRvIGNvbmZpZ3VyZQ0KPiB0aGUNCj4gPiA+IG1heCBzaXplIG9m
IHRoZSBUWCBwdXNoLCByaWdodD8NCj4gPg0KPiA+IFdlJ3JlIG5vdCBjb25maWd1cmluZyB0aGUg
bWF4IHNpemUgb2YgdGhlIFRYIHB1c2gsIGJ1dCBlZmZlY3RpdmVseSB0aGUNCj4gPiBtYXhpbWFs
IHBhY2tldCBoZWFkZXIgc2l6ZSB0byBiZSBwdXNoZWQgdG8gdGhlIGRldmljZS4NCj4gPiBUaGlz
IGlzIG5vdGVkIGluIHRoZSBkb2N1bWVudGF0aW9uIG9uIHBhdGNoIDUvNSBpbiB0aGlzIHBhdGNo
c2V0Lg0KPiA+IEFGQUlLLCB0aGVyZSdzIG5vIHJlbGV2YW50IGV0aHRvb2wgcGFyYW1ldGVyIGZv
ciB0aGlzIGNvbmZpZ3VyYXRpb24uDQo+IA0KPiBQZXJoYXBzIEkgc2hvdWxkIGhhdmUgY29tcGxh
aW5lZCBhYm91dCB0aGUgbG93IHF1YWxpdHkgb2YgdGhhdA0KPiBkb2N1bWVudGF0aW9uIHRvIG1h
a2UgaXQgY2xlYXIgdGhhdCBJIGhhdmUgaW4gZmFjdCByZWFkIGl0IDovDQo+IA0KDQpOb3RlZCwg
d2Ugd2lsbCBzZWUgaG93IHRvIGltcHJvdmUgZG9jdW1lbnRhdGlvbiBnb2luZyBmb3J3YXJkLg0K
DQo+IEkgcmVhZCBpdCBhZ2FpbiAtIGFuZCBJIHN0aWxsIGRvbid0IGtub3cgd2hhdCB5b3UncmUg
ZG9pbmcuDQo+IEkgc291bmRzIGxpa2UgaW5saW5lIGhlYWRlciBsZW5ndGggY29uZmlndXJhdGlv
biB5ZXQgeW91IGFsc28gdXNlIExMUSBhbGwNCj4gb3ZlciB0aGUgcGxhY2UuIEFuZCBMTFEgZm9y
IEVOQSBpcyBkb2N1bWVudGVkIGFzIGJhc2ljYWxseSB0eF9wdXNoOg0KPiANCj4gICAtICoqTG93
IExhdGVuY3kgUXVldWUgKExMUSkgbW9kZSBvciAicHVzaC1tb2RlIjoqKg0KPiANCj4gUGxlYXNl
IGV4cGxhaW4gdGhpcyBpbiBhIHdheSB3aGljaCBhc3N1bWVzIHplcm8gQW1hem9uLXNwZWNpZmlj
DQo+IGtub3dsZWRnZSA6KA0KPiANCg0KTG93IExhdGVuY3kgUXVldWVzIChMTFEpIGlzIGEgbW9k
ZSBvZiBvcGVyYXRpb24gd2hlcmUgdGhlIHBhY2tldCBoZWFkZXJzDQoodXAgdG8gYSBkZWZpbmVk
IGxlbmd0aCkgYXJlIGJlaW5nIHdyaXR0ZW4gZGlyZWN0bHkgdG8gdGhlIGRldmljZSBtZW1vcnku
DQpUaGVyZWZvcmUsIHlvdSBhcmUgcmlnaHQsIHRoZSBkZXNjcmlwdGlvbiBpcyBzaW1pbGFyIHRv
IHR4X3B1c2guIEhvd2V2ZXIsDQpUaGlzIGlzIG5vdCBhIGNvbmZpZ3VyYWJsZSBvcHRpb24gd2hp
bGUgRVRIVE9PTF9BX1JJTkdTX1RYX1BVU0gNCmNvbmZpZ3VyZXMgd2hldGhlciB0byB3b3JrIGlu
IGEgbW9kZSBvciBub3QuDQpJZiBJJ20gdW5kZXJzdGFuZGluZyB0aGUgaW50ZW50IGJlaGluZCBF
VEhUT09MX0FfUklOR1NfVFhfUFVTSA0KYW5kIHRoZSBpbXBsZW1lbnRhdGlvbiBpbiB0aGUgZHJp
dmVyIHRoYXQgaW50cm9kdWNlZCB0aGUgZmVhdHVyZSwgaXQNCnJlZmVycyB0byBhIHB1c2ggb2Yg
dGhlIHBhY2tldCBhbmQgbm90IGp1c3QgdGhlIGhlYWRlcnMsIHdoaWNoIGlzIG5vdCB3aGF0DQp0
aGUgZW5hIGRyaXZlciBkb2VzLg0KDQpJbiB0aGlzIHBhdGNoc2V0LCB3ZSBhbGxvdyB0aGUgY29u
ZmlndXJhdGlvbiBvZiBhbiBleHRlbmRlZCBzaXplIG9mIHRoZQ0KTG93IExhdGVuY3kgUXVldWUs
IG1lYW5pbmcsIGFsbG93IGVuYWJsZWQgYW5vdGhlciwgbGFyZ2VyLCBwcmUtZGVmaW5lZA0Kc2l6
ZSB0byBiZSB1c2VkIGFzIGEgbWF4IHNpemUgb2YgdGhlIHBhY2tldCBoZWFkZXIgdG8gYmUgcHVz
aGVkIGRpcmVjdGx5IHRvDQpkZXZpY2UgbWVtb3J5LiBJdCBpcyBub3QgY29uZmlndXJhYmxlIGlu
IHZhbHVlLCB0aGVyZWZvcmUsIGl0IHdhcyBkZWZpbmVkIGFzDQpsYXJnZSBMTFEuDQoNCkkgaG9w
ZSB0aGlzIHByb3ZpZGVzIG1vcmUgY2xhcmlmaWNhdGlvbiwgaWYgbm90LCBJJ2xsIGJlIGhhcHB5
IHRvIGVsYWJvcmF0ZSBmdXJ0aGVyLg0KDQo+ID4gPiBUaGUgcmVsb2FkIGlzIGFsc28gYW4gb3Zl
cmtpbGwsIHJlbG9hZCBzaG91bGQgcmUtcmVnaXN0ZXIgYWxsIGRyaXZlcg0KPiA+ID4gb2JqZWN0
cyBidXQgdGhlIGRldmxpbmsgaW5zdGFuY2UsIElJUkMuIFlvdSdyZSBub3QgZXZlbiB1bnJlZ2lz
dGVyaW5nDQo+IHRoZSBuZXRkZXYuDQo+ID4gPiBZb3Ugc2hvdWxkIGhhbmRsZSB0aGlzIGNoYW5n
ZSB0aGUgc2FtZSB3YXkgeW91IGhhbmRsZSBhbnkgcmluZyBzaXplDQo+ID4gPiBjaGFuZ2VzLg0K
PiA+DQo+ID4gVGhlIExMUSBjb25maWd1cmF0aW9uIGlzIGRpZmZlcmVudCBmcm9tIG90aGVyIGNv
bmZpZ3VyYXRpb25zIHNldCB2aWENCj4gPiBldGh0b29sIChsaWtlIHF1ZXVlIHNpemUgYW5kIG51
bWJlciBvZiBxdWV1ZXMpLiBMTFEgcmVxdWlyZXMNCj4gPiByZS1uZWdvdGlhdGlvbiB3aXRoIHRo
ZSBkZXZpY2UgYW5kIHJlcXVpcmVzIGEgcmVzZXQsIHdoaWNoIGlzIG5vdA0KPiA+IHBlcmZvcm1l
ZCBpbiB0aGUgZXRodG9vbCBjb25maWd1cmF0aW9ucyBjYXNlLg0KPiANCj4gV2hhdCBkbyB5b3Ug
bWVhbiB3aGVuIHlvdSBzYXkgdGhhdCByZXNldCBpcyBub3QgcmVxdWlyZWQgaW4gdGhlIGV0aG9v
bA0KPiBjb25maWd1cmF0aW9uIGNhc2U/DQo+IA0KPiBBRkFJSyBldGh0b29sIGNvbmZpZyBzaG91
bGQgbm90IChhbHRob3VnaCBzYWRseSB2ZXJ5IG9mdGVuIGl0IGRvZXMpIGNhdXNlDQo+IGFueSBs
b3NzIG9mIHVucmVsYXRlZCBjb25maWd1cmF0aW9uLiBCdXQgeW91IGNhbiBjZXJ0YWlubHkgcmVz
ZXQgSFcgYmxvY2tzDQo+IG9yIHJlbmVnIGZlYXR1cmVzIHdpdGggRlcgb3Igd2hhdGV2ZXIgZWxz
ZS4uLg0KPiANCg0KVGhlIGVuYSBkcml2ZXIgY3VycmVudGx5IHN1cHBvcnRzIHZhcmlvdXMgY29u
ZmlndXJhdGlvbnMgdmlhIGV0aHRvb2wsDQpmb3IgZXhhbXBsZSwgY2hhbmdpbmcgdGhlIG51bWJl
ciBvZiBxdWV1ZXMvY2hhbm5lbHMgYW5kIHRoZQ0KcXVldWUvY2hhbm5lbCBzaXplLiBUaGVzZSBv
cHRpb25zLCBmb3IgZXhhbXBsZSwgcmVxdWlyZSBjaGFuZ2VzIGluIHRoZQ0KbmV0ZGV2IGFuZCB0
aGUgaW50ZXJmYWNlcyB3aXRoIHRoZSBrZXJuZWwsIHRoZXJlZm9yZSwgd2UgcGVyZm9ybSBhDQpy
ZWNvbmZpZ3VyYXRpb24gb24gdGhpcyBsZXZlbC4gQnV0LCB0aGVzZSBjb25maWd1cmF0aW9ucyBk
byBub3QgcmVxdWlyZQ0KdGhlIGludGVyZmFjZSBiZXR3ZWVuIHRoZSBkcml2ZXIgYW5kIGRldmlj
ZSB0byBiZSByZXNldC4NCkxvdyBMYXRlbmN5IFF1ZXVlIG1vZGUgY2hhbmdlIGZyb20gc3RhbmRh
cmQgdG8gbGFyZ2UgKHdoYXQncyBiZWluZw0KY29uZmlndXJlZCBpbiB0aGlzIHBhdGhzZXQpIGlz
IG1vcmUgc2lnbmlmaWNhbnQgZnVuY3Rpb25hbGl0eSBjaGFuZ2UgYW5kDQpyZXF1aXJlcyB0aGlz
IHJlc2V0Lg0KDQo+ID4gSXQgbWF5IGJlIHBvc3NpYmxlIHRvIHVucmVnaXN0ZXIvcmVnaXN0ZXIg
dGhlIG5ldGRldiwgYnV0IGl0IGlzDQo+ID4gdW5uZWNlc3NhcnkgaW4gdGhpcyBjYXNlLCBhcyBt
b3N0IG9mIHRoZSBjaGFuZ2VzIGFyZSByZWZsZWN0ZWQgaW4gdGhlDQo+ID4gaW50ZXJmYWNlIGFu
ZCBzdHJ1Y3R1cmVzIGJldHdlZW4gdGhlIGRyaXZlciBhbmQgdGhlIGRldmljZS4NCj4gPg0KPiA+
ID4gRm9yIGZ1dHVyZSByZWZlcmVuY2UgLSBpZiB5b3UgZXZlciBfYWN0dWFsbHlfIG5lZWQgZGV2
bGluayBwbGVhc2UNCj4gPiA+IHVzZSB0aGUNCj4gPiA+IGRldmxfKiBBUElzIGFuZCB0YWtlIHRo
ZSBpbnN0YW5jZSBsb2NrcyBleHBsaWNpdGx5LiBUaGVyZSBoYXMgbm90DQo+ID4gPiBiZWVuIGEg
c2luZ2xlIGRldmxpbmsgcmVsb2FkIGltcGxlbWVudGF0aW9uIHdoaWNoIHdvdWxkIGdldCBsb2Nr
aW5nDQo+ID4gPiByaWdodCB1c2luZyB0aGUgZGV2bGlua18qIEFQSXMg8J+YlO+4jw0KPiA+DQo+
ID4gVGhpcyBvcGVyYXRpb24gY2FuIGhhcHBlbiBpbiBwYXJhbGxlbCB0byBhIHJlc2V0IG9mIHRo
ZSBkZXZpY2UgZnJvbSBhDQo+ID4gZGlmZmVyZW50IGNvbnRleHQgd2hpY2ggaXMgdW5yZWxhdGVk
IHRvIGRldmxpbmsuIE91ciBpbnRlbnRpb24gaXMgdG8NCj4gPiBhdm9pZCBzdWNoIGNhc2VzLCB0
aGVyZWZvcmUsIGhvbGRpbmcgdGhlIGRldmxpbmsgbG9jayB1c2luZyBkZXZsX2xvY2sgQVBJcw0K
PiB3aWxsIG5vdCBiZSBzdWZmaWNpZW50Lg0KPiA+IFRoZSBkcml2ZXIgaG9sZHMgdGhlIFJUTkxf
TE9DSyBpbiBrZXkgcGxhY2VzLCBlaXRoZXIgZXhwbGljaXRseSBvcg0KPiA+IGltcGxpY2l0bHks
IGFzIGluIGV0aHRvb2wgY29uZmlndXJhdGlvbiBjaGFuZ2VzIGZvciBleGFtcGxlLg0KPiANCj4g
WWVhaCwgd2hpY2ggaXMgd2h5IHlvdSBzaG91bGQgbm90IGJlIHVzaW5nIGRldmxpbmsgZm9yIHRo
aXMuDQoNClRob3VnaCB1c2luZyBldGh0b29sIHdvdWxkJ3ZlIGJlZW4gbW9yZSBjb252ZW5pZW50
IGFzIFJUTkxfTE9DSyBpcyBiZWluZw0KaGVsZCB3aGlsZSB0aGUgY29tbWFuZCB0YWtlcyBwbGFj
ZSwgdGhpcyBmdW5jdGlvbmFsaXR5IGlzIHNwZWNpZmljIHRvIEFtYXpvbiBhbmQNCmFkZGluZyBh
IHByaXZhdGUgZmxhZywgZm9yIGV4YW1wbGUsIGlzIG5vdCBkZXNpcmFibGUuIENyZWF0aW5nIGEg
bmV3IGV0aHRvb2wgb3INCnVwZGF0aW5nIGFuIGV4aXN0aW5nIG9uZSB3b3VsZCBiZSBzcGVjaWZp
YyBvbmx5IGZvciBBbWF6b24gYXMgd2VsbC4NClBlciBvdXIgdW5kZXJzdGFuZGluZywgZXRodG9v
bCBpcyB1c2VkIGZvciBpbnRlcmZhY2Ugb3BlcmF0aW9ucywgd2hpbGUgZGV2bGluaw0KaXMgdXNl
ZCBmb3IgZGV2aWNlIG9wZXJhdGlvbnMuIFBlcmZvcm1pbmcgdGhlIGRpc2N1c3NlZCBjb25maWd1
cmF0aW9uIGNoYW5nZQ0KaXMgYSBkZXZpY2UgY29uZmlndXJhdGlvbiwgYXMgaXQgYWZmZWN0cyB0
aGUgd2F5IHRoZSBkZXZpY2UgY29uZmlndXJlcyBpdHMgb3duIG1lbW9yeS4NCg0KDQoNCg==
