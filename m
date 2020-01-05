Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4371307CA
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 12:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgAELuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 06:50:07 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2922 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgAELuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 06:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578225007; x=1609761007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lg1v9M/VbcojrIJ7K5G8fqqptS1JU9IPfKrcUFg1Wuw=;
  b=Ql3i7Jn5ZXypIp8ehtty5UJqq228i1yK9Zd0WV9Kgrj1rxCgE/3dYyND
   rkhTkgxtODx+wRXOsdE+qCk/YpxlGFiGDtJxGtRQbFBh/xdBSXKDOKHvh
   kTi1f3HotNkrciY4Yuy/jdPxZmprLTjBdXjeD84GvWgY2VEWIFq3sLI3H
   I=;
IronPort-SDR: AfUyo1R8OSZ2uxszw38quRvJFlUD4HH3rk4QqbQH8GwPoNhQb8KFuITZ6XQulcORPjp2I6q3ri
 pfklJaAnYevA==
X-IronPort-AV: E=Sophos;i="5.69,398,1571702400"; 
   d="scan'208";a="16825679"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 05 Jan 2020 11:49:56 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 9FD4BA2250;
        Sun,  5 Jan 2020 11:49:53 +0000 (UTC)
Received: from EX13D11EUC001.ant.amazon.com (10.43.164.110) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Sun, 5 Jan 2020 11:49:53 +0000
Received: from EX13D06EUC004.ant.amazon.com (10.43.164.101) by
 EX13D11EUC001.ant.amazon.com (10.43.164.110) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 5 Jan 2020 11:49:52 +0000
Received: from EX13D06EUC004.ant.amazon.com ([10.43.164.101]) by
 EX13D06EUC004.ant.amazon.com ([10.43.164.101]) with mapi id 15.00.1367.000;
 Sun, 5 Jan 2020 11:49:52 +0000
From:   "Bshara, Saeed" <saeedb@amazon.com>
To:     "liran.alon@oracle.com" <liran.alon@oracle.com>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "haakon.bugge@oracle.com" <haakon.bugge@oracle.com>,
        "Pressman, Gal" <galpress@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>
Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Topic: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Index: AQHVwZiv3JZfW3mmvU2NpEO5RPqyX6fZSREAgACqDICAAdxeZ4AAEWSAgAAYaAA=
Date:   Sun, 5 Jan 2020 11:49:51 +0000
Message-ID: <1539a496db269f92764f9296778f89afecfff634.camel@amazon.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
         <20200102180830.66676-3-liran.alon@oracle.com>
         <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>
         <2BB3E76D-CAF7-4539-A8E3-540CDB253742@amazon.com>
         <1578218014463.62861@amazon.com>
         <C2CB0420-79C8-4282-AE14-F575407B7C22@oracle.com>
In-Reply-To: <C2CB0420-79C8-4282-AE14-F575407B7C22@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.142]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9B3DF64E5554E4AA88589527172B391@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAxLTA1IGF0IDEyOjIyICswMjAwLCBMaXJhbiBBbG9uIHdyb3RlOg0KPiBI
aSBTYWVlZCwNCj4gDQo+IElmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHksIHRoZSBkZXZpY2UgaXMg
b25seSBhd2FyZSBvZiBuZXcNCj4gZGVzY3JpcHRvcnMgb25jZSB0aGUgdGFpbCBpcyB1cGRhdGVk
IGJ5IGVuYV9jb21fd3JpdGVfc3FfZG9vcmJlbGwoKQ0KPiB1c2luZyB3cml0ZWwoKS4NCj4gSWYg
dGhhdOKAmXMgdGhlIGNhc2UsIHRoZW4gd3JpdGVsKCkgZ3VhcmFudGVlcyBhbGwgcHJldmlvdXMg
d3JpdGVzIHRvDQo+IFdCL1VDIG1lbW9yeSBpcyB2aXNpYmxlIHRvIGRldmljZSBiZWZvcmUgdGhl
IHdyaXRlIGRvbmUgYnkgd3JpdGVsKCkuDQpkZXZpY2UgZmV0Y2hlcyBwYWNrZXQgb25seSBhZnRl
ciBkb29yYmVsbCBub3RpZmljYXRpb24uDQp5b3UgYXJlIHJpZ2h0LCB3cml0ZWwoKSBpbmNsdWRl
cyB0aGUgbmVlZGVkIGJhcnJpZXIgKA0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgv
djUuNC44L3NvdXJjZS9Eb2N1bWVudGF0aW9uL21lbW9yeS1iYXJyaWVycy50eHQjTDE5MjkNCikN
CnNvIGluZGVlZCB3ZSBzaG91bGQgYmUgb2sgd2l0aG91dCBhbnkgZXhwbGljaXQgd21iKCkgb3Ig
ZG1hX3dtYigpLg0KDQo+IA0KPiBJZiBkZXZpY2UgaXMgYWxsb3dlZCB0byBmZXRjaCBwYWNrZXQg
cGF5bG9hZCBhdCB0aGUgbW9tZW50IHRoZQ0KPiB0cmFuc21pdCBkZXNjcmlwdG9yIGlzIHdyaXR0
ZW4gaW50byBkZXZpY2UtbWVtb3J5IHVzaW5nIExMUSwNCj4gdGhlbiBlbmFfY29tX3dyaXRlX2Jv
dW5jZV9idWZmZXJfdG9fZGV2KCkgc2hvdWxkIGRtYV93bWIoKSBiZWZvcmUNCj4gX19pb3dyaXRl
NjRfY29weSgpLiBJbnN0ZWFkIG9mIHdtYigpLiBBbmQgY29tbWVudA0KPiBpcyB3cm9uZyBhbmQg
c2hvdWxkIGJlIHVwZGF0ZWQgYWNjb3JkaW5nbHkuDQo+IEZvciBleGFtcGxlLCB0aGlzIHdpbGwg
b3B0aW1pc2UgeDg2IHRvIG9ubHkgaGF2ZSBhIGNvbXBpbGVyLWJhcnJpZXINCj4gaW5zdGVhZCBv
ZiBleGVjdXRpbmcgYSBTRkVOQ0UuDQo+IA0KPiBDYW4geW91IGNsYXJpZnkgd2hhdCBpcyBkZXZp
Y2UgYmVoYXZpb3VyIG9uIHdoZW4gaXQgaXMgYWxsb3dlZCB0bw0KPiByZWFkIHRoZSBwYWNrZXQg
cGF5bG9hZD8NCj4gaS5lLiBJcyBpdCBvbmx5IGFmdGVyIHdyaXRpbmcgdG8gZG9vcmJlbGwgb3Ig
aXMgaXQgZnJvbSB0aGUgbW9tZW50DQo+IHRoZSB0cmFuc21pdCBkZXNjcmlwdG9yIGlzIHdyaXR0
ZW4gdG8gTExRPw0KPiANCj4gLUxpcmFuDQo+IA0K
