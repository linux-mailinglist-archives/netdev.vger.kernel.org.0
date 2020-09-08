Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A495261C7B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbgIHTUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:20:49 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2124 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731116AbgIHQCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:02:13 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f578de80000>; Tue, 08 Sep 2020 06:58:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 06:58:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 08 Sep 2020 06:58:14 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 13:58:13 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Sep 2020 13:58:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iw43f52kXmxUnaI2ZMrJRkS+iieooRlT626D30r9b+ba3f+gT4jqH4v1Zs45Zn7zMwRc7YqvrFemROlB8V7+3lenfeyvClLuIGN3ZGPJGql/jx8Q3VkXmka+VP2Hq5JoP3NRc7v50A6xfujmkzYaduOau5fauUmlj9kXhhZ7gjZj3JytX2SmaQDWmlImtxJKQSV+c+gWRAhPCszNK7nmgfmkZOmv8R+LCm+GWgi01YqPIgE2qWFb/joRp56jl9vAIq3dxKZeHvpYrIH+tZIpUcoJvEyVL8y5kgWLbq5O7o7aTHt5GxX8wf5/bsEidsGnVdKzJAQifNoCfCOZutOuvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLzBN1ajQpu8CRZ40l6wBiMZimftuyydyrJe+t0zdf4=;
 b=jU0RRILA0f/HXYvzt+Jk/7T+F5CuZx3Q0R0Wx3wvnMoItqvut2KZ8QhQ9sp2qaRp/esFvD3GdKRE+uoN8UoEnKG6595c2QG9ArStgEZS/rxp7z2GuPS+mg3arMHIAYOGShIKigWL+kNptDg5pEUsth+OyZESlgrqaQP9NrG2uLM6OmjyD/DTWO/B7gk7rTpxnv9ZtOdODg26b4FnWDx9+WSRDyw2worMKzEFRrtr35R8Pe4toNNmnhv1TSqrQQx5hExCkT5LO5UnNWGpUgHCMtN4b+0Ua1o5ElndLUjzVvmiSgKbL9HELsM7Yf+uBQ0Aty5yDlM2xQU/oce1v+TzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB3413.namprd12.prod.outlook.com (2603:10b6:a03:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 13:58:12 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 13:58:12 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC 7/7] bridge: cfm: Bridge port remove.
