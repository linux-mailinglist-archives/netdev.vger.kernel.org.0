Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6047CCEC
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 07:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242720AbhLVGV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 01:21:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49569 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhLVGV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 01:21:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640154086; x=1671690086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=22kuXmWO1eCJiHPoHssEZiHsvy/6dwRNJRX0YfUp+FY=;
  b=wY+md7fgqfoJHTf4/76xIBl+NAxHAh3MIwnPboRHpSOxG7eCTTcNn7Vc
   6yR9UNNgBjnxFKPMvX7UAoIortK3vHBCvSnhXwAthKLyFF+OiCmrcrsCR
   aX9+l0groomx3jUPtHem70ZCWW4labG7HiSO8+hD7+Z2teV7thgb/PKTD
   yddtaLx3lnvKvsKU+wRcaoJlBw8axkfBMObsLayuFHzLXOVL2dsZ/PN5F
   tEvx9jzSl8ixY/4EzfSTJhcYRLvcpT5B3Z4SoNwH8am4QqYwEY29lMryd
   8SOMQfTnUYQOjFdKLPUtp/XKIGUF9F5u0mdYaxrdXMxlbQi48QDQGkumi
   w==;
IronPort-SDR: LBGJih/+/VhNkDN4UyTCoa/y8dZKDRBrea39YJf6F3OAK6QJ78jeu4YlVBEb29ygxzP9HhxO4a
 CtmUJCmRTpPjjxeqp6TC+66LY+LOzulvbQ4EgxyO0v6vM2KQLQsC//K77A9kqXNY11YewmI7LX
 SOvcRuMvp04XX4DC6wsRURxiKZtBzz3xHz/9U9oXnGJHQlxf26LpU9f7dL4FG/wksxPs/I1M04
 lZo7xWMNR1KT/1vGr0KloMmGWHIF5PSGUKV/oQWrYIJa2ktbqqKSPB6P2g9G3wdMB4NNki08QG
 dDHvER7g7X2U41PCF7PNQ9NN
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="156344597"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2021 23:21:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 21 Dec 2021 23:21:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 21 Dec 2021 23:21:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag6f0KI0n937a6MgOKrltSulvACTX+RNXoz4/UNLYOlAn+ydfpnw5s7lWcDbjrqMHdcvKX4/VPwgcjf0565GDtk0QGGTvDDX2vrCqlEOUMoI83bHGiycp6xN3BFduTC0GKQ+02cakxix+3NO/vS6yKzttFB87KcFRXuLaqNB6WjAFh0uXyatxbyU7zRdH7d8KTReLyYI9kSZRKQW0ku9oAXJZXHzZ8sSkucDZu/Am9WIkrDUHRid5PLbS0K1cvGDbDlwuClKhxiGq51/Xl69f6kziT8gUTBtsJq/QVpmWRMwdUgCHIOd8+unWrub784tJKQzyQJmlwAJQev2nsIUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=22kuXmWO1eCJiHPoHssEZiHsvy/6dwRNJRX0YfUp+FY=;
 b=L6xYkS+vMTnLjtWoqqV2lR1oUQS46N4h6IZYCS8eksR+PIc8Ef4HkAVUi6CcOjur34unjDBBzx8FYgiT8LCowhnh806SW2X2GX5CkzhmMOVw6WoZvLqectKGO29QDFvChnSM/n8ZklzwPIQjIVjTqDN8OOOcVJJRwbqL2B8htgtyih1/wE+djDjUmeI5xRFJcReHdGFIflRnDv74oV8eWUbShIpM6sxy9VO5WSbQJ8wAZ5KOpcwiMDogWLwIryAyNzIcAwvYDqCPyJSv2FpLF0JJji7fsaHwkM2cOnDrVvA6c4gmlsW/Ub5PuLJbwen8CqkQgT9jJT1ieaQrvhYLdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22kuXmWO1eCJiHPoHssEZiHsvy/6dwRNJRX0YfUp+FY=;
 b=L2wkmwGd0YrMYIPQUhV0egBEy+TDtmcUxl8c+/TFQEq12yTsaZbWxaXFye1yghQsOWQTX0MvgGRgePWkHm/6ivHbAj3MqjSeNe2GJYcaFZ5JDI2A1zCwcNO+yEEeszarZ23iDdDMlc0MYjpjHW3GcNEcisM+DhSCpJBs7skm/+Q=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 22 Dec
 2021 06:21:12 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::1f6:467f:69d9:e0b3]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::1f6:467f:69d9:e0b3%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 06:21:12 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <adham.abozaeid@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <kvalo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v7 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v7 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX9vwdZz5SMyMd80uylZqOdffzxw==
