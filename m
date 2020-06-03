Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58B01ED8B5
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 00:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgFCWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 18:40:23 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:60265 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgFCWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 18:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591224022; x=1622760022;
  h=from:to:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Myq6ZV85It0R/N8eLRhclOg1iR9ZpMgAQsNUyFxW00E=;
  b=piywcRHR6QcRsJn67IKNTa9KWgnwhGS8O6SLcN4CSD3YS4qJqsBLWmFr
   +I4mcdwpbvRrQUDD9XPKFmMPdJHsiLqEx3m8uudDsGLkuKqvcvUv0mSOL
   bsKn4e3BgWFeuTdJPX04mpjCgU/FDUewauqrzrykXVl8hw1lno25GYJWX
   E=;
IronPort-SDR: HGlszbAaMjRlQSBHjzfb07Sq8D3XcgSehxso6VS97ueiDdkojxtD16vl+YaA7qNIELHPqOLb9F
 PkJE9W82B+IA==
X-IronPort-AV: E=Sophos;i="5.73,470,1583193600"; 
   d="scan'208";a="41391349"
Subject: Re: [PATCH 04/12] x86/xen: add system core suspend and resume callbacks
Thread-Topic: [PATCH 04/12] x86/xen: add system core suspend and resume callbacks
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 03 Jun 2020 22:40:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 5F279A179C;
        Wed,  3 Jun 2020 22:40:16 +0000 (UTC)
Received: from EX13D05UWB001.ant.amazon.com (10.43.161.181) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 22:40:15 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D05UWB001.ant.amazon.com (10.43.161.181) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 22:40:15 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1497.006;
 Wed, 3 Jun 2020 22:40:15 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>
Thread-Index: AQHWLjTkyZyRRrOMA06VZoqhuNYdW6jBUn0AgAXLpQA=
Date:   Wed, 3 Jun 2020 22:40:15 +0000
Message-ID: <B966B3A2-4F08-42FA-AF59-B8AA0783C2BA@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <79cf02631dc00e62ebf90410bfbbdb52fe7024cb.1589926004.git.anchalag@amazon.com>
 <4b577564-e4c3-0182-2b9e-5f79004f32a1@oracle.com>
