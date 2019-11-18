Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6F100EF7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKRWu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:50:57 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:5556 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKRWu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574117456; x=1605653456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1TBCj8S5tiY8lhLSka2cC9BaFEo3dEfDS9nvfhst664=;
  b=lopWEQespzIk+QbFoxtJhCxVxGQB/xt4uu2nLMgqFu1PRw3Th1gtbdnr
   vOVB3veDyMZzJ2cBMlxPdsZy2kMrqXEYoBmrkdvJuwMeOCuJJOun56/S/
   sgPeZFZ3W7h7hLt026BkLHVva1VnEt9EtQqdESQGTehob6N/Z79dAb35N
   Y=;
IronPort-SDR: YAUFUtGwZEsOF+dtfms7gj40Vziv0l1dJXEl5COAlNTLstrcKNwPgTlwMht3hzAqr95hFrIO3D
 aLOwJwxxrk6Q==
X-IronPort-AV: E=Sophos;i="5.68,321,1569283200"; 
   d="scan'208";a="9098233"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 18 Nov 2019 22:50:53 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id E2983A1F75;
        Mon, 18 Nov 2019 22:50:51 +0000 (UTC)
Received: from EX13D04EUB003.ant.amazon.com (10.43.166.235) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 18 Nov 2019 22:50:51 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D04EUB003.ant.amazon.com (10.43.166.235) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 18 Nov 2019 22:50:50 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Mon, 18 Nov 2019 22:50:50 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     David Miller <davem@davemloft.net>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
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
        "Agroskin, Shay" <shayagr@amazon.com>
Subject: Re: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Topic: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Index: AQHVkwdBRTuKvi3GFE+1IFjb+Yuigad7Y1QAgAMjDQCAComjgIAIajMA//+e3QA=
Date:   Mon, 18 Nov 2019 22:50:50 +0000
Message-ID: <A4B5B150-86CB-4B92-B3CA-868FE20507EC@amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
 <1572868728-5211-3-git-send-email-akiyano@amazon.com>
 <20191104.111852.941272299166797826.davem@davemloft.net>
 <081dc70c42bb4c638f8d2fcb669941cd@EX13D22EUA004.ant.amazon.com>
 <2FDAF85D-51A1-4F69-9E76-E02E3D47A00C@amazon.com>
 <92294494768e4c41a0755218e51a0138@EX13D22EUA004.ant.amazon.com>