Date:   Wed, 22 Dec 2021 06:21:12 +0000
Message-ID: <7b3970fd-0781-aa2c-4c89-821f2eb3585e@microchip.com>
References: <20211221212531.4011609-1-davidm@egauge.net>
 <20211221212531.4011609-2-davidm@egauge.net>
In-Reply-To: <20211221212531.4011609-2-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9fa6c08-f044-4102-c977-08d9c5134053
x-ms-traffictypediagnostic: CO1PR11MB5170:EE_
x-microsoft-antispam-prvs: <CO1PR11MB5170371F29749A80591BF5D8877D9@CO1PR11MB5170.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:28;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2EhvXmtPVAmsmkg1JqLLGsttj6pTY2RHPtINXXUonhKSMZLUTd3Kf6Z9H78dpFb2KwmiaMh/p4H3nzfvaTBfPozSu8taTOrA83aIqvQbUhKZOBQQLEFrBcA2l8NR8LAjheEOI6tM0h8OJ8Ii751QwhDsrg0qMoPNC8XlqpKjIT9JFw45TReZW0d+6/y8R0KSZbtQaA7FryNuUghjmhF5tTjmL5qUnXJhS5IASTbMxApG8hMYLV/Z29BEUL7k9br9KRfj3SdgUz/ve08F9f/rOfw4rTD3c12qxsW2J1uNZnGnxVHic970GKLMCIrmALyMbohU1aIUPFj+B6WJNsOMetbpUX7aBwgIbwjdaYHbWtc80hvU+FUTK0o8VwRnc4TafF+To3JEfkIktxoqAX++xE5Pn3Qogs0EhngvPrwzeT2SoEKzkdbM/ykH9yr/HkEnGkCGoY++Gb0UoZss+s88fBcB0z9BRmfYUS3GIRvp238AyKnazrksHz0mooGyVBgC7FejsNIMJgz7upBTJeuh6BwcGKmHoXngLNtzXJqCl7POQn0VbI6uuI9pS+dlzZXJjfHay96RxFdaSy4rT9Q1t+5MeWZmnlyMGb1y9DXflb8S7WFujDm13QQkqyhNF5Q9xdGzSnepWJU2L027wO4q3E01dvN4wErqjdQdy37as9Eon3mnb/8/obTaSBHvjLhlCJ9BHn4v9zgliEJVRdTjmpH/7lKNhOt2Nlcu6O/rbn5NnL6NWJWy5GY77xvxilmnQ1EkFMBNdLsg9xkPRhLcrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(2616005)(5660300002)(83380400001)(66946007)(66446008)(64756008)(66556008)(76116006)(38100700002)(54906003)(66476007)(91956017)(36756003)(71200400001)(38070700005)(6512007)(6486002)(6636002)(186003)(26005)(4326008)(6506007)(53546011)(122000001)(2906002)(8936002)(8676002)(508600001)(31696002)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1NZQ0h3Uk5samE3c3BHUE83RlFyd3FueXdMNWkzME9ibG5uMWtTZ2Z4eHJZ?=
 =?utf-8?B?VVVvOFNDdms4WEw0enpIekpyeVg4TTAvZEx4L3NnQ2JvT2JvS3UxR0V3VWJK?=
 =?utf-8?B?SWE5VmMrTENubngwbm1BWG94MTcyM0RYQUlVTzVNQThwUlFyTUZtM1J4ay93?=
 =?utf-8?B?RnVjdlE0VExPTXR0ZkwwUUZGUk8xckVidm5aUVg3NTJmMkJWcHFSNTNQVVJ1?=
 =?utf-8?B?UU5sNnU0ODBGMEZaUzVzdm5VRHFsS3dVL1VvU3I5dkFGWGp5K3l3YUdtS3dN?=
 =?utf-8?B?YjdDYWpZME9VVUgxR3VkSzZtODZYbUpXQkpRYVJpSWN6am44RTVIUXR6eHpS?=
 =?utf-8?B?ODczNFNoWCtsd3cxUEpQZENjZTdCQzRhM2x6eTJUK1JpajBKS2lvblBTS1dD?=
 =?utf-8?B?cVk2YlpJMk54UG1jd08yS0lETTJRUWtKNlNEYXhLejFkbzZLNEJVc3doeU5P?=
 =?utf-8?B?OHovemxmQk9Sb0xkZUZiYnZaR3lxQmc4VEhQdVVIRlBoUFN4VkJ1Z1VoVGZW?=
 =?utf-8?B?UG1aVFV4eVNuaHEvcDBUOVg2U1Zsa1dFM0Vad3ZnS3RqenMrTjMwM3E1VmNU?=
 =?utf-8?B?MUpxbWtkZEdWbm82SjM2akV4TGRMbkcrQzdvOWVJM01HaCs5RzR4QWpETFBw?=
 =?utf-8?B?VXEzZ2VBKzY1QldFaFRXaHdLTFhhUjF1YldkQ2lMYlRDcEREUWNHdUExcTE2?=
 =?utf-8?B?S3J1V2U2eXl4YWFBMmJjTTlzaWFXWWtmU204UVpvOFhpRWRHMlFUR1pPR3ZU?=
 =?utf-8?B?eDRheTBIZjZkeks4dmdQaDlUSS9Vc1VvY3BaTDV5bmdoWjRCR2dRbGhFRS9Y?=
 =?utf-8?B?bEFzNmo3Wmh1Y3M0TEdyV3laU2RrVTRqbGYzQzBCTENaM3NEQUlmbUZBOGs3?=
 =?utf-8?B?SEVZQ242elF2Z2pqVEVDMjYyMCtnNFhGaVcrNmhkRFltRDZiN0o3V2x2WCtX?=
 =?utf-8?B?VmY5eXlTM0VqdDZhbCtuSHRBSVh6UitLbTdFUjlnbGNTNWExZE12dWVlSVJw?=
 =?utf-8?B?Myt3SkxWWWhZUS9BS2N3NVQwR0IyUnNIOHRvZ1Bsd1ZYV3pTZXpnQnl5cHVZ?=
 =?utf-8?B?V25IOW82SDN5ekIvVHBmUUtONzV2OW1NSXVxd2dESlRsdnlKZ0t3ajBhNVdo?=
 =?utf-8?B?Zi9nNUpWU2NpSVdDaVJPaVlHNXkzN3ozWlFBS3FiaklqU3Y3Mk02dG5nQWVk?=
 =?utf-8?B?QlAzUFhUYkh4Zy9SZXMraTd3ZVZ1b1RNb0hFNkxrU253UEIwWlkweDZEWEtT?=
 =?utf-8?B?dm5TQ01SbzRwbTBvdG4rMUJWSkRGeHlROVhlSlJmTnUvci9VRU53eGhTRnNp?=
 =?utf-8?B?YU9iKzVzMkdsK05RVENuMGFGQk9UbGNCa2IrNjlGWWNqa3RHRzRXNjdhakhi?=
 =?utf-8?B?allCczAzQ2RzRExZTTR5SmkxZG02cXJWUDFUMWwwTzdyZ2hJZ0VKWER2RHNX?=
 =?utf-8?B?bmZaV2tQYmhacW82akxZaWtlTkpEYjc5NWY1K2h0d1VmZXcrdGR4MXI4NXMw?=
 =?utf-8?B?WWR2aUFhei9kWStrL0FoU2xabmlKUE41UEE2QldFWi93dnlQTHoycCtvNG1v?=
 =?utf-8?B?VXppTEpFU2FjdjJEcUVXdnZnWnBJWHdQK1d0SUwzOU92VWlpZTJuSmxBaURo?=
 =?utf-8?B?N0pVTVFOdlN3NkJKRTN3RU1paFEyR0hZdjhWbFBWbEQveUozSGZKVHpyUzYz?=
 =?utf-8?B?NS9yM1E4ZmszcG9oUGt2RTZzTUh1VkgrRFlrRjR3NEtnVTdKcmZSWEFpSUk4?=
 =?utf-8?B?WWNUWjlKTHN6c2I2b1RxZnZUOUIrSU5OU1V0NEYwN0YxbXZJamNERWtUSkhD?=
 =?utf-8?B?MjZjMEVpREp1dEdZYmF6b09uK2tBNmR6K1lpZlNuaUpiWUE4cDZlWWZldllN?=
 =?utf-8?B?aEtYVGthTTdndk1CRHBad1JrTWpCdUZ1YnFRNHdiNHltVzJOSU81KzBJZkxV?=
 =?utf-8?B?NnlNL1Vqc2VEUlAzQnpRdW93czhRdTZTY0RMankwYWRyRGNrMm51bnlSOUcv?=
 =?utf-8?B?ZlduelZxMmlCMnZweGs1bEd5N3dYNHBiSzRxYUdITXNOK1BpOW1NRERQc1ZD?=
 =?utf-8?B?VE1UeUkrcW1sQlQxYnBsYTZQYVhEQjBwdHRzNUZpa29vaWV1c29zLzNJdkRy?=
 =?utf-8?B?OUhZQS83RHV1NTBhZ0lVdHZDOGNJUFVPVG1EWEcwR2o3NWd2bTFOZ1VpTGRT?=
 =?utf-8?B?UEUxY3pORDM1bTJLa3ZUWlJJRkFWNkZoR0Iva1RZdmZySTlsYzV1N2d0eGM4?=
 =?utf-8?B?bTlaRkkwbWFXdCt2b2pTeEFuS0VnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41A7D9C1262C8A43AD794D912F3162B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fa6c08-f044-4102-c977-08d9c5134053
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 06:21:12.3138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hOa5UYHvLqMkQsVrl4fAwFTpitdsmniyx+nvMyyr2SPKt9GixNDJFCrBLtXz677eqCgtgHuMYjBiqpvIrxc86rXjgxq0mjzgObswdfrx2Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMTIuMjAyMSAyMzoyNSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRm9yIHRoZSBTRElPIGRyaXZlciwg
dGhlIFJFU0VUL0VOQUJMRSBwaW5zIG9mIFdJTEMxMDAwIGFyZSBjb250cm9sbGVkDQo+IHRocm91
Z2ggdGhlIFNESU8gcG93ZXIgc2VxdWVuY2UgZHJpdmVyLiAgVGhpcyBjb21taXQgYWRkcyBhbmFs
b2dvdXMNCj4gc3VwcG9ydCBmb3IgdGhlIFNQSSBkcml2ZXIuICBTcGVjaWZpY2FsbHksIGR1cmlu
ZyBpbml0aWFsaXphdGlvbiwgdGhlDQo+IGNoaXAgd2lsbCBiZSBFTkFCTEVkIGFuZCB0YWtlbiBv
dXQgb2YgUkVTRVQgYW5kIGR1cmluZw0KPiBkZWluaXRpYWxpemF0aW9uLCB0aGUgY2hpcCB3aWxs
IGJlIHBsYWNlZCBiYWNrIGludG8gUkVTRVQgYW5kIGRpc2FibGVkDQo+IChib3RoIHRvIHJlZHVj
ZSBwb3dlciBjb25zdW1wdGlvbiBhbmQgdG8gZW5zdXJlIHRoZSBXaUZpIHJhZGlvIGlzDQo+IG9m
ZikuDQo+IA0KPiBCb3RoIFJFU0VUIGFuZCBFTkFCTEUgR1BJT3MgYXJlIG9wdGlvbmFsLiAgSG93
ZXZlciwgaWYgdGhlIEVOQUJMRSBHUElPDQo+IGlzIHNwZWNpZmllZCwgdGhlbiB0aGUgUkVTRVQg
R1BJTyBzaG91bGQgbm9ybWFsbHkgYWxzbyBiZSBzcGVjaWZpZWQgYXMNCj4gb3RoZXJ3aXNlIHRo
ZXJlIGlzIG5vIHdheSB0byBlbnN1cmUgcHJvcGVyIHRpbWluZyBvZiB0aGUgRU5BQkxFL1JFU0VU
DQo+IHNlcXVlbmNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTW9zYmVyZ2VyLVRhbmcg
PGRhdmlkbUBlZ2F1Z2UubmV0Pg0KDQpBbHNvLCBmcm9tIHY1Og0KUmV2aWV3ZWQtYnk6IENsYXVk
aXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIHwgNjIgKysrKysrKysr
KysrKysrKysrLQ0KPiAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5j
ICAgIHwgIDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNjAgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2No
aXAvd2lsYzEwMDAvc3BpLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEw
MDAvc3BpLmMNCj4gaW5kZXggNWFjZTllM2E1NmZjOC4uMmMyZWQ0YjA5ZWZkNSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zcGkuYw0KPiBAQCAt
OCw2ICs4LDcgQEANCj4gICNpbmNsdWRlIDxsaW51eC9zcGkvc3BpLmg+DQo+ICAjaW5jbHVkZSA8
bGludXgvY3JjNy5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2NyYy1pdHUtdC5oPg0KPiArI2luY2x1
ZGUgPGxpbnV4L2dwaW8vY29uc3VtZXIuaD4NCj4gDQo+ICAjaW5jbHVkZSAibmV0ZGV2LmgiDQo+
ICAjaW5jbHVkZSAiY2ZnODAyMTEuaCINCj4gQEAgLTQ1LDYgKzQ2LDEwIEBAIHN0cnVjdCB3aWxj
X3NwaSB7DQo+ICAgICAgICAgYm9vbCBwcm9iaW5nX2NyYzsgICAgICAgLyogdHJ1ZSBpZiB3ZSdy
ZSBwcm9iaW5nIGNoaXAncyBDUkMgY29uZmlnICovDQo+ICAgICAgICAgYm9vbCBjcmM3X2VuYWJs
ZWQ7ICAgICAgLyogdHJ1ZSBpZiBjcmM3IGlzIGN1cnJlbnRseSBlbmFibGVkICovDQo+ICAgICAg
ICAgYm9vbCBjcmMxNl9lbmFibGVkOyAgICAgLyogdHJ1ZSBpZiBjcmMxNiBpcyBjdXJyZW50bHkg
ZW5hYmxlZCAqLw0KPiArICAgICAgIHN0cnVjdCB3aWxjX2dwaW9zIHsNCj4gKyAgICAgICAgICAg
ICAgIHN0cnVjdCBncGlvX2Rlc2MgKmVuYWJsZTsgICAgICAgLyogRU5BQkxFIEdQSU8gb3IgTlVM
TCAqLw0KPiArICAgICAgICAgICAgICAgc3RydWN0IGdwaW9fZGVzYyAqcmVzZXQ7ICAgICAgICAv
KiBSRVNFVCBHUElPIG9yIE5VTEwgKi8NCj4gKyAgICAgICB9IGdwaW9zOw0KPiAgfTsNCj4gDQo+
ICBzdGF0aWMgY29uc3Qgc3RydWN0IHdpbGNfaGlmX2Z1bmMgd2lsY19oaWZfc3BpOw0KPiBAQCAt
MTUyLDYgKzE1Nyw1MCBAQCBzdHJ1Y3Qgd2lsY19zcGlfc3BlY2lhbF9jbWRfcnNwIHsNCj4gICAg
ICAgICB1OCBzdGF0dXM7DQo+ICB9IF9fcGFja2VkOw0KPiANCj4gK3N0YXRpYyBpbnQgd2lsY19w
YXJzZV9ncGlvcyhzdHJ1Y3Qgd2lsYyAqd2lsYykNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3Qgc3Bp
X2RldmljZSAqc3BpID0gdG9fc3BpX2RldmljZSh3aWxjLT5kZXYpOw0KPiArICAgICAgIHN0cnVj
dCB3aWxjX3NwaSAqc3BpX3ByaXYgPSB3aWxjLT5idXNfZGF0YTsNCj4gKyAgICAgICBzdHJ1Y3Qg
d2lsY19ncGlvcyAqZ3Bpb3MgPSAmc3BpX3ByaXYtPmdwaW9zOw0KPiArDQo+ICsgICAgICAgLyog
Z2V0IEVOQUJMRSBwaW4gYW5kIGRlYXNzZXJ0IGl0IChpZiBpdCBpcyBkZWZpbmVkKTogKi8NCj4g
KyAgICAgICBncGlvcy0+ZW5hYmxlID0gZGV2bV9ncGlvZF9nZXRfb3B0aW9uYWwoJnNwaS0+ZGV2
LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiZW5h
YmxlIiwgR1BJT0RfT1VUX0xPVyk7DQo+ICsgICAgICAgLyogZ2V0IFJFU0VUIHBpbiBhbmQgYXNz
ZXJ0IGl0IChpZiBpdCBpcyBkZWZpbmVkKTogKi8NCj4gKyAgICAgICBpZiAoZ3Bpb3MtPmVuYWJs
ZSkgew0KPiArICAgICAgICAgICAgICAgLyogaWYgZW5hYmxlIHBpbiBleGlzdHMsIHJlc2V0IG11
c3QgZXhpc3QgYXMgd2VsbCAqLw0KPiArICAgICAgICAgICAgICAgZ3Bpb3MtPnJlc2V0ID0gZGV2
bV9ncGlvZF9nZXQoJnNwaS0+ZGV2LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgInJlc2V0IiwgR1BJT0RfT1VUX0hJR0gpOw0KPiArICAgICAgICAgICAg
ICAgaWYgKElTX0VSUihncGlvcy0+cmVzZXQpKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAg
IGRldl9lcnIoJnNwaS0+ZGV2LCAibWlzc2luZyByZXNldCBncGlvLlxuIik7DQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKGdwaW9zLT5yZXNldCk7DQo+ICsgICAgICAg
ICAgICAgICB9DQo+ICsgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAgICAgICAgIGdwaW9zLT5y
ZXNldCA9IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsKCZzcGktPmRldiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJyZXNldCIsIEdQSU9E
X09VVF9ISUdIKTsNCj4gKyAgICAgICB9DQo+ICsgICAgICAgcmV0dXJuIDA7DQo+ICt9DQo+ICsN
Cj4gK3N0YXRpYyB2b2lkIHdpbGNfd2xhbl9wb3dlcihzdHJ1Y3Qgd2lsYyAqd2lsYywgYm9vbCBv
bikNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3Qgd2lsY19zcGkgKnNwaV9wcml2ID0gd2lsYy0+YnVz
X2RhdGE7DQo+ICsgICAgICAgc3RydWN0IHdpbGNfZ3Bpb3MgKmdwaW9zID0gJnNwaV9wcml2LT5n
cGlvczsNCj4gKw0KPiArICAgICAgIGlmIChvbikgew0KPiArICAgICAgICAgICAgICAgLyogYXNz
ZXJ0IEVOQUJMRTogKi8NCj4gKyAgICAgICAgICAgICAgIGdwaW9kX3NldF92YWx1ZShncGlvcy0+
ZW5hYmxlLCAxKTsNCj4gKyAgICAgICAgICAgICAgIG1kZWxheSg1KTsNCj4gKyAgICAgICAgICAg
ICAgIC8qIGRlYXNzZXJ0IFJFU0VUOiAqLw0KPiArICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3Zh
bHVlKGdwaW9zLT5yZXNldCwgMCk7DQo+ICsgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAgICAg
ICAgIC8qIGFzc2VydCBSRVNFVDogKi8NCj4gKyAgICAgICAgICAgICAgIGdwaW9kX3NldF92YWx1
ZShncGlvcy0+cmVzZXQsIDEpOw0KPiArICAgICAgICAgICAgICAgLyogZGVhc3NlcnQgRU5BQkxF
OiAqLw0KPiArICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3ZhbHVlKGdwaW9zLT5lbmFibGUsIDAp
Ow0KPiArICAgICAgIH0NCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCB3aWxjX2J1c19wcm9iZShz
dHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQ0KPiAgew0KPiAgICAgICAgIGludCByZXQ7DQo+IEBAIC0x
NzEsNiArMjIwLDEwIEBAIHN0YXRpYyBpbnQgd2lsY19idXNfcHJvYmUoc3RydWN0IHNwaV9kZXZp
Y2UgKnNwaSkNCj4gICAgICAgICB3aWxjLT5idXNfZGF0YSA9IHNwaV9wcml2Ow0KPiAgICAgICAg
IHdpbGMtPmRldl9pcnFfbnVtID0gc3BpLT5pcnE7DQo+IA0KPiArICAgICAgIHJldCA9IHdpbGNf
cGFyc2VfZ3Bpb3Mod2lsYyk7DQo+ICsgICAgICAgaWYgKHJldCA8IDApDQo+ICsgICAgICAgICAg
ICAgICBnb3RvIG5ldGRldl9jbGVhbnVwOw0KPiArDQo+ICAgICAgICAgd2lsYy0+cnRjX2NsayA9
IGRldm1fY2xrX2dldF9vcHRpb25hbCgmc3BpLT5kZXYsICJydGMiKTsNCj4gICAgICAgICBpZiAo
SVNfRVJSKHdpbGMtPnJ0Y19jbGspKSB7DQo+ICAgICAgICAgICAgICAgICByZXQgPSBQVFJfRVJS
KHdpbGMtPnJ0Y19jbGspOw0KPiBAQCAtOTgzLDkgKzEwMzYsMTAgQEAgc3RhdGljIGludCB3aWxj
X3NwaV9yZXNldChzdHJ1Y3Qgd2lsYyAqd2lsYykNCj4gDQo+ICBzdGF0aWMgaW50IHdpbGNfc3Bp
X2RlaW5pdChzdHJ1Y3Qgd2lsYyAqd2lsYykNCj4gIHsNCj4gLSAgICAgICAvKg0KPiAtICAgICAg
ICAqIFRPRE86DQo+IC0gICAgICAgICovDQo+ICsgICAgICAgc3RydWN0IHdpbGNfc3BpICpzcGlf
cHJpdiA9IHdpbGMtPmJ1c19kYXRhOw0KPiArDQo+ICsgICAgICAgc3BpX3ByaXYtPmlzaW5pdCA9
IGZhbHNlOw0KPiArICAgICAgIHdpbGNfd2xhbl9wb3dlcih3aWxjLCBmYWxzZSk7DQo+ICAgICAg
ICAgcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiBAQCAtMTAwNiw2ICsxMDYwLDggQEAgc3RhdGljIGlu
dCB3aWxjX3NwaV9pbml0KHN0cnVjdCB3aWxjICp3aWxjLCBib29sIHJlc3VtZSkNCj4gICAgICAg
ICAgICAgICAgIGRldl9lcnIoJnNwaS0+ZGV2LCAiRmFpbCBjbWQgcmVhZCBjaGlwIGlkLi4uXG4i
KTsNCj4gICAgICAgICB9DQo+IA0KPiArICAgICAgIHdpbGNfd2xhbl9wb3dlcih3aWxjLCB0cnVl
KTsNCj4gKw0KPiAgICAgICAgIC8qDQo+ICAgICAgICAgICogY29uZmlndXJlIHByb3RvY29sDQo+
ICAgICAgICAgICovDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2No
aXAvd2lsYzEwMDAvd2xhbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMx
MDAwL3dsYW4uYw0KPiBpbmRleCAzZjMzOWMyZjQ2ZjExLi4xYTM3YTQ5ZmU2NDc3IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93bGFuLmMNCj4g
QEAgLTEyNTQsNyArMTI1NCw3IEBAIHZvaWQgd2lsY193bGFuX2NsZWFudXAoc3RydWN0IG5ldF9k
ZXZpY2UgKmRldikNCj4gICAgICAgICB3aWxjLT5yeF9idWZmZXIgPSBOVUxMOw0KPiAgICAgICAg
IGtmcmVlKHdpbGMtPnR4X2J1ZmZlcik7DQo+ICAgICAgICAgd2lsYy0+dHhfYnVmZmVyID0gTlVM
TDsNCj4gLSAgICAgICB3aWxjLT5oaWZfZnVuYy0+aGlmX2RlaW5pdChOVUxMKTsNCj4gKyAgICAg
ICB3aWxjLT5oaWZfZnVuYy0+aGlmX2RlaW5pdCh3aWxjKTsNCj4gIH0NCj4gDQo+ICBzdGF0aWMg
aW50IHdpbGNfd2xhbl9jZmdfY29tbWl0KHN0cnVjdCB3aWxjX3ZpZiAqdmlmLCBpbnQgdHlwZSwN
Cj4gLS0NCj4gMi4yNS4xDQo+IA0KDQo=
