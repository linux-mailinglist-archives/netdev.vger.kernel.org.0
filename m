Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578212CACB3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392449AbgLATtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:49:11 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:12182 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgLATtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606852151; x=1638388151;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=GzkO5rwPs8IlbxZJJrtJwOYn0DQoZfkgjuvYZZOBFQ8=;
  b=WRExycdlv4/+qPnlc1ANdSJsnXdF3ymAYKzupBD0637AqTgc0euZMWQO
   P4QhE+JWEMUaOA4g9ntMW1JqRfc+mqpo+/dlMvGn2vaq42GhHJz/rudkJ
   PDh+MmwcfBqnJ0qnBWaZUSEA5fWE68eWOPGcP/Fdxv6bnLHco1aFcp3zB
   s=;
X-IronPort-AV: E=Sophos;i="5.78,385,1599523200"; 
   d="scan'208";a="99646116"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 01 Dec 2020 19:06:53 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 57947A0644;
        Tue,  1 Dec 2020 19:06:51 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 19:06:45 +0000
Subject: Re: [PATCH net-next v1 3/3] af_vsock: Assign the vsock transport
 considering the vsock address flag
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201201152505.19445-1-andraprs@amazon.com>
 <20201201152505.19445-4-andraprs@amazon.com>
 <20201201162323.gwfzktkwtu6x4eef@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <17abfe6d-88d2-4d86-911a-247bd4bd677e@amazon.com>
