Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6517AFD5
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCEUiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:38:00 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:60059 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgCEUiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583440679; x=1614976679;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=oxYd6ah9OjaIQ7LD4IQisvG6s8lIKLCWNzBgVZxMRzY=;
  b=rp8zaA0VxC6eClYT0pF2Q0gn4uSws0eGHUNA9TgZvW1FaumECyyW4j0Q
   ZtVGuMELkaLJd9YR+asXzq1cFk/2lO0OzIfLGJDNSbLisZQtSPumSOGIn
   +9tSf2OJ/7Mgu+EsAS0nIYJBCmXIEYO0aRRVBLGQHianfUD9uYFsHStBU
   8=;
IronPort-SDR: IrJA6gzkA2NMffrK/X+I+iTgyo+tEmOL9izuSts3o50fkMQxoNHOaEUVEtycvSWNbY1pY0ZPb9
 5i15LllLXzWQ==
X-IronPort-AV: E=Sophos;i="5.70,519,1574121600"; 
   d="scan'208";a="19805340"
Thread-Topic: [RESEND PATCH V1 net-next] net: ena: fix broken interface between ENA driver
 and FW
Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface between ENA
 driver and FW
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Mar 2020 20:37:46 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 0A4A0A1E80;
        Thu,  5 Mar 2020 20:37:44 +0000 (UTC)
Received: from EX13D28EUB004.ant.amazon.com (10.43.166.176) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 5 Mar 2020 20:37:44 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D28EUB004.ant.amazon.com (10.43.166.176) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 5 Mar 2020 20:37:43 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1497.006;
 Thu, 5 Mar 2020 20:37:43 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
CC:     David Miller <davem@davemloft.net>,
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
Thread-Index: AQHV7IwHTleIAn29A0CjjPWG/SVzNqgueR+AgAVOa4CABlQQgIAAUHeA//+QkAA=
Date:   Thu, 5 Mar 2020 20:37:43 +0000
Message-ID: <F07A24C7-930D-4F59-92BD-405B74F01707@amazon.com>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
 <20200226.204809.102099518712120120.davem@davemloft.net>
 <20200301135007.GS12414@unreal>
 <37c7130a38ab46cda8a0f7a3e07e7fa3@EX13D22EUA004.ant.amazon.com>
 <20200305191633.GI184088@unreal>
