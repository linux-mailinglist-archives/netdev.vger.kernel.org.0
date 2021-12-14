Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E24743B6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhLNNnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:43:45 -0500
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com ([104.47.55.173]:24809
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhLNNnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 08:43:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQdAx3tQ40Hi+i9PWt6/fbRpJxxOJsa87zZf5bF/aWzELat6pCV/gu7Ws/faEAgl+n0qqkEsPXwPqgGOWvaBHO2WFs9gTe/JpTmhAKMtWaYMdUQzE9EwcX+Hgz1OiPXltO6QF9t6t+lQxlwQ7RPJ0az4URVOLR2EE6VyCa6/n3HDw63wKyT/bgleFv9RSlvUbREHGEiO6OA6N8i+ZDZJ/otuqUq020M45gtlvdvwa+J4Jd/yWpIbx1nZ8lGGUOR6hYsImNraN3tfMUyi7a8AA3OuPINP96EVEJPNA4V8ix5X6OZUiMFzHqrK/H+eivjd6LFf2e/FbORkwCuS8OOSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SDMOWKK1itj4/aSrwjkNJYohJGllW+vzuL7c4jHaKs=;
 b=cR9+EwbzToEVMS/wlo2Sh34VSdIZPhVwrW97Y1/tifCdBTuSdzGOvNMU6sG1Y5BOf0l1u9seZcgKp8tZ4snwjMuIzU8rFJDOkiim+NBpWbbzIZx7+xz0K2NditlpgVdEUpgia1xcGYezJUxMMaOv4PdVZBSPgj+i3LK+uYvA4Ay6IHtz1kRS6sTYkhdP6egyAvov0JB4nsONepx3sEems6CWJjKdFmp9Smzz6AY7b/RswSC2HnOdKxR1/ZTZOJgCar+siD3biMMv2LMCpQdUvNc/FM5OAq9EjobfkZ+X2G2wP/gL1K14aiyGw+G2e+LR3IRD5JEqo49tJ+ZvKfeXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SDMOWKK1itj4/aSrwjkNJYohJGllW+vzuL7c4jHaKs=;
 b=j+kJ9B7I4uV7Vrp1YK5TqOcfrA5JzCkFmWVSInaTj0BoQRomJB1uxzd+hciE8Mlh056Rh2c57f9snmjEDQy1MY5xfUKgjVmG1XLG7qcYa3VNPoqFW+o6u2VCtWFHV8rrpWmxDoeufb+IqW4DPqEzNJQnwfcC9ZtGTC5GXtYle70=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DS7PR13MB4607.namprd13.prod.outlook.com (2603:10b6:5:297::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.13; Tue, 14 Dec
 2021 13:43:43 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Tue, 14 Dec 2021
 13:43:43 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Thread-Topic: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Thread-Index: AQHX7N8rxbSjY0IJLEePq/ca2Cw9Kawtt2mAgADaTQCAA1kigIAAFfeg
Date:   Tue, 14 Dec 2021 13:43:43 +0000
Message-ID: <DM5PR1301MB2172C97E25E66520DEC901CFE7759@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-9-simon.horman@corigine.com>
 <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
 <DM5PR1301MB2172002C966B5CC41EA6537AE7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <4a909bf2-a7a1-67f9-2d62-d6858d3553b9@mojatatu.com>
In-Reply-To: <4a909bf2-a7a1-67f9-2d62-d6858d3553b9@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d1179b4-fa7f-4095-dd2f-08d9bf07bea1
x-ms-traffictypediagnostic: DS7PR13MB4607:EE_
x-microsoft-antispam-prvs: <DS7PR13MB4607D55E6FC785267B447F9FE7759@DS7PR13MB4607.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cHlqEnn62KIrGFAGy/g6sGNVegyDrFWSY60dLvMmviaKhQm0Q60IvtTl/k79OpKcdvF1+5EDKYpQkTpHYKov62hmcch3W5f9xP9NpuAEH2bOw6BCF9qTphh4PHxJgz2u79AOiFJfOtfNNeIyoy2XzxzpEY+HpguIdSO+DBIamN4O1N9SLz5djFvrp5Vzx814y/XgAZb5nO1sHivEuz2ASBhhNjSeKfsG4q0gK8YsjLeVYS144h8hnK1QGrWzm8B8O6lvI24XTErYtXgsuSmnoOR71NanNaqfnx9L7DWHExRQjZWEXb9Pr/SbaABHmRKq+o10Vupoj5yGHQ8bH5dSJKViHNR6vHVs5ceC2Osh/GVvjM+d26jfGSerHAP3nVwG5qRl+35xyzdFsn04tOLPVZgArIa8iiSqodwgIsg5n5BgsFm5+hdHY7iWe93XZkmpikMez3xzBZChon5Wce5eenSEeT0+502FV+rIytpUEpeUUUM/BNBdc1gxvoJe06GjCKTgVbJg0IUeaNnXLkn+9cQSgXmMrfidWT1cjJ7T01fMqkkU7YEY2uxIebGyuK+IlZnLMu3eJZMjljtODTZDgoz/l+ZoOITg4wVguGajLZMfkclzlvmBkAd8XoqvKIEFKnadz+4fTLvJyJT5TZxTUgKkw9Dcb0I1BiiCQa0ls3F8i8oZNHfqne3ieeg2wtILcmfX4Ja3yERDWpFobfvY1Um1X+4hX9XQmsQus63zXnvqsTKkGoC4dyUKpRY1Om9p
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39840400004)(376002)(396003)(366004)(38100700002)(122000001)(76116006)(66476007)(66446008)(64756008)(4326008)(66946007)(54906003)(508600001)(8676002)(66556008)(86362001)(186003)(110136005)(316002)(26005)(8936002)(38070700005)(53546011)(83380400001)(6506007)(2906002)(9686003)(44832011)(4001150100001)(15650500001)(7696005)(71200400001)(5660300002)(107886003)(52536014)(55016003)(33656002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGZ5cVA4dUFuWWdqV0ZlMVNQMjduemU5NVlUY2tlODF1UkNmdFRPUURKcWds?=
 =?utf-8?B?TlRaV05kNnpLYjRHVEZ2VXlJZWJudjBMRGVqaVNVWHB6NDc3cWVuUitFM0Zq?=
 =?utf-8?B?Q2VTTUpkQ0w5WEtVcnltUWZvYlN3RFpXaDRiQ1RhZWdPeDhzOXpYMDRSY3Iy?=
 =?utf-8?B?YjRndS9LNW03RzNocXpXMFNFT1RDOGh3ZjFrZTNROHRJbGtZRVAzbjZna1c3?=
 =?utf-8?B?ZFp6Vjg3ZnBKOXdxeUROamRORzlpWUEwMCtSRW4xaHRBSmZZdzMzRU9ueUg3?=
 =?utf-8?B?RmFhVURpdjNpK2F2dGNkWHE3eDh4emp6SWQ1NWlLZUZhdU0wSE5wK0swd3Ro?=
 =?utf-8?B?NkFDb2NvS1RlbGM3cDJaMlU0Q2FkMDd6NzFyYlF3NTBIOEdSdnpNUG02Wm5F?=
 =?utf-8?B?cFlDYnZiQmlFZzJnMTMwNlA1cDVlcmU0TS9UZTRsaElERWVKVUU5NEVnU252?=
 =?utf-8?B?ckp0M3lQTTZRT0pRYVdFT1lNeVlQYWIyN0lHSmZlNG81ZFFDOEN6TFUzdkF3?=
 =?utf-8?B?K1owb1g2QTg0cFc3aGk2OUk4RmhNNldtaGlhajBhQlErc2xmLzd2alY5S0Mx?=
 =?utf-8?B?bHAwQkNrbFA5c2p2d2xaam1BRy9raFlxSTR4d09sZVpzSnVzeXl1dHZ3aUJK?=
 =?utf-8?B?QWV2ZVM5N3NRVlBKeGV2LzRUYmVqNWlzQmdZRUpsSTRTV3NsTks0ZE5mWjd4?=
 =?utf-8?B?aE9JNjlSK2pZRTUxTlpmRVNjeUROdmwyeVFIdVUrU2ZxT2FrRW9LaDNTRVl5?=
 =?utf-8?B?ejdNblNSR1BnbVVnZVZUdGVsTHZSdDNYcnl1RXJ1SUZEenFydzNoZHlnNzZX?=
 =?utf-8?B?ZWNqUDV4U2hNT1loRkxiSG9aZzdTVnpMYWdJUThCWEFZSlJzQUhBVzRNS3l1?=
 =?utf-8?B?cXR1MXpRM3prc1lweEJzcGZBQXJiWHJjNjlpUVZkZXY0aHlFKys5QW0rbGlK?=
 =?utf-8?B?N2ZsUWF1ZmV0YjBUZC9LTEdBQXE5aDFhM01COFQwSTI2RmN6VDBPNnBQYXU3?=
 =?utf-8?B?VnQrcitLYVB4T3V0THgyVzRKWDlTd2JyQWFPd3ZoRUFXL2RSeUxreTR5bnll?=
 =?utf-8?B?NGtKUFgwU2E4R2VYc2FWVlRPQ0lNMTZzenE2ekdXbk44WUVwbVM2Zk1GY204?=
 =?utf-8?B?SHhXcGNYQ2ErVXZGUS90Tm9rdWg5T0g1T0Q4bElFYzNVQUJ6Ti85aDR4Z25q?=
 =?utf-8?B?Y05lNkd3MWRBazRIbXQ1bjRmVVBoaWdIN2VHazdnYWJmTWNiaThpRWI2NDdP?=
 =?utf-8?B?LzJJdDZqN05BZ1ZDdk9lZGxlb2s1d3ZWYlBKcXJLYXFzeG5ubUR2WVBuT2lS?=
 =?utf-8?B?QWFnY1lKbWowdHp3djVKYk1oMWp1cUd0Rk9PNi9rQkVDUWgxMzFTczNjZjZz?=
 =?utf-8?B?ajcxTTBHdHcyNHQyK0l3cUpZQzZEYStDcDJCWEEzQTRHQ21UTkJQRXJreW9B?=
 =?utf-8?B?blZESFNyYmZkWjkzQzZCOEZRSW9rUWtUWi9na2w0T29PblphVEJXcC9LMlpo?=
 =?utf-8?B?VG1xR1ZCQnRnUnNKNjlMT2VwMnN3M09LRTZEOTYvekFSQndldHFqYXdLTVYw?=
 =?utf-8?B?UWdGSmg2K0Q0elJ0QmhDeUIxcVNuWnZCK2VNNmp1TVEyd1FOT3U0VUNQRFpq?=
 =?utf-8?B?dXc1dmZ2U1ROYncwTmpTR1N3LytXQlVzL3N5SVVtMjhrN3FCdXlnaGM0MWZN?=
 =?utf-8?B?WDNkOVk2TFJCTDdHN2ZPbExlb1oxVTR0Z1lsVFFGK1gwajNFWVpSNHVvUWFr?=
 =?utf-8?B?L0wwSGpKVWM4bG1Ody85ZGRpNEY3TEEzREtZcjFPa2FUOXR3MmhVNlY1SkJW?=
 =?utf-8?B?S1ZmYU04VjVZTUZGM3dqM2ZCOGNVMGRUNkVXM3RBYkpsMStmNmtLVVNra2tW?=
 =?utf-8?B?Yis5SlBpcEpGaGVkbU0zR0tGWGdNakNlaWk4U0haeC95aURSekI0eDhBRmhT?=
 =?utf-8?B?WkxkUnNWTFhhUjQ5M1EzMzdBNDlrVlgwQXl6NW5wUnIvSjhPcGdLeFJZRHp3?=
 =?utf-8?B?TjRZVXQ2dmVYdjlvY1RGQmNVYWsxZHZqZzhGUVVOVFhnUUNIRmpNK25iSnRo?=
 =?utf-8?B?Qm9XcVY4MXgzMWpIVUlHRyt0bnRxYk43amdESDA5ZVRodE5jZjBEdUZudHZV?=
 =?utf-8?B?TzNNb2s1SEU1UkZmSHJSZ1d3R3VyRitNSmo5dXhvZTJQMzZ3S3ZSMkttOTQw?=
 =?utf-8?B?VFBUb21jb2N4bEJSNjcrTlhGR0R3eWxoVXpVVHg3KzRuK2FZV3N4UTFNYWUz?=
 =?utf-8?B?WlBKc3k2aDJxaXdLYzE2Z29iMGZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1179b4-fa7f-4095-dd2f-08d9bf07bea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 13:43:43.2441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85G16wVd0VAnkHa7A/patdcl3NRr0dnpugrL4oXQVpXnleO5aS/V+ksbhfKnMrqdAb0JYb0DffNOt0jW9HAnzf+DIXrV7wQGFyIq/XfeWJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4607
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTQsIDIwMjEgODowMSBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTEyIDA0OjAwLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBPbiBEZWNlbWJlciAx
MiwgMjAyMSAzOjUyIEFNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPj4+IE9uIDIwMjEtMTIt
MDkgMDQ6MjgsIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4+Pj4gaW5jbHVkZS9uZXQvYWN0X2FwaS5o
IHwgIDEgKw0KPj4+PiAgICBpbmNsdWRlL25ldC9wa3RfY2xzLmggfCAxOCArKysrKysrKysrLS0t
LS0tLS0NCj4+Pj4gICAgbmV0L3NjaGVkL2FjdF9hcGkuYyAgIHwgMzQgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPj4+PiAgICAzIGZpbGVzIGNoYW5nZWQsIDQ1IGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9hY3RfYXBpLmggYi9pbmNsdWRlL25ldC9hY3RfYXBpLmggaW5kZXgNCj4+Pj4gN2U0ZTc5YjUw
MjE2Li5jZTA5NGU3OWY3MjIgMTAwNjQ0DQo+Pj4+IC0tLSBhL2luY2x1ZGUvbmV0L2FjdF9hcGku
aA0KPj4+PiArKysgYi9pbmNsdWRlL25ldC9hY3RfYXBpLmgNCj4+Pj4gQEAgLTI1Myw2ICsyNTMs
NyBAQCB2b2lkIHRjZl9hY3Rpb25fdXBkYXRlX3N0YXRzKHN0cnVjdCB0Y19hY3Rpb24NCj4+Pj4g
KmEsDQo+Pj4gdTY0IGJ5dGVzLCB1NjQgcGFja2V0cywNCj4+Pj4gICAgCQkJICAgICB1NjQgZHJv
cHMsIGJvb2wgaHcpOw0KPj4+PiAgICBpbnQgdGNmX2FjdGlvbl9jb3B5X3N0YXRzKHN0cnVjdCBz
a19idWZmICosIHN0cnVjdCB0Y19hY3Rpb24gKiwNCj4+Pj4gaW50KTsNCj4+Pj4NCj4+Pj4gK2lu
dCB0Y2ZfYWN0aW9uX3VwZGF0ZV9od19zdGF0cyhzdHJ1Y3QgdGNfYWN0aW9uICphY3Rpb24pOw0K
Pj4+PiAgICBpbnQgdGNmX2FjdGlvbl9jaGVja19jdHJsYWN0KGludCBhY3Rpb24sIHN0cnVjdCB0
Y2ZfcHJvdG8gKnRwLA0KPj4+PiAgICAJCQkgICAgIHN0cnVjdCB0Y2ZfY2hhaW4gKipoYW5kbGUs
DQo+Pj4+ICAgIAkJCSAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqbmV3Y2hhaW4pOyBkaWZm
IC0tZ2l0DQo+Pj4+IGEvaW5jbHVkZS9uZXQvcGt0X2Nscy5oIGIvaW5jbHVkZS9uZXQvcGt0X2Ns
cy5oIGluZGV4DQo+Pj4+IDEzZjBlNGEzYTEzNi4uMTk0MmZlNzJiM2UzIDEwMDY0NA0KPj4+PiAt
LS0gYS9pbmNsdWRlL25ldC9wa3RfY2xzLmgNCj4+Pj4gKysrIGIvaW5jbHVkZS9uZXQvcGt0X2Ns
cy5oDQo+Pj4+IEBAIC0yNjksMTggKzI2OSwyMCBAQCB0Y2ZfZXh0c19zdGF0c191cGRhdGUoY29u
c3Qgc3RydWN0IHRjZl9leHRzDQo+KmV4dHMsDQo+Pj4+ICAgICNpZmRlZiBDT05GSUdfTkVUX0NM
U19BQ1QNCj4+Pj4gICAgCWludCBpOw0KPj4+Pg0KPj4+PiAtCXByZWVtcHRfZGlzYWJsZSgpOw0K
Pj4+PiAtDQo+Pj4+ICAgIAlmb3IgKGkgPSAwOyBpIDwgZXh0cy0+bnJfYWN0aW9uczsgaSsrKSB7
DQo+Pj4+ICAgIAkJc3RydWN0IHRjX2FjdGlvbiAqYSA9IGV4dHMtPmFjdGlvbnNbaV07DQo+Pj4+
DQo+Pj4+IC0JCXRjZl9hY3Rpb25fc3RhdHNfdXBkYXRlKGEsIGJ5dGVzLCBwYWNrZXRzLCBkcm9w
cywNCj4+Pj4gLQkJCQkJbGFzdHVzZSwgdHJ1ZSk7DQo+Pj4+IC0JCWEtPnVzZWRfaHdfc3RhdHMg
PSB1c2VkX2h3X3N0YXRzOw0KPj4+PiAtCQlhLT51c2VkX2h3X3N0YXRzX3ZhbGlkID0gdXNlZF9o
d19zdGF0c192YWxpZDsNCj4+Pj4gLQl9DQo+Pj4+ICsJCS8qIGlmIHN0YXRzIGZyb20gaHcsIGp1
c3Qgc2tpcCAqLw0KPj4+PiArCQlpZiAodGNmX2FjdGlvbl91cGRhdGVfaHdfc3RhdHMoYSkpIHsN
Cj4+Pj4gKwkJCXByZWVtcHRfZGlzYWJsZSgpOw0KPj4+PiArCQkJdGNmX2FjdGlvbl9zdGF0c191
cGRhdGUoYSwgYnl0ZXMsIHBhY2tldHMsIGRyb3BzLA0KPj4+PiArCQkJCQkJbGFzdHVzZSwgdHJ1
ZSk7DQo+Pj4+ICsJCQlwcmVlbXB0X2VuYWJsZSgpOw0KPj4+Pg0KPj4+PiAtCXByZWVtcHRfZW5h
YmxlKCk7DQo+Pj4+ICsJCQlhLT51c2VkX2h3X3N0YXRzID0gdXNlZF9od19zdGF0czsNCj4+Pj4g
KwkJCWEtPnVzZWRfaHdfc3RhdHNfdmFsaWQgPSB1c2VkX2h3X3N0YXRzX3ZhbGlkOw0KPj4+PiAr
CQl9DQo+Pj4+ICsJfQ0KPj4+PiAgICAjZW5kaWYNCj4+Pj4gICAgfQ0KPj4+DQo+Pj4gU29ycnkg
LSBkaWRudCBxdWlldCBmb2xsb3cgdGhpcyBvbmUgZXZlbiBhZnRlciByZWFkaW5nIHRvIHRoZSBl
bmQuDQo+Pj4gSSBtYXkgaGF2ZSBtaXNzZWQgdGhlIG9idmlvdXMgaW4gdGhlIGVxdWl2YWxlbmNl
Og0KPj4+IEluIHRoZSBvbGQgY29kZSB3ZSBkaWQgdGhlIHByZWVtcHQgZmlyc3QgdGhlbiBjb2xs
ZWN0LiBUaGUgY2hhbmdlZA0KPj4+IHZlcnNpb24gb25seSBkb2VzIGl0IGlmIHRjZl9hY3Rpb25f
dXBkYXRlX2h3X3N0YXRzKCkgaXMgdHJ1ZS4NCj4+IEhpIEphbWFsLCBmb3IgdGhpcyBjaGFuZ2Us
IHRoaXMgaXMgYmVjYXVzZSBmb3IgdGhlIGZ1bmN0aW9uIG9mDQo+PiB0Y2ZfYWN0aW9uX3VwZGF0
ZV9od19zdGF0cywgaXQgd2lsbCB0cnkgdG8gcmV0cmlldmUgaHcgc3RhdHMgZnJvbiBoYXJkd2Fy
ZS4NCj5CdXQgaW4gaGUgcHJvY2VzcyBvZiByZXRyaWV2aW5nIHN0YXRzIGluZm9ybWF0aW9uLCB0
aGUgZHJpdmVyIG1heSBoYXZlIExvY2sgb3INCj5vdGhlciBzbGVlcGluZyBmdW5jdGlvbi4gU28g
d2Ugc2hvdWxkIG5vdCBjYWxsIHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzDQo+ZnVuY3Rpb24g
aW4gY29udGV4dCBvZiBwcmVlbXB0X2Rpc2FibGUuDQo+DQo+U3RpbGwgY29uZnVzZWQgcHJvYmFi
bHkgYmVjYXVzZSB0aGlzIGlzIG9uZSBvZiB0aG9zZSBmdW5jdGlvbnMgdGhhdCBhcmUgYmFkbHkN
Cj5uYW1lZC4gSW5pdGlhbGx5IGkgdGhvdWdodCB0aGF0IGl0IHdhcyB1c2VmdWwgdG8gY2FsbCB0
aGlzIGZ1bmN0aW9uIGZvciBib3RoDQo+b2ZmbG9hZGVkIHZzIG5vbi1vZmZsb2FkZWQgc3RhdHMu
IEJ1dCBpdCBzZWVtcyBpdCBpcyBvbmx5IHVzZWZ1bCBmb3IgaHcNCj5vZmZsb2FkZWQgc3RhdHM/
IElmIHNvLCBwbGVhc2UgY29uc2lkZXIgYSBwYXRjaCBmb3IgcmVuYW1pbmcgdGhpcyBhcHByb3By
aWF0ZWx5DQo+Zm9yIHJlYWRhYmlsaXR5Lg0KWWVzLCBpdCBpcyBvbmx5IGZvciBodyBvZmZsb2Fk
IHN0YXRzIGFuZCBpcyB1c2VkIHRvIHN5bmMgdGhlIHN0YXRzIGluZm9ybWF0aW9uIGZyb20gdGhl
DQpPZmZsb2FkZWQgZmlsdGVyIHRvIHRoZSBhY3Rpb25zIHRoZSBmaWx0ZXIgcmVmZXJyZWQgdG8u
DQoNCldlIHdpbGwgY29uc2lkZXIgdG8gYWRkIGEgcGF0Y2ggdG8gcmVuYW1lIHRoaXMgZnVuY3Rp
b24gZm9yIHJlYWRhYmlsaXR5Lg0KPg0KPlJlZ2FyZGxlc3MsIHR3byB0aGluZ3M6DQo+DQo+MSkg
SW4gdGhlIG9sZCBjb2RlIHRoZSBsYXN0IHR3byBsaW5lcw0KPisJCQlhLT51c2VkX2h3X3N0YXRz
ID0gdXNlZF9od19zdGF0czsNCj4rCQkJYS0+dXNlZF9od19zdGF0c192YWxpZCA9IHVzZWRfaHdf
c3RhdHNfdmFsaWQ7DQo+aW5zaWRlIHRoZSBwcmVlbXB0IGNoZWNrIGFuZCB3aXRoIHRoaXMgdGhl
eSBhcmUgb3V0c2lkZS4NCj4NCj5UaGlzIGlzIGZpbmUgaWYgdGhlIG9ubHkgcmVhc29uIHdlIGhh
dmUgdGhpcyBmdW5jdGlvbiBpcyBmb3IgaC93IG9mZmxvYWQuDQo+DQo+MikgWW91IGludHJvZHVj
ZWQgdGNmX2FjdGlvbl91cGRhdGVfaHdfc3RhdHMoKSB3aGljaCBhbHNvIGRvZXMgcHJlZW1wdA0K
PmRpc2FibGUvZW5hYmxlIGFuZCBzZWVtcyB0byByZXBlYXQgc29tZSBvZiB0aGUgdGhpbmdzIHlv
dSBhcmUgZG9pbmcgYXMgd2VsbA0KPmluIHRoaXMgZnVuY3Rpb24/DQpBcyBJIG1lbnRpb25lZCBh
Ym92ZSwgdGhlIGZ1bmN0aW9uIG9mIHRjZl9leHRzX3N0YXRzX3VwZGF0ZSBpcyB1c2VkIHRvIHN5
bmMgdGhlIHN0YXRzDQppbmZvcm1hdGlvbiBmcm9tIHRoZSBvZmZsb2FkZWQgZmlsdGVyIHRvIHRo
ZSBhY3Rpb25zIHRoZSBmaWx0ZXIgcmVmZXJyZWQgdG8uDQpUaGVuIHRoZSBuZXcgYWRkZWQgZnVu
Y3Rpb24gdGNmX2FjdGlvbl91cGRhdGVfaHdfc3RhdHMoKSBpcyB1c2VkIHRvIHN5bmMgdGhlIHN0
YXRzDQpJbmZvcm1hdGlvbiBmcm9tIHRoZSBodyBkZXZpY2UgdGhhdCBvZmZsb2FkcyB0aGlzIGFj
dGlvbi4gIFNvIGlmIHRoZSBhY3Rpb24gaXMgb2ZmbG9hZGVkDQp0byBodyBhcyBhIHNpbmdsZSBh
Y3Rpb24sIHRoZW4gaXQgd2lsbCBub3Qgc3luYyB0aGUgc3RhdHMgZnJvbSB0aGUgaHcgZmlsdGVy
Lg0KPg0KPj4gQWN0dWFsbHksIHNpbmNlIHRoZXJlIGlzIG5vIHZlbmRvciB0byBzdXBwb3J0IHVw
ZGF0ZSBzaW5nbGUgYWN0aW9uIHN0YXRzIGZyb20NCj5oYXJkd2FyZSwgc28gaXQgaXMgbm90IG9i
dmlvdXMsIHdlIHdpbGwgcG9zdCBvdXIgaW1wbGVtZW50IHN1cHBvcnQgYWZ0ZXIgdGhlc2UNCj5w
YXRjaGVzIHNldC4NCj4+IERvIHlvdSB0aGluayBpZiBpdCBtYWtlIHNlbnNlPw0KPg0KPlNpbmNl
IHlvdSBwbGFuIHRvIGhhdmUgbW9yZSBwYXRjaGVzOg0KPklmIGl0IGRvZXNudCBhZmZlY3QgeW91
ciBjdXJyZW50IGdvYWxzIHRoZW4gaSB3b3VsZCBzdWdnZXN0IHlvdSBsZWF2ZSBpdCB0byBsYXRl
ci4NCj5UaGUgcXVlc3Rpb24gaXMsIHdpdGggd2hhdCB5b3UgYWxyZWFkeSBoYXZlIGluIHRoaXMg
cGF0Y2hzZXQsIGRvIHdlIGdldA0KPnNvbWV0aGluZyBmdW5jdGlvbmFsIGFuZCBzdGFuZGFsb25l
Pw0KPg0KV2hhdCB3ZSB3aWxsIHBvc3QgbGF0ZXIgdG8gc3VwcG9ydCB1cGRhdGUgc2luZ2xlIGFj
dGlvbiBzdGF0cyBmcm9tIGhhcmR3YXJlIGlzIGNvZGUgZm9yIGRyaXZlciBzaWRlLA0KSXQgd2ls
bCBtYWlubHkgaW1wbGVtZW50IHRoZSBmbG93X29mZmxvYWRfYWN0X2NvbW1hbmQgb2Ygc3RhdHMg
YW4gYWN0aW9uIGZyb20gaHcgaW4gZHJpdmVyLg0KDQpTbyBpIHRoaW5rIGl0IHdpbGwgcHJvcGVy
IHRvIHBvc3QgdGhlIHdob2xlIGZyYW1ld29yayBjb2RlIGluIGFjdF9hcGkgYW5kIGNsc19hcGkg
aW4gdGhpcyBzZXJpZXMuIA0KVGhlbiB3aGVuIHdlIHBvc3QgdGhlIGRyaXZlciBwYXRjaCwgd2Ug
d2lsbCBub3QgbmVlZCB0byBjaGFuZ2UgdGhlIGFjdC9jbHMgaW1wbGVtZW50Lg0KDQpXRFlUPw0K
DQo+Y2hlZXJzLA0KPmphbWFsDQo+DQo+DQo+DQo+DQo+DQo+Pj4gY2hlZXJzLA0KPj4+IGphbWFs
DQoNCg==