Thread-Topic: [PATCH RFC 7/7] bridge: cfm: Bridge port remove.
Thread-Index: AQHWgpyHLaENKv4yb0qBy3Zff1l+PqleyvOA
Date:   Tue, 8 Sep 2020 13:58:12 +0000
Message-ID: <d84df90ff3fd079ba0fec33f865ce4a257ab23d8.camel@nvidia.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904091527.669109-8-henrik.bjoernlund@microchip.com>
In-Reply-To: <20200904091527.669109-8-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0731d73-67c2-4a45-ba93-08d853ff39d5
x-ms-traffictypediagnostic: BYAPR12MB3413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB341342B2271A5796612B8318DF290@BYAPR12MB3413.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lbTrtC0B5yWjBqAXiiLb9nWfpHTpzU7jsDhP3pK84f5AWNTP0YuQwKag8K3ZSVjav2AsPXMlai8m0+1YxDJnKBF/YQEmgifWhslNVcb4kMcSiRXKNhoijZ8TDiPwwyaj2Bo+2qCqD4mKhyuIVQPvRbdBtFYT1+0EK7xdkwN+t99tg7aLZr7yYfuaIyG9LhXLyxh4mLxkl7y4R+cXCFPxCNHrw2dVCrzetqbFlMg8xpDZjSbSiuv0+lOIDKrNuIr7XRY7+FAYgJQ30uXNGYTbkChWXeGAVRAOAVTAHCLS8ac4j9aTT7pzGBDcOkiC87uDiovSSMDXMZaStlaSj8/XdKHgirGsWKoUs5Zgj4SNB8QJagkNzgL3cz2Sv85wHw08
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(76116006)(91956017)(66946007)(66476007)(64756008)(8936002)(66556008)(66446008)(2616005)(83380400001)(71200400001)(5660300002)(316002)(36756003)(6506007)(186003)(26005)(3450700001)(2906002)(6512007)(6486002)(4326008)(8676002)(110136005)(86362001)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MWCA+xiZMRGjANL9RqFAxyjmTvQRt+uG+KlpgaLgAk2MZ4gxXJF0gLnoeBfiQ8+3V6pAqpQeIK+zPPHNTCJW4zs2UxefFBIZNkJX6EdIyqYgMHa3cJBC3a2osfv3NTBE0NWDyH91/edGGOQMgrr0OTcSEvQi/6MxTDE0a+uLHRPx2yIIjjTIQY2cendW45qQB1Hq+kZQtm03GJH+pAalhW6zoI9kOE67EdG+zN0jSl5c436RQJ5PO5nUaVb3i8LesGkFORNEiRbVno/2acH3u96ZzlWCPS0TPl9RylBnOvJJGD+gv3d9Di0uviXId50paZdIdZdNwyTAhsmhQYYOiNllEXxof8AB2E1vBeghiB+RDqKy9Kr4w8HhlpRV3oRb3BvRjOOFhrGsaR22Rq4yolpxb2ri5uEXTE1LlYmVrU5qwfeHOOqthsWKFHYV35xslw2tMIvPW31alD/lmFbVRRU7CgT9WxhD1JLvibcVJrOyAX3hYWe87VFmJdfUf3tsStzzkFHDTHuQvQnA/2JjfDqntrZI+0UYz4l2+i+dIHBPn0ycGfeya4B5sFdqYPvphQAKFfF3+3Il2sMgmM23H7y5fd9AEa0qa6cAOPzWDcfgG3u6HDcINZz9kXZOxQ8teB+j4ejaepbNHjjqMl+8BA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E0AA0620E8AF14E836B7E8218D64754@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0731d73-67c2-4a45-ba93-08d853ff39d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 13:58:12.3420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HCHX7+yUyoO3ZrcOF7U8PIpP0UAuI5OhEuOF7RHan1ECWJDpzFGNJqz+OtKREacqgzYd5RO59lMKChNWpGfA/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3413
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599573480; bh=eLzBN1ajQpu8CRZ40l6wBiMZimftuyydyrJe+t0zdf4=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=gZSadcJRjXPgt1veyUEF79LSTy9fkzmwDLuwd6xYiw7UvAda+ctXmVVWmU2SseRlm
         UOMoRzX5BlWt/mxz94jhaEdDDwUHPw61I0YOtJ6oAjhbZz1Eb2oql8MYVe8c/3cA33
         N19KksfsUtJxISt1BQwBcdbhO+GhoEpkigVrNfjH9Q0Sr6n2IS8JCoV/hCIJcVUY31
         ETiGdH6uA9ISzuGAO/JYkbldqjm8hxfE0CUdj5EIHlIqJNM3YhOM14gJtn5ukM1Y4K
         ybI6868ft1dGAXVkiSU3mvNqCWcYNZl5+Nkv0mtGR6lctxkGN4doyNyQCCISQvxkTZ
         5VhJQPYY2jqMw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTA0IGF0IDA5OjE1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyBhZGRpdGlvbiBvZiBDRk0gZnVuY3Rpb25hbGl0eSB0byBkZWxldGUgTUVQ
