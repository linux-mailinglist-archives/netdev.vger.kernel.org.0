Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5811434C1
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgAUAgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:36:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbgAUAgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:36:21 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00L0a5HK031983;
        Mon, 20 Jan 2020 16:36:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k7kKark++Brp/uEGkNyVnSgkFNCrC+EE2W7sFCw3mqI=;
 b=Bo2LUDIyKtdQ8rx0Asv4UasX8t8nRvHs9pwhdj/E7374rxyOCKK4B1Ga0oZrfnfIYgo9
 1dRMmJzwU518Q7gsKcJq/F+b4GFD/jqjhN096fuMfEa2DhJIAUTuc9GkQJyJl6VUKeVB
 YQ4sfA3bW6VOTSouY10Zua8Qz0nCNKfUf+4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xmjeupg00-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Jan 2020 16:36:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 20 Jan 2020 16:35:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dw4qCXfSzdYOHmsZWudXMiDsb4z3X27sMiuYCxNBaQZd356fbYa3TKZTzHPkEkZu8jVyEFu8y3ObdbQxDEbqbdsbpKTUXQf+ZyGInviF/AvLAK6wChZhDzOfSHl7lD8kI99XqSj2UN2UxUhWNnlmYK8xtftQr7wA8Mxrx7e/uV2YOcfamRlhUqf2cX6zMgX90h5uyKPfyw2oNh2hRLF2LR/3Q/gBwNMQyf57xu42YJ/XVOvApS4c1s/KnvtegEXXeJU1FoM6O26XNIpZsMYel6s/AIqFmcKLU+imEEFvFBz7MaTSvZVPFxNVuBfY0KCuiRqSLmeTW4O5NLYt5bammQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7kKark++Brp/uEGkNyVnSgkFNCrC+EE2W7sFCw3mqI=;
 b=VU80OSQstt5kPs2kl8+bIcWV+dI148FtA7wJiLojjkui6bbois+eVNC6pA92c9PFZvOT2FDL+gdGq7WU5ChPRXSNv/8fX4l8bZdPf74NUTJBq14RTmFoQrxCVCDW3yXYgJsZW+g1HF4Eewp29ORH/tQVmxZvS+q+r775s9OG/dRG7qYufr8TrxeT/7WQf7/KmSQAH+IDiJAgN7ngw9QyKVipF3PmUMNBIL6OVngavv/nAu9lQcS7/xgpvxOtnGEiz0ZLv4rT3+lx7k9hteHcf4Xgti/oUr6QfG2W1t1rekyPIFEsMalplSAaP9i42cIHcKVdW/uQGB1CJtA/cGCUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7kKark++Brp/uEGkNyVnSgkFNCrC+EE2W7sFCw3mqI=;
 b=DPFvIVnkhJck1o9Zh2yM9VuUP+ODVj/jmbGq4Wr6MCZSPowi2KXML+bgJz8YZzrVcv21f3pepNXXnk7nb9wsT10pZ5B30ZAh6rdhnN2xD+5aUnlYqcH859aZwwbOEE6VRFUI/8sktdOV6wIqqjQHmzQO4MLKttZmWgZo4wohPZE=
