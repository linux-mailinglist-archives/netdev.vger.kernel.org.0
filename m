Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A62825D7
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfHEUEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:04:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbfHEUEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:04:39 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75K41OM030834;
        Mon, 5 Aug 2019 13:04:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JHcxEOLt6gp8YWTf4wc+5CFjxJRCt8fDv4T2ZSsvvek=;
 b=kgyYkvmpM8ixqnwuT7mHfPjirePIHVrZmP3etlWTJTyp3P+TyuXLy5qk9l3Dbqa3ObzV
 u5DRDl7eXvGPdomfZJShcrbdAXh+fsNtgWp0wRa7S+Oz2IMcifOu0ZaMSMSTwDTYKpCc
 7SHnRpzh/agC762r9hO2x6L0nD1o5qtQtME= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6tcq05u1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 13:04:16 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 5 Aug 2019 13:04:15 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 5 Aug 2019 13:04:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWbJyJqJjaNAaSppdr2mj4R19HIq6knBAu20cKEX+qFD2CBVJYLmvNO2uGx1B+LJjwLL7BsbfNL7z7bcf+Wq9v8gand+3lCaIUlUje07qoMDBoZ2RovxheAF1+fBUWO13IvayI2BDoeGn3M6j/4Ik22jCZ4g2Q9Ql85kh9QjX1QFCNJdnuzKST07HBDQ2e+xdzHtnwnLy2c/kHhDT2D3ZC+7y3bsqr3aF2JuF9u1GMUAN4oe/GlJrY8gh0zouPhPSLvyHJo+ajeTrxyhF+ZvSSspHNI/6pVXc4FaVLiAY3uE1WjlRrYV5RQ0NE8YW5j1wRbx9vCN4KWb/1bvg89upg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHcxEOLt6gp8YWTf4wc+5CFjxJRCt8fDv4T2ZSsvvek=;
 b=idzDFP9O+8aPBEt+BcYZoAverOhb3ulvHxaciv/04A2jNsOn5abuU4uyxHz0UDlIfjEFxDaG1qlziLEQQTSv7nWXS8ExWI3mwx0IkZCZNj6zoKo0It6Wz5MI6B38+m8dF1rrOfjET38Orw3lLd/A3yk9Pqhr5nJJJdGQECSwBz6E0KoBkyUcwG7o5HfMARciM/twZkd+KQ9Tyeo4Xa6rW5d/cx0UK058AyQBtpPcWxwfFvZPg5leb/bFBRTiJAoD0j7loL5oxzMBU3gtBuCs7+RahCFqd+rI3BTyICvHyiI07cLAjw0Y+vcPfPSxjzW+7NPnOCjJxtX8+Ft5wjXQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHcxEOLt6gp8YWTf4wc+5CFjxJRCt8fDv4T2ZSsvvek=;
 b=V07Stjq80XKDy/Onmn739BEYza9ZXZrZ1aRRb6pr6Ecqj0HWT85+ycq8BRMrJVaFbAEZ6OSdxqu13zRAtO5UAa4VCvMkGw4flIK27PZM5UiQGOVk5zzwxbxl0OMu2oL1N14W61E3eUTEQSihgxzBiZoghoLOjHs4tRyuEWzl7to=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2696.namprd15.prod.outlook.com (20.179.156.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Mon, 5 Aug 2019 20:04:14 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 20:04:14 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Topic: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Index: AQHVS8ZZRvjRjh/ij0+eu7mMX24CUKbs+k0A
Date:   Mon, 5 Aug 2019 20:04:13 +0000
Message-ID: <db0340a8-a4d7-f652-729d-9edd22a87310@fb.com>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-2-ast@kernel.org>
 <CAEf4Bzb==_gzT78_oN7AfiGHrqGXdYK+oEamkxpfEjP5fzr_UA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb==_gzT78_oN7AfiGHrqGXdYK+oEamkxpfEjP5fzr_UA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0070.namprd10.prod.outlook.com
 (2603:10b6:300:2c::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:1bdd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49a05ec3-eca0-4cdc-e524-08d719e0167e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2696;
x-ms-traffictypediagnostic: BYAPR15MB2696:
x-microsoft-antispam-prvs: <BYAPR15MB269629C7AAE14BF9EC5146BFD3DA0@BYAPR15MB2696.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(6506007)(229853002)(4326008)(25786009)(2906002)(6512007)(76176011)(54906003)(305945005)(53936002)(66946007)(7736002)(6486002)(110136005)(6436002)(66446008)(64756008)(66556008)(66476007)(316002)(53546011)(386003)(5660300002)(256004)(476003)(2616005)(31686004)(11346002)(186003)(71190400001)(486006)(71200400001)(46003)(6116002)(86362001)(68736007)(102836004)(31696002)(478600001)(446003)(8936002)(6246003)(52116002)(81166006)(14454004)(81156014)(36756003)(99286004)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2696;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ig8H+o41X7T0ekcGTXtG1jYQpZElU6AGtq6/4Mb2LS4fsJA7DKLf9jvCg9NYaWDCsD1DO3SvSJRxagO6DUtwy8AWsJO4L77zFgIORT2X0UQe8PpmVlhR3+olVqKnmoU+WKh9QFxTue8gyd5p9ola/rBuN8D9bIqGLfZ3NNyf1WaStzFAZ37mT7J+S3EDoe+QWUUXDo0ZRJvXC8l/fqTsiso2Ua2GZJc3rloyN0YT6EWpYPuXcmqtCel5q5voygtnZ+scfizKcajZk3a886F2p0dPH2N8YxOR03j8KDdvRCfeA3nNWjuG9Qb+0RjXbNuZ/r6H4V4HNoGAFFXUmOlINpAjRPkTyeAoh/4LY7WryKBb7t1QKkg8jyw9TGQs46eT4/McEA3CJEALR1G1fdBwKVHNeV+C4bjPk2zwOE+jFNU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17C6667075E2DB4D8CF66F5B89EC7F77@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a05ec3-eca0-4cdc-e524-08d719e0167e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 20:04:13.9266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvNS8xOSAxMjo0NSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBTYXQs
IEF1ZyAzLCAyMDE5IGF0IDg6MTkgUE0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+Pg0KPj4gQWRkIGEgdGVzdCB0aGF0IHJldHVybnMgYSAncmFuZG9tJyBudW1i
ZXIgYmV0d2VlbiBbMCwgMl4yMCkNCj4+IElmIHN0YXRlIHBydW5pbmcgaXMgbm90IHdvcmtpbmcg
Y29ycmVjdGx5IGZvciBsb29wIGJvZHkgdGhlIG51bWJlciBvZg0KPj4gcHJvY2Vzc2VkIGluc25z
IHdpbGwgYmUgMl4yMCAqIG51bV9vZl9pbnNuc19pbl9sb29wX2JvZHkgYW5kIHRoZSBwcm9ncmFt
DQo+PiB3aWxsIGJlIHJlamVjdGVkLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFy
b3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4+ICAgLi4uL2JwZi9wcm9nX3Rlc3Rz
L2JwZl92ZXJpZl9zY2FsZS5jICAgICAgICAgIHwgIDEgKw0KPj4gICB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvbG9vcDQuYyAgICAgfCAyMyArKysrKysrKysrKysrKysrKysrDQo+
PiAgIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKQ0KPj4gICBjcmVhdGUgbW9kZSAx
MDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A0LmMNCj4+DQo+PiBk
aWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvYnBmX3Zl
cmlmX3NjYWxlLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZf
dmVyaWZfc2NhbGUuYw0KPj4gaW5kZXggYjRiZTk2MTYyZmY0Li43NTdlMzk1NDBlZGEgMTAwNjQ0
DQo+PiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZfdmVy
aWZfc2NhbGUuYw0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVz
dHMvYnBmX3ZlcmlmX3NjYWxlLmMNCj4+IEBAIC03MSw2ICs3MSw3IEBAIHZvaWQgdGVzdF9icGZf
dmVyaWZfc2NhbGUodm9pZCkNCj4+DQo+PiAgICAgICAgICAgICAgICAgIHsgImxvb3AxLm8iLCBC
UEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UIH0sDQo+PiAgICAgICAgICAgICAgICAgIHsgImxv
b3AyLm8iLCBCUEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UIH0sDQo+PiArICAgICAgICAgICAg
ICAgeyAibG9vcDQubyIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4+DQo+PiAg
ICAgICAgICAgICAgICAgIC8qIHBhcnRpYWwgdW5yb2xsLiAxOWsgaW5zbiBpbiBhIGxvb3AuDQo+
PiAgICAgICAgICAgICAgICAgICAqIFRvdGFsIHByb2dyYW0gc2l6ZSAyMC44ayBpbnNuLg0KPj4g
ZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9sb29wNC5jIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A0LmMNCj4+IG5ldyBmaWxlIG1v
ZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjNlN2VlMTRmZGRiZA0KPj4gLS0tIC9k
ZXYvbnVsbA0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A0
LmMNCj4+IEBAIC0wLDAgKzEsMjMgQEANCj4+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMA0KPj4gKy8vIENvcHlyaWdodCAoYykgMjAxOSBGYWNlYm9vaw0KPj4gKyNpbmNsdWRl
IDxsaW51eC9zY2hlZC5oPg0KPj4gKyNpbmNsdWRlIDxsaW51eC9wdHJhY2UuaD4NCj4+ICsjaW5j
bHVkZSA8c3RkaW50Lmg+DQo+PiArI2luY2x1ZGUgPHN0ZGRlZi5oPg0KPj4gKyNpbmNsdWRlIDxz
dGRib29sLmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L2JwZi5oPg0KPj4gKyNpbmNsdWRlICJicGZf
aGVscGVycy5oIg0KPj4gKw0KPj4gK2NoYXIgX2xpY2Vuc2VbXSBTRUMoImxpY2Vuc2UiKSA9ICJH
UEwiOw0KPj4gKw0KPj4gK1NFQygic29ja2V0IikNCj4+ICtpbnQgY29tYmluYXRpb25zKHZvbGF0
aWxlIHN0cnVjdCBfX3NrX2J1ZmYqIHNrYikNCj4+ICt7DQo+PiArICAgICAgIGludCByZXQgPSAw
LCBpOw0KPj4gKw0KPj4gKyNwcmFnbWEgbm91bnJvbGwNCj4+ICsgICAgICAgZm9yIChpID0gMDsg
aSA8IDIwOyBpKyspDQo+PiArICAgICAgICAgICAgICAgaWYgKHNrYi0+bGVuKQ0KPj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgcmV0IHw9IDEgPDwgaTsNCj4gDQo+IFNvIEkgdGhpbmsgdGhlIGlk
ZWEgaXMgdGhhdCBiZWNhdXNlIHZlcmlmaWVyIHNob3VsZG4ndCBrbm93IHdoZXRoZXINCj4gc2ti
LT5sZW4gaXMgemVybyBvciBub3QsIHRoZW4geW91IGhhdmUgdHdvIG91dGNvbWVzIG9uIGV2ZXJ5
IGl0ZXJhdGlvbg0KPiBsZWFkaW5nIHRvIDJeMjAgc3RhdGVzLCByaWdodD8NCj4gDQo+IEJ1dCBJ
J20gYWZyYWlkIHRoYXQgdmVyaWZpZXIgY2FuIGV2ZW50dWFsbHkgYmUgc21hcnQgZW5vdWdoIChp
ZiBpdCdzDQo+IG5vdCBhbHJlYWR5LCBidHcpLCB0byBmaWd1cmUgb3V0IHRoYXQgcmV0IGNhbiBi
ZSBlaXRoZXIgMCBvciAoKDEgPDwNCj4gMjEpIC0gMSksIGFjdHVhbGx5LiBJZiBza2ItPmxlbiBp
cyBwdXQgaW50byBzZXBhcmF0ZSByZWdpc3RlciwgdGhlbg0KPiB0aGF0IHJlZ2lzdGVyJ3MgYm91
bmRzIHdpbGwgYmUgZXN0YWJsaXNoZWQgb24gZmlyc3QgbG9vcCBpdGVyYXRpb24gYXMNCj4gZWl0
aGVyID09IDAgb24gb25lIGJyYW5jaCBvciAoMCwgaW5mKSBvbiBhbm90aGVyIGJyYW5jaCwgYWZ0
ZXIgd2hpY2gNCj4gYWxsIHN1YnNlcXVlbnQgaXRlcmF0aW9ucyB3aWxsIG5vdCBicmFuY2ggYXQg
YWxsIChvbmUgb3IgdGhlIG90aGVyDQo+IGJyYW5jaCB3aWxsIGJlIGFsd2F5cyB0YWtlbikuDQo+
IA0KPiBJdCdzIGFsc28gcG9zc2libGUgdGhhdCBMTFZNL0NsYW5nIGlzIHNtYXJ0IGVub3VnaCBh
bHJlYWR5IHRvIGZpZ3VyZQ0KPiB0aGlzIG91dCBvbiBpdHMgb3duIGFuZCBvcHRpbWl6ZSBsb29w
IGludG8uDQo+IA0KPiANCj4gaWYgKHNrYi0+bGVuKSB7DQo+ICAgICAgZm9yIChpID0gMDsgaSA8
IDIwOyBpKyspDQo+ICAgICAgICAgIHJldCB8PSAxIDw8IGk7DQo+IH0NCg0KV2UgaGF2ZQ0KICAg
IHZvbGF0aWxlIHN0cnVjdCBfX3NrX2J1ZmYqIHNrYg0KDQpTbyBmcm9tIHRoZSBzb3VyY2UgY29k
ZSwgc2tiLT5sZW4gY291bGQgYmUgZGlmZmVyZW50IGZvciBlYWNoDQppdGVyYXRpb24uIFRoZSBj
b21waWxlciBjYW5ub3QgZG8gdGhlIGFib3ZlIG9wdGltaXphdGlvbi4NCg0KPiANCj4gDQo+IFNv
IHR3byBjb21wbGFpbnM6DQo+IA0KPiAxLiBMZXQncyBvYmZ1c2NhdGUgdGhpcyBhIGJpdCBtb3Jl
LCBlLmcuLCB3aXRoIHRlc3RpbmcgKHNrYi0+bGVuICYNCj4gKDE8PGkpKSBpbnN0ZWFkLCBzbyB0
aGF0IHJlc3VsdCByZWFsbHkgZGVwZW5kcyBvbiBhY3R1YWwgbGVuZ3RoIG9mIHRoZQ0KPiBwYWNr
ZXQuDQo+IDIuIElzIGl0IHBvc3NpYmxlIHRvIHNvbWVob3cgdHVybiBvZmYgdGhpcyBwcmVjaXNp
b24gdHJhY2tpbmcgKGUuZy4sDQo+IHJ1bm5pbmcgbm90IHVuZGVyIHJvb3QsIG1heWJlPykgYW5k
IHNlZSB0aGF0IHRoaXMgc2FtZSBwcm9ncmFtIGZhaWxzDQo+IGluIHRoYXQgY2FzZT8gVGhhdCB3
YXkgd2UnbGwga25vdyB0ZXN0IGFjdHVhbGx5IHZhbGlkYXRlcyB3aGF0IHdlDQo+IHRoaW5rIGl0
IHZhbGlkYXRlcy4NCj4gDQo+IFRob3VnaHRzPw0KPiANCj4+ICsgICAgICAgcmV0dXJuIHJldDsN
Cj4+ICt9DQo+PiAtLQ0KPj4gMi4yMC4wDQo+Pg0K
