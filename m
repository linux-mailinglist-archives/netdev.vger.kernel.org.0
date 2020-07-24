Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC822C95C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgGXPi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:38:26 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51768 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXPiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:38:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595605104; x=1627141104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lco7GfgwPha1XFvDJQMGrHDnOzSmTddpVA2aB1W2Z4s=;
  b=1CmJURyKOr6O78RN1bMe0B1OC+5WJi7TiAkd/3STozkggqzF5NA9yGHk
   3qK1NEwxh4OHxTa+9gjCw+ToixPFkWCRrsfPNUbfFAVSIl0eDUC3IOu5+
   4AoI8oPXnzOZMTii3w5ZRiwLhpUI3qjM/vlSqK09MBwt6UW8k2XgOy0ct
   o4XZCexiBAGaaE5ipe/36K26HsZJLeNuVvbTgn5l19TIXHz7BGz4SYenj
   EMVpBDWbDCtB3Jl4vWtwmmovMBAgpNoF8iEkzzBA0gAHNxRdLwO4yrYxD
   7v4tvWMANWFlqcSREgACVQNzRdIwVePyB2xMfp/xwEc5jubMnubsOkjI5
   w==;
IronPort-SDR: CGt1zt8tZONcY26YEI1OHGKPj8FGz0o+S81sWCRwFCS3oMWdXC3085vJzcwY4GpxXDFcTbLQzm
 8umRnNLsJzPbD9Wa+YcOxL4GX8xtHoSBu33VcCKFbQM5vnM5uZo+BPlgiSxxhzeFV2Z/wFpabg
 1pEpwN7Q/12FXbmnqlsiQwFSQVuKxjYeP0Ovp8re0/kKAvEBWBwkkfdHMtpDJScU9lSUZr16bm
 zdQWNt8yF6J+Y3Fqm52zDxQO9RcrnhvHNmCyLILztaKC5YrT3lG3NHtNy+CstgnNOXQhmdGcG/
 i1w=
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="83182798"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 08:38:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 08:37:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 24 Jul 2020 08:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zsb03opG2UDJDwXKZ2P1ZJUrpvBC2QqJWTpuGjzFGBypLbV3rgoWZ8w0j67w0y5VKQGYViremjNW+s1SNgoMhIJ5cs1jcMR6ULMBgcDcOnCBGqW7WY0lQlq47jMHaGOlqNAIt2pUq4dMyXHwAnIt0MBPTDy+K6GUIrHXtcDv48r5PDGJSTjpDqbnfyvMT1I9cL9ofcnCXQeILkos+pKXXhrdHVPpt4cYwxfSTolclX8X/Apsc6lVmcf6VjBGGfqGiLzZDH6NbP5TX8+whb/zL7mpJhE0/qyp/NNAsca+dNTCQ2fj255UBirXEHju4YRK4Mxh1qP2XCD7gQCIuKtg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lco7GfgwPha1XFvDJQMGrHDnOzSmTddpVA2aB1W2Z4s=;
 b=nrmVcjIa/j5Hdt7eExx4DyUttuuKKjQqbsOnP8lsjRGIi6dmMyxIc8Dhe3niZ5loHgvmBpNYHI9vkzpeEn6hAwE/ng5YvHJkqE22h/jX4CSDwuWmZpdzVX3K57nglYNzbO6o1Ng7Y19zmg+gEJAsaeT1lveSQhqcK4RzNaOF1SShU2EEaKVe2GADXR1JeH29ZZ/Z99Db+ney1cDDMRN7FITeGuDbKM4I/taznnWxYQyHeg/szKCvcQdBCQX0t0uzcDDk5RthvRXDksNCV5W0fzTj3IM3NDqwoPbJH4ONTGS+Zq1Et5E8O/w9Ivhm5AXQ89+tT0DLXIbliYma7Tf6Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lco7GfgwPha1XFvDJQMGrHDnOzSmTddpVA2aB1W2Z4s=;
 b=f2Y9O7tj23GWDjN+G8aAgqPiFZRyqPl+JmEHlUx3KpMWapZ2dh57Zbj95LahCg/4sXGtXkF/uzTyfom5+neCljZ/7sD/ptr4PVR95URBLrLwMoMBZR5pzj8mYU+9lQa8yoY0qVikxEVxLSr+atfTdP1a6zL2KjrjOxCkpiJPJ/A=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3792.namprd11.prod.outlook.com (2603:10b6:208:f7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Fri, 24 Jul
 2020 15:38:21 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54%7]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 15:38:21 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Topic: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Index: AQHWYS1Pa/FhIgpObUi5DOaSOO6xe6kVq1KAgAEzHJA=
