Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2B132DAD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgAGRzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:55:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54870 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728266AbgAGRzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:55:42 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007HtPDt031488;
        Tue, 7 Jan 2020 09:55:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Sz9cU7dXOtK8M0Y32CGV7NAW1Rhb8/hDPkl1Amby348=;
 b=LyBRwlnYfZHd8tpDHzyJKuc8BU3BWbM3ibw00vHfGE6+g0WR/lG4JoEbi8DxpaZkQQ0t
 DaMePz5FWFOV1f2sZDyaJkYYA8viQbNDECHXBZto3N8w/Q52A+NVd1VE+jJbrIT+zGC5
 4nJvSNOpGCZ21LF/4itJCddWW8wG/R3qusA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xbbh1vr23-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jan 2020 09:55:26 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 09:55:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD3UUmLfx1LcNgCCubbcbANZP5mA2cbBM9qWIdOiMpJHBhGuswrqJo1pLL00MD0FvoKLgMLoJYBJEfQR9rdFegHyxvTO/LGBVsqDxHYQfTWl47yZeGv++/V51I7W2rNu5OKOMcTXSiDwBjM5pZN0B8HXDS0Q5vUVkDCNMaeKn7NMIOW4zFtK19NS/9qeu7Aee/KmmJRMjLQuDQRIaQ+hinZn37M9nrV8Bwi9LKtTToxpxPHvozRazUIwDDSrrOUCEB3kXyLK59csojr47803de0hxOjHhVEZSclFjin1cS3mmvJkfFawoJLKOFQAGdx4c1bSEXv/B2Xcep/WnUmW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sz9cU7dXOtK8M0Y32CGV7NAW1Rhb8/hDPkl1Amby348=;
 b=THqzDsAvbqzqpX+IyYlrZmTRdqB9LhVJqd/RtCi+mVcOvm/WR4UJtccocVAg5Su4CuX8+IUBRWh7f7c3oxFOO90GoXe4Dzy3pYLwpkipu2V2WYLZ5y2kOESopVMK6ULWxmWI6yXUjpZDRs+0PJtvfiU1dGOx3WeVaTLlCLw3Koj/HD/vBUWmHmTXpErASAHj9fpLeMdJQP+fEfcAbbiYrzkQY7BJy5K8R4XsRLoPabczbULRyTXqRiOyiKSpxB+fSf8BhfJ6oqpv3piAcPXMXAGcwuQKFpSr2efPxj1cyQYpkw2fu5O3RHl0bTnFNn8+nzuRfhkdTmRPJNHTpJ5/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sz9cU7dXOtK8M0Y32CGV7NAW1Rhb8/hDPkl1Amby348=;
 b=SJ0dQW454noGGz54aTheNDldcER0YUYyxbaGKbZR1ykfZrRjEfaMGarjVW8CdA4Mb1fTn2iGNKEoG8SGGbN2AcMlwcOC9uDPgQ9+H7Sx9EOQDAK5/mkj1ey6CHf4qNdau02EHlGmOuOFNcBl0czLD27Gw5/xXlneLQM0flmt9ZA=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1244.namprd15.prod.outlook.com (10.173.210.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 17:55:05 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 17:55:05 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::1:2af9) by CO2PR04CA0105.namprd04.prod.outlook.com (2603:10b6:104:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Tue, 7 Jan 2020 17:55:04 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Andrii Nakryiko" <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Topic: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Index: AQHVvlWQhA1GLUWWnESW6jgQCFjtZafeNfeAgAD1D4CAADywgIAAIsoA
Date:   Tue, 7 Jan 2020 17:55:05 +0000
Message-ID: <c8ed83dc-3f3b-30d2-69fa-3a5c59152034@fb.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
 <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com> <20200107121319.GG290055@krava>
 <20200107155031.GB349285@krava>
In-Reply-To: <20200107155031.GB349285@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:104:6::31) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2af9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 894ea948-13e2-4776-f10b-08d7939aba13
x-ms-traffictypediagnostic: DM5PR15MB1244:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1244E33A459B313C93244777D33F0@DM5PR15MB1244.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(346002)(396003)(136003)(189003)(199004)(31686004)(5660300002)(2906002)(478600001)(4326008)(6512007)(316002)(54906003)(31696002)(16526019)(186003)(6486002)(8936002)(81166006)(81156014)(8676002)(2616005)(6916009)(36756003)(52116002)(6506007)(53546011)(64756008)(66946007)(66556008)(66476007)(86362001)(71200400001)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1244;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b3scCUHHHj5r2svPBc5e1dhsziqNzsDoq3zZV+KTyGickS8ql06oy60U6szLwE7c+cXJf7JWaTlQsRa8F4nPb13p9klTlXsfphVQu3B9KnFop3UTamidHhnbquep1WcfhmfKBJ+KEJkwgew1YR7wJ1fIPhS42qxy2l6PeL+J/jc2Txx/AUI0emthOTvzEU1/HfIYAdupN6OM7UJj14InS7kEyI079vPp+iy35SyIcL0NBwjILXJ/3F5KlSue5Dh+Ii2mg8FDEumk0TTvCNmAocq3XKJtFGiLYR7PKK4+yFDRvbkeIYY49iXD/dhsx+t5/Jou89SJcnxkufyx30bKjw1eLn+GLqOstvUOPOsg4fWs30aREKkw65eAzHqestC1vrB+NI97cPSd8evjOUsR66ytMua7m5C3LW7bEeo8ION3WIaqC4ko0DFJOccRgOtI
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC0A3E5BE93A7C4A9FC2335AD0FD2039@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 894ea948-13e2-4776-f10b-08d7939aba13
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 17:55:05.4489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 86PcgemOw1cjvn9bNkkWZoii2NBOhMHKEZMN9AeWwArmQxwr3Jxa+SpFMErMYSvu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1244
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvNy8yMCA3OjUwIEFNLCBKaXJpIE9sc2Egd3JvdGU6DQo+IE9uIFR1ZSwgSmFuIDA3
LCAyMDIwIGF0IDAxOjEzOjIzUE0gKzAxMDAsIEppcmkgT2xzYSB3cm90ZToNCj4+IE9uIE1vbiwg
SmFuIDA2LCAyMDIwIGF0IDA5OjM2OjE3UE0gKzAwMDAsIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+
Pj4NCj4+Pg0KPj4+IE9uIDEyLzI5LzE5IDY6MzcgQU0sIEppcmkgT2xzYSB3cm90ZToNCj4+Pj4g
SSdtIG5vdCBzdXJlIHdoeSB0aGUgcmVzdHJpY3Rpb24gd2FzIGFkZGVkLA0KPj4+PiBidXQgSSBj
YW4ndCBhY2Nlc3MgcG9pbnRlcnMgdG8gUE9EIHR5cGVzIGxpa2UNCj4+Pj4gY29uc3QgY2hhciAq
IHdoZW4gcHJvYmluZyB2ZnNfcmVhZCBmdW5jdGlvbi4NCj4+Pj4NCj4+Pj4gUmVtb3ZpbmcgdGhl
IGNoZWNrIGFuZCBhbGxvdyBub24gc3RydWN0IHR5cGUNCj4+Pj4gYWNjZXNzIGluIGNvbnRleHQu
DQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEppcmkgT2xzYSA8am9sc2FAa2VybmVsLm9yZz4N
Cj4+Pj4gLS0tDQo+Pj4+ICAgIGtlcm5lbC9icGYvYnRmLmMgfCA2IC0tLS0tLQ0KPj4+PiAgICAx
IGZpbGUgY2hhbmdlZCwgNiBkZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC9icGYvYnRmLmMgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+Pj4+IGluZGV4IGVkMjA3NTg4NDcy
NC4uYWU5MGY2MGFjMWI4IDEwMDY0NA0KPj4+PiAtLS0gYS9rZXJuZWwvYnBmL2J0Zi5jDQo+Pj4+
ICsrKyBiL2tlcm5lbC9icGYvYnRmLmMNCj4+Pj4gQEAgLTM3MTIsMTIgKzM3MTIsNiBAQCBib29s
IGJ0Zl9jdHhfYWNjZXNzKGludCBvZmYsIGludCBzaXplLCBlbnVtIGJwZl9hY2Nlc3NfdHlwZSB0
eXBlLA0KPj4+PiAgICAJLyogc2tpcCBtb2RpZmllcnMgKi8NCj4+Pj4gICAgCXdoaWxlIChidGZf
dHlwZV9pc19tb2RpZmllcih0KSkNCj4+Pj4gICAgCQl0ID0gYnRmX3R5cGVfYnlfaWQoYnRmLCB0
LT50eXBlKTsNCj4+Pj4gLQlpZiAoIWJ0Zl90eXBlX2lzX3N0cnVjdCh0KSkgew0KPj4+PiAtCQli
cGZfbG9nKGxvZywNCj4+Pj4gLQkJCSJmdW5jICclcycgYXJnJWQgdHlwZSAlcyBpcyBub3QgYSBz
dHJ1Y3RcbiIsDQo+Pj4+IC0JCQl0bmFtZSwgYXJnLCBidGZfa2luZF9zdHJbQlRGX0lORk9fS0lO
RCh0LT5pbmZvKV0pOw0KPj4+PiAtCQlyZXR1cm4gZmFsc2U7DQo+Pj4+IC0JfQ0KPj4+DQo+Pj4g
SGksIEppcmksIHRoZSBSRkMgbG9va3MgZ3JlYXQhIEVzcGVjaWFsbHksIHlvdSBhbHNvIHJlZmVy
ZW5jZWQgdGhpcyB3aWxsDQo+Pj4gZ2l2ZSBncmVhdCBwZXJmb3JtYW5jZSBib29zdCBmb3IgYmNj
IHNjcmlwdHMuDQo+Pj4NCj4+PiBDb3VsZCB5b3UgcHJvdmlkZSBtb3JlIGNvbnRleHQgb24gd2h5
IHRoZSBhYm92ZSBjaGFuZ2UgaXMgbmVlZGVkPw0KPj4+IFRoZSBmdW5jdGlvbiBidGZfY3R4X2Fj
Y2VzcyBpcyB1c2VkIHRvIGNoZWNrIHZhbGlkaXR5IG9mIGFjY2Vzc2luZw0KPj4+IGZ1bmN0aW9u
IHBhcmFtZXRlcnMgd2hpY2ggYXJlIHdyYXBwZWQgaW5zaWRlIGEgc3RydWN0dXJlLCBJIGFtIHdv
bmRlcmluZw0KPj4+IHdoYXQga2luZHMgb2YgYWNjZXNzZXMgeW91IHRyaWVkIHRvIGFkZHJlc3Mg
aGVyZS4NCj4+DQo+PiB3aGVuIEkgd2FzIHRyYW5zZm9ybWluZyBvcGVuc25vb3AucHkgdG8gdXNl
IHRoaXMgSSBnb3QgZmFpbCBpbg0KPj4gdGhlcmUgd2hlbiBJIHRyaWVkIHRvIGFjY2VzcyBmaWxl
bmFtZSBhcmcgaW4gZG9fc3lzX29wZW4NCj4+DQo+PiBidXQgYWN0dWFseSBpdCBzZWVtcyB0aGlz
IHNob3VsZCBnZXQgcmVjb2duaXplZCBlYXJsaWVyIGJ5Og0KPj4NCj4+ICAgICAgICAgICAgaWYg
KGJ0Zl90eXBlX2lzX2ludCh0KSkNCj4+ICAgICAgICAgICAgICAgICAgLyogYWNjZXNzaW5nIGEg
c2NhbGFyICovDQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPj4NCj4+IEknbSBu
b3Qgc3VyZSB3aHkgaXQgZGlkIG5vdCBwYXNzIGZvciBjb25zdCBjaGFyKiwgSSdsbCBjaGVjaw0K
PiANCj4gaXQgc2VlbXMgd2UgZG9uJ3QgY2hlY2sgZm9yIHBvaW50ZXIgdG8gc2NhbGFyIChqdXN0
IHZvaWQpLA0KPiB3aGljaCBpcyB0aGUgY2FzZSBpbiBteSBleGFtcGxlICdjb25zdCBjaGFyICpm
aWxlbmFtZScNCg0KVGhhbmtzIGZvciBjbGFyaWZpY2F0aW9uLiBTZWUgc29tZSBjb21tZW50cyBi
ZWxvdy4NCg0KPiANCj4gSSdsbCBwb3N0IHRoaXMgaW4gdjIgd2l0aCBvdGhlciBjaGFuZ2VzDQo+
IA0KPiBqaXJrYQ0KPiANCj4gDQo+IC0tLQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYu
YyBiL2tlcm5lbC9icGYvYnRmLmMNCj4gaW5kZXggZWQyMDc1ODg0NzI0Li42NTBkZjRlZDM0NmUg
MTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvYnRmLmMNCj4gKysrIGIva2VybmVsL2JwZi9idGYu
Yw0KPiBAQCAtMzYzMyw3ICszNjMzLDcgQEAgYm9vbCBidGZfY3R4X2FjY2VzcyhpbnQgb2ZmLCBp
bnQgc2l6ZSwgZW51bSBicGZfYWNjZXNzX3R5cGUgdHlwZSwNCj4gICAJCSAgICBjb25zdCBzdHJ1
Y3QgYnBmX3Byb2cgKnByb2csDQo+ICAgCQkgICAgc3RydWN0IGJwZl9pbnNuX2FjY2Vzc19hdXgg
KmluZm8pDQo+ICAgew0KPiAtCWNvbnN0IHN0cnVjdCBidGZfdHlwZSAqdCA9IHByb2ctPmF1eC0+
YXR0YWNoX2Z1bmNfcHJvdG87DQo+ICsJY29uc3Qgc3RydWN0IGJ0Zl90eXBlICp0cCwgKnQgPSBw
cm9nLT5hdXgtPmF0dGFjaF9mdW5jX3Byb3RvOw0KPiAgIAlzdHJ1Y3QgYnBmX3Byb2cgKnRndF9w
cm9nID0gcHJvZy0+YXV4LT5saW5rZWRfcHJvZzsNCj4gICAJc3RydWN0IGJ0ZiAqYnRmID0gYnBm
X3Byb2dfZ2V0X3RhcmdldF9idGYocHJvZyk7DQo+ICAgCWNvbnN0IGNoYXIgKnRuYW1lID0gcHJv
Zy0+YXV4LT5hdHRhY2hfZnVuY19uYW1lOw0KPiBAQCAtMzY5NSw2ICszNjk1LDE3IEBAIGJvb2wg
YnRmX2N0eF9hY2Nlc3MoaW50IG9mZiwgaW50IHNpemUsIGVudW0gYnBmX2FjY2Vzc190eXBlIHR5
cGUsDQo+ICAgCQkgKi8NCj4gICAJCXJldHVybiB0cnVlOw0KPiAgIA0KPiArCXRwID0gYnRmX3R5
cGVfYnlfaWQoYnRmLCB0LT50eXBlKTsNCj4gKwkvKiBza2lwIG1vZGlmaWVycyAqLw0KPiArCXdo
aWxlIChidGZfdHlwZV9pc19tb2RpZmllcih0cCkpDQo+ICsJCXRwID0gYnRmX3R5cGVfYnlfaWQo
YnRmLCB0cC0+dHlwZSk7DQo+ICsNCj4gKwlpZiAoYnRmX3R5cGVfaXNfaW50KHRwKSkNCj4gKwkJ
LyogVGhpcyBpcyBhIHBvaW50ZXIgc2NhbGFyLg0KPiArCQkgKiBJdCBpcyB0aGUgc2FtZSBhcyBz
Y2FsYXIgZnJvbSB0aGUgdmVyaWZpZXIgc2FmZXR5IHBvdi4NCj4gKwkJICovDQo+ICsJCXJldHVy
biB0cnVlOw0KDQpUaGlzIHNob3VsZCB3b3JrIHNpbmNlOg0KICAgIC0gdGhlIGludCBwb2ludGVy
IHdpbGwgYmUgdHJlYXRlZCBhcyBhIHNjYWxhciBsYXRlciBvbg0KICAgIC0gYnBmX3Byb2JlX3Jl
YWQoKSB3aWxsIGJlIHVzZWQgdG8gcmVhZCB0aGUgY29udGVudHMNCg0KSSBhbSB3b25kZXJpbmcg
d2hldGhlciB3ZSBzaG91bGQgYWRkIHByb3BlciB2ZXJpZmllciBzdXBwb3J0DQp0byBhbGxvdyBw
b2ludGVyIHRvIGludCBjdHggYWNjZXNzLiBUaGVyZSwgdXNlcnMgZG8gbm90IG5lZWQNCnRvIHVz
ZSBicGZfcHJvYmVfcmVhZCgpIHRvIGRlcmVmZXJlbmNlIHRoZSBwb2ludGVyLg0KDQpEaXNjdXNz
ZWQgd2l0aCBNYXJ0aW4sIG1heWJlIHNvbWV3aGVyZSBpbiBjaGVja19wdHJfdG9fYnRmX2FjY2Vz
cygpLA0KYmVmb3JlIGJ0Zl9zdHJ1Y3RfYWNjZXNzKCksIGNoZWNraW5nIGlmIGl0IGlzIGEgcG9p
bnRlciB0byBpbnQvZW51bSwNCml0IHNob3VsZCBqdXN0IGFsbG93IGFuZCByZXR1cm4gU0NBTEFS
X1ZBTFVFLg0KDQpJZiB5b3UgZG8gdmVyaWZpZXIgY2hhbmdlcywgcGxlYXNlIGVuc3VyZSBicGZf
cHJvYmVfcmVhZCgpIGlzIG5vdA0KbmVlZGVkIGFueSBtb3JlLiBJbiBiY2MsIHlvdSBuZWVkIHRv
IGhhY2sgdG8gcHJldmVudCByZXdyaXRlciB0bw0KcmUtaW50cm9kdWNlIGJwZl9wcm9iZV9yZWFk
KCkgOi0pLg0KDQo+ICsNCj4gICAJLyogdGhpcyBpcyBhIHBvaW50ZXIgdG8gYW5vdGhlciB0eXBl
ICovDQo+ICAgCWluZm8tPnJlZ190eXBlID0gUFRSX1RPX0JURl9JRDsNCj4gICAJaW5mby0+YnRm
X2lkID0gdC0+dHlwZTsNCj4gDQo=
