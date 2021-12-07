Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDAE46BC02
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhLGNC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:02:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:35064 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhLGNC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:02:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638881937; x=1670417937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1MT04POYlUhHvC2CC7nUiDF3E3mGH+o+aYes+VbYyvg=;
  b=CYnyNkbNAWFcq8qNSu9A6C1QuSb51vFST/Cg9ga11rhu5KcNTGEgV2b0
   HcfsCNQe6uNK2m32wA8P/F9TvzgV7T6KTq3L6Fb4GS9A1xeGJTpltXcGY
   9R8GXVPOIzXydz8e0u+11JlZyACCgEULSmKdSaFI2ksJcKtu2JA/dMb08
   ZsHBIalQQ7hrxVgCxTNuZuYuTnmKI9peCKaczQQPci5TXj7OiKFYmfSJP
   inmhdiF/T6dQ4A4RhgfTvemeoH4CToWuJTOqAq0+DXod05eVrdEldAYOJ
   AmAwlIljLHZcrkjOyZye7wUtpWClEJYg6B1I9koyqg6BiLZML10mBZRB0
   Q==;
IronPort-SDR: vS/wPqS72dnbEEL7zP3XXCj07sANBiregMfFcL7vCtn30Rq5nXIFuOFCBTdbeGOdyuzaflDlA4
 rKNnyB4k/xrOHDOfW6GH2AP4nF17l3KpLLyheJDdYoM1P6kom26X1aUObqH7ZwpBQJ1lZGwvxu
 2M5G/NRqRQ8W/HPeT6WKPSjDk0m4aH+YoAqwuwtNFxLa9260+0mDpESTDfLoGmm+ViO7X4m1kx
 S8rwgPLZXf+mIkbywVblFRAOy4cPuCQQGZYTNFVTBtN7Ph0L6Cjw5aDZcxoR/HYYOCa8iI+7lX
 uvE5Lha7SC/mZYJoXjYtHEWt
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="78755763"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2021 05:58:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Dec 2021 05:58:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Tue, 7 Dec 2021 05:58:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+TYGv+4SF4vmc7KVz3t1h+MEVkBHqMyubZLx7wHLVKm++8zAgIDltNnz/duQ1XY/fw2hEY3GuHNjdayH5D5D53rZC6D5a7sKLESIpyME3x/LzGmnyHg/nTo+1EqZTea5+7p6xDYS9D758ZTFQSvO0qMYVeh+18PugbiSoguVAJdVCtv0uXZlDVTm0Aot5dsfQMfpXcH4KwjHXgyZ7x33tbwhzt1vLwo0kiPhSGOD0cY8kPJSpCzp6TPvLBd5TQTAfPAbCaReC0DaOzGrtEsdKEZgzQEg3taKB4BaucjZDbMERRIBoZuGqsyIKQgGXRbvanTBnYOrL2+BQkxo5lyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MT04POYlUhHvC2CC7nUiDF3E3mGH+o+aYes+VbYyvg=;
 b=OoUOtUFHxkY4S4GAl4Fu245L0FFI8547kLbfnYIXLVZih8LZR/0Na+heZMRaE6J3Vpcg8eg0wceRSI2GNd8VzDy93z09Ea/Ncl8Tv23PrZPOCVjw/JT5jpB//iCd6JupUhK7eYBB8BgZeeAYdHgrE2rauo8/2bgkTPsOf5EOI+svMpFXM23+xsFdW1x5Tp3hkUiETMcSkPI1061wd8sDzXVfroQfVkl+cPt6KendgQXrDStOtRmgmB+vM0+t9OBoPJn7iBfnHfITndo7gM/U9XJLNnkHoihFvdzKehiTA4L7vj80cSgknztQbLpwmFCV4lFZcGF+o9dtZq820+zXxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MT04POYlUhHvC2CC7nUiDF3E3mGH+o+aYes+VbYyvg=;
 b=WahZ0vdFluVOnbbrBEPK60LllzPu+3nbxvwzKNpgeK1il7xfIe6w83NFII2U3ssXWxRbIf8CxxFdZEL3NqER0Ob3iiUPtIcJGzxusAIb+DOW+9KskCoFHC04vp1yjyM12nsQ39HoP+TzkO1LraGgtTOTgXJQ8sfoqIfLwbxMHwI=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by SJ0PR11MB4797.namprd11.prod.outlook.com (2603:10b6:a03:2d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Tue, 7 Dec
 2021 12:58:45 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%5]) with mapi id 15.20.4755.023; Tue, 7 Dec 2021
 12:58:45 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: Remove misleading USE_SPI_DMA macro
