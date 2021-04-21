Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3001B366C47
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241043AbhDUNNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:13:45 -0400
Received: from mail-mw2nam12on2097.outbound.protection.outlook.com ([40.107.244.97]:61280
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242057AbhDUNLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:11:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ue5+4SMq8VzbfdGzAijN0gC8zldVPFD0ZdBmQTYvDq4HS0+ODIu0yFZNYAtLvrzO3F+gjO+e+mtThdcTJjvGQuYMA2vst+QVRuHMRoE/YIRZ1C56LOU6bayFwKLs5Qf8QJ1gjcUgk/i5TcTNeC9QGqyOhNK0cdlsn+qh/ATdzKP7AvROd8mHLb32+OZbviceZebBbgfCkJNwWp5Ifw9vUu5LNFzq3ErqGvO49BZJdL0f8aEzcj2jNqHEkfZPYij640Mg1IPaofGJYZjBbm4hCprV2XhlBDQTCnBtsNKJImUk1VuyfyPBlByYMZjmyCkU86VlNps2VW4/Zy3t8NPQBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9IHcOMijLo8ckoJ5EcjUohv0mu9v/66FwnZ21m8L9o=;
 b=ETt0SdSWxsV9LBaORWrkpo8i9qVupErYasRZI5oYuxCJcI4cVjUxnBemUzIDNKZbpkQn5RlrjiLfMwd3KFUyVcl/ESoJ0vxAQbSNBcs37w85jFPXI29nIgYoKu+OLc7ci7RuKKGr6I+L7vHNnrou7IfxpxXC84xP9WbXPtv0VoFGTt7rRxdXddk522cSIDhR+TskNqFE5pZ+NviEA+j9JC0JVQrhzcoFV/kK7jlEifMx+evra2xeKNQoaqQG52Fn/depQFufsfitQE2u5oq9zSTltcdYjCoJ1PRUQQ5xpllXKplHkpKYkRgvVon+HWnyl3Yci3lGVgvpSnBV9KJfWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9IHcOMijLo8ckoJ5EcjUohv0mu9v/66FwnZ21m8L9o=;
 b=NdMQ0Kq0xXFjCozrXOkixyu4+o3ASyS2wHdeUsp0TNSIgvzt9/B3U5YZzfAwtFkRCCo2kuRGYFhU0UmwBPwzSWugiMWOaWn32ctsD6d3SnPxsoj1GL/zHYKUgP+f61T1q1l+NMsgkTV1FTddBKn6wc3cvxdFHRwYrujQqwU0E4I=
Received: from BN0PR13MB4725.namprd13.prod.outlook.com (2603:10b6:408:121::8)
 by BN6PR13MB1684.namprd13.prod.outlook.com (2603:10b6:404:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6; Wed, 21 Apr
 2021 13:11:03 +0000
Received: from BN0PR13MB4725.namprd13.prod.outlook.com
 ([fe80::8de6:fcd7:c82d:c86a]) by BN0PR13MB4725.namprd13.prod.outlook.com
 ([fe80::8de6:fcd7:c82d:c86a%3]) with mapi id 15.20.4065.021; Wed, 21 Apr 2021
 13:11:03 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "a.shelat@northeastern.edu" <a.shelat@northeastern.edu>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "pakki001@umn.edu" <pakki001@umn.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Topic: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Index: AQHXK0NV8TqxghYc4k6II+5Gojms3qq9E1SAgACmLACAAMk/gIAACR6AgABJzICAAAPegIAAGyIAgAAF9ACAAA5qAA==
Date:   Wed, 21 Apr 2021 13:11:03 +0000
Message-ID: <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
         <YH5/i7OvsjSmqADv@kroah.com> <20210420171008.GB4017@fieldses.org>
         <YH+zwQgBBGUJdiVK@unreal> <YH+7ZydHv4+Y1hlx@kroah.com>
         <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
         <YH/8jcoC1ffuksrf@kroah.com>
         <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
         <YIAYThdIoAPu2h7b@unreal>
In-Reply-To: <YIAYThdIoAPu2h7b@unreal>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: northeastern.edu; dkim=none (message not signed)
 header.d=none;northeastern.edu; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5860e8d2-844c-40e0-f036-08d904c6eab9
x-ms-traffictypediagnostic: BN6PR13MB1684:
x-microsoft-antispam-prvs: <BN6PR13MB1684AB2423BD70B1BE19B6C5B8479@BN6PR13MB1684.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QCsxrt3SR3w4XROvI71jRox/gTXsb0IjKnFPfVxDXJWgW/5nHI56ZYFYkBiz8zTejLtlvQSO6tSnAQwZcvAfGZowGVK4AVsJlm6vPLmewNoLcdwF7Qbe7TKEjBJwSxt78t2G64lhIjUvEpyAgH5uHV7D3v/+2oNIgGImTJOIEHSGA7DSuiAQWgRT+E0qJaVmxyeuUzuXktBh4uxRBB9qp15UIn3Pr8TbKefSF7gKsSpIzOM3UKQqpRZRWKtZh9CZewHO/yaXUb2nqsi7HyXGEuV8HHdSHOskBpNa48PICE7B2/u+BMSiyFnLOkyZfsTtSjhZT8PQrJE4hJ9vlMqE8ummWZTdnv/KvtgWrcuuj+aAjwbUE41A8Sww34N7m7X7vj/tdgdH1o7nmk+b7WmB2RQOZORpM/ca097GGuUvz9cGxo9fNoFJdyXCTTa2drvj0hBQAzma9vh2E9dOF9KJyk27EJWQ3I1Tz1lQ0E9kwJP/Mnr/Q9uL/HCSZ7uAAHB0raqzIxsiK7IQXD8YBVCeHCzOpB4x9AFwdq7U7xC2JW3acTKmaWqlmzeE8Y093ogE8RdPv5+nRORJYPDT79qb144j84MTE1ItjRqIm8Lj31Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR13MB4725.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39840400004)(346002)(136003)(396003)(316002)(296002)(122000001)(478600001)(36756003)(7416002)(66946007)(64756008)(6512007)(8676002)(83380400001)(66476007)(76116006)(54906003)(4326008)(110136005)(71200400001)(6506007)(66556008)(2616005)(186003)(6486002)(2906002)(38100700002)(8936002)(26005)(5660300002)(91956017)(86362001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QjU1bjU1Y29PaThteFJ1b0JiOTdXOVFna21weFlrVmpJWDRwZGNHN3pnNDdY?=
 =?utf-8?B?OGNDVXNyelpSNDNBc3pkOHBENXZUYUpKekk1S3FOcnRYdW1UNjU2OWpMclhD?=
 =?utf-8?B?UEJFNEVMOFRLWDJsZlpZc2RYcG10ZUp1MFh4UFVCdmt2U29ueVN4Zk9ZTHJs?=
 =?utf-8?B?cXFaUXZmeS9jNUtyeHZySHp5Y3hiTTlZcmRsUEVlMGpBSHVmUU42WjNhUUk1?=
 =?utf-8?B?Q1ltY0tKUkJPL25peFBhM0wwS3FsTzJmZ3dTell1OUJ5TFNEOG5sdmFtU3Jo?=
 =?utf-8?B?Y2lMWS9ZMmVFUTFwRmYreGhZc3RCOFQxOHNheE4veHdlRDlSb1VZL3EzLzFD?=
 =?utf-8?B?NTR6aWZHZEt3VUdpaEE3REc1Tm5MbnBwWHpNcCtZTGxHVmFOdWExdnA1TS9m?=
 =?utf-8?B?dWVwRFF5QmExeDE3SU5iNk9wdlM2WXpxVnNpa2xhUU5WTUw4dHZwdWxCV3pL?=
 =?utf-8?B?M0xTc0NFL09leDNoRGFFODNieUNGNkMvYmkzTUNIMXBHSG8yWWJySm9idi9n?=
 =?utf-8?B?ZzIrakFRTVZMeS9mZEpQTktjZnVyV3hFNG5rbnZwdmpZakpoQ2tmTkU0UWNz?=
 =?utf-8?B?Mm9ScFJORGxwZ0NDcHloZkJZRWZwTlFYaXZDWVJrTFhVRktQd0taenZLWXVK?=
 =?utf-8?B?WFVSVmlxa3REcC9pTGFRcTNuTlBrVVlrNFVzWFRkNVMxSElrcjc1T1U4WW9Q?=
 =?utf-8?B?NDZqd1g1RDc2SEZaR01MU3JuV3VldnVzN05lM3dJL1RwY0VmMzI1QlQ3aHJO?=
 =?utf-8?B?OEtRUThlZ2VaV3JSZlUyc3ZnekJwYnpuZGIyNFUwaEZjTHRTdDlWMUxmenpQ?=
 =?utf-8?B?cW5XQlB1UWNhRkxFQ3FQb1U3RHhXbUd1ejNHdzhQLzRtcjd6U3hUM29EYzhF?=
 =?utf-8?B?TzhQeHdsZEt1U1EvaFlROTIrUmk2S295NHdlWkVYSnJNRVh1SVlOTitXdXdY?=
 =?utf-8?B?djBXSWY1ODZtU2VyVVIyZEJlekxBRGRDK1VZV2E1bFhhd0RxOUVFRy9MU2Rr?=
 =?utf-8?B?THB1S0E3V1gzcDJvUSs1SzBBUnF4Nmh3YXN6YlpaY2xsUERhVWJWZ3hsRTVF?=
 =?utf-8?B?WlVyRTR0akNuVTZVZFhUMi92MjM5K09GVEV4T1Q0NmRTZEFwTFRUbXhMOTVs?=
 =?utf-8?B?N0dNbXRPRlZGRzc5OXQrNE1DdVh6bmU1ZlBWa0JGMVMxUDUxb2JxVG1MVXZi?=
 =?utf-8?B?am9XdEt5MG1lS1ZhUm5JbjVVWERQdkRzUXo2bjc4cmhDcXZqK2dRLytGUlY1?=
 =?utf-8?B?YmNtZ0VOb3ZZTGpZakZJVGJMQXN3TVViRHlZcUJKdkV1R05RZlcraTlIQVBp?=
 =?utf-8?B?STRYU0s4dnNNcFZXdmRpaXZzUDN1MTNDMldkRTlYWmJPbUhZMmJIT3VHRDJH?=
 =?utf-8?B?UUhZWUp2SXhuY2hPeWQ4WU1kME1ZNWZFcjkzeGZZMXBRd2ZxZWJlN29sVEYy?=
 =?utf-8?B?bFBlUGpWSk8vZ1I3bkJsS2ZLN2JNRHpSdEpqZkwzMzJaajFMZUI2cC9ISGZS?=
 =?utf-8?B?cDJ3STMyVVFJS3NaenZRVExkVzRjbGdmQmErcnhNNHlHUE9Pa2Y1cXFnYjdr?=
 =?utf-8?B?TDNyeW85Ly9OeHl6aEdrTXdMS0NVNHFQUHBORnJGdk9BdWpXbTY3RlhsbEo0?=
 =?utf-8?B?K3BWdW83RVZsR3l1S0RvUTUzM3ZPb3QySVM0aFIzd3FUMWEybzNEUUNVbkJm?=
 =?utf-8?B?SGRDTGFkZExCTnFzTEorZFBhNjBDMFZKbG81dG1JM0xMc3YyVzFWK2lsR1o1?=
 =?utf-8?B?MmdwSkRlM2VLaEhuRTJRbkc2V2hLSEtlb3dzM001SGtROHVjNXgwQjZGRjM2?=
 =?utf-8?B?S0lGem5WV1NRTXU5a2MzUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <23C713876FED744D8DDB1EA7436CA91E@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR13MB4725.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5860e8d2-844c-40e0-f036-08d904c6eab9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 13:11:03.6421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NtRO1Lix/NgiGpv3JxuHSCHCeQ3UGMtYYNM3ARcDeKFKEqkggphtZz+0/SACiKHFw75Eo98fdKBn/hG7gD1/1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA0LTIxIGF0IDE1OjE5ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFdlZCwgQXByIDIxLCAyMDIxIGF0IDExOjU4OjA4QU0gKzAwMDAsIFNoZWxhdCwgQWJo
aSB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGV5IGludHJvZHVjZSBrZXJuZWwgYnVn
cyBvbiBwdXJwb3NlLiBZZXN0ZXJkYXksIEkgdG9vayBhDQo+ID4gPiA+ID4gPiBsb29rIG9uIDQN
Cj4gPiA+ID4gPiA+IGFjY2VwdGVkIHBhdGNoZXMgZnJvbSBBZGl0eWEgYW5kIDMgb2YgdGhlbSBh
ZGRlZCB2YXJpb3VzDQo+ID4gPiA+ID4gPiBzZXZlcml0eSBzZWN1cml0eQ0KPiA+ID4gPiA+ID4g
ImhvbGVzIi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBBbGwgY29udHJpYnV0aW9ucyBieSB0aGlz
IGdyb3VwIG9mIHBlb3BsZSBuZWVkIHRvIGJlDQo+ID4gPiA+ID4gcmV2ZXJ0ZWQsIGlmIHRoZXkN
Cj4gPiA+ID4gPiBoYXZlIG5vdCBiZWVuIGRvbmUgc28gYWxyZWFkeSwgYXMgd2hhdCB0aGV5IGFy
ZSBkb2luZyBpcw0KPiA+ID4gPiA+IGludGVudGlvbmFsDQo+ID4gPiA+ID4gbWFsaWNpb3VzIGJl
aGF2aW9yIGFuZCBpcyBub3QgYWNjZXB0YWJsZSBhbmQgdG90YWxseQ0KPiA+ID4gPiA+IHVuZXRo
aWNhbC7CoCBJJ2xsDQo+ID4gPiA+ID4gbG9vayBhdCBpdCBhZnRlciBsdW5jaCB1bmxlc3Mgc29t
ZW9uZSBlbHNlIHdhbnRzIHRvIGRvIGl04oCmDQo+ID4gPiA+IA0KPiA+IA0KPiA+IDxzbmlwPg0K
PiA+IA0KPiA+IEFjYWRlbWljIHJlc2VhcmNoIHNob3VsZCBOT1Qgd2FzdGUgdGhlIHRpbWUgb2Yg
YSBjb21tdW5pdHkuDQo+ID4gDQo+ID4gSWYgeW91IGJlbGlldmUgdGhpcyBiZWhhdmlvciBkZXNl
cnZlcyBhbiBlc2NhbGF0aW9uLCB5b3UgY2FuDQo+ID4gY29udGFjdCB0aGUgSW5zdGl0dXRpb25h
bCBSZXZpZXcgQm9hcmQgKGlyYkB1bW4uZWR1KSBhdCBVTU4gdG8NCj4gPiBpbnZlc3RpZ2F0ZSB3
aGV0aGVyIHRoaXMgYmVoYXZpb3Igd2FzIGhhcm1mdWw7IGluIHBhcnRpY3VsYXIsDQo+ID4gd2hl
dGhlciB0aGUgcmVzZWFyY2ggYWN0aXZpdHkgaGFkIGFuIGFwcHJvcHJpYXRlIElSQiByZXZpZXcs
IGFuZA0KPiA+IHdoYXQgc2FmZWd1YXJkcyBwcmV2ZW50IHJlcGVhdHMgaW4gb3RoZXIgY29tbXVu
aXRpZXMuDQo+IA0KPiBUaGUgaHVnZSBhZHZhbnRhZ2Ugb2YgYmVpbmcgImNvbW11bml0eSIgaXMg
dGhhdCB3ZSBkb24ndCBuZWVkIHRvIGRvDQo+IGFsbA0KPiB0aGUgYWJvdmUgYW5kIHdhc3RlIG91
ciB0aW1lIHRvIGZpbGwgc29tZSBidXJlYXVjcmF0aWMgZm9ybXMgd2l0aA0KPiB1bmNsZWFyDQo+
IHRpbWVsaW5lcyBhbmQgcmVzdWx0cy4NCj4gDQo+IE91ciBzb2x1dGlvbiB0byBpZ25vcmUgYWxs
IEB1bW4uZWR1IGNvbnRyaWJ1dGlvbnMgaXMgbXVjaCBtb3JlDQo+IHJlbGlhYmxlDQo+IHRvIHVz
IHdobyBhcmUgc3VmZmVyaW5nIGZyb20gdGhlc2UgcmVzZWFyY2hlcnMuDQo+IA0KDQo8c2hydWc+
VGhhdCdzIGFuIGVhc3kgdGhpbmcgdG8gc2lkZXN0ZXAgYnkganVzdCBzaGlmdGluZyB0byB1c2lu
ZyBhDQpwcml2YXRlIGVtYWlsIGFkZHJlc3MuPC9zaHJ1Zz4NCg0KVGhlcmUgcmVhbGx5IGlzIG5v
IGFsdGVybmF0aXZlIGZvciBtYWludGFpbmVycyBvdGhlciB0aGFuIHRvIGFsd2F5cyBiZQ0Kc2Nl
cHRpY2FsIG9mIHBhdGNoZXMgc3VibWl0dGVkIGJ5IHBlb3BsZSB3aG8gYXJlIG5vdCBrbm93biBh
bmQgdHJ1c3RlZA0KbWVtYmVycyBvZiB0aGUgY29tbXVuaXR5LCBhbmQgdG8gc2NydXRpbmlzZSB0
aG9zZSBwYXRjaGVzIHdpdGggbW9yZQ0KY2FyZS4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxp
bnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBo
YW1tZXJzcGFjZS5jb20NCg0KDQo=
