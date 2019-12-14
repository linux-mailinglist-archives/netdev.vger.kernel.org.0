Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3111EF33
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLNAXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:23:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57016 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbfLNAXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:23:06 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0Kd7T032208;
        Fri, 13 Dec 2019 16:22:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FppG/ckWH2nmj5J/nvhrkTtg46EywbK8H7nDKJek+9E=;
 b=T6bITZ+PuxHCkViljLuLhHhE2o0ya++ARYw6hgSYklPpWcQt/bD5E2O8WV3qXe/HSEch
 9SCTVoVRoGE36SNqG3C04HnasH2GwRRG3ngptE4/+/uFDluXOA/fUcnQk8jAopkaGOVw
 NHxa98zu9mc1q9JdA/wxrQ3kD0FHYY8ix1A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvkm20btx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 16:22:54 -0800
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 16:22:53 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 16:22:53 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 16:22:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4pstaPUl2LVq3HdlXBy3GA/CrV7GPBHE64lEUdLkCtGUklpmvLoRJtHBcANsIaXX0+60+Ub5wX7Oi/AJLD9ouVZvXyFE8JIe7ezKGbcX2WO2KnqweeGfIdEfvllroydBQKg6PQ0kAmurk18j6o4/e94wivyq09qOPW8QqnuCuDL0lHArteGUSCIvF1AfJ1VwfRoHiCAncFmeUXkVsQL2okeqTtd0Ogj+h+MHb0hEs+Q5GBzSpOMd0n7LbcNqPusSWgC0Ig8U5PBLVp+rIMHrzHSqxr8h+hE2350yOgqFbesXrYiKbmqwQMN7GJU3Ht0SdjtYcf/M+zqVF5k8saIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FppG/ckWH2nmj5J/nvhrkTtg46EywbK8H7nDKJek+9E=;
 b=ab5oOjlCr7kIZzE/XkiTxUI8rJQCqnffRp8pqp5+lMWN0/hJZwOio43LHs5m12p6SsqyKOsufk/6Ei6JKDMBdzQYsDQn7lYrPnI2AI2UWxL3UuetGM1P3SkfCTsmuKvovTbLm8jOfCmz0ju7Dw5hqskwSvTBrZQNm3kIG87aZL1AWs7cXQK+4sSSLesQGj5LkHkpvsc/j2VRgGGVELgpibofuORprj5ylyiMIEKeGrPzOPYyWKS9f4NEmu0CECIlIFdlbQm0jZez9qIjiY9nMY5boOexJ0KRF2vmvbMx1q1xZzlHfK2vsj1ctnzQJxbjcLEjgQM4wK1iad7kp8idZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FppG/ckWH2nmj5J/nvhrkTtg46EywbK8H7nDKJek+9E=;
 b=CvKm4oXVGBxIbP3yq7lLDdLe1ordJcXu2vythZKoCE+ue/u2ofGo9ADl1kVZeDpPCRZVMJt6+8hVblDWeBIbWEKeIALTq5LutsuKxiGkCWL98HL+2hWhgz7SknxTxQ2gWbjeUok4lQd1GskyP5LyvnHEBGxpxIQkY2Nr2LTBZss=
Received: from MWHPR15MB1678.namprd15.prod.outlook.com (10.175.137.19) by
 MWHPR15MB1407.namprd15.prod.outlook.com (10.173.235.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Sat, 14 Dec 2019 00:22:52 +0000
Received: from MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8]) by MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8%9]) with mapi id 15.20.2538.017; Sat, 14 Dec 2019
 00:22:52 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for
 libbpf-provided externs
Thread-Topic: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for
 libbpf-provided externs
Thread-Index: AQHVshBQCFJlXPjNuEKnNP/6iafrXae4xRqA
Date:   Sat, 14 Dec 2019 00:22:52 +0000
Message-ID: <5f04c91d-2e8b-3092-ec7b-af6d59d073a9@fb.com>
References: <20191213235144.3063354-1-andriin@fb.com>
 <20191213235144.3063354-5-andriin@fb.com>