In-Reply-To: <20200305191633.GI184088@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.206]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6136A51C3FBC2648ADD621D1EBE50E77@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDMvNS8yMCwgMTE6MTcgQU0sICJMZW9uIFJvbWFub3Zza3kiIDxsZW9uQGtlcm5l
bC5vcmc+IHdyb3RlOg0KDQogICAgDQogICAgT24gVGh1LCBNYXIgMDUsIDIwMjAgYXQgMDI6Mjg6
MzNQTSArMDAwMCwgS2l5YW5vdnNraSwgQXJ0aHVyIHdyb3RlOg0KICAgID4gPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KICAgID4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2Vy
bmVsLm9yZz4NCiAgICA+ID4gU2VudDogU3VuZGF5LCBNYXJjaCAxLCAyMDIwIDM6NTAgUE0NCiAg
ICA+ID4gVG86IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCiAgICA+ID4gQ2M6
IEtpeWFub3Zza2ksIEFydGh1ciA8YWtpeWFub0BhbWF6b24uY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsNCiAgICA+ID4gV29vZGhvdXNlLCBEYXZpZCA8ZHdtd0BhbWF6b24uY28udWs+OyBN
YWNodWxza3ksIFpvcmlrDQogICAgPiA+IDx6b3Jpa0BhbWF6b24uY29tPjsgTWF0dXNoZXZza3ks
IEFsZXhhbmRlciA8bWF0dWFAYW1hem9uLmNvbT47DQogICAgPiA+IEJzaGFyYSwgU2FlZWQgPHNh
ZWVkYkBhbWF6b24uY29tPjsgV2lsc29uLCBNYXR0IDxtc3dAYW1hem9uLmNvbT47DQogICAgPiA+
IExpZ3VvcmksIEFudGhvbnkgPGFsaWd1b3JpQGFtYXpvbi5jb20+OyBCc2hhcmEsIE5hZmVhDQog
ICAgPiA+IDxuYWZlYUBhbWF6b24uY29tPjsgVHphbGlrLCBHdXkgPGd0emFsaWtAYW1hem9uLmNv
bT47IEJlbGdhemFsLCBOZXRhbmVsDQogICAgPiA+IDxuZXRhbmVsQGFtYXpvbi5jb20+OyBTYWlk
aSwgQWxpIDxhbGlzYWlkaUBhbWF6b24uY29tPjsgSGVycmVuc2NobWlkdCwNCiAgICA+ID4gQmVu
amFtaW4gPGJlbmhAYW1hem9uLmNvbT47IERhZ2FuLCBOb2FtIDxuZGFnYW5AYW1hem9uLmNvbT47
DQogICAgPiA+IEFncm9za2luLCBTaGF5IDxzaGF5YWdyQGFtYXpvbi5jb20+OyBKdWJyYW4sIFNh
bWloDQogICAgPiA+IDxzYW1lZWhqQGFtYXpvbi5jb20+DQogICAgPiA+IFN1YmplY3Q6IFJlOiBb
UkVTRU5EIFBBVENIIFYxIG5ldC1uZXh0XSBuZXQ6IGVuYTogZml4IGJyb2tlbiBpbnRlcmZhY2Ug
YmV0d2Vlbg0KICAgID4gPiBFTkEgZHJpdmVyIGFuZCBGVw0KICAgID4gPg0KICAgID4gPiBPbiBX
ZWQsIEZlYiAyNiwgMjAyMCBhdCAwODo0ODowOVBNIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6
DQogICAgPiA+ID4gRnJvbTogPGFraXlhbm9AYW1hem9uLmNvbT4NCiAgICA+ID4gPiBEYXRlOiBX
ZWQsIDI2IEZlYiAyMDIwIDEyOjAzOjM1ICswMjAwDQogICAgPiA+ID4NCiAgICA+ID4gPiA+IEZy
b206IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgPiA+ID4gPg0K
ICAgID4gPiA+ID4gSW4gdGhpcyBjb21taXQgd2UgcmV2ZXJ0IHRoZSBwYXJ0IG9mIGNvbW1pdCAx
YTYzNDQzYWZkNzANCiAgICA+ID4gPiA+ICgibmV0L2FtYXpvbjogRW5zdXJlIHRoYXQgZHJpdmVy
IHZlcnNpb24gaXMgYWxpZ25lZCB0byB0aGUgbGludXgNCiAgICA+ID4gPiA+IGtlcm5lbCIpLCB3
aGljaCBicmVha3MgdGhlIGludGVyZmFjZSBiZXR3ZWVuIHRoZSBFTkEgZHJpdmVyIGFuZCBGVy4N
CiAgICA+ID4gPiA+DQogICAgPiA+ID4gPiBXZSBhbHNvIHJlcGxhY2UgdGhlIHVzZSBvZiBEUklW
RVJfVkVSU0lPTiB3aXRoIERSSVZFUl9HRU5FUkFUSU9ODQogICAgPiA+ID4gPiB3aGVuIHdlIGJy
aW5nIGJhY2sgdGhlIGRlbGV0ZWQgY29uc3RhbnRzIHRoYXQgYXJlIHVzZWQgaW4gaW50ZXJmYWNl
DQogICAgPiA+ID4gPiB3aXRoIEVOQSBkZXZpY2UgRlcuDQogICAgPiA+ID4gPg0KICAgID4gPiA+
ID4gVGhpcyBjb21taXQgZG9lcyBub3QgY2hhbmdlIHRoZSBkcml2ZXIgdmVyc2lvbiByZXBvcnRl
ZCB0byB0aGUgdXNlcg0KICAgID4gPiA+ID4gdmlhIGV0aHRvb2wsIHdoaWNoIHJlbWFpbnMgdGhl
IGtlcm5lbCB2ZXJzaW9uLg0KICAgID4gPiA+ID4NCiAgICA+ID4gPiA+IEZpeGVzOiAxYTYzNDQz
YWZkNzAgKCJuZXQvYW1hem9uOiBFbnN1cmUgdGhhdCBkcml2ZXIgdmVyc2lvbiBpcw0KICAgID4g
PiA+ID4gYWxpZ25lZCB0byB0aGUgbGludXgga2VybmVsIikNCiAgICA+ID4gPiA+IFNpZ25lZC1v
ZmYtYnk6IEFydGh1ciBLaXlhbm92c2tpIDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgPiA+ID4N
CiAgICA+ID4gPiBBcHBsaWVkLg0KICAgID4gPg0KICAgID4gPiBEYXZlLA0KICAgID4gPg0KICAg
ID4gPiBJIHNlZSB0aGF0IEknbSBsYXRlIGhlcmUgYW5kIG15IGVtYWlsIHNvdW5kcyBsaWtlIG9s
ZCBtYW4gZ3J1bWJsaW5nLCBidXQgSSBhc2tlZA0KICAgID4gPiBmcm9tIHRob3NlIGd1eXMgdG8g
dXBkYXRlIHRoZWlyIGNvbW1pdCB3aXRoIHJlcXVlc3QgdG8gcHV0IHRoZSBmb2xsb3dpbmcgbGlu
ZToNCiAgICA+ID4gIi8qIERPIE5PVCBDSEFOR0UgRFJWX01PRFVMRV9HRU5fKiB2YWx1ZXMgaW4g
aW4tdHJlZSBjb2RlICovIg0KICAgID4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYv
MjAyMDAyMjQxNjI2NDkuR0E0NTI2QHVucmVhbC8NCiAgICA+ID4NCiAgICA+ID4gSSBhbHNvIGFz
a2VkIGhvdyB0aG9zZSB2ZXJzaW9ucyBhcmUgdHJhbnNmZXJyZWQgdG8gRlcgYW5kIHVzZWQgdGhl
cmUsIGJ1dCB3YXMNCiAgICA+ID4gaWdub3JlZC4NCiAgICA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbmV0ZGV2LzIwMjAwMjI0MDk0MTE2LkdENDIyNzA0QHVucmVhbC8NCiAgICA+ID4NCiAg
ICA+ID4gQlRXLCBJdCBpcyBhbHNvIHVuY2xlYXIgd2h5IEkgd2Fzbid0IENDZWQgaW4gdGhpcyBw
YXRjaC4NCiAgICA+ID4NCiAgICA+ID4gVGhhbmtzDQogICAgPg0KICAgID4gTGVvbiwNCiAgICA+
ICBTb3JyeSBmb3Igbm90IHJlc3BvbmRpbmcgZWFybGllciB0byB5b3VyIGlucXVpcmllcywgdGhl
eSBhcmUgZXhhY3RseSB0b3VjaGluZyB0aGUNCiAgICA+ICBwb2ludHMgdGhhdCB3ZSB3b3VsZCBs
aWtlIHRvIGRpc2N1c3MuDQogICAgPiAgVXAgdW50aWwgbm93LCB3ZSBpbiBBV1MsIGhhdmUgYmVl
biBtb25pdG9yaW5nIHRoZSBkcml2ZXJzIGluIHRoZSBkYXRhY2VudGVyIHVzaW5nIHRoZQ0KICAg
ID4gIGRyaXZlciB2ZXJzaW9uLCBhbmQgYWN0aXZlbHkgc3VnZ2VzdGluZyBkcml2ZXIgdXBkYXRl
cyB0byBvdXIgY3VzdG9tZXJzDQogICAgPiAgd2hlbmV2ZXIgYSBjcml0aWNhbCBidWcgd2FzIGZp
eGVkLCBvciBhIG5ldyBpbXBvcnRhbnQgZmVhdHVyZSB3YXMgYWRkZWQuDQogICAgPiAgUmVtb3Zp
bmcgdGhlIGRyaXZlciB2ZXJzaW9uIGFuZCBub3QgYWxsb3dpbmcgdG8gbWFpbnRhaW4gb3VyIG93
biBpbnRlcm5hbA0KICAgID4gIHZlcnNpb24gbmVnYXRpdmVseSBpbXBhY3RzIG91ciBlZmZvcnQg
dG8gZ2l2ZSBvdXIgY3VzdG9tZXJzIHRoZSBiZXN0IHBvc3NpYmxlIGNsb3VkDQogICAgPiAgZXhw
ZXJpZW5jZS4gV2UgdGhlcmVmb3JlIHByZWZlciB0byBtYWludGFpbiB1c2luZyBvdXIgaW50ZXJu
YWwgZHJpdmVyIHZlcnNpb24uDQogICAgPg0KICAgID4gIEFyZSB0aGVyZSBhbnkgb3RoZXIgcmVj
b21tZW5kZWQgd2F5cyB0byBhY2hpZXZlIG91ciBnb2FsIHdpdGhvdXQgYSBkcml2ZXINCiAgICA+
ICB2ZXJzaW9uPw0KICAgIA0KICAgIE9mIGNvdXJzZSwgZHJpdmVycyBhcmUgc3VwcG9zZWQgdG8g
YmVoYXZlIGxpa2UgYW55IG90aGVyIHVzZXIgdmlzaWJsZSBBUEkuDQogICAgVGhleSBuZWVkIHRv
IGVuc3VyZSBiYWNrd2FyZCBjb21wYXRpYmlsaXR5LCBzbyBuZXcgY29kZSB3aWxsIHdvcmsgd2l0
aA0KICAgIG9sZCBIVy9GVy4gVGhpcyBpcyBub3JtYWxseSBkb25lIGJ5IGNhcGFiaWxpdHkgbWFz
a3MsIHNlZSBob3cgaXQgaXMgZG9uZQ0KICAgIGluIE1lbGxhbm94IGRyaXZlcnMgYW5kIEkgdGhp
bmsgaW4gSW50ZWwgdG9vLg0KICAgIA0KICAgIFNvIHlvdXIgdXBkYXRlIHBvbGljeSBiYXNlZCBv
biBkcml2ZXIgdmVyc2lvbiBzdHJpbmcgaXMgbm9uc2Vuc2UgYW5kDQogICAgYnJva2VuIGJ5IGRl
c2lnbi4NCiAgICANCiAgICBPcmlnaW5hbCB0aHJlYWQgd2l0aCBMaW51cyBpcyBoZXJlIFsxXS4N
CiAgICANCiAgICBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3N1bW1pdC1kaXNjdXNzL0NB
KzU1YUZ4OUE9NWNjMFFaN0N5U0M0RjJLN2VZYUVmemtkWUVjOUphTmdDY1YyNT1yZ0BtYWlsLmdt
YWlsLmNvbS8NCiAgICANCiAgICBUaGFua3MgDQoNCldlIGRvIHN1cHBvcnQgZmVhdHVyZXMgY2Fw
YWJpbGl0eSBtYXNrIGFzIHdlbGwgYXMgdmVyc2lvbmluZyBwZXIgZmVhdHVyZS4gDQpIb3dldmVy
LCB3aGVuZXZlciB0aGVyZSBhcmUga25vd24gaXNzdWVzIGluIGEgY2VydGFpbiB2ZXJzaW9uIG9m
IHRoZSAgZHJpdmVyDQp0aGF0IGNhbiBiZSB3b3JrZWQgYXJvdW5kIGJ5IHRoZSBkZXZpY2UsIHdl
IG5lZWQgdGhlIGRldmljZSB0byBiZSBhd2FyZSBvZiB0aGUgDQpkcml2ZXIgdmVyc2lvbi4gQW5v
dGhlciBwdXJwb3NlIGlzIG9wZXJhdGlvbmFsIC0ga25vd2luZyBkcml2ZXIgdmVyc2lvbiBoZWxw
cyB1cyANCnJlcHJvZHVjZSBjdXN0b21lciBpc3N1ZXMgYW5kIGRlYnVnIHRoZW0sIGFzIHdlbGwg
YXMgc3VnZ2VzdCBvdXIgY3VzdG9tZXJzDQp0byB1cGdyYWRlIHRoZWlyIGRyaXZlcnMsIGFzIEFy
dGh1ciBtZW50aW9uZWQgYWJvdmUuDQpUaGFua3MNCg0KICAgIA0KICAgID4NCiAgICA+ICBUaGFu
a3MhDQogICAgPg0KICAgIA0KDQo=