Date:   Fri, 24 Jul 2020 15:38:21 +0000
Message-ID: <MN2PR11MB36627D9D41606D0BCD9021D8FA770@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
 <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
In-Reply-To: <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [68.195.34.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a76e52ea-41ae-47a1-d63a-08d82fe79840
x-ms-traffictypediagnostic: MN2PR11MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37922B656C7416C66CE073CFFA770@MN2PR11MB3792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86uP1Ru08ehEuUn0tjGtjhGh1Y4aaKMrCb0hBKujkYa8KB0HCw/PIQGxSBza/QtCfsWeeG/oKF8Arc0sVQDZFNr2Hr1SYI0IHqW9wEoOmWRdM020Jru37LaxvuFS34f3OACcXYtcozsXLPAxOf0AP2KjZ3TJp4wISGNb0Wvnn3qmLFIS++x077V0zHV7QTbVjlwImR8UCpp7y+OBI5BYrD644/6r4KhacRl8vDhh7w0eTdJNhEbGV/51Wla6wCWFq0yMpMN6hVJ8vWcNaDPcsEDUQqAideAG0iASEbatXZLajAkHAnCWWB43vSbjcC4zzxd9QAzj++8r9SQUzI0JXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(316002)(2906002)(9686003)(110136005)(26005)(53546011)(33656002)(7696005)(478600001)(54906003)(55016002)(6506007)(186003)(8676002)(8936002)(83380400001)(64756008)(4326008)(66446008)(66476007)(107886003)(66946007)(66556008)(86362001)(71200400001)(52536014)(5660300002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: u7jkxR8FNuA3Co5nGiOWNjkJTwHfYSW1VWSdYDSGsrrECsVRHXgJZiTHeqjv//wKH6WOpAxf9XViokSH1442nh0hTn9lJdh764cJsV7eNed0S+ClMCYbz2hxbYfY2Ne8gEAqj12m5A4+Lq2CQ5D7ablMemG4dVe2s8o1X/7+icSFweQIJ9/tHr24kP+pH3owP2kWw3B4R3KnNmP3TSzY1DLi2eW10I1HlfU/3lHERNTgzCznA/m5dTo9IByB2LeeCsNL2R2cVnRvdFMIEUsiXxSIvRp3PDrJRhlRF0MqQ3PdzVaObLsqUgztUEb4Mseks4OEdnDnV5GNfnOj7qVZtB4n7f8C6Kx2EpS6x/x5aDfIS0eW63NvZMZhOhRL/cRyawBh7XEbJp/c68fS+LQuN+tW2e598NkSEp3PQIOcTRUUwFg2ugrgd9zpDDzzyUzkOem/U89eIl3xQ8wbIde88sB1/hP5WWOJG/bQ7QH9lYQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76e52ea-41ae-47a1-d63a-08d82fe79840
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 15:38:21.0482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tIPLr9G4SX0QItixuWhMyQa5lBmh9BTr73ampWlxHRBO4DtDulkE78gue3BrE/gyyNjhGHp7Q0+Wz4JVwHts9C3637V2MTQk2TcP1p9ZDBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEZsb3JpYW4sIEkgd2lsbCBhcHBseSB5b3VyIHN1Z2dlc3Rpb25zLg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVs
bGlAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyMywgMjAyMCA1OjE5IFBNDQo+
IFRvOiBCcnlhbiBXaGl0ZWhlYWQgLSBDMjE5NTggPEJyeWFuLldoaXRlaGVhZEBtaWNyb2NoaXAu
Y29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgVU5HTGludXhEcml2ZXINCj4gPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIG1zY2M6IEFkZCBMQ1BMTCBSZXNldCB0byBWU0M4
NTc0IEZhbWlseSBvZiBwaHkNCj4gZHJpdmVycw0KPiANCj4gRVhURVJOQUwgRU1BSUw6IERvIG5v
dCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUNCj4g
Y29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiA3LzIzLzIwIDE6MDkgUE0sIEJyeWFuIFdoaXRlaGVh
ZCB3cm90ZToNCj4gPiBUaGUgTENQTEwgUmVzZXQgc2VxdWVuY2UgaXMgYWRkZWQgdG8gdGhlIGlu
aXRpYWxpemF0aW9uIHBhdGggb2YgdGhlDQo+ID4gVlNDODU3NCBGYW1pbHkgb2YgcGh5IGRyaXZl
cnMuDQo+ID4NCj4gPiBUaGUgTENQTEwgUmVzZXQgc2VxdWVuY2UgaXMga25vd24gdG8gcmVkdWNl
IGhhcmR3YXJlIGludGVyLW9wIGlzc3Vlcw0KPiA+IHdoZW4gdXNpbmcgdGhlIFFTR01JSSBNQUMg
aW50ZXJmYWNlLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBpcyBzdWJtaXR0ZWQgdG8gbmV0LW5leHQg
dG8gYXZvaWQgbWVyZ2luZyBjb25mbGljdHMgdGhhdA0KPiA+IG1heSBhcmlzZSBpZiBzdWJtaXR0
ZWQgdG8gbmV0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQnJ5YW4gV2hpdGVoZWFkIDxCcnlh
bi5XaGl0ZWhlYWRAbWljcm9jaGlwLmNvbT4NCj4gDQo+IENhbiB5b3UgY29weSB0aGUgUEhZIGxp
YnJhcnkgbWFpbnRhaW5lcnMgZm9yIGZ1dHVyZSBjaGFuZ2VzIHN1Y2ggdGhhdCB0aGlzIGRvZXMN
Cj4gbm90IGVzY2FwZSB0aGVpciByZXZpZXc/DQo+IA0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25l
dC9waHkvbXNjYy9tc2NjX21haW4uYyB8IDkwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOTAgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9tc2NjL21zY2NfbWFpbi5jDQo+
ID4gYi9kcml2ZXJzL25ldC9waHkvbXNjYy9tc2NjX21haW4uYw0KPiA+IGluZGV4IGE0ZmJmM2Eu
LmYyZmEyMjEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjY19tYWlu
LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9waHkvbXNjYy9tc2NjX21haW4uYw0KPiA+IEBAIC05
MjksNiArOTI5LDkwIEBAIHN0YXRpYyBib29sIHZzYzg1NzRfaXNfc2VyZGVzX2luaXQoc3RydWN0
DQo+ID4gcGh5X2RldmljZSAqcGh5ZGV2KSAgfQ0KPiA+DQo+ID4gIC8qIGJ1cy0+bWRpb19sb2Nr
IHNob3VsZCBiZSBsb2NrZWQgd2hlbiB1c2luZyB0aGlzIGZ1bmN0aW9uICovDQo+ID4gKy8qIFBh
Z2Ugc2hvdWxkIGFscmVhZHkgYmUgc2V0IHRvIE1TQ0NfUEhZX1BBR0VfRVhURU5ERURfR1BJTyAq
Lw0KPiA+ICtzdGF0aWMgaW50IHZzYzg1NzRfd2FpdF9mb3JfbWljcm9fY29tcGxldGUoc3RydWN0
IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiArew0KPiA+ICsgICAgIHUxNiB0aW1lb3V0ID0gNTAw
Ow0KPiA+ICsgICAgIHUxNiByZWcxOGcgPSAwOw0KPiA+ICsNCj4gPiArICAgICByZWcxOGcgPSBw
aHlfYmFzZV9yZWFkKHBoeWRldiwgMTgpOw0KPiA+ICsgICAgIHdoaWxlIChyZWcxOGcgJiAweDgw
MDApIHsNCj4gPiArICAgICAgICAgICAgIHRpbWVvdXQtLTsNCj4gPiArICAgICAgICAgICAgIGlm
ICh0aW1lb3V0ID09IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4g
PiArICAgICAgICAgICAgIHVzbGVlcF9yYW5nZSgxMDAwLCAyMDAwKTsNCj4gPiArICAgICAgICAg
ICAgIHJlZzE4ZyA9IHBoeV9iYXNlX3JlYWQocGh5ZGV2LCAxOCk7DQo+IA0KPiBQbGVhc2UgY29u
c2lkZXIgdXNpbmcgcGh5X3JlYWRfcG9sbF90aW1lb3V0KCkgaW5zdGVhZCBvZiBvcGVuIGNvZGlu
ZyB0aGlzIGJ1c3kNCj4gd2FpdGluZyBsb29wLg0KPiANCj4gPiArICAgICB9DQo+ID4gKw0KPiA+
ICsgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKiBidXMtPm1kaW9fbG9jayBz
aG91bGQgYmUgbG9ja2VkIHdoZW4gdXNpbmcgdGhpcyBmdW5jdGlvbiAqLyBzdGF0aWMNCj4gPiAr
aW50IHZzYzg1NzRfcmVzZXRfbGNwbGwoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikgew0KPiA+
ICsgICAgIHUxNiByZWdfdmFsID0gMDsNCj4gPiArICAgICBpbnQgcmV0ID0gMDsNCj4gPiArDQo+
ID4gKyAgICAgcGh5X2Jhc2Vfd3JpdGUocGh5ZGV2LCBNU0NDX0VYVF9QQUdFX0FDQ0VTUywNCj4g
PiArICAgICAgICAgICAgICAgICAgICBNU0NDX1BIWV9QQUdFX0VYVEVOREVEX0dQSU8pOw0KPiA+
ICsNCj4gPiArICAgICAvKiBSZWFkIExDUExMIGNvbmZpZyB2ZWN0b3IgaW50byBQUkFNICovDQo+
ID4gKyAgICAgcGh5X2Jhc2Vfd3JpdGUocGh5ZGV2LCAxOCwgMHg4MDIzKTsNCj4gPiArICAgICBy
ZXQgPSB2c2M4NTc0X3dhaXRfZm9yX21pY3JvX2NvbXBsZXRlKHBoeWRldik7DQo+ID4gKyAgICAg
aWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGdvdG8gZG9uZTsNCj4gDQo+IEl0IG1pZ2h0IG1h
a2Ugc2Vuc2UgdG8gd3JpdGUgYSBoZWxwZXIgZnVuY3Rpb24gdGhhdCBlbmNhcHN1bGF0ZXMgdGhl
Og0KPiANCj4gLSBwaHlfYmFzZV93cml0ZSgpDQo+IC0gd2FpdF9mb3JfY29tcGxldGUNCj4gDQo+
IHBhdHRlcm4gYW5kIHVzZSBpdCB0aHJvdWdob3V0LCB3aXRoIGFuIG9wdGlvbiBkZWxheSByYW5n
ZSBhcmd1bWVudCBzbyB5b3UgY2FuDQo+IHB1dCB0aGF0IGluIHRoZXJlLCB0b28uDQo+IC0tDQo+
IEZsb3JpYW4NCg==
