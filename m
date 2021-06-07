Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB53239D4AB
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFGGMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:12:40 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:43657
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229470AbhFGGMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:12:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkVSFmscMwF6TGPCbW0DpbVDEplMzX+GammjCEjPeEMtrxrFd67ScjjmLIRRrm7MITn6gZeqgImhH6wAO0XFKRisjj85ZVFS3Q1ohDmk+6CTiO5uFB/Ul1Q/S2Ds5kxgQfcxIH/pYU2t323zQIGLLdO1qB6QJntGbskyXYn7dkO6V9BmPOQEVOLdyRlT05spGaFfT8VHmIah6Puypl9RaAtBe4Jl9VZbsOhpivuxZO7rCsYrdlkii4J1ze2npxg8rjYQpv4FY+JemSSloJ5h4GtwfkHDrg/mdXLdUGt7eMEp/Fjzh2XuyIMSgZTXTRCKBPDdsflYx8UEZLu305nVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpGZsHG5qbxkHDpiLauVHVn31epSRq+TWk0xlM8HJmQ=;
 b=IRI40sQr4w6fi+XHfXh4AQKqacAOBHX/cfjvjokIHQaAOyqGiVAhh0XEBVlpZ9EHnDmUl3N9/cJhxmU59J+gqgdDIsy8Qf47AUqWKDONISqCt1P5z1FAVfLXatAAatBG0b7VhnAInfcmvJeeBw2BZTRSg6bN6munhNudl1BO7FqORjvIDfXZ0GBsrhl2yRbYPbM9VLnxtQY5NXB7iy7o/eQkLMcPWmVDu1+M3xWtZurQ+XQKfFGLYVoHpwMdmEQpezMvuhWJaJ/x+5JrGdOlInK/+oIGIEcAh0jnH5gkLwEivFlBV35/f6lc/q/XRrSP7tOBw4Xn968Q4YJZt8tSpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpGZsHG5qbxkHDpiLauVHVn31epSRq+TWk0xlM8HJmQ=;
 b=sJgMoADu9erwt62Gg4sZknSKMICY2WGw38FPVrr87rkt3D72+JDzAQ2JwBZa6HySuDpBEjdODsLGYrS4OnoxekQ+bVyYv7+mEraUEvERCgpe+W7JwbejjovmPxE4Oj4XNtTsiTD0NOX2teFPziCuF0my3tr80xamQCaTxYJtEBea7z++FqGsNQPdQ3H9ADGnPSLJTBQMRPxLN4ZUsVaIE8uPN1fCmIXhgVWKxCsUU7eTKGvKH/joRLQrTS8MB2v/PcPVooKTFDT3hbqqxy0XU3K/ezV2Eq26Cl1Su2AfkQXRfl7VbUPFLNR6Jn0Ja+B44wHg4OYvTZ/PCNLGAw3dKA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 06:10:47 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 06:10:47 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXWGpNwXhSEOm/yUu2yThJsUjGQKsDErIAgAN3H5CAAWCHgIAAKVuQ
