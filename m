Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64376DCFBB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443405AbfJRUHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:07:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16240 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443385AbfJRUFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:05:01 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IK3PJd014287;
        Fri, 18 Oct 2019 13:04:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WFXfCX54zXRsyY1l1xonyLb/VG+Ly+eawqx362/s3X8=;
 b=NdgMA8UHVVt2g4oqzZ1j7DGvcu1pFkmJXYJ8c5vQ/Viwp7TPbOcnFu5BzHfidATtTqNW
 r9lTvEHmD+7b4IIbclvS+ZvSbylWhhZTCudU1Ippy+Z8Av8vTgFTUKv+ly701E1N+X/t
 DFFwOgOVTZOVNvcb3XoorXiKlbxEBI8I7cU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqhgjrt9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 13:04:46 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 13:04:45 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 13:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JibffTdBe0p1ZPxv+LOaMADIduudgkGD/V50V/DgvM6OG7CRRTFbpiRW+qiH6eg6yjWGS363CQOhTjkYRuAgYP/06MhE1l2QeJLquW8cTrUpe5nEGYK6HLZ47JB7e3dOppaSxg7S8GLXi2eEr4tBwkaiFnwnWcwgvA4YJKyjwm6rdU5GAXGGlWPImc+D5x57I+PkKEIWUCWj0HX+cmk4tl3NRcgfLqAl7ZbdHB7SbFQ52lYwN8wPPu6hFFxpnbV4nGq7uo9whbJ2YRiORG65HukOCoE89HBqzu4MmsMGklS1JNGldXYFDY2Nn/ofYYf6TzPWkISYSTjmzDBVx/+CMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFXfCX54zXRsyY1l1xonyLb/VG+Ly+eawqx362/s3X8=;
 b=gm2574INR+T2SPtDrdPt/uQAo5i6O0jhn1yoS9OCFOZEAHtwd4nGeDYfbA9NknTm7Q17Hfm7ABoHajtWJfHkACdcgtRh0DscfDL8lN+zBY8mi+IFkJbKxs5v6e9+LkFf1eR8EM03ZY8S81Uag+BaZO79o4OlRb3pCCaTgCEeP9R0cwQVli9C2tzN/UFITPlXxu44sietCOfA//PthuL3rsCgbwiNCB5CXrL1WtGmS+oJvgFCrBDKLEJCcRuKeWHWx3YXet7dryJ4gzbnYhMaBpY0At8OxUOcmKjFZFO3gDdb8lz2I3VfDGK3Q2Ri9WqBNd3w37XAeqD+Hql5dxXM5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFXfCX54zXRsyY1l1xonyLb/VG+Ly+eawqx362/s3X8=;
 b=hxaElVmmW0ijREpou803unaVpYgEbszusyEch6jXLI/nTK2lKbOoVn2W97wLbj3whP7D0cYRw/KDiqYTq3JXEls/bdWGaXCNkvthqnsndX20RiU0FKoMJrBZLDUu/y82kmmS1/nnQEtnglOMRnWnZQczOyFUXCKtuheLCv2GA0I=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3511.namprd15.prod.outlook.com (20.179.59.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 20:04:44 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 20:04:44 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Thread-Topic: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Thread-Index: AQHVhZ+U0jV2Q1nMRUqVPzHW0g079qdgnHiAgAA21oA=
Date:   Fri, 18 Oct 2019 20:04:44 +0000
Message-ID: <78433b38-3f34-c97a-ee74-a9b6dee95aa2@fb.com>
References: <20191018103404.12999-1-jolsa@kernel.org>
 <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
In-Reply-To: <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0066.namprd21.prod.outlook.com
 (2603:10b6:300:db::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:95af]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a33eb7f2-cbc9-431e-c603-08d754066b26
x-ms-traffictypediagnostic: BYAPR15MB3511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB35119AF53A3BECAF50C79472D36C0@BYAPR15MB3511.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(376002)(136003)(396003)(189003)(199004)(14454004)(478600001)(102836004)(2616005)(446003)(31686004)(11346002)(110136005)(256004)(316002)(46003)(71200400001)(54906003)(486006)(386003)(6506007)(36756003)(6486002)(53546011)(76176011)(229853002)(71190400001)(6436002)(476003)(305945005)(7736002)(8676002)(81166006)(6246003)(2906002)(52116002)(81156014)(66476007)(6116002)(25786009)(4326008)(6512007)(99286004)(8936002)(86362001)(31696002)(5660300002)(186003)(64756008)(66556008)(66946007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3511;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5t+Tn4hby7yvukUxojkNPBR3v1CD8w5PRsb7Bn08JnAY1Q1K70c9bdJqMUIbPgj59cpv5q7mFU9xjFDTfSCGEN5+PdE2sr8CiSaU1+t6lPtQbkGOF0nDqyPhju8H74UPS0BaGne56bLFVamI/skkmwxc6KEfmsb9U59rjEfcPWaHVj9yruGtYsgFBQm3F/zlu34piLxlPeRRIJALBSx+VGS8cQJer7jvnzjysVstpsIww0ixZzdYK3nV0vz41tRrwjaqEmDoqHePKnEdYySHJB4uGcq5pJtzatqxZPYz2hnVMfsh2qFPjDCVAxknWUAM8+HKDi7rE81SGm74B3NtWL+Atz2kDo6OOVke0TeoRN7FhVFPIYMO55SzrDOw3ahjsJe7OHHn1SZ5M1yTmNdd3NzrbCnEP+KsMDwtx0bbXU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B3EEFBC68E91D44B995E8C7246A6E74@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a33eb7f2-cbc9-431e-c603-08d754066b26
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 20:04:44.2843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/lxpHrST5ukVV1cNCqpGUeltfl979/Mh/FlkHYRW4MR5v86B0mwjTJa9Wa0ISRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3511
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_05:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE4LzE5IDk6NDggQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gMTAv
MTgvMTkgMzozNCBBTSwgSmlyaSBPbHNhIHdyb3RlOg0KPj4gVGhlIGJwZnRvb2wgaW50ZXJmYWNl
IHN0YXlzIHRoZSBzYW1lLCBidXQgbm93IGl0J3MgcG9zc2libGUNCj4+IHRvIHJ1biBpdCBvdmVy
IEJURiByYXcgZGF0YSwgbGlrZToNCj4gDQo+IE9oLCBncmVhdCwgSSBoYWQgc2ltaWxhciBwYXRj
aCBsYXlpbmcgYXJvdW5kIGZvciBhIHdoaWxlLCBuZXZlciBnb3QgdG8NCj4gY2xlYW5pbmcgaXQg
dXAsIHRob3VnaCwgc28gdGhhbmtzIGZvciBwaWNraW5nIHRoaXMgdXAhDQo+IA0KPj4NCj4+ICAg
ICAkIGJwZnRvb2wgYnRmIGR1bXAgZmlsZSAvc3lzL2tlcm5lbC9idGYvdm1saW51eA0KPj4gICAg
IGxpYmJwZjogZmFpbGVkIHRvIGdldCBFSERSIGZyb20gL3N5cy9rZXJuZWwvYnRmL3ZtbGludXgN
Cj4gDQo+IFdlIHNob3VsZCBpbXBsZW1lbnQgdGhpcyBzbyB0aGF0IHdlIGRvbid0IGdldCBhbiBl
eHRyYSBsb2cgb3V0cHV0IHdpdGgNCj4gZXJyb3JzLiBJJ3ZlIGJlZW4gdGhpbmtpbmcgYWJvdXQg
Y2hlY2tpbmcgZmlyc3QgZmV3IGJ5dGVzIG9mIHRoZSBmaWxlLg0KPiBJZiB0aGF0IG1hdGNoZXMg
QlRGX01BR0lDLCB0aGVuIHRyeSB0byBwYXJzZSBpdCBhcyByYXcgQlRGLCBvdGhlcndpc2UNCj4g
cGFyc2UgYXMgRUxGIHcvIEJURi4gRG9lcyBpdCBtYWtlIHNlbnNlPw0KDQpBZ3JlZWQsIHRoaXMg
bWFrZXMgc2Vuc2UuIFdlIHNob3VsZCBub3QgZW1pdCBlcnJvcnMgaW4gc3VjaCBjYXNlcy4NCk9u
ZSBtaW5vciBjb21tZW50IGJlbG93Lg0KDQo+IA0KPj4gICAgIFsxXSBJTlQgJyhhbm9uKScgc2l6
ZT00IGJpdHNfb2Zmc2V0PTAgbnJfYml0cz0zMiBlbmNvZGluZz0obm9uZSkNCj4+ICAgICBbMl0g
SU5UICdsb25nIHVuc2lnbmVkIGludCcgc2l6ZT04IGJpdHNfb2Zmc2V0PTAgbnJfYml0cz02NCBl
bmNvZGluZz0obm9uZSkNCj4+ICAgICBbM10gQ09OU1QgJyhhbm9uKScgdHlwZV9pZD0yDQo+Pg0K
Pj4gSSdtIGFsc28gYWRkaW5nIGVyciBpbml0IHRvIDAgYmVjYXVzZSBJIHdhcyBnZXR0aW5nIHVu
aW5pdGlhbGl6ZWQNCj4+IHdhcm5pbmdzIGZyb20gZ2NjLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IEppcmkgT2xzYSA8am9sc2FAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPj4gICAgdG9vbHMvYnBmL2Jw
ZnRvb2wvYnRmLmMgfCA0NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2JwZi9icGZ0b29sL2J0Zi5jIGIvdG9vbHMvYnBm
L2JwZnRvb2wvYnRmLmMNCj4+IGluZGV4IDlhOTM3NmQxZDNkZi4uMTAwZmI3ZTAyMzI5IDEwMDY0
NA0KPj4gLS0tIGEvdG9vbHMvYnBmL2JwZnRvb2wvYnRmLmMNCj4+ICsrKyBiL3Rvb2xzL2JwZi9i
cGZ0b29sL2J0Zi5jDQo+PiBAQCAtMTIsNiArMTIsOSBAQA0KPj4gICAgI2luY2x1ZGUgPGxpYmJw
Zi5oPg0KPj4gICAgI2luY2x1ZGUgPGxpbnV4L2J0Zi5oPg0KPj4gICAgI2luY2x1ZGUgPGxpbnV4
L2hhc2h0YWJsZS5oPg0KPj4gKyNpbmNsdWRlIDxzeXMvdHlwZXMuaD4NCj4+ICsjaW5jbHVkZSA8
c3lzL3N0YXQuaD4NCj4+ICsjaW5jbHVkZSA8dW5pc3RkLmg+DQo+PiAgICANCj4+ICAgICNpbmNs
dWRlICJidGYuaCINCj4+ICAgICNpbmNsdWRlICJqc29uX3dyaXRlci5oIg0KPj4gQEAgLTM4OCw2
ICszOTEsMzUgQEAgc3RhdGljIGludCBkdW1wX2J0Zl9jKGNvbnN0IHN0cnVjdCBidGYgKmJ0ZiwN
Cj4+ICAgIAlyZXR1cm4gZXJyOw0KPj4gICAgfQ0KPj4gICAgDQo+PiArc3RhdGljIHN0cnVjdCBi
dGYgKmJ0Zl9fcGFyc2VfcmF3KGNvbnN0IGNoYXIgKmZpbGUpDQo+PiArew0KPj4gKwlzdHJ1Y3Qg
YnRmICpidGYgPSBFUlJfUFRSKC1FSU5WQUwpOw0KPj4gKwlfX3U4ICpidWYgPSBOVUxMOw0KPj4g
KwlzdHJ1Y3Qgc3RhdCBzdDsNCj4+ICsJRklMRSAqZjsNCj4+ICsNCj4+ICsJaWYgKHN0YXQoZmls
ZSwgJnN0KSkNCj4+ICsJCXJldHVybiBidGY7DQo+PiArDQo+PiArCWYgPSBmb3BlbihmaWxlLCAi
cmIiKTsNCj4+ICsJaWYgKCFmKQ0KPj4gKwkJcmV0dXJuIGJ0ZjsNCj4+ICsNCj4+ICsJYnVmID0g
bWFsbG9jKHN0LnN0X3NpemUpOw0KPj4gKwlpZiAoIWJ1ZikNCj4+ICsJCWdvdG8gZXJyOw0KPj4g
Kw0KPj4gKwlpZiAoKHNpemVfdCkgc3Quc3Rfc2l6ZSAhPSBmcmVhZChidWYsIDEsIHN0LnN0X3Np
emUsIGYpKQ0KPj4gKwkJZ290byBlcnI7DQo+PiArDQo+PiArCWJ0ZiA9IGJ0Zl9fbmV3KGJ1Ziwg
c3Quc3Rfc2l6ZSk7DQo+PiArDQo+PiArZXJyOg0KDQpOb24gZXJyb3IgY2FzZSBjYW4gYWxzbyBy
ZWFjaCBoZXJlLiBMZXQgdXMgY2hhbmdlDQpsYWJlbCB0byBhIGRpZmZlcmVudCBuYW1lLCBlLmcu
LCAiZG9uZSI/DQoNCj4+ICsJZnJlZShidWYpOw0KPj4gKwlmY2xvc2UoZik7DQo+PiArCXJldHVy
biBidGY7DQo+PiArfQ0KPj4gKw0KPj4gICAgc3RhdGljIGludCBkb19kdW1wKGludCBhcmdjLCBj
aGFyICoqYXJndikNCj4+ICAgIHsNCj4+ICAgIAlzdHJ1Y3QgYnRmICpidGYgPSBOVUxMOw0KPj4g
QEAgLTM5Nyw3ICs0MjksNyBAQCBzdGF0aWMgaW50IGRvX2R1bXAoaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQ0KPj4gICAgCV9fdTMyIGJ0Zl9pZCA9IC0xOw0KPj4gICAgCWNvbnN0IGNoYXIgKnNyYzsN
Cj4+ICAgIAlpbnQgZmQgPSAtMTsNCj4+IC0JaW50IGVycjsNCj4+ICsJaW50IGVyciA9IDA7DQo+
PiAgICANCj4+ICAgIAlpZiAoIVJFUV9BUkdTKDIpKSB7DQo+PiAgICAJCXVzYWdlKCk7DQo+PiBA
QCAtNDY4LDEwICs1MDAsMTUgQEAgc3RhdGljIGludCBkb19kdW1wKGludCBhcmdjLCBjaGFyICoq
YXJndikNCj4+ICAgIAkJYnRmID0gYnRmX19wYXJzZV9lbGYoKmFyZ3YsIE5VTEwpOw0KPj4gICAg
CQlpZiAoSVNfRVJSKGJ0ZikpIHsNCj4+ICAgIAkJCWVyciA9IFBUUl9FUlIoYnRmKTsNCj4+IC0J
CQlidGYgPSBOVUxMOw0KPj4gLQkJCXBfZXJyKCJmYWlsZWQgdG8gbG9hZCBCVEYgZnJvbSAlczog
JXMiLA0KPj4gLQkJCSAgICAgICphcmd2LCBzdHJlcnJvcihlcnIpKTsNCj4+IC0JCQlnb3RvIGRv
bmU7DQo+PiArCQkJaWYgKGVyciA9PSAtTElCQlBGX0VSUk5PX19GT1JNQVQpDQo+PiArCQkJCWJ0
ZiA9IGJ0Zl9fcGFyc2VfcmF3KCphcmd2KTsNCj4+ICsJCQlpZiAoSVNfRVJSKGJ0ZikpIHsNCj4+
ICsJCQkJYnRmID0gTlVMTDsNCj4+ICsJCQkJLyogRGlzcGxheSB0aGUgb3JpZ2luYWwgZXJyb3Ig
dmFsdWUuICovDQo+PiArCQkJCXBfZXJyKCJmYWlsZWQgdG8gbG9hZCBCVEYgZnJvbSAlczogJXMi
LA0KPj4gKwkJCQkgICAgICAqYXJndiwgc3RyZXJyb3IoZXJyKSk7DQo+PiArCQkJCWdvdG8gZG9u
ZTsNCj4+ICsJCQl9DQo+PiAgICAJCX0NCj4+ICAgIAkJTkVYVF9BUkcoKTsNCj4+ICAgIAl9IGVs
c2Ugew0KPj4NCj4gDQo=
