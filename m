Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F2E475902
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbhLOMoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:44:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28384 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhLOMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639572246; x=1671108246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i2pnURk1c2JK1XNP7TCfUsaqFyipMRUhcc0MtzuGQlg=;
  b=XHQT6U03xq9taWzhh0l1wobwcuz2HZwphzO/g8dmJMwEFDCWqsUSgeAV
   DaaV5C08tUOXw0kvtDpMTvjTYJXDxUqGeKeXPot8HqsjumhkuQEDz9TbH
   JpEnbwJA9UwY5X7Jv811byUl/LovhCUFOMoCGvJ2uMW/8iP/A789luDhr
   /n3E01tRTVMydy8qk8IezFbnnCWd8wfjoSBOnzibaJ4qk/q3aawu9xC7n
   r9t37gDEhCm5JUOJ/ZpRyG/6xU+S4L7zJG/Jj2irYyg1fWoT/vVSJ0Uho
   XmnCylsM2JAMeWtvla59UX0ZOLT3iEbhQj94Ms5JydvnrdlNqWtvfNFFm
   Q==;
IronPort-SDR: wK95snK1WylOCoLaXl9fQqrbECt4tfEZJQBvBymYWNo5/OtZ82BnEUYSP5EvmKtfSEjAgnoE3q
 t4KwscfJ7wtq2cNMj88WhY1JMXVGj9JiENsfJII8syXIFGlJnMkPtKeGYndVj9tpQCgo/8vKiT
 9iJmkexIuJzHXzx+RnD4bhntzO1WuNO2aCZ5yxj1cf2Hx/JxdX6bljz7satm1xPWH3+STkd2XQ
 z85AQBjy5naW0jtzgxVwj3jxr92ykUREkcaUHkSXEmhNCbjO/9Bl96ldwcKvkjINC2QbpAXhNW
 J8/6Nij4hhiuzH4JrWC1NFAq
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="139850652"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 05:44:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 05:44:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Dec 2021 05:44:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crgjB+e07bHgYTReUtnpIyGyEBbbeufHKbU0wyQOPpdbtxuxjorqMTACGxBZQskybtLEgELEYTDRYeRGaWvd96a/NDDTONA6UoYiiUBzb3s6+7onPDu7rXDZRAiNu2A/LmeiM0O4KZQWwvEhInQ8nzIWKkSWpqrfpgt7vcvsLclHWvLV6Zp4wylCJZKqugHYpT4z1GsYXu/APApdG3rOf+rmB/XmQ55efhysm4ofPDj74RJHu3RN09BcUCsk5+O4+3QFlXCWk5tIDWoCeMcxNgRwrFfUa5EYkLO/X0zgiPfPsmQnVASHdbpT3UlcjucEtlJw3iwbts27It6bKLiVtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2pnURk1c2JK1XNP7TCfUsaqFyipMRUhcc0MtzuGQlg=;
 b=jOqklcsxjS27WhcYrqXD5EYtq9LTkjS2MNZm8t00QTcjLeWyvGavM7eQRRLXbruza3o0qiPJ9lZIcB8kry368RyChpW6VSSELgq3Mr0L+/fqoykOl++VRO1XTgfUpIbMKMm7pQ6ulbgrXer8UlZqWafYCbb1ZGwsxla0fvtp+pMrz44Atwq2dKrJhhbnnAiYdKZ7nAhm2JHUiIxorDUHOh0XZnnPpReTKwWNxmpg2qx5xWAiwMYjN85SSiM4mBGhF53XJkqmjdnc/ceP+8+4xokNkV1IvBrZQrNu8MFjC207g13VDIu9UrukSMNavS5oPmk9jdceolwVY+G3c4AglQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2pnURk1c2JK1XNP7TCfUsaqFyipMRUhcc0MtzuGQlg=;
 b=jes4y6QvJXgHq+I79ebhWntOfEc467qoj3kWeR/CZcE0OfWTfl54dxssk81EHOwg/iVZ+smuFu/RkJPrzp7B5p2yiYTqaOtBD5uuSrPxp0lMuPuWQhOrnYi9FvGlqf8GwESux26/ZZShbz2BzbHNJqI9KDg/rgFIwhWNsmGGWxI=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by BYAPR11MB3045.namprd11.prod.outlook.com (2603:10b6:a03:88::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 12:44:00 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 12:44:00 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>, <Claudiu.Beznea@microchip.com>,
        <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: RFC: wilc1000: refactor TX path to use sk_buff queue
Thread-Topic: RFC: wilc1000: refactor TX path to use sk_buff queue
Thread-Index: AQHX7s47Id+ErdfLW0e5eTjespmh7awzhT+A
Date:   Wed, 15 Dec 2021 12:44:00 +0000
Message-ID: <7a6956db-8710-4d6c-9bed-702ec1b7041e@microchip.com>
References: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
In-Reply-To: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7c183c6-e0b7-4bcb-a43b-08d9bfc8917f
x-ms-traffictypediagnostic: BYAPR11MB3045:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3045B758B69720712B8939D0E3769@BYAPR11MB3045.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2pG7fBrkN5wWhzIVhMxZQwto/Eh+MeVTvh0empvPY1XCLxHROrR/ayNdFztzTtE2sbWo3ZUdYyzyJdtX6LY5E0kpasffNe/xAD5rAs44Os0LzFD8ijPeMJTttrfFxjnbEWFgLzjAbyD4Rcf0RLHspQbggm9LY/wje5atw9q0uiqwFN9tjcwZFM9ZnvAxCn2HzJJjReXqWYl0fE417Ixw03dZucygOJd1SLhOoNSMn/vEFoeZH8b928pEzsrjGv9Utey7aajQmUP3MCqa4D8vevlABuqbUppNOSPCAAAypwymvkSvvWq0qgzRCRkU6E3ccwK2IbSo+Pejvm0RhWJ7WLEyVeaiaJys3aPmrOnw+6BOVmvGGT4wu7FOM8/gHZFB0fD9lBASENPEaOPOrIDFKPiPmZxUgs3I2xVQddAsWHQ75i1x7GlChCj8r+2vJvCwlSNFdnKbtVsT9wkT/IOqHACnVyt4CnGKjuj0/tZ9i7S0MdJ5Glc2dNFZctWXLGYZizdX3TDdF/IKoPg5Na8P2/29d2dAlYbzso+e4Ne8mD/XpMg6NFv16GhN3rSCJrGtv0+s6M5V/k7uZuD+I6hWsIFimLHI1IGDpxsHsRnoUyMAWxeu1YRhAACqtFOD1fdwNKlKTeuxvzlLfLXW/lM5wBukn9LOJfCv/m1+9/Y8X9Sjibeb5EkCFH7TYU0KK0jY9XcIlh9qQbYgdMCu0NAWl9+TzMcs9hLW9s9nala9aMP1pE+lhwMPrUrubueu+S3qsyGkBD10T32+ZM4gIKhH4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(71200400001)(4326008)(31696002)(186003)(8676002)(122000001)(316002)(5660300002)(91956017)(2906002)(38070700005)(6512007)(508600001)(66446008)(26005)(110136005)(76116006)(36756003)(86362001)(8936002)(83380400001)(66476007)(66556008)(53546011)(38100700002)(54906003)(2616005)(66946007)(31686004)(55236004)(6506007)(64756008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFFiVWFZN3ppeHprdTNIQzM4TEdMYUhOdjUwcWF0TXR1NVhPSFB0SnlPYjd4?=
 =?utf-8?B?b0xWMUNCcjdmekVySXJodnFVQ3hXcUcxQmUwUTRjVW93ZmhkcHJjdFMxbDNE?=
 =?utf-8?B?My9CZ2tRZVcrOHNpdk9HOTE0ZDBFSDB0VThOTVk5OHdOK0dMWU50aDJsblJO?=
 =?utf-8?B?UjlIL3dsQ0ErUmZPQlN3NkE3ODd4cUtSYjlZM1IxM0poUTB0NGZUcHd4eFEx?=
 =?utf-8?B?VXJHeHZMSGoreTFLeS94NW8xeU5zb0RGd0ptOFNDZXBkL2lQL2k0QVJyRXhH?=
 =?utf-8?B?RnV2eUdOajlucE1QVWUwYldidm1kNFZ5aGEwMnZGL0FRb1FvN2lRWTN5Zkpy?=
 =?utf-8?B?eTBGbjZhbnFmVmI1UTBlSGsrendMTjBZMjErMUNHWVhhRUYydlZVN09DYjFa?=
 =?utf-8?B?Y1VjbGxhUzJ2Z3BhODUvQWFDeFNaRFVac1ZGY0xTWmZKUVVtcURmQVFMOTRD?=
 =?utf-8?B?MVZEcE85ZVY2VkJndlVZRWVYYnpUQ1ZxNHE0TnFEZWpNMVM5a0NreHl0R1dU?=
 =?utf-8?B?ZGkzS1A2ZXQ0andrTkhJdEd6M0xIWVFJWXppU2pjYnNDSVJ3cUhFdDBKSTRx?=
 =?utf-8?B?QnRRMVBzVE1JK3FRbVRSTTJ3Z1pqQUZNd3Rxb3JldUpjb1JNVFVyUU1QZGdG?=
 =?utf-8?B?SzRwdW5QSmVhR1VQaGJSYnhXUDMzU1VBdEI3QS9VWFVDbWN1MExmTkozMjFX?=
 =?utf-8?B?QjVQMTR4QUwyN1daRU8wdng1aTdzcDFNZHRpb0ZCMlZZL2RQK3lWdHFldlA0?=
 =?utf-8?B?L0pEektrZXJ2S0pRSWRZRzVMSE1CSHRxOXMzRFZya3ArYkZEd3A5VDdvUTRT?=
 =?utf-8?B?N1o5VC81ak5kTWI5RUZGb0RTVEJ0RHNRMnFPNHNPamtIamY0WFlxQ0lPUC93?=
 =?utf-8?B?MmRrMzVOVE1EdDZCM00xNzEwcmF6NDdKTWFRdkxRNXNKZGs4aXdvYU4za01Z?=
 =?utf-8?B?aElhcXQ3Wit5SUdIZ0xVZ3M1SEpaSGFESGQ4ZXErdTBmSnRXTXB3NkxQUUNM?=
 =?utf-8?B?VU55MStjdEJGK3VVY093bC9zZlc1ZkNiUUNqcVRvTUFvdTFYSlNka2xqYWtI?=
 =?utf-8?B?MXoydG03YVNoNWxmSERGWHpadlRjbm1uTjNQUnllSk9qQkVmaEdsd1hDK3Jo?=
 =?utf-8?B?L0FFWUR0cVd3Rkl4NWRHMVFGZ25KZWFKRmQ2WG5JK2Mwek9DU0NVZGo3bkNK?=
 =?utf-8?B?SmtEdjlPNzNiU1lSdDdmV0FMa2VDRDkzUyt1b01Dayt0ZmFISXpGVG5DTzdB?=
 =?utf-8?B?NnFIVXRSVXZ2UVF6cDluakdSdGhBWkxoc1l6QmhwK1NJTmdXUkVIakczTTJM?=
 =?utf-8?B?K3dJSFQ1eVNpNEt3OVBJNUZvbEtnNXg1R0pHUEpMemV5amdTRkF1VDY5ZWVQ?=
 =?utf-8?B?MWdEVlhlVVhYSnpKdGJCQ3FzaE83RkdjcWtabFlybW83SGdKQSs4bFJJWFMx?=
 =?utf-8?B?c3V6MHJaUnlSZC9HUG9aMzVRa1V0TFErNmRqMTlkdGE1RVExd003YkZWSGtG?=
 =?utf-8?B?dWNpcThSdXNrWE9BRmQ4akZUVElhemUxdXd6dWFQdFhzZVpvS1VSY0FKcnBP?=
 =?utf-8?B?b21RY3c2cDJXM21laW1UcWVFNnJndnlwcm1Ca0duQy9VQTBVVTZmTk1kUlVz?=
 =?utf-8?B?MDVSV3pQeGh2QmpYa3Buc0ZPMUtkZlFWanNuRHY1cmhPMzZMNEM1ZmtkdTF5?=
 =?utf-8?B?UDNWZWRzcGtnSDRzanFZdjhWdFljQ1dtZGRtS2dDUXZ5Y01iV3JwUThKdm1Q?=
 =?utf-8?B?OFFSSUc0dWdBaUI5T2NFK095SnhPdi82UWtaU3ArRCtQWW9IWHR6cFJEYnlC?=
 =?utf-8?B?WXdXbElLa0k0c2tnMDZQVndhUW55cVluQlFKU3dhU1BHZGVybFVlUjl6NXc2?=
 =?utf-8?B?TkRCamJtR0xqSkVTUWxLSWN3MWlQUVhlNkY2bXZBRWdnWUdtWFlwWDh2V2Fj?=
 =?utf-8?B?SWt4RkZnT3JSbkJaS05rMVM0cGQwWjVuU0tMeWQydGNZOG1nbnBkUCtGNGlT?=
 =?utf-8?B?QnlUdWljMU1LbnlwYW53dTFkaEtDaGk4bHdidUUrNHkxV3hTaXZIQ3pJOWRX?=
 =?utf-8?B?Nk8rNDFRZ2JtWHdYMUY5TDd6RXFsb1E2VU1SKy9HVC9mc2JIREtPeml4dnJq?=
 =?utf-8?B?VDdoM0xqcGs4OVUxL3JlNWY2cTVzNEgrMk9DVkExQ3pRWnpSYld2QStTNGRq?=
 =?utf-8?B?U2RtMzVOUWUyd09LU25KVHhWZUdjY1diSjM0dnVmdGFHUVVadldQeGpaYkRX?=
 =?utf-8?B?Z3MyTGE0YmpWbzZLcTc1Sjg2bldnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <152B2974C0BAB442895074875F4773A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c183c6-e0b7-4bcb-a43b-08d9bfc8917f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 12:44:00.4076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k60UwJJa90aibjWUvMM12LppwQj5avQArio0a+RCHLtbMjjvS7XO3fQ8VpVuMzR+w4tiUvj1IALqU3ADbZfhfBbHZGsAdqnqSPA9aV1PNjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTIvMjEgMDI6MDIsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gSSdkIGxpa2UgdG8gcHJvcG9zZSB0byBy
ZXN0cnVjdHVyZSB0aGUgd2lsYzEwMDAgVFggcGF0aCB0byB0YWtlDQo+IGFkdmFudGFnZSBvZiB0
aGUgZXhpc3Rpbmcgc2tfYnVmZiBxdWV1aW5nIGFuZCBidWZmZXIgb3BlcmF0aW9ucyByYXRoZXIN
Cj4gdGhhbiB1c2luZyBhIGRyaXZlci1zcGVjaWZpYyBzb2x1dGlvbi4gIFRvIG1lLCB0aGUgcmVz
dWx0aW5nIGNvZGUgbG9va3MNCj4gc2ltcGxlciBhbmQgdGhlIGRpZmZzdGF0IHNob3dzIGEgZmFp
ciBhbW91bnQgb2YgY29kZS1yZWR1Y3Rpb246DQo+DQo+ICAgY2ZnODAyMTEuYyB8ICAgMzUgLS0t
LQ0KPiAgIG1vbi5jICAgICAgfCAgIDM2IC0tLS0NCj4gICBuZXRkZXYuYyAgIHwgICAyOCAtLS0N
Cj4gICBuZXRkZXYuaCAgIHwgICAxMCAtDQo+ICAgd2xhbi5jICAgICB8ICA0OTkgKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAg
IHdsYW4uaCAgICAgfCAgIDUxICsrLS0tLQ0KPiAgIDYgZmlsZXMgY2hhbmdlZCwgMjU1IGluc2Vy
dGlvbnMoKyksIDQwNCBkZWxldGlvbnMoLSkNCj4NCj4gUGVyZm9ybWFuY2UgaXNuJ3Qgc2lnbmlm
aWNhbnRseSBhZmZlY3RlZCBieSB0aGlzIHBhdGNoOg0KPg0KPiAgICAgQmVmb3JlIHRoaXMgcGF0
Y2g6DQo+ICAgICAgICAgICAgICAgICAgVFggW01icHNdICAgICAgIFJYIFtNYnBzXQ0KPiAgICAg
ICBQU00gb2ZmOiAgIDE1LjQgICAgICAgICAgICAxOS43DQo+ICAgICAgIFBTTSAgb246ICAgMTIu
MiAgICAgICAgICAgIDE3LjkNCj4NCj4gICAgIFdpdGggdGhpcyBwYXRjaDoNCj4gICAgICAgICAg
ICAgICAgICBUWCBbTWJwc10gICAgICAgUlggW01icHNdDQo+ICAgICAgIFBTTSBvZmY6ICAgICAg
MTUuOSAgICAgICAgIDIwLjUNCj4gICAgICAgUFNNICBvbjogICAxMi4zICAgICAgICAgICAgMTgu
OA0KPg0KPiBUaGUgcXVlc3Rpb24gSSBoYXZlIGlzIHdoZXRoZXIgc29tZXRoaW5nIGFsb25nIHRo
ZXNlIGxpbmVzIHdvdWxkIGJlDQo+IGV2ZW4gY29uc2lkZXJlZCBmb3IgbWVyZ2luZy4gIFRoZSBw
cm9ibGVtIGlzIHRoYXQgdGhlIHBhdGNoIGlzIGZhaXJseQ0KPiBsYXJnZSBhbmQgSSBkb24ndCBz
ZWUgYW55IG9idmlvdXMgd2F5IG9mIG1ha2luZyBpdCBzbWFsbGVyIG9yIHNwbGl0dGluZw0KPiBp
dCBpbnRvIHNtYWxsZXIgcGllY2VzOiBvbmNlIHlvdSBzd2l0Y2ggdGhlIHR4IHF1ZXVlIGRhdGEg
c3RydWN0dXJlLA0KPiB0aGVyZSBpcyBqdXN0IGEgYnVuY2ggb2YgY29kZSB0aGF0IG5lZWRzIHRv
IGdldCB1cGRhdGVkIGFzIHdlbGwgaW4NCj4gb3JkZXIgdG8gZ2V0IGEgd29ya2luZyBkcml2ZXIg
YWdhaW4uDQo+DQo+IE5vdGVzOg0KPg0KPiAgIC0gRG9uJ3QgdHJ5IHRvIGFwcGx5IHRoaXMgcGF0
Y2ggYXMgaXMuICBUaGVyZSBhcmUgdHdvIG90aGVyIHNtYWxsDQo+ICAgICBidXQgdW5yZWxhdGVk
IGNoYW5nZXMgdGhhdCB0aGlzIHBhdGNoIGJlbG93IGRlcGVuZHMgb24uDQoNCg0KQnR3IHdoYXQg
YXJlIHRoZSBvdGhlciB0d28gY2hhbmdlcyByZXF1aXJlZCB0byBtYWtlIGl0IHdvcmsuIEkgYmVs
aWV2ZSANCnRoZSB3b3JraW5nIGZsb3cgc2hvdWxkbid0IGdldCBpbXBhY3RlZCBhZnRlciB0aGUg
cmVzdHJ1Y3R1cmluZyANCmVzcGVjaWFsbHkgd2hlbiBjb2RlIGlzIHJlZmFjdG9yKHJlcGxhY2Vk
KSB1c2luZyB0aGUgZXhpc3Rpbmcgc29sdXRpb24uDQoNCj4gICAtIFRoaXMgcGF0Y2ggbGVhdmVz
IHR4cV9zcGlubG9jayBpbiBwbGFjZSBldmVuIHRob3VnaCBpdHMgb25seQ0KPiAgICAgcmVtYWlu
aW5nIGZ1bmN0aW9uIGlzIHRvIHNlcmlhbGl6ZSBhY2Nlc3MgdG8gd2lsYy0+dHhfcV9saW1pdA0K
PiAgICAgYW5kIHZpZi0+YWNrX2ZpbHRlci4gIFRoaXMgb2J2aW91c2x5IGNvdWxkIGJlIHJlbmFt
ZWQgaW4NCj4gICAgIGEgc2VwYXJhdGUgcGF0Y2guICBBY3R1YWxseSwgc3BlYWtpbmcgb2Ygd2hp
Y2gsIGlzIHRoZXJlDQo+ICAgICBubyBjb21tb24gY29kZSBpbiB0aGUga2VybmVsIHRvIGhhbmRs
ZSBkdXBsaWNhdGUtYWNrDQo+ICAgICBlbGltaW5hdGlvbj8NCj4NCj4gVGhvdWdodHMgYW5kL29y
IHN1Z2dlc3Rpb25zPw0KDQpVc2luZyBza19idWZmIHF1ZXVlIGlzIGEgZ29vZCBpZGVhIGJ1dCB0
aGUgcGF0Y2ggaGFzIG90aGVyIGNoYW5nZXMgYWxzby4gDQpUaGlzIHBhdGNoIHNob3VsZCBiZSBz
cGxpdGVkIGludG8gYSBmZXcgZGlmZmVyZW50IGxvZ2ljYWwgcmVsYXRlZCANCmNoYW5nZXMuIFVz
aW5nIGEgc2luZ2xlIHBhdGNoIGZvciBhbGwgdGhlc2UgY2hhbmdlcyBtYXkgbm90IGJlIGVhc3kg
dG8gDQpyZXZpZXcgYW5kIGhhbmRsZSBpZiB0aGVyZSBhcmUgYW55IHJlZ3Jlc3Npb25zLg0KDQpP
bmUgd2F5IHRvIHNwbGl0IHRoZSBjaGFuZ2VzIGNvdWxkIGJlIGxpa2U6DQoNCiDCoC0gc2tfYnVm
ZiBoYW5kbGluZyBmb3IgbWdtdC9kYXRhIGFuZCBjb25maWcgZnJhbWVzDQogwqAtIFdJRChjb25m
aWcgcGFja2V0cykgZnVuY3Rpb25zIHJlZmFjdG9yaW5nDQogwqAtIEZ1bmN0aW9ucyByZWZhY3Rv
cmluZw0KIMKgLSBSZW5hbWUgcmVsYXRlZCBjaGFuZ2VzDQoNCg0KW3NuaXBdDQoNCj4gICBzdGF0
aWMgaW5saW5lIHZvaWQgYWNfdXBkYXRlX2Z3X2FjX3BrdF9pbmZvKHN0cnVjdCB3aWxjICp3bCwg
dTMyIHJlZykNCj4gICB7DQo+IC0gICAgICAgd2wtPnR4cVtBQ19CS19RXS5mdy5jb3VudCA9IEZJ
RUxEX0dFVChCS19BQ19DT1VOVF9GSUVMRCwgcmVnKTsNCj4gLSAgICAgICB3bC0+dHhxW0FDX0JF
X1FdLmZ3LmNvdW50ID0gRklFTERfR0VUKEJFX0FDX0NPVU5UX0ZJRUxELCByZWcpOw0KPiAtICAg
ICAgIHdsLT50eHFbQUNfVklfUV0uZncuY291bnQgPSBGSUVMRF9HRVQoVklfQUNfQ09VTlRfRklF
TEQsIHJlZyk7DQo+IC0gICAgICAgd2wtPnR4cVtBQ19WT19RXS5mdy5jb3VudCA9IEZJRUxEX0dF
VChWT19BQ19DT1VOVF9GSUVMRCwgcmVnKTsNCj4gLQ0KPiAtICAgICAgIHdsLT50eHFbQUNfQktf
UV0uZncuYWNtID0gRklFTERfR0VUKEJLX0FDX0FDTV9TVEFUX0ZJRUxELCByZWcpOw0KPiAtICAg
ICAgIHdsLT50eHFbQUNfQkVfUV0uZncuYWNtID0gRklFTERfR0VUKEJFX0FDX0FDTV9TVEFUX0ZJ
RUxELCByZWcpOw0KPiAtICAgICAgIHdsLT50eHFbQUNfVklfUV0uZncuYWNtID0gRklFTERfR0VU
KFZJX0FDX0FDTV9TVEFUX0ZJRUxELCByZWcpOw0KPiAtICAgICAgIHdsLT50eHFbQUNfVk9fUV0u
ZncuYWNtID0gRklFTERfR0VUKFZPX0FDX0FDTV9TVEFUX0ZJRUxELCByZWcpOw0KPiArICAgICAg
IHdsLT5md1tBQ19CS19RXS5jb3VudCA9IEZJRUxEX0dFVChCS19BQ19DT1VOVF9GSUVMRCwgcmVn
KTsNCj4gKyAgICAgICB3bC0+ZndbQUNfQkVfUV0uY291bnQgPSBGSUVMRF9HRVQoQkVfQUNfQ09V
TlRfRklFTEQsIHJlZyk7DQo+ICsgICAgICAgd2wtPmZ3W0FDX1ZJX1FdLmNvdW50ID0gRklFTERf
R0VUKFZJX0FDX0NPVU5UX0ZJRUxELCByZWcpOw0KPiArICAgICAgIHdsLT5md1tBQ19WT19RXS5j
b3VudCA9IEZJRUxEX0dFVChWT19BQ19DT1VOVF9GSUVMRCwgcmVnKTsNCj4gKw0KPiArICAgICAg
IHdsLT5md1tBQ19CS19RXS5hY20gPSBGSUVMRF9HRVQoQktfQUNfQUNNX1NUQVRfRklFTEQsIHJl
Zyk7DQo+ICsgICAgICAgd2wtPmZ3W0FDX0JFX1FdLmFjbSA9IEZJRUxEX0dFVChCRV9BQ19BQ01f
U1RBVF9GSUVMRCwgcmVnKTsNCj4gKyAgICAgICB3bC0+ZndbQUNfVklfUV0uYWNtID0gRklFTERf
R0VUKFZJX0FDX0FDTV9TVEFUX0ZJRUxELCByZWcpOw0KPiArICAgICAgIHdsLT5md1tBQ19WT19R
XS5hY20gPSBGSUVMRF9HRVQoVk9fQUNfQUNNX1NUQVRfRklFTEQsIHJlZyk7DQo+ICAgfQ0KDQpu
YW1lIGNoYW5nZXMgbGlrZSBhYm92ZSBjYW4gYmUgcGFydCBvZiBzZXBhcmF0ZSBwYXRjaA0KDQoN
CjxzbmlwPg0KDQo+ICAgICAgICAgICAgICAgICAgKCphYykrKzsNCj4gICAgICAgICAgDQo+ICtz
dGF0aWMgaW50IHdpbGNfd2xhbl9jZmdfYXBwbHlfd2lkKHN0cnVjdCB3aWxjX3ZpZiAqdmlmLCBp
bnQgc3RhcnQsIHUxNiB3aWQsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dTggKmJ1ZmZlciwgdTMyIGJ1ZmZlcl9zaXplLCBpbnQgY29tbWl0LA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHUzMiBkcnZfaGFuZGxlciwgYm9vbCBzZXQpDQo+ICAgew0K
PiAtICAgICAgIHUzMiBvZmZzZXQ7DQo+ICAgICAgICAgIGludCByZXRfc2l6ZTsNCj4gICAgICAg
ICAgc3RydWN0IHdpbGMgKndpbGMgPSB2aWYtPndpbGM7DQo+DQo+ICAgICAgICAgIG11dGV4X2xv
Y2soJndpbGMtPmNmZ19jbWRfbG9jayk7DQo+DQo+IC0gICAgICAgaWYgKHN0YXJ0KQ0KPiAtICAg
ICAgICAgICAgICAgd2lsYy0+Y2ZnX2ZyYW1lX29mZnNldCA9IDA7DQo+IC0NCj4gLSAgICAgICBv
ZmZzZXQgPSB3aWxjLT5jZmdfZnJhbWVfb2Zmc2V0Ow0KPiAtICAgICAgIHJldF9zaXplID0gd2ls
Y193bGFuX2NmZ19zZXRfd2lkKHdpbGMtPmNmZ19mcmFtZS5mcmFtZSwgb2Zmc2V0LA0KPiAtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdpZCwgYnVmZmVyLCBidWZmZXJf
c2l6ZSk7DQo+IC0gICAgICAgb2Zmc2V0ICs9IHJldF9zaXplOw0KPiAtICAgICAgIHdpbGMtPmNm
Z19mcmFtZV9vZmZzZXQgPSBvZmZzZXQ7DQo+IC0NCj4gLSAgICAgICBpZiAoIWNvbW1pdCkgew0K
PiAtICAgICAgICAgICAgICAgbXV0ZXhfdW5sb2NrKCZ3aWxjLT5jZmdfY21kX2xvY2spOw0KPiAt
ICAgICAgICAgICAgICAgcmV0dXJuIHJldF9zaXplOw0KPiArICAgICAgIGlmIChzdGFydCkgew0K
PiArICAgICAgICAgICAgICAgV0FSTl9PTih3aWxjLT5jZmdfc2tiKTsNCj4gKyAgICAgICAgICAg
ICAgIHdpbGMtPmNmZ19za2IgPSBhbGxvY19jZmdfc2tiKHZpZik7DQo+ICsgICAgICAgICAgICAg
ICBpZiAoIXdpbGMtPmNmZ19za2IpIHsNCg0KDQonY2ZnX2NtZF9sb2NrJyBtdXRleCB1bmxvY2sg
aXMgbWlzc2luZy4NCg0KPiArICAgICAgICAgICAgICAgICAgICAgICBuZXRkZXZfZGJnKHZpZi0+
bmRldiwgIkZhaWxlZCB0byBhbGxvYyBjZmdfc2tiIik7DQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiAwOw0KPiArICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgICB9DQo+DQoNClJl
Z2FyZHMsDQpBamF5DQoNCg==
