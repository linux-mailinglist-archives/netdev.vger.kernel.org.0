Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6D12D3DE
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 20:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfL3TXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 14:23:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727648AbfL3TXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 14:23:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBUJMNNO015675;
        Mon, 30 Dec 2019 11:22:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dMxjhvW8vgZK8/c7+/nAb6fKFiuaJ+7S3fA8LWCJs54=;
 b=TLVvzfW0Z/dvsfPWNWQ4vJGYc0hvpGU8FHRquV6ANKl9rcEJAq2z8q/P5TUZRdgLOULF
 dHrlIR08WSOfl8smJ6pK1jd1D0C/xKmOcbbAhJHSLxmPUBaastNaKHn2CNw6ljV+Nuny
 tTk2yaSB3YPXPZiUO5oTGn0KfMZSN6Vxzc8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x6r3m4yyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Dec 2019 11:22:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 30 Dec 2019 11:22:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1cPktNGPsTOQTyTsK6sLoJpmT6jRy4r8WXMmIKAgvN9rr/qNrvLJZtBEWH7LgnqGaP2vec26PHR6yfYz5vcLo5qI/KqBqTZQruF3g21phpTr2YMQnyIHggn1mgotM9E7tNeMgZxZd9KuqUmRSDuUH87rNsX1sn72FpaSs3pkmYbkKPyMeX+Vf6LPTY0t/bwhCe+aRsy5IJaY7SdRE9ZiPHeDM6Fx7nqUPdR3Ct8istjBvXax7BVthVQN52CzkKaUroRBVdtvW0w7iN5vnmEHpiWVRZnzgDnAPBE6ri8AzLfbuWLgqPdPDkTJD3Gjki1uj2NEh6WlAwaZnSNpZVvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMxjhvW8vgZK8/c7+/nAb6fKFiuaJ+7S3fA8LWCJs54=;
 b=SOfk95u7kLhxteRtjIjcUMzpLA1QG1q5HXhpxq4NNIBRsxcUHug3mOpJevkHr49oDH9cpZjEJO3uQZIpG+U7gPXGyYcjLP8AqJ02mRxwJl9VnDdre2M9vJ4k9/juLwZpL1kIG6jFrJKQm9O6s2+KwhDzOYXloeUTBCUrVUW47hlSbpFTrr34g/D6sw6sGuZZjOMR0XuhL/NGfvtgoetmDAYt/tFDUe/unuDBMTcgzHxOsvc9gGLu1HzRXPOwV4s5SIaodhSFCieI7bekDshGACsQMq/NXWP4TU8CXi6TWri/pDlr8h4vIHfXVOoPMHv+a6EVjdTGwG9tw0iD6q2cOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMxjhvW8vgZK8/c7+/nAb6fKFiuaJ+7S3fA8LWCJs54=;
 b=AVsbqV0cSl2tqC0C1C/D4gaMcLBtpgWz2G0zPHX5xvpp8ks7H+WaZ5Tcq+S0X414K2AXiml3kmN2EfSE0nJqjmMz/fAa1bqF8VKZ/yc5ibGx74W8iq8i4S2N2Zv3SKEDhn6WKdKMBk+ihKoGYZhJ3kWeV28Jxuz85mmeYpPzoiE=
