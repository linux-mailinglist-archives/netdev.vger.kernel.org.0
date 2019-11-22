Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9F7105DBC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVAeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:34:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61316 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfKVAeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:34:37 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM0TOkX016556;
        Thu, 21 Nov 2019 16:34:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bRY5V8A+3pwHDmINYlTTY7j8M9vHzzXNl+pk+x21kAs=;
 b=MA0+/kVVJdnxUwpU74lg7RZq+qV9Ogw4/sG67REpniqtLUKys1MekksQwdqwXgs3iqh2
 z/gZJEBF6bEySZRzKZwUAaAoeOkxZFIxmtf6TcTVpzk22uOhjARDTg4Hfxe1SuGBPEK1
 9sbfYmQ4OHkH9wrHMTGpX2NOSUH/3Buzz6I= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wda3vm7yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 16:34:18 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 16:34:17 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 16:34:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIumxcKYg/NbNWIYbOiWnf+3iPt3KTDLLi2Ddxr2s6ycB0zN4x/YCEeajRXGNJST4/b0oRLSEyEttHq4+lLI14mDL1AxGAKar7CEUJri6vipUcTSsHT3z47k2gtKu9Agp6UfeW/2YfkH8wK8zu1e/OpUq3AHbsLO0NZP0MpzwTx3VrpQxjTViSPdHoLdUodClSZ++kb3fxttGJ9zbxhFBfMrH5j+KF1QOdBIwOWKIO9Qx8ywII++wPD+t8KE7qywc2tn7USRqSCcc6z34DcUGJJXuvBrkB/e6mziJC8gTHw+mm+DcJunV/qZYEaGEao52j9NhLIkB1jFM8YUSPRB4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRY5V8A+3pwHDmINYlTTY7j8M9vHzzXNl+pk+x21kAs=;
 b=Jf/h7vytKDAPKzYGSlRGrOIzNQRXv61BeesIDAl2Y1sboPL24w4Daz4p+XBrWPLxIaXS4o0jcnSqKzZGbpdPERZzwkh6zTyUrmhHCukJAMKi2c6+2YvB+tjGoH0bQaOtO23IaQgeLL1yLncaaV5wBrrsMbGMJJcHkc4awE/6lK+oeNOEw4YNEgSP7TPJIaW0ahduLM7k66f5vIAYyM2UKhCi4I1DN5dtbeymQvHAM6Jf7YEYxy+hQLJUpxNZvPkV1pATtAfHUAB0y85P+b0AOxXIbB9kbqubi5/pBopMuqkakYwlyqc2okmxWvf9yFoXwoYV+mbfXWW4ibYV92OKzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRY5V8A+3pwHDmINYlTTY7j8M9vHzzXNl+pk+x21kAs=;
 b=BeP1W9ZSYFFI6JjFjxpvkuPw50ztO8iZ7QglhHoc4dtJK9tJ/ilOrbq4l728cMMManKVrLUrzI4tWZTdJnMj0PtjY1Tp1sUXTcdOQR/FE1eLSwec49mWbw/xnkDu/2gcTSF930EkhJ4Mh58m+hd6RqxGb1PcTf75EPb7M1qVpgQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3192.namprd15.prod.outlook.com (20.179.59.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Fri, 22 Nov 2019 00:34:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 00:34:15 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>
CC:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/9] bpf: add generic support for lookup and
 lookup_and_delete batch ops
Thread-Topic: [PATCH v2 bpf-next 2/9] bpf: add generic support for lookup and
 lookup_and_delete batch ops
Thread-Index: AQHVnw/qHa5aYibJs0i7hlxvNzQNFKeV5i4AgABDLoCAADGjAA==
Date:   Fri, 22 Nov 2019 00:34:15 +0000
Message-ID: <e9cb66e4-16fd-8850-4755-3034f75788c5@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-3-brianvv@google.com>
 <de05c3f2-5b70-b9af-445c-9cf43b55737c@fb.com>
 <CAMzD94TfpQaFN=7cQR9kmHun0gZNF2oMwEJu7aZMYhsYhvgRDg@mail.gmail.com>
