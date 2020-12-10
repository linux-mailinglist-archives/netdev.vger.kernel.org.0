Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD62D5ADC
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 13:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbgLJMuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 07:50:09 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:23046 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgLJMuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 07:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607604609; x=1639140609;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=tcLqxPwaSqcgvBVU7moichOadnOJ+FPqDvzfSY3JseI=;
  b=exZXH4lky3Jd9Oc8F3yCkY8bZBVT7ReFUhW0QYG8/NqWNs9vsDc0vKlh
   IAhzRFS3qbDCzBVegBOhinst4usqxbyNK4dSe6mF57xPT7IV1GiHKR3U4
   R5AVyU6ieuqMYsKZySMrhBaEyN+v3mq4dXfUtANwZarUYLOTT43LeqnfQ
   k=;
X-IronPort-AV: E=Sophos;i="5.78,408,1599523200"; 
   d="scan'208";a="71742352"
Subject: Re: [PATCH net] tcp: select sane initial rcvq_space.space for big MSS
Thread-Topic: [PATCH net] tcp: select sane initial rcvq_space.space for big MSS
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Dec 2020 12:49:21 +0000
Received: from EX13D18EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 25885A240A;
        Thu, 10 Dec 2020 12:49:18 +0000 (UTC)
Received: from EX13D18EUA004.ant.amazon.com (10.43.165.164) by
 EX13D18EUA004.ant.amazon.com (10.43.165.164) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 12:49:18 +0000
Received: from EX13D18EUA004.ant.amazon.com ([10.43.165.164]) by
 EX13D18EUA004.ant.amazon.com ([10.43.165.164]) with mapi id 15.00.1497.006;
 Thu, 10 Dec 2020 12:49:18 +0000
From:   "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "ycheng@google.com" <ycheng@google.com>
Thread-Index: AQHWzX5HjH+8kJFOBEey/EOG0+0cU6nt6Y0AgAJhNIA=
Date:   Thu, 10 Dec 2020 12:49:18 +0000
Message-ID: <A65467F2-CC10-4FAF-A728-0969FD17E780@amazon.com>
References: <20201208162131.313635-1-eric.dumazet@gmail.com>
 <20201208.162852.2205708169665484487.davem@davemloft.net>
