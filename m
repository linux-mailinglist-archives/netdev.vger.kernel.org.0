Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC532CAAFD
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbgLASpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:45:03 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:37268 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgLASpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:45:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606848302; x=1638384302;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gPL8yVdRgPPgaE4tkQOv9WMoBd1u11ZmTvs9QLNe4tU=;
  b=n3f1kb5EC57D+Cdg4X+PX0vZLC1ave50xI5EOig/Wv7uE+Ag0DN5qjZi
   KWNNxs1NwKaTk2ZX+UJdiZu6fSdWAv8jzM63KnxiUaVPPnVTudEyYe1Uc
   66lUn3mpq7vCGpfD7jJ5ZKzul4qeiCmQJh/CUnyipW9yNOZCPvZFNJ2s3
   I=;
X-IronPort-AV: E=Sophos;i="5.78,385,1599523200"; 
   d="scan'208";a="100895407"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Dec 2020 18:15:18 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 8461AA0828;
        Tue,  1 Dec 2020 18:15:15 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.102) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 18:15:10 +0000
Subject: Re: [PATCH net-next v1 1/3] vm_sockets: Include flag field in the
 vsock address data structure
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
 <20201201152505.19445-2-andraprs@amazon.com>
 <20201201160937.sswd3prfn6r52ihc@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <70d9868a-c883-d823-abf8-7e77ea4c933c@amazon.com>
