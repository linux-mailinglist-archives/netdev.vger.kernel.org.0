Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7D71EB06D
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFAUqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:46:55 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:8256 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFAUqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591044414; x=1622580414;
  h=from:to:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=ZLQRMmjXeZ9LXwaaepYqyU0oq/QACExlx8fvTsISthA=;
  b=EA4uVH7JXQpoPBY67Six+zvJHr8/gZwfJWKF6OuoLTA5I1p1+SRUf6il
   uP66heYcRw/6HRXK74AzwgdKa7LMgDgHoCsretkd3QGVSOyBqFLc6xbJ8
   kgij5VF8IudNZaOk3clrnjR60djKDPRDDQVUeWUUFEixztqwD1okm4pNg
   M=;
IronPort-SDR: xSAj6NUQuk1GI9XJvErr6FXDs1ApEMIJue3r2qVXTTl6oMfK95od4DorURWmH7QD72BU14905Q
 DHYsHdE8q+hQ==
X-IronPort-AV: E=Sophos;i="5.73,462,1583193600"; 
   d="scan'208";a="40686768"
Subject: Re: [PATCH 05/12] genirq: Shutdown irq chips in suspend/resume during
 hibernation
Thread-Topic: [PATCH 05/12] genirq: Shutdown irq chips in suspend/resume during hibernation
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Jun 2020 20:46:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id E0136A26B4;
        Mon,  1 Jun 2020 20:46:49 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 20:46:49 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 20:46:49 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1497.006;
 Mon, 1 Jun 2020 20:46:49 +0000
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
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Thread-Index: AQHWLjTy8XV/vbMfPkSkRneQeZchzKjBVJ6AgAKFKQA=
Date:   Mon, 1 Jun 2020 20:46:48 +0000
Message-ID: <86B7AA7D-F32A-47CA-B258-8456D02B3EE6@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <fce013fc1348f02b8e4ec61e7a631093c72f993c.1589926004.git.anchalag@amazon.com>
 <0471e6e3-b6ed-d2c6-db41-1688a0af9abd@oracle.com>
