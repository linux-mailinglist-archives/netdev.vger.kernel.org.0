Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A7FC09EB
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfI0Q7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:59:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727079AbfI0Q7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:59:46 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8RGhInM007992;
        Fri, 27 Sep 2019 09:59:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XKB0Wz6GqAElYU6QP/nozyo5jLKt/eOTWuYChBn200w=;
 b=dUojtPNVa4SKMPj6RAPGzoheEVwawNCmLqRe93RUr+G5ClQLXGpAI2gJgzcWZwfC6c7p
 C6LBnPSpGiwp4BfmWfmdfgiQ7y2sXcCWyd7h0biWmF526Plv1DOfg/SVdtuFoZQ4INpj
 HxYWo1uPjjCm33ukr2RCtmFd7IMCbkbldyI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v8sdx7n6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Sep 2019 09:59:39 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Sep 2019 09:59:38 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Sep 2019 09:59:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDVQlk6N9mqXaD7b4lXrGHB3b2uOC/4cK9a95JQMO4If9GoSiszhj+apOoRbT4u8uG1eHSDvw4a7cQyCZEbVgZXa15pcR9X81361Mnn8QG2Y3qbLY7YLSeDejp59w4xmoJmYhBpc7wjCziLxqKNLmdOh3kscv6O8kFJVhWpx7dUMxVpwrs7BmnkPb1RSDBiLeYQyjisu/1HB1rgZYMY4o1aaSzFoVVvWQ96mDZeDHGuX+0J5kD+R5BQbWG7DnFbSJMKuQYyBIwXOy4GdLzRaEXm/qpmO48QDvsPBoHAh8aurs7Knud5uX2wPYUEphE+/pgQB4c9fps0VVlWaONTnIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKB0Wz6GqAElYU6QP/nozyo5jLKt/eOTWuYChBn200w=;
 b=AX0F2xiJ8JaqJA5ZQGMNVS5KlgoVF7YGzag6ZcDAKs+8JYA80T0QMb4dtATVMt23AW3fp0TeD+sq42v7i7fzwd3VWMuJp3HrCDbEZ6MEbS2Ov02s0cuRdukFZGyKCpxURxXtv6GAn/vPt3/Xgnow9EIylRRIRsEV4NQYmksj07XKyCUjuOxbRy1lMrFwfiEMliLxjb/NBxwnNpTZOtrDJ9uK9p51P14PIYZo0lIPwUrx1wqGQ6imczJPxZF9vRxD73CaJCsfSXMe2hWGETt5dTzHwtNMNE3cCQQo8xHZhzlZ9u3HZTsw+UlHqjLBLWZVUOhmOQxY3Rk69SjCDXCv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKB0Wz6GqAElYU6QP/nozyo5jLKt/eOTWuYChBn200w=;
 b=VXHSRPEcjLAX9snCTcoCrpGRfxz2PIAtCkBcOtkFoV6L2/65Jt9CMfQ3yvn9RRIdZ9FJkWO7CXxG7wxygsKhveguNkc4qYCGi4mXmerbGAFFpw35/7cWFdKWtTS1uqY5wRecTgwciUeUwtdXSYgc23b3B/xGVx6s2PbMpVfX908=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2904.namprd15.prod.outlook.com (20.178.236.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Fri, 27 Sep 2019 16:59:38 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2284.023; Fri, 27 Sep 2019
 16:59:37 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Carlos Neira <cneirabustos@gmail.com>
CC:     Networking <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v11 2/4] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Thread-Topic: [PATCH bpf-next v11 2/4] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Thread-Index: AQHVdU7ici1k90v/ikGUa3F8N2NsUqc/v0IA
Date:   Fri, 27 Sep 2019 16:59:37 +0000
Message-ID: <12db0313-668e-3825-d5fa-28d0f675808c@fb.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <20190924152005.4659-3-cneirabustos@gmail.com>
 <CAEf4BzZeO3cZJWVG0min98gnFs3E8D1m67E+3A_9-rTjHA_Ybg@mail.gmail.com>