Date:   Mon, 7 Jun 2021 06:10:47 +0000
Message-ID: <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
In-Reply-To: <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.218.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8007ab0f-d28b-429c-2dc3-08d9297afe52
x-ms-traffictypediagnostic: PH0PR12MB5500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5500C596A086E73796C4B184DC389@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jwlDen7cxofLXqXGTerhYUVPuLc8Rel8vDojdcZnvuCHv/93PdFCkfJfV21ajQ8X4NAK9bvK7ZXOX9aq8POoxOF9WqG+BrQBQIR34s5a7737I9NBMl6MTlg1ujT0clDOcRobKhZoMUzJ3ToYwCFX46R/8X4GAyZh3BXCA9h5iwGwt+xGIBhlQ0+tIDDeZ0xM9JxnQCyuJDrE43btpRN684HvdDFMMrawMf/jV45FC7pKmc/G4gomTVuac/nAneEbsWvyxU/yLAwOr8ECDjBEOJWQERV1zTk6PSTroYk1PW9wtV3d8XOGLm/H/Q0PhODzxgkkx5itBmNKX+OsRDYSGnbFN8dD6ZjS3YRkKYhKgu9983VJQZ9/GiCMPfQZfWGNGOh5QtNRXYoE7p958wS5fIh9uS7014akIOTHcvo695kAEMYR3rlpgaegnbPv4JNQ5TCSWwpn3AQvEouVuTPIBHjr5R0P9uXCFXVPLTJmoxsWZd6qo1gFXXIQ3/VY+ze3gDv0hV9h1P97Kwf1EqWIgON807Us6SoP700wgWvkG5JqXVfDE9prLhtvbFfFNUMbFv4pY1T8napux5qZz2vB/JqrutTfKowXTJh8r63ASf66PrtGnHjPs3VU0NPsjn5dOlxLhdUlenWv+X+pM8qFRTeyrkdpLH3zXqwl1jpmv/ExWqS56V5ttS34lc9KQY+pAfzEBfxinNhujo1WdmkUIl1I9ui9b51cfWT/iAzIvaYG51QQ2WkdIXuXEl2M5cQyjxOmLOL1d6hichvIyJcXog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(4326008)(5660300002)(55016002)(54906003)(110136005)(52536014)(316002)(7696005)(2906002)(86362001)(83380400001)(71200400001)(966005)(9686003)(26005)(186003)(122000001)(33656002)(8676002)(66946007)(8936002)(478600001)(76116006)(66556008)(66476007)(64756008)(66446008)(38100700002)(6506007)(53546011)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OXdpTkRiM3BqOWJlYWt1S0ZsUjdoZ3Ywb3I1MXFDUUg2a05PdjNSOFQreVh3?=
 =?utf-8?B?MDg3aVRyclNNeWlWY0lzcS9QclBQZlZuZEcvWWJuV1VrZHhtazMyS2o4WXo3?=
 =?utf-8?B?ZURoV2NDdTVjUXpVTVZnQnpzTGl1d2NaUjRRZytXVHJPbTlUbmZ5am52S0sr?=
 =?utf-8?B?NHBJR2JVWS9VWGZvRjBJVmVyTHQyWUMxTU94bUdub0dqR2EvUlVrbUlhOHFU?=
 =?utf-8?B?bHYrTWhlRFZPZkY4dGR1WjVpTXpSMGtuMEVWdlJrdDhjMEtsdWxwWmdPNFNl?=
 =?utf-8?B?b2dSQXBKWm1EanBmOUVxNG5qcStwTS9vWGNHRkx2UXErQm5KYWtoSVhtQTVQ?=
 =?utf-8?B?RFU1NGdXeDVjQzJoemFja0ZXc1FONDVYeXF3cy9YTG5kWktmZUd5TERIamRM?=
 =?utf-8?B?dUtxMzE0QU1SZno1UTFMTjNFZVhMUGpoVjhnS2s5aHNlTGlaYTVMZlkybC9Z?=
 =?utf-8?B?aUtjWTcrMmE2WEE2WWpROC9vVm5vbGFGbzIyb1ZwNTBWYVVSS2ZmeC96cEF5?=
 =?utf-8?B?MktXN1ZjNy9hYmhpbzZNd3lnbGdJTEhKV21aS3RxUXdJMlRHOVVmUkdYM3li?=
 =?utf-8?B?b0tIMnVKMUdnZ3ZTTHRKcm9aRkxraFBpclRWbGV6NXRKQ2tTa3gySXZMMGJ4?=
 =?utf-8?B?Vkxiam4rc2V3R1B1QzA3TDdkanpKZ0drYUFMUDJRV3hKeVFScVFZZmZkRXpJ?=
 =?utf-8?B?RFdOeFU0VnM5djIvNXpvOUl2TXBRNG5WTHBCeHVFTHBDSEVVL1plTFFqMGxY?=
 =?utf-8?B?Rlg0YkVJMWNUUXBhYnI1UFJ6VlRjNlJNK3l1R1hCSnpzN1hzaVMzYnFRZVIw?=
 =?utf-8?B?WTRZYVAyaElNMjJUWHB5cVVDY2lLV2xTdjRFL29ETjk0eHNucHVXSkVtcXNJ?=
 =?utf-8?B?RTVqaXAyY21VRy9keFh2Y1U1V0RQQTVkZEVtNkVOb3NFOThwWGdIWEg0R0Uz?=
 =?utf-8?B?VFFEc0ViRkNnL1pYckJpd0ZFY0JsSXEyQ3J4MGhYcitYNHg1RjJvZVkyRGlt?=
 =?utf-8?B?VWhtZWxIcHVHNUc3bG5yeG1xaDVyRmZTc1VQUGcvejFCaURZMUxoRlcvOFZn?=
 =?utf-8?B?QldYYnJiRnFVT3MwOXhGY3NQeHVreHNLMTAvQWV4NGk2ODN2Q0YzR2ZOR1Av?=
 =?utf-8?B?QlFEYnN2Um0vajA1ZWZTYmFCa2pSTzBXdTRId2x5R1U5VWdiTEZFVTdieTkv?=
 =?utf-8?B?WmJFaHZRakR2a2NjSVJ6ZjFPTllCVzlVMXkyWWd3UU5wcnhKUUlSZVVicm1X?=
 =?utf-8?B?MVlUNklqZWhWazlEa1JmbzN5T05FUTA2MXF6eFcxYTVmSndwekx6NzhvQ3JN?=
 =?utf-8?B?R3EzZU9keHdPLzl3RlVGMGFCS1BYVDRFVGo0ZkhBVlBOa2NTUTRYTXlyWEhy?=
 =?utf-8?B?SnpyMy9xMnEvb3dzRDJvWkQ3N3dGcVJnWWF6WGVZOWFXUVIxaERMTW5VOEV2?=
 =?utf-8?B?bEs3TlVKdVl2MC9rQS9xaDRLNngyRzI5ZThPdUhxU3hZT2ZDZzZNQW5qK1J4?=
 =?utf-8?B?eEdqdWdSL1FMbGthOFgzSUlEbDZEc09jVC9BSUQ2K2VtUFBpQi82QkpNd2Zm?=
 =?utf-8?B?TXYwT05paWl0ZzBFekV6d2pMVWJqS2x3RGJpSHZOM0FIMW9GVG1QeFBpSlJT?=
 =?utf-8?B?U1NvbDRteXJCZ0ExemVEbmFKeDRZZndLZ283K2FSZEVrWTVjTnA2UGQvODdM?=
 =?utf-8?B?VWRXbVRaQnM3RCtCYStYWER0alFuL1NnWEorT0JXWmZEa1I2c0hGTGNrOW51?=
 =?utf-8?Q?fIHf0qEuGMI0Dblzyw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8007ab0f-d28b-429c-2dc3-08d9297afe52
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 06:10:47.7829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ycbj8IiN5R1eHvEgaXrN13Zb3Y8uTEOl8R2/fUA1SoS+LJ6pyENwRvgqG0KywMVfJOzNr+gg7uqLcu82I5nSqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBNb25kYXksIEp1bmUgNywgMjAyMSA5OjAxIEFNDQo+IA0KPiBPbiAyMDIxLzYvNiAxNToxMCwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEhpIFl1bnNoZW5nLA0KPiA+DQo+ID4+IEZyb206IFl1
bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBK
dW5lIDQsIDIwMjEgNzowNSBBTQ0KPiA+Pg0KPiA+PiBPbiAyMDIxLzYvMyAxOToxOSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+Pj4gQSB1c2VyIG9wdGlvbmFsbHkgcHJvdmlkZXMgdGhlIGV4dGVy
bmFsIGNvbnRyb2xsZXIgbnVtYmVyIHdoZW4gdXNlcg0KPiA+Pj4gd2FudHMgdG8gY3JlYXRlIGRl
dmxpbmsgcG9ydCBmb3IgdGhlIGV4dGVybmFsIGNvbnRyb2xsZXIuDQo+ID4+DQo+ID4+IEhpLCBQ
YXJhdg0KPiA+PiAgICBJIHdhcyBwbGFuaW5nIHRvIHVzZSBjb250cm9sbGVyIGlkIHRvIHNvbHZl
IHRoZSBkZXZsaW5rIGluc3RhbmNlDQo+ID4+IHJlcHJlc2VudGluZyBwcm9ibGVtIGZvciBtdWx0
aS1mdW5jdGlvbiB3aGljaCBzaGFyZXMgY29tbW9uIHJlc291cmNlDQo+ID4+IGluIHRoZSBzYW1l
IEFTSUMsIHNlZSBbMV0uDQo+ID4+DQo+ID4+IEl0IHNlZW1zIHRoZSBjb250cm9sbGVyIGlkIHVz
ZWQgaGVyZSBpcyB0byBkaWZmZXJlbnRpYXRlIHRoZSBmdW5jdGlvbg0KPiA+PiB1c2VkIGluIGRp
ZmZlcmVudCBob3N0Pw0KPiA+Pg0KPiA+IFRoYXTigJlzIGNvcnJlY3QuIENvbnRyb2xsZXIgaG9s
ZHMgb25lIG9yIG1vcmUgUENJIGZ1bmN0aW9ucyAoUEYsVkYsU0YpLg0KPiANCj4gSSBhbSBub3Qg
c3VyZSBJIHVuZGVyc3RhbmQgdGhlIGV4YWN0IHVzYWdlIG9mIGNvbnRyb2xsZXIgYW5kIHdoeSBj
b250cm9sbGVyIGlkDQo+IGlzIGluICJkZXZsaW5rX3BvcnRfKl9hdHRycyIuDQo+IA0KPiBMZXQn
cyBjb25zaWRlciBhIHNpbXBsaWZpZWQgY2FzZSB3aGVyZSB0aGVyZSBpcyB0d28gUEYoc3VwcG9z
aW5nIGJvdGggaGF2ZQ0KPiBWRiBlbmFibGVkKSwgYW5kIGVhY2ggUEYgaGFzIGRpZmZlcmVudCBj
b250cm9sbGVyIGFuZCBlYWNoIFBGIGNvcnJlc3BvbmRzIHRvDQo+IGEgZGlmZmVyZW50IHBoeXNp
Y2FsIHBvcnQoT3IgaXQgaXMgYWJvdXQgbXVsdGktaG9zdCBjYXNlIG11bHRpIFBGIG1heSBzaGFy
aW5nDQo+IHRoZSBzYW1lIHBoeXNpY2FsIHBvcnQ/KToNClR5cGljYWxseSBzaW5nbGUgaG9zdCB3
aXRoIHR3byBQRnMgaGF2ZSB0aGVpciBvd24gcGh5c2ljYWwgcG9ydHMuDQpNdWx0aS1ob3N0IHdp
dGggdHdvIFBGcywgb24gZWFjaCBob3N0IHRoZXkgc2hhcmUgcmVzcGVjdGl2ZSBwaHlzaWNhbCBw
b3J0cy4NCg0KU2luZ2xlIGhvc3Q6DQpQZjAucGh5c2ljYWxfcG9ydCA9IHAwDQpQZjEucGh5c2lj
YWxfcG9ydCA9IHAxLg0KDQpNdWx0aS1ob3N0ICh0d28pIGhvc3Qgc2V0dXANCkgxLnBmMC5waHlp
Y2FsX3BvcnQgPSBwMC4NCkgxLnBmMS5waHlpY2FsX3BvcnQgPSBwMS4NCkgyLnBmMC5waHlpY2Fs
X3BvcnQgPSBwMC4NCkgyLnBmMS5waHlpY2FsX3BvcnQgPSBwMS4NCg0KPiAxLiBJIHN1cHBvc2Ug
ZWFjaCBQRiBoYXMgaXQncyBkZXZsaW5rIGluc3RhbmNlIGZvciBtbHggY2FzZShJIHN1cHBvc2Ug
ZWFjaA0KPiAgICBWRiBjYW4gbm90IGhhdmUgaXQncyBvd24gZGV2bGluayBpbnN0YW5jZSBmb3Ig
VkYgc2hhcmVzIHRoZSBzYW1lIHBoeXNpY2FsDQo+ICAgIHBvcnQgd2l0aCBQRiwgcmlnaHQ/KS4N
ClZGIGFuZCBTRiBwb3J0cyBhcmUgb2YgZmxhdm91ciBWSVJUVUFMLg0KDQo+IDIuIGVhY2ggUEYn
cyBkZXZsaW5rIGluc3RhbmNlIGhhcyB0aHJlZSB0eXBlcyBvZiBwb3J0LCB3aGljaCBpcw0KPiAg
ICBGTEFWT1VSX1BIWVNJQ0FMLCBGTEFWT1VSX1BDSV9QRiBhbmQgRkxBVk9VUl9QQ0lfVkYoc3Vw
cG9zaW5nIEkNCj4gdW5kZXJzdGFuZA0KPiAgICBwb3J0IGZsYXZvdXIgY29ycmVjdGx5KS4NCj4g
DQpGTEFWT1VSX1BDSV97UEYsVkYsU0Z9IGJlbG9uZ3MgdG8gZXN3aXRjaCAocmVwcmVzZW50b3Ip
IHNpZGUgb24gc3dpdGNoZGV2IGRldmljZS4NCg0KPiBJZiBJIHVuZGVyc3RhbmQgYWJvdmUgY29y
cmVjdGx5LCBhbGwgcG9ydHMgaW4gdGhlIHNhbWUgZGV2bGluayBpbnN0YW5jZSBzaG91bGQNCj4g
aGF2ZSB0aGUgc2FtZSBjb250cm9sbGVyIGlkLCByaWdodD8gSWYgeWVzLCB3aHkgbm90IHB1dCB0
aGUgY29udHJvbGxlciBpZCBpbiB0aGUNCj4gZGV2bGluayBpbnN0YW5jZT8NCk5lZWQgbm90IGJl
LiBBbGwgUENJX3tQRixWRixTRn0gY2FuIGhhdmUgY29udHJvbGxlciBpZCBkaWZmZXJlbnQgZm9y
IGRpZmZlcmVudCBjb250cm9sbGVycy4NClVzdWFsbHkgZWFjaCBtdWx0aS1ob3N0IGlzIGEgZGlm
ZmVyZW50IGNvbnRyb2xsZXIuIA0KUmVmZXIgdG8gdGhpcyBkaWFncmFtIFsxXSBhbmQgZGV0YWls
ZWQgZGVzY3JpcHRpb24uDQoNCj4gDQo+ID4gSW4geW91ciBjYXNlIGlmIHRoZXJlIGlzIHNpbmds
ZSBkZXZsaW5rIGluc3RhbmNlIHJlcHJlc2VudGluZyBBU0lDLCBpdCBpcyBiZXR0ZXINCj4gdG8g
aGF2ZSBoZWFsdGggcmVwb3J0ZXJzIHVuZGVyIHRoaXMgc2luZ2xlIGluc3RhbmNlLg0KPiA+DQo+
ID4gRGV2bGluayBwYXJhbWV0ZXJzIGRvIG5vdCBzcGFuIG11bHRpcGxlIGRldmxpbmsgaW5zdGFu
Y2UuDQo+IA0KPiBZZXMsIHRoYXQgaXMgd2hhdCBJIHRyeSB0byBkbzogc2hhcmVkIHN0YXR1cy9w
YXJhbWV0ZXJzIGluIGRldmxpbmsgaW5zdGFuY2UsDQo+IHBoeXNpY2FsIHBvcnQgc3BlY2lmaWMg
c3RhdHVzL3BhcmFtZXRlcnMgaW4gZGV2bGluayBwb3J0IGluc3RhbmNlLg0KPiANCj4gPiBTbyBp
ZiB5b3UgbmVlZCB0byBjb250cm9sIGRldmxpbmsgaW5zdGFuY2UgcGFyYW1ldGVycyBvZiBlYWNo
IGZ1bmN0aW9uDQo+IGJ5aXRzZWxmLCB5b3UgbGlrZWx5IG5lZWQgZGV2bGluayBpbnN0YW5jZSBm
b3IgZWFjaC4NCj4gPiBBbmQgc3RpbGwgY29udGludWUgdG8gaGF2ZSBBU0lDIHdpZGUgaGVhbHRo
IHJlcG9ydGVycyB1bmRlciBzaW5nbGUgaW5zdGFuY2UNCj4gdGhhdCByZXByZXNlbnRzIHdob2xl
IEFTSUMuDQo+IA0KPiBJIGRvIG5vdCB0aGluayBlYWNoIGZ1bmN0aW9uIG5lZWQgYSBkZXZsaW5r
IGluc3RhbmNlIGlmIHRoZXJlIGlzIGEgZGV2bGluaw0KPiBpbnN0YW5jZSByZXByZXNlbnRpbmcg
YSB3aG9sZSBBU0lDLCB1c2luZyB0aGUgZGV2bGluayBwb3J0IGluc3RhbmNlIHRvDQo+IHJlcHJl
c2VudCB0aGUgZnVuY3Rpb24gc2VlbXMgZW5vdWdoPw0KJ2RldmxpbmsgcG9ydCBmdW5jdGlvbidz
IGlzIGVxdWl2YWxlbnQgb2YgaHlwZXJ2aXNvci9uaWN2aXNvciBlbnRpdHkgY29udHJvbGxlZCBi
eSB0aGUgbmV0d29yay9zeXNhZG1pbi4NCldoaWxlIGRldmxpbmsgaW5zdGFuY2Ugb2YgYSBnaXZl
biBQRixWRixTRiBpcyBtYW5hZ2VkIGJ5IHRoZSB1c2VyIG9mIHN1Y2ggZnVuY3Rpb24gaXRzZWxm
Lg0KRm9yIGV4YW1wbGUgd2hlbiBhIFZGIGlzIG1hcHBlZCB0byBhIFZNLCBkZXZsaW5rIGluc3Rh
bmNlIG9mIHRoaXMgVkYgcmVzaWRlcyBpbiB0aGUgVk0gbWFuYWdlZCBieSB0aGUgZ3Vlc3QgVk0u
DQoNCkJlZm9yZSB0aGlzIFZGIGlzIGdpdmVuIHRvIFZNLCB1c3VhbGx5IGh5cGVydmlzb3Ivbmlj
dmlzb3IgYWRtaW4gcHJvZ3JhbXMgdGhpcyBmdW5jdGlvbiAoc3VjaCBhcyBtYWMgYWRkcmVzcykg
ZXhwbGFpbmVkIGluIFszXS4NClNvIHRoYXQgYSBnaXZlbiBWTSBhbHdheXMgZ2V0cyB0aGUgc2Ft
ZSBtYWMgYWRkcmVzcyByZWdhcmRsZXNzIG9mIHdoaWNoIFZGIHthIG9yIGIpLg0KDQpbMV0gaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGlu
dXguZ2l0L3RyZWUvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGluay1wb3J0
LnJzdD9oPXY1LjEzLXJjNSNuNzINClsyXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9Eb2N1bWVudGF0aW9uL25l
dHdvcmtpbmcvZGV2bGluay9kZXZsaW5rLXBvcnQucnN0P2g9djUuMTMtcmM1I242MA0KWzNdIGh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xp
bnV4LmdpdC90cmVlL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9kZXZsaW5rL2RldmxpbmstcG9y
dC5yc3Q/aD12NS4xMy1yYzUjbjExMA0KDQo+IA0KPiA+DQo+ID4+IDEuIGh0dHBzOi8vbGttbC5v
cmcvbGttbC8yMDIxLzUvMzEvMjk2DQoNCg==
