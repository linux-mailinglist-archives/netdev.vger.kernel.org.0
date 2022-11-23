Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E78636073
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiKWNvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiKWNvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:51:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97141B78E;
        Wed, 23 Nov 2022 05:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669210919; x=1700746919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3w10l3S9Ne+4swopmxAkU+LR9CX5W64ZdbfNaprZlMw=;
  b=gHCfWdnmKUib79GxqsQI9xFcJibvptdr+xOktXp4x5jW51H/YoEt88Q3
   8noF2tNCdCwcVduFKhJsmnK+YRO1f83Qp8H+TUnyl/C6659jus8gumYq5
   jZ7fiS2yLioBStNdH7L09hn8e3jAK+N7QTrpgXjNCa0ZXJLnOjkjf1LJJ
   ZxIChXV8FXmBXwlpmRYt16VrMnh6ksNAD3AG7l4s8gB5eGPxpAyPYneGm
   d3DjhlwQX/vxPiyNZRjpE51JqMD/8ULxa1/z+QUHhCZmYs/MKYykd3aid
   5/ZQipHSCy5yNS99Etu7UC+2tgGONhm8xmxgmufQ2DCp8eLtULNgXhjv0
   g==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="190244752"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 06:41:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 06:41:48 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 06:41:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jw7vLXAdxHD/BD22O8ZNMfwxE2GX/02QvHmSFnoKDDyAcmPLUULC7dDfTTbK8DKtqX7E8APMjc6FOUCJW9eN4MxdWkUHGWvBjGbSzj12J+h1X6G8F6X/nCj2AWOIxWjgZ7MzCgpJd0tbETiO+pn1E4Uhdu6g805TJz+EQtWM2ZFsm78UiMu1RmefIhZ9fRMuXl6DZ7UWCT84dfvgZys34PyaOOEvXI2D/v3Pl+aN9/A6hfn71D/eLVXfKRpOE9IH5vohi/xhAAdeptPkoIUVZFPdzhVM6qOLSy+BgyYvTRphogbY5Dl9J3MN31GctPU+ZuUJqbUrz7rzbj/dC+/rGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w10l3S9Ne+4swopmxAkU+LR9CX5W64ZdbfNaprZlMw=;
 b=ElzzhfQD65AepXNIQ28T/fXyiGWfK59GeZExAzYYOtoTs3aUTmeGHZ1uvciUr7kYb85xom6d4HyXGiFIKBGUal8AN6XPflJwOk1P0aavMNc5cbHD56lB0eUsQxvKojwbAqmDlKBzxcUxwKVPc6q3Tf9ZIVIqflLbZ3RW5qu7mmIgNussH2ajSwx39hfldi4xP/DKPp7/BCuOf7EQkuUn+UhoAJJ0hjlnVzoJa9f8ITHnVnI/US6yOMvuwq9NCptjCYmJp2rumFzB8L77BXoG3GXueF7BnR9WEjhE1vH8J6g10xEz0a2yx9acVMxQGm+68ZxzZ13IjAEF/2yZUAzA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w10l3S9Ne+4swopmxAkU+LR9CX5W64ZdbfNaprZlMw=;
 b=am84xONH7RheN3N4QkEXziGd0hH4WwPnxwfxFHv2DMEB6I0mocGTeCX6f9zYzCnbmIJmfPGj8FCKdQzOyoXrdOPOU0DNUrNbzm3hDakr/CX4LAVLLzCFU0qB43u+fHK0Enhec4EboI6jda8pYsKJys4ZwTHqzj5seu1FWi8ek7E=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH7PR11MB7718.namprd11.prod.outlook.com (2603:10b6:510:2b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 13:41:45 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Wed, 23 Nov 2022
 13:41:45 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v5 5/5] net: dsa: microchip: enable MTU
 normalization for KSZ8795 and KSZ9477 compatible switches
Thread-Topic: [PATCH net-next v5 5/5] net: dsa: microchip: enable MTU
 normalization for KSZ8795 and KSZ9477 compatible switches
Thread-Index: AQHY/y5/QEW4X5LXlkOlv3dmMieGeq5MhEkA
Date:   Wed, 23 Nov 2022 13:41:45 +0000
Message-ID: <1a86733bfac803e6ef0f6baa290af39e4cd47668.camel@microchip.com>
References: <20221123112625.2082797-1-o.rempel@pengutronix.de>
         <20221123112625.2082797-6-o.rempel@pengutronix.de>
