Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55994493538
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 08:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiASHHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 02:07:40 -0500
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:10625
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230223AbiASHHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 02:07:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzfB4/GrYQSJAHCu/R1DMoryuPHYCxwWbQY+WCtCvy7EShDVuFTlTyvrsLqhxAxm8J/jRA/z74Id8E0RhCnOAoilZK2muVKeTawNzN52Z4W2rPEX1XwEgFF7mnWPEFZ8MqIUM6I7krpkLdBewpqQyoE+0wmtLkamjyc3q0ssCrc2jFkqlz/4TLj4YkOPc709F7g4gPT76TsXrE9Fja8XwtSxh+2xHQwniUYR6C6KiIC6r/L+6Lv1yPTDGPwL4B+3n0K0nsOL1ZWJ/MLTinyW1ByTIg2Gb+3Vwu3ANyMCoq8qeVewKznO+PeUhLf2I1em/6qQxMMarCl5VFjjw+znlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20CDsar/CpgdU5ExFWGc7Phm+1fJ6SYtsY9Y9MtM5MA=;
 b=Tiavi6AR5MlHEl76Iyfvalqv/p02RqxiFE5Uw8Y9iQorMJyjJEkUFRDSsIPG09RHxED5Hbja2DYuUW4zUdkt9kzIheHCqP81kBaTC5KUxbFpb/YWhdzKRQJxAagddmJGvTGyLa03QH7OViAF7azVUpjmllpXcC6U3WVDP1Z8zu481678IhY/w+kMAjHwz/OJNJ70WML3HMgRh6c7pP2dTquTGWizViITu4CjA9FLh7ylliailTL5XaaA5h4lthRRJIU/aJEGhB/twmAreDoTyoxQKrTMF0uzyawQJh5fM68QtsdP81T9j3lg27jm4ggKOmfFBWzhNcaWbAbyxq2tTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20CDsar/CpgdU5ExFWGc7Phm+1fJ6SYtsY9Y9MtM5MA=;
 b=cAV5asJyo6WtfSmfEjybF2yBoK8s2WteDrLwUPOonaZ9PU8wd4Ggg5OYz9/yB4a/VYosyH26sTvXeEDoiHIzAh8Rq4Uajrxlz1qHTvxte/O8PEo4q0Apq6WaY/YAhqg4cGjj/zEfZ97P2nzqeKLVZm7PJv5ldDiiBSgq1KTsqJo=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BN8PR02MB5908.namprd02.prod.outlook.com (2603:10b6:408:b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 07:07:38 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05%4]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 07:07:38 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [PATCH net v3 0/9] Xilinx axienet fixes
Thread-Topic: [PATCH net v3 0/9] Xilinx axienet fixes
Thread-Index: AQHYDLRVpF6DBll7yk+GpnuGRgxsl6xpZkoAgACB5/A=
Date:   Wed, 19 Jan 2022 07:07:37 +0000
Message-ID: <SA1PR02MB85601DA6A4009BA3FDAF256BC7599@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
 <993dcdd75d3839b5952e8632ae278f723273df03.camel@calian.com>