Thread-Topic: [PATCH] wilc1000: Remove misleading USE_SPI_DMA macro
Thread-Index: AQHX6wEKW/DJ7ebylkWRvBnFVU9Yc6wm/lOA
Date:   Tue, 7 Dec 2021 12:58:45 +0000
Message-ID: <bc144dbc-ae56-c763-94f8-c1a5e421e813@microchip.com>
References: <20211207002453.3193737-1-davidm@egauge.net>
In-Reply-To: <20211207002453.3193737-1-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e8e5ec-d4b7-486b-5445-08d9b9814db0
x-ms-traffictypediagnostic: SJ0PR11MB4797:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB47972FBDB33DC340DED60669E36E9@SJ0PR11MB4797.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3AHVtTmn2M0XqXq6QRFj6LeXcr98C9/CIESQqJRGn4wNlQV1YyXff0DW4w/pV2mIk2CsMaY1UjZ//t7qr3P6i1uDEymrtQocEZF/YAzLas+XySewiY2us9JmVCU3QsEA5IiUrBd52wfEQ3feaoUSy2r02hyrphaSQUOCnxh0SbtgeNAUoUzB8biLt5AWiRuxUK2G1Eo2Ah40hfrAD9Vkg64noH+ZoWCsFv6+bmA39GrKf44VD/qJ6NWxgT4kmcprQjtuA7sOmb/h9j1Q7aqtL8CcUfR3a0wYZwJrcAaAaZ+dEdAspiAL39LlNnXPFK3hDkgJ0hLkKtsxlJo7qkq6LjwAeJlGWxf3TIFR8A5jMobyjokVp8UNR0im73eJnUwhyOoICzGpNQO8wscS+C2M/xoqUNReQjjemNif7KVshgoYkm2SvJnJfy/Vgh3OJhXW2UhI8O8XfXmAgjN6DSOqWQGW83BYKCw97ZCsNIFZ8pMcplkr6UG9TALTIXm7Vd2u7pdEmsl4zaHbf38/wetu79+47bzqLKakzTd39OpKiNDorJ4iOfBxuKRhQbZMowuqBx703OiWKPhi5hYNmcYlQKpi51Y53SaimQ3kucb7w3J4qvZJeRyr++zRI6uXbTJwRPbwcYdmAaP3meaqVScSfFd5wiQlGiKPgNL0gIb+jfgCiMhSqIqDqo2AUUH/9r+AF5Kb6wZ9zVj2ciMhlVF6gUFnmri/WG8iEcPaVkZWqsMGFgDzjyzdrOsPfx6ErZnIdFOxabjaM1enJPweEMU5AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(2616005)(86362001)(38070700005)(83380400001)(71200400001)(6916009)(4326008)(66946007)(6486002)(6512007)(508600001)(36756003)(8676002)(6506007)(66476007)(31686004)(5660300002)(66446008)(38100700002)(316002)(53546011)(66556008)(55236004)(54906003)(2906002)(26005)(64756008)(122000001)(91956017)(76116006)(8936002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFVGNnNCOFg0VXJLVXEvV1R5elg5MnhqTEFPL1d2a1JyYXFqdE9lK1Y1bGhD?=
 =?utf-8?B?a0crQlZQQXZ3aDBYTUYxV2VxTllnUVdXckhkeUpIT0g1dC94Rk5BRXgxRnE5?=
 =?utf-8?B?YUhzWStDR1hUTDZ5dFZ2dFFJNDgrbS9lZHg5eDU3NTEwaXpPZXl3eFZpNmVu?=
 =?utf-8?B?WTE1VG83elFzQ1ZtTFNMVVloN1dPcHNvRXgxRjhHWmJMVlhJMEIzcEhVMy80?=
 =?utf-8?B?bVBwZ29taFVCTlViaFhjWjlISnZad0dMZ2RvaXR5T1dyWEdsbkpXQVgrT3cy?=
 =?utf-8?B?aXlhUkNZZy9Mdk5menh2eEhiTmJMRGljanAxbHJTVG5zUUV3bU1qenlybk1k?=
 =?utf-8?B?K2VOZEpWYjhVYTRnOU9WT2xDWGlnemsyMWVFblMwdGphb1pIOEJJQ092ZHph?=
 =?utf-8?B?ZG9HaHYxZjhNM3hPVGVISWpGMjQ2Zk0zdzFOUGZ4SURUNnVDdll1R3c2anl5?=
 =?utf-8?B?emdHSFdFUTlwc2JoU3VPRFNlUzhsRXhvK1RkUno3S25mbXp6MkgvazNCTGZ3?=
 =?utf-8?B?YkZBMDdtSzZWZ2s3RklWUy9lS0liRm82L1ZjS1h6K096aDNnMllNbithZmsx?=
 =?utf-8?B?UGpwYmE4bXgzNHBNVjhpTVNPSk9mTkJKQzg1dkUzU0NCcnp1Vko3aUtvWHJB?=
 =?utf-8?B?ZmZOZXMyOUM5emhLN2x2SEtqU0VhaEp0aE1wcFhuZVdLUW1nb2ZUKzlKVVNs?=
 =?utf-8?B?ZjBGUURSYkpkU2dPRXpEWkNvdWxCSFFCVnRmOFViemlSVnBnUGtnSWxFUEUr?=
 =?utf-8?B?ak5OQWJvU0Z2WHBXQURQMldjVnN1YTNrbHhhZEViVVQ4S1dmdWVoc2NzTEFN?=
 =?utf-8?B?cm9hM2gxSUpWTDYzUGcvRzZTUlBPOVpQSFo4dW9GdUljZEE4bVJoTERud3pJ?=
 =?utf-8?B?T2xIbGVGWmpDN0JBVVk0bHVReG1nZkFXeEhlazhOdjlrRndvZ3E1aWI3ZndR?=
 =?utf-8?B?bk54aFl5NTdMdzc1UWpFWXA1WDVKby9GU3Z6aUlrcUQ4dTI4eFlHUlJ6OVVG?=
 =?utf-8?B?VGdjdU4zalNhd25iVU94L2ttODJ3ZG9VMnJsL1A0TXFFWjlrSkJBdThYWTZM?=
 =?utf-8?B?SjlFUnpLdk9OMHZQUmV5S0NxMXRueHY2NUlhV2s0bTRkM3FhN1E2Y0NlbDRp?=
 =?utf-8?B?ZXZNNnhmRnBhWkN0MDZ3NEhxSTg4UmpkKy9BOVFJT1J2UUR3M0lQbmRGT3Zy?=
 =?utf-8?B?S1RDajhuRnE0WTFweDk0QzBlQ3crejA1MVM0WVhxV2dqOWUvNDRPQ2NzKzNr?=
 =?utf-8?B?SW44SXBkNnNlNU5udzgvU1BaekVxTGt5ZnRZSzJFK1hPWFZ1MHRLS3Q4aUJV?=
 =?utf-8?B?V2VobXhZdCt2Q2tHMU94R1RuZGlXMGw4UnVkNkNsV2tla2srNXRQcU51R2NL?=
 =?utf-8?B?dGd0cXA5UmNvQnpjdHpXeTV4NUFZVGxuVUJ0bjRQUHBxUEhaQk9HS0k4dTcx?=
 =?utf-8?B?VlhXNlU1Tkc0Y0hycWtTeWZIV1A4QmQ4SUlwUUpzN0xqZHhGUjBUcjJYNHF6?=
 =?utf-8?B?akMyYUpnbGxORjdJNC9rK3JkcmI0elg1dlRvcmdwVFY3TnJNYmpMdzZlTGVV?=
 =?utf-8?B?SzZlUXlRTVBoZTlSb20xaE1mSERkUk80TkpqUmhlbk1rZmlmcG83WkZOVDZk?=
 =?utf-8?B?RjhacFl3YUhSOUpIVTQ0SUwzRmtGU0EvZHY5dTdMV0RlL254MlpPTDdnWjJl?=
 =?utf-8?B?NTNuWmVtNjFDeDRjRzFZM1lwS2IxMVI4Y0g4UVNUN3VwK1lOWVpSeGc0NXEy?=
 =?utf-8?B?aFlUbkhiY29rOGdiZXJUQTBRd3E0d2pqT1BVMi9tajFBQ1U3NDdQK2ZWN3RC?=
 =?utf-8?B?QXdQY04zSUN5UzRWQVZYdHVHT09qNVlpckQ5eVdOUFpERUFWTXNLVmUvRHVS?=
 =?utf-8?B?K3NPU0tFZTd4c2pRM0kvcEQzT0pXaHBnWTg4ZzNOZlhTdklJSVpZbDZpNWxw?=
 =?utf-8?B?bW1yWnRrR0FBY0REUW5TMndEdUNiMlpQVWF0eHhLR0JsRE5WdlpCaXU5U2Ra?=
 =?utf-8?B?b0U1enpCYjJ6M01lWm9yeVdTYWF3Z2NJcS9lS043NTNybitQSUc0TWxWaVov?=
 =?utf-8?B?V0hHOFlFT25FeTJtNU9vWit3ekJTeEJ2MDZNT2REZ1Z3bWQxYURDMGE3WTc3?=
 =?utf-8?B?S0hWbzBDaWVNUDhkaC94ZzZOU083MjV0NzZDZXczUEVXQ2xFZHVLZ3dwZi84?=
 =?utf-8?B?Mm1IVXFqTytpMUFqM1lSTVFOdElEVlRzdUdZYWZRaXdpYzEzNWw2UnVUUXR6?=
 =?utf-8?B?NWU1RS9FT1RqUHh5SVlGR0F1TlZnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07B4D9EDBEA0524ABCD860C3FE737DE0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e8e5ec-d4b7-486b-5445-08d9b9814db0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 12:58:45.4290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMYqdKktFZWu06k6WoBXdpasFwAfFK4xq74jZ30I8w+5rdS0gEKsmj9v3InfAEL/vhC6/cx+8auRAV41a3KyinYxnIG5X3ZMoa6vMS0eanY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcvMTIvMjEgMDU6NTYsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gVGhlIFVTRV9TUElfRE1BIG1hY3JvIG5h
