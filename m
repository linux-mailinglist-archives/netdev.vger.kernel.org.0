Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0250435365
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhJTTGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:06:53 -0400
Received: from mail-bn8nam11on2118.outbound.protection.outlook.com ([40.107.236.118]:61883
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhJTTGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 15:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5tjEw31I/l5RQHc7saDc07uThST6UBKVkW/v/zRbX5L/9j3832Yi4jLGa1INxg12+clorZfo/9zMLXiPjpTKr5ryhV04As1try3HLWqlZvzPJ5vyZvPl9p7d8UUnfikNUv8FOcxk0O1JFGgnVWIwInj0ATatqUW4rU4NOJPGVSwjwCHUUzKjVWupuqzHI9+PS1+DhZEFLlejsZ/vlHowTwNH9LED3iuzEvkWlbKZ1Bx1wdep1uN0scM1bn4HWs/m+PFJVzAVGMBHazbPMe/BDe+WAnRUxTyBUUv1dXIg+S7+7tzrFredEUqUz68Jv9wU2/4rGyFkmivzDHz3q9XtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XG9cf64R9ImpQRGnm5EnAsV/buEJwg5JAe+gVIVeqdc=;
 b=cRzfnTIhPBiaOKRenHu0rZMSUocY/4pW+KlV4tucARl5wb4wLflt43i3m7JlEPoUu3h9eaWGx8VrVvDG2KV9vnIGyfjEVwfq1P3qINMhz8XbGYuwM23znaZ2LhyVUDQCcFCX1fYx/Hmb11ukHKK9O2q/Zevbh0lVbaKlX+om+uCbWPzxo4E7cpiyEPvrURnM+FViwvxnmI39fP0ZIOKlRNoLpdxBgaXLJEJSqtFZGbJNsNdGun2slvPJTRpptaQJAcLT5OHK0cj3Udt1Obbjx1wdD0vw9Tp4/WsIPLwZu1Pe330XCRg3UGQD7e5hiLNPSnodA7XYE0HN4Y5B5GiY6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG9cf64R9ImpQRGnm5EnAsV/buEJwg5JAe+gVIVeqdc=;
 b=LXelKZSgxibzm/PNvrKAk9j6vG3b8qOCOd7RaDjHgSfIi2Qe3tGHmxamWOvZ1XCH2qbqWx5Cqz8SrpR+BsyhPBZYvPOyEJWb1Y3saCv7y/Zwe2UgkDHXiorhNA1+t1XG9i6SUZxUiyfQZMxbQaceGxguPU35BXDA6mlRgZzDD20=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH2PR13MB4375.namprd13.prod.outlook.com (2603:10b6:610:2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13; Wed, 20 Oct
 2021 19:04:35 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::1533:4550:d876:1486]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::1533:4550:d876:1486%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 19:04:35 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "trbecker@gmail.com" <trbecker@gmail.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
CC:     "tbecker@redhat.com" <tbecker@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
Subject: Re: [PATCH] sunrpc: bug on rpc_task_set_client when no client is
 present.
Thread-Topic: [PATCH] sunrpc: bug on rpc_task_set_client when no client is
 present.
Thread-Index: AQHXxB0aCpXzItx0y0+ho9pjv35b6KvcQmkA
Date:   Wed, 20 Oct 2021 19:04:35 +0000
Message-ID: <f16b2dc1c2fa50cb557b39a9ef83bf83ea6279b5.camel@hammerspace.com>
References: <20211018123812.71482-1-trbecker@gmail.com>
In-Reply-To: <20211018123812.71482-1-trbecker@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68f6e04c-7651-4e48-bfd2-08d993fc74f5
x-ms-traffictypediagnostic: CH2PR13MB4375:
x-microsoft-antispam-prvs: <CH2PR13MB43758AC8CA11C5E3C87408BEB8BE9@CH2PR13MB4375.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+a+Y5IPfRXyfJqChmhNZuqzbn8CdJ3ApmVvPBATMml8pnL/4MPkF68GJfwTb7IZplgWfYfvce1USt9HdnQp5hmd6BLC5jfwVtrrVvD15k44roV/yu+trxD/z/7Io6QU29ChWXRxla6ICrgp1FExCLHCc0AHeg5Pudsao5X+vGvAuG0gc+psVN1vJpmslD//z3Qk7H++SophxTW3KcwctBezKrVSFn8pbOA50dPO+3S4BZ8XBLz3xdVnGtyb6gY5v0Uv8A8RURotcJTEnjYTh/Ed1lUS5tokq+AJbsVyrTgh9sVAjYzwkYcEMm1t6LwN51Mx/JHu0uq4bHPiI8zZrrKwUKL6HQHJcIRENaX6v6pvapjEA0USffW1GV3QWOuH1zMPHbB0rN/NSfu3irTsRxo4qgz3cnE9uvbRQLmCwe2DeOI/rz3aGU/oM57YlYwaml/sRxYb/Iv4U92AHPuG92i6bsWOfq3ls88aeo8PfjPUAwcmx1zRGUvzpZqoQ1pNVNwk4GOPM4/rII/VDVWYQA7E1QfI/Heg0G3QXKt8dYXfZD3Ye+Ly5mWKlWuUMm3FQk7YmdofMrxBDSMzS0b3RbHLEp+H74PTe0r0jjZMM26ewQDCcH27QWbUnfaRjfYYZDUEGYPyEEFPuTwFSPms1RT3AsfvY4RKnrVdR1KQ9BlikHZN0rci51dTzxtz8Y8/q14IA9LiPzL2r8rDOMjpmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(54906003)(6486002)(66946007)(76116006)(86362001)(7416002)(186003)(64756008)(110136005)(36756003)(508600001)(66446008)(8676002)(4001150100001)(4326008)(38070700005)(122000001)(71200400001)(26005)(38100700002)(6506007)(2906002)(5660300002)(2616005)(8936002)(83380400001)(6512007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHFEQWttbFpIY3hGR2dIblZ5b3duTmRrcHp4MEVEZXJVMExmZlJYZk9UVk9F?=
 =?utf-8?B?YjM0Rk5LaS9sVVhkSjFLWlduY1o5ZEZGeHZuT2lqQnhlWmhWdXFQZ2I3TVlw?=
 =?utf-8?B?ZmloNk9JZUhMZ3NOTmFQSkJyZjdCS1dGd0FVYXRWd0Z5c2FUd0kzZXIwRVo0?=
 =?utf-8?B?Wk54bENDa2h0Ry9rNk9RRzVnMC9OMC9uQkhxTGM0TWJIczBMMlNibi83OW8x?=
 =?utf-8?B?ckowVW05SUxLYmVKdDQ0NnpPanZoREUxeGVQN0xDc01JNkp6WWZSRzBoaU1u?=
 =?utf-8?B?OWkzQnQ3N3luZWRxUEZOVjF2QWJKWGNkVzVRV0NibEFiUWlpWHkvQm80RjZr?=
 =?utf-8?B?a0RiYmFrRWE3cjV0ZnArUWFlcHRscWNvYzZrUzUzdEwzMG1KK1ZWdWQzek94?=
 =?utf-8?B?T3I4Tlk2SmlZZ3ZjTlExclA3RUdrRmxGUkdleWovOUIwcFFRSERYVzNhbDhq?=
 =?utf-8?B?VXRsWmxFcDJna1J2bjhVeFdqUEpaWkhZRUNIMi90d0NGVTBCL3pYclcvdWxo?=
 =?utf-8?B?dmg0QS9Kb2FaUFF2ZGNUejduN002VksrQlJENjNiMU16ZiszekwwZVZNNzJF?=
 =?utf-8?B?QWRKTnp1NDRKb21qM3o3ejdHeUZFM2NrTW5jcWE5TkR0cEltNklXZTBFWmoz?=
 =?utf-8?B?Q0xqaFJYMUZIcXZtclJKWFIvTHNEamxxS2M1MWtZMmhBeTh4WFlLaEhtamYx?=
 =?utf-8?B?MEtReTVkRDZwOUtsNzJyUGFoSTU3YjhEOXEzcDh1cm9Wa2VSNHJYeWIvVDFN?=
 =?utf-8?B?SVJFUlduVmEwdTJVc0NDeThkU0NFTnlmTDdoK1ZRNys0NXdMUXFabThydGIw?=
 =?utf-8?B?V1dNYWY4SmhPb2lXeGp3SGtHYmExbmd2S3kxV0svWktoNlhTYWFDcVZ5alBH?=
 =?utf-8?B?WW14THhQbWdzREdjSnc5VmdlZS9RNlNNakZWeWNFQ3Z3Q3dYT0l2aTY5ejRT?=
 =?utf-8?B?a2dZOUJ2cEJCMSt0RHNnNjgzVzM2QXUwaDl6SitjWC9wWURaZG40b002OWYw?=
 =?utf-8?B?QTZEcEc4T2hURkY1RE5PbHBuTWRuYjVVWElERTlQbGhFQTJSNzMrRmpvYTlO?=
 =?utf-8?B?Ym91YllZdG55Ry9KOUhKOVJwdTVRNjRpeE5VQUlERWV3SUxreldmSUpnc0xU?=
 =?utf-8?B?TjlBNjBXYTVycnRoMEE3TXdmOUx5ODU5cjA2SVc5Z2RiRWZFM0o1ZnBielZK?=
 =?utf-8?B?TE5UV1RKemhhTmdrR0w5eTJTV3MyVld5N3FLa2VqbmkrMnNFVXRNck0xYVVh?=
 =?utf-8?B?QmFsaDM1S1FiQnpURVk5UTZFUlltQVBMZUg3U1RtM2Z2TlFxVnlIQzEweEFE?=
 =?utf-8?B?RlgyMHJ5VzNtK1hVKzZQU3JXL1N5OXJWNEFMSDU5bDlDbkdLaWlYdkM0OWZY?=
 =?utf-8?B?V1N5cUdUYUJlZHdoZUJlaHlzNVl0cE9iYmtycFJ2SXhLR005K21OaEZ1WEZp?=
 =?utf-8?B?TXVOYTlpMWZmZlRGcHgwLzltcWk5dzIxZ2dOcW42KytKWkRJcmdPT1U1NVdZ?=
 =?utf-8?B?Zm55L0dFcGcvazcrNVJFMGEvek9vdHREWFllVWszdVd1eHFXaGNYSUJMa29C?=
 =?utf-8?B?MUpKeEt0OVlJT25wa084WkRYMmZEYTRia0t6UkEwVUUreXlwdy9ndmdFUFFV?=
 =?utf-8?B?TVNxU3lmYVBCL3pLWHFaYlFlcHBSR081ZzBlS2ZMTjdBZC9kYVJpdStnVHor?=
 =?utf-8?B?KzZKZVYwWTU2QWtDSWZKNWY1RkpuSHNLV1FhR1UrSVltMjY1V3Jkc3ZmbDRm?=
 =?utf-8?B?SGFnVUxMeU8wcEdQcWErNGhOUGlWdDRIdFNKdFFFRGoyV2RIb000UjZzUE80?=
 =?utf-8?B?Q016NzdYb1o1UVVVdFAyNk83dFByczNlN1NpR2Q3clNrSWdZM042TWdUZjZE?=
 =?utf-8?B?RXAxc0Qvcm43c25yM2lLZUQ3UUNNaDJEUUp2VFhIZ1JaWU1PeUtUdVp2QnNx?=
 =?utf-8?Q?23yFWRx5DTWX7FD13pixvXMUQeqHyPdB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <675361191FC1AE4099D07B60D23C1CD3@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f6e04c-7651-4e48-bfd2-08d993fc74f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 19:04:35.2153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: trondmy@hammerspace.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4375
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTEwLTE4IGF0IDA5OjM4IC0wMzAwLCBUaGlhZ28gUmFmYWVsIEJlY2tlciB3
cm90ZToNCj4gSWYgd2UgcGFzcyBhIE5VTEwgY2xpZW50IHRvIHJwY190YXNrX3NldF9jbGllbnQg
YW5kIG5vIGNsaWVudCBpcw0KPiBhdHRhY2hlZCB0byB0aGUgdGFzaywgdGhlbiB0aGUga2VybmVs
IHdpbGwgY3Jhc2ggbGF0ZXIuIEFudGVjaXBhdGUNCj4gdGhlDQo+IGNyYXNoIGJ5IGNoZWNraW5n
IGlmIGEgY2xpZW50IGlzIGF2YWlsYWJsZSBmb3IgdGhlIHRhc2suDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBUaGlhZ28gUmFmYWVsIEJlY2tlciA8dHJiZWNrZXJAZ21haWwuY29tPg0KPiAtLS0NCj4g
wqBuZXQvc3VucnBjL2NsbnQuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL2NsbnQu
YyBiL25ldC9zdW5ycGMvY2xudC5jDQo+IGluZGV4IGYwNTZmZjkzMTQ0NC4uY2NiYzlhOTcxNWRh
IDEwMDY0NA0KPiAtLS0gYS9uZXQvc3VucnBjL2NsbnQuYw0KPiArKysgYi9uZXQvc3VucnBjL2Ns
bnQuYw0KPiBAQCAtMTA3Niw3ICsxMDc2LDcgQEAgdm9pZCBycGNfdGFza19zZXRfdHJhbnNwb3J0
KHN0cnVjdCBycGNfdGFzaw0KPiAqdGFzaywgc3RydWN0IHJwY19jbG50ICpjbG50KQ0KPiDCoHN0
YXRpYw0KPiDCoHZvaWQgcnBjX3Rhc2tfc2V0X2NsaWVudChzdHJ1Y3QgcnBjX3Rhc2sgKnRhc2ss
IHN0cnVjdCBycGNfY2xudA0KPiAqY2xudCkNCj4gwqB7DQo+IC0NCj4gK8KgwqDCoMKgwqDCoMKg
QlVHX09OKGNsbnQgPT0gTlVMTCAmJiB0YXNrLT50a19jbGllbnQgPT0gTlVMTCk7DQo+IMKgwqDC
oMKgwqDCoMKgwqBpZiAoY2xudCAhPSBOVUxMKSB7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcnBjX3Rhc2tfc2V0X3RyYW5zcG9ydCh0YXNrLCBjbG50KTsNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0YXNrLT50a19jbGllbnQgPSBjbG50Ow0KDQoNCkknbSBu
b3Qgc2VlaW5nIHRoZSBwb2ludCBvZiB0aGlzIEJVR19PTigpLiBXaHkgbm90IGp1c3QgY2hhbmdl
IHRoaXMNCmNvZGUgdG8gbm90IGNoZWNrIGZvciBjbG50ID09IE5VTEwsIGFuZCBsZXQgdGhlIHRo
aW5nIE9vcHMgd2hlbiBpdA0KdHJpZXMgdG8gZGVyZWZlcmVuY2UgY2xudD8NCg0KLS0gDQpUcm9u
ZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRy
b25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
