Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAB459DDA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhKWI0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:26:55 -0500
Received: from mail-bn8nam12on2102.outbound.protection.outlook.com ([40.107.237.102]:57185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230334AbhKWI0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 03:26:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxfOn02hXx6/nGQ3aFbgjoS4F7by7YWuDt3rrFzB3OfodbW/cshDJdUtdBL5RP0p4z15bp4RiOm8ecwAWZM1Vma5e6YLf92Q6Q2Gac5uBnbzpD+V46CPvM6PCle95/nPaUe0IknSFcAc06sQSg/7Pdy3aryr19xgcyTxa0qxVw8oHPrOn+UrzVC5yVGOtwdFyeY7P3hfgKWdY2nx7aifvElje8jiPT0m9P/soczz7USsk0KtZUY4dEh9k+pmZpsyzY6etpjMPq/N7YrACDu0PGeSxk6q02RY1TETm54ifK1FyjcukyWzLuQGQmrRwtnZTLY+d+fkpaz1Z8YBjFh2KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9Qx7C1A5iZR8foDDHDRlpQpIyGTSBwXV+PB1KhRWUc=;
 b=Hd1G7KnnbAFHQqQd5uH/8mLD3EOTSU19TDrKZje8oR8eLzBw6ulz2iTJJjgPsTitpCPCB6n0qkCHzhklAZT1/4ixzkFQZa0ojE42e8ABamr1tdxrbg6vL33u6wEKYiwgU0IsmKL/G6vm3Sq9VakCXFM0Ax04k4pVUi8KqVc5mCnRk5ij69L+HcLWxu6tzt2HohaAPe4Of3dMSCuhMRGut/1I+4anPdS2ELGyf9nTuvl4OBaJI3UEdB1fj2nXTGlvIoSx7l1Tf5rCUpRfpNxl15M0TZs4Z7lsIvPa3mmjeGozeaQKesZbCXfSn2ZGghsqayMxlJ/wL6Px4pPmpSFDkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9Qx7C1A5iZR8foDDHDRlpQpIyGTSBwXV+PB1KhRWUc=;
 b=QZk0CQdHvGkj1fvazSQsL+tLdVa0Osh0VG+AJ2tZQux9zRoudHkc+B5Lnt9CY88mpD452OOKoDNlul9By2YLhbAupmNUkfg/IULzQUaT7k5p5LgDo+buColbWDczKqphgwloPy/jWwLw1YxaXBtpjVzgFH8qe7Ba+3i4M/qDd/g=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB2716.namprd13.prod.outlook.com (2603:10b6:5:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Tue, 23 Nov
 2021 08:23:44 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 08:23:44 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Thread-Topic: [PATCH v4 04/10] flow_offload: allow user to offload tc action
 to net device
Thread-Index: AQHX3H1ga5WIPFCaM0W10xbzQpwKhKwPftuAgAFJvqA=
Date:   Tue, 23 Nov 2021 08:23:44 +0000
Message-ID: <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
In-Reply-To: <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6768024-0eed-46bc-5c9a-08d9ae5a9055
x-ms-traffictypediagnostic: DM6PR13MB2716:
x-microsoft-antispam-prvs: <DM6PR13MB27164C6D4154CF7A6D932129E7609@DM6PR13MB2716.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MxZGqr3oMunFDTqZPwFRKLUe/CWB0bqephehf/fRcYCWjByltX0BnDU4yvuLXcWUpT3enjpOjcbrfFPb1r3Saj78+UuJPkYETAsZdO+W3jV8AbsY15EcOyGngneOweK21GzdnGXx4KJY7NDJBQFjIZSfeGOItRn8SQy9no6n9SExNXBDSd8VRH27AEmrq0yQ4R7syfYF+gFqGhGKu/v+73MvsKc7RekskgsUsE8INsl6J3VU8TqnNZE11tp/ADjCldBMv0+bl+AXFZr8d2dU4qCFJd68NTfw+ZXlSSnGZ3UnPRvn8ztWjicHRcFdixkz0X1GXiXZnGoz26MZBCDHyakgH2dRSZQdIh3ExyJXw1+1l6Z3JVEz/I3+rlVnVgxiING3V8RaqB4ticfZnP9n23B2+MpJK61qpOSNx0WjuBah3vrl/Sg81LKBkvvdUVq4GFBT3dSYPDdsanQltELii858WT+lPBoIvjcoE+Eeav6d+8G0Iee9ZqANauKtti0Vgi5xnRpp4W1UyYPsjnbaLz/9BgSBZP4JHLotphHW993IKpLt502wx/IWgfzo7vUKFRBg9Sh5gJ9f/QlI68NSzzzoosi9nl2AEjvQ9nAgM7vPwZwV5+W1h6oJejwzJHYFtgBvfwm+2y8GMZIAbDPLV24hglLTuF03Zn1GRztNJihND/BPzApGpj950JUZiVZ+Vshoz8hw4tdLbXXoewzhmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39830400003)(136003)(346002)(54906003)(110136005)(316002)(44832011)(26005)(9686003)(55016003)(122000001)(38100700002)(52536014)(33656002)(4326008)(76116006)(38070700005)(71200400001)(107886003)(508600001)(86362001)(8936002)(8676002)(66446008)(64756008)(66556008)(66476007)(66946007)(6506007)(5660300002)(7696005)(2906002)(186003)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3VUbklZWklMSUJBVktPRUNDY2MzWURVdHVqdC9xSUc0RDBHb01JVTRiWE8x?=
 =?utf-8?B?VnRQVlVWNUE2a2V5Y3NNSTBWWVdaTWN0QklJdkgwcUh6S0c3amhoeGZsWDk2?=
 =?utf-8?B?Qmo0andHUWxpS3hXU1djVGhWYWp1VTN4SC85N2pGbDJ4aGVjUkc5amFta3hz?=
 =?utf-8?B?U20vakZvak1TelFuakxjM3ZzMUhLUFVnZkozNVo4NjA3T1FzT08vWGtyZjFU?=
 =?utf-8?B?WTFtNmkvaXJvMUlqcnRGaVhCaGRtUEF1QzR4NnVCb2RyNUQ2SllNbHBkUUdS?=
 =?utf-8?B?ODhMQXpEYTVsQzFnREtRNmFWYUVnTXpCMUhqem5FVmtXWGJjaHI0Q204S25s?=
 =?utf-8?B?eXIzYy94QUdpbHBqekVCanVSZmRvMUVZdlFMTk0vTWdIeitZaytDN1ZwSzF0?=
 =?utf-8?B?V1NtcUlvczlRdG10UUJqZlZSelc4dHFKQzJGTVJxaHgwQjZWSDZMWmZXTnpL?=
 =?utf-8?B?SjdLK0UrV2ZmMFpnazlLTE9wTE5MaXZTaTVqZVRidGpsSS9ZVjR3eDNmU09a?=
 =?utf-8?B?ckdwU3VERE5mUGVTVFQzYWt6NG9nL3dwS1puSDEvRmV4UHMyczhnWURxdHZy?=
 =?utf-8?B?ZWJoUVRKbU9kcDVCOTBndzE4K2orUVRLWjgvRmxlOTZESVpodm1zMlBqVmU1?=
 =?utf-8?B?WXhhNU8xeUkxZ0hlWXdEbEhoVzE1Q1FHaDhXOHJraisyVE9OdC9NZEdVT2Q5?=
 =?utf-8?B?ZHNoOHVJb1dxbFhGdlV5T3lYN2ZuNEUveml3TDQ4RGE3K2pCdWMyVStxTXBN?=
 =?utf-8?B?b0E3M0pBMStFZG1qalU0QkdoTzYwYWNOb1Z0bm1nZGx2cDJYQUVRc1FSYi9y?=
 =?utf-8?B?TUo2eS9GdmpZSnd4MlduSHBwVEtkeEJ5YTFXQldLYm9YM2hnWWNNVmtFM1FB?=
 =?utf-8?B?Wkg1enNOdlhBemZZcnAwYi8zRzhUeSs1dVRMeEc4MTJxQmhDaUZBSklZMDVw?=
 =?utf-8?B?dEZEY2haSFlleUVjOVM1NkE1Q0Y1VkQ1bTJ6enRzQzRWaVg2UmFobHN3Wkwr?=
 =?utf-8?B?N0VOeEg0YlVGcnNubFErRnNZS2wweUhaLzNGczFyQmVVSnNPWXU3SWcydXRk?=
 =?utf-8?B?dzZuK29QSlJ0RzA1ckZDT3AyV1BzekVjcVhYd1YrUGRJbFovTTBLUjFNczJZ?=
 =?utf-8?B?NUIybGtaRGtHY0RCSGdpelZ5a2RiQnVaSEg2Z1ZIdU9aYU9lenBCSWV3ck4y?=
 =?utf-8?B?RGNGaUNjUVMzRURJamdudDVhZlpaaXdKc3gydWc3YklkNGluY0RlSlMramhP?=
 =?utf-8?B?Q0FmZGZtaENNOGgzemhDV0JuVTI1SndKa2hzcDNTaWo3YURWZ1gvMys0alVj?=
 =?utf-8?B?Wms5alhsYndPMU9oZjQ2bGp0NmhVcXozdFlJajhQay95amk3Zmw3NkVlREd1?=
 =?utf-8?B?Q2ZRT1JEMllTcTc3bnh4NTBsMnRtNS9ZcGd5WmE0T0d4VFpQMGtuaWlmWXdN?=
 =?utf-8?B?Y25MRC9qTmFVR3VSQWNXa3V0RVlJZVRPODFkS0VUOVJsMjEyMm1IYU1HdHFS?=
 =?utf-8?B?Um92VTg3bStKZ3RTS1FXVHlDUUR0SjJPRVNvWGFCR3FlR0UvcTJaemkvSitR?=
 =?utf-8?B?ZXZHdmdLbyt4Y0wxS3BZSlV0R0R4TVNvOEdUNkM4SG5pcitPSVJCd3VXYjBB?=
 =?utf-8?B?SnhkRjNaR0FXMHlrRVNOY3V4VzFDNlNZa3JLQXNueWU0VDdRZmU2aUNhMFVz?=
 =?utf-8?B?Q0JWQVdNOE1SbWNEK0V1RkM1TWI2bGZiSzVWdVdBbi9UU2loYzBWQTRMV05X?=
 =?utf-8?B?bE1lem9XL09ydExCZitIVG8vakVrazFiajhUVnI4VlVFbmhjeHNPRkIxaHRW?=
 =?utf-8?B?Y096S2pqM0VqbVFUdjBySS9xNDNsTEgzMEJmU2NLWHRocDZiWkhleUhlZzMv?=
 =?utf-8?B?SG9lSUVrNWZlOTY4OTV3dmxyd3FYTGVsZUNJWFdyWUt2UTdSem9RY044eXNT?=
 =?utf-8?B?TVJkeUJON2pOTVF6dWgwL1JnN3k2OENLOHpmWXV1cURRbHBWVkwwMWJIcFdu?=
 =?utf-8?B?enBSVktPYU5RTFpqVERVOTFQeGpjemtkeDQyLzlzZ1gwQ0RsQytlSnFPWkpa?=
 =?utf-8?B?U0JneWlNUVBTTHlOTExZS1ZDMDdNVjN3dnJUSGFEQUhGeFQ5Y1Q3aDQ3VzR3?=
 =?utf-8?B?Q1AvcENYQU5ZMlU4QUc5UzRWRXlnV2ZJSHN4eDhJTUJvV1VKaVNtMk1FRW96?=
 =?utf-8?B?ZWxwZWd6SWgyUEVjRHlWVExSdWlEWlFVeTY5a0xWZmkvTWZxbHZrRG5oQStu?=
 =?utf-8?B?SkZmN0NmeTRveVZ5U0NXZm9mQ013PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6768024-0eed-46bc-5c9a-08d9ae5a9055
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 08:23:44.0489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7ZbzGEwJRiM5lDN3aj4f9L+Vqti11neRC9wN3ODG2jETiHhFOmSdbFD9Av/UgnUOtmwsMDa8HbavgSeBw2qWD4Q9rCIxddAnF5vFbBT19A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMjIsIDIwMjEgODoyNSBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTExLTE4IDA4OjA3LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+DQo+Wy4uXQ0KPg0KPiA+
IC0tLSBhL25ldC9zY2hlZC9hY3RfYXBpLmMNCj4gPiArKysgYi9uZXQvc2NoZWQvYWN0X2FwaS5j
DQo+ID4gQEAgLTIxLDYgKzIxLDE5IEBADQo+PiArI2luY2x1ZGUgPG5ldC90Y19hY3QvdGNfcGVk
aXQuaD4NCj4+ICsjaW5jbHVkZSA8bmV0L3RjX2FjdC90Y19taXJyZWQuaD4NCj4+ICsjaW5jbHVk
ZSA8bmV0L3RjX2FjdC90Y192bGFuLmg+DQo+PiArI2luY2x1ZGUgPG5ldC90Y19hY3QvdGNfdHVu
bmVsX2tleS5oPiAjaW5jbHVkZSA8bmV0L3RjX2FjdC90Y19jc3VtLmg+DQo+PiArI2luY2x1ZGUg
PG5ldC90Y19hY3QvdGNfZ2FjdC5oPiAjaW5jbHVkZSA8bmV0L3RjX2FjdC90Y19wb2xpY2UuaD4N
Cj4+ICsjaW5jbHVkZSA8bmV0L3RjX2FjdC90Y19zYW1wbGUuaD4gI2luY2x1ZGUgPG5ldC90Y19h
Y3QvdGNfc2tiZWRpdC5oPg0KPj4gKyNpbmNsdWRlIDxuZXQvdGNfYWN0L3RjX2N0Lmg+ICNpbmNs
dWRlIDxuZXQvdGNfYWN0L3RjX21wbHMuaD4NCj4+ICsjaW5jbHVkZSA8bmV0L3RjX2FjdC90Y19n
YXRlLmg+ICNpbmNsdWRlIDxuZXQvZmxvd19vZmZsb2FkLmg+DQo+Pg0KPj4gICAjaWZkZWYgQ09O
RklHX0lORVQNCj4+ICAgREVGSU5FX1NUQVRJQ19LRVlfRkFMU0UodGNmX2ZyYWdfeG1pdF9jb3Vu
dCk7DQo+PiBAQCAtMTI5LDggKzE0MiwxNTcgQEAgc3RhdGljIHZvaWQgZnJlZV90Y2Yoc3RydWN0
IHRjX2FjdGlvbiAqcCkNCj4+ICAgCWtmcmVlKHApOw0KPj4gICB9DQo+Pg0KPj4gK3N0YXRpYyBp
bnQgZmxvd19hY3Rpb25faW5pdChzdHJ1Y3QgZmxvd19vZmZsb2FkX2FjdGlvbiAqZmxfYWN0aW9u
LA0KPj4gKwkJCSAgICBzdHJ1Y3QgdGNfYWN0aW9uICphY3QsDQo+PiArCQkJICAgIGVudW0gZmxv
d19hY3RfY29tbWFuZCBjbWQsDQo+PiArCQkJICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4
dGFjaykgew0KPj4gKwlpZiAoIWZsX2FjdGlvbikNCj4+ICsJCXJldHVybiAtRUlOVkFMOw0KPj4g
Kw0KPj4gKwlmbF9hY3Rpb24tPmV4dGFjayA9IGV4dGFjazsNCj4+ICsJZmxfYWN0aW9uLT5jb21t
YW5kID0gY21kOw0KPj4gKwlmbF9hY3Rpb24tPmluZGV4ID0gYWN0LT50Y2ZhX2luZGV4Ow0KPj4g
Kw0KPj4gKwlpZiAoaXNfdGNmX2dhY3Rfb2soYWN0KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5pZCA9
IEZMT1dfQUNUSU9OX0FDQ0VQVDsNCj4+ICsJfSBlbHNlIGlmIChpc190Y2ZfZ2FjdF9zaG90KGFj
dCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+aWQgPSBGTE9XX0FDVElPTl9EUk9QOw0KPj4gKwl9IGVs
c2UgaWYgKGlzX3RjZl9nYWN0X3RyYXAoYWN0KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5pZCA9IEZM
T1dfQUNUSU9OX1RSQVA7DQo+PiArCX0gZWxzZSBpZiAoaXNfdGNmX2dhY3RfZ290b19jaGFpbihh
Y3QpKSB7DQo+PiArCQlmbF9hY3Rpb24tPmlkID0gRkxPV19BQ1RJT05fR09UTzsNCj4+ICsJfSBl
bHNlIGlmIChpc190Y2ZfbWlycmVkX2VncmVzc19yZWRpcmVjdChhY3QpKSB7DQo+PiArCQlmbF9h
Y3Rpb24tPmlkID0gRkxPV19BQ1RJT05fUkVESVJFQ1Q7DQo+PiArCX0gZWxzZSBpZiAoaXNfdGNm
X21pcnJlZF9lZ3Jlc3NfbWlycm9yKGFjdCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+aWQgPSBGTE9X
X0FDVElPTl9NSVJSRUQ7DQo+PiArCX0gZWxzZSBpZiAoaXNfdGNmX21pcnJlZF9pbmdyZXNzX3Jl
ZGlyZWN0KGFjdCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+aWQgPSBGTE9XX0FDVElPTl9SRURJUkVD
VF9JTkdSRVNTOw0KPj4gKwl9IGVsc2UgaWYgKGlzX3RjZl9taXJyZWRfaW5ncmVzc19taXJyb3Io
YWN0KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX01JUlJFRF9JTkdSRVNT
Ow0KPj4gKwl9IGVsc2UgaWYgKGlzX3RjZl92bGFuKGFjdCkpIHsNCj4+ICsJCXN3aXRjaCAodGNm
X3ZsYW5fYWN0aW9uKGFjdCkpIHsNCj4+ICsJCWNhc2UgVENBX1ZMQU5fQUNUX1BVU0g6DQo+PiAr
CQkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX1ZMQU5fUFVTSDsNCj4+ICsJCQlicmVhazsN
Cj4+ICsJCWNhc2UgVENBX1ZMQU5fQUNUX1BPUDoNCj4+ICsJCQlmbF9hY3Rpb24tPmlkID0gRkxP
V19BQ1RJT05fVkxBTl9QT1A7DQo+PiArCQkJYnJlYWs7DQo+PiArCQljYXNlIFRDQV9WTEFOX0FD
VF9NT0RJRlk6DQo+PiArCQkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX1ZMQU5fTUFOR0xF
Ow0KPj4gKwkJCWJyZWFrOw0KPj4gKwkJZGVmYXVsdDoNCj4+ICsJCQlyZXR1cm4gLUVPUE5PVFNV
UFA7DQo+PiArCQl9DQo+PiArCX0gZWxzZSBpZiAoaXNfdGNmX3R1bm5lbF9zZXQoYWN0KSkgew0K
Pj4gKwkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX1RVTk5FTF9FTkNBUDsNCj4+ICsJfSBl
bHNlIGlmIChpc190Y2ZfdHVubmVsX3JlbGVhc2UoYWN0KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5p
ZCA9IEZMT1dfQUNUSU9OX1RVTk5FTF9ERUNBUDsNCj4+ICsJfSBlbHNlIGlmIChpc190Y2ZfY3N1
bShhY3QpKSB7DQo+PiArCQlmbF9hY3Rpb24tPmlkID0gRkxPV19BQ1RJT05fQ1NVTTsNCj4+ICsJ
fSBlbHNlIGlmIChpc190Y2Zfc2tiZWRpdF9tYXJrKGFjdCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+
aWQgPSBGTE9XX0FDVElPTl9NQVJLOw0KPj4gKwl9IGVsc2UgaWYgKGlzX3RjZl9zYW1wbGUoYWN0
KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX1NBTVBMRTsNCj4+ICsJfSBl
bHNlIGlmIChpc190Y2ZfcG9saWNlKGFjdCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+aWQgPSBGTE9X
X0FDVElPTl9QT0xJQ0U7DQo+PiArCX0gZWxzZSBpZiAoaXNfdGNmX2N0KGFjdCkpIHsNCj4+ICsJ
CWZsX2FjdGlvbi0+aWQgPSBGTE9XX0FDVElPTl9DVDsNCj4+ICsJfSBlbHNlIGlmIChpc190Y2Zf
bXBscyhhY3QpKSB7DQo+PiArCQlzd2l0Y2ggKHRjZl9tcGxzX2FjdGlvbihhY3QpKSB7DQo+PiAr
CQljYXNlIFRDQV9NUExTX0FDVF9QVVNIOg0KPj4gKwkJCWZsX2FjdGlvbi0+aWQgPSBGTE9XX0FD
VElPTl9NUExTX1BVU0g7DQo+PiArCQkJYnJlYWs7DQo+PiArCQljYXNlIFRDQV9NUExTX0FDVF9Q
T1A6DQo+PiArCQkJZmxfYWN0aW9uLT5pZCA9IEZMT1dfQUNUSU9OX01QTFNfUE9QOw0KPj4gKwkJ
CWJyZWFrOw0KPj4gKwkJY2FzZSBUQ0FfTVBMU19BQ1RfTU9ESUZZOg0KPj4gKwkJCWZsX2FjdGlv
bi0+aWQgPSBGTE9XX0FDVElPTl9NUExTX01BTkdMRTsNCj4+ICsJCQlicmVhazsNCj4+ICsJCWRl
ZmF1bHQ6DQo+PiArCQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPj4gKwkJfQ0KPj4gKwl9IGVsc2Ug
aWYgKGlzX3RjZl9za2JlZGl0X3B0eXBlKGFjdCkpIHsNCj4+ICsJCWZsX2FjdGlvbi0+aWQgPSBG
TE9XX0FDVElPTl9QVFlQRTsNCj4+ICsJfSBlbHNlIGlmIChpc190Y2Zfc2tiZWRpdF9wcmlvcml0
eShhY3QpKSB7DQo+PiArCQlmbF9hY3Rpb24tPmlkID0gRkxPV19BQ1RJT05fUFJJT1JJVFk7DQo+
PiArCX0gZWxzZSBpZiAoaXNfdGNmX2dhdGUoYWN0KSkgew0KPj4gKwkJZmxfYWN0aW9uLT5pZCA9
IEZMT1dfQUNUSU9OX0dBVEU7DQo+PiArCX0gZWxzZSB7DQo+PiArCQlyZXR1cm4gLUVPUE5PVFNV
UFA7DQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0KPj4gKw0KPg0KPlRoZSBj
aGFsbGVuZ2Ugd2l0aCB0aGlzIGlzIG5vdyBpdCBpcyBpbXBvc3NpYmxlIHRvIHdyaXRlIGFuIGFj
dGlvbiBhcyBhDQo+c3RhbmRhbG9uZSBtb2R1bGUgKHdoaWNoIHdvcmtzIHRvZGF5KS4NCj5PbmUg
cmVzb2x1dGlvbiB0byB0aGlzIGlzIHRvIGVpdGhlciByZXVzZSBvciBpbnRyb2R1Y2UgYSBuZXcg
b3BzIGluIHN0cnVjdA0KPnRjX2FjdGlvbl9vcHMuDQo+VGhlbiBmbG93X2FjdGlvbl9pbml0KCkg
d291bGQganVzdCBpbnZva2UgdGhpcyBhY3QtPm9wcygpIHdoaWNoIHdpbGwgZG8gYWN0aW9uDQo+
c3BlY2lmaWMgc2V0dXAuDQo+DQpUaGFua3MgZm9yIGJyaW5naW5nIHRoaXMgdG8gdXMuDQpBcyBt
eSB1bmRlcnN0YW5kaW5nLCBmb3IgdGhpcyBpc3N1ZSwgd2UgYXJlIGZhY2luZyB0aGUgc2FtZSBm
YWN0IHdpdGggV2hhdCB3ZSBkbyBpbiBmdW5jdGlvbiB0Y19zZXR1cF9mbG93X2FjdGlvbi4gDQpJ
ZiB3ZSBhZGQgYSBmaWx0ZXIgd2l0aCBhIG5ldyBhZGRlZCBhY3Rpb24sIHdlIHdpbGwgYWxzbyBm
YWlsIHRvIG9mZmxvYWQgdGhlIGZpbHRlci4NCkZvciBhIG5ldyBhZGRlZCBhY3Rpb24sIGlmIHdl
IGFpbSB0byBvZmZsb2FkIHRoZSBhY3Rpb24gdG8gaGFyZHdhcmUsIHRoZW4gd2UgZGVmaW5pdGVs
eSBuZWVkIGENCmluaXQgZmN0aW9uIGFuZCBzZXR1cCBmdW5jdGlvbiBmb3IgYWN0aW9uL2ZpbHRl
ciBvZmZsb2FkLiBXZSBjYW4gYWRkIGEgb3BzIGZvciB0aGUgbmV3IGFkZGVkIGFjdGlvbiB0byBp
bml0IG9yIHNldHVwIHRoZSBhY3Rpb24uDQoNCkRvIHlvdSB0aGluayBpdCBpcyBwcm9wZXIgdG8g
aW5jbHVkZSB0aGlzIGltcGxlbWVudCBpbiBvdXIgcGF0Y2ggc2VyaWVzIG9yIHdlIGNhbiBkZWxp
dmVyeSBhIG5ldyBwYXRjaCBmb3IgdGhpcz8NCj5jaGVlcnMsDQo+amFtYWwNCg==