bWUgc3VnZ2VzdHMgdGhhdCBpdCBjb3VsZCBiZSBzZXQgdG8gMSB0bw0KPiBjb250cm9sIHdoZXRo
ZXIgb3Igbm90IFNQSSBETUEgc2hvdWxkIGJlIHVzZWQuICBIb3dldmVyLCB0aGF0J3Mgbm90DQo+
IHdoYXQgaXQgZG9lcy4gIElmIHNldCB0byAxLCBpdCdsbCBzZXQgdGhlIFNQSSBtZXNzYWdlcycN
Cj4gImlzX2RtYV9tYXBwZWQiIGZsYWcgdG8gdHJ1ZSwgZXZlbiB0aG91Z2ggdGhlIHR4L3J4IGJ1
ZmZlcnMgYXJlbid0DQo+IGFjdHVhbGx5IERNQSBtYXBwZWQgYnkgdGhlIGRyaXZlci4gIEluIG90
aGVyIHdvcmRzLCBzZXR0aW5nIHRoaXMgZmxhZw0KPiB0byAxIHdpbGwgYnJlYWsgdGhlIGRyaXZl
ci4NCj4NCj4gQmVzdCB0byBjbGVhbiB1cCB0aGlzIGNvbmZ1c2lvbiBieSByZW1vdmluZyB0aGUg
bWFjcm8gYWx0b2dldGhlci4NCj4gVGhlcmUgaXMgbm8gbmVlZCB0byBleHBsaWNpdGx5IGluaXRp
YWxpemUgImlzX2RtYV9tYXBwZWQiIGJlY2F1c2UgdGhlDQo+IG1lc3NhZ2UgaXMgY2xlYXJlZCB0
byB6ZXJvIGFueWhvdywgc28gImlzX2RtYV9tYXBwZWQiIGlzIHNldCB0byBmYWxzZQ0KPiBieSBk
ZWZhdWx0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBNb3NiZXJnZXItVGFuZyA8ZGF2aWRt
QGVnYXVnZS5uZXQ+DQoNCg0KVGhhbmtzIQ0KDQoNCkFja2VkLWJ5OiBBamF5IFNpbmdoIDxhamF5
LmthdGhhdEBtaWNyb2NoaXAuY29tPg0KDQoNCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIHwgNSAtLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCA1IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
L3dpbGMxMDAwL3NwaS5jDQo+IGluZGV4IDY0MDg1MGY5ODlkZC4uMTg1NjUyNWI5ODM0IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvc3BpLmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+
IEBAIC05OSw4ICs5OSw2IEBAIHN0YXRpYyBpbnQgd2lsY19zcGlfcmVzZXQoc3RydWN0IHdpbGMg
KndpbGMpOw0KPiAgICNkZWZpbmUgREFUQV9QS1RfTE9HX1NaICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBEQVRBX1BLVF9MT0dfU1pfTUFYDQo+ICAgI2RlZmluZSBEQVRBX1BLVF9TWiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAoMSA8PCBEQVRBX1BLVF9MT0dfU1opDQo+DQo+IC0j
ZGVmaW5lIFVTRV9TUElfRE1BICAgICAgICAgICAgICAgICAgICAgICAgICAgIDANCj4gLQ0KPiAg
ICNkZWZpbmUgV0lMQ19TUElfQ09NTUFORF9TVEFUX1NVQ0NFU1MgICAgICAgICAgMA0KPiAgICNk
ZWZpbmUgV0lMQ19HRVRfUkVTUF9IRFJfU1RBUlQoaCkgICAgICAgICAgICAgKCgoaCkgPj4gNCkg
JiAweGYpDQo+DQo+IEBAIC0yNDAsNyArMjM4LDYgQEAgc3RhdGljIGludCB3aWxjX3NwaV90eChz
dHJ1Y3Qgd2lsYyAqd2lsYywgdTggKmIsIHUzMiBsZW4pDQo+ICAgICAgICAgICAgICAgICAgbWVt
c2V0KCZtc2csIDAsIHNpemVvZihtc2cpKTsNCj4gICAgICAgICAgICAgICAgICBzcGlfbWVzc2Fn
ZV9pbml0KCZtc2cpOw0KPiAgICAgICAgICAgICAgICAgIG1zZy5zcGkgPSBzcGk7DQo+IC0gICAg
ICAgICAgICAgICBtc2cuaXNfZG1hX21hcHBlZCA9IFVTRV9TUElfRE1BOw0KPiAgICAgICAgICAg
ICAgICAgIHNwaV9tZXNzYWdlX2FkZF90YWlsKCZ0ciwgJm1zZyk7DQo+DQo+ICAgICAgICAgICAg
ICAgICAgcmV0ID0gc3BpX3N5bmMoc3BpLCAmbXNnKTsNCj4gQEAgLTI4NCw3ICsyODEsNiBAQCBz
dGF0aWMgaW50IHdpbGNfc3BpX3J4KHN0cnVjdCB3aWxjICp3aWxjLCB1OCAqcmIsIHUzMiBybGVu
KQ0KPiAgICAgICAgICAgICAgICAgIG1lbXNldCgmbXNnLCAwLCBzaXplb2YobXNnKSk7DQo+ICAg
ICAgICAgICAgICAgICAgc3BpX21lc3NhZ2VfaW5pdCgmbXNnKTsNCj4gICAgICAgICAgICAgICAg
ICBtc2cuc3BpID0gc3BpOw0KPiAtICAgICAgICAgICAgICAgbXNnLmlzX2RtYV9tYXBwZWQgPSBV
U0VfU1BJX0RNQTsNCj4gICAgICAgICAgICAgICAgICBzcGlfbWVzc2FnZV9hZGRfdGFpbCgmdHIs
ICZtc2cpOw0KPg0KPiAgICAgICAgICAgICAgICAgIHJldCA9IHNwaV9zeW5jKHNwaSwgJm1zZyk7
DQo+IEBAIC0zMjMsNyArMzE5LDYgQEAgc3RhdGljIGludCB3aWxjX3NwaV90eF9yeChzdHJ1Y3Qg
d2lsYyAqd2lsYywgdTggKndiLCB1OCAqcmIsIHUzMiBybGVuKQ0KPiAgICAgICAgICAgICAgICAg
IG1lbXNldCgmbXNnLCAwLCBzaXplb2YobXNnKSk7DQo+ICAgICAgICAgICAgICAgICAgc3BpX21l
c3NhZ2VfaW5pdCgmbXNnKTsNCj4gICAgICAgICAgICAgICAgICBtc2cuc3BpID0gc3BpOw0KPiAt
ICAgICAgICAgICAgICAgbXNnLmlzX2RtYV9tYXBwZWQgPSBVU0VfU1BJX0RNQTsNCj4NCj4gICAg
ICAgICAgICAgICAgICBzcGlfbWVzc2FnZV9hZGRfdGFpbCgmdHIsICZtc2cpOw0KPiAgICAgICAg
ICAgICAgICAgIHJldCA9IHNwaV9zeW5jKHNwaSwgJm1zZyk7DQo+IC0tDQo+IDIuMjUuMQ0KPg0K
DQo=
