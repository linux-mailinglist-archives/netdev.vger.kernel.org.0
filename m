Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC91C21BE77
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGJUcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:32:03 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:49671 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJUcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594413122; x=1625949122;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=i1pUaERWgOFWEtdtLChCqNzuzrq4NHWIfzgKGnKVzZ8=;
  b=gjGR3cMIXQR5G8KfPlBXnskObhUIcfqXI3pSIuPcUGxOuXHuXdFa8wM9
   AtESCWNdsdnd7Zs6UkqG2zxC7cK7L2DRCkI1xHHWGIoGPFGdufkWuwYKC
   6/Y7PrdcM6DVBClLJH3XB5Vu+awIMyo/it9mos4deeuxzKzVti0Xp6KW5
   c=;
IronPort-SDR: PHBOVm0KzPOE47EdsiTKQSeFkNxnfT7qGLDm/zS2++dEBl+v6cDL2e9zPz+J102w5dtkt0014H
 QFnW/2RsVCkw==
X-IronPort-AV: E=Sophos;i="5.75,336,1589241600"; 
   d="scan'208";a="41223846"
Subject: Re: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Thread-Topic: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash key and
 function changes
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jul 2020 20:32:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 9FC1CA1787;
        Fri, 10 Jul 2020 20:32:00 +0000 (UTC)
Received: from EX13D11EUB004.ant.amazon.com (10.43.166.188) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 20:32:00 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D11EUB004.ant.amazon.com (10.43.166.188) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 20:31:59 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Fri, 10 Jul 2020 20:31:58 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Thread-Index: AQHWViPyxgncFwies0e5jhwpAWeGRqj/sUCAgAEUwoCAAHiNgP//kiCA
Date:   Fri, 10 Jul 2020 20:31:58 +0000
Message-ID: <C1F3BC8C-AFAD-4AB4-8329-A48F4AD0E60B@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
 <1594321503-12256-7-git-send-email-akiyano@amazon.com>
 <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <53596F13-16F7-4C82-A5BC-5F5DB22C36A4@amazon.com>
 <20200710130513.057a2854@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200710130513.057a2854@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C85C6E8E00CCAE42B6268B47F445EC9E@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDcvMTAvMjAsIDE6MDUgUE0sICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVs
Lm9yZz4gd3JvdGU6DQoNCiAgICBPbiBGcmksIDEwIEp1bCAyMDIwIDE5OjUzOjQ2ICswMDAwIE1h
Y2h1bHNreSwgWm9yaWsgd3JvdGU6DQogICAgPiBPbiA3LzkvMjAsIDE6MjQgUE0sICJKYWt1YiBL
aWNpbnNraSIgPGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6DQogICAgPg0KICAgID4gICAgIE9uIFRo
dSwgOSBKdWwgMjAyMCAyMjowNTowMSArMDMwMCBha2l5YW5vQGFtYXpvbi5jb20gd3JvdGU6DQog
ICAgPiAgICAgPiBGcm9tOiBBcnRodXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0K
ICAgID4gICAgID4NCiAgICA+ICAgICA+IEFkZCB0aGUgcnNzX2NvbmZpZ3VyYWJsZV9mdW5jdGlv
bl9rZXkgYml0IHRvIGRyaXZlcl9zdXBwb3J0ZWRfZmVhdHVyZS4NCiAgICA+ICAgICA+DQogICAg
PiAgICAgPiBUaGlzIGJpdCB0ZWxscyB0aGUgZGV2aWNlIHRoYXQgdGhlIGRyaXZlciBpbiBxdWVz
dGlvbiBzdXBwb3J0cyB0aGUNCiAgICA+ICAgICA+IHJldHJpZXZpbmcgYW5kIHVwZGF0aW5nIG9m
IFJTUyBmdW5jdGlvbiBhbmQgaGFzaCBrZXksIGFuZCB0aGVyZWZvcmUNCiAgICA+ICAgICA+IHRo
ZSBkZXZpY2Ugc2hvdWxkIGFsbG93IFJTUyBmdW5jdGlvbiBhbmQga2V5IG1hbmlwdWxhdGlvbi4N
CiAgICA+ICAgICA+DQogICAgPiAgICAgPiBTaWduZWQtb2ZmLWJ5OiBBcnRodXIgS2l5YW5vdnNr
aSA8YWtpeWFub0BhbWF6b24uY29tPg0KICAgID4NCiAgICA+ICAgICBJcyB0aGlzIGEgZml4IG9m
IHRoZSBwcmV2aW91cyBwYXRjaGVzPyBsb29rcyBzdHJhbmdlIHRvIGp1c3Qgc3RhcnQNCiAgICA+
ICAgICBhZHZlcnRpc2luZyBhIGZlYXR1cmUgYml0IGJ1dCBub3QgYWRkIGFueSBjb2RlLi4NCiAg
ICA+DQogICAgPiBUaGUgcHJldmlvdXMgcmVsYXRlZCBjb21taXRzIHdlcmUgbWVyZ2VkIGFscmVh
ZHk6DQogICAgPiAwYWYzYzRlMmVhYjggbmV0OiBlbmE6IGNoYW5nZXMgdG8gUlNTIGhhc2gga2V5
IGFsbG9jYXRpb24NCiAgICA+IGMxYmQxN2U1MWM3MSBuZXQ6IGVuYTogY2hhbmdlIGRlZmF1bHQg
UlNTIGhhc2ggZnVuY3Rpb24gdG8gVG9lcGxpdHoNCiAgICA+IGY2NmMyZWEzYjE4YSBuZXQ6IGVu
YTogYWxsb3cgc2V0dGluZyB0aGUgaGFzaCBmdW5jdGlvbiB3aXRob3V0IGNoYW5naW5nIHRoZSBr
ZXkNCiAgICA+IGU5YTFkZTM3OGRkNCBuZXQ6IGVuYTogZml4IGVycm9yIHJldHVybmluZyBpbiBl
bmFfY29tX2dldF9oYXNoX2Z1bmN0aW9uKCkNCiAgICA+IDgwZjg0NDNmY2RhYSBuZXQ6IGVuYTog
YXZvaWQgdW5uZWNlc3NhcnkgYWRtaW4gY29tbWFuZCB3aGVuIFJTUyBmdW5jdGlvbiBzZXQgZmFp
bHMNCiAgICA+IDZhNGY3ZGM4MmQxZSBuZXQ6IGVuYTogcnNzOiBkbyBub3QgYWxsb2NhdGUga2V5
IHdoZW4gbm90IHN1cHBvcnRlZA0KICAgID4gMGQxYzNkZTdiOGM3IG5ldDogZW5hOiBmaXggaW5j
b3JyZWN0IGRlZmF1bHQgUlNTIGtleQ0KDQogICAgVGhlc2UgY29tbWl0cyBhcmUgaW4gbmV0Lg0K
DQogICAgPiBUaGlzIGNvbW1pdCB3YXMgbm90IGluY2x1ZGVkIGJ5IG1pc3Rha2UsIHNvIHdlIGFy
ZSBhZGRpbmcgaXQgbm93Lg0KDQogICAgWW91J3JlIGFkZGluZyBpdCB0byBuZXQtbmV4dC4NClRo
aXMgY29tbWl0IGFjdHVhbGx5IGVuYWJsZXMgYSBmZWF0dXJlIGFmdGVyIGl0IHdhcyBmaXhlZCBi
eSBwcmV2aW91cyBjb21taXRzLCB0aGVyZWZvcmUgd2UgdGhvdWdodA0KdGhhdCBuZXQtbmV4dCBj
b3VsZCBiZSBhIHJpZ2h0IHBsYWNlLiBCdXQgaWYgeW91IHRoaW5rIGl0IHNob3VsZCBnbyB0byBu
ZXQsIHdlJ2xsIGdvIGFoZWFkIGFuZCByZXN1Ym1pdCANCml0IHRoZXJlLiBUaGFua3MgZm9yIHlv
dXIgY29tbWVudHMuIA0KDQo=
