Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AF82C8F97
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgK3VCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:02:37 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:38934 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387486AbgK3VCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 16:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606770156; x=1638306156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0gRwv1EA7q/OJNZlF26lMQda+h21JWkIGjBk9JPUecg=;
  b=Nk4XmxFrE2GFALuxVDD7ObBjYrWbjHOdN/pqb9mZ2QBsvq/84eLWvB76
   u8nEO1k26FtMNUQ3a4eVo2HukgRqgfarg2KhcdjrJrU8WwUyR+1NYpHWP
   u44piJ1cuN5ITDIcVxhAqWlgvVTzveSjcbiOvcr7WsONULYr3XgH69knq
   rF7HHKMkXi0IV0BnhVJ5izY+yAQBP8I2u8nUVD+4RRA1RRrb0UUDGzDYv
   V8q/4S0hai2F5jGRBWOTN6fyeez1nSDUcJ0b689NvHLeTDMl7vGzWVPp7
   Ag6h6M3hSwLQ2D7exdup6+PD0kQjOj5OSLumEUHCgl8WlB2BiWXwgRd5h
   w==;
IronPort-SDR: QQIobEcERKA+Zthplu2QfLcwt9PLsiQow8b4C/monER2iAbGHqvxW60GetIpRxYFKb4qphglW7
 zXHZlQ+6pgGTlnBdHTRL41rrPGCzHK9wXvjiOfdmW1smFMjsVvMN/0O83E8aEsFtrqi6s5OCfV
 wsFfBcj+svo59Pi+ttL1LIvDECGHHvyxGAUqdAMqVMB0Zm1HtVKOOjpCo4h4kFPFT+2tL+IMBV
 itAHrVKEIFteKmQddB1xYJ6MNku9AECcW+9Lr7RwNLcCU0zzu9/WCEIB+uoej2WAm8tADMYydl
 H5A=
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="105547283"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 14:01:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 14:01:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 14:01:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUwtW0dF3r72u4UwfTwGa1rp366ZIxNAi8kHhQbT6em0B07MS2JdOAzuO/5AfFi2sTEt+ULYq11coofIH81vPKItxNEhKtxH+DmheZ7NIIgeOYZawlYzAVCosUQHXbblQ4/Ndg7273ECn5VqntiaCZM7kay8Qjqlfl2W52TVhD+vGhHZ6GEDcnTDk0f74OzYWguDzemECfXb5qjckLtHZR8Wkl4jOs6wW0SmCytiuTwrshlqtMVuVxdKcbzb6fb0bUEG0ks7jDfbHtPCYdPnm/fvhpHMMY9QvQyY+r85JMJjJz64cajQDNOHrRYGz4SFxflFNUETSX6ps6vgPQKVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gRwv1EA7q/OJNZlF26lMQda+h21JWkIGjBk9JPUecg=;
 b=DpPQSj8pHfYKqrWnwwCQSFqb6vVrCwbuo3U9VIvOjZakMuE6MzGVCB1QLaTUZB4EMRUGHwrtXldzchHgqgy97IVARIb32gz22m3ouFrBYInv5Lx/1Qo9xqKvnRktzVyiMbHrgspw/5KEL/HqbxkmmD4MO6Mp8aQw4z/oA3EhNlOvSj0a+gFvH7zsWANwHNng5D4qThpW5E/0IJO2ufKbgBv1XNO6+YZiKSCFhgjXErRIoL+S8AUXr2tMJaEd841DbXM/J16v9lquNI7cW+d/w1eL9/PbjQ7uGVxIvbv2pjMGoCt3ndT4nbU2B2IksrASwzEKquuqgOf+fijlTmZguw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gRwv1EA7q/OJNZlF26lMQda+h21JWkIGjBk9JPUecg=;
 b=fV2BSzf8OBMVvqtJh5TzfdEXkiF5IsZUewqJ3MgoWrq4X6FQ+gyC7s53I02AhiCexCgmCXlcffUWQFlPkCugfJ1Qzf2I4Z13l4zn3csk3BvtDM7ykB64RfxcYlHqdQJ+vXAq5cYfPgaAPoOiSRWUgonSBBb5ZgA6OonNvKPvULk=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 30 Nov
 2020 21:01:26 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::ddf8:d2b5:c453:4ad8%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 21:01:25 +0000
