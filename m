Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD9432A5E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhJRXd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:33:57 -0400
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:40801
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229608AbhJRXd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:33:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2cxldktoa4FFrPLSFF+h7MacvRJArKJ9btVetpCGYQhPBdv4DirwepRzkSrGLQ1RNVBwJToh4Sl6aySPuYMdXAx86Co8PTKT+HQsEqlfT9M4dntD8bdofoHi51T2TyOGSxLz1aK3k9I9qKGGWCMF2MnklG8K4YwdoRh9MT9/P8ux0Hk6OO3/wbpPUR8sssPGxyy9ugiIFUXFOkanjr03oiZWxqCQaqENzRWejgMEUiIA3/mt4cxbnRi9UGKIN+xczZnjqoIzd4qLUkfEUU+I2el62z32KUl0OSOvTZ3cvy2I60UbzYbPTidQQ+1IgyeZ8iPoozBZaYwsKnoD157vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYC8N94SWTzu3cHbVTmtMMVuHLkecA1M0uZUUpvvlmQ=;
 b=NYGp4qj91Lxrw/SzcBqpMnaEMLkoll7fdDjouNh0dBbH06qoQlcdsdy5Ngd2TOapvW05iIpdh2f4fIEaOFhbfE//XFe/6DuQFI3jP2g1+0QX8/u24MMCTS+9N/BKp4sqA3pOigpuyoc38MS1qnvBtl8KBV7If5Rc/bkMvvM+beBvw6b6zjGAyYXoMc81O26BQbW4zv0CVqvp2aftWmaKoxO4I26tjquOvI9WYHfEjXoc9fqbfvJSj+3ucODyb3n03c9/2J4PGXE6boQsODg3L7IPpTdTXbQOKLvAdLkHJnWZ430rqPHI1tefe8v7+nBIl4meawQkeh3O+vRJAdHYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYC8N94SWTzu3cHbVTmtMMVuHLkecA1M0uZUUpvvlmQ=;
 b=XnzzB0KKCa+sPeFc0tnqIbc1uIBMaK4q4pQS2rHa8tIDUf0Gjne0OE+WD3hfORLtTchmGpStsS1dg/uWBNAZZxEJl0BONIaivG2eiSy057bn9PN/SZz9fXjIcdaBsHzNfrkTs8qy4/zH0fRj3RvlX7eAD6uvRWg1W9VLKh6Ri4pPAAppb0SCoooQIpGy+vUb0u4CQbrZhgYmJxBvdC4FIZlYre3LyexxLgYr9+FL5mPobjGM1iwJNkoiK2mFaom60/B9apMXUy/sGGf92D+6b5vyYec2K4DuwgFGKh/Xb//mSc1fLPhPF30Eemwr86jrNFC9ZlXVWkRWYYv8BNCN1g==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2632.namprd12.prod.outlook.com (2603:10b6:a03:6c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 23:31:41 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%8]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 23:31:41 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "joamaki@gmail.com" <joamaki@gmail.com>, "yhs@fb.com" <yhs@fb.com>,
        "toke@toke.dk" <toke@toke.dk>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com" 
        <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
Thread-Topic: [syzbot] BUG: corrupted list in netif_napi_add
Thread-Index: AQHXwCcfqg3aoSxsr0STvbdWJFX0YavQ7jKAgAGWQgCABk1TgIAAG02AgAAImICAAHqgAA==
Date:   Mon, 18 Oct 2021 23:31:41 +0000
Message-ID: <8209462f985ac235a9d307de05835e31053528cc.camel@nvidia.com>
References: <0000000000005639cd05ce3a6d4d@google.com>
         <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
         <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
         <ygnh5ytubfa4.fsf@nvidia.com>
         <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <ygnh35oyb9c0.fsf@nvidia.com>
