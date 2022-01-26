Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53AF49C4B3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbiAZHpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:45:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50533 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiAZHpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643183122; x=1674719122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H4vlJB/NXXVIGOrmuSD2FCR1Mm2s/DMDqPTcTlLpzTg=;
  b=LJLqKXHgAvjtkQ/ITKaGZSBDL172ltX+j5IIyvU6u26o6nus0lVVqsxq
   /l+0moMmrqSsnux9Ngq/u+0VnSrDkUwukLDhCIGexPMQA5fC+L9vqLEKl
   qT4gldORSmun+UyhwHUPakt6HgCgfWqStNGGvJl7m1Da0BA8l0BeWY6tJ
   bY76yjilsHHtBBG2DIcfhrLv6Lmmy5gO75HDUoTHUnS8BwioRCdV6nFC8
   B8h1qFLgJPxzUnSQvafyi8BwuMsmXOdSX5A06q2typumrKdT6C8PAVY+m
   wkgidFC/ZiBhWKf5iIChE7h8ICfWyc3vLl2LilscRybyzWzbI5yfJdBGN
   g==;
IronPort-SDR: 685LkMzDtvwgUunIVsCaQ+OHT+WzBSnunKKfZdnxALkPm0GGa7C08kOjr+uH3g8/VaQ++Kxam2
 DzAP13VnaWj6i7S9yttIRDC7CvyzHGlFjyM83HU4EBQjXPhde81RAPyUzbbeI9b67RYJMjk8SD
 CtxaU3AY1RX8u5/8DWOcLH6tIpZijWViTQqw9XLUCfdVo7tHCr82pD/QP9kuNPYm0a1jGO7uke
 w9oCiBNTxG+C8ccqCQMj0f7HpBm2SlJKmcRVOml/8DLdBg0xcMCae4rqhE9BiCyy27byk9XRNj
 AcxiWXMmQE+8RHfEk8pK+bmn
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="160005968"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2022 00:45:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 26 Jan 2022 00:45:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 26 Jan 2022 00:45:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSTZ2bxVUN8st+VuSQwIiiZGBNj2+X6Kt0Z5QSSECwonLlhdycDmpLoon7XfxASecuW8gjJH+3lQNNnBmKkxlY+uxkB0CtnbcpetEO/Svhnv143UbgkasF4GHxMdBLEh7tttybGX+rvNATsFe/uyRLN8iYBcIMuZx/a1WwkLWFtQ+ukfifAP4rrPaAQGsE1h/B7BUkhfMOC5vF9TaEtFL+WQVWE4Efyfbx2yCCILRJRU1l1+hT7StaJHMCi/c0ujHBTJTj9K4Ri/biZS1OIZmuJG0zvIjXxy5J12UDcAInXiroGi3H9986+xh6cMn2wi4KWgdiaW54iKj4AVMmMUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4vlJB/NXXVIGOrmuSD2FCR1Mm2s/DMDqPTcTlLpzTg=;
 b=QnGYbYLJUzLGObX+IlpXw0RO7v3yqtBpnyT/YxC5eGXOtIfoGjngBSkKCo8tz3jAXzgR8gKktmoJCET51ZVIUdrySyUrhP1p6RG/cZUXRvnmayF3NqAG5aYvswB5zk3w1AMAQP0zzenTdfXmr+M/C8Q9/v+9tCFxti6iFXLOdGKar388rubOGC6oX5POCAtdrJkxbY9uKye4Jg+hSMWte6z4O5ugS6bBgia0XDM77vD7kpxq8DHBiT9p7KWBZh/sFg7/M5Wi8Rkhw3Iq0P+igcX0OzeewLZZeWd005m0YX23qkwPF4xQLxNUjLSR8xLraWSwC8O7pWOhmaI9hYxTfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4vlJB/NXXVIGOrmuSD2FCR1Mm2s/DMDqPTcTlLpzTg=;
 b=f3wdrqiR0L3765t16djl2xnT74fZiEPHuGxti+e7x4/6VMDqnXf+Ku6Q1wVZsXOMlCOgCBSwthnzZi1Aq9X3eE65CpSrrn0TgOr4PbbHEpdnIkYsHmwl45mEJsFH6gpS3vuE1nOS1qsGaByD5W8Fbf/gKUsSu+76f4G4cIoM7s8=
