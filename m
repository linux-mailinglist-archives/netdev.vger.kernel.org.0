Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD8118649
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfLJL2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:28:31 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:57166 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfLJL2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:28:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575977310; x=1607513310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NUoCAK/mpjcbMc8JkpIMvzmW3nPRoFqvKWKq31LSnhU=;
  b=CfjPv74/dOZAp3TO16TJWXnVVqObDbHI9Q9A6HE13zzeb0FOyn284yKh
   G0RYxHKY0rpl3C2FgO1EW2DY2VI+1b4rr22laQJGUKweiWOMo5notcpeD
   tPC5jplLXuSezUmGBGxi0XnDImApITaeCPNlhOiJUthfHnHkPrLV8jqWV
   A=;
IronPort-SDR: Lglrm8HEe+jh9KQt4feCx2yXg0TuGW2Rl/RiUs5Mg1XsroEM+zktHX6D0Rx6ZThE+liN35QXyr
 ohh9khd/1mjQ==
X-IronPort-AV: E=Sophos;i="5.69,299,1571702400"; 
   d="scan'208";a="12634244"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2019 11:28:20 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 5373BA1FDE;
        Tue, 10 Dec 2019 11:28:19 +0000 (UTC)
Received: from EX13D06EUA001.ant.amazon.com (10.43.165.229) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 11:28:18 +0000
Received: from EX13D06EUA003.ant.amazon.com (10.43.165.206) by
 EX13D06EUA001.ant.amazon.com (10.43.165.229) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 11:28:18 +0000
Received: from EX13D06EUA003.ant.amazon.com ([10.43.165.206]) by
 EX13D06EUA003.ant.amazon.com ([10.43.165.206]) with mapi id 15.00.1367.000;
 Tue, 10 Dec 2019 11:28:17 +0000
From:   "Belgazal, Netanel" <netanel@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: Re: [PATCH V1 net] net: ena: fix napi handler misbehavior when the
 napi budget is zero
Thread-Topic: [PATCH V1 net] net: ena: fix napi handler misbehavior when the
 napi budget is zero
Thread-Index: AQHVre08IfwyGPSUS0646Jb1q0ppCaeyIt0AgAE8pYA=
Date:   Tue, 10 Dec 2019 11:28:17 +0000
Message-ID: <4903CBE2-8A70-4B47-ABB2-A884C99E3ABF@amazon.com>
References: <20191208173026.25745-1-netanel@amazon.com>
 <20191209.103458.2167030481856657930.davem@davemloft.net>
In-Reply-To: <20191209.103458.2167030481856657930.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.10.f.191014
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.120]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7A73E56663E16499D0569BCD4C4D44E@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBqdXN0IGRpZCBpdC4NCg0KUmVnYXJkcywNCk5ldGFuZWwNCg0K77u/T24gMTIvOS8xOSwgODoz
NSBQTSwgIkRhdmlkIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+IHdyb3RlOg0KDQogICAg
RnJvbTogTmV0YW5lbCBCZWxnYXphbCA8bmV0YW5lbEBhbWF6b24uY29tPg0KICAgIERhdGU6IFN1
biwgOCBEZWMgMjAxOSAxNzozMDoyNiArMDAwMA0KICAgIA0KICAgID4gSW4gbmV0cG9sbCB0aGUg
bmFwaSBoYW5kbGVyIGNvdWxkIGJlIGNhbGxlZCB3aXRoIGJ1ZGdldCBlcXVhbCB0byB6ZXJvLg0K
ICAgID4gQ3VycmVudCBFTkEgbmFwaSBoYW5kbGVyIGRvZXNuJ3QgdGFrZSB0aGF0IGludG8gY29u
c2lkZXJhdGlvbi4NCiAgICA+IA0KICAgID4gVGhlIG5hcGkgaGFuZGxlciBoYW5kbGVzIFJ4IHBh
Y2tldHMgaW4gYSBkby13aGlsZSBsb29wLg0KICAgID4gQ3VycmVudGx5LCB0aGUgYnVkZ2V0IGNo
ZWNrIGhhcHBlbnMgb25seSBhZnRlciBkZWNyZW1lbnRpbmcgdGhlDQogICAgPiBidWRnZXQsIHRo
ZXJlZm9yZSB0aGUgbmFwaSBoYW5kbGVyLCBpbiByYXJlIGNhc2VzLCBjb3VsZCBydW4gb3Zlcg0K
ICAgID4gTUFYX0lOVCBwYWNrZXRzLg0KICAgID4gDQogICAgPiBJbiBhZGRpdGlvbiB0byB0aGF0
LCB0aGlzIG1vdmVzIGFsbCBidWRnZXQgcmVsYXRlZCB2YXJpYWJsZXMgdG8gaW50DQogICAgPiBj
YWxjdWxhdGlvbiBhbmQgc3RvcCBtaXhpbmcgdTMyIHRvIGF2b2lkIGFtYmlndWl0eQ0KICAgID4g
DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBOZXRhbmVsIEJlbGdhemFsIDxuZXRhbmVsQGFtYXpvbi5j
b20+DQogICAgDQogICAgQnVnIGZpeGVzIG5lZWQgdG8gaGF2ZSBhbiBhcHByb3ByaWF0ZSBGaXhl
czogdGFnLg0KICAgIA0KICAgIFBsZWFzZSByZXBvc3Qgd2l0aCB0aGF0IGFkZGVkLCB0aGFuayB5
b3UuDQogICAgDQoNCg==
