Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2742683E15
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHGABW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:01:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726085AbfHGABW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:01:22 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x76NvjKc008307;
        Tue, 6 Aug 2019 17:01:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1axxaCt1IMsynNjcCWcGqUURirBKjr9GdSBLx4ghe9Q=;
 b=bX5Sat7Q8HcimBq2e8G1/dYVdUClSYp8chhRcwzaZiH5WaZtvSIKT+iKUKrSYg+7qn9t
 rPO5xdgzM3fRDprSY7VgirBqApzv6BHlp6ZasPP6DVMZ0psCzlgzT8koTlLKtcqOs84d
 YfAGf76O7bJxsXDo9Ao5Zkq3optyyZEw/8w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u7an3j7yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Aug 2019 17:00:59 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 17:00:59 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 6 Aug 2019 17:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/7xcafjcY6A1Iw3uL1L3+GqsIJflBi+qMKzxoaMydLXfk8IxznCPg1Vc3Rd6736DA+U/KK9vU7IfcngLMWLTiEt9poXwJ8DZU65Zg/V9m+zKJxbkRN3Yczfc2FNza2C/jyxAeg59SCMWqmAajhCf0J/zUBctzCqso8LMwG3buTmjYAvB44Rx3NUCOgTw+OoMFXJ2VuM/KJKpSvpOhtsbci24IvKT7GW82bWsudpKGtEZorJDf/4jLlB6gAdsqlCK4G355vN90hVWfNKdtfSXDMOwHEsdQNR3ZLHDvFAbPoHqRdOJJ/CHby71b4728EofoQ+TDutBBMv8yn0bhWohw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1axxaCt1IMsynNjcCWcGqUURirBKjr9GdSBLx4ghe9Q=;
 b=MR6UqIUWkRd9MoTd0RHkQ7vq3L5crnP0fRZQ4CcZrq+Jsmvjz4QJWeVVIagc9eBtB0Gz8b3scYPbqVHHTPD2T6vjK4qaP7HsCO6psyTPe/qiL4EvEuj97HVAFTwZMtMwZH4p1++Q1o3lzQd0B5vCpDQ1dcE12MpIBgnaLLi1ToqMINBh75ZJmU4IX2fFhr5pkdx9Ccmu3xsSj5tDjxtSrIkYRoXrXhyVf7oHfJx/LGC4u8sgTjwMztkb9Mbcsm2lypii2l1aoNtbUG3a72O0MKwh/e/04bX9GmczIjMfIQFPbS/YhQ0vUlTN1Q4JF+1Wp4H0dUmLdMYYnoGFrmq7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1axxaCt1IMsynNjcCWcGqUURirBKjr9GdSBLx4ghe9Q=;
 b=de9tqR1JzIbNfQenL5WRxKtZOhnK3HZ0LYCeMEhIifYZHxLUt37l4URr3iqftfuPmvbSVdnM7C0KHDJvO3ibt666TWqB6KmtNEPBMI7aU/4dR0KiRZcWLuE3Iz1zWWNNuUYytCGeWhTctkQNFNpEdyzV0Hu+gAIi5GbGmlyeH/U=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1613.namprd15.prod.outlook.com (10.175.139.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 7 Aug 2019 00:00:57 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.011; Wed, 7 Aug 2019
 00:00:57 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVTJuYHTgXpcglwkmoKo5MNz+oeabuq2UAgAAhwAA=
Date:   Wed, 7 Aug 2019 00:00:57 +0000
Message-ID: <cf9bfd8b-c959-cc97-6965-bda9e19ada72@fb.com>
References: <20190806210931.3723590-1-taoren@fb.com>
 <36d81485-ec23-eb7b-583e-3dd0f90ca562@gmail.com>
In-Reply-To: <36d81485-ec23-eb7b-583e-3dd0f90ca562@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0057.namprd11.prod.outlook.com
 (2603:10b6:a03:80::34) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::cfa4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1c5cd21-b96e-4596-5461-08d71aca52f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1613;
x-ms-traffictypediagnostic: MWHPR15MB1613:
x-microsoft-antispam-prvs: <MWHPR15MB161312CCBE15484818D0D499B2D40@MWHPR15MB1613.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(136003)(376002)(346002)(189003)(199004)(76176011)(31696002)(2616005)(31686004)(71200400001)(8936002)(71190400001)(8676002)(11346002)(6512007)(53936002)(68736007)(25786009)(81166006)(316002)(446003)(2201001)(81156014)(86362001)(58126008)(102836004)(7416002)(2501003)(186003)(99286004)(53546011)(65826007)(6506007)(52116002)(5660300002)(46003)(486006)(256004)(36756003)(14454004)(6436002)(2906002)(66556008)(476003)(66476007)(66946007)(64126003)(64756008)(229853002)(110136005)(478600001)(305945005)(386003)(6116002)(66446008)(65956001)(6246003)(65806001)(6486002)(7736002)(14444005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1613;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dONUi+tQMysH5KpFEr+Tkj/WiNJiQMFC21svcDxm9Sbu0Tg750e65xjmMaf2vZ0Gxpntdw2tQKEnIlCBY026VtwRBC2wveVn+NGwpiG0EeKHEgVyjs/lP9GvJz9g9boaC74JK3LCdy7M3EgGRDmGGj7wqSB55MJTjgehyUekN75k4CiRxIc9PlPo0ForC6/6oEKfxO8Qbary8CXvsBjwd8UwvhpFnLNZde4j2bwiVRpqA2lbSVkJQQaAqKF0/9w+FIR2T8m12E22046IbT1DDmLMKBn3ORympBel0yNguVQNED1xQYkXdPuAYQGLP6SnBxMtiSvnjQ0Ii1WQEShLM2EoKVuYclyMzHX6W1I2DntKAJyafI1tIy5y74lRhOVN5Ei9F+G/fPCrhA6kTBlTl0Jah5bfM7Gx4YEeaTSLK0A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3636D42BB3DB3B4FAFF973EE38EBBD74@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c5cd21-b96e-4596-5461-08d71aca52f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 00:00:57.6253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jlqHkFJD/TXXt587ATM0KrSrQAMsS3vr2DnHaG3mv+DOunTAPUcT1RmJoquRIyPT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1613
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060210
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC82LzE5IDM6MDAgUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMDYuMDguMjAx
OSAyMzowOSwgVGFvIFJlbiB3cm90ZToNCj4+IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3Jr
IHByb3Blcmx5IGluIFJHTUlJLT4xMDAwQmFzZS1LWCBtb2RlIChmb3INCj4+IGV4YW1wbGUsIG9u
IEZhY2Vib29rIENNTSBCTUMgcGxhdGZvcm0pLCBtYWlubHkgYmVjYXVzZSBnZW5waHkgZnVuY3Rp
b25zDQo+PiBhcmUgZGVzaWduZWQgZm9yIGNvcHBlciBsaW5rcywgYW5kIDEwMDBCYXNlLVggKGNs
YXVzZSAzNykgYXV0byBuZWdvdGlhdGlvbg0KPj4gbmVlZHMgdG8gYmUgaGFuZGxlZCBkaWZmZXJl
bnRseS4NCj4+DQo+PiBUaGlzIHBhdGNoIGVuYWJsZXMgMTAwMEJhc2UtWCBzdXBwb3J0IGZvciBC
Q001NDYxNlMgYnkgY3VzdG9taXppbmcgMw0KPj4gZHJpdmVyIGNhbGxiYWNrczoNCj4+DQo+PiAg
IC0gcHJvYmU6IHByb2JlIGNhbGxiYWNrIGRldGVjdHMgUEhZJ3Mgb3BlcmF0aW9uIG1vZGUgYmFz
ZWQgb24NCj4+ICAgICBJTlRFUkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0
aW9uIGJpdCBpbiBTZXJERVMgMTAwLUZYDQo+PiAgICAgQ29udHJvbCByZWdpc3Rlci4NCj4+DQo+
PiAgIC0gY29uZmlnX2FuZWc6IGJjbTU0NjE2c19jb25maWdfYW5lZ18xMDAwYnggZnVuY3Rpb24g
aXMgYWRkZWQgZm9yIGF1dG8NCj4+ICAgICBuZWdvdGlhdGlvbiBpbiAxMDAwQmFzZS1YIG1vZGUu
DQo+Pg0KPj4gICAtIHJlYWRfc3RhdHVzOiBCQ001NDYxNlMgYW5kIEJDTTU0ODIgUEhZIHNoYXJl
IHRoZSBzYW1lIHJlYWRfc3RhdHVzDQo+PiAgICAgY2FsbGJhY2sgd2hpY2ggbWFudWFsbHkgc2V0
IGxpbmsgc3BlZWQgYW5kIGR1cGxleCBtb2RlIGluIDEwMDBCYXNlLVgNCj4+ICAgICBtb2RlLg0K
Pj4NCj4+IFNpZ25lZC1vZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+DQo+PiAtLS0NCj4+
ICBDaGFuZ2VzIGluIHY0Og0KPj4gICAtIGFkZCBiY201NDYxNnNfY29uZmlnX2FuZWdfMTAwMGJ4
KCkgdG8gZGVhbCB3aXRoIGF1dG8gbmVnb3RpYXRpb24gaW4NCj4+ICAgICAxMDAwQmFzZS1YIG1v
ZGUuDQo+PiAgQ2hhbmdlcyBpbiB2MzoNCj4+ICAgLSByZW5hbWUgYmNtNTQ4Ml9yZWFkX3N0YXR1
cyB0byBiY201NHh4X3JlYWRfc3RhdHVzIHNvIHRoZSBjYWxsYmFjayBjYW4NCj4+ICAgICBiZSBz
aGFyZWQgYnkgQkNNNTQ4MiBhbmQgQkNNNTQ2MTZTLg0KPj4gIENoYW5nZXMgaW4gdjI6DQo+PiAg
IC0gQXV0by1kZXRlY3QgUEhZIG9wZXJhdGlvbiBtb2RlIGluc3RlYWQgb2YgcGFzc2luZyBEVCBu
b2RlLg0KPj4gICAtIG1vdmUgUEhZIG1vZGUgYXV0by1kZXRlY3QgbG9naWMgZnJvbSBjb25maWdf
aW5pdCB0byBwcm9iZSBjYWxsYmFjay4NCj4+ICAgLSBvbmx5IHNldCBzcGVlZCAobm90IGluY2x1
ZGluZyBkdXBsZXgpIGluIHJlYWRfc3RhdHVzIGNhbGxiYWNrLg0KPj4gICAtIHVwZGF0ZSBwYXRj
aCBkZXNjcmlwdGlvbiB3aXRoIG1vcmUgYmFja2dyb3VuZCB0byBhdm9pZCBjb25mdXNpb24uDQo+
PiAgIC0gcGF0Y2ggIzEgaW4gdGhlIHNlcmllcyAoIm5ldDogcGh5OiBicm9hZGNvbTogc2V0IGZl
YXR1cmVzIGV4cGxpY2l0bHkNCj4+ICAgICBmb3IgQkNNNTQ2MTYiKSBpcyBkcm9wcGVkOiB0aGUg
Zml4IHNob3VsZCBnbyB0byBnZXRfZmVhdHVyZXMgY2FsbGJhY2sNCj4+ICAgICB3aGljaCBtYXkg
cG90ZW50aWFsbHkgZGVwZW5kIG9uIHRoaXMgcGF0Y2guDQo+Pg0KPj4gIGRyaXZlcnMvbmV0L3Bo
eS9icm9hZGNvbS5jIHwgNjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0N
Cj4+ICBpbmNsdWRlL2xpbnV4L2JyY21waHkuaCAgICB8IDEwICsrKystLQ0KPj4gIDIgZmlsZXMg
Y2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvcGh5L2Jyb2FkY29tLmMgYi9kcml2ZXJzL25ldC9waHkvYnJvYWRj
b20uYw0KPj4gaW5kZXggOTM3ZDAwNTllOGFjLi5iZjYxZWQ4NDUxZTUgMTAwNjQ0DQo+PiAtLS0g
YS9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L2Jy
b2FkY29tLmMNCj4+IEBAIC0zODMsOSArMzgzLDkgQEAgc3RhdGljIGludCBiY201NDgyX2NvbmZp
Z19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgCQkvKg0KPj4gIAkJICogU2Vs
ZWN0IDEwMDBCQVNFLVggcmVnaXN0ZXIgc2V0IChwcmltYXJ5IFNlckRlcykNCj4+ICAJCSAqLw0K
Pj4gLQkJcmVnID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0ODJfU0hEX01PREUp
Ow0KPj4gLQkJYmNtX3BoeV93cml0ZV9zaGFkb3cocGh5ZGV2LCBCQ001NDgyX1NIRF9NT0RFLA0K
Pj4gLQkJCQkgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsNCj4+ICsJCXJlZyA9
IGJjbV9waHlfcmVhZF9zaGFkb3cocGh5ZGV2LCBCQ001NFhYX1NIRF9NT0RFKTsNCj4+ICsJCWJj
bV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSwNCj4+ICsJCQkJICAg
ICByZWcgfCBCQ001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+PiAgDQo+PiAgCQkvKg0KPj4gIAkJ
ICogTEVEMT1BQ1RJVklUWUxFRCwgTEVEMz1MSU5LU1BEWzJdDQo+PiBAQCAtNDA5LDcgKzQwOSw3
IEBAIHN0YXRpYyBpbnQgYmNtNTQ4Ml9jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5
ZGV2KQ0KPj4gIAlyZXR1cm4gZXJyOw0KPj4gIH0NCj4+ICANCj4+IC1zdGF0aWMgaW50IGJjbTU0
ODJfcmVhZF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICtzdGF0aWMgaW50
IGJjbTU0eHhfcmVhZF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICB7DQo+
PiAgCWludCBlcnI7DQo+PiAgDQo+PiBAQCAtNDUxLDEyICs0NTEsNjAgQEAgc3RhdGljIGludCBi
Y201NDgxX2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgCXJldHVy
biByZXQ7DQo+PiAgfQ0KPj4gIA0KPj4gK3N0YXRpYyBpbnQgYmNtNTQ2MTZzX3Byb2JlKHN0cnVj
dCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0KPj4gKwlpbnQgdmFsLCBpbnRmX3NlbDsNCj4+
ICsNCj4+ICsJdmFsID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01P
REUpOw0KPj4gKwlpZiAodmFsIDwgMCkNCj4+ICsJCXJldHVybiB2YWw7DQo+PiArDQo+PiArCS8q
IFRoZSBQSFkgaXMgc3RyYXBwZWQgaW4gUkdNSUkgdG8gZmliZXIgbW9kZSB3aGVuIElOVEVSRl9T
RUxbMTowXQ0KPj4gKwkgKiBpcyAwMWIuDQo+PiArCSAqLw0KPj4gKwlpbnRmX3NlbCA9ICh2YWwg
JiBCQ001NFhYX1NIRF9JTlRGX1NFTF9NQVNLKSA+PiAxOw0KPj4gKwlpZiAoaW50Zl9zZWwgPT0g
MSkgew0KPj4gKwkJdmFsID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0NjE2U19T
SERfMTAwRlhfQ1RSTCk7DQo+PiArCQlpZiAodmFsIDwgMCkNCj4+ICsJCQlyZXR1cm4gdmFsOw0K
Pj4gKw0KPj4gKwkJLyogQml0IDAgb2YgdGhlIFNlckRlcyAxMDAtRlggQ29udHJvbCByZWdpc3Rl
ciwgd2hlbiBzZXQNCj4+ICsJCSAqIHRvIDEsIHNldHMgdGhlIE1JSS9SR01JSSAtPiAxMDBCQVNF
LUZYIGNvbmZpZ3VyYXRpb24uDQo+PiArCQkgKiBXaGVuIHRoaXMgYml0IGlzIHNldCB0byAwLCBp
dCBzZXRzIHRoZSBHTUlJL1JHTUlJIC0+DQo+PiArCQkgKiAxMDAwQkFTRS1YIGNvbmZpZ3VyYXRp
b24uDQo+PiArCQkgKi8NCj4+ICsJCWlmICghKHZhbCAmIEJDTTU0NjE2U18xMDBGWF9NT0RFKSkN
Cj4+ICsJCQlwaHlkZXYtPmRldl9mbGFncyB8PSBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYOw0K
Pj4gKwl9DQo+PiArDQo+PiArCXJldHVybiAwOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgaW50
IGJjbTU0NjE2c19jb25maWdfYW5lZ18xMDAwYngoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikN
Cj4+ICt7DQo+PiArCWludCBlcnI7DQo+PiArCWludCBhZHYgPSAwOw0KPj4gKw0KPj4gKwlpZiAo
bGlua21vZGVfdGVzdF9iaXQoRVRIVE9PTF9MSU5LX01PREVfMTAwMGJhc2VYX0Z1bGxfQklULA0K
Pj4gKwkJCSAgICAgIHBoeWRldi0+c3VwcG9ydGVkKSkNCj4+ICsJCWFkdiB8PSBBRFZFUlRJU0Vf
MTAwMFhGVUxMOw0KPj4gKw0KPj4gKwllcnIgPSBwaHlfbW9kaWZ5X2NoYW5nZWQocGh5ZGV2LCBN
SUlfQURWRVJUSVNFLCAwLCBhZHYpOw0KPiANCj4gVGhlICIwIiBwYXJhbWV0ZXIgaXMgd3Jvbmcs
IGl0IG11c3QgYmUgQURWRVJUSVNFXzEwMDBYRlVMTC4NCj4gRmlyc3QgeW91IHJlc2V0IHRoZSBi
aXQsIGFuZCB0aGVuIHlvdSBzZXQgaXQgb3Igbm90Lg0KDQpHb3QgaXQuIFdpbGwgZml4IGl0IGlu
IHBhdGNoIHY1LiBUaGFua3MuDQoNCj4+ICsJaWYgKGVyciA+IDApDQo+PiArCQllcnIgPSBnZW5w
aHlfcmVzdGFydF9hbmVnKHBoeWRldik7DQo+PiArDQo+PiArCXJldHVybiBlcnI7DQo+PiArfQ0K
Pj4gKw0KPj4gIHN0YXRpYyBpbnQgYmNtNTQ2MTZzX2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXYpDQo+PiAgew0KPj4gIAlpbnQgcmV0Ow0KPj4gIA0KPj4gIAkvKiBBbmVnIGZp
cnNseS4gKi8NCj4+IC0JcmV0ID0gZ2VucGh5X2NvbmZpZ19hbmVnKHBoeWRldik7DQo+PiArCWlm
IChwaHlkZXYtPmRldl9mbGFncyAmIFBIWV9CQ01fRkxBR1NfTU9ERV8xMDAwQlgpDQo+PiArCQly
ZXQgPSBiY201NDYxNnNfY29uZmlnX2FuZWdfMTAwMGJ4KHBoeWRldik7DQo+PiArCWVsc2UNCj4+
ICsJCXJldCA9IGdlbnBoeV9jb25maWdfYW5lZyhwaHlkZXYpOw0KPj4gIA0KPj4gIAkvKiBUaGVu
IHdlIGNhbiBzZXQgdXAgdGhlIGRlbGF5LiAqLw0KPj4gIAliY201NHh4X2NvbmZpZ19jbG9ja19k
ZWxheShwaHlkZXYpOw0KPj4gQEAgLTY1NSw2ICs3MDMsOCBAQCBzdGF0aWMgc3RydWN0IHBoeV9k
cml2ZXIgYnJvYWRjb21fZHJpdmVyc1tdID0gew0KPj4gIAkuY29uZmlnX2FuZWcJPSBiY201NDYx
NnNfY29uZmlnX2FuZWcsDQo+PiAgCS5hY2tfaW50ZXJydXB0CT0gYmNtX3BoeV9hY2tfaW50ciwN
Cj4+ICAJLmNvbmZpZ19pbnRyCT0gYmNtX3BoeV9jb25maWdfaW50ciwNCj4+ICsJLnJlYWRfc3Rh
dHVzCT0gYmNtNTR4eF9yZWFkX3N0YXR1cywNCj4gDQo+IElmIHlvdSB1c2UgYW5lZywgeW91IHNo
b3VsZCBhbHNvIHJlYWQgd2hhdCB3YXMgbmVnb3RpYXRlZC4NCj4gQnV0IHRoaXMgZnVuY3Rpb24g
cmVhZHMgbmVpdGhlciBuZWdvdGlhdGVkIGR1cGxleCBtb2RlIG5vcg0KPiBwYXVzZSBzZXR0aW5n
cy4NCg0KTGV0IG1lIHNlZSBob3cgdG8gZml4IGl0Li4gV2lsbCBjb21lIGJhY2sgc29vbi4uDQoN
Cg0KVGhhbmtzLA0KDQpUYW8NCg==
