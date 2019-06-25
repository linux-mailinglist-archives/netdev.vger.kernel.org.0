Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC0520F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 05:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfFYDT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 23:19:26 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30004 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbfFYDTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 23:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561432765; x=1592968765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Tm85/P6EdnHUS9/ZgUYKUpI215+EhEkrIW3ZTHLkxks=;
  b=Jo8yVy2IeWvSivAmbaQ5LYHj3XmuPj7WV1Bq9Rhx7Fye5JYjIrOavLHl
   mXLx+rV/6OC+DmmWCtt3OXEqbQ50l0ffjI9AKujUfkpEaiK8v0tRkEXfE
   lQkLiHofrcMy0Q7c4OrTISjFJi6wGTyQp7B7cNb6ag4FKo2H6epuNLcyD
   A=;
X-IronPort-AV: E=Sophos;i="5.62,413,1554768000"; 
   d="scan'208";a="807462291"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jun 2019 03:19:24 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 7279FC2661;
        Tue, 25 Jun 2019 03:19:24 +0000 (UTC)
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 25 Jun 2019 03:19:23 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D04EUB004.ant.amazon.com (10.43.166.59) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 25 Jun 2019 03:19:22 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Tue, 25 Jun 2019 03:19:22 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Jubran, Samih" <sameehj@amazon.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>
Subject: Re: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Thread-Topic: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Thread-Index: AQHVKZJBCsQnHt2DH0+685GXOvKMPqapSsWAgAH2TYA=
Date:   Tue, 25 Jun 2019 03:19:22 +0000
Message-ID: <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
 <20190623070649.18447-2-sameehj@amazon.com> <20190623162133.6b7f24e1@carbon>
In-Reply-To: <20190623162133.6b7f24e1@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.187]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF7F838899875B4CACCF1E56D0E95FD7@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDYvMjMvMTksIDc6MjEgQU0sICJKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIiA8YnJv
dWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KDQogICAgT24gU3VuLCAyMyBKdW4gMjAxOSAxMDowNjo0
OSArMDMwMCA8c2FtZWVoakBhbWF6b24uY29tPiB3cm90ZToNCiAgICANCiAgICA+IFRoaXMgY29t
bWl0IGltcGxlbWVudHMgdGhlIGJhc2ljIGZ1bmN0aW9uYWxpdHkgb2YgZHJvcC9wYXNzIGxvZ2lj
IGluIHRoZQ0KICAgID4gZW5hIGRyaXZlci4NCiAgICANCiAgICBVc3VhbGx5IHdlIHJlcXVpcmUg
YSBkcml2ZXIgdG8gaW1wbGVtZW50IGFsbCB0aGUgWERQIHJldHVybiBjb2RlcywNCiAgICBiZWZv
cmUgd2UgYWNjZXB0IGl0LiAgQnV0IGFzIERhbmllbCBhbmQgSSBkaXNjdXNzZWQgd2l0aCBab3Jp
ayBkdXJpbmcNCiAgICBOZXRDb25mWzFdLCB3ZSBhcmUgZ29pbmcgdG8gbWFrZSBhbiBleGNlcHRp
b24gYW5kIGFjY2VwdCB0aGUgZHJpdmVyDQogICAgaWYgeW91IGFsc28gaW1wbGVtZW50IFhEUF9U
WC4NCiAgICANCiAgICBBcyB3ZSB0cnVzdCB0aGF0IFpvcmlrL0FtYXpvbiB3aWxsIGZvbGxvdyBh
bmQgaW1wbGVtZW50IFhEUF9SRURJUkVDVA0KICAgIGxhdGVyLCBnaXZlbiBoZS95b3Ugd2FudHMg
QUZfWERQIHN1cHBvcnQgd2hpY2ggcmVxdWlyZXMgWERQX1JFRElSRUNULg0KDQpKZXNwZXIsIHRo
YW5rcyBmb3IgeW91ciBjb21tZW50cyBhbmQgdmVyeSBoZWxwZnVsIGRpc2N1c3Npb24gZHVyaW5n
IE5ldENvbmYhIA0KVGhhdCdzIHRoZSBwbGFuLCBhcyB3ZSBhZ3JlZWQuIEZyb20gb3VyIHNpZGUg
SSB3b3VsZCBsaWtlIHRvIHJlaXRlcmF0ZSBhZ2FpbiB0aGUgDQppbXBvcnRhbmNlIG9mIG11bHRp
LWJ1ZmZlciBzdXBwb3J0IGJ5IHhkcCBmcmFtZS4gV2Ugd291bGQgcmVhbGx5IHByZWZlciBub3Qg
DQp0byBzZWUgb3VyIE1UVSBzaHJpbmtpbmcgYmVjYXVzZSBvZiB4ZHAgc3VwcG9ydC4gICANCg0K
ICAgIA0KICAgIFsxXSBodHRwOi8vdmdlci5rZXJuZWwub3JnL25ldGNvbmYyMDE5Lmh0bWwNCiAg
ICAtLSANCiAgICBCZXN0IHJlZ2FyZHMsDQogICAgICBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyDQog
ICAgICBNU2MuQ1MsIFByaW5jaXBhbCBLZXJuZWwgRW5naW5lZXIgYXQgUmVkIEhhdA0KICAgICAg
TGlua2VkSW46IGh0dHA6Ly93d3cubGlua2VkaW4uY29tL2luL2Jyb3Vlcg0KICAgIA0KDQo=
