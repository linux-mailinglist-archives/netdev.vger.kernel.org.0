Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254402D5FBF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbgLJPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:30:37 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13710 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgLJPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607614229; x=1639150229;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MhZAByVLLuYeb6Yt+0exS27yV+fgPNkBuQO+bOJbTFo=;
  b=LNPf2QhsL1/ywBJAtNH5T8nOvKLcM03CREzB2u/JhoACDl/BbSRF3M5Z
   lIr9BDSWaBGizPKYwPwwii07Xk25Pep/G5HzcRiGcRIWatXdw1z+hm/xt
   zNNMJI20+VPro9mHktkTAHYwl83F9tHVWEkojRh8MjqfBeNbFF5Y6lbtZ
   w=;
X-IronPort-AV: E=Sophos;i="5.78,408,1599523200"; 
   d="scan'208";a="68620578"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Dec 2020 15:29:41 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id B48B6A179A;
        Thu, 10 Dec 2020 15:29:40 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.185) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 15:29:35 +0000
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
To:     Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>
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
 <4f2a1ac5-68c7-190f-6abf-452f67b3a7f4@amazon.com>
 <20201209093019.1caae20e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <265d2382-3909-cf1d-f3af-4fd14278ad4c@amazon.com>
Date:   Thu, 10 Dec 2020 17:29:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209093019.1caae20e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.185]
X-ClientProxiedBy: EX13D43UWC003.ant.amazon.com (10.43.162.16) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwOS8xMi8yMDIwIDE5OjMwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToKPiBPbiBXZWQsIDkg
RGVjIDIwMjAgMTc6MTc6NTYgKzAyMDAgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToKPj4+
IEkgYWdyZWUgdGhhdCBjb3VsZCBiZSBhIHByb2JsZW0sIGJ1dCBoZXJlIHNvbWUgY29uc2lkZXJh
dGlvbnM6Cj4+PiAtIEkgY2hlY2tlZCBzb21lIGFwcGxpY2F0aW9ucyAocWVtdS1ndWVzdC1hZ2Vu
dCwgbmNhdCwgaXBlcmYtdnNvY2spIGFuZAo+Pj4gICAgYWxsIHVzZSB0aGUgc2FtZSBwYXR0ZXJu
OiBhbGxvY2F0ZSBtZW1vcnksIGluaXRpYWxpemUgYWxsIHRoZQo+Pj4gICAgc29ja2FkZHJfdm0g
dG8gemVybyAodG8gYmUgc3VyZSB0byBpbml0aWFsaXplIHRoZSBzdm1femVybyksIHNldCB0aGUK
Pj4+ICAgIGNpZCBhbmQgcG9ydCBmaWVsZHMuCj4+PiAgICBTbyB3ZSBzaG91bGQgYmUgc2FmZSwg
YnV0IG9mIGNvdXJzZSBpdCBtYXkgbm90IGFsd2F5cyBiZSB0cnVlLgo+Pj4KPj4+IC0gRm9yIG5v
dyB0aGUgaXNzdWUgY291bGQgYWZmZWN0IG9ubHkgbmVzdGVkIFZNcy4gV2UgaW50cm9kdWNlZCB0
aGlzCj4+PiAgICBzdXBwb3J0IG9uZSB5ZWFyIGFnbywgc28gaXQncyBzb21ldGhpbmcgbmV3IGFu
ZCBtYXliZSB3ZSBkb24ndCBjYXVzZQo+Pj4gICAgdG9vIG1hbnkgcHJvYmxlbXMuCj4+Pgo+Pj4g
QXMgYW4gYWx0ZXJuYXRpdmUsIHdoYXQgYWJvdXQgdXNpbmcgMSBvciAyIGJ5dGVzIGZyb20gc3Zt
X3plcm9bXT8KPj4+IFRoZXNlIG11c3QgYmUgc2V0IGF0IHplcm8sIGV2ZW4gaWYgd2Ugb25seSBj
aGVjayB0aGUgZmlyc3QgYnl0ZSBpbiB0aGUKPj4+IGtlcm5lbC4KPj4gVGhhbmtzIGZvciB0aGUg
Zm9sbG93LXVwIGluZm8uCj4+Cj4+IFdlIGNhbiBhbHNvIGNvbnNpZGVyIHRoZSAic3ZtX3plcm8i
IG9wdGlvbiBhbmQgY291bGQgdXNlIDIgYnl0ZXMgZnJvbQo+PiB0aGF0IGZpZWxkIGZvciAic3Zt
X2ZsYWdzIiwga2VlcGluZyB0aGUgc2FtZSAidW5zaWduZWQgc2hvcnQiIHR5cGUuCj4gT3IgdXNl
IHN2bV96ZXJvIGFzIGEgZ2F0ZSBmb3IgaW50ZXJwcmV0aW5nIG90aGVyIGZpZWxkcz8KPiBJZiBz
dm1femVyb1swXSogPT0gc29tZXRoaW5nIHN0YXJ0IGNoZWNraW5nIHRoZSB2YWx1ZSBvZiByZXNl
cnZlZDE/Cj4gKiBpbiBwcmFjdGljZSB0aGUgbmFtZSBjYW4gYmUgdW5pb25lZCB0byBzb21ldGhp
bmcgbW9yZSBwYWxhdGFibGUgOykKClRoYW5rcyBmb3IgdGhlIHNoYXJlZCBvcHRpb24sIHRoYXQg
Y291bGQgYmUgb25lIGNhc2UgdG8gcmV1c2UgdGhlIApyZXNlcnZlZCBmaWVsZCwgd2l0aCBhIHR3
byBwaGFzZSBjaGVjayBsb2dpYy4KCkknbGwgZ2l2ZSBpdCBhIHRyeSB0byB0aGUgb3B0aW9uIG9m
IGhhdmluZyBhIG5ldyBmaWVsZCAic3ZtX2ZsYWdzIiBhbmQgCnRoZSAic3ZtX3plcm8iIHVwZGF0
ZWQgYW5kIHRoZW4gc2VuZCBvdXQgYSBuZXcgcmV2aXNpb24uIEp1c3QgbGV0IG1lIAprbm93IGlm
IHRoZXJlIGFyZSBvdGhlciB1cGRhdGVzIG5lZWRlZCAvIHF1ZXN0aW9ucyBpbiB0aGUgbWVhbnRp
bWUuCgoKc3RydWN0IHNvY2thZGRyX3ZtIHsKIMKgwqDCoCBfX2tlcm5lbF9zYV9mYW1pbHlfdCBz
dm1fZmFtaWx5OwogwqDCoMKgIHVuc2lnbmVkIHNob3J0IHN2bV9yZXNlcnZlZDE7CiDCoMKgwqAg
dW5zaWduZWQgaW50IHN2bV9wb3J0OwogwqDCoMKgIHVuc2lnbmVkIGludCBzdm1fY2lkOwogwqDC
oMKgIHVuc2lnbmVkIHNob3J0IHN2bV9mbGFnczsKIMKgwqDCoCB1bnNpZ25lZCBjaGFyIHN2bV96
ZXJvW3NpemVvZihzdHJ1Y3Qgc29ja2FkZHIpIC0KIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDC
oMKgwqDCoCBzaXplb2Yoc2FfZmFtaWx5X3QpIC0KIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDC
oMKgwqDCoCBzaXplb2YodW5zaWduZWQgc2hvcnQpIC0KIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKg
wqDCoMKgwqDCoCBzaXplb2YodW5zaWduZWQgaW50KSAtIHNpemVvZih1bnNpZ25lZCBpbnQpIC0K
c2l6ZW9mKHVuc2lnbmVkIHNob3J0KV07Cn07CgoKVGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBT
Zi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1
LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIy
LzI2MjEvMjAwNS4K

