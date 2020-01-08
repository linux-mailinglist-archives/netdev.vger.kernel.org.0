Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F52C1349EF
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 18:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgAHR6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 12:58:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbgAHR6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 12:58:42 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008HwMfr027841;
        Wed, 8 Jan 2020 09:58:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IRI+7DiGppIsLZ3MK1DmV1J2CoegoNI8Dzw9vhVBVbo=;
 b=F5cn7GcejV/fR4qvzKZJgymNBLtd2v4gqXrI0PHfouQuX4gxhI4aNfdtyOTDA5EWRdF3
 SuQUv56YaK1pyblzbJYsTmffu5kZRUzqh16fprZq9Lmk44BC0upgx9oMOUAcRvwWZXzb
 ZnjPx+/5J2GyBanbKAUm8VL+E4gZYRKwoDE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdkut8119-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 09:58:25 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 8 Jan 2020 09:57:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jan 2020 09:57:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0sMQsqx2OkwHoWrAjewHtChlaWVWRlVEmANHq6FkDN64Ngt9Q1a8VJfweca8DvqOrWmxiKrVQVrh1A6LOR4CUTIy8/pgZO0JR0AICH8fEP1xajISYv/swE58vtN0A85gW89heBPSFWSxcYBiOSDj3hf7UwYYR/Vn5BwvNZGTKq2zpJy1SdRVIalT8jRXtlfARhpvxYSXFmgoYDqDx8JQJsejh+FkNewv2OU+VKtp3rpTUfcIaAE12+0ZPUgYsgzFTKFzaOj7Tjtvj9g1waHmC8nZjPN6VGIMDjvBNxk+lFghoaTyaoAX0G4wUMQIcR6D9De/+0Q9GDX5fnPn/zrJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRI+7DiGppIsLZ3MK1DmV1J2CoegoNI8Dzw9vhVBVbo=;
 b=CcNOIQLX3tclXUvs0f4sLyQ0ePCJCJ+JGvYQUbdwt3UI8EmkheQ/hZbLzNSuXPENN/uYbW4Nc1XPi3NrONDezYRiHE+4xGPFiM217Rry9ihD5xLYU6ytsCMgGoUHpk/1ss0g/x9Vdwgt2CgrJqcvJIz4Vu1xnNSEy8GvDLInNuFiPPKnSAD2xm6XjU9liTBoHDxjsOV9baBGmqd2oPUvMlKnc5Fe2g+x8ARu79+mUyd1Qi2IRGtToziD+U/k1J4/15IVIg8M+NsZyCkQX89FJNsEn8pszTtCJ4ZTqMK6nniwtSuQTvmoD9IgiNclgeKgoRYiV023/lBuSXhpu47G8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRI+7DiGppIsLZ3MK1DmV1J2CoegoNI8Dzw9vhVBVbo=;
 b=EzqGXS3Pl8zGr8LggugR4Uvj/hlg2hJl7bdgaiy2yzHHXT3GoD7dnW3UPA3VRWwXewMLtHerXZHpGF0+SeWs8gRWVW3gOuzl4F6JaTuWfIO5uLGBs/U/yOrLMo7Sk5f/7vClOxJf2eWIlIlZUz/iZ9fjZdlzIgPQfcmKO5OCs48=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3045.namprd15.prod.outlook.com (20.178.237.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 17:57:55 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 17:57:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about
 functions
Thread-Topic: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about
 functions
Thread-Index: AQHVxfThMozInHXHykGjLFHsqut+uqfgj9sAgAB+iAA=
Date:   Wed, 8 Jan 2020 17:57:55 +0000
Message-ID: <76F721B3-A848-40BD-8B1D-A0AA3EB1AB39@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-3-ast@kernel.org> <871rsai6td.fsf@toke.dk>
In-Reply-To: <871rsai6td.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2125502-2950-408e-645f-08d7946449d5
x-ms-traffictypediagnostic: BYAPR15MB3045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB30456F6168CF80AAFC1D2C15B33E0@BYAPR15MB3045.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(346002)(376002)(396003)(189003)(199004)(33656002)(53546011)(81156014)(316002)(2616005)(54906003)(6512007)(91956017)(6506007)(186003)(6916009)(86362001)(66556008)(66446008)(36756003)(66476007)(81166006)(6486002)(4744005)(5660300002)(66946007)(478600001)(76116006)(64756008)(2906002)(8936002)(8676002)(71200400001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3045;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lE/rhy09OSB+JqwFDZbYBMCPaz23wKlXR2zAcdIF/V7ofVtz3v8OsxYkqTIKCe44ajY7evgRL49Vgd2nMTH3GukaYWPdFwiBv0nig8gSyunHcGij6jEGIPndYl8uSKEOa7H/TO0aqfSQ+eIKWzV9P2hXx6Be2Kms9MdDeoCiTgviWztZU6XY4DaYogGqe8dOcqqZjK7nC/tvOhDCfZ5Cmx7lqjnYGo/qWEjGMXUuJaLNrAhfOIJs5HEm24CM6Ee1yZh/mgCQCv44wUlLVx9JQCqYApXmmoQzXS406wbJjXfRE2WSzX6FhXY5vaPpoREl+BUUCcarCrhm2V8Y5JcJEYjO22JJAVUlBMqmgk4yS1llgHK3rOnXIvMnf3heB0yAVcLZPk5GGvEuEIseHZ0oVReVS4jKyW9iKJyWTnic6pQ8n7l3PTXTu8r1SQrOfvfQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E703A59BDA2254DA4FBD6912CA166B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b2125502-2950-408e-645f-08d7946449d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 17:57:55.0457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hBpesmXdJeEvZreoNl3x4Z1pZSJJmt7CoxeRfKWAUek72jcM31qMPnKSnh5KVGfFwsWolE9iOS/LN8n+hOagaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3045
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=961 impostorscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSmFuIDgsIDIwMjAsIGF0IDI6MjUgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0
QGtlcm5lbC5vcmc+IHdyaXRlczoNCj4gDQo+PiBDb2xsZWN0IHN0YXRpYyB2cyBnbG9iYWwgaW5m
b3JtYXRpb24gYWJvdXQgQlBGIGZ1bmN0aW9ucyBmcm9tIEVMRiBmaWxlIGFuZA0KPj4gaW1wcm92
ZSBCVEYgd2l0aCB0aGlzIGFkZGl0aW9uYWwgaW5mbyBpZiBsbHZtIGlzIHRvbyBvbGQgYW5kIGRv
ZXNuJ3QgZW1pdCBpdCBvbg0KPj4gaXRzIG93bi4NCj4gDQo+IEhhcyB0aGUgc3VwcG9ydCBmb3Ig
dGhpcyBhY3R1YWxseSBsYW5kZWQgaW4gTExWTSB5ZXQ/IEkgdHJpZWQgZ3JlcCdpbmcNCj4gaW4g
dGhlIGNvbW1pdCBsb2cgYW5kIGNvdWxkbid0IGZpbmQgYW55dGhpbmcuLi4NCj4gDQo+IFsuLi5d
DQo+PiBAQCAtMzEzLDYgKzMyMSw3IEBAIHN0cnVjdCBicGZfb2JqZWN0IHsNCj4+IAlib29sIGxv
YWRlZDsNCj4+IAlib29sIGhhc19wc2V1ZG9fY2FsbHM7DQo+PiAJYm9vbCByZWxheGVkX2NvcmVf
cmVsb2NzOw0KPj4gKwlib29sIGxsdm1fZW1pdHNfZnVuY19saW5rYWdlOw0KPiANCj4gTml0OiBz
L2xsdm0vY29tcGlsZXIvPyBQcmVzdW1hYmx5IEdDQyB3aWxsIGFsc28gc3VwcG9ydCB0aGlzIGF0
IHNvbWUNCj4gcG9pbnQ/DQoNCkVjaG9pbmcgdGhpcyBuaXQgKGFuZCBvdGhlciByZWZlcmVuY2Vz
IHRvIGxsdm0pLiBPdGhlcndpc2UsDQoNCkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZp
bmdAZmIuY29tPg==
