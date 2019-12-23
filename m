Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E210D129A66
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLWTd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:33:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbfLWTd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 14:33:59 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNJTTLq015709;
        Mon, 23 Dec 2019 11:33:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=69JQjPCnyOtCykoj4NTG9tkxLNzmVZGUdE/RQjxW4fU=;
 b=KqT7zuNvrl9E/r9ovrfk7WAcAKKF8U2dx4RV4sJDgkiQhlrdBI0MngMztXsnU4S8gVtL
 gPi7R5UrOrJ1WfqqsYqREFyNTIOwjPorTlsuMSniNit0/b5YaV3/OlaKzAOXcBSOwMd3
 Y+5ofnkgYRoKS4LVI3S7aYEQuV+VhDbdr40= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x1hswgn08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 11:33:43 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 23 Dec 2019 11:33:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Dec 2019 11:33:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPzNom4QQV6KDVLlauueh8JyGL0cbyO5YSyGwsf+26OrmbD/dn52ODR8dVCZK6QCNssIMfWVapDG48fABJ6vvYLYQNjgOSQlS9CRmraVcJKpNFBsCJZflBntUIRA4bxTe51571ZLsO5oLjZdulF8frPO+/qyKyyy/OujExl/whM4gv6Ms1OxVnpVd9IN9BCfsG1nZvNhdDjf1oiMjPYsCjdnuEIMLesaEZXQtI6wF8l6ReiA/y0Vi1gliJIx1GmVqKMlvCXJtXWWnme30YxAuAcdzv/n+khYAHDRsQRFCA+n9WD0dm9im0BMYxLfZ9kOteqQk9FKae5r7cxKn+0KGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69JQjPCnyOtCykoj4NTG9tkxLNzmVZGUdE/RQjxW4fU=;
 b=ZFX8SDkuwF9ZfqSklIBiwArma0qisFWnRZKDYbxJJSM/H+xT2hImUTzy4D9XlfwKUIdGzxoVjKbHdIxhNGls67pl66iKutyIg3KvE8nxbMpK4AjDzNkUKEEq2Y+be4EYcfnudlWe+gKakQwJ2BXV7GotIQ69ERNV/K0/AVx1tQWDXUApvQUHkAAByBV3CKbZycXkyd6iwNSP5y39+V73Zi6C55d+11EyVcQEstuVXIbqdVI1xZDNQEd8tloOmFZneiO4lcQBVCI51geFyqkVgZBk2gK+/dYKA+e13zt6D6MCzjB9qbmaAfmlqwf1LWEbgJxPUoRwP0TruI8lLniz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69JQjPCnyOtCykoj4NTG9tkxLNzmVZGUdE/RQjxW4fU=;
 b=UGk4leduy8j013bMBzfdFEYj46wnAwzZRjPWAkN8Q8alqXeYZhQuDAdxPX1bN5I+a4RoTl09xxlJEaFmCoIZ+V96leWCF3Um5RGsL7Y3JaH4MXRgMcFMQJpkswEFTzZTrYlRSkyKNE1LiHzzktWo5mdp8QRWXglSOTvTkwAwBMM=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1177.namprd15.prod.outlook.com (10.173.209.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 19:33:41 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 19:33:40 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::4a23) by MWHPR1401CA0006.namprd14.prod.outlook.com (2603:10b6:301:4b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 19:33:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 05/11] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v2 05/11] bpf: Introduce
 BPF_PROG_TYPE_STRUCT_OPS
Thread-Index: AQHVt8eKP2WKQJFTCEGWlNbUr6aAQ6fIIC+A
Date:   Mon, 23 Dec 2019 19:33:40 +0000
Message-ID: <9da5d3dc-6de5-c3c8-5184-67c5adba97ef@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062606.1182939-1-kafai@fb.com>
In-Reply-To: <20191221062606.1182939-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0006.namprd14.prod.outlook.com
 (2603:10b6:301:4b::16) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::4a23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e65eed4-1446-4aa9-f7c9-08d787df0389
