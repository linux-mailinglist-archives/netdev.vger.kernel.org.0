Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54947D417
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhLVPDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:03:07 -0500
Received: from mail-mw2nam12on2123.outbound.protection.outlook.com ([40.107.244.123]:18401
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237278AbhLVPDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 10:03:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvaZl2HqxoVH8MypZrfe56lTr944grAvFjfnfUo6L1Ay6UnJ0Fb9HrOWbRdhvmH/hFxOKlp2I889Dxg1mnnavmUtb5CrBGLTje0ByDTTwVf7wamJOfJ5E583CQjrUcILG+DM8PQW3+3U1ykxviNpnmZ/5r9U2FU4YW4Vvt9pfg4euYdfwzKDOfChPK3z3ENQl8gKjewBzRVrTfS2vru9DbFoC4+W/J0AWqY8wVGvwHvzTIfQ07PDUBNy6IhZ94L+VHlJnpQfVT61kgSLx+NrwTwh0UtSPRUui00Ndf/jCtdY1yWTWOsdrB+YsixKUb19ndrYkBMjwaLki7NrNG2UXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmO4oF3KScK9Uq0DPjgdqsUIt3R8kS3vu+l4T7YEkWw=;
 b=jlqSYBHDGuLvE7w3Kiw8IVBdyEP4j1FiVZ2d3d13/g+KRyf/6iYpeaL2ac1w/nm3jt3ACzk4XD50Y1YeBk3n8xc+E5mbZelcqxB9mL3gSHIXFaEc1ZHGTPsMNd45qkzqa2HA18/poIQb4lHwtGcXLnyRUqaHZQYsPQD2wUlvbEgzWVewHO+6H3vULzht1eswaIpHJPZ7tAIEFTZ1ydXbLfObTwYWRvPv+ihjY1g9PhSjms4AiPWBuxS0YhDzxzM45qfx46xrktldiN4IFS4cvdRinz2nLa8zqGlu3L9czG6mxGpdmrR/6rGwAAawPYhMXzs5YuvyYVmfezaReLWm5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmO4oF3KScK9Uq0DPjgdqsUIt3R8kS3vu+l4T7YEkWw=;
 b=TiO2MCSzKZKe1x3aRSacR7JRhOlHXuWA7QQsbO2+4ySKm6QOF9cXU1r2X/dIzUiBARk25ZAgkzUipy+Sp2N6BmVXgHxsOkV67FVIYZZhx4pKRtI5lxTxi251+rkjKkJGd0DB7F4N0KR3BO+68polvv0nib7IgEa+vAsa7Jkik4M=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MWHPR13MB0974.namprd13.prod.outlook.com (2603:10b6:300:15::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 22 Dec
 2021 15:02:59 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::288c:e4f1:334a:a08]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::288c:e4f1:334a:a08%3]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 15:02:59 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "pete.wl@alibaba-inc.com" <pete.wl@alibaba-inc.com>,
        "xiaoh.peixh@alibaba-inc.com" <xiaoh.peixh@alibaba-inc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "weipu.zy@alibaba-inc.com" <weipu.zy@alibaba-inc.com>,
        "wenan.mwa@alibaba-inc.com" <wenan.mwa@alibaba-inc.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
Subject: Re: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
Thread-Topic: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
Thread-Index: AQHX8PIF1uk7AUWrmE+w9HCnnE9qfaw6xHsAgAD2qICAAiHDgIAAyzeA
Date:   Wed, 22 Dec 2021 15:02:58 +0000
Message-ID: <b8c236d99fd0f4e08dd0ee12a81274bd643a7690.camel@hammerspace.com>
References: <1639490018-128451-1-git-send-email-cuibixuan@linux.alibaba.com>
         <1639490018-128451-2-git-send-email-cuibixuan@linux.alibaba.com>
         <c5c17989-4c1e-35d2-5a75-a27e58cf6673@linux.alibaba.com>
         <c5d8fa4cfe87800afe588c4c3d54cd3178e04b47.camel@hammerspace.com>
         <efbf73f3-c6cd-90f6-ef22-bde14be708cc@linux.alibaba.com>
