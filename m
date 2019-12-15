Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4911F8CA
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 17:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLOQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 11:10:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726135AbfLOQK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 11:10:29 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBFGAD1L012526;
        Sun, 15 Dec 2019 08:10:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BkE8QjO25UBApcCF9mWvDaHAdiUQ/ghTF+hQ9jZTRwA=;
 b=XBLpLmtlr5i6n5IOn6WeMHvCblCXVnAvLOVXDuNd1vPO0zaTviHz4pXm7lsM0eH9vQKy
 D6sNL5l2Lz7xefkOUc2O9oV+tTCJWkCiyxSgeZhuYyw6BPToZSYsIzioekJpEltvMCrK
 +Dp6Twzad/OGq0mM8rKFCoR/7+UIpliOYDU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgmcrynd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 15 Dec 2019 08:10:13 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 15 Dec 2019 08:10:11 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Dec 2019 08:10:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQhnZCAaT1JxQjrJvTZTkEy0sYlhBDENWiG8PHAhVmLJidNn1fFcVH3AvHQPLfjboLL7UaE/a0enKs2sQ93BfbXVOGOjsejGPTh9Hhyh9aCSUUqRHwnOm5D5ubzFWftT6XRq4pFqW+UC1oWiGXtDZZkSGj1BsUtVlZz9Li7Mg4rhfnJ1r405fhQMP0haDyqpwg/m41aUT5OkUczHdr8b0aZRqOfr4P3Tn58nfYoj+AHn6/LoGJh4NB78YuiBgn0vPVk/lbV4a4WVLnrur7qFjSzLIpYTTJK1FEjuX9D4jk6QXIWb+qz02RHdY3tKbCKv82D0hDqJEDUq1NAQctFXFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkE8QjO25UBApcCF9mWvDaHAdiUQ/ghTF+hQ9jZTRwA=;
 b=bkK4YaADq3M06ii1gd8Sin28Pf2jFeVQOCe9yvu+2KLGUViMetkljppe6a4zipGwcugY6VaqPDJefukqsxsls1832pIdtuRBsygGNBiTNl8XZN8p49M+qEYrXzs6yolg+R5Xt261UpRJQyRr2cm+WSebiwfMmmWh6yu//Az+vH9j/0DDHNuz1Dkl62Q7mHl2OvbOGya8m9KoLFQPk8p2nzVYsHy8pOsKEx/rRReDMS881Z84BiSzV+e5KdBb+VkUSzk7yCGFIalKu1tWkAPCpA67FsQf/jAWXNnJYeSKNFr0DHQmyNfNhtAFqZPVKzZka+N0KfHA9/RFpYv7M3edag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkE8QjO25UBApcCF9mWvDaHAdiUQ/ghTF+hQ9jZTRwA=;
 b=gkhTk4NkOmckzJnzU5t5uohzPSPt35gDAj74NuakzyX3encfB9UmIM3HqF5n7DVqyLikoXQfz6c8gqlIH62/dZmFAEBBZL3ZCRXqs9QcONzWx/grVhLQX0Rta4KWZrkkBlGEywebeeZ+QsmALEpBqoZPmld7VI2pIRW3Ty6cHJg=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1497.namprd15.prod.outlook.com (10.173.225.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Sun, 15 Dec 2019 16:10:10 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 16:10:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Thread-Topic: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Thread-Index: AQHVsvxXzJN9aTKnK0ael6l0VjzbR6e7XkIA
Date:   Sun, 15 Dec 2019 16:10:10 +0000
Message-ID: <aa4bf1b3-0411-1a04-6156-3fb97add1f2c@fb.com>
References: <cover.1576381511.git.ethercflow@gmail.com>
 <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
In-Reply-To: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0015.namprd20.prod.outlook.com
 (2603:10b6:301:15::25) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b685]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c2496f7-c7e1-437e-04f9-08d78179429e
