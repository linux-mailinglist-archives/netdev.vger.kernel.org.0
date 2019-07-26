Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A943A77335
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGZVGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:06:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29640 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfGZVGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:06:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QL19e6019251;
        Fri, 26 Jul 2019 14:05:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vsolyvoBI8mjxwDcvo6DRD3M8cd2EnRVhLjcwMijc24=;
 b=HKJ93EL+V6u7+6481FGgvkyZ4oQJtidRjiGGi8voytVykXsUGeqGxfqFcuQ0QzGzRwIY
 n9CMNkFp9OuNz/oTCO2TaDZ0HlI7HOOaYDnQilv/Rchmt30RgMZ0dBaCc8u5nd6DypH3
 9Tn/3UADgT75wbqNc830Gpxk2L4Yw6ANzEg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u04m61353-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jul 2019 14:05:47 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 14:05:25 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 14:05:24 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jul 2019 14:05:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKe0hL6rf2jZuQ19Pue6zkpqSpfOWn9g83Hq7RNvOBvpwfzbcJ1UWO5v84ylvjmx6ohZrRZ9XagIaWCqs4d+7SDbfiVH0VOcH0QoV1XqBOAvoi8L5rFG26fugBj/E8jjkR3T7dmWKKH2LPMz8rFI33WECO1G/Avz3QxCqD8KaIT5t/CHAgQtLHtEoDAqd2hfRWnQIE59J7abUGvovR3Vr5Ag5yQFHuvLfKhhnQBvtMwftYJxug+Mru5thBPIWel5ZpjLDQ0FhbGTtbUyhMZ7pH9pGekAexcP4n2T3DtksVv3b7uZzzDlMWMrUyCx4rwBVq7x3uBAQnkL8L8Rsh8Ccw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsolyvoBI8mjxwDcvo6DRD3M8cd2EnRVhLjcwMijc24=;
 b=D2+BtgumJ6pWHpJGSxaC5C0jzW3qPDYmN3TRe9A/l43kpdIRyGOPbUlcZo2T82gRZh+dJNSgh0Zqh+9vHKCcw7YDgJ46p6xsV6MNrWyoehyf55pGgIjMFhKP0rsrtksYPGYYYP531fuRwQ2CQUnt8avwOu98tcjGH9pJORkLML0QyWq3JuYy51eXpqjiJrXU66NOAVdhBY2ssjgeSLf3uIDskOcJyvdY6bJQb/TCQ6gb4lf8VSToFJUhZhw3Reyvv6E3jZ7Ouh7yRn6scpe8Rru17s/JNc+Rjf8wiDXO+7oO6kgcrzXvHqi4pPC6yqgrkrrVGUKPkWmxIlqQQH41aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsolyvoBI8mjxwDcvo6DRD3M8cd2EnRVhLjcwMijc24=;
 b=cB6/yvlOO8GuzSUbzR1MBed6+yHvyESdh22CvBvIXfVcjM0MZbT3isVqg/DZYk3SInZJOprNJ5UOtDjCIZ7TS/J63G2vPRyaSvwaEz3b12AZk+lWEiCOd7tI23NoiEVuOcmB3xv67dVehdY+TcOQWiB9cAsv0ymsvivtWav8sGw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2933.namprd15.prod.outlook.com (20.178.237.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 21:05:24 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 21:05:24 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Topic: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Index: AQHVQ4xS9PP3XA7/nkqulb+RBeHJq6bcleMAgADHHgCAAAeRgA==
Date:   Fri, 26 Jul 2019 21:05:23 +0000
Message-ID: <5bb726c5-5f50-ba44-9d78-e57a92a58266@fb.com>
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
 <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
In-Reply-To: <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:104:1::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::81eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f06e40eb-09b4-48de-034e-08d7120cf9cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2933;
x-ms-traffictypediagnostic: BYAPR15MB2933:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB2933E0FED5AC510939CC3EE8D3C00@BYAPR15MB2933.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(366004)(376002)(45914002)(189003)(199004)(31014005)(71200400001)(25786009)(14454004)(6486002)(5024004)(14444005)(256004)(2616005)(446003)(11346002)(476003)(66446008)(316002)(229853002)(6306002)(31696002)(1361003)(54906003)(71190400001)(46003)(66946007)(66556008)(4326008)(53936002)(52116002)(68736007)(6512007)(5660300002)(86362001)(66476007)(478600001)(45080400002)(6436002)(5640700003)(2501003)(6916009)(81156014)(81166006)(7736002)(2351001)(305945005)(102836004)(6246003)(6116002)(186003)(966005)(2906002)(386003)(53546011)(6506007)(486006)(36756003)(76176011)(8676002)(64756008)(99286004)(8936002)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2933;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6IBv1eubCi6GaQo4BlHdq+pT29XnZ2xRbj4AMs1Uvs5BRhWOIbyPsqnVVYUO8EyBa7f9+Y+m925YUoB0y14Q2Cxocqf4oeZF7EehD7+H0EfdoLCJON+T/a74hRdDlV/Z51cOpThc0VTfDgRTF/RjXMTUJM+i5AzwNAWS4S7FV3P4y87q2CRMV2dRw/DFay/x6hijtbfiRTg6990wySPAUUBeAoM8VWn+Zaw/zMQfKVki4e3Zo/b0NiOUcHTmQVuGkJ6aZM0I51V9JSAP3BsBz02tMoqqmVOsLxDzG/C7fu+/T1RS4RDorBOAxbf5L+prKIiZlnEfvckRUm87+gE4wjKH65KwHrPjtSLby2j8gNfGjYf9ryjWyJfV21YSc+dP1kBra/Vbby1b2w2Xjg+ohhzvbglJSSnPmBWkuGY1hr4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26D73F401881564188E9EE860A2D5022@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f06e40eb-09b4-48de-034e-08d7120cf9cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 21:05:23.8497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2933
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjYvMTkgMTozOCBQTSwgU2VkYXQgRGlsZWsgd3JvdGU6DQo+IEhpIFlvbmdob25n
IFNvbmcsDQo+IA0KPiBPbiBGcmksIEp1bCAyNiwgMjAxOSBhdCA1OjQ1IFBNIFlvbmdob25nIFNv
bmcgPHloc0BmYi5jb20+IHdyb3RlOg0KPj4NCj4+DQo+Pg0KPj4gT24gNy8yNi8xOSAxOjI2IEFN
LCBTZWRhdCBEaWxlayB3cm90ZToNCj4+PiBIaSwNCj4+Pg0KPj4+IEkgaGF2ZSBvcGVuZWQgYSBu
ZXcgaXNzdWUgaW4gdGhlIENsYW5nQnVpbHRMaW51eCBpc3N1ZSB0cmFja2VyLg0KPj4NCj4+IEds
YWQgdG8ga25vdyBjbGFuZyA5IGhhcyBhc20gZ290byBzdXBwb3J0IGFuZCBub3cgSXQgY2FuIGNv
bXBpbGUNCj4+IGtlcm5lbCBhZ2Fpbi4NCj4+DQo+IA0KPiBZdXBwLg0KPiANCj4+Pg0KPj4+IEkg
YW0gc2VlaW5nIGEgcHJvYmxlbSBpbiB0aGUgYXJlYSBicGYvc2VjY29tcCBjYXVzaW5nDQo+Pj4g
c3lzdGVtZC9qb3VybmFsZC91ZGV2ZCBzZXJ2aWNlcyB0byBmYWlsLg0KPj4+DQo+Pj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDMgMjAxOV0gc3lzdGVtZFs0NTNdOiBzeXN0ZW1kLXVkZXZkLnNlcnZpY2U6
IEZhaWxlZA0KPj4+IHRvIGNvbm5lY3Qgc3Rkb3V0IHRvIHRoZSBqb3VybmFsIHNvY2tldCwgaWdu
b3Jpbmc6IENvbm5lY3Rpb24gcmVmdXNlZA0KPj4+DQo+Pj4gVGhpcyBoYXBwZW5zIHdoZW4gSSB1
c2UgdGhlIChMTFZNKSBMTEQgbGQubGxkLTkgbGlua2VyIGJ1dCBub3Qgd2l0aA0KPj4+IEJGRCBs
aW5rZXIgbGQuYmZkIG9uIERlYmlhbi9idXN0ZXIgQU1ENjQuDQo+Pj4gSW4gYm90aCBjYXNlcyBJ
IHVzZSBjbGFuZy05IChwcmVyZWxlYXNlKS4NCj4+DQo+PiBMb29rcyBsaWtlIGl0IGlzIGEgbGxk
IGJ1Zy4NCj4+DQo+PiBJIHNlZSB0aGUgc3RhY2sgdHJhY2UgaGFzIF9fYnBmX3Byb2dfcnVuMzIo
KSB3aGljaCBpcyB1c2VkIGJ5DQo+PiBrZXJuZWwgYnBmIGludGVycHJldGVyLiBDb3VsZCB5b3Ug
dHJ5IHRvIGVuYWJsZSBicGYgaml0DQo+PiAgICAgc3lzY3RsIG5ldC5jb3JlLmJwZl9qaXRfZW5h
YmxlID0gMQ0KPj4gSWYgdGhpcyBwYXNzZWQsIGl0IHdpbGwgcHJvdmUgaXQgaXMgaW50ZXJwcmV0
ZXIgcmVsYXRlZC4NCj4+DQo+IA0KPiBBZnRlci4uLg0KPiANCj4gc3lzY3RsIC13IG5ldC5jb3Jl
LmJwZl9qaXRfZW5hYmxlPTENCj4gDQo+IEkgY2FuIHN0YXJ0IGFsbCBmYWlsZWQgc3lzdGVtZCBz
ZXJ2aWNlcy4NCj4gDQo+IHN5c3RlbWQtam91cm5hbGQuc2VydmljZQ0KPiBzeXN0ZW1kLXVkZXZk
LnNlcnZpY2UNCj4gaGF2ZWdlZC5zZXJ2aWNlDQo+IA0KPiBUaGlzIGlzIGluIG1haW50ZW5hbmNl
IG1vZGUuDQo+IA0KPiBXaGF0IGlzIG5leHQ6IERvIHNldCBhIHBlcm1hbmVudCBzeXNjdGwgc2V0
dGluZyBmb3IgbmV0LmNvcmUuYnBmX2ppdF9lbmFibGU/DQoNCkkgZG8gdGhpbmsgeW91IHNob3Vs
ZCBzZXQgbmV0LmNvcmUuYnBmX2ppdF9lbmFibGUgYnkgZGVmYXVsdC4gVGhpcyBpcyANCm1vcmUg
dGVzdGVkIGluIHByb2R1Y3Rpb24gYW5kIHlvdSBnZXQgYmV0dGVyIHBlcmZvcm1hbmNlIGFzIHdl
bGwuDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IC0gU2VkYXQgLQ0KPiANCj4+Pg0KPj4+IEJhc2UgZm9y
IHRlc3Rpbmc6IG5leHQtMjAxOTA3MjMuDQo+Pj4NCj4+PiBUaGUgY2FsbC10cmFjZSBsb29rcyBs
aWtlIHRoaXM6DQo+Pj4NCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBCVUc6IHVuYWJs
ZSB0byBoYW5kbGUgcGFnZSBmYXVsdCBmb3INCj4+PiBhZGRyZXNzOiBmZmZmZmZmZjg1NDAzMzcw
DQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gI1BGOiBzdXBlcnZpc29yIHJlYWQgYWNj
ZXNzIGluIGtlcm5lbCBtb2RlDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gI1BGOiBl
cnJvcl9jb2RlKDB4MDAwMCkgLSBub3QtcHJlc2VudCBwYWdlDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6
MDg6NDIgMjAxOV0gUEdEIDc2MjBlMDY3IFA0RCA3NjIwZTA2NyBQVUQgNzYyMGYwNjMgUE1EDQo+
Pj4gNDRmZTg1MDYzIFBURSA4MDBmZmZmZjhhM2ZjMDYyDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6
NDIgMjAxOV0gT29wczogMDAwMCBbIzFdIFNNUCBQVEkNCj4+PiBbRnJpIEp1bCAyNiAwODowODo0
MiAyMDE5XSBDUFU6IDIgUElEOiA0MTcgQ29tbTogKGpvdXJuYWxkKSBOb3QNCj4+PiB0YWludGVk
IDUuMy4wLXJjMS01LWFtZDY0LWNibC1hc21nb3RvICM1fmJ1c3RlcitkaWxla3MxDQo+Pj4gW0Zy
aSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gSGFyZHdhcmUgbmFtZTogTEVOT1ZPDQo+Pj4gMjBIRENU
TzFXVy8yMEhEQ1RPMVdXLCBCSU9TIE4xUUVUODNXICgxLjU4ICkgMDQvMTgvMjAxOQ0KPj4+IFtG
cmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFJJUDogMDAxMDpfX19icGZfcHJvZ19ydW4rMHg0MC8w
eDE0ZjANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBDb2RlOiBmMyBlYiAyNCA0OCA4
MyBmOCAzOCAwZiA4NCBhOSAwYyAwMA0KPj4+IDAwIDQ4IDgzIGY4IDM5IDBmIDg1IDhhIDE0IDAw
IDAwIDBmIDFmIDAwIDQ4IDBmIGJmIDQzIDAyIDQ4IDhkIDFjIGMzDQo+Pj4gNDggODMgYzMgMDgg
MGYgYjYgMzMgPDQ4PiA4YiAwNCBmNSAxMCAyZSA0MCA4NSA0OCA4MyBmOCAzYiA3ZiA2MiA0OCA4
Mw0KPj4+IGY4IDFlIDBmIDhmIGM4IDAwDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0g
UlNQOiAwMDE4OmZmZmY5OTJlYzAyOGZjYjggRUZMQUdTOiAwMDAxMDI0Ng0KPj4+IFtGcmkgSnVs
IDI2IDA4OjA4OjQyIDIwMTldIFJBWDogZmZmZjk5MmVjMDI4ZmQ2MCBSQlg6IGZmZmY5OTJlYzAw
ZTkwMzgNCj4+PiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDINCj4+PiBbRnJpIEp1bCAyNiAwODowODo0
MiAyMDE5XSBSRFg6IGZmZmY5OTJlYzAyOGZkNDAgUlNJOiAwMDAwMDAwMDAwMDAwMGFjDQo+Pj4g
UkRJOiBmZmZmOTkyZWMwMjhmY2UwDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUkJQ
OiBmZmZmOTkyZWMwMjhmY2QwIFIwODogMDAwMDAwMDAwMDAwMDAwMA0KPj4+IFIwOTogZmZmZjk5
MmVjMDI4ZmY1OA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFIxMDogMDAwMDAwMDAw
MDAwMDAwMCBSMTE6IGZmZmZmZmZmODQ5YjgyMTANCj4+PiBSMTI6IDAwMDAwMDAwN2ZmZjAwMDAN
Cj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSMTM6IGZmZmY5OTJlYzAyOGZlYjggUjE0
OiAwMDAwMDAwMDAwMDAwMDAwDQo+Pj4gUjE1OiBmZmZmOTkyZWMwMjhmY2UwDQo+Pj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDIgMjAxOV0gRlM6ICAwMDAwN2Y1ZDIwZjFkOTQwKDAwMDApDQo+Pj4gR1M6
ZmZmZjhiYTNkMjUwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+Pj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDIgMjAxOV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAw
MDAwMDA4MDA1MDAzMw0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIENSMjogZmZmZmZm
ZmY4NTQwMzM3MCBDUjM6IDAwMDAwMDA0NDViM2UwMDENCj4+PiBDUjQ6IDAwMDAwMDAwMDAzNjA2
ZTANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBDYWxsIFRyYWNlOg0KPj4+IFtGcmkg
SnVsIDI2IDA4OjA4OjQyIDIwMTldICBfX2JwZl9wcm9nX3J1bjMyKzB4NDQvMHg3MA0KPj4+IFtG
cmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldICA/IGZsdXNoX3RsYl9mdW5jX2NvbW1vbisweGQ4LzB4
MjMwDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gID8gbWVtX2Nncm91cF9jb21taXRf
Y2hhcmdlKzB4OGMvMHgxMjANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSAgPyB3cF9w
YWdlX2NvcHkrMHg0NjQvMHg3YTANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSAgc2Vj
Y29tcF9ydW5fZmlsdGVycysweDU0LzB4MTEwDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAx
OV0gIF9fc2VjY29tcF9maWx0ZXIrMHhmNy8weDZlMA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQy
IDIwMTldICA/IGRvX3dwX3BhZ2UrMHgzMmIvMHg1ZDANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0
MiAyMDE5XSAgPyBoYW5kbGVfbW1fZmF1bHQrMHg5MGQvMHhiZjANCj4+PiBbRnJpIEp1bCAyNiAw
ODowODo0MiAyMDE5XSAgc3lzY2FsbF90cmFjZV9lbnRlcisweDE4Mi8weDI5MA0KPj4+IFtGcmkg
SnVsIDI2IDA4OjA4OjQyIDIwMTldICBkb19zeXNjYWxsXzY0KzB4MzAvMHg5MA0KPj4+IFtGcmkg
SnVsIDI2IDA4OjA4OjQyIDIwMTldICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0
NC8weGE5DQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUklQOiAwMDMzOjB4N2Y1ZDIy
MGQ3ZjU5DQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gQ29kZTogMDAgYzMgNjYgMmUg
MGYgMWYgODQgMDAgMDAgMDAgMDAgMDANCj4+PiAwZiAxZiA0NCAwMCAwMCA0OCA4OSBmOCA0OCA4
OSBmNyA0OCA4OSBkNiA0OCA4OSBjYSA0ZCA4OSBjMiA0ZCA4OSBjOA0KPj4+IDRjIDhiIDRjIDI0
IDA4IDBmIDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgMDcgNmYgMGMg
MDANCj4+PiBmNyBkOCA2NCA4OSAwMSA0OA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTld
IFJTUDogMDAyYjowMDAwN2ZmZDExMzMyYjQ4IEVGTEFHUzogMDAwMDAyNDYNCj4+PiBPUklHX1JB
WDogMDAwMDAwMDAwMDAwMDEzZA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFJBWDog
ZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA1NWJmOGFiMzQwMTANCj4+PiBSQ1g6IDAwMDA3ZjVk
MjIwZDdmNTkNCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSRFg6IDAwMDA1NWJmOGFi
MzQwMTAgUlNJOiAwMDAwMDAwMDAwMDAwMDAwDQo+Pj4gUkRJOiAwMDAwMDAwMDAwMDAwMDAxDQo+
Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUkJQOiAwMDAwNTViZjhhYjk3ZmIwIFIwODog
MDAwMDU1YmY4YWJiZTE4MA0KPj4+IFIwOTogMDAwMDAwMDBjMDAwMDAzZQ0KPj4+IFtGcmkgSnVs
IDI2IDA4OjA4OjQyIDIwMTldIFIxMDogMDAwMDU1YmY4YWJiZTFlMCBSMTE6IDAwMDAwMDAwMDAw
MDAyNDYNCj4+PiBSMTI6IDAwMDA3ZmZkMTEzMzJiYTANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0
MiAyMDE5XSBSMTM6IDAwMDA3ZmZkMTEzMzJiOTggUjE0OiAwMDAwN2Y1ZDIxZjA4N2Y4DQo+Pj4g
UjE1OiAwMDAwMDAwMDAwMDAwMDJjDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gTW9k
dWxlcyBsaW5rZWQgaW46IGkyY19kZXYgcGFycG9ydF9wYw0KPj4+IHN1bnJwYyBwcGRldiBscCBw
YXJwb3J0IGVmaXZhcmZzIGlwX3RhYmxlcyB4X3RhYmxlcyBhdXRvZnM0IGV4dDQNCj4+PiBjcmMz
MmNfZ2VuZXJpYyBtYmNhY2hlIGNyYzE2IGpiZDIgYnRyZnMgenN0ZF9kZWNvbXByZXNzIHpzdGRf
Y29tcHJlc3MNCj4+PiBhbGdpZl9za2NpcGhlciBhZl9hbGcgc2RfbW9kIGRtX2NyeXB0IGRtX21v
ZCByYWlkMTAgcmFpZDQ1Ng0KPj4+IGFzeW5jX3JhaWQ2X3JlY292IGFzeW5jX21lbWNweSBhc3lu
Y19wcSBhc3luY194b3IgYXN5bmNfdHggeG9yDQo+Pj4gcmFpZDZfcHEgbGliY3JjMzJjIHJhaWQx
IHVhcyByYWlkMCB1c2Jfc3RvcmFnZSBtdWx0aXBhdGggbGluZWFyDQo+Pj4gc2NzaV9tb2QgbWRf
bW9kIGhpZF9jaGVycnkgaGlkX2dlbmVyaWMgdXNiaGlkIGhpZCBjcmN0MTBkaWZfcGNsbXVsDQo+
Pj4gY3JjMzJfcGNsbXVsIGNyYzMyY19pbnRlbCBnaGFzaF9jbG11bG5pX2ludGVsIGFlc25pX2lu
dGVsIGFlc194ODZfNjQNCj4+PiBpOTE1IGdsdWVfaGVscGVyIGNyeXB0b19zaW1kIG52bWUgaTJj
X2FsZ29fYml0IGNyeXB0ZCBwc21vdXNlIHhoY2lfcGNpDQo+Pj4gZHJtX2ttc19oZWxwZXIgZTEw
MDBlIGkyY19pODAxIHhoY2lfaGNkIGludGVsX2xwc3NfcGNpIG52bWVfY29yZQ0KPj4+IGludGVs
X2xwc3MgZHJtIHVzYmNvcmUgdGhlcm1hbCB3bWkgdmlkZW8gYnV0dG9uDQo+Pj4gW0ZyaSBKdWwg
MjYgMDg6MDg6NDIgMjAxOV0gQ1IyOiBmZmZmZmZmZjg1NDAzMzcwDQo+Pj4gW0ZyaSBKdWwgMjYg
MDg6MDg6NDIgMjAxOV0gLS0tWyBlbmQgdHJhY2UgODY3YjM1YzdkNmM2NzA1YSBdLS0tDQo+Pj4g
W0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUklQOiAwMDEwOl9fX2JwZl9wcm9nX3J1bisweDQw
LzB4MTRmMA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIENvZGU6IGYzIGViIDI0IDQ4
IDgzIGY4IDM4IDBmIDg0IGE5IDBjIDAwDQo+Pj4gMDAgNDggODMgZjggMzkgMGYgODUgOGEgMTQg
MDAgMDAgMGYgMWYgMDAgNDggMGYgYmYgNDMgMDIgNDggOGQgMWMgYzMNCj4+PiA0OCA4MyBjMyAw
OCAwZiBiNiAzMyA8NDg+IDhiIDA0IGY1IDEwIDJlIDQwIDg1IDQ4IDgzIGY4IDNiIDdmIDYyIDQ4
IDgzDQo+Pj4gZjggMWUgMGYgOGYgYzggMDANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5
XSBSU1A6IDAwMTg6ZmZmZjk5MmVjMDI4ZmNiOCBFRkxBR1M6IDAwMDEwMjQ2DQo+Pj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDIgMjAxOV0gUkFYOiBmZmZmOTkyZWMwMjhmZDYwIFJCWDogZmZmZjk5MmVj
MDBlOTAzOA0KPj4+IFJDWDogMDAwMDAwMDAwMDAwMDAwMg0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4
OjQyIDIwMTldIFJEWDogZmZmZjk5MmVjMDI4ZmQ0MCBSU0k6IDAwMDAwMDAwMDAwMDAwYWMNCj4+
PiBSREk6IGZmZmY5OTJlYzAyOGZjZTANCj4+PiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBS
QlA6IGZmZmY5OTJlYzAyOGZjZDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAwDQo+Pj4gUjA5OiBmZmZm
OTkyZWMwMjhmZjU4DQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUjEwOiAwMDAwMDAw
MDAwMDAwMDAwIFIxMTogZmZmZmZmZmY4NDliODIxMA0KPj4+IFIxMjogMDAwMDAwMDA3ZmZmMDAw
MA0KPj4+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFIxMzogZmZmZjk5MmVjMDI4ZmViOCBS
MTQ6IDAwMDAwMDAwMDAwMDAwMDANCj4+PiBSMTU6IGZmZmY5OTJlYzAyOGZjZTANCj4+PiBbRnJp
IEp1bCAyNiAwODowODo0MiAyMDE5XSBGUzogIDAwMDA3ZjVkMjBmMWQ5NDAoMDAwMCkNCj4+PiBH
UzpmZmZmOGJhM2QyNTAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCj4+PiBbRnJp
IEp1bCAyNiAwODowODo0MiAyMDE5XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAw
MDAwMDAwMDgwMDUwMDMzDQo+Pj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gQ1IyOiBmZmZm
ZmZmZjg1NDAzMzcwIENSMzogMDAwMDAwMDQ0NWIzZTAwMQ0KPj4+IENSNDogMDAwMDAwMDAwMDM2
MDZlMA0KPj4+DQo+Pj4gTW9yZSBkZXRhaWxzIGluIFsxXSBhbmQgd2hhdCBJIHRyaWVkIChmb3Ig
ZXhhbXBsZSBDT05GSUdfU0VDQ09NUD1uKQ0KPj4+DQo+Pj4gSSBoYXZlIG5vIGNsdWUgYWJvdXQg
QlBGIG9yIFNFQ0NPTVAuDQo+Pj4NCj4+PiBDYW4geW91IGNvbW1lbnQgb24gdGhpcz8NCj4+Pg0K
Pj4+IElmIHRoaXMgdG91Y2hlcyBCUEY6IENhbiB5b3UgZ2l2ZSBtZSBzb21lIGhpbnRzIGFuZCBp
bnN0cnVjdGlvbnMgaW4gZGVidWdnaW5nPw0KPj4+DQo+Pj4gTXkga2VybmVsLWNvbmZpZyBhbmQg
ZG1lc2ctbG9nIGFyZSBhdHRhY2hlZC4NCj4+Pg0KPj4+IFRoYW5rcy4NCj4+Pg0KPj4+IFJlZ2Fy
ZHMsDQo+Pj4gLSBTZWRhdCAtDQo+Pj4NCj4+PiBbMV0gaHR0cHM6Ly9naXRodWIuY29tL0NsYW5n
QnVpbHRMaW51eC9saW51eC9pc3N1ZXMvNjE5DQo+Pj4NCg==
