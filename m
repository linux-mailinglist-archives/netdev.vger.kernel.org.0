Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3124AEDC
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgHTGCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:02:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:55901 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTGCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597903322; x=1629439322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bu5N1KuYorqOzYrwbuGRpO771W/BmdXSMHeXOjdz6QM=;
  b=sw1mwCrjuNMTPLDrdEr2j1o3eqELjhIsOuoZPZjShe6xNf/gRim712Kb
   PY7B/zqM0lKy8b/X/F0Xv3DSqox3l1EpO0UHFvKabaF7rCbXVhtcU09s6
   XzHWF2TzBinUdGhFu8F73G+e4RZlC+9ZQa5Aj1TWuBuTxbcjocjS5h+HK
   THYr+QLqKKI++ADSzMmz9U6IPZprFgFdL2uKnmumr9czzwR6kya95R0nb
   lwS0UeFbeqrPZ6S7tMjjerA/J9s7MUG+Vl45R/ZCAJRKxIN9JFWrObKjk
   ScIhClWRZlzVWfh2+RO8uIgwbaz6BP/IRS0cnL/zMjz40GcH2t7UPRGS4
   g==;
IronPort-SDR: fSRrepG54qoy7OIHv3vlQsbCFo0V96KjmTPP5Y2gL6YSp7XfF5Zg9KrOBNryRtVlL8wxhWkkCj
 GMGy1+d1KJJ4Sq6AG1nz4GKHg6DE8mcrQasiKz06Kiarns3ESrHMTqPuL/1AX6Y8ALlpcGcAnu
 QLYDkO6eE/qYmht7JyOmM4mAqbd4X7bApAyRAfrSfRb8Rs0g4nnI/d6cT64+ldCglhgDNhLuCL
 LgxcAEHdoeMs8sC/wsfmRyR6dMWLt1d1cvEj/dPtcWb7MlM0gY2xjzknzms9GcNlwXW2qaNzNu
 +qs=
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="84145923"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2020 23:02:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 23:01:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 19 Aug 2020 23:01:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTiwRGWHFDFIdHpeOvHbL6hd4YsLgGTzmlfPJuEHzrW15pSzB8AuECD/eaC09VqCETxdHQn/WJUdq/GZsPFhkf6Rl6Cqk92pJaDsc1lW1u7KyMLMRiMeAMZ8ihtK2BNnE+9Zs2J4Wel9oVIG4a9eRLngYfshaJYkebLNHqyA0T+QAi5JfKip1ZShu+KK+k7Vf6T+Vbni3emk6UBCHqtQ9XHb3Vv/HasDlpLOhlJW6hz/17vD8PP3pDfHwTiorR4i6XVrkfo2g6jPRaQtr9P9Go4R/AiJpPAmo5Ouwc++V1GuXjuqPU5Fw7Hsbg41DzWkMx5zLDGQMUFep501kadWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu5N1KuYorqOzYrwbuGRpO771W/BmdXSMHeXOjdz6QM=;
 b=X5MxAyuICQ/B10RUDS7Ds+VISQMdinxhMYzw5jF85GWG1h0ocNkE0BYgWSKg+wtv7JjB3nO+TJdS3NnILacniTrcfuqQw9/SnrAFEalXMInKWXtV0E3bN27rPlWwkz1PG7M63FcvHsLGKLNGXG3CRXD2Fst/KflFJmTTMtzUVz4j3lwUQ4uPSYey4gVGgPU7hs/CS8hYzmKagYoACXBxo7yFLsDaB0b8Emvl7JOZdWbJ0c5Nolhcul0ZaHxt+Tp5b3L5PHTbndlSCRikY0e2Ad0i/ZCndQxDWWWZv7mPhuJFXF8g1oO/dp3rATeXmDXE2MYuIv8iRgkUYTgVXlWuvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu5N1KuYorqOzYrwbuGRpO771W/BmdXSMHeXOjdz6QM=;
 b=DrZN0rpDOEhe7Ui0tvdG5qiWEffxCt2iBPg3sGR5OSTe70sskpd+YvZ3tL88+ctBKjmGonJTilJf/0ypIlW5XzAAmqLycKYm6k2eJY7D2wFvDvzr6Hxm8IDq6DwzFX2lU9wNAgXWypfByPIWZq4kdPAUscp8AXiAhXIzT0X9kUQ=
