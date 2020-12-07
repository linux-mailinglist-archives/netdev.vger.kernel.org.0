Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6E2D1972
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgLGT0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:26:42 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54950 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLGT0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607369202; x=1638905202;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Qk52FxS0FBAC1M8Ab9BgcixQ+mSTttHEC0f/5hPtxA4=;
  b=sL3miq8GxDrUbXWzmRc2jwPZI2nG+EMQQoLjX+tp3EnXAOao9YT3vm/R
   p9rNipCpqJYVDY48Xc/qxmJXtdDngdCcR888yovMvXDBwbvEhyGP86zVL
   Ex+uOs8XdzCre67x1Z3FjS9XomMvDC69R/9KkvST3rEcIcpZWKjuSavSs
   M=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="901217084"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 19:25:54 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 6B3C2A2168;
        Mon,  7 Dec 2020 19:25:51 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.252) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:25:46 +0000
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
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
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-2-andraprs@amazon.com>
 <20201207095905.q7rczeh54n2zy7fo@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <5c98dbc3-ecba-a579-8ada-48697367964c@amazon.com>
Date:   Mon, 7 Dec 2020 21:25:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207095905.q7rczeh54n2zy7fo@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D23UWC004.ant.amazon.com (10.43.162.219) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwNy8xMi8yMDIwIDExOjU5LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBG
cmksIERlYyAwNCwgMjAyMCBhdCAwNzowMjozMlBNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IHZzb2NrIGVuYWJsZXMgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHZpcnR1YWwgbWFjaGlu
ZXMgYW5kIHRoZSBob3N0IHRoZXkKPj4gYXJlIHJ1bm5pbmcgb24uIFdpdGggdGhlIG11bHRpIHRy
YW5zcG9ydCBzdXBwb3J0IChndWVzdC0+aG9zdCBhbmQKPj4gaG9zdC0+Z3Vlc3QpLCBuZXN0ZWQg
Vk1zIGNhbiBhbHNvIHVzZSB2c29jayBjaGFubmVscyBmb3IgY29tbXVuaWNhdGlvbi4KPj4KPj4g
SW4gYWRkaXRpb24gdG8gdGhpcywgYnkgZGVmYXVsdCwgYWxsIHRoZSB2c29jayBwYWNrZXRzIGFy
ZSBmb3J3YXJkZWQgdG8KPj4gdGhlIGhvc3QsIGlmIG5vIGhvc3QtPmd1ZXN0IHRyYW5zcG9ydCBp
cyBsb2FkZWQuIFRoaXMgYmVoYXZpb3IgY2FuIGJlCj4+IGltcGxpY2l0bHkgdXNlZCBmb3IgZW5h
YmxpbmcgdnNvY2sgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHNpYmxpbmcgVk1zLgo+Pgo+PiBBZGQg
YSBmbGFncyBmaWVsZCBpbiB0aGUgdnNvY2sgYWRkcmVzcyBkYXRhIHN0cnVjdHVyZSB0aGF0IGNh
biBiZSB1c2VkCj4+IHRvIGV4cGxpY2l0bHkgbWFyayB0aGUgdnNvY2sgY29ubmVjdGlvbiBhcyBi
ZWluZyB0YXJnZXRlZCBmb3IgYSBjZXJ0YWluCj4+IHR5cGUgb2YgY29tbXVuaWNhdGlvbi4gVGhp
cyB3YXksIGNhbiBkaXN0aW5ndWlzaCBiZXR3ZWVuIGRpZmZlcmVudCB1c2UKPj4gY2FzZXMgc3Vj
aCBhcyBuZXN0ZWQgVk1zIGFuZCBzaWJsaW5nIFZNcy4KPj4KPj4gVXNlIHRoZSBhbHJlYWR5IGF2
YWlsYWJsZSAic3ZtX3Jlc2VydmVkMSIgZmllbGQgYW5kIG1hcmsgaXQgYXMgYSBmbGFncwo+PiBm
aWVsZCBpbnN0ZWFkLiBUaGlzIGZpZWxkIGNhbiBiZSBzZXQgd2hlbiBpbml0aWFsaXppbmcgdGhl
IHZzb2NrIGFkZHJlc3MKPj4gdmFyaWFibGUgdXNlZCBmb3IgdGhlIGNvbm5lY3QoKSBjYWxsLgo+
Pgo+PiBDaGFuZ2Vsb2cKPj4KPj4gdjEgLT4gdjIKPj4KPj4gKiBVcGRhdGUgdGhlIGZpZWxkIG5h
bWUgdG8gInN2bV9mbGFncyIuCj4+ICogU3BsaXQgdGhlIGN1cnJlbnQgcGF0Y2ggaW4gMiBwYXRj
aGVzLgo+Cj4gVXN1YWxseSB0aGUgY2hhbmdlbG9nIGdvZXMgYWZ0ZXIgdGhlIDMgZGFzaGVzLCBi
dXQgSSdtIG5vdCBzdXJlIHRoZXJlIGlzCj4gYSBzdHJpY3QgcnVsZSA6LSkKCll1cCwgSSd2ZSBz
ZWVuIGJvdGggd2F5cy4gSSdkIHJhdGhlciBrZWVwIHRoZSBjaGFuZ2Vsb2cgaW4gdGhlIGNvbW1p
dCAKbWVzc2FnZSwgZm9yIGZ1cnRoZXIgcmVmZXJlbmNlIGFmdGVyIG1lcmdlLCBpbiB0aGUgY29t
bWl0cy4KCj4KPiBBbnl3YXkgdGhlIHBhdGNoIExHVE06Cj4KPiBSZXZpZXdlZC1ieTogU3RlZmFu
byBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPgoKVGhhbmsgeW91LgoKQW5kcmEKCj4K
Pj4KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29t
Pgo+PiAtLS0KPj4gaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaCB8IDIgKy0KPj4gMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCj4+Cj4+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oIAo+PiBiL2luY2x1ZGUvdWFwaS9s
aW51eC92bV9zb2NrZXRzLmgKPj4gaW5kZXggZmQwZWQ3MjIxNjQ1ZC4uNDY3MzUzNzZhNTdhOCAx
MDA2NDQKPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZtX3NvY2tldHMuaAo+PiArKysgYi9p
bmNsdWRlL3VhcGkvbGludXgvdm1fc29ja2V0cy5oCj4+IEBAIC0xNDUsNyArMTQ1LDcgQEAKPj4K
Pj4gc3RydWN0IHNvY2thZGRyX3ZtIHsKPj4gwqDCoMKgwqDCoCBfX2tlcm5lbF9zYV9mYW1pbHlf
dCBzdm1fZmFtaWx5Owo+PiAtwqDCoMKgwqDCoCB1bnNpZ25lZCBzaG9ydCBzdm1fcmVzZXJ2ZWQx
Owo+PiArwqDCoMKgwqDCoCB1bnNpZ25lZCBzaG9ydCBzdm1fZmxhZ3M7Cj4+IMKgwqDCoMKgwqAg
dW5zaWduZWQgaW50IHN2bV9wb3J0Owo+PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBzdm1fY2lk
Owo+PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGNoYXIgc3ZtX3plcm9bc2l6ZW9mKHN0cnVjdCBzb2Nr
YWRkcikgLQo+PiAtLSAKPj4gMi4yMC4xIChBcHBsZSBHaXQtMTE3KQo+Pgo+Pgo+Pgo+Pgo+PiBB
bWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZp
Y2U6IDI3QSBTZi4gCj4+IExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gCj4+IFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo+Pgo+CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQg
Q2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAw
NS4K