In-Reply-To: <92294494768e4c41a0755218e51a0138@EX13D22EUA004.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.193]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4FD11673BCE8540BE185E33333E9307@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgIA0KICAgICAgICAgPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KICAgICAgICA+IEZy
b206IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCiAgICAgICAgPiBTZW50OiBN
b25kYXksIE5vdmVtYmVyIDQsIDIwMTkgOToxOSBQTQ0KICAgICAgICA+IFRvOiBLaXlhbm92c2tp
LCBBcnRodXIgPGFraXlhbm9AYW1hem9uLmNvbT4NCiAgICAgICAgPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgV29vZGhvdXNlLCBEYXZpZCA8ZHdtd0BhbWF6b24uY28udWs+Ow0KICAgICAg
ICA+IE1hY2h1bHNreSwgWm9yaWsgPHpvcmlrQGFtYXpvbi5jb20+OyBNYXR1c2hldnNreSwgQWxl
eGFuZGVyDQogICAgICAgID4gPG1hdHVhQGFtYXpvbi5jb20+OyBCc2hhcmEsIFNhZWVkIDxzYWVl
ZGJAYW1hem9uLmNvbT47IFdpbHNvbiwNCiAgICAgICAgPiBNYXR0IDxtc3dAYW1hem9uLmNvbT47
IExpZ3VvcmksIEFudGhvbnkgPGFsaWd1b3JpQGFtYXpvbi5jb20+Ow0KICAgICAgICA+IEJzaGFy
YSwgTmFmZWEgPG5hZmVhQGFtYXpvbi5jb20+OyBUemFsaWssIEd1eSA8Z3R6YWxpa0BhbWF6b24u
Y29tPjsNCiAgICAgICAgPiBCZWxnYXphbCwgTmV0YW5lbCA8bmV0YW5lbEBhbWF6b24uY29tPjsg
U2FpZGksIEFsaQ0KICAgICAgICA+IDxhbGlzYWlkaUBhbWF6b24uY29tPjsgSGVycmVuc2NobWlk
dCwgQmVuamFtaW4gPGJlbmhAYW1hem9uLmNvbT47DQogICAgICAgID4gRGFnYW4sIE5vYW0gPG5k
YWdhbkBhbWF6b24uY29tPjsgQWdyb3NraW4sIFNoYXkNCiAgICAgICAgPiA8c2hheWFnckBhbWF6
b24uY29tPg0KICAgICAgICA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjEgbmV0IDIvMl0gbmV0OiBl
bmE6IGZpeCB0b28gbG9uZyBkZWZhdWx0IHR4IGludGVycnVwdA0KICAgICAgICA+IG1vZGVyYXRp
b24gaW50ZXJ2YWwNCiAgICAgICAgPiANCiAgICAgICAgPiBGcm9tOiA8YWtpeWFub0BhbWF6b24u
Y29tPg0KICAgICAgICA+IERhdGU6IE1vbiwgNCBOb3YgMjAxOSAxMzo1ODo0OCArMDIwMA0KICAg
ICAgICA+IA0KICAgICAgICA+ID4gRnJvbTogQXJ0aHVyIEtpeWFub3Zza2kgPGFraXlhbm9AYW1h
em9uLmNvbT4NCiAgICAgICAgPiA+DQogICAgICAgID4gPiBDdXJyZW50IGRlZmF1bHQgbm9uLWFk
YXB0aXZlIHR4IGludGVycnVwdCBtb2RlcmF0aW9uIGludGVydmFsIGlzIDE5NiB1cy4NCiAgICAg
ICAgPiA+IFRoaXMgY29tbWl0IHNldHMgaXQgdG8gMCwgd2hpY2ggaXMgbXVjaCBtb3JlIHNlbnNp
YmxlIGFzIGEgZGVmYXVsdCB2YWx1ZS4NCiAgICAgICAgPiA+IEl0IGNhbiBiZSBtb2RpZmllZCB1
c2luZyBldGh0b29sIC1DLg0KICAgICAgICA+ID4NCiAgICAgICAgPiA+IFNpZ25lZC1vZmYtYnk6
IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgICAgID4gDQogICAg
ICAgID4gSSBkbyBub3QgYWdyZWUgdGhhdCB0dXJuaW5nIFRYIGludGVycnVwdCBtb2RlcmF0aW9u
IG9mZiBjb21wbGV0ZWx5IGlzIGEgbW9yZQ0KICAgICAgICA+IHNlbnNpYmxlIGRlZmF1bHQgdmFs
dWUuDQogICAgICAgID4gDQogICAgICAgID4gTWF5YmUgYSBtdWNoIHNtYWxsZXIgdmFsdWUsIGJ1
dCB0dXJuaW5nIG9mZiB0aGUgY29hbGVzY2luZyBkZWxheSBjb21wbGV0ZWx5DQogICAgICAgID4g
aXMgYSBiaXQgbXVjaC4NCiAgICAgICAgDQogICAgICAgIERhdmlkLA0KICAgICAgICBVcCB1bnRp
bCBub3csIHRoZSBFTkEgZGV2aWNlIGRpZCBub3Qgc3VwcG9ydCBpbnRlcnJ1cHQgbW9kZXJhdGlv
biwgc28gZWZmZWN0aXZlbHkgdGhlIGRlZmF1bHQgdHggaW50ZXJydXB0IG1vZGVyYXRpb24gaW50
ZXJ2YWwgd2FzIDAuDQogICAgICAgIFlvdSBhcmUgcHJvYmFibHkgcmlnaHQgdGhhdCAwIGlzIG5v
dCBhbiBvcHRpbWFsIHZhbHVlLg0KICAgICAgICBIb3dldmVyIHVudGlsIHdlIHJlc2VhcmNoIGFu
ZCBmaW5kIHN1Y2ggYW4gb3B0aW1hbCB2YWx1ZSwgaW4gb3JkZXIgdG8gYXZvaWQgYSBkZWdyYWRh
dGlvbiBpbiBkZWZhdWx0IHBlcmZvcm1hbmNlLCB3ZSB3YW50IHRoZSBkZWZhdWx0IHZhbHVlIGlu
IHRoZSBuZXcgZHJpdmVyIHRvIGJlIChlZmZlY3RpdmVseSkgdGhlIHNhbWUgYXMgaW4gdGhlIG9s
ZCBkcml2ZXIuDQogICAgICAgIA0KICAgICBEYXZpZCwNCiAgICBKdXN0IHdhbnRlZCB0byByZS1p
dGVyYXRlIHdoYXQgQXJ0aHVyIGhhcyBtZW50aW9uZWQuIFdlIGNsZWFybHkgc2VlIEJXIGFuZCBD
UFUgdXRpbGl6YXRpb24gaW1wcm92ZW1lbnQgd2l0aCBpbnRyb2R1Y3Rpb24gb2YgRElNIG9uIHRo
ZSBSeCBzaWRlIGFuZCBub24tYWRhcHRpdmUgbW9kZXJhdGlvbiBvbiB0aGUgVHggc2lkZSBpbiBv
dXIgZHJpdmVyLiANCiAgICBXZSdkIGxpa2UgdG8gZGVsaXZlciB0aGlzIHRvIG91ciBjdXN0b21l
cnMgQVNBUC4gV2UgYXJlIHVzdWFsbHkgdmVyeSBjYXV0aW91cyB3aXRoIGludHJvZHVjdGlvbiBv
ZiB0aGUgbmV3IGZlYXR1cmVzLCB0aGVyZWZvcmUgd2UnZCBsaWtlIHRvIGtlZXAgaW50ZXJydXB0
IG1vZGVyYXRpb24gZGlzYWJsZWQgYnkgZGVmYXVsdCBmb3Igbm93LiBXZSdkIGFkdmlzZSBvdXIg
Y3VzdG9tZXJzIGF3YWl0aW5nIGZvciBpdCB0byBlbmFibGUgaXQgdXNpbmcgZXRodG9vbC4gDQog
ICAgV2UgYXJlIGdvaW5nIHRvIGVuYWJsZSBtb2RlcmF0aW9uIGJ5IGRlZmF1bHQgYWZ0ZXIgd2Ug
YWNjdW11bGF0ZSBtb3JlIG1pbGVhZ2Ugd2l0aCBpdCBhbmQgZmluZSB0dW5lIGl0IGZ1cnRoZXIu
IFRoYXQncyB0aGUgcmVhc29uIGJlaGluZCBoYXZpbmcgVHggaW50ZXJ2YWwgPTAgZm9yIG5vdyAo
UnggbW9kZXJhdGlvbiBpcyBkaXNhYmxlZCBieSBkZWZhdWx0IGFzIHdlbGwpLiBIb3BlIGl0IG1h
a2VzIHNlbnNlLiAgICANCg0KRGF2aWQsDQpJJ20gYnVtcGluZyB0aGlzIHVwIHRvIGJyaW5nIGl0
IHRvIHlvdXIgYXR0ZW50aW9uLg0KVGhhbmtzLiAgICAgIAkgICAgICAgDQogICAgDQogICAgDQoN
Cg==