Date:   Tue, 1 Dec 2020 20:15:04 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201160937.sswd3prfn6r52ihc@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D10UWB002.ant.amazon.com (10.43.161.130) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMS8xMi8yMDIwIDE4OjA5LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBU
dWUsIERlYyAwMSwgMjAyMCBhdCAwNToyNTowM1BNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IHZzb2NrIGVuYWJsZXMgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHZpcnR1YWwgbWFjaGlu
ZXMgYW5kIHRoZSBob3N0IHRoZXkKPj4gYXJlIHJ1bm5pbmcgb24uIFdpdGggdGhlIG11bHRpIHRy
YW5zcG9ydCBzdXBwb3J0IChndWVzdC0+aG9zdCBhbmQKPj4gaG9zdC0+Z3Vlc3QpLCBuZXN0ZWQg
Vk1zIGNhbiBhbHNvIHVzZSB2c29jayBjaGFubmVscyBmb3IgY29tbXVuaWNhdGlvbi4KPj4KPj4g
SW4gYWRkaXRpb24gdG8gdGhpcywgYnkgZGVmYXVsdCwgYWxsIHRoZSB2c29jayBwYWNrZXRzIGFy
ZSBmb3J3YXJkZWQgdG8KPj4gdGhlIGhvc3QsIGlmIG5vIGhvc3QtPmd1ZXN0IHRyYW5zcG9ydCBp
cyBsb2FkZWQuIFRoaXMgYmVoYXZpb3IgY2FuIGJlCj4+IGltcGxpY2l0bHkgdXNlZCBmb3IgZW5h
YmxpbmcgdnNvY2sgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHNpYmxpbmcgVk1zLgo+Pgo+PiBBZGQg
YSBmbGFnIGZpZWxkIGluIHRoZSB2c29jayBhZGRyZXNzIGRhdGEgc3RydWN0dXJlIHRoYXQgY2Fu
IGJlIHVzZWQgdG8KPj4gZXhwbGljaXRseSBtYXJrIHRoZSB2c29jayBjb25uZWN0aW9uIGFzIGJl
aW5nIHRhcmdldGVkIGZvciBhIGNlcnRhaW4KPj4gdHlwZSBvZiBjb21tdW5pY2F0aW9uLiBUaGlz
IHdheSwgY2FuIGRpc3Rpbmd1aXNoIGJldHdlZW4gbmVzdGVkIFZNcyBhbmQKPj4gc2libGluZyBW
TXMgdXNlIGNhc2VzIGFuZCBjYW4gYWxzbyBzZXR1cCB0aGVtIGF0IHRoZSBzYW1lIHRpbWUuIFRp
bGwKPj4gbm93LCBjb3VsZCBlaXRoZXIgaGF2ZSBuZXN0ZWQgVk1zIG9yIHNpYmxpbmcgVk1zIGF0
IGEgdGltZSB1c2luZyB0aGUKPj4gdnNvY2sgY29tbXVuaWNhdGlvbiBzdGFjay4KPj4KPj4gVXNl
IHRoZSBhbHJlYWR5IGF2YWlsYWJsZSAic3ZtX3Jlc2VydmVkMSIgZmllbGQgYW5kIG1hcmsgaXQg
YXMgYSBmbGFnCj4+IGZpZWxkIGluc3RlYWQuIFRoaXMgZmxhZyBjYW4gYmUgc2V0IHdoZW4gaW5p
dGlhbGl6aW5nIHRoZSB2c29jayBhZGRyZXNzCj4+IHZhcmlhYmxlIHVzZWQgZm9yIHRoZSBjb25u
ZWN0KCkgY2FsbC4KPgo+IE1heWJlIHdlIGNhbiBzcGxpdCB0aGlzIHBhdGNoIGluIDIgcGF0Y2hl
cywgb25lIHRvIHJlbmFtZSB0aGUgc3ZtX2ZsYWcKPiBhbmQgb25lIHRvIGFkZCB0aGUgbmV3IGZs
YWdzLgoKU3VyZSwgSSBjYW4gc3BsaXQgdGhpcyBpbiAyIHBhdGNoZXMsIHRvIGhhdmUgYSBiaXQg
bW9yZSBzZXBhcmF0aW9uIG9mIApkdXRpZXMuCgo+Cj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJh
IFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gLS0tCj4+IGluY2x1ZGUvdWFwaS9s
aW51eC92bV9zb2NrZXRzLmggfCAxOCArKysrKysrKysrKysrKysrKy0KPj4gMSBmaWxlIGNoYW5n
ZWQsIDE3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvdWFwaS9saW51eC92bV9zb2NrZXRzLmggCj4+IGIvaW5jbHVkZS91YXBpL2xpbnV4L3Zt
X3NvY2tldHMuaAo+PiBpbmRleCBmZDBlZDcyMjE2NDVkLi41OGRhNWE5MTQxM2FjIDEwMDY0NAo+
PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oCj4+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC92bV9zb2NrZXRzLmgKPj4gQEAgLTExNCw2ICsxMTQsMjIgQEAKPj4KPj4gI2Rl
ZmluZSBWTUFERFJfQ0lEX0hPU1QgMgo+Pgo+PiArLyogVGhpcyBzb2NrYWRkcl92bSBmbGFnIHZh
bHVlIGNvdmVycyB0aGUgY3VycmVudCBkZWZhdWx0IHVzZSBjYXNlOgo+PiArICogbG9jYWwgdnNv
Y2sgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIGd1ZXN0IGFuZCBob3N0IGFuZCBuZXN0ZWQgVk1zIAo+
PiBzZXR1cC4KPj4gKyAqIEluIGFkZGl0aW9uIHRvIHRoaXMsIGltcGxpY2l0bHksIHRoZSB2c29j
ayBwYWNrZXRzIGFyZSBmb3J3YXJkZWQgCj4+IHRvIHRoZSBob3N0Cj4+ICsgKiBpZiBubyBob3N0
LT5ndWVzdCB2c29jayB0cmFuc3BvcnQgaXMgc2V0Lgo+PiArICovCj4+ICsjZGVmaW5lIFZNQURE
Ul9GTEFHX0RFRkFVTFRfQ09NTVVOSUNBVElPTsKgwqDCoMKgIDB4MDAwMAo+Cj4gSSB0aGluayB3
ZSBkb24ndCBuZWVkIHRoaXMgbWFjcm8sIHNpbmNlIHRoZSBuZXh0IG9uZSBjYW4gYmUgdXNlZCB0
bwo+IGNoZWNrIGlmIGl0IGEgc2libGluZyBjb21tdW5pY2F0aW9uIChmbGFnIDB4MSBzZXQpIG9y
IG5vdCAoZmxhZyAweDEKPiBub3Qgc2V0KS4KClJpZ2h0LCB0aGF0J3Mgbm90IHBhcnRpY3VsYXJs
eSB0aGUgdXNlIG9mIHRoZSBmbGFnIHZhbHVlLCBhcyBieSBkZWZhdWx0IApjb21lcyBhcyAwLiBJ
dCB3YXMgbW9yZSBmb3Igc2hhcmluZyB0aGUgY2FzZXMgdGhpcyBjb3ZlcnMuIEJ1dCBJIGNhbiAK
cmVtb3ZlIHRoZSBkZWZpbmUgYW5kIGtlZXAgdGhpcyBraW5kIG9mIGluZm8sIHdpdGggcmVnYXJk
IHRvIHRoZSBkZWZhdWx0IApjYXNlLCBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgLyBjb21tZW50cy4K
Cj4KPj4gKwo+PiArLyogU2V0IHRoaXMgZmxhZyB2YWx1ZSBpbiB0aGUgc29ja2FkZHJfdm0gY29y
cmVzcG9uZGluZyBmaWVsZCBpZiB0aGUgCj4+IHZzb2NrCj4+ICsgKiBjaGFubmVsIG5lZWRzIHRv
IGJlIHNldHVwIGJldHdlZW4gdHdvIHNpYmxpbmcgVk1zIHJ1bm5pbmcgb24gdGhlIAo+PiBzYW1l
IGhvc3QuCj4+ICsgKiBUaGlzIHdheSBjYW4gZXhwbGljaXRseSBkaXN0aW5ndWlzaCBiZXR3ZWVu
IHZzb2NrIGNoYW5uZWxzIAo+PiBjcmVhdGVkIGZvciBuZXN0ZWQKPj4gKyAqIFZNcyAob3IgbG9j
YWwgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIGd1ZXN0IGFuZCBob3N0KSBhbmQgdGhlIG9uZXMgCj4+
IGNyZWF0ZWQgZm9yCj4+ICsgKiBzaWJsaW5nIFZNcy4gQW5kIHZzb2NrIGNoYW5uZWxzIGZvciBt
dWx0aXBsZSB1c2UgY2FzZXMgKG5lc3RlZCAvIAo+PiBzaWJsaW5nIFZNcykKPj4gKyAqIGNhbiBi
ZSBzZXR1cCBhdCB0aGUgc2FtZSB0aW1lLgo+PiArICovCj4+ICsjZGVmaW5lIFZNQUREUl9GTEFH
X1NJQkxJTkdfVk1TX0NPTU1VTklDQVRJT04gMHgwMDAxCj4KPiBXaGF0IGRvIHlvdSB0aGluayBp
ZiB3ZSBzaG9ydGVuIGluIFZNQUREUl9GTEFHX1NJQkxJTkc/Cj4KCll1cCwgdGhpcyBzZWVtcyBv
ayBhcyB3ZWxsIGZvciBtZS4gSSdsbCB1cGRhdGUgdGhlIG5hbWluZy4KClRoYW5rcywKQW5kcmEK
Cj4KPj4gKwo+PiAvKiBJbnZhbGlkIHZTb2NrZXRzIHZlcnNpb24uICovCj4+Cj4+ICNkZWZpbmUg
Vk1fU09DS0VUU19JTlZBTElEX1ZFUlNJT04gLTFVCj4+IEBAIC0xNDUsNyArMTYxLDcgQEAKPj4K
Pj4gc3RydWN0IHNvY2thZGRyX3ZtIHsKPj4gwqDCoMKgwqDCoCBfX2tlcm5lbF9zYV9mYW1pbHlf
dCBzdm1fZmFtaWx5Owo+PiAtwqDCoMKgwqDCoCB1bnNpZ25lZCBzaG9ydCBzdm1fcmVzZXJ2ZWQx
Owo+PiArwqDCoMKgwqDCoCB1bnNpZ25lZCBzaG9ydCBzdm1fZmxhZzsKPj4gwqDCoMKgwqDCoCB1
bnNpZ25lZCBpbnQgc3ZtX3BvcnQ7Cj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHN2bV9jaWQ7
Cj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgY2hhciBzdm1femVyb1tzaXplb2Yoc3RydWN0IHNvY2th
ZGRyKSAtCj4+IC0tIAo+PiAyLjIwLjEgKEFwcGxlIEdpdC0xMTcpCj4+Cj4+Cj4+Cj4+Cj4+IEFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmlj
ZTogMjdBIFNmLiAKPj4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENv
dW50eSwgNzAwMDQ1LCBSb21hbmlhLiAKPj4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3Ry
YXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCj4+Cj4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBD
ZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBT
dHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEu
IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1
Lgo=

