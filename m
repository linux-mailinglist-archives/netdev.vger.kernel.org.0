Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1E502575
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiDOGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350326AbiDOGTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:19:42 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2091.outbound.protection.outlook.com [40.92.103.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB6AFAE4;
        Thu, 14 Apr 2022 23:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3K7ShN3tWfhwmsuxTHWh2LsQsfXHRMLMchkdR0pUKPxbWu0tIizchMkDEerG/q3+8icN4NyFW+JxZ1GNeSc3HuAEZqCaNLIeBG44mUtAWNolKIH7/RC8IBtHr/zkudKQ4oSjoaYy6w12dady7U3EUBot9Ku/tM03QyVQUXN0z+w05OdzMw7v6Nj2rVlB/KKPki7TJhHqfE7oE/FRtREbuhT22ZhaH/HPjACA+pylw8b31VPaw9X4TQwZdnPGWzKcEnnqqyTJAUU8bq1AVlyATcQhP2WHZ7OGzYtWE11A23jeZYFosn7mrCfLvln4tdmIe2ERlDNMUTTLdOCqaooVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvaB9EMqG65BwaBjruMozk748Ov3X7Tb6cb3rpKeQoE=;
 b=kQj5VeNwYeo7D+BMX3pNfRyAg9JldI4NRbQ4gz0sWo44cQ/ZzC4JYqoWyY62qyPlnZEMykTHVVbE3r1iHPQKSEfBNQRyx5H+/GklT5h8Hdel+XzCk+QzHuD35nzi+Act7KNO8YfkTeXTsxmTrPbAJ0EWrnmZhDL+BPR6p/W3o3ouYAutfE0zjq8XLwRnwDlZiY8Ga3TNAoLvRwx71JY74aczfZx/0RgR345masuomcm3FdZiLsuI5kJm7lVjsqT4jZXU57OPyHSbChV4BsBLUB9UTdd2O8Dhnc/KxdlwI510FyWS2vPxPOxM2jPMRANsJ/WfNfbeXGOTvW9sr7noxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvaB9EMqG65BwaBjruMozk748Ov3X7Tb6cb3rpKeQoE=;
 b=HTa3axXq7XGUCFdpy+Lys7CikMFF6N49NUBKMjPVIEsNH8rdSqauru3oRJ9HMJ3no/xqeJRCo19MBFFRiPBThziLGWYzKCcpGLrjRignGoLAdS6e2vmDaC+Q6adLdLH2GArIr0APZs4gV7qroE3trU12uLJ+dWvD/kHYS1o24X4V4y7ZOaUgjMQBdZ46XgIt5rX3vC3WGpQPpdehDfzgdGEX8ohIl96kjt3ceqqRMJZ/hVfZfMNPkcY3KNyEfTVb+TnuOsqxqF9KoHBsxqzuOzo4tX5e1YJ77UhZqb1K7INIFjWEfoSKlxOpVugaSqDTHlxCIdmxh3Knmn+4FYyJww==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA1PR0101MB1335.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 06:17:06 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 06:17:06 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v5] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYTz9dfWCixF5v0EC2QNtcr1SBvazvaS4AgAEZKgA=
Date:   Fri, 15 Apr 2022 06:17:05 +0000
Message-ID: <4AADFC21-2BD4-4925-A74B-D366A20D6FF0@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
 <9aca02b10ff179a8297b06df11bde4faa8a39650.camel@linux.ibm.com>
