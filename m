Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA552FFF3D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbhAVJbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:31:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9459 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbhAVJM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611306746; x=1642842746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w4P9syTMTvVhNDSyIrJVjRCmcduLq0W1uJ2o9alCz8E=;
  b=Ba20LUzt/z741FBYm30C64k8JvK7B+PCTbiq/Z7v8OLl46TDOKqIlBrx
   TuHaa26mBw72DKtwDir+0yZlfo8M/NU+LW6bee2Fz6PgezoN0COnGHaBf
   VHTEoJ/7hxs4JdIF65oSDego6f2UKNxs2gGaFEu8/cGN2qkaCybL+neMV
   Niq/ZOrAG5g8uOS8YBosJpVP15AA+SQ4xFKpsLFAthmSiz/CMKEAE8yZp
   NP1/xs5Cr/6LP2SjhI4YMX7NxuuFSeXR08Qy+h9AgpL49ucJk+cLa0ggM
   z+Bg7YzCcv2VId0cCXjQdiPYrmLTBEn329INIUNm3rbks5ZV1TFn7fkew
   A==;
IronPort-SDR: 7XJT/oZi/znXJ00U2QuwD001L1yakaWNheBlnmu18NszlN2I3hSIPHivLdAC9fgKUqVPesvM/X
 9OcaTWI3gKu5n5ojaHCUSLmofq7a48hM4cbn+dPlCcboeRamh6nYCWA+XOdYUtQv40G7nq8qLE
 PHmnJW2vPoYDccchAyozEUt98My7aRqpnqJcRaO4nrz/9anVVBfnPTdvWGOan7Mk/cXgXP88Cq
 6cRnfPKJNAFfkUm+XQwPzn0zXMMWNXaIURa7izVZDCOSrWq1m31W9584jj25hE34rzVB9zY+lw
 rEw=
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="112064559"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jan 2021 02:11:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 02:11:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 22 Jan 2021 02:11:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQtjb8XJ3maGYOXju5ODAw3udwcStZrye+Ab0SuMAENM6iW23nQ0Mq1NPoSTCy67AS7SHVk24NXHL/sRXqW/HMMEgI3U8GTp0+qs6Tuh5zmGjt8bPRiENrCbD/smtURKdNKoBYmqarsQ0MwGiHCpiuyuf87W10svWLQVwH5SxCcUau+2LiqY1CxXpQu/yYoOoI7w4+iUr7fI00+Yi96vDjATOi7T+WaqFeOpIJxihU0x9xprh6mSIS8BqapSLwDi3dC/+krgQZSqndYrLdMhMzx1auwzPlpmn87pTm65ji07XTUmHcDtKyDV4pmRUx5S75kf0OClpalT3DA7ZCCkHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4P9syTMTvVhNDSyIrJVjRCmcduLq0W1uJ2o9alCz8E=;
 b=PpQ6xsDTKe1vsoLaY44KDbbcdLAoE9tUA/VVsQipJy8VdrL9o53EdjI3J0f6gtukEARqyi01PdrrsYTr204C6V7AOuVB9ylIBEugznBAedGptIEw0Mjft5JcWK+3wUTFpukfAESPdQo9OgWRkY2HSETSv7Cksx/bWrJ0611VLflTnG2JxzHXoNGwD0eImmUIrdXUQVSfxX/eSGRMN1DngB1+I+fNoRg2GuzAwNk8D7wzIutweLNS6NsmwpUksEAcUYZ2pZt4jFjWpbHBlh18YBD61XPSwh+c62AGcXbytWGoNDKNmKiddrIvSAaX+vJrKdYDHTdLkJIEZ5NMe0bLmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4P9syTMTvVhNDSyIrJVjRCmcduLq0W1uJ2o9alCz8E=;
 b=hUAf08uQvzVtI3/WaALJAQFMiV3U2ixtu3c6Hhr/YXCHGs/DOYqJbpN3kZmHfaFVx6T77zP8PdKHj/UFc4xheVjTRerjoNmOux99K17UjjMpMeicMttvpOhvPhnrQTIWafAe5phOiZc2H85g/KVi6xD6OoVd4AhUzNovX19dfkA=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB1577.namprd11.prod.outlook.com (2603:10b6:4:a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.12; Fri, 22 Jan 2021 09:10:58 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 09:10:58 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <michael@walle.cc>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Topic: [PATCH] net: macb: ignore tx_clk if MII is used
Thread-Index: AQHW79Z6nzNG5V5dqke5o+L2S+jLWw==
Date:   Fri, 22 Jan 2021 09:10:58 +0000
Message-ID: <1bde9969-8769-726b-02cb-a1fcded0cd74@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
 <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
 <bd029c647db42e05bf1a54d43d601861@walle.cc>
In-Reply-To: <bd029c647db42e05bf1a54d43d601861@walle.cc>
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
x-ms-office365-filtering-correlation-id: 57aef1f7-a0f6-46bd-3fb3-08d8beb5a1d8
x-ms-traffictypediagnostic: DM5PR11MB1577:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1577D76B2D6E18B964A54E4C87A09@DM5PR11MB1577.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Kn69bp9lVBWWNzgViLx107EuTeygkSV+SRLBGRXlKB6u1Mu+O4O7vf+pUFmaY3j1CD2ZzVIFOF6wofpxGYQ91JoAswGq7rc802vJ2GWyQ3PNX4VrvBT2lRtDRuIDRKPMKb0P9NjLeSN18sFZGY5oO2uG2lFOf9b0xRv2Z4YFyURzoEbKXK5DIxighKFAUGFKsnB+zFDDUVq8NQRl9dM2z4iim86jGj7BrSjXRgoU56GSMVRJOVOU8svmoJliS3LNrLBF7Ttz7n7UxqkuUB29NVLLnwJWV69+zJLEXj947D9FDmpq+qZ+szvcuyFOFYrWdk0EGVAyb0AffCcHHyvrPQ1NCrxRbMV23IwA7dqdfKC7ZmtEW8E1kJMBSUvgKlyZuBoAeUPKzlmM41kUQ9yNqmw+jAhMTcmSwgwbvKl4vo9Z1OqkybPfDZW2S7OqgPi0wFidhIARpFFrwNl7gdnJ6/wgi7qoFm/NtBwYPq/CXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(8936002)(8676002)(4326008)(186003)(86362001)(5660300002)(2906002)(316002)(6916009)(478600001)(31686004)(36756003)(54906003)(6512007)(53546011)(6506007)(26005)(91956017)(66556008)(66446008)(64756008)(2616005)(66476007)(6486002)(31696002)(76116006)(71200400001)(66946007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZGlCTE1KdDh3ZzkzYTlTV05hNGsySXBwV2NUR3ZCV2RqU0pTQ0Iva3MzT0FS?=
 =?utf-8?B?U1lOQ201R2xjTFlzQ3BLRXBrdVBBK3o1ZDhRa25DcS9WNlUzcGZqN0VsdkxS?=
 =?utf-8?B?RkNsY0RCd3RGYXdna0YvcFhuTW11enRaMWhFcUlCUk4rVWpobnNUcmR5c2Rk?=
 =?utf-8?B?cjFpa2VKV1JXNEY5Y3U4R0xOK2RSVTR5WVhneDlyYU5hNW9ZVXFoYUh4VnNo?=
 =?utf-8?B?U1l0cXRsd3FqdDV4S2s3T1hMa0ptV1lXakZxeGIwUjl5by9xT1FjdGFTZ2J0?=
 =?utf-8?B?ZG1pR1pEemdUL0xYUnlhV0dHY3pjVWNkOWNFWkd0K1lSWUNqa3pWQ3g4Wkg4?=
 =?utf-8?B?MzhScitzd1cyTTNnRTMzTm90dHFPY2czV1pvdnFvM2JzUWd3YjR3Nlp0QVNs?=
 =?utf-8?B?UUVkazRyeEtuUnVGVUxrZzltRVBhMzVqbDI1UTZXYTVJZmUyNXNOVjE3Y0VQ?=
 =?utf-8?B?NTlJMllQT3U4UEtWeEVVVGxvUWtvTHZ1eTN5ZStJYjkxb0RmUlNPVlJlZzJ2?=
 =?utf-8?B?c2FOTUI1enl6N2g1T3J6eU53cUNBN0Fma0lZeHhPalN0c0ZQd2hkcEwrRm5L?=
 =?utf-8?B?NWk5Y01YaTJVdm0zOGtwZXNnbnJ6Z2RaOStrVWppclZNaHFlVUtOSjgrM3o5?=
 =?utf-8?B?OWNRc3plSDF5c0xZVFh6T0cyQ1VRd0dFbjM0K0NsVDBwNmJrSUk5M0pZVTZE?=
 =?utf-8?B?d0haQjRUV0RweGljb24vbmR6dFR2VmNBeVBGZTNoQkVEeC85NURCQitzYkRw?=
 =?utf-8?B?QktoN0ZHU29zZjBqRXc0S1dqZFBlQUdnNlRESFhndzErQkpHSVVJSjN2MTdX?=
 =?utf-8?B?dUc0NEUrV3Zpc3IyWEN6WkJlSHhFQm9nMXFoeDlyZzdiSEdQQmkzNS9hbzJk?=
 =?utf-8?B?QUp3SjZOUXdFb0JpZ1VqbGRjRjlRMmNaOHZJd2xybEdBQThYL0kwRzg4N2R1?=
 =?utf-8?B?RTZFWmZDdE91dzVaYWRHZFNMVjFVT1lhNEhnNXNTK21ucnl6UVQvTVlyTlNk?=
 =?utf-8?B?SjV3YzE0UzlxSnk0RXl0Q1JpVjlVYmpxVVRqL3hYeWdNZWthRGFVNytsbVkw?=
 =?utf-8?B?OVg1ZlBjV0s3YjRjL25ZNEZ3QmpqZ2dFckpHNUdHUlB5MENrSGV2YlpuOTMw?=
 =?utf-8?B?ZTNpV1hUTHZSWDNSaGxxTnJlQzZLNXVlQWtmQ3Z3UzlJbWg4aUMvV0FDSFJU?=
 =?utf-8?B?bjNFbDBWTUJiVkhzYXZDMUMzT0l0NDJYNWpwR1FSbjdWeUtReEFXTnVxQk9G?=
 =?utf-8?B?Y20zb1NpN3ZrRXhvQkpxbEtsZGRZYVNtbEFXL3BpMmdEMitjb0FHQnAyNllO?=
 =?utf-8?Q?hvulaLvzh3hQE0ahXGu4mCl0YPTNAEo39c?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB4004D703C8EC438B60337CFE1D3F10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57aef1f7-a0f6-46bd-3fb3-08d8beb5a1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 09:10:58.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78x7HnXGIikPHGpMEzjI9KxTnlOKFvF8Y4AksXCuwZmw5XHnbxHvqcOW6vZgxIx+XV5ED2AG1AhUdv9t98jgk56wonT+A3u2dnX5Y50wN9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIxLjAxLjIwMjEgMTE6NDEsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlDQo+IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGkgQ2xhdWRpdSwNCj4gDQo+IEFt
IDIwMjEtMDEtMjEgMTA6MTksIHNjaHJpZWIgQ2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbToN
Cj4+IE9uIDIwLjAxLjIwMjEgMjE6NDMsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+Pj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdw0KPj4+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pg0KPj4+IElmIHRoZSBNSUkgaW50
ZXJmYWNlIGlzIHVzZWQsIHRoZSBQSFkgaXMgdGhlIGNsb2NrIG1hc3RlciwgdGh1cyBkb24ndA0K
Pj4+IHNldCB0aGUgY2xvY2sgcmF0ZS4gT24gWnlucS03MDAwLCB0aGlzIHdpbGwgcHJldmVudCB0
aGUgZm9sbG93aW5nDQo+Pj4gd2FybmluZzoNCj4+PiDCoCBtYWNiIGUwMDBiMDAwLmV0aGVybmV0
IGV0aDA6IHVuYWJsZSB0byBnZW5lcmF0ZSB0YXJnZXQgZnJlcXVlbmN5Og0KPj4+IDI1MDAwMDAw
IEh6DQo+Pj4NCj4+DQo+PiBTaW5jZSBpbiB0aGlzIGNhc2UgdGhlIFBIWSBwcm92aWRlcyB0aGUg
VFggY2xvY2sgYW5kIGl0IHByb3ZpZGVzIHRoZQ0KPj4gcHJvcGVyDQo+PiByYXRlIGJhc2VkIG9u
IGxpbmsgc3BlZWQsIHRoZSBNQUNCIGRyaXZlciBzaG91bGQgbm90IGhhbmRsZSB0aGUNCj4+IGJw
LT50eF9jbGsNCj4+IGF0IGFsbCAoTUFDQiBkcml2ZXIgdXNlcyB0aGlzIGNsb2NrIG9ubHkgZm9y
IHNldHRpbmcgdGhlIHByb3BlciByYXRlIG9uDQo+PiBpdA0KPj4gYmFzZWQgb24gbGluayBzcGVl
ZCkuIFNvLCBJIGJlbGlldmUgdGhlIHByb3BlciBmaXggd291bGQgYmUgdG8gbm90IHBhc3MNCj4+
IHRoZQ0KPj4gdHhfY2xrIGF0IGFsbCBpbiBkZXZpY2UgdHJlZS4gVGhpcyBjbG9jayBpcyBvcHRp
b25hbCBmb3IgTUFDQiBkcml2ZXIuDQo+IA0KPiBUaGFua3MgZm9yIGxvb2tpbmcgaW50byB0aGlz
Lg0KPiANCj4gSSBoYWQgdGhlIHNhbWUgdGhvdWdodC4gQnV0IHNob3VsZG4ndCB0aGUgZHJpdmVy
IGhhbmRsZSB0aGlzIGNhc2UNCj4gZ3JhY2VmdWxseT8NCj4gSSBtZWFuIGl0IGRvZXMga25vdyB0
aGF0IHRoZSBjbG9jayBpc24ndCBuZWVkZWQgYXQgYWxsLg0KDQpDdXJyZW50bHkgaXQgbWF5IGtu
b3dzIHRoYXQgYnkgY2hlY2tpbmcgdGhlIGJwLT50eF9jbGsuIE1vcmVvdmVyIHRoZSBjbG9jaw0K
Y291bGQgYmUgcHJvdmlkZWQgYnkgUEhZIG5vdCBvbmx5IGZvciBNSUkgaW50ZXJmYWNlLg0KDQpN
b3Jlb3ZlciB0aGUgSVAgaGFzIHRoZSBiaXQgInJlZmNsayIgb2YgcmVnaXN0ZXIgYXQgb2Zmc2V0
IDB4YyAodXNlcmlvKQ0KdGhhdCB0ZWxscyBpdCB0byB1c2UgdGhlIGNsb2NrIHByb3ZpZGVkIGJ5
IFBIWSBvciB0byB1c2Ugb25lIGludGVybmFsIHRvDQp0aGUgU29DLiBJZiBhIFNvQyBnZW5lcmF0
ZWQgY2xvY2sgd291bGQgYmUgdXNlZCB0aGUgSVAgbG9naWMgbWF5IGhhdmUgdGhlDQpvcHRpb24g
dG8gZG8gdGhlIHByb3BlciBkaXZpc2lvbiBiYXNlZCBvbiBsaW5rIHNwZWVkIChpZiBJUCBoYXMg
dGhpcyBvcHRpb24NCmVuYWJsZWQgdGhlbiB0aGlzIHNob3VsZCBiZSBzZWxlY3RlZCBpbiBkcml2
ZXIgd2l0aCBjYXBhYmlsaXR5DQpNQUNCX0NBUFNfQ0xLX0hXX0NIRykuDQoNCklmIHRoZSBjbG9j
ayBwcm92aWRlZCBieSB0aGUgUEhZIGlzIHRoZSBvbmUgdG8gYmUgdXNlZCB0aGVuIHRoaXMgaXMN
CnNlbGVjdGVkIHdpdGggY2FwYWJpbGl0eSBNQUNCX0NBUFNfVVNSSU9fSEFTX0NMS0VOLiBTbywg
aWYgdGhlIGNoYW5nZSB5b3UNCnByb3Bvc2VkIGluIHRoaXMgcGF0Y2ggaXMgc3RpbGwgaW1wZXJh
dGl2ZSB0aGVuIGNoZWNraW5nIGZvciB0aGlzDQpjYXBhYmlsaXR5IHdvdWxkIGJlIHRoZSBiZXN0
IGFzIHRoZSBjbG9jayBjb3VsZCBiZSBwcm92aWRlZCBieSBQSFkgbm90IG9ubHkNCmZvciBNSUkg
aW50ZXJmYWNlLg0KDQo+IFVzdXN1YWxseSB0aGF0DQo+IGNsb2NrDQo+IGlzIGRlZmluZWQgaW4g
YSBkZXZpY2UgdHJlZSBpbmNsdWRlLiBTbyB5b3UnZCBoYXZlIHRvIHJlZGVmaW5lIHRoYXQgbm9k
ZQ0KPiBpbg0KPiBhbiBhY3R1YWwgYm9hcmQgZmlsZSB3aGljaCBtZWFucyBkdXBsaWNhdGluZyB0
aGUgb3RoZXIgY2xvY2tzLg0KPiANCj4gLW1pY2hhZWw=
