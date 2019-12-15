Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CF311F8F3
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 17:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLOQZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 11:25:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41884 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbfLOQZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 11:25:21 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBFGLLGR028635;
        Sun, 15 Dec 2019 08:25:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MIm3u2k5nRzD83SPO5xJ/sxGqb2wvittjfkNqmoCmic=;
 b=qerPVXxSJ8zMAA3/GoMobmsslupufqhY/D4POvaiIGGhgOVyvbIImmD66yTkcay6SNXf
 u5g7GlqAmldSKXVAYjaT39F9wU8+CCiSfao+Wkjge05U2cO0lbzuUrHo6PzPlVfAcVdi
 eUAryJmsn4Fy9foGzs5MopBg2c50kT95gT0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvxeqbhnt-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 08:25:08 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 15 Dec 2019 08:24:52 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Dec 2019 08:24:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=midk4bpSqz7XbMqhGfg2+Wl54Wrjr6vThqQMi+fZKin+rvhnMKIx5X0WHct2hT99fHayQvyOZUY+dApcRjeulZzhzmYJrwok8wPJ/GugelS031ZprYwQUNFC0RMIsj7HYeg56F1v+Gq1VDY0UXacHsYVQal6401LuIP9MXu/ZyyzfYZ+ghJEHIFgXdMWkIsk7hSolYJWlQEuMTP6SqCvNccm2M8Lxtvnw6WfEYkZK3+CfzZPjPK58jSBujVXdyk1MaSZKBprl5TwPYOp1G9IIoOBG0XVsPtMz/1dfJcPe4k7bLSpKXVTu59E7VQK5L3rawxlXpYbGuVn50MMhSQvaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIm3u2k5nRzD83SPO5xJ/sxGqb2wvittjfkNqmoCmic=;
 b=oUnRQ69DNxElGAIPz1h9Z9jXLrgJPK67Eds1xolJj5T1AsuAnaLP86BWJquFV1IpYYSY3KiTYQ1lmRVn+7KhEbb3iiAreU+5RlrBr8nTdalT9PBUlRvd/mjf7NuV2iR2PP9+GyxcKr2jz/DEUaThPNynACFh/Vvl0CRa0HteSuTXdZjziXoWyv7OLDPTeNPC40fNLXS9PwKEK4qDBCEHb+vTWAg/sl3DpTc3OzJGSP81O7XpLkPT6+F9uLO9xeSjX5vz3v/R1xCXAp1Am4WCOpcdBoALJZIdQy0GDn9HOUEZ5eh6/MnhpygzontMzBaBGDMV1njP8/pnuHYWq31hlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIm3u2k5nRzD83SPO5xJ/sxGqb2wvittjfkNqmoCmic=;
 b=IzLWflP4smup5ZfQPhYVuIrV0Eonqx2dq6gfpIFDIRsQKHJ8Q7TF0K6tuYzxVuComx93mkjEPZfbgxuPqHGFcsrsSx9GFQhuEbztaQl/EBy1evzZNUvBZ+a5FyxfPzMqcKrxDT8cSEPqX5na+9XaJb8PXtUor4qu7N3Zsa0lcPs=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1804.namprd15.prod.outlook.com (10.174.108.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Sun, 15 Dec 2019 16:24:37 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 16:24:37 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: test for
 bpf_get_file_path() from tracepoint
Thread-Topic: [PATCH bpf-next v12 2/2] selftests/bpf: test for
 bpf_get_file_path() from tracepoint
Thread-Index: AQHVsvxYmrJNxRpypU29QIi+fvaSJ6e7YkuA
Date:   Sun, 15 Dec 2019 16:24:37 +0000
Message-ID: <737b90af-aa51-bd7d-8f68-b68050cbb028@fb.com>
References: <cover.1576381511.git.ethercflow@gmail.com>
 <088f1485865016d639cadc891957918060261405.1576381512.git.ethercflow@gmail.com>
In-Reply-To: <088f1485865016d639cadc891957918060261405.1576381512.git.ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:104:5::27) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b685]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb1a6c87-52dc-44d0-381e-08d7817b471e
x-ms-traffictypediagnostic: DM5PR15MB1804:
x-microsoft-antispam-prvs: <DM5PR15MB18040AEA427AB247791D76B7D3560@DM5PR15MB1804.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(136003)(376002)(366004)(199004)(189003)(53546011)(186003)(6506007)(8936002)(5660300002)(52116002)(6512007)(8676002)(64756008)(86362001)(66556008)(81166006)(66476007)(81156014)(66446008)(110136005)(54906003)(6486002)(316002)(31696002)(31686004)(2616005)(36756003)(66946007)(71200400001)(4326008)(2906002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1804;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aWUmwceCBlrN/UMkTCMNy2UrwD/sUtZ8IrsVjK1F1b22hLB2WYc6cA4wFc4OxJPbZjG15KnvbCFkzOyfK5JJ7KY08C9y7MZ0F9YHNSHhxuFl46YzQ2mkBmPjfM8udGvrYfn5i+KmY68yQ475qudfjLZVsvWjiV9QiNHkfJIDUwap4Ytcr08fSiC+qNWMFGE01JqiBdcPQQobZ3kFVvb9ZOtOUPftyySBmsUvpyxGw0ZYJwSsZbFCh33VmX9hXiRIW7h1xu+48Fd3djHCj6QxH95GMDmAbsXy/ZrV6S71nM8hcQprah4ACfqslFh0027QqM1RhV4s+CQzxUojns7pZii5MdDRCJVbMpdIpKI65T5HpNJCR8x75Xrdts7ETqN8vu6+JM5J5IVCHg1MZlB/RTBacokpRI80d2DI1MQynOHqsmcNfDso0Y9/WBtLaUm8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A27D7CCF410454CA16BE99B966410F4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1a6c87-52dc-44d0-381e-08d7817b471e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 16:24:37.1717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JRdc4Yq+riwd0fzmGZHVu0GnjLPqdtJPXYzrS/xORkdbfpiKkpY6G0JHFi++xZSP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1804
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_04:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE0LzE5IDg6MDEgUE0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiB0cmFjZSBmc3Rh
dCBldmVudHMgYnkgdHJhY2Vwb2ludCBzeXNjYWxscy9zeXNfZW50ZXJfbmV3ZnN0YXQsIGFuZCBo
YW5kbGUNCj4gZXZlbnRzIG9ubHkgcHJvZHVjZWQgYnkgdGVzdF9maWxlX2dldF9wYXRoLCB3aGlj
aCBjYWxsIGZzdGF0IG9uIHNldmVyYWwNCj4gZGlmZmVyZW50IHR5cGVzIG9mIGZpbGVzIHRvIHRl
c3QgYnBmX2dldF9maWxlX3BhdGgncyBmZWF0dXJlLg0KPiANCj4gdjQtPnY1OiBhZGRyZXNzZWQg
QW5kcmlpJ3MgZmVlZGJhY2sNCj4gLSBwYXNzIE5VTEwgZm9yIG9wdHMgYXMgYnBmX29iamVjdF9f
b3Blbl9maWxlJ3MgUEFSQU0yLCBhcyBub3QgcmVhbGx5DQo+IHVzaW5nIGFueQ0KPiAtIG1vZGlm
eSBwYXRjaCBzdWJqZWN0IHRvIGtlZXAgdXAgd2l0aCB0ZXN0IGNvZGUNCj4gLSBhcyB0aGlzIHRl
c3QgaXMgc2luZ2xlLXRocmVhZGVkLCBzbyB1c2UgZ2V0cGlkIGluc3RlYWQgb2YgU1lTX2dldHRp
ZA0KPiAtIHJlbW92ZSB1bm5lY2Vzc2FyeSBwYXJlbnMgYXJvdW5kIGNoZWNrIHdoaWNoIGFmdGVy
IGlmIChpIDwgMykNCj4gLSBpbiBrZXJuIHVzZSBicGZfZ2V0X2N1cnJlbnRfcGlkX3RnaWQoKSA+
PiAzMiB0byBmaXQgZ2V0cGlkKCkgaW4NCj4gdXNlcnNwYWNlIHBhcnQNCj4gLSB3aXRoIHRoZSBw
YXRjaCBhZGRpbmcgaGVscGVyIGFzIG9uZSBwYXRjaCBzZXJpZXMNCj4gDQo+IHYzLT52NDogYWRk
cmVzc2VkIEFuZHJpaSdzIGZlZWRiYWNrDQo+IC0gdXNlIGEgc2V0IG9mIGZkIGluc3RlYWQgb2Yg
ZmRzIGFycmF5DQo+IC0gdXNlIGdsb2JhbCB2YXJpYWJsZXMgaW5zdGVhZCBvZiBtYXBzIChpbiB2
MywgSSBtaXN0YWtlbmx5IHRob3VnaHQgdGhhdA0KPiB0aGUgYnBmIG1hcHMgYXJlIGdsb2JhbCB2
YXJpYWJsZXMuKQ0KPiAtIHJlbW92ZSB1bmNlc3NhcnkgZ2xvYmFsIHZhcmlhYmxlIHBhdGhfaW5m
b19pbmRleA0KPiAtIHJlbW92ZSBmZCBjb21wYXJlIGFzIHRoZSBmc3RhdCdzIG9yZGVyIGlzIGZp
eGVkDQo+IA0KPiB2Mi0+djM6IGFkZHJlc3NlZCBBbmRyaWkncyBmZWVkYmFjaw0KPiAtIHVzZSBn
bG9iYWwgZGF0YSBpbnN0ZWFkIG9mIHBlcmZfYnVmZmVyIHRvIHNpbXBsaWZpZWQgY29kZQ0KPiAN
Cj4gdjEtPnYyOiBhZGRyZXNzZWQgRGFuaWVsJ3MgZmVlZGJhY2sNCj4gLSByZW5hbWUgYnBmX2Zk
MnBhdGggdG8gYnBmX2dldF9maWxlX3BhdGggdG8gYmUgY29uc2lzdGVudCB3aXRoIG90aGVyDQo+
IGhlbHBlcidzIG5hbWVzDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXZW5ibyBaaGFuZyA8ZXRoZXJj
Zmxvd0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMv
Z2V0X2ZpbGVfcGF0aC5jICB8IDE3MSArKysrKysrKysrKysrKysrKysNCj4gICAuLi4vc2VsZnRl
c3RzL2JwZi9wcm9ncy90ZXN0X2dldF9maWxlX3BhdGguYyAgfCAgNDMgKysrKysNCj4gICAyIGZp
bGVzIGNoYW5nZWQsIDIxNCBpbnNlcnRpb25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2dldF9maWxlX3BhdGguYw0KPiAg
IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVz
dF9nZXRfZmlsZV9wYXRoLmMNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfZmlsZV9wYXRoLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfZmlsZV9wYXRoLmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi43ZWMxMWU0M2UwZmMNCj4gLS0tIC9kZXYvbnVsbA0K
PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfZmlsZV9w
YXRoLmMNCj4gQEAgLTAsMCArMSwxNzEgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wDQo+ICsjZGVmaW5lIF9HTlVfU09VUkNFDQo+ICsjaW5jbHVkZSA8dGVzdF9wcm9n
cy5oPg0KPiArI2luY2x1ZGUgPHN5cy9zdGF0Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvc2NoZWQu
aD4NCj4gKyNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPg0KPiArDQo+ICsjZGVmaW5lIE1BWF9QQVRI
X0xFTgkJMTI4DQo+ICsjZGVmaW5lIE1BWF9GRFMJCQk3DQo+ICsjZGVmaW5lIE1BWF9FVkVOVF9O
VU0JCTE2DQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3QgZmlsZV9wYXRoX3Rlc3RfZGF0YSB7DQo+ICsJ
cGlkX3QgcGlkOw0KPiArCV9fdTMyIGNudDsNCj4gKwlfX3UzMiBmZHNbTUFYX0VWRU5UX05VTV07
DQo+ICsJY2hhciBwYXRoc1tNQVhfRVZFTlRfTlVNXVtNQVhfUEFUSF9MRU5dOw0KPiArfSBzcmMs
IGRzdDsNCj4gKw0KPiArc3RhdGljIGlubGluZSBpbnQgc2V0X3BhdGhuYW1lKGludCBmZCkNCg0K
SW4gbm9uLWJwZiAuYyBmaWxlLCB0eXBpY2FsbHkgd2UgZG8gbm90IGFkZCAnaW5saW5lJyBhdHRy
aWJ1dGUuDQpJdCBpcyB1cCB0byBjb21waWxlciB0byBkZWNpZGUgd2hldGhlciBpdCBzaG91bGQg
YmUgaW5saW5lZC4NCg0KPiArew0KPiArCWNoYXIgYnVmW01BWF9QQVRIX0xFTl07DQo+ICsNCj4g
KwlzbnByaW50ZihidWYsIE1BWF9QQVRIX0xFTiwgIi9wcm9jLyVkL2ZkLyVkIiwgc3JjLnBpZCwg
ZmQpOw0KPiArCXNyYy5mZHNbc3JjLmNudF0gPSBmZDsNCj4gKwlyZXR1cm4gcmVhZGxpbmsoYnVm
LCBzcmMucGF0aHNbc3JjLmNudCsrXSwgTUFYX1BBVEhfTEVOKTsNCj4gK30NCj4gKw0KWy4uLl0N
Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2dl
dF9maWxlX3BhdGguYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2dl
dF9maWxlX3BhdGguYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAw
MDAuLmVhZTY2M2MxMjYyYQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2dldF9maWxlX3BhdGguYw0KPiBAQCAtMCwwICsxLDQz
IEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArDQo+ICsjaW5j
bHVkZSA8bGludXgvYnBmLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvcHRyYWNlLmg+DQo+ICsjaW5j
bHVkZSA8c3RyaW5nLmg+DQo+ICsjaW5jbHVkZSA8dW5pc3RkLmg+DQo+ICsjaW5jbHVkZSAiYnBm
X2hlbHBlcnMuaCINCj4gKyNpbmNsdWRlICJicGZfdHJhY2luZy5oIg0KPiArDQo+ICsjZGVmaW5l
IE1BWF9QQVRIX0xFTgkJMTI4DQo+ICsjZGVmaW5lIE1BWF9FVkVOVF9OVU0JCTE2DQo+ICsNCj4g
K3N0YXRpYyBzdHJ1Y3QgZmlsZV9wYXRoX3Rlc3RfZGF0YSB7DQo+ICsJcGlkX3QgcGlkOw0KPiAr
CV9fdTMyIGNudDsNCj4gKwlfX3UzMiBmZHNbTUFYX0VWRU5UX05VTV07DQo+ICsJY2hhciBwYXRo
c1tNQVhfRVZFTlRfTlVNXVtNQVhfUEFUSF9MRU5dOw0KPiArfSBkYXRhOw0KPiArDQo+ICtzdHJ1
Y3Qgc3lzX2VudGVyX25ld2ZzdGF0X2FyZ3Mgew0KPiArCXVuc2lnbmVkIGxvbmcgbG9uZyBwYWQx
Ow0KPiArCXVuc2lnbmVkIGxvbmcgbG9uZyBwYWQyOw0KPiArCXVuc2lnbmVkIGludCBmZDsNCj4g
K307DQoNClRoZSBCVEYgZ2VuZXJhdGVkIHZtbGludXguaCBoYXMgdGhlIGZvbGxvd2luZyBzdHJ1
Y3R1cmUsDQpzdHJ1Y3QgdHJhY2VfZW50cnkgew0KICAgICAgICAgc2hvcnQgdW5zaWduZWQgaW50
IHR5cGU7DQogICAgICAgICB1bnNpZ25lZCBjaGFyIGZsYWdzOw0KICAgICAgICAgdW5zaWduZWQg
Y2hhciBwcmVlbXB0X2NvdW50Ow0KICAgICAgICAgaW50IHBpZDsNCn07DQpzdHJ1Y3QgdHJhY2Vf
ZXZlbnRfcmF3X3N5c19lbnRlciB7DQogICAgICAgICBzdHJ1Y3QgdHJhY2VfZW50cnkgZW50Ow0K
ICAgICAgICAgbG9uZyBpbnQgaWQ7DQogICAgICAgICBsb25nIHVuc2lnbmVkIGludCBhcmdzWzZd
Ow0KICAgICAgICAgY2hhciBfX2RhdGFbMF07DQp9Ow0KDQpUaGUgdGhpcmQgcGFyYW1ldGVyIHR5
cGUgc2hvdWxkIGJlIGxvbmcsIG90aGVyd2lzZSwNCml0IG1heSBoYXZlIGlzc3VlIG9uIGJpZyBl
bmRpYW4gbWFjaGluZXM/DQo=