In-Reply-To: <0471e6e3-b6ed-d2c6-db41-1688a0af9abd@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.90]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E803394E47DA743B7734743B9ED83BC@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu78gICAgQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0
aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMg
c2FmZS4NCg0KDQoNCiAgICBPbiA1LzE5LzIwIDc6MjYgUE0sIEFuY2hhbCBBZ2Fyd2FsIHdyb3Rl
Og0KICAgID4gTWFueSBsZWdhY3kgZGV2aWNlIGRyaXZlcnMgZG8gbm90IGltcGxlbWVudCBwb3dl
ciBtYW5hZ2VtZW50IChQTSkNCiAgICA+IGZ1bmN0aW9ucyB3aGljaCBtZWFucyB0aGF0IGludGVy
cnVwdHMgcmVxdWVzdGVkIGJ5IHRoZXNlIGRyaXZlcnMgc3RheQ0KICAgID4gaW4gYWN0aXZlIHN0
YXRlIHdoZW4gdGhlIGtlcm5lbCBpcyBoaWJlcm5hdGVkLg0KICAgID4NCiAgICA+IFRoaXMgZG9l
cyBub3QgbWF0dGVyIG9uIGJhcmUgbWV0YWwgYW5kIG9uIG1vc3QgaHlwZXJ2aXNvcnMgYmVjYXVz
ZSB0aGUNCiAgICA+IGludGVycnVwdCBpcyByZXN0b3JlZCBvbiByZXN1bWUgd2l0aG91dCBhbnkg
bm90aWNhYmxlIHNpZGUgZWZmZWN0cyBhcw0KICAgID4gaXQgc3RheXMgY29ubmVjdGVkIHRvIHRo
ZSBzYW1lIHBoeXNpY2FsIG9yIHZpcnR1YWwgaW50ZXJydXB0IGxpbmUuDQogICAgPg0KICAgID4g
VGhlIFhFTiBpbnRlcnJ1cHQgbWVjaGFuaXNtIGlzIGRpZmZlcmVudCBhcyBpdCBtYWludGFpbnMg
YSBtYXBwaW5nDQogICAgPiBiZXR3ZWVuIHRoZSBMaW51eCBpbnRlcnJ1cHQgbnVtYmVyIGFuZCBh
IFhFTiBldmVudCBjaGFubmVsLiBJZiB0aGUNCiAgICA+IGludGVycnVwdCBzdGF5cyBhY3RpdmUg
b24gaGliZXJuYXRpb24gdGhpcyBtYXBwaW5nIGlzIHByZXNlcnZlZCBidXQNCiAgICA+IHRoZXJl
IGlzIHVuZm9ydHVuYXRlbHkgbm8gZ3VhcmFudGVlIHRoYXQgb24gcmVzdW1lIHRoZSBzYW1lIGV2
ZW50DQogICAgPiBjaGFubmVscyBhcmUgcmVhc3NpZ25lZCB0byB0aGVzZSBkZXZpY2VzLiBUaGlz
IGNhbiByZXN1bHQgaW4gZXZlbnQNCiAgICA+IGNoYW5uZWwgY29uZmxpY3RzIHdoaWNoIHByZXZl
bnQgdGhlIGFmZmVjdGVkIGRldmljZXMgZnJvbSBiZWluZw0KICAgID4gcmVzdG9yZWQgY29ycmVj
dGx5Lg0KICAgID4NCiAgICA+IE9uZSB3YXkgdG8gc29sdmUgdGhpcyB3b3VsZCBiZSB0byBhZGQg
dGhlIG5lY2Vzc2FyeSBwb3dlciBtYW5hZ2VtZW50DQogICAgPiBmdW5jdGlvbnMgdG8gYWxsIGFm
ZmVjdGVkIGxlZ2FjeSBkZXZpY2UgZHJpdmVycywgYnV0IHRoYXQncyBhDQogICAgPiBxdWVzdGlv
bmFibGUgZWZmb3J0IHdoaWNoIGRvZXMgbm90IHByb3ZpZGUgYW55IGJlbmVmaXRzIG9uIG5vbi1Y
RU4NCiAgICA+IGVudmlyb25tZW50cy4NCiAgICA+DQogICAgPiBUaGUgbGVhc3QgaW50cnVzaXZl
IGFuZCBtb3N0IGVmZmljaWVudCBzb2x1dGlvbiBpcyB0byBwcm92aWRlIGENCiAgICA+IG1lY2hh
bmlzbSB3aGljaCBhbGxvd3MgdGhlIGNvcmUgaW50ZXJydXB0IGNvZGUgdG8gdGVhciBkb3duIHRo
ZXNlDQogICAgPiBpbnRlcnJ1cHRzIG9uIGhpYmVybmF0aW9uIGFuZCBicmluZyB0aGVtIGJhY2sg
dXAgYWdhaW4gb24gcmVzdW1lLiBUaGlzDQogICAgPiBhbGxvd3MgdGhlIFhFTiBldmVudCBjaGFu
bmVsIG1lY2hhbmlzbSB0byBhc3NpZ24gYW4gYXJiaXRyYXJ5IGV2ZW50DQogICAgPiBjaGFubmVs
IG9uIHJlc3VtZSB3aXRob3V0IGFmZmVjdGluZyB0aGUgZnVuY3Rpb25hbGl0eSBvZiB0aGVzZQ0K
ICAgID4gZGV2aWNlcy4NCiAgICA+DQogICAgPiBGb3J0dW5hdGVseSBhbGwgdGhlc2UgZGV2aWNl
IGludGVycnVwdHMgYXJlIGhhbmRsZWQgYnkgYSBkZWRpY2F0ZWQgWEVODQogICAgPiBpbnRlcnJ1
cHQgY2hpcCBzbyB0aGUgY2hpcCBjYW4gYmUgbWFya2VkIHRoYXQgYWxsIGludGVycnVwdHMgY29u
bmVjdGVkDQogICAgPiB0byBpdCBhcmUgaGFuZGxlZCB0aGlzIHdheS4gVGhpcyBpcyBwcmV0dHkg
bXVjaCBpbiBsaW5lIHdpdGggdGhlIG90aGVyDQogICAgPiBpbnRlcnJ1cHQgY2hpcCBzcGVjaWZp
YyBxdWlya3MsIGUuZy4gSVJRQ0hJUF9NQVNLX09OX1NVU1BFTkQuDQogICAgPg0KICAgID4gQWRk
IGEgbmV3IHF1aXJrIGZsYWcgSVJRQ0hJUF9TSFVURE9XTl9PTl9TVVNQRU5EIGFuZCBhZGQgc3Vw
cG9ydCBmb3INCiAgICA+IGl0IHRoZSBjb3JlIGludGVycnVwdCBzdXNwZW5kL3Jlc3VtZSBwYXRo
cy4NCiAgICA+DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBBbmNoYWwgQWdhcndhbCA8YW5jaGFsYWdA
YW1hem9uLmNvbT4NCiAgICA+IFNpZ25lZC1vZmYtLWJ5OiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhA
bGludXRyb25peC5kZT4NCg0KDQogICAgU2luY2UgVGhvbWFzIHdyb3RlIHRoaXMgcGF0Y2ggSSB0
aGluayBpdCBzaG91bGQgYWxzbyBoYXZlICJGcm9tOiAiIGhpbS4NCg0KVGhhdCBzb3VuZHMgYWJv
dXQgcmlnaHQuIEkgd2lsbCB1cGRhdGUgaXQgbmV4dCByb3VuZCBhbmQgYWRkIFRlc3RlZC1ieS4N
Cg0KICAgIC1ib3Jpcw0KDQotIEFuY2hhbA0KDQoNCg0K
