Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6843C374
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbhJ0HEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:04:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21424 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbhJ0HEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:04:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635318137; x=1666854137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qhMo8xrSBAMfFNZNMm0m3/BHvRT7X5XsFjd0rNG/tsM=;
  b=cXLiNtylg6bZGxQl/LVD9yhyU+KUkVpfmX1Yq2QL2Y7o3aw3FQkTzxlK
   CTC/fwI4ZJaoaGBbxIZXU8kL+f9m+xHwBsG1ex0O2JEX0QAhvWd9+2QZK
   gCcusVNK5ZOR/bwDqJ/YCQrhCT+BW9cRV6HnLzt9ZPSLloMLPigUtoSqb
   GHpdnRxpyeX+ff9r6CMzKowIOERUrVPcYFjR0kqdLpGwmMfj9NytyKIzu
   p08emfrXH3BTqAxYomrKFAg+gdHJC1BwInHcp59Ex+6dzTz6G1t2LvPHF
   TESXo8gQ9dbkxEvCY1rA9eRK05l7h5h8qq175aE7P3TLEHhc777wvCKLe
   Q==;
IronPort-SDR: 51JS/aaY5ld7aWZo8hPeFoW0pKhlw5arQQ6D6IYhuvTJEp44OECPG4IBIvLYuqWHZjOMblrfSo
 DM+3TKD3hTEICSosksn4pZI6t1UpRLjo/TkoWjNNw4rLjqufizGU4mWrJJUG0uubBt9dEWSUbU
 ZSfQaOgoDHxIUZOLy2dX2ZiDFevtsUe5aYInj4WjEZBrl9yH2HWBc+7ij7+8EGyOGz5wztkFfP
 uiU3ABhJov7bxQGrktJ6l4TacQZePWPlCNqCpt7ejX49/17xjJEu0669y3DDOtsBhmdW0On8vS
 qZumOQMlCRSD8TACBPhrTeiq
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="141805990"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 00:02:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 00:02:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 00:02:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsTBW5osBA02YLCgeXLoILRtCZVpH1iZP6DipEXS5+ZXWhg7nCJLiHPoz8MZf+p/nJ5KplAZKBtZEV0Y+N5zhDk4pNmslrfebs3AYuhpoG+phyUiDfm3AttebDBke3dqDdi8ZH54jZecR0Y/mL749LmG1awX1nwx2Y1egCxUpDMm1WBYA87e+pa9mWhM3MQHAx2/v+7IojKLP5I0zaLsYS1etSMB39OiqT+IHxw8Ann+ghChUWQV/T61Dnyc/BvcJ0dqaH7mG5scdo0O5luGK1MHIewtrI3QQw01/t2ZlGswQrMV2SXOgg3tAgT5T4lTxuKkFYQ7eaajz+coJQz7yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhMo8xrSBAMfFNZNMm0m3/BHvRT7X5XsFjd0rNG/tsM=;
 b=RKbQeBH/iaf2EjnOnIRsf+NSJYhsr66KQAPn4XSvaKRCUQSXvAsdu7Arlw9O7mEQUAL0y71r6jLF89dl3NFOLX3uf2CLBdjiteFG5WqwSw9+9QmFBGNlyeCMFDPVyYNW+uHf5vx9vK/8V+B2lmru3VIOYKqDWgNJY22h+jiEuivneMYQ8824ePbi0kFj1pFxcF7IvjizxwsIjJNclFoEsn7sw5UHDpul2LALl7bu4JhuPgAE9KUmBkwiu5MQrIiEgEWLk0pqtGu66d3EzzineVNX/+tADaIiuZqZcDE9L+TbC/FHfaobRbJvDgKAXC2AurueD2MM6fgzE1yjSrKSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhMo8xrSBAMfFNZNMm0m3/BHvRT7X5XsFjd0rNG/tsM=;
 b=lupFnr+ckSYzUP6DdGqP7w9BmP7275GD3WcV7DoK9Ji90dCAMWr8osnI4EQ8CRKyKDiAf6V18y9q5Kibpyzlkr2INxwCgCR4r6vwtrRLruAsgnbIyMSdQ5m/kTQ+JIledU/c69sYpwVCTx0vFkPWbi+ZS1+J5mnfs8/QKI6/7fo=
