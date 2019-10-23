Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A164E1031
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389020AbfJWCvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:51:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34686 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732748AbfJWCvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:51:45 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N2mhXN011015;
        Tue, 22 Oct 2019 19:51:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=E2ZB53uj6fstbbmoPf8NrJfbmJKc1uAxCTTd22zVwko=;
 b=RfPtHj80iQyFmvra3kA5YEgGrIouB/DY3MfYBILxTt85uxoeRFSuUiiyHOJ3D+IrPcgN
 YyubSx/SUJYiHzur/bIfnu6+XI8IGe11atfvAn08aUniEKEptp36u7ONL2cceEoQ+xzL
 qlCWVfQZYLmJULz5D9H6ZfwvpR+Tfe1bl24= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9t6h2af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 19:51:39 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 22 Oct 2019 19:51:38 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 19:51:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrjH4FQbUitCiOarwLBSK1lw5NRT2FirDYDr3I+Fd0zLw7PFrLOk2zhce1+ftQpGdliWJe6BMKeaQpl48mGz2f1WglaBna+SVyd3ET4d3byiZf5w/FTWzL4yUK12hdE+ms/daC66FtsVihDYxoK7+zXyUGTfJALo4BGsq+CeAVW1D8OgkCXQkuStkimuRpBS9SgsHrLpSjy+kYW6vv+an8+y5O3EI52qABmv/dP+0F2kABUdYPoPDgLTiP05zlwqRZXvBAUEztwFm9nC7KFXgzNlMGnEMsFbkzYcgmenlra/i7aAieK9cix/PYYw46wTc0KsjfNsok3HM/zREd7wYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2ZB53uj6fstbbmoPf8NrJfbmJKc1uAxCTTd22zVwko=;
 b=D7AUIjkSqKg59oNvainXbTZpALklInCFxZ7M/M1lr/VAM5KOVe/5LtvEF4qiABOGDt3Q0XMR4BdQnkiwjgBnKmvwMyOnV5AS5x9LlqmBmjEpMmqGng4bPJiRF59Ba993rknCf5n5hy6UtZtuAUhuFhOUDdfWgNQRB2Pv5bIyFlKrL4ZzbxLj9r9UXrj5ENhDDgz78lcIri7Dh6AvMB2QsTzYPhE67GkOmI7j8h8CFlO5/Oz09c2k64kMXAJApBuga5lJCmXhwPEh9XD66Og3iqcSvPu7RKu/zyoCYKG0r9arFBUi69/u/xVtDHnqDYvpzX21EOkLUtYUSNFuHQPSww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2ZB53uj6fstbbmoPf8NrJfbmJKc1uAxCTTd22zVwko=;
 b=KdBdi/2Q0tu58kkvl2OcCTVOsC9zTnwhow5xWgncYE/6vV93UijppVqaD7h43VAlXGfLzW+is8jsJqI1blWMAXEKfKeuzP69qgPLOjLRg9gXHZmitXPLutQOnnS486PcdABSBLCHkDzHWDpaGVyNqtE5mZa71c5x0omEGKaxq00=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2213.namprd15.prod.outlook.com (52.135.194.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 02:51:37 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 02:51:37 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Thread-Topic: [PATCH v15 2/5] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Thread-Index: AQHViQ1y6a3VxTw7C0Kva37GsK2s/qdnh3IA
Date:   Wed, 23 Oct 2019 02:51:37 +0000
Message-ID: <6bd7f915-176c-dd1a-b867-50a04e0f7ad5@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-3-cneirabustos@gmail.com>
In-Reply-To: <20191022191751.3780-3-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:300:13d::23) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74bbc3f7-cfdf-4b48-df98-08d75763ec29
x-ms-traffictypediagnostic: BYAPR15MB2213:
x-microsoft-antispam-prvs: <BYAPR15MB2213D51EAC10FA0B0423B91BD36B0@BYAPR15MB2213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(25786009)(31686004)(4326008)(8936002)(6246003)(8676002)(81166006)(81156014)(256004)(305945005)(7736002)(14444005)(2501003)(316002)(46003)(66446008)(64756008)(66946007)(66476007)(66556008)(86362001)(6512007)(102836004)(229853002)(446003)(11346002)(2616005)(6436002)(486006)(6486002)(476003)(99286004)(5660300002)(6116002)(52116002)(386003)(53546011)(6506007)(36756003)(76176011)(2906002)(186003)(54906003)(110136005)(478600001)(14454004)(31696002)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2213;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AEodV1ybje6kc1uIyYmGuXaOGNilR5JiL2I5vhP6uHAoMvxQl/RcFyEjRbUigwZLi7y8OQXp6ZUDHUEHuxUKAlG/fQ//iDrKMD5gQwEkRTybYo+MfzdhwvaH41OMMfYw7b7QBMz0MVLlfxVHdhRd4HGFoS/CJBeBNLVYByhoQeOkIP41exgnRs6EhhQZ8s/hDD+1AJ8dwB9q8f/yA26Zxbaj3+mAT7uVUNTp3GxF8g9UN4H/k2E7JMiuCgeUnLdpj4jOf+zV7uoSTDeBV2t2UBSMEw9oU+UF2zLjHbS2y27Vztcde6rxGM1wh/HdizVLWzplkeX8qHqAKRmyh1z5C3XV7SLLigya+fDtrHH1fsmGlKFqf4VyL8ydkT793nhU14wExGaM58qYoedjzENRJMLp2ykO7is6XU4MfBYB2zFO2ZkRtvu57iGQVhFfxQ/7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4B75F08BC5E5B4FAD38DA91DA68D5A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bbc3f7-cfdf-4b48-df98-08d75763ec29
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 02:51:37.4169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G++cQdeWm6cQfTlPAQE2nxktOdfEzO0kNqG67HiAA5lgUhA5SiWKlKJkBf8QxZ+6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IE5ldyBicGYg
aGVscGVyIGJwZl9nZXRfbnNfY3VycmVudF9waWRfdGdpZCwNCj4gVGhpcyBoZWxwZXIgd2lsbCBy
ZXR1cm4gcGlkIGFuZCB0Z2lkIGZyb20gY3VycmVudCB0YXNrDQo+IHdoaWNoIG5hbWVzcGFjZSBt
YXRjaGVzIGRldl90IGFuZCBpbm9kZSBudW1iZXIgcHJvdmlkZWQsDQo+IHRoaXMgd2lsbCBhbGxv
d3MgdXMgdG8gaW5zdHJ1bWVudCBhIHByb2Nlc3MgaW5zaWRlIGEgY29udGFpbmVyLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KDQpB
Y2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiAtLS0NCj4gICBpbmNsdWRl
L2xpbnV4L2JwZi5oICAgICAgfCAgMSArDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwg
MjAgKysrKysrKysrKysrKysrKystDQo+ICAga2VybmVsL2JwZi9jb3JlLmMgICAgICAgIHwgIDEg
Kw0KPiAgIGtlcm5lbC9icGYvaGVscGVycy5jICAgICB8IDQ1ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gICBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgfCAgMiAr
Kw0KPiAgIDUgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYnBmLmggYi9pbmNsdWRlL2xpbnV4L2Jw
Zi5oDQo+IGluZGV4IDJjMmMyOWI0OTg0NS4uMWQ3Yzg2MDE5MTEzIDEwMDY0NA0KPiAtLS0gYS9p
bmNsdWRlL2xpbnV4L2JwZi5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gQEAgLTEw
ODIsNiArMTA4Miw3IEBAIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dl
dF9sb2NhbF9zdG9yYWdlX3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNf
cHJvdG8gYnBmX3N0cnRvbF9wcm90bzsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5j
X3Byb3RvIGJwZl9zdHJ0b3VsX3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1
bmNfcHJvdG8gYnBmX3RjcF9zb2NrX3Byb3RvOw0KPiArZXh0ZXJuIGNvbnN0IHN0cnVjdCBicGZf
ZnVuY19wcm90byBicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfcHJvdG87DQo+ICAgDQo+ICAg
LyogU2hhcmVkIGhlbHBlcnMgYW1vbmcgY0JQRiBhbmQgZUJQRi4gKi8NCj4gICB2b2lkIGJwZl91
c2VyX3JuZF9pbml0X29uY2Uodm9pZCk7DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gaW5kZXggNGFmOGIwODE5YTMy
Li40YzNlMGIwOTUyZTYgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0K
PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gQEAgLTI3NzUsNiArMjc3NSwxOSBA
QCB1bmlvbiBicGZfYXR0ciB7DQo+ICAgICogCQlyZXN0cmljdGVkIHRvIHJhd190cmFjZXBvaW50
IGJwZiBwcm9ncmFtcy4NCj4gICAgKiAJUmV0dXJuDQo+ICAgICogCQkwIG9uIHN1Y2Nlc3MsIG9y
IGEgbmVnYXRpdmUgZXJyb3IgaW4gY2FzZSBvZiBmYWlsdXJlLg0KPiArICoNCj4gKyAqIGludCBi
cGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQodTY0IGRldiwgdTY0IGlubywgc3RydWN0IGJwZl9w
aWRuc19pbmZvICpuc2RhdGEsIHUzMiBzaXplKQ0KPiArICoJRGVzY3JpcHRpb24NCj4gKyAqCQlS
ZXR1cm5zIDAgb24gc3VjY2VzcywgdmFsdWVzIGZvciAqcGlkKiBhbmQgKnRnaWQqIGFzIHNlZW4g
ZnJvbSB0aGUgY3VycmVudA0KPiArICoJCSpuYW1lc3BhY2UqIHdpbGwgYmUgcmV0dXJuZWQgaW4g
Km5zZGF0YSouDQo+ICsgKg0KPiArICoJCU9uIGZhaWx1cmUsIHRoZSByZXR1cm5lZCB2YWx1ZSBp
cyBvbmUgb2YgdGhlIGZvbGxvd2luZzoNCj4gKyAqDQo+ICsgKgkJKiotRUlOVkFMKiogaWYgZGV2
IGFuZCBpbnVtIHN1cHBsaWVkIGRvbid0IG1hdGNoIGRldl90IGFuZCBpbm9kZSBudW1iZXINCj4g
KyAqICAgICAgICAgICAgICB3aXRoIG5zZnMgb2YgY3VycmVudCB0YXNrLCBvciBpZiBkZXYgY29u
dmVyc2lvbiB0byBkZXZfdCBsb3N0IGhpZ2ggYml0cy4NCj4gKyAqDQo+ICsgKgkJKiotRU5PRU5U
KiogaWYgcGlkbnMgZG9lcyBub3QgZXhpc3RzIGZvciB0aGUgY3VycmVudCB0YXNrLg0KPiArICoN
Cj4gICAgKi8NCj4gICAjZGVmaW5lIF9fQlBGX0ZVTkNfTUFQUEVSKEZOKQkJXA0KPiAgIAlGTih1
bnNwZWMpLAkJCVwNCj4gQEAgLTI4ODgsNyArMjkwMSw4IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4g
ICAJRk4oc2tfc3RvcmFnZV9kZWxldGUpLAkJXA0KPiAgIAlGTihzZW5kX3NpZ25hbCksCQlcDQo+
ICAgCUZOKHRjcF9nZW5fc3luY29va2llKSwJCVwNCj4gLQlGTihza2Jfb3V0cHV0KSwNCj4gKwlG
Tihza2Jfb3V0cHV0KSwJCQlcDQo+ICsJRk4oZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQpLA0KPiAg
IA0KPiAgIC8qIGludGVnZXIgdmFsdWUgaW4gJ2ltbScgZmllbGQgb2YgQlBGX0NBTEwgaW5zdHJ1
Y3Rpb24gc2VsZWN0cyB3aGljaCBoZWxwZXINCj4gICAgKiBmdW5jdGlvbiBlQlBGIHByb2dyYW0g
aW50ZW5kcyB0byBjYWxsDQo+IEBAIC0zNjM5LDQgKzM2NTMsOCBAQCBzdHJ1Y3QgYnBmX3NvY2tv
cHQgew0KPiAgIAlfX3MzMglyZXR2YWw7DQo+ICAgfTsNCj4gICANCj4gK3N0cnVjdCBicGZfcGlk
bnNfaW5mbyB7DQo+ICsJX191MzIgcGlkOw0KPiArCV9fdTMyIHRnaWQ7DQo+ICt9Ow0KPiAgICNl
bmRpZiAvKiBfVUFQSV9fTElOVVhfQlBGX0hfXyAqLw0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2Jw
Zi9jb3JlLmMgYi9rZXJuZWwvYnBmL2NvcmUuYw0KPiBpbmRleCA2NzNmNWQ0MGE5M2UuLjA0MDgz
OTQyYTEzYSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9jb3JlLmMNCj4gKysrIGIva2VybmVs
L2JwZi9jb3JlLmMNCj4gQEAgLTIwNzksNiArMjA3OSw3IEBAIGNvbnN0IHN0cnVjdCBicGZfZnVu
Y19wcm90byBicGZfZ2V0X2N1cnJlbnRfdWlkX2dpZF9wcm90byBfX3dlYWs7DQo+ICAgY29uc3Qg
c3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfY3VycmVudF9jb21tX3Byb3RvIF9fd2VhazsN
Cj4gICBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50X2Nncm91cF9p
ZF9wcm90byBfX3dlYWs7DQo+ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRf
bG9jYWxfc3RvcmFnZV9wcm90byBfX3dlYWs7DQo+ICtjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJv
dG8gYnBmX2dldF9uc19jdXJyZW50X3BpZF90Z2lkX3Byb3RvIF9fd2VhazsNCj4gICANCj4gICBj
b25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gKiBfX3dlYWsgYnBmX2dldF90cmFjZV9wcmludGtf
cHJvdG8odm9pZCkNCj4gICB7DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2hlbHBlcnMuYyBi
L2tlcm5lbC9icGYvaGVscGVycy5jDQo+IGluZGV4IDVlMjg3MTg5MjhjYS4uNTQ3N2FkOTg0ZDdj
IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2hlbHBlcnMuYw0KPiArKysgYi9rZXJuZWwvYnBm
L2hlbHBlcnMuYw0KPiBAQCAtMTEsNiArMTEsOCBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC91aWRn
aWQuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4
L2N0eXBlLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvcGlkX25hbWVzcGFjZS5oPg0KPiArI2luY2x1
ZGUgPGxpbnV4L3Byb2NfbnMuaD4NCj4gICANCj4gICAjaW5jbHVkZSAiLi4vLi4vbGliL2tzdHJ0
b3guaCINCj4gICANCj4gQEAgLTQ4NywzICs0ODksNDYgQEAgY29uc3Qgc3RydWN0IGJwZl9mdW5j
X3Byb3RvIGJwZl9zdHJ0b3VsX3Byb3RvID0gew0KPiAgIAkuYXJnNF90eXBlCT0gQVJHX1BUUl9U
T19MT05HLA0KPiAgIH07DQo+ICAgI2VuZGlmDQo+ICsNCj4gK0JQRl9DQUxMXzQoYnBmX2dldF9u
c19jdXJyZW50X3BpZF90Z2lkLCB1NjQsIGRldiwgdTY0LCBpbm8sDQo+ICsJICAgc3RydWN0IGJw
Zl9waWRuc19pbmZvICosIG5zZGF0YSwgdTMyLCBzaXplKQ0KPiArew0KPiArCXN0cnVjdCB0YXNr
X3N0cnVjdCAqdGFzayA9IGN1cnJlbnQ7DQo+ICsJc3RydWN0IHBpZF9uYW1lc3BhY2UgKnBpZG5z
Ow0KPiArCWludCBlcnIgPSAtRUlOVkFMOw0KPiArDQo+ICsJaWYgKHVubGlrZWx5KHNpemUgIT0g
c2l6ZW9mKHN0cnVjdCBicGZfcGlkbnNfaW5mbykpKQ0KPiArCQlnb3RvIGNsZWFyOw0KPiArDQo+
ICsJaWYgKHVubGlrZWx5KCh1NjQpKGRldl90KWRldiAhPSBkZXYpKQ0KPiArCQlnb3RvIGNsZWFy
Ow0KPiArDQo+ICsJaWYgKHVubGlrZWx5KCF0YXNrKSkNCj4gKwkJZ290byBjbGVhcjsNCj4gKw0K
PiArCXBpZG5zID0gdGFza19hY3RpdmVfcGlkX25zKHRhc2spOw0KPiArCWlmICh1bmxpa2VseSgh
cGlkbnMpKSB7DQo+ICsJCWVyciA9IC1FTk9FTlQ7DQo+ICsJCWdvdG8gY2xlYXI7DQo+ICsJfQ0K
PiArDQo+ICsJaWYgKCFuc19tYXRjaCgmcGlkbnMtPm5zLCAoZGV2X3QpZGV2LCBpbm8pKQ0KPiAr
CQlnb3RvIGNsZWFyOw0KPiArDQo+ICsJbnNkYXRhLT5waWQgPSB0YXNrX3BpZF9ucl9ucyh0YXNr
LCBwaWRucyk7DQo+ICsJbnNkYXRhLT50Z2lkID0gdGFza190Z2lkX25yX25zKHRhc2ssIHBpZG5z
KTsNCj4gKwlyZXR1cm4gMDsNCj4gK2NsZWFyOg0KPiArCW1lbXNldCgodm9pZCAqKW5zZGF0YSwg
MCwgKHNpemVfdCkgc2l6ZSk7DQo+ICsJcmV0dXJuIGVycjsNCj4gK30NCj4gKw0KPiArY29uc3Qg
c3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfbnNfY3VycmVudF9waWRfdGdpZF9wcm90byA9
IHsNCj4gKwkuZnVuYwkJPSBicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQsDQo+ICsJLmdwbF9v
bmx5CT0gZmFsc2UsDQo+ICsJLnJldF90eXBlCT0gUkVUX0lOVEVHRVIsDQo+ICsJLmFyZzFfdHlw
ZQk9IEFSR19BTllUSElORywNCj4gKwkuYXJnMl90eXBlCT0gQVJHX0FOWVRISU5HLA0KPiArCS5h
cmczX3R5cGUgICAgICA9IEFSR19QVFJfVE9fVU5JTklUX01FTSwNCj4gKwkuYXJnNF90eXBlICAg
ICAgPSBBUkdfQ09OU1RfU0laRSwNCj4gK307DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2Uv
YnBmX3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gaW5kZXggYzMyNDA4OThj
YzQ0Li4wN2Y2ZmEzNTRmMTUgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC90cmFjZS9icGZfdHJhY2Uu
Yw0KPiArKysgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gQEAgLTczNSw2ICs3MzUsOCBA
QCB0cmFjaW5nX2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1
Y3QgYnBmX3Byb2cgKnByb2cpDQo+ICAgI2VuZGlmDQo+ICAgCWNhc2UgQlBGX0ZVTkNfc2VuZF9z
aWduYWw6DQo+ICAgCQlyZXR1cm4gJmJwZl9zZW5kX3NpZ25hbF9wcm90bzsNCj4gKwljYXNlIEJQ
Rl9GVU5DX2dldF9uc19jdXJyZW50X3BpZF90Z2lkOg0KPiArCQlyZXR1cm4gJmJwZl9nZXRfbnNf
Y3VycmVudF9waWRfdGdpZF9wcm90bzsNCj4gICAJZGVmYXVsdDoNCj4gICAJCXJldHVybiBOVUxM
Ow0KPiAgIAl9DQo+IA0K
