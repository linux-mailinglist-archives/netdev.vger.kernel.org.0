Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4051B67894B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbjAWVPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjAWVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:15:05 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBE37B6D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:15:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCrbAyKGO0vY1ptcY5Y0Dj9gPcroXbYd3PGdJHtY/WisHCW1jdCUK2qLlsDQfyV6PBpU6fFz08aTpVrWylbwddJAgUD+Xe/2ijzRx226DI722Rp4rrt2s53THqYFizfT1rO+Cm6wz9suwfP2Fn61AN/yzf8SqDBpJfcSMqT/EmnuujORkOLlz5LvNLwFOgBqDQ+nee3Ujfx2EXQvLhLGTu/S4GMIO5djK+ugKbnyKzyCrW9WT9cUmqHr8Hi9dcBRlyhJIYfyZF8YzX7JRm6PVuC0BJXVLjQoXEhu1/i4+EAo3j0Xc5AlWOVwIxZ5uxHK7N8jRP8L9myF1+HOgHq/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQEliQxgvlvleKoiKEX1D6c4tJH6kn/531tsI0fugX0=;
 b=ZrSkPR1CQup5MsRMEG2HjCErqMBBIlTOO6cehJVysCXTXnIlkVTqpq94vBoE3t0nxlf2iAwp88bgKUSJlTresxUOvx+nr4nsciMjt7H+kDurzzWwBTuGUHiK8nVh2H6+VDOHfQECAkPAe7vC2CaeawbdrZSYYWG1coBLPMOFDOCmo5jo9qxmkHppmyz3cQWicNxwu1FDeMpC6fz3KBPOcS25Po+wtvh6Ohmo4c6oOIUnWrzwD62gb/iyrKPkXcDCBj5TARoyKp9sJlPSsXFjBWbZhQBYdnju+6mowTGU/6E/7SkK7DUxC1waMpuCv25sN/xVAwqPip2WIXhrsH5nbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQEliQxgvlvleKoiKEX1D6c4tJH6kn/531tsI0fugX0=;
 b=xy39udmgoupLjDwfpaXpYGg4HtwBbV1+g4Nv8jNP4fOAm30C/3336uVe8RX8UTXys7GqEC9UbrScxNNlejZMPCW4S8+7QjrAhpQSZgIGf+XxSacJ+T+OGzrWVYGRk7s740VYy/jcn1Ra7hV5AkSBcwCVRM2mZhafDIz+Z3dXqtMKensgxy5CvTkAX9UFgo0T4OKbuMueevyIXOmWFaBrnOVlD0MdTUEHv8PtvNq0SEtRPuqX7RquzDAnLV5THeLxdAOAuoaedmiNaDFcCRQ0icd9lbTww8xd6WS9BoVHoCm5AnW9AHnOtH2+tKeol31+2QOrkkAT5pZmEWES5+dLng==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AS8PR10MB6102.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:570::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 21:15:01 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9%2]) with mapi id 15.20.6002.028; Mon, 23 Jan 2023
 21:15:01 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "Freihofer, Adrian" <adrian.freihofer@siemens.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: dsa: phy started on dsa_register_switch()
Thread-Topic: dsa: phy started on dsa_register_switch()
Thread-Index: AQHZL1l5u/8UqDcWzUK0y/q7DWBrr66sWksAgAAOoICAABfkgA==
Date:   Mon, 23 Jan 2023 21:15:01 +0000
Message-ID: <a8c1bd9a16ad146e80e4e575441780f5c556d6be.camel@siemens.com>
References: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
         <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com> <Y87ky0q3HWJhxfca@lunn.ch>
