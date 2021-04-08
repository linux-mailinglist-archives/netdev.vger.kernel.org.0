Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F058358930
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhDHQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:03:00 -0400
Received: from mail-co1nam11on2106.outbound.protection.outlook.com ([40.107.220.106]:64225
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231655AbhDHQC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+qrO57pgVmRAA3wYM2OJPJU9QBmTIBLfkI0mV5W96rDLarYT52s9lQOAIAguUHtA35u48KnCef0ZbkV+V8z9ZCSfS2rEz/p7K5LOkiE4GKxEq77aOUnP2fIgOfxSDLPiiyFhfNgo8eJaoRvVsWTSkF4dTKzRQ0c64eJn0S4q+I+2yZYoVv8GV30TuKtZBP9KCQu2R0qqnflUjBu66a3nYgb9GL+EHgWy0m9JHIAqrI4cYFc+nZwGBcz9FHRIJhcudKgpSWqB8d4WawiaKuXfspcrjtByANn6Uvh8zcN73WZXN+vA7VKS+Zk23eTw42LoJ8ex37p7rXtj5cKnEUU8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAQ8FFD58JBGEfhmj7xyYjmyw0Y7RvdW4FDttHlETMU=;
 b=DYtdYih95qrIycPNGSt18szWNMyZdO2/l+/5gdtrB4OMBRajNVTGbR+eXs/2ppz3nkfZxnRk9Hy+xseuECxxhAjZKaUC4/+6wDOdVSiNl8hUZmq9V+Mji9wyusmc4binpEMCZvVX8TkoMVAXquBOVLl6FCQGzzlxgEQhDqSSmnUF4s8RHQG6V9SiHgRM77SJt2qvrCthua2iqMUMMDQtJXn3On770ejGk+HgYB5IGOmZE3FfMMBYKin4D7o23xu4gXgAWG+RkQy1+GMAqgkLhTBWd5oBrTMoT79/vkek0oTbNcE+QzNXZOaQbU0wIX1yc69ptL2dSSwjZdJpM8oTdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAQ8FFD58JBGEfhmj7xyYjmyw0Y7RvdW4FDttHlETMU=;
 b=VILCmO9eXkmrWxT3C0/coUH90vp1Ch/KouSytx6BhPGvcoAuwktrm+0MBX4LnyZStjDoBsjuRAOu+YpagpgN3XSoVsm4WP2y8+xdAubbgeFl5mQ5SE44U5Z8U/xJR/ZI7XXEIK4UIEJDzyVfiLexL2Tln1I9H92KgzIrgOIaB1I=
Received: from DS7PR13MB4733.namprd13.prod.outlook.com (2603:10b6:5:3b1::24)
 by DM6PR13MB3865.namprd13.prod.outlook.com (2603:10b6:5:1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.6; Thu, 8 Apr 2021 16:02:43 +0000
Received: from DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0]) by DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0%4]) with mapi id 15.20.4020.021; Thu, 8 Apr 2021
 16:02:43 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "aglo@umich.edu" <aglo@umich.edu>
CC:     "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "pakki001@umn.edu" <pakki001@umn.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Topic: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Index: AQHXK0NV8TqxghYc4k6II+5Gojms3qqquYoAgAAGi4CAAAqWgA==
Date:   Thu, 8 Apr 2021 16:02:43 +0000
Message-ID: <717504ebff4d1c7506897d1fd8e6550d9969d983.camel@hammerspace.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
         <c0de0985c0bf09a96efc538da2146f86e6fa7037.camel@hammerspace.com>
         <CAN-5tyETkDBVfYQrBOm1veAzMdo-9K37bfgL+QZTPW=d2OAP9A@mail.gmail.com>
In-Reply-To: <CAN-5tyETkDBVfYQrBOm1veAzMdo-9K37bfgL+QZTPW=d2OAP9A@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: umich.edu; dkim=none (message not signed)
 header.d=none;umich.edu; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88101b1e-c700-4661-9253-08d8faa7be9a
