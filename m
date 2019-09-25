Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE3EBD6B1
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 05:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411510AbfIYD1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 23:27:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404095AbfIYD1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 23:27:11 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8P3JDfG005503;
        Tue, 24 Sep 2019 20:27:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7krzVMmLIxQzEV+/fgplYO4UDEDBeLpzSR+sngDsylo=;
 b=XKA8PRyHEsPFSMqR7OjQ/Z2TX6/jWSHFzW31i4FwmzjJDp4/E0lLyGhmfaZYUg0rhSPN
 4D/cka0u7YyvBkZlkdmTFQBUIfahi1yrW8SKZZHGdRljdProY9v0y98E27gimzwpc+BJ
 opCMUKvS87WyqyL0oUTn7REVf3g0/8qwI4s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2v752ky8hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 20:27:06 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 24 Sep 2019 20:27:05 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 24 Sep 2019 20:27:05 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Sep 2019 20:27:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr5qayZ+/ng1ovucVHzPf5D7Zugl/+l3N0Tw4sfSoxaOAGyzGDFdRO5v1pSDLginazhQdgsj6mQ0vCXze/jWx8wNbVNyOjDfm5umHGa/zeaqCOJ/uQKoz2oYfa6lrtze925QHCShuxbWrbIM5F6pgUuBrV0n6/cbkUoo5NcoPcCxQ8O0gRhmaXWjAfuJJybGX9Srg2dAEARaS590/V4UrxJiE/I1zEugo8Etf273fGJVAmdQOOUsEXkyv697CG2URIgTsg3dFqk5dfIeJApmhqhBRhgYHjfQNow1D/5rGNcK0jtySyJjVjQFA7xT3xzucKTihW3cdNW3wenmTmgi6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7krzVMmLIxQzEV+/fgplYO4UDEDBeLpzSR+sngDsylo=;
 b=k+l4gmvYlQoczj0FSWN3WU1rSwywHk3YwWKBnCo9CgBoXnS/BujimKNZFveKh2p80VJGrLGi4elNzIgl+xaMlk8CLbKKhmKW0gell7EnUyrZiwi8XLA7EFocGHLTpB6D7nxaX8IP2mre41lAz7ObfbHFmnSB7udmugNSGgDcJ9/NDb4DhfGNi8xwJZca+kVV8VNCoe4J3QXzUz+VAXkig2R5M9IZi0YmLwD67XrEXTf7T9mZLoeQHgKC00DoYBeiA4NYvSIEkQZFyGlnmp8SC3MudUGnPjZNzP2suOlzjMJLxCq210NmEOowTRgw1vdRZ72WdnvOcqNYOoqofBZsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7krzVMmLIxQzEV+/fgplYO4UDEDBeLpzSR+sngDsylo=;
 b=IFi3BsANy44thTQGSbo924torTGU4ELR9Icwfv+nDFUy78bVNBl38rmJPBFIENSsmWRP551vjXhh6bMzvNhtX/UpepI53e5+OoVsvKJYV6pSRAbmZJbTxDY9La3QWeQk1CwZPh/UAab5LLV4wE6UzAvmYIecAOXJU0Oirg2GVg4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3127.namprd15.prod.outlook.com (20.178.239.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Wed, 25 Sep 2019 03:27:04 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 03:27:04 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v11 3/4] tools: Added bpf_get_ns_current_pid_tgid
 helper
Thread-Topic: [PATCH bpf-next v11 3/4] tools: Added
 bpf_get_ns_current_pid_tgid helper
