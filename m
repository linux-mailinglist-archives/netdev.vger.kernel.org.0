Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD32CACA4
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392282AbgLAToq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:44:46 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:40620 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgLATop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606851884; x=1638387884;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=594SgZNdjDsywSezcV0Z6nCc3hdXELc3K5lOR/HXMoU=;
  b=o7fpzL4tEPvJGnCRXLjeMorWlhPvFaKITQezPM9NVsdDs9KNMBHFnnA1
   oXK4G4v+L8MCLvU8SI+w68nyI7oohBtAbDoxX3m4EwJoon9kszoqnJFP2
   sCGypnkmKjA2lAOuVr0rMKycckTZGKPdmw8R9hhVhiroQMBE7IUAVY8sj
   I=;
X-IronPort-AV: E=Sophos;i="5.78,385,1599523200"; 
   d="scan'208";a="92639036"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 19:01:20 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 0DE74A1F05;
        Tue,  1 Dec 2020 19:01:16 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 19:01:11 +0000
Subject: Re: [PATCH net-next v1 2/3] virtio_transport_common: Set sibling VMs
 flag on the receive path
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
 <20201201152505.19445-3-andraprs@amazon.com>
 <20201201162213.adcshbtspleosyod@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <447c0557-68f7-54ae-88ac-ebe50c6f2f9b@amazon.com>
