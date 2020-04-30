Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F371BF1ED
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 09:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgD3H7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 03:59:46 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:64299 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgD3H7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 03:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588233584; x=1619769584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FjkXdSlq+OoNXQeeeLsO2ITvWoSarBEMAvte+JP8xKE=;
  b=odedNmk89z0bvbqNkATrJFRDuYSy1De/6s84sF3Z9ISKyLUHticQedEK
   YufJQC6dpwDJP6vEu+m7dOmS83mHHLX2DTS/w1OtCGSFi59gD+mRSdcTZ
   sVZSbUVF50GeQWentoQ/uhDzUf2Wsr1QVMKHhCPhu+G+pWEMbvjOStte4
   MgM6bzSeT7eTCyXAnakwyPUXc7EyKzjeuScaIIBcxD1pXn3OeS4PvebET
   6oYEe3t0bnt+bKh92gA34k5WMUbdIwGmIl0qUopDYE1k7fXTGrodB2TQl
   UHQxVHXJz4Pfw/3JwBgA0nN9Jj2VVNUwHneZztB+pD/GvSyuCACPC/yoy
   w==;
IronPort-SDR: rie+jPYjmEaMbeG1deYOHQvIWOL2unLre8XmNRINZRkp+6tgmNIZz4hpEf6qS7XIzDHdRrw/ko
 LcXZsOdCAPvfgkReySCkNrcwTXa8MNXXRKT7TgDmb85Jmou4LaALuvOlMZXn0dEkvugzqQQuOC
 iM5X3G4h/YS5u9T2Eh+e2ZOSUkeKD2d8Zbfk5ErpXrO4J5gjNpQSCbyIEb1tPgWAc56G5vICXO
 YMyjFyirUxY4n+BG1yHxj4mgu1W5vAzXT9S+Iy5BS2dc5dpN+MxR0SmQtvlHX7ZsoYsMlLitpG
 XXA=
X-IronPort-AV: E=Sophos;i="5.73,334,1583218800"; 
   d="scan'208";a="75056577"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Apr 2020 00:59:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 30 Apr 2020 00:59:37 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 30 Apr 2020 00:59:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2RHX0GKppEkm8+oLqi8iR6sTYQGMYGwM2AcaD0u6du98qBiqL4TJbfBL9sWOOAcuQvn1lECHAO18Ck8iNPjboO9HA/WoQ+qVpFSRRnrQwSAssW0QO6bG65Q59w3JUBxxYEkiBFhNBNl8TCNey4PwcU/1aDcUqKzn4smkgciNpwAUkKP49xs8sTuPu8piFZ3D4ADKpmlm206BNrH9bDu6lk3hjdaL0iZo1ithi/DNlPIhnwEAH6TseM2ILXahHzIcSmvY7sD7Fbevq/5OCu25QeQ4xsx1qX0/0NYTLhSbTdyvM0kkzmc07Ehxxfnwq1ettjKu8wO7Cpo8YGb9DoZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjkXdSlq+OoNXQeeeLsO2ITvWoSarBEMAvte+JP8xKE=;
 b=WUa8ktjmP1HpCY5Fz8Dj4B8MjuOtcx+Y8J9a3YuxU6o0OPhGdrdNrdNtoWt9+b4Hds9PD83ITd7MM8eAD5Fv+ER3ex9bMintc95pBPuNKAe8SniO8EuuCu8oPD4BG6s/CP4otET8LZXEEaza4V85IuWvGBhqe3RK7kkFO+Vg327okSNhuZ0HWX1d68+TfpfZbZ5UG0WpjJfyX62MGrpbx0C6ScCu+0IxsG+JJp3//VWsQOV2Sr71a7R4F0Pccv9bn+of9+5QhIvfMCItJKpNaR3tsPOEpzUi81MIw8XrmYk7Y/imDe55PiCkUgz20KYA+c6PTJybp11Qz3wzF1V6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjkXdSlq+OoNXQeeeLsO2ITvWoSarBEMAvte+JP8xKE=;
 b=lX/ofFAI4rxEK3RgF2D0pc+XBbo+Zc9MQZAX3+hX4yEivGBPV234npHnIn/3CBwa2Nf7O0dgF5PG78qRyYl4kIdsya685aGGgO9urH6NqaVsiUvxZbrQu+9eCN2wuYNmsIrkPVk2OyWKzsrZPYAhacc5z5v1Z3E8ClwjK3/x9DI=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB4074.namprd11.prod.outlook.com (2603:10b6:5:5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Thu, 30 Apr 2020 07:59:42 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::91cb:6555:db9b:53fa]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::91cb:6555:db9b:53fa%7]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 07:59:41 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <andriy.shevchenko@linux.intel.com>, <Nicolas.Ferre@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v1] net: macb: Fix runtime PM refcounting