In-Reply-To: <993dcdd75d3839b5952e8632ae278f723273df03.camel@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d3e7132-41cd-4874-7bae-08d9db1a6044
x-ms-traffictypediagnostic: BN8PR02MB5908:EE_
x-microsoft-antispam-prvs: <BN8PR02MB5908AF417DEC60BA4A7AE51AC7599@BN8PR02MB5908.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cifkWS8/aA32Wj621vxVB7S7M1HM3Opx9I2wbOjaHgKr941EI/V5oMUz/v+jSzJF5Ih0p7sYwZCNZcWySY+JVcl769mNPbgLTYDfQDclFfekk30B0SAvE/JUgeajPE/7DrAE7ARzCjwtvkEXeJxvc5o6F/zW4262dj5XHh07oqHroUzttdOGfs6EKrwieip1TaqE4wPy02LhczqxLHYXdLsSvRohsstjmqu1fVs4a8KOm9jhJHJHErao31KitE1Rd0bssYO/krRxqO8JxA0x3vJlZKksTtSI/qLKQn5LXL4yhDJoWpwcuNMaJM4pZDNoqRsz9WYhfMxjfHEOYkEoUgsDvENEt2FbVFWf1sCyxorM5C0+9g5hb22mTstAZhRE5CfQ6TSQTGAxTUVHBIpjxcWkdkqRNX86wZxudsv1P6t1CUWTt1Q9A2jSWqximFI568AxWrl11bIILdk1VOyuZaHVjk6ejhKfOQ0X0FjunvaDMuQlUtzcpuKK5Fd5tR+7bK3dnPdzVwQL7jhVRCLXou6QPmEJW93+hxFhX886PY4FMNUD/tllmRltB9v5ZRGP+DV0OBqqZy7mM11QkHDcsrqpDkIV1VtAKXTyQmijAqlvBY2cXnh4C+Y3xiixdE8/4KG/WUgTNcjYhn5bkQ9DzkvSkocnh6XYMJdBW3KxwPQ6Y878insTnHa9qIeM3UCbMHal50wSZySLUynkCJ79ILojMENu3Y55TMNTtW0r51SM0u1FIBPp3NLiqQI20bAKDeIdKzCsLc6AiXepAQSAj63uaw6dOi3KmuTNuMhx9dZ7ysufEVLrT74wusBydRvLTHeb5exAQdFjBLCL2lcQKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(66556008)(76116006)(53546011)(5660300002)(66946007)(15974865002)(66476007)(64756008)(66446008)(71200400001)(110136005)(8676002)(55016003)(8936002)(2906002)(52536014)(38070700005)(122000001)(6506007)(508600001)(86362001)(107886003)(9686003)(7696005)(186003)(26005)(33656002)(38100700002)(83380400001)(4326008)(316002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekRycGZYcFhZSnBCQ0Z0WmRiZ0xBVVcxRHZyYVN0SjE3cW42VzdzRVlMa0Iy?=
 =?utf-8?B?OTFsVVBoNmRMK2lLSHdudmgzT2lFWlc5c0ZSeDZDU3pqVnBXaGN2ZlMybThP?=
 =?utf-8?B?TDI3Q1V3ZkpZbG1WQjJjR3Q2b1Zla0g4ckJGYTlmMUljL0twOThFSnNwZzJa?=
 =?utf-8?B?dklQUHFUZEdIOFp4TjFKS2cyS21sK0Y2QVdIekYrVHRyazk1Z21MejZQZkVq?=
 =?utf-8?B?ZTk1djJpN0VwaytxY3hmZ09jaXBkaGY0NjRvelc3N1crQmFHYW04SXQ0T041?=
 =?utf-8?B?RC9FNW9sc1hNTzdzYmUvN1gxdkcvZXBVZ0NuREYyVC80TTN5SFhoOCtNeDZR?=
 =?utf-8?B?Unk3WEYxRENlSzZWS1drUnFndTdxbFhDRFpMSzBDKzF6YkZWTVh3UEpTbk4v?=
 =?utf-8?B?ekV5NmpIZDlTMTNkVnBBeVJCR0huSmdYS2lEbFdDVFV1SG1nbFFESkhzVkRk?=
 =?utf-8?B?UGJKWlAxc3RrUklJaWVVakR6RVBQZ3RqOUZvcE5pSVdrK2pkT1JHQnQ1eENs?=
 =?utf-8?B?bE95bDdkY2Y5b2lTY2hNSCtsOHBCcXgrNWt2bm1GT0FWNHBFRW5PenMwd1pl?=
 =?utf-8?B?VjBWK1lXdWNHN2xhdHdLTUFpUkNTMGpNSzQ2VWxxQTVPdjhJVTI4aXFSa1d2?=
 =?utf-8?B?ZTZUSlozS1BiczNvUzlDT1pFMlZkcmp1d3p3TnE4RmZicnpkVU0xZ3BPc1Mv?=
 =?utf-8?B?L3owTUl2Ynk5R3pDbjNTQUlkeHovRnZvYW5TcFN3NWtDZ0tEUnJZMnljR1d0?=
 =?utf-8?B?dUYxakdZYW51NHNNQW11QU5SL3YxRHl2TVlxdHNBcnBWRE5yNWR1SW11b2lL?=
 =?utf-8?B?cnBNaUQ0dDZOcUkrV2NVWU9EY1VSS0t3bjBqalJCVkpqSm1SRkhnMDBEZDRR?=
 =?utf-8?B?THpQWmZ1R0ZWdy9GaEJDaWJoSVpVNHJac0ltQXNteVdpaGdEWGtDMjUrYnh4?=
 =?utf-8?B?eGN1RzU3MFFpb1IwdWpqdERRR1d2OFdBRmpRT0RFb0N1WVR2MitISWFOTjJr?=
 =?utf-8?B?M1RLc1hrd0NYM2tCY2hsZWNDTlRFV1U5RzlEL1h2bnAvbWJWY2xtU2dNTXE1?=
 =?utf-8?B?c01wUmhYUlZEL2Fpb3V3a2loU0h3a1pHNWVKYXZZK20zbEgyb1c4RDFubU9V?=
 =?utf-8?B?aEZPb3Q2eTRiTUtzM3JHVlBWb254NHFtM3UvM1RyVzIzazNVUUFISk50bUNQ?=
 =?utf-8?B?QmtsU1FSbXJHK2VzQjdkU0hRMlB2R21XK01IOGt6dTlqTythQ2s4eHc3L280?=
 =?utf-8?B?VUtCVkZzdStqSkFqY3htU1oyeEF1TWc5QjB5ZThtTnI2UTljc28vRHZUWDds?=
 =?utf-8?B?VzNtZlFvVjVLVCszNncrZXFvRUFXdVo3c3ExNjI0VGdVbEpabXJiUldmTmR4?=
 =?utf-8?B?WWRwd1p1OGpNWDJNeXhoNEZpZ0xhME1XcTJKUDRhMEJVc3VQaHgwdWxCeHAy?=
 =?utf-8?B?TXNLNnEwZzE1QUNxd1R3TWE1MWs2ZWRLZ3BYY3V5WHdZUWZidTFSMDduck1n?=
 =?utf-8?B?ZFg2MG9OaDA2OERrdnlPS0JhZmFYSGtCUW5oTnhOMXM4TWowRW9lMmY4VUV1?=
 =?utf-8?B?OWs5cUxrclZDQkFKSC9jWjBvZGMvbXliam14T0JiMVVuMUl3K3FUNUJsV1Ra?=
 =?utf-8?B?TTM2c2d4bWkxM0hqcjVqSjVvc0Q3elJxUmNBaDk0WVByNDFSdXpZTkwxTmJX?=
 =?utf-8?B?Zm5weUpDK0hJWkZzYW5nMlU1S3VpZ1NpOUNZSnhjYnlNUnpQVFpaMnU1YTV6?=
 =?utf-8?B?K2JMTndqaGNzenI4UlRsUEtxQzR4N3dyOG5OREkwVHR4Njl6TWVkKzlFZXZQ?=
 =?utf-8?B?ak55ZXVWOFNnRFkrSmN1M1YwYXhuZ0wrdEVXQ082eng3TVZlVTFORmN4RlhS?=
 =?utf-8?B?N2l6MU1pY0lwdTZTOEVBQUxGUERGanNKdkdBd1dUckt6VjFOWUxYMTRzZC82?=
 =?utf-8?B?NHBzZ09paW1hRE5qR1RVVEplaDNvbG5hK21INVV2MlpUYjdVVE4wa1IzVjg5?=
 =?utf-8?B?RTY5b1NKOXFOWTFNRldWZnAxSklvRDhUSHgzMkIveEkyT1k1NU5mN1Biclhh?=
 =?utf-8?B?Um43NDNWdEhpTWJUbTA1TEFHbVBsL3dvRHNBRUVxR1ZBK2YwN2JOTzRMWlFE?=
 =?utf-8?B?M2xMT25DRXp5TWh0QXlhbEZHN05oTHRnci9mSWFyTzJhRm1xQ1BSRSsyRm9C?=
 =?utf-8?Q?ivRQtpBTdXruZsHtS5rye+4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3e7132-41cd-4874-7bae-08d9db1a6044
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 07:07:37.9432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCviQgydAKTEYXDkPtPTC7HcVb4XJ/bUJR+eciNC+MvLJlmKIb0ZHjwRKmXmTg8vJqfNl0TFTkNQh5iwFAvX9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR02MB5908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2JlcnQgSGFuY29jayA8cm9i
ZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDE5LCAy
MDIyIDQ6MzUgQU0NCj4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWFy
bS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4ga3Vi
YUBrZXJuZWwub3JnOyBNaWNoYWwgU2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47IFJhZGhleSBT
aHlhbSBQYW5kZXkNCj4gPHJhZGhleXNAeGlsaW54LmNvbT47IGRhbmllbEBpb2dlYXJib3gubmV0
OyBhbmRyZXdAbHVubi5jaA0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCB2MyAwLzldIFhpbGlu
eCBheGllbmV0IGZpeGVzDQo+IA0KPiBPbiBUdWUsIDIwMjItMDEtMTggYXQgMTU6NDEgLTA2MDAs
IFJvYmVydCBIYW5jb2NrIHdyb3RlOg0KPiA+IFZhcmlvdXMgZml4ZXMgZm9yIHRoZSBYaWxpbngg
QVhJIEV0aGVybmV0IGRyaXZlci4NCj4gPg0KPiA+IENoYW5nZWQgc2luY2UgdjI6DQo+ID4gLWFk
ZGVkIFJldmlld2VkLWJ5IHRhZ3MsIGFkZGVkIHNvbWUgZXhwbGFuYXRpb24gdG8gY29tbWl0IG1l
c3NhZ2VzLCBubw0KPiA+IGNvZGUgY2hhbmdlcw0KPiA+DQo+ID4gQ2hhbmdlZCBzaW5jZSB2MToN
Cj4gPiAtY29ycmVjdGVkIGEgRml4ZXMgdGFnIHRvIHBvaW50IHRvIG1haW5saW5lIGNvbW1pdCAt
c3BsaXQgdXAgcmVzZXQNCj4gPiBjaGFuZ2VzIGludG8gMyBwYXRjaGVzIC1hZGRlZCByYXRlbGlt
aXQgb24gbmV0ZGV2X3dhcm4gaW4gVFggYnVzeSBjYXNlDQo+ID4NCj4gPiBSb2JlcnQgSGFuY29j
ayAoOSk6DQo+ID4gICBuZXQ6IGF4aWVuZXQ6IGluY3JlYXNlIHJlc2V0IHRpbWVvdXQNCj4gPiAg
IG5ldDogYXhpZW5ldDogV2FpdCBmb3IgUGh5UnN0Q21wbHQgYWZ0ZXIgY29yZSByZXNldA0KPiA+
ICAgbmV0OiBheGllbmV0OiByZXNldCBjb3JlIG9uIGluaXRpYWxpemF0aW9uIHByaW9yIHRvIE1E
SU8gYWNjZXNzDQo+ID4gICBuZXQ6IGF4aWVuZXQ6IGFkZCBtaXNzaW5nIG1lbW9yeSBiYXJyaWVy
cw0KPiA+ICAgbmV0OiBheGllbmV0OiBsaW1pdCBtaW5pbXVtIFRYIHJpbmcgc2l6ZQ0KPiA+ICAg
bmV0OiBheGllbmV0OiBGaXggVFggcmluZyBzbG90IGF2YWlsYWJsZSBjaGVjaw0KPiA+ICAgbmV0
OiBheGllbmV0OiBmaXggbnVtYmVyIG9mIFRYIHJpbmcgc2xvdHMgZm9yIGF2YWlsYWJsZSBjaGVj
aw0KPiA+ICAgbmV0OiBheGllbmV0OiBmaXggZm9yIFRYIGJ1c3kgaGFuZGxpbmcNCj4gPiAgIG5l
dDogYXhpZW5ldDogaW5jcmVhc2UgZGVmYXVsdCBUWCByaW5nIHNpemUgdG8gMTI4DQo+ID4NCj4g
PiAgLi4uL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jIHwgMTM1DQo+
ID4gKysrKysrKysrKystLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4NCBpbnNlcnRpb25z
KCspLCA1MSBkZWxldGlvbnMoLSkNCj4gPg0KPiANCj4gRllJLCBmb3IgdGhlIG5ldGRldi9jY19t
YWludGFpbmVycyBQYXRjaHdvcmsgY2hlY2ssIEkgZHJvcHBlZCBBcmlhbmUgS2VsbGVyIDwNCj4g
YXJpYW5lLmtlbGxlckB0aWsuZWUuZXRoei5jaD4gZnJvbSB0aGUgQ0MgbGlzdCBhcyB0aGVpciBt
YWlsIHdhcyBib3VuY2luZy4NCg0KVGhhbmtzIGZvciB0aGUgc2VyaWVzLiBJIGhhdmUgYWRkZWQg
SGFyaW5pIHRvIHRoaXMgdGhyZWFkIHRvIGFsc28gcmV2aWV3DQphbmQgYWRkIGhlciBUZXN0ZWQt
YnkgdGFnLiBKdXN0IEZZSS0gV2UgYXJlIGluIGZlYXR1cmUgZnJlZXplIHNvIHBsYW4gaXMNCnRv
IGNsb3NlIG9uIHRoaXMgc2VyaWVzIGJ5IG5leHQgd2Vlay4gSG9wZSB0aGF0J3MgZmluZS4NCg0K
PiANCj4gLS0NCj4gUm9iZXJ0IEhhbmNvY2sNCj4gU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBD
YWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzIHd3dy5jYWxpYW4uY29tDQo=
