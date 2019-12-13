Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD7D11EAC6
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfLMS67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:58:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728473AbfLMS67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:58:59 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDIq1ap025606;
        Fri, 13 Dec 2019 10:58:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Kx6MqbG6kl+atUNNQbwoiDYmpXrpG8746xcS8N3lV5I=;
 b=aaQkWNMY8iVcOLR9SPFAKtRZIOwE7ka2jkE+kG6NPrSZEHfiXf9fqXvnEHb67WFlrRP7
 fl+B+266bqVnZ1cWm+C2ZsbmFTdOLPlUQhNU4Nd1FkGvfLBFyk8tr+jeeppEMTJ4tiC/
 Sg7daR5e9q9sG4XTLs7wrj9YkRXJIMTNSUc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wuuxkd4vm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Dec 2019 10:58:39 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 10:58:38 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 10:58:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz40aJPX9gCdReFRku80GE+sdBJrSSzdHGpDnpvlbDNWufIlWo3btfMDrihpLBlRA9OuLLK4Dly2YWzDdHb1XncYCahvhGKTI3pK/914Mk3fOJXgt6YtC9+ksVo3vKUSUlZj5NJ5yYknmiAgesY6BP2d+YXH5eqmyhUBHe7JHiZOcx2m5b2lS65j4fXwP6rvA7mQ1Jx1KBtBxTRAp+S3NMiU79xFLA68noMOUEH81tkGZ88LeIoxgOJU3JArx4XuPxsD2dR/1L0LGK5JMusQXA8zQ/p6Hup/DnUJPX2DJgyBZQ9k1o60Z/CaPWor8U6FzlecEz83QqSepbLR7CBJIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx6MqbG6kl+atUNNQbwoiDYmpXrpG8746xcS8N3lV5I=;
 b=ZbW6c6ir+C/STHdf9SkxClNkKMFLBnp9NOCZtG4qpERUf/IRgY0JICiwhH9jR+Nibbn658Om7IYc7xwqTCK4RXyMF7XI9+4AqDDYHVAkMdJcmAHtPcop2b5WhIQX8YF4qQdgYArnx18aD84ryKB1+A91bEGcqzg1HJixhT6gR0Yz6jdr7DEijxOYOUeIWjOD5ZODao1e8f+PlWJTRjET6C39JAzPUrXzUek1iW76xNwwJiq1hmwvEt64wLHkrPLROP1KLts96cOAwR67NskrK/piQcIOHUpBRhJ7pqx/3SlKUUDsCHeMFG6Aa5hY1+rYWiZ6eIWMqR8apPiDOnlncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx6MqbG6kl+atUNNQbwoiDYmpXrpG8746xcS8N3lV5I=;
 b=CXEZySRlxhF6iWe8ebcDiU7MCiIuC22VRCGJUh0WGkbV2iRigkARn4VLn819O/jUKnyai0UefrLyQwhf+kVuLZAN1B28al8c4UhEljNwuas6kEmlt52aG8pADKQdWKxPaip3d6IqsRQA0ImoZ36rkezAizmY8eZuA2xO4HK+/30=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1546.namprd15.prod.outlook.com (10.173.223.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Fri, 13 Dec 2019 18:58:36 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 18:58:36 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: add batch ops to all htab bpf map
Thread-Topic: [PATCH v3 bpf-next 06/11] bpf: add batch ops to all htab bpf map
Thread-Index: AQHVsHMuYMDKZmq21kWyUxx3YJSoMae4bbuA
Date:   Fri, 13 Dec 2019 18:58:36 +0000
Message-ID: <a33dab7b-0f46-c29f-0db1-a5539c433b3d@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-7-brianvv@google.com>
In-Reply-To: <20191211223344.165549-7-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0053.namprd14.prod.outlook.com
 (2603:10b6:300:81::15) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e31cf9bd-53c6-461f-daf0-08d77ffe7576
x-ms-traffictypediagnostic: DM5PR15MB1546:
x-microsoft-antispam-prvs: <DM5PR15MB1546019442AAB70AC910EAEED3540@DM5PR15MB1546.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(52116002)(478600001)(966005)(4326008)(6506007)(53546011)(186003)(5660300002)(316002)(8936002)(36756003)(54906003)(86362001)(31696002)(110136005)(8676002)(81156014)(66946007)(64756008)(2616005)(71200400001)(66556008)(66476007)(66446008)(7416002)(81166006)(6486002)(31686004)(6512007)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1546;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ddtfvaFMULg+iEWRaKBi60gmM+UNvsX2ZJGs/+Usq1dgTFxKJJmF2M8rjcpZPE5gbarJRZpOnGXNlT/H+BTjvnlnY80pNW2mdFdvAEekiex06/uiSG78BI/4fl99lUBrIxPutrE3QEk6yb+sfHlBeSBmav5/c6okApGhS/gbynbSowwM+JROiOWgmDl/fD73lq6GGdgjk0PSvHqRRzs0m0ccfj5yGB3UUbEcyx1854pXZTwwvd82p4bGuTteibJxnpciR2TAEnPDLVkJFfpecRbp3mtsq/P0F81Nq11AlQV0oMS5g/oL6u3Xr0QNyAW9L6rjt0ZJP+nFsNiH3GbaxxklZBWfz0cCwalJxW7RgOpqbGLWFw0MXK12Zu1tsF8PGaInfF0pcNkhTk/E/hTJLPAlfzzc75xuxAxp/8slQYvdWNMSziQsHtReoHKsFIOkAJpIzyOxQueC3bLxv2Fev9iVaREwsgOdU+2sZ5KqvDM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <33DAEE067798FD42979FA2D430DA6EE6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e31cf9bd-53c6-461f-daf0-08d77ffe7576
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 18:58:36.6398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cABoCw8CuGVzTtkCrNYph6kmzc7rR4WTxqba3gS7YI55fIXoElBwSxnL2k1drdDk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1546
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IEZyb206IFlv
bmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IA0KPiBodGFiIGNhbid0IHVzZSBnZW5lcmljIGJh
dGNoIHN1cHBvcnQgZHVlIHNvbWUgcHJvYmxlbWF0aWMgYmVoYXZpb3Vycw0KPiBpbmhlcmVudCB0
byB0aGUgZGF0YSBzdHJ1Y3RyZSwgaS5lLiB3aGlsZSBpdGVyYXRpbmcgdGhlIGJwZiBtYXAgIGEN
Cj4gY29uY3VycmVudCBwcm9ncmFtIG1pZ2h0IGRlbGV0ZSB0aGUgbmV4dCBlbnRyeSB0aGF0IGJh
dGNoIHdhcyBhYm91dCB0bw0KPiB1c2UsIGluIHRoYXQgY2FzZSB0aGVyZSdzIG5vIGVhc3kgc29s
dXRpb24gdG8gcmV0cmlldmUgdGhlIG5leHQgZW50cnksDQo+IHRoZSBpc3N1ZSBoYXMgYmVlbiBk
aXNjdXNzZWQgbXVsdGlwbGUgdGltZXMgKHNlZSBbMV0gYW5kIFsyXSkuDQo+IA0KPiBUaGUgb25s
eSB3YXkgaG1hcCBjYW4gYmUgdHJhdmVyc2VkIHdpdGhvdXQgdGhlIHByb2JsZW0gcHJldmlvdXNs
eQ0KPiBleHBvc2VkIGlzIGJ5IG1ha2luZyBzdXJlIHRoYXQgdGhlIG1hcCBpcyB0cmF2ZXJzaW5n
IGVudGlyZSBidWNrZXRzLg0KPiBUaGlzIGNvbW1pdCBpbXBsZW1lbnRzIHRob3NlIHN0cmljdCBy
ZXF1aXJlbWVudHMgZm9yIGhtYXAsIHRoZQ0KPiBpbXBsZW1lbnRhdGlvbiBmb2xsb3dzIHRoZSBz
YW1lIGludGVyYWN0aW9uIHRoYXQgZ2VuZXJpYyBzdXBwb3J0IHdpdGgNCj4gc29tZSBleGNlcHRp
b25zOg0KPiANCj4gICAtIElmIGtleXMvdmFsdWVzIGJ1ZmZlciBhcmUgbm90IGJpZyBlbm91Z2gg
dG8gdHJhdmVyc2UgYSBidWNrZXQsDQo+ICAgICBFTk9TUEMgd2lsbCBiZSByZXR1cm5lZC4NCj4g
ICAtIG91dF9iYXRjaCBjb250YWlucyB0aGUgdmFsdWUgb2YgdGhlIG5leHQgYnVja2V0IGluIHRo
ZSBpdGVyYXRpb24sIG5vdA0KPiAgICAgdGhlIG5leHQga2V5LCBidXQgdGhpcyBpcyB0cmFuc3Bh
cmVudCBmb3IgdGhlIHVzZXIgc2luY2UgdGhlIHVzZXINCj4gICAgIHNob3VsZCBuZXZlciB1c2Ug
b3V0X2JhdGNoIGZvciBvdGhlciB0aGFuIGJwZiBiYXRjaCBzeXNjYWxscy4NCj4gDQo+IE5vdGUg
dGhhdCBvbmx5IGxvb2t1cCBhbmQgbG9va3VwX2FuZF9kZWxldGUgYmF0Y2ggb3BzIHJlcXVpcmUg
dGhlIGhtYXANCj4gc3BlY2lmaWMgaW1wbGVtZW50YXRpb24sIHVwZGF0ZS9kZWxldGUgYmF0Y2gg
b3BzIGNhbiBiZSB0aGUgZ2VuZXJpYw0KPiBvbmVzLg0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2JwZi8yMDE5MDcyNDE2NTgwMy44NzQ3MC0xLWJyaWFudnZAZ29vZ2xlLmNvbS8N
Cj4gWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDE5MDkwNjIyNTQzNC4zNjM1NDIx
LTEteWhzQGZiLmNvbS8NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFlvbmdob25nIFNvbmcgPHloc0Bm
Yi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNv
bT4NCj4gLS0tDQo+ICAga2VybmVsL2JwZi9oYXNodGFiLmMgfCAyNDIgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyNDIgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvaGFzaHRhYi5jIGIva2Vy
bmVsL2JwZi9oYXNodGFiLmMNCj4gaW5kZXggMjIwNjZhNjJjOGM5Ny4uZmFjMTA3YmRhZjllYyAx
MDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9oYXNodGFiLmMNCj4gKysrIGIva2VybmVsL2JwZi9o
YXNodGFiLmMNCj4gQEAgLTE3LDYgKzE3LDE3IEBADQo+ICAgCShCUEZfRl9OT19QUkVBTExPQyB8
IEJQRl9GX05PX0NPTU1PTl9MUlUgfCBCUEZfRl9OVU1BX05PREUgfAlcDQo+ICAgCSBCUEZfRl9B
Q0NFU1NfTUFTSyB8IEJQRl9GX1pFUk9fU0VFRCkNCj4gICANCj4gKyNkZWZpbmUgQkFUQ0hfT1BT
KF9uYW1lKQkJCVwNCj4gKwkubWFwX2xvb2t1cF9iYXRjaCA9CQkJXA0KPiArCV9uYW1lIyNfbWFw
X2xvb2t1cF9iYXRjaCwJCVwNCj4gKwkubWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoID0JCVwN
Cj4gKwlfbmFtZSMjX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaCwJXA0KPiArCS5tYXBfdXBk
YXRlX2JhdGNoID0JCQlcDQo+ICsJZ2VuZXJpY19tYXBfdXBkYXRlX2JhdGNoLAkJXA0KPiArCS5t
YXBfZGVsZXRlX2JhdGNoID0JCQlcDQo+ICsJZ2VuZXJpY19tYXBfZGVsZXRlX2JhdGNoDQo+ICsN
Cj4gKw0KPiAgIHN0cnVjdCBidWNrZXQgew0KPiAgIAlzdHJ1Y3QgaGxpc3RfbnVsbHNfaGVhZCBo
ZWFkOw0KPiAgIAlyYXdfc3BpbmxvY2tfdCBsb2NrOw0KPiBAQCAtMTIzMiw2ICsxMjQzLDIzMyBA
QCBzdGF0aWMgdm9pZCBodGFiX21hcF9zZXFfc2hvd19lbGVtKHN0cnVjdCBicGZfbWFwICptYXAs
IHZvaWQgKmtleSwNCj4gICAJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICAgfQ0KPiAgIA0KPiArc3Rh
dGljIGludA0KPiArX19odGFiX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaChzdHJ1Y3QgYnBm
X21hcCAqbWFwLA0KPiArCQkJCSAgIGNvbnN0IHVuaW9uIGJwZl9hdHRyICphdHRyLA0KPiArCQkJ
CSAgIHVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIsDQo+ICsJCQkJICAgYm9vbCBkb19kZWxl
dGUsIGJvb2wgaXNfbHJ1X21hcCwNCj4gKwkJCQkgICBib29sIGlzX3BlcmNwdSkNCj4gK3sNCj4g
KwlzdHJ1Y3QgYnBmX2h0YWIgKmh0YWIgPSBjb250YWluZXJfb2YobWFwLCBzdHJ1Y3QgYnBmX2h0
YWIsIG1hcCk7DQo+ICsJdTMyIGJ1Y2tldF9jbnQsIHRvdGFsLCBrZXlfc2l6ZSwgdmFsdWVfc2l6
ZSwgcm91bmR1cF9rZXlfc2l6ZTsNCj4gKwl2b2lkICprZXlzID0gTlVMTCwgKnZhbHVlcyA9IE5V
TEwsICp2YWx1ZSwgKmRzdF9rZXksICpkc3RfdmFsOw0KPiArCXZvaWQgX191c2VyICp1dmFsdWVz
ID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLnZhbHVlcyk7DQo+ICsJdm9pZCBfX3VzZXIg
KnVrZXlzID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLmtleXMpOw0KPiArCXZvaWQgKnVi
YXRjaCA9IHU2NF90b191c2VyX3B0cihhdHRyLT5iYXRjaC5pbl9iYXRjaCk7DQo+ICsJdTY0IGVs
ZW1fbWFwX2ZsYWdzLCBtYXBfZmxhZ3M7DQo+ICsJc3RydWN0IGhsaXN0X251bGxzX2hlYWQgKmhl
YWQ7DQo+ICsJdTMyIGJhdGNoLCBtYXhfY291bnQsIHNpemU7DQo+ICsJc3RydWN0IGhsaXN0X251
bGxzX25vZGUgKm47DQo+ICsJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gKwlzdHJ1Y3QgaHRhYl9l
bGVtICpsOw0KPiArCXN0cnVjdCBidWNrZXQgKmI7DQo+ICsJaW50IHJldCA9IDA7DQo+ICsNCj4g
KwltYXhfY291bnQgPSBhdHRyLT5iYXRjaC5jb3VudDsNCj4gKwlpZiAoIW1heF9jb3VudCkNCj4g
KwkJcmV0dXJuIDA7DQo+ICsNCj4gKwllbGVtX21hcF9mbGFncyA9IGF0dHItPmJhdGNoLmVsZW1f
ZmxhZ3M7DQo+ICsJaWYgKChlbGVtX21hcF9mbGFncyAmIH5CUEZfRl9MT0NLKSB8fA0KPiArCSAg
ICAoKGVsZW1fbWFwX2ZsYWdzICYgQlBGX0ZfTE9DSykgJiYgIW1hcF92YWx1ZV9oYXNfc3Bpbl9s
b2NrKG1hcCkpKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCW1hcF9mbGFncyA9IGF0
dHItPmJhdGNoLmZsYWdzOw0KPiArCWlmIChtYXBfZmxhZ3MpDQo+ICsJCXJldHVybiAtRUlOVkFM
Ow0KPiArDQo+ICsJYmF0Y2ggPSAwOw0KPiArCWlmICh1YmF0Y2ggJiYgY29weV9mcm9tX3VzZXIo
JmJhdGNoLCB1YmF0Y2gsIHNpemVvZihiYXRjaCkpKQ0KPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4g
Kw0KPiArCWlmIChiYXRjaCA+PSBodGFiLT5uX2J1Y2tldHMpDQo+ICsJCXJldHVybiAtRU5PRU5U
Ow0KPiArDQo+ICsJLyogV2UgY2Fubm90IGRvIGNvcHlfZnJvbV91c2VyIG9yIGNvcHlfdG9fdXNl
ciBpbnNpZGUNCj4gKwkgKiB0aGUgcmN1X3JlYWRfbG9jay4gQWxsb2NhdGUgZW5vdWdoIHNwYWNl
IGhlcmUuDQo+ICsJICovDQo+ICsJa2V5X3NpemUgPSBodGFiLT5tYXAua2V5X3NpemU7DQo+ICsJ
cm91bmR1cF9rZXlfc2l6ZSA9IHJvdW5kX3VwKGh0YWItPm1hcC5rZXlfc2l6ZSwgOCk7DQo+ICsJ
dmFsdWVfc2l6ZSA9IGh0YWItPm1hcC52YWx1ZV9zaXplOw0KPiArCXNpemUgPSByb3VuZF91cCh2
YWx1ZV9zaXplLCA4KTsNCj4gKwlpZiAoaXNfcGVyY3B1KQ0KPiArCQl2YWx1ZV9zaXplID0gc2l6
ZSAqIG51bV9wb3NzaWJsZV9jcHVzKCk7DQo+ICsJa2V5cyA9IGt2bWFsbG9jKGtleV9zaXplLCBH
RlBfVVNFUiB8IF9fR0ZQX05PV0FSTik7DQo+ICsJdmFsdWVzID0ga3ZtYWxsb2ModmFsdWVfc2l6
ZSwgR0ZQX1VTRVIgfCBfX0dGUF9OT1dBUk4pOw0KPiArCWlmICgha2V5cyB8fCAhdmFsdWVzKSB7
DQo+ICsJCXJldCA9IC1FTk9NRU07DQo+ICsJCWdvdG8gb3V0Ow0KPiArCX0NCj4gKw0KPiArCWRz
dF9rZXkgPSBrZXlzOw0KPiArCWRzdF92YWwgPSB2YWx1ZXM7DQo+ICsJdG90YWwgPSAwOw0KPiAr
DQo+ICsJcHJlZW1wdF9kaXNhYmxlKCk7DQo+ICsJdGhpc19jcHVfaW5jKGJwZl9wcm9nX2FjdGl2
ZSk7DQo+ICsJcmN1X3JlYWRfbG9jaygpOw0KPiArDQo+ICthZ2FpbjoNCj4gKwliID0gJmh0YWIt
PmJ1Y2tldHNbYmF0Y2hdOw0KPiArCWhlYWQgPSAmYi0+aGVhZDsNCj4gKwlyYXdfc3Bpbl9sb2Nr
X2lycXNhdmUoJmItPmxvY2ssIGZsYWdzKTsNCj4gKw0KPiArCWJ1Y2tldF9jbnQgPSAwOw0KPiAr
CWhsaXN0X251bGxzX2Zvcl9lYWNoX2VudHJ5X3JjdShsLCBuLCBoZWFkLCBoYXNoX25vZGUpDQo+
ICsJCWJ1Y2tldF9jbnQrKzsNCj4gKw0KPiArCWlmIChidWNrZXRfY250ID4gKG1heF9jb3VudCAt
IHRvdGFsKSkgew0KPiArCQlpZiAodG90YWwgPT0gMCkNCj4gKwkJCXJldCA9IC1FTk9TUEM7DQo+
ICsJCWdvdG8gYWZ0ZXJfbG9vcDsNCj4gKwl9DQo+ICsNCj4gKwlobGlzdF9udWxsc19mb3JfZWFj
aF9lbnRyeV9zYWZlKGwsIG4sIGhlYWQsIGhhc2hfbm9kZSkgew0KPiArCQltZW1jcHkoZHN0X2tl
eSwgbC0+a2V5LCBrZXlfc2l6ZSk7DQo+ICsNCj4gKwkJaWYgKGlzX3BlcmNwdSkgew0KPiArCQkJ
aW50IG9mZiA9IDAsIGNwdTsNCj4gKwkJCXZvaWQgX19wZXJjcHUgKnBwdHI7DQo+ICsNCj4gKwkJ
CXBwdHIgPSBodGFiX2VsZW1fZ2V0X3B0cihsLCBtYXAtPmtleV9zaXplKTsNCj4gKwkJCWZvcl9l
YWNoX3Bvc3NpYmxlX2NwdShjcHUpIHsNCj4gKwkJCQlicGZfbG9uZ19tZW1jcHkoZHN0X3ZhbCAr
IG9mZiwNCj4gKwkJCQkJCXBlcl9jcHVfcHRyKHBwdHIsIGNwdSksIHNpemUpOw0KPiArCQkJCW9m
ZiArPSBzaXplOw0KPiArCQkJfQ0KPiArCQl9IGVsc2Ugew0KPiArCQkJdmFsdWUgPSBsLT5rZXkg
KyByb3VuZHVwX2tleV9zaXplOw0KPiArCQkJaWYgKGVsZW1fbWFwX2ZsYWdzICYgQlBGX0ZfTE9D
SykNCj4gKwkJCQljb3B5X21hcF92YWx1ZV9sb2NrZWQobWFwLCBkc3RfdmFsLCB2YWx1ZSwNCj4g
KwkJCQkJCSAgICAgIHRydWUpOw0KPiArCQkJZWxzZQ0KPiArCQkJCWNvcHlfbWFwX3ZhbHVlKG1h
cCwgZHN0X3ZhbCwgdmFsdWUpOw0KPiArCQkJY2hlY2tfYW5kX2luaXRfbWFwX2xvY2sobWFwLCBk
c3RfdmFsKTsNCj4gKwkJfQ0KPiArCQlpZiAoZG9fZGVsZXRlKSB7DQo+ICsJCQlobGlzdF9udWxs
c19kZWxfcmN1KCZsLT5oYXNoX25vZGUpOw0KPiArCQkJaWYgKGlzX2xydV9tYXApDQo+ICsJCQkJ
YnBmX2xydV9wdXNoX2ZyZWUoJmh0YWItPmxydSwgJmwtPmxydV9ub2RlKTsNCj4gKwkJCWVsc2UN
Cj4gKwkJCQlmcmVlX2h0YWJfZWxlbShodGFiLCBsKTsNCj4gKwkJfQ0KPiArCQlpZiAoY29weV90
b191c2VyKHVrZXlzICsgdG90YWwgKiBrZXlfc2l6ZSwga2V5cywga2V5X3NpemUpIHx8DQo+ICsJ
CSAgIGNvcHlfdG9fdXNlcih1dmFsdWVzICsgdG90YWwgKiB2YWx1ZV9zaXplLCB2YWx1ZXMsDQo+
ICsJCSAgIHZhbHVlX3NpemUpKSB7DQoNCldlIGNhbm5vdCBkbyBjb3B5X3RvX3VzZXIgaW5zaWRl
IGF0b21pYyByZWdpb24gd2hlcmUgaXJxIGlzIGRpc2FibGVkDQp3aXRoIHJhd19zcGluX2xvY2tf
aXJxc2F2ZSgpLiBXZSBjb3VsZCBkbyB0aGUgZm9sbG93aW5nOg0KICAgIC4gd2Uga2FsbG9jIG1l
bW9yeSBiZWZvcmUgcHJlZW1wdF9kaXNhYmxlKCkgd2l0aCB0aGUgY3VycmVudCBjb3VudA0KICAg
ICAgb2YgYnVja2V0IHNpemUuDQogICAgLiBpbnNpZGUgdGhlIHJhd19zcGluX2xvY2tfaXJxc2F2
ZSgpIHJlZ2lvbiwgd2UgY2FuIGRvIGNvcHkgdG8ga2VybmVsDQogICAgICBtZW1vcnkuDQogICAg
LiBpbnNpZGUgdGhlIHJhd19zcGluX2xvY2tfaXJxc2F2ZSgpIHJlZ2lvbiwgaWYgdGhlIGJ1Y2tl
dCBzaXplDQogICAgICBjaGFuZ2VzLCB3ZSBjYW4gaGF2ZSBhIGZldyByZXRyaWVzIHRvIGluY3Jl
YXNlIGFsbG9jYXRpb24gc2l6ZQ0KICAgICAgYmVmb3JlIGdpdmluZyB1cC4NCkRvIHlvdSB0aGlu
ayB0aGlzIG1heSB3b3JrPw0KDQo+ICsJCQlyZXQgPSAtRUZBVUxUOw0KPiArCQkJZ290byBhZnRl
cl9sb29wOw0KPiArCQl9DQo+ICsJCXRvdGFsKys7DQo+ICsJfQ0KPiArDQo+ICsJYmF0Y2grKzsN
Cj4gKwlpZiAoYmF0Y2ggPj0gaHRhYi0+bl9idWNrZXRzKSB7DQo+ICsJCXJldCA9IC1FTk9FTlQ7
DQo+ICsJCWdvdG8gYWZ0ZXJfbG9vcDsNCj4gKwl9DQo+ICsNCj4gKwlyYXdfc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmYi0+bG9jaywgZmxhZ3MpOw0KPiArCWdvdG8gYWdhaW47DQo+ICsNCj4gK2Fm
dGVyX2xvb3A6DQo+ICsJcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmItPmxvY2ssIGZsYWdz
KTsNCj4gKw0KPiArCXJjdV9yZWFkX3VubG9jaygpOw0KPiArCXRoaXNfY3B1X2RlYyhicGZfcHJv
Z19hY3RpdmUpOw0KPiArCXByZWVtcHRfZW5hYmxlKCk7DQo+ICsNCj4gKwlpZiAocmV0ICYmIHJl
dCAhPSAtRU5PRU5UKQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCS8qIGNvcHkgZGF0YSBiYWNr
IHRvIHVzZXIgKi8NCj4gKwl1YmF0Y2ggPSB1NjRfdG9fdXNlcl9wdHIoYXR0ci0+YmF0Y2gub3V0
X2JhdGNoKTsNCj4gKwlpZiAoY29weV90b191c2VyKHViYXRjaCwgJmJhdGNoLCBzaXplb2YoYmF0
Y2gpKSB8fA0KPiArCSAgICBwdXRfdXNlcih0b3RhbCwgJnVhdHRyLT5iYXRjaC5jb3VudCkpDQo+
ICsJCXJldCA9IC1FRkFVTFQ7DQo+ICsNCj4gK291dDoNCj4gKwlrdmZyZWUoa2V5cyk7DQo+ICsJ
a3ZmcmVlKHZhbHVlcyk7DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KWy4uLl0NCg==
