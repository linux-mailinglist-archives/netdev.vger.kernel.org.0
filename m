Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C25129B08
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 22:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLWVWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 16:22:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50190 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbfLWVWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 16:22:16 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNLLiGT031718;
        Mon, 23 Dec 2019 13:22:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xOYxTIJOlC0kEgIrQRUcSFC7WTOU7MtE1mgBhU3odhM=;
 b=KhtCoyQFD7EA5YrkDFFk7rNELp6yiAMRMYSgPjmtaUdkOsdlypuPAS8pnz4L4wbeCoRw
 s0BbeDbS4d1SIxlP2na9YoPQwPPWwgeRtYJyxAGI0Dtmzs6emiSlAAfBwDLPHDo3eqTg
 9COD+Dtd0ok3HKvzKvoN4fZqnytB0e403X8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x1hswh1qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 13:22:01 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 13:21:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PW+TJEZkwUC9dWlVW2sPl3YFXL/XU+rESXGb3KlGxSRTs7FDXz18RXP1C7aaN7VwsLsOM3LKTP2JpQ1jOm+0/UFcvP91JVN4FclEo4vTAN5FAdtNtKG6weU4rKkY9l8Pu9Kb0B7Q+CByM7VE5aYikDzpUo8jb/3oYDRZkhyaYBxKYFm8Ai3UagoTDMdeno3OhVzNr+xPT+LqTCwTbDiBgSGpcU45sFpqwGJl0DkI+XMOQvvdMH7I1AtuZ9wOBeTcbf5vSeqkHnNR2+QP8P4qJrUZ5Yp2VUZSjsosUMhzDH8Y3sPRZpRLsmoIgTlLjh1ih6OxcmrNwa4/td+lJKd11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOYxTIJOlC0kEgIrQRUcSFC7WTOU7MtE1mgBhU3odhM=;
 b=YLr/4iKpr1jloXW3Fvz0rLa9HBUDFaejMIuFPD2m5k0Z60KjuYApcK0c8E5nnVIJ/dhiWyNcTd+4NcJm44en2eY7hCDCkDw2fr0w+0dJaV1oHvg6X9Bk3iTlZQn7uNhLTScJFvMdBdMFJrJgLjpUAV7AxLWTbTd1Uut7mJ3/7JopAUI9nyRxqqn9tomeiUdfoOHuuUbGIqeJ1RODBASl3o2GIRmhVnRzSPBxCWMIB3KP0j93SXQFjbNBdInqUhIrJIzo/h6F0OPF/7qGhgSSBuyf0pwwYufkqiScoVNc699eNpfipmzd1nRkp8fav/lfdzS23RB5s5YQYkd/njxs6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOYxTIJOlC0kEgIrQRUcSFC7WTOU7MtE1mgBhU3odhM=;
 b=cPJ1zyLicIUvHvNc+GZ4DPIMke9GrbStIsmq281x7nLVtxHA1jV2tp0XLXaBKaiubcnrPN2QQqRFxUv3piCXeGZPl+X24hyTjSbq2GgNNfVQnx7NRTUg5NA14HTZkdy1qiQyXPVHEhGIbq2L6K9raUVMTJ2pJIuwQhThVgz8H8Q=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1147.namprd15.prod.outlook.com (10.173.214.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 21:21:58 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 21:21:58 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::4a23) by CO2PR18CA0050.namprd18.prod.outlook.com (2603:10b6:104:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 21:21:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Topic: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Index: AQHVt8eMPrh8mmnRe0KFFgYnEVuYFqfIKSMAgAAVToA=
Date:   Mon, 23 Dec 2019 21:21:58 +0000
Message-ID: <0ce336dc-203c-f2f0-a877-24360d02452d@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062604.1182843-1-kafai@fb.com>
 <CAEf4Bzam8yp9ciDDY0jye+zE1jM-sbe1+LSjby9ChRvWbeXmbw@mail.gmail.com>
In-Reply-To: <CAEf4Bzam8yp9ciDDY0jye+zE1jM-sbe1+LSjby9ChRvWbeXmbw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:104:2::18) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::4a23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8c1ce9f-610a-4b9f-aee8-08d787ee2483
x-ms-traffictypediagnostic: DM5PR15MB1147:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1147C8203B940EC9D7866954D32E0@DM5PR15MB1147.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(66946007)(16526019)(36756003)(64756008)(66446008)(66476007)(66556008)(186003)(6512007)(31686004)(110136005)(54906003)(81156014)(53546011)(6506007)(81166006)(5660300002)(316002)(6486002)(71200400001)(52116002)(4326008)(8936002)(86362001)(2616005)(8676002)(2906002)(478600001)(31696002)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1147;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdJ+8WMFB3fK9xwNdaubFHWt8y72UYvsq7U3trkv6XFdk8zljbNeoQTDPxMA6biVp4QyRN14ebrc+jV4RHOXirtPZaZoLeresSqNg9KumE+Lo0qGiBz3dQA/4yT4M3J1eT2GdqE7SvgGJXZ9eUhIz2yJaHsqbb6hkMeQZW0N8dHxZmWqRMY5SB85oOV6aruXTEC4Tn/NDoOiPLS8W6d1xt6ejJGhvSp7OqmKhojI2AdBGgm926Y9CyH5WOBLLHszxcwaSE0omfGihLYPc2OecoLUeZ93G+HvT6A9mclZNuhDcYWWi3WxkeG9A48tHLbAhuzUi3VM25S3+GhxUTaS729Lm4xeR2iAnnLOLyVUR3kSF3aEUD+lvlaI8sx2BnVOq7kRwKySJr4K+vq1CLta1GfeFSQrTZjIdSk4smBX9+kL+EHA173ctHalMLaldCKy
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A38192B1BFD414F8F0B4BB69838891B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c1ce9f-610a-4b9f-aee8-08d787ee2483
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 21:21:58.2779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pra8MSAVyjh0ZWZxej25/0jd8GJJWY2BINSRpKUVFKiRK9Qu+NEIF9IVYuxQGDOo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1147
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_09:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIzLzE5IDEyOjA1IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIEZy
aSwgRGVjIDIwLCAyMDE5IGF0IDEwOjI2IFBNIE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNv
bT4gd3JvdGU6DQo+Pg0KPj4gVGhpcyBwYXRjaCBhbGxvd3MgYml0ZmllbGQgYWNjZXNzIGFzIGEg
c2NhbGFyLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZi
LmNvbT4NCj4+IC0tLQ0KPj4gICBrZXJuZWwvYnBmL2J0Zi5jIHwgMTAgKysrKysrLS0tLQ0KPj4g
ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2J0Zi5jIGIva2VybmVsL2JwZi9idGYuYw0KPj4gaW5k
ZXggNmU2NTI2NDM4NDliLi5kYTczYjYzYWNmYzUgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwvYnBm
L2J0Zi5jDQo+PiArKysgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+PiBAQCAtMzc0NCwxMCArMzc0NCw2
IEBAIGludCBidGZfc3RydWN0X2FjY2VzcyhzdHJ1Y3QgYnBmX3ZlcmlmaWVyX2xvZyAqbG9nLA0K
Pj4gICAgICAgICAgfQ0KPj4NCj4+ICAgICAgICAgIGZvcl9lYWNoX21lbWJlcihpLCB0LCBtZW1i
ZXIpIHsNCj4+IC0gICAgICAgICAgICAgICBpZiAoYnRmX21lbWJlcl9iaXRmaWVsZF9zaXplKHQs
IG1lbWJlcikpDQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAvKiBiaXRmaWVsZHMgYXJlIG5v
dCBzdXBwb3J0ZWQgeWV0ICovDQo+PiAtICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsN
Cj4+IC0NCj4+ICAgICAgICAgICAgICAgICAgLyogb2Zmc2V0IG9mIHRoZSBmaWVsZCBpbiBieXRl
cyAqLw0KPj4gICAgICAgICAgICAgICAgICBtb2ZmID0gYnRmX21lbWJlcl9iaXRfb2Zmc2V0KHQs
IG1lbWJlcikgLyA4Ow0KPj4gICAgICAgICAgICAgICAgICBpZiAob2ZmICsgc2l6ZSA8PSBtb2Zm
KQ0KPj4gQEAgLTM3NTcsNiArMzc1MywxMiBAQCBpbnQgYnRmX3N0cnVjdF9hY2Nlc3Moc3RydWN0
IGJwZl92ZXJpZmllcl9sb2cgKmxvZywNCj4+ICAgICAgICAgICAgICAgICAgaWYgKG9mZiA8IG1v
ZmYpDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+Pg0KPj4gKyAgICAg
ICAgICAgICAgIGlmIChidGZfbWVtYmVyX2JpdGZpZWxkX3NpemUodCwgbWVtYmVyKSkgew0KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgaWYgKG9mZiA9PSBtb2ZmICYmIG9mZiArIHNpemUgPD0g
dC0+c2l6ZSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIFNDQUxB
Ul9WQUxVRTsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPj4gKyAgICAg
ICAgICAgICAgIH0NCj4gDQo+IFNob3VsZG4ndCB0aGlzIGNoZWNrIGJlIGRvbmUgYmVmb3JlIChv
ZmYgPCBtb2ZmKSBhYm92ZT8NCj4gDQo+IEltYWdpbmUgdGhpcyBzaXR1YXRpb246DQo+IA0KPiBz
dHJ1Y3Qgew0KPiAgICBpbnQgOjE2Ow0KPiAgICBpbnQgeDo4Ow0KPiB9Ow0KDQpPaCwgeWVzLCBm
b3Jnb3QgdGhlIGNhc2Ugd2hlcmUgdGhlIGZpcnN0IGJpdGZpZWxkIG1lbWJlciBtYXkgaGF2ZSBu
bw0KbmFtZSwgaW4gd2hpY2ggY2FzZSwgYG9mZmAgd2lsbCBub3QgbWF0Y2ggYW55IGBtb2ZmYC4N
Cg0KYnRmX3N0cnVjdF9hY2Nlc3MgaXMgdXNlZCB0byBjaGVjayB2bWxpbnV4IGJ0ZiB0eXBlcy4g
SSB0aGluayBpbg0Kdm1saW51eCB3ZSBtYXkgbm90IGhhdmUgc3VjaCBzY2VuYXJpb3MuIFNvIHRo
ZSBhYm92ZSBjb2RlIHNob3VsZA0KaGFuZGxlIHZtbGludXggdXNlIGNhc2VzIHByb3Blcmx5Lg0K
DQpCdXQgSSBhZ3JlZSB3aXRoIEFuZHJpaSB0aGF0IHdlIHByb2JhYmx5IHdhbnQgdG8gaGFuZGxl
DQphbm9ueW1vdXMgYml0ZmllbGQgbWVtYmVyICh3aGljaCBpcyBpZ25vcmVkIGluIGRlYnVnaW5m
byBhbmQgQlRGKSBwcm9wZXJseS4NCg0KPiANCj4gQ29tcGlsZXIgd2lsbCBnZW5lcmF0ZSA0LWJ5
dGUgbG9hZCB3aXRoIG9mZnNldCAwLCBhbmQgdGhlbiBiaXQgc2hpZnRzDQo+IHRvIGV4dHJhY3Qg
dGhpcmQgYnl0ZS4gRnJvbSBrZXJuZWwgcGVyc3BlY3RpdmUsIHlvdSdsbCBzZWUgdGhhdCBvZmY9
MCwNCj4gYnV0IG1vZmY9Miwgd2hpY2ggd2lsbCBnZXQgc2tpcHBlZC4NCj4gDQo+IFNvIHRoZXJl
IGFyZSB0d28gcHJvYmxlbXMsIEkgdGhpbms6DQo+IDEuIGlmIG1lbWJlciBpcyBiaXRmaWVsZCwg
c3BlY2lhbCBoYW5kbGUgdGhhdCBiZWZvcmUgKG9mZiA8IG1vZmYpIGNhc2UuDQo+IDIuIG9mZiA9
PSBtb2ZmIGlzIHRvbyBwcmVjaXNlLCBJIHRoaW5rIGl0IHNob3VsZCBiZSBgb2ZmIDw9IG1vZmZg
LCBidXQNCj4gYWxzbyBjaGVjayB0aGF0IGl0IGNvdmVycyBlbnRpcmUgYml0ZmllbGQsIGUuZy46
DQo+IA0KPiAgICAob2ZmICsgc2l6ZSkgKiA4ID49IGJ0Zl9tZW1iZXJfYml0X29mZnNldCh0LCBt
ZW1iZXIpICsNCj4gYnRmX21lbWJlcl9iaXRmaWVsZF9zaXplKHQsIG1lbWJlcikNCj4gDQo+IE1h
a2Ugc2Vuc2Ugb3IgYW0gSSBtaXNzaW5nIGFueXRoaW5nPw0KPiANCj4+ICsNCj4+ICAgICAgICAg
ICAgICAgICAgLyogdHlwZSBvZiB0aGUgZmllbGQgKi8NCj4+ICAgICAgICAgICAgICAgICAgbXR5
cGUgPSBidGZfdHlwZV9ieV9pZChidGZfdm1saW51eCwgbWVtYmVyLT50eXBlKTsNCj4+ICAgICAg
ICAgICAgICAgICAgbW5hbWUgPSBfX2J0Zl9uYW1lX2J5X29mZnNldChidGZfdm1saW51eCwgbWVt
YmVyLT5uYW1lX29mZik7DQo+PiAtLQ0KPj4gMi4xNy4xDQo+Pg0K