Date:   Tue, 1 Dec 2020 21:01:05 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201162213.adcshbtspleosyod@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D10UWA003.ant.amazon.com (10.43.160.248) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwMS8xMi8yMDIwIDE4OjIyLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBU
dWUsIERlYyAwMSwgMjAyMCBhdCAwNToyNTowNFBNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IFRoZSB2c29jayBmbGFnIGNhbiBiZSBzZXQgZHVyaW5nIHRoZSBjb25uZWN0KCkgc2V0
dXAgbG9naWMsIHdoZW4KPj4gaW5pdGlhbGl6aW5nIHRoZSB2c29jayBhZGRyZXNzIGRhdGEgc3Ry
dWN0dXJlIHZhcmlhYmxlLiBUaGVuIHRoZSB2c29jawo+PiB0cmFuc3BvcnQgaXMgYXNzaWduZWQs
IGFsc28gY29uc2lkZXJpbmcgdGhpcyBmbGFnLgo+Pgo+PiBUaGUgdnNvY2sgdHJhbnNwb3J0IGlz
IGFsc28gYXNzaWduZWQgb24gdGhlIChsaXN0ZW4pIHJlY2VpdmUgcGF0aC4gVGhlCj4+IGZsYWcg
bmVlZHMgdG8gYmUgc2V0IGNvbnNpZGVyaW5nIHRoZSB1c2UgY2FzZS4KPj4KPj4gU2V0IHRoZSB2
c29jayBmbGFnIG9mIHRoZSByZW1vdGUgYWRkcmVzcyB0byB0aGUgb25lIHRhcmdldGVkIGZvciBz
aWJsaW5nCj4+IFZNcyBjb21tdW5pY2F0aW9uIGlmIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9ucyBh
cmUgbWV0Ogo+Pgo+PiAqIFRoZSBzb3VyY2UgQ0lEIG9mIHRoZSBwYWNrZXQgaXMgaGlnaGVyIHRo
YW4gVk1BRERSX0NJRF9IT1NULgo+PiAqIFRoZSBkZXN0aW5hdGlvbiBDSUQgb2YgdGhlIHBhY2tl
dCBpcyBoaWdoZXIgdGhhbiBWTUFERFJfQ0lEX0hPU1QuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gLS0tCj4+IG5ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDggKysrKysrKysKPj4gMSBmaWxlIGNoYW5n
ZWQsIDggaW5zZXJ0aW9ucygrKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92aXJ0
aW9fdHJhbnNwb3J0X2NvbW1vbi5jIAo+PiBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9y
dF9jb21tb24uYwo+PiBpbmRleCA1OTU2OTM5ZWViYjc4Li44NzFjODRlMDkxNmIxIDEwMDY0NAo+
PiAtLS0gYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMKPj4gKysrIGIv
bmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jCj4+IEBAIC0xMDYyLDYgKzEw
NjIsMTQgQEAgdmlydGlvX3RyYW5zcG9ydF9yZWN2X2xpc3RlbihzdHJ1Y3Qgc29jayAqc2ssIAo+
PiBzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdCAqcGt0LAo+PiDCoMKgwqDCoMKgIHZzb2NrX2FkZHJf
aW5pdCgmdmNoaWxkLT5yZW1vdGVfYWRkciwgCj4+IGxlNjRfdG9fY3B1KHBrdC0+aGRyLnNyY19j
aWQpLAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGUzMl90
b19jcHUocGt0LT5oZHIuc3JjX3BvcnQpKTsKPj4KPgo+IE1heWJlIGlzIGJldHRlciB0byBjcmVh
dGUgYW4gaGVscGVyIGZ1bmN0aW9uIHRoYXQgb3RoZXIgdHJhbnNwb3J0cyBjYW4KPiB1c2UgZm9y
IHRoZSBzYW1lIHB1cnBvc2Ugb3Igd2UgY2FuIHB1dCB0aGlzIGNvZGUgaW4gdGhlCj4gdnNvY2tf
YXNzaWduX3RyYW5zcG9ydCgpIGFuZCBzZXQgdGhpcyBmbGFnIG9ubHkgd2hlbiB0aGUgJ3Bzaycg
YXJndW1lbnQKPiBpcyBub3QgTlVMTCAodGhpcyBpcyB0aGUgY2FzZSB3aGVuIGl0J3MgY2FsbGVk
IGJ5IHRoZSB0cmFuc3BvcnRzIHdoZW4gd2UKPiByZWNlaXZlIGEgbmV3IGNvbm5lY3Rpb24gcmVx
dWVzdCBhbmQgJ3BzaycgaXMgdGhlIGxpc3RlbmVyIHNvY2tldCkuCj4KPiBUaGUgc2Vjb25kIHdh
eSBzaG91bGQgYWxsb3cgdXMgdG8gc3VwcG9ydCBhbGwgdGhlIHRyYW5zcG9ydHMgd2l0aG91dAo+
IHRvdWNoaW5nIHRoZW0uCgpBY2ssIEkgd2FzIHdvbmRlcmluZyBhYm91dCB0aGUgb3RoZXIgdHJh
bnNwb3J0cyBzdWNoIGFzIHZtY2kgb3IgaHlwZXJ2LgoKSSBjYW4gbW92ZSB0aGUgbG9naWMgYmVs
b3cgaW4gdGhlIGNvZGViYXNlIHRoYXQgYXNzaWducyB0aGUgdHJhbnNwb3J0LCAKYWZ0ZXIgY2hl
Y2tpbmcgJ3BzaycuCgo+Cj4+ICvCoMKgwqDCoMKgIC8qIElmIHRoZSBwYWNrZXQgaXMgY29taW5n
IHdpdGggdGhlIHNvdXJjZSBhbmQgZGVzdGluYXRpb24gCj4+IENJRHMgaGlnaGVyCj4+ICvCoMKg
wqDCoMKgwqAgKiB0aGFuIFZNQUREUl9DSURfSE9TVCwgdGhlbiBhIHZzb2NrIGNoYW5uZWwgc2hv
dWxkIGJlIAo+PiBlc3RhYmxpc2hlZCBmb3IKPj4gK8KgwqDCoMKgwqDCoCAqIHNpYmxpbmcgVk1z
IGNvbW11bmljYXRpb24uCj4+ICvCoMKgwqDCoMKgwqAgKi8KPj4gK8KgwqDCoMKgwqAgaWYgKHZj
aGlsZC0+bG9jYWxfYWRkci5zdm1fY2lkID4gVk1BRERSX0NJRF9IT1NUICYmCj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqAgdmNoaWxkLT5yZW1vdGVfYWRkci5zdm1fY2lkID4gVk1BRERSX0NJRF9IT1NU
KQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNoaWxkLT5yZW1vdGVfYWRkci5zdm1f
ZmxhZyA9IAo+PiBWTUFERFJfRkxBR19TSUJMSU5HX1ZNU19DT01NVU5JQ0FUSU9OOwo+Cj4gc3Zt
X2ZsYWcgaXMgYWx3YXlzIGluaXRpYWxpemVkIHRvIDAgaW4gdnNvY2tfYWRkcl9pbml0KCksIHNv
IHRoaXMKPiBhc3NpZ25tZW50IGlzIHRoZSBmaXJzdCBvbmUgYW5kIGl0J3Mgb2theSwgYnV0IHRv
IGF2b2lkIGZ1dHVyZSBpc3N1ZXMKPiBJJ2QgdXNlIHw9IGhlcmUgdG8gc2V0IHRoZSBmbGFnLgoK
RmFpciBwb2ludC4gSSB3YXMgdGhpbmtpbmcgbW9yZSB0b3dhcmRzIGV4Y2x1c2l2ZSBmbGFncyB2
YWx1ZXMgCihwdXJwb3NlcyksIGJ1dCB0aGF0J3MgZmluZSB3aXRoIHRoZSBiaXR3aXNlIG9wZXJh
dG9yIGlmIHdlIHdvdWxkIGdldCBhIApzZXQgb2YgZmxhZyB2YWx1ZXMgdG9nZXRoZXIuIEkgd2ls
bCBhbHNvIHVwZGF0ZSB0aGUgZmllbGQgbmFtZSB0byAKJ3N2bV9mbGFncycsIGxldCBtZSBrbm93
IGlmIHdlIHNob3VsZCBrZWVwIHRoZSBwcmV2aW91cyBvbmUgb3IgdGhlcmUgaXMgCmEgYmV0dGVy
IG9wdGlvbi4KClRoYW5rcywKQW5kcmEKCj4KPj4gKwo+PiDCoMKgwqDCoMKgIHJldCA9IHZzb2Nr
X2Fzc2lnbl90cmFuc3BvcnQodmNoaWxkLCB2c2spOwo+PiDCoMKgwqDCoMKgIC8qIFRyYW5zcG9y
dCBhc3NpZ25lZCAobG9va2luZyBhdCByZW1vdGVfYWRkcikgbXVzdCBiZSB0aGUgc2FtZQo+PiDC
oMKgwqDCoMKgwqAgKiB3aGVyZSB3ZSByZWNlaXZlZCB0aGUgcmVxdWVzdC4KPj4gLS0gMi4yMC4x
IChBcHBsZSBHaXQtMTE3KQo+Pgo+Pgo+Pgo+Pgo+PiBBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVy
IChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gCj4+IExhemFyIFN0
cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4g
Cj4+IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8y
MDA1Lgo+Pgo+CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4g
cmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJ
YXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEu
IFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

