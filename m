Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89EE8522D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbfHGRhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:37:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35422 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388760AbfHGRhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:37:08 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77HLkOX030419;
        Wed, 7 Aug 2019 10:36:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : content-type : content-id : content-transfer-encoding
 : mime-version; s=facebook;
 bh=4Tbrr8zmmoHCs1mVjo01WE4qubw+YYDUtcM4rt0cQ5s=;
 b=XxxT6fH6CsGQ61n3zJgNqdiAJh4RWopPqG9ftNkFBcdCyiK5KjW2BnbzADudYmkD6C+l
 IWQI/hRs0Zg1nOtAkaJSDlqXOBoJv/KRHzkczozOsIJoo86i8OdIEboPzquW3oIwrE6z
 1jCcylUn7mH4CsHKPp0w1XPLnrCltpbjbIY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u80f8rpgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Aug 2019 10:36:50 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 10:36:49 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 10:36:49 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 10:36:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcN5WzC0kLyB3+tSQRJWVfnoTV1GMW1Ts/eeAIT60YJd5NVluOuzWR6uQsNk30plN6RHCNjq/PuCOCshVa9cNa2TtCYdoUwi0H85ptI42JqCkVMkkRsSiHIhALYFJ8CgExqzu67RItZU+aWTG8UNjRjOjyxuHWsQIKXUscvCYBtr9LuVoyeJICpPftZrxOLfow9aDBZvKOjrNJFvqOy4/4BibA/IxwGCn9d7iu9Zbpc+muGzvBUG47IqHu634g7LcVZnv79TETWU4NvS6M2J7QJsfuy3SdZPlX+xxdH8VBtH9y3LthQLDbL+Q52QkCUQJNUK9mnjMTHmO5h5xRSAfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Tbrr8zmmoHCs1mVjo01WE4qubw+YYDUtcM4rt0cQ5s=;
 b=M7r7B5I+AuXTtFjJ8LnvQxbcTZ3cEFYEw3/f5HTh/w+08y8gfMWozO3300M8oNorDkxZZHmyGFpcWECPtKlfp15xxgYOcO6HQoLY9Jc6/suWkXqXhGXcz43pfyHy5+eQ/jW8QXaMKeahJIv0xiu5MpRp5IwQK1PcdfQjAK0LCs6T1zWhz+nGYWrx00udNAVsAMGrjG9nZmh/cAiXoMFCRHUU/Sq/wGoinRQI/XdGbzFG+C1uAm3iLKA8bdKYngKCqQCG/iYN7ZCsLK/kQ8ULN4Bh0+7KmM+3T2q4VDjPwhA9UQ3tz1tM6Rb4Q6neD5C2cLfpzXwc4zM1fu2d7mPH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Tbrr8zmmoHCs1mVjo01WE4qubw+YYDUtcM4rt0cQ5s=;
 b=Hf0a29Le30oc3zzurpGEfW8DsyWmMYYaplDGxpW5GI3b3i+3uDkvk5wXlvi7Sindm4yMhQW4h1AGBDv585qUYifAojp+N+lRKYm3wHtc6MeCByAFF6T/BWTzKwNmrVxpgNmYM4JxUj9VJBcGn23MUxdgGYZHB0ki0eG0fI/VLKk=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1717.namprd15.prod.outlook.com (10.174.54.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Wed, 7 Aug 2019 17:36:47 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0%8]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 17:36:47 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Tao Ren <taoren@fb.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re:[PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTUaw7KvSLDhTGEGo9NvmPIPC2A==
Date:   Wed, 7 Aug 2019 17:36:47 +0000
Message-ID: <75DDAF9A-DABC-4670-BEC0-320185017642@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:5fd5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66638a1d-4475-42f4-31e5-08d71b5dd2cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1717;
x-ms-traffictypediagnostic: CY4PR15MB1717:
x-microsoft-antispam-prvs: <CY4PR15MB1717B139B41046FB237CD45ADDD40@CY4PR15MB1717.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(189003)(71190400001)(5660300002)(14454004)(14444005)(53936002)(256004)(71200400001)(91956017)(6512007)(7736002)(6506007)(66556008)(6486002)(66946007)(102836004)(478600001)(305945005)(66446008)(316002)(36756003)(64756008)(86362001)(33656002)(76116006)(486006)(2616005)(2501003)(99286004)(46003)(186003)(25786009)(2201001)(110136005)(68736007)(476003)(2906002)(66476007)(81166006)(6116002)(6436002)(8936002)(8676002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1717;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rsmxfkD7dCFssyN87lrZFOqjoptCd7zU6fgYEHzkdI07L7cUqN4RSeUkfazz6QaRy7uPZui88r6jXzsiQj1KZCezPFfPaKeHpuEW6XOWnTcRSIjJxywjp6FNahoLY+ypFSHKkwkNaa4W9jnCGNAbgmeRHC3kJK5Lbn8UyL0na0JT5ozp+prYD+vyytwWYWxlBJjYoJfB6xcIjwTHaS5YE/ddd1Hed0kfBy9cvyp10gV7lFZFJeGtUe9/SE6++cdJWB4ki2tJRct/etMo1UdBbEWHMuKGWdNvbkjGCw0PgyJ20aXzgrTgdYLDn1LnVVHEv1xURfFRQcE/LmaXzMnZbl76/UTzQw4iPVYfHh2zsIVZ+TspXDviENAv3w3lwR+eQC5YWIym5Y4JHP1Xzssh2f6L6wOqimzX6u3bVP/VDCQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03BA4D1D80803B4EAB293595BDEE4EC3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66638a1d-4475-42f4-31e5-08d71b5dd2cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 17:36:47.7890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vijaykhemka@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1717
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=903 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGd0bSBleGNlcHQgb25lIHNtYWxsIGNvbW1lbnQgYmVsb3cuDQoNCu+7v09uIDgvNi8xOSwgNToy
MiBQTSwgIm9wZW5ibWMgb24gYmVoYWxmIG9mIFRhbyBSZW4iIDxvcGVuYm1jLWJvdW5jZXMrdmlq
YXlraGVta2E9ZmIuY29tQGxpc3RzLm96bGFicy5vcmcgb24gYmVoYWxmIG9mIHRhb3JlbkBmYi5j
b20+IHdyb3RlOg0KDQogICAgQ3VycmVudGx5IEJNQydzIE1BQyBhZGRyZXNzIGlzIGNhbGN1bGF0
ZWQgYnkgYWRkaW5nIDEgdG8gTkNTSSBOSUMncyBiYXNlDQogICAgTUFDIGFkZHJlc3Mgd2hlbiBD
T05GSUdfTkNTSV9PRU1fQ01EX0dFVF9NQUMgb3B0aW9uIGlzIGVuYWJsZWQuIFRoZSBsb2dpYw0K
ICAgIGRvZXNuJ3Qgd29yayBmb3IgcGxhdGZvcm1zIHdpdGggZGlmZmVyZW50IEJNQyBNQUMgb2Zm
c2V0OiBmb3IgZXhhbXBsZSwNCiAgICBGYWNlYm9vayBZYW1wIEJNQydzIE1BQyBhZGRyZXNzIGlz
IGNhbGN1bGF0ZWQgYnkgYWRkaW5nIDIgdG8gTklDJ3MgYmFzZQ0KICAgIE1BQyBhZGRyZXNzICgi
QmFzZU1BQyArIDEiIGlzIHJlc2VydmVkIGZvciBIb3N0IHVzZSkuDQogICAgDQogICAgVGhpcyBw
YXRjaCBhZGRzIE5FVF9OQ1NJX01DX01BQ19PRkZTRVQgY29uZmlnIG9wdGlvbiB0byBjdXN0b21p
emUgb2Zmc2V0DQogICAgYmV0d2VlbiBOSUMncyBCYXNlIE1BQyBhZGRyZXNzIGFuZCBCTUMncyBN
QUMgYWRkcmVzcy4gSXRzIGRlZmF1bHQgdmFsdWUgaXMNCiAgICBzZXQgdG8gMSB0byBhdm9pZCBi
cmVha2luZyBleGlzdGluZyB1c2Vycy4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBUYW8gUmVu
IDx0YW9yZW5AZmIuY29tPg0KICAgIC0tLQ0KICAgICBuZXQvbmNzaS9LY29uZmlnICAgIHwgIDgg
KysrKysrKysNCiAgICAgbmV0L25jc2kvbmNzaS1yc3AuYyB8IDE1ICsrKysrKysrKysrKystLQ0K
ICAgICAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQog
ICAgDQogICAgZGlmZiAtLWdpdCBhL25ldC9uY3NpL0tjb25maWcgYi9uZXQvbmNzaS9LY29uZmln
DQogICAgaW5kZXggMmYxZTU3NTZjMDNhLi5iZThlZmUxZWQ5OWUgMTAwNjQ0DQogICAgLS0tIGEv
bmV0L25jc2kvS2NvbmZpZw0KICAgICsrKyBiL25ldC9uY3NpL0tjb25maWcNCiAgICBAQCAtMTcs
MyArMTcsMTEgQEAgY29uZmlnIE5DU0lfT0VNX0NNRF9HRVRfTUFDDQogICAgIAktLS1oZWxwLS0t
DQogICAgIAkgIFRoaXMgYWxsb3dzIHRvIGdldCBNQUMgYWRkcmVzcyBmcm9tIE5DU0kgZmlybXdh
cmUgYW5kIHNldCB0aGVtIGJhY2sgdG8NCiAgICAgCQljb250cm9sbGVyLg0KICAgICtjb25maWcg
TkVUX05DU0lfTUNfTUFDX09GRlNFVA0KICAgICsJaW50DQogICAgKwlwcm9tcHQgIk9mZnNldCBv
ZiBNYW5hZ2VtZW50IENvbnRyb2xsZXIncyBNQUMgQWRkcmVzcyINCiAgICArCWRlcGVuZHMgb24g
TkNTSV9PRU1fQ01EX0dFVF9NQUMNCiAgICArCWRlZmF1bHQgMQ0KICAgICsJaGVscA0KICAgICsJ
ICBUaGlzIGRlZmluZXMgdGhlIG9mZnNldCBiZXR3ZWVuIE5ldHdvcmsgQ29udHJvbGxlcidzIChi
YXNlKSBNQUMNCiAgICArCSAgYWRkcmVzcyBhbmQgTWFuYWdlbWVudCBDb250cm9sbGVyJ3MgTUFD
IGFkZHJlc3MuDQogICAgZGlmZiAtLWdpdCBhL25ldC9uY3NpL25jc2ktcnNwLmMgYi9uZXQvbmNz
aS9uY3NpLXJzcC5jDQogICAgaW5kZXggNzU4MWJmOTE5ODg1Li4yNGE3OTFmOWViZjUgMTAwNjQ0
DQogICAgLS0tIGEvbmV0L25jc2kvbmNzaS1yc3AuYw0KICAgICsrKyBiL25ldC9uY3NpL25jc2kt
cnNwLmMNCiAgICBAQCAtNjU2LDYgKzY1NiwxMSBAQCBzdGF0aWMgaW50IG5jc2lfcnNwX2hhbmRs
ZXJfb2VtX2JjbV9nbWEoc3RydWN0IG5jc2lfcmVxdWVzdCAqbnIpDQogICAgIAlzdHJ1Y3QgbmNz
aV9yc3Bfb2VtX3BrdCAqcnNwOw0KICAgICAJc3RydWN0IHNvY2thZGRyIHNhZGRyOw0KICAgICAJ
aW50IHJldCA9IDA7DQogICAgKyNpZmRlZiBDT05GSUdfTkVUX05DU0lfTUNfTUFDX09GRlNFVA0K
ICAgICsJaW50IG1hY19vZmZzZXQgPSBDT05GSUdfTkVUX05DU0lfTUNfTUFDX09GRlNFVDsNCiAg
ICArI2Vsc2UNCiAgICArCWludCBtYWNfb2Zmc2V0ID0gMTsNCiAgICArI2VuZGlmDQogICAgIA0K
ICAgICAJLyogR2V0IHRoZSByZXNwb25zZSBoZWFkZXIgKi8NCiAgICAgCXJzcCA9IChzdHJ1Y3Qg
bmNzaV9yc3Bfb2VtX3BrdCAqKXNrYl9uZXR3b3JrX2hlYWRlcihuci0+cnNwKTsNCiAgICBAQCAt
NjYzLDggKzY2OCwxNCBAQCBzdGF0aWMgaW50IG5jc2lfcnNwX2hhbmRsZXJfb2VtX2JjbV9nbWEo
c3RydWN0IG5jc2lfcmVxdWVzdCAqbnIpDQogICAgIAlzYWRkci5zYV9mYW1pbHkgPSBuZGV2LT50
eXBlOw0KICAgICAJbmRldi0+cHJpdl9mbGFncyB8PSBJRkZfTElWRV9BRERSX0NIQU5HRTsNCiAg
ICAgCW1lbWNweShzYWRkci5zYV9kYXRhLCAmcnNwLT5kYXRhW0JDTV9NQUNfQUREUl9PRkZTRVRd
LCBFVEhfQUxFTik7DQogICAgLQkvKiBJbmNyZWFzZSBtYWMgYWRkcmVzcyBieSAxIGZvciBCTUMn
cyBhZGRyZXNzICovDQogICAgLQlldGhfYWRkcl9pbmMoKHU4ICopc2FkZHIuc2FfZGF0YSk7DQog
ICAgKw0KICAgICsJLyogTWFuYWdlbWVudCBDb250cm9sbGVyJ3MgTUFDIGFkZHJlc3MgaXMgY2Fs
Y3VsYXRlZCBieSBhZGRpbmcNCiAgICArCSAqIHRoZSBvZmZzZXQgdG8gTmV0d29yayBDb250cm9s
bGVyJ3MgKGJhc2UpIE1BQyBhZGRyZXNzLg0KICAgICsJICogTm90ZTogbmVnYXRpdmUgb2Zmc2V0
IGlzICJpZ25vcmVkIiwgYW5kIEJNQyB3aWxsIHVzZSB0aGUgQmFzZQ0KSnVzdCBtZW50aW9uIG5l
Z2F0aXZlIGFuZCB6ZXJvIG9mZnNldCBpcyBpZ25vcmVkLiBBcyB5b3UgYXJlIGlnbm9yaW5nIDAg
YXMgd2VsbC4NCg0KICAgICsJICogTUFDIGFkZHJlc3MgaW4gdGhpcyBjYXNlLg0KICAgICsJICov
DQogICAgKwl3aGlsZSAobWFjX29mZnNldC0tID4gMCkNCiAgICArCQlldGhfYWRkcl9pbmMoKHU4
ICopc2FkZHIuc2FfZGF0YSk7DQogICAgIAlpZiAoIWlzX3ZhbGlkX2V0aGVyX2FkZHIoKGNvbnN0
IHU4ICopc2FkZHIuc2FfZGF0YSkpDQogICAgIAkJcmV0dXJuIC1FTlhJTzsNCiAgICAgDQogICAg
LS0gDQogICAgMi4xNy4xDQogICAgDQogICAgDQoNCg==