In-Reply-To: <20191213235144.3063354-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:104:1::19) To MWHPR15MB1678.namprd15.prod.outlook.com
 (2603:10b6:300:11e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7ad7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 018bc3e0-2c83-47cf-918f-08d7802bc1ea
x-ms-traffictypediagnostic: MWHPR15MB1407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB14077E09EAE9C0BFE9E6F5E6D7570@MWHPR15MB1407.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 025100C802
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(71200400001)(8936002)(8676002)(2906002)(6486002)(6512007)(186003)(81166006)(86362001)(52116002)(4326008)(2616005)(478600001)(6506007)(53546011)(110136005)(81156014)(5660300002)(64756008)(66446008)(66946007)(66556008)(66476007)(316002)(54906003)(31686004)(31696002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1407;H:MWHPR15MB1678.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e1d7OgFtCO9V8eLjSgab/Xl8vQjj3c+gaCeF+7Dm2jdwHe5911UUJw9Gfm8sXIUt7UEMGy+qsmfWKpiqK6zS2t43VyfQKeHvEQ6BNvo/YnBLS+JMPhEpdkw/lmlTjCUNHZrXpNn4rndhJRvmmLsKzNzgwQlGAaNdkJIaSckC0tzdh+0H+5VimZO7TvG5v16Dfgx786QeofEF1yUfQvHb2kDRgG0k5Vk1mLhIrlmeK+VsjZyNVFW4MOHhu74h0958H1RQpIylVrIIh3K7Z/GkoSr1qyF90e2OadYDTgd5jjY+qbHfKBgp5pcOBWxRYVV0HHH/GWTh4isJHKQzUSeuXgfFWybrP0g1AaU/oRBZC7i5SQhF2t2Ckcypu/KlHAyxNK+uy3nvYdVP+hgnhW2bUA7DyMbmlSOKywghWYuLj8/yVM9s4iqAhAjlrnKDLaaS
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D8EDE9ACB6FC4D8D901C3B077EAD5A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 018bc3e0-2c83-47cf-918f-08d7802bc1ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2019 00:22:52.3368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJyBM1QxzhE1SsREhgPuNQpzz3Ir0v1R0R21FtBPKtEEaGmMuAJJx5JcIG8rmtYD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTMvMTkgMzo1MSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgYSBzZXQg
b2YgdGVzdHMgdmFsaWRhdGluZyBsaWJicGYtcHJvdmlkZWQgZXh0ZXJuIHZhcmlhYmxlcy4gT25l
IGNydWNpYWwNCj4gZmVhdHVyZSB0aGF0J3MgdGVzdGVkIGlzIGRlYWQgY29kZSBlbGltaW5hdGlv
biB0b2dldGhlciB3aXRoIHVzaW5nIGludmFsaWQgQlBGDQo+IGhlbHBlci4gQ09ORklHX01JU1NJ
TkcgaXMgbm90IHN1cHBvc2VkIHRvIGV4aXN0IGFuZCBzaG91bGQgYWx3YXlzIGJlIHNwZWNpZmll
ZA0KPiBieSBsaWJicGYgYXMgemVybywgd2hpY2ggYWxsb3dzIEJQRiB2ZXJpZmllciB0byBjb3Jy
ZWN0bHkgZG8gYnJhbmNoIHBydW5pbmcNCj4gYW5kIG5vdCBmYWlsIHZhbGlkYXRpb24sIHdoZW4g
aW52YWxpZCBCUEYgaGVscGVyIGlzIGNhbGxlZCBmcm9tIGRlYWQgaWYgYnJhbmNoLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gLS0tDQo+
ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9jb3JlX2V4dGVybi5jICAgIHwgMTkzICsr
KysrKysrKysrKysrKysrKw0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvc2tlbGV0
b24uYyAgICAgICB8ICAxOCArLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfY29y
ZV9leHRlcm4uYyAgICB8ICA2MiArKysrKysNCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy90
ZXN0X3NrZWxldG9uLmMgICAgICAgfCAgIDkgKw0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgMjgxIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvY29yZV9leHRlcm4uYw0KPiAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9jb3Jl
X2V4dGVybi5jDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Byb2dfdGVzdHMvY29yZV9leHRlcm4uYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9w
cm9nX3Rlc3RzL2NvcmVfZXh0ZXJuLmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXgg
MDAwMDAwMDAwMDAwLi40ZjVmODQzOWNiMDINCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9jb3JlX2V4dGVybi5jDQo+IEBAIC0w
LDAgKzEsMTkzIEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiAr
I2luY2x1ZGUgPHRlc3RfcHJvZ3MuaD4NCg0KY29weXJpZ2h0IGp1c3QgZm9yIGNvbnNpc3RlbmN5
ID8NCg0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9jb3Jl
X2V4dGVybi5jDQo+IEBAIC0wLDAgKzEsNjIgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlm
aWVyOiBHUEwtMi4wDQo+ICsvLyBDb3B5cmlnaHQgKGMpIDIwMTcgRmFjZWJvb2sNCj4gKw0KDQp3
cm9uZyB5ZWFyIGFuZCBmb3JtYXQuDQpJdCBzaG91bGQgYmUgQyBzdHlsZSBjb21tZW50IC8qICov
DQoNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc2tlbGV0
b24uYw0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9za2Vs
ZXRvbi5jDQo+IEBAIC0xLDYgKzEsNyBAQA0KPiAgIC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wDQo+ICAgLy8gQ29weXJpZ2h0IChjKSAyMDE3IEZhY2Vib29rDQoNCmRpdHRvDQo=
