Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4514E2FE633
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbhAUJUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:20:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:40427 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbhAUJUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611220830; x=1642756830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=88I2XL0f6c44qJXiPw9Wm8rVJQHGd2JS2SkcbySpqCs=;
  b=n8qwYrCqJmqqPBSlI1HfaAnXRuqbMJHVyVqi6U6EhBUxThqCoc/9LGxN
   tIxja3QbBe2IfHHEqF18AGfRoirsOhkx27Rw0g+KHd4jGXaZBqh8PMcla
   vuJd49VTNLnhzpaGz1zHu/jNwpFyLEcfrpWrsHUsTNp+BYxAGPb0VX2bN
   CdQHSBKkqoNkvVKTHMfuciTgrFJHi+HrcIY1nuyVw0q2g99n82ffqArGd
   qFyMEGpbBHp6tcEBTOj8sKvKKJ+t+PlgAF3ZpkI1jt+9FDt4zzH06b3or
   E0ob3ZUCEGbsKcbY9+DScWrOs1LlBSvxIjYf2JcOsMnKN5yM1efxAKGwm
   Q==;
IronPort-SDR: crmbY5d3Cf6q+/q23u1PIr48+wRVDVZ4QxNFV2sAYnRy+x+B4Q1TknENip4yMaPNVmSyNVLrnh
 ZdvwkCwxSHDNL7lf7XeIciFGpf6BNo7ml1saiI2EWWVmwnKQL2Cb0YS+tfJem5Rn8wY2cl70ue
 EkGGPFi8f/PgLLBfQKs/wW8EFPtYjXSd4lyO7L6+Om3pdTrD1OR0gHAvcc5IFYScqqtijGjbpr
 8xcra2c9fF9cldlpXo8A85LZwpH95VYaMDOoEph7xaVgxTqCpaXRBcNrQ4gGjG62ePF79bXstO
 Ju8=
X-IronPort-AV: E=Sophos;i="5.79,363,1602572400"; 
   d="scan'208";a="106749679"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jan 2021 02:19:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 02:19:13 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 21 Jan 2021 02:19:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1CQ8u63tvfL4Ma/XbtHFUmos0gcNSye4n2MHym1Uc9ZEhJ8D55uyk+eTjB0AXrICpWCAZ9KCP3wMTcrt3intMOnGSPXJnHP29P7RUvDLgPxNeejAT9Co/5zz8l42tzX+RTKNJjsQ6e/ecsW7FvI2uxuTOLOnDewQ9kQituqcm9w7gOlXAjtz8wyRb3T8pKku3/8TTd7Kkke/n6NcC1rury5d9f/RZoLqdpYN2Mv/TqqAT4QW/FuoD5YR2cX1PBwDrDruWIJv+5hLoSQ446+A4v/ey3e+vN3mfLVAbxuzLMvQ2j4seZwwccTGrJQP+kSgTHYErqS53LoZ+Gqm9ofCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88I2XL0f6c44qJXiPw9Wm8rVJQHGd2JS2SkcbySpqCs=;
 b=Rt+5M+EnuwVfg2ClDoPl630e41IHDuac6M2zoW3RmD3yJOI7tsCQvbrBOTgjF7Drj+GFCDTUlVgyrgjwyn3DOxb+GAVqHlSqlo9Ohb0DLNrZ8Y6PO0Y34Q/ONoZ61cI/9EFx8TkmENLugRzkkCX1tfyd8KvpOyqvD51ewPJbHYekQw2cHlSWtBOll3a5dIKPw9KExQCD/PvPDTM73L3nZ4YUt2yUlumN0NpoLpigqqMJj89BwWCMmZtfsnyIagasdis8muXwt0VhyF46MtP0ZN68AaZqcFSK2M4RRy/fLg67DYCed9ckSg0ySzGQY58bulzuW1VTLOBgukqoJsv7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88I2XL0f6c44qJXiPw9Wm8rVJQHGd2JS2SkcbySpqCs=;
 b=kFhKLqPj//SX/yHxfg49a1NtQ1ZZMohP0NbuKUntpfkl4TB2V1uhQd37m7/DHEXC/hxGpIqmNPheD3agk5Wd54ZFqomlUMYUXzNuX/fG6IK6zm27oplbh145L/d9ZPr9Ou6zdrRfjH+UBe5uepIIOQMJGu+nPQ9UjjVTyV/fp3s=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB3146.namprd11.prod.outlook.com (2603:10b6:5:67::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.14; Thu, 21 Jan 2021 09:19:12 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 09:19:12 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <michael@walle.cc>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Topic: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Index: AQHW79Z6nzNG5V5dqke5o+L2S+jLWw==