Received: from MN2PR11MB4030.namprd11.prod.outlook.com (2603:10b6:208:156::32)
 by MN2PR11MB3903.namprd11.prod.outlook.com (2603:10b6:208:136::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 05:58:19 +0000
Received: from MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43]) by MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43%4]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 05:58:18 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <adham.abozaeid@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_bus_probe
Thread-Topic: [PATCH] [v2] wilc1000: Fix memleak in wilc_bus_probe
Thread-Index: AQHWdrZgZhWFClGLaEq2Gw8ZiOqF2alAgGAA
Date:   Thu, 20 Aug 2020 05:58:18 +0000
Message-ID: <d8fde586-1230-9900-acd8-e012c4e9dee0@microchip.com>
References: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
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
x-ms-office365-filtering-correlation-id: 0d53f6e5-befe-41d6-a1a0-08d844ce09b4
x-ms-traffictypediagnostic: MN2PR11MB3903:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3903355AE710DE32B3BE692DE35A0@MN2PR11MB3903.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F1oqIsRtfUQ8eopoAs/HhkLsqpuEWD/UDZlHg922v3tSQ5rSpJIMyG8qHWCEdm2qX+o4magtNkbdL1KozsHW4nUO87AFLctzukfgnIwA0THAF7u8VdXvkSQvhTm+/fujcHnKMgZ7tTf+d99bF4tzXzFOaUk3nfOf6085RFU5id1qgQsIrDXa5Dv4ltqvWmdqEaCJsvSJbUmwxJGWk1DJfC0XkBtoZGmKpewtggQdkl1UzPF8Afk4D3va6k5O3q9L4RdSTTNNhzsBoP13DPeqMUNTlZUuaOoazBAA+zIUE9CJt//ZEtHL7PxAa88aQVRn9gmZynqnaK+cXOdry11I2wNebhjKiICk//9+7HOU4tmk2XBK2UZPgZ4W5HF3xzYA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4030.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(8676002)(6486002)(110136005)(53546011)(54906003)(186003)(55236004)(316002)(26005)(71200400001)(6506007)(83380400001)(36756003)(2616005)(91956017)(66476007)(31696002)(8936002)(4326008)(31686004)(66446008)(2906002)(66946007)(64756008)(66556008)(6512007)(5660300002)(76116006)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VNCxdKRP6nadSEN6WxgOtJxy/M4S/0EW+8uA1d/iEmpAXDJvZ3lj3ruf0TQv6H/nEReZL9JDpl2/2Kiv0H2cQUzFrFFH/c05zoHpIRnFGsTpJ0fxo2MMIGYO8Lwg5x+jskjvQboAm4q0kB9wXFG/AQZxfqlIvzxz1pUebOi2hBNMeupeB23klhEmWuBvgKz4MjEIJrpuuNRCyTs0eVMcZ22aKdAcW3g/bWjZTi3r1BEH/k8rf5AuktpfOMYwoxxbmkI0VshuOwFnfslJOJ0qILM2U4OuQmdSse3PUZMbwTycuG6KMKhFpR9/O71FxH8yIXeDqD6ZmlUUSL4B4VjhC+ln1oIOm54GNbCz58TqsoqM6ZZhuLcDSmS1o6knFJoDNXkSXoRtARPBoQkfolJw2EPp3AIdzwgI3zw3aQflYnp5D5lCILLV8cQ6BIDwUROSmdpteVnNkE3S+R1P3jcKXOqD4FqHQ7mI9S6vpNJ9tll4CQPES5zSCXbpphuBZvASvTFmXTtJx8MilZjk9neVhD9yhQ7ZCLV7+X11OyrOK0b/IglG0FgZ3QtVbUq96PaZEQwBXICeUtsHiu/32pssDoxbaLxlZz53Ha1cPvjhBBZuGoX/YGuVs2GXi/hCvD4ZLM0HyFEzsb6+T+YnxlHAMg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <F25EC611CFE50E43AB3159E15DA5F1FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4030.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d53f6e5-befe-41d6-a1a0-08d844ce09b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 05:58:18.8380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3O4Ven0Vsr4zVyKXOyrRd9PWOrNrePT2cbOnW9g4/Hr3IumFLyyT5gpNtd9phFc8dPWv8OLP8Qj+caOs2EzTGoJuHsGAdppo7pTb4P7f1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3903
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwLzA4LzIwIDExOjIyIGFtLCBEaW5naGFvIExpdSB3cm90ZToNCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBXaGVuIGRldm1fY2xrX2dldCgpIHJldHVy
bnMgLUVQUk9CRV9ERUZFUiwgc3BpX3ByaXYNCj4gc2hvdWxkIGJlIGZyZWVkIGp1c3QgbGlrZSB3
aGVuIHdpbGNfY2ZnODAyMTFfaW5pdCgpDQo+IGZhaWxzLg0KPiANCj4gRml4ZXM6IDg1NGQ2NmRm
NzRhZWQgKCJzdGFnaW5nOiB3aWxjMTAwMDogbG9vayBmb3IgcnRjX2NsayBjbG9jayBpbiBzcGkg
bW9kZSIpDQo+IFNpZ25lZC1vZmYtYnk6IERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1
LmNuPg0KDQpBY2tlZC1ieTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4N
Cg0KPiAtLS0NCj4gDQo+IENoYW5nZWxvZzoNCj4gDQo+IHYyOiAtIFJlbW92ZSAnc3RhZ2luZycg
cHJlZml4IGluIHN1YmplY3QuDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9j
aGlwL3dpbGMxMDAwL3NwaS5jIHwgNSArKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvc3BpLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9t
aWNyb2NoaXAvd2lsYzEwMDAvc3BpLmMNCj4gaW5kZXggM2YxOWUzZjM4YTM5Li5hMThkYWMwYWE2
YjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAw
MC9zcGkuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAv
c3BpLmMNCj4gQEAgLTExMiw5ICsxMTIsMTAgQEAgc3RhdGljIGludCB3aWxjX2J1c19wcm9iZShz
dHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQ0KPiAgICAgICAgIHdpbGMtPmRldl9pcnFfbnVtID0gc3Bp
LT5pcnE7DQo+IA0KPiAgICAgICAgIHdpbGMtPnJ0Y19jbGsgPSBkZXZtX2Nsa19nZXQoJnNwaS0+
ZGV2LCAicnRjX2NsayIpOw0KPiAtICAgICAgIGlmIChQVFJfRVJSX09SX1pFUk8od2lsYy0+cnRj
X2NsaykgPT0gLUVQUk9CRV9ERUZFUikNCj4gKyAgICAgICBpZiAoUFRSX0VSUl9PUl9aRVJPKHdp
bGMtPnJ0Y19jbGspID09IC1FUFJPQkVfREVGRVIpIHsNCj4gKyAgICAgICAgICAgICAgIGtmcmVl
KHNwaV9wcml2KTsNCj4gICAgICAgICAgICAgICAgIHJldHVybiAtRVBST0JFX0RFRkVSOw0KPiAt
ICAgICAgIGVsc2UgaWYgKCFJU19FUlIod2lsYy0+cnRjX2NsaykpDQo+ICsgICAgICAgfSBlbHNl
IGlmICghSVNfRVJSKHdpbGMtPnJ0Y19jbGspKQ0KPiAgICAgICAgICAgICAgICAgY2xrX3ByZXBh
cmVfZW5hYmxlKHdpbGMtPnJ0Y19jbGspOw0KPiANCj4gICAgICAgICByZXR1cm4gMDsNCj4gLS0N
Cj4gMi4xNy4xDQo+IA==