x-ms-traffictypediagnostic: DM5PR15MB1177:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1177EBD22C6412686E99E299D32E0@DM5PR15MB1177.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(376002)(136003)(346002)(189003)(199004)(66446008)(8936002)(6506007)(8676002)(186003)(66476007)(66556008)(64756008)(53546011)(81166006)(52116002)(16526019)(5660300002)(2906002)(86362001)(6486002)(81156014)(4326008)(31686004)(2616005)(71200400001)(6666004)(36756003)(54906003)(316002)(31696002)(6512007)(66946007)(478600001)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1177;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B18TVOV0e7t+Fy07V9hW/cCpOH0EPEPelWlWyvbH047S6JOgHFVnc8vv+y1T50fHctYFVuZtps71urlN3nJNe0uBE/lRtTcWeul+PrzlJpS0Mk+FBoDlSDmsRrSSu/lCEVV5gtlfF4AusStsmnxHSJ4MraYZ/w9y/qWqCApUHUaYK0bh0H9CJ8AJnVVtVrEPc4nfu34yzDj9BoapQydxnSIuMbFm+ZxS7Ga/j9yjsUy/yU+Flyf8I1K+CzEN4osWZSE5Z77nPvFaybKulwd+nQqqYXWZfNOU+OGurAHF932Tz7qClPb7rZ544Hs3DOmCReM5d+iEs6jTjMzeZRGvhTenaKZBziCvIhGs68s20zAhOC+OIPMujvDl99kLl5pNuRphLKp12nh0rgoQAzrAfQ+pS2u2Gm79pIzuIg7XlPJmeXY2kmH0n76z61W3BCdJ
Content-Type: text/plain; charset="utf-8"
Content-ID: <56934AA07C8D4F40AE0DC969B0C7CB61@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e65eed4-1446-4aa9-f7c9-08d787df0389
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 19:33:40.7462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zRXlJCKDGcFsAXcClcIfSH0/o0gWo4Yfpk26PaUwpUBKl3s/1nzmNcQQLil7n5S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1177
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=706 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIwLzE5IDEwOjI2IFBNLCBNYXJ0aW4gS2FGYWkgTGF1IHdyb3RlOg0KPiBUaGlz
IHBhdGNoIGFsbG93cyB0aGUga2VybmVsJ3Mgc3RydWN0IG9wcyAoaS5lLiBmdW5jIHB0cikgdG8g
YmUNCj4gaW1wbGVtZW50ZWQgaW4gQlBGLiAgVGhlIGZpcnN0IHVzZSBjYXNlIGluIHRoaXMgc2Vy
aWVzIGlzIHRoZQ0KPiAic3RydWN0IHRjcF9jb25nZXN0aW9uX29wcyIgd2hpY2ggd2lsbCBiZSBp
bnRyb2R1Y2VkIGluIGENCj4gbGF0dGVyIHBhdGNoLg0KPiANCj4gVGhpcyBwYXRjaCBpbnRyb2R1
Y2VzIGEgbmV3IHByb2cgdHlwZSBCUEZfUFJPR19UWVBFX1NUUlVDVF9PUFMuDQo+IFRoZSBCUEZf
UFJPR19UWVBFX1NUUlVDVF9PUFMgcHJvZyBpcyB2ZXJpZmllZCBhZ2FpbnN0IGEgcGFydGljdWxh
cg0KPiBmdW5jIHB0ciBvZiBhIGtlcm5lbCBzdHJ1Y3QuICBUaGUgYXR0ci0+YXR0YWNoX2J0Zl9p
ZCBpcyB0aGUgYnRmIGlkDQo+IG9mIGEga2VybmVsIHN0cnVjdC4gIFRoZSBhdHRyLT5leHBlY3Rl
ZF9hdHRhY2hfdHlwZSBpcyB0aGUgbWVtYmVyDQo+ICJpbmRleCIgb2YgdGhhdCBrZXJuZWwgc3Ry
dWN0LiAgVGhlIGZpcnN0IG1lbWJlciBvZiBhIHN0cnVjdCBzdGFydHMNCj4gd2l0aCBtZW1iZXIg
aW5kZXggMC4gIFRoYXQgd2lsbCBhdm9pZCBhbWJpZ3VpdHkgd2hlbiBhIGtlcm5lbCBzdHJ1Y3QN
Cj4gaGFzIG11bHRpcGxlIGZ1bmMgcHRycyB3aXRoIHRoZSBzYW1lIGZ1bmMgc2lnbmF0dXJlLg0K
PiANCj4gRm9yIGV4YW1wbGUsIGEgQlBGX1BST0dfVFlQRV9TVFJVQ1RfT1BTIHByb2cgaXMgd3Jp
dHRlbg0KPiB0byBpbXBsZW1lbnQgdGhlICJpbml0IiBmdW5jIHB0ciBvZiB0aGUgInN0cnVjdCB0
Y3BfY29uZ2VzdGlvbl9vcHMiLg0KPiBUaGUgYXR0ci0+YXR0YWNoX2J0Zl9pZCBpcyB0aGUgYnRm
IGlkIG9mIHRoZSAic3RydWN0IHRjcF9jb25nZXN0aW9uX29wcyINCj4gb2YgdGhlIF9ydW5uaW5n
XyBrZXJuZWwuICBUaGUgYXR0ci0+ZXhwZWN0ZWRfYXR0YWNoX3R5cGUgaXMgMy4NCj4gDQo+IFRo
ZSBjdHggb2YgQlBGX1BST0dfVFlQRV9TVFJVQ1RfT1BTIGlzIGFuIGFycmF5IG9mIHU2NCBhcmdz
IHNhdmVkDQo+IGJ5IGFyY2hfcHJlcGFyZV9icGZfdHJhbXBvbGluZSB0aGF0IHdpbGwgYmUgZG9u
ZSBpbiB0aGUgbmV4dA0KPiBwYXRjaCB3aGVuIGludHJvZHVjaW5nIEJQRl9NQVBfVFlQRV9TVFJV
Q1RfT1BTLg0KPiANCj4gInN0cnVjdCBicGZfc3RydWN0X29wcyIgaXMgaW50cm9kdWNlZCBhcyBh
IGNvbW1vbiBpbnRlcmZhY2UgZm9yIHRoZSBrZXJuZWwNCj4gc3RydWN0IHRoYXQgc3VwcG9ydHMg
QlBGX1BST0dfVFlQRV9TVFJVQ1RfT1BTIHByb2cuICBUaGUgc3VwcG9ydGluZyBrZXJuZWwNCj4g
c3RydWN0IHdpbGwgbmVlZCB0byBpbXBsZW1lbnQgYW4gaW5zdGFuY2Ugb2YgdGhlICJzdHJ1Y3Qg
YnBmX3N0cnVjdF9vcHMiLg0KPiANCj4gVGhlIHN1cHBvcnRpbmcga2VybmVsIHN0cnVjdCBhbHNv
IG5lZWRzIHRvIGltcGxlbWVudCBhIGJwZl92ZXJpZmllcl9vcHMuDQo+IER1cmluZyBCUEZfUFJP
R19MT0FELCBicGZfc3RydWN0X29wc19maW5kKCkgd2lsbCBmaW5kIHRoZSByaWdodA0KPiBicGZf
dmVyaWZpZXJfb3BzIGJ5IHNlYXJjaGluZyB0aGUgYXR0ci0+YXR0YWNoX2J0Zl9pZC4NCj4gDQo+
IEEgbmV3ICJidGZfc3RydWN0X2FjY2VzcyIgaXMgYWxzbyBhZGRlZCB0byB0aGUgYnBmX3Zlcmlm
aWVyX29wcyBzdWNoDQo+IHRoYXQgdGhlIHN1cHBvcnRpbmcga2VybmVsIHN0cnVjdCBjYW4gb3B0
aW9uYWxseSBwcm92aWRlIGl0cyBvd24gc3BlY2lmaWMNCj4gY2hlY2sgb24gYWNjZXNzaW5nIHRo
ZSBmdW5jIGFyZyAoZS5nLiBwcm92aWRlIGxpbWl0ZWQgd3JpdGUgYWNjZXNzKS4NCj4gDQo+IEFm
dGVyIGJ0Zl92bWxpbnV4IGlzIHBhcnNlZCwgdGhlIG5ldyBicGZfc3RydWN0X29wc19pbml0KCkg
aXMgY2FsbGVkDQo+IHRvIGluaXRpYWxpemUgc29tZSB2YWx1ZXMgKGUuZy4gdGhlIGJ0ZiBpZCBv
ZiB0aGUgc3VwcG9ydGluZyBrZXJuZWwNCj4gc3RydWN0KSBhbmQgaXQgY2FuIG9ubHkgYmUgZG9u
ZSBvbmNlIHRoZSBidGZfdm1saW51eCBpcyBhdmFpbGFibGUuDQo+IA0KPiBUaGUgUjAgY2hlY2tz
IGF0IEJQRl9FWElUIGlzIGV4Y2x1ZGVkIGZvciB0aGUgQlBGX1BST0dfVFlQRV9TVFJVQ1RfT1BT
IHByb2cNCj4gaWYgdGhlIHJldHVybiB0eXBlIG9mIHRoZSBwcm9nLT5hdXgtPmF0dGFjaF9mdW5j
X3Byb3RvIGlzICJ2b2lkIi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLYUZhaSBMYXUg
PGthZmFpQGZiLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
