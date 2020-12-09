Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366712D4534
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgLIPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:19:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5886 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgLIPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:19:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607527141; x=1639063141;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=tSICQDUPs66nJxfczRlMLkD4QxWuIAFL5JG14lQCK40=;
  b=qMTYmLc6IlBKUHU+Ec9WRjrMm4hq5dn7mg5qMlleHZZ51Joa5q0QRb8v
   AZz7Fhk9XGQ5IwfpEyMlQat+Qhy7eVgZ6Otp6QVBEcJ8icc4BfMsk3bpA
   g/SoAdwoL/ZtjIidsbd1AaH9E0Fai/7/YPKYUxsUKdCH9lU5gI6uQzxzp
   E=;
X-IronPort-AV: E=Sophos;i="5.78,405,1599523200"; 
   d="scan'208";a="71540010"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Dec 2020 15:18:13 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 64BE4A2128;
        Wed,  9 Dec 2020 15:18:10 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Dec 2020 15:18:04 +0000
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-2-andraprs@amazon.com>
 <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
 <20201208104222.605bb669@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201209104806.qbuemoz3oy6d3v3b@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <4f2a1ac5-68c7-190f-6abf-452f67b3a7f4@amazon.com>
Date:   Wed, 9 Dec 2020 17:17:56 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209104806.qbuemoz3oy6d3v3b@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D07UWA004.ant.amazon.com (10.43.160.32) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwOS8xMi8yMDIwIDEyOjQ4LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBU
dWUsIERlYyAwOCwgMjAyMCBhdCAxMDo0MjoyMkFNIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90
ZToKPj4gT24gVHVlLCA4IERlYyAyMDIwIDIwOjIzOjI0ICswMjAwIFBhcmFzY2hpdiwgQW5kcmEt
SXJpbmEgd3JvdGU6Cj4+PiA+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5o
Cj4+PiA+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oCj4+PiA+PiBAQCAt
MTQ1LDcgKzE0NSw3IEBACj4+PiA+Pgo+Pj4gPj7CoMKgIHN0cnVjdCBzb2NrYWRkcl92bSB7Cj4+
PiA+PsKgwqDCoMKgwqDCoMKgIF9fa2VybmVsX3NhX2ZhbWlseV90IHN2bV9mYW1pbHk7Cj4+PiA+
PiAtwqDCoMKgwqAgdW5zaWduZWQgc2hvcnQgc3ZtX3Jlc2VydmVkMTsKPj4+ID4+ICvCoMKgwqDC
oCB1bnNpZ25lZCBzaG9ydCBzdm1fZmxhZ3M7Cj4+PiA+PsKgwqDCoMKgwqDCoMKgIHVuc2lnbmVk
IGludCBzdm1fcG9ydDsKPj4+ID4+wqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHN2bV9jaWQ7
Cj4+PiA+PsKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGNoYXIgc3ZtX3plcm9bc2l6ZW9mKHN0cnVj
dCBzb2NrYWRkcikgLQo+Pj4gPiBTaW5jZSB0aGlzIGlzIGEgdUFQSSBoZWFkZXIgSSBnb3R0YSBh
c2sgLSBhcmUgeW91IDEwMCUgc3VyZSB0aGF0IGl0J3MKPj4+ID4gb2theSB0byByZW5hbWUgdGhp
cyBmaWVsZD8KPj4+ID4KPj4+ID4gSSBkaWRuJ3QgZ3Jhc3AgZnJvbSBqdXN0IHJlYWRpbmcgdGhl
IHBhdGNoZXMgd2hldGhlciB0aGlzIGlzIGEgCj4+PiB1QVBJIG9yCj4+PiA+IGp1c3QgaW50ZXJu
YWwga2VybmVsIGZsYWcsIHNlZW1zIGxpa2UgdGhlIGZvcm1lciBmcm9tIHRoZSByZWFkaW5nIG9m
Cj4+PiA+IHRoZSBjb21tZW50IGluIHBhdGNoIDIuIEluIHdoaWNoIGNhc2Ugd2hhdCBndWFyYW50
ZWVzIHRoYXQgZXhpc3RpbmcKPj4+ID4gdXNlcnMgZG9uJ3QgcGFzcyBpbiBnYXJiYWdlIHNpbmNl
IHRoZSBrZXJuZWwgZG9lc24ndCBjaGVjayBpdCB3YXMgMD8KPj4+Cj4+PiBUaGF0J3MgYWx3YXlz
IGdvb2QgdG8gZG91YmxlLWNoZWNrIHRoZSB1YXBpIGNoYW5nZXMgZG9uJ3QgYnJlYWsgLyAKPj4+
IGFzc3VtZQo+Pj4gc29tZXRoaW5nLCB0aGFua3MgZm9yIGJyaW5naW5nIHRoaXMgdXAuIDopCj4+
Pgo+Pj4gU3VyZSwgbGV0J3MgZ28gdGhyb3VnaCB0aGUgcG9zc2libGUgb3B0aW9ucyBzdGVwIGJ5
IHN0ZXAuIExldCBtZSAKPj4+IGtub3cgaWYKPj4+IEkgZ2V0IGFueXRoaW5nIHdyb25nIGFuZCBp
ZiBJIGNhbiBoZWxwIHdpdGggY2xhcmlmaWNhdGlvbnMuCj4+Pgo+Pj4gVGhlcmUgaXMgdGhlICJz
dm1fcmVzZXJ2ZWQxIiBmaWVsZCB0aGF0IGlzIG5vdCB1c2VkIGluIHRoZSBrZXJuZWwKPj4+IGNv
ZGViYXNlLiBJdCBpcyBzZXQgdG8gMCBvbiB0aGUgcmVjZWl2ZSAobGlzdGVuKSBwYXRoIGFzIHBh
cnQgb2YgdGhlCj4+PiB2c29jayBhZGRyZXNzIGluaXRpYWxpemF0aW9uIFsxXVsyXS4gVGhlICJz
dm1fZmFtaWx5IiBhbmQgInN2bV96ZXJvIgo+Pj4gZmllbGRzIGFyZSBjaGVja2VkIGFzIHBhcnQg
b2YgdGhlIGFkZHJlc3MgdmFsaWRhdGlvbiBbM10uCj4+Pgo+Pj4gTm93LCB3aXRoIHRoZSBjdXJy
ZW50IGNoYW5nZSB0byAic3ZtX2ZsYWdzIiwgdGhlIGZsb3cgaXMgdGhlIGZvbGxvd2luZzoKPj4+
Cj4+PiAqIE9uIHRoZSByZWNlaXZlIChsaXN0ZW4pIHBhdGgsIHRoZSByZW1vdGUgYWRkcmVzcyBz
dHJ1Y3R1cmUgaXMKPj4+IGluaXRpYWxpemVkIGFzIHBhcnQgb2YgdGhlIHZzb2NrIGFkZHJlc3Mg
aW5pdCBsb2dpYyBbMl0uIFRoZW4gcGF0Y2ggMy80Cj4+PiBvZiB0aGlzIHNlcmllcyBzZXRzIHRo
ZSAiVk1BRERSX0ZMQUdfVE9fSE9TVCIgZmxhZyBnaXZlbiBhIHNldCBvZgo+Pj4gY29uZGl0aW9u
cyAobG9jYWwgYW5kIHJlbW90ZSBDSUQgPiBWTUFERFJfQ0lEX0hPU1QpLgo+Pj4KPj4+ICogT24g
dGhlIGNvbm5lY3QgcGF0aCwgdGhlIHVzZXJzcGFjZSBsb2dpYyBjYW4gc2V0IHRoZSAic3ZtX2Zs
YWdzIgo+Pj4gZmllbGQuIEl0IGNhbiBiZSBzZXQgdG8gMCBvciAxIChWTUFERFJfRkxBR19UT19I
T1NUKTsgb3IgYW55IG90aGVyIAo+Pj4gdmFsdWUKPj4+IGdyZWF0ZXIgdGhhbiAxLiBJZiB0aGUg
IlZNQUREUl9GTEFHX1RPX0hPU1QiIGZsYWcgaXMgc2V0LCBhbGwgdGhlIHZzb2NrCj4+PiBwYWNr
ZXRzIGFyZSB0aGVuIGZvcndhcmRlZCB0byB0aGUgaG9zdC4KPj4+Cj4+PiAqIFdoZW4gdGhlIHZz
b2NrIHRyYW5zcG9ydCBpcyBhc3NpZ25lZCwgdGhlICJzdm1fZmxhZ3MiIGZpZWxkIGlzCj4+PiBj
aGVja2VkLCBhbmQgaWYgaXQgaGFzIHRoZSAiVk1BRERSX0ZMQUdfVE9fSE9TVCIgZmxhZyBzZXQs
IGl0IGdvZXMgb24KPj4+IHdpdGggYSBndWVzdC0+aG9zdCB0cmFuc3BvcnQgKHBhdGNoIDQvNCBv
ZiB0aGlzIHNlcmllcykuIE90aGVyd2lzZSwKPj4+IG90aGVyIHNwZWNpZmljIGZsYWcgdmFsdWUg
aXMgbm90IGN1cnJlbnRseSB1c2VkLgo+Pj4KPj4+IEdpdmVuIGFsbCB0aGVzZSBwb2ludHMsIHRo
ZSBxdWVzdGlvbiByZW1haW5zIHdoYXQgaGFwcGVucyBpZiB0aGUKPj4+ICJzdm1fZmxhZ3MiIGZp
ZWxkIGlzIHNldCBvbiB0aGUgY29ubmVjdCBwYXRoIHRvIGEgdmFsdWUgaGlnaGVyIHRoYW4gMQo+
Pj4gKG1heWJlIGEgYm9ndXMgb25lLCBub3QgaW50ZW5kZWQgc28pLiBBbmQgaXQgaW5jbHVkZXMg
dGhlCj4+PiAiVk1BRERSX0ZMQUdfVE9fSE9TVCIgdmFsdWUgKHRoZSBzaW5nbGUgZmxhZyBzZXQg
YW5kIHNwZWNpZmljYWxseSB1c2VkCj4+PiBmb3Igbm93LCBidXQgd2Ugc2hvdWxkIGFsc28gYWNj
b3VudCBmb3IgYW55IGZ1cnRoZXIgcG9zc2libGUgZmxhZ3MpLiBJbgo+Pj4gdGhpcyBjYXNlLCBh
bGwgdGhlIHZzb2NrIHBhY2tldHMgd291bGQgYmUgZm9yd2FyZGVkIHRvIHRoZSBob3N0IGFuZAo+
Pj4gbWF5YmUgbm90IGludGVuZGVkIHNvLCBoYXZpbmcgYSBib2d1cyB2YWx1ZSBmb3IgdGhlIGZs
YWdzIGZpZWxkLiBJcyAKPj4+IHRoaXMKPj4+IHBvc3NpYmxlIGNhc2Ugd2hhdCB5b3UgYXJlIHJl
ZmVycmluZyB0bz8KPj4KPj4gQ29ycmVjdC4gV2hhdCBpZiB1c2VyIGJhc2ljYWxseSBkZWNsYXJl
ZCB0aGUgc3RydWN0dXJlIG9uIHRoZSBzdGFjaywKPj4gYW5kIG9ubHkgaW5pdGlhbGl6ZWQgdGhl
IGZpZWxkcyB0aGUga2VybmVsIHVzZWQgdG8gY2hlY2s/Cj4+Cj4+IFRoaXMgcHJvYmxlbSBuZWVk
cyB0byBiZSBhdCB0aGUgdmVyeSBsZWFzdCBkaXNjdXNzZWQgaW4gdGhlIGNvbW1pdAo+PiBtZXNz
YWdlLgo+Pgo+Cj4gSSBhZ3JlZSB0aGF0IGNvdWxkIGJlIGEgcHJvYmxlbSwgYnV0IGhlcmUgc29t
ZSBjb25zaWRlcmF0aW9uczoKPiAtIEkgY2hlY2tlZCBzb21lIGFwcGxpY2F0aW9ucyAocWVtdS1n
dWVzdC1hZ2VudCwgbmNhdCwgaXBlcmYtdnNvY2spIGFuZAo+IMKgIGFsbCB1c2UgdGhlIHNhbWUg
cGF0dGVybjogYWxsb2NhdGUgbWVtb3J5LCBpbml0aWFsaXplIGFsbCB0aGUKPiDCoCBzb2NrYWRk
cl92bSB0byB6ZXJvICh0byBiZSBzdXJlIHRvIGluaXRpYWxpemUgdGhlIHN2bV96ZXJvKSwgc2V0
IHRoZQo+IMKgIGNpZCBhbmQgcG9ydCBmaWVsZHMuCj4gwqAgU28gd2Ugc2hvdWxkIGJlIHNhZmUs
IGJ1dCBvZiBjb3Vyc2UgaXQgbWF5IG5vdCBhbHdheXMgYmUgdHJ1ZS4KPgo+IC0gRm9yIG5vdyB0
aGUgaXNzdWUgY291bGQgYWZmZWN0IG9ubHkgbmVzdGVkIFZNcy4gV2UgaW50cm9kdWNlZCB0aGlz
Cj4gwqAgc3VwcG9ydCBvbmUgeWVhciBhZ28sIHNvIGl0J3Mgc29tZXRoaW5nIG5ldyBhbmQgbWF5
YmUgd2UgZG9uJ3QgY2F1c2UKPiDCoCB0b28gbWFueSBwcm9ibGVtcy4KPgo+IEFzIGFuIGFsdGVy
bmF0aXZlLCB3aGF0IGFib3V0IHVzaW5nIDEgb3IgMiBieXRlcyBmcm9tIHN2bV96ZXJvW10/Cj4g
VGhlc2UgbXVzdCBiZSBzZXQgYXQgemVybywgZXZlbiBpZiB3ZSBvbmx5IGNoZWNrIHRoZSBmaXJz
dCBieXRlIGluIHRoZQo+IGtlcm5lbC4KClRoYW5rcyBmb3IgdGhlIGZvbGxvdy11cCBpbmZvLgoK
V2UgY2FuIGFsc28gY29uc2lkZXIgdGhlICJzdm1femVybyIgb3B0aW9uIGFuZCBjb3VsZCB1c2Ug
MiBieXRlcyBmcm9tIAp0aGF0IGZpZWxkIGZvciAic3ZtX2ZsYWdzIiwga2VlcGluZyB0aGUgc2Ft
ZSAidW5zaWduZWQgc2hvcnQiIHR5cGUuCgpUaGFua3MsCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9w
bWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBM
YXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJv
bWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYy
MS8yMDA1Lgo=

