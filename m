Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9072132E66
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgAGS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:28:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727925AbgAGS2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:28:30 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 007INSE1013485;
        Tue, 7 Jan 2020 10:28:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/uuliCpQbFYW9DrrcKu0Kob9BErDzm8zSVayqxbppNU=;
 b=p8VthtTcayGOSa9kNzkyx90ZLi1z3fy8mF/85gruGneEVbdlwe1A83HnJRBUF8+JsxWc
 LniEASO+CQbZO9L3N8fvvpjCQh5qROxW6wbDnF3LVLq7W+YBaHKgQYg5H72DO4hHZt3m
 SXD/11NkhqPrTToUcSoHOIxRjsJNHdL9CWQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xcerhcg91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jan 2020 10:28:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jan 2020 10:28:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b13dxUsyWEx3UR1pSMY8w/oaOWyhOJWy1ydB7VvbpAZTw6e+tejav5RST1sRj/PsgBRVRsnRcp2m/4S5Xw4bIJXo9nksjvgckbU0Ky4Ewrabp515ynDwVqldLRlT4jgW4lGR/gf5xT8IMr0Zl4MDJD45iY4epnhJER8fDBapfWcLBwV2IQd6WGOmRkvM/8Z/upDpwdpIbEQZob+V5dcQRQOzk/Aq3vcu40Z4nXlZOHqOILGgSk+LbmdD4eYAmCX3mS8yTcFIy9GZn2GUUb1Hz98FJiuSUOe7za9QjcI8xA8btDjknsY0LXMokRQj1pAYusWW/soyOfMUwDxLqCqqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uuliCpQbFYW9DrrcKu0Kob9BErDzm8zSVayqxbppNU=;
 b=NQHqYEVPbhPHCA5Yn2zt4UHU2yjygm2i2uqlVSwsDMMPqmOb7vuDKwkcuKNieJgMwjEHPtk257N2e/VGBXxB18P4LUtIXuSEdf6d2zt0kogKQgOgrg2TXIFZ/7PtJowvXHGba3xw3Ix1acXEalHk13JA4x4p9zDHhORQBFKiS7I8IZiqBVizpoZNIXRlxsVPKRCySNjafbmUXWDzppyFWi+aL+9+lP5fkOoY8bsfj9iV2aXzvVqUF47dnJf5nh1BFQMRsg0o5LgK+c8VCRcs/Q4U8DW4JDYXi8N6aqj3OYF5qvJqP2FHFdK0mgJs3QfEQTind2/IJYobKgfw2EXcfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uuliCpQbFYW9DrrcKu0Kob9BErDzm8zSVayqxbppNU=;
 b=PodVShOUbYrfRWaaMXLMJ6A2fdueOyi3dsYUJMqItcGMax2Nkc881y0jr4hOaI72bN9NbhBHzXbWsHd/lNuyIWULUhd4CPFbnahc66hAkrfARVxVjwj2QSaxqG4IT/HNQZan/QL9/y0T7OaN3ILTBopW41SKXzhBmrx1vwmWpFQ=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 18:28:11 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 18:28:11 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::1:2af9) by MWHPR14CA0060.namprd14.prod.outlook.com (2603:10b6:300:81::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Tue, 7 Jan 2020 18:28:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Andrii Nakryiko" <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Topic: Re: [PATCH 1/5] bpf: Allow non struct type for btf ctx access
Thread-Index: AQHVvlWQhA1GLUWWnESW6jgQCFjtZafeNfeAgAD1D4CAADywgIAAIsoAgAAJPwA=
Date:   Tue, 7 Jan 2020 18:28:11 +0000
Message-ID: <962209d7-cdfa-9ee3-8a12-6375091843cf@fb.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-2-jolsa@kernel.org>
 <d7b8cecf-d28a-1f4d-eb2b-eb8a601b9914@fb.com> <20200107121319.GG290055@krava>
 <20200107155031.GB349285@krava> <c8ed83dc-3f3b-30d2-69fa-3a5c59152034@fb.com>
In-Reply-To: <c8ed83dc-3f3b-30d2-69fa-3a5c59152034@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0060.namprd14.prod.outlook.com
 (2603:10b6:300:81::22) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2af9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ed3ba37-abfe-4192-b045-08d7939f59c5
x-ms-traffictypediagnostic: DM5PR15MB1675:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1675D3B2CF3FA2973441C8AAD33F0@DM5PR15MB1675.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39860400002)(366004)(136003)(189003)(199004)(66556008)(31686004)(81166006)(66446008)(64756008)(66476007)(6512007)(81156014)(66946007)(8936002)(2616005)(36756003)(6486002)(8676002)(4326008)(478600001)(54906003)(16526019)(6916009)(186003)(71200400001)(52116002)(2906002)(6506007)(5660300002)(86362001)(316002)(31696002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1675;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mIisL0mlrk5goI1pHGxe3KMMD3PCxiAuR9oYS1zAxS+NDypbECedQoZvLcB0i4IAgyQuRfIxJiwM1nBRvflMkqFBNzplUL7bDB3ajTDatUcykmnIdE7HyBial6W/MzUQJVECoSSWTBShbADwlwSAocZWj6OPLwPWPjwWTZThEviyws2GHJu9HWp5lHrlCKXfQqxVt9IsEiKhT22ip+0epdlwaqUHQ2iUAH9/UbwVhFhlZa6Ayweswn0PgoMETdQiKF2axYbcLSs8TQ4MxNlaEagR4DltXtQqQNIex5NO5Tw80Cn3wSw3KQC1oPmOJrqjcH0bn4FRiV8HxhkWM9z37HelXAGZfRmK8LfUpjVDgA5gMukWIL3cVqI9pHkxCiO7Hplh9lpivmXjOSanIGk0wXeJNpiOlH5KMiaGYF8EHukdJDbinwn3YiD8hT8d14rt
Content-Type: text/plain; charset="utf-8"
Content-ID: <745A8F8D5666DB4080B34E0109BD9BBF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed3ba37-abfe-4192-b045-08d7939f59c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 18:28:11.3374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5I3bcXvUb/vRnsDqPdDNqXvY2qQc+KmFm+/Gjf2jyMn6888V7Tbvu+cOrtgWZaO4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1675
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvNy8yMCA5OjU1IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiANCj4gDQo+IE9u
IDEvNy8yMCA3OjUwIEFNLCBKaXJpIE9sc2Egd3JvdGU6DQo+PiBPbiBUdWUsIEphbiAwNywgMjAy
MCBhdCAwMToxMzoyM1BNICswMTAwLCBKaXJpIE9sc2Egd3JvdGU6DQo+Pj4gT24gTW9uLCBKYW4g
MDYsIDIwMjAgYXQgMDk6MzY6MTdQTSArMDAwMCwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4+Pj4N
Cj4+Pj4NCj4+Pj4gT24gMTIvMjkvMTkgNjozNyBBTSwgSmlyaSBPbHNhIHdyb3RlOg0KPj4+Pj4g
SSdtIG5vdCBzdXJlIHdoeSB0aGUgcmVzdHJpY3Rpb24gd2FzIGFkZGVkLA0KPj4+Pj4gYnV0IEkg
Y2FuJ3QgYWNjZXNzIHBvaW50ZXJzIHRvIFBPRCB0eXBlcyBsaWtlDQo+Pj4+PiBjb25zdCBjaGFy
ICogd2hlbiBwcm9iaW5nIHZmc19yZWFkIGZ1bmN0aW9uLg0KPj4+Pj4NCj4+Pj4+IFJlbW92aW5n
IHRoZSBjaGVjayBhbmQgYWxsb3cgbm9uIHN0cnVjdCB0eXBlDQo+Pj4+PiBhY2Nlc3MgaW4gY29u
dGV4dC4NCj4+Pj4+DQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKaXJpIE9sc2EgPGpvbHNhQGtlcm5l
bC5vcmc+DQo+Pj4+PiAtLS0NCj4+Pj4+ICAgICBrZXJuZWwvYnBmL2J0Zi5jIHwgNiAtLS0tLS0N
Cj4+Pj4+ICAgICAxIGZpbGUgY2hhbmdlZCwgNiBkZWxldGlvbnMoLSkNCj4+Pj4+DQo+Pj4+PiBk
aWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYuYyBiL2tlcm5lbC9icGYvYnRmLmMNCj4+Pj4+IGlu
ZGV4IGVkMjA3NTg4NDcyNC4uYWU5MGY2MGFjMWI4IDEwMDY0NA0KPj4+Pj4gLS0tIGEva2VybmVs
L2JwZi9idGYuYw0KPj4+Pj4gKysrIGIva2VybmVsL2JwZi9idGYuYw0KPj4+Pj4gQEAgLTM3MTIs
MTIgKzM3MTIsNiBAQCBib29sIGJ0Zl9jdHhfYWNjZXNzKGludCBvZmYsIGludCBzaXplLCBlbnVt
IGJwZl9hY2Nlc3NfdHlwZSB0eXBlLA0KPj4+Pj4gICAgIAkvKiBza2lwIG1vZGlmaWVycyAqLw0K
Pj4+Pj4gICAgIAl3aGlsZSAoYnRmX3R5cGVfaXNfbW9kaWZpZXIodCkpDQo+Pj4+PiAgICAgCQl0
ID0gYnRmX3R5cGVfYnlfaWQoYnRmLCB0LT50eXBlKTsNCj4+Pj4+IC0JaWYgKCFidGZfdHlwZV9p
c19zdHJ1Y3QodCkpIHsNCj4+Pj4+IC0JCWJwZl9sb2cobG9nLA0KPj4+Pj4gLQkJCSJmdW5jICcl
cycgYXJnJWQgdHlwZSAlcyBpcyBub3QgYSBzdHJ1Y3RcbiIsDQo+Pj4+PiAtCQkJdG5hbWUsIGFy
ZywgYnRmX2tpbmRfc3RyW0JURl9JTkZPX0tJTkQodC0+aW5mbyldKTsNCj4+Pj4+IC0JCXJldHVy
biBmYWxzZTsNCj4+Pj4+IC0JfQ0KPj4+Pg0KPj4+PiBIaSwgSmlyaSwgdGhlIFJGQyBsb29rcyBn
cmVhdCEgRXNwZWNpYWxseSwgeW91IGFsc28gcmVmZXJlbmNlZCB0aGlzIHdpbGwNCj4+Pj4gZ2l2
ZSBncmVhdCBwZXJmb3JtYW5jZSBib29zdCBmb3IgYmNjIHNjcmlwdHMuDQo+Pj4+DQo+Pj4+IENv
dWxkIHlvdSBwcm92aWRlIG1vcmUgY29udGV4dCBvbiB3aHkgdGhlIGFib3ZlIGNoYW5nZSBpcyBu
ZWVkZWQ/DQo+Pj4+IFRoZSBmdW5jdGlvbiBidGZfY3R4X2FjY2VzcyBpcyB1c2VkIHRvIGNoZWNr
IHZhbGlkaXR5IG9mIGFjY2Vzc2luZw0KPj4+PiBmdW5jdGlvbiBwYXJhbWV0ZXJzIHdoaWNoIGFy
ZSB3cmFwcGVkIGluc2lkZSBhIHN0cnVjdHVyZSwgSSBhbSB3b25kZXJpbmcNCj4+Pj4gd2hhdCBr
aW5kcyBvZiBhY2Nlc3NlcyB5b3UgdHJpZWQgdG8gYWRkcmVzcyBoZXJlLg0KPj4+DQo+Pj4gd2hl
biBJIHdhcyB0cmFuc2Zvcm1pbmcgb3BlbnNub29wLnB5IHRvIHVzZSB0aGlzIEkgZ290IGZhaWwg
aW4NCj4+PiB0aGVyZSB3aGVuIEkgdHJpZWQgdG8gYWNjZXNzIGZpbGVuYW1lIGFyZyBpbiBkb19z
eXNfb3Blbg0KPj4+DQo+Pj4gYnV0IGFjdHVhbHkgaXQgc2VlbXMgdGhpcyBzaG91bGQgZ2V0IHJl
Y29nbml6ZWQgZWFybGllciBieToNCj4+Pg0KPj4+ICAgICAgICAgICAgIGlmIChidGZfdHlwZV9p
c19pbnQodCkpDQo+Pj4gICAgICAgICAgICAgICAgICAgLyogYWNjZXNzaW5nIGEgc2NhbGFyICov
DQo+Pj4gICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQo+Pj4NCj4+PiBJJ20gbm90IHN1
cmUgd2h5IGl0IGRpZCBub3QgcGFzcyBmb3IgY29uc3QgY2hhciosIEknbGwgY2hlY2sNCj4+DQo+
PiBpdCBzZWVtcyB3ZSBkb24ndCBjaGVjayBmb3IgcG9pbnRlciB0byBzY2FsYXIgKGp1c3Qgdm9p
ZCksDQo+PiB3aGljaCBpcyB0aGUgY2FzZSBpbiBteSBleGFtcGxlICdjb25zdCBjaGFyICpmaWxl
bmFtZScNCj4gDQo+IFRoYW5rcyBmb3IgY2xhcmlmaWNhdGlvbi4gU2VlIHNvbWUgY29tbWVudHMg
YmVsb3cuDQo+IA0KPj4NCj4+IEknbGwgcG9zdCB0aGlzIGluIHYyIHdpdGggb3RoZXIgY2hhbmdl
cw0KPj4NCj4+IGppcmthDQo+Pg0KPj4NCj4+IC0tLQ0KPj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9i
cGYvYnRmLmMgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+PiBpbmRleCBlZDIwNzU4ODQ3MjQuLjY1MGRm
NGVkMzQ2ZSAxMDA2NDQNCj4+IC0tLSBhL2tlcm5lbC9icGYvYnRmLmMNCj4+ICsrKyBiL2tlcm5l
bC9icGYvYnRmLmMNCj4+IEBAIC0zNjMzLDcgKzM2MzMsNyBAQCBib29sIGJ0Zl9jdHhfYWNjZXNz
KGludCBvZmYsIGludCBzaXplLCBlbnVtIGJwZl9hY2Nlc3NfdHlwZSB0eXBlLA0KPj4gICAgCQkg
ICAgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpwcm9nLA0KPj4gICAgCQkgICAgc3RydWN0IGJwZl9p
bnNuX2FjY2Vzc19hdXggKmluZm8pDQo+PiAgICB7DQo+PiAtCWNvbnN0IHN0cnVjdCBidGZfdHlw
ZSAqdCA9IHByb2ctPmF1eC0+YXR0YWNoX2Z1bmNfcHJvdG87DQo+PiArCWNvbnN0IHN0cnVjdCBi
dGZfdHlwZSAqdHAsICp0ID0gcHJvZy0+YXV4LT5hdHRhY2hfZnVuY19wcm90bzsNCj4+ICAgIAlz
dHJ1Y3QgYnBmX3Byb2cgKnRndF9wcm9nID0gcHJvZy0+YXV4LT5saW5rZWRfcHJvZzsNCj4+ICAg
IAlzdHJ1Y3QgYnRmICpidGYgPSBicGZfcHJvZ19nZXRfdGFyZ2V0X2J0Zihwcm9nKTsNCj4+ICAg
IAljb25zdCBjaGFyICp0bmFtZSA9IHByb2ctPmF1eC0+YXR0YWNoX2Z1bmNfbmFtZTsNCj4+IEBA
IC0zNjk1LDYgKzM2OTUsMTcgQEAgYm9vbCBidGZfY3R4X2FjY2VzcyhpbnQgb2ZmLCBpbnQgc2l6
ZSwgZW51bSBicGZfYWNjZXNzX3R5cGUgdHlwZSwNCj4+ICAgIAkJICovDQo+PiAgICAJCXJldHVy
biB0cnVlOw0KPj4gICAgDQo+PiArCXRwID0gYnRmX3R5cGVfYnlfaWQoYnRmLCB0LT50eXBlKTsN
Cj4+ICsJLyogc2tpcCBtb2RpZmllcnMgKi8NCj4+ICsJd2hpbGUgKGJ0Zl90eXBlX2lzX21vZGlm
aWVyKHRwKSkNCj4+ICsJCXRwID0gYnRmX3R5cGVfYnlfaWQoYnRmLCB0cC0+dHlwZSk7DQo+PiAr
DQo+PiArCWlmIChidGZfdHlwZV9pc19pbnQodHApKQ0KPj4gKwkJLyogVGhpcyBpcyBhIHBvaW50
ZXIgc2NhbGFyLg0KPj4gKwkJICogSXQgaXMgdGhlIHNhbWUgYXMgc2NhbGFyIGZyb20gdGhlIHZl
cmlmaWVyIHNhZmV0eSBwb3YuDQo+PiArCQkgKi8NCj4+ICsJCXJldHVybiB0cnVlOw0KPiANCj4g
VGhpcyBzaG91bGQgd29yayBzaW5jZToNCj4gICAgICAtIHRoZSBpbnQgcG9pbnRlciB3aWxsIGJl
IHRyZWF0ZWQgYXMgYSBzY2FsYXIgbGF0ZXIgb24NCj4gICAgICAtIGJwZl9wcm9iZV9yZWFkKCkg
d2lsbCBiZSB1c2VkIHRvIHJlYWQgdGhlIGNvbnRlbnRzDQo+IA0KPiBJIGFtIHdvbmRlcmluZyB3
aGV0aGVyIHdlIHNob3VsZCBhZGQgcHJvcGVyIHZlcmlmaWVyIHN1cHBvcnQNCj4gdG8gYWxsb3cg
cG9pbnRlciB0byBpbnQgY3R4IGFjY2Vzcy4gVGhlcmUsIHVzZXJzIGRvIG5vdCBuZWVkDQo+IHRv
IHVzZSBicGZfcHJvYmVfcmVhZCgpIHRvIGRlcmVmZXJlbmNlIHRoZSBwb2ludGVyLg0KPiANCj4g
RGlzY3Vzc2VkIHdpdGggTWFydGluLCBtYXliZSBzb21ld2hlcmUgaW4gY2hlY2tfcHRyX3RvX2J0
Zl9hY2Nlc3MoKSwNCj4gYmVmb3JlIGJ0Zl9zdHJ1Y3RfYWNjZXNzKCksIGNoZWNraW5nIGlmIGl0
IGlzIGEgcG9pbnRlciB0byBpbnQvZW51bSwNCj4gaXQgc2hvdWxkIGp1c3QgYWxsb3cgYW5kIHJl
dHVybiBTQ0FMQVJfVkFMVUUuDQoNCmRvdWJsZSBjaGVja2VkIGNoZWNrX3B0cl90b19idGZfYWNj
ZXNzKCkgYW5kIGJ0Zl9zdHJ1Y3RfYWNjZXNzKCkuDQpidGZfc3RydWN0X2FjY2VzcygpIGFscmVh
ZHkgcmV0dXJucyBTQ0FMQVJfVkFMVUUgZm9yIHBvaW50ZXIgdG8gDQppbnQvZW51bS4gU28gdmVy
aWZpZXIgY2hhbmdlIGlzIHByb2JhYmx5IG5vdCBuZWVkZWQuDQoNCkluIHlvdXIgYWJvdmUgY29k
ZSwgY291bGQgeW91IGRvDQogICAgYnRmX3R5cGVfaXNfaW50KHQpIHx8IGJ0Zl90eXBlX2lzX2Vu
dW0odCkNCndoaWNoIHdpbGwgY292ZXIgcG9pbnRlciB0byBlbnVtIGFzIHdlbGw/DQoNCj4gDQo+
IElmIHlvdSBkbyB2ZXJpZmllciBjaGFuZ2VzLCBwbGVhc2UgZW5zdXJlIGJwZl9wcm9iZV9yZWFk
KCkgaXMgbm90DQo+IG5lZWRlZCBhbnkgbW9yZS4gSW4gYmNjLCB5b3UgbmVlZCB0byBoYWNrIHRv
IHByZXZlbnQgcmV3cml0ZXIgdG8NCj4gcmUtaW50cm9kdWNlIGJwZl9wcm9iZV9yZWFkKCkgOi0p
Lg0KPiANCj4+ICsNCj4+ICAgIAkvKiB0aGlzIGlzIGEgcG9pbnRlciB0byBhbm90aGVyIHR5cGUg
Ki8NCj4+ICAgIAlpbmZvLT5yZWdfdHlwZSA9IFBUUl9UT19CVEZfSUQ7DQo+PiAgICAJaW5mby0+
YnRmX2lkID0gdC0+dHlwZTsNCj4+DQo=