In-Reply-To: <9aca02b10ff179a8297b06df11bde4faa8a39650.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [aTBuSNb9A87qTRc7hfMG+T4mixlPr6fG/Re5jXtQN9TsDubE0RNdBux4nR8FKnFfniUAtytX34c=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49140d10-a9b1-40f2-f701-08da1ea7909c
x-ms-traffictypediagnostic: MA1PR0101MB1335:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 18Vr8rGdi9t3fXG4OlyZ+7lkDGp9HhNUwDufHBJrRbj3qY56H5QTQzEy22Bsra2t2p25R5AFQytxt3NhuIf9s/juu86JnphlX2nUuYsX6nSWelCZB+WdWIafqxihrQaZqOOqaKea/YdUsQp1dJAJApppUVIlGSnRh/4dwenH/VNNldM8YBEJJ7j3mu5kPd4FOdmvMmT5R86a0ReYx9+M+OfqGkwqA5RE5l8zmPGfgLGSK/W/u8Ni1RgPfbUrL3REEfByjqJoBj4cbcYEuvC7JskYggmPUMDfLHiO+moRhpSsbvDXuuN/lAbNOzkBo+tTn8Acji4tc+aKT8+1nceShbcL75FT8zd2QvNF1Y8xJYmXWuvo5yZzZOsQMMVUwLX8ah+3iq1vptcZRAHiJQj7I8qK3jHk0AZVSVYk0XFJPxE5YnJMY4gNEZQD1ZbxDlaHcIwC4qhYmUQ+2bzS2ZAv8/ZveWW6FM8zBzrJjaIVa3Yruk5y1YlofVany5tEWh03wX/fgvQOFzQoyjA8yo2DRSpQ4ipWdMZIwxd7mhgd5f+eXLpU0g/AI5aF4vVDs6FSDwdtvOVonz908bsh1R/zbA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZE5icjN5Y0xhOFBZOFp6NGRtQlVGb2k0bUc2eDZ3T2FvZEcybzFHMDJubVlp?=
 =?utf-8?B?ZHUrTk4rZXIzSzIrc3hPcVM2WjBrMTYzS1VCR2FPakMxMVgrU1pXaUF1TTlh?=
 =?utf-8?B?WXNYb3BnVWNvWGQxYUZRdzI3UlBaNTd3V1ZkTFM4Z1JOUWRwenIrbGFiMG1T?=
 =?utf-8?B?aEY5bXlkL1FVQ2Y4U0dHSm5FaSt2dkc3T0NLcVVvTmhjR3Zjcm1mcldQLy8r?=
 =?utf-8?B?djZBdDdMSUZMQ1pXdkV5VFY3VThvRGZod0pwR1Uvc3BQbVJsQmxZZjNBVGlh?=
 =?utf-8?B?SHZURG5GT2NLNXJiMzQybFpxTmhHaXpUNVRadnFZTjJrV0pITjdCSEhreFVz?=
 =?utf-8?B?dHRudHBhdjNwK1laY2hBdkM3dHp1aUFKM25uVXlsWEJCaHUzenVKbkFTRUsy?=
 =?utf-8?B?SitLVS9UT1pUZzRtQkdMQXFqWHp5WW9mdEZJVzNaTERGa1l3cE83MVF0bkJG?=
 =?utf-8?B?MkpvL05hOHlVK1g3ZE02Y096WVBpOG5PUEJ3RStKTEZmRkkvbGRtdkoxMXQr?=
 =?utf-8?B?T0NZbUVTdzY2VHVJOUxxemd2WWEyQllFbTNzWE8vRkVRM0lyQVRsN1JDZ1Jm?=
 =?utf-8?B?K3FKY1FlSVFSNXpZQVNtczN6YkxwTUFFRWQ0QVhPRlNmWDdCZFdCOXkxUVFm?=
 =?utf-8?B?N3JGMjVZeFBCZ0Z4NnhtUG1OdUJESnJlTTRSeHdzVEhZU0MxWXVpL1hBZzhR?=
 =?utf-8?B?NlpPWUJ0NjFPMTBjZFpwWllhdkhyYi9iZ05ML1FBbVpRaHpqakN2SkZITFRs?=
 =?utf-8?B?ZVZLdDV2UDN3WE9wcGpPYmFuaUFwQnB4VHpRRUxpbXBZQnptVTFIQjFVVFVV?=
 =?utf-8?B?dTY4N3hZNzdwdGFuaWVhT1I4MnZVQm9sSWhYOUI4SGhHV3RQTlNjMnB1TGdP?=
 =?utf-8?B?REhnemh0REduUkJDMUhnR3c3R3JZTmJRZHhjVUhkcjQyRzE5V1VDd3ZxS091?=
 =?utf-8?B?d2F1Kyswc0taMzVRL2J0Uk42ejBIcnNNOEFPQThHV243M1dsbGVNWkM2QU5z?=
 =?utf-8?B?NDBqaWdMNHBPT2Zickxab2hRMWhmRzlnRjJRWUJzalhmVlZzOC9wWW9qUG8r?=
 =?utf-8?B?MW1rY3QwUWQ1UHZFUXMrSFpsbDdIaGttSkdRSElUTFZPdm9yeTFDQzRSVGZS?=
 =?utf-8?B?SVV3NzlVTUo1Uk5NNVRwa0ZQZUFxREswQzZsMGcwRHlSM0plVjA3UjN6Vm5o?=
 =?utf-8?B?bUdnclRsUXcyK3ZhMUxYRE9hOEFzOHFlV1hDOXd6TE5ZVkVQRVFXSlBXOVYy?=
 =?utf-8?B?cDdUbjV6eEFLeE5lT1BUL29UdjUzaWFRcitEdzhNZnIxRVB5V0twOFAwS0RB?=
 =?utf-8?B?blZYaTFhaVdFVmRjWXlnM2IwTzJwd3FLbW83N3FLQWswUXRqeUhIYU5BZXlz?=
 =?utf-8?B?ZnE5am9GNGUwTVpJZzl3OTl2QVRoaktvYmEwM1ZRQWQ0RVNCazhqQnhQUFFC?=
 =?utf-8?B?N0ZPSUNucTN6RndUZlhnd0p3U0liaGlxRjBwQ2FrQ3RwWUtNZVJnYkRncVpw?=
 =?utf-8?B?WVB6TDhycU4vOWR6dzhrTDR1L1FmRDVJTVQ1Yk1ReUNlYld4eUJzY0tmMUdB?=
 =?utf-8?B?QVI4NjhiVmVEWVhLMkRmcng3U1BHU1FxdUFuaWJ5M21NbCtwelhMUkVTR3Nv?=
 =?utf-8?B?MWVEa0h4WTVjRXRIaStEd0hwbGErT2dUVzNWSzgzV0FvODMvT1U5MlcrRlpN?=
 =?utf-8?B?QzVzRUczemNWQ2dNdUF2bXNlOHc2SXNQUEd3bmhaRGVYSXpCTGFLZlRnTmVQ?=
 =?utf-8?B?QnhtOWh3RVd2Q0d6SHpIZ2dTZjIyZi92Qktoa2c3SzlGS0h1MHFoVllFYnNM?=
 =?utf-8?B?dkJ2anhuVFc1dTRpdXJQQmlWcEU0TUh1UTREMWJxN2Y5VkxiWFBWRnljblN1?=
 =?utf-8?B?S3I5MHBvb1RuTkFzWndvZmJPMUlHbXd3ZmR0TGoxaHBHLzkwVi9TaUY0Z2xZ?=
 =?utf-8?B?N0NjN1RRUEgzS1RST3FFaGN5ZnBnc3lhUWV4L1NCNktpN0d3QmdJU0pQUk14?=
 =?utf-8?B?ZzVKTGJLVWc3YkdUL2RxUXQ4dU1TcWhoVVBXTzc1cTNDRVlYQXoraUl4UnE0?=
 =?utf-8?Q?ABIUN/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <277761703006244BBFE01F0AF5FF28A6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 49140d10-a9b1-40f2-f701-08da1ea7909c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 06:17:06.0143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR0101MB1335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEJhc2VkIG9uIHlvdXIgZXhwbGFuYXRpb24sIHRoZXJlIHNlZW1zIHRvIGJlIHR3byBpc3N1
ZXMgLSBpbmFiaWxpdHkgdG8NCj4gcmVhZCBFRkkgdmFyaWFibGVzLCAidXNlcnMgY2FuJ3QgYWRk
IHRoZWlyIG93biIga2V5cy4gTmVpdGhlciBvZiB3aGljaA0KPiBtZWFuICJhIG5vbi1zdGFuZGFy
ZCBpbXBsZW1lbnRhdGlvbiBvZiBzZWN1cmUgYm9vdCIuIFBsZWFzZSBmaXggdGhlDQo+ICJjYXVz
ZSIgYW5kICJhZmZlY3QiIGluIHRoZSBwYXRjaCBkZXNjcmlwdGlvbiBhbmQgY29tbWVudHMuDQoN
ClNlbmRpbmcgYSB2Ng0KDQpBbHNvLCBJIGd1ZXNzIEkgc2hvdWxkIGp1c3QgcmVtb3ZlIHRoZSBz
ZWN1cmUgYm9vdCBiaXQsIGNhdXNlIHNlY3VyZSBib290LCB0aG91Z2gga2luZGEgcmVsYXRlZCwg
ZG9lc27igJl0IGhhdmUgbXVjaCByb2xlIGhlcmUuDQoNClRoZSDigJxjYXVzZeKAnSBpcyByZWFk
aW5nIG9mIHNwZWNpZmljIFVFRkkgdmFyaWFibGVzLCBsaWtlIGRiLCBkYnggZXRjLCBhbmQgdGhl
IOKAnGFmZmVjdOKAnSBiZWluZyBjcmFzaGluZyBvZiBFRkkgUnVudGltZSBTZXJ2aWNlcy4NCg0K
VGhlIOKAnGZpeOKAnSwgc2ltcGx5IHByZXZlbnQgcmVhZGluZyBvZiB0aGVzZSB2YXJpYWJsZXMN
Cg0KVGhlIHJvbGUgb2Ygc2VjdXJlIGJvb3QgKFdoaWNoIEkgaGF2ZSByZW1vdmVkIGluIHRoZSBk
ZXNjcmlwdGlvbiBvZiB2NiwgY2F1c2UgaXRzIG5vdCBvZiBtdWNoIHNpZ25pZmljYW5jZSBpbiBy
ZWdhcmQgdG8gdGhpcyBwYXRjaCkgOi0NCg0KTG9hZGluZyBvZiB0aGVzZSBjZXJ0aWZpY2F0ZXMg
aXMgcmVxdWlyZWQgdG8g4oCcYm9vdCBzZWN1cmVseeKAnS4gQnkgZGlzYWJsaW5nIGxvYWRpbmcg
b2YgdGhlc2UgY2VydGlmaWNhdGVzLCB3ZSBhcmUgdGVjaG5pY2FsbHkgcHJldmVudGluZyBib290
aW5nIExpbnV4IOKAnHNlY3VyZWx54oCdIG9uIHRoZXNlIG1hY2hpbmVzLiBCdXQsIHRoaXMgc2hv
dWxkbuKAmXQgYmUgYSBtYXR0ZXIgdG8gd29ycnkgYWJvdXQuIFRoZSByZWFzb24gYmVpbmcsIEFw
cGxlIGRvZXNu4oCZdCBhbGxvdyBhbnl0aGluZyBvdGhlciB0aGF0IG1hY09TIG9yIFdpbmRvd3Mg
dG8gYm9vdCBpZiBTZWN1cmUgQm9vdCBpbiB0dXJuZWQgb24sIG9uIHRoZXNlIE1hY3MsIG1ha2lu
ZyBpdCBpbXBvc3NpYmxlIHRvIGJvb3QgTGludXggd2l0aCBzZWN1cmUgYm9vdCBvbiwgdW5sZXNz
IEFwcGxlIGl0c2VsZiB1cGRhdGVzIHRoZSBmaXJtd2FyZSBvbiB0aGUgVDIgQ2hpcCwgdG8gc3Vw
cG9ydCBMaW51eCBhcyB3ZWxsLCB3aGljaCBpcyBoaWdobHkgdW5saWtlbHkuDQo+IA0KPiB0aGFu
a3MsDQo+IA0KPiBNaW1pDQoNCg==
