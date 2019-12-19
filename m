Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A24126CA6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfLSTFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:05:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729278AbfLSSqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 13:46:04 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJIjsu3017158;
        Thu, 19 Dec 2019 10:46:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aUsiiIThZk00EuVzXEFq0gclpu+d8I3C3s6kBNjzMEQ=;
 b=HbrAoZPP8Oqu8cme5Idp3DcQVQB9urku51yLlhJvgTOz/vdNlm4Z6aiHYQvFCGiq34aA
 VKTG3y4XJEv1ihdQqtU2QEwwc/tYLyPvuzbhUxwrgaf1E1gDbSNHApAVK8MXWF4iF+yD
 T53DNYRkbadMQmftkrUN3wGvbyvjLOPppRE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wyqmcpc30-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 10:46:01 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 19 Dec 2019 10:45:52 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 19 Dec 2019 10:45:52 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Dec 2019 10:45:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hn0PlPEQ/5rakSs4rhFrg7O7imbzK3rgLDKXqYNVTYSXzSDx7ZpYG7UJGdXfTz01y1+3tCaZVfJM0WBMlKgmffdOH5Le8ii4HlVW7n0WUViqsYeuuZ6hxxy+U4uVDIvpFZOYcsnqvNQmTsOtMfOeg5gbn55J4BDvUNbJy5HGwLku/du71lk6bygtO4umxAFw2ajBN5XBVwtsVEexzRYbS4H0ZWreVtT9DJUiCElDSCTQXYVmitWG4aonNBldEWsVqZtx1tN35kq3CekU1Yqd0Reloz+bM4qI/4z0XUfLsTKmaC3wdV4H1NEuNQs7UqS4PapOfBnDRcbhLW/OjyvKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUsiiIThZk00EuVzXEFq0gclpu+d8I3C3s6kBNjzMEQ=;
 b=fxSt6cJSmY3OPbuCQBzaPRu9TLXzRocJaQVsPJ8Y4njKP82zNXZFYdEx+7yeAb1lfxpSqsk6pBdQaCkmk18e8NifCOaZsnYGDr7ERzxFb3EgORERYcCAP4FVgKPWbUQWQCmRgunjtZYKKelK6Y7tLpKeXx+h2Fvr4Q2KLY7sef6Ho11i6CSeqWV+iNEb+YftdDjak9kQA0lVMYUiP2PbLsQmXdGI5ediQPCh9zvytLb6s7mUpzJ4Wru3vOhFb0r58zlHtzbD/KxieGSAgJZ8F4toIgdv8oY11y5wSHp8p8dKxe78tJzt3PFdG78GM3g46vMNjQFCXjuuTV+L82DE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUsiiIThZk00EuVzXEFq0gclpu+d8I3C3s6kBNjzMEQ=;
 b=NZVSl/tjAqb03W21oFRi0TSnh0zU8szw7ZSbRJoVBgsmoi+aoWRm4899XxT6Tda3FxndZzYefoYKnmGjyz/7FiG66D8pKBg5+XDtYq4WXcQ4WeHfzCytg1l7oltJ6pAu253GOv2pBOxG5kZcOQllEqLLejpVOAzrTzyTUs7RTxE=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1244.namprd15.prod.outlook.com (10.173.210.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Thu, 19 Dec 2019 18:45:51 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 18:45:50 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v16 1/5] fs/nsfs.c: added ns_match
Thread-Topic: [PATCH v16 1/5] fs/nsfs.c: added ns_match
Thread-Index: AQHVtcoEGNkiOevgrU6VLf+f4uRSYqfBzXoA
Date:   Thu, 19 Dec 2019 18:45:50 +0000
Message-ID: <f64287b8-0998-a7cc-0b48-a88955438c49@fb.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <20191218173827.20584-2-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-2-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0035.namprd12.prod.outlook.com
 (2603:10b6:301:2::21) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:442e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0128830-85db-45b0-043a-08d784b3ab58
