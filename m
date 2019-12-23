Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C712927F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfLWHsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:48:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12620 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbfLWHsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 02:48:38 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBN7kEtb008660;
        Sun, 22 Dec 2019 23:48:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4ibdPyROHDDpcJchLn6ouGTR21Lgx/sW9Y0xOla8Ir8=;
 b=CYTP0eAQuNOOetLGTgd+gx93ALxzKQTssUDZCQTfzOa7DvA6Vo+KoxCTBYAOphe2ibgw
 QSd9GkLkqY9NTZ1mRjaYVxL3g9aDiuQBPQXvun/SmK6pN7nxqC7mMSg3/b9iyE0XpsY4
 3Mn/axQVfh3NcVkUi+FDfBAYGaVjUrBlVmQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x2410b6my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Dec 2019 23:48:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 22 Dec 2019 23:48:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLEBTsRXMkFc4EjYyCxyppRH0F980h1wiGXImTY75x78Dann+t76cm2knhFR8nUBvHVazdeOQ8MCXBBoXgkOGz3MsKsbdNwCgDg93qxtrBwblxZ5xUtncSCXE90YA8fpOZq0gxJbcl+/oBQLOt5ZhwU5RiMpLPlNvCoL7NUvfCe/M0M4Mhb6u4G346copfJ/QJu2vH6EcaEdFE7J4GBvm44FwBayP5+Cace1p88jj0ypal08FllqXkcuDjXj3x8/MK+FiCakip2sysCpUa3RhSLnZcxVHXSivKO8W1EjaCCdBh60yTyJ/UYKvGgabwCV9tezAdJ0k+QDGfsYwdeGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ibdPyROHDDpcJchLn6ouGTR21Lgx/sW9Y0xOla8Ir8=;
 b=Bak7IEplQtA5vsuQ4WytmMtxL3ZTXyBRsZRoB01Z6EH5CPfJxdiseUycA7evpnOlM54UPDan5GjK8JpfVPpihDv5x2H41vOfIbKD6Jl5m4xV17Lur4Ow2xLy4RlNb4BRaqrKGRnnWLq+U3yyYaasXnNg1b23/tyOxTjrc8i73t6iujRv1znNA4RWKgODy8OiZ0HcH/1c16lVStcvU96o0NNFLz4+lnZqc5PWGvcImQ2T9VvxV7svZSalZeIie/OYc1HEogQJjjX/bQsbU5iif8ff84rjp5zOcXqKi5rSX67OBvYA/md1twim2pTRx77f5KNtSN4MD3Lw4B+WDSg53g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ibdPyROHDDpcJchLn6ouGTR21Lgx/sW9Y0xOla8Ir8=;
 b=dr7zYLEcgSnHLBNCLgGatD0VnsMqhoL7LH8vxFkLa7TUcZSbOcJArzOVDmoHEJPkmnBdRMwHiRCH3uITMfgLZWVLFOGXe4hOweYIVoDq+BTk7ST3gV1cqxGL84SXa31p30E33Rna+AJD7Wj5v4Iu9nvoMkUbVSDKADhdH/O1lV0=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1547.namprd15.prod.outlook.com (10.173.221.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 07:48:22 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 07:48:21 +0000
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:180::62a8) by CO1PR15CA0088.namprd15.prod.outlook.com (2603:10b6:101:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 07:48:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: support CO-RE relocations for
 LD/LDX/ST/STX instructions
Thread-Topic: [PATCH bpf-next] libbpf: support CO-RE relocations for
 LD/LDX/ST/STX instructions
Thread-Index: AQHVuVjlfxCfUgiRgEuZK5Kvafk33qfHV/wA
Date:   Mon, 23 Dec 2019 07:48:21 +0000
Message-ID: <e70fde6d-77fd-6fa8-c6ce-23848dce4b22@fb.com>
References: <20191223061855.1601999-1-andriin@fb.com>
In-Reply-To: <20191223061855.1601999-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0088.namprd15.prod.outlook.com
 (2603:10b6:101:20::32) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::62a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa90ab70-c98f-4a31-c91c-08d7877c7b8c
x-ms-traffictypediagnostic: DM5PR15MB1547:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1547253B3887FC17587FF8B1D32E0@DM5PR15MB1547.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(54906003)(6512007)(86362001)(110136005)(316002)(52116002)(31686004)(2906002)(5660300002)(6486002)(31696002)(66476007)(66556008)(66446008)(64756008)(66946007)(186003)(16526019)(8676002)(81156014)(81166006)(6506007)(53546011)(966005)(71200400001)(2616005)(478600001)(8936002)(36756003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1547;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOwpgtGa1J3xEGyKbFcvEKbT4kkFG841xGWJiY1OwhGXlkJrAZao2i221qtPUG/h5iWjslJs6uz/XePfBExEqJOmmAMX54hheEmOiSyEeFcY3TUVaHv45v8zfFfXHPJxu9wTnMnGQvMqMAbJonWRTLijRUkwKu2pdTzfOVcbmGTMegkg4VFj6hBMFRSPJcc8IbjSSn3U8sPX2FLugu6Cw3ZnkBMZcuFUL72ZJANjfEe5QoSllwaZX4t3bLJajf7ZrUzciZhr1UK1GSAQAeKRgM4b+sdi97m2iMopKyg/Ox7pN9E04ZPXKzIlgofbr7N89Wwa8Z74HHpQYXU7tXkWGmAuiExu0zbgwf4XAHY+t7r1H6La9x6KmH9juZvHJqnCcyAXgdQjoziN8t7pqGJD3tLNIGdXEsXSicX4wTMV7sFItuAi67/zjAt88/brENSXRJe8gMIHdRu4P359wU+ubIZgdVRG1+53p3ei30MoHJs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D75FDFAADF7934F96D2859C84DB479C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fa90ab70-c98f-4a31-c91c-08d7877c7b8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 07:48:21.7551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: du+4/Txk9B2YIQ1FgZg6dp8sNSPjulHi5nz6g3mleLK0FPJU/ptnVJI4BF5zlnoc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1547
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_03:2019-12-17,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIyLzE5IDEwOjE4IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IENsYW5n
IHBhdGNoIFswXSBlbmFibGVzIGVtaXR0aW5nIHJlbG9jYXRhYmxlIGdlbmVyaWMgQUxVL0FMVTY0
IGluc3RydWN0aW9ucw0KPiAoaS5lLCBzaGlmdHMgYW5kIGFyaXRobWV0aWMgb3BlcmF0aW9ucyks
IGFzIHdlbGwgYXMgZ2VuZXJpYyBsb2FkL3N0b3JlDQo+IGluc3RydWN0aW9ucy4gVGhlIGZvcm1l
ciBvbmVzIGFyZSBhbHJlYWR5IHN1cHBvcnRlZCBieSBsaWJicGYgYXMgaXMuIFRoaXMNCj4gcGF0
Y2ggYWRkcyBmdXJ0aGVyIHN1cHBvcnQgZm9yIGxvYWQvc3RvcmUgaW5zdHJ1Y3Rpb25zLiBSZWxv
Y2F0YWJsZSBmaWVsZA0KPiBvZmZzZXQgaXMgZW5jb2RlZCBpbiBCUEYgaW5zdHJ1Y3Rpb24ncyAx
Ni1iaXQgb2Zmc2V0IHNlY3Rpb24gYW5kIGFyZSBhZGp1c3RlZA0KPiBieSBsaWJicGYgYmFzZWQg
b24gdGFyZ2V0IGtlcm5lbCBCVEYuDQo+IA0KPiBUaGVzZSBDbGFuZyBjaGFuZ2VzIGFuZCBjb3Jy
ZXNwb25kaW5nIGxpYmJwZiBjaGFuZ2VzIGFsbG93IGZvciBtb3JlIHN1Y2NpbmN0DQo+IGdlbmVy
YXRlZCBCUEYgY29kZSBieSBlbmNvZGluZyByZWxvY2F0YWJsZSBmaWVsZCByZWFkcyBhcyBhIHNp
bmdsZQ0KPiBMRC9TVC9MRFgvU1RYIGluc3RydWN0aW9uLiBJdCBhbHNvIGVuYWJsZXMgcmVsb2Nh
dGFibGUgYWNjZXNzIHRvIEJQRiBjb250ZXh0Lg0KPiBQcmV2aW91c2x5LCBpZiBjb250ZXh0IHN0
cnVjdCAoZS5nLiwgX19za19idWZmKSB3YXMgYWNjZXNzZWQgd2l0aCBDTy1SRQ0KPiByZWxvY2F0
aW9ucyAoZS5nLiwgZHVlIHRvIHByZXNlcnZlX2FjY2Vzc19pbmRleCBhdHRyaWJ1dGUpLCBpdCB3
b3VsZCBiZQ0KPiByZWplY3RlZCBieSBCUEYgdmVyaWZpZXIgZHVlIHRvIG1vZGlmaWVkIGNvbnRl
eHQgcG9pbnRlciBkZXJlZmVyZW5jZS4gV2l0aA0KPiBDbGFuZyBwYXRjaCwgc3VjaCBjb250ZXh0
IGFjY2Vzc2VzIGFyZSBib3RoIHJlbG9jYXRhYmxlIGFuZCBoYXZlIGEgZml4ZWQNCj4gb2Zmc2V0
IGZyb20gdGhlIHBvaW50IG9mIHZpZXcgb2YgQlBGIHZlcmlmaWVyLg0KPiANCj4gICAgWzBdIGh0
dHBzOi8vcmV2aWV3cy5sbHZtLm9yZy9ENzE3OTANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJp
aSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAgIHRvb2xzL2xpYi9icGYvbGli
YnBmLmMgfCAzMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGlu
ZGV4IDk1NzZhOTBjNWExYy4uMmRiYzIyMDRhMDJjIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIv
YnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTE4LDYg
KzE4LDcgQEANCj4gICAjaW5jbHVkZSA8c3RkYXJnLmg+DQo+ICAgI2luY2x1ZGUgPGxpYmdlbi5o
Pg0KPiAgICNpbmNsdWRlIDxpbnR0eXBlcy5oPg0KPiArI2luY2x1ZGUgPGxpbWl0cy5oPg0KPiAg
ICNpbmNsdWRlIDxzdHJpbmcuaD4NCj4gICAjaW5jbHVkZSA8dW5pc3RkLmg+DQo+ICAgI2luY2x1
ZGUgPGVuZGlhbi5oPg0KPiBAQCAtMzgxMCwxMSArMzgxMSwxMyBAQCBzdGF0aWMgaW50IGJwZl9j
b3JlX3JlbG9jX2luc24oc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPiAgIAlpbnNuID0gJnBy
b2ctPmluc25zW2luc25faWR4XTsNCj4gICAJY2xhc3MgPSBCUEZfQ0xBU1MoaW5zbi0+Y29kZSk7
DQo+ICAgDQo+IC0JaWYgKGNsYXNzID09IEJQRl9BTFUgfHwgY2xhc3MgPT0gQlBGX0FMVTY0KSB7
DQo+ICsJc3dpdGNoIChjbGFzcykgew0KPiArCWNhc2UgQlBGX0FMVToNCj4gKwljYXNlIEJQRl9B
TFU2NDoNCj4gICAJCWlmIChCUEZfU1JDKGluc24tPmNvZGUpICE9IEJQRl9LKQ0KPiAgIAkJCXJl
dHVybiAtRUlOVkFMOw0KPiAgIAkJaWYgKCFmYWlsZWQgJiYgdmFsaWRhdGUgJiYgaW5zbi0+aW1t
ICE9IG9yaWdfdmFsKSB7DQo+IC0JCQlwcl93YXJuKCJwcm9nICclcyc6IHVuZXhwZWN0ZWQgaW5z
biAjJWQgdmFsdWU6IGdvdCAldSwgZXhwICV1IC0+ICV1XG4iLA0KPiArCQkJcHJfd2FybigicHJv
ZyAnJXMnOiB1bmV4cGVjdGVkIGluc24gIyVkIChBTFUvQUxVNjQpIHZhbHVlOiBnb3QgJXUsIGV4
cCAldSAtPiAldVxuIiwNCj4gICAJCQkJYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSwg
aW5zbl9pZHgsDQo+ICAgCQkJCWluc24tPmltbSwgb3JpZ192YWwsIG5ld192YWwpOw0KPiAgIAkJ
CXJldHVybiAtRUlOVkFMOw0KPiBAQCAtMzgyNCw3ICszODI3LDMwIEBAIHN0YXRpYyBpbnQgYnBm
X2NvcmVfcmVsb2NfaW5zbihzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICAgCQlwcl9kZWJ1
ZygicHJvZyAnJXMnOiBwYXRjaGVkIGluc24gIyVkIChBTFUvQUxVNjQpJXMgaW1tICV1IC0+ICV1
XG4iLA0KPiAgIAkJCSBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLCBpbnNuX2lkeCwN
Cj4gICAJCQkgZmFpbGVkID8gIiB3LyBmYWlsZWQgcmVsb2MiIDogIiIsIG9yaWdfdmFsLCBuZXdf
dmFsKTsNCj4gLQl9IGVsc2Ugew0KPiArCQlicmVhazsNCj4gKwljYXNlIEJQRl9MRDoNCg0KTWF5
YmUgd2Ugc2hvdWxkIHJlbW92ZSBCUEZfTEQgaGVyZT8gQlBGX0xEIGlzIHVzZWQgZm9yIGxkX2lt
bTY0LCBsZF9hYnMgDQphbmQgbGRfaW5kLCB3aGVyZSB0aGUgaW5zbi0+b2ZmID0gMCBhbmQgbm90
IHJlYWxseSB1c2VkLg0KDQo+ICsJY2FzZSBCUEZfTERYOg0KPiArCWNhc2UgQlBGX1NUOg0KPiAr
CWNhc2UgQlBGX1NUWDogPiArCQlpZiAoIWZhaWxlZCAmJiB2YWxpZGF0ZSAmJiBpbnNuLT5vZmYg
IT0gb3JpZ192YWwpIHsNCj4gKwkJCXByX3dhcm4oInByb2cgJyVzJzogdW5leHBlY3RlZCBpbnNu
ICMlZCAoTEQvTERYL1NUL1NUWCkgdmFsdWU6IGdvdCAldSwgZXhwICV1IC0+ICV1XG4iLA0KPiAr
CQkJCWJwZl9wcm9ncmFtX190aXRsZShwcm9nLCBmYWxzZSksIGluc25faWR4LA0KPiArCQkJCWlu
c24tPm9mZiwgb3JpZ192YWwsIG5ld192YWwpOw0KPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJ
CX0NCj4gKwkJaWYgKG5ld192YWwgPiBTSFJUX01BWCkgew0KPiArCQkJcHJfd2FybigicHJvZyAn
JXMnOiBpbnNuICMlZCAoTEQvTERYL1NUL1NUWCkgdmFsdWUgdG9vIGJpZzogJXVcbiIsDQo+ICsJ
CQkJYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSwgaW5zbl9pZHgsDQo+ICsJCQkJbmV3
X3ZhbCk7DQo+ICsJCQlyZXR1cm4gLUVSQU5HRTsNCj4gKwkJfQ0KPiArCQlvcmlnX3ZhbCA9IGlu
c24tPm9mZjsNCj4gKwkJaW5zbi0+b2ZmID0gbmV3X3ZhbDsNCj4gKwkJcHJfZGVidWcoInByb2cg
JyVzJzogcGF0Y2hlZCBpbnNuICMlZCAoTEQvTERYL1NUL1NUWCklcyBvZmYgJXUgLT4gJXVcbiIs
DQo+ICsJCQkgYnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSwgaW5zbl9pZHgsDQo+ICsJ
CQkgZmFpbGVkID8gIiB3LyBmYWlsZWQgcmVsb2MiIDogIiIsIG9yaWdfdmFsLCBuZXdfdmFsKTsN
Cj4gKwkJYnJlYWs7DQo+ICsJZGVmYXVsdDoNCj4gICAJCXByX3dhcm4oInByb2cgJyVzJzogdHJ5
aW5nIHRvIHJlbG9jYXRlIHVucmVjb2duaXplZCBpbnNuICMlZCwgY29kZToleCwgc3JjOiV4LCBk
c3Q6JXgsIG9mZjoleCwgaW1tOiV4XG4iLA0KPiAgIAkJCWJwZl9wcm9ncmFtX190aXRsZShwcm9n
LCBmYWxzZSksDQo+ICAgCQkJaW5zbl9pZHgsIGluc24tPmNvZGUsIGluc24tPnNyY19yZWcsIGlu
c24tPmRzdF9yZWcsDQo+IA0K