In-Reply-To: <20221123112625.2082797-6-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH7PR11MB7718:EE_
x-ms-office365-filtering-correlation-id: a69dfa07-618e-4e98-b750-08dacd587687
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0nWKXCJr9kQafyaZp1KBwzUyyJ+F383gSZ4/WfAAHxqGmvKZSP+0g81keeTiGi9k8qG/MCUPyWS11cH/sXeCIjKS1Gt9VqN5ezF0ckxHu2XHaGhEuEDZ7PHqIMzRzDUJ5mbTBlps2/UENJuZwkkoH5JuaY+XRjPeyGZpXwL720VaD5daKZ5VuGoiwECLnip9KjHbBwcPkV/z2gKnUal8yVp4+rj7woSvdcld3AgBOrjzYsNJm3anM/oMH9CjtVF6k00iJaFI5/zqLUHm6a0SHcZqawc7ScAP+0oN1YKQXZyD6mL30aydO2YPCMbpgtUmXvOo5rzPONftuxiE2jxG4BpJQH2qhRJhkj5GA9FjbtdBdGKbjN/KngM0WaEwfrHDR+9ve5qN2ML+TX4G4MYoA6AYkp/wjA+Tn1mcoYkOx7TPKKDOCj+yPzsUwF/Cdc7nRwz4DUvjDSMN18mO8qZLfuVKcXCmvuzuA7gJPW8GsSRPn2H0m4zn70hqGGvZyuPPD3BxwpYqqvoiF/9Y8T9RQoDZdVUc8uNiCBm3+hMAl7nwxSEd/PWKTmzu2VNTCqOeIWVAEwT56t1AVE0ER+yLa2MSIWKPnmLUIuy5TYKbRLfDssmkAHfQfQdaSfeYNvE6fSn+u1EMFxC1tlWslhfztvbkOmzTf04jYJKBfyKd7lWdhsG/Tq5LrYLahMpwWplsPiJzcFdgVwm6nx/VoJrVaJh8CCBc1K/XCoW12HNTHKiPvnOMTrrpgOH3kbX/k/0K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(76116006)(4326008)(7416002)(66946007)(66446008)(36756003)(66476007)(8676002)(8936002)(66556008)(64756008)(4001150100001)(2616005)(186003)(91956017)(2906002)(83380400001)(86362001)(41300700001)(5660300002)(38100700002)(122000001)(921005)(38070700005)(478600001)(6486002)(110136005)(316002)(54906003)(6506007)(6512007)(71200400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFhGZGF2ZFdFdlQ0Wm5BcVNEVGEvMDhob2gxRzFNV3cwd05oME4yN0xnZ0E4?=
 =?utf-8?B?NUs3NHpzWTV2TEJZanZtQmkvYWRKL1FkSytEbEpzTGV2eE52QU5xUWlobTFD?=
 =?utf-8?B?SlBtUmxYNVdsQnJTVkV4RE93MHFxa2FJcGNtZzYwV2hsUHBBNjRrMnpkRlJW?=
 =?utf-8?B?U1NNaEZ0NThGTGVlemJuaTdRWlRCblRCdkZ2OElTOWxoYmt5ZXdKTnY4RG5X?=
 =?utf-8?B?N1dITHNPbFFZUHRBZ0RVTHYrYXI2b1BwMzNveVowSE1LMERqS3hydEFqdnhF?=
 =?utf-8?B?anppZFZBUER1OFI4a1pJNUNVZW1ZRzMrM2Z4c0o5WXk5cGF5V2hpZDdRbjd4?=
 =?utf-8?B?VG8xUFd0d0JDeVF2clNxeldmRHAxR2R1ckJ4dHA2d2xUdTZNQ2VqazhRYnhv?=
 =?utf-8?B?QVY4bENDS0RPVDBaSWxtRC92Vm5zZmFWVmM0STlNZk1RYm9MZXFNT0QwSVhH?=
 =?utf-8?B?SzdNMHpZTm96dU0vTEg0MEZkSHZEbXduTG9KUWxkWHNGOUhHbWU3SDRXSVdQ?=
 =?utf-8?B?VkwwYmppVWUyUXA2T3RrZ3ZaR2kyaDFsdzZ0ZjcwQlhhMVE5dzYrZkpuQWk0?=
 =?utf-8?B?ejNYbGlrK2hadTlDSDNrQmZ1TVczT0xBUU93dzlaMWQ2RE1WY1pvaEM1ZllB?=
 =?utf-8?B?bFdwbWlFUzREczhvbzB4dG5lT2xnQi9wazM0LzBEVXVRU1Z6REZMM0hWTUlP?=
 =?utf-8?B?V1dTaDlPVG1QRVZJdnQzV3VqSkUwNFlxT2lMeHFwTzMxZUVGd0NPVEdOemhG?=
 =?utf-8?B?MUY3eGZIM0dLUkNMMWJmT0gvSlJjZkZtd1EyRnE1MjQzckd2a2JSb2Q3NWFT?=
 =?utf-8?B?YzBrYy9YVzJwckNMNDBDWWlpbGc3d3ppWlR2UTNkL0d0QngyUGdNZ1NQVW5u?=
 =?utf-8?B?czV3bEsyZnZLTTF4ZWRQaHhiMDNSQVlmSWZ5aEdkMkUzbUtSanBjZ0ZueFpM?=
 =?utf-8?B?K2grcXNZeGxnMUdqOVExWWZaTmxSWUNYU3VzaFNSM0NTQmVYSW5FNWtnK08x?=
 =?utf-8?B?aGlNMTdQRmVnZDArSU02RUkza2MvMFF1MjZQYldsL0M2L1dyamw5TldqeXMz?=
 =?utf-8?B?U01IWGZJUFhvTlRGY2dlSi8ya1hzVjlhNzZwYUhmSG9wSDg5b2wza1FKQlBZ?=
 =?utf-8?B?ZjNaT25rVktERnYrb0JWby9sWWpHQjJvRVBabmtwenZjTkhrUEorVEpqMkRa?=
 =?utf-8?B?Vk9wWk83VkVOTmhROWdKdUhobUplUmN5UVNJM1JEb1c1NVRtNlFjZFJXZ1gz?=
 =?utf-8?B?enp5VFZYdTkvYlN2b1pFTEQ2OXpvWTlrNmNuaFZCeWdXa1Zhc0pyTkI1Y3JI?=
 =?utf-8?B?dEgvTG5ieXp6UTdQcGVRSm8wOVFJRUVmeTBadjhTRXpCbUh5elpEcXF3MCtB?=
 =?utf-8?B?eTVCNU42U1VJLzIwL0NmRTFwY0hLRlBOYjdKcGI3MDJvNTJIcEE5cW4wVkdi?=
 =?utf-8?B?aVBaUWtzQTBRb1dxRk9xYnpIVUh5aEp0cm1BaloyV3FaZDViejRHK0wwZFpN?=
 =?utf-8?B?a1dFOTY5TmFab0tFWjdORTR0VlFXQXFYUEtHeE5MMEZ0V1hsQ2tDRkw1MzI0?=
 =?utf-8?B?VGdYWFVEODZ2VERLNm02OGxGdEJnNk5KNGJzZk5uL2Z2L1FmbUtyR054WS9j?=
 =?utf-8?B?a1hKRXU1ZjZUKzVqV1FpUW42bzBkbG1rb1E4WDVZMWZzS1IzMEhxMXlSTHFR?=
 =?utf-8?B?eEVOZW5rMjhGbTRrZmtBU2ZZZ3ZlWDczejd5WHhjeFNFOEZBVGtjNG9LdXpP?=
 =?utf-8?B?MC9DOWswN1htak52cEgvSGNBeWxRS3JkK1FPbk5FRkFCOTRPeFNjV05nZU5V?=
 =?utf-8?B?OG5vaUtHV2JyODF6TDVTNGVCcDRVT1pVWHZEQjVTcDduSy9UczB4M1JJQU9s?=
 =?utf-8?B?T25lK2k1QVBTRVNxdmhWNm9rRmV1YmE3RyttWGpLMVlUS1g1a3oycmZjOGlN?=
 =?utf-8?B?LzlaY1ppTS9NcDZVTW1ZREJqYjJDODV4d0xVUXNZZFVIZU5OM0R2M1lIVmFy?=
 =?utf-8?B?N3RQYWJsS2ZTLzRNV081ZFRBZzdFVGp4TXg0aDh2ZEg3bXdmcUw1MXBtZG94?=
 =?utf-8?B?WXdSYm1sYldTMWhXYjM0UVl5UDdyVDUxMEJ2MmtCbkxLb0xkTk1zZXlqblhx?=
 =?utf-8?B?V1FKNEtiUWRVcXkrb3VWaXp1YUkyb1VOMzlqRWNudG1rbFN5bkRFK0V0anM1?=
 =?utf-8?B?KzhmLzB0Qm9UUDdTZ2NjUThqNVY0ZnRkV1o5NXFzREhLbXhvQUFQV3djalVW?=
 =?utf-8?Q?jUeon80K/jnBm50Q6O5+4KQQbFX+wduM5Fc/PVhZec=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F29D87190709D441B5CEBE9438E69176@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69dfa07-618e-4e98-b750-08dacd587687
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 13:41:45.5455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NUpIF2cz1+7/5/Gd32HBMZOsaCK4ZsAz1YzG3fHAfzRIeLFaFaFvIiafpilsqsPgNiXg79EuVYDv2RaX1WF21U7ucE3XIIWET+qvWsMqA80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7718
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gV2VkLCAyMDIyLTExLTIzIGF0IDEyOjI2ICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBLU1o4Nzk1IGFuZCBLU1o5NDc3IGNvbXBhdGlibGUgc2VyaWVzIG9mIHN3aXRjaGVzIHVz
ZSBnbG9iYWwgbWF4DQo+IGZyYW1lDQo+IHNpemUgY29uZmlndXJhdGlvbiByZWdpc3Rlci4gU28s
IGVuYWJsZSBNVFUgbm9ybWFsaXphdGlvbiBmb3IgdGhpcw0KPiByZWFzb24uDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMgfCAyICsrDQo+ICBkcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyB8IDIgKysNCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o4Nzk1LmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUu
Yw0KPiBpbmRleCBkMDFiZmQ2MDkxMzAuLmQ4OGQwYjk4OWUxYSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gQEAgLTE0MjYsNiArMTQyNiw4IEBAIGludCBrc3o4X3N3
aXRjaF9pbml0KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYpDQo+ICAgICAgICAgICovDQo+ICAgICAg
ICAgZGV2LT5kcy0+dmxhbl9maWx0ZXJpbmdfaXNfZ2xvYmFsID0gdHJ1ZTsNCj4gDQo+ICsgICAg
ICAgZGV2LT5kcy0+bXR1X2VuZm9yY2VtZW50X2luZ3Jlc3MgPSB0cnVlOw0KPiArDQo+ICAgICAg
ICAgcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o5NDc3LmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0Nzcu
Yw0KPiBpbmRleCBmNmU3OTY4YWIxMDUuLjRmYjA3ZmJkZjU2NSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gQEAgLTExMzQsNiArMTEzNCw4IEBAIGludCBrc3o5NDc3
X3NldHVwKHN0cnVjdCBkc2Ffc3dpdGNoICpkcykNCj4gICAgICAgICBzdHJ1Y3Qga3N6X2Rldmlj
ZSAqZGV2ID0gZHMtPnByaXY7DQo+ICAgICAgICAgaW50IHJldCA9IDA7DQo+IA0KPiArICAgICAg
IGRldi0+ZHMtPm10dV9lbmZvcmNlbWVudF9pbmdyZXNzID0gdHJ1ZTsNCj4gKw0KDQpGb3IgdGhl
IGtzejgsIHlvdSBoYXZlIGFkZGVkIGVuZm9yY2VtZW50X2luZ3Jlc3MgaW4ga3N6OF9zd2l0Y2hf
aW5pdA0KYnV0IGZvciBrc3o5NDc3LCB5b3UgYWRkZWQgaW4ga3N6OTQ3N19zZXR1cC4gQ2FuIHlv
dSBtb3ZlDQppbml0aWFsaXphdGlvbiBmcm9tIGtzejhfc3dpdGNoX2luaXQgdG8ga3N6OF9zZXR1
cCB0byBtYWtlIHNpbWlsYXINCmltcGxlbWVudGF0aW9uIGZvciBib3RoIHRoZSBzd2l0Y2hlcy4N
Cg0KPiAgICAgICAgIC8qIFJlcXVpcmVkIGZvciBwb3J0IHBhcnRpdGlvbmluZy4gKi8NCj4gICAg
ICAgICBrc3o5NDc3X2NmZzMyKGRldiwgUkVHX1NXX1FNX0NUUkxfXzQsIFVOSUNBU1RfVkxBTl9C
T1VOREFSWSwNCj4gICAgICAgICAgICAgICAgICAgICAgIHRydWUpOw0KPiAtLQ0KPiAyLjMwLjIN
Cj4gDQo=