Thread-Topic: [PATCH v1] net: macb: Fix runtime PM refcounting
Thread-Index: AQHWHsVM8o1NWVtiaEyPfmmhScydVA==
Date:   Thu, 30 Apr 2020 07:59:41 +0000
Message-ID: <75573a4d-b465-df63-c61d-6ec4c626e7fb@microchip.com>
References: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
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
x-ms-office365-filtering-correlation-id: 00e97678-fb44-4ad8-5f81-08d7ecdc7068
x-ms-traffictypediagnostic: DM6PR11MB4074:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB40747AA3B5EA945A304E684F87AA0@DM6PR11MB4074.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zowwwq+jHeNQDBpJqDk7AgcFdvh5xwvcrhzGg+9eLTsKjHhZLlt6ud1RuDHrTJ+Bwuyh8dqRIUbJTmwpRxLTj60csDqIwiNtMp8MgnTfu+sWjQHQPkJqf25YLbxxnMMZvEhs09+xhPnRJOQx7mSNgHyYwEd4zRGpWWnttrtD2F4abWI6l1VaHfgYnkiOsCqxHdhsWQ515EfcBWymvuh03x13J91oKIlKbiu5H8rOgZ8RNyMlLJrz0pgeLAmK6mEQf+Jc5+r7MVgM1N0f3mWbNNp2nmolG0v9Qz0L36VPQ+Vi4BoWw3FdGcJXb6QHFt6kznAt41m+//3HTf7FHQTuoeV2Sx+5BxdplUR6Kp09RQpfO8wDshfuRvn6PmzQC/UEd7tj246TkaaTPTuHrcbXbZkPGPvQwSoK108Q7nPFze+qv+ohOoF/454vGM29lNxb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(346002)(39860400002)(396003)(31696002)(66556008)(76116006)(64756008)(186003)(110136005)(66946007)(91956017)(66476007)(36756003)(66446008)(8936002)(31686004)(71200400001)(6486002)(6512007)(86362001)(2616005)(478600001)(8676002)(316002)(2906002)(53546011)(6506007)(4326008)(26005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nddHl/FjpyjKeL5UXYriO/uwJhLiC8ZeEapYi3SkTZYwZsi0bNE1urjn4v2T8bc5O+80/eVxz4zYiT+w/HN7VZeYRkrPqRxTCAMAJA1dH/yq7+iaKdsD2KskE/2IYHJ0M28l0bIcRpwD/fqts6u2ZcRKTAGJXeC1WVXomKz3VeH1xPPet58TAUvyacrh/SXoHy4IP8CKzqmOnOGnWKQj/gB7/58f0ZrhJwcQMC4YaMYYoUgOzibEJQtkjtI4vsA9HMqx/Cw9bk/nnMVCRZa/ZJbFCXC/KAaqzdZgjcFG6MHvsmHyGzu6rjaJREAX169MaZVqmYe+F3gVHxt5u4E7AonaBj23GFM7ZFN1YdXVgmUMaCL2lHOD9yDWZOwAoWWZBMzjwr53QmroywUUeNdmyohrjuW7FGE4fjzQi1Q8gTM72v68OXNV7s7AQ4+qo+9FqHz/ytdEEWOLWxi+XXb/AO0c8Ne84BdquQtMGBjeW01yT5cSykiwZXfIMZ8qY9nOZjqBKl2pEPYBy94UVslZZz2njFvgX2rT6uE/HEI5H3fRstnnMmPuyAxhUhy3pj0+UZLP04/5JZ+dYbjEPh6ZWQQbvmB6mgp5GIsxL8DV1N+OhOF8yN2mYDHMebodYwf4XlLlYLTDcy2+JPQntdEwne3AL1kW8anlt+rsllSPREzDarm9JazywOcThN8cDgD/CXKI5MGGN3CXwkAF5JxcqYDYre5achMHMzuo/lvPs35TvlU1BriYwpPjChMAro4mAglYFq32ys5DeGvjhG9hirXDoXd7S1kT67kKEnTJkeI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D93F21F593B2B34B8FB1ABE8084D31A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e97678-fb44-4ad8-5f81-08d7ecdc7068
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 07:59:41.6494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yoqk1grDDH7gNL2DT7K3Z59omWf8zBB3AKQ9Q8a3hFYSDWDIu3v9Ox/6aKIGMNxKxXSNQHL5hOUVwxesXZT8culeq0OEZrdYdsPSD+nFxBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI3LjA0LjIwMjAgMTM6NTEsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGUgY29tbWl0IGU2YTQxYzIzZGYw
ZCwgd2hpbGUgdHJ5aW5nIHRvIGZpeCBhbiBpc3N1ZSwNCj4gDQo+ICAgICAoIm5ldDogbWFjYjog
ZW5zdXJlIGludGVyZmFjZSBpcyBub3Qgc3VzcGVuZGVkIG9uIGF0OTFybTkyMDAiKQ0KPiANCj4g
aW50cm9kdWNlZCBhIHJlZmNvdW50aW5nIHJlZ3Jlc3Npb24sIGJlY2F1c2UgaW4gZXJyb3IgY2Fz
ZSByZWZjb3VudGVyDQo+IG11c3QgYmUgYmFsYW5jZWQuIEZpeCBpdCBieSBjYWxsaW5nIHBtX3J1
bnRpbWVfcHV0X25vaWRsZSgpIGluIGVycm9yIGNhc2UuDQo+IA0KPiBXaGlsZSBoZXJlLCBmaXgg
dGhlIHNhbWUgbWlzdGFrZSBpbiBvdGhlciBjb3VwbGUgb2YgcGxhY2VzLg0KPiANCj4gRml4ZXM6
IGU2YTQxYzIzZGYwZCAoIm5ldDogbWFjYjogZW5zdXJlIGludGVyZmFjZSBpcyBub3Qgc3VzcGVu
ZGVkIG9uIGF0OTFybTkyMDAiKQ0KPiBDYzogQWxleGFuZHJlIEJlbGxvbmkgPGFsZXhhbmRyZS5i
ZWxsb25pQGJvb3RsaW4uY29tPg0KPiBDYzogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVh
QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHkgU2hldmNoZW5rbyA8YW5kcml5
LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAxMiArKysrKysrKystLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggYTBlOGM1YmJhYmMwMS4uZjczOWQx
NmQyOWIxZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNi
X21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5j
DQo+IEBAIC0zMzQsOCArMzM0LDEwIEBAIHN0YXRpYyBpbnQgbWFjYl9tZGlvX3JlYWQoc3RydWN0
IG1paV9idXMgKmJ1cywgaW50IG1paV9pZCwgaW50IHJlZ251bSkNCj4gICAgICAgICBpbnQgc3Rh
dHVzOw0KPiANCj4gICAgICAgICBzdGF0dXMgPSBwbV9ydW50aW1lX2dldF9zeW5jKCZicC0+cGRl
di0+ZGV2KTsNCj4gLSAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gKyAgICAgICBpZiAoc3RhdHVz
IDwgMCkgew0KPiArICAgICAgICAgICAgICAgcG1fcnVudGltZV9wdXRfbm9pZGxlKCZicC0+cGRl
di0+ZGV2KTsNCg0KcG1fcnVudGltZV9nZXRfc3luYygpIGNhbGxzIF9fcG1fcnVudGltZV9yZXN1
bWUoZGV2LCBSUE1fR0VUX1BVVCksDQppbmNyZW1lbnQgcmVmY291bnRlciBhbmQgcmVzdW1lIHRo
ZSBkZXZpY2UgY2FsbGluZyBycG1fcmVzdW1lKCkuDQoNCnBtX3J1bnRpbWVfcHV0X25vaWRsZSgp
IGp1c3QgZGVjcmVtZW50IHRoZSByZWZjb3VudGVyLiBUaGUgcHJvcGVyIHdheSwNCnNob3VsZCBi
ZSBjYWxsaW5nIHN1c3BlbmQgYWdhaW4gaWYgdGhlIG9wZXJhdGlvbiBmYWlscyBhcw0KcG1fcnVu
dGltZV9wdXRfYXV0b3N1c3BlbmQoKSBkb2VzLiBTbywgd2hhdCB0aGUgY29kZSB1bmRlciBtZGlv
X3BtX2V4aXQNCmxhYmVsIGRvZXMgc2hvdWxkIGJlIGVub3VnaC4NCg0KPiAgICAgICAgICAgICAg
ICAgZ290byBtZGlvX3BtX2V4aXQ7DQo+ICsgICAgICAgfQ0KPiANCj4gICAgICAgICBzdGF0dXMg
PSBtYWNiX21kaW9fd2FpdF9mb3JfaWRsZShicCk7DQo+ICAgICAgICAgaWYgKHN0YXR1cyA8IDAp
DQo+IEBAIC0zODYsOCArMzg4LDEwIEBAIHN0YXRpYyBpbnQgbWFjYl9tZGlvX3dyaXRlKHN0cnVj
dCBtaWlfYnVzICpidXMsIGludCBtaWlfaWQsIGludCByZWdudW0sDQo+ICAgICAgICAgaW50IHN0
YXR1czsNCj4gDQo+ICAgICAgICAgc3RhdHVzID0gcG1fcnVudGltZV9nZXRfc3luYygmYnAtPnBk
ZXYtPmRldik7DQo+IC0gICAgICAgaWYgKHN0YXR1cyA8IDApDQo+ICsgICAgICAgaWYgKHN0YXR1
cyA8IDApIHsNCj4gKyAgICAgICAgICAgICAgIHBtX3J1bnRpbWVfcHV0X25vaWRsZSgmYnAtPnBk
ZXYtPmRldik7DQoNCkRpdHRvLg0KDQo+ICAgICAgICAgICAgICAgICBnb3RvIG1kaW9fcG1fZXhp
dDsNCj4gKyAgICAgICB9DQo+IA0KPiAgICAgICAgIHN0YXR1cyA9IG1hY2JfbWRpb193YWl0X2Zv
cl9pZGxlKGJwKTsNCj4gICAgICAgICBpZiAoc3RhdHVzIDwgMCkNCj4gQEAgLTM4MTYsOCArMzgy
MCwxMCBAQCBzdGF0aWMgaW50IGF0OTFldGhlcl9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYp
DQo+ICAgICAgICAgaW50IHJldDsNCj4gDQo+ICAgICAgICAgcmV0ID0gcG1fcnVudGltZV9nZXRf
c3luYygmbHAtPnBkZXYtPmRldik7DQo+IC0gICAgICAgaWYgKHJldCA8IDApDQo+ICsgICAgICAg
aWYgKHJldCA8IDApIHsNCj4gKyAgICAgICAgICAgICAgIHBtX3J1bnRpbWVfcHV0X25vaWRsZSgm
bHAtPnBkZXYtPmRldik7DQoNClRoZSBwcm9wZXIgd2F5IHNob3VsZCBiZSBjYWxsaW5nIHBtX3J1
bnRpbWVfcHV0X3N5bmMoKSBub3Qgb25seSBmb3IgdGhpcw0KcmV0dXJuaW5nIHBhdGggYnV0IGZv
ciBhbGwgb2YgdGhlbSBpbiB0aGlzIGZ1bmN0aW9uLg0KDQo+ICAgICAgICAgICAgICAgICByZXR1
cm4gcmV0Ow0KPiArICAgICAgIH0NCj4gDQo+ICAgICAgICAgLyogQ2xlYXIgaW50ZXJuYWwgc3Rh
dGlzdGljcyAqLw0KPiAgICAgICAgIGN0bCA9IG1hY2JfcmVhZGwobHAsIE5DUik7DQo+IC0tDQo+
IDIuMjYuMg0KPiA=
