Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9140F2B9494
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgKSO0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:26:08 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:39584 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgKSO0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605795967; x=1637331967;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qjdMlOWZXh4K/hB3uG1InFbNf+dnU/RQwbbTQxT6hlY=;
  b=miTTIiKCMbMbyOQg0AEahUGDZmexkGk+KEcndVeGuBoqL7VNQ8HVHYyw
   q2Jf3ou6IWYa3RRq/P5prJjTZLQQKCV6oPNopPEHWssyVO9+3BF5NM2X8
   Oc5PB8Ygq6h3lB1rn8qYYUtn3ORTdci+5AEVk/v+8utk7VWk5rlLePL3c
   M=;
X-IronPort-AV: E=Sophos;i="5.77,490,1596499200"; 
   d="scan'208";a="97012348"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Nov 2020 14:25:55 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 14B8B101206;
        Thu, 19 Nov 2020 14:25:51 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 14:25:51 +0000
Received: from freeip.amazon.com (10.43.161.43) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 14:25:47 +0000
Subject: Re: [PATCH net] vsock: forward all packets to the host when no H2G is
 registered
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <netdev@vger.kernel.org>, Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        "Anthony Liguori" <aliguori@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        "Andra Paraschiv" <andraprs@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, "Alexander Graf" <graf@amazon.de>
References: <20201112133837.34183-1-sgarzare@redhat.com>
 <20201119140359.GE838210@stefanha-x1.localdomain>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <ffdc9e0c-fee2-e334-053b-0a26305b55ae@amazon.com>
Date:   Thu, 19 Nov 2020 15:25:42 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:84.0)
 Gecko/20100101 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20201119140359.GE838210@stefanha-x1.localdomain>
Content-Language: en-US
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D03UWC003.ant.amazon.com (10.43.162.79) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ck9uIDE5LjExLjIwIDE1OjAzLCBTdGVmYW4gSGFqbm9jemkgd3JvdGU6Cj4gT24gVGh1LCBOb3Yg
MTIsIDIwMjAgYXQgMDI6Mzg6MzdQTSArMDEwMCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOgo+
PiBCZWZvcmUgY29tbWl0IGMwY2ZhMmQ4YTc4OCAoInZzb2NrOiBhZGQgbXVsdGktdHJhbnNwb3J0
cyBzdXBwb3J0IiksCj4+IGlmIGEgRzJIIHRyYW5zcG9ydCB3YXMgbG9hZGVkIChlLmcuIHZpcnRp
byB0cmFuc3BvcnQpLCBldmVyeSBwYWNrZXRzCj4+IHdhcyBmb3J3YXJkZWQgdG8gdGhlIGhvc3Qs
IHJlZ2FyZGxlc3Mgb2YgdGhlIGRlc3RpbmF0aW9uIENJRC4KPj4gVGhlIEgyRyB0cmFuc3BvcnRz
IGltcGxlbWVudGVkIHVudGlsIHRoZW4gKHZob3N0LXZzb2NrLCBWTUNJKSBhbHdheXMKPj4gcmVz
cG9uZGVkIHdpdGggYW4gZXJyb3IsIGlmIHRoZSBkZXN0aW5hdGlvbiBDSUQgd2FzIG5vdAo+PiBW
TUFERFJfQ0lEX0hPU1QuCj4+Cj4+ICBGcm9tIHRoYXQgY29tbWl0LCB3ZSBhcmUgdXNpbmcgdGhl
IHJlbW90ZSBDSUQgdG8gZGVjaWRlIHdoaWNoCj4+IHRyYW5zcG9ydCB0byB1c2UsIHNvIHBhY2tl
dHMgd2l0aCByZW1vdGUgQ0lEID4gVk1BRERSX0NJRF9IT1NUKDIpCj4+IGFyZSBzZW50IG9ubHkg
dGhyb3VnaCBIMkcgdHJhbnNwb3J0LiBJZiBubyBIMkcgaXMgYXZhaWxhYmxlLCBwYWNrZXRzCj4+
IGFyZSBkaXNjYXJkZWQgZGlyZWN0bHkgaW4gdGhlIGd1ZXN0Lgo+Pgo+PiBTb21lIHVzZSBjYXNl
cyAoZS5nLiBOaXRybyBFbmNsYXZlcyBbMV0pIHJlbHkgb24gdGhlIG9sZCBiZWhhdmlvdXIKPj4g
dG8gaW1wbGVtZW50IHNpYmxpbmcgVk1zIGNvbW11bmljYXRpb24sIHNvIHdlIHJlc3RvcmUgdGhl
IG9sZAo+PiBiZWhhdmlvciB3aGVuIG5vIEgyRyBpcyByZWdpc3RlcmVkLgo+PiBJdCB3aWxsIGJl
IHVwIHRvIHRoZSBob3N0IHRvIGRpc2NhcmQgcGFja2V0cyBpZiB0aGUgZGVzdGluYXRpb24gaXMK
Pj4gbm90IHRoZSByaWdodCBvbmUuIEFzIGl0IHdhcyBhbHJlYWR5IGltcGxlbWVudGVkIGJlZm9y
ZSBhZGRpbmcKPj4gbXVsdGktdHJhbnNwb3J0IHN1cHBvcnQuCj4+Cj4+IFRlc3RlZCB3aXRoIG5l
c3RlZCBRRU1VL0tWTSBieSBtZSBhbmQgTml0cm8gRW5jbGF2ZXMgYnkgQW5kcmEuCj4+Cj4+IFsx
XSBEb2N1bWVudGF0aW9uL3ZpcnQvbmVfb3ZlcnZpZXcucnN0Cj4+Cj4+IENjOiBKb3JnZW4gSGFu
c2VuIDxqaGFuc2VuQHZtd2FyZS5jb20+Cj4+IENjOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3Nv
ZnQuY29tPgo+PiBGaXhlczogYzBjZmEyZDhhNzg4ICgidnNvY2s6IGFkZCBtdWx0aS10cmFuc3Bv
cnRzIHN1cHBvcnQiKQo+PiBSZXBvcnRlZC1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0Bh
bWF6b24uY29tPgo+PiBUZXN0ZWQtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9u
LmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRo
YXQuY29tPgo+PiAtLS0KPj4gICBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgfCAyICstCj4+ICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCj4gQWNrZWQtYnk6
IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KCgpJcyB0aGVyZSBhbnl0aGlu
ZyB3ZSBoYXZlIHRvIGRvIHRvIGFsc28gZ2V0IHRoaXMgaW50byB0aGUgYWZmZWN0ZWQgCnN0YWJs
ZSB0cmVlcz8gOikKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkg
R21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNo
dCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDog
REUgMjg5IDIzNyA4NzkKCgo=