x-ms-traffictypediagnostic: DM5PR15MB1497:
x-microsoft-antispam-prvs: <DM5PR15MB1497C1D7798897AD6B901532D3560@DM5PR15MB1497.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(396003)(346002)(136003)(189003)(199004)(4326008)(2906002)(8936002)(8676002)(81166006)(81156014)(52116002)(478600001)(2616005)(6486002)(6512007)(64756008)(86362001)(66446008)(66476007)(66946007)(66556008)(31696002)(5660300002)(36756003)(71200400001)(110136005)(316002)(186003)(6506007)(31686004)(966005)(54906003)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1497;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Du5PSYNrCbZSi/hBEkg1pryzYj48VT+vKwFiCL40eQCbsfA49UtC1VYspMvdVmc1VyD44KrH6F3RzF5pXYHdyGT+nu7XpskEPuXy/w0+JSo/9fFkv1NmVpCOoue4KRXItR2cX7vNBNfiIBfsdrKmdcxVhadW/GntbKBtEgqKwYNUmKD+QwoXNtObVbXSzQHkdUE5a62t3JSolgKn3haZXuHrkFeDBwa/dhQBee/oXr36r4AfztygWFNMaZZAEbIARlSFcfTatEaRpc7qlbCZvx3z7l+XQfrJWvleP6N/VTqA1a/4PbRtQYgB1ZspBlCWR4+9GLtogoIhx0zMPuFvWEgH07bR1ebRya3/bU49gbIxu8wIW4KAL4/m5LtnxsAxLkoliidEzKiDy2kVl/D6t1MnrFnFES+P8e27NeSBdfv/knct9xIPav4A+KKn7IJ/sNtDYHUPikY00BzchyFgjYZeBTV9KX2ihhbTDXMdUeY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BF4B0E7D8217449BBF6ED948FC572F0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2496f7-c7e1-437e-04f9-08d78179429e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 16:10:10.6741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gemvq9heNfMTLynOGWYi3C7cq/+gV1BaA3H6ieDNpSs/GEVDsgIWck5zusNK2K+3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1497
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_04:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912150150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE0LzE5IDg6MDEgUE0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiBXaGVuIHBlb3Bs
ZSB3YW50IHRvIGlkZW50aWZ5IHdoaWNoIGZpbGUgc3lzdGVtIGZpbGVzIGFyZSBiZWluZyBvcGVu
ZWQsDQo+IHJlYWQsIGFuZCB3cml0dGVuIHRvLCB0aGV5IGNhbiB1c2UgdGhpcyBoZWxwZXIgd2l0
aCBmaWxlIGRlc2NyaXB0b3IgYXMNCj4gaW5wdXQgdG8gYWNoaWV2ZSB0aGlzIGdvYWwuIE90aGVy
IHBzZXVkbyBmaWxlc3lzdGVtcyBhcmUgYWxzbyBzdXBwb3J0ZWQuDQo+IA0KPiBUaGlzIHJlcXVp
cmVtZW50IGlzIG1haW5seSBkaXNjdXNzZWQgaGVyZToNCj4gDQo+ICAgIGh0dHBzOi8vZ2l0aHVi
LmNvbS9pb3Zpc29yL2JjYy9pc3N1ZXMvMjM3DQo+IA0KPiB2MTEtPnYxMjogYWRkcmVzc2VkIEFs
ZXhlaSdzIGZlZWRiYWNrDQo+IC0gb25seSBhbGxvdyB0cmFjZXBvaW50cyB0byBtYWtlIHN1cmUg
aXQgd29uJ3QgZGVhZCBsb2NrDQo+IA0KPiB2MTAtPnYxMTogYWRkcmVzc2VkIEFsIGFuZCBBbGV4
ZWkncyBmZWVkYmFjaw0KPiAtIGZpeCBtaXNzaW5nIGZwdXQoKQ0KPiANCj4gdjktPnYxMDogYWRk
cmVzc2VkIEFuZHJpaSdzIGZlZWRiYWNrDQo+IC0gc2VuZCB0aGlzIHBhdGNoIHRvZ2V0aGVyIHdp
dGggdGhlIHBhdGNoIHNlbGZ0ZXN0cyBhcyBvbmUgcGF0Y2ggc2VyaWVzDQo+IA0KPiB2OC0+djk6
DQo+IC0gZm9ybWF0IGhlbHBlciBkZXNjcmlwdGlvbg0KPiANCj4gdjctPnY4OiBhZGRyZXNzZWQg
QWxleGVpJ3MgZmVlZGJhY2sNCj4gLSB1c2UgZmdldF9yYXcgaW5zdGVhZCBvZiBmZGdldF9yYXcs
IGFzIGZkZ2V0X3JhdyBpcyBvbmx5IHVzZWQgaW5zaWRlIGZzLw0KPiAtIGVuc3VyZSB3ZSdyZSBp
biB1c2VyIGNvbnRleHQgd2hpY2ggaXMgc2FmZSBmb3QgdGhlIGhlbHAgdG8gcnVuDQo+IC0gZmls
dGVyIHVubW91bnRhYmxlIHBzZXVkbyBmaWxlc3lzdGVtLCBiZWNhdXNlIHRoZXkgZG9uJ3QgaGF2
ZSByZWFsIHBhdGgNCj4gLSBzdXBwbGVtZW50IHRoZSBkZXNjcmlwdGlvbiBvZiB0aGlzIGhlbHBl
ciBmdW5jdGlvbg0KPiANCj4gdjYtPnY3Og0KPiAtIGZpeCBtaXNzaW5nIHNpZ25lZC1vZmYtYnkg
bGluZQ0KPiANCj4gdjUtPnY2OiBhZGRyZXNzZWQgQW5kcmlpJ3MgZmVlZGJhY2sNCj4gLSBhdm9p
ZCB1bm5lY2Vzc2FyeSBnb3RvIGVuZCBieSBoYXZpbmcgdHdvIGV4cGxpY2l0IHJldHVybnMNCj4g
DQo+IHY0LT52NTogYWRkcmVzc2VkIEFuZHJpaSBhbmQgRGFuaWVsJ3MgZmVlZGJhY2sNCj4gLSBy
ZW5hbWUgYnBmX2ZkMnBhdGggdG8gYnBmX2dldF9maWxlX3BhdGggdG8gYmUgY29uc2lzdGVudCB3
aXRoIG90aGVyDQo+IGhlbHBlcidzIG5hbWVzDQo+IC0gd2hlbiBmZGdldF9yYXcgZmFpbHMsIHNl
dCByZXQgdG8gLUVCQURGIGluc3RlYWQgb2YgLUVJTlZBTA0KPiAtIHJlbW92ZSBmZHB1dCBmcm9t
IGZkZ2V0X3JhdydzIGVycm9yIHBhdGgNCj4gLSB1c2UgSVNfRVJSIGluc3RlYWQgb2YgSVNfRVJS
X09SX05VTEwgYXMgZF9wYXRoIGV0aGVyIHJldHVybnMgYSBwb2ludGVyDQo+IGludG8gdGhlIGJ1
ZmZlciBvciBhbiBlcnJvciBjb2RlIGlmIHRoZSBwYXRoIHdhcyB0b28gbG9uZw0KPiAtIG1vZGlm
eSB0aGUgbm9ybWFsIHBhdGgncyByZXR1cm4gdmFsdWUgdG8gcmV0dXJuIGNvcGllZCBzdHJpbmcg
bGVuZ3RoDQo+IGluY2x1ZGluZyBOVUwNCj4gLSB1cGRhdGUgdGhpcyBoZWxwZXIgZGVzY3JpcHRp
b24ncyBSZXR1cm4gYml0cy4NCj4gDQo+IHYzLT52NDogYWRkcmVzc2VkIERhbmllbCdzIGZlZWRi
YWNrDQo+IC0gZml4IG1pc3NpbmcgZmRwdXQoKQ0KPiAtIG1vdmUgZmQycGF0aCBmcm9tIGtlcm5l
bC9icGYvdHJhY2UuYyB0byBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gLSBtb3ZlIGZkMnBh
dGgncyB0ZXN0IGNvZGUgdG8gYW5vdGhlciBwYXRjaA0KPiAtIGFkZCBjb21tZW50IHRvIGV4cGxh
aW4gd2h5IHVzZSBmZGdldF9yYXcgaW5zdGVhZCBvZiBmZGdldA0KPiANCj4gdjItPnYzOiBhZGRy
ZXNzZWQgWW9uZ2hvbmcncyBmZWVkYmFjaw0KPiAtIHJlbW92ZSB1bm5lY2Vzc2FyeSBMT0NLRE9X
Tl9CUEZfUkVBRA0KPiAtIHJlZmFjdG9yIGVycm9yIGhhbmRsaW5nIHNlY3Rpb24gZm9yIGVuaGFu
Y2VkIHJlYWRhYmlsaXR5DQo+IC0gcHJvdmlkZSBhIHRlc3QgY2FzZSBpbiB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYNCj4gDQo+IHYxLT52MjogYWRkcmVzc2VkIERhbmllbCdzIGZlZWRiYWNr
DQo+IC0gZml4IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkNCj4gLSBhZGQgdGhpcyBoZWxwZXIgZGVz
Y3JpcHRpb24NCj4gLSBmaXggc2lnbmVkLW9mZiBuYW1lDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBX
ZW5ibyBaaGFuZyA8ZXRoZXJjZmxvd0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGluY2x1ZGUvdWFw
aS9saW51eC9icGYuaCAgICAgICB8IDI5ICsrKysrKysrKysrKystDQo+ICAga2VybmVsL3RyYWNl
L2JwZl90cmFjZS5jICAgICAgIHwgNzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiAgIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDI5ICsrKysrKysrKysrKyst
DQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxMjYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3Vh
cGkvbGludXgvYnBmLmgNCj4gaW5kZXggZGJiY2YwYjAyOTcwLi43MWQ5NzA1ZGYxMjAgMTAwNjQ0
DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiArKysgYi9pbmNsdWRlL3VhcGkv
bGludXgvYnBmLmgNCj4gQEAgLTI4MjEsNiArMjgyMSwzMiBAQCB1bmlvbiBicGZfYXR0ciB7DQo+
ICAgICogCVJldHVybg0KPiAgICAqIAkJT24gc3VjY2VzcywgdGhlIHN0cmljdGx5IHBvc2l0aXZl
IGxlbmd0aCBvZiB0aGUgc3RyaW5nLAlpbmNsdWRpbmcNCj4gICAgKiAJCXRoZSB0cmFpbGluZyBO
VUwgY2hhcmFjdGVyLiBPbiBlcnJvciwgYSBuZWdhdGl2ZSB2YWx1ZS4NCj4gKyAqDQo+ICsgKiBp
bnQgYnBmX2dldF9maWxlX3BhdGgoY2hhciAqcGF0aCwgdTMyIHNpemUsIGludCBmZCkNCj4gKyAq
CURlc2NyaXB0aW9uDQo+ICsgKgkJR2V0ICoqZmlsZSoqIGF0cnJpYnV0ZSBmcm9tIHRoZSBjdXJy
ZW50IHRhc2sgYnkgKmZkKiwgdGhlbiBjYWxsDQo+ICsgKgkJKipkX3BhdGgqKiB0byBnZXQgaXQn
cyBhYnNvbHV0ZSBwYXRoIGFuZCBjb3B5IGl0IGFzIHN0cmluZyBpbnRvDQo+ICsgKgkJKnBhdGgq
IG9mICpzaXplKi4gTm90aWNlIHRoZSAqKnBhdGgqKiBkb24ndCBzdXBwb3J0IHVubW91bnRhYmxl
DQo+ICsgKgkJcHNldWRvIGZpbGVzeXN0ZW1zIGFzIHRoZXkgZG9uJ3QgaGF2ZSBwYXRoIChlZzog
U09DS0ZTLCBQSVBFRlMpLg0KPiArICoJCVRoZSAqc2l6ZSogbXVzdCBiZSBzdHJpY3RseSBwb3Np
dGl2ZS4gT24gc3VjY2VzcywgdGhlIGhlbHBlcg0KPiArICoJCW1ha2VzIHN1cmUgdGhhdCB0aGUg
KnBhdGgqIGlzIE5VTC10ZXJtaW5hdGVkLCBhbmQgdGhlIGJ1ZmZlcg0KPiArICoJCWNvdWxkIGJl
Og0KPiArICoJCS0gYSByZWd1bGFyIGZ1bGwgcGF0aCAoaW5jbHVkZSBtb3VudGFibGUgZnMgZWc6
IC9wcm9jLCAvc3lzKQ0KPiArICoJCS0gYSByZWd1bGFyIGZ1bGwgcGF0aCB3aXRoICIoZGVsZXRl
ZCkiIGF0IHRoZSBlbmQuDQo+ICsgKgkJT24gZmFpbHVyZSwgaXQgaXMgZmlsbGVkIHdpdGggemVy
b2VzLg0KPiArICoJUmV0dXJuDQo+ICsgKgkJT24gc3VjY2VzcywgcmV0dXJucyB0aGUgbGVuZ3Ro
IG9mIHRoZSBjb3BpZWQgc3RyaW5nIElOQ0xVRElORw0KPiArICoJCXRoZSB0cmFpbGluZyBOVUwu
DQo+ICsgKg0KPiArICoJCU9uIGZhaWx1cmUsIHRoZSByZXR1cm5lZCB2YWx1ZSBpcyBvbmUgb2Yg
dGhlIGZvbGxvd2luZzoNCj4gKyAqDQo+ICsgKgkJKiotRVBFUk0qKiBpZiBubyBwZXJtaXNzaW9u
IHRvIGdldCB0aGUgcGF0aCAoZWc6IGluIGlycSBjdHgpLg0KPiArICoNCj4gKyAqCQkqKi1FQkFE
RioqIGlmICpmZCogaXMgaW52YWxpZC4NCj4gKyAqDQo+ICsgKgkJKiotRUlOVkFMKiogaWYgKmZk
KiBjb3JyZXNwb25kcyB0byBhIHVubW91bnRhYmxlIHBzZXVkbyBmcw0KPiArICoNCj4gKyAqCQkq
Ki1FTkFNRVRPT0xPTkcqKiBpZiBmdWxsIHBhdGggaXMgbG9uZ2VyIHRoYW4gKnNpemUqDQo+ICAg
ICovDQo+ICAgI2RlZmluZSBfX0JQRl9GVU5DX01BUFBFUihGTikJCVwNCj4gICAJRk4odW5zcGVj
KSwJCQlcDQo+IEBAIC0yOTM4LDcgKzI5NjQsOCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ICAgCUZO
KHByb2JlX3JlYWRfdXNlciksCQlcDQo+ICAgCUZOKHByb2JlX3JlYWRfa2VybmVsKSwJCVwNCj4g
ICAJRk4ocHJvYmVfcmVhZF91c2VyX3N0ciksCVwNCj4gLQlGTihwcm9iZV9yZWFkX2tlcm5lbF9z
dHIpLA0KPiArCUZOKHByb2JlX3JlYWRfa2VybmVsX3N0ciksCVwNCj4gKwlGTihnZXRfZmlsZV9w
YXRoKSwNCj4gICANCj4gICAvKiBpbnRlZ2VyIHZhbHVlIGluICdpbW0nIGZpZWxkIG9mIEJQRl9D
QUxMIGluc3RydWN0aW9uIHNlbGVjdHMgd2hpY2ggaGVscGVyDQo+ICAgICogZnVuY3Rpb24gZUJQ
RiBwcm9ncmFtIGludGVuZHMgdG8gY2FsbA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2Jw
Zl90cmFjZS5jIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+IGluZGV4IGU1ZWY0YWU5ZWRi
NS4uZGI5YzBlYzQ2YTVkIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMN
Cj4gKysrIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+IEBAIC03NjIsNiArNzYyLDcyIEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3NlbmRfc2lnbmFsX3Byb3Rv
ID0gew0KPiAgIAkuYXJnMV90eXBlCT0gQVJHX0FOWVRISU5HLA0KPiAgIH07DQo+ICAgDQo+ICtC
UEZfQ0FMTF8zKGJwZl9nZXRfZmlsZV9wYXRoLCBjaGFyICosIGRzdCwgdTMyLCBzaXplLCBpbnQs
IGZkKQ0KPiArew0KPiArCXN0cnVjdCBmaWxlICpmOw0KPiArCWNoYXIgKnA7DQo+ICsJaW50IHJl
dCA9IC1FQkFERjsNCg0KcGxlYXNlIHRyeSB0byB1c2UgcmV2ZXJzZSBDaHJpc3RtYXMgdHJlZSBm
b3IgZGVjbGFyYXRpb25zLg0KDQo+ICsNCj4gKwkvKiBFbnN1cmUgd2UncmUgaW4gdXNlciBjb250
ZXh0IHdoaWNoIGlzIHNhZmUgZm9yIHRoZSBoZWxwZXIgdG8NCj4gKwkgKiBydW4uIFRoaXMgaGVs
cGVyIGhhcyBubyBidXNpbmVzcyBpbiBhIGt0aHJlYWQuDQo+ICsJICovDQo+ICsJaWYgKHVubGlr
ZWx5KGluX2ludGVycnVwdCgpIHx8DQo+ICsJCSAgICAgY3VycmVudC0+ZmxhZ3MgJiAoUEZfS1RI
UkVBRCB8IFBGX0VYSVRJTkcpKSkgew0KPiArCQlyZXQgPSAtRVBFUk07DQo+ICsJCWdvdG8gZXJy
b3I7DQo+ICsJfQ0KPiArDQo+ICsJLyogVXNlIGZnZXRfcmF3IGluc3RlYWQgb2YgZmdldCB0byBz
dXBwb3J0IE9fUEFUSCwgYW5kIGl0IGRvZXNuJ3QNCj4gKwkgKiBoYXZlIGFueSBzbGVlcGFibGUg
Y29kZSwgc28gaXQncyBvayB0byBiZSBoZXJlLg0KPiArCSAqLw0KPiArCWYgPSBmZ2V0X3Jhdyhm
ZCk7DQo+ICsJaWYgKCFmKQ0KPiArCQlnb3RvIGVycm9yOw0KPiArDQo+ICsJLyogRm9yIHVubW91
bnRhYmxlIHBzZXVkbyBmaWxlc3lzdGVtLCBpdCBzZWVtcyB0byBoYXZlIG5vIG1lYW5pbmcNCj4g
KwkgKiB0byBnZXQgdGhlaXIgZmFrZSBwYXRocyBhcyB0aGV5IGRvbid0IGhhdmUgcGF0aCwgYW5k
IHRvIGJlIG5vDQo+ICsJICogd2F5IHRvIHZhbGlkYXRlIHRoaXMgZnVuY3Rpb24gcG9pbnRlciBj
YW4gYmUgYWx3YXlzIHNhZmUgdG8gY2FsbA0KPiArCSAqIGluIHRoZSBjdXJyZW50IGNvbnRleHQu
DQo+ICsJICovDQo+ICsJaWYgKGYtPmZfcGF0aC5kZW50cnktPmRfb3AgJiYgZi0+Zl9wYXRoLmRl
bnRyeS0+ZF9vcC0+ZF9kbmFtZSkgew0KPiArCQlyZXQgPSAtRUlOVkFMOw0KPiArCQlmcHV0KGYp
Ow0KPiArCQlnb3RvIGVycm9yOw0KPiArCX0NCj4gKw0KPiArCS8qIEFmdGVyIGZpbHRlciB1bm1v
dW50YWJsZSBwc2V1ZG8gZmlsZXN5dGVtLCBkX3BhdGggd29uJ3QgY2FsbA0KPiArCSAqIGRlbnRy
eS0+ZF9vcC0+ZF9uYW1lKCksIHRoZSBub3JtYWxseSBwYXRoIGRvZXNuJ3QgaGF2ZSBhbnkNCj4g
KwkgKiBzbGVlcGFibGUgY29kZSwgYW5kIGRlc3BpdGUgaXQgdXNlcyB0aGUgY3VycmVudCBtYWNy
byB0byBnZXQNCj4gKwkgKiBmc19zdHJ1Y3QgKGN1cnJlbnQtPmZzKSwgd2UndmUgYWxyZWFkeSBl
bnN1cmVkIHdlJ3JlIGluIHVzZXINCj4gKwkgKiBjb250ZXh0LCBzbyBpdCdzIG9rIHRvIGJlIGhl
cmUuDQo+ICsJICovDQo+ICsJcCA9IGRfcGF0aCgmZi0+Zl9wYXRoLCBkc3QsIHNpemUpOw0KPiAr
CWlmIChJU19FUlIocCkpIHsNCj4gKwkJcmV0ID0gUFRSX0VSUihwKTsNCj4gKwkJZnB1dChmKTsN
Cj4gKwkJZ290byBlcnJvcjsNCj4gKwl9DQo+ICsNCj4gKwlyZXQgPSBzdHJsZW4ocCk7DQo+ICsJ
bWVtbW92ZShkc3QsIHAsIHJldCk7DQo+ICsJZHN0W3JldCsrXSA9ICdcMCc7DQo+ICsJZnB1dChm
KTsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArDQo+ICtlcnJvcjoNCj4gKwltZW1zZXQoZHN0LCAnMCcs
IHNpemUpOw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsNClsuLi5dDQo=