In-Reply-To: <efbf73f3-c6cd-90f6-ef22-bde14be708cc@linux.alibaba.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cba6572-2885-4809-8971-08d9c55c2499
x-ms-traffictypediagnostic: MWHPR13MB0974:EE_
x-microsoft-antispam-prvs: <MWHPR13MB0974CC53B8605A1F96E22089B87D9@MWHPR13MB0974.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ybde6H9r6OsKZRSiRpyIjO7ek7E8yH3slhjK1Ic+Zp7HJo7jUstqoiuIj5D9mWZBnN2tLGmBw0C+R+IoxDSpcL270ggTTmU0y9I4uG3lWFTq1NRhzl6pq3R0KIPFVA8Y3paIiXisdHueLiPyQIw1jM32BIahYYbiEkEwAd+3IKHTtTE/GfEud6vvpsRFTr+smC3g5hNscUdnWd6W+i/doWq7M+HpGduVD9XHe1bZC1XuwqM52AdyRlFix3wvUMMpub270STRHQPYDBil7XAcmJDlb8Dbny39oBJYBqWDRBVgC/Sg0CBkxp9U5VWtxRtFabgBU/E9B7HtNqPqhba/0MnqgPAXWLYS+ZqVHms0P+UOJYO516y3afjQQdN8RR6M46DtAnz23ctPGLxLe4inxVOs6JDs0xhLdK+DLEFg87n4M6l+l3E6vY58f4qw4U5ZJJ6T95u73q9BS1JydyV9P/QjfqfMwmy2GFp/D7daeKCAg1LQAhrfQacQMUeUfge2OoOLXVzAkt9RXc7147RWuUpcWdiPcdlrND7mjvVxpp0XYshVR2b3yLAzDmsXy1AHD4hKp4JwGRaAQhJSCLvHzLuHMM75JOmkIMzLElit1livSMz66oZS17kw8jdxrxy12yPSbdfOhXJPAW0FBR9+1SkHi7gi69MTJ0Mft21hphrEUL9Em5mK0BNQGxgeJCR/6ErwyBReC+DwAUCADsKVkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(376002)(39830400003)(346002)(396003)(26005)(6512007)(86362001)(2616005)(186003)(38070700005)(83380400001)(122000001)(110136005)(54906003)(316002)(38100700002)(66446008)(8936002)(36756003)(66476007)(8676002)(64756008)(66556008)(4326008)(5660300002)(7416002)(2906002)(66946007)(76116006)(4001150100001)(6506007)(6486002)(508600001)(71200400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFNqRy9WeFlxYkZpNm42L3kzZXlHUmp3UVBUUE56cXZwT3hBaVFFWGx5Q3k5?=
 =?utf-8?B?YkhTblptcko2K3gzTC9DZU9qSW5MUnpXbURrM3FZL3d0eDZ2UC9WT2tUUjk5?=
 =?utf-8?B?YVlCWDJLejhTNUZvNXNwY2pCRldLeXl1bVNZUTVCZEx4UE4rd2dKOEU0ZGtT?=
 =?utf-8?B?SVpFZk9SeWlYSTh6eHhqVjlNc2oxZWlWdWVqL1VEb3MvTWx2ckJaajNENXkr?=
 =?utf-8?B?MjhPeWdxRDh3R0dVK0hTK3BCTVhkUERJMk1wbnZ2eUQ2R25CZUdSeitmVTRa?=
 =?utf-8?B?ODFMbmM4anR5M3VyUVQzWGwrTW9UelJVMEVrcHU1VFZZL0VzdDJ1ZFZiUHZT?=
 =?utf-8?B?ZFpmSDNxSjJkSlZ3cEdoc1Q0RVFYU1lGUlFoVHZ6d2t1dGtjTnE2dVRKcVBS?=
 =?utf-8?B?bHNnRHNmbmtRNndDcmxDU0NsN0dsTlpMTk5YUVM0NEhrWFZLOXpxRXZYdXEv?=
 =?utf-8?B?aEdCWnVha1lnclA1YnUzK1RUSFpoMzc0bnR4anhwOGRvamtpa3ZuTzFZSnUr?=
 =?utf-8?B?MEkyQllTalNsUzY3NEFyN2g4OHVGeTQzWGMxVkZPeVVpNFhKckd1N3hCcW5X?=
 =?utf-8?B?S3FYdGlZRFBPUHJCalpYMkRHS2RXSmNLdXJJTkRnNzFrdW95R090NXltVVVu?=
 =?utf-8?B?WFA5ZDdrYWRvMlBYeXNRci8rSVFyOWp3RVBZcmZKNUJMOUNJVkdkbHFiU3d1?=
 =?utf-8?B?YW03aUdFOUhHNHZZOXI5UnVsSGQxaGhqc1lMQWJUanhTNml2YVlqWVRLZmhh?=
 =?utf-8?B?dk1mUXdpYVNQTG14VXJXMVduRTc1dUd2ek11Wm90bEhRSC9iKzBZU1JBbDhM?=
 =?utf-8?B?RHo1TlA4SWxQaERNY05OejYyQWlQRDNuckdUS0M1NGJtTWhqcW9nbVRNUmd6?=
 =?utf-8?B?Sm5DWENCUG9EZ3AvVjR2NURyRDhhdzNmQ0VvRGl1SjRQZUxGR0lTZSsrcHNq?=
 =?utf-8?B?SFVTeGJ6TERlT0dKbzBDT284eVJ6MmdtRDBMR3JkUFVJWFpCT3hRQWl6Vjlq?=
 =?utf-8?B?cGpqcElBZFY5WDRDM3MrQ1dXV25MaVp5ZGlwdlBxM2dSTGhqeUIrbFY1SU91?=
 =?utf-8?B?VlNqa3E5UTJpZktqSjF2NnAxY3VpMCtxVjVGdjFZdG5FQUhTTjdJN2swYVlS?=
 =?utf-8?B?bkpNdngvVUpwNW1YYm1FZmtSRjdacVJMQ1MrN2xRdThKRUU4L1p1dk9QZ1Vr?=
 =?utf-8?B?dVliYzkyOUdzWDBLMFQzeEVGTUtoejdTc0Z4b2hibnZOS2lZMjAxdmRZcW1p?=
 =?utf-8?B?OG1PRmZlSU91bWN4aGZ5WHNUODdUUk4wU1pQejVQWllkVE85MXNLQnlhQ05U?=
 =?utf-8?B?MVA0cUdzZlBPTEpYekliQ1RPcTF3SkNVcjVrSnRmdzlodWVrR0d5S2w3dzdo?=
 =?utf-8?B?OFBiZjBmeEozR1VVcFQ4WW9yMGlzRStYcjBqTTVsVlFLMmpsbzdXYWpqeDZX?=
 =?utf-8?B?L3JtR2FmRFhudEUyVlFqSHNvanpXbGpBRkYxR0N0NzNoVWthZk9tUTZNYVJC?=
 =?utf-8?B?M0xwZnBFSjlPUkpPRE9Pb1BNZDFXQXd1U2F1Wk5BRHlsdGpkL3JWUFpTVDZL?=
 =?utf-8?B?OEwwY3hjbWNOUjN1SVZUSEQ2bnowOWRzL2pCeTd3WVFybldtK3JvSkx6cUlP?=
 =?utf-8?B?R1NhdjBNRDhzZVRNL1JCblg5ZXk3ckJDamN2SlpZdHFIOW1nWC8zQzloOG80?=
 =?utf-8?B?ZVBsdWh3dmJXMEJjTS9tZ04ySklac2pjcWJrYU5ZR0ZialRTQnhkYVdKM3g4?=
 =?utf-8?B?ZURVcEVhcGZaS0srMnI0a2wxNnZ6aDNDYlh3cUhtNWRJTGZoSkdzZ2l4dDJ2?=
 =?utf-8?B?NGFEdnJra3FSZmcwMlRYelFQRDY2blBJQXZ5cVg2cTJIdkM2RVNmZFcvNlUy?=
 =?utf-8?B?YVZaY2F0aTdNeWlFanZNV1dHTUxEY0dDMzM1eG1qbDI5QlNSNitoYXQrSHlJ?=
 =?utf-8?B?bDg4WjN2ZUwzcGVYdHgzZU1TYTRQRUVSdDJ4Uzh6dm9BZXIrdDN2MUFHUFVs?=
 =?utf-8?B?bTRUVmNMK1dSOUJNS3YyLzlOT3VHWkRKdHJEN3JDRktRcmpFSENaaVlLZHhD?=
 =?utf-8?B?MzRvT253ZkpBeUFJRHF4QlpWY25LVmFEajdGQnZFZHlTc2FWZzBtd0x0MmJ4?=
 =?utf-8?B?dlZFdXVzUUpnZmZaL3V0OStCTW1BQkZoZGl4aFlUMWZiWElTWStldnEwTEtt?=
 =?utf-8?Q?wS3S6C8Gp0lqiaDfJrTStPU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E952C34CBA9FC4A9C7970F5E2D629D3@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cba6572-2885-4809-8971-08d9c55c2499
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 15:02:58.8413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5yIjzhdaq4N1dr3A+IahSiZ94qNskJ8vG4TrX0WOzSSy5pgox02VbKKg36ofSJwGxobMKYFLoz9PK2nwmhaOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB0974
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTIyIGF0IDEwOjU1ICswODAwLCBCaXh1YW4gQ3VpIHdyb3RlOg0KPiAN
Cj4g5ZyoIDIwMjEvMTIvMjEg5LiK5Y2IMjoyMiwgVHJvbmQgTXlrbGVidXN0IOWGmemBkzoNCj4g
wqANCj4gPiBPbiBNb24sIDIwMjEtMTItMjAgYXQgMTE6MzkgKzA4MDAsIEJpeHVhbiBDdWkgd3Jv
dGU6DQo+ID4gwqANCj4gPiA+IHBpbmd+DQo+ID4gPiANCj4gPiA+IOWcqCAyMDIxLzEyLzE0IOS4
i+WNiDk6NTMsIEJpeHVhbiBDdWkg5YaZ6YGTOg0KPiA+ID4gwqANCj4gPiA+ID4gV2hlbiB0aGUg
dmFsdWVzIG9mIHRjcF9tYXhfc2xvdF90YWJsZV9lbnRyaWVzIGFuZA0KPiA+ID4gPiBzdW5ycGMu
dGNwX3Nsb3RfdGFibGVfZW50cmllcyBhcmUgbG93ZXIgdGhhbiB0aGUgbnVtYmVyIG9mIHJwYw0K
PiA+ID4gPiB0YXNrcywNCj4gPiA+ID4geHBydF9keW5hbWljX2FsbG9jX3Nsb3QoKSBpbiB4cHJ0
X2FsbG9jX3Nsb3QoKSB3aWxsIHJldHVybiAtDQo+ID4gPiA+IEVBR0FJTiwNCj4gPiA+ID4gYW5k
DQo+ID4gPiA+IHRoZW4gc2V0IHhwcnQtPnN0YXRlIHRvIFhQUlRfQ09OR0VTVEVEOg0KPiA+ID4g
PiDCoMKgIHhwcnRfcmV0cnlfcmVzZXJ2ZQ0KPiA+ID4gPiDCoMKgwqDCoCAtPnhwcnRfZG9fcmVz
ZXJ2ZQ0KPiA+ID4gPiDCoMKgwqDCoMKgwqAgLT54cHJ0X2FsbG9jX3Nsb3QNCj4gPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoCAtPnhwcnRfZHluYW1pY19hbGxvY19zbG90IC8vIHJldHVybiAtRUFHQUlO
IGFuZCB0YXNrLQ0KPiA+ID4gPiDCoA0KPiA+ID4gPiA+IHRrX3Jxc3RwIGlzIE5VTEwNCj4gPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgLT54cHJ0X2FkZF9iYWNrbG9nIC8vIHNldF9iaXQoWFBS
VF9DT05HRVNURUQsICZ4cHJ0LQ0KPiA+ID4gPiDCoA0KPiA+ID4gPiA+IHN0YXRlKTsNCj4gPiA+
ID4gV2hlbiBycGMgdGFzayBpcyBraWxsZWQsIFhQUlRfQ09OR0VTVEVEIGJpdCBvZiB4cHJ0LT5z
dGF0ZSB3aWxsDQo+ID4gPiA+IG5vdA0KPiA+ID4gPiBiZQ0KPiA+ID4gPiBjbGVhbmVkIHVwIGFu
ZCBuZnMgaGFuZ3M6DQo+ID4gPiA+IMKgwqAgcnBjX2V4aXRfdGFzaw0KPiA+ID4gPiDCoMKgwqDC
oCAtPnhwcnRfcmVsZWFzZSAvLyBpZiAocmVxID09IE5VTEwpIGlzIHRydWUsIHRoZW4NCj4gPiA+
ID4gWFBSVF9DT05HRVNURUQNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIC8vIGJpdCBub3QgY2xlYW4NCj4gPiA+ID4gDQo+ID4gPiA+IEFkZCB4cHJ0X3dha2Vf
dXBfYmFja2xvZyh4cHJ0KSB0byBjbGVhbiBYUFJUX0NPTkdFU1RFRCBiaXQgaW4NCj4gPiA+ID4g
eHBydF9yZWxlYXNlKCkuDQo+ID4gSSdtIG5vdCBzZWVpbmcgaG93IHRoaXMgZXhwbGFuYXRpb24g
bWFrZXMgc2Vuc2UuIElmIHRoZSB0YXNrDQo+ID4gZG9lc24ndA0KPiA+IGhvbGQgYSBzbG90LCB0
aGVuIGZyZWVpbmcgdGhhdCB0YXNrIGlzbid0IGdvaW5nIHRvIGNsZWFyIHRoZQ0KPiA+IGNvbmdl
c3Rpb24NCj4gPiBjYXVzZWQgYnkgYWxsIHRoZSBzbG90cyBiZWluZyBpbiB1c2UuDQo+IEhp77yM
DQo+IElmIHRoZSBycGMgdGFzayBpcyBmcmVlLCBjYWxsIHhwcnRfcmVsZWFzZSgpIDoNCj4gdm9p
ZCB4cHJ0X3JlbGVhc2Uoc3RydWN0IHJwY190YXNrICp0YXNrKQ0KPiDCoHsNCj4gwqDCoMKgwqDC
oCBpZiAocmVxID09IE5VTEwpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAodGFzay0+dGtfY2xpZW50KSB7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhwcnQgPSB0YXNrLT50a194cHJ0Ow0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB4cHJ0X3JlbGVhc2Vfd3Jp
dGUoeHBydCwgdGFzayk7IC8vIDEuDQo+IHJlbGVhc2UgeHBydA0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm47DQo+IMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+IMKgwqDCoMKgwqAgLi4uLg0KPiDC
oMKgwqDCoMKgIGlmIChsaWtlbHkoIWJjX3ByZWFsbG9jKHJlcSkpKQ0KPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhwcnQtPm9wcy0+ZnJlZV9zbG90KHhwcnQsIHJlcSk7IC8v
IDIuIHJlbGVhc2Ugc2xvdA0KPiBhbmQgY2FsbCB4cHJ0X3dha2VfdXBfYmFja2xvZyh4cHJ0LCBy
ZXEpIHRvIHdha2V1cCBuZXh0IHRhc2soY2xlYXINCj4gWFBSVF9DT05HRVNURUQgYml0IGlmIG5l
eHQgaXMgTlVMTCkgaW4geHBydF9mcmVlX3Nsb3QoKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqAgZWxz
ZQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhwcnRfZnJlZV9iY19yZXF1
ZXN0KHJlcSk7DQo+IMKgfQ0KPiDCoEkgbWVhbiB0aGF0IGluIHN0ZXAgMSwgeHBydCB3YXMgb25s
eSByZWxlYXNlZCwgYnV0DQo+IHhwcnRfd2FrZV91cF9iYWNrbG9nIHdhcyBub3QgY2FsbGVkIChJ
IGRvbuKAmXQga25vdyBpZiBpdCBpcyBuZWNlc3NhcnksDQo+IGJ1dCB4cHJ0LT5zdGF0ZSBtYXkg
c3RpbGwgYmUgWFBSVF9DT05HRVNURUQpLCB3aGljaCBjYXVzZXMgeHBydCB0bw0KPiBob2xkIHVw
LiBJIHRoaW5rIGl0IGhhcHBlbnMgd2hlbiB0aGUgdGFzayB0aGF0IGRvZXMgbm90IGhvbGQgYSBz
bG90DQo+IGlzIHRoZSBsYXN0IHJlbGVhc2VkIHRhc2vvvIx4cHJ0X3dha2VfdXBfYmFja2xvZyhj
bGVhciBYUFJUX0NPTkdFU1RFRCkNCj4gd2lsbCBub3QgYmUgZXhlY3V0ZWQuIDotKQ0KPiBUaGFu
a3PvvIwNCj4gQml4dWFuIEN1aQ0KPiANCj4gwqANCg0KTXkgcG9pbnQgaXMgdGhhdCBpbiB0aGF0
IGNhc2UgMSwgdGhlcmUgaXMgbm8gc2xvdCB0byBmcmVlLCBzbyB0aGVyZSBpcw0Kbm8gY2hhbmdl
IHRvIHRoZSBjb25nZXN0aW9uIHN0YXRlLg0KDQpJT1c6IHlvdXIgcGF0Y2ggaXMgaW5jb3JyZWN0
IGJlY2F1c2UgaXQgaXMgdHJ5aW5nIHRvIGFzc2lnbiBhIHNsb3QgaW4gYQ0KY2FzZSB3aGVyZSB0
aGVyZSBpcyBubyBzbG90IHRvIGFzc2lnbi4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4
IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1t
ZXJzcGFjZS5jb20NCg0KDQo=
