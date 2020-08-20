Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ADA24AED6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHTF5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:57:35 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:6700 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTF5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 01:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597903053; x=1629439053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YVmHT/o+n3Xi2aejaLxEzxXJdAXMizwPhW1K4vEJw8I=;
  b=CTL8ujN2Se8aXn68m0mCmiFxbeiD+EZMWjtjEh8qx8sP2T9ks8yq9mkr
   ws0Bp8DQY6fpR/sDFRrHaZ39TMR8QtR9hpjteR0sw4Zx1lf5vrdVvCQke
   Lt3emaM7V+ofU85ynNk0FFCvIXj9L4deCNwyvHCi7gm8UjUm2EavhKo1S
   VgdBqHJZvln19F4Kw5bDGhNXcmAT7RL7W2zdlKx7CJbwqluQIEJDIKHdY
   7ESKeLBjV6hGoDEBkw10vzfYo7DKrprP35vovvLJvn7Zo/0NLDqMwJmM1
   4Nq7EuQzp3TTEhfP1iUWjHecm58cjsBzPBLPRzyFnCmr58JjQDFA3R3QJ
   g==;
IronPort-SDR: PM65R1piDgyIObNPolN353FJbworluaXiTJoADwoohix5ue40YRGK8DApapL81+syNu8qeTZHs
 ZxHXj8y68bipJQ92uKeBsOmNeJbWDeQfCBxbhwG+m970rtTqZAYjUneRS8fr0L4nIkPIsHg1/u
 +1ABlOpHFoAsLJ5kxbnXKH34f95PTcm7k3RdJCb6jWpfPINWcd25uIt8EW/hjoC2dxvflmHsgN
 Jc8ufW4NMJdsWZDz0Aju2KpuKgFEEN80zTh9w7Xnq2Q/S2Y5GOe4LgrYRtGbXxnoZoid/0ZuFe
 4C4=
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="86268246"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2020 22:57:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 22:56:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 19 Aug 2020 22:56:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXaeeJgp/OmA4DNyxcnXRI58u+wArnGsuJjDCFOjta5gK0lBOJRIBAd8DboPR4vqaARfvJQjETKgCP/JSUL5WJqRsD3KilM6eflqzQUFa+ZEoWXjLYAM5XgZFI+rwyRDnKR1RkCV6DXJ/aFKB/pXVfARobpGiJx9LYSHkGsZbM0FIlsmkiRj/AkYXFTjRNqLc8t7vsEfvJyt90YC+7CLfC7Kv1mQg6g0T+r5IAbdWIHj1y0wjE1bJTnXo/1fbHRMZ7iuKJsoyJ+5VYDX3Pc3CrKnZFMvehn/nnp0KaTfAkz73HdDAZ0VQubngIdwUjjYBOEYLx+ZbAp8MquONyTpFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVmHT/o+n3Xi2aejaLxEzxXJdAXMizwPhW1K4vEJw8I=;
 b=h4n4ZacMoiXPbeQNIWHfSbpIotUU8+aGf9NE561YJ4Z3MQZBK9eDrCnwndAlLYCV1OR8Xl5YqG8mHdu+HXNOKjPg0PuG5A6lvjWMwjqSZ+/FuuCbxJQ5dN2YKifW0sUwCkpBLx1BMIguVxQPgoEKH/lUG6KM6CdkvVPexMRmVM9001bJByjXCjLiAv1lADu6Tuh6kTxuPnrKDGktwv29t+FJLGc3eXnxvpX9q9XSsYuOQCwsONF9UyqFc9YgEVRDoswO0Ek2LtdF6fkxyJmHFlCem7rfOLLFfCTrTjJ7WyAkLGlkghUE2uMzJowU7qsZNDNwdxtFx7K8vIgUJpF2og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVmHT/o+n3Xi2aejaLxEzxXJdAXMizwPhW1K4vEJw8I=;
 b=BrH95rSIdGRmdm2MtXdQobr3yQGQVIa/Tw8e7BieqTVEDDLhad4feKoESLnuc43bhH2eHIGqP6F2qnukwQvptRlOJFgX/pvUKOc8JAoQhjwdfrn5Hitt20yVYheUr9YiqmTXYTN/6ZLe5b0eDt1C4hffJ9r47f5edLR8XXyUiDg=
