Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0A521BE1F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGJTxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:53:51 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61444 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJTxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594410830; x=1625946830;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=eE68H+aTSnuIATN+vAcpC+rA1gjzQ4/DCzb+CbMLdhU=;
  b=GTXW76dY3CMxAbBL41sVlbjMOlkV7+rLnnQ/kAtxji/0uFA+dGGrJDHr
   tMqpGkgnAmR3g3ZkPXuGzUVfwroOYsghn25zfA0wHJhjHZJCLxW+Ibdu3
   gVF8UUnGgFWJoP2TjtiL9W7HomCfQXYcYJ4FSclM+tbOrkmrKux5IbT7C
   c=;
IronPort-SDR: Jb60msTeavhY3oGOcijXKbjnbbte5RSb6BZha6UuYXqbB24JZTeHh6aAmf311isydtqTcYINF6
 ZTkrQF8J3mzg==
X-IronPort-AV: E=Sophos;i="5.75,336,1589241600"; 
   d="scan'208";a="41168158"
Subject: Re: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Thread-Topic: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 10 Jul 2020 19:53:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 09742A1C6B;
        Fri, 10 Jul 2020 19:53:47 +0000 (UTC)
Received: from EX13D04EUB001.ant.amazon.com (10.43.166.190) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 19:53:47 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D04EUB001.ant.amazon.com (10.43.166.190) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 19:53:46 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Fri, 10 Jul 2020 19:53:46 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWViPyxgncFwies0e5jhwpAWeGRqj/sUCAgAEUwoA=
Date:   Fri, 10 Jul 2020 19:53:46 +0000
Message-ID: <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
 <1594321503-12256-7-git-send-email-akiyano@amazon.com>
 <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.16]
Content-Type: text/plain; charset="utf-8"
Content-ID: <452CF43880E099449C40E9B4B3AB58C9@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDcvOS8yMCwgMToyNCBQTSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToNCg0KICAgIE9uIFRodSwgOSBKdWwgMjAyMCAyMjowNTowMSArMDMwMCBha2l5
YW5vQGFtYXpvbi5jb20gd3JvdGU6DQogICAgPiBGcm9tOiBBcnRodXIgS2l5YW5vdnNraSA8YWtp
eWFub0BhbWF6b24uY29tPg0KICAgID4NCiAgICA+IEFkZCB0aGUgcnNzX2NvbmZpZ3VyYWJsZV9m
dW5jdGlvbl9rZXkgYml0IHRvIGRyaXZlcl9zdXBwb3J0ZWRfZmVhdHVyZS4NCiAgICA+DQogICAg
PiBUaGlzIGJpdCB0ZWxscyB0aGUgZGV2aWNlIHRoYXQgdGhlIGRyaXZlciBpbiBxdWVzdGlvbiBz
dXBwb3J0cyB0aGUNCiAgICA+IHJldHJpZXZpbmcgYW5kIHVwZGF0aW5nIG9mIFJTUyBmdW5jdGlv
biBhbmQgaGFzaCBrZXksIGFuZCB0aGVyZWZvcmUNCiAgICA+IHRoZSBkZXZpY2Ugc2hvdWxkIGFs
bG93IFJTUyBmdW5jdGlvbiBhbmQga2V5IG1hbmlwdWxhdGlvbi4NCiAgICA+DQogICAgPiBTaWdu
ZWQtb2ZmLWJ5OiBBcnRodXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0KDQogICAg
SXMgdGhpcyBhIGZpeCBvZiB0aGUgcHJldmlvdXMgcGF0Y2hlcz8gbG9va3Mgc3RyYW5nZSB0byBq
dXN0IHN0YXJ0DQogICAgYWR2ZXJ0aXNpbmcgYSBmZWF0dXJlIGJpdCBidXQgbm90IGFkZCBhbnkg
Y29kZS4uDQoNClRoZSBwcmV2aW91cyByZWxhdGVkIGNvbW1pdHMgd2VyZSBtZXJnZWQgYWxyZWFk
eToNCjBhZjNjNGUyZWFiOCBuZXQ6IGVuYTogY2hhbmdlcyB0byBSU1MgaGFzaCBrZXkgYWxsb2Nh
dGlvbg0KYzFiZDE3ZTUxYzcxIG5ldDogZW5hOiBjaGFuZ2UgZGVmYXVsdCBSU1MgaGFzaCBmdW5j
dGlvbiB0byBUb2VwbGl0eg0KZjY2YzJlYTNiMThhIG5ldDogZW5hOiBhbGxvdyBzZXR0aW5nIHRo
ZSBoYXNoIGZ1bmN0aW9uIHdpdGhvdXQgY2hhbmdpbmcgdGhlIGtleQ0KZTlhMWRlMzc4ZGQ0IG5l
dDogZW5hOiBmaXggZXJyb3IgcmV0dXJuaW5nIGluIGVuYV9jb21fZ2V0X2hhc2hfZnVuY3Rpb24o
KQ0KODBmODQ0M2ZjZGFhIG5ldDogZW5hOiBhdm9pZCB1bm5lY2Vzc2FyeSBhZG1pbiBjb21tYW5k
IHdoZW4gUlNTIGZ1bmN0aW9uIHNldCBmYWlscw0KNmE0ZjdkYzgyZDFlIG5ldDogZW5hOiByc3M6
IGRvIG5vdCBhbGxvY2F0ZSBrZXkgd2hlbiBub3Qgc3VwcG9ydGVkDQowZDFjM2RlN2I4YzcgbmV0
OiBlbmE6IGZpeCBpbmNvcnJlY3QgZGVmYXVsdCBSU1Mga2V5DQoNClRoaXMgY29tbWl0IHdhcyBu
b3QgaW5jbHVkZWQgYnkgbWlzdGFrZSwgc28gd2UgYXJlIGFkZGluZyBpdCBub3cuIA0KDQo=
