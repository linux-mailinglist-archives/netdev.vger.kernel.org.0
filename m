Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56DADCDD9
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410758AbfJRSUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:20:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394221AbfJRSUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:20:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IIJZ3O002629;
        Fri, 18 Oct 2019 11:20:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JfxNZcsHicaHOFm5N/sMuCoQSu6OfUB8KT90W146Dng=;
 b=mWhV+FOR0Oc0htdukwtOStna4vAoziGNzcU4MX+VGC0/iYq+GOfbSVbev95NDosfeUHo
 0fYAYwC/ysRgIbp0jDtpSerQUC1ZERj1t4zS5YepTVoAky29/9YHm+AuDBYgM5FoUkgh
 jn1wVukcmSyllopB/tmWpligdCgysaVHAhY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqguv8hj9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Oct 2019 11:20:24 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 11:20:09 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 11:20:09 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 11:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn/1HfbIqMmvK5jQUaXyLN7kRd411n23ZXznrY/uIUrbEEsC1WVaLgT5UkqbRygOk7sh8XnOG6nSgM/h98Q1G0zDzxNNAbcx6N/VnE+Vvg+V/INDzb8PFFt58MXnCUFLbE8DT0Ps6if3fARmNILWYnQ5MONDtBP2dJYJU33/neoLZKHZBr0C70m2K7H28dAC5zuwFJKnicuYnZo39zWkdKdrDxDqFlBw0UukoKlwDTGSw6a2VsyfJYioPbJTM0AK4prfOUc0wkUIlzyx+ykS+eRgYzC4TfKV9aRt+eJ0XNiR7TvqD3xpWJUxZAJ29qPA6GjOPtZ3a/xl4MQQpIcd/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfxNZcsHicaHOFm5N/sMuCoQSu6OfUB8KT90W146Dng=;
 b=arzZFuxTWMjXm+cTxFfeEDP3l74Ah98RUoQhN5oUya0ENAHV6WHv3G4v8BXkx2nvSRrAE5HArTitjddtNkhG/3SBxt4ZzkVYTN0fIAajflt5UayydAoY9y/0bEpqG74l4txoX3YLNVuLn8lvArhHO9XS2uzQhoJx7NZKhgiWvEVmLqMfyH+BMPug2J50hM2gKy1gR1lHSTc3/Uly0SnV69lZXbyLRwn04CO9akxYnGIoJLDW/sW2Ajwxh/HB051O5qdbFxuN3XY9oSZVENyLNqLDOmDRfKnpQBRu++crFnINF91WIBrHeDI9bUt6CO4Iad9lz3O+ngMv4i68QTVCnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfxNZcsHicaHOFm5N/sMuCoQSu6OfUB8KT90W146Dng=;
 b=bmSqnZ1tCFY2h/bU851uT2K2MJI11T4kuQ2JLG9dacKjiK6S3YBrPlFnEE/ljBbpp4khUPrvhcoLytkSVb6/KuQv5IoOZlvIyEF+QkKmkxWJFKq6idfnWlwbDMhJ7TV83xvT1ThSwgy1a4+Oi7XT7irv5BSWhYerkkNRMo2IAlE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3189.namprd15.prod.outlook.com (20.179.56.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 18:20:08 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 18:20:08 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file
 descriptor to a pathname
Thread-Topic: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file
 descriptor to a pathname
Thread-Index: AQHVhaGRlUegLiUHnkSYyEX5w3pAr6dgthGA
Date:   Fri, 18 Oct 2019 18:20:08 +0000
Message-ID: <c6bf920a-845e-b7f5-ec47-a1e97b806427@fb.com>
References: <20191018104748.25486-1-ethercflow@gmail.com>
In-Reply-To: <20191018104748.25486-1-ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:104:7::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80cac716-1c9c-4369-00ce-08d753f7ce76
x-ms-traffictypediagnostic: BYAPR15MB3189:
x-microsoft-antispam-prvs: <BYAPR15MB3189AC5FCEEAD2F5A4A109F0D36C0@BYAPR15MB3189.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(376002)(346002)(189003)(199004)(110136005)(305945005)(7736002)(86362001)(316002)(2906002)(31696002)(14444005)(6512007)(71190400001)(486006)(6436002)(6246003)(256004)(5660300002)(71200400001)(2616005)(6116002)(36756003)(446003)(2501003)(102836004)(31686004)(81156014)(8936002)(229853002)(478600001)(476003)(99286004)(46003)(8676002)(186003)(4326008)(66476007)(66446008)(66946007)(66556008)(64756008)(52116002)(6506007)(6486002)(386003)(76176011)(25786009)(53546011)(11346002)(81166006)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3189;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8r+PKeGxOsbivzkg1FEMP8Rs+5Icw71njhypqsgnTaniRtKnNrhFdsWPfM1JGH6DUUZgvOAKeTRQIZ2g8WMKwLriqcsH6bqNp7606wG3v4qdV1w1u2hwa+RQ/VsOhF3Kx5DzMVSK3fHuykXS26fC39vkyb1fJklxcFkiwifDXy67cwF1rsoupENEIqI57QPc3B9jO48Ur33XZxwLmHyNEhnXHG0Rj55GtShed5ZeDHgiPFBdBWfMLFdmed1tkWUg4aV5zadG6mlXRbZew+HZUqFbuF9spcf/Be5/R2yPg9YJPgx/jsJ2T5XTvk1UuZBKCPesKANnZwXDVE9m/s8Rtf37OCv51eN8NuPzgZhbzxLyC+mReTUKVCJ4p+YeavA34WZkG4N6yQE+TasFEAV49keZPKhzhBdQjw/0H89soRg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <36F82B43882C04498146C9683E2AB998@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 80cac716-1c9c-4369-00ce-08d753f7ce76
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 18:20:08.4300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +A5zEeVuPMkBO68jgHiyhatkoQBQLkFSSMSiV1kiSIWrY6oB0wyqek8OxvGPeZZH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE4LzE5IDM6NDcgQU0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiBXaGVuIHBlb3Bs
ZSB3YW50IHRvIGlkZW50aWZ5IHdoaWNoIGZpbGUgc3lzdGVtIGZpbGVzIGFyZSBiZWluZyBvcGVu
ZWQsDQo+IHJlYWQsIGFuZCB3cml0dGVuIHRvLCB0aGV5IGNhbiB1c2UgdGhpcyBoZWxwZXIgd2l0
aCBmaWxlIGRlc2NyaXB0b3IgYXMNCj4gaW5wdXQgdG8gYWNoaWV2ZSB0aGlzIGdvYWwuIE90aGVy
IHBzZXVkbyBmaWxlc3lzdGVtcyBhcmUgYWxzbyBzdXBwb3J0ZWQuDQoNCkkgY29tbWVudGVkIG9u
IHByZXZpb3VzIHZlcnNpb24gb2YgdGhlIHBhdGNoLg0KQ291bGQgeW91IGFkZCB2ZXJzaW9uIG51
bWJlciAodGhpcyBpcyB2MikgdG8gdGhlIHBhdGNoIHNldA0Kd2hlbiB5b3Ugc3VibWl0IG5leHQg
dGltZSAod2hpY2ggd2lsbCBiZSB2MykuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdlbmJvIFpo
YW5nIDxldGhlcmNmbG93QGdtYWlsLmNvbT4NCj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9icGYu
aCAgICAgICAgICAgIHwgIDEgKw0KPiAgIGluY2x1ZGUvdWFwaS9saW51eC9icGYuaCAgICAgICB8
IDEyICsrKysrKysrKystDQo+ICAga2VybmVsL2JwZi9jb3JlLmMgICAgICAgICAgICAgIHwgIDEg
Kw0KPiAgIGtlcm5lbC9icGYvaGVscGVycy5jICAgICAgICAgICB8IDM5ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gICBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgICAgICAg
fCAgMiArKw0KPiAgIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDEyICsrKysrKysr
KystDQo+ICAgNiBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYnBmLmggYi9pbmNsdWRlL2xpbnV4
L2JwZi5oDQo+IGluZGV4IDJjMmMyOWI0OTg0NS4uZDczMzE0YTdlNjc0IDEwMDY0NA0KPiAtLS0g
YS9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gQEAg
LTEwODIsNiArMTA4Miw3IEBAIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBm
X2dldF9sb2NhbF9zdG9yYWdlX3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1
bmNfcHJvdG8gYnBmX3N0cnRvbF9wcm90bzsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9m
dW5jX3Byb3RvIGJwZl9zdHJ0b3VsX3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBm
X2Z1bmNfcHJvdG8gYnBmX3RjcF9zb2NrX3Byb3RvOw0KPiArZXh0ZXJuIGNvbnN0IHN0cnVjdCBi
cGZfZnVuY19wcm90byBicGZfZmQycGF0aF9wcm90bzsNCj4gICANCj4gICAvKiBTaGFyZWQgaGVs
cGVycyBhbW9uZyBjQlBGIGFuZCBlQlBGLiAqLw0KPiAgIHZvaWQgYnBmX3VzZXJfcm5kX2luaXRf
b25jZSh2b2lkKTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCBiL2lu
Y2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiBpbmRleCA0YWY4YjA4MTlhMzIuLmZkYjM3NzQwOTUx
ZiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ICsrKyBiL2luY2x1
ZGUvdWFwaS9saW51eC9icGYuaA0KPiBAQCAtMjc3Myw2ICsyNzczLDE1IEBAIHVuaW9uIGJwZl9h
dHRyIHsNCj4gICAgKg0KPiAgICAqIAkJVGhpcyBoZWxwZXIgaXMgc2ltaWxhciB0byAqKmJwZl9w
ZXJmX2V2ZW50X291dHB1dCoqXCAoKSBidXQNCj4gICAgKiAJCXJlc3RyaWN0ZWQgdG8gcmF3X3Ry
YWNlcG9pbnQgYnBmIHByb2dyYW1zLg0KPiArICoNCj4gKyAqIGludCBicGZfZmQycGF0aChjaGFy
ICpwYXRoLCB1MzIgc2l6ZSwgaW50IGZkKQ0KPiArICoJRGVzY3JpcHRpb24NCj4gKyAqCQlHZXQg
KipmaWxlKiogYXRycmlidXRlIGZyb20gdGhlIGN1cnJlbnQgdGFzayBieSAqZmQqLCB0aGVuIGNh
bGwNCj4gKyAqCQkqKmRfcGF0aCoqIHRvIGdldCBpdCdzIGFic29sdXRlIHBhdGggYW5kIGNvcHkg
aXQgYXMgc3RyaW5nIGludG8NCj4gKyAqCQkqcGF0aCogb2YgKnNpemUqLiBUaGUgKipwYXRoKiog
YWxzbyBzdXBwb3J0IHBzZXVkbyBmaWxlc3lzdGVtcw0KPiArICoJCSh3aGV0aGVyIG9yIG5vdCBp
dCBjYW4gYmUgbW91bnRlZCkuIFRoZSAqc2l6ZSogbXVzdCBiZSBzdHJpY3RseQ0KPiArICoJCXBv
c2l0aXZlLiBPbiBzdWNjZXNzLCB0aGUgaGVscGVyIG1ha2VzIHN1cmUgdGhhdCB0aGUgKnBhdGgq
IGlzDQo+ICsgKgkJTlVMLXRlcm1pbmF0ZWQuIE9uIGZhaWx1cmUsIGl0IGlzIGZpbGxlZCB3aXRo
IHplcm9lcy4NCj4gICAgKiAJUmV0dXJuDQo+ICAgICogCQkwIG9uIHN1Y2Nlc3MsIG9yIGEgbmVn
YXRpdmUgZXJyb3IgaW4gY2FzZSBvZiBmYWlsdXJlLg0KPiAgICAqLw0KPiBAQCAtMjg4OCw3ICsy
ODk3LDggQEAgdW5pb24gYnBmX2F0dHIgew0KPiAgIAlGTihza19zdG9yYWdlX2RlbGV0ZSksCQlc
DQo+ICAgCUZOKHNlbmRfc2lnbmFsKSwJCVwNCj4gICAJRk4odGNwX2dlbl9zeW5jb29raWUpLAkJ
XA0KPiAtCUZOKHNrYl9vdXRwdXQpLA0KPiArCUZOKHNrYl9vdXRwdXQpLAkJCVwNCj4gKwlGTihm
ZDJwYXRoKSwNCj4gICANCj4gICAvKiBpbnRlZ2VyIHZhbHVlIGluICdpbW0nIGZpZWxkIG9mIEJQ
Rl9DQUxMIGluc3RydWN0aW9uIHNlbGVjdHMgd2hpY2ggaGVscGVyDQo+ICAgICogZnVuY3Rpb24g
ZUJQRiBwcm9ncmFtIGludGVuZHMgdG8gY2FsbA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9j
b3JlLmMgYi9rZXJuZWwvYnBmL2NvcmUuYw0KPiBpbmRleCA2NzNmNWQ0MGE5M2UuLjZiNDRlZDgw
NDI4MCAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9jb3JlLmMNCj4gKysrIGIva2VybmVsL2Jw
Zi9jb3JlLmMNCj4gQEAgLTIwNzksNiArMjA3OSw3IEBAIGNvbnN0IHN0cnVjdCBicGZfZnVuY19w
cm90byBicGZfZ2V0X2N1cnJlbnRfdWlkX2dpZF9wcm90byBfX3dlYWs7DQo+ICAgY29uc3Qgc3Ry
dWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfY3VycmVudF9jb21tX3Byb3RvIF9fd2VhazsNCj4g
ICBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50X2Nncm91cF9pZF9w
cm90byBfX3dlYWs7DQo+ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfbG9j
YWxfc3RvcmFnZV9wcm90byBfX3dlYWs7DQo+ICtjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8g
YnBmX2ZkMnBhdGhfcHJvdG8gX193ZWFrOw0KPiAgIA0KPiAgIGNvbnN0IHN0cnVjdCBicGZfZnVu
Y19wcm90byAqIF9fd2VhayBicGZfZ2V0X3RyYWNlX3ByaW50a19wcm90byh2b2lkKQ0KPiAgIHsN
Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvaGVscGVycy5jIGIva2VybmVsL2JwZi9oZWxwZXJz
LmMNCj4gaW5kZXggNWUyODcxODkyOGNhLi4wODMyNTM2YzdkZGIgMTAwNjQ0DQo+IC0tLSBhL2tl
cm5lbC9icGYvaGVscGVycy5jDQo+ICsrKyBiL2tlcm5lbC9icGYvaGVscGVycy5jDQo+IEBAIC00
ODcsMyArNDg3LDQyIEBAIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfc3RydG91bF9w
cm90byA9IHsNCj4gICAJLmFyZzRfdHlwZQk9IEFSR19QVFJfVE9fTE9ORywNCj4gICB9Ow0KPiAg
ICNlbmRpZg0KPiArDQo+ICtCUEZfQ0FMTF8zKGJwZl9mZDJwYXRoLCBjaGFyICosIGRzdCwgdTMy
LCBzaXplLCBpbnQsIGZkKQ0KPiArew0KPiArCXN0cnVjdCBmZCBmOw0KPiArCWludCByZXQ7DQo+
ICsJY2hhciAqcDsNCj4gKw0KPiArCXJldCA9IHNlY3VyaXR5X2xvY2tlZF9kb3duKExPQ0tET1dO
X0JQRl9SRUFEKTsNCj4gKwlpZiAocmV0IDwgMCkNCj4gKwkJZ290byBvdXQ7DQo+ICsNCj4gKwlm
ID0gZmRnZXRfcmF3KGZkKTsNCj4gKwlpZiAoIWYuZmlsZSkNCj4gKwkJZ290byBvdXQ7DQo+ICsN
Cj4gKwlwID0gZF9wYXRoKCZmLmZpbGUtPmZfcGF0aCwgZHN0LCBzaXplKTsNCj4gKwlpZiAoSVNf
RVJSX09SX05VTEwocCkpDQo+ICsJCXJldCA9IFBUUl9FUlIocCk7DQo+ICsJZWxzZSB7DQo+ICsJ
CXJldCA9IHN0cmxlbihwKTsNCj4gKwkJbWVtbW92ZShkc3QsIHAsIHJldCk7DQo+ICsJCWRzdFty
ZXRdID0gMDsNCj4gKwl9DQo+ICsNCj4gKwlpZiAodW5saWtlbHkocmV0IDwgMCkpDQo+ICtvdXQ6
DQo+ICsJCW1lbXNldChkc3QsICcwJywgc2l6ZSk7DQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiAr
fQ0KPiArDQo+ICtjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2ZkMnBhdGhfcHJvdG8g
PSB7DQo+ICsJLmZ1bmMgICAgICAgPSBicGZfZmQycGF0aCwNCj4gKwkuZ3BsX29ubHkgICA9IHRy
dWUsDQo+ICsJLnJldF90eXBlICAgPSBSRVRfSU5URUdFUiwNCj4gKwkuYXJnMV90eXBlICA9IEFS
R19QVFJfVE9fVU5JTklUX01FTSwNCj4gKwkuYXJnMl90eXBlICA9IEFSR19DT05TVF9TSVpFLA0K
PiArCS5hcmczX3R5cGUgID0gQVJHX0FOWVRISU5HLA0KPiArfTsNCj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC90cmFjZS9icGZfdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPiBpbmRl
eCA1MmY3ZTlkOGMyOWIuLjIzY2MzYTk1NWU1OSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL3RyYWNl
L2JwZl90cmFjZS5jDQo+ICsrKyBiL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPiBAQCAtNzM1
LDYgKzczNSw4IEBAIHRyYWNpbmdfZnVuY19wcm90byhlbnVtIGJwZl9mdW5jX2lkIGZ1bmNfaWQs
IGNvbnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4gICAjZW5kaWYNCj4gICAJY2FzZSBCUEZf
RlVOQ19zZW5kX3NpZ25hbDoNCj4gICAJCXJldHVybiAmYnBmX3NlbmRfc2lnbmFsX3Byb3RvOw0K
PiArCWNhc2UgQlBGX0ZVTkNfZmQycGF0aDoNCj4gKwkJcmV0dXJuICZicGZfZmQycGF0aF9wcm90
bzsNCj4gICAJZGVmYXVsdDoNCj4gICAJCXJldHVybiBOVUxMOw0KPiAgIAl9DQo+IGRpZmYgLS1n
aXQgYS90b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi90b29scy9pbmNsdWRlL3VhcGkv
bGludXgvYnBmLmgNCj4gaW5kZXggNGFmOGIwODE5YTMyLi5mZGIzNzc0MDk1MWYgMTAwNjQ0DQo+
IC0tLSBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiArKysgYi90b29scy9pbmNs
dWRlL3VhcGkvbGludXgvYnBmLmgNCj4gQEAgLTI3NzMsNiArMjc3MywxNSBAQCB1bmlvbiBicGZf
YXR0ciB7DQo+ICAgICoNCj4gICAgKiAJCVRoaXMgaGVscGVyIGlzIHNpbWlsYXIgdG8gKipicGZf
cGVyZl9ldmVudF9vdXRwdXQqKlwgKCkgYnV0DQo+ICAgICogCQlyZXN0cmljdGVkIHRvIHJhd190
cmFjZXBvaW50IGJwZiBwcm9ncmFtcy4NCj4gKyAqDQo+ICsgKiBpbnQgYnBmX2ZkMnBhdGgoY2hh
ciAqcGF0aCwgdTMyIHNpemUsIGludCBmZCkNCj4gKyAqCURlc2NyaXB0aW9uDQo+ICsgKgkJR2V0
ICoqZmlsZSoqIGF0cnJpYnV0ZSBmcm9tIHRoZSBjdXJyZW50IHRhc2sgYnkgKmZkKiwgdGhlbiBj
YWxsDQo+ICsgKgkJKipkX3BhdGgqKiB0byBnZXQgaXQncyBhYnNvbHV0ZSBwYXRoIGFuZCBjb3B5
IGl0IGFzIHN0cmluZyBpbnRvDQo+ICsgKgkJKnBhdGgqIG9mICpzaXplKi4gVGhlICoqcGF0aCoq
IGFsc28gc3VwcG9ydCBwc2V1ZG8gZmlsZXN5c3RlbXMNCj4gKyAqCQkod2hldGhlciBvciBub3Qg
aXQgY2FuIGJlIG1vdW50ZWQpLiBUaGUgKnNpemUqIG11c3QgYmUgc3RyaWN0bHkNCj4gKyAqCQlw
b3NpdGl2ZS4gT24gc3VjY2VzcywgdGhlIGhlbHBlciBtYWtlcyBzdXJlIHRoYXQgdGhlICpwYXRo
KiBpcw0KPiArICoJCU5VTC10ZXJtaW5hdGVkLiBPbiBmYWlsdXJlLCBpdCBpcyBmaWxsZWQgd2l0
aCB6ZXJvZXMuDQo+ICAgICogCVJldHVybg0KPiAgICAqIAkJMCBvbiBzdWNjZXNzLCBvciBhIG5l
Z2F0aXZlIGVycm9yIGluIGNhc2Ugb2YgZmFpbHVyZS4NCj4gICAgKi8NCj4gQEAgLTI4ODgsNyAr
Mjg5Nyw4IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4gICAJRk4oc2tfc3RvcmFnZV9kZWxldGUpLAkJ
XA0KPiAgIAlGTihzZW5kX3NpZ25hbCksCQlcDQo+ICAgCUZOKHRjcF9nZW5fc3luY29va2llKSwJ
CVwNCj4gLQlGTihza2Jfb3V0cHV0KSwNCj4gKwlGTihza2Jfb3V0cHV0KSwJCQlcDQo+ICsJRk4o
ZmQycGF0aCksDQo+ICAgDQo+ICAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBC
UEZfQ0FMTCBpbnN0cnVjdGlvbiBzZWxlY3RzIHdoaWNoIGhlbHBlcg0KPiAgICAqIGZ1bmN0aW9u
IGVCUEYgcHJvZ3JhbSBpbnRlbmRzIHRvIGNhbGwNCj4gDQo=