Received: from MN2PR15MB3630.namprd15.prod.outlook.com (52.132.174.216) by
 MN2PR15MB2781.namprd15.prod.outlook.com (20.179.144.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Tue, 21 Jan 2020 00:35:43 +0000
Received: from MN2PR15MB3630.namprd15.prod.outlook.com
 ([fe80::f043:c81c:e3ee:fa21]) by MN2PR15MB3630.namprd15.prod.outlook.com
 ([fe80::f043:c81c:e3ee:fa21%5]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 00:35:43 +0000
Received: from [IPv6:2620:10d:c081:1131::1401] (2620:10d:c090:180::a4eb) by MWHPR19CA0094.namprd19.prod.outlook.com (2603:10b6:320:1f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 00:35:42 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Add support for program extensions
Thread-Topic: [PATCH bpf-next 2/3] libbpf: Add support for program extensions
Thread-Index: AQHVzZefP6juEXWqDEOaSieGSD7Auaf0LS4AgAAdCgA=
Date:   Tue, 21 Jan 2020 00:35:43 +0000
Message-ID: <f8a4009d-9249-8583-b08a-60e037eec357@fb.com>
References: <20200118000657.2135859-1-ast@kernel.org>
 <20200118000657.2135859-3-ast@kernel.org>
 <CAEf4BzaOhCqYbznPsnuScJx1qbnLJu+2SQfhMwfdq-tJx9k7gA@mail.gmail.com>
In-Reply-To: <CAEf4BzaOhCqYbznPsnuScJx1qbnLJu+2SQfhMwfdq-tJx9k7gA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0094.namprd19.prod.outlook.com
 (2603:10b6:320:1f::32) To MN2PR15MB3630.namprd15.prod.outlook.com
 (2603:10b6:208:180::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a4eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e902a76-19be-4cf4-0e93-08d79e09d938
x-ms-traffictypediagnostic: MN2PR15MB2781:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB27819FC61D03802AC5D53024D70D0@MN2PR15MB2781.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(136003)(39860400002)(346002)(199004)(189003)(316002)(66946007)(64756008)(31686004)(66476007)(66556008)(5660300002)(54906003)(86362001)(31696002)(66446008)(71200400001)(4326008)(2616005)(478600001)(81166006)(81156014)(8676002)(8936002)(186003)(2906002)(52116002)(110136005)(6486002)(53546011)(16526019)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2781;H:MN2PR15MB3630.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 00ATcL1kFlD7unWj6QUjnC6zBL2Rc+aNac5mlNIcEuyXFLoPiMxPUUKrzZ4TUMJe1/S0o/aThEA6IR4bsqXkGWV8aq1twt85yxQ9ONSIhfM+QBHWkkIuT+OzXM09Fdn5P8zlexTOWuSV2sIO9lhcB0Qunc6JIMnCPSmKRts9rrArJCqgxA40lA+HjLVVahc8THXO3+PMOC4CYYN6X6Pk62Inzc/72EqvZBApVtKCRyoE3idlu4volj5gOF3jAxsciRWF9Ya7AW/UTrgo/EOhOZG+XhJJKtipaEHvg0hnRISpig+GzDELZ5xXtUPrJSg8Fd+IfnoteRKiYAcYWE/RuhzXQYueV5egyDvp+t0G6vaJsNrnhcJ7gmr4xDPOO82sJkdPmkGurrXy/46KDGZvcO7q+k9Ul3C3vZQ8veAr1HHrjCVlvMxiArptYqtClGdO
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A1AE0DA53BCBD448E445956EE963EC6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e902a76-19be-4cf4-0e93-08d79e09d938
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 00:35:43.4477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNXWOV4nuVx1/fTFmrvBQyx/Z02/Lix4UX7zy1U481XpYpeNfjXrU163QTwDk1S5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2781
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_10:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yMC8yMCAyOjUxIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIEZyaSwgSmFu
IDE3LCAyMDIwIGF0IDQ6NDcgUE0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gQWRkIG1pbmltYWwgc3VwcG9ydCBmb3IgcHJvZ3JhbSBleHRlbnNpb25z
LiBicGZfb2JqZWN0X29wZW5fb3B0cygpIG5lZWRzIHRvIGJlDQo+PiBjYWxsZWQgd2l0aCBhdHRh
Y2hfcHJvZ19mZCA9IHRhcmdldF9wcm9nX2ZkIGFuZCBCUEYgcHJvZ3JhbSBleHRlbnNpb24gbmVl
ZHMgdG8NCj4+IGhhdmUgaW4gLmMgZmlsZSBzZWN0aW9uIGRlZmluaXRpb24gbGlrZSBTRUMoInJl
cGxhY2UvZnVuY190b19iZV9yZXBsYWNlZCIpLg0KPj4gbGliYnBmIHdpbGwgc2VhcmNoIGZvciAi
ZnVuY190b19iZV9yZXBsYWNlZCIgaW4gdGhlIHRhcmdldF9wcm9nX2ZkJ3MgQlRGIGFuZA0KPj4g
d2lsbCBwYXNzIGl0IGluIGF0dGFjaF9idGZfaWQgdG8gdGhlIGtlcm5lbC4gVGhpcyBhcHByb2Fj
aCB3b3JrcyBmb3IgdGVzdHMsIGJ1dA0KPj4gbW9yZSBjb21wZXggdXNlIGNhc2UgbWF5IG5lZWQg
dG8gcmVxdWVzdCBmdW5jdGlvbiBuYW1lIChhbmQgYXR0YWNoX2J0Zl9pZCB0aGF0DQo+PiBrZXJu
ZWwgc2VlcykgdG8gYmUgbW9yZSBkeW5hbWljLiBTdWNoIEFQSSB3aWxsIGJlIGFkZGVkIGluIGZ1
dHVyZSBwYXRjaGVzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8
YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2Jw
Zi5oIHwgIDEgKw0KPj4gICB0b29scy9saWIvYnBmL2JwZi5jICAgICAgICAgICAgfCAgMyArKy0N
Cj4+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgICAgICAgIHwgMTQgKysrKysrKysrKystLS0N
Cj4+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuaCAgICAgICAgIHwgIDIgKysNCj4+ICAgdG9vbHMv
bGliL2JwZi9saWJicGYubWFwICAgICAgIHwgIDIgKysNCj4+ICAgdG9vbHMvbGliL2JwZi9saWJi
cGZfcHJvYmVzLmMgIHwgIDEgKw0KPj4gICA2IGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPiANCj4gWy4uLl0NCj4gDQo+PiAgIGVudW0gYnBmX2F0
dGFjaF90eXBlDQo+PiAgIGJwZl9wcm9ncmFtX19nZXRfZXhwZWN0ZWRfYXR0YWNoX3R5cGUoc3Ry
dWN0IGJwZl9wcm9ncmFtICpwcm9nKQ0KPj4gQEAgLTYyNjUsNiArNjI2OSwxMCBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGJwZl9zZWNfZGVmIHNlY3Rpb25fZGVmc1tdID0gew0KPj4gICAgICAgICAg
ICAgICAgICAuZXhwZWN0ZWRfYXR0YWNoX3R5cGUgPSBCUEZfVFJBQ0VfRkVYSVQsDQo+PiAgICAg
ICAgICAgICAgICAgIC5pc19hdHRhY2hfYnRmID0gdHJ1ZSwNCj4+ICAgICAgICAgICAgICAgICAg
LmF0dGFjaF9mbiA9IGF0dGFjaF90cmFjZSksDQo+PiArICAgICAgIFNFQ19ERUYoInJlcGxhY2Uv
IiwgRVhULA0KPiANCj4gaG93IGFib3V0IGZyZXBsYWNlLywgc2ltaWxhciB0byBmZW50cnkvZmV4
aXQ/DQoNCkkgdGhpbmsgaXQncyB1Z2xpZXIsIGJ1dCBmaW5lLg0KDQo+PiArICAgICAgICAgICAg
ICAgLmV4cGVjdGVkX2F0dGFjaF90eXBlID0gMCwNCj4gDQo+IG5vIG5lZWQsIGl0IHdpbGwgYmUg
emVybywgaWYgbm90IHNwZWNpZmllZCBoZXJlDQoNCmZpeGVkLg0K