x-ms-traffictypediagnostic: DM5PR15MB1244:
x-microsoft-antispam-prvs: <DM5PR15MB1244EA8EB7573D28B5E62340D3520@DM5PR15MB1244.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(396003)(39860400002)(346002)(199004)(189003)(71200400001)(81156014)(81166006)(54906003)(31696002)(6512007)(64756008)(66476007)(316002)(66556008)(66446008)(478600001)(186003)(8676002)(52116002)(36756003)(6916009)(8936002)(53546011)(6506007)(86362001)(5660300002)(6486002)(66946007)(4326008)(2906002)(31686004)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1244;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dh9LnrFxYXdt0cfLkyfzxMqWl/Xzt70HY75tHA3nPDD0lsGk4vD/l7XL53xJt1ABMR6zTeC65uZy/77p8oGx8GEtmFkv4PkKHNfT53ikQQ3nMlExTHrMXaxMaPXPj83kyZo7fFiKCqNOSlZadXx6Azw7CafB4m/0mEMoUr+kDfh3TCIUiyuZhpxOQIgkxJMOF10Pdd4VcbTKQNtojmOPubPe2nTJZAK5I0yibCoX4vtLKi74S0jiOnkbI0pybtLy9eXTFsWONkA3+N8faUlzoRT/rLOerNh7Hus/ULidM0eDTV1cINpm802pBBlz1kIoitPQ/jzBuFN7q7BSfhIM0emlWM13SSKBZf9sw6OyVa1fAXfEIcyngtNJW8oZhN7ojJLw/lAeUI2jtUbbvUEwoWx0tZMiwgelz7fsLPEsg4rWIdfev+7iamC8owgWGLF5
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7F015C41E1F1641845D48AF6FEF6AC7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c0128830-85db-45b0-043a-08d784b3ab58
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:45:50.7857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTfUf/ep8yxUMcNi4bh2iceSA/YGI1SvI0XLciqE7FyGfmcgPWOiSsdtggqqjZ3b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1244
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMi8xOC8xOSA5OjM4IEFNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IG5zX21hdGNoIHJl
dHVybnMgdHJ1ZSBpZiB0aGUgbmFtZXNwYWNlIGlub2RlIGFuZCBkZXZfdCBtYXRjaGVzIHRoZSBv
bmVzDQo+IHByb3ZpZGVkIGJ5IHRoZSBjYWxsZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYXJs
b3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGZzL25zZnMuYyAg
ICAgICAgICAgICAgIHwgMTQgKysrKysrKysrKysrKysNCj4gICBpbmNsdWRlL2xpbnV4L3Byb2Nf
bnMuaCB8ICAyICsrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZnMvbnNmcy5jIGIvZnMvbnNmcy5jDQo+IGluZGV4IGEwNDMxNjQyYzZi
NS4uZWY1OWNmMzQ3Mjg1IDEwMDY0NA0KPiAtLS0gYS9mcy9uc2ZzLmMNCj4gKysrIGIvZnMvbnNm
cy5jDQo+IEBAIC0yNDUsNiArMjQ1LDIwIEBAIHN0cnVjdCBmaWxlICpwcm9jX25zX2ZnZXQoaW50
IGZkKQ0KPiAgIAlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gICB9DQo+ICAgDQo+ICsvKioN
Cj4gKyAqIG5zX21hdGNoKCkgLSBSZXR1cm5zIHRydWUgaWYgY3VycmVudCBuYW1lc3BhY2UgbWF0
Y2hlcyBkZXYvaW5vIHByb3ZpZGVkLg0KPiArICogQG5zX2NvbW1vbjogY3VycmVudCBucw0KPiAr
ICogQGRldjogZGV2X3QgZnJvbSBuc2ZzIHRoYXQgd2lsbCBiZSBtYXRjaGVkIGFnYWluc3QgY3Vy
cmVudCBuc2ZzDQo+ICsgKiBAaW5vOiBpbm9fdCBmcm9tIG5zZnMgdGhhdCB3aWxsIGJlIG1hdGNo
ZWQgYWdhaW5zdCBjdXJyZW50IG5zZnMNCj4gKyAqDQo+ICsgKiBSZXR1cm46IHRydWUgaWYgZGV2
IGFuZCBpbm8gbWF0Y2hlcyB0aGUgY3VycmVudCBuc2ZzLg0KPiArICovDQo+ICtib29sIG5zX21h
dGNoKGNvbnN0IHN0cnVjdCBuc19jb21tb24gKm5zLCBkZXZfdCBkZXYsIGlub190IGlubykNCj4g
K3sNCj4gKwlyZXR1cm4gKG5zLT5pbnVtID09IGlubykgJiYgKG5zZnNfbW50LT5tbnRfc2ItPnNf
ZGV2ID09IGRldik7DQo+ICt9DQo+ICsNCj4gKw0KPiAgIHN0YXRpYyBpbnQgbnNmc19zaG93X3Bh
dGgoc3RydWN0IHNlcV9maWxlICpzZXEsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkNCj4gICB7DQo+
ICAgCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7DQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaCBiL2luY2x1ZGUvbGludXgvcHJvY19ucy5oDQo+IGlu
ZGV4IGQzMWNiNjIxNTkwNS4uMWRhOWYzMzQ4OWYzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xp
bnV4L3Byb2NfbnMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaA0KPiBAQCAtODIs
NiArODIsOCBAQCB0eXBlZGVmIHN0cnVjdCBuc19jb21tb24gKm5zX2dldF9wYXRoX2hlbHBlcl90
KHZvaWQgKik7DQo+ICAgZXh0ZXJuIHZvaWQgKm5zX2dldF9wYXRoX2NiKHN0cnVjdCBwYXRoICpw
YXRoLCBuc19nZXRfcGF0aF9oZWxwZXJfdCBuc19nZXRfY2IsDQo+ICAgCQkJICAgIHZvaWQgKnBy
aXZhdGVfZGF0YSk7DQo+ICAgDQo+ICtleHRlcm4gYm9vbCBuc19tYXRjaChjb25zdCBzdHJ1Y3Qg
bnNfY29tbW9uICpucywgZGV2X3QgZGV2LCBpbm9fdCBpbm8pOw0KPiArDQo+ICAgZXh0ZXJuIGlu
dCBuc19nZXRfbmFtZShjaGFyICpidWYsIHNpemVfdCBzaXplLCBzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KnRhc2ssDQo+ICAgCQkJY29uc3Qgc3RydWN0IHByb2NfbnNfb3BlcmF0aW9ucyAqbnNfb3BzKTsN
Cj4gICBleHRlcm4gdm9pZCBuc2ZzX2luaXQodm9pZCk7DQoNCkVyaWMsIHRoZSBhYm92ZSBuc19t
YXRjaCBtZWNoYW5pc20gaXMgd2hhdCB3ZSBkaXNjdXNzZWQgYW5kIHlvdSANCnN1Z2dlc3RlZC4g
SXQgd291bGQgYmUgZ29vZCB0byBnZXQgeW91IGxvb2sgYXQgaXQgYWdhaW4gYW5kIGFjaw0KaWYg
bm8gZnVydGhlciBxdWVzdGlvbnMuIFRoYW5rcyENCg==
