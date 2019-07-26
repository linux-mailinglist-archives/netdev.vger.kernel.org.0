Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662B876E3A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfGZPqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:46:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6132 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbfGZPqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 11:46:08 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QFSO5S029258;
        Fri, 26 Jul 2019 08:45:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RfpiC4CFiFMdN78Z977e8FMhFB3Yrpl6CvPJaYdXncc=;
 b=a/DlCRFWxKWBBRRVJPoQiEdAGY0h+m1XgE5M3EdsgWMxD4bMYxNm1zfnzyDmNFF9y/m2
 a4i0EYGMvk/8gMbwkToZ6QnVwpKanLScNEI/G1v5PVd5z9k3GSSApE4ki1fbIcxOCJUO
 QRrzH7KALu1HmjJWJAIVu0qkTfJhFbYMh9A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u006agxd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jul 2019 08:45:42 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 26 Jul 2019 08:45:41 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jul 2019 08:45:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+k455gaIdyR/sPjky6dC3x6XE22nqxYwFF4ZfHRfSVyuKhXqhfZDrnpo/H/tM+SJDVamAwFdXW65n0wbimxyBG/k4WRGyeH5VT28rFRhXrh0UDoJkwYt8QUqVACwSrz6mXlkNtdzkCwuawGIqHi/0EyoE95L1w+7OTp8VSoYxjHLR/AhGy9AJI7Yt6Si3UPsUMdrgXL8MYEZnGQxrNJe22v/ZZlNIQ2TyjFlmOrGQZHfZ2sR7yDvJN73ZdDKGmCFazbC6l694TcszhU22ocABouvpafZARlwkhNLzzqwQ8q5sVn+ypIrCT47/gwxXN50TMOg/wCfgyLLXAWyX1oOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfpiC4CFiFMdN78Z977e8FMhFB3Yrpl6CvPJaYdXncc=;
 b=YQCVFOLEU1dZA/0KvA8UxPsqWqfGOHdsATs94M8BkIrzZK0xDxmuft6GSaLGh0Wio7Vw4F64YbeQIV7yWwIH8igHdHI7+mmF/pZHDdKsydL4aXrGCJ9/MvSrN/U0eyPM6SInj6b5w955ZqnfLLTpp23xxPtro5hbTcVEEIcdR8AEVgGSIqGni87jMIp38vz7b2Z2BdEiseLpiUe3F41QK9oA4r0b583H5QuQ2WwACmVg0VjZ3A8WN9ZHl/0rIixzCNZQmK6/Ki1q4yMs4dLVCzURSL3FXVonrWaqVYqbsBV+4FwZiL2fv+Ks37M2Jv7B81mvFXMiB1R5Z9kdl93vKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfpiC4CFiFMdN78Z977e8FMhFB3Yrpl6CvPJaYdXncc=;
 b=FEsbmc1J2CP8649G+zeoS0Fuaa2/yQit5xLthvr/kux6jr+hKxzpDNwO0pFPhgPGQ+fxXoVALGdP7rlcDw+9LABG9ijHU7qvUww6GoQp3YDQ8ILg+JEnhLqIp3n9pN/HhDp0iAm/UGcf4DUC7erochpGn9U2nvOUHi+UA7nen+s=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2278.namprd15.prod.outlook.com (52.135.197.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Fri, 26 Jul 2019 15:45:39 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 15:45:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Topic: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Index: AQHVQ4xS9PP3XA7/nkqulb+RBeHJq6bdCzwA
Date:   Fri, 26 Jul 2019 15:45:39 +0000
Message-ID: <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
In-Reply-To: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:300:d4::27) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::81eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b34563ca-e2a5-45cb-c935-08d711e04f06
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2278;
x-ms-traffictypediagnostic: BYAPR15MB2278:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB2278B1A952F7ECEE8DE2E5FDD3C00@BYAPR15MB2278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(396003)(366004)(39860400002)(189003)(199004)(31014005)(45914002)(5024004)(256004)(14444005)(229853002)(6436002)(6306002)(110136005)(6512007)(64756008)(66556008)(66446008)(66476007)(6486002)(54906003)(66946007)(45080400002)(52116002)(2616005)(53936002)(71190400001)(6116002)(31686004)(25786009)(186003)(305945005)(478600001)(7736002)(966005)(4326008)(99286004)(53546011)(6506007)(386003)(486006)(2906002)(2501003)(6246003)(76176011)(36756003)(102836004)(86362001)(31696002)(8676002)(81166006)(5660300002)(81156014)(8936002)(68736007)(11346002)(46003)(316002)(476003)(6636002)(14454004)(446003)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2278;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qGPlquMP3NjyniRB120TlXKBYAvqMjOgtAzVmeHu+3FOX6MT8GmRGv/eZ/urXBt+jPTgzJgj9Di0ini+lVURAgMGhS/hjxfpjAmPX5bTP5AeZ9CF2wZlLpa8hbSIddb/a9OXVDOD+Yc/ek7j197yBx1yHXAYZuV24l5/5hEPjw8UuIb2O1o7a99vE2dExMMFEkbJ/rIuHHMDG8oq7axPfYo8kb4nX4ePvYSRS8nmmg0t2vgnca7N5oi73K5kIummdZ4DPzp/IIb/331l4iHHFr1OjSKfGIBGVqCGGeZbyMnsQ51uqUheARkpZ7Lr9BPgcyMVYQ7HC46SftCvsWVxOCVXp/Jz0rRou2LXmkFszP2ju31hCrVmoynapZBwdYeJRXuLLWq7w+VqZTEolMeN4Z25kKA9sPexhJNtnPPiKJA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90E615333D14124482A9506461F14F3B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b34563ca-e2a5-45cb-c935-08d711e04f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:45:39.5394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjYvMTkgMToyNiBBTSwgU2VkYXQgRGlsZWsgd3JvdGU6DQo+IEhpLA0KPiANCj4g
SSBoYXZlIG9wZW5lZCBhIG5ldyBpc3N1ZSBpbiB0aGUgQ2xhbmdCdWlsdExpbnV4IGlzc3VlIHRy
YWNrZXIuDQoNCkdsYWQgdG8ga25vdyBjbGFuZyA5IGhhcyBhc20gZ290byBzdXBwb3J0IGFuZCBu
b3cgSXQgY2FuIGNvbXBpbGUNCmtlcm5lbCBhZ2Fpbi4NCg0KPiANCj4gSSBhbSBzZWVpbmcgYSBw
cm9ibGVtIGluIHRoZSBhcmVhIGJwZi9zZWNjb21wIGNhdXNpbmcNCj4gc3lzdGVtZC9qb3VybmFs
ZC91ZGV2ZCBzZXJ2aWNlcyB0byBmYWlsLg0KPiANCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDMgMjAx
OV0gc3lzdGVtZFs0NTNdOiBzeXN0ZW1kLXVkZXZkLnNlcnZpY2U6IEZhaWxlZA0KPiB0byBjb25u
ZWN0IHN0ZG91dCB0byB0aGUgam91cm5hbCBzb2NrZXQsIGlnbm9yaW5nOiBDb25uZWN0aW9uIHJl
ZnVzZWQNCj4gDQo+IFRoaXMgaGFwcGVucyB3aGVuIEkgdXNlIHRoZSAoTExWTSkgTExEIGxkLmxs
ZC05IGxpbmtlciBidXQgbm90IHdpdGgNCj4gQkZEIGxpbmtlciBsZC5iZmQgb24gRGViaWFuL2J1
c3RlciBBTUQ2NC4NCj4gSW4gYm90aCBjYXNlcyBJIHVzZSBjbGFuZy05IChwcmVyZWxlYXNlKS4N
Cg0KTG9va3MgbGlrZSBpdCBpcyBhIGxsZCBidWcuDQoNCkkgc2VlIHRoZSBzdGFjayB0cmFjZSBo
YXMgX19icGZfcHJvZ19ydW4zMigpIHdoaWNoIGlzIHVzZWQgYnkNCmtlcm5lbCBicGYgaW50ZXJw
cmV0ZXIuIENvdWxkIHlvdSB0cnkgdG8gZW5hYmxlIGJwZiBqaXQNCiAgIHN5c2N0bCBuZXQuY29y
ZS5icGZfaml0X2VuYWJsZSA9IDENCklmIHRoaXMgcGFzc2VkLCBpdCB3aWxsIHByb3ZlIGl0IGlz
IGludGVycHJldGVyIHJlbGF0ZWQuDQoNCj4gDQo+IEJhc2UgZm9yIHRlc3Rpbmc6IG5leHQtMjAx
OTA3MjMuDQo+IA0KPiBUaGUgY2FsbC10cmFjZSBsb29rcyBsaWtlIHRoaXM6DQo+IA0KPiBbRnJp
IEp1bCAyNiAwODowODo0MiAyMDE5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUgcGFnZSBmYXVsdCBm
b3INCj4gYWRkcmVzczogZmZmZmZmZmY4NTQwMzM3MA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAy
MDE5XSAjUEY6IHN1cGVydmlzb3IgcmVhZCBhY2Nlc3MgaW4ga2VybmVsIG1vZGUNCj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDIgMjAxOV0gI1BGOiBlcnJvcl9jb2RlKDB4MDAwMCkgLSBub3QtcHJlc2Vu
dCBwYWdlDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFBHRCA3NjIwZTA2NyBQNEQgNzYy
MGUwNjcgUFVEIDc2MjBmMDYzIFBNRA0KPiA0NGZlODUwNjMgUFRFIDgwMGZmZmZmOGEzZmMwNjIN
Cj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gT29wczogMDAwMCBbIzFdIFNNUCBQVEkNCj4g
W0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gQ1BVOiAyIFBJRDogNDE3IENvbW06IChqb3VybmFs
ZCkgTm90DQo+IHRhaW50ZWQgNS4zLjAtcmMxLTUtYW1kNjQtY2JsLWFzbWdvdG8gIzV+YnVzdGVy
K2RpbGVrczENCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gSGFyZHdhcmUgbmFtZTogTEVO
T1ZPDQo+IDIwSERDVE8xV1cvMjBIRENUTzFXVywgQklPUyBOMVFFVDgzVyAoMS41OCApIDA0LzE4
LzIwMTkNCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUklQOiAwMDEwOl9fX2JwZl9wcm9n
X3J1bisweDQwLzB4MTRmMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBDb2RlOiBmMyBl
YiAyNCA0OCA4MyBmOCAzOCAwZiA4NCBhOSAwYyAwMA0KPiAwMCA0OCA4MyBmOCAzOSAwZiA4NSA4
YSAxNCAwMCAwMCAwZiAxZiAwMCA0OCAwZiBiZiA0MyAwMiA0OCA4ZCAxYyBjMw0KPiA0OCA4MyBj
MyAwOCAwZiBiNiAzMyA8NDg+IDhiIDA0IGY1IDEwIDJlIDQwIDg1IDQ4IDgzIGY4IDNiIDdmIDYy
IDQ4IDgzDQo+IGY4IDFlIDBmIDhmIGM4IDAwDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTld
IFJTUDogMDAxODpmZmZmOTkyZWMwMjhmY2I4IEVGTEFHUzogMDAwMTAyNDYNCj4gW0ZyaSBKdWwg
MjYgMDg6MDg6NDIgMjAxOV0gUkFYOiBmZmZmOTkyZWMwMjhmZDYwIFJCWDogZmZmZjk5MmVjMDBl
OTAzOA0KPiBSQ1g6IDAwMDAwMDAwMDAwMDAwMDINCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAx
OV0gUkRYOiBmZmZmOTkyZWMwMjhmZDQwIFJTSTogMDAwMDAwMDAwMDAwMDBhYw0KPiBSREk6IGZm
ZmY5OTJlYzAyOGZjZTANCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUkJQOiBmZmZmOTky
ZWMwMjhmY2QwIFIwODogMDAwMDAwMDAwMDAwMDAwMA0KPiBSMDk6IGZmZmY5OTJlYzAyOGZmNTgN
Cj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTog
ZmZmZmZmZmY4NDliODIxMA0KPiBSMTI6IDAwMDAwMDAwN2ZmZjAwMDANCj4gW0ZyaSBKdWwgMjYg
MDg6MDg6NDIgMjAxOV0gUjEzOiBmZmZmOTkyZWMwMjhmZWI4IFIxNDogMDAwMDAwMDAwMDAwMDAw
MA0KPiBSMTU6IGZmZmY5OTJlYzAyOGZjZTANCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0g
RlM6ICAwMDAwN2Y1ZDIwZjFkOTQwKDAwMDApDQo+IEdTOmZmZmY4YmEzZDI1MDAwMDAoMDAwMCkg
a25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQo+IFtGcmkgSnVs
IDI2IDA4OjA4OjQyIDIwMTldIENSMjogZmZmZmZmZmY4NTQwMzM3MCBDUjM6IDAwMDAwMDA0NDVi
M2UwMDENCj4gQ1I0OiAwMDAwMDAwMDAwMzYwNmUwDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIw
MTldIENhbGwgVHJhY2U6DQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldICBfX2JwZl9wcm9n
X3J1bjMyKzB4NDQvMHg3MA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSAgPyBmbHVzaF90
bGJfZnVuY19jb21tb24rMHhkOC8weDIzMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSAg
PyBtZW1fY2dyb3VwX2NvbW1pdF9jaGFyZ2UrMHg4Yy8weDEyMA0KPiBbRnJpIEp1bCAyNiAwODow
ODo0MiAyMDE5XSAgPyB3cF9wYWdlX2NvcHkrMHg0NjQvMHg3YTANCj4gW0ZyaSBKdWwgMjYgMDg6
MDg6NDIgMjAxOV0gIHNlY2NvbXBfcnVuX2ZpbHRlcnMrMHg1NC8weDExMA0KPiBbRnJpIEp1bCAy
NiAwODowODo0MiAyMDE5XSAgX19zZWNjb21wX2ZpbHRlcisweGY3LzB4NmUwDQo+IFtGcmkgSnVs
IDI2IDA4OjA4OjQyIDIwMTldICA/IGRvX3dwX3BhZ2UrMHgzMmIvMHg1ZDANCj4gW0ZyaSBKdWwg
MjYgMDg6MDg6NDIgMjAxOV0gID8gaGFuZGxlX21tX2ZhdWx0KzB4OTBkLzB4YmYwDQo+IFtGcmkg
SnVsIDI2IDA4OjA4OjQyIDIwMTldICBzeXNjYWxsX3RyYWNlX2VudGVyKzB4MTgyLzB4MjkwDQo+
IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldICBkb19zeXNjYWxsXzY0KzB4MzAvMHg5MA0KPiBb
RnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1l
KzB4NDQvMHhhOQ0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSSVA6IDAwMzM6MHg3ZjVk
MjIwZDdmNTkNCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gQ29kZTogMDAgYzMgNjYgMmUg
MGYgMWYgODQgMDAgMDAgMDAgMDAgMDANCj4gMGYgMWYgNDQgMDAgMDAgNDggODkgZjggNDggODkg
ZjcgNDggODkgZDYgNDggODkgY2EgNGQgODkgYzIgNGQgODkgYzgNCj4gNGMgOGIgNGMgMjQgMDgg
MGYgMDUgPDQ4PiAzZCAwMSBmMCBmZiBmZiA3MyAwMSBjMyA0OCA4YiAwZCAwNyA2ZiAwYyAwMA0K
PiBmNyBkOCA2NCA4OSAwMSA0OA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSU1A6IDAw
MmI6MDAwMDdmZmQxMTMzMmI0OCBFRkxBR1M6IDAwMDAwMjQ2DQo+IE9SSUdfUkFYOiAwMDAwMDAw
MDAwMDAwMTNkDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFJBWDogZmZmZmZmZmZmZmZm
ZmZkYSBSQlg6IDAwMDA1NWJmOGFiMzQwMTANCj4gUkNYOiAwMDAwN2Y1ZDIyMGQ3ZjU5DQo+IFtG
cmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFJEWDogMDAwMDU1YmY4YWIzNDAxMCBSU0k6IDAwMDAw
MDAwMDAwMDAwMDANCj4gUkRJOiAwMDAwMDAwMDAwMDAwMDAxDQo+IFtGcmkgSnVsIDI2IDA4OjA4
OjQyIDIwMTldIFJCUDogMDAwMDU1YmY4YWI5N2ZiMCBSMDg6IDAwMDA1NWJmOGFiYmUxODANCj4g
UjA5OiAwMDAwMDAwMGMwMDAwMDNlDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFIxMDog
MDAwMDU1YmY4YWJiZTFlMCBSMTE6IDAwMDAwMDAwMDAwMDAyNDYNCj4gUjEyOiAwMDAwN2ZmZDEx
MzMyYmEwDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIFIxMzogMDAwMDdmZmQxMTMzMmI5
OCBSMTQ6IDAwMDA3ZjVkMjFmMDg3ZjgNCj4gUjE1OiAwMDAwMDAwMDAwMDAwMDJjDQo+IFtGcmkg
SnVsIDI2IDA4OjA4OjQyIDIwMTldIE1vZHVsZXMgbGlua2VkIGluOiBpMmNfZGV2IHBhcnBvcnRf
cGMNCj4gc3VucnBjIHBwZGV2IGxwIHBhcnBvcnQgZWZpdmFyZnMgaXBfdGFibGVzIHhfdGFibGVz
IGF1dG9mczQgZXh0NA0KPiBjcmMzMmNfZ2VuZXJpYyBtYmNhY2hlIGNyYzE2IGpiZDIgYnRyZnMg
enN0ZF9kZWNvbXByZXNzIHpzdGRfY29tcHJlc3MNCj4gYWxnaWZfc2tjaXBoZXIgYWZfYWxnIHNk
X21vZCBkbV9jcnlwdCBkbV9tb2QgcmFpZDEwIHJhaWQ0NTYNCj4gYXN5bmNfcmFpZDZfcmVjb3Yg
YXN5bmNfbWVtY3B5IGFzeW5jX3BxIGFzeW5jX3hvciBhc3luY190eCB4b3INCj4gcmFpZDZfcHEg
bGliY3JjMzJjIHJhaWQxIHVhcyByYWlkMCB1c2Jfc3RvcmFnZSBtdWx0aXBhdGggbGluZWFyDQo+
IHNjc2lfbW9kIG1kX21vZCBoaWRfY2hlcnJ5IGhpZF9nZW5lcmljIHVzYmhpZCBoaWQgY3JjdDEw
ZGlmX3BjbG11bA0KPiBjcmMzMl9wY2xtdWwgY3JjMzJjX2ludGVsIGdoYXNoX2NsbXVsbmlfaW50
ZWwgYWVzbmlfaW50ZWwgYWVzX3g4Nl82NA0KPiBpOTE1IGdsdWVfaGVscGVyIGNyeXB0b19zaW1k
IG52bWUgaTJjX2FsZ29fYml0IGNyeXB0ZCBwc21vdXNlIHhoY2lfcGNpDQo+IGRybV9rbXNfaGVs
cGVyIGUxMDAwZSBpMmNfaTgwMSB4aGNpX2hjZCBpbnRlbF9scHNzX3BjaSBudm1lX2NvcmUNCj4g
aW50ZWxfbHBzcyBkcm0gdXNiY29yZSB0aGVybWFsIHdtaSB2aWRlbyBidXR0b24NCj4gW0ZyaSBK
dWwgMjYgMDg6MDg6NDIgMjAxOV0gQ1IyOiBmZmZmZmZmZjg1NDAzMzcwDQo+IFtGcmkgSnVsIDI2
IDA4OjA4OjQyIDIwMTldIC0tLVsgZW5kIHRyYWNlIDg2N2IzNWM3ZDZjNjcwNWEgXS0tLQ0KPiBb
RnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSSVA6IDAwMTA6X19fYnBmX3Byb2dfcnVuKzB4NDAv
MHgxNGYwDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIENvZGU6IGYzIGViIDI0IDQ4IDgz
IGY4IDM4IDBmIDg0IGE5IDBjIDAwDQo+IDAwIDQ4IDgzIGY4IDM5IDBmIDg1IDhhIDE0IDAwIDAw
IDBmIDFmIDAwIDQ4IDBmIGJmIDQzIDAyIDQ4IDhkIDFjIGMzDQo+IDQ4IDgzIGMzIDA4IDBmIGI2
IDMzIDw0OD4gOGIgMDQgZjUgMTAgMmUgNDAgODUgNDggODMgZjggM2IgN2YgNjIgNDggODMNCj4g
ZjggMWUgMGYgOGYgYzggMDANCj4gW0ZyaSBKdWwgMjYgMDg6MDg6NDIgMjAxOV0gUlNQOiAwMDE4
OmZmZmY5OTJlYzAyOGZjYjggRUZMQUdTOiAwMDAxMDI0Ng0KPiBbRnJpIEp1bCAyNiAwODowODo0
MiAyMDE5XSBSQVg6IGZmZmY5OTJlYzAyOGZkNjAgUkJYOiBmZmZmOTkyZWMwMGU5MDM4DQo+IFJD
WDogMDAwMDAwMDAwMDAwMDAwMg0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSRFg6IGZm
ZmY5OTJlYzAyOGZkNDAgUlNJOiAwMDAwMDAwMDAwMDAwMGFjDQo+IFJESTogZmZmZjk5MmVjMDI4
ZmNlMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBSQlA6IGZmZmY5OTJlYzAyOGZjZDAg
UjA4OiAwMDAwMDAwMDAwMDAwMDAwDQo+IFIwOTogZmZmZjk5MmVjMDI4ZmY1OA0KPiBbRnJpIEp1
bCAyNiAwODowODo0MiAyMDE5XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiBmZmZmZmZmZjg0
OWI4MjEwDQo+IFIxMjogMDAwMDAwMDA3ZmZmMDAwMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAy
MDE5XSBSMTM6IGZmZmY5OTJlYzAyOGZlYjggUjE0OiAwMDAwMDAwMDAwMDAwMDAwDQo+IFIxNTog
ZmZmZjk5MmVjMDI4ZmNlMA0KPiBbRnJpIEp1bCAyNiAwODowODo0MiAyMDE5XSBGUzogIDAwMDA3
ZjVkMjBmMWQ5NDAoMDAwMCkNCj4gR1M6ZmZmZjhiYTNkMjUwMDAwMCgwMDAwKSBrbmxHUzowMDAw
MDAwMDAwMDAwMDAwDQo+IFtGcmkgSnVsIDI2IDA4OjA4OjQyIDIwMTldIENTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNCj4gW0ZyaSBKdWwgMjYgMDg6MDg6
NDIgMjAxOV0gQ1IyOiBmZmZmZmZmZjg1NDAzMzcwIENSMzogMDAwMDAwMDQ0NWIzZTAwMQ0KPiBD
UjQ6IDAwMDAwMDAwMDAzNjA2ZTANCj4gDQo+IE1vcmUgZGV0YWlscyBpbiBbMV0gYW5kIHdoYXQg
SSB0cmllZCAoZm9yIGV4YW1wbGUgQ09ORklHX1NFQ0NPTVA9bikNCj4gDQo+IEkgaGF2ZSBubyBj
bHVlIGFib3V0IEJQRiBvciBTRUNDT01QLg0KPiANCj4gQ2FuIHlvdSBjb21tZW50IG9uIHRoaXM/
DQo+IA0KPiBJZiB0aGlzIHRvdWNoZXMgQlBGOiBDYW4geW91IGdpdmUgbWUgc29tZSBoaW50cyBh
bmQgaW5zdHJ1Y3Rpb25zIGluIGRlYnVnZ2luZz8NCj4gDQo+IE15IGtlcm5lbC1jb25maWcgYW5k
IGRtZXNnLWxvZyBhcmUgYXR0YWNoZWQuDQo+IA0KPiBUaGFua3MuDQo+IA0KPiBSZWdhcmRzLA0K
PiAtIFNlZGF0IC0NCj4gDQo+IFsxXSBodHRwczovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExpbnV4
L2xpbnV4L2lzc3Vlcy82MTkNCj4gDQo=
