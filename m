Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BAD664D18
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjAJUL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjAJULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:11:35 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C0A13DF1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673381491; x=1704917491;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=1Jbc6UyAdwSkZjAT0pTGOeUoymDqvjkv+F89dSNYquk=;
  b=Uzq5DxcGl1io1vAX/1HuBI9LJfO7WyfIXpePHVt5nE/onk0/iVS+29Dt
   lAEdKIjZZBjckQgA+JYngFX9n2j9GYUmT6371UNQuS1faDs4WpQyw+xhz
   TIt3lq5x2onmkzbsV027PQ3VTCkIpdFromfZxz2cBsugW5KwxzyMejt1k
   M=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="298825786"
Subject: RE: [PATCH V1 net-next 0/5] Add devlink support to ena
Thread-Topic: [PATCH V1 net-next 0/5] Add devlink support to ena
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 20:11:26 +0000
Received: from EX13D31EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 1E5DF416E3;
        Tue, 10 Jan 2023 20:11:25 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D31EUB001.ant.amazon.com (10.43.166.210) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 10 Jan 2023 20:11:23 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.7; Tue, 10 Jan 2023 20:11:23 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.020; Tue, 10 Jan 2023 20:11:23 +0000
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
Thread-Index: AQHZJIzV+wAfc6WK6kuI0VjEEkTbvK6YFPoQ
Date:   Tue, 10 Jan 2023 20:11:23 +0000
Message-ID: <574f532839dd4e93834dbfc776059245@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
 <20230109164500.7801c017@kernel.org>
