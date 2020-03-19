Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8980B18AA88
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCSCBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:01:17 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45424 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSCBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 22:01:17 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 92C76891AD
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 15:01:14 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584583274;
        bh=sXipLBlSBjXVTINH+Wab8FEFAm0QRlBTKmtfGF2xf30=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=GzeG+MHVJTc23Rnx5F9wi93+gXPk11ibBH0DXfvynLl4N+4ZDWpFFt3qxOavmynWj
         vEQG+xJtpGexh9Hg4cboA0ORkx+npF411kaEhHylb0wgtCm62doRYSE+5g108OV484
         RapqRX2Y+I5X/jHsjK/4asWtiCx9pAni7RLqRCQjJQDWEXaKu2AnmCy6STD+xbSaOy
         SCLPloS7udVMY/CkTVZvJ8xQIlk87bMQ3SlFvdY7BOZIZTWjMnuAUHF4o3+mI3+IFw
         dbVWh9TDAULX57Bpv1KATOh4z7fUmIKhaj8rqlCJRgs2KwEUxzob4ezh0kD5lkXeNk
         oHyqiETOPgfQQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e72d25a0002>; Thu, 19 Mar 2020 15:00:58 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 19 Mar 2020 15:00:57 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 19 Mar 2020 15:00:57 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marek.behun@nic.cz" <marek.behun@nic.cz>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Thread-Topic: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Thread-Index: AQHV/Y3jysg2xFhB6kOpvd67sEDP3KhOT2uA
Date:   Thu, 19 Mar 2020 02:00:57 +0000
Message-ID: <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
References: <20200319012940.14490-1-marek.behun@nic.cz>
In-Reply-To: <20200319012940.14490-1-marek.behun@nic.cz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:c08d:12b2:f65d:675b]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFF3D0D6EE07C94A9269BC59EABD5CBE@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyZWssDQoNCk9uIFRodSwgMjAyMC0wMy0xOSBhdCAwMjoyOSArMDEwMCwgTWFyZWsgQmVo
w7puIHdyb3RlOg0KPiBDb21taXQgZTFmNTUwZGM0NGE0IG1hZGUgdGhlIHVzZSBvZiBwbGF0Zm9y
bV9nZXRfaXJxX29wdGlvbmFsLCB3aGljaCBjYW4NCj4gcmV0dXJuIC1FTlhJTyB3aGVuIGludGVy
cnVwdCBpcyBtaXNzaW5nLiBIYW5kbGUgdGhpcyBhcyBub24tZXJyb3IsDQo+IG90aGVyd2lzZSB0
aGUgZHJpdmVyIHdvbid0IHByb2JlLg0KDQpUaGlzIGhhcyBhbHJlYWR5IGJlZW4gZml4ZWQgaW4g
bmV0L21hc3RlciBieSByZXZlcnRpbmcgZTFmNTUwZGM0NGE0IGFuZA0KcmVwbGFjaW5nIGl0IHdp
dGggZmEyNjMyZjc0ZTU3YmJjODY5YzhhZDM3NzUxYTExYjYxNDdhM2FjYy4NCg0KPiANCj4gRml4
ZXM6IGUxZjU1MGRjNDRhNCAoIm5ldDogbXZtZGlvOiBhdm9pZCBlcnJvciBtZXNzYWdlIGZvciBv
cHRpb25hbC4uLiIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmVrIEJlaMO6biA8bWFyZWsuYmVodW5A
bmljLmN6Pg0KPiBDYzogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxlc2lz
LmNvLm56Pg0KPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZtZGlvLmMgfCAyICstDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWFydmVsbC9tdm1kaW8uYw0KPiBpbmRleCBkMmUyZGM1Mzg0MjguLmY5ZjA5ZGE1NzAzMSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdm1kaW8uYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212bWRpby5jDQo+IEBAIC0zNjQsNyAr
MzY0LDcgQEAgc3RhdGljIGludCBvcmlvbl9tZGlvX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpDQo+ICAJCXdyaXRlbChNVk1ESU9fRVJSX0lOVF9TTUlfRE9ORSwNCj4gIAkJCWRl
di0+cmVncyArIE1WTURJT19FUlJfSU5UX01BU0spOw0KPiAgDQo+IC0JfSBlbHNlIGlmIChkZXYt
PmVycl9pbnRlcnJ1cHQgPCAwKSB7DQo+ICsJfSBlbHNlIGlmIChkZXYtPmVycl9pbnRlcnJ1cHQg
PCAwICYmIGRldi0+ZXJyX2ludGVycnVwdCAhPSAtRU5YSU8pIHsNCj4gIAkJcmV0ID0gZGV2LT5l
cnJfaW50ZXJydXB0Ow0KPiAgCQlnb3RvIG91dF9tZGlvOw0KPiAgCX0NCg==