In-Reply-To: <ygnh35oyb9c0.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 326cdc33-7c27-4da9-2d91-08d9928f70af
x-ms-traffictypediagnostic: BYAPR12MB2632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB263295DEADC4F13D030CA9E4B3BC9@BYAPR12MB2632.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /haB2ouFHzVLKRMBghn4/K88Qh0j/XocF4rGlBfl+WW6ZQuZ1xJemSz5Pj0D6gbSd8Q2V61Y/2D+1VVV8PY8GJK4myu30GrXYnqTaoZKxrlIIVYmKL2Cbywbp/SaTtwEMqwKh9HybHOccpwXrTf160TqcCK805Pcmk15242xkyRSR6fdhCqb4+/KEiOlGsXoQuVN8+Vo6ty7GrJFlG885CtrlcnQFQLft75KZL9ClVtVSnn7HwPfmO/jZg/dpKjY3cfJCgy6tyV7rzuJ/epbL0rqqgB98pbO5ncF9Oz0iimbfFnY+BLZSNwJd5urZD5jG9thHb7zNTieOp+jQWQIu3tLqpVCoJRhU9eV/2XnywFv3KHPmyVi6GUREh8yZe2mcl/0K32SNDPDUSTCzIbKHZaG6e6hFeOVSd6KYpJVGOAUB41E46c8WxKiPr1CksULYAjBVrYuyM2wUWUKCeI0bXYuL0sRfMDctp8TSE8AgDvM769OtfTvgtllP7MahhtDTpLahmZRCto0LaMZ13wcoPUebkTq0HrcGr4Na12TkiV8Sko1mjvQ+heP25ssagqNkfWGyTbf3YyunEmUxRsjz7cCNBj4I6Zl0iGoBNaXlroljwu3taBS0UwLrtOc6xNpJHqOyj44VArPT9hRJsmf3qASfoKC3wtxHeXDNfwrkMjqXVQ3hvDgSRQFDhu/7fSOX9ute7sJlqi9uHVyNBS90Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(7416002)(8936002)(4326008)(6486002)(6506007)(83380400001)(71200400001)(38070700005)(36756003)(76116006)(4001150100001)(316002)(66946007)(2616005)(66476007)(26005)(122000001)(66556008)(66446008)(2906002)(6512007)(86362001)(186003)(64756008)(508600001)(38100700002)(8676002)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWlOakZ6a1NjQWdoRi82ektBOTNQNU9tNVB4NEVTQUNrcDBNL21NVEYyRHRr?=
 =?utf-8?B?RTkvT1RYK2ptQXZyVXZTQml3bTRNSCthdTFvM0dtNDBPNkhmWjBjcHRPa0hV?=
 =?utf-8?B?NlpTeXJPWE03WnQ2VE9MNzFualZncVlzc2I4VEZkRitubEdqMGlxRldjNTIy?=
 =?utf-8?B?aUtJR3hLV0w0Nm1CUVBuYlBYcUVmZDNmRUd0OUh0UDgwVHlNVzYwcHdFc2Nx?=
 =?utf-8?B?Y2xaUElwNFB3eUx2eTByOEJuaFlGYXpGVnBERVQvZThnOWxub0cyLzM3dXkz?=
 =?utf-8?B?b0prOXR3aC9Ja2F3YndYMmVySjIwWnJIbGZrVGgxcm8xV2RicGUzK2RHUnJh?=
 =?utf-8?B?c2RiaVZwNWpOZlJBRWhUaDJvMDdicHpPNytBL1FUTURLdHk3bVVtRDZSQmVS?=
 =?utf-8?B?ZUxjU1d5MVVONVV6ZHVhK2JoaEVycDBySVlXY1Z0WU9oSDhxZlhGNFVVaVFQ?=
 =?utf-8?B?MW5NRUx2b0tHc0hOQ3hiVFp0UWthR05iMXR4ZzZMaS9RaEZUMjJpaFBFc21M?=
 =?utf-8?B?OGZBRzI2akZ6WVJOb0xxanUwVmJEbUphTHZZcHE1SW01RjNIeWxCVFgzS2lx?=
 =?utf-8?B?ZUFNK2djVlVWMUl3Zjg2NU42MWxIaVRhdC9uK0xYV1pDdWZmTFdSOCtmYVU5?=
 =?utf-8?B?ZWtrc2loNFlaNTYxaVhtRlRMZ2hWaWMzMjBXZGZZTkx3SVVJMlphVmZPb1Bi?=
 =?utf-8?B?OXVWYjk4UmhBWFoxTEs1dWdqS2lUWXlSL0JMRUptZXppS3pKU2E4Q1JWbE9m?=
 =?utf-8?B?QUV4SzFFUzE4NEhVeld0QytQSVBaZTZ3UTVzKzZlR21ubkw1NkVQazZYOUtM?=
 =?utf-8?B?eXpGZ1JvVGdvbkkyWDkwTEw3ZXA0MzZtQ3BMVm54ek92TERJelhZWEFmWHU0?=
 =?utf-8?B?cHFqWTIvdHJibjMrRy9OMTBOUkhxenNMRE1SaXRiZUQxVEtTTjlrdHJYMlJa?=
 =?utf-8?B?VWt4ZVZOV25FaVZNUXNDUmg5UlpqbmxpZDBkSEorZUZkYmhUWmVBRGhnS0RU?=
 =?utf-8?B?SzVUVEE0ZnRWVldSanZHYTNBS08vUFJIdzVxMlYrM1poaG55UWxUZzg3Z2sz?=
 =?utf-8?B?NVVOcmFPN1V0Yy9nekRTMlN6TUkzai8vb0o3VGh0SjFiWDkyZm42QWczbXl3?=
 =?utf-8?B?OXBsY2p1dDFRTnMyaDZzdDc4Y0JLR3FBNldiQ0xEdGhMUWdVZmpvc3Exajhh?=
 =?utf-8?B?d0JvTHZHRmJhd01FWVZqUEt0TEp3azNjTWE5MlIyL3N6emlXZFdhdmRPYjJ1?=
 =?utf-8?B?RXlBQXNQOEtOUVlxTnN4b20wdGx5QXVXaW9OYjZNL1NxYVNsd2NTZEV2a1M0?=
 =?utf-8?B?c3VOZ29rbEM5WWlIZzREVUZYckVBYjd0SEJvOEczN2o2ODdqKytKZGt3TFhL?=
 =?utf-8?B?MFVXOHBtVElIaG9uZE15RUxDSCtsZ2VSOWdUbG5aTnVVRGYyb3BRd2xOc3Nt?=
 =?utf-8?B?YkhCcWFnK3JtZHIvY3ByeHAwc1ZRazRvZmxGdWc1cldobWY0OXVNdEh2SzdF?=
 =?utf-8?B?QmNIODhqeDlmSEpDQ1lRbFBLYjlzai91VGZJb3pqYWtiYkJHMHZBT1ZGUlJz?=
 =?utf-8?B?LzZjb1BpN0hXZHdOR1BNaDNmMEdubDJscFZxei8ra3RsMThhUnd4bkIvOXo5?=
 =?utf-8?B?bkxmcWRLU2JNQ3pTK3UxVGZLNzFHUWduV0dpdGpSVGYvMDRoZ1hUaE13cS93?=
 =?utf-8?B?SUs3dEVDNVVoeUZJUE01OURsbkRJY01sYVpsVDFTL0k2b1M3YkVsdE1vcmlL?=
 =?utf-8?B?MnMxQTZhU3NsOFl3Wk5tcFk2bWdFZTFZWHA5YWhHWnhEYkVyc3AwYTgwclJH?=
 =?utf-8?B?NVJNK3hOdGRCNnFXS1ZuUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96A43AEB96DEBE418347698141721FD3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 326cdc33-7c27-4da9-2d91-08d9928f70af
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 23:31:41.6928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UWZDOVOaiV5kvTcKsNImmPX86JgCiCR+O9J02XkjdfJ+bebPxi7G+46jEu9/FMKOLY8uipkpSKrU0h+489gGhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2632
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTEwLTE4IGF0IDE5OjEyICswMzAwLCBWbGFkIEJ1c2xvdiB3cm90ZToNCj4g
T24gTW9uIDE4IE9jdCAyMDIxIGF0IDE4OjQyLCBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gPiBPbiBNb24sIDE4IE9jdCAyMDIxIDE3OjA0OjE5ICswMzAwIFZsYWQg
QnVzbG92IHdyb3RlOg0KPiA+ID4gV2UgZ290IGEgdXNlLWFmdGVyLWZyZWUgd2l0aCB2ZXJ5IHNp
bWlsYXIgdHJhY2UgWzBdIGR1cmluZw0KPiA+ID4gbmlnaHRseQ0KPiA+ID4gcmVncmVzc2lvbi4g
VGhlIGlzc3VlIGhhcHBlbnMgd2hlbiBpcCBsaW5rIHVwL2Rvd24gc3RhdGUgaXMNCj4gPiA+IGZs
aXBwZWQNCj4gPiA+IHNldmVyYWwgdGltZXMgaW4gbG9vcCBhbmQgZG9lc24ndCByZXByb2R1Y2Ug
Zm9yIG1lIG1hbnVhbGx5LiBUaGUNCj4gPiA+IGZhY3QNCj4gPiA+IHRoYXQgaXQgZGlkbid0IHJl
cHJvZHVjZSBmb3IgbWUgYWZ0ZXIgcnVubmluZyB0ZXN0IHRlbiB0aW1lcw0KPiA+ID4gc3VnZ2Vz
dHMNCj4gPiA+IHRoYXQgaXQgaXMgZWl0aGVyIHZlcnkgaGFyZCB0byByZXByb2R1Y2Ugb3IgdGhh
dCBpdCBpcyBhIHJlc3VsdA0KPiA+ID4gb2Ygc29tZQ0KPiA+ID4gaW50ZXJhY3Rpb24gYmV0d2Vl
biBzZXZlcmFsIHRlc3RzIGluIG91ciBzdWl0ZS4NCj4gPiA+IA0KPiA+ID4gWzBdOg0KPiA+ID4g
DQo+ID4gPiBbIDMxODcuNzc5NTY5XSBtbHg1X2NvcmUgMDAwMDowODowMC4wIGVucDhzMGYwOiBM
aW5rIHVwDQo+ID4gPiDCoFsgMzE4Ny44OTA2OTRdDQo+ID4gPiA9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+ID4gPQ0K
PiA+ID4gwqBbIDMxODcuODkyNTE4XSBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbg0KPiA+
ID4gX19saXN0X2FkZF92YWxpZCsweGMzLzB4ZjANCj4gPiA+IMKgWyAzMTg3Ljg5NDEzMl0gUmVh
ZCBvZiBzaXplIDggYXQgYWRkciBmZmZmODg4MTE1MGIzZmI4IGJ5IHRhc2sNCj4gPiA+IGlwLzEx
OTYxOA0KPiA+IA0KPiA+IEhtLCBub3Qgc3VyZSBob3cgc2ltaWxhciBpdCBpcy4gVGhpcyBvbmUg
bG9va3MgbGlrZSBjaGFubmVsIHdhcw0KPiA+IGZyZWVkDQo+ID4gd2l0aG91dCBkZWxldGluZyBO
QVBJLiBEbyB5b3UgaGF2ZSBsaXN0IGRlYnVnIGVuYWJsZWQ/DQo+IA0KPiBZZXMsIENPTkZJR19E
RUJVR19MSVNUIGlzIGVuYWJsZWQuDQo+IA0KZG8geW91IGhhdmUgY29yZSBkdW1wcyA/DQpsZXQn
cyBlbmFibGUga2VybmVsLnBhbmljX29uX29vcHMgd2l0aCBjb3JlIGR1bXBzIGFuZCBsb29rIGF0
IGl0IG5leHQNCnRpbWUgd2Ugc2VlIHRoaXMsIEkgcmVhbGx5IGRvbid0IHRoaW5rIG1seDUgaXMg
bGVha2luZy4uIA0KDQo=
