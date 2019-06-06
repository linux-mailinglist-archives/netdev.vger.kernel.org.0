Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD737EF5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfFFUqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:46:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50002 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfFFUqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:46:24 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Kh629010757;
        Thu, 6 Jun 2019 13:46:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CiLsSMfr+jQbUcmcVNnuPweDTFMro/oOa7K5Tb/ZlKw=;
 b=beYRUT+ZZCMuQZ8BOsE542WU4HZRn+XZngdVBpIIza7XUowJ/wMBiq7nbEi2X2Cry+kt
 QpB2q/ERWITE28/HFWYNK0JBwygdwDLW3WbPuAa+swBJtjLzT2hz7zSzjHoRW+aQ408Z
 Oy8QGnD9TLO9Wo/PcYz3mij7BazKmTfArSM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy7pu8mgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 13:46:00 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 13:45:59 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 13:45:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiLsSMfr+jQbUcmcVNnuPweDTFMro/oOa7K5Tb/ZlKw=;
 b=mUZuWpqwQjDtiy6ApHq5pPQK5FdAvX6zm2o5l360SAcsp3XXhprOvDZZYvFaXOZ+3UpRwHr1lB25K/PdphyFYc6Y7W8MNy1CLJgiL0OhzC73cmoJGhdE2ilTeAOsRS+3tb92vG8VshGSWGnaNzSWgXtIuBeZh70I6l2KRNG9jPA=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1159.namprd15.prod.outlook.com (10.172.175.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 20:45:58 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb%2]) with mapi id 15.20.1943.018; Thu, 6 Jun 2019
 20:45:58 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        Martin Lau <kafai@fb.com>, "m@lambda.lt" <m@lambda.lt>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Topic: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Index: AQHVHHUuKmeVn8eTnkeGX10FyBqYwaaPGMGA