x-ms-traffictypediagnostic: DM6PR13MB3865:
x-microsoft-antispam-prvs: <DM6PR13MB3865AFD7C4338D2AA74B6BD4B8749@DM6PR13MB3865.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ZOzLx9oMn/I6+HVXipuMl2DlbUTVQXCQy+adTRlDoP0en2e81b0nw9D+soohXy4nUrrpJN0dZnklfUBp+DG7UeJIIw65Q0MVqMg6iOTHI8jHMs1sgc7iTEBZFbGtXBEEm8zbAwVNxtutHgDaXhaGajS1ePgtKhbECfIu2UBgIgRbR6CRFUbk+yWyH05iBzGDGBxzmzdC9Ng2nGQXtVoLa2lCPkxR08Mfr1j5ZTMgzW/P4JCfPOE0rvwkP8L0CAMBxKxhj8UqlUxITDgOn31u57M0Y83bFuWYBHSPauoHucKs1v+OHq98IDRHgWmFvUQgEmDJ6uN6uhn4ex07QA6+j/9xZL01EAK3tr4aI+IyJJoASLmgIwhtar5r+XsExl2GdOXt1H3jiV4tjF4J2bghWL0wtCRrZdZ4Oc17SGqo2SeL9CyQcn6OBIeRqkdV/rhsAjtPrmQlaxzDk59XR6wVuzpVxOK3RBT6Y0AKrmzXHQNGo/a4Z+ew7LvPpM6gxN/184vBZZJBhuD24VVCt1mTFbOL6qjRBAh+tcHvA0xHq5z2ooGwV4frwbJ3B8azNo3pVBO9WeiYbUNK7tAmNDE3Si1dNdBLCWUEZAj31jq6PiPxL4hxU5AVYjDFp0WqInAXVSXOnAPP/HPYxJPCXxUCct86ChjMbjhI74JUcFs4o4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR13MB4733.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39840400004)(346002)(366004)(396003)(8936002)(478600001)(26005)(186003)(76116006)(6512007)(4326008)(66946007)(66476007)(7416002)(66556008)(66446008)(64756008)(8676002)(71200400001)(54906003)(6486002)(2906002)(5660300002)(6506007)(83380400001)(53546011)(38100700001)(2616005)(91956017)(6916009)(316002)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z09KVVBKdHNHQWpNM0JGQWFHUlM5aVpPY3NrRWg2N2Q3R3kvcTFKNkVWU2kz?=
 =?utf-8?B?TkgvL0tnYWNORDRJRXBBRmh0bVE0L3F1NkpxenB5Nlp4S1lYS25Id3hwR3ov?=
 =?utf-8?B?Vzdmc25WNy9MV0M1OUR6dXJlMXVKQjRHd2JrRzN4TWswOWc2YjNJa2tBUXFX?=
 =?utf-8?B?ZUZtK1ljcU90RjViV1duSlllUG5KdTFieGp0MW9lQVIxZVdsVWRkdnYzbk5P?=
 =?utf-8?B?SzhxaEtBVHR0Smo1Qjkwd2p5Mm9xWE1FTlhXYkYyb2NGTDg1NkVKUVNoMTBX?=
 =?utf-8?B?MTMwaG1uSE9xVEE4TXFjdytET0ZVSWVrMThMd3JBeTh0WWRubk5FVXJLWlIr?=
 =?utf-8?B?THVOenpPUWJpT3hvWlRsNkhSUVJJUGU2anhFMithWnpiRHpucTFNN2RwWHpK?=
 =?utf-8?B?UnNWL3NzeStMV2kvWVhaZktyNHBKVDJjTW1nQU91UDk1WUNGVjlyQmw4c2xn?=
 =?utf-8?B?c292REwwQnozRXQzdWZMR0VCVzkrMjhwalJPV2c5dW1qd3poczhEZGZFMFRv?=
 =?utf-8?B?b29WRGFwbmZDekd5V0NTd0xlbC9pRTVrallPaGlRRnRReExOKzhzN1Zaenhx?=
 =?utf-8?B?YWtoUGx4Nk4wcGtPcGhVYkJidjI5Z01ISUZVREk5YkxldGVxLzBSbmJFWVVJ?=
 =?utf-8?B?M3pRL3Q2ODlRUWlKSU1NdWRJMTVPcE0zZ3lxazBsaWI2ZTdXTGN6Q0xkUEQ3?=
 =?utf-8?B?Qy9mR2FMQUZMNmJ3SktQdGl6TUdFem04ZFZlYkpSRkU4WEhWSVNzTmlScUNV?=
 =?utf-8?B?T05mQzhCcmtKR1p3eko1aTVpMS9SRnNoWGp5THM2RkN6NkV1a0RyT0ZsUUtt?=
 =?utf-8?B?N1BzdWRhOTg1QnAyZmdRQ0RLY09QOWtQOHM2TmVWZFFzNitQdHpCRVN3bHBZ?=
 =?utf-8?B?U0RRb1YzSE11czhjSDZOM3hqS2pUeHBEdWZLUXJhZWFtYzVzaVhMR21UYzRt?=
 =?utf-8?B?RXQvMGdpM2FVd29CTzRrVnpLK2xDa1lrUTRER1VlakIxVzc5aG5rdEJyaHJQ?=
 =?utf-8?B?dFBMQUtrdGdTTGNGZE1aREVuVW55SnZJaWtMM0ZDMjNqdFhJQ1JjakJhMWp6?=
 =?utf-8?B?YUlocjJRYWp6a2RZWnBVUkdBbWlPUDAvSHQ2UStET0Y4bGt4VC9qc25Fc2dH?=
 =?utf-8?B?WTJmSVRHaUZaS1pkUTBjYmk0bk9jNGdCaWZIN3N0ajBtUUYwZ2VjYTkvZVcv?=
 =?utf-8?B?NVltVGVucjB0S3pHWmtnNDlsL2hVbjBCbVpGcFljL3pvenhVQTlPdVFxV05n?=
 =?utf-8?B?R2h0RzRpSXFyTmhnWU54U24xN0gxb2dsTkNaaXFYVFh4WkZrbXNqdzNPU0g0?=
 =?utf-8?B?N3RMUkxSUUpwYldtRzljT3NFODdQVlExK3ZxU2FwNzZkRE45c2x2dURtTjB5?=
 =?utf-8?B?blc1MlUxYTU3b01uTUs0M3BKZ0tuUjIyZ1htbytzMVRURS9maXNESDVuZHNE?=
 =?utf-8?B?V1BiWUZaWElBQmN3SFdySHJ0N3o5SThkYzBpcFZ3V0pxR3dPaGlkNTBtYVRI?=
 =?utf-8?B?VGduMzRzRnY1cVJzMmNjOUdxV1M3dnVwT3NMVzN5bEk0ZElhejJybERTV3JS?=
 =?utf-8?B?YXlLSnhGS2FpMU5OSkpOQjFDbHBibUo1SENZa0dVUUt1b0MxRmdJdW1UZmpo?=
 =?utf-8?B?dUhhQWdBT25Nc21TU0V0czNUcDZTS0wrd1pFb0s1MllVUTNZdUJBbkFKbFdQ?=
 =?utf-8?B?dG1sdmdvUmhtM3lsaXBtc0lVZUhSUWpHaVBia211djc0MVoycXZEdEt6alRW?=
 =?utf-8?Q?lEFCbqDDsqIQe3nI8gk04JCS/0DuPbbo062JBWQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B902FC6312871B41846CE335B54450D3@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR13MB4733.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88101b1e-c700-4661-9253-08d8faa7be9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 16:02:43.6511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2okwDh8B0aeh0LAHOLwI2FHlSLYHA7qyPrapMRsOAoRC87bEKzdHjPGR3rGXEL54qz+JwOS4u+DMU7HvIVXSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA0LTA4IGF0IDExOjI0IC0wNDAwLCBPbGdhIEtvcm5pZXZza2FpYSB3cm90
