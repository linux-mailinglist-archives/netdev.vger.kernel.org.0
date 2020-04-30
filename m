Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07131BF7F6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD3MNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:13:05 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:14289 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgD3MNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588248784; x=1619784784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GLRnPu5EfK6k3UrW/UXU2aiSS8re/67FkraVTyppCg4=;
  b=Aq+itdRRj3CuS5e1MWRybbfgfuo/DTFWIZm/Nr9h6EwfMTv4hRUy2A0S
   1IIoZgNhdLimb6tgeab6BLNhhAfXG0Hai0IdiHCv1o8ycIP2wKNNGNaQV
   6pxZULlV4dTB21GcNfprCOsqM0c+v5FncxWv5rN1Ln3MK3JnM/T1oG2Mr
   uZ7HmaeUY/HWmJ5nGj6hO1ZSsS7WjYWOpQmTrvFwXMfoaiYLLyAbOf+Hw
   z3KFRKFcl1aGMaGikM0aojK3qKAmDwtFLffekJARdj9x2yW/3j+8deRbo
   o3f6sitk35cUFElk0S8g4Br5Xt2G6761O9Hj0Rbb+yWgQbHwBVcYOjuj8
   w==;
IronPort-SDR: B8MJgYwb6ur0Bnpe4FzFcWDETjK0fbiGXnR6Eus79xZKgFP+m5lS3UW87gJbaQOJRHpaW2Cp5g
 RvctjX4AY8RpOal62oYGd7PrJdWXIM+7/6mHxoCrKTO9KUkanYK+jbMkGfNPGr7kBM4rFepAE9
 uQ3XG6dB6X2+10DsySWP7yjFuAouiE21zBFVzZuaV530BxUkKvzbOQvIMbHC7xEgrOAD9JBzFU
 9u5A/QLciR4jC/WPLlD2xnuC0NvDxTLxMivzBVolIx0ByFigCYK1eswRVOhmtMEP+Kc++Emb91
 DGw=
X-IronPort-AV: E=Sophos;i="5.73,334,1583218800"; 
   d="scan'208";a="74368023"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Apr 2020 05:13:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 30 Apr 2020 05:13:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 30 Apr 2020 05:13:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qx8ByobCDPvuY6H41YB0a/cUyUlrhPrvUq46A+wrjCmHA9F1AVQb3zlqwtiJhxoXCXmkMlkBOGbt21EqE/7Wh8MRvPmhkov4055Lri1Ng161bVa2igPYr4I6nH/Om/Q4/Tb2YKZ+4Dc2qR0WJIaypeIpp8w9y+DZGgwO9yaOR/4tatqMXnVI3cQeoyfAF6J+PpzlnDjw4l/pOqrPyg8oRW6QsC2MRz6CpcfqPj+zzAvrX/RG0R12XJBQry/PbTT+oyiTN+n3YttXEpdR4b2qA5CipaPm4pUxlmOxFUK9FDgMudayXZxorC5FjzMpZE6hJfHQ5agq46oEB6In4BB0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLRnPu5EfK6k3UrW/UXU2aiSS8re/67FkraVTyppCg4=;
 b=mRD9/8lzuUviCzXsS1XLkAA+0jVluX8qGrzOFoRgUZmjRsaIWfJ6WRBZkMiXCITeXNxyNZY3iZImpILaSeW9lHlXP04RXQDnE6Rj0zJLnCtZ2g/MTFxPH60jTlnsPU9D984sbj5fUtFeJYpB2RglEFO4V4x2524icWTPHJroxcSnD44SstWWBmgazX9bc19X/oxziRGoniOS4yTBIpLgBvJVFBoDjhNwou6Ap5VCPdiM7d/Pkck9M3ji5Tg+qDjAp7lo+rWOJYuFHwJ0ZxBuTtWtMya109HX9q1487PmDhNt0EFqnO26aPL+mkYRPc17pdf5XtPrCz7kcL2GY4dxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLRnPu5EfK6k3UrW/UXU2aiSS8re/67FkraVTyppCg4=;
 b=I0tDfh2jlv/G0LdT6+LuU36Twx7QILYARTw5QbHNH4KKHyJfMA2do34y+9BoAPYf9QFGzzNgiMwbTVrEvVdfKZHcxjupPrsm24rsd2cVZfzULzgnc1/mi27uRxU9wQypNeSp2dbenSf+kEKXc/nbyNfBOOjSnx0ZwtwvVpNQWeI=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB4364.namprd11.prod.outlook.com (2603:10b6:5:201::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 12:13:01 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::91cb:6555:db9b:53fa]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::91cb:6555:db9b:53fa%7]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 12:13:01 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <andriy.shevchenko@linux.intel.com>