Date:   Thu, 6 Jun 2019 20:45:58 +0000
Message-ID: <20190606204554.GA50385@rdna-mbp.dhcp.thefacebook.com>
References: <20190606143517.25710-1-daniel@iogearbox.net>
In-Reply-To: <20190606143517.25710-1-daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0055.namprd12.prod.outlook.com
 (2603:10b6:300:103::17) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:877]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2322c024-74b0-408e-37d9-08d6eabffa82
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1159;
x-ms-traffictypediagnostic: CY4PR15MB1159:
x-microsoft-antispam-prvs: <CY4PR15MB11593241802CC29DE545AAA5A8170@CY4PR15MB1159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(189003)(68736007)(99286004)(66476007)(9686003)(6436002)(476003)(81166006)(81156014)(54906003)(8676002)(6486002)(53936002)(186003)(446003)(11346002)(5660300002)(561944003)(6916009)(6512007)(305945005)(7736002)(66946007)(73956011)(478600001)(1076003)(66446008)(66556008)(64756008)(46003)(71200400001)(8936002)(71190400001)(229853002)(52116002)(6246003)(76176011)(5024004)(14444005)(256004)(316002)(6116002)(102836004)(386003)(33656002)(6506007)(4326008)(86362001)(486006)(2906002)(14454004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1159;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NSvEfb45l9zqVy3H420yYye+mXqNmOunEvMWgG/alhAtCwFR6OEn1+xG3dpy9Qv5M1BnXLiHtroJYBxQbZ9ibIKAOL6YQV7rLFcTZdLN57QxVHGjm/lP5AX/Id6HKaPIB1EffxVU+5mhg23BgxFZJqIcTerlLC2EyFEi4k5ioCDaoAVApfPOGoLFgnltRWrXm3w2dbPx5+LwCZLp3LoN8IeQT78sda5ncgewdX11eEjd0jn8YxLFjmuLsm8e7y2dktHjoNgwmTV8S416XvF+wUCY0QTBjTdaO3DMtrZ64tt6gjsGxwUseUIsBPUaJpFFjd/D5IvXJDeMHORoA2fWjhqs5kG8VTt7+Cp96A4Px1Cxhd/lguOYG2YnKwv4TFi/oaHhLfvtKZVfVilzZUdjDA/5uUeS4jVHhNmvVVwuAbI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C93CECEF11ED2C49AB6E7938D0D323FE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2322c024-74b0-408e-37d9-08d6eabffa82
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 20:45:58.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdna@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4gW1RodSwgMjAxOS0wNi0wNiAw
NzozNiAtMDcwMF06DQo+IFBsZWFzZSByZWZlciB0byB0aGUgcGF0Y2ggMS80IGFzIHRoZSBtYWlu
IHBhdGNoIHdpdGggdGhlIGRldGFpbHMNCj4gb24gdGhlIGN1cnJlbnQgc2VuZG1zZyBob29rIEFQ
SSBsaW1pdGF0aW9ucyBhbmQgcHJvcG9zYWwgdG8gZml4DQo+IGl0IGluIG9yZGVyIHRvIHdvcmsg
d2l0aCBiYXNpYyBhcHBsaWNhdGlvbnMgbGlrZSBETlMuIFJlbWFpbmluZw0KPiBwYXRjaGVzIGFy
ZSB0aGUgdXN1YWwgdWFwaSBhbmQgdG9vbGluZyB1cGRhdGVzIGFzIHdlbGwgYXMgdGVzdA0KPiBj
YXNlcy4gVGhhbmtzIGEgbG90IQ0KPiANCj4gdjEgLT4gdjI6DQo+ICAgLSBTcGxpdCBvZmYgdWFw
aSBoZWFkZXIgc3luYyBhbmQgYnBmdG9vbCBiaXRzIChNYXJ0aW4sIEFsZXhlaSkNCj4gICAtIEFk
ZGVkIG1pc3NpbmcgYnBmdG9vbCBkb2MgYW5kIGJhc2ggY29tcGxldGlvbiBhcyB3ZWxsDQo+IA0K
PiBEYW5pZWwgQm9ya21hbm4gKDQpOg0KPiAgIGJwZjogZml4IHVuY29ubmVjdGVkIHVkcCBob29r
cw0KPiAgIGJwZjogc3luYyB0b29saW5nIHVhcGkgaGVhZGVyDQo+ICAgYnBmLCBicGZ0b29sOiBl
bmFibGUgcmVjdm1zZyBhdHRhY2ggdHlwZXMNCj4gICBicGY6IGFkZCBmdXJ0aGVyIG1zZ19uYW1l
IHJld3JpdGUgdGVzdHMgdG8gdGVzdF9zb2NrX2FkZHINCj4gDQo+ICBpbmNsdWRlL2xpbnV4L2Jw
Zi1jZ3JvdXAuaCAgICAgICAgICAgICAgICAgICAgfCAgIDggKw0KPiAgaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5oICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsNCj4gIGtlcm5lbC9icGYvc3lz
Y2FsbC5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgOCArDQo+ICBrZXJuZWwvYnBmL3Zl
cmlmaWVyLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTIgKy0NCj4gIG5ldC9jb3JlL2Zp
bHRlci5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+ICBuZXQvaXB2NC91
ZHAuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKw0KPiAgbmV0L2lwdjYv
dWRwLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA0ICsNCj4gIC4uLi9icGZ0
b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1jZ3JvdXAucnN0ICB8ICAgNiArLQ0KPiAgLi4uL2Jw
ZnRvb2wvRG9jdW1lbnRhdGlvbi9icGZ0b29sLXByb2cucnN0ICAgIHwgICAyICstDQo+ICB0b29s
cy9icGYvYnBmdG9vbC9iYXNoLWNvbXBsZXRpb24vYnBmdG9vbCAgICAgfCAgIDUgKy0NCj4gIHRv
b2xzL2JwZi9icGZ0b29sL2Nncm91cC5jICAgICAgICAgICAgICAgICAgICB8ICAgNSArLQ0KPiAg
dG9vbHMvYnBmL2JwZnRvb2wvcHJvZy5jICAgICAgICAgICAgICAgICAgICAgIHwgICAzICstDQo+
ICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggICAgICAgICAgICAgICAgfCAgIDIgKw0K
PiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc29ja19hZGRyLmMgIHwgMjEzICsr
KysrKysrKysrKysrKystLQ0KPiAgMTQgZmlsZXMgY2hhbmdlZCwgMjUwIGluc2VydGlvbnMoKyks
IDI2IGRlbGV0aW9ucygtKQ0KDQp0b29scy9saWIvYnBmL2xpYmJwZi5jIHNob3VsZCBhbHNvIGJl
IHVwZGF0ZWQ6IHNlY3Rpb25fbmFtZXMgYW5kDQpicGZfcHJvZ190eXBlX19uZWVkc19rdmVyLiBQ
bGVhc2UgZWl0aGVyIGZvbGxvdy11cCBzZXBhcmF0ZWx5IG9yIHNlbmQNCnYzLiBPdGhlciB0aGFu
IHRoaXMgTEdNVC4NCg0KQWNrZWQtYnk6IEFuZHJleSBJZ25hdG92IDxyZG5hQGZiLmNvbT4NCg0K
LS0gDQpBbmRyZXkgSWduYXRvdg0K
