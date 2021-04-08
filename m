Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02083589E5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhDHQkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:40:17 -0400
Received: from mail-dm6nam11on2127.outbound.protection.outlook.com ([40.107.223.127]:27040
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231480AbhDHQkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:40:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVRRxigWluxB6OO+FEZIEItQuFhPksYV2MCMxNwMoMr6CTa5lwERb91a5QaaO28Z4sA6GZSa/dmPZZRK/NURsaiJMQV0vuWJ8nIAO/QoHshWOSNthCZ/PrSHbmomZs39skcwLITEwLIWSrgqV4ET2A1yyEOJNRNEqd1YvDOM6CnE15KPGuw/bsSuL3tRaVOOQYbg7+FNgZs7DHFIXFrvw0VDIp43GahPrKQl3kmzoJaTG3FqIiBxLlhF8aOUmQCWSL6f4AbKo2KMKQXuJt8UGdpgTYiltAJC4DZ3ckDRDGXCikpfG+SvcDp7ODP5Okgq3BCrLx7lUnx+0ZoFOCc89g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+NyhSU5Fp0iwd2OpGoiMRzzr0qs6NN22fUp2tDQnu0=;
 b=GZyzmPGmTLdQ9pn5HTsTMo98/NUoIz6B8P/Ii9vQy2x/AZfbhF5Wvm2Rk0s9g/TM8mTTMNswxa1dC9c6r1hIVQxP6HwLZztBc3bQs7eSLC1spCUAT+WtWqCa/bj7z3GcyH2Pl83oQzvcfeElK4hmD7BE7tDix5NIgAMIWW9s2pp9BLaIS8Dg93XtnKgPCWvoP9pEj1szgnm8lSn9aI7WJQO9HAsnRQmle+kNDLP+SbA3U/eJSZb5inP80Mor9l+IuGy/x1ZZfvB4m+/0jJhqK4/vciZevUBvdyZdQDf9NBp1NHOgnLOnFnICjJYTuyDXVq73KnZ6SWlHIuv/+4KNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+NyhSU5Fp0iwd2OpGoiMRzzr0qs6NN22fUp2tDQnu0=;
 b=hWf2P9/SDXo1uPpnrXoIBv/V1p//LJSTFGzxptS5z4pz1wpAhvOdh71drlChj5/78QwzlTvCY/+/M1GVPGpcpJPdTookIMuaJNYI5nvcgejEjV2LZ9/bSgbcOmth9oeaM4OuXoM/KFS87iR9Lef4HHioKJN48iwxkqn+NVvPZLE=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1778.namprd21.prod.outlook.com
 (2603:10b6:207:1c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Thu, 8 Apr
 2021 16:40:03 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Thu, 8 Apr 2021
 16:40:03 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLFfPL8irt8hn+U2/SmY55+fY0Kqqzi+AgAAEEJA=
Date:   Thu, 8 Apr 2021 16:40:02 +0000
Message-ID: <BL0PR2101MB09301FF0A115F3C8D9BEBC7DCA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210408091543.22369-1-decui@microsoft.com>
 <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
In-Reply-To: <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=261f7a44-bed7-4245-ac03-ee8c6ea5b8c4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-08T16:37:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 898c3fee-dc34-46e2-c62c-08d8faacf574
x-ms-traffictypediagnostic: BL0PR2101MB1778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB17785C84E201517258FFD7D8CA749@BL0PR2101MB1778.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eTIKdQLj6JhOpitQRmQN22XbRP5CU/9obAzafbCmW+Suyr7guCnqlIBYr4mUu846XltOrtDX0iR1FKLqGYL3uZUJhaPg83NWOLEPbnumK81uifwFj2I6/4vCSYTfRZ0KZWGb4UHqmeEgDoUV7jwkEt7XPFautsQ1HqyVc1qDOr3hkH8dGXbZJxl6DxIosp3w3+iO1pi7inim32H9tA285ZffC8XNSv6wVrhZsAbgw119+puvtvDx41E7auUiRBmzsIvvtvqqF39xHRWGj/aMFV+YKBaZ4/g7hBYPIKTCsmYDUDmv1rpRcHvRSJsek4x6LbRmdDLeEY9l9hn2UTidkqUYUhew8gV4wF9SIeMebLKYfWrEx+3AgbizKu00GlBXEVaH4KNxhbOlfS6R+WD/lKwcIMWDXuvucTBE9YQkQnS8Zb6y1WGBdpGFT4OddkT1NjJt6orDthWvJIG4NOA9QEaHguwkWhsxFCRhONV1pBu8Z7VXK3dM8sAcc6bUk84WElK26527UxWUomnEpLRaQY5Zl4Wt5gPuibZn8TJyfMYyB8HaCYIZvuJSLQZYZ+adc7IeiQqjayuKXhBRKwvP8P+T5v094vHVy+FAzA/FXl42A137hLO1G+bHRr1c3TPuwxJfa4mTi48qZgfqkMD2KGUvKPoXCsC+jKH2cxDvqQssCZ1H5dSI+U4c+otelDkV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(47530400004)(38100700001)(186003)(6506007)(7696005)(55016002)(9686003)(66556008)(53546011)(10290500003)(64756008)(66946007)(921005)(86362001)(33656002)(26005)(66476007)(316002)(66446008)(478600001)(8936002)(5660300002)(8676002)(4326008)(82950400001)(82960400001)(71200400001)(7416002)(8990500004)(54906003)(76116006)(2906002)(110136005)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eENsNWc1YURMajIxYUwwMUNOU0NZbXhhOW1qdTIvV0xDNDlVd3lYZUx4Mjlr?=
 =?utf-8?B?Zm8rcUVFdzdiQUEvai9xMnY5aW9tZ3l2NkRrV3dhUVpqOVN3S2MwK0JrV0sy?=
 =?utf-8?B?OVZLdnIxdS9hSDAwd3RONUhBaXkwQ2dvNFRocnZwV3BNRWRLTWRWT1FlbUx2?=
 =?utf-8?B?QmVrYUw4TlZpc01RZnJLVGxhbnJyYWpENEFyc3VIQWZWZmFWRVBNZXh6aTVo?=
 =?utf-8?B?QTZNdmFsK2dJbW1RMzdCd3RoL0QrdHhraEc4SGw1bnVhQmNQUnZjQkNkK3Bs?=
 =?utf-8?B?OXdDZUIzMWRPZ1ZPY29lcTFudHdwa3M4SnJnSTl4WHpOU2c4VmY5Z2hMUkhM?=
 =?utf-8?B?bG1PMzhRTlFQTlNEYXVoZWZtTFJKcnI4VVpFdk1PSEdEQnJxamFhVTBhbEVF?=
 =?utf-8?B?YzY0R3pKWXBBZGpzSGVVVmdOTTJuYzJlZ2xNL0FtNFd6RWIrWnFiclppYUt0?=
 =?utf-8?B?OEdhVTBUa1NNbXJhbkpDZjJZVlNCL2hUUy9tYW41QkVXblI2NG5PbXB0Z1hp?=
 =?utf-8?B?V2RaUDlqY2R2bTB6RDV2c1FXMDQzY2JsTWRIZGlpcEd3SCtwdmRmSWQrSzc0?=
 =?utf-8?B?SXN4YmU3cHZvT2RIMVBkYkJLaU5ES092RURGWnRQRUpkTzFTakRqSHE0MjZw?=
 =?utf-8?B?Tjdrb0tKaVlvS2V1bnpZUW9xVnV2Skp3ZHlvOWFaT0NyODRMTXRZYk03SUph?=
 =?utf-8?B?STVockJtV2FBSnZFQlh1enNJbnFnb3VGRzJoUkpiRTF0VXJUckJ3MFlzNnJQ?=
 =?utf-8?B?YmRHaUZyV3VqNnp4VlJFczdmWkRvOWFHVGpJZmtHNmJlaHoyZnVza0MxYTlS?=
 =?utf-8?B?aUpoSnVJdVQwVHVGWVJ2WDNvTVIwZnVjOUYrSVgrVlcrM3Brb2ZwNFZydUJk?=
 =?utf-8?B?dXBlcjdjRWlyZzJGVXRnbVJvVjhGcjVlR0NPa2FsM1JucDJUdWlvNFd6WE9G?=
 =?utf-8?B?UGxVUVNYejQvK0VMQzNrUkxiL1NBSkRJd2lkem5kWjRxb3VlWWpuMnhBK3lB?=
 =?utf-8?B?NmpNbnFZWEVJcUxNK3Jqd1p6QmZZMnRBbHMrODhRWHRqdDhKV3dLcUVTN09P?=
 =?utf-8?B?ZXBRM3JvclZ5cExUNlhXUjFWQ3BZY0dTVHJCenBMYnNEbnhqVzVpVWxzNm94?=
 =?utf-8?B?ZFEwK29XN2ZCRlZJVTdqUERQaHVCUHFRQnVpY1dCb1hmK29kYmg2a0JQOVcr?=
 =?utf-8?B?dGdLRGZlMVBqT1dwaHJobDh5RmhKYktsNHB0RkorWklENFAzNmt6Y01FdWJB?=
 =?utf-8?B?d3I5UitzWGV6OGhNelRpN25XSG8rdW9aaTI2Q1ZzMXVzTWtkZjVCRTBvQUFq?=
 =?utf-8?B?ZlpTM3lqelRHaFpwQStQVnE4SHBXMUtDL1lHbFNkbGdOUmxkS0JFTU54MGpX?=
 =?utf-8?B?ZUlTMDUwQkxWTnhWemhPQ1RXVE9lanAzeFEwMkNiMFYwdE9xc0pNampDWGdv?=
 =?utf-8?B?cDlZMnJUUS9tcjFzbnNOeWR0V0tHSUNDbjluejlMUnpReGxqUHZyd0FUME1B?=
 =?utf-8?B?YkdBVWMwRC9veEptSkdFQ2ZPN0h5OUJSUW1FWG5nV3d5VklTdEhJWTJRTGtY?=
 =?utf-8?B?MmJ1Z25WelJWUjhqOU9aV2JqekJPRFpPVmRGaFV5ZzhZSERKa2Uwa01vNTBo?=
 =?utf-8?B?N2tKS1UyZzB6K0ExODdUNyt5SzkrdUs4d21SaHM5U00wc2tkOHVlV2RhZ3dX?=
 =?utf-8?B?ZnFVRTNuZndvN25mM3pyTFN3dCt2QjErdEgwdzJ0Z2t4aW53cTUzN2Q5QlpQ?=
 =?utf-8?Q?HrEpRR/tkxvI+zKylruZPSqYOfk3AeXwoZFnUIK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898c3fee-dc34-46e2-c62c-08d8faacf574
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 16:40:03.0066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VaCWqJNTAfB4hvNHL2tIAfrcks9wJy+N7IVZphs+6f7fSZKcT4Hm3MzbipXX/yWGxyH611lUbKsmO8/dEjUCyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmFuZHkgRHVubGFwIDxy
ZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCA4LCAyMDIxIDEy
OjIzIFBNDQo+IFRvOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsNCj4ga3ViYUBrZXJuZWwub3JnOyBLWSBTcmluaXZhc2FuIDxreXNAbWljcm9z
b2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcNCj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBTdGVw
aGVuIEhlbW1pbmdlcg0KPiA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT47IHdlaS5saXVAa2VybmVs
Lm9yZzsgV2VpIExpdQ0KPiA8bGl1d2VAbWljcm9zb2Z0LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IGxlb25Aa2VybmVsLm9yZzsNCj4gYW5kcmV3QGx1bm4uY2g7IGJlcm5kQHBldHJvdml0
c2NoLnByaXYuYXQNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWh5
cGVydkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXQtbmV4dF0g
bmV0OiBtYW5hOiBBZGQgYSBkcml2ZXIgZm9yIE1pY3Jvc29mdCBBenVyZQ0KPiBOZXR3b3JrIEFk
YXB0ZXIgKE1BTkEpDQo+IA0KPiBPbiA0LzgvMjEgMjoxNSBBTSwgRGV4dWFuIEN1aSB3cm90ZToN
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L0tjb25maWcN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb3NvZnQvS2NvbmZpZw0KPiA+IG5ldyBmaWxl
IG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi4xMmVmNmI1ODE1NjYNCj4gPiAt
LS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9zb2Z0L0tj
b25maWcNCj4gPiBAQCAtMCwwICsxLDMwIEBADQo+ID4gKyMNCj4gPiArIyBNaWNyb3NvZnQgQXp1
cmUgbmV0d29yayBkZXZpY2UgY29uZmlndXJhdGlvbg0KPiA+ICsjDQo+ID4gKw0KPiA+ICtjb25m
aWcgTkVUX1ZFTkRPUl9NSUNST1NPRlQNCj4gPiArCWJvb2wgIk1pY3Jvc29mdCBBenVyZSBOZXR3
b3JrIERldmljZSINCj4gDQo+IFNlZW1zIHRvIG1lIHRoYXQgc2hvdWxkIGJlIGdlbmVyYWxpemVk
LCBtb3JlIGxpa2U6DQo+IA0KPiAJYm9vbCAiTWljcm9zb2Z0IE5ldHdvcmsgRGV2aWNlcyINClRo
aXMgZGV2aWNlIGlzIHBsYW5uZWQgZm9yIEF6dXJlIGNsb3VkIGF0IHRoaXMgdGltZS4NCldlIHdp
bGwgdXBkYXRlIHRoZSB3b3JkaW5nIGlmIHRoaW5ncyBjaGFuZ2UuDQoNCj4gDQo+IA0KPiA+ICsJ
ZGVmYXVsdCB5DQo+ID4gKwloZWxwDQo+ID4gKwkgIElmIHlvdSBoYXZlIGEgbmV0d29yayAoRXRo
ZXJuZXQpIGRldmljZSBiZWxvbmdpbmcgdG8gdGhpcyBjbGFzcywgc2F5IFkuDQo+ID4gKw0KPiA+
ICsJICBOb3RlIHRoYXQgdGhlIGFuc3dlciB0byB0aGlzIHF1ZXN0aW9uIGRvZXNuJ3QgZGlyZWN0
bHkgYWZmZWN0IHRoZQ0KPiA+ICsJICBrZXJuZWw6IHNheWluZyBOIHdpbGwganVzdCBjYXVzZSB0
aGUgY29uZmlndXJhdG9yIHRvIHNraXAgdGhlDQo+ID4gKwkgIHF1ZXN0aW9uIGFib3V0IE1pY3Jv
c29mdCBBenVyZSBuZXR3b3JrIGRldmljZS4gSWYgeW91IHNheSBZLCB5b3UNCj4gDQo+IAkgICAg
ICAgICAgIGFib3V0IE1pY3Jvc29mdCBuZXR3b3JraW5nIGRldmljZXMuDQooZGl0dG8pDQoNCj4g
DQo+ID4gKwkgIHdpbGwgYmUgYXNrZWQgZm9yIHlvdXIgc3BlY2lmaWMgZGV2aWNlIGluIHRoZSBm
b2xsb3dpbmcgcXVlc3Rpb24uDQo+ID4gKw0KPiA+ICtpZiBORVRfVkVORE9SX01JQ1JPU09GVA0K
PiA+ICsNCj4gPiArY29uZmlnIE1JQ1JPU09GVF9NQU5BDQo+ID4gKwl0cmlzdGF0ZSAiTWljcm9z
b2Z0IEF6dXJlIE5ldHdvcmsgQWRhcHRlciAoTUFOQSkgc3VwcG9ydCINCj4gPiArCWRlZmF1bHQg
bQ0KPiANCj4gUGxlYXNlIGRyb3AgdGhlIGRlZmF1bHQgbS4gV2UgZG9uJ3QgcmFuZG9tbHkgYWRk
IGRyaXZlcnMgdG8gYmUgYnVpbHQuDQpXZSB3aWxsLg0KDQo+IA0KPiBPciBsZWF2ZSB0aGlzIGFz
IGlzIGFuZCBjaGFuZ2UgTkVUX1ZFTkRPUl9NSUNST1NPRlQgdG8gYmUgZGVmYXVsdCBuLg0KPiAN
Cj4gDQo+ID4gKwlkZXBlbmRzIG9uIFBDSV9NU0kgJiYgWDg2XzY0DQo+ID4gKwlzZWxlY3QgUENJ
X0hZUEVSVg0KPiA+ICsJaGVscA0KPiA+ICsJICBUaGlzIGRyaXZlciBzdXBwb3J0cyBNaWNyb3Nv
ZnQgQXp1cmUgTmV0d29yayBBZGFwdGVyIChNQU5BKS4NCj4gPiArCSAgU28gZmFyLCB0aGUgZHJp
dmVyIGlzIG9ubHkgdmFsaWRhdGVkIG9uIFg4Nl82NC4NCj4gDQo+IHZhbGlkYXRlZCBob3c/DQpP
biBvdXIgcHJlLXJlbGVhc2VkIEhXLg0KDQpUaGFua3MsDQotIEhhaXlhbmcNCg==