Received: from MWHPR15MB1597.namprd15.prod.outlook.com (10.173.234.137) by
 MWHPR15MB1263.namprd15.prod.outlook.com (10.175.2.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Mon, 30 Dec 2019 19:22:40 +0000
Received: from MWHPR15MB1597.namprd15.prod.outlook.com
 ([fe80::cdbf:b63c:437:4dd2]) by MWHPR15MB1597.namprd15.prod.outlook.com
 ([fe80::cdbf:b63c:437:4dd2%8]) with mapi id 15.20.2581.007; Mon, 30 Dec 2019
 19:22:40 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [net-next PATCH] net/ncsi: Fix gma flag setting after response
Thread-Topic: [net-next PATCH] net/ncsi: Fix gma flag setting after response
Thread-Index: AQHVvQcvq4Utc53XEUy7GF5JxeUuH6fP1s4AgAK2CAA=
Date:   Mon, 30 Dec 2019 19:22:40 +0000
Message-ID: <18C0CEBF-04F1-4597-911A-3C55C09FA15E@fb.com>
References: <20191227224349.2182366-1-vijaykhemka@fb.com>
 <9d5d71d2cb6be3d98ccd85f971667c2e0ed32e06.camel@mendozajonas.com>
In-Reply-To: <9d5d71d2cb6be3d98ccd85f971667c2e0ed32e06.camel@mendozajonas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:9565]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e52cb65-4fe3-4229-1356-08d78d5da35e
x-ms-traffictypediagnostic: MWHPR15MB1263:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1263E0B096C06CE02167AD51DD270@MWHPR15MB1263.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(189003)(66446008)(478600001)(2616005)(66946007)(36756003)(64756008)(66476007)(66556008)(76116006)(6506007)(6486002)(6512007)(8936002)(33656002)(186003)(8676002)(81156014)(81166006)(86362001)(4001150100001)(71200400001)(54906003)(110136005)(2906002)(4326008)(5660300002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1263;H:MWHPR15MB1597.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vwLbmKg6E9++sl7Nr5Bnfbk5IebPbqcU+16ftcIm5dY3dIEOSUJRpMqwpCeputoFUN0wYpcr2HBIha9ELDpRrzvfjCCHuqgkZDEfMuWsei733naqFQJHYtA1z2VHe+x66FwqsADo1MRkpyN/dLzz75v79IMvSbGpqby57BngXXf5Eo1q2xU8oWaYLd0LBrdvRBD4phIa5AcQLzhLgxpw94Jtxn7/e6gokx4vRc5bK8EVkQVnljI7fqHA2dH/L5sf+Kiy2rpUIDHMEpzpoBB8pwqytjsOqWApX2R+vRfh3PVGj+H4bRzOldIKyzy+vI6YFkq97QeAeY+W2Y4a+F8anSGXcLg6JNNb57BAHh/Z4aMDoGpSAsZsEWzu82n21T8kf9DvyJdLixudNNe1KT+lXzBVJDdI6RN9/OU+PUyaMBMNN9kzh78sEyNz5o53wMkq
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7ECFAAB92627540A2B9CD031AE2206C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e52cb65-4fe3-4229-1356-08d78d5da35e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2019 19:22:40.7281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kRtAUy1Atmn0qGDak+OLCO939/XAXIcjsh8jGqYcAggySYnCQ2Hx3svyOy9jP6a00PdZWxb5D8sKdpKBkws0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-30_06:2019-12-27,2019-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912300174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEyLzI4LzE5LCA5OjU4IEFNLCAiU2FtdWVsIE1lbmRvemEtSm9uYXMiIDxzYW1A
bWVuZG96YWpvbmFzLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBGcmksIDIwMTktMTItMjcgYXQgMTQ6
NDMgLTA4MDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+IGdtYV9mbGFnIHdhcyBzZXQgYXQg
dGhlIHRpbWUgb2YgR01BIGNvbW1hbmQgcmVxdWVzdCBidXQgaXQgc2hvdWxkDQogICAgPiBvbmx5
IGJlIHNldCBhZnRlciBnZXR0aW5nIHN1Y2Nlc3NmdWwgcmVzcG9uc2UuIE1vdmlubmcgdGhpcyBm
bGFnDQogICAgPiBzZXR0aW5nIGluIEdNQSByZXNwb25zZSBoYW5kbGVyLg0KICAgID4gDQogICAg
PiBUaGlzIGZsYWcgaXMgdXNlZCBtYWlubHkgZm9yIG5vdCByZXBlYXRpbmcgR01BIGNvbW1hbmQg
b25jZQ0KICAgID4gcmVjZWl2ZWQgTUFDIGFkZHJlc3MuDQogICAgPiANCiAgICA+IFNpZ25lZC1v
ZmYtYnk6IFZpamF5IEtoZW1rYSA8dmlqYXlraGVta2FAZmIuY29tPg0KICAgIA0KICAgIFRlY2hu
aWNhbGx5IHRoaXMgbWVhbnMgdGhlIGRyaXZlciB3aWxsIGFsd2F5cyBzZW5kIHRoaXMgY29tbWFu
ZCBldmVyeQ0KICAgIHRpbWUgaXQgY29uZmlndXJlcyBpZiB0aGUgYXNzb2NpYXRlZCBOSUMgZG9l
c24ndCByZXNwb25kIHRvIHRoaXMNCiAgICBjb21tYW5kLCBidXQgdGhhdCB3b24ndCBjaGFuZ2Ug
dGhlIGJlaGF2aW91ciBvdGhlcndpc2UuDQoNClllcyBTYW0sIHlvdSBhcmUgcmlnaHQuIA0KICAg
IA0KICAgIFJldmlld2VkLWJ5OiBTYW11ZWwgTWVuZG96YS1Kb25hcyA8c2FtQG1lbmRvemFqb25h
cy5jb20+DQogICAgDQogICAgPiAtLS0NCiAgICA+ICBuZXQvbmNzaS9uY3NpLW1hbmFnZS5jIHwg
MyAtLS0NCiAgICA+ICBuZXQvbmNzaS9uY3NpLXJzcC5jICAgIHwgNiArKysrKysNCiAgICA+ICAy
IGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCiAgICA+IA0K
ICAgID4gZGlmZiAtLWdpdCBhL25ldC9uY3NpL25jc2ktbWFuYWdlLmMgYi9uZXQvbmNzaS9uY3Np
LW1hbmFnZS5jDQogICAgPiBpbmRleCA3MGZlMDI2OTc1NDQuLmUyMGI4MTUxNDAyOSAxMDA2NDQN
CiAgICA+IC0tLSBhL25ldC9uY3NpL25jc2ktbWFuYWdlLmMNCiAgICA+ICsrKyBiL25ldC9uY3Np
L25jc2ktbWFuYWdlLmMNCiAgICA+IEBAIC03NjQsOSArNzY0LDYgQEAgc3RhdGljIGludCBuY3Np
X2dtYV9oYW5kbGVyKHN0cnVjdCBuY3NpX2NtZF9hcmcNCiAgICA+ICpuY2EsIHVuc2lnbmVkIGlu
dCBtZl9pZCkNCiAgICA+ICAJCXJldHVybiAtMTsNCiAgICA+ICAJfQ0KICAgID4gIA0KICAgID4g
LQkvKiBTZXQgdGhlIGZsYWcgZm9yIEdNQSBjb21tYW5kIHdoaWNoIHNob3VsZCBvbmx5IGJlIGNh
bGxlZA0KICAgID4gb25jZSAqLw0KICAgID4gLQluY2EtPm5kcC0+Z21hX2ZsYWcgPSAxOw0KICAg
ID4gLQ0KICAgID4gIAkvKiBHZXQgTWFjIGFkZHJlc3MgZnJvbSBOQ1NJIGRldmljZSAqLw0KICAg
ID4gIAlyZXR1cm4gbmNoLT5oYW5kbGVyKG5jYSk7DQogICAgPiAgfQ0KICAgID4gZGlmZiAtLWdp
dCBhL25ldC9uY3NpL25jc2ktcnNwLmMgYi9uZXQvbmNzaS9uY3NpLXJzcC5jDQogICAgPiBpbmRl
eCBkNTYxMWYwNDkyNmQuLmE5NGJiNTk3OTNmMCAxMDA2NDQNCiAgICA+IC0tLSBhL25ldC9uY3Np
L25jc2ktcnNwLmMNCiAgICA+ICsrKyBiL25ldC9uY3NpL25jc2ktcnNwLmMNCiAgICA+IEBAIC02
MjcsNiArNjI3LDkgQEAgc3RhdGljIGludCBuY3NpX3JzcF9oYW5kbGVyX29lbV9tbHhfZ21hKHN0
cnVjdA0KICAgID4gbmNzaV9yZXF1ZXN0ICpucikNCiAgICA+ICAJc2FkZHIuc2FfZmFtaWx5ID0g
bmRldi0+dHlwZTsNCiAgICA+ICAJbmRldi0+cHJpdl9mbGFncyB8PSBJRkZfTElWRV9BRERSX0NI
QU5HRTsNCiAgICA+ICAJbWVtY3B5KHNhZGRyLnNhX2RhdGEsICZyc3AtPmRhdGFbTUxYX01BQ19B
RERSX09GRlNFVF0sDQogICAgPiBFVEhfQUxFTik7DQogICAgPiArCS8qIFNldCB0aGUgZmxhZyBm
b3IgR01BIGNvbW1hbmQgd2hpY2ggc2hvdWxkIG9ubHkgYmUgY2FsbGVkDQogICAgPiBvbmNlICov
DQogICAgPiArCW5kcC0+Z21hX2ZsYWcgPSAxOw0KICAgID4gKw0KICAgID4gIAlyZXQgPSBvcHMt
Pm5kb19zZXRfbWFjX2FkZHJlc3MobmRldiwgJnNhZGRyKTsNCiAgICA+ICAJaWYgKHJldCA8IDAp
DQogICAgPiAgCQluZXRkZXZfd2FybihuZGV2LCAiTkNTSTogJ1dyaXRpbmcgbWFjIGFkZHJlc3Mg
dG8gZGV2aWNlDQogICAgPiBmYWlsZWRcbiIpOw0KICAgID4gQEAgLTY3MSw2ICs2NzQsOSBAQCBz
dGF0aWMgaW50IG5jc2lfcnNwX2hhbmRsZXJfb2VtX2JjbV9nbWEoc3RydWN0DQogICAgPiBuY3Np
X3JlcXVlc3QgKm5yKQ0KICAgID4gIAlpZiAoIWlzX3ZhbGlkX2V0aGVyX2FkZHIoKGNvbnN0IHU4
ICopc2FkZHIuc2FfZGF0YSkpDQogICAgPiAgCQlyZXR1cm4gLUVOWElPOw0KICAgID4gIA0KICAg
ID4gKwkvKiBTZXQgdGhlIGZsYWcgZm9yIEdNQSBjb21tYW5kIHdoaWNoIHNob3VsZCBvbmx5IGJl
IGNhbGxlZA0KICAgID4gb25jZSAqLw0KICAgID4gKwluZHAtPmdtYV9mbGFnID0gMTsNCiAgICA+
ICsNCiAgICA+ICAJcmV0ID0gb3BzLT5uZG9fc2V0X21hY19hZGRyZXNzKG5kZXYsICZzYWRkcik7
DQogICAgPiAgCWlmIChyZXQgPCAwKQ0KICAgID4gIAkJbmV0ZGV2X3dhcm4obmRldiwgIk5DU0k6
ICdXcml0aW5nIG1hYyBhZGRyZXNzIHRvIGRldmljZQ0KICAgID4gZmFpbGVkXG4iKTsNCiAgICAN
CiAgICANCg0K