Date:   Tue, 1 Dec 2020 21:06:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201162323.gwfzktkwtu6x4eef@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA002.ant.amazon.com (10.43.160.24) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMS8xMi8yMDIwIDE4OjIzLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBU
dWUsIERlYyAwMSwgMjAyMCBhdCAwNToyNTowNVBNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IFRoZSB2c29jayBmbGFnIGhhcyBiZWVuIHNldCBpbiB0aGUgY29ubmVjdCBhbmQgKGxp
c3RlbikgcmVjZWl2ZSBwYXRocy4KPj4KPj4gV2hlbiB0aGUgdnNvY2sgdHJhbnNwb3J0IGlzIGFz
c2lnbmVkLCB0aGUgcmVtb3RlIENJRCBpcyB1c2VkIHRvCj4+IGRpc3Rpbmd1aXNoIGJldHdlZW4g
dHlwZXMgb2YgY29ubmVjdGlvbi4KPj4KPj4gVXNlIHRoZSB2c29jayBmbGFnIChpbiBhZGRpdGlv
biB0byB0aGUgQ0lEKSBmcm9tIHRoZSByZW1vdGUgYWRkcmVzcyB0bwo+PiBkZWNpZGUgd2hpY2gg
dnNvY2sgdHJhbnNwb3J0IHRvIGFzc2lnbi4gRm9yIHRoZSBzaWJsaW5nIFZNcyB1c2UgY2FzZSwK
Pj4gYWxsIHRoZSB2c29jayBwYWNrZXRzIG5lZWQgdG8gYmUgZm9yd2FyZGVkIHRvIHRoZSBob3N0
LCBzbyBhbHdheXMgYXNzaWduCj4+IHRoZSBndWVzdC0+aG9zdCB0cmFuc3BvcnQgaWYgdGhlIHZz
b2NrIGZsYWcgaXMgc2V0LiBGb3IgdGhlIG90aGVyIHVzZQo+PiBjYXNlcywgdGhlIHZzb2NrIHRy
YW5zcG9ydCBhc3NpZ25tZW50IGxvZ2ljIGlzIG5vdCBjaGFuZ2VkLgo+Pgo+PiBTaWduZWQtb2Zm
LWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+IC0tLQo+PiBuZXQv
dm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAxNSArKysrKysrKysrKy0tLS0KPj4gMSBmaWxlIGNoYW5n
ZWQsIDExIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9u
ZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMKPj4gaW5k
ZXggZDEwOTE2YWI0NTI2Ny4uYmFmYzFjYjIwYWJkNCAxMDA2NDQKPj4gLS0tIGEvbmV0L3Ztd192
c29jay9hZl92c29jay5jCj4+ICsrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYwo+PiBAQCAt
NDE5LDE2ICs0MTksMjEgQEAgc3RhdGljIHZvaWQgdnNvY2tfZGVhc3NpZ25fdHJhbnNwb3J0KHN0
cnVjdCAKPj4gdnNvY2tfc29jayAqdnNrKQo+PiDCoCogKGUuZy4gZHVyaW5nIHRoZSBjb25uZWN0
KCkgb3Igd2hlbiBhIGNvbm5lY3Rpb24gcmVxdWVzdCBvbiBhIGxpc3RlbmVyCj4+IMKgKiBzb2Nr
ZXQgaXMgcmVjZWl2ZWQpLgo+PiDCoCogVGhlIHZzay0+cmVtb3RlX2FkZHIgaXMgdXNlZCB0byBk
ZWNpZGUgd2hpY2ggdHJhbnNwb3J0IHRvIHVzZToKPj4gLSAqwqAgLSByZW1vdGUgQ0lEID09IFZN
QUREUl9DSURfTE9DQUwgb3IgZzJoLT5sb2NhbF9jaWQgb3IgCj4+IFZNQUREUl9DSURfSE9TVCBp
Zgo+PiAtICrCoMKgwqAgZzJoIGlzIG5vdCBsb2FkZWQsIHdpbGwgdXNlIGxvY2FsIHRyYW5zcG9y
dDsKPj4gLSAqwqAgLSByZW1vdGUgQ0lEIDw9IFZNQUREUl9DSURfSE9TVCB3aWxsIHVzZSBndWVz
dC0+aG9zdCB0cmFuc3BvcnQ7Cj4+IC0gKsKgIC0gcmVtb3RlIENJRCA+IFZNQUREUl9DSURfSE9T
VCB3aWxsIHVzZSBob3N0LT5ndWVzdCB0cmFuc3BvcnQ7Cj4+ICsgKsKgIC0gcmVtb3RlIGZsYWcg
PT0gVk1BRERSX0ZMQUdfU0lCTElOR19WTVNfQ09NTVVOSUNBVElPTiwgd2lsbCBhbHdheXMKPj4g
KyAqwqDCoMKgIGZvcndhcmQgdGhlIHZzb2NrIHBhY2tldHMgdG8gdGhlIGhvc3QgYW5kIHVzZSBn
dWVzdC0+aG9zdCAKPj4gdHJhbnNwb3J0Owo+PiArICrCoCAtIG90aGVyd2lzZSwgZ29pbmcgZm9y
d2FyZCB3aXRoIHRoZSByZW1vdGUgZmxhZyBkZWZhdWx0IHZhbHVlOgo+PiArICrCoMKgwqAgLSBy
ZW1vdGUgQ0lEID09IFZNQUREUl9DSURfTE9DQUwgb3IgZzJoLT5sb2NhbF9jaWQgb3IgCj4+IFZN
QUREUl9DSURfSE9TVAo+PiArICrCoMKgwqDCoMKgIGlmIGcyaCBpcyBub3QgbG9hZGVkLCB3aWxs
IHVzZSBsb2NhbCB0cmFuc3BvcnQ7Cj4+ICsgKsKgwqDCoCAtIHJlbW90ZSBDSUQgPD0gVk1BRERS
X0NJRF9IT1NUIG9yIGgyZyBpcyBub3QgbG9hZGVkLCB3aWxsIHVzZQo+PiArICrCoMKgwqDCoMKg
IGd1ZXN0LT5ob3N0IHRyYW5zcG9ydDsKPj4gKyAqwqDCoMKgIC0gcmVtb3RlIENJRCA+IFZNQURE
Ul9DSURfSE9TVCB3aWxsIHVzZSBob3N0LT5ndWVzdCB0cmFuc3BvcnQ7Cj4+IMKgKi8KPj4gaW50
IHZzb2NrX2Fzc2lnbl90cmFuc3BvcnQoc3RydWN0IHZzb2NrX3NvY2sgKnZzaywgc3RydWN0IHZz
b2NrX3NvY2sgCj4+ICpwc2spCj4+IHsKPj4gwqDCoMKgwqDCoCBjb25zdCBzdHJ1Y3QgdnNvY2tf
dHJhbnNwb3J0ICpuZXdfdHJhbnNwb3J0Owo+PiDCoMKgwqDCoMKgIHN0cnVjdCBzb2NrICpzayA9
IHNrX3Zzb2NrKHZzayk7Cj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHJlbW90ZV9jaWQgPSB2
c2stPnJlbW90ZV9hZGRyLnN2bV9jaWQ7Cj4+ICvCoMKgwqDCoMKgIHVuc2lnbmVkIHNob3J0IHJl
bW90ZV9mbGFnID0gdnNrLT5yZW1vdGVfYWRkci5zdm1fZmxhZzsKPj4gwqDCoMKgwqDCoCBpbnQg
cmV0Owo+Pgo+PiDCoMKgwqDCoMKgIHN3aXRjaCAoc2stPnNrX3R5cGUpIHsKPj4gQEAgLTQzOCw2
ICs0NDMsOCBAQCBpbnQgdnNvY2tfYXNzaWduX3RyYW5zcG9ydChzdHJ1Y3QgdnNvY2tfc29jayAK
Pj4gKnZzaywgc3RydWN0IHZzb2NrX3NvY2sgKnBzaykKPj4gwqDCoMKgwqDCoCBjYXNlIFNPQ0tf
U1RSRUFNOgo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodnNvY2tfdXNlX2xvY2Fs
X3RyYW5zcG9ydChyZW1vdGVfY2lkKSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIG5ld190cmFuc3BvcnQgPSB0cmFuc3BvcnRfbG9jYWw7Cj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlIGlmIChyZW1vdGVfZmxhZyA9PSAKPj4gVk1BRERSX0ZM
QUdfU0lCTElOR19WTVNfQ09NTVVOSUNBVElPTikKPgo+IE90aGVycyBmbGFncyBjYW4gYmUgYWRk
ZWQsIHNvIGhlcmUgd2Ugc2hvdWxkIHVzZSB0aGUgYml0d2lzZSBBTkQKPiBvcGVyYXRvciB0byBj
aGVjayBpZiB0aGlzIGZsYWcgaXMgc2V0Lgo+Cj4gQW5kIHdoYXQgYWJvdXQgbWVyZ2luZyB3aXRo
IHRoZSBuZXh0IGlmIGNsYXVzZT8KPgoKSW5kZWVkLCBJJ2xsIHVwZGF0ZSB0aGUgY29kZWJhc2Ug
dG8gdXNlIHRoZSBiaXR3aXNlIG9wZXJhdG9yLiBUaGVuIEkgY2FuIAphbHNvIG1lcmdlIGFsbCB0
aGUgY2hlY2tzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIGcyaCB0cmFuc3BvcnQgaW4gYSBzaW5nbGUg
CmlmIGJsb2NrLgoKVGhhbmtzLApBbmRyYQoKPgo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIG5ld190cmFuc3BvcnQgPSB0cmFuc3BvcnRfZzJoOwo+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlIGlmIChyZW1vdGVfY2lkIDw9IFZNQUREUl9DSURf
SE9TVCB8fAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAhdHJhbnNwb3J0X2gyZykKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5ld190cmFuc3BvcnQg
PSB0cmFuc3BvcnRfZzJoOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4+IC0t
IAo+PiAyLjIwLjEgKEFwcGxlIEdpdC0xMTcpCj4+Cj4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBD
ZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBT
dHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEu
IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1
Lgo=