In-Reply-To: <CAEf4BzZeO3cZJWVG0min98gnFs3E8D1m67E+3A_9-rTjHA_Ybg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:300:16::13) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:993b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34fe1fc2-6465-407e-1113-08d7436c1467
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2904;
x-ms-traffictypediagnostic: BYAPR15MB2904:
x-microsoft-antispam-prvs: <BYAPR15MB290446796FBBBD5AE79B8C84D3810@BYAPR15MB2904.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(346002)(396003)(376002)(54094003)(199004)(189003)(14454004)(52116002)(8936002)(6486002)(386003)(81156014)(99286004)(25786009)(8676002)(7736002)(46003)(81166006)(86362001)(186003)(102836004)(31686004)(36756003)(256004)(229853002)(305945005)(11346002)(71190400001)(31696002)(76176011)(6116002)(476003)(14444005)(6506007)(5660300002)(6436002)(53546011)(66446008)(64756008)(66556008)(71200400001)(66946007)(2616005)(486006)(2906002)(446003)(6512007)(54906003)(316002)(478600001)(110136005)(4326008)(6246003)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2904;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NHXqek+d7jE3eGCEyhlnFmcHbBhD/bemWhkjbsFWSkiLSYkLOHkmax3g96fswm7Xv2mXpw2KLdDMxjgeiROYc+K9BhORkzTDScGXIQpXVkNyucO8LCexEyDvA83dbwg8qIeEa+NVDhRJeH7IrUCKl9cGhCxEmv2ZPGBdgYAyjCbHPPiseaaw7pP+bmb67m+2Zo5fXaknRRnIogaAum6zpHkhiCZV/MQNRhbAjKKUkMEV4b+Dea6eB2YJGUibkneJR6n3MuPw+9JQLMkLnxwDImPW9ZXwhXhV1lY6vmArpdF+m7iW4G6QnhTUpamifTrxWE/M7yKE7jfpGcNQyQ4dzf4H3Gng7q32Z0nwPp41S+IIAT1g1ZD+xPnmRYAXpF/GDn+L4vNDGXgxXvQ1grOSZv3OUMILNNxwMWfO6nUyjg0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE5E5DCCE04E464190107B329EFA5323@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fe1fc2-6465-407e-1113-08d7436c1467
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 16:59:37.7080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H1qiTxGSsWj/5M5mA4VegaNd2TOzGzlGRLWwClDSWAE9VITAaCJEtJbaf06GFOwj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2904
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_08:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMjcvMTkgOToxNSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBUaHUs
IFNlcCAyNiwgMjAxOSBhdCAxOjE1IEFNIENhcmxvcyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWls
LmNvbT4gd3JvdGU6DQo+Pg0KPj4gTmV3IGJwZiBoZWxwZXIgYnBmX2dldF9uc19jdXJyZW50X3Bp
ZF90Z2lkLA0KPj4gVGhpcyBoZWxwZXIgd2lsbCByZXR1cm4gcGlkIGFuZCB0Z2lkIGZyb20gY3Vy
cmVudCB0YXNrDQo+PiB3aGljaCBuYW1lc3BhY2UgbWF0Y2hlcyBkZXZfdCBhbmQgaW5vZGUgbnVt
YmVyIHByb3ZpZGVkLA0KPj4gdGhpcyB3aWxsIGFsbG93cyB1cyB0byBpbnN0cnVtZW50IGEgcHJv
Y2VzcyBpbnNpZGUgYSBjb250YWluZXIuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2FybG9zIE5l
aXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KPj4gLS0tDQo+PiAgIGluY2x1ZGUvbGludXgv
YnBmLmggICAgICB8ICAxICsNCj4+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgMTggKysr
KysrKysrKysrKysrKystDQo+PiAgIGtlcm5lbC9icGYvY29yZS5jICAgICAgICB8ICAxICsNCj4+
ICAga2VybmVsL2JwZi9oZWxwZXJzLmMgICAgIHwgMzIgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4+ICAga2VybmVsL3RyYWNlL2JwZl90cmFjZS5jIHwgIDIgKysNCj4+ICAgNSBm
aWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYnBmLmggYi9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+PiBp
bmRleCA1YjlkMjIzMzg2MDYuLjIzMTAwMTQ3NTUwNCAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUv
bGludXgvYnBmLmgNCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYnBmLmgNCj4+IEBAIC0xMDU1LDYg
KzEwNTUsNyBAQCBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfbG9j
YWxfc3RvcmFnZV9wcm90bzsNCj4+ICAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90
byBicGZfc3RydG9sX3Byb3RvOw0KPj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3By
b3RvIGJwZl9zdHJ0b3VsX3Byb3RvOw0KPj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5j
X3Byb3RvIGJwZl90Y3Bfc29ja19wcm90bzsNCj4+ICtleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9m
dW5jX3Byb3RvIGJwZl9nZXRfbnNfY3VycmVudF9waWRfdGdpZF9wcm90bzsNCj4+DQo+PiAgIC8q
IFNoYXJlZCBoZWxwZXJzIGFtb25nIGNCUEYgYW5kIGVCUEYuICovDQo+PiAgIHZvaWQgYnBmX3Vz
ZXJfcm5kX2luaXRfb25jZSh2b2lkKTsNCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+IGluZGV4IDc3YzZiZTk2ZDY3
Ni4uOTI3MmRjOGZiMDhjIDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5o
DQo+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+IEBAIC0yNzUwLDYgKzI3NTAs
MjEgQEAgdW5pb24gYnBmX2F0dHIgew0KPj4gICAgKiAgICAgICAgICAgICAqKi1FT1BOT1RTVVBQ
Kioga2VybmVsIGNvbmZpZ3VyYXRpb24gZG9lcyBub3QgZW5hYmxlIFNZTiBjb29raWVzDQo+PiAg
ICAqDQo+PiAgICAqICAgICAgICAgICAgICoqLUVQUk9UT05PU1VQUE9SVCoqIElQIHBhY2tldCB2
ZXJzaW9uIGlzIG5vdCA0IG9yIDYNCj4+ICsgKg0KPj4gKyAqIGludCBicGZfZ2V0X25zX2N1cnJl
bnRfcGlkX3RnaWQodTMyIGRldiwgdTY0IGludW0pDQo+PiArICogICAgIFJldHVybg0KPj4gKyAq
ICAgICAgICAgICAgIEEgNjQtYml0IGludGVnZXIgY29udGFpbmluZyB0aGUgY3VycmVudCB0Z2lk
IGFuZCBwaWQgZnJvbSBjdXJyZW50IHRhc2sNCj4gDQo+IEZ1bmN0aW9uIHNpZ25hdHVyZSBkb2Vz
bid0IGNvcnJlc3BvbmQgdG8gdGhlIGFjdHVhbCByZXR1cm4gdHlwZSAoaW50IHZzIHU2NCkuDQo+
IA0KPj4gKyAqICAgICAgICAgICAgICB3aGljaCBuYW1lc3BhY2UgaW5vZGUgYW5kIGRldl90IG1h
dGNoZXMgLCBhbmQgaXMgY3JlYXRlIGFzIHN1Y2g6DQo+PiArICogICAgICAgICAgICAgKmN1cnJl
bnRfdGFzaypcICoqLT50Z2lkIDw8IDMyIFx8KioNCj4+ICsgKiAgICAgICAgICAgICAqY3VycmVu
dF90YXNrKlwgKiotPnBpZCoqLg0KPj4gKyAqDQo+PiArICogICAgICAgICAgICAgT24gZmFpbHVy
ZSwgdGhlIHJldHVybmVkIHZhbHVlIGlzIG9uZSBvZiB0aGUgZm9sbG93aW5nOg0KPj4gKyAqDQo+
PiArICogICAgICAgICAgICAgKiotRUlOVkFMKiogaWYgZGV2IGFuZCBpbnVtIHN1cHBsaWVkIGRv
bid0IG1hdGNoIGRldl90IGFuZCBpbm9kZSBudW1iZXINCj4+ICsgKiAgICAgICAgICAgICAgd2l0
aCBuc2ZzIG9mIGN1cnJlbnQgdGFzay4NCj4+ICsgKg0KPj4gKyAqICAgICAgICAgICAgICoqLUVO
T0VOVCoqIGlmIC9wcm9jL3NlbGYvbnMgZG9lcyBub3QgZXhpc3RzLg0KPj4gKyAqDQo+PiAgICAq
Lw0KPiANCj4gWy4uLl0NCj4gDQo+PiAgICNpbmNsdWRlICIuLi8uLi9saWIva3N0cnRveC5oIg0K
Pj4NCj4+IEBAIC00ODcsMyArNDg5LDMzIEBAIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBi
cGZfc3RydG91bF9wcm90byA9IHsNCj4+ICAgICAgICAgIC5hcmc0X3R5cGUgICAgICA9IEFSR19Q
VFJfVE9fTE9ORywNCj4+ICAgfTsNCj4+ICAgI2VuZGlmDQo+PiArDQo+PiArQlBGX0NBTExfMihi
cGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQsIHUzMiwgZGV2LCB1NjQsIGludW0pDQo+IA0KPiBK
dXN0IGN1cmlvdXMsIGlzIGRldl90IG9mZmljaWFsbHkgc3BlY2lmaWVkIGFzIHUzMiBhbmQgaXMg
bmV2ZXINCj4gc3VwcG9zZWQgdG8gZ3JvdyBiaWdnZXI/IEkgd29uZGVyIGlmIGFjY2VwdGluZyB1
NjQgbWlnaHQgYmUgbW9yZQ0KPiBmdXR1cmUtcHJvb2YgQVBJIGhlcmU/DQoNClRoaXMgaXMgd2hh
dCB3ZSBoYXZlIG5vdyBpbiBrZXJuZWwgKGluY2x1ZGUvbGludXgvdHlwZXMuaCkNCnR5cGVkZWYg
dTMyIF9fa2VybmVsX2Rldl90Ow0KdHlwZWRlZiBfX2tlcm5lbF9kZXZfdCAgICAgICAgICBkZXZf
dDsNCg0KQnV0IHVzZXJzcGFjZSBkZXZfdCAoZGVmaW5lZCBhdCAvdXNyL2luY2x1ZGUvc3lzL3R5
cGVzLmgpIGhhdmUNCjggYnl0ZXMuDQoNCkFncmVlLiBMZXQgdXMganVzdCB1c2UgdTY0LiBJdCB3
b24ndCBodXJ0IGFuZCBhbHNvIHdpbGwgYmUgZmluZQ0KaWYga2VybmVsIGludGVybmFsIGRldl90
IGJlY29tZXMgNjRiaXQuDQoNCj4gDQo+PiArew0KPj4gKyAgICAgICBzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRhc2sgPSBjdXJyZW50Ow0KPj4gKyAgICAgICBzdHJ1Y3QgcGlkX25hbWVzcGFjZSAqcGlk
bnM7DQo+IA0KPiBbLi4uXQ0KPiANCg==