Received: from DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15)
 by DM6PR11MB4188.namprd11.prod.outlook.com (2603:10b6:5:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 07:02:12 +0000
Received: from DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c]) by DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c%9]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 07:02:11 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <sean.anderson@seco.com>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <Claudiu.Beznea@microchip.com>, <atenart@kernel.org>,
        <pthombar@cadence.com>, <mparab@cadence.com>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Thread-Topic: [PATCH v4] net: macb: Fix several edge cases in validate
Thread-Index: AQHXywCQ40DLc8J0zkeJSHc69ABsOw==
Date:   Wed, 27 Oct 2021 07:02:11 +0000
Message-ID: <7022cd00-e863-d0ed-3a48-8fe9d48968e2@microchip.com>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
 <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
 <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
 <b911cfcc-1c6f-1092-3803-6a57f785bde1@seco.com>
 <YXhIvQiTTiHrmrBm@shell.armlinux.org.uk>
 <7d3d60af-d089-c7bd-bef7-d60d86b97333@seco.com>
In-Reply-To: <7d3d60af-d089-c7bd-bef7-d60d86b97333@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: seco.com; dkim=none (message not signed)
 header.d=none;seco.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c44f51e5-1e8b-4fba-4f48-08d99917b33c
x-ms-traffictypediagnostic: DM6PR11MB4188:
x-microsoft-antispam-prvs: <DM6PR11MB4188D30B9005B006DCF705C4E0859@DM6PR11MB4188.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+sGeYLTqXqTmkt2cOP/bB0VmClJgOBH5xANNyJTK4PJjYCvr20YDmt74S8giZnXDVnfRM6dG4dBnLgSL6o1UoLqY7HA9OY2tYStT5uyR7ogouGBEJrc+8tqHh/vvXUHjxRc+/BObS17iCZ/ASENRWU7HYbAy37Q6HQFEFYxF0m3DYNIySh0pHsXpwFJWwslz28I8c73Ah9Z4Ut/28dEE2Y0cwjmlzIToLsL1dccDdHL+n9M66jQKxMBsE1ZC0vNZoyOCIvoB9hNS0WCKgb1ZQOVAdiegNGCKU/SKffr0aj34cLuTHr6JOuJVtU3m8wLoVxu0k/WgELpu2MlXmPZNA2Y+ZR9Ub9Dktx16WToQ2eVvVWL/UcHYkyWAX+HNJN5eu6ZpnqfpwHRmXymndzv+0fhdk847VwYRTxD5b9yk/ZqI1sk0QfTBFa2ipHt9El3w7S4nMZLjEy0uHvbtAY28mqLdRfpW75fWJMZFUH9Avifr6XVK9MOKdVXujNvJkv1pou19RVq0x2ym6fzDjmRFZIboIcTjPspk7c4f2knFOPEV46R+lHMLk6WrLFPAdR26gb/RpUYxR7Lo1j2MCuoJSVisvpBHPCmBzBsvSuXqpNwrKJifdGy7g1uw0Iw8nxBAGGeGMhylmnv56dBxkPNnr2ab45CNX01rQcRNPYTJbmvi3HAfHu1gpFIL+FwmaScmlh0LfqBdXmPeUFNlOC3zxo41cpWmqQG6/FhIZpn+Xpg1yRXmhwD9tNVuWoQVgs2cNVRYF0zkwtwBZdfhqKOrtLHaL1DNcFbcN3Ap0n2J4yMXoKjAxymi4SK2FNZbNC0tGsKm6/yIYrP1r+/Ov3bFcGdKzJ7kBqvkG6hTd906eSsUyeqIkv0NmcB3jeHoW1a3FsfV/veaeZV9bbY2hgf9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5536.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(53546011)(8936002)(316002)(5660300002)(2906002)(76116006)(38100700002)(6506007)(66946007)(91956017)(31696002)(38070700005)(66556008)(64756008)(8676002)(122000001)(66476007)(86362001)(2616005)(508600001)(6512007)(110136005)(36756003)(54906003)(186003)(6486002)(966005)(83380400001)(71200400001)(31686004)(66446008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXJ6Q0tiN3gySlpWTnBhSGdyK2FxeDFIVkp4NnN6Y3NzNVhKZzB1Y0ROSTRE?=
 =?utf-8?B?YVd4d2drYlVCYkRIZnl1bDZkekoyd3RwSGdXdWk0Qmd3N0hyR1IzVmRaWklt?=
 =?utf-8?B?cExodEsyL0dEazVTZG5SSW5uVmx4NWhyRkxmNyt4Y1FXKzNJV0VwdFJTN2lK?=
 =?utf-8?B?UDJQVXJYeUYxbENlQmd4Q0Y1a3lCbGFhcDF1OUVIV3grM2NJZGhuYlJwM3Zo?=
 =?utf-8?B?c1VoRzFNOE1xVm5ibTZBcUNSYlVoYjU0ajFlNjFmZVFSNWw4VnlNMFpnT3Vn?=
 =?utf-8?B?NjVLWEx0MjVMb3lkZC9HTnE5dTdYWjFxSVlqU21XSi91MjBlRnFrek9FRlBR?=
 =?utf-8?B?VHY3RVM3RCthazV0QmtsdlVLMGhvaUh1cCtybGJ6b01jL2txMFNtcFBIWEJy?=
 =?utf-8?B?VkpJUzJuWTlycjNMRE0rRU90M0ZTbnB2cUFObEgyK08yS2Iva2JVOC92RHBp?=
 =?utf-8?B?ZkpxQkNZRzNnR1crSjIyZzNQT2RBbFF2eEJCMlY3cXFIRWUzSjFlbnQvdng0?=
 =?utf-8?B?Q1hnd0lDRmdNbnBIZi95TE56Kytlekd6S2NkblRSUTJkRXhkQXpFeDdVbGN2?=
 =?utf-8?B?UWtINU1sNTUzVlBRRUVja2ZDRFoyVTJGTko0K1ZJUVZCZ0l5R3RoMGlyNldt?=
 =?utf-8?B?alRrODY0SU43VW0rVllVdzhNbk91Y0ZDNFg3cnZxU3hLSTFmSFlYZlJtVkVx?=
 =?utf-8?B?cTVBQjl1UXNLODF2NGt2YkhJS25tb1dzL1pNYkxFZjFMWDI3cHhTUkhTY0lG?=
 =?utf-8?B?ZThoS1Y4a1FncVlJMURNSkI0T00zYVhKdit1UEY2WXFSb2NKb1FGZFdMU0cx?=
 =?utf-8?B?ZVhZcm1DMEdEZXRYc01XZWwzaHNERER2Tjgvd2Nwb0o1d1Z4SWxBRTlpL1gr?=
 =?utf-8?B?aEdlZllJY29aaFRVbmxoUEFVMGsxNlg1OFFPZnpDMUxpaHVPdXVheUphb1hw?=
 =?utf-8?B?eVNBYWo1NXZCMWppeFNyVXd4MVBveU9heGNnYVc5UThITm9MTnVvMHRKY3NP?=
 =?utf-8?B?aWlTd3pHdEpjaVd2aWtCbTBWQXFzSnJPa3dFVVlIMTkza3hnRU5kSVFpSTdK?=
 =?utf-8?B?TmdJKzV2RTVZTzNTVW1RTGh6NndQOTBTbk82LzR5dy9NdkJydktuMmJWYU9y?=
 =?utf-8?B?NlowN0R4ZzZsQ2FKdGNSQjlQd2tQbXgxd0RySmI1UVlEZ21LcHo2T214ZkMy?=
 =?utf-8?B?MjQrU0RXTUxvSk52VnIrSG9QZXExcTNqNWd1cUw3b0U3V05ETnh0YjZUQnVE?=
 =?utf-8?B?WTNNV1ZJb293WDdCTCt3Y3lUcHJvWVYzbVYrMERleGRlb2Z5L2RGMmRla0Zy?=
 =?utf-8?B?MUtSL0FPcFJaSWpvT3hzajlFVjdmelNRK2ptRUllZzVjMWtTTDJtQVZ0MGpV?=
 =?utf-8?B?ejV6SGU2VzRISFFUV0o3a1RsRzlsbTZudEtsb0ZPSUZQcUwySjlRZk54VUJL?=
 =?utf-8?B?Z0cvVFlMT1ZxQS9HZmMrdWtKd1kxVEZzUXA2eWg2ZzZFNlRoUDZxaFBJeFg4?=
 =?utf-8?B?VVI0emdnQlFJRmpITytNcjl4VVdycU5LaVpSb29sM1pla3VTdzNIQWxtcENE?=
 =?utf-8?B?ek14eDlUMElTQlhmQUNKcEtXajkweGRabzFlNUtJTGpNQjFBbHVHajd4Qzli?=
 =?utf-8?B?cnVRTzlobUllcHRFOC9tUTFmQXlOclR5VE82Y0FoVlNaZ2NjNUZoTGltZjJo?=
 =?utf-8?B?b1VTYWZya1V1OFlVZDlJSXJjNzBScGw1SmVXWnlmQ01mbHE3WERhR21wRE9Q?=
 =?utf-8?B?VTEvd29STTQrYXdpMkRzanI2SkJHZDhWaTRDOXluQ0ljWlI5bDY4aDJIZHJM?=
 =?utf-8?B?eVdzZnJYSHlqb0txekRtZDB6RWRmMFdHWEd5UjlJcjZDZWVEeFM0QlBLd2Ny?=
 =?utf-8?B?N2ZWSFNPRjlEUVM5NGpmNTZFNks1L0NZekdhT3hoeDR6SjVTeXl0S0NsNHk1?=
 =?utf-8?B?Z3RWN1FRWlV2RVV6Y1BCWE54KzhLUkpuNVRFY2g4bXQyeC85MU05SC9uNjNZ?=
 =?utf-8?B?b0VKdm1JNXlxdXhHbE84WDdvSkJsbjlDMlUyVWVRdUxpVjFwM0huNXF5Q2pw?=
 =?utf-8?B?KzVCM0JTdkthc3l2NWQzMVhLOEFlaVl6YkVYd0JYMTBPaWVDQitVQ0E2QkIx?=
 =?utf-8?B?NFBQMTNCS29xWWljOU5Ra2l5cTdnV0hwbWU2aEM5cDJJRGNCUWVvYk5VSEoz?=
 =?utf-8?B?SUdiZFF5UnFVdTltaUZSeEw1SUlTRUJ3bTNXeCtIWlNDWDdyZm1GQ1JhWDJh?=
 =?utf-8?B?OGNScVk0UmJHL0RYam9jakhOZkJhcTBBMG1OaWlNQWFtOU41QzFFT0xUclMv?=
 =?utf-8?B?ZFNyc2djT3RwME44MnRTWlpJUUV2eVJQTEZzTzlaaE1MOGdmTCtDUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD3053821B50774FA1D170A20816C209@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5536.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44f51e5-1e8b-4fba-4f48-08d99917b33c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 07:02:11.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6LfBLmpQoLmsrn1/yFoEvLlC3YliBj2U50IanEnQqWOOWPoZiNjgo70CpgI0f+BqI42H63Y9MRs6vRPLEEUhGKhCVZIv5T5WWotElESjf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4188
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2VhbiwgUnVzc2VsbCwNCg0KT24gMjYvMTAvMjAyMSBhdCAyMDo1MiwgU2VhbiBBbmRlcnNvbiB3
cm90ZToNCj4+DQo+PiBHb2luZyBiYWNrIHRvIHRoZSBmaXJzdCBwb2ludCBJIG1lbnRpb25lZCBh
Ym92ZSwgaG93IG11Y2ggc2hvdWxkIHdlDQo+PiB0YWtlIGZyb20gdGhlc2UgZG9jdW1lbnRzIGFz
IGFjdHVhbGx5IGJlaW5nIGNvcnJlY3Q/IFNob3VsZCB3ZSBub3QNCj4+IGFzc3VtZSBhbnl0aGlu
ZywgYnV0IGluc3RlYWQganVzdCBleHBlcmltZW50IHdpdGggdGhlIGhhcmR3YXJlIGFuZA0KPj4g
c2VlIHdoYXQgd29ya3MuDQo+PiBGb3IgZXhhbXBsZSwgYXJlIHRoZSB0d28gc3BlZWQgYml0cyBp
biB0aGUgUENTIGNvbnRyb2wgcmVnaXN0ZXINCj4+IHJlYWxseSByZWFkLW9ubHkgd2hlbiBpbiBD
aXNjbyBTR01JSSBtb2RlLCBvciBjYW4gdGhleSBiZSBjaGFuZ2VkIC0NCj4+IGFuZCBpZiB0aGV5
IGNhbiBiZSBjaGFuZ2VkLCBkb2VzIHRoYXQgaGF2ZSBhbiBlZmZlY3Qgb24gdGhlIGV0aGVybmV0
DQo+PiBsaW5rPw0KPiBLZWVwIGluIG1pbmQgdGhhdCBpdCBpcyBub3Qgb25seSBaeW5xKE1QKSBw
YXJ0cyB3aXRoIGhhdmUgR0VNcywgYnV0DQo+IHNldmVyYWwgb3RoZXIgU29DcyBhcyB3ZWxsLiBJ
IGhhdmUgbm90IHJldmlld2VkIHRoZWlyIGRhdGFzaGVldHMgKGV4Y2VwdA0KPiBmb3IgU2lGaXZl
J3Mgd2hpY2gganVzdCBzYXkgImdvIHJlYWQgdGhlIExpbnV4IGRyaXZlciIpLiBJdCBpcyBwb3Nz
aWJsZQ0KPiB0aGF0IG90aGVyIFNvQ3MgbWF5IG5vdCBoYXZlIHRoZXNlIGxpbWl0YXRpb25zLiBT
byBhbnkgZXhwZXJpbWVudGFsDQo+IHByb2dyYW0gd2lsbCBuZWVkIHRvIGFsc28gZXhwZXJpbWVu
dCB3aXRoIGUuZy4gc2FtYS4NCg0KQ2xhdWRpdSBhbmQgbXlzZWxmIGNhbiBjZXJ0YWlubHkgaGVs
cCBpbiByZXZpZXdpbmcgYW5kIHRlc3Rpbmcgb24gDQpNaWNyb2NoaXAgZGV2aWNlcy4gVGhlIGxp
bWl0YXRpb24gdGhhdCBJIHNlZSBpcyB0aGF0IHdlIG9ubHkgaGF2ZSAxMC8xMDAgDQphbmQgMTAw
MCBzcGVlZHMgaW1wbGVtZW50ZWQgaW4gb3VyIFNvQyB3aXRoIGxpbWl0ZWQgbnVtYmVyIG9mIGxp
bmsgdHlwZXMgDQpjb3ZlcmVkIChNSUksIFJNSUksIEdNSUkgYW5kIFJHTUlJKS4NCg0KT3VyIGRh
dGFzaGVldHMgaW5jbHVkaW5nIGRpZmZlcmVudCB2YXJpYW50cyBvZiBNQUNCIGFuZCBHRU0gY2Fu
IGdpdmUgDQpzb21lIGluZm9ybWF0aW9uOg0KTUFDQiBleGFtcGxlIGluOiANCmh0dHA6Ly93dzEu
bWljcm9jaGlwLmNvbS9kb3dubG9hZHMvZW4vRGV2aWNlRG9jL1NBTTlYNjAtRGF0YS1TaGVldC1E
UzYwMDAxNTc5QS5wZGYNCg0KR0VNIGV4YW1wbGUgYXQgMTAvMTAwIGluOiANCmh0dHBzOi8vd3d3
Lm1pY3JvY2hpcC5jb20vY29udGVudC9kYW0vbWNocC9kb2N1bWVudHMvTVBVMzIvUHJvZHVjdERv
Y3VtZW50cy9EYXRhU2hlZXRzL1NBTUE1RDItU2VyaWVzLURhdGEtc2hlZXQtZHM2MDAwMTQ3Nkcu
cGRmDQoNCkdFTSBleGFtcGxlIHdpdGggMTAvMTAwLzEwMDAgaW46IA0KaHR0cHM6Ly93d3cubWlj
cm9jaGlwLmNvbS9jb250ZW50L2RhbS9tY2hwL2RvY3VtZW50cy9NUFUzMi9Qcm9kdWN0RG9jdW1l
bnRzL0RhdGFTaGVldHMvU0FNQTVEMy1TZXJpZXMtRGF0YS1zaGVldC1EUzYwMDAxNjA5Yi5wZGYN
Cg0KV2UgY2FuIGFsc28gZXhwbG9yZSBzb21lIG9mIHRoZSBkZXNpZ24gYW5kIGNvbmZpZ3VyYXRp
b24gcmVnaXN0ZXJzIChEQ0ZHbikuDQoNCj4gUGVyaGFwcyBzb21lb25lIGZyb20gY2FkZW5jZSBj
b3VsZCBjb21tZW50IG9uIHdoYXQgaXMgYWN0dWFsbHkgc3VwcG9ydGVkDQo+IGJ5IGdlbS9tYWNi
Pw0KDQpUaGF0IGNvdWxkIGJlIGdvb2QgYXMgd2VsbC4NCg0KQmVzdCByZWdhcmRzLA0KICAgTmlj
b2xhcw0KDQotLSANCk5pY29sYXMgRmVycmUNCg==