From:   <Tristram.Ha@microchip.com>
To:     <ceggers@arri.de>
CC:     <olteanv@gmail.com>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <richardcochran@gmail.com>, <robh+dt@kernel.org>,
        <vivien.didelot@gmail.com>, <davem@davemloft.net>,
        <kurt.kanzenbach@linutronix.de>, <george.mccollister@gmail.com>,
        <marex@denx.de>, <helmut.grohne@intenta.de>,
        <pbarker@konsulko.com>, <Codrin.Ciubotariu@microchip.com>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Thread-Topic: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Thread-Index: AQHWvenhDxym6cdhMkevUTN+Ss+rxqnOjIQAgABhLACAANQCsIAJoMWAgAFK74CABoSacA==
Date:   Mon, 30 Nov 2020 21:01:25 +0000
Message-ID: <BYAPR11MB355857CFE8E9DA29BDAA900AECF50@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201118203013.5077-1-ceggers@arri.de>
 <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
 <3569829.EPWo3g8d0Q@n95hx1g2> <12878838.xADNQ6XqJ4@n95hx1g2>
In-Reply-To: <12878838.xADNQ6XqJ4@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arri.de; dkim=none (message not signed)
 header.d=none;arri.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [99.25.38.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37b4ce72-1974-492d-c438-08d8957319ce
x-ms-traffictypediagnostic: SJ0PR11MB4814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB48140A9CC111F7508E16F7D4ECF50@SJ0PR11MB4814.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zFPW7cdSTivPNHgAxgJLXkm62tovxSOXUm21mdVqSCwyrFT8uMivQl44hO4ceipb9BzCYD/m/savD3dHIqJZuNNycfg9k+p0jtj3gd3tGLCCsLxruUpnqJqzYeEdq8BjruIVrdRg3xxn9aPGQVuQNr3hcvk2aEecceU5Xcb4kWEW80iLpx5MW1+xPTWJs3EfC4G4lIcczq2jtNr9Mraj49TIvUlhLYk6K5GUOdfqErgFvImv9PeXqwirJq7nf6SAO5YGQPK7dp9LR3r3dD6N8DtEraHA0gWrbOuvLppkWTqrTsf0D5WaTKOuH80oMADhefqTkTgWWiXccd+fNFAKzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(366004)(136003)(5660300002)(9686003)(186003)(478600001)(71200400001)(33656002)(55016002)(83380400001)(7416002)(8936002)(316002)(54906003)(6916009)(6506007)(2906002)(8676002)(26005)(86362001)(76116006)(66946007)(4326008)(66476007)(66446008)(64756008)(66556008)(52536014)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bG81NTNMZHlrY1VvMXozd1NYVEZ5TXJKekdoQ0JpKzJTUlhCZC96QWdkOHVV?=
 =?utf-8?B?TmZXNVJxUWtPcTl4V25pWlpEekNGTVh3MVJFODRoZkVDWGRZbm5IejRuemJ6?=
 =?utf-8?B?ZTc5bllvYmlhU1RPMmZxTDg5TG50MStKb1Q3WkZYOERMOVM0aDhOd0J6RFRy?=
 =?utf-8?B?T1FjR0dyZ3NHYi82QytpUHVCcElRVi9LSVgrWkhYT1hiaCtSeERzMi9MZW8y?=
 =?utf-8?B?Qkk0dTcxZndlb251MHZsMjlJR3RUdk9zdGVqNXNjOVk5blkvbU1ocWxZZ1R3?=
 =?utf-8?B?UkNzdzE5MkgyUytESWs1dHV2U01EeEdtdmRXSjg5NGxIK2VucDE1M2xZZGpP?=
 =?utf-8?B?VS83TDMrUjRqdXJOQ3VJSFlvdmZEdXRmc3dNdldPMjJDeUJUZXZZVWtWcEhh?=
 =?utf-8?B?dlRrQzRsdDBQNnBIdUhJZG42Ui9zb0srMXMxY0RabWxmMXdITkFFZ0Rxb2NL?=
 =?utf-8?B?SHdUMzQ4OVlUTUQ2SUlqTDFXTUxkKzVyRENCK2Z2blBjbThIamFRSTNzZDJD?=
 =?utf-8?B?eC9aOHFkbXVQYXJVM3NxZmhVUEZ6Vm54TXFJdkxSeUVsTjQvWm05K3I4S3Qw?=
 =?utf-8?B?dnRJRzRKQTNsZWZoNHhZQUU3RDhMYmdONjdSekRvNk9DUlRCeWF3SS9xT2Rn?=
 =?utf-8?B?a0ZVQ0EwVkJKZEJRdHdCZmFVWUlkSUR6aXZKcER3NmVsQjU0a3lUQmNTWitO?=
 =?utf-8?B?dU1jbk53akQvZllhc25IRXlEbG5LVkQ3bGgwQU9TTjNMZ3Z1UU8wVnk0NlZt?=
 =?utf-8?B?dWJvd0Zncjg5TjlDcjlPWkNMNGRyejFuQUJSM1B3eDJQZDV6KzdEb0dPTHkx?=
 =?utf-8?B?dHEzRHRPa2tWb1JvdEJBVHVSR3NJUzE3L0VWOHczVjlORGltdFFwU2NycEVB?=
 =?utf-8?B?YllEaDFKVTlkemgremJqUjVqbXJJd2I2a091eVRmUUI0eFY5WncrdjBKL1Aw?=
 =?utf-8?B?TTlEYThGeWQwTXVpUmN2YndDSk9Nd3ZVYVJGMG5ReXpGSUMyd3JCUEs0WE13?=
 =?utf-8?B?cmFjbTJwYmVyUUJtQzFmOGg2bFN1cjcyYndla0l4emxxUlB3a2JGbUFIUnhE?=
 =?utf-8?B?bHQyVnJ6MG04RE01Q1NFeWw0ZWVJcGQ0aGV1aktZTzYrZ0krV3QrRXVwRkJ2?=
 =?utf-8?B?Mm9BdmNtTm1PWGF1cFdkUG9mZWtiWC9haHgwbFpvQVpZZUc5OGZRTGt0Wmxm?=
 =?utf-8?B?blFXanJTTyszUlM3elFXaENub0RLbi9GYTQzd21lMmF3UWNDTFpGaW9DRFVk?=
 =?utf-8?B?emFFTFk1Z1BOaDYvL3JaSzRpNDRPQXlmNVNLSmFKbEdoeW5Bc2RFRGdXTDlz?=
 =?utf-8?Q?MmzykiwaF6Bw8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b4ce72-1974-492d-c438-08d8957319ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 21:01:25.8784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6c3oetXS7DJ4iPEQZkpyqkDYshgZzNgHUigg+zYaqhStw3Mp2BbQB+T1sajIpQd3518HPHDrHt5uh/xhb95/TAiO/ylop5WxzAJZvNq+tX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBIaSBNaWNyb2NoaXAsDQo+IA0KPiBhcyBBQ0wgYmFzZWQgYmxvY2tpbmcgb2YgUFRQIHRyYWZm
aWMgc2VlbXMgbm90IHRvIHdvcmssIEkgdHJpZWQgdG8gaW5zdGFsbCBNQUMNCj4gYmFzZWQgc3Rh
dGljIGxvb2t1cCBydWxlcyBvbiB0aGUgc3dpdGNoIEkgc3VjY2Vzc2Z1bGx5IG1hbmFnZWQgdG8g
YmxvY2sgb3RoZXINCj4gbm9uLVBUUCB0cmFmZmljLCBidXQgZm9yIFBUUCB0aGUgbG9va3VwIHRh
YmxlIGVudHJ5IChzZWUgYmVsb3cpIHNlZW1zIG5vdCB0bw0KPiB3b3JrLiBJbmNvbWluZyBTWU5D
IG1lc3NhZ2VzIG9uIHBvcnQgYXJlIHN0aWxsIGZvcndhcmRlZCB0byBwb3J0IDIuDQo+IA0KPiBU
aGUgdGFibGUgZW50cnkgaXMgYmFzZWQgb24gdGhlIG11bHRpY2FzdCBNQUMgdXNlZCBmb3IgUFRQ
LiBXaXRoIFBUUA0KPiBkb21haW5zIT0wDQo+IHRoZXJlIGNvdWxkIGJlIDEyOCBwb3NzaWJsZSBN
QUMgYWRkcmVzc2VzIHRoYXQgbmVlZHMgdG8gYmxvY2tlZCAoYnV0IHRoZQ0KPiBzd2l0Y2gNCj4g
aGFzIG9ubHkgMTYgZW50cmllcyBpbiB0aGUgc3RhdGljIHRhYmxlKS4gSXMgdGhlcmUgYW55IHdh
eSB0byBibG9jayB0aGUgd2hvbGUNCj4gUFRQIG11bHRpY2FzdCBhZGRyZXNzIHJhbmdlICgwMTow
MDo1RTowMDowMTo4MS0wMTowMDo1RTowMDowMTpmZik/IFRoZSBkYXRhDQo+IHNoZWV0DQo+IG1l
bnRpb25zIHRoYXQgdGhlIHN0YXRpYyBhZGRyZXNzIHRhYmxlIGNhbiBiZSB1c2VkIGZvciBtdWx0
aWNhc3QgYWRkcmVzc2VzLA0KPiBzbyB0aGVyZSBzaG91bGQgYmUgYSB3YXkuDQo+IA0KPiBBbHRl
cm5hdGl2ZWx5LCBpcyB0aGVyZSBhIGhpZGRlbiAiZGlzYWJsZSBUQyIgc2V0dGluZyB3aGljaCBk
aXNhYmxlcyB0aGUNCj4gdHJhbnNwYXJlbnQgY2xvY2sgZW50aXJlbHk/DQoNClRoZSAxNTg4IFBU
UCBlbmdpbmUgaW4gdGhlIEtTWiBzd2l0Y2hlcyB3YXMgZGVzaWduZWQgdG8gYmUgY29udHJvbGxl
ZCBjbG9zZWx5IGJ5DQphIFBUUCBzdGFjaywgc28gaXQgaXMgYSBsaXR0bGUgZGlmZmljdWx0IHRv
IHVzZSB3aGVuIHRoZXJlIGlzIGEgbGF5ZXIgb2Yga2VybmVsIHN1cHBvcnQNCmJldHdlZW4gdGhl
IGFwcGxpY2F0aW9uIGFuZCB0aGUgZHJpdmVyLg0KDQpUaGUgZGVmYXVsdCBtb2RlIHRvIHVzZSBz
aG91bGQgYmUgMS1zdGVwIEUyRSB3aGVyZSB0aGUgc3dpdGNoIGFjdHMgYXMgYW4gRTJFDQpUcmFu
c3BhcmVudCBDbG9jay4NCg0KVGhlIDE2LWJpdCByZWdpc3RlciAweDUxNCBzcGVjaWZpZXMgdGhl
IGJhc2ljIG9wZXJhdGlvbiBtb2RlIG9mIHRoZSBzd2l0Y2guDQoNCkJpdCAwIGlzIGZvciAxLXN0
ZXAgY2xvY2sgbW9kZS4NCkJpdCAxIGlzIGZvciBtYXN0ZXIgbW9kZSwgd2hpY2ggc2hvdWxkIGJl
IG9mZiB3aGVuIHRoZSBjbG9jayBpcyBhY3RpbmcgYXMgYSBtYXN0ZXIuDQpCaXQgMiBpcyBmb3Ig
UDJQIG1vZGUuDQpCaXQgNyBzdG9wcyB0aGUgYXV0b21hdGljIGZvcndhcmRpbmcgYW5kIGV2ZXJ5
IFBUUCBtZXNzYWdlIGdvZXMgdG8gdGhlIGhvc3QgcG9ydC4NClRoaXMgaXMgdGhlIG1vZGUgdG8g
dXNlIHdoZW4gdGhlIHN3aXRjaCBhY3RzIGFzIGEgQm91bmRhcnkgQ2xvY2sgb3IgMi1zdGVwIENs
b2NrLg0KDQpXaGVuIG1hc3RlciBtb2RlIGlzIG9uIERlbGF5X1Jlc3Agd2lsbCBub3QgYmUgZm9y
d2FyZGVkIHRvIHRoZSBob3N0IHBvcnQuDQpXaGVuIG1hc3RlciBtb2RlIGlzIG9mZiBEZWxheV9S
ZXEgd2lsbCBub3QgYmUgZm9yd2FyZGVkIHRvIHRoZSBob3N0IHBvcnQuDQoNCldoZW4gUDJQIG1v
ZGUgaXMgb2ZmIFBkZWxheV9SZXEvUGRlbGF5X1Jlc3AvUGRlbGF5X1Jlc3BfRm9sbG93X1VwIHdp
bGwgbm90DQpiZSBmb3J3YXJkZWQgdG8gdGhlIGhvc3QgcG9ydC4NCldoZW4gUDJQIG1vZGUgaXMg
b24gdGhvc2UgbWVzc2FnZXMgY2FuIGJlIHNlbnQgYW5kIHJlY2VpdmVkIGV2ZW4gdGhvdWdoIHRo
ZSBwb3J0DQpJcyBjbG9zZWQgZm9yIG5vcm1hbCBjb21tdW5pY2F0aW9uLg0KDQpCaXQgNSByZWNv
Z25pemVzIEwyIFBUUCBtZXNzYWdlcyBhbmQgdGhlIHN3aXRjaCBhY3RzIGFjY29yZGluZ2x5Lg0K
Qml0IDQgaXMgZm9yIFVEUHY0IHdoaWxlIGJpdCAzIGlzIGZvciBVRFB2Ni4NCg0KSXQgaXMgcmF0
aGVyIHBvaW50bGVzcyB0byBhY3RpdmVseSBmaWx0ZXIgY2VydGFpbiBQVFAgbWVzc2FnZXMgdGhy
b3VnaCBvdGhlciBtZWFucy4NCkl0IGlzIGJldHRlciB0byBsZWF2ZSB0aGUga2VybmVsIFBUUCBy
ZWNlaXZlIGZpbHRlciBhcyBjb2Fyc2UgYXMgcG9zc2libGUuDQoNCldoZW4gdXNpbmcgUDJQIGlu
IDEtc3RlcCBjbG9jayBtb2RlIHRoZSBwb3J0IGlkIGluIHRoZSBQVFAgaGVhZGVyIGlzIGF1dG9t
YXRpY2FsbHkNCmNoYW5nZWQgYnkgaGFyZHdhcmUgdG8gYmUgdGhlIHNhbWUgYXMgdGhlIHJlYWwg
cG9ydCwgc28gaXQgaXMgdXNlbGVzcyB0byBhcmJpdHJhcmlseQ0KdXNlIGEgZGlmZmVyZW50IHBv
cnQgaWQuICBUaGUgb3JpZ2luYWwgaW50ZW50IGlzIHRvIHNlbmQgMSBQZGVsYXlfUmVxIGFuZCBy
ZWNlaXZlDQpzZXZlcmFsIFBkZWxheV9SZXNwIGluIGVhY2ggcG9ydC4NCg0KVGhlIGNhbGN1bGF0
ZWQgcGVlciBkZWxheSBmcm9tIHRoZSBwb3J0IG5lZWRzIHRvIGJlIHByb2dyYW1tZWQgdG8gdGhl
IHBvcnQNCnJlZ2lzdGVyIHNvIHRoYXQgdGhlIFN5bmMgbWVzc2FnZSBjYW4gYmUgY29tcGVuc2F0
ZWQgY29ycmVjdGx5IHdoaWxlIGl0IHRyYXZlbHMNCnRocm91Z2ggdGhlIHN3aXRjaGVzLiAgVGhp
cyBwb3NlcyBhIHByb2JsZW0gYXMgdGhlIGRyaXZlciBub3JtYWxseSBkb2VzIG5vdCBkbyB0aGUN
CmNhbGN1bGF0aW9uLg0KDQpUaGUgMi1zdGVwIGNsb2NrIG1vZGUgYXZvaWRzIHNvbWUgb2YgdGhl
IG1lbnRpb25lZCBpc3N1ZXMuICBIb3dldmVyIHRoZXJlIGFyZSBzb21lDQpoYXJkd2FyZSBidWdz
IGFzc29jaWF0ZWQgd2l0aCB0aGlzIG9wZXJhdGlvbiBtb2RlIGFuZCBpdCBpcyBub3QgcmVjb21t
ZW5kZWQgdG8gdXNlLg0KDQpGb3Igc29tZSBwcm9maWxlcyB0aGF0IHJlcXVpcmUgMi1zdGVwIG9w
ZXJhdGlvbiBsaWtlIGdQVFAgdGhlcmUgYXJlIHdheXMgdG8gd29ya2Fyb3VuZC4NCg0KRm9yIFN5
bmMgaXQgaXMgcXVpdGUgc2ltcGxlIHRvIHNlbmQgRm9sbG93X1VwIGFmdGVyIGl0IGV2ZW4gdGhv
dWdoIHRoZSBTeW5jIGNvbnRhaW5zIHRoZQ0KdHJhbnNtaXQgdGltZXN0YW1wLiAgVGhlIEZvbGxv
d19VcCBqdXN0IHJlcGVhdHMgdGhhdCBpbmZvcm1hdGlvbi4NCg0KRm9yIDItc3RlcCBQZGVsYXlf
UmVzcCBpdCBpcyBoYXJkZXIgYXMgdGhlIGhhcmR3YXJlIHB1dHMgdGhlIHR1cm5hcm91bmQgdGlt
ZSBpbg0KdGhlIGNvcnJlY3Rpb24gZmllbGQuICBUaGUgZHJpdmVyIHdvcmthcm91bmQgaXMgdG8g
cmVwb3J0IHRoZSB0cmFuc21pdCB0aW1lc3RhbXANCmRpZmZlcmVudGx5IHN1Y2ggdGhhdCBpdCBp
cyB0aGUgc2FtZSBhcyBQZGVsYXlfUmVxIHJlY2VpdmUgdGltZXN0YW1wIHNvIHRoYXQgdGhlIG5l
dA0KY2FsY3VsYXRpb24gb2YgdGhlIHBlZXIgZGVsYXkgaXMganVzdCB0aGUgc2FtZSBhcyByZWNl
aXZpbmcgMS1zdGVwIFBkZWxheV9SZXNwLg0KDQpJIHdpbGwgdHJ5IG15IG93biBpbXBsZW1lbnRh
dGlvbiB0byBzZWUgaG93IHRoZXNlIHN0ZXBzIGNhbiBiZSBkb25lLg0KDQo=
