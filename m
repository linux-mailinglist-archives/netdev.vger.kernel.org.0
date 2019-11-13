Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80718FB967
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfKMUIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:08:25 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:20030 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMUIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1573675704; x=1605211704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OYQyGMFDVcR5Xri3NWTCypUVBQ1f9tgChcWtihAIlHU=;
  b=MWZDOD1bC4GlP6m7yRRdhzRp7jQe0xk/2S4Z1JiO88U5NYWw86SHqgQv
   LFt60pUNtkxkUmrhSgeMzCP9gZ73nAdphI36sU+7/VjQ8sGGlngX7LYR9
   ofpWpfuhLNy3dzLbLC0MJ/1CNyr1n8FdTXN65Rh6Bu2dpGhRYnf+iOBB3
   g=;
IronPort-SDR: 6C7nQzZ8XRAfW8RlHpMQ8eGLhs6wMPiqkjgTsHOJ197MJ0GoPg8/zH4EocZawYf/IIADe0CFBG
 NC3WWEcDwoQQ==
X-IronPort-AV: E=Sophos;i="5.68,301,1569283200"; 
   d="scan'208";a="7036621"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Nov 2019 20:08:22 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 031DCA20C7;
        Wed, 13 Nov 2019 20:08:21 +0000 (UTC)
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 13 Nov 2019 20:08:21 +0000
Received: from EX13D10EUB001.ant.amazon.com (10.43.166.211) by
 EX13D04EUB004.ant.amazon.com (10.43.166.59) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 13 Nov 2019 20:08:20 +0000
Received: from EX13D10EUB001.ant.amazon.com ([10.43.166.211]) by
 EX13D10EUB001.ant.amazon.com ([10.43.166.211]) with mapi id 15.00.1367.000;
 Wed, 13 Nov 2019 20:08:20 +0000
From:   "Machulsky, Zorik" <zorik@amazon.com>
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: Re: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Topic: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Index: AQHVkwdBRTuKvi3GFE+1IFjb+Yuigad7Y1QAgAMjDQCAComjgA==
Date:   Wed, 13 Nov 2019 20:08:20 +0000
Message-ID: <2FDAF85D-51A1-4F69-9E76-E02E3D47A00C@amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
 <1572868728-5211-3-git-send-email-akiyano@amazon.com>
 <20191104.111852.941272299166797826.davem@davemloft.net>
 <081dc70c42bb4c638f8d2fcb669941cd@EX13D22EUA004.ant.amazon.com>