In-Reply-To: <4b577564-e4c3-0182-2b9e-5f79004f32a1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.48]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB32A01A0FC73E469E52EFDA0074EE47@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgIENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQoNCg0KDQogICAgT24gNS8xOS8yMCA3OjI2IFBNLCBBbmNoYWwgQWdhcndhbCB3cm90ZToNCiAg
ICA+IEZyb206IE11bmVoaXNhIEthbWF0YSA8a2FtYXRhbUBhbWF6b24uY29tPg0KICAgID4NCiAg
ICA+IEFkZCBYZW4gUFZIVk0gc3BlY2lmaWMgc3lzdGVtIGNvcmUgY2FsbGJhY2tzIGZvciBQTSBz
dXNwZW5kIGFuZA0KICAgID4gaGliZXJuYXRpb24gc3VwcG9ydC4gVGhlIGNhbGxiYWNrcyBzdXNw
ZW5kIGFuZCByZXN1bWUgWGVuDQogICAgPiBwcmltaXRpdmVzLGxpa2Ugc2hhcmVkX2luZm8sIHB2
Y2xvY2sgYW5kIGdyYW50IHRhYmxlLiBOb3RlIHRoYXQNCiAgICA+IFhlbiBzdXNwZW5kIGNhbiBo
YW5kbGUgdGhlbSBpbiBhIGRpZmZlcmVudCBtYW5uZXIsIGJ1dCBzeXN0ZW0NCiAgICA+IGNvcmUg
Y2FsbGJhY2tzIGFyZSBjYWxsZWQgZnJvbSB0aGUgY29udGV4dC4NCg0KDQogICAgSSBkb24ndCB0
aGluayBJIHVuZGVyc3RhbmQgdGhhdCBsYXN0IHNlbnRlbmNlLg0KDQpMb29rcyBsaWtlIGl0IG1h
eSBoYXZlIGNyeXB0aWMgbWVhbmluZyBvZiBzdGF0aW5nIHRoYXQgeGVuX3N1c3BlbmQgY2FsbHMg
c3lzY29yZV9zdXNwZW5kIGZyb20geGVuX3N1c3BlbmQNClNvLCBpZiB0aGVzZSBzeXNjb3JlIG9w
cyBnZXRzIGNhbGxlZCAgZHVyaW5nIHhlbl9zdXNwZW5kIGRvIG5vdCBkbyBhbnl0aGluZy4gQ2hl
Y2sgaWYgdGhlIG1vZGUgaXMgaW4geGVuIHN1c3BlbmQgDQphbmQgcmV0dXJuIGZyb20gdGhlcmUu
IFRoZXNlIHN5c2NvcmVfb3BzIGFyZSBzcGVjaWZpY2FsbHkgZm9yIGRvbVUgaGliZXJuYXRpb24u
DQpJIG11c3QgYWRtaXQsIEkgbWF5IGhhdmUgb3Zlcmxvb2tlZCBsYWNrIG9mIGV4cGxhbmF0aW9u
IG9mIHNvbWUgaW1wbGljaXQgZGV0YWlscyBpbiB0aGUgb3JpZ2luYWwgY29tbWl0IG1zZy4gDQoN
CiAgICA+ICBTbyBpZiB0aGUgY2FsbGJhY2tzDQogICAgPiBhcmUgY2FsbGVkIGZyb20gWGVuIHN1
c3BlbmQgY29udGV4dCwgcmV0dXJuIGltbWVkaWF0ZWx5Lg0KICAgID4NCg0KDQogICAgPiArDQog
ICAgPiArc3RhdGljIGludCB4ZW5fc3lzY29yZV9zdXNwZW5kKHZvaWQpDQogICAgPiArew0KICAg
ID4gKyAgICAgc3RydWN0IHhlbl9yZW1vdmVfZnJvbV9waHlzbWFwIHhyZnA7DQogICAgPiArICAg
ICBpbnQgcmV0Ow0KICAgID4gKw0KICAgID4gKyAgICAgLyogWGVuIHN1c3BlbmQgZG9lcyBzaW1p
bGFyIHN0dWZmcyBpbiBpdHMgb3duIGxvZ2ljICovDQogICAgPiArICAgICBpZiAoeGVuX3N1c3Bl
bmRfbW9kZV9pc194ZW5fc3VzcGVuZCgpKQ0KICAgID4gKyAgICAgICAgICAgICByZXR1cm4gMDsN
CiAgICA+ICsNCiAgICA+ICsgICAgIHhyZnAuZG9taWQgPSBET01JRF9TRUxGOw0KICAgID4gKyAg
ICAgeHJmcC5ncGZuID0gX19wYShIWVBFUlZJU09SX3NoYXJlZF9pbmZvKSA+PiBQQUdFX1NISUZU
Ow0KICAgID4gKw0KICAgID4gKyAgICAgcmV0ID0gSFlQRVJWSVNPUl9tZW1vcnlfb3AoWEVOTUVN
X3JlbW92ZV9mcm9tX3BoeXNtYXAsICZ4cmZwKTsNCiAgICA+ICsgICAgIGlmICghcmV0KQ0KICAg
ID4gKyAgICAgICAgICAgICBIWVBFUlZJU09SX3NoYXJlZF9pbmZvID0gJnhlbl9kdW1teV9zaGFy
ZWRfaW5mbzsNCiAgICA+ICsNCiAgICA+ICsgICAgIHJldHVybiByZXQ7DQogICAgPiArfQ0KICAg
ID4gKw0KICAgID4gK3N0YXRpYyB2b2lkIHhlbl9zeXNjb3JlX3Jlc3VtZSh2b2lkKQ0KICAgID4g
K3sNCiAgICA+ICsgICAgIC8qIFhlbiBzdXNwZW5kIGRvZXMgc2ltaWxhciBzdHVmZnMgaW4gaXRz
IG93biBsb2dpYyAqLw0KICAgID4gKyAgICAgaWYgKHhlbl9zdXNwZW5kX21vZGVfaXNfeGVuX3N1
c3BlbmQoKSkNCiAgICA+ICsgICAgICAgICAgICAgcmV0dXJuOw0KICAgID4gKw0KICAgID4gKyAg
ICAgLyogTm8gbmVlZCB0byBzZXR1cCB2Y3B1X2luZm8gYXMgaXQncyBhbHJlYWR5IG1vdmVkIG9m
ZiAqLw0KICAgID4gKyAgICAgeGVuX2h2bV9tYXBfc2hhcmVkX2luZm8oKTsNCiAgICA+ICsNCiAg
ICA+ICsgICAgIHB2Y2xvY2tfcmVzdW1lKCk7DQogICAgPiArDQogICAgPiArICAgICBnbnR0YWJf
cmVzdW1lKCk7DQoNCg0KICAgIERvIHlvdSBjYWxsIGdudHRhYl9zdXNwZW5kKCkgaW4gcG0gc3Vz
cGVuZCBwYXRoPw0KTm8sIHNpbmNlIGl0IGRvZXMgbm90aGluZyBmb3IgSFZNIGd1ZXN0cy4gVGhl
IHVubWFwX2ZyYW1lcyBpcyBvbmx5IGFwcGxpY2FibGUgZm9yIFBWIGd1ZXN0cyByaWdodD8NCg0K
ICAgID4gK30NCiAgICA+ICsNCiAgICA+ICsvKg0KICAgID4gKyAqIFRoZXNlIGNhbGxiYWNrcyB3
aWxsIGJlIGNhbGxlZCB3aXRoIGludGVycnVwdHMgZGlzYWJsZWQgYW5kIHdoZW4gaGF2aW5nIG9u
bHkNCiAgICA+ICsgKiBvbmUgQ1BVIG9ubGluZS4NCiAgICA+ICsgKi8NCiAgICA+ICtzdGF0aWMg
c3RydWN0IHN5c2NvcmVfb3BzIHhlbl9odm1fc3lzY29yZV9vcHMgPSB7DQogICAgPiArICAgICAu
c3VzcGVuZCA9IHhlbl9zeXNjb3JlX3N1c3BlbmQsDQogICAgPiArICAgICAucmVzdW1lID0geGVu
X3N5c2NvcmVfcmVzdW1lDQogICAgPiArfTsNCiAgICA+ICsNCiAgICA+ICt2b2lkIF9faW5pdCB4
ZW5fc2V0dXBfc3lzY29yZV9vcHModm9pZCkNCiAgICA+ICt7DQogICAgPiArICAgICBpZiAoeGVu
X2h2bV9kb21haW4oKSkNCg0KDQogICAgSGF2ZSB5b3UgdGVzdGVkIHRoaXMgKHRoZSB3aG9sZSBm
ZWF0dXJlLCBub3QganVzdCB0aGlzIHBhdGNoKSB3aXRoIFBWSA0KICAgIGd1ZXN0IEJUVz8gQW5k
IFBWSCBkb20wIGZvciB0aGF0IG1hdHRlcj8NCg0KTm8gSSBoYXZlbid0LiBUaGUgd2hvbGUgc2Vy
aWVzIGlzIGp1c3QgdGVzdGVkIHdpdGggaHZtL3B2aHZtIGd1ZXN0cy4NCg0KICAgIC1ib3Jpcw0K
VGhhbmtzLA0KQW5jaGFsDQoNCiAgICA+ICsgICAgICAgICAgICAgcmVnaXN0ZXJfc3lzY29yZV9v
cHMoJnhlbl9odm1fc3lzY29yZV9vcHMpOw0KICAgID4gK30NCg0KDQoNCg0K
