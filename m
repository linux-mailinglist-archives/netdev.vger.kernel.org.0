Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B429EDEF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJ2OLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:11:00 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:43036
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgJ2OK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:10:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZ3e8Ma6B2Jtwb9P8C9pvF8S0jR+FPo6qzREIyGb+fC99VPI9+pkXK4VNVR6nnWAs02azHH0HWyCsRgaouLxVFne265x1pu480op0EhJJSWx9A0Z+xglECHTQezCFXnhrn2u7wliAUU5ElZklOlu3svVdAsc5gq54Ivdex+ozVSzTONvw+qmuoQt2ZMcozxIoNNyJtVQnbQ9J5Kt10NTvp8eB7hIijl89Ki6vTEP0YGfVTDVb+OgfrdZ1Q3xMVhd2TBtYhCh/VO+q63L9SXno+xSQwozLQPBuViC3ay2N7FVrth55o7ovmtuVbk1AJv+mVGX61xO03Gn3XCe1mtYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Yfjpz4+5vokPAIgJRoFbp+8WCukWH9iJZvr9NM6RvA=;
 b=dTelm0BnSA0DJUW+1W/URl94P71AhHVkTJzPcnndOSTsFRMeCsxNY7F693a6aoGFNPVLIKlM0pOFrFqJx653zCNkMQZPW/PAXmvgukScPeC90PVn4eRqzZHekIHKF0JXGtxSXKHV7PxjHirVTIgmmuJvdxRHshyxGIKyWo1ksH12qHgS23TrmJOLtFSl/TTnxdgixaUFP9NcU0AnkNtTWcxrU0RsJfXvdfG6ji15G2ldSKhIfmxmmFDf0XqUYvc/D6lVNvIy0GlDCc+Tvmmia8fMzgn0x9wlcu/dY3Ft438eYF/rLtmVCjWtqsvc3ZizYlixssj3VyQyVb2pN1lGVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Yfjpz4+5vokPAIgJRoFbp+8WCukWH9iJZvr9NM6RvA=;
 b=SQTH4uT+isJczDYgAr6POx/6HJOz0ED1V63IkCx0+jcAYGaa0mBEqPDByeFoihKphrH9mTR3G8v+uNo+D3ADrcY1+oMlCEhPmKLV4iLxW2bagmQ/6rYlFVNVEQm7dfHqxKubQ1VsmvpkBgXFbyNgmbog6FsOuljJqJ0DPOH1dzk=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1478.namprd10.prod.outlook.com
 (2603:10b6:903:2a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 29 Oct
 2020 14:10:55 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 14:10:55 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: arping stuck with ENOBUFS in 4.19.150
Thread-Topic: arping stuck with ENOBUFS in 4.19.150
Thread-Index: AQHWqIbAhm/w52lyHEuPPxU5ZaHMxKmp3kiAgABdAgCABG5JAA==
Date:   Thu, 29 Oct 2020 14:10:55 +0000
Message-ID: <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
         <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
         <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
In-Reply-To: <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c3150b8-a84f-4d18-7934-08d87c14739e
x-ms-traffictypediagnostic: CY4PR10MB1478:
x-microsoft-antispam-prvs: <CY4PR10MB1478305B01B8B6A6614795A9F4140@CY4PR10MB1478.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZi8ILJRhzIFMqsolLKLNUd/Xb3W5qKrKNKZvo0eDtCzwTc5KbHtoXDbkKDGDXW9hsL7ZrxrOt2yQMjbbdhsVTRfEXYl7r9gPPKk4jCqNHxM5Xype3aDWM9+FAsH4Xkb+ardaZ46wo0g2tSSSDqd2WI8EFIPx2vHNCDb0ikRB8lU/GPmksmNyX0Ttu1JsUt7z4aobvJd/gfTYOT7LTkDulWm5WG4QJlovWzXFWcA239tECExvk2RKgZ3TvLNDYJ0Rcnny37BaCM9aMZMjCRODqkcBCy9vh8DfPcdU5Gv/hlY6De/3EZl/s60VcKyVWE5XhrI1U/jmsYJ8u5LGl1scg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(6506007)(26005)(186003)(6486002)(53546011)(86362001)(64756008)(2906002)(478600001)(5660300002)(2616005)(71200400001)(8936002)(8676002)(4001150100001)(110136005)(66946007)(316002)(91956017)(83380400001)(66446008)(36756003)(6512007)(66556008)(76116006)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MskljI7e9RwdBXOWgyADjT1hRd7o/CJF/gmbrMPjMLCnHufKZeJYBU2WHyAHMoYQpUpebr4sWT0gTARcJlBRso64dnohWOtYcQl6OfcS+rGdZ9q70Ik7CmxR1wlALM/r5RMNcyNcFpbCMbSjW0gHOKbLcF2xk2jFe2qxbRcIg8TuhFirkSBdNwNwXC6evDSGy5dd5IX2TA1jPh//D81s1NwXcPrvxo8/lhk6EfgFdely8fdWzcYHkMmN58qqxjgFu+QH4WJntMo7gPnC/g+f7b+EW2ZRWODdCUypnp2cICdrtRZVpI5nQEmqYJshh0oh8pRVLLBqUv7PG2PeVCFokP3/2z5MnvQ2TCEYXEM+rUIZjB9lSiEjh/EeIf4D60yhkzYgmXZGRQIIYFtAQJ/SoFsBrOW/GmW2wu08Nk/i6LS+cTmHkO69ZyFb++BLKvB+JOlaQAbqKzvzWuP3aQH1MpC8i8mn9ZMe7BMfzBt6MOKJPsWjRKBsSpoBf/hzaV2p/EI4ym/x7XFX7eWs1W96+4D8go9BIHdMgsSQUr1XHRCQV3XMUG5Y+x2tvSU1lobn2Ao1z1WlQW63bmJo+us7KV/JddhodLPgB0NfYI8ektVf5+xLdzhdqjBcBUrkmcSPPjdHqn0ZKlrNv+6m9jDjRw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <910A1BF2DF630D48BE70015379AB5747@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3150b8-a84f-4d18-7934-08d87c14739e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2020 14:10:55.2961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kWlfjjoBj8aD51xPX6tahgJjsCclgZu/TNLDcFPbSxU7WbI2J5U0XRofqiClCSsVx4WzawRJEE+WeSLohruidw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T0ssIGJpc2VjdGluZyAod2FzIGEgYml0IG9mIGEgYm90aGVyIHNpbmNlIHdlIG1lcmdlIHVwc3Ry
ZWFtIHJlbGVhc2VzIGludG8gb3VyIHRyZWUsIGlzIHRoZXJlIGEgd2F5IHRvIGp1c3QgYmlzZWN0
IHRoYXQ/KQ0KDQpSZXN1bHQgd2FzIGNvbW1pdCAibmV0OiBzY2hfZ2VuZXJpYzogYXZpb2QgY29u
Y3VycmVudCByZXNldCBhbmQgZW5xdWV1ZSBvcCBmb3IgbG9ja2xlc3MgcWRpc2MiICAoNzQ5Y2Mw
YjBjN2YzZGNkZmU1ODQyZjk5OGMwMjc0ZTU0OTg3Mzg0ZikNCg0KUmV2ZXJ0aW5nIHRoYXQgY29t
bWl0IG9uIHRvcCBvZiBvdXIgdHJlZSBtYWRlIGl0IHdvcmsgYWdhaW4uIEhvdyB0byBmaXg/DQoN
CiBKb2NrZQ0KIA0KT24gTW9uLCAyMDIwLTEwLTI2IGF0IDEyOjMxIC0wNjAwLCBEYXZpZCBBaGVy
biB3cm90ZToNCj4gDQo+IE9uIDEwLzI2LzIwIDY6NTggQU0sIEpvYWtpbSBUamVybmx1bmQgd3Jv
dGU6DQo+ID4gUGluZyAgKG1heWJlIGl0IHNob3VsZCByZWFkICJhcnBpbmciIGluc3RlYWQgOikN
Cj4gPiANCj4gPiDCoEpvY2tlDQo+ID4gDQo+ID4gT24gVGh1LCAyMDIwLTEwLTIyIGF0IDE3OjE5
ICswMjAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiA+ID4gc3RyYWNlIGFycGluZyAtcSAt
YyAxIC1iIC1VICAtSSBldGgxIDAuMC4wLjANCj4gPiA+IC4uLg0KPiA+ID4gc2VuZHRvKDMsICJc
MFwxXDEwXDBcNlw0XDBcMVwwXDZcMjM0XHZcNiBcdlx2XHZcdlwzNzdcMzc3XDM3N1wzNzdcMzc3
XDM3N1wwXDBcMFwwIiwgMjgsIDAsIHtzYV9mYW1pbHk9QUZfUEFDS0VULCBwcm90bz0weDgwNiwg
aWY0LCBwa3R0eXBlPVBBQ0tFVF9IT1NULCBhZGRyKDYpPXsxLCBmZmZmZmZmZmZmZmZ9LA0KPiA+
ID4gMjApID0gLTEgRU5PQlVGUyAoTm8gYnVmZmVyIHNwYWNlIGF2YWlsYWJsZSkNCj4gPiA+IC4u
Li4NCj4gPiA+IGFuZCB0aGVuIGFycGluZyBsb29wcy4NCj4gPiA+IA0KPiA+ID4gaW4gNC4xOS4x
MjcgaXQgd2FzOg0KPiA+ID4gc2VuZHRvKDMsICJcMFwxXDEwXDBcNlw0XDBcMVwwXDZcMjM0XDVc
MjcxXDM2MlxuXDMyMlwyMTJFXDM3N1wzNzdcMzc3XDM3N1wzNzdcMzc3XDBcMFwwXDAiLCAyOCwg
MCwge+KAi3NhX2ZhbWlseT1BRl9QQUNLRVQsIHByb3RvPTB4ODA2LCBpZjQsIHBrdHR5cGU9UEFD
S0VUX0hPU1QsIGFkZHIoNik9e+KAizEsDQo+ID4gPiBmZmZmZmZmZmZmZmZ94oCLLCAyMCkgPSAy
OA0KPiA+ID4gDQo+ID4gPiBTZWVtcyBsaWtlIHNvbWV0aGluZyBoYXMgY2hhbmdlZCB0aGUgSVAg
YmVoYXZpb3VyIGJldHdlZW4gbm93IGFuZCB0aGVuID8NCj4gPiA+IGV0aDEgaXMgVVAgYnV0IG5v
dCBSVU5OSU5HIGFuZCBoYXMgYW4gSVAgYWRkcmVzcy4NCj4gPiA+IA0KPiA+ID4gwqBKb2NrZQ0K
PiA+IA0KPiANCj4gZG8gYSBnaXQgYmlzZWN0IGJldHdlZW4gdGhlIHJlbGVhc2VzIHRvIGZpbmQg
b3V0IHdoaWNoIGNvbW1pdCBpcyBjYXVzaW5nDQo+IHRoZSBjaGFuZ2UgaW4gYmVoYXZpb3IuDQoN
Cg==
