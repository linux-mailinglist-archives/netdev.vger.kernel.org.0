Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124B177AB0
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbfG0RI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:08:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22160 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387856AbfG0RI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:08:56 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RH4jjx020283;
        Sat, 27 Jul 2019 10:08:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YxGz/74tcwCqiM4o2USaBrDhbjfpdA/JqUbUV7K6ZpQ=;
 b=H0w7Hwgs7OpL9XE4sSeuL4Ub/TikA2ebR+RYCBsXPXyoS82Cva9thy1oEJc57EHDmw4h
 34WWm8WhiLtcTD4kgFKUEmpOVJ9ON6+3PYPEvhyv/oZLIauY/Ip3F/8FxQQp9JCXP2pf
 mZVKsFIi3CVtaedF+oWzUZawbbJSvZkRULM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0ma0rxba-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 27 Jul 2019 10:08:30 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 10:08:29 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 27 Jul 2019 10:08:28 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 10:08:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwONNwygm26+5yxEhuTBZro046ckrkqTZIWr3fZ/ZPzWtrar2+uy7VQZEtXcmv1tI2C9t98W4aFYMfnfBKpMu9qWzK7W2nBBAEt/D4m0HxAThpgo1oEJ5EsBagYodOc1s5F9NBKFLbiPuSJt7giehRVarV9Hcc43CsiF1Wvk9E+XrCYv3zDdGJsMd1JjfY+lYw3M9kVEJfBhwyRQaDqm7v5SbZZcV8eaWRJsHy7K3kR2jsXX7mzoOBCCA84j27Vqk+vUgq278Dg42flD4Z4j1HnnUUHNvlFxiH6LZxPda0Q6cd9kdIbic4UaeLQiCK5X30ukutCJTMyOy8sITGp30A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxGz/74tcwCqiM4o2USaBrDhbjfpdA/JqUbUV7K6ZpQ=;
 b=HWXUj1kpGPm5uIIyZ5pdqBMjxCifaZkuw4AtkGW5Z8mkTcroKgABMogrMbfTcAFb2iceWHEv8jYjn2cfI5pA8+/cJ+thlE9ZjMG/5r83iRrMaymmmmqO5ftVk27+pCpAGBeio8532TmECetnsrmVpaSdcOWqcnhVPE2HuAqdHX4DrgXm2MKr38cUJDpbmwXSe4YL5txsypuznSL7bNpCod4SOjtWc4ghzHlD2RuPy/YPpQrl+HaFNAtvbqDKtr8nCtKBTKePrt2+7t3hoFI5KCVOD2S0iCO8lt9+gqmcG5mSlvVfKgWFccRh4qf+qn9x4QCEqA8AjXHptaXPc4S01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxGz/74tcwCqiM4o2USaBrDhbjfpdA/JqUbUV7K6ZpQ=;
 b=CJnYXGj9pWtcT1c9/bI0zqxMygrnoVnSFtvumqU4UkK2yPHsVrFqPR/gsuKquFMwiF1R9JkCXRrXYZ+gCZP/xY09MkiYyzRicYs49FXM3J2jPsOO1kfV8HJBOF0cYX4bOJehpFKczRmawVmBkf2CJZ8HQcgOp96j8HEVG6xKL8I=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2278.namprd15.prod.outlook.com (52.135.197.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Sat, 27 Jul 2019 17:08:12 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 17:08:12 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Topic: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Index: AQHVQ4xS9PP3XA7/nkqulb+RBeHJq6bcleMAgADHHgCAAAbMgP//jN8AgAEkTwyAAJ+kgA==
Date:   Sat, 27 Jul 2019 17:08:11 +0000
Message-ID: <934a2a0a-c3fb-fd75-b8a3-c1042d73ca0c@fb.com>
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
 <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com>
 <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
 <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
In-Reply-To: <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0036.prod.exchangelabs.com (2603:10b6:300:101::22)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:16cd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10a58177-1c58-4e86-b5b8-08d712b5012b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2278;
x-ms-traffictypediagnostic: BYAPR15MB2278:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB227807DB7B697E1D81BC816CD3C30@BYAPR15MB2278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(376002)(346002)(39860400002)(45914002)(189003)(31014005)(199004)(40764003)(52314003)(11346002)(316002)(76176011)(386003)(2906002)(6246003)(486006)(7416002)(102836004)(2501003)(68736007)(8936002)(46003)(476003)(446003)(6506007)(53546011)(36756003)(71200400001)(86362001)(31696002)(81156014)(5660300002)(81166006)(8676002)(14454004)(256004)(66946007)(66476007)(64756008)(66556008)(66446008)(6486002)(229853002)(6436002)(14444005)(6306002)(6512007)(110136005)(478600001)(25786009)(186003)(4326008)(99286004)(966005)(7736002)(31686004)(2616005)(71190400001)(52116002)(53936002)(305945005)(54906003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2278;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NqiZmpqowOmHdOghP2N1Dmq7vgIk1STYjC31akf1Wq6dhBdUMRo7rp18ArTDR7KL67SYBOJoSOkwWuYdf7lb0M7VQ8Ckzrm8Hj6LYbzvIGdlTGMUAfZ2zQDMr9Rxsvm0bf0qhEXZfykKydJeF1gUlIUn8EK9lpd1aNyJLGAkkJWmNo/fEQyFshrDlgm8TFNYUa3cf2y4c9J/ePQJy394xrRSIaESw2pUFzMythySw7aD7z6LMIUDFCyfFmfcUrIB4d1ABxkMGNAcbK21G+vWKte0MO2wAqlPVysPEvWeF8VWw8glTTjk4hZ+u5Gs1Gg/ZIF3FNTFMKdWeCUkochqVmQi+U86Fef1yGia84F6A/N+MpBhi/4FgL+mhSXwPyfZr9BdlMlVhuDT2/on2J91hvhef5eUjPeF6b8jHLrDAzw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <197C97ED56EA194985E51A7D661AEC4B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a58177-1c58-4e86-b5b8-08d712b5012b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 17:08:11.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjcvMTkgMTI6MzYgQU0sIFNlZGF0IERpbGVrIHdyb3RlOg0KPiBPbiBTYXQsIEp1
bCAyNywgMjAxOSBhdCA0OjI0IEFNIEFsZXhlaSBTdGFyb3ZvaXRvdg0KPiA8YWxleGVpLnN0YXJv
dm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gRnJpLCBKdWwgMjYsIDIwMTkgYXQg
MjoxOSBQTSBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPiB3cm90ZToNCj4+Pg0K
Pj4+IE9uIEZyaSwgSnVsIDI2LCAyMDE5IGF0IDExOjEwIFBNIFlvbmdob25nIFNvbmcgPHloc0Bm
Yi5jb20+IHdyb3RlOg0KPj4+Pg0KPj4+Pg0KPj4+Pg0KPj4+PiBPbiA3LzI2LzE5IDI6MDIgUE0s
IFNlZGF0IERpbGVrIHdyb3RlOg0KPj4+Pj4gT24gRnJpLCBKdWwgMjYsIDIwMTkgYXQgMTA6Mzgg
UE0gU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4+Pj4NCj4+
Pj4+PiBIaSBZb25naG9uZyBTb25nLA0KPj4+Pj4+DQo+Pj4+Pj4gT24gRnJpLCBKdWwgMjYsIDIw
MTkgYXQgNTo0NSBQTSBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiB3cm90ZToNCj4+Pj4+Pj4N
Cj4+Pj4+Pj4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gT24gNy8yNi8xOSAxOjI2IEFNLCBTZWRhdCBEaWxl
ayB3cm90ZToNCj4+Pj4+Pj4+IEhpLA0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IEkgaGF2ZSBvcGVuZWQg
YSBuZXcgaXNzdWUgaW4gdGhlIENsYW5nQnVpbHRMaW51eCBpc3N1ZSB0cmFja2VyLg0KPj4+Pj4+
Pg0KPj4+Pj4+PiBHbGFkIHRvIGtub3cgY2xhbmcgOSBoYXMgYXNtIGdvdG8gc3VwcG9ydCBhbmQg
bm93IEl0IGNhbiBjb21waWxlDQo+Pj4+Pj4+IGtlcm5lbCBhZ2Fpbi4NCj4+Pj4+Pj4NCj4+Pj4+
Pg0KPj4+Pj4+IFl1cHAuDQo+Pj4+Pj4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBJIGFtIHNlZWluZyBh
IHByb2JsZW0gaW4gdGhlIGFyZWEgYnBmL3NlY2NvbXAgY2F1c2luZw0KPj4+Pj4+Pj4gc3lzdGVt
ZC9qb3VybmFsZC91ZGV2ZCBzZXJ2aWNlcyB0byBmYWlsLg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IFtG
cmkgSnVsIDI2IDA4OjA4OjQzIDIwMTldIHN5c3RlbWRbNDUzXTogc3lzdGVtZC11ZGV2ZC5zZXJ2
aWNlOiBGYWlsZWQNCj4+Pj4+Pj4+IHRvIGNvbm5lY3Qgc3Rkb3V0IHRvIHRoZSBqb3VybmFsIHNv
Y2tldCwgaWdub3Jpbmc6IENvbm5lY3Rpb24gcmVmdXNlZA0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IFRo
aXMgaGFwcGVucyB3aGVuIEkgdXNlIHRoZSAoTExWTSkgTExEIGxkLmxsZC05IGxpbmtlciBidXQg
bm90IHdpdGgNCj4+Pj4+Pj4+IEJGRCBsaW5rZXIgbGQuYmZkIG9uIERlYmlhbi9idXN0ZXIgQU1E
NjQuDQo+Pj4+Pj4+PiBJbiBib3RoIGNhc2VzIEkgdXNlIGNsYW5nLTkgKHByZXJlbGVhc2UpLg0K
Pj4+Pj4+Pg0KPj4+Pj4+PiBMb29rcyBsaWtlIGl0IGlzIGEgbGxkIGJ1Zy4NCj4+Pj4+Pj4NCj4+
Pj4+Pj4gSSBzZWUgdGhlIHN0YWNrIHRyYWNlIGhhcyBfX2JwZl9wcm9nX3J1bjMyKCkgd2hpY2gg
aXMgdXNlZCBieQ0KPj4+Pj4+PiBrZXJuZWwgYnBmIGludGVycHJldGVyLiBDb3VsZCB5b3UgdHJ5
IHRvIGVuYWJsZSBicGYgaml0DQo+Pj4+Pj4+ICAgICAgc3lzY3RsIG5ldC5jb3JlLmJwZl9qaXRf
ZW5hYmxlID0gMQ0KPj4+Pj4+PiBJZiB0aGlzIHBhc3NlZCwgaXQgd2lsbCBwcm92ZSBpdCBpcyBp
bnRlcnByZXRlciByZWxhdGVkLg0KPj4+Pj4+Pg0KPj4+Pj4+DQo+Pj4+Pj4gQWZ0ZXIuLi4NCj4+
Pj4+Pg0KPj4+Pj4+IHN5c2N0bCAtdyBuZXQuY29yZS5icGZfaml0X2VuYWJsZT0xDQo+Pj4+Pj4N
Cj4+Pj4+PiBJIGNhbiBzdGFydCBhbGwgZmFpbGVkIHN5c3RlbWQgc2VydmljZXMuDQo+Pj4+Pj4N
Cj4+Pj4+PiBzeXN0ZW1kLWpvdXJuYWxkLnNlcnZpY2UNCj4+Pj4+PiBzeXN0ZW1kLXVkZXZkLnNl
cnZpY2UNCj4+Pj4+PiBoYXZlZ2VkLnNlcnZpY2UNCj4+Pj4+Pg0KPj4+Pj4+IFRoaXMgaXMgaW4g
bWFpbnRlbmFuY2UgbW9kZS4NCj4+Pj4+Pg0KPj4+Pj4+IFdoYXQgaXMgbmV4dDogRG8gc2V0IGEg
cGVybWFuZW50IHN5c2N0bCBzZXR0aW5nIGZvciBuZXQuY29yZS5icGZfaml0X2VuYWJsZT8NCj4+
Pj4+Pg0KPj4+Pj4NCj4+Pj4+IFRoaXMgaXMgd2hhdCBJIGRpZDoNCj4+Pj4NCj4+Pj4gSSBwcm9i
YWJseSB3b24ndCBoYXZlIGN5Y2xlcyB0byBkZWJ1ZyB0aGlzIHBvdGVudGlhbCBsbGQgaXNzdWUu
DQo+Pj4+IE1heWJlIHlvdSBhbHJlYWR5IGRpZCwgSSBzdWdnZXN0IHlvdSBwdXQgZW5vdWdoIHJl
cHJvZHVjaWJsZQ0KPj4+PiBkZXRhaWxzIGluIHRoZSBidWcgeW91IGZpbGVkIGFnYWluc3QgbGxk
IHNvIHRoZXkgY2FuIHRha2UgYSBsb29rLg0KPj4+Pg0KPj4+DQo+Pj4gSSB1bmRlcnN0YW5kIGFu
ZCB3aWxsIHB1dCB0aGUgam91cm5hbGN0bC1sb2cgaW50byB0aGUgQ0JMIGlzc3VlDQo+Pj4gdHJh
Y2tlciBhbmQgdXBkYXRlIGluZm9ybWF0aW9ucy4NCj4+Pg0KPj4+IFRoYW5rcyBmb3IgeW91ciBo
ZWxwIHVuZGVyc3RhbmRpbmcgdGhlIEJQRiBjb3JyZWxhdGlvbnMuDQo+Pj4NCj4+PiBJcyBzZXR0
aW5nICduZXQuY29yZS5icGZfaml0X2VuYWJsZSA9IDInIGhlbHBmdWwgaGVyZT8NCj4+DQo+PiBq
aXRfZW5hYmxlPTEgaXMgZW5vdWdoLg0KPj4gT3IgdXNlIENPTkZJR19CUEZfSklUX0FMV0FZU19P
TiB0byB3b3JrYXJvdW5kLg0KPj4NCj4+IEl0IHNvdW5kcyBsaWtlIGNsYW5nIG1pc2NvbXBpbGVz
IGludGVycHJldGVyLg0KPj4gbW9kcHJvYmUgdGVzdF9icGYNCj4+IHNob3VsZCBiZSBhYmxlIHRv
IHBvaW50IG91dCB3aGljaCBwYXJ0IG9mIGludGVycHJldGVyIGlzIGJyb2tlbi4NCj4gDQo+IE1h
eWJlIHdlIG5lZWQgc29tZXRoaW5nIGxpa2UuLi4NCj4gDQo+ICJicGY6IERpc2FibGUgR0NDIC1m
Z2NzZSBvcHRpbWl6YXRpb24gZm9yIF9fX2JwZl9wcm9nX3J1bigpIg0KPiANCj4gLi4uZm9yIGNs
YW5nPw0KDQpOb3Qgc3VyZSBob3cgZG8geW91IGdldCBjb25jbHVzaW9uIGl0IGlzIGdjc2UgY2F1
c2luZyB0aGUgcHJvYmxlbS4NCkJ1dCBhbnl3YXksIGFkZGluZyBzdWNoIGZsYWcgaW4gdGhlIGtl
cm5lbCBpcyBub3QgYSBnb29kIGlkZWEuDQpjbGFuZy9sbHZtIHNob3VsZCBiZSBmaXhlZCBpbnN0
ZWFkLiBFc3AuIHRoZXJlIGlzIHN0aWxsIHRpbWUNCmZvciA5LjAuMCByZWxlYXNlIHRvIGZpeCBi
dWdzLg0KDQo+IA0KPiAtIFNlZGF0IC0NCj4gDQo+IFsxXSBodHRwczovL2dpdC5rZXJuZWwub3Jn
L2xpbnVzLzMxOTNjMDgzNmYyMDNhOTFiZWY5NmQ4OGM2NGNjY2YwYmUwOTBkOWMNCj4gDQo=
