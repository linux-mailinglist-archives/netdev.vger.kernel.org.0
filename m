Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8763E313F20
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhBHTfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:35:36 -0500
Received: from mail-eopbgr760092.outbound.protection.outlook.com ([40.107.76.92]:9952
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235512AbhBHTew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:34:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVX8IQLhPPY8/gW/9zUhPYZJi0p8YYCVfq287zcXeeBadxGJWDwQqh/eswZ/JYli+j13+iqZKXanRGb8z/V4680JklbAsotayFyRwKZCPPjPkv0/o+JN8UeC8ADE3IA8637XncpBC+7CP50Jpac1zlLTprTmqPfL1MVUdXDOGYY2R3snQKCNjv5DNcPPSujpfhgQNBSirnGqsL1xu3LQuYxUDL3RKXbfFOAGnQvoNMk2O7KtxfdkHxDb1rZDWko+l8PF6gxyh9g9hR5dYLEGQe1JPA74duI5O40Uj4ZyiPoWlL6F9c7pgzx6o9UeppYQY0Gnm1QM/U7TVGtK0oU1Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDR6XU1E8Q+LtNearK/ORzIAAZ4UjmYq4L/buxB2ir4=;
 b=f1NYdUWu4fYVWFWX47Bht/T3+V5WtL2ac/J1+HSFzZC7n1MrjpD1aCmZJjCRe4hXae6K5jss1mWEZ8GWIdULvtYBxLeWcQ1t0qwfRM1hni1DgCWEoHTiR5QgIyi3khAS4uz94o42kWdQElNxh37L5OrHb144T1KBWYkVSMXj2u3iC8Oi8tn5PJhaK0/Cdrm2gcX2yHDcYst8SI5XHkSgm220Q2Gop7ECTvHpSBgFLstSYghg2nHqy5zzwQcHigSxzngKckvm9J+kZ9jUldb+YE2gCwmr1l+/3TekumTXQyehbaDaLHCQbNvySzQM6sc/aXJZrNAsv+93pxZwj4algQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDR6XU1E8Q+LtNearK/ORzIAAZ4UjmYq4L/buxB2ir4=;
 b=HEdrzQs5gdJwJoKWDjWafLBHfADfl8jrhQidZ2W6+u9Nclz+1zSBcmoQsVYSX+ZWgrt5W+IhywD8LKH+sfE38xKtyWr3ZlCoSNayLpzXooMaCn/MdcL6+L58Vw3e9L/NZWNNLH95Xba2P0hZUT9xyzScRVLNrJwubGHHiEyUS08=
Received: from (2603:10b6:610:21::29) by
 CH0PR13MB4714.namprd13.prod.outlook.com (2603:10b6:610:c2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.13; Mon, 8 Feb 2021 19:34:02 +0000
Received: from CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063]) by CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063%3]) with mapi id 15.20.3846.025; Mon, 8 Feb 2021
 19:34:02 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "daire@dneg.com" <daire@dneg.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: Re: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Topic: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Index: AQHW7tQlUl/ijYkh5UeVw+yM/Wf1I6pOxQuA
Date:   Mon, 8 Feb 2021 19:34:02 +0000
Message-ID: <2c8a1cfc781b1687ace222a8d4699934f635c1e9.camel@hammerspace.com>
References: <20210120012602.769683-1-sashal@kernel.org>
         <20210120012602.769683-3-sashal@kernel.org>