In-Reply-To: <20201208.162852.2205708169665484487.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3A593172E84F54E8D7B2E440403F370@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXJpYywNCg0KSSBkb24ndCBzZWUgdGhlIHBhdGNoIGluIHRoZSBzdGFibGUgcXVldWUuIENh
biB3ZSBhZGQgaXQgIHRvIHN0YWJsZSBzbyB3ZSBjYW4gY2hlcnJ5IHBpY2sgaXQgIGluIEFtYXpv
biBMaW51eCBrZXJuZWw/DQoNClRoYW5rIHlvdS4NCg0KSGF6ZW0NCg0K77u/T24gMDkvMTIvMjAy
MCwgMDA6MjksICJEYXZpZCBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PiB3cm90ZToNCg0K
ICAgIENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQoNCg0KDQogICAgRnJvbTogRXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPg0K
ICAgIERhdGU6IFR1ZSwgIDggRGVjIDIwMjAgMDg6MjE6MzEgLTA4MDANCg0KICAgID4gRnJvbTog
RXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KICAgID4NCiAgICA+IEJlZm9yZSBj
b21taXQgYTMzNzUzMWI5NDJiICgidGNwOiB1cCBpbml0aWFsIHJtZW0gdG8gMTI4S0IgYW5kIFNZ
TiByd2luIHRvIGFyb3VuZCA2NEtCIikNCiAgICA+IHNtYWxsIHRjcF9ybWVtWzFdIHZhbHVlcyB3
ZXJlIG92ZXJyaWRkZW4gYnkgdGNwX2ZpeHVwX3JjdmJ1ZigpIHRvIGFjY29tbW9kYXRlIHZhcmlv
dXMgTVNTLg0KICAgID4NCiAgICA+IFRoaXMgaXMgbm8gbG9uZ2VyIHRoZSBjYXNlLCBhbmQgSGF6
ZW0gTW9oYW1lZCBBYnVlbGZvdG9oIHJlcG9ydGVkDQogICAgPiB0aGF0IERSUyB3b3VsZCBub3Qg
d29yayBmb3IgTVRVIDkwMDAgZW5kcG9pbnRzIHJlY2VpdmluZyByZWd1bGFyICgxNTAwIGJ5dGVz
KSBmcmFtZXMuDQogICAgPg0KICAgID4gUm9vdCBjYXVzZSBpcyB0aGF0IHRjcF9pbml0X2J1ZmZl
cl9zcGFjZSgpIHVzZXMgdHAtPnJjdl93bmQgZm9yIHVwcGVyIGxpbWl0DQogICAgPiBvZiByY3Zx
X3NwYWNlLnNwYWNlIGNvbXB1dGF0aW9uLCB3aGlsZSBpdCBjYW4gc2VsZWN0IGxhdGVyIGEgc21h
bGxlcg0KICAgID4gdmFsdWUgZm9yIHRwLT5yY3Zfc3N0aHJlc2ggYW5kIHRwLT53aW5kb3dfY2xh
bXAuDQogICAgPg0KICAgID4gc3MgLXRlbW9pIG9uIHJlY2VpdmVyIHdvdWxkIHNob3cgOg0KICAg
ID4NCiAgICA+IHNrbWVtOihyMCxyYjEzMTA3Mix0MCx0YjQ2MDgwLGYwLHcwLG8wLGJsMCxkMCkg
cmN2X3NwYWNlOjYyNDk2IHJjdl9zc3RocmVzaDo1NjU5Ng0KICAgID4NCiAgICA+IFRoaXMgbWVh
bnMgdGhhdCBUQ1AgY2FuIG5vdCBpbmNyZWFzZSBpdHMgd2luZG93IGluIHRjcF9ncm93X3dpbmRv
dygpLA0KICAgID4gYW5kIHRoYXQgRFJTIGNhbiBuZXZlciBraWNrLg0KICAgID4NCiAgICA+IEZp
eCB0aGlzIGJ5IG1ha2luZyBzdXJlIHRoYXQgcmN2cV9zcGFjZS5zcGFjZSBpcyBub3QgYmlnZ2Vy
IHRoYW4gbnVtYmVyIG9mIGJ5dGVzDQogICAgPiB0aGF0IGNhbiBiZSBoZWxkIGluIFRDUCByZWNl
aXZlIHF1ZXVlLg0KICAgID4NCiAgICA+IFBlb3BsZSB1bmFibGUvdW53aWxsaW5nIHRvIGNoYW5n
ZSB0aGVpciBrZXJuZWwgY2FuIHdvcmsgYXJvdW5kIHRoaXMgaXNzdWUgYnkNCiAgICA+IHNlbGVj
dGluZyBhIGJpZ2dlciB0Y3Bfcm1lbVsxXSB2YWx1ZSBhcyBpbiA6DQogICAgPg0KICAgID4gZWNo
byAiNDA5NiAxOTY2MDggNjI5MTQ1NiIgPi9wcm9jL3N5cy9uZXQvaXB2NC90Y3Bfcm1lbQ0KICAg
ID4NCiAgICA+IEJhc2VkIG9uIGFuIGluaXRpYWwgcmVwb3J0IGFuZCBwYXRjaCBmcm9tIEhhemVt
IE1vaGFtZWQgQWJ1ZWxmb3RvaA0KICAgID4gIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRl
di8yMDIwMTIwNDE4MDYyMi4xNDI4NS0xLWFidWVoYXplQGFtYXpvbi5jb20vDQogICAgPg0KICAg
ID4gRml4ZXM6IGEzMzc1MzFiOTQyYiAoInRjcDogdXAgaW5pdGlhbCBybWVtIHRvIDEyOEtCIGFu
ZCBTWU4gcndpbiB0byBhcm91bmQgNjRLQiIpDQogICAgPiBGaXhlczogMDQxYTE0ZDI2NzE1ICgi
dGNwOiBzdGFydCByZWNlaXZlciBidWZmZXIgYXV0b3R1bmluZyBzb29uZXIiKQ0KICAgID4gUmVw
b3J0ZWQtYnk6IEhhemVtIE1vaGFtZWQgQWJ1ZWxmb3RvaCA8YWJ1ZWhhemVAYW1hem9uLmNvbT4N
CiAgICA+IFNpZ25lZC1vZmYtYnk6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4N
Cg0KICAgIEFwcGxpZWQsIHRoYW5rcyBFcmljLg0KDQoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIEVN
RUEgU0FSTCwgMzggYXZlbnVlIEpvaG4gRi4gS2VubmVkeSwgTC0xODU1IEx1eGVtYm91cmcsIFIu
Qy5TLiBMdXhlbWJvdXJnIEIxODYyODQKCkFtYXpvbiBXZWIgU2VydmljZXMgRU1FQSBTQVJMLCBJ
cmlzaCBCcmFuY2gsIE9uZSBCdXJsaW5ndG9uIFBsYXphLCBCdXJsaW5ndG9uIFJvYWQsIER1Ymxp
biA0LCBJcmVsYW5kLCBicmFuY2ggcmVnaXN0cmF0aW9uIG51bWJlciA5MDg3MDUKCgo=