Thread-Index: AQHVcuudAWYjTW0730uz3NXi0PzFQ6c7vFcA
Date:   Wed, 25 Sep 2019 03:27:03 +0000
Message-ID: <756e3fd4-28a2-3d7e-694d-ef9b54b491f3@fb.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <20190924152005.4659-4-cneirabustos@gmail.com>
In-Reply-To: <20190924152005.4659-4-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:104:6::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8fa7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f047d5f-41e9-448b-3499-08d741683c21
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3127;
x-ms-traffictypediagnostic: BYAPR15MB3127:
x-microsoft-antispam-prvs: <BYAPR15MB312764D792E0C2224BC78112D3870@BYAPR15MB3127.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(366004)(396003)(346002)(199004)(189003)(486006)(6246003)(71190400001)(31686004)(71200400001)(81166006)(14444005)(229853002)(6486002)(6116002)(2616005)(2906002)(81156014)(14454004)(46003)(186003)(6436002)(256004)(476003)(8936002)(99286004)(4326008)(446003)(36756003)(76176011)(52116002)(66946007)(31696002)(2501003)(305945005)(6512007)(66476007)(66446008)(54906003)(316002)(66556008)(8676002)(7736002)(64756008)(25786009)(53546011)(86362001)(386003)(478600001)(5660300002)(102836004)(6506007)(110136005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3127;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2TW9NCrGJczEJvK02QWZK3dGvW1qkptPdKRCyJ1hitwIgq5/56MJvR8GeQSwJ3v9z5m60ni1xcu9TMnHwDDEP7crtFTs/RCR8O/+Ud4QPypPrwXhj9cMwxL5YjlC757mNDEgCn16cWnUT2VdeJTEdMIE8N7fhsftGnn/WMnJOcCdsMBO+peKrdCEEcyA65Vji2ZiYyLCre0AvZ6KeoXyglBV+EsN5GyR1IRhY7lAYDRlP4lhNzVkMWYwp2cTYVlNSVujdd9ETTLLb6aQ2JVVxUxvtsXRmILjXpsbhImRcUL+NctwqEebPB3Ags6mMetUmMWnZAt4IuwCSUuPgQOR2/hX+xNEMeeQxtgDzmeG/dGGMcouy/pz/iY4WAYTSyQwKsyART7YiFwekiAdmkB5/r+SPwAHvq9sC6ksVihFnQc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B25999AA34053542BDE720FB5A90DD58@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f047d5f-41e9-448b-3499-08d741683c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 03:27:04.0885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iw2B5qSIldo7S/n5g1cIjP3DqsXG9abQAibFGTjkKh2IN5LhnFCYvtc8mMSOkuW4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3127
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-25_02:2019-09-23,2019-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1909250031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMjQvMTkgODoyMCBBTSwgQ2FybG9zIE5laXJhIHdyb3RlOg0KPiBTaWduZWQtb2Zm
LWJ5OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQoNClBsZWFzZSBkbyBh
ZGQgc29tZSBjb21taXQgbWVzc2FnZS4gQSBjb3VwbGUgb2YgZXhhbXBsZXMsDQoNCmNvbW1pdCAw
ZmMyZTBiODRiYTcyNWM1ZTZlZTY2MDU5OTM2NjM4Mzg5ZTY3YzgwDQpBdXRob3I6IEFsZXhlaSBT
dGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQpEYXRlOiAgIFRodSBBdWcgMjIgMjI6NTI6MTMg
MjAxOSAtMDcwMA0KDQogICAgIHRvb2xzL2JwZjogc3luYyBicGYuaA0KDQogICAgIHN5bmMgYnBm
LmggZnJvbSBrZXJuZWwvIHRvIHRvb2xzLw0KDQogICAgIFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBT
dGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQogICAgIEFja2VkLWJ5OiBTb25nIExpdSA8c29u
Z2xpdWJyYXZpbmdAZmIuY29tPg0KICAgICBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgQm9ya21hbm4g
PGRhbmllbEBpb2dlYXJib3gubmV0Pg0KDQpjb21taXQgMWY4OTE5YjE3MDMxOGU3ZTEzZTMwM2Vl
ZGFjMzYzZDQ0MDU3OTk1Zg0KQXV0aG9yOiBQZXRlciBXdSA8cGV0ZXJAbGVrZW5zdGV5bi5ubD4N
CkRhdGU6ICAgV2VkIEF1ZyAyMSAwMDowOTowMCAyMDE5ICswMTAwDQoNCiAgICAgYnBmOiBzeW5j
IGJwZi5oIHRvIHRvb2xzLw0KDQogICAgIEZpeCBhICdzdHJ1Y3QgcHRfcmVnJyB0eXBvIGFuZCBj
bGFyaWZ5IHdoZW4gYnBmX3RyYWNlX3ByaW50ayBkaXNjYXJkcw0KICAgICBsaW5lcy4gQWZmZWN0
cyBkb2N1bWVudGF0aW9uIG9ubHkuDQoNCiAgICAgU2lnbmVkLW9mZi1ieTogUGV0ZXIgV3UgPHBl
dGVyQGxla2Vuc3RleW4ubmw+DQogICAgIFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3ZvaXRv
diA8YXN0QGtlcm5lbC5vcmc+DQoNCj4gLS0tDQo+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4
L2JwZi5oIHwgMTggKysrKysrKysrKysrKysrKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDE3IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy9pbmNs
dWRlL3VhcGkvbGludXgvYnBmLmggYi90b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4g
aW5kZXggNzdjNmJlOTZkNjc2Li45MjcyZGM4ZmIwOGMgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2lu
Y2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiArKysgYi90b29scy9pbmNsdWRlL3VhcGkvbGludXgv
YnBmLmgNCj4gQEAgLTI3NTAsNiArMjc1MCwyMSBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ICAgICoJ
CSoqLUVPUE5PVFNVUFAqKiBrZXJuZWwgY29uZmlndXJhdGlvbiBkb2VzIG5vdCBlbmFibGUgU1lO
IGNvb2tpZXMNCj4gICAgKg0KPiAgICAqCQkqKi1FUFJPVE9OT1NVUFBPUlQqKiBJUCBwYWNrZXQg
dmVyc2lvbiBpcyBub3QgNCBvciA2DQo+ICsgKg0KPiArICogaW50IGJwZl9nZXRfbnNfY3VycmVu
dF9waWRfdGdpZCh1MzIgZGV2LCB1NjQgaW51bSkNCj4gKyAqCVJldHVybg0KPiArICoJCUEgNjQt
Yml0IGludGVnZXIgY29udGFpbmluZyB0aGUgY3VycmVudCB0Z2lkIGFuZCBwaWQgZnJvbSBjdXJy
ZW50IHRhc2sNCj4gKyAqICAgICAgICAgICAgICB3aGljaCBuYW1lc3BhY2UgaW5vZGUgYW5kIGRl
dl90IG1hdGNoZXMgLCBhbmQgaXMgY3JlYXRlIGFzIHN1Y2g6DQo+ICsgKgkJKmN1cnJlbnRfdGFz
aypcICoqLT50Z2lkIDw8IDMyIFx8KioNCj4gKyAqCQkqY3VycmVudF90YXNrKlwgKiotPnBpZCoq
Lg0KPiArICoNCj4gKyAqCQlPbiBmYWlsdXJlLCB0aGUgcmV0dXJuZWQgdmFsdWUgaXMgb25lIG9m
IHRoZSBmb2xsb3dpbmc6DQo+ICsgKg0KPiArICoJCSoqLUVJTlZBTCoqIGlmIGRldiBhbmQgaW51
bSBzdXBwbGllZCBkb24ndCBtYXRjaCBkZXZfdCBhbmQgaW5vZGUgbnVtYmVyDQo+ICsgKiAgICAg
ICAgICAgICAgd2l0aCBuc2ZzIG9mIGN1cnJlbnQgdGFzay4NCj4gKyAqDQo+ICsgKgkJKiotRU5P
RU5UKiogaWYgL3Byb2Mvc2VsZi9ucyBkb2VzIG5vdCBleGlzdHMuDQo+ICsgKg0KPiAgICAqLw0K
PiAgICNkZWZpbmUgX19CUEZfRlVOQ19NQVBQRVIoRk4pCQlcDQo+ICAgCUZOKHVuc3BlYyksCQkJ
XA0KPiBAQCAtMjg2Miw3ICsyODc3LDggQEAgdW5pb24gYnBmX2F0dHIgew0KPiAgIAlGTihza19z
dG9yYWdlX2dldCksCQlcDQo+ICAgCUZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwJCVwNCj4gICAJRk4o
c2VuZF9zaWduYWwpLAkJXA0KPiAtCUZOKHRjcF9nZW5fc3luY29va2llKSwNCj4gKwlGTih0Y3Bf
Z2VuX3N5bmNvb2tpZSksICAgICAgICAgIFwNCj4gKwlGTihnZXRfbnNfY3VycmVudF9waWRfdGdp
ZCksDQo+ICAgDQo+ICAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBCUEZfQ0FM
TCBpbnN0cnVjdGlvbiBzZWxlY3RzIHdoaWNoIGhlbHBlcg0KPiAgICAqIGZ1bmN0aW9uIGVCUEYg
cHJvZ3JhbSBpbnRlbmRzIHRvIGNhbGwNCj4gDQo=