In-Reply-To: <20230109164500.7801c017@kernel.org>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBTdW4sIDggSmFuIDIwMjMgMTA6MzU6MjggKzAwMDAgRGF2aWQgQXJpbnpvbiB3cm90ZToN
Cj4gPiBUaGlzIHBhdGNoc2V0IGFkZHMgZGV2bGluayBzdXBwb3J0IHRvIHRoZSBlbmEgZHJpdmVy
Lg0KPiANCj4gV3JvbmcgcGxhY2UsIHBsZWFzZSB0YWtlIGEgbG9vayBhdA0KPiANCj4gICAgICAg
ICBzdHJ1Y3Qga2VybmVsX2V0aHRvb2xfcmluZ3BhcmFtOjp0eF9wdXNoDQo+IA0KPiBhbmQgRVRI
VE9PTF9BX1JJTkdTX1RYX1BVU0guIEkgdGhpbmsgeW91IGp1c3Qgd2FudCB0byBjb25maWd1cmUg
dGhlDQo+IG1heCBzaXplIG9mIHRoZSBUWCBwdXNoLCByaWdodD8NCj4gDQoNCkhpIEpha3ViLA0K
VGhhbmsgeW91IGZvciB0aGUgZmVlZGJhY2tzLg0KDQpXZSdyZSBub3QgY29uZmlndXJpbmcgdGhl
IG1heCBzaXplIG9mIHRoZSBUWCBwdXNoLCBidXQgZWZmZWN0aXZlbHkgdGhlDQptYXhpbWFsIHBh
Y2tldCBoZWFkZXIgc2l6ZSB0byBiZSBwdXNoZWQgdG8gdGhlIGRldmljZS4NClRoaXMgaXMgbm90
ZWQgaW4gdGhlIGRvY3VtZW50YXRpb24gb24gcGF0Y2ggNS81IGluIHRoaXMgcGF0Y2hzZXQuDQpB
RkFJSywgdGhlcmUncyBubyByZWxldmFudCBldGh0b29sIHBhcmFtZXRlciBmb3IgdGhpcyBjb25m
aWd1cmF0aW9uLg0KDQo+IFRoZSByZWxvYWQgaXMgYWxzbyBhbiBvdmVya2lsbCwgcmVsb2FkIHNo
b3VsZCByZS1yZWdpc3RlciBhbGwgZHJpdmVyIG9iamVjdHMNCj4gYnV0IHRoZSBkZXZsaW5rIGlu
c3RhbmNlLCBJSVJDLiBZb3UncmUgbm90IGV2ZW4gdW5yZWdpc3RlcmluZyB0aGUgbmV0ZGV2Lg0K
PiBZb3Ugc2hvdWxkIGhhbmRsZSB0aGlzIGNoYW5nZSB0aGUgc2FtZSB3YXkgeW91IGhhbmRsZSBh
bnkgcmluZyBzaXplDQo+IGNoYW5nZXMuDQo+IA0KPiANCg0KVGhlIExMUSBjb25maWd1cmF0aW9u
IGlzIGRpZmZlcmVudCBmcm9tIG90aGVyIGNvbmZpZ3VyYXRpb25zIHNldCB2aWEgZXRodG9vbA0K
KGxpa2UgcXVldWUgc2l6ZSBhbmQgbnVtYmVyIG9mIHF1ZXVlcykuIExMUSByZXF1aXJlcyByZS1u
ZWdvdGlhdGlvbg0Kd2l0aCB0aGUgZGV2aWNlIGFuZCByZXF1aXJlcyBhIHJlc2V0LCB3aGljaCBp
cyBub3QgcGVyZm9ybWVkIGluIHRoZSBldGh0b29sDQpjb25maWd1cmF0aW9ucyBjYXNlLiBJdCBt
YXkgYmUgcG9zc2libGUgdG8gdW5yZWdpc3Rlci9yZWdpc3RlciB0aGUgbmV0ZGV2LA0KYnV0IGl0
IGlzIHVubmVjZXNzYXJ5IGluIHRoaXMgY2FzZSwgYXMgbW9zdCBvZiB0aGUgY2hhbmdlcyBhcmUg
cmVmbGVjdGVkIGluIHRoZQ0KaW50ZXJmYWNlIGFuZCBzdHJ1Y3R1cmVzIGJldHdlZW4gdGhlIGRy
aXZlciBhbmQgdGhlIGRldmljZS4NCg0KPiBGb3IgZnV0dXJlIHJlZmVyZW5jZSAtIGlmIHlvdSBl
dmVyIF9hY3R1YWxseV8gbmVlZCBkZXZsaW5rIHBsZWFzZSB1c2UgdGhlDQo+IGRldmxfKiBBUElz
IGFuZCB0YWtlIHRoZSBpbnN0YW5jZSBsb2NrcyBleHBsaWNpdGx5LiBUaGVyZSBoYXMgbm90IGJl
ZW4gYQ0KPiBzaW5nbGUgZGV2bGluayByZWxvYWQgaW1wbGVtZW50YXRpb24gd2hpY2ggd291bGQg
Z2V0IGxvY2tpbmcgcmlnaHQgdXNpbmcNCj4gdGhlIGRldmxpbmtfKiBBUElzIPCfmJTvuI8NCg0K
VGhpcyBvcGVyYXRpb24gY2FuIGhhcHBlbiBpbiBwYXJhbGxlbCB0byBhIHJlc2V0IG9mIHRoZSBk
ZXZpY2UgZnJvbSBhIGRpZmZlcmVudA0KY29udGV4dCB3aGljaCBpcyB1bnJlbGF0ZWQgdG8gZGV2
bGluay4gT3VyIGludGVudGlvbiBpcyB0byBhdm9pZCBzdWNoIGNhc2VzLA0KdGhlcmVmb3JlLCBo
b2xkaW5nIHRoZSBkZXZsaW5rIGxvY2sgdXNpbmcgZGV2bF9sb2NrIEFQSXMgd2lsbCBub3QgYmUg
c3VmZmljaWVudC4NClRoZSBkcml2ZXIgaG9sZHMgdGhlIFJUTkxfTE9DSyBpbiBrZXkgcGxhY2Vz
LCBlaXRoZXIgZXhwbGljaXRseSBvciBpbXBsaWNpdGx5LA0KYXMgaW4gZXRodG9vbCBjb25maWd1
cmF0aW9uIGNoYW5nZXMgZm9yIGV4YW1wbGUuDQo=