CC:     <Nicolas.Ferre@microchip.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v1] net: macb: Fix runtime PM refcounting
Thread-Topic: [PATCH v1] net: macb: Fix runtime PM refcounting
Thread-Index: AQHWHsVM8o1NWVtiaEyPfmmhScydVA==
Date:   Thu, 30 Apr 2020 12:13:01 +0000
Message-ID: <f301da54-3eb7-8bab-50cd-f37fc3a92b2c@microchip.com>
References: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
 <75573a4d-b465-df63-c61d-6ec4c626e7fb@microchip.com>
 <20200430103407.GS185537@smile.fi.intel.com>
In-Reply-To: <20200430103407.GS185537@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [86.120.221.109]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 925d3761-0756-438d-b5d7-08d7ecffd448
x-ms-traffictypediagnostic: DM6PR11MB4364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4364FA029985A4840B2D280C87AA0@DM6PR11MB4364.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(396003)(39860400002)(366004)(136003)(91956017)(71200400001)(31686004)(6506007)(4326008)(66446008)(53546011)(478600001)(186003)(2906002)(66476007)(26005)(66946007)(64756008)(66556008)(54906003)(76116006)(8676002)(316002)(6512007)(86362001)(31696002)(6916009)(5660300002)(8936002)(6486002)(2616005)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /JBBnoy1E4XI+C1qVLKOPBA/q2uohRY5OtRA5ZtDGoFRpiJ14Ejrn3/iPgveV5nlXnz8HBaZx5I46+LTClyxx0YR+sKLf6m0IsKwdEDxULGseOHcfp7L8SqnCwdnIJXB2H2n6lNqneVeNqparqpXJLdT1Q7qG5CunT6n7BwW8V9cRlg60vp0wYo23RzQUNEUBg6wjerTKSl6gRayTogX3tqgDpCv6T5yfndjaQWW66h0gvmIeMXJFKisedRcscNYphJ6XssMTJiwTyjZUSliwkBmFkQqV6W2WbvELI1WCEsN1DFL98lYQcsWVC/bCOmr0LWglXy0CHgDw+4MKQQdEPVbQH9J7d/t5ZtjqazfWjJnNe6fopc4jFfhFzIOJWvNggIW6NrhKUp38SUlKBdub1s8w8o0HXeSzxV66QBn9GJeNQUTurwlsV2y5AQVmGw9
x-ms-exchange-antispam-messagedata: 0dIzBvrJezeirhkWxaxMr+/BXmjdY5tGlx9pBSrFdaP08LUBzMm6eXWxHs6bv7zPdvXhmx74MvxLtQ4tLJvjUwxMNxmNOGICYOxwt6+ZBKity2pReCGqjx3KEk5XHnonfq/1YDLOrUo9kucfqQRbXKBER6g9BDIcqxPXY71OzpslbrwAdiw4uKghVe6CpfV6VdWWV0GUYvkRsIoObfaYjELV2wPYQst31tJ6jrZ9nCcIlTfj+2NFyu8bfu7hfFa8ht/O4Y89ueQtz/wg6FLsTkGFpUjvrtSThvjJgfxNlZJ/wrdjxFHhooPkEHVBN2V911LxHcd6Yl2wBUyv+vNkzNKG1WCw9gm330EExhUPiKs95OQUn2sUDR0dSVXp7OOPKedwGTe6nRTTRsPmqKBWgUvaZyl9NqITsfVkAYxIrCu1yC0LAd3bVICptSzq3sP4C8Nb7jyEXd1/geG+LevM8dxIaP2/dIZlCaluKwAgu61Wh4ySLbAUn9+S7xow9fAHpERvCceaRe7gHMbtc1FrG2Yr6up1LOM47vmQTfczHm+B0PAVY/GzN6p3wa19lg7DsR7RdU682qshl1y5Cqy2l1HFSE3ot2hVEz7NthSG923/Mm3psc1q+JedfmcFfVsuCHOdvAV8eqR4A1np/0hQL5zaUT54S2adg01gHnurIoI7Mc4wZGjVIDGtMWAB2rfZCDYK0vOKINCKIpJmPpc2auwfGgJMEzoCzWLBrvwv8j0ENKe2hqSLHQdOiL6tz9pejdoyaOPZ1jgWxpfUdZrARm7Ji+RqJ69dMhr61Kb/fsI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D28C8DA2AA76E49B7451F7C46BE8777@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 925d3761-0756-438d-b5d7-08d7ecffd448
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 12:13:01.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oWLt4Mnr7vqWi/tIi27iq6x+tBnkilld70A483IyqJ2ZW62oEVncf9y67z8i6Py2aAfHNdAzLfARYkuQwp4Lo7r8phPG/KzPVRTrSa4qMsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4364
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDMwLjA0LjIwMjAgMTM6MzQsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIEFwciAzMCwgMjAyMCBh
dCAwNzo1OTo0MUFNICswMDAwLCBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIHdyb3RlOg0K
Pj4NCj4+DQo+PiBPbiAyNy4wNC4yMDIwIDEzOjUxLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+
Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBUaGUgY29tbWl0
IGU2YTQxYzIzZGYwZCwgd2hpbGUgdHJ5aW5nIHRvIGZpeCBhbiBpc3N1ZSwNCj4+Pg0KPj4+ICAg
ICAoIm5ldDogbWFjYjogZW5zdXJlIGludGVyZmFjZSBpcyBub3Qgc3VzcGVuZGVkIG9uIGF0OTFy
bTkyMDAiKQ0KPj4+DQo+Pj4gaW50cm9kdWNlZCBhIHJlZmNvdW50aW5nIHJlZ3Jlc3Npb24sIGJl
Y2F1c2UgaW4gZXJyb3IgY2FzZSByZWZjb3VudGVyDQo+Pj4gbXVzdCBiZSBiYWxhbmNlZC4gRml4
IGl0IGJ5IGNhbGxpbmcgcG1fcnVudGltZV9wdXRfbm9pZGxlKCkgaW4gZXJyb3IgY2FzZS4NCj4+
Pg0KPj4+IFdoaWxlIGhlcmUsIGZpeCB0aGUgc2FtZSBtaXN0YWtlIGluIG90aGVyIGNvdXBsZSBv
ZiBwbGFjZXMuDQo+IA0KPiAuLi4NCj4gDQo+Pj4gICAgICAgICBzdGF0dXMgPSBwbV9ydW50aW1l
X2dldF9zeW5jKCZicC0+cGRldi0+ZGV2KTsNCj4+PiAtICAgICAgIGlmIChzdGF0dXMgPCAwKQ0K
Pj4+ICsgICAgICAgaWYgKHN0YXR1cyA8IDApIHsNCj4+PiArICAgICAgICAgICAgICAgcG1fcnVu
dGltZV9wdXRfbm9pZGxlKCZicC0+cGRldi0+ZGV2KTsNCj4+DQo+PiBwbV9ydW50aW1lX2dldF9z
eW5jKCkgY2FsbHMgX19wbV9ydW50aW1lX3Jlc3VtZShkZXYsIFJQTV9HRVRfUFVUKSwNCj4+IGlu
Y3JlbWVudCByZWZjb3VudGVyIGFuZCByZXN1bWUgdGhlIGRldmljZSBjYWxsaW5nIHJwbV9yZXN1
bWUoKS4NCj4gDQo+IFJlYWQgdGhlIGNvZGUgZnVydGhlciB0aGFuIHRoZSBoZWFkZXIgZmlsZSwg
cGxlYXNlLg0KPiANCj4+IHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpIGp1c3QgZGVjcmVtZW50IHRo
ZSByZWZjb3VudGVyLg0KPiANCj4gd2hpY2ggaXMgZXhhY3RseSB3aGF0IGhhcyB0byBiZSBkb25l
IG9uIGVycm9yIHBhdGguDQo+IA0KPj4gVGhlIHByb3BlciB3YXksDQo+PiBzaG91bGQgYmUgY2Fs
bGluZyBzdXNwZW5kIGFnYWluIGlmIHRoZSBvcGVyYXRpb24gZmFpbHMgYXMNCj4+IHBtX3J1bnRp
bWVfcHV0X2F1dG9zdXNwZW5kKCkgZG9lcy4gU28sIHdoYXQgdGhlIGNvZGUgdW5kZXIgbWRpb19w
bV9leGl0DQo+PiBsYWJlbCBkb2VzIHNob3VsZCBiZSBlbm91Z2guDQo+IA0KPiBIdWg/IEl0IHJl
dHVybnMgYW4gZXJyb3Igd2l0aG91dCByZWJhbGFuY2luZyByZWZjb3VudGVyLg0KDQpZZXAsIG15
IG1pc3Rha2UuIFlvdXIgY29kZSBpcyBnb29kLg0KDQoNCj4gDQo+IFllYWgsIG9uZSBtb3JlIHRp
bWUgYW4gZXZpZGVuY2UgdGhhdCBwZW9wbGUgZG8gbm90IGdldCBydW50aW1lIFBNIHByb3Blcmx5
Lj4gDQo+Pj4gICAgICAgICAgICAgICAgIGdvdG8gbWRpb19wbV9leGl0Ow0KPj4+ICsgICAgICAg
fQ0KPj4+DQo+Pj4gICAgICAgICBzdGF0dXMgPSBtYWNiX21kaW9fd2FpdF9mb3JfaWRsZShicCk7
DQo+Pj4gICAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4+PiBAQCAtMzg2LDggKzM4OCwxMCBAQCBz
dGF0aWMgaW50IG1hY2JfbWRpb193cml0ZShzdHJ1Y3QgbWlpX2J1cyAqYnVzLCBpbnQgbWlpX2lk
LCBpbnQgcmVnbnVtLA0KPj4+ICAgICAgICAgaW50IHN0YXR1czsNCj4+Pg0KPj4+ICAgICAgICAg
c3RhdHVzID0gcG1fcnVudGltZV9nZXRfc3luYygmYnAtPnBkZXYtPmRldik7DQo+Pj4gLSAgICAg
ICBpZiAoc3RhdHVzIDwgMCkNCj4+PiArICAgICAgIGlmIChzdGF0dXMgPCAwKSB7DQo+Pj4gKyAg
ICAgICAgICAgICAgIHBtX3J1bnRpbWVfcHV0X25vaWRsZSgmYnAtPnBkZXYtPmRldik7DQo+Pg0K
Pj4gRGl0dG8uDQo+IA0KPiBEaXR0by4NCj4gDQo+Pg0KPj4+ICAgICAgICAgICAgICAgICBnb3Rv
IG1kaW9fcG1fZXhpdDsNCj4+PiArICAgICAgIH0NCj4+Pg0KPj4+ICAgICAgICAgc3RhdHVzID0g
bWFjYl9tZGlvX3dhaXRfZm9yX2lkbGUoYnApOw0KPj4+ICAgICAgICAgaWYgKHN0YXR1cyA8IDAp
DQo+Pj4gQEAgLTM4MTYsOCArMzgyMCwxMCBAQCBzdGF0aWMgaW50IGF0OTFldGhlcl9vcGVuKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+Pj4gICAgICAgICBpbnQgcmV0Ow0KPj4+DQo+Pj4gICAg
ICAgICByZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKCZscC0+cGRldi0+ZGV2KTsNCj4+PiAtICAg
ICAgIGlmIChyZXQgPCAwKQ0KPj4+ICsgICAgICAgaWYgKHJldCA8IDApIHsNCj4+PiArICAgICAg
ICAgICAgICAgcG1fcnVudGltZV9wdXRfbm9pZGxlKCZscC0+cGRldi0+ZGV2KTsNCj4+DQo+PiBU
aGUgcHJvcGVyIHdheSBzaG91bGQgYmUgY2FsbGluZyBwbV9ydW50aW1lX3B1dF9zeW5jKCkgbm90
IG9ubHkgZm9yIHRoaXMNCj4+IHJldHVybmluZyBwYXRoIGJ1dCBmb3IgYWxsIG9mIHRoZW0gaW4g
dGhpcyBmdW5jdGlvbi4NCj4gDQo+IE9mIGNvdXJzZSBub3QuDQo+IA0KPj4+ICAgICAgICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KPj4+ICsgICAgICAgfQ0KPj4+DQo+Pj4gICAgICAgICAvKiBDbGVh
ciBpbnRlcm5hbCBzdGF0aXN0aWNzICovDQo+Pj4gICAgICAgICBjdGwgPSBtYWNiX3JlYWRsKGxw
LCBOQ1IpOw0KPj4+IC0tDQo+Pj4gMi4yNi4yDQo+Pj4NCj4gDQo+IC0tDQo+IFdpdGggQmVzdCBS
ZWdhcmRzLA0KPiBBbmR5IFNoZXZjaGVua28NCj4gDQo+IA==
