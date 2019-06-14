Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680B145481
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfFNGNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:13:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47032 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbfFNGNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 02:13:06 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5E694ir024525;
        Thu, 13 Jun 2019 23:12:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rjNuTit39hbgafCT6OKI6n8b4mDjXsoZF/92uXdy8UY=;
 b=YdnT4EWII2mHrgIFcj48O1h06kcR5SHlPIJXyvKYnGjHtbyJt3KBDL1v9W6vBhNJZaeY
 /yEuGK+wOfmG5XLsz/jWXa3UyFegbMMs03uvTGz2HagQoIeJD6HdL/AwUr8Cfwas6nAd
 WT+JMOkMhsiM+/NkQV+zNjL19K655Fi3NNI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3ru7jjk5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 23:12:39 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 23:12:31 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 13 Jun 2019 23:12:31 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 23:12:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjNuTit39hbgafCT6OKI6n8b4mDjXsoZF/92uXdy8UY=;
 b=P7xt8ogTAonEfGe007E7a+bY1PHSj+NtePT/2nfNxCIDmF/IWP8BI4rDMbZUSigGA4TYTCtdSbfzCuq9sspUHVsQ+wMGC82PaN73wBbMt7wLBaEWFML/TarFGSOvEUEBuFs0P+oq0UsPeFojSmRlSm+OYUX4GYJhe5rBY0Vcszk=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3352.namprd15.prod.outlook.com (20.179.58.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Fri, 14 Jun 2019 06:12:30 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 06:12:30 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/9] bpf: extend is_branch_taken to registers
Thread-Topic: [PATCH bpf-next 3/9] bpf: extend is_branch_taken to registers
Thread-Index: AQHVIZ9SJE68G0KurUarnkGNuwuevqaaKomAgACCfYA=
Date:   Fri, 14 Jun 2019 06:12:29 +0000
Message-ID: <14369865-bb37-20d8-8c56-e68a89263e5d@fb.com>
References: <20190613042003.3791852-1-ast@kernel.org>
 <20190613042003.3791852-4-ast@kernel.org>
 <CAEf4BzZ0Dt-3hdCnSWtFGc0Yob5N2C8QgGAB=PwC5OgZMVEtsQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0Dt-3hdCnSWtFGc0Yob5N2C8QgGAB=PwC5OgZMVEtsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0053.namprd22.prod.outlook.com
 (2603:10b6:300:12a::15) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:f6f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be642e81-6510-414e-f8d7-08d6f08f478e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3352;
