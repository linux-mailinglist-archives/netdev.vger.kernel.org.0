Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0400239DBAC
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFGLpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:45:51 -0400
Received: from mail-dm3nam07on2083.outbound.protection.outlook.com ([40.107.95.83]:9121
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230237AbhFGLpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 07:45:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhyE3fxfmKryt+1d0Yh4WJNRic8RQEW+EsayHzrAYp8ZpEdNFRBdvnrJElNjKlqiInJuzrossGSHS6XrkoRTFFC6vhB1qh4Otn4KYEhX3Pc3plUKT8QftiDLmIFNSSi86bhREz/CrlAm7MIHPMVkPFDtIafiw8CLMe8zQ/5AIGNz13t6cuCw0LZ17cdBIZLz5mL9ud/Bg6XCZvjuRzVf4R4w9ELjHK87hFLvzowtbRFFFMLZ8yVZoWCRUSRuJATi5g+C4vcpeOvQs2F9Uigs+QBMIBOiZV1YRolukS7iCsNzDpCnkEl8qMwjDHTfGVlOsyFV/c/3XhTUcZBmr17Ecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiWwjYVUpcEsvebz0XwsEVJMuouYH2035RiGyg6H0hk=;
 b=gvq30OKrhLVTdVn2zLpxazvl4bqddXilk+RCWz3kzniyrkYpBC7UW5ekYCACtjibilZTECkGvRhcqG7ZCRzfhf/j5i538Gi8xJn776l27VXyQ9HItWri3TrQIKlTH+15xskZYVFIPE5Sg2cwT0x1Rp203HTA1zOmuU0YIK7Ol2TEL4/wIGaBZbiF2p1WZONZNH5+H9s6v7gokzjiXMqtQcj+eIsi9qwr0fUAMK5MB0+hmWbPF0AWvFJt+chROcopO/rsqFNeR1Jjf+Nw+Cw9dDD/6vC08wXF6C+phw3SAAWz8tN6UStRVfA9dL2rg4cRfOO4dFZWTXGU4mqrH0r+Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiWwjYVUpcEsvebz0XwsEVJMuouYH2035RiGyg6H0hk=;
 b=tOJemoULeEQIIHliELr7IjFtcc/Pr4BagWQKrxfv819JThZJ7gqfqDRmEF5NUy39miKCogBqdbD0kb8EfxroeeeyHNeMUIVpwsdj+prq6XTbXc/s1yzucZqGCd5N1syO/XYyt7nYcWZtPxxvA+z7QprCqNLsr29Y1ETEuxO5L6x0DyMEwHTNq7WGxnW/41nxRakUIbO6ua5V0/N3doLfUnaPa/qyem0lkyE52KUHbZ+atwvFH+fqedAczItw8ZxFIjDDnVlm4Txs/O3Jb7BOJ8DxEmtiWwAPsIRjBANHQUPFaSotffozXgSNbnrZclzO5Zy3XPFJ/QiR9aNYWNYXsg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5402.namprd12.prod.outlook.com (2603:10b6:510:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 11:43:58 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 11:43:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXWGpNwXhSEOm/yUu2yThJsUjGQKsH4bwAgACRO4A=
Date:   Mon, 7 Jun 2021 11:43:58 +0000
Message-ID: <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
In-Reply-To: <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.218.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d07afd08-a769-44c4-053b-08d929a989bd
x-ms-traffictypediagnostic: PH0PR12MB5402:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5402A92FAEA4C83D71C65806DC389@PH0PR12MB5402.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OHuyNF9RocCnDZlx+zU4A7wJQ78MjJLVcjeKB1HsQ+AQFQueCe5L+FVGxA2+rCXQ5BrFhAFYXwI+fGOX/5lpW2ZECBSmaBCB5uYYWrUNdVqBJ3vUnXRw6zGRKPhM53G7gkpbKhE0P1ZZLSFsVjAplYqk4BW280qMDzwJ5eb1mdfYYFBshAoa7kOXE2kapYyxzwUanh5g8fHIcgB7kubP93zu72ds2gNpq8pc2cEWbEboldZcPvTcOoYMdvlWgSKCwxYcAWoqYUBPcdB3lsAPqWr7N1dmL3IoJvmrNQUoDBYnrELtHdqzJtnHaXPdErS/V6tPLbZshVXaD8i0KfyUg1y7zCekFXYP2F19g3o299XEAKKIxjhv+MFFN87hopVAoSqQt+DGljmb9b3W6aWOvOWExzbBW15Lta8CNJdGlciRsBd0+kYTmyqWZnZ67HdFLt1yMblS4y3+A6CPba2bVDfztQvcojn66QviWHxRgsOmmxCnDceL3lSjp26LcBcQm3UDB6MnHCdm7C20ERls8CPT4jGK6J1eJTDek/CHS3i9GisF977mQaMUgZkYPOLvk6wQuge5K/rsYejNJQEJ3TWdDFUaN+g/ZCEmuNGsEpQXYk1Xmwu+gjbWAwkofxDWDWqd2NPBhXSwZOGkF0WWAnFd+2H5moOEPtaC02m1N12MJKOx13S5uR0qS6xmQkJIZ7fUfLU5mENFyRwD4hFrZyrUhd3q/2pkZLSq+W4w52s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(110136005)(52536014)(55236004)(5660300002)(66946007)(122000001)(38100700002)(186003)(83380400001)(7696005)(4326008)(76116006)(53546011)(71200400001)(55016002)(64756008)(66446008)(478600001)(66476007)(966005)(8676002)(107886003)(66556008)(33656002)(2906002)(316002)(26005)(6506007)(9686003)(86362001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RWxoenljWUVJbnNJSnFmbUhwT1NMK0VGRVpiOERLMURuc2FSNlp4aUpKb3Fs?=
 =?utf-8?B?T2Voa2U2eTJsWGlnS2VJODQ3eHdxNDR0eFduRzk1b284OWxuL0pkdy9pREto?=
 =?utf-8?B?d0R3aW1XcmZ4VEMzK0JWT0FJaWpzaUx3U3JLaVd0Y3JTUFNqc0FVSkRFNVcy?=
 =?utf-8?B?N0d2V05XcHNnSDlyYjREVVFXQmh6eE82b09vZkI2TmlvQWpCZ3B4akNlcVRz?=
 =?utf-8?B?QkpLMC9ZYmVIendTZ21xUWVEQ3M0N1ZYM3VRWXpSVnRsb1RWUlQ3Y29QWVda?=
 =?utf-8?B?SlFRK1o1OXliWkRqaUZJWUwrVll3RTRZY1pqTWVqRjdXbSsvQStsSnlNMTdq?=
 =?utf-8?B?OFVhSlhIbjF6NnlpT3JPZ1IrK2RwOXgrNHIyYlIzS3loZXBVbjhTajdsQmJq?=
 =?utf-8?B?VlFVbGl3WnBjTFphS2UySDZtRGxTLzNYYWh4RWNjTUVLNW1CTzZXcVg1ZVdn?=
 =?utf-8?B?V0txNnBXdDZmSEh2NkFKUFN6SkhmYUR2MDI5dTVvVlN1TjRzT0pLS3V3am1D?=
 =?utf-8?B?bEUrSFpLaW9JRG1DNENiY0tmbjRwQjlPQkZLd2VXOVlLNzJqWnlJeDNuMEVF?=
 =?utf-8?B?NHRheitKVldQNlZBZE1LVlRzNzZEcTFPeTRYNzJPWlQ1TUhCYzFoVndqdVI4?=
 =?utf-8?B?V0tzY01STWNKQi93amVuVDFjRWtsTnJrVnNQZjlCaWRkcldCWDdFeHVxZUlX?=
 =?utf-8?B?UVNENVBBY29wZkd0NlduNS95QmJzTmRPcHYycTRPSkFTQlhlZjBmNzc4QW11?=
 =?utf-8?B?SzQ3akZHdjdsem9yWHhpc0xHZGVjQjhqeFVodzIza2EyMHZnMFJTbHExZzha?=
 =?utf-8?B?ZzE1dlI1L2ZjMGdueUtpQ00yKzQ4KzdyaUZJQjI4RkZIdGJwMittUTVPSlh5?=
 =?utf-8?B?TGpsVkVQS1FPTkpFNVBwWWl4d0VJYnpxU2RIY2VkUmhPajV4azFsWGZuN21p?=
 =?utf-8?B?bkdZV2lVemE3Yjd4ZXZncUxwUnZIOUpqM3ZKOFIvYjNncklqdS9Pb0NrVzFT?=
 =?utf-8?B?bkwzeHZ6dUk0Y3lEQzJLeE1ZL1dDVy91MVBaWTJXam5lMmxkLy9yc2p2TnlJ?=
 =?utf-8?B?bjBjNmFjRnk4bUIrVmJ4YUU1elo3c0pQcEZ5RE5MUlA4WUhNaGRrTnhNNkJB?=
 =?utf-8?B?VithR3g0MnRERmREWFY3NUQwdndDQklUZHkzY2tpYzBUWWgxdEg2Zk1SR05I?=
 =?utf-8?B?dis4a2lDTnNhTXpGV0JuSUFjTTJ1VjQzQmN2M2VsWHFDaE80SmUyOHZIQVNZ?=
 =?utf-8?B?YjlqQUczNmJFdjczdFQ3RkNLTDNKVnA4SVNTY0YyVW5LRTNuMUNhT3VCejBp?=
 =?utf-8?B?V0d4d2hlbW5GeW1WMXNERGFjWWJkd3pWbEFyekduZ0VxdlZyb09YSVZ4eDI4?=
 =?utf-8?B?RXlLVnNmdWFvbHYrV3p0ckNpM2VqTC9XRUhXZmtGWXN0OHFUTFQzeHBoSjFo?=
 =?utf-8?B?VTZzVzdibnRERmNtMXVHTFNnTGRHUU1SVUNIZjZCcGhkTjFUOUExalVsTWEr?=
 =?utf-8?B?bCtKYWxYUDN2TXlsTFVzVlE5Rkl6N1FwbnhiMXh1Rm5OQlJpZVBrMzhwYVJD?=
 =?utf-8?B?SVRnWmFVeTN3bjZpWVZtdVpTb3dLWXUzeGRKR2dHRFRlRkxIczZkUFE0czFB?=
 =?utf-8?B?RGRlaytFVUZkQTA4M3pNazhCL2M3Y0JZVGRvWmRaN0R2eHF5RE5RRzdSc2JJ?=
 =?utf-8?B?SnpJM1g4OUszaEtVbHBmRW5UZzUzNHJoRmI1dzAzOG9NOVBMQllOSUtaNXln?=
 =?utf-8?Q?1XmuIazllfBuUZkjKRbvj74Ke25WBvdqmts7dYQ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07afd08-a769-44c4-053b-08d929a989bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 11:43:58.5310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Xo6K2pgXFr4LmAgIZ/gWkfupNO2zDniXAQ0ovWp1FIEpLjCot/Kg0wbOxP2ThRG31nxwzPp6QwE/tZMgORkpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBNb25kYXksIEp1bmUgNywgMjAyMSA4OjMxIEFNDQo+IA0KPiBPbiA2LzMvMjEgNToxOSBB
TSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEBAIC0zNzk1LDcgKzM4MDYsNyBAQCBzdGF0aWMg
dm9pZCBjbWRfcG9ydF9oZWxwKHZvaWQpDQo+ID4gIAlwcl9lcnIoIiAgICAgICBkZXZsaW5rIHBv
cnQgcGFyYW0gc2V0IERFVi9QT1JUX0lOREVYIG5hbWUNCj4gUEFSQU1FVEVSIHZhbHVlIFZBTFVF
IGNtb2RlIHsgcGVybWFuZW50IHwgZHJpdmVyaW5pdCB8IHJ1bnRpbWUgfVxuIik7DQo+ID4gIAlw
cl9lcnIoIiAgICAgICBkZXZsaW5rIHBvcnQgcGFyYW0gc2hvdyBbREVWL1BPUlRfSU5ERVggbmFt
ZQ0KPiBQQVJBTUVURVJdXG4iKTsNCj4gPiAgCXByX2VycigiICAgICAgIGRldmxpbmsgcG9ydCBo
ZWFsdGggc2hvdyBbIERFVi9QT1JUX0lOREVYIHJlcG9ydGVyDQo+IFJFUE9SVEVSX05BTUUgXVxu
Iik7DQo+ID4gLQlwcl9lcnIoIiAgICAgICBkZXZsaW5rIHBvcnQgYWRkIERFVi9QT1JUX0lOREVY
IGZsYXZvdXIgRkxBVk9VUg0KPiBwZm51bSBQRk5VTSBbIHNmbnVtIFNGTlVNIF1cbiIpOw0KPiA+
ICsJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFkZCBERVYvUE9SVF9JTkRFWCBmbGF2b3Vy
IEZMQVZPVVINCj4gcGZudW0gUEZOVU0gWyBzZm51bSBTRk5VTSBdIFsgY29udHJvbGxlciBDTlVN
IF1cbiIpOw0KPiA+ICAJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGRlbCBERVYvUE9SVF9J
TkRFWFxuIik7DQo+ID4gIH0NCj4gPg0KPiA+IEBAIC00MzI0LDcgKzQzMzUsNyBAQCBzdGF0aWMg
aW50IF9fY21kX2hlYWx0aF9zaG93KHN0cnVjdCBkbCAqZGwsIGJvb2wNCj4gPiBzaG93X2Rldmlj
ZSwgYm9vbCBzaG93X3BvcnQpOw0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIGNtZF9wb3J0X2FkZF9o
ZWxwKHZvaWQpDQo+ID4gIHsNCj4gPiAtCXByX2VycigiICAgICAgIGRldmxpbmsgcG9ydCBhZGQg
eyBERVYgfCBERVYvUE9SVF9JTkRFWCB9IGZsYXZvdXINCj4gRkxBVk9VUiBwZm51bSBQRk5VTSBb
IHNmbnVtIFNGTlVNIF1cbiIpOw0KPiA+ICsJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFk
ZCB7IERFViB8IERFVi9QT1JUX0lOREVYIH0gZmxhdm91cg0KPiBGTEFWT1VSIHBmbnVtIFBGTlVN
IFsgc2ZudW0gU0ZOVU0gXSBbIGNvbnRyb2xsZXIgQ05VTSBdXG4iKTsNCj4gDQo+IFRoaXMgbGlu
ZSBhbmQgdGhlIG9uZSBhYm92ZSBuZWVkIHRvIGJlIHdyYXBwZWQuIFRoaXMgYWRkaXRpb24gcHV0
cyBpdCB3ZWxsDQo+IGludG8gdGhlIDkwcy4NCj4gDQpJdOKAmXMgYSBwcmludCBtZXNzYWdlLg0K
SSB3YXMgZm9sbG93aW5nIGNvZGluZyBzdHlsZSBvZiBbMV0gdGhhdCBzYXlzICJIb3dldmVyLCBu
ZXZlciBicmVhayB1c2VyLXZpc2libGUgc3RyaW5ncyBzdWNoIGFzIHByaW50ayBtZXNzYWdlcyBi
ZWNhdXNlIHRoYXQgYnJlYWtzIHRoZSBhYmlsaXR5IHRvIGdyZXAgZm9yIHRoZW0uIi4NClJlY2Vu
dCBjb2RlIG9mIGRjYl9ldHMuYyBoYXMgc2ltaWxhciBsb25nIHN0cmluZyBpbiBwcmludC4gU28g
SSBkaWRuJ3Qgd3JhcCBpdC4NClNob3VsZCB3ZSB3YXJwIGl0Pw0KDQpbMV0gaHR0cHM6Ly93d3cu
a2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvcHJvY2Vzcy9jb2Rpbmctc3R5bGUuaHRtbCNicmVh
a2luZy1sb25nLWxpbmVzLWFuZC1zdHJpbmdzDQo=