In-Reply-To: <Y87ky0q3HWJhxfca@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AS8PR10MB6102:EE_
x-ms-office365-filtering-correlation-id: 3839eaef-50ef-4dff-1704-08dafd86e401
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W1weU2ZhxJsdh2vc6DHTea1uLCOygirOf4XoJFxLhjvFE4YSairpcj+bMK6rbhVzgCU1tdXXRo/JRUe+3cqWvlzbeEnvz3gfoDs1wFZ+gtOxeV5MJJYyrr06ynpISNHwcZPNB0aK+BbG2JnrSTdf4UL4ohBbseBzkbgMoT4DpWbFtnUmjD7Uf9V9HgHCL4nNRMyJqjQXvv+KHPHtmcHwUHOaPTBXsdt/FOw9PAtgM7aNC+dIuR9MeZPwPvXGeHWmB4+/RjZJwgUpU4EtHuUPq1J0Wn/rA8c4qmLluo19lMnpujEpYwiRTGx3xGvcMyXKi9T8ZoGpIJDI7LLtEU5GtWsbpxlQFeY8/4aDucptXm15npXZig9UjB1kDLBQNnRIut8u39jhlo1SxKJdW0UY434Q6cSadcJ/fSDTtHPZk3pLDup3PPrVi3rhdnNtAq8mWAOtAM1VDcIkn1HOh8tNIANqjvTlg+/iuVOtrcJnKYQoih0ZCrE0ZFogIzNJqLmNmfqUnovsWsKkkHxcPg15eorXGpafkn+tknHG0mzZJuOezowyFFNwhNwlaXKQT7KmN9lPe722ZB4UCT6AWk0Dp/o+dYFExgFWcxAW/j12Q/ChMAddvY8Cr0/u6XY0Desp6F7qoiIiHk1u1a38cv8s9TcO8j83FAfsFuZst5zk5cPJRYHDfHGFXmQ5ULV0B4SJLzXSFZmtJk4WDqE9J3v0n8RtUNDGX14+ehzl1Tw5i9kxmp/N+4yRK5pNP9BASFp4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(451199015)(76116006)(91956017)(66946007)(66446008)(66556008)(66476007)(8936002)(8676002)(5660300002)(4326008)(54906003)(110136005)(2906002)(6486002)(316002)(71200400001)(64756008)(478600001)(26005)(186003)(6512007)(6506007)(55236004)(38070700005)(2616005)(82960400001)(38100700002)(122000001)(36756003)(41300700001)(83380400001)(86362001)(15974865002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXU3d05wZWswT25lczQ4R2syRFZodk05b3ZqVmpzelhMR1U1bktlanFoZmFp?=
 =?utf-8?B?UG1WanQ4a2MyWGFtclk4VVltOFNXZW9HckRFMm95LzdUb0gwaThnbXEyeERq?=
 =?utf-8?B?U0RxSEZLOFNKUXBvSHVQRTFjRmE3WWE0YmRpSVErRVV5akJHNXFYRUoveEdH?=
 =?utf-8?B?N3dvcUxDZkEvV0RKaWVlZnRkUnErS3dRTVRXTFN0T2p0Uy9uQ2lJWFl2KzFP?=
 =?utf-8?B?eW1CVDQzaUJ1K2JobWdBaXNSeERMc1lyU3lqRnpxK0FGalV4d1lYc0JDdUFm?=
 =?utf-8?B?YmVHUFVOSHdRNXNWa3hoa0lHeExObHFQd1puTWd4S3ZVeWx0UkUxd3hoLzR1?=
 =?utf-8?B?dXFDaHpyK1ZzYW9SQUc2bnJ0OVY3QStNOVhVSDcvdStXZUtwbGtEUDhFUGxP?=
 =?utf-8?B?cFdwMEplN2NCRVNvWTNuOURlMzN5Q0pzSTB0RVdVY3hNZ0Y1NTJQSVRwK3Nz?=
 =?utf-8?B?R05DSjBVRWw3SEE4eDM3OHlhVUUvZnZBYkVyUEVYZUc4cWlkN3FkaEVHR0NM?=
 =?utf-8?B?eWFjc0pKOG5iNG5paXZFdWhyK2ZrYkU1TXlheEs4akdHRVBKM0hIWHFoY0py?=
 =?utf-8?B?ZlVRRjlQMHljaXpMNTFqZXlVOGFCYXB6YjN3TUxYbUppQ1VBbEo1a3ZkQmpm?=
 =?utf-8?B?S0N5UklsZHp0OFA0T2pmVVZmMDE5WU5DZkdPeXRmYzVWRXhmOVVPSGNYM3dL?=
 =?utf-8?B?SUpSMDRoRlNaMCsyWlJnRWFKSVBCWXUvUlE0Q2xlZmhGSVdHSkpIa09uK2lG?=
 =?utf-8?B?RERUMWVFNXNsSEJFWDk2MHZ3MkttVmxSY1d6QjY2d05sb2h0dEpVRlpBNzRl?=
 =?utf-8?B?ZHYrVEF2UW5TQzJuZ1YyTmlTVzRVdFF3bjRQR0NScFdReUI3Q3dKWE9vU3Iz?=
 =?utf-8?B?SEw1S2V6NHl5ZU01d3ppdWR3RDZ6cFZCdisyOU5WZjRIaEQ2S0FzSmh0VWdI?=
 =?utf-8?B?d3hnUnYrYkxQTU9ZSEVXODFYQmtaSTM0dXNRRHJIdFVnNlVXOURsM1U3VmIx?=
 =?utf-8?B?MkZNYmN4TE00MjRYREFsaVY5SVpoM0hRQ25PL0VuUjB2NVFINmR5ZW8xSWVp?=
 =?utf-8?B?L2NxRFZ1S1l2c2dFSXQwQzJLWENGdlg1RGpvdm1KS3M4UjhxakVQa1RxblF5?=
 =?utf-8?B?c1dzakowNVdiRStMV3FXVzNyU2xPN3hlZkJoUjh5VjlQU1N1dGhrQnV1WGEv?=
 =?utf-8?B?dXpuVEdSWXp6bFdLZVhaYUNuZlFmdnRUNDRqcExoMUJ4RUFXV1lmYVkrWlQr?=
 =?utf-8?B?ajRSOE81ZE05RHROMFNGT3c5eVI4YUV4a3NOSTdEb0I5S3Z2RFh2dnFnM1R4?=
 =?utf-8?B?cGtUU215eGMyYXRrT3lJK0owRmh5MGw0SHFuOUhCQXkxR2lJTGJNbHZRMmVN?=
 =?utf-8?B?U1FENFJUcXVaN2VVWk4xSXZ0b3V3c3Q0ZVBEemNCeC9HYzQrdWJGM2VQSHVx?=
 =?utf-8?B?RVVGcFVKZHpHNVl0R0dyK0pMdFVGcU9YSzZCWnZrOEhETGNSTmtFR0tYN2NO?=
 =?utf-8?B?RDJJTEErWnVQb3pmd2JlNHZyZlNZQ0VBYjNDM1Fadjk1MjJqbC9OREgxTEJR?=
 =?utf-8?B?WW5DeVFwZlI4Z3hma0JpcEwzZHN2eHJ1aFc4anpWcU9DYmJ4Z3kyNHp4YWF0?=
 =?utf-8?B?SVZ2OWRZRHMwNGRQc3U3N1ZreVArZmZzM1BqNUFscXRrRTU1cktSTGZEYnpq?=
 =?utf-8?B?SEZ1OFc1ZTJtbk1OMEg1VmVTaXBFNXBib0VLV0M3R1FBQ0M1a3diUTU5ck1X?=
 =?utf-8?B?eVRjMFZHYTVrZ1l6RitsUUpsd01IMk5hWi9VYVVWcTA2azFxTEx1UVMvTWpG?=
 =?utf-8?B?Qis2Y1pXSTZmMmZ5WGtsY1lTQ0t3N1phNzYzNzhxR3BjTDhabjNIRVdaYUl6?=
 =?utf-8?B?a2lYTjJIb2ZIQVJQei9wQXZCUmQxNnpIcEtpOTFPUzc1TTE5UWlBLzVZcFJE?=
 =?utf-8?B?M0tnTElhSTk4cGFaYWlVbEtncmFxQktpUHRGL1Mrc25nMGovbnpkeVV2ZTFS?=
 =?utf-8?B?WGE2M2ZRRnRNTnJCdDN1aElHN0ZBL1d0OEtWUEw4Q0RPVUVKc0FaY0h3RUVi?=
 =?utf-8?B?Si8xSUh5dk4rY29Dd2JkRldDZUUyVGVMMUxIbXdwVk1Ob1cwb2RGbXpDYTg1?=
 =?utf-8?B?TkZIU0ZUbzhwQ28wNXlPQmRyeElQTjM0U3NDd1k2aW1Rd3VnMVNoa3hsOVFw?=
 =?utf-8?Q?F53UPV3uVTzQWMYR+kdN8bU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9673829A4446024AA0CEA455F2A79264@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3839eaef-50ef-4dff-1704-08dafd86e401
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 21:15:01.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3qUvCVsZ/YHxGgOpihLDIhRn7s/CaRKvDM4Lbk9ye0kgWubQV/9hlhWF6YTce1XTGW0ZpSKhHyxCAvLWPUltaDdXrC5hvpgGE1BfnSBBYY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB6102
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBNb24sIDIwMjMtMDEtMjMgYXQgMjA6NDkgKzAxMDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiBUaGVyZSBhcmUgYSBudW1iZXIgb2YgTUFDcyB3aGljaCBkbyB0aGUgY29u
bmVjdCBpbiB0aGUgcHJvYmUuIEJvdGgNCj4gYXJlDQo+IGNvbnNpZGVyZWQgY29ycmVjdCwgYW5k
IGRvaW5nIGl0IGluIHByb2JlIGhhcyBhZHZhbnRhZ2VzLCBzdWNoIGFzDQo+IGJlaW5nIGFibGUg
dG8gcmV0dXJuIC1FUFJPQkVfREVGRVIgYmVjYXVzZSB0aGUgUEhZIGhhcyBub3QgYXBwZWFyZWQN
Cj4geWV0Lg0KPiANCj4gSXQgc2hvdWxkIGFsc28gYmUgbm90ZWQgdGhhdCBwaHlsaWIgd2lsbCBu
b3QgZXhwbGljaXRseSBkb3duIGEgUEhZDQo+IGR1cmluZyB0aGUgUEhZcyBwcm9iZS4gU28gaWYg
dGhlIFBIWSBpcyBzdHJhcHBlZCB0byBjb21lIHVwIG9uIHBvd2VyDQo+IHVwLCBvciBzb21ldGhp
bmcgZWxzZSBsaWtlIHRoZSBib290bG9hZGVyIHRvIGJyb3VnaHQgaXQgdXAsIGl0IHdpbGwNCj4g
cmVtYWluIHVwLg0KPiANCj4gPiBJIGFtIHNlbnNpdGl2ZSB0byB0aGUgcG93ZXIgbWFuYWdlbWVu
dCBhc3BlY3QgdGhhdCBnZXR0aW5nIHRoZSBQSFkNCj4gPiBhbmQNCj4gPiBFdGhlcm5ldCBsaW5r
IG5lZ290aWF0ZWQgYW5kIHRoZW4gKHJlKW5lZ290aWF0ZWQgc2V2ZXJhbCB0aW1lcw0KPiA+IHRo
cm91Z2ggYQ0KPiA+IHByb2R1Y3RzJyBib290IGN5Y2xlIGlzIGEgd2FzdGUgb2YgZW5lcmd5IGFu
ZCB0b28gbWFueSB0aW1lcyBkbyB3ZQ0KPiA+IGJyZWFrIGFuZA0KPiA+IG1ha2UgdGhlIGxpbmsu
IFRoZSBzZWN1cml0eSBhc3BlY3QsIEkgYW0gbGVzcyBzZW5zaXRpdmUgc2luY2UgdGhlDQo+ID4g
UEhZIGlzIG5vdA0KPiA+IGhvdyBpdCBzaG91bGQgYmUgZW5mb3JjZWQuDQo+IA0KPiBUaGVyZSBh
cmUgYWxzbyBwZW9wbGUgd2hvIGFzIHNlbnNpdGl2ZSB0byB0aGUgdGltZSBpdCB0YWtlcyB0bw0K
PiBlc3RhYmxpc2ggbGluay4gQXV0by1uZWcgdGFrZXMgYXJvdW5kIDEuNSBzZWNvbmRzLiBJbiBz
b21lIGVtYmVkZGVkDQo+IHVzZXMgY2FzZXMsIHRoYXQgY2FuIGJlIGEgbG9uZyB0aW1lLCB0aGV5
IHdhbnQgdG8gYXZvaWQgd2FpdGluZyBmb3INCj4gdGhhdCBieSBzdHJhcHBpbmcgdGhlIFBIWSB0
byBzdGFydCBhdXRvbmVnIG9uIHBvd2VyIG9uLCBzbyBpdCBtaWdodA0KPiBiZQ0KPiByZWFkeSB0
byBnbyBieSB0aGUgdGltZSB1c2Vyc3BhY2UgaWZ1cCdzIHRoZSBpbnRlcmZhY2UuDQo+IA0KPiBJ
biBnZW5lcmFsLCBQSFkgTEVEcyBhcmUgYSB3aWxkIHdlc3QgaW4gTGludXgsIG5vIHdlbGwgZGVm
aW5lZA0KPiBiZWhhdmlvdXIuIFNvIGkgZXhwZWN0IHRoZXJlIGFyZSB0cmFkaXRpb25hbCBOSUNz
IHdob3MgTEVEcyBhcmUgb24NCj4gd2hlbiB0aGUgbGluayBpcyBhZG1pbiBkb3duLg0KDQp0aGFu
ayB5b3UgZm9yIHRoZSBleHBsYW5hdGlvbiENCg0KLS0gDQpBbGV4YW5kZXIgU3ZlcmRsaW4NClNp
ZW1lbnMgQUcNCnd3dy5zaWVtZW5zLmNvbQ0K