x-ms-traffictypediagnostic: BYAPR15MB3352:
x-microsoft-antispam-prvs: <BYAPR15MB33521AD8D4D73BC097694A1AD7EE0@BYAPR15MB3352.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(396003)(346002)(376002)(189003)(199004)(66946007)(54906003)(6116002)(36756003)(68736007)(6486002)(229853002)(7736002)(5660300002)(110136005)(66476007)(66556008)(99286004)(6436002)(73956011)(305945005)(66446008)(64756008)(316002)(8676002)(81156014)(6512007)(71190400001)(71200400001)(8936002)(52116002)(81166006)(53936002)(478600001)(46003)(102836004)(31686004)(6246003)(186003)(4326008)(31696002)(486006)(86362001)(2906002)(14444005)(256004)(446003)(11346002)(476003)(2616005)(14454004)(25786009)(53546011)(7416002)(6506007)(386003)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3352;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SoDWSYTLYuOr9MruWZ28yh5k6+yfMpFamP2+UrYQVrhQ/UgUZ45TvFczC0hzgUpbPvmilXHfNj2QAvtWjnFiHcpZNZlwMUzgbK2fqVwdWuJLlwxcazqs1XacaciWijL3Zl1aHRCiO2E2zEuG5bFZXBV30DTh4lizTHIYdVJ8ttpVTxNkpI10qnC/U9oWuG05A+1+UuCHj5JlN0OOVOWCB0JJybhjo+1kPa/eUe44EaQEWSCElkpvlOh+Pmqpp2daFfvPtlypXI6REigw8EzA1wFNbxYizTQgqxHvkoVXCpXNWQ4FuBZKLzRiCpvuCFos+iWsTKmYcPjHlQVxVWSUM0na2gZefxYTr9RvNN9kPAQfGa6fXnOp3uehPjnaHyMZMiQmqlhLQg7uFCs/iwHY7eGg+2yNOGsLUcEwy/z8yM0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F74607607D0674894DE859CA27DA5CE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: be642e81-6510-414e-f8d7-08d6f08f478e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 06:12:29.7491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3352
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xMy8xOSAzOjI1IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIFRodSwgSnVu
IDEzLCAyMDE5IGF0IDk6NTAgQU0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gVGhpcyBwYXRjaCBleHRlbmRzIGlzX2JyYW5jaF90YWtlbigpIGxvZ2lj
IGZyb20gSk1QK0sgaW5zdHJ1Y3Rpb25zDQo+PiB0byBKTVArWCBpbnN0cnVjdGlvbnMuDQo+PiBD
b25kaXRpb25hbCBicmFuY2hlcyBhcmUgb2Z0ZW4gZG9uZSB3aGVuIHNyYyBhbmQgZHN0IHJlZ2lz
dGVycw0KPj4gY29udGFpbiBrbm93biBzY2FsYXJzLiBJbiBzdWNoIGNhc2UgdGhlIHZlcmlmaWVy
IGNhbiBmb2xsb3cNCj4+IHRoZSBicmFuY2ggdGhhdCBpcyBnb2luZyB0byBiZSB0YWtlbiB3aGVu
IHByb2dyYW0gZXhlY3V0ZXMgb24gQ1BVLg0KPj4gVGhhdCBzcGVlZHMgdXAgdGhlIHZlcmlmaWNh
dGlvbiBhbmQgZXNzZW50aWFsIGZlYXR1cmUgdG8gc3VwcG9ydA0KPiANCj4gdHlwbzogYW5kICpp
cyogZXNzZW50aWFsDQo+IA0KPj4gYm91bmRlZCBsb29wcy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5
OiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgIGtlcm5l
bC9icGYvdmVyaWZpZXIuYyB8IDE2ICsrKysrKysrKysrKystLS0NCj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDEzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2tlcm5lbC9icGYvdmVyaWZpZXIuYyBiL2tlcm5lbC9icGYvdmVyaWZpZXIuYw0KPj4gaW5kZXgg
YTIxYmFmZDdkOTMxLi5jNzljMDk1ODZhOWUgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwvYnBmL3Zl
cmlmaWVyLmMNCj4+ICsrKyBiL2tlcm5lbC9icGYvdmVyaWZpZXIuYw0KPj4gQEAgLTUyNjMsMTAg
KzUyNjMsMTEgQEAgc3RhdGljIGludCBjaGVja19jb25kX2ptcF9vcChzdHJ1Y3QgYnBmX3Zlcmlm
aWVyX2VudiAqZW52LA0KPj4gICAgICAgICAgc3RydWN0IGJwZl92ZXJpZmllcl9zdGF0ZSAqdGhp
c19icmFuY2ggPSBlbnYtPmN1cl9zdGF0ZTsNCj4+ICAgICAgICAgIHN0cnVjdCBicGZfdmVyaWZp
ZXJfc3RhdGUgKm90aGVyX2JyYW5jaDsNCj4+ICAgICAgICAgIHN0cnVjdCBicGZfcmVnX3N0YXRl
ICpyZWdzID0gdGhpc19icmFuY2gtPmZyYW1lW3RoaXNfYnJhbmNoLT5jdXJmcmFtZV0tPnJlZ3M7
DQo+PiAtICAgICAgIHN0cnVjdCBicGZfcmVnX3N0YXRlICpkc3RfcmVnLCAqb3RoZXJfYnJhbmNo
X3JlZ3M7DQo+PiArICAgICAgIHN0cnVjdCBicGZfcmVnX3N0YXRlICpkc3RfcmVnLCAqb3RoZXJf
YnJhbmNoX3JlZ3MsICpzcmNfcmVnID0gTlVMTDsNCj4+ICAgICAgICAgIHU4IG9wY29kZSA9IEJQ
Rl9PUChpbnNuLT5jb2RlKTsNCj4+ICAgICAgICAgIGJvb2wgaXNfam1wMzI7DQo+PiAgICAgICAg
ICBpbnQgZXJyOw0KPj4gKyAgICAgICB1NjQgY29uZF92YWw7DQo+IA0KPiByZXZlcnNlIENocmlz
dG1hcyB0cmVlDQo+IA0KPj4NCj4+ICAgICAgICAgIC8qIE9ubHkgY29uZGl0aW9uYWwganVtcHMg
YXJlIGV4cGVjdGVkIHRvIHJlYWNoIGhlcmUuICovDQo+PiAgICAgICAgICBpZiAob3Bjb2RlID09
IEJQRl9KQSB8fCBvcGNvZGUgPiBCUEZfSlNMRSkgew0KPj4gQEAgLTUyOTAsNiArNTI5MSw3IEBA
IHN0YXRpYyBpbnQgY2hlY2tfY29uZF9qbXBfb3Aoc3RydWN0IGJwZl92ZXJpZmllcl9lbnYgKmVu
diwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGluc24tPnNyY19yZWcpOw0K
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUFDQ0VTOw0KPj4gICAgICAgICAg
ICAgICAgICB9DQo+PiArICAgICAgICAgICAgICAgc3JjX3JlZyA9ICZyZWdzW2luc24tPnNyY19y
ZWddOw0KPj4gICAgICAgICAgfSBlbHNlIHsNCj4+ICAgICAgICAgICAgICAgICAgaWYgKGluc24t
PnNyY19yZWcgIT0gQlBGX1JFR18wKSB7DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgdmVy
Ym9zZShlbnYsICJCUEZfSk1QL0pNUDMyIHVzZXMgcmVzZXJ2ZWQgZmllbGRzXG4iKTsNCj4+IEBA
IC01MzA2LDggKzUzMDgsMTEgQEAgc3RhdGljIGludCBjaGVja19jb25kX2ptcF9vcChzdHJ1Y3Qg
YnBmX3ZlcmlmaWVyX2VudiAqZW52LA0KPj4gICAgICAgICAgaXNfam1wMzIgPSBCUEZfQ0xBU1Mo
aW5zbi0+Y29kZSkgPT0gQlBGX0pNUDMyOw0KPj4NCj4+ICAgICAgICAgIGlmIChCUEZfU1JDKGlu
c24tPmNvZGUpID09IEJQRl9LKSB7DQo+PiAtICAgICAgICAgICAgICAgaW50IHByZWQgPSBpc19i
cmFuY2hfdGFrZW4oZHN0X3JlZywgaW5zbi0+aW1tLCBvcGNvZGUsDQo+PiAtICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXNfam1wMzIpOw0KPj4gKyAgICAgICAgICAg
ICAgIGludCBwcmVkOw0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgIGNvbmRfdmFsID0gaW5zbi0+
aW1tOw0KPj4gK2NoZWNrX3Rha2VuOg0KPj4gKyAgICAgICAgICAgICAgIHByZWQgPSBpc19icmFu
Y2hfdGFrZW4oZHN0X3JlZywgY29uZF92YWwsIG9wY29kZSwgaXNfam1wMzIpOw0KPj4NCj4+ICAg
ICAgICAgICAgICAgICAgaWYgKHByZWQgPT0gMSkgew0KPj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAvKiBvbmx5IGZvbGxvdyB0aGUgZ290bywgaWdub3JlIGZhbGwtdGhyb3VnaCAqLw0KPj4g
QEAgLTUzMTksNiArNTMyNCwxMSBAQCBzdGF0aWMgaW50IGNoZWNrX2NvbmRfam1wX29wKHN0cnVj
dCBicGZfdmVyaWZpZXJfZW52ICplbnYsDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICov
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+PiAgICAgICAgICAgICAg
ICAgIH0NCj4+ICsgICAgICAgfSBlbHNlIGlmIChCUEZfU1JDKGluc24tPmNvZGUpID09IEJQRl9Y
ICYmDQo+PiArICAgICAgICAgICAgICAgICAgc3JjX3JlZy0+dHlwZSA9PSBTQ0FMQVJfVkFMVUUg
JiYNCj4+ICsgICAgICAgICAgICAgICAgICB0bnVtX2lzX2NvbnN0KHNyY19yZWctPnZhcl9vZmYp
KSB7DQo+PiArICAgICAgICAgICAgICAgY29uZF92YWwgPSBzcmNfcmVnLT52YXJfb2ZmLnZhbHVl
Ow0KPj4gKyAgICAgICAgICAgICAgIGdvdG8gY2hlY2tfdGFrZW47DQo+PiAgICAgICAgICB9DQo+
IA0KPiBUbyBlbGltaW5hdGUgZ290bywgaG93IGFib3V0IHRoaXM7DQo+IA0KPiBpbnQgcHJlZCA9
IC0xOw0KPiANCj4gaWYgKEJQRl9TUkMoaW5zbi0+Y29kZSkgPT0gQlBGX0spDQo+ICAgICAgICAg
ICBwcmVkID0gaXNfYnJhbmNoX3Rha2VuKGRzdF9yZWcsIGluc24tPmltbSwgb3Bjb2RlLCBpc19q
bXAzMik7DQo+IGVsc2UgaWYgKEJQRl9TUkMoaW5zbi0+Y29kZSkgPT0gQlBGX1ggJiYNCj4gICAg
ICAgICAgICAgICAgICAgc3JjX3JlZy0+dHlwZSA9PSBTQ0FMQVJfVkFMVUUgJiYNCj4gICAgICAg
ICAgICAgICAgICAgdG51bV9pc19jb25zdChzcmNfcmVnLT52YXJfb2ZmKQ0KPiAgICAgICAgICAg
cHJlZCA9IGlzX2JyYW5jaF90YWtlbihkc3RfcmVnLCBzcmNfcmVnLT52YXJfb2ZmLnZhbHVlLA0K
PiBvcGNvZGUsIGlzX2ptcDMyKTsNCj4gDQo+IC8qIGhlcmUgZG8gcHJlZCA9PSAxIGFuZCBwcmVk
ID09IDAgc3BlY2lhbCBoYW5kbGluZywgb3RoZXJ3aXNlIGZhbGwtdGhyb3VnaCAqLw0KPiANCj4g
QWdhaW4sIG1vcmUgbGluZWFyIGFuZCBubyB1bm5lY2Vzc2FyeSBnb3Rvcy4gcHJlZCA9PSAtMSBo
YXMgYWxyZWFkeSBhDQo+IG1lYW5pbmcgb2YgImRvbid0IGtub3csIGhhdmUgdG8gdHJ5IGJvdGgi
Lg0KDQpzdXJlLiBzaG91bGQgd29yay4NCg==