Received: from PH0PR11MB4775.namprd11.prod.outlook.com (2603:10b6:510:34::22)
 by MN2PR11MB3725.namprd11.prod.outlook.com (2603:10b6:208:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Wed, 26 Jan
 2022 07:45:11 +0000
Received: from PH0PR11MB4775.namprd11.prod.outlook.com
 ([fe80::4cb3:6dd6:d745:9a83]) by PH0PR11MB4775.namprd11.prod.outlook.com
 ([fe80::4cb3:6dd6:d745:9a83%7]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 07:45:10 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <michal.simek@xilinx.com>, <robert.hancock@calian.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <Nicolas.Ferre@microchip.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Topic: [PATCH net-next v2 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Index: AQHYEoikfq62l4BtRk+7A/8RyPRDwQ==
Date:   Wed, 26 Jan 2022 07:45:10 +0000
Message-ID: <1624a3d8-0986-8931-264f-3b9d1f1ca5fd@microchip.com>
References: <20220125170533.256468-1-robert.hancock@calian.com>
 <20220125170533.256468-3-robert.hancock@calian.com>
 <ad19fcf6-7976-4fd4-bded-97e1021c99cf@xilinx.com>
In-Reply-To: <ad19fcf6-7976-4fd4-bded-97e1021c99cf@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6700f282-2f66-4cae-0acc-08d9e09fc7ec
x-ms-traffictypediagnostic: MN2PR11MB3725:EE_
x-microsoft-antispam-prvs: <MN2PR11MB37257D770525DF6EB8FC12CF87209@MN2PR11MB3725.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFVKWgo7Xmy4kU7vIQlX1EB9NEED95vPRhPfRV6Su4ZFO6vzsua9QXPKiAh5JVr089G1diu0ehKq6u8S3rbT/w5PkOOjRbk2I9P2Mv9xL196nXDOqnqYs4j6BsJ7nwKUo+Zf3cLAt3zg1bKGkOsCsgQEkfJ/RSbD5epeAo3xuNPHUtU0xYkMOr22OVm4dDAIWiNbUNlMnCBFTjdDwWUgRewh7UEotfzUm6HZfscw8K8oLfTXZZdB3AGL9C0kksCgUsWOgKPlPeZzmvoW4pQj3gx2DXEqisb8gT1RCqmfaBYkBvHZvoI1yUGwkIrhOgedqtH41WRCFVQAa9NsaVVWi1X8cwARBBgBG6zSK6YSio21y2bdOqBR2bc7+/BdtDWDmuKhwtYJwYi1rULmZ+mELJ8T86oZU1s/1WDZbobQzJgQcFrGPeHfkCjZzZQtB4bPlqQ4L7OTrtyP2Yno4VPfdzRvQjjWhY7TFgvAw/xKjwphX8xZdXcWF/dRfHfhRcM7BgJQ186WgGwLCeQO0FuSblt4uceunzn2nkvxH04PwVOMVIh563AmmAxzMVdCTVRnShX/CjYKKG04d5Lyl/YY2a1FmuXGA1hrAPKJd2RaICV9cJCr4c2Tden482L8UOKbcOhr1bbQlhLR9IW7vwtk4zBEfYhdu5+8ezj8/PQGivK6xGRBmJGT0reKWZCJl4k+uqJudyadYzMr+zNtdcC179quPyLCGAO2Q3lTxVwQ349Xs6wLqyeT6+WzaGNw5A1wMjci//2P4xAafBxKkYM3eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(64756008)(66476007)(66946007)(83380400001)(8936002)(71200400001)(38070700005)(6506007)(508600001)(53546011)(2906002)(8676002)(26005)(38100700002)(186003)(122000001)(91956017)(76116006)(6512007)(110136005)(54906003)(316002)(86362001)(2616005)(6486002)(5660300002)(66446008)(31696002)(31686004)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlkvVkxIQ1JldG1nMmFQWW1IMklCTWNEYnFkMUhOWWdWbGRjcnlRdnBNQjdu?=
 =?utf-8?B?dFJaTzAraHFJdHg1YUdUZ3hqWXh0MnprMEVoWG1jSDllSlY1Y0tyNThzeGVT?=
 =?utf-8?B?cWNaUEhvM2QxWUhEbWdML25xSVZjVlJNMElONGhJVEFXc3pTRktXdTJGUmh4?=
 =?utf-8?B?RU5WbG1ZVWJ6Qkp1clhCNVpIREsrNWZnODcrUUJUNTJjQnRnbFFBT0RqYTVX?=
 =?utf-8?B?RXhUN0dscGtwZVIvcWloanI2YWIzSWNwaS9Pc3ZxUWRsVFVvUWxDQmUrZmwr?=
 =?utf-8?B?ZVJ6YkRMVlFWVTFjRDE5eDN0Q0JBbWNwaFRFNEp3eUtpSStDODNjZmZNWUFu?=
 =?utf-8?B?MjVHeGU2eU5XRmtUVG9ZY2dDb1RRZlRQM2ZUYVdHVFVDYWZYL3B0K3B0TUhr?=
 =?utf-8?B?eXpSTitQVGhCaVZZOC9oajk4VUZtWlMxUUNyRThMVjdWVDZRZk9Hb3VtY2dN?=
 =?utf-8?B?VE1TeVNxK1JLaisxaXhoaDVJalhoRzM4ajlCSms5cW82bXN2SlNwNTMxQnBs?=
 =?utf-8?B?UVVqMk5YaXdnUSt4MGpPMmRDcEd5K1A0SjJER1VmSWhIVE9meWJFRWlxZFVS?=
 =?utf-8?B?KzJoSktQOStacmdraXZ4S1VxVTFDY1lEeVFrMEhzU3FxUWNuRG9NZGN0d1NR?=
 =?utf-8?B?R2RPcFQxaDJxYzEvMWVqMjRhTFNvN1ljSllSelpvbHhJdkpTWGE3dGE5TUtl?=
 =?utf-8?B?L0lhbStsYXJXcDhoejZDL2U2cm5jQWFHWkUrRndwcHA2Z29CVkRDRVBJbU9y?=
 =?utf-8?B?OERPN1BQSXJISW9ZSWtydXIyOVplQlRQTGJyS1pQaVhlczdRNDhIQjhIM0ox?=
 =?utf-8?B?ZXl4QXB0S3hlb1VOckZBdWs4M2ZpSTM0ZkE2REZoTkU4TVFMQkczR1Eva29m?=
 =?utf-8?B?TE83enEzcDhvb0gxUzRMbUswbFVPQUloSkQ3ZFdFZFFod3VIMlZqbkg5YVVC?=
 =?utf-8?B?alF6eE5nMlJkZ0hiZDR4Q2tVLy84WXNLdlB6dVlObm1SaldGaDZLUU1FcVdk?=
 =?utf-8?B?eFNDeHYzUnVBc2NEdjZlc1dQR2o0KzhGRjkxS1g5QzhYSFppellQMnUxUUZ1?=
 =?utf-8?B?N3hWVVVCRTdHbS80Z2hxZWFTNFAwQkNoeElHbFV0VGJnYjBJSjNhNHVhYlJ6?=
 =?utf-8?B?SzFlVmNpUjUxV2VKN1NqK0NmTExKdGVzMkxTeEJZTUdBWVlMNUQxVk5tb2tD?=
 =?utf-8?B?dVFFRVFxbEYyMldwYWNmc0pVR0t5UERwZ043TEw3ejdtakU5cWFXT1ZqeU93?=
 =?utf-8?B?cmlIeGk1ZnJmaFhTdjBDLytMNHRTL0ZlbFErSVord2JGaG5Sd2FIbXQ2T0Rp?=
 =?utf-8?B?MUpPTi95cHhmUHJpcmlYWlpRTTU1RWNvUHBNUmRqdkk2ckdiT0cyLzVOcVdm?=
 =?utf-8?B?U2RDRlBaZEhyUCswMXBjYTZSUUMyTFBMaHU5MmwzdGYyZUFXV2lvOEI5UHI4?=
 =?utf-8?B?RWhHaGZub053VHNiaVVNeUxYbTU0V2RUOVErMDJBSkZpM05YWjB3Qm8ra2J4?=
 =?utf-8?B?Nm9BWnNZMXBRR0pxNEZOeGVtS1R2UnRXbDAxV1JYcllLN3dWNzM5S1NCd0p0?=
 =?utf-8?B?Wk8xaUw2Wk43NVFGbFFFK1FkS2tYUHRnME1DRzR5QTltclNpcFoyWW11dkNs?=
 =?utf-8?B?ckQ1UmJKQjI1c1JUOG1hUkNPZHpMcjZVOHpjR0d4ZjBjZWtzOFpvOW1DcnFE?=
 =?utf-8?B?UzVzS1ZobTEzTDJrVjZKRlpCM0xaMTIzNXFRWXZkSVo3OC9Zb2x3MGR2Qm16?=
 =?utf-8?B?N0tHeGQzY0JKRVZEb2k4YTJqaDBacUpzclVjcW5BYkE3WnpMU29qSXlYNjNZ?=
 =?utf-8?B?T1ZTeVQvOE5scEdlNDJTWVhFSXllanJVM0dpWUYzUFhVaTJlUk9yQnJGSFR6?=
 =?utf-8?B?Y0o2WkNwNHhrRmxDNFh5cE84Y1hxL1EwTUlxdDFjZE0rZVZ2YjFQUmJUQVpZ?=
 =?utf-8?B?WGdrNXRIL3BidzMvZ3MwSHc2bkdIWjJqb3JMUFU3bStJcTJWbWFick1NRmJX?=
 =?utf-8?B?eVpPK042RStFTGlYVjYzNnFrMWFrN3V3cG5KdXI0TlUzeWFsSGZmZU0reTdk?=
 =?utf-8?B?czkvWnRKdEFrS0NrdmxZZnpJai92TVZYdHpNbUpHZ0FPaFRSOS93STc1S1ln?=
 =?utf-8?B?djVSOVdXOVRISHNGajhDU3ZkYTNDR2RvU3NxUkZVcFFxT2RHdi9Pd0xSSUwy?=
 =?utf-8?B?YllqSXJJdWl5OCs4OGp4S3V1V3Y5QXpTMW0weG1jNTZyZklJNlN6UzdCV0ZG?=
 =?utf-8?B?cDhsMGZUQUhINjR0dHZqc0NQYU1RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D7DA330FAC0F54C8955A956AF8A28D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4775.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6700f282-2f66-4cae-0acc-08d9e09fc7ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 07:45:10.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 05oYwOKJhFZk54C+MerZ5Vo5YFEpzpRXcr9Z0rPVAUK6bmKPGvUJ4nMe+z85Y+80M8PHGVrbnmMuLs4CcgoCB17ripiL4VHPMS3c912pRZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYuMDEuMjAyMiAwOTozMCwgTWljaGFsIFNpbWVrIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZQ0KPiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIDEvMjUvMjIgMTg6MDUsIFJvYmVydCBI
YW5jb2NrIHdyb3RlOg0KPj4gVGhlIEdFTSBjb250cm9sbGVycyBvbiBaeW5xTVAgd2VyZSBtaXNz
aW5nIHNvbWUgaW5pdGlhbGl6YXRpb24gc3RlcHMgd2hpY2gNCj4+IGFyZSByZXF1aXJlZCBpbiBz
b21lIGNhc2VzIHdoZW4gdXNpbmcgU0dNSUkgbW9kZSwgd2hpY2ggdXNlcyB0aGUgUFMtR1RSDQo+
PiB0cmFuc2NlaXZlcnMgbWFuYWdlZCBieSB0aGUgcGh5LXp5bnFtcCBkcml2ZXIuDQo+Pg0KPj4g
VGhlIEdFTSBjb3JlIGFwcGVhcnMgdG8gbmVlZCBhIGhhcmR3YXJlLWxldmVsIHJlc2V0IGluIG9y
ZGVyIHRvIHdvcmsNCj4+IHByb3Blcmx5IGluIFNHTUlJIG1vZGUgaW4gY2FzZXMgd2hlcmUgdGhl
IEdUIHJlZmVyZW5jZSBjbG9jayB3YXMgbm90DQo+PiBwcmVzZW50IGF0IGluaXRpYWwgcG93ZXIt
b24uIFRoaXMgY2FuIGJlIGRvbmUgdXNpbmcgYSByZXNldCBtYXBwZWQgdG8NCj4+IHRoZSB6eW5x
bXAtcmVzZXQgZHJpdmVyIGluIHRoZSBkZXZpY2UgdHJlZS4NCj4+DQo+PiBBbHNvLCB3aGVuIGlu
IFNHTUlJIG1vZGUsIHRoZSBHRU0gZHJpdmVyIG5lZWRzIHRvIGVuc3VyZSB0aGUgUEhZIGlzDQo+
PiBpbml0aWFsaXplZCBhbmQgcG93ZXJlZCBvbiB3aGVuIGl0IGlzIGluaXRpYWxpemluZy4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFu
LmNvbT4NCj4+IC0tLQ0KPj4gwqAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYyB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKysrLQ0KPj4gwqAgMSBmaWxlIGNoYW5nZWQs
IDQ3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+PiBpbmRleCBhMzYzZGE5MjhlOGIuLjgwODgy
OTA4YTY4ZiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMNCj4+IEBAIC0zNCw3ICszNCw5IEBADQo+PiDCoCAjaW5jbHVkZSA8bGludXgvdWRwLmg+DQo+
PiDCoCAjaW5jbHVkZSA8bGludXgvdGNwLmg+DQo+PiDCoCAjaW5jbHVkZSA8bGludXgvaW9wb2xs
Lmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCj4+IMKgICNpbmNsdWRlIDxsaW51
eC9wbV9ydW50aW1lLmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L3Jlc2V0Lmg+DQo+PiDCoCAjaW5j
bHVkZSAibWFjYi5oIg0KPj4NCj4+IMKgIC8qIFRoaXMgc3RydWN0dXJlIGlzIG9ubHkgdXNlZCBm
b3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNlcyAqLw0KPj4gQEAgLTQ0NTUsNiArNDQ1Nyw1
MCBAQCBzdGF0aWMgaW50IGZ1NTQwX2MwMDBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+
PiAqcGRldikNCj4+IMKgwqDCoMKgwqAgcmV0dXJuIG1hY2JfaW5pdChwZGV2KTsNCj4+IMKgIH0N
Cj4+DQo+PiArc3RhdGljIGludCB6eW5xbXBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpw
ZGV2KQ0KPj4gK3sNCj4+ICvCoMKgwqDCoCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gcGxhdGZv
cm1fZ2V0X2RydmRhdGEocGRldik7DQo+PiArwqDCoMKgwqAgc3RydWN0IG1hY2IgKmJwID0gbmV0
ZGV2X3ByaXYoZGV2KTsNCj4+ICvCoMKgwqDCoCBpbnQgcmV0Ow0KPj4gKw0KPj4gK8KgwqDCoMKg
IGlmIChicC0+cGh5X2ludGVyZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfU0dNSUkpIHsNCj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogRW5zdXJlIFBTLUdUUiBQSFkgZGV2aWNlIHVz
ZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFkeSAqLw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3QgcGh5ICpzZ21paV9waHkgPSBkZXZtX3BoeV9nZXQoJnBkZXYtPmRldiwgInNnbWlp
LXBoeSIpOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoSVNfRVJSKHNn
bWlpX3BoeSkpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldCA9IFBUUl9FUlIoc2dtaWlfcGh5KTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGRldl9lcnJfcHJvYmUoJnBkZXYtPmRldiwgcmV0LA0KPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICJmYWlsZWQgdG8gZ2V0IFBTLUdUUiBQSFlcbiIpOw0KPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBw
aHlfaW5pdChzZ21paV9waHkpOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0
KSB7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJy
KCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gaW5pdCBQUy1HVFIgUEhZOiAlZFxuIiwNCj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQp
Ow0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJl
dDsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPiANCj4gSSB0aGluayByZXNldCBi
ZWxvdyBzaG91bGQgYmUgaGVyZSB0byBmb2xsb3cgY29ycmVjdCBzdGFydHVwIHNlcXVlbmNlLg0K
DQpJZiB0aGF0J3MgdGhlIGNhc2UgaXMgdGhlIGZ1bmN0aW9uYWxpdHkgc3RpbGwga2VwdCBpZiBt
b3ZpbmcgcGh5X3Bvd2VyX29uKCkNCmluIG1hY2Jfb3BlbigpIGFuZCB0aGUgY29ycmVzcG9uZGVu
dCBwaHlfcG93ZXJfb2ZmKCkgaW4gbWFjYl9jbG9zZSgpID8NCg0KQWxzbywgUm9iZXJ0LCBwbGVh
c2UgaGFuZGxlIHRoZSBlcnJvciBwYXRoIGluIHRoaXMgZnVuY3Rpb24gKHdpdGggY2FsbHMgdG8N
CnBoeV9leGl0KCksIHBoeV9wb3dlcl9vZmYoKSkgYW5kIFBIWSBoYW5kbGluZyBpbiBtYWNiX3Jl
bW92ZSgpLg0KDQpUaGFuayB5b3UsDQpDbGF1ZGl1IEJlem5lYQ0KDQo+IA0KPiBUaGFua3MsDQo+
IE1pY2hhbA0KPiANCj4gDQo+PiArDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9
IHBoeV9wb3dlcl9vbihzZ21paV9waHkpOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAocmV0KSB7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBk
ZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gcG93ZXIgb24gUFMtR1RSIFBIWToNCj4+ICVk
XG4iLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldCk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gcmV0Ow0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+PiArwqDC
oMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoMKgIC8qIEZ1bGx5IHJlc2V0IEdFTSBjb250cm9sbGVy
IGF0IGhhcmR3YXJlIGxldmVsIHVzaW5nIHp5bnFtcC1yZXNldA0KPj4gZHJpdmVyLA0KPj4gK8Kg
wqDCoMKgwqAgKiBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUuDQo+PiArwqDCoMKgwqDCoCAqLw0K
Pj4gK8KgwqDCoMKgIHJldCA9IGRldmljZV9yZXNldF9vcHRpb25hbCgmcGRldi0+ZGV2KTsNCj4+
ICvCoMKgwqDCoCBpZiAocmV0KSB7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9l
cnJfcHJvYmUoJnBkZXYtPmRldiwgcmV0LCAiZmFpbGVkIHRvIHJlc2V0IGNvbnRyb2xsZXIiKTsN
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+ICvCoMKgwqDCoCB9
DQo+PiArDQo+PiArwqDCoMKgwqAgcmV0dXJuIG1hY2JfaW5pdChwZGV2KTsNCj4+ICt9DQo+PiAr
DQo+PiDCoCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfdXNyaW9fY29uZmlnIHNhbWE3ZzVfdXNy
aW8gPSB7DQo+PiDCoMKgwqDCoMKgIC5taWkgPSAwLA0KPj4gwqDCoMKgwqDCoCAucm1paSA9IDEs
DQo+PiBAQCAtNDU1MCw3ICs0NTk2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZp
ZyB6eW5xbXBfY29uZmlnID0gew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIE1BQ0JfQ0FQU19HRU1fSEFTX1BUUCB8IE1BQ0JfQ0FQU19CRF9SRF9QUkVGRVRD
SCwNCj4+IMKgwqDCoMKgwqAgLmRtYV9idXJzdF9sZW5ndGggPSAxNiwNCj4+IMKgwqDCoMKgwqAg
LmNsa19pbml0ID0gbWFjYl9jbGtfaW5pdCwNCj4+IC3CoMKgwqDCoCAuaW5pdCA9IG1hY2JfaW5p
dCwNCj4+ICvCoMKgwqDCoCAuaW5pdCA9IHp5bnFtcF9pbml0LA0KPj4gwqDCoMKgwqDCoCAuanVt
Ym9fbWF4X2xlbiA9IDEwMjQwLA0KPj4gwqDCoMKgwqDCoCAudXNyaW8gPSAmbWFjYl9kZWZhdWx0
X3VzcmlvLA0KPj4gwqAgfTsNCg0K