IGluc3RhbmNlcw0KPiBvbiBhIHBvcnQgdGhhdCBpcyByZW1vdmVkIGZyb20gdGhlIGJyaWRnZS4N
Cj4gQSBNRVAgY2FuIG9ubHkgZXhpc3Qgb24gYSBwb3J0IHRoYXQgaXMgcmVsYXRlZCB0byBhIGJy
aWRnZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVucmlrLmJq
b2Vybmx1bmRAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2NmbS5jICAg
ICB8IDEzICsrKysrKysrKysrKysNCj4gIG5ldC9icmlkZ2UvYnJfaWYuYyAgICAgIHwgIDEgKw0K
PiAgbmV0L2JyaWRnZS9icl9wcml2YXRlLmggfCAgNiArKysrKysNCj4gIDMgZmlsZXMgY2hhbmdl
ZCwgMjAgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfY2Zt
LmMgYi9uZXQvYnJpZGdlL2JyX2NmbS5jDQo+IGluZGV4IGI3ZmVkMmMxZDhlYy4uYzcyNGNlMDIw
Y2UzIDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX2NmbS5jDQo+ICsrKyBiL25ldC9icmlk
Z2UvYnJfY2ZtLmMNCj4gQEAgLTkyMSwzICs5MjEsMTYgQEAgYm9vbCBicl9jZm1fY3JlYXRlZChz
dHJ1Y3QgbmV0X2JyaWRnZSAqYnIpDQo+ICB7DQo+ICAJcmV0dXJuICFsaXN0X2VtcHR5KCZici0+
bWVwX2xpc3QpOw0KPiAgfQ0KPiArDQo+ICsvKiBEZWxldGVzIHRoZSBDRk0gaW5zdGFuY2VzIG9u
IGEgc3BlY2lmaWMgYnJpZGdlIHBvcnQNCj4gKyAqIG5vdGU6IGNhbGxlZCB1bmRlciBydG5sX2xv
Y2sNCj4gKyAqLw0KPiArdm9pZCBicl9jZm1fcG9ydF9kZWwoc3RydWN0IG5ldF9icmlkZ2UgKmJy
LCBzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwb3J0KQ0KPiArew0KPiArCXN0cnVjdCBicl9jZm1f
bWVwICptZXA7DQo+ICsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3JjdShtZXAsICZici0+bWVw
X2xpc3QsIGhlYWQsDQo+ICsJCQkJbG9ja2RlcF9ydG5sX2lzX2hlbGQoKSkNCg0KVXNlIHN0YW5k
YXJkL25vbi1yY3UgbGlzdCB0cmF2ZXJzaW5nLCBydG5sIGlzIGFscmVhZHkgaGVsZC4NCg0KPiAr
CQlpZiAobWVwLT5jcmVhdGUuaWZpbmRleCA9PSBwb3J0LT5kZXYtPmlmaW5kZXgpDQo+ICsJCQlt
ZXBfZGVsZXRlX2ltcGxlbWVudGF0aW9uKGJyLCBtZXApOw0KPiArfQ0KPiBkaWZmIC0tZ2l0IGEv
bmV0L2JyaWRnZS9icl9pZi5jIGIvbmV0L2JyaWRnZS9icl9pZi5jDQo+IGluZGV4IGEwZTlhNzkz
NzQxMi4uZjdkMmY0NzJhZTI0IDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX2lmLmMNCj4g
KysrIGIvbmV0L2JyaWRnZS9icl9pZi5jDQo+IEBAIC0zMzQsNiArMzM0LDcgQEAgc3RhdGljIHZv
aWQgZGVsX25icChzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwKQ0KPiAgCXNwaW5fdW5sb2NrX2Jo
KCZici0+bG9jayk7DQo+ICANCj4gIAlicl9tcnBfcG9ydF9kZWwoYnIsIHApOw0KPiArCWJyX2Nm
bV9wb3J0X2RlbChiciwgcCk7DQo+ICANCj4gIAlicl9pZmluZm9fbm90aWZ5KFJUTV9ERUxMSU5L
LCBOVUxMLCBwKTsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9icl9wcml2YXRlLmgg
Yi9uZXQvYnJpZGdlL2JyX3ByaXZhdGUuaA0KPiBpbmRleCA1M2JjYmRkMjFmMzQuLjU2MTcyNTVm
MGMwYyAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRnZS9icl9wcml2YXRlLmgNCj4gKysrIGIvbmV0
L2JyaWRnZS9icl9wcml2YXRlLmgNCj4gQEAgLTEzNjksNiArMTM2OSw3IEBAIGludCBicl9jZm1f
cGFyc2Uoc3RydWN0IG5ldF9icmlkZ2UgKmJyLCBzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwLA0K
PiAgCQkgc3RydWN0IG5sYXR0ciAqYXR0ciwgaW50IGNtZCwgc3RydWN0IG5ldGxpbmtfZXh0X2Fj
ayAqZXh0YWNrKTsNCj4gIGludCBicl9jZm1fcnhfZnJhbWVfcHJvY2VzcyhzdHJ1Y3QgbmV0X2Jy
aWRnZV9wb3J0ICpwLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4gIGJvb2wgYnJfY2ZtX2NyZWF0
ZWQoc3RydWN0IG5ldF9icmlkZ2UgKmJyKTsNCj4gK3ZvaWQgYnJfY2ZtX3BvcnRfZGVsKHN0cnVj
dCBuZXRfYnJpZGdlICpiciwgc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCk7DQo+ICBpbnQgYnJf
Y2ZtX2NvbmZpZ19maWxsX2luZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9icmlk
Z2UgKmJyKTsNCj4gIGludCBicl9jZm1fc3RhdHVzX2ZpbGxfaW5mbyhzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLA0KPiAgCQkJICAgIHN0cnVjdCBuZXRfYnJpZGdlICpiciwNCj4gQEAgLTEzOTMsNiArMTM5
NCwxMSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgYnJfY2ZtX2NyZWF0ZWQoc3RydWN0IG5ldF9icmlk
Z2UgKmJyKQ0KPiAgCXJldHVybiBmYWxzZTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGlubGluZSB2
b2lkIGJyX2NmbV9wb3J0X2RlbChzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsDQo+ICsJCQkJICAgc3Ry
dWN0IG5ldF9icmlkZ2VfcG9ydCAqcCkNCj4gK3sNCj4gK30NCj4gKw0KPiAgc3RhdGljIGlubGlu
ZSBpbnQgYnJfY2ZtX2NvbmZpZ19maWxsX2luZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0
IG5ldF9icmlkZ2UgKmJyKQ0KPiAgew0KPiAgCXJldHVybiAtRU9QTk9UU1VQUDsNCg0K