In-Reply-To: <20210120012602.769683-3-sashal@kernel.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18723167-3726-4d86-5c37-08d8cc687d73
x-ms-traffictypediagnostic: CH0PR13MB4714:
x-microsoft-antispam-prvs: <CH0PR13MB47148731700AE4CAECB22BCDB88F9@CH0PR13MB4714.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FNyDcI/W0RIMf2Vo2RPNMgphXaL51OcpcdxDhgoc27qFXkXmKsOX+swM7tVIJeD6YUcsgoc6mboLr1lynyjFyy/ykikWX/RIsPsGgRbrb7s53QQr9EAj+4liOeh3QU4tHEjAEF2V+z4LL+Kls0QUo10hZcPqmmW0Dmm++iUMQgGcF2MTWNmebzFdvdX/KA4dsnQ54fHfbW+rMzZzc7AN8nl/T8z9DmLLYhlZvmCO3F7VD5kIWP1o0wPY/X7TfJ0kTfM/JVHvM9RGv4a2TWj2wW4CWMDEf/88xulnLISIM+NXlToNyX3DfZN9C1+JIF5KwGnbrGhlejivGQ8uSLJDu/pch4TtqyxsxM2d+MRUtyx4cfo/sKaoXo59D1WD1Bs/KvMB7r4T1lasaGfG18/icJq+ZSoKx25pBG7bNkGpWONlg6/yHVwsVBuxVy/r9konryxGTsBqEhtsKqLvc51hgdo5ZwmiX6eYp20e5PrZpyb7qunXqAlFHBHFh21W4dYO055B21GRYA18uYJEyJfia3t/remMcg2SEE6ONz45XoPx+9mfYnFEvY9e4jJZ9HZrEaEyzRVczUEkwVj36cczjYEKssogDlqjryem2I8Miiw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3525.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39830400003)(346002)(66556008)(66946007)(66446008)(66476007)(64756008)(478600001)(2906002)(6506007)(186003)(6512007)(71200400001)(26005)(6486002)(36756003)(83380400001)(8936002)(76116006)(966005)(86362001)(316002)(54906003)(110136005)(8676002)(5660300002)(4326008)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SnVuS0QrODhZTG9XYzJXdEE3QmJkTk45MW1BV2ZuYVhBT2J1WC9WRGtBd25H?=
 =?utf-8?B?QVJPbVhEQ0p1d3pXbjVuZFAzMXFXajFFUzgxUmR1cC9nR3d6N2xIWkwzaHho?=
 =?utf-8?B?TEFWUlZFaWhoUFYvZFhjcjkrdzlGS2hDZXJmK05rQWxMQ2VZak9velgrL2ZH?=
 =?utf-8?B?d1VpRXhvWDNBY2p6dXdpTDNLa3dtanVISC9Xa242eW5zdUpIOGdqM0xTK0du?=
 =?utf-8?B?K0ZUS05kbzI5UHdDMDdKWmZTcWh5TUhhaGV3bjFadFBSWExTVi83NzIrSGtF?=
 =?utf-8?B?RVgvU20vVUtVUXp4VzN2SGZLUWpKclpiT0d2VmQxN3ZLNU1aMFlqem1INk1o?=
 =?utf-8?B?Zzk1MWZEWmQwRWJUWTJubzNRMnpaaXZteDdqNDRxa2ZOTG1KMTRIbGVwY2JT?=
 =?utf-8?B?NGxrU2FuRDlUclRvRFVnN2F5MDJPV2E3Z1Y0bU9aZnptV0VvNExlUE9hRmY1?=
 =?utf-8?B?ZFNRWkVsRTdkZ0lyTXdvc0RnTlI1MkZ6cUpISWhQeFpsSUJUdHE0cXBQZDNV?=
 =?utf-8?B?ejFHVmF3TnBVR2h6Y01Xb3NoZXFlRmNjRm54SWx0bjJwc3hHaWJTVWdpUTJV?=
 =?utf-8?B?RU1OUCtZSjdXU3p1MVhtQy95K2dsZFYvcFpyc0dua291M1l0d3FlRzNzZGdX?=
 =?utf-8?B?TWNVdGZNTjBzcjhFdTJQdjViTDRsaDB0Y0x3NGNiczNsL2lQSmdvQ2NrTUJZ?=
 =?utf-8?B?Z1YvRS9vby9QOW1qWlZtWEFaVFhRUEVHYXdkL1Btb3M1VGpZb3h6UU5QdUtZ?=
 =?utf-8?B?Zy90RWhxR1BDS1RsVEdnbHdseUVNT1ZXZXlTQjFDY21tcVRRY1psTjhRTW1M?=
 =?utf-8?B?NFFUdmhBVTJsVndGZkttWSs5aE55c054ZWZkQk9HdmlsVDdDcjVmV0ZBeFpi?=
 =?utf-8?B?VUwvT1V5VWwwQ2JwQkFvT0ZlVm81ODIwb21iaGZ2a2dKMlpDZXkwZmU1RTRB?=
 =?utf-8?B?OFhFU0x4bjJ6azRFdENqbkhlcGNRWWliUEJVMDBCRHhES1RJNjJ2ZThXZUhL?=
 =?utf-8?B?dlFkakxrMVdxT0l0czQ0K3o0cWhmR21pT0lPcnd2Y2dBL2pHQXNQc3NYWVU1?=
 =?utf-8?B?ZUg3Y0NoNVdUZlRieWZDRDBaaTBrV0d5MElEc1A4V01KK3hiZFBEaFBXVytE?=
 =?utf-8?B?WnRvVWZwL1dickw0VmJhZFBPd3BadWpWWTcwL2VrKytWeUxJVlVwdVQrYU5U?=
 =?utf-8?B?OG9QVHlLUzA5MFExVXVkYVBoMnNLTS9QR3lZUlJ0U01yQ0g0MmtwRFJIMXdi?=
 =?utf-8?B?SEEwQVZoQWVrTTgwQU1uTC82T1VNUGQwL284RzFRN0xSQVhGZ3dtekliK3Nk?=
 =?utf-8?B?Zm5lK2lCNE5oSU9IUUNMdW5WV2F3N2R1SEwyYk16YlhybkFGbDQyVkNYRWVz?=
 =?utf-8?B?WmQ1bzJSaWkrVHZMMmJvT2c3U3k5RnorZ29QeTVWRFJuZDlyazRpdVROdHlF?=
 =?utf-8?B?c3FEbkVsYTFqdXp0WU9raFJnWVlPa2dLdDVjYzkzMVl6bURHOVNYU1JHeGxi?=
 =?utf-8?B?VU1aMGpFK1Z4SUg5WHhHeTBld3NOZW03M21aSVMxRmZsSVpEZE9mdTRBS1pr?=
 =?utf-8?B?STVLU0p1Qy9mdVVTSHZZV291bXUxWlZUb1FlMEQ1OG9ZT2tQdHZTd05EZzdj?=
 =?utf-8?B?K2pka1lMV1BIMlpYN3d5YTQzYlNJV01OVmxiYy9RaUorUGVYL1JOMjZLaEZw?=
 =?utf-8?B?QWtRTUF4UzREVksyM3Y2Z0FFWkhibkJTcU5WZzR4WUYzaUZ0OWFxRm92bmJa?=
 =?utf-8?Q?qcd8wm/yGp8T3dGUeIBWjWPfye+by1AfMQz9UXA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7A22A91AE0554428B953F4082FE2C85@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3525.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18723167-3726-4d86-5c37-08d8cc687d73
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 19:34:02.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SLy48jlCTqmHl/4yU3+SJoE2Cjmpe8BJkns2Lzq6JlpzJKSySBxkgI9WEZ2Rgh0vJAdVQQv8/nMgB99uMVZQyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4714
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTE5IGF0IDIwOjI1IC0wNTAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
RnJvbTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+IA0KPiBbIFVwc3Ry
ZWFtIGNvbW1pdCA0YTg1YTZhMzMyMGI0YTYyMjMxNWQyZTBlYTkxYTFkMmIwMTNiY2U0IF0NCj4g
DQo+IERhaXJlIEJ5cm5lIHJlcG9ydHMgYSB+NTAlIGFnZ3JlZ3JhdGUgdGhyb3VnaHB1dCByZWdy
ZXNzaW9uIG9uIGhpcw0KPiBMaW51eCBORlMgc2VydmVyIGFmdGVyIGNvbW1pdCBkYTE2NjFiOTNi
ZjQgKCJTVU5SUEM6IFRlYWNoIHNlcnZlciB0bw0KPiB1c2UgeHBydF9zb2NrX3NlbmRtc2cgZm9y
IHNvY2tldCBzZW5kcyIpLCB3aGljaCByZXBsYWNlZA0KPiBrZXJuZWxfc2VuZF9wYWdlKCkgY2Fs
bHMgaW4gTkZTRCdzIHNvY2tldCBzZW5kIHBhdGggd2l0aCBjYWxscyB0bw0KPiBzb2NrX3NlbmRt
c2coKSB1c2luZyBpb3ZfaXRlci4NCj4gDQo+IEludmVzdGlnYXRpb24gc2hvd2VkIHRoYXQgdGNw
X3NlbmRtc2coKSB3YXMgbm90IHVzaW5nIHplcm8tY29weSB0bw0KPiBzZW5kIHRoZSB4ZHJfYnVm
J3MgYnZlYyBwYWdlcywgYnV0IGluc3RlYWQgd2FzIHJlbHlpbmcgb24gbWVtY3B5Lg0KPiBUaGlz
IG1lYW5zIGNvcHlpbmcgZXZlcnkgYnl0ZSBvZiBhIGxhcmdlIE5GUyBSRUFEIHBheWxvYWQuDQo+
IA0KPiBJdCBsb29rcyBsaWtlIFRMUyBzb2NrZXRzIGRvIGluZGVlZCBzdXBwb3J0IGEgLT5zZW5k
cGFnZSBtZXRob2QsDQo+IHNvIGl0J3MgcmVhbGx5IG5vdCBuZWNlc3NhcnkgdG8gdXNlIHhwcnRf
c29ja19zZW5kbXNnKCkgdG8gc3VwcG9ydA0KPiBUTFMgZnVsbHkgb24gdGhlIHNlcnZlci4gQSBt
ZWNoYW5pY2FsIHJldmVyc2lvbiBvZiBkYTE2NjFiOTNiZjQgaXMNCj4gbm90IHBvc3NpYmxlIGF0
IHRoaXMgcG9pbnQsIGJ1dCB3ZSBjYW4gcmUtaW1wbGVtZW50IHRoZSBzZXJ2ZXIncw0KPiBUQ1Ag
c29ja2V0IHNlbmRtc2cgcGF0aCB1c2luZyBrZXJuZWxfc2VuZHBhZ2UoKS4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBEYWlyZSBCeXJuZSA8ZGFpcmVAZG5lZy5jb20+DQo+IEJ1Z0xpbms6IGh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA5NDM5DQo+IFNpZ25lZC1vZmYt
Ynk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiDCoG5ldC9zdW5ycGMv
c3Zjc29jay5jIHwgODYNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgODUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMvc3Zjc29jay5jIGIvbmV0L3N1bnJwYy9z
dmNzb2NrLmMNCj4gaW5kZXggYzI3NTJlMmI5Y2UzNC4uNDQwNGM0OTFlYjM4OCAxMDA2NDQNCj4g
LS0tIGEvbmV0L3N1bnJwYy9zdmNzb2NrLmMNCj4gKysrIGIvbmV0L3N1bnJwYy9zdmNzb2NrLmMN
Cj4gQEAgLTEwNjIsNiArMTA2Miw5MCBAQCBzdGF0aWMgaW50IHN2Y190Y3BfcmVjdmZyb20oc3Ry
dWN0IHN2Y19ycXN0DQo+ICpycXN0cCkNCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwO8KgwqDC
oMKgwqDCoMKgLyogcmVjb3JkIG5vdCBjb21wbGV0ZSAqLw0KPiDCoH0NCj4gwqANCj4gK3N0YXRp
YyBpbnQgc3ZjX3RjcF9zZW5kX2t2ZWMoc3RydWN0IHNvY2tldCAqc29jaywgY29uc3Qgc3RydWN0
IGt2ZWMNCj4gKnZlYywNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGludCBmbGFncykNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgcmV0
dXJuIGtlcm5lbF9zZW5kcGFnZShzb2NrLCB2aXJ0X3RvX3BhZ2UodmVjLT5pb3ZfYmFzZSksDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIG9mZnNldF9pbl9wYWdlKHZlYy0+aW92X2Jhc2UpLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2ZWMtPmlvdl9sZW4sIGZs
YWdzKTsNCg0KSSdtIGhhdmluZyB0cm91YmxlIHdpdGggdGhpcyBsaW5lLiBUaGlzIGxvb2tzIGxp
a2UgaXQgaXMgdHJ5aW5nIHRvIHB1c2gNCmEgc2xhYiBwYWdlIGludG8ga2VybmVsX3NlbmRwYWdl
KCkuIFdoYXQgZ3VhcmFudGVlcyB0aGF0IHRoZSBuZnNkDQp0aHJlYWQgd29uJ3QgY2FsbCBrZnJl
ZSgpIGJlZm9yZSB0aGUgc29ja2V0IGxheWVyIGlzIGRvbmUgdHJhbnNtaXR0aW5nDQp0aGUgcGFn
ZT8NCg0KDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWlu
ZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