In-Reply-To: <CAMzD94TfpQaFN=7cQR9kmHun0gZNF2oMwEJu7aZMYhsYhvgRDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:301:2::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:ffef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91128186-1bd5-42fd-5926-08d76ee3b3fc
x-ms-traffictypediagnostic: BYAPR15MB3192:
x-microsoft-antispam-prvs: <BYAPR15MB319294E916F5A8BF48406DCDD3490@BYAPR15MB3192.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(346002)(376002)(39860400002)(199004)(189003)(6512007)(4326008)(14454004)(6486002)(66556008)(66446008)(7736002)(305945005)(31686004)(36756003)(229853002)(66476007)(64756008)(54906003)(316002)(6246003)(478600001)(66946007)(99286004)(6436002)(86362001)(76176011)(52116002)(81166006)(81156014)(102836004)(71190400001)(8676002)(46003)(2906002)(186003)(446003)(31696002)(256004)(14444005)(386003)(6506007)(11346002)(2616005)(71200400001)(6916009)(5660300002)(53546011)(7416002)(25786009)(6116002)(8936002)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3192;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSj5/jyV45vROmea4XtHiwqnFw1hvI8KP74XEB3S1X8gifEpI2TaoSJVUA4bvv+kW/QFIJ0DMUksfuiesYwm7bPkcAYcaMBfyXvylMk0Zvr3LAJZDp/l5OFV2hR6IMh5L8JC1LCSwE6bWqnV1nIwJOXbjKH/zniDSyhx8dLKc850+/fhFZ37+iUWrMXNH3Yax59yCtohDDIVXfHLiBMJoYDU6DYPgYzix88A73tLGsdAH0o4D6DGFBnulm/B95Wd6bNaVF3lkSAp4DZXjafbEsXbX5wGp9rqms3ziCp1ZsTUwtYR8PLBjX7jNBqRvqyevQoQDqA3RucbRSoEOj0TgSjZurSWZDlY+NGKgWQKIp4UaCqWkAinZk/JQKOT5ToC2ChsTAoM1UNB0nEONkAcsqkMbmp7Pt2i4cuMn5Ueawm812+RGF3RC3jCSAI+kCWV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64FAF966C0F0E342BDD6BE12F231A934@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 91128186-1bd5-42fd-5926-08d76ee3b3fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 00:34:15.4224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vldueZd8n4hK2fCfb54o49K+nWUh1QmSJunMYOfwWOyU43TVuNBSre+BgB7hKVQN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzIxLzE5IDE6MzYgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IEhpIFlvbmdo
b25nLA0KPiB0aGFua3MgZm9yIHJldmlld2luZyB0aGUgcGF0Y2gsIEkgd2lsbCBmaXggYWxsIHRo
ZSBkaXJlY3QgcmV0dXJucyBhbmQNCj4gc21hbGwgZml4ZXMgaW4gbmV4dCB2ZXJzaW9uLg0KPiAN
Cj4gT24gVGh1LCBOb3YgMjEsIDIwMTkgYXQgOTozNiBBTSBZb25naG9uZyBTb25nIDx5aHNAZmIu
Y29tPiB3cm90ZToNCj4+DQo+Pg0KPj4NCj4+IE9uIDExLzE5LzE5IDExOjMwIEFNLCBCcmlhbiBW
YXpxdWV6IHdyb3RlOg0KPj4+IFRoaXMgY29tbWl0IGludHJvZHVjZXMgZ2VuZXJpYyBzdXBwb3J0
IGZvciB0aGUgYnBmX21hcF9sb29rdXBfYmF0Y2ggYW5kDQo+Pj4gYnBmX21hcF9sb29rdXBfYW5k
X2RlbGV0ZV9iYXRjaCBvcHMuIFRoaXMgaW1wbGVtZW50YXRpb24gY2FuIGJlIHVzZWQgYnkNCj4+
PiBhbG1vc3QgYWxsIHRoZSBicGYgbWFwcyBzaW5jZSBpdHMgY29yZSBpbXBsZW1lbnRhdGlvbiBp
cyByZWx5aW5nIG9uIHRoZQ0KPj4+IGV4aXN0aW5nIG1hcF9nZXRfbmV4dF9rZXksIG1hcF9sb29r
dXBfZWxlbSBhbmQgbWFwX2RlbGV0ZV9lbGVtDQo+Pj4gZnVuY3Rpb25zLiBUaGUgYnBmIHN5c2Nh
bGwgc3ViY29tbWFuZHMgaW50cm9kdWNlZCBhcmU6DQo+Pj4NClsuLi5dDQo+Pj4gKyAgICAgZm9y
IChjcCA9IDA7IGNwIDwgbWF4X2NvdW50OyBjcCsrKSB7DQo+Pj4gKyAgICAgICAgICAgICBpZiAo
Y3AgfHwgZmlyc3Rfa2V5KSB7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIHJjdV9yZWFkX2xv
Y2soKTsNCj4+PiArICAgICAgICAgICAgICAgICAgICAgZXJyID0gbWFwLT5vcHMtPm1hcF9nZXRf
bmV4dF9rZXkobWFwLCBwcmV2X2tleSwga2V5KTsNCj4+PiArICAgICAgICAgICAgICAgICAgICAg
cmN1X3JlYWRfdW5sb2NrKCk7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChlcnIpDQo+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+Pj4gKyAgICAgICAgICAg
ICB9DQo+Pj4gKyAgICAgICAgICAgICBlcnIgPSBicGZfbWFwX2NvcHlfdmFsdWUobWFwLCBrZXks
IHZhbHVlLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGF0dHIt
PmJhdGNoLmVsZW1fZmxhZ3MsIGRvX2RlbGV0ZSk7DQo+Pj4gKw0KPj4+ICsgICAgICAgICAgICAg
aWYgKGVyciA9PSAtRU5PRU5UKSB7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChyZXRy
eSkgew0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHJ5LS07DQo+Pg0KPj4g
V2hhdCBpcyB0aGUgJ3JldHJ5JyBzZW1hbnRpY3MgaGVyZT8gQWZ0ZXIgJ2NvbnRpbnVlJywgY3Ar
KyBpcyBleGVjdXRlZC4NCj4gDQo+IEdvb2QgY2F0Y2gsIEknbGwgbW92ZSBjcCsrIHRvIGEgcHJv
cGVyIHBsYWNlLiByZXRyeSBpcyB1c2VkIHRvIHByZXZlbnQNCj4gdGhlIGNhc2VzIHdoZXJlIHRo
ZSBtYXAgaXMgZG9pbmcgbWFueSBjb25jdXJyZW50IGFkZGl0aW9ucyBhbmQNCj4gZGVsZXRpb25z
LCB0aGlzIGNvdWxkIHJlc3VsdCBpbiBtYXBfZ2V0X25leHRfa2V5IHN1Y2NlZWRpbmcgYnV0DQo+
IGJwZl9tYXBfY29weV92YWx1ZSBmYWlsaW5nLCBpbiB3aGljaCBjYXNlIEkgdGhpbmsgaXQnZCBi
ZSBiZXR0ZXIgdG8NCj4gdHJ5IGFuZCBmaW5kIGEgbmV4dCBlbGVtLCBidXQgd2UgZG9uJ3Qgd2Fu
dCB0byBkbyB0aGlzIGZvciBtb3JlIHRoYW4gMw0KPiB0aW1lcy4NCj4gDQo+Pg0KPj4+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPj4+ICsgICAgICAgICAgICAgICAg
ICAgICB9DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGVyciA9IC1FSU5UUjsNCj4+DQo+PiBX
aHkgcmV0dXJuaW5nIC1FSU5UUj8NCj4gDQo+IEkgdGhvdWdodCB0aGF0IHRoaXMgaXMgdGhlIGVy
ciBtb3JlIGFwcHJvcHJpYXRlIGZvciB0aGUgYmVoYXZpb3VyIEkNCj4gZGVzY3JpYmUgYWJvdmUu
IFNob3VsZCBJIGhhbmRsZSB0aGF0IGNhc2U/IFdEWVQ/DQoNCkkgc2VlLiBXZSBkbyBub3Qgd2Fu
dCB0byB1c2UgLUVOT0VOVCBzaW5jZSBnZXRfbmV4dF9rZXkgbWF5IHJldHVybiANCi1FTk9FTlQu
IEkgdGhpbmsgLUVJTlRSIGlzIG9rYXkgaGVyZSB0byBpbmRpY2F0ZSB3ZSBoYXZlIGtleSwgYnV0
IA0Ka2V5L3ZhbHVlIGVudHJ5IGlzIGdvbmUgcmlnaHQgYmVmb3JlIHRoZSBhdHRlbXB0ZWQgYWNj
ZXNzLg0K
