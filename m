Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF0F444D4D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 03:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhKDCd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 22:33:26 -0400
Received: from mail-bn8nam12on2093.outbound.protection.outlook.com ([40.107.237.93]:21793
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbhKDCd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 22:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjPhuPtYWGyE9H2phk8GvWJbGY8pIaD5aUCV3bq/u+vHBcB5nNrW0KBqwrlkSxCX5JSUknErk55uQYYX1rmUHkxPafZycerTUu1yxYpQFXcvOTJsQR5rRy3NriaB9uGxDiGYkEJX1QDtbbWqd5KBmHKlrbX+jurYSi49Ve4GBFKwUPpz04ZW1K/Wspv4H9gTWJZIPwWKetGrH+OyV1xlJE0n2TttHLquLYP5WAtXRLsLlxOMNGgyIStlZ7sahbhXaWziDuXqrFDVDd3b5FOLY4fFWLI6bJKrfg6BaDz2cZHCnZYv6vAE6yTxBsZq0qC1rRTsN2ZR10uS/p4XRR/Ytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kSVMGBszpHeJ/tUGOc+bhUGf/glw6rzxxt1HN9nChI=;
 b=CpWoATxu1D9q6R8pnZ0cNRFDB0W1vr1Grr0mTWi7J+sgTg585tUBAZ8D8oNQrUmXFgMR/m054XHjbPgtPjCZdFtqfan4+PBJ8F6lVtL4rSHPNztk+dC1aP4TTO4aT0Gu4puyfsnRgqFW9xDb2unsH++XZit+AMPDviKbBAstEOiWi5vXNuH20gu16k6UF52rOZW7gqlsa5mj60v/S7I57yU9BFrJZ6pPdDg5rm7PDVmNM6SvUmSEF2CNMpJ0ACbAshnU55VT+iBBdOeQeNUcx2x7Jh37ruj+90aSw2NXmsZJzBvYIqrF6s5k7O6S4lL9FM3sJG/veO4Sgjlh+kbGPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kSVMGBszpHeJ/tUGOc+bhUGf/glw6rzxxt1HN9nChI=;
 b=CYG833iDAAcvbZGmyTGU8q3cXF4N12DvYpHefanLYA0UV8qPzAHdITKGlnD4U12DiNIjGCRvkL7mTwr+ffUCm0WDDaZQ8lRdx1nrp1vCwDveFnC170+FNXqDkgz20F2tMwn/KccHKVLOxABsdP+fuJYduUFSVIxTyQPxhgPu9RE=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1467.namprd13.prod.outlook.com (2603:10b6:3:125::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6; Thu, 4 Nov
 2021 02:30:46 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Thu, 4 Nov 2021
 02:30:46 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAhnPzA=
Date:   Thu, 4 Nov 2021 02:30:46 +0000
Message-ID: <DM5PR1301MB21722934E954B577033F0F56E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
In-Reply-To: <ygnhilxfaexq.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf180a7-6eaa-436d-6c84-08d99f3b1b8a
x-ms-traffictypediagnostic: DM5PR13MB1467:
x-microsoft-antispam-prvs: <DM5PR13MB14676EC51C73764748BFC50DE78D9@DM5PR13MB1467.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TMRKKBkgyznEWjZh7/jxSN1yXG29nS67FYCPLBXbKe/PovTmUA9dNLbbmImwOJV0/vz/0TpvIWhUVOc5nvj47JJNLdgTb2+gEsMR/Q4sI8cuzNCgSkgc9NQrveOFGiY4catrVdBMmd5kG/Rm8pLiLpLumFvSb5/tSYgpBY99RQysaY7BY6bBoYbeX4Dy8zRDDQeTyh/d4yeROqQQiTVwDPF0vf+oyEX0E+R0hGVyqZ0INYMOwqJix1WaE3eYsG5e1CZTBni3r14T7omNWQ+M/Z7Zo1nA7sOIse8vr6fuAWmk8HwD1P2txgkq5FOA/2Jmv9kqDTXHAcJpNFyznqYLS3H3IOqvvvhJ+f9+qHfmWiICwdAsgXzRgjU+XXMAz4+aKWK7MKyPDpsY9QfY1h5Ey1n4nTfifZdHOra1mOE/TC0w/fyHhtcS0G3B014z2S4MH9aF3WkbHgDmRokSNeWmLJODXPRlbt7rCU4PJ/TUiqAOtbrUuLBM/KpTC/Vh6SKHNHRPRrlDH6PFOWG7CJkTI5vMEnVf+3c4hW4GaBB4Eo/LJNZN2I/1wN9fpkvywrmvU10f1TVAgy3FBsCR7ptMrto0Hgkq0Io5/MRtMaeEKw9eIECBTlpldesNZIBhgQmYK5AftT9zmBrGy4aPbBdzsBraOK7hUHcsg82LpAvhL4jwbMkLypIYHYFm98CqUNwt+hoTBwJA2i9pHoyFNlWjMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(366004)(346002)(396003)(15650500001)(4326008)(33656002)(8936002)(52536014)(83380400001)(8676002)(2906002)(110136005)(54906003)(316002)(44832011)(55016002)(186003)(38100700002)(76116006)(5660300002)(6636002)(7696005)(38070700005)(9686003)(122000001)(26005)(71200400001)(508600001)(66446008)(66556008)(66476007)(64756008)(107886003)(6506007)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2N0djhPL3BQdnp6UGoyRVdaL2g5ZXhVTCtiMU5GMU9xWTM5MEQ4czIwaHlV?=
 =?utf-8?B?aU5IT01XaHZ5ak1LTzVUYVFrUzNyYy96YlQzL2tjRDF2S0xTVHdwMGRUZEJW?=
 =?utf-8?B?dldtbWxzL1E2ZlpFdkFjeFhja2lncWMrd04zdWk5NHllNXpybmpldEhVenk3?=
 =?utf-8?B?TmJvNGFCVjNZYXRad1hoSWNyUkg3ajh4U0FFRE5BeG5pTlNSQ25ZU1FKeHFE?=
 =?utf-8?B?WVhHa2Z1NlRSQ25OaTIxS2tWcHFKSjY4NnlkZndHRTNieDRyYmxBTUFYOTBD?=
 =?utf-8?B?YTlMaE5leTdPSXVLSnFGV05WS21xa1pzTlVLejdEQ2MvV2xZVzJrRUg1RjZ6?=
 =?utf-8?B?RW1jOG1QMDVGNG51bnFIVlQyR3luc1YxcTJoR0RicCszQ1VPWDFKdHZzbnlS?=
 =?utf-8?B?czdOUFZCbjczZGd4MWJYZlFUSzEwOXFYd0RpcUVyNHdmSVB4bkZUdFBhQjVp?=
 =?utf-8?B?NEYyb2t4amg5QldJa2xqVHd4V1ZHcDg2bVd5YjU5R3ROUld5QmZyVWIxSzBF?=
 =?utf-8?B?REdkOGhpbEpBNEN2MVdpWmNNRHdhZEVsSmVxR2gvNDVEeGRSZ2ZzRCtDTE1E?=
 =?utf-8?B?NUhSRkdKNlptaUxFTG02N0orVWp2aHdldGZlQXQ0bmtsSzMvVjhnL1JHZDBL?=
 =?utf-8?B?QThrTEhXb2tJY3BzTGhNZ212c21Wd1hNZHdJLzdQQW1sc0NIY0FycFcwY05X?=
 =?utf-8?B?UDN4dS9Jc040VUlZeHUvYWpROWd1U3Z6ZnRUckRWL3ZsUzhGbXFpQ0Q1Q2x3?=
 =?utf-8?B?eW54RTl3azFqTjJSeUQwSzV5d1g3U1VvUFVVOG80Tm0xRTVoZ0NndEx2Titw?=
 =?utf-8?B?eWVDcTBhUG5BVk9CM2tEUDd5UG9lRCtLbTJDZ2xzY2wwWHZFMUJyTU85dFBy?=
 =?utf-8?B?YTZkd014NXN3SzlhTVkrQ1VocDRsMlJBeWJoeFpnNDY4Y0hKUUlTWFdSMSsy?=
 =?utf-8?B?VWE3Q0YrWlNWYlVpQ0dQS0lLcDdFRDFvQWpNZzNUa1R4eUdRWDk4bnVhbEZZ?=
 =?utf-8?B?Ym1kVVNXSHB4OTgybkg2eFVMS250blNmc0FFQXRCdVkvM056MTBUdHhJRDBW?=
 =?utf-8?B?dlJiKzZEeW1YS1dYNGtpTXZrTXRCNksyYWk5OTBmZTl0M1kyRk01ZXEyVFNq?=
 =?utf-8?B?OUZDYVJQQjIxc2dlR3NkU3V0bVBnNXloMkk0Tm1WbVdOT21rYXNMbFVKWUg2?=
 =?utf-8?B?eDE3dDRLNTN5M29hNXVpV1NsS1IvQjNTcnRXQ1c4cUc1RThGV3A5bkROaGZk?=
 =?utf-8?B?b09jenZZZndmbm5YOWxJVzNQYTYveUsyQkpEcHkyTE9ERmFneGdVV3FEK3kz?=
 =?utf-8?B?OGpaakpiQ3FzaVJrUmdOclczN3NLSnJEV3BlTWx5R1hSaWw3OVh1MDcxL1lR?=
 =?utf-8?B?Tzg5eTFjMFVycUhDUWZXcW9TamhZL1hNaHRYUzRLR0pPUStzc0xVY1FrUzdO?=
 =?utf-8?B?b3Z3UUQ2WmRuV0wvREhtN1d5Q3VRZlZFVWR1K0M1a1paUzNINVRsTGJ1bDg2?=
 =?utf-8?B?cDFycmFzWkFKejBCbDB4Q2VQUUt5T2dFbVp3VTBETXA3TlZzeTZTN2p2alk4?=
 =?utf-8?B?MHBXWlNmNVFSU1pwejcxZGpMdXVOcmczR1JsTkd2Q1dUTzF4Y2x1Rm5tdmhz?=
 =?utf-8?B?QTBDclJLSVpzcEd3NG9pYjNSUXlSMytmd3JyaU5mUndwNXRFN1MrSGR6SWdD?=
 =?utf-8?B?TC9JdmVabWJRc2JuSXhUZ3Z4ZjB2bWx0K3VST05JUGVuMTFWU1lHZzhlU0Vy?=
 =?utf-8?B?dUE0UWhFbnJKZTF1OGs3cnYzMjU4eFIzQ3RnUXVrNnVGenM3amg5am5yU1hQ?=
 =?utf-8?B?dFlFRllscXNKTkt2RGswaXJqMjY2eUc1dzZSb0VScGZLL2g5WEV3ajFrcVhh?=
 =?utf-8?B?ekRoVENDTEkwVU5RYlgxUnc2N1ZMUkJjRlJOYWNkdmhEZkpvOHhXOS93ZUJy?=
 =?utf-8?B?dHMwNTYxZFRCb2Q1bXpJK3h3LzZFQXFHZHVHR1RwbEhEYXBTZGZmS0xVbHhh?=
 =?utf-8?B?YnpBSVpyak9yTGxOZlk2eG5Na3RydU11TS9zOWNuYkFXd2xuRHdKTFFVOENp?=
 =?utf-8?B?UjNxSWdOaUR1R0JtQ1ZLU3d4UFhUanlqQnhFQmRqTlVvcHBPQU9iY1kvZlMw?=
 =?utf-8?B?eHdyNElOK1g2UVhEZUgxRFpyLzRNd0t0dWZGMFJEQm1wSCtwS0gwQ05NaWVu?=
 =?utf-8?B?bTlnck0wNTNyVHJIVGZiTlk5WVUzOXJNYS9LeXB0Tnh3ckV5NHpuWnAwZVBo?=
 =?utf-8?B?RGdtYmtEblBRdkZoaTduT1VneXlRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf180a7-6eaa-436d-6c84-08d99f3b1b8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 02:30:46.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRQoUv1e1/v0SkPhHHdp0w/EYy5b9fuByzkVA3hVnN+SxCrqvM3sBgHoGSz7Lmu9cAixvbDIWzsAKYNM7/OWoJcWOLs1cxKAhXCKix4DUu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1467
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJldmlldyBhbmQgc29ycnkgZm9yIGRlbGF5IGluIHJlc3BvbmRpbmcu
DQpPbiBPY3RvYmVyIDMwLCAyMDIxIDI6MDEgQU0sIFZsYWQgQnVzbG92IHdyb3RlOg0KPk9uIFRo
dSAyOCBPY3QgMjAyMSBhdCAxNDowNiwgU2ltb24gSG9ybWFuIDxzaW1vbi5ob3JtYW5AY29yaWdp
bmUuY29tPg0KPndyb3RlOg0KPj4gRnJvbTogQmFvd2VuIFpoZW5nIDxiYW93ZW4uemhlbmdAY29y
aWdpbmUuY29tPg0KPj4NCj4+IEFkZCBwcm9jZXNzIHRvIHZhbGlkYXRlIGZsYWdzIG9mIGZpbHRl
ciBhbmQgYWN0aW9ucyB3aGVuIGFkZGluZyBhIHRjDQo+PiBmaWx0ZXIuDQo+Pg0KPj4gV2UgbmVl
ZCB0byBwcmV2ZW50IGFkZGluZyBmaWx0ZXIgd2l0aCBmbGFncyBjb25mbGljdHMgd2l0aCBpdHMg
YWN0aW9ucy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBCYW93ZW4gWmhlbmcgPGJhb3dlbi56aGVu
Z0Bjb3JpZ2luZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBMb3VpcyBQZWVucyA8bG91aXMucGVl
bnNAY29yaWdpbmUuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogU2ltb24gSG9ybWFuIDxzaW1vbi5o
b3JtYW5AY29yaWdpbmUuY29tPg0KPj4gLS0tDQo+PiAgbmV0L3NjaGVkL2Nsc19hcGkuYyAgICAg
IHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+ICBuZXQvc2NoZWQvY2xzX2Zsb3dl
ci5jICAgfCAgMyArKy0NCj4+ICBuZXQvc2NoZWQvY2xzX21hdGNoYWxsLmMgfCAgNCArKy0tDQo+
PiAgbmV0L3NjaGVkL2Nsc191MzIuYyAgICAgIHwgIDcgKysrKy0tLQ0KPj4gIDQgZmlsZXMgY2hh
bmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvbmV0L3NjaGVkL2Nsc19hcGkuYyBiL25ldC9zY2hlZC9jbHNfYXBpLmMgaW5kZXgNCj4+IDM1
MWQ5Mzk4OGI4Yi4uODA2NDdkYTk3MTNhIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3NjaGVkL2Nsc19h
cGkuYw0KPj4gKysrIGIvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPj4gQEAgLTMwMjUsNiArMzAyNSwy
OSBAQCB2b2lkIHRjZl9leHRzX2Rlc3Ryb3koc3RydWN0IHRjZl9leHRzICpleHRzKSAgfQ0KPj4g
RVhQT1JUX1NZTUJPTCh0Y2ZfZXh0c19kZXN0cm95KTsNCj4+DQo+PiArc3RhdGljIGJvb2wgdGNm
X2V4dHNfdmFsaWRhdGVfYWN0aW9ucyhjb25zdCBzdHJ1Y3QgdGNmX2V4dHMgKmV4dHMsDQo+PiAr
dTMyIGZsYWdzKSB7ICNpZmRlZiBDT05GSUdfTkVUX0NMU19BQ1QNCj4+ICsJYm9vbCBza2lwX3N3
ID0gdGNfc2tpcF9zdyhmbGFncyk7DQo+PiArCWJvb2wgc2tpcF9odyA9IHRjX3NraXBfaHcoZmxh
Z3MpOw0KPj4gKwlpbnQgaTsNCj4+ICsNCj4+ICsJaWYgKCEoc2tpcF9zdyB8IHNraXBfaHcpKQ0K
Pj4gKwkJcmV0dXJuIHRydWU7DQo+PiArDQo+PiArCWZvciAoaSA9IDA7IGkgPCBleHRzLT5ucl9h
Y3Rpb25zOyBpKyspIHsNCj4+ICsJCXN0cnVjdCB0Y19hY3Rpb24gKmEgPSBleHRzLT5hY3Rpb25z
W2ldOw0KPj4gKw0KPj4gKwkJaWYgKChza2lwX3N3ICYmIHRjX2FjdF9za2lwX2h3KGEtPnRjZmFf
ZmxhZ3MpKSB8fA0KPj4gKwkJICAgIChza2lwX2h3ICYmIHRjX2FjdF9za2lwX3N3KGEtPnRjZmFf
ZmxhZ3MpKSkNCj4+ICsJCQlyZXR1cm4gZmFsc2U7DQo+PiArCX0NCj4+ICsJcmV0dXJuIHRydWU7
DQo+PiArI2Vsc2UNCj4+ICsJcmV0dXJuIHRydWU7DQo+PiArI2VuZGlmDQo+PiArfQ0KPj4gKw0K
Pg0KPkkga25vdyBKYW1hbCBzdWdnZXN0ZWQgdG8gaGF2ZSBza2lwX3N3IGZvciBhY3Rpb25zLCBi
dXQgaXQgY29tcGxpY2F0ZXMgdGhlDQo+Y29kZSBhbmQgSSdtIHN0aWxsIG5vdCBlbnRpcmVseSB1
bmRlcnN0YW5kIHdoeSBpdCBpcyBuZWNlc3NhcnkuDQo+QWZ0ZXIgYWxsLCBhY3Rpb24gY2FuIG9u
bHkgZ2V0IGFwcGxpZWQgdG8gYSBwYWNrZXQgaWYgdGhlIHBhY2tldCBoYXMgYmVlbg0KPm1hdGNo
ZWQgYnkgc29tZSBmaWx0ZXIgYW5kIGZpbHRlcnMgYWxyZWFkeSBoYXZlIHNraXAgc3cvaHcgY29u
dHJvbHMuIEZvcmdvaW5nDQo+YWN0aW9uIHNraXBfc3cgZmxhZyB3b3VsZDoNCj4NCj4tIEFsbGV2
aWF0ZSB0aGUgbmVlZCB0byB2YWxpZGF0ZSB0aGF0IGZpbHRlciBhbmQgYWN0aW9uIGZsYWdzIGFy
ZSBjb21wYXRpYmxlLg0KPih0cnlpbmcgdG8gb2ZmbG9hZCBmaWx0ZXIgdGhhdCBwb2ludHMgdG8g
ZXhpc3Rpbmcgc2tpcF9odyBhY3Rpb24gd291bGQganVzdCBmYWlsDQo+YmVjYXVzZSB0aGUgZHJp
dmVyIHdvdWxkbid0IGZpbmQgdGhlIGFjdGlvbiB3aXRoIHByb3ZpZGVkIGlkIGluIGl0cyB0YWJs
ZXMpDQo+DQo+LSBSZW1vdmUgdGhlIG5lZWQgdG8gYWRkIG1vcmUgY29uZGl0aW9uYWxzIGludG8g
VEMgc29mdHdhcmUgZGF0YSBwYXRoIGluDQo+cGF0Y2ggNC4NCj4NCj5XRFlUPw0KQXMgd2UgZGlz
Y3Vzc2VkIHdpdGggSmFtYWwsIHdlIHdpbGwga2VlcCB0aGUgZmxhZyBvZiBza2lwX3N3IGFuZCB3
ZSBuZWVkIHRvIG1ha2UNCmV4YWN0bHkgbWF0Y2ggZm9yIHRoZSBhY3Rpb25zIHdpdGggZmxhZ3Mg
YW5kIHRoZSBmaWx0ZXIgc3BlY2lmaWMgYWN0aW9uIHdpdGggaW5kZXguIA0KPg0KPj4gIGludCB0
Y2ZfZXh0c192YWxpZGF0ZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLCBz
dHJ1Y3QgbmxhdHRyICoqdGIsDQo+PiAgCQkgICAgICBzdHJ1Y3QgbmxhdHRyICpyYXRlX3Rsdiwg
c3RydWN0IHRjZl9leHRzICpleHRzLA0KPj4gIAkJICAgICAgdTMyIGZsYWdzLCBzdHJ1Y3QgbmV0
bGlua19leHRfYWNrICpleHRhY2spIEBAIC0zMDY2LDYNCj4rMzA4OSw5DQo+PiBAQCBpbnQgdGNm
X2V4dHNfdmFsaWRhdGUoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCwgc3Ry
dWN0IG5sYXR0cg0KPioqdGIsDQo+PiAgCQkJCXJldHVybiBlcnI7DQo+PiAgCQkJZXh0cy0+bnJf
YWN0aW9ucyA9IGVycjsNCj4+ICAJCX0NCj4+ICsNCj4+ICsJCWlmICghdGNmX2V4dHNfdmFsaWRh
dGVfYWN0aW9ucyhleHRzLCBmbGFncykpDQo+PiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+PiAgCX0N
Cj4+ICAjZWxzZQ0KPj4gIAlpZiAoKGV4dHMtPmFjdGlvbiAmJiB0YltleHRzLT5hY3Rpb25dKSB8
fCBkaWZmIC0tZ2l0DQo+PiBhL25ldC9zY2hlZC9jbHNfZmxvd2VyLmMgYi9uZXQvc2NoZWQvY2xz
X2Zsb3dlci5jIGluZGV4DQo+PiBlYjYzNDVhMDI3ZTEuLjU1Zjg5ZjBlMzkzZSAxMDA2NDQNCj4+
IC0tLSBhL25ldC9zY2hlZC9jbHNfZmxvd2VyLmMNCj4+ICsrKyBiL25ldC9zY2hlZC9jbHNfZmxv
d2VyLmMNCj4+IEBAIC0yMDM1LDcgKzIwMzUsOCBAQCBzdGF0aWMgaW50IGZsX2NoYW5nZShzdHJ1
Y3QgbmV0ICpuZXQsIHN0cnVjdCBza19idWZmDQo+KmluX3NrYiwNCj4+ICAJfQ0KPj4NCj4+ICAJ
ZXJyID0gZmxfc2V0X3Bhcm1zKG5ldCwgdHAsIGZuZXcsIG1hc2ssIGJhc2UsIHRiLCB0Y2FbVENB
X1JBVEVdLA0KPj4gLQkJCSAgIHRwLT5jaGFpbi0+dG1wbHRfcHJpdiwgZmxhZ3MsIGV4dGFjayk7
DQo+PiArCQkJICAgdHAtPmNoYWluLT50bXBsdF9wcml2LCBmbGFncyB8IGZuZXctPmZsYWdzLA0K
Pj4gKwkJCSAgIGV4dGFjayk7DQo+DQo+QXJlbid0IHlvdSBvci1pbmcgZmxhZ3MgZnJvbSB0d28g
ZGlmZmVyZW50IHJhbmdlcyAoVENBX0NMU19GTEFHU18qIGFuZA0KPlRDQV9BQ1RfRkxBR1NfKikg
dGhhdCBtYXAgdG8gc2FtZSBiaXRzLCBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPyBUaGlzDQo+
aXNuJ3QgZXhwbGFpbmVkIGluIGNvbW1pdCBtZXNzYWdlIHNvIGl0IGlzIGhhcmQgZm9yIG1lIHRv
IHVuZGVyc3RhbmQgdGhlIGlkZWENCj5oZXJlLg0KWWVzLCBhcyB5b3Ugc2FpZCB3ZSB1c2UgVENB
X0NMU19GTEFHU18qIG9yIFRDQV9BQ1RfRkxBR1NfKiBmbGFncyB0byB2YWxpZGF0ZSB0aGUgYWN0
aW9uIGZsYWdzLiANCkFzIHlvdSBrbm93LCB0aGUgVENBX0FDVF9GTEFHU18qIGluIGZsYWdzIGFy
ZSBzeXN0ZW0gZmxhZ3MoaW4gaGlnaCAxNiBiaXRzKSBhbmQgdGhlIFRDQV9DTFNfRkxBR1NfKg0K
YXJlIHVzZXIgZmxhZ3MoaW4gbG93IDE2IGJpdHMpLCBzbyB0aGV5IHdpbGwgbm90IGJlIGNvbmZs
aWN0LiANCkJ1dCBJIHRoaW5rIHlvdSBzdWdnZXN0aW9uIGFsc28gbWFrZXMgc2Vuc2UgdG8gdXMs
IGRvIHlvdSB0aGluayB3ZSBuZWVkIHRvIHBhc3MgYSBzaW5nbGUgZmlsdGVyIGZsYWcNCnRvIG1h
a2UgdGhlIHByb2Nlc3MgbW9yZSBjbGVhcj8gDQo+DQo+PiAgCWlmIChlcnIpDQo+PiAgCQlnb3Rv
IGVycm91dDsNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jIGIv
bmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jIGluZGV4DQo+PiAyNGYwMDQ2Y2UwYjMuLjAwYjc2ZmJj
MWRjZSAxMDA2NDQNCj4+IC0tLSBhL25ldC9zY2hlZC9jbHNfbWF0Y2hhbGwuYw0KPj4gKysrIGIv
bmV0L3NjaGVkL2Nsc19tYXRjaGFsbC5jDQo+PiBAQCAtMjI2LDggKzIyNiw4IEBAIHN0YXRpYyBp
bnQgbWFsbF9jaGFuZ2Uoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc2tfYnVmZg0KPippbl9za2Is
DQo+PiAgCQlnb3RvIGVycl9hbGxvY19wZXJjcHU7DQo+PiAgCX0NCj4+DQo+PiAtCWVyciA9IG1h
bGxfc2V0X3Bhcm1zKG5ldCwgdHAsIG5ldywgYmFzZSwgdGIsIHRjYVtUQ0FfUkFURV0sIGZsYWdz
LA0KPj4gLQkJCSAgICAgZXh0YWNrKTsNCj4+ICsJZXJyID0gbWFsbF9zZXRfcGFybXMobmV0LCB0
cCwgbmV3LCBiYXNlLCB0YiwgdGNhW1RDQV9SQVRFXSwNCj4+ICsJCQkgICAgIGZsYWdzIHwgbmV3
LT5mbGFncywgZXh0YWNrKTsNCj4+ICAJaWYgKGVycikNCj4+ICAJCWdvdG8gZXJyX3NldF9wYXJt
czsNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc191MzIuYyBiL25ldC9zY2hlZC9j
bHNfdTMyLmMgaW5kZXgNCj4+IDQyNzI4MTQ0ODdmMC4uZmM2NzBjYzQ1MTIyIDEwMDY0NA0KPj4g
LS0tIGEvbmV0L3NjaGVkL2Nsc191MzIuYw0KPj4gKysrIGIvbmV0L3NjaGVkL2Nsc191MzIuYw0K
Pj4gQEAgLTg5NSw3ICs4OTUsOCBAQCBzdGF0aWMgaW50IHUzMl9jaGFuZ2Uoc3RydWN0IG5ldCAq
bmV0LCBzdHJ1Y3Qgc2tfYnVmZg0KPippbl9za2IsDQo+PiAgCQkJcmV0dXJuIC1FTk9NRU07DQo+
Pg0KPj4gIAkJZXJyID0gdTMyX3NldF9wYXJtcyhuZXQsIHRwLCBiYXNlLCBuZXcsIHRiLA0KPj4g
LQkJCQkgICAgdGNhW1RDQV9SQVRFXSwgZmxhZ3MsIGV4dGFjayk7DQo+PiArCQkJCSAgICB0Y2Fb
VENBX1JBVEVdLCBmbGFncyB8IG5ldy0+ZmxhZ3MsDQo+PiArCQkJCSAgICBleHRhY2spOw0KPj4N
Cj4+ICAJCWlmIChlcnIpIHsNCj4+ICAJCQl1MzJfZGVzdHJveV9rZXkobmV3LCBmYWxzZSk7DQo+
PiBAQCAtMTA2MCw4ICsxMDYxLDggQEAgc3RhdGljIGludCB1MzJfY2hhbmdlKHN0cnVjdCBuZXQg
Km5ldCwgc3RydWN0DQo+c2tfYnVmZiAqaW5fc2tiLA0KPj4gIAl9DQo+PiAgI2VuZGlmDQo+Pg0K
Pj4gLQllcnIgPSB1MzJfc2V0X3Bhcm1zKG5ldCwgdHAsIGJhc2UsIG4sIHRiLCB0Y2FbVENBX1JB
VEVdLCBmbGFncywNCj4+IC0JCQkgICAgZXh0YWNrKTsNCj4+ICsJZXJyID0gdTMyX3NldF9wYXJt
cyhuZXQsIHRwLCBiYXNlLCBuLCB0YiwgdGNhW1RDQV9SQVRFXSwNCj4+ICsJCQkgICAgZmxhZ3Mg
fCBuLT5mbGFncywgZXh0YWNrKTsNCj4+ICAJaWYgKGVyciA9PSAwKSB7DQo+PiAgCQlzdHJ1Y3Qg
dGNfdV9rbm9kZSBfX3JjdSAqKmluczsNCj4+ICAJCXN0cnVjdCB0Y191X2tub2RlICpwaW5zOw0K
DQo=
