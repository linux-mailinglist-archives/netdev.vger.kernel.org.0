Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85067DCA47
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394089AbfJRQHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:07:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14376 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbfJRQHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:07:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IG3oob032545;
        Fri, 18 Oct 2019 09:07:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NodH2Aox7lBLT3WGBsijbLWD3ay2rBK4cesH1Iifj9g=;
 b=Dc3TwnrWt6K7gwKOt6+cNM32RTHvgQZr7LmRM4E/neDXUZsJC1nMbLRCDgtbvDcg1ywK
 12gmZINBxoa+9igD/Fwaee7hxy1As8SMNL8/I6UmRR/lMx6v/KCxQC4UhpBtMciqtolg
 HvAJnP0eRlFig2671FcHYWHkhOe6A8GIZP4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpw9rcfus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Oct 2019 09:07:04 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 09:07:04 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:07:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWFfJJE00+exIm+XZnkiUO0H3JXWyFHDnDp7qxIg1ReE3Iz7gFX0RRArWM4MkGjUh36ggaN/GaoLbmgkC3ssllWlEOVMv73utpW7t2fj6MMjya0kJ3crb0JYiQoWPBMnbUJ7SLBaN0wacliqUZGgL2GZATGF5p5n5nGOF51kgj/yvzD8Jvtgqdx8dGsH687eNho0myUPn16UmLNefl8aCgySeDRy0sUff0zdyjH4JHswic4gCafa0UvPjG6wWm0ioG1J6NKcBKWy2jU/TvLpyDlB18hMMWwJUf59YU3sa3LMTQEA0A0HHcgi+iDQrVL3dqdHtUGNcSCLQkwcW5EB7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NodH2Aox7lBLT3WGBsijbLWD3ay2rBK4cesH1Iifj9g=;
 b=Rm3hAdhnwdzHyDPFg5WNfQ37u1B2oB++syPflwAn3fY+V0BQxrOduTX/n1+3GythCVDRUHMQKUOCoKG14R9Ex5qGCALxjgEma6q0XGJd0VaUj2R/cTHjiLRG43Le8gWQCkByP3ZPPvxCuuuBqAK5SYHZetlNWr8z7GVWgsf+udLbMwqtsT+Q36wKM1fcIRizluuAwESqYc8+cYszjmzGyPRDwOc0+IxhKDcyfnp9LmxgenMpKD2HJpHYFH+pcAVCe8ez8wAh9m8VPoCAyg6xdd85wGeINgs//Z/3B2zZvWfPi3Ka3h5d5GR0sgI5sgCUDK2OaRJjBi5SK3OaBOaMpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NodH2Aox7lBLT3WGBsijbLWD3ay2rBK4cesH1Iifj9g=;
 b=cWPEHunqeHt5PaxrALyIZo4SRoIdOjP4m6TRMFzFcwp0PTcspm6cumVwn7IbJcwU8jyyoAuiLJ0mmlaO9kqNv92jQKdQ9XOWG9SjhLrNZ1SbnFTRmFOuMC6l9H+ySCiLjSomLWKRNqK5QyaanMQ1mbbt8Yq/hFwt3Hm4Edz/57Y=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2966.namprd15.prod.outlook.com (20.178.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 16:07:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 16:07:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Zwb <ethercflow@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file
 descriptor to a pathname
Thread-Topic: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file
 descriptor to a pathname
Thread-Index: AQHVhM0LV4pB8c5eRUG6NpzI4t6LF6dgkn6A
Date:   Fri, 18 Oct 2019 16:07:01 +0000
Message-ID: <abad45da-99a9-cb13-7414-60de5315de82@fb.com>
References: <20191017092631.3739-1-ethercflow@gmail.com>
In-Reply-To: <20191017092631.3739-1-ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:301:4b::34) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3147f1b7-c83c-4851-2a85-08d753e53619
x-ms-traffictypediagnostic: BYAPR15MB2966:
x-microsoft-antispam-prvs: <BYAPR15MB2966BE42AB06C7BF908D943ED36C0@BYAPR15MB2966.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(6512007)(6246003)(186003)(66446008)(64756008)(66556008)(66946007)(71200400001)(71190400001)(102836004)(53546011)(6506007)(386003)(46003)(66476007)(99286004)(76176011)(229853002)(8676002)(52116002)(14454004)(31686004)(8936002)(81166006)(81156014)(36756003)(31696002)(6436002)(86362001)(2906002)(2501003)(305945005)(6116002)(7736002)(11346002)(478600001)(256004)(446003)(25786009)(486006)(476003)(110136005)(2616005)(316002)(14444005)(5660300002)(6486002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2966;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pNbSqKEahTctU2yA7M4eBTyuXhYCNk2TwG82uMCo/KLWuSfVO8F8aowBcxNXnssY0oZczfURE83hWpHmuqMjgRvNRpAAOm0ODa6ria7fV4SzgdRf22oZwwdcP4rQDbO8imaLazSV0Z0L9yMgrguwQYqEpuTmfkGSG9D8HaUkSJjvDciuBdYpsdGlXwHywrViGlrrnXHEuV+9SQvbj+fy3gDG/QCpccA3BK8X3yLpGpWPFH7Ek/+uXUghipbsfrFyqN7R9/s1zNRT7d3fjkOkf0viOr3NsrJPmWU38W62JDF8Jkb1OXRPOdQ8T64lnH8+qgbMM5gPFgz5vWiSTzG0jdR8Nzte3iuevb6tcpHN9r7VriKpQhpgE+aK82h7Klusj4l8Ee+y3owFx9JQAVsC56G68UmUS0bc5CGyPTvr71A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <415CD2536258EF4A95EE1EB297141873@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3147f1b7-c83c-4851-2a85-08d753e53619
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:07:01.9118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VudNpECZAfYbzpmIirtxlXgByPGfzwbU/jK6KxEP2qU4cSl0xVXVVDqSpOMiboqS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2966
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1011
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDI6MjYgQU0sIFp3YiB3cm90ZToNCj4gV2hlbiBwZW9wbGUgd2FudCB0
byBpZGVudGlmeSB3aGljaCBmaWxlIHN5c3RlbSBmaWxlcyBhcmUgYmVpbmcgb3BlbmVkLA0KPiBy
ZWFkLCBhbmQgd3JpdHRlbiB0bywgdGhleSBjYW4gdXNlIHRoaXMgaGVscGVyIHdpdGggZmlsZSBk
ZXNjcmlwdG9yIGFzDQo+IGlucHV0IHRvIGFjaGlldmUgdGhpcyBnb2FsLiBPdGhlciBwc2V1ZG8g
ZmlsZXN5c3RlbXMgYXJlIGFsc28gc3VwcG9ydGVkLg0KDQpGb3IgdGhlIGRlc2NyaXB0aW9uLCBh
IGxpbmsgdG8gcmVsYXRlZCBiY2MgaXNzdWUgbWF5IHByb3ZpZGUgbW9yZSANCmJhY2tncm91bmQg
d2h5IHRoaXMgaXMgbmVlZGVkLg0KDQpQbGVhc2Ugc2VuZCB0byBicGYgbWFpbGluZyBsaXN0IGJw
ZkB2Z2VyLmtlcm5lbC5vcmcuIFRoaXMgd2F5LCBtb3JlIA0KcGVvcGxlIGNhbiBjYXRjaCBhbmQg
bG9vayBhdCB0aGlzIHBhdGNoLg0KDQpQbGVhc2UgcHJvdmlkZSBhIHRlc3QgY2FzZSBpbiB0b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYgZGlyZWN0b3J5Lg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBad2IgPGV0aGVyY2Zsb3dAZ21haWwuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRlL2xpbnV4L2Jw
Zi5oICAgICAgICAgICAgfCAgMSArDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAg
IHwgIDEgKw0KPiAgIGtlcm5lbC9icGYvY29yZS5jICAgICAgICAgICAgICB8ICAxICsNCj4gICBr
ZXJuZWwvYnBmL2hlbHBlcnMuYyAgICAgICAgICAgfCAzOSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ICAga2VybmVsL3RyYWNlL2JwZl90cmFjZS5jICAgICAgIHwgIDIgKysN
Cj4gICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAgMSArDQo+ICAgNiBmaWxlcyBj
aGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9icGYuaCBiL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gaW5kZXggMjgyZTI4YmY0MWVjLi5jMGE3
MTBjZjJjODggMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gKysrIGIvaW5j
bHVkZS9saW51eC9icGYuaA0KPiBAQCAtMTA1NSw2ICsxMDU1LDcgQEAgZXh0ZXJuIGNvbnN0IHN0
cnVjdCBicGZfZnVuY19wcm90byBicGZfZ2V0X2xvY2FsX3N0b3JhZ2VfcHJvdG87DQo+ICAgZXh0
ZXJuIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfc3RydG9sX3Byb3RvOw0KPiAgIGV4
dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3N0cnRvdWxfcHJvdG87DQo+ICAg
ZXh0ZXJuIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfdGNwX3NvY2tfcHJvdG87DQo+
ICtleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9mZDJwYXRoX3Byb3RvOw0K
PiAgIA0KPiAgIC8qIFNoYXJlZCBoZWxwZXJzIGFtb25nIGNCUEYgYW5kIGVCUEYuICovDQo+ICAg
dm9pZCBicGZfdXNlcl9ybmRfaW5pdF9vbmNlKHZvaWQpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IGluZGV4IGE2
NWMzYjBjNjkzNS4uYTRhNWQ0MzJlNTcyIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmgNCj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0yNzY5LDYg
KzI3NjksNyBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ICAgCUZOKGdldF9jdXJyZW50X3BpZF90Z2lk
KSwJXA0KPiAgIAlGTihnZXRfY3VycmVudF91aWRfZ2lkKSwJXA0KPiAgIAlGTihnZXRfY3VycmVu
dF9jb21tKSwJCVwNCj4gKwlGTihmZDJwYXRoKSwJCQlcDQoNCkFzIERhbmllbCBtZW50aW9uZWQs
IHBsZWFzZSBwdXQgdGhpcyBhdCB0aGUgZW5kIG9mIGVudW0gdG8NCmF2b2lkIGJyZWFraW5nIGJh
Y2t3YXJkIGNvbXBhdGliaWxpdHkuIEFsc28gdGhpcyBuZWVkcyBwcm9wZXINCmRvY3VtZW50YXRp
b24uDQoNCj4gICAJRk4oZ2V0X2Nncm91cF9jbGFzc2lkKSwJCVwNCj4gICAJRk4oc2tiX3ZsYW5f
cHVzaCksCQlcDQo+ICAgCUZOKHNrYl92bGFuX3BvcCksCQlcDQo+IGRpZmYgLS1naXQgYS9rZXJu
ZWwvYnBmL2NvcmUuYyBiL2tlcm5lbC9icGYvY29yZS5jDQo+IGluZGV4IDY2MDg4YTllOWI5ZS4u
MzQ5YThiMWJlMjMyIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2NvcmUuYw0KPiArKysgYi9r
ZXJuZWwvYnBmL2NvcmUuYw0KPiBAQCAtMjA0Miw2ICsyMDQyLDcgQEAgY29uc3Qgc3RydWN0IGJw
Zl9mdW5jX3Byb3RvIGJwZl9nZXRfY3VycmVudF91aWRfZ2lkX3Byb3RvIF9fd2VhazsNCj4gICBj
b25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50X2NvbW1fcHJvdG8gX193
ZWFrOw0KPiAgIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfZ2V0X2N1cnJlbnRfY2dy
b3VwX2lkX3Byb3RvIF9fd2VhazsNCj4gICBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBm
X2dldF9sb2NhbF9zdG9yYWdlX3Byb3RvIF9fd2VhazsNCj4gK2NvbnN0IHN0cnVjdCBicGZfZnVu
Y19wcm90byBicGZfZmQycGF0aF9wcm90byBfX3dlYWs7DQo+ICAgDQo+ICAgY29uc3Qgc3RydWN0
IGJwZl9mdW5jX3Byb3RvICogX193ZWFrIGJwZl9nZXRfdHJhY2VfcHJpbnRrX3Byb3RvKHZvaWQp
DQo+ICAgew0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9oZWxwZXJzLmMgYi9rZXJuZWwvYnBm
L2hlbHBlcnMuYw0KPiBpbmRleCA1ZTI4NzE4OTI4Y2EuLjA4MzI1MzZjN2RkYiAxMDA2NDQNCj4g
LS0tIGEva2VybmVsL2JwZi9oZWxwZXJzLmMNCj4gKysrIGIva2VybmVsL2JwZi9oZWxwZXJzLmMN
Cj4gQEAgLTQ4NywzICs0ODcsNDIgQEAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9z
dHJ0b3VsX3Byb3RvID0gew0KPiAgIAkuYXJnNF90eXBlCT0gQVJHX1BUUl9UT19MT05HLA0KPiAg
IH07DQo+ICAgI2VuZGlmDQo+ICsNCj4gK0JQRl9DQUxMXzMoYnBmX2ZkMnBhdGgsIGNoYXIgKiwg
ZHN0LCB1MzIsIHNpemUsIGludCwgZmQpDQo+ICt7DQo+ICsJc3RydWN0IGZkIGY7DQo+ICsJaW50
IHJldDsNCj4gKwljaGFyICpwOw0KPiArDQo+ICsJcmV0ID0gc2VjdXJpdHlfbG9ja2VkX2Rvd24o
TE9DS0RPV05fQlBGX1JFQUQpOw0KPiArCWlmIChyZXQgPCAwKQ0KPiArCQlnb3RvIG91dDsNCg0K
VGhlIExPQ0tET1dOX0JQRl9SRUFEIGlzIHVzZWQgd2hlbiBrZXJuZWwgaW50ZXJuYWwgZGF0YSBp
cyBleHBvc2VkLg0KVGhhdCBpcyB3aHkgY3VycmVudGx5IG9ubHkgYnBmX3Byb2JlX3JlYWQoKSBh
bmQgYnBmX3Byb2JlX3JlYWRfc3RyKCkNCmFyZSBjaGVja2VkLg0KTm90IDEwMCUgc3VyZSB3aGV0
aGVyIHRoaXMgaGVscGVyIG5lZWRzIGNoZWNrIG9mIExPQ0tET1dOX0JQRl9SRUFEDQpvciBub3Qu
DQoNCj4gKw0KPiArCWYgPSBmZGdldF9yYXcoZmQpOw0KPiArCWlmICghZi5maWxlKQ0KPiArCQln
b3RvIG91dDsNCj4gKw0KPiArCXAgPSBkX3BhdGgoJmYuZmlsZS0+Zl9wYXRoLCBkc3QsIHNpemUp
Ow0KDQppbnNpZGUgZF9wYXRoLCBzcGluX2xvY2soKSBjb3VsZCBiZSBjYWxsZWQuIEkgZ3Vlc3Mg
aXQgaXMgb2theS4NCg0KPiArCWlmIChJU19FUlJfT1JfTlVMTChwKSkNCj4gKwkJcmV0ID0gUFRS
X0VSUihwKTsNCj4gKwllbHNlIHsNCj4gKwkJcmV0ID0gc3RybGVuKHApOw0KPiArCQltZW1tb3Zl
KGRzdCwgcCwgcmV0KTsNCj4gKwkJZHN0W3JldF0gPSAwOw0KPiArCX0NCj4gKw0KPiArCWlmICh1
bmxpa2VseShyZXQgPCAwKSkNCj4gK291dDoNCj4gKwkJbWVtc2V0KGRzdCwgJzAnLCBzaXplKTsN
Cg0KVGhlIGNvZGluZyBzdHlsZSBoZXJlIGlzIG5vdCBncmVhdC4gTWF5YmUgeW91IGNhbiBkbw0K
CWlmIChJU19FUlJfT1JfTlVMTChwKSkgew0KCQlyZXQgPSBQVFJFUlIocCk7DQoJCWdvdG8gZXJy
b3I7DQoJfQ0KDQoJcmV0ID0gc3RybGVuKHApOw0KCW1lbW1vdmUoZHN0LCBwLCByZXQpOw0KCWRz
dFtyZXRdID0gJ1wwJzsNCglyZXR1cm4gcmV0Ow0KDQogICAgZXJyb3I6DQoJbWVtc2V0KGRzdCwg
JzAnLCBzaXplKTsNCglyZXR1cm4gcmV0Ow0KDQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0K
PiArDQo+ICtjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2ZkMnBhdGhfcHJvdG8gPSB7
DQo+ICsJLmZ1bmMgICAgICAgPSBicGZfZmQycGF0aCwNCj4gKwkuZ3BsX29ubHkgICA9IHRydWUs
DQo+ICsJLnJldF90eXBlICAgPSBSRVRfSU5URUdFUiwNCj4gKwkuYXJnMV90eXBlICA9IEFSR19Q
VFJfVE9fVU5JTklUX01FTSwNCj4gKwkuYXJnMl90eXBlICA9IEFSR19DT05TVF9TSVpFLA0KPiAr
CS5hcmczX3R5cGUgID0gQVJHX0FOWVRISU5HLA0KPiArfTsNCj4gZGlmZiAtLWdpdCBhL2tlcm5l
bC90cmFjZS9icGZfdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPiBpbmRleCA0
NGJkMDhmMjQ0M2IuLjBjYTdmZGVmYjhlNSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL3RyYWNlL2Jw
Zl90cmFjZS5jDQo+ICsrKyBiL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPiBAQCAtNzM1LDYg
KzczNSw4IEBAIHRyYWNpbmdfZnVuY19wcm90byhlbnVtIGJwZl9mdW5jX2lkIGZ1bmNfaWQsIGNv
bnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4gICAjZW5kaWYNCj4gICAJY2FzZSBCUEZfRlVO
Q19zZW5kX3NpZ25hbDoNCj4gICAJCXJldHVybiAmYnBmX3NlbmRfc2lnbmFsX3Byb3RvOw0KPiAr
CWNhc2UgQlBGX0ZVTkNfZmQycGF0aDoNCj4gKwkJcmV0dXJuICZicGZfZmQycGF0aF9wcm90bzsN
Cj4gICAJZGVmYXVsdDoNCj4gICAJCXJldHVybiBOVUxMOw0KPiAgIAl9DQo+IGRpZmYgLS1naXQg
YS90b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi90b29scy9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmgNCj4gaW5kZXggYTY1YzNiMGM2OTM1Li5hNGE1ZDQzMmU1NzIgMTAwNjQ0DQo+IC0t
LSBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiArKysgYi90b29scy9pbmNsdWRl
L3VhcGkvbGludXgvYnBmLmgNCj4gQEAgLTI3NjksNiArMjc2OSw3IEBAIHVuaW9uIGJwZl9hdHRy
IHsNCj4gICAJRk4oZ2V0X2N1cnJlbnRfcGlkX3RnaWQpLAlcDQo+ICAgCUZOKGdldF9jdXJyZW50
X3VpZF9naWQpLAlcDQo+ICAgCUZOKGdldF9jdXJyZW50X2NvbW0pLAkJXA0KPiArCUZOKGZkMnBh
dGgpLAkJCVwNCj4gICAJRk4oZ2V0X2Nncm91cF9jbGFzc2lkKSwJCVwNCj4gICAJRk4oc2tiX3Zs
YW5fcHVzaCksCQlcDQo+ICAgCUZOKHNrYl92bGFuX3BvcCksCQlcDQo+IA0K