Received: from MN2PR11MB4030.namprd11.prod.outlook.com (2603:10b6:208:156::32)
 by MN2PR11MB3903.namprd11.prod.outlook.com (2603:10b6:208:136::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 05:56:56 +0000
Received: from MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43]) by MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43%4]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 05:56:56 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Eugen.Hristev@microchip.com>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_sdio_probe
Thread-Topic: [PATCH] [v2] wilc1000: Fix memleak in wilc_sdio_probe
Thread-Index: AQHWdrWPp9yRMn+7tEOyXN2yJogycalAf/+A
Date:   Thu, 20 Aug 2020 05:56:55 +0000
Message-ID: <ead9e558-2487-b385-33f9-9c96a360762e@microchip.com>
References: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [106.51.105.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7674150-38b1-4500-9c58-08d844cdd854
x-ms-traffictypediagnostic: MN2PR11MB3903:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3903CF5796A867BF04374D15E35A0@MN2PR11MB3903.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:534;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D8bMrbx1lbvhaJ4eyD2k7Lvt1z6QR0ebdyalqI2CEVpIYfWDXDCb7QjtTwHW3+BzJt6KIBiriPXBK32QJwaNQIw2prENZJucGCfV366Fsa18KZ3FHNMp7d6Se9+X+7nHqy1nztsZpORlMZWpgX7WUJlfFGBABYA8epR87RA3+KHRXiw4VBmeaB459+M1lWoGtn/e/8kpEsATk1hxM5hep36BxgEeCN6ptRw3ToEGy9cpdJUGzGLV0ZUji7sQ6Til+Bgwlz+MLNQJYrw6nNmxSpHMA2usFnPQw8iV3JiWsYVUHQKxfRi2Z1VUsbbzZsnr3FVww+HP62bqjqjCdzaCbLkjfJOLOMS5QCItGBKrtXfo6+PojwwAWf5yEZ+JCz5G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4030.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(8676002)(6486002)(110136005)(53546011)(54906003)(186003)(55236004)(316002)(26005)(71200400001)(6506007)(83380400001)(36756003)(2616005)(91956017)(66476007)(31696002)(8936002)(4326008)(31686004)(66446008)(2906002)(66946007)(64756008)(66556008)(6512007)(5660300002)(76116006)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iGELDxwmY2z6GBro6sy0fL0WYzHE8auNSRMYzMxwPY/2dViPuADhDjjr/PQpZaN2Z6V+Xz/M+3mQniP6+hv7cudATEvlPjLCy2Hp1G1Esczuqw1MCljgi5EbRDYD8pd23yY/cgtivFJL03KOwerFH9MNhh3rDhfuwgSv5shIloToEBWxqz47SN35VWxOdYXeyyYe6uh6LmZ1tpQHSK+tswOyDf+TWE6lrRp7EcWKQM+Ofxz/cQBMVI0htvF5HBXVCZ1xISR3ACty643Kvh81wNbh9mnYdtrXpQ5swcPru4yLf3s90Ld/MLVaukb5Onc42Uo2RLglksR8JnU7F3kK5oYe4Ryc3Oi856RoCgyVOCmNcjQfNssIzvH9L81hkVtqjI7+2m5vpMnG7e/cxlmZ3JCRwLRZU5OrROZIf76msleVsO/SrtISUo6Y46Zcj3cYEhNcrrsenZHZ6rN0ZssvUemrLpx4dUGBno1oyZx8Y0iuZ47UQnF/s8nOa8pvzsOqd34pcfuJqh8CCJCvRM08707pSC5Pz5+KUBeEVFDh7U49LmDcQyVt/AmFv+f6JUoVLuCWMbHEjoBXejm4o1I82NTnQ29CUi1r+sol4aZaP48/VIktMJ178GoY8jqA/y3eh91LgKLqd41q7Z5QdYzNgQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A91F3A1BDB87F4482FBD77D5F1FCFAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4030.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7674150-38b1-4500-9c58-08d844cdd854
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 05:56:55.9704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEJpOg1iTrcfCvq72WWLpqcjP0zjMkNzTE7jqivgoDCL42UwPJplq24PDvLduQpRiizx2hJBUmRxKLybFGWSR3u2FckwJNBone5cxY9D3hU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3903
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMC8wOC8yMCAxMToxOCBhbSwgRGluZ2hhbyBMaXUgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gV2hlbiBkZXZtX2Nsa19nZXQoKSByZXR1cm5z
IC1FUFJPQkVfREVGRVIsIHNkaW9fcHJpdg0KPiBzaG91bGQgYmUgZnJlZWQganVzdCBsaWtlIHdo
ZW4gd2lsY19jZmc4MDIxMV9pbml0KCkNCj4gZmFpbHMuDQo+IA0KPiBGaXhlczogODY5MmIwNDdl
ODZjZiAoInN0YWdpbmc6IHdpbGMxMDAwOiBsb29rIGZvciBydGNfY2xrIGNsb2NrIikNCj4gU2ln
bmVkLW9mZi1ieTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+DQoNCkFja2Vk
LWJ5OiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiAN
Cj4gQ2hhbmdlbG9nOg0KPiANCj4gdjI6IC0gUmVtb3ZlICdzdGFnaW5nJyBwcmVmaXggaW4gc3Vi
amVjdC4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAv
c2Rpby5jIHwgNSArKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNy
b2NoaXAvd2lsYzEwMDAvc2Rpby5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dp
bGMxMDAwL3NkaW8uYw0KPiBpbmRleCAzZWNlN2IwYjAzOTIuLjM1MWZmOTA5YWIxYyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NkaW8uYw0K
PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvc2Rpby5jDQo+
IEBAIC0xNDksOSArMTQ5LDEwIEBAIHN0YXRpYyBpbnQgd2lsY19zZGlvX3Byb2JlKHN0cnVjdCBz
ZGlvX2Z1bmMgKmZ1bmMsDQo+ICAgICAgICAgd2lsYy0+ZGV2ID0gJmZ1bmMtPmRldjsNCj4gDQo+
ICAgICAgICAgd2lsYy0+cnRjX2NsayA9IGRldm1fY2xrX2dldCgmZnVuYy0+Y2FyZC0+ZGV2LCAi
cnRjIik7DQo+IC0gICAgICAgaWYgKFBUUl9FUlJfT1JfWkVSTyh3aWxjLT5ydGNfY2xrKSA9PSAt
RVBST0JFX0RFRkVSKQ0KPiArICAgICAgIGlmIChQVFJfRVJSX09SX1pFUk8od2lsYy0+cnRjX2Ns
aykgPT0gLUVQUk9CRV9ERUZFUikgew0KPiArICAgICAgICAgICAgICAga2ZyZWUoc2Rpb19wcml2
KTsNCj4gICAgICAgICAgICAgICAgIHJldHVybiAtRVBST0JFX0RFRkVSOw0KPiAtICAgICAgIGVs
c2UgaWYgKCFJU19FUlIod2lsYy0+cnRjX2NsaykpDQo+ICsgICAgICAgfSBlbHNlIGlmICghSVNf
RVJSKHdpbGMtPnJ0Y19jbGspKQ0KPiAgICAgICAgICAgICAgICAgY2xrX3ByZXBhcmVfZW5hYmxl
KHdpbGMtPnJ0Y19jbGspOw0KPiANCj4gICAgICAgICBkZXZfaW5mbygmZnVuYy0+ZGV2LCAiRHJp
dmVyIEluaXRpYWxpemluZyBzdWNjZXNzXG4iKTsNCj4gLS0NCj4gMi4xNy4xDQo+IA==
