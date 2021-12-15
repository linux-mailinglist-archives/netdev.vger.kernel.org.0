Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03286476579
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhLOWOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:14:14 -0500
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:52704
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229811AbhLOWON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 17:14:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gp/77yb/a8js179o2XgkgnDBXVRjohJl3zDfauMz8NIPOqFmq+3mc+nSQKw2/Tqi1DU8wr83rptoaucG3dXyAPuf7GRGK2EyJqIvyI829THX5TURL6UfYO+hYY4fE4KpDsM1bxBoBFIZ+kC2UO8is6JF46xYUg9ex42LhrG8MEBhNO3bN+ZVdmxBPSWtwEuT7MnrY0WMrYRP2TWUQ98oWU2SzAAjP2qgjyYGE1/o3ActsDxydJ0PUeJasuBql9N7Ka7Df4k+9BxZNCrqF+MnVP4s759NxtfbPaPdYhF9eAON9r6RxY3gsKExagVmKZLU95Ff3nMsqsMHr01hJxr/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wkE20k8i9yqg0/ahSH0XUCzyDev/2BQK0yKu9vnFRI=;
 b=MK7CN0pqTyf0EORusBfA+YNcvt2KKqatu0hG1VGhpixZMX1MbkIwz68PHOSs1/3npwJF1XvBpjfCYzV5TfBCrS+cB3xTSH9ZQtjjdJMUV8PxsV1DQ2c8uUk96BpU40Zo+xW17gtyBbjyJJa6KVZt4y9+ot3mQxLuKOsiphf2ksIRVEdHPyzp+rEttnxdjdbBLyTSQwBTV+2d2h3EARGJhPIilegCCbrpr4FeBwVfSdT3tk/Ug38+4cN1Pyj8nk0dOc1E1pvz7cf4VdXfvxl6Fr6s59PJgDYX2vm9BduEpMHh5e4pTZI+uOPxeczVU1oQjvE2u9cghdMK7IcrYZXN8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wkE20k8i9yqg0/ahSH0XUCzyDev/2BQK0yKu9vnFRI=;
 b=YO1a6M3AJlYug2o3ZUZTkd5bK4BMdnlXBaDSYbT3UpnwhIr36BRaNn+o4yauwtcsldBngWiLO2nr+5BNeqqH1QhFgyo2XUOBuo1CTrUkDwtVGPh0jeABh66URGHckFaZk8bRjOLXAcVELvQxtFzynkxlmnzRgh2DyuEAOzoekLqtV4MSpaNxrA2/B6mY/6DZWoRrmqiTPgZZFhKc+Hh0S+R9848nN7dvRQH23pmP2Mz/Cygdt2ClUa0GGqyvgsRTV0mEDaOeDXmqxFKO9SLMQsgVNk/FC+W9kGHio1tBPJshjwpH1Jc74KA+C3x+u77iPviuFywjZpAbP7gQ5QHuXg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3400.namprd12.prod.outlook.com (2603:10b6:a03:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 22:14:12 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 22:14:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
Thread-Topic: [pull-request] mlx5-next branch 2021-12-15
Thread-Index: AQHX8eSNpvHoVn9Q10+0EcNJVS/d9Kwz7qWAgAAvvAA=
Date:   Wed, 15 Dec 2021 22:14:11 +0000
Message-ID: <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
References: <20211215184945.185708-1-saeed@kernel.org>
         <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a71fb06f-7d9d-45a8-0b91-08d9c0183940
x-ms-traffictypediagnostic: BYAPR12MB3400:EE_
x-microsoft-antispam-prvs: <BYAPR12MB340088FA6EC09D82C4BC02D7B3769@BYAPR12MB3400.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xez/hx95LgtBLxw0be7nJ5Xuf7PrcDWAWiF09WckHCtIVN6qv3dz4osoaYeZXkhWCsU/lh4xH7lM6anEDn1oNTWH75/DjU+HT9TYQsmjh6afIcCmGEDjyLxlc77ZGL7+8oQNPLDSMhI1g1VZdin1yoj2+VpRUfQd35XYaB+SUzheyh92zl7dmsrf9dlQ3BhQxgfhDK7c+v63ZJUpXIdjn6meUHDbPHePhgtgsyQkyvTY6KeL96dQknLY3WoIH85XCIwVNXvNuTr7yEgwOEtGVsk1qRsh7Qk7MjmTBWbu7hunt3yBwwJ20VqlJAgtKgRHkDyrJthALK4OU33AsPwDI29+3u3skkZYbS1ibZCtdOuHNhEmMosL/dn0yTpQ+mMKRWGP9Yn3nLFHew5xw53IvVN+8S3IgYa0hl3DH8owesiafuMx8EyS/GPxJ0zazU/0jFbTeqTTiU8gSGJdH4RegsCZOw7Pzpb6pTrUhVcZRqyfVsuSOPyjZ/Ea/GS54kCgc8JKA2f6TZ0xiuREFO2HtjqaI42sahgZQxCjcrhcaJv6VJDuubGiYsDjisdc+SdR6YhxO1wR6190ERSkgpsnJhUbd7SglKmBpqaYkURQAjVbkSpT4spXro2yM88Dx5f5aq9fRQ5TaDMwVtzsxSAYk1XYNzhr58gw/ji2NiTrtKGHX2yn9FcayN3FyxLiRWjdltroVKOZwR+lr9xI4VNHU4w1vy48TFySutCMF0O6xC9Whz/A2zsldALH9niXi7QES9oNB/YO+pP48hwm5Zt3jVPoyy2YE8N9wF1BPGiFTcaP6mzJzUHOmHzh+otMSwdkl1SYcFMDvDCBm+lzVoz7jA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8676002)(4326008)(26005)(5660300002)(4001150100001)(4744005)(186003)(38100700002)(8936002)(71200400001)(54906003)(6916009)(6506007)(38070700005)(36756003)(86362001)(6486002)(122000001)(316002)(966005)(6512007)(66946007)(64756008)(66556008)(508600001)(76116006)(66446008)(66476007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejR2WWU3SFIvb3lsa0VyZkkyRUZRMkU5dU0xNEJmZkN2b3pmbGR3SmlQWjE1?=
 =?utf-8?B?dXo3aHIzM2h1SDdURjM3WWNhd3JJNmJ1WEFGKytpN3dTaGMwbmxXRFoxVXFv?=
 =?utf-8?B?S2pIRm40MTFQWTVyc3RQUVpMM1NYUUxqcnY2SDk0VHllTGVZS2sxL0Yrckdo?=
 =?utf-8?B?QkhmN0JENS9PaDZadnVDMGhIYTVDd0FXeXVaZjZYeGZoRTJ4a2kyRXdwVW1F?=
 =?utf-8?B?dGtaeEY5cWRmR0NMMDA0c2RCc0dwZ0pFQzZiSFR1aGMxbzh2RE5PelRDUU5z?=
 =?utf-8?B?dS9WUW1MeUxPbEx0eDJmcWlCRmJJUGdzQkZuelV4dTNiUlZ6SzV3MHpsV0ow?=
 =?utf-8?B?RG5XeHA4dEZjVmNKVXpRM3d1UzNqcXFZR0hTYzlVQ0w3dzZKZ3FMeWoxdWdL?=
 =?utf-8?B?NVZHQXJISFg1dzdVdUFQZVdhRHVvNVhYNmhyODNaY21pM05TNTYxZmZxNzZr?=
 =?utf-8?B?U3RrWjFlaTBoNDlLd25FamFrVFBiTXJuSVVUYktBd1hFWEpKZk4wTmJ2NVpL?=
 =?utf-8?B?NUtzaU8yaitHd0x6RTlPU2pjYm1xRyt3WlZKeHdsaTdCeWxuV2Ftc0tFbDlU?=
 =?utf-8?B?NThPQmRvejJtdUlMem5JYitxMjNNVkxQM2IyQm1pRVNwZVBYNjJFWmNTRTVU?=
 =?utf-8?B?T0ljQnlWdFR5NVVCTzNOcFAyWmh5K3d5MEdhQ2E5aDBZclRrVGtRbG96RllQ?=
 =?utf-8?B?ZFNodXF1S0FBK1N5YnlyNzZNM2pEdnFQcGNwbEx1RWxMV2FFOExaZG84d0E0?=
 =?utf-8?B?UFhqcm5OeWxINXZ2RGJBMzl0OFI0NlFNcU1jYTlpRzF4WTNHM2JwRStjMnlY?=
 =?utf-8?B?Mkg1TXh3MHg4Z0JIWm9yWFgrbjUyb1UrQzJ4Z3RNZHk1VXQxeExjWkp1Z1FI?=
 =?utf-8?B?T1hTS2trVVBBMUZwQzhoUU1ZYnZ3RFRlNEVYRGFZdGJhQ3NCSERna2ZuNS9I?=
 =?utf-8?B?OHNGeUV5ZkVKNE5nMXJnTDhTZUZnVXo1b1gwM1kyQU80RkMrSW1MUWZQeVg5?=
 =?utf-8?B?Nm9TMGlnYlp0WUNCd2p3SDhTdmovRGdhbFA4ZFJrV3dlNnV2V3hZSmZmZDdp?=
 =?utf-8?B?dmhIK05VemtGREdEcWgvVHNrZDhFM3I1THljRTVMaUlRc1M2UFZ5ZWFjM01T?=
 =?utf-8?B?aC9YaFRVT3RpQkcxQzFTNDBjMXFyajZmeVU4Lzl2bEZFUDNyeSt6dHZPaVVQ?=
 =?utf-8?B?RDlXeEpWMHRIM3B0a3BEM2JIdW44bUtaZ0Z2NHY3VWJHeFNaZEEyanNNcHpB?=
 =?utf-8?B?eUQ0NEFqODJlVzYyV1JzckNyOTI4TFdmN0xLaHpBbEdEK3QrUnlqTHpKYnc3?=
 =?utf-8?B?RS9peDd0cEU2cEJ4bi9KS3FXelNoaXRlTVJyR2JvWC96THNnL21hSUlQM3h3?=
 =?utf-8?B?bXBTQytKZjM0Vk51RFc1QVFhekVQYjMxZGdyQ1hzZDQ5WlI1eXhLcnVKbmww?=
 =?utf-8?B?N3F5T0ROSHZsM2NCVDd6SEI1OVZreWM4QUpMaHZCWm9RLzN3T0ZBQU8xUjNZ?=
 =?utf-8?B?TlVmLzNrVjRna3lGejQzcHd1ZmlhRWh0L3dFeGdGcTRoenlVV1U3STJ1QUw4?=
 =?utf-8?B?WjU5dDYyL2hDdFUrdnF4MXd3UzYvenhzL2FkOHRrbHQzMnh1aXZMNzR4TzZ4?=
 =?utf-8?B?Y3FKUExlS0NqOVJ2WXpTTGxIT01RSWkzMmsxUWVqRHdyOW95R21Yd1NHYmFF?=
 =?utf-8?B?dCtRQ3ZQYjUvN0JxWDlLL1VCU1Z3WVhZdFhrb0U1bUgxNFMzNmtHMUVQMlYr?=
 =?utf-8?B?N0c1M2UrQWlkZ2dmK2xiWTNUajh2Q3F4cnFLNi9YZXpQc2NjekxseDM1TjFG?=
 =?utf-8?B?Y1pmODlTSGFRai95SWowT2NBa2pxSUY5aDUwSktkTjBRaUd4SHIzY0lyM1Z2?=
 =?utf-8?B?d1RFY0V1b2Y3bllSallsYzNWQ2FYaC9ReURzenJlY1FPTDJHMUtkZDdhL1hz?=
 =?utf-8?B?dkFFZWpCOWIyM2FPSU05R3hOazBQVEp6L0xMeDNEbFdxdFFtdHlNTDFqSUFH?=
 =?utf-8?B?VlI0QUExT1lsTGsvU29wS3pzL0doc3ViaFU2bWx3QVVnVGpKSnV4QStUSGo3?=
 =?utf-8?B?WnY1NGtHWFJSOUNSR215TFRtOGNnazdINVhPRUlYUkRJU2txckdaSDdiUG44?=
 =?utf-8?B?bzM1NVB6Y0ZqZHF2TDJYdGhFYVVwcEhSTjF4R3NFK21UKzAwcDdSM0l2WlJt?=
 =?utf-8?Q?vMTAG5bWsCDYHe8ia8BIfxr5fd7lAVjMJGbkGMBgkdlt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44C670E915623048B4DD9687D81A6CD5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71fb06f-7d9d-45a8-0b91-08d9c0183940
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 22:14:12.0269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NtqgjqGzO78O1A4wvYG94qJmKIpUV+JpJpOonqBnmTXRi1u1QYpwJoSp4ZByC4ETb1/t1yzCDOapGDqMlWUhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTE1IGF0IDExOjIzIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNSBEZWMgMjAyMSAxMDo0OTo0NSAtMDgwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBUaGlzIHB1bGxzIG1seDUtbmV4dCBicmFuY2ggaW50byBuZXQtbmV4dCBhbmQgcmRt
YSBicmFuY2hlcy4NCj4gPiBBbGwgcGF0Y2hlcyBhbHJlYWR5IHJldmlld2VkIG9uIGJvdGggcmRt
YSBhbmQgbmV0ZGV2IG1haWxpbmcgbGlzdHMuDQo+ID4gDQo+ID4gUGxlYXNlIHB1bGwgYW5kIGxl
dCBtZSBrbm93IGlmIHRoZXJlJ3MgYW55IHByb2JsZW0uDQo+ID4gDQo+ID4gMSkgQWRkIG11bHRp
cGxlIEZEQiBzdGVlcmluZyBwcmlvcml0aWVzIFsxXQ0KPiA+IDIpIEludHJvZHVjZSBIVyBiaXRz
IG5lZWRlZCB0byBjb25maWd1cmUgTUFDIGxpc3Qgc2l6ZSBvZiBWRi9TRi4NCj4gPiDCoMKgIFJl
cXVpcmVkIGZvciAoIm5ldC9tbHg1OiBNZW1vcnkgb3B0aW1pemF0aW9ucyIpIHVwY29taW5nIHNl
cmllcw0KPiA+IFsyXS4NCj4gDQo+IFdoeSBhcmUgeW91IG5vdCBwb3N0aW5nIHRoZSBwYXRjaGVz
Pw0KDQphbHJlYWR5IHBvc3RlZCBiZWZvcmUgOg0KWzFdDQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9uZXRkZXYvMjAyMTEyMDExOTM2MjEuOTEyOS0xLXNhZWVkQGtlcm5lbC5vcmcvDQpbMl0NCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMTEyMDgxNDE3MjIuMTM2NDYtMS1zaGF5ZEBu
dmlkaWEuY29tLw0KDQoNCg==