In-Reply-To: <081dc70c42bb4c638f8d2fcb669941cd@EX13D22EUA004.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.193]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CD7F0266477584DB2556BB865578CAA@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCiAgICAgPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KICAgID4gRnJvbTogRGF2aWQg
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KICAgID4gU2VudDogTW9uZGF5LCBOb3ZlbWJl
ciA0LCAyMDE5IDk6MTkgUE0NCiAgICA+IFRvOiBLaXlhbm92c2tpLCBBcnRodXIgPGFraXlhbm9A
YW1hem9uLmNvbT4NCiAgICA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBXb29kaG91c2Us
IERhdmlkIDxkd213QGFtYXpvbi5jby51az47DQogICAgPiBNYWNodWxza3ksIFpvcmlrIDx6b3Jp
a0BhbWF6b24uY29tPjsgTWF0dXNoZXZza3ksIEFsZXhhbmRlcg0KICAgID4gPG1hdHVhQGFtYXpv
bi5jb20+OyBCc2hhcmEsIFNhZWVkIDxzYWVlZGJAYW1hem9uLmNvbT47IFdpbHNvbiwNCiAgICA+
IE1hdHQgPG1zd0BhbWF6b24uY29tPjsgTGlndW9yaSwgQW50aG9ueSA8YWxpZ3VvcmlAYW1hem9u
LmNvbT47DQogICAgPiBCc2hhcmEsIE5hZmVhIDxuYWZlYUBhbWF6b24uY29tPjsgVHphbGlrLCBH
dXkgPGd0emFsaWtAYW1hem9uLmNvbT47DQogICAgPiBCZWxnYXphbCwgTmV0YW5lbCA8bmV0YW5l
bEBhbWF6b24uY29tPjsgU2FpZGksIEFsaQ0KICAgID4gPGFsaXNhaWRpQGFtYXpvbi5jb20+OyBI
ZXJyZW5zY2htaWR0LCBCZW5qYW1pbiA8YmVuaEBhbWF6b24uY29tPjsNCiAgICA+IERhZ2FuLCBO
b2FtIDxuZGFnYW5AYW1hem9uLmNvbT47IEFncm9za2luLCBTaGF5DQogICAgPiA8c2hheWFnckBh
bWF6b24uY29tPg0KICAgID4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQgMi8yXSBuZXQ6IGVu
YTogZml4IHRvbyBsb25nIGRlZmF1bHQgdHggaW50ZXJydXB0DQogICAgPiBtb2RlcmF0aW9uIGlu
dGVydmFsDQogICAgPiANCiAgICA+IEZyb206IDxha2l5YW5vQGFtYXpvbi5jb20+DQogICAgPiBE
YXRlOiBNb24sIDQgTm92IDIwMTkgMTM6NTg6NDggKzAyMDANCiAgICA+IA0KICAgID4gPiBGcm9t
OiBBcnRodXIgS2l5YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0KICAgID4gPg0KICAgID4g
PiBDdXJyZW50IGRlZmF1bHQgbm9uLWFkYXB0aXZlIHR4IGludGVycnVwdCBtb2RlcmF0aW9uIGlu
dGVydmFsIGlzIDE5NiB1cy4NCiAgICA+ID4gVGhpcyBjb21taXQgc2V0cyBpdCB0byAwLCB3aGlj
aCBpcyBtdWNoIG1vcmUgc2Vuc2libGUgYXMgYSBkZWZhdWx0IHZhbHVlLg0KICAgID4gPiBJdCBj
YW4gYmUgbW9kaWZpZWQgdXNpbmcgZXRodG9vbCAtQy4NCiAgICA+ID4NCiAgICA+ID4gU2lnbmVk
LW9mZi1ieTogQXJ0aHVyIEtpeWFub3Zza2kgPGFraXlhbm9AYW1hem9uLmNvbT4NCiAgICA+IA0K
ICAgID4gSSBkbyBub3QgYWdyZWUgdGhhdCB0dXJuaW5nIFRYIGludGVycnVwdCBtb2RlcmF0aW9u
IG9mZiBjb21wbGV0ZWx5IGlzIGEgbW9yZQ0KICAgID4gc2Vuc2libGUgZGVmYXVsdCB2YWx1ZS4N
CiAgICA+IA0KICAgID4gTWF5YmUgYSBtdWNoIHNtYWxsZXIgdmFsdWUsIGJ1dCB0dXJuaW5nIG9m
ZiB0aGUgY29hbGVzY2luZyBkZWxheSBjb21wbGV0ZWx5DQogICAgPiBpcyBhIGJpdCBtdWNoLg0K
ICAgIA0KICAgIERhdmlkLA0KICAgIFVwIHVudGlsIG5vdywgdGhlIEVOQSBkZXZpY2UgZGlkIG5v
dCBzdXBwb3J0IGludGVycnVwdCBtb2RlcmF0aW9uLCBzbyBlZmZlY3RpdmVseSB0aGUgZGVmYXVs
dCB0eCBpbnRlcnJ1cHQgbW9kZXJhdGlvbiBpbnRlcnZhbCB3YXMgMC4NCiAgICBZb3UgYXJlIHBy
b2JhYmx5IHJpZ2h0IHRoYXQgMCBpcyBub3QgYW4gb3B0aW1hbCB2YWx1ZS4NCiAgICBIb3dldmVy
IHVudGlsIHdlIHJlc2VhcmNoIGFuZCBmaW5kIHN1Y2ggYW4gb3B0aW1hbCB2YWx1ZSwgaW4gb3Jk
ZXIgdG8gYXZvaWQgYSBkZWdyYWRhdGlvbiBpbiBkZWZhdWx0IHBlcmZvcm1hbmNlLCB3ZSB3YW50
IHRoZSBkZWZhdWx0IHZhbHVlIGluIHRoZSBuZXcgZHJpdmVyIHRvIGJlIChlZmZlY3RpdmVseSkg
dGhlIHNhbWUgYXMgaW4gdGhlIG9sZCBkcml2ZXIuDQogICAgDQogRGF2aWQsDQpKdXN0IHdhbnRl
ZCB0byByZS1pdGVyYXRlIHdoYXQgQXJ0aHVyIGhhcyBtZW50aW9uZWQuIFdlIGNsZWFybHkgc2Vl
IEJXIGFuZCBDUFUgdXRpbGl6YXRpb24gaW1wcm92ZW1lbnQgd2l0aCBpbnRyb2R1Y3Rpb24gb2Yg
RElNIG9uIHRoZSBSeCBzaWRlIGFuZCBub24tYWRhcHRpdmUgbW9kZXJhdGlvbiBvbiB0aGUgVHgg
c2lkZSBpbiBvdXIgZHJpdmVyLiANCldlJ2QgbGlrZSB0byBkZWxpdmVyIHRoaXMgdG8gb3VyIGN1
c3RvbWVycyBBU0FQLiBXZSBhcmUgdXN1YWxseSB2ZXJ5IGNhdXRpb3VzIHdpdGggaW50cm9kdWN0
aW9uIG9mIHRoZSBuZXcgZmVhdHVyZXMsIHRoZXJlZm9yZSB3ZSdkIGxpa2UgdG8ga2VlcCBpbnRl
cnJ1cHQgbW9kZXJhdGlvbiBkaXNhYmxlZCBieSBkZWZhdWx0IGZvciBub3cuIFdlJ2QgYWR2aXNl
IG91ciBjdXN0b21lcnMgYXdhaXRpbmcgZm9yIGl0IHRvIGVuYWJsZSBpdCB1c2luZyBldGh0b29s
LiANCldlIGFyZSBnb2luZyB0byBlbmFibGUgbW9kZXJhdGlvbiBieSBkZWZhdWx0IGFmdGVyIHdl
IGFjY3VtdWxhdGUgbW9yZSBtaWxlYWdlIHdpdGggaXQgYW5kIGZpbmUgdHVuZSBpdCBmdXJ0aGVy
LiBUaGF0J3MgdGhlIHJlYXNvbiBiZWhpbmQgaGF2aW5nIFR4IGludGVydmFsID0wIGZvciBub3cg
KFJ4IG1vZGVyYXRpb24gaXMgZGlzYWJsZWQgYnkgZGVmYXVsdCBhcyB3ZWxsKS4gSG9wZSBpdCBt
YWtlcyBzZW5zZS4gICAgDQogIAkgICAgICAgDQoNCg==
