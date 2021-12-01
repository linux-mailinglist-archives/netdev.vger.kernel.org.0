Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8AC46479A
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347093AbhLAHK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:10:27 -0500
Received: from mail-bn8nam08on2085.outbound.protection.outlook.com ([40.107.100.85]:14817
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232517AbhLAHK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 02:10:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tco7XpJn485CiMzUNeHBUN1wpC5vuPAD6pnaVAQrIcdlxIbwgugvPlRjH460csWdKUZF/K0DodTJlvkikX9Tvu1YcMksybh3kbEBhbmNKULUQ8DN8A3+7qECF57SpOfUxQC7YeFPNE4pHjuA4V70RU9XprHwtlOArwLZnW0iH4UsRHLLL6JyW09XANHsGGbvUilSzRIIug1bH0l4P71FEqOodDZ1MKgQn+xPcmrDO3tRQnnB+BVa/iJUMHqWKo5aqBLO5rVuKInBXpKCbIi3RAoQtFixnjhOnzXURbG6gZ9Pu46bfejYXQBIz46g+8o4z2H8Irl6K27cQwqg0umhNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2MSb6BLHJNp14CVvc2CXBu44yzhnKt7ptwXe0mu5Mc=;
 b=Yf/nqQte6vz9zhFh4OEWWGNMp2vRX9JV0RYYkWhrRO7XcfS3NW3nZbQmtyEm5+JPsmzVkLXfY43vnFe4zWzqoExBXCMckzoeBJ2I3ojllExWda4dAti7+pnRDbciFI8o7pUyG5B2a4ZK/s0CXWJFGJgUGuLDBDldAOZcjlCr5qqox2B14SzVzeHMjVrYCTWb/ODfdJVNjlZkjjJYkEDShSpDXQcIkLrRHkZL6Y0XSCTxLCYA4524cH/yZt02giDDax+ua7HX/mevn03OH9IDQYOeufR7UfPf+CShW68XXPAvRAUj0vyioERp4ioEmk1gTiQuzGHfmccsx8V8kDKZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2MSb6BLHJNp14CVvc2CXBu44yzhnKt7ptwXe0mu5Mc=;
 b=Edb9L1CnXdK3g2lBLP62b4GoE1S5lNlxkQjNst4FjngMa6LQFWtESAIq5ZnOtqKmh4xvn5i53IJkUv//8XCrtCVesMV2a+4jcAqe+3HfWs+BFVjiVJpuTJINN/7fRlxSie7iCwn8ewu2gIJOuNExLsx4BJLSwoeH2DtwyhE4047CtAOIgAqu1kfD2pGtQAgSGIosW2icHi8LY1h4dEX0C6q/Wfucj2qsCgqqOG75kIDhg0zBI5fVUYY9glw4b19Gs7JMhs9u5CgBrAnyOJDsG8IDSJt3wouYi2WqENN4JGD8pRB5mGcj/kxxt6yPy3P88OQR9V+sTh7oCznK9F3K+g==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 1 Dec
 2021 07:07:05 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4713.029; Wed, 1 Dec 2021
 07:07:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369esocIlp2uqECAMRBwa0Q32qwQUeyAgAxe1YCAAFJzgIAAQYMA
Date:   Wed, 1 Dec 2021 07:07:05 +0000
Message-ID: <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
         <20211122144307.218021-2-sunrani@nvidia.com>
         <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
         <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12e45c43-9727-469f-7c7b-08d9b4992ea0
x-ms-traffictypediagnostic: BY5PR12MB4097:
x-microsoft-antispam-prvs: <BY5PR12MB409703F5F0D835382ABA14C3B3689@BY5PR12MB4097.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PSgbLN1Iwt3mA4DEyZx4B58BTmn0WJaEu2YPZ1KD8VOtWD3SgXtWaC4GIyNhgInjzbaK9gBH3aOVjdWdVWK4950sGkBMrZmDh/Hkxocp4iX4Z3/MFbJ6eHQP/q5BVnxFxKu1oJnI4FAD/stBlKaelvYb93EtOaZWixJhkENVLoqqEXAobVXUSP36qTEsZ0yExYTwTc74vJeuzGGkGaiLDtrs0s8U0BpjCVNSZRGxRm3YeTP35FYgOe2knE1j78QHKkOn4KhXX6C5NfwxusHVzoDGI6rtp0f+LFBhg4tIyfFJdLV5PfMRnJYoOFxk5bh+75JgPII4pT4/8blN+OJKAoseBkQ/djGoVfbBBiCmJtUnn2xlYt9nJ+lFu/ds2vmbeEcIMu4YAq2HSmkrNGrEFbsFM0wOK1KkQjwZVZBCyqlanEwhQZDzgyrAJBXvsrcJze07xS77cf1tb95UiJg93ZEROK7feFTxkLsAOUxvnZ++Yw40ZSoKwXzkKUdeDzXRZTGdoHm8mGCTV/IwPoL4iNcdgB0cQOVLg+PjyEtwFClQY7OJGMlbT1OL9F6sO1yf71JZSTMei4+gJx8u96iS2ljHIX65o0BIni5i4fsrpfw5B9VuW+Q0EGsIhyjg12ngAibgkdcC1+9lrTVOts3If9I9Mrg61Hu37ViYDSj0f8FgQW1zwE1fCJ1x3HXw1QLhFojC/mW2MIU9gHuMdV0wVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(76116006)(38100700002)(186003)(66946007)(107886003)(2616005)(6512007)(64756008)(5660300002)(8676002)(66446008)(26005)(66476007)(2906002)(6636002)(54906003)(8936002)(71200400001)(6486002)(508600001)(4001150100001)(4326008)(110136005)(83380400001)(66556008)(122000001)(86362001)(316002)(36756003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFpIK25ZbXZ2cEF5ZTVZVGU5TG1mK1FqTVN4bWRSbmg3RWVyaWZmUXpSNHow?=
 =?utf-8?B?RHg2R0d1cmp1YmhKVEg4RHM5RGtwTW83WWVCVzJuaVF1a1RtV20rSDdzbFBU?=
 =?utf-8?B?NWNPTlRMUTBvcVdYbXBqTG1RWEZRSnlKZkNQa1BhY2g4dDhRblA0eW9Wb0FZ?=
 =?utf-8?B?MFZhYTkzWkhBaFZJNVFYQjliOGZWTVNsZFJFNVJtTlNpTGpjdVdXRDhCVG9q?=
 =?utf-8?B?SUt1SFZENkJjWjBQVTA2YXhYa1ZhYWNlbzloZUN0SDlaUGxqKzFla01OalJp?=
 =?utf-8?B?UlpTMjJpNXNGR0lSUnBxbU91MUxMbHoybys0M0swRWgreVR3WGcwMm96VTIx?=
 =?utf-8?B?bG9oLzNwdVFiMlNsUDlaRTA5dWcreU16RmpwdGNMTzVuQjFtMVUyc2I3aVZG?=
 =?utf-8?B?TmpnMFZaMFQ1OUJiSittVWEyQjdOc1lkdFFyQmNLa3BuTXpHZnM3OTZSNzJD?=
 =?utf-8?B?M3NmbHAvamd5NElKeXFmZUs0VXZ1aVlkRXlXcTc2OUc2NWpoUTNtRk0rR1JY?=
 =?utf-8?B?aUhIVXNzZ1pJL1djb29VajY0Snp1cEtGaFZUU3p1azZYR2pVU3hNMXlTL0Vk?=
 =?utf-8?B?dytHOVovT21NRnhhV1RHNy9taUxnRmF3cTFML1BlVzFvYk9LdjFJUktxSkpU?=
 =?utf-8?B?ZURVNDRTdit1OVcwb2dnVWNBV2N5MlcrdTBXaGZGY2FvN1diTm5XU0dkN3Rp?=
 =?utf-8?B?NytCZUk4eEJNcHF4dWJaWk5PZ2hZcjlKd0ZZNER6Q3F5Q0FnazJRNzNvTDBi?=
 =?utf-8?B?ZmE1RnJEdUhPVWUySGhqRUFOTXQ0NmQvQSs4UmszQjA5TWFzeTgyUG0ySklQ?=
 =?utf-8?B?TGNFbjRDNzlSbk1TaUlveWZiTkduOUxqQ0VuazdBeGFKdG1tL2YyOWxBalJw?=
 =?utf-8?B?RGVYbDlqNkZOWUY0S2NpWlVsRG1wYzYyOUpvRG5BVUQrKzJ1Tkg0WFU2TGRl?=
 =?utf-8?B?YzR3bjBUS01KQUR3RTNacW91VDVqeWVyL3gyejNrSjhXaXFxd0ZxVU1HeGox?=
 =?utf-8?B?R0pDUFRmMElOYXlnUS9EVFJ3VW1hdGlDQlJIZmFlb2wvSTJUb0VjdUUybVBX?=
 =?utf-8?B?MnRLaFZXWG03REJBVU9rbm0wakhBaGRCNmE5R3kva25tYlJEUHJ3L2hudGVy?=
 =?utf-8?B?WTNvUzN6Y1VXUzk0ekdiK2RLdVNEYk5HRWVVd3pnU3FORGxlY1Z0SXBKZXNE?=
 =?utf-8?B?NmRxQWsraFhSdnRZc2gvZ0lnSjVHQmpXWFc2WkVwTGtQcU51b09aZ0tKdnN6?=
 =?utf-8?B?cFdsZUR1Zjc0N0czNnBxN0ZrUE9HMlY5anJMYjBKMUgzaXlQRnk3eGM3bHMz?=
 =?utf-8?B?UzNteDF5S2NYZUhXNTFlNHBwMjc0R2xHbDFnQXN2czNhNlZ5WTZwd2FOOFNS?=
 =?utf-8?B?YUhCVXVQeGVqaHA5eVA4ZzFRRytaSFJPMDVQU2c0b3pIczVTVTY5WHJvN2pN?=
 =?utf-8?B?R3B3TEE4MHFJMmZnbmxwK1F6SVgxUElrSE4zZ1lqck0ybWlUVkFuL1A4c3Vj?=
 =?utf-8?B?N1RaNjZzVks5OXJMMzVGRnlIOXBZYXJHc2YvWHVJNVJwdmFCTWxyemVYN3BW?=
 =?utf-8?B?RGxMdjREd09WbDRLTURKQ2FRRWVnQWRMcHBWZVRXeVJxK2tsOENlL0pYTVc2?=
 =?utf-8?B?eGFkbnFBcFJQMyszWXNNSmdVSjVheE8yeGNBdHFnc1F2cjlwZzJURG1WejJK?=
 =?utf-8?B?WHk1cFBFQXhqdmlzZDNCUmQ4d1B6Qnp2elR0OXpGZkRqSW55cERWcXp4Mk9m?=
 =?utf-8?B?NzVMcytnaHdWRzM5NHNmYVZOSXJZS0NBUm53L0VnU1k4by8ya2grOUsyQ1M4?=
 =?utf-8?B?ZDFYdDB0ejBQakpVc2FSN3NDQ1NrdmpKbDhETnFaQ3ErdnB5cDgvZXl1Umgz?=
 =?utf-8?B?WmM2KzZ2TzVJU0R5TlMyZitmZlhNbno1SVhtdWVEYmsva0VLamZEV3g2d2ht?=
 =?utf-8?B?ZytmL0U3QXJ2a0xyOG01WmNPbzJYU3M0Y3VJMnNFSjRBNkRjNjFJSEkyS0l2?=
 =?utf-8?B?WS82cXRnK0drbDc1QXVONDhSL2NNTjl5SG56TGRiV3k5YWNza0dYUGNJSmNk?=
 =?utf-8?B?RVZsSkp0cEo3QWdFUlUxZ2E4R1Y4OUlzM1l3VC9tZDNyMzFFcndXVHA5cFNL?=
 =?utf-8?B?c3JTemNqY01peXZabWRaQXR2ams3ZS9tZ3JrRW5vOG9reTIzeEZXMnVqQkFy?=
 =?utf-8?Q?NYaUKG8KtJzGXkh5ZUCzft47BLMI3c5bQgK2Vr6DQfXg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA65B8FB6D64B14880D6BAF121CAF992@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e45c43-9727-469f-7c7b-08d9b4992ea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 07:07:05.4343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SG0NRFGQ96mAbgdi/1+TFzfizzGJf5EGNHUgAhsTp17wycCTkAWt624hp7kl79sSrbl3YaFnyzI6zHeZVctQYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTExLTMwIGF0IDE5OjEyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAzMCBOb3YgMjAyMSAyMjoxNzoyOSArMDAwMCBTdW5pbCBTdWRoYWthciBSYW5p
IHdyb3RlOg0KPiA+ID4gT24gTW9uLCAyMiBOb3YgMjAyMSAxNjo0MzowNiArMDIwMCBTdW5pbCBS
YW5pIHdyb3RlOsKgIA0KPiA+ID4gPiBUaGUgZGV2aWNlL2Zpcm13YXJlIGRlY2lkZXMgaG93IHRv
IGRlZmluZSBwcml2aWxlZ2VzIGFuZCBhY2Nlc3MNCj4gPiA+ID4gdG8gcmVzb3VyY2VzLg0KPiA+
ID4gDQo+ID4gPiBHcmVhdCBBUEkgZGVmaW5pdGlvbi4gTmFja8KgIA0KPiA+IA0KPiA+IFNvcnJ5
IGZvciB0aGUgbGF0ZSByZXNwb25zZS4gV2UgYWdyZWUgdGhhdCB0aGUgY3VycmVudCBkZWZpbml0
aW9uDQo+ID4gaXMgdmFndWUuDQo+ID4gDQo+ID4gV2hhdCB3ZSBtZWFudCBpcyB0aGF0IHRoZSBl
bmZvcmNlbWVudCBpcyBkb25lIGJ5IGRldmljZS9GVy4NCj4gPiBXZSBzaW1wbHkgd2FudCB0byBh
bGxvdyBWRi9TRiB0byBhY2Nlc3MgcHJpdmlsZWdlZCBvciByZXN0cmljdGVkDQo+ID4gcmVzb3Vy
Y2Ugc3VjaCBhcyBwaHlzaWNhbCBwb3J0IGNvdW50ZXJzLg0KPiA+IFNvIGhvdyBhYm91dCBkZWZp
bmluZyB0aGUgYXBpIHN1Y2ggdGhhdDoNCj4gPiBUaGlzIGtub2IgYWxsb3dzIHRoZSBWRi9TRiB0
byBhY2Nlc3MgcmVzdHJpY3RlZCByZXNvdXJjZSBzdWNoIGFzDQo+ID4gcGh5c2ljYWwgcG9ydCBj
b3VudGVycy4NCj4gDQo+IFlvdSBuZWVkIHRvIHNheSBtb3JlIGFib3V0IHRoZSB1c2UgY2FzZSwg
SSBkb24ndCB1bmRlcnN0YW5kIA0KPiB3aGF0IHlvdSdyZSBkb2luZy4NCg0KU29tZSBkZXZpY2Ug
ZmVhdHVyZXMvcmVnaXN0ZXJzL3VuaXRzIGFyZSBub3QgYXZhaWxhYmxlIGJ5IGRlZmF1bHQgdG8N
ClZGcy9TRnMgKGUuZyByZXN0cmljdGVkKSwgZXhhbXBsZXMgYXJlOiBwaHlzaWNhbCBwb3J0DQpy
ZWdpc3RlcnMvY291bnRlcnMgYW5kIHNpbWlsYXIgZ2xvYmFsIGF0dHJpYnV0ZXMuDQoNClNvbWUg
Y3VzdG9tZXJzIHdhbnQgdG8gdXNlIFNGL1ZGIGluIHNwZWNpYWxpemVkIFZNL2NvbnRhaW5lciBm
b3INCm1hbmFnZW1lbnQgYW5kIG1vbml0b3JpbmcsIHRodXMgdGhleSB3YW50IFNGL1ZGIHRvIGhh
dmUgc2ltaWxhcg0KcHJpdmlsZWdlcyB0byBQRiBpbiB0ZXJtcyBvZiBhY2Nlc3MgdG8gcmVzdHJp
Y3RlZCByZXNvdXJjZXMuDQoNCk5vdGU6IHRoaXMgZG9lc24ndCBicmVhayB0aGUgc3Jpb3Yvc2Yg
bW9kZWwsIHRydXN0ZWQgU0YvVkYgd2lsbCBub3QgYmUNCmFsbG93ZWQgdG8gYWx0ZXIgZGV2aWNl
IGF0dHJpYnV0ZXMsIHRoZXkgd2lsbCBzaW1wbHkgZW5qb3kgYWNjZXNzIHRvDQptb3JlIHJlc291
cmNlcy9mZWF0dXJlcy4NCg0KV2Ugd291bGQndmUgcHVzaGVkIGZvciBhIG1vcmUgZmluZS1ncmFp
bmVkIHBlciAiY2FwYWJpbGl0eSIgQVBJLCBidXQNCndoZXJlIGRvIHdlIHN0YXJ0L2VuZD8gSSB0
aGluayAidHJ1c3QiIGNvbmNlcHQgaXMgdGhlIHJpZ2h0IGFwcHJvYWNoLg0KDQo=