Date:   Thu, 21 Jan 2021 09:19:12 +0000
Message-ID: <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
In-Reply-To: <20210120194303.28268-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.76.227.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e521d6ad-17a8-4ac2-75b7-08d8bded9dda
x-ms-traffictypediagnostic: DM6PR11MB3146:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB314678A61100796852BCA3DC87A10@DM6PR11MB3146.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EdqPneuC0EhMw/YulyysWRv+u7aCs4WK17O1VEr4DdRZmU7Jp+of+86fmTW3XqstODgVm6bPnKs9R9DU8dyhsn3Z6v70BdICkKdSRo9nUU5wAOLEoNtzJA7PlAkBnfqaXI77F6yodOy27+CFUptqsV3YLTDdDrsiRc1495ttqv6SgOZRf3I3+Lj5AsmXfQJfuDtZoXSoG68g02ywwPYg83XRyE0pQk/fj/wofMDMRHOc3q+2IVons3geUNmM+Pk/jl9/S3q1Aw+p9+X5SLLtaFuFRwVm0LGhiDl2bg4CiIGqnPQRq3JXrc+A13PFXGFo/AIoC1oyDBD4Aao5r8Tu5GsBR3eG9PQtpzLV3CRaDmME2/PcRFHezPRaOOlx1NBxFLCdsN9UCA+QseufZ3rHksVI78o0EcHlkSEtk4YqfXq7OsMhHa9XIx2HYkaVEzFc31xB9zjTB66uNPA4250qpJEJhHThurOJx6WJ7RsXIQ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(76116006)(66556008)(8676002)(66476007)(64756008)(66446008)(316002)(2906002)(4326008)(6512007)(71200400001)(8936002)(91956017)(110136005)(66946007)(6486002)(478600001)(5660300002)(2616005)(31696002)(31686004)(186003)(83380400001)(53546011)(6506007)(54906003)(86362001)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bEM1SnVGcDRjYmxwZnVYLzd1TDJObm9EbU1HS2h4QW4wdVVzQ2hzbEdXdjBo?=
 =?utf-8?B?M3lOWmpLM0thakE4UFhCZVl4QUJSZEN2Qll2TkQ3RnEvd0Q4ZDlNQVNxamk3?=
 =?utf-8?B?Uzk4azJKNUk2T3J5Z1k3bU5MaHhrUnlvd245MUtjQWFWVXE3dTF1TlZlWita?=
 =?utf-8?B?bFFoNVI4eU96dEVEa2hoRDJDajhXd2Z1cmprNTFpK2M2ZjFIbndrWXBZYXZU?=
 =?utf-8?B?QUxVR1ZYZW9GdnpOQ3dZZnhEUkQ0VTN5YTJLSWlLQlpJejJPMXM5L0R1Sy9J?=
 =?utf-8?B?a0pndXBFc2hRRk0rT0VudCtpQVZ2dGNrZFg1U2Mza0lvN1BmcnNXQW9BUE13?=
 =?utf-8?B?d05oQzdRMWhCVE9iZ3NGRC9TbG5HeENMQUlSOVpKazgxWnlaMmR3bjZBd1I2?=
 =?utf-8?B?Z3JodTFlMmx0QzNxVUJLTW9wSnc5dDFLeU1CR0tBUlJTMDRDM1Z4QUVDU1VO?=
 =?utf-8?B?cXRwSkZtc0RrbFRxNk8zUDNJUFZoczJDNDVyR3V1Z2VQVVBSa2lnQjkwK2U5?=
 =?utf-8?B?K1hQNHNvYmpQZHlISHp2Vm9GRUg5Ny9lM1l3dkt3M1ZudFJuN3grTndvL2Rq?=
 =?utf-8?B?bVg3YTUwKyt4dmp1ZnlRR3hWMzViY1ovbURrTUhPbU9pTWh6UU9sUzNCeGN1?=
 =?utf-8?B?cjNTMnZRODFxSCt3R0ZHbTA0VVh4Yyt5bGh1bzgrQTRFR3ZJWFQxTyswS3Q3?=
 =?utf-8?B?K2hZSHpPQ1hqOGNnT2NwR1N5cWhlUEdxWWVBS2RxWkszLzZDM09ZeEhEWlJI?=
 =?utf-8?B?cTFBRExpVGNtOG80cnZzNW1YcFFpNkw3YkhqY1J6em9OWG5MM0gweEV1ZmMr?=
 =?utf-8?B?QVJDYWNRc25VU1l2S01mUU96ckRCYU1tRW44RktwN3Z5TGdBdlZZUElNNXN2?=
 =?utf-8?B?Q0l3bHpGUmVMUUFnUmE3TXdOZnRhVzB3eW11SGw3MzlpbWZ6UlhxT2xqS0oy?=
 =?utf-8?B?SU43Y2wvdi9PVTZrQTAzeFkvTHJuWEJJSG9uNTZRUkxUVHArLzMwYysxQVRy?=
 =?utf-8?B?cUhBNjVsTzZHZGlDTmZwVVYvcjJYaVZQS0NMNzg2V3JUQnVGK0dWeWRlSXNa?=
 =?utf-8?B?TkpQK1F2V1luR2UxQmZwbjI5WHpsTW15aGcwRnN5cVdlSDBWTzdTYUFDZ3Rz?=
 =?utf-8?B?RDRINUFMQU5YYU9SenpDSWZsb3pvcVJsMmZYQXhqeVJFTm94U05jNjUwS3pt?=
 =?utf-8?B?ZG9rTnpGZ2xCMjNFNFIzMEMvREtnc1h4QzRDSTRtNHFOWlJQTzFrNElRVFlT?=
 =?utf-8?B?aGxUUTI3U3RkZHBsU3R1MW1RZjVZSWFjenpMbWNGVHhNbmNubEhKZzlrOGt3?=
 =?utf-8?Q?WKQV+Cup4gIBL3ZH5deQc6fZy7UNYAlXjY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47B3582D6A0B6546A3D414B15B242D61@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e521d6ad-17a8-4ac2-75b7-08d8bded9dda
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 09:19:12.5044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 428w5PukX2DoyrdfnyVhmP382yvwTCGuU5ugOHDvuzWfimE+nihcpQQwm4lDXHzIRaHdRfxKVuCrGhGQYWAXM1jSEalZnid7FQTC2G2/REU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWljaGFlbCwNCg0KT24gMjAuMDEuMjAyMSAyMTo0MywgTWljaGFlbCBXYWxsZSB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBJZiB0aGUgTUlJIGlu
dGVyZmFjZSBpcyB1c2VkLCB0aGUgUEhZIGlzIHRoZSBjbG9jayBtYXN0ZXIsIHRodXMgZG9uJ3QN
Cj4gc2V0IHRoZSBjbG9jayByYXRlLiBPbiBaeW5xLTcwMDAsIHRoaXMgd2lsbCBwcmV2ZW50IHRo
ZSBmb2xsb3dpbmcNCj4gd2FybmluZzoNCj4gICBtYWNiIGUwMDBiMDAwLmV0aGVybmV0IGV0aDA6
IHVuYWJsZSB0byBnZW5lcmF0ZSB0YXJnZXQgZnJlcXVlbmN5OiAyNTAwMDAwMCBIeg0KPiANCg0K
U2luY2UgaW4gdGhpcyBjYXNlIHRoZSBQSFkgcHJvdmlkZXMgdGhlIFRYIGNsb2NrIGFuZCBpdCBw
cm92aWRlcyB0aGUgcHJvcGVyDQpyYXRlIGJhc2VkIG9uIGxpbmsgc3BlZWQsIHRoZSBNQUNCIGRy
aXZlciBzaG91bGQgbm90IGhhbmRsZSB0aGUgYnAtPnR4X2Nsaw0KYXQgYWxsIChNQUNCIGRyaXZl
ciB1c2VzIHRoaXMgY2xvY2sgb25seSBmb3Igc2V0dGluZyB0aGUgcHJvcGVyIHJhdGUgb24gaXQN
CmJhc2VkIG9uIGxpbmsgc3BlZWQpLiBTbywgSSBiZWxpZXZlIHRoZSBwcm9wZXIgZml4IHdvdWxk
IGJlIHRvIG5vdCBwYXNzIHRoZQ0KdHhfY2xrIGF0IGFsbCBpbiBkZXZpY2UgdHJlZS4gVGhpcyBj
bG9jayBpcyBvcHRpb25hbCBmb3IgTUFDQiBkcml2ZXIuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUg
QmV6bmVhDQoNCj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBXYWxsZSA8bWljaGFlbEB3YWxsZS5j
Yz4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwg
NCArKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggODE0YTViMTAxNDFkLi40
NzJiZjhmMjIwYmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYw0KPiBAQCAtNDcwLDYgKzQ3MCwxMCBAQCBzdGF0aWMgdm9pZCBtYWNiX3NldF90eF9jbGso
c3RydWN0IG1hY2IgKmJwLCBpbnQgc3BlZWQpDQo+ICAgICAgICAgaWYgKCFicC0+dHhfY2xrIHx8
IChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19DTEtfSFdfQ0hHKSkNCj4gICAgICAgICAgICAgICAgIHJl
dHVybjsNCj4gDQo+ICsgICAgICAgLyogSW4gY2FzZSBvZiBNSUkgdGhlIFBIWSBpcyB0aGUgY2xv
Y2sgbWFzdGVyICovDQo+ICsgICAgICAgaWYgKGJwLT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV9NSUkpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICsNCj4gICAgICAg
ICBzd2l0Y2ggKHNwZWVkKSB7DQo+ICAgICAgICAgY2FzZSBTUEVFRF8xMDoNCj4gICAgICAgICAg
ICAgICAgIHJhdGUgPSAyNTAwMDAwOw0KPiAtLQ0KPiAyLjIwLjENCj4g