ZToNCj4gT24gVGh1LCBBcHIgOCwgMjAyMSBhdCAxMTowMSBBTSBUcm9uZCBNeWtsZWJ1c3QgPA0K
PiB0cm9uZG15QGhhbW1lcnNwYWNlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gVHVlLCAyMDIx
LTA0LTA2IGF0IDE5OjE2IC0wNTAwLCBBZGl0eWEgUGFra2kgd3JvdGU6DQo+ID4gPiBJbiBnc3Nf
cGlwZV9kZXN0cm95X21zZygpLCBpbiBjYXNlIG9mIGVycm9yIGluIG1zZywNCj4gPiA+IGdzc19y
ZWxlYXNlX21zZw0KPiA+ID4gZGVsZXRlcyBnc3NfbXNnLiBUaGUgcGF0Y2ggYWRkcyBhIGNoZWNr
IHRvIGF2b2lkIGEgcG90ZW50aWFsDQo+ID4gPiBkb3VibGUNCj4gPiA+IGZyZWUuDQo+ID4gPiAN
Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFkaXR5YSBQYWtraSA8cGFra2kwMDFAdW1uLmVkdT4NCj4g
PiA+IC0tLQ0KPiA+ID4gwqBuZXQvc3VucnBjL2F1dGhfZ3NzL2F1dGhfZ3NzLmMgfCAzICsrLQ0K
PiA+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL2F1dGhfZ3NzL2F1dGhfZ3NzLmMN
Cj4gPiA+IGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9hdXRoX2dzcy5jDQo+ID4gPiBpbmRleCA1ZjQy
YWE1ZmM2MTIuLmViNTJlZWJiMzkyMyAxMDA2NDQNCj4gPiA+IC0tLSBhL25ldC9zdW5ycGMvYXV0
aF9nc3MvYXV0aF9nc3MuYw0KPiA+ID4gKysrIGIvbmV0L3N1bnJwYy9hdXRoX2dzcy9hdXRoX2dz
cy5jDQo+ID4gPiBAQCAtODQ4LDcgKzg0OCw4IEBAIGdzc19waXBlX2Rlc3Ryb3lfbXNnKHN0cnVj
dCBycGNfcGlwZV9tc2cNCj4gPiA+ICptc2cpDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHdhcm5fZ3NzZCgpOw0KPiA+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGdzc19yZWxlYXNlX21zZyhnc3NfbXNnKTsNCj4gPiA+IMKgwqDC
oMKgwqDCoMKgIH0NCj4gPiA+IC3CoMKgwqDCoMKgwqAgZ3NzX3JlbGVhc2VfbXNnKGdzc19tc2cp
Ow0KPiA+ID4gK8KgwqDCoMKgwqDCoCBpZiAoZ3NzX21zZykNCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGdzc19yZWxlYXNlX21zZyhnc3NfbXNnKTsNCj4gPiA+IMKgfQ0KPiA+
ID4gDQo+ID4gPiDCoHN0YXRpYyB2b2lkIGdzc19waXBlX2RlbnRyeV9kZXN0cm95KHN0cnVjdCBk
ZW50cnkgKmRpciwNCj4gPiANCj4gPiANCj4gPiBOQUNLLiBUaGVyZSdzIG5vIGRvdWJsZSBmcmVl
IHRoZXJlLg0KPiANCj4gSSBkaXNhZ3JlZSB0aGF0IHRoZXJlIGlzIG5vIGRvdWJsZSBmcmVlLCB0
aGUgd29yZGluZyBvZiB0aGUgY29tbWl0DQo+IGRlc2NyaWJlcyB0aGUgcHJvYmxlbSBpbiB0aGUg
ZXJyb3IgY2FzZSBpcyB0aGF0IHdlIGNhbGwNCj4gZ3NzX3JlbGVhc2VfbXNnKCkgYW5kIHRoZW4g
d2UgY2FsbCBpdCBhZ2FpbiBidXQgdGhlIDFzdCBvbmUgcmVsZWFzZWQNCj4gdGhlIGdzc19tc2cu
IEhvd2V2ZXIsIEkgdGhpbmsgdGhlIGZpeCBzaG91bGQgcHJvYmFibHkgYmUgaW5zdGVhZDoNCj4g
ZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMvYXV0aF9nc3MvYXV0aF9nc3MuYw0KPiBiL25ldC9zdW5y
cGMvYXV0aF9nc3MvYXV0aF9nc3MuYw0KPiBpbmRleCA1ZjQyYWE1ZmM2MTIuLmU4YWFlNjE3ZTk4
MSAxMDA2NDQNCj4gLS0tIGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9hdXRoX2dzcy5jDQo+ICsrKyBi
L25ldC9zdW5ycGMvYXV0aF9nc3MvYXV0aF9nc3MuYw0KPiBAQCAtODQ2LDcgKzg0Niw3IEBAIGdz
c19waXBlX2Rlc3Ryb3lfbXNnKHN0cnVjdCBycGNfcGlwZV9tc2cgKm1zZykNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdzc191bmhhc2hfbXNnKGdzc19tc2cpOw0KPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1zZy0+ZXJybm8gPT0gLUVUSU1FRE9VVCkNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB3YXJuX2dzc2Qo
KTsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ3NzX3JlbGVhc2VfbXNnKGdzc19t
c2cpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZ3NzX3JlbGVhc2Vf
bXNnKGdzc19tc2cpOw0KPiDCoMKgwqDCoMKgwqDCoCB9DQo+IMKgwqDCoMKgwqDCoMKgIGdzc19y
ZWxlYXNlX21zZyhnc3NfbXNnKTsNCj4gwqB9DQo+IA0KUGxlYXNlIGxvb2sgb25lIGxpbmUgZnVy
dGhlciB1cDogdGhlcmUgaXMgYSByZWZjb3VudF9pbmMoKSB0aGF0IG1hdGNoZXMNCnRoYXQgZmly
c3QgZ3NzX3JlbGVhc2VfbXNnKCkuIFJlbW92aW5nIHRoYXQgY2FsbCByZXN1bHRzIGluIGENCnJl
aW50cm9kdWN0aW9uIG9mIHRoZSBsZWFrIHRoYXQgTmVpbCBmaXhlZCBpbiBjb21taXQgMWNkZWQ5
ZDI5NzRmZQ0KKCJTVU5SUEM6IGZpeCByZWZjb3VudGluZyBwcm9ibGVtcyB3aXRoIGF1dGhfZ3Nz
IG1lc3NhZ2VzLiIpLg0KDQpXZSBtaWdodCwgaG93ZXZlciwgaW5zdGVhZCBvcHQgdG8gcmVtb3Zl
IGJvdGggdGhlIHJlZmNvdW50X2luYygpIGFuZA0KbWF0Y2hpbmcgZ3NzX3JlbGVhc2VfbXNnKCku
IFRob3NlIGRvIHNlZW0gdG8gYmUgcmVkdW5kYW50LCBnaXZlbiB0aGF0DQp0aGUgY2FsbGVyIGFs
c28gaG9sZHMgYSByZWZjb3VudC4NCg0KPiA+IA0KPiA+IC0tDQo+ID4gVHJvbmQgTXlrbGVidXN0
DQo+ID4gTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1tZXJzcGFjZQ0KPiA+IHRyb25k
Lm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCj4gPiANCj4gPiANCg0KLS0gDQpUcm9uZCBNeWts
ZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15
a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
