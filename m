Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE5AE5B0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbfIJIiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:38:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfIJIiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:38:00 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8A8ZEbX026551;
        Tue, 10 Sep 2019 01:37:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wTTUiOnuy5WfhGWrSCAMaWpvCBMVp3ybaMXi85IX3Vg=;
 b=Ea0TnPCptfilTwM60x0yNhWeODIkXaZUqTEUzal+MIaUTE2+IXDLqG5hOIbgXVvwxuUD
 uYV1Wbby8ef/YcTILPbw3DLxZMNGwYheEseREBcXwS3zkXYLQ6Kq4pg9tvIbocmzz/fT
 5ROgbEmkHQ6BfUIXlkMcfn9gbZ1hBgLnJk4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uwrs8kv1g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Sep 2019 01:37:36 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Sep 2019 01:37:35 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 01:37:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmyxFc/LlkpIiXb8NJLzlVLPJ6+7fEmLIqx/gxFWyj1aRJfUHWaVxFmy/YYvPOFGDKphl0dzXAlWyV1AOzTLuHA6iKPAIlosfjmzO7ZPe8nT184THG9MV8nHt80re22+iBHwCwJd2vYggoLxHujUpWfKroOIj521ryGOId7F43S7bncyap2vnnw9rQRg9FJc0c7vpCIiZcwipcjnA0lT1OEK3WO/ecWj0M8T6lEBAiiESC6u0IQB4fu3WsJJWoiaAXB2l9MuXT4uQVcEG7Tz9MgC32cKidVVRvEE+wF2uToMmO5Iwa5H/Gxcl4GZNj6WOsm0qFbABuXBPYkjE9UHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTTUiOnuy5WfhGWrSCAMaWpvCBMVp3ybaMXi85IX3Vg=;
 b=bOX3KoP5w4NfIhNzZQOjeeLTitdLh/yOL91PtLbIGkETSddmKn85+UsgA1MtEvdQfHcrB+rhuU/7uFI7RV2En/Xq4r8vaquy8rV+flzTEph0KSDQy35vdRT0QQ3ZGI5urA/uuUaQoyBmN0hZDZOMESfN4KzMAw3IIGW3oBKYQr7oU+BgIkNfWLGAaYv9otgrjKFsIQHvLEqhtGz8dGeHeUuUDoi0YINnAUHYlCKzaZvvqiC8lFP4bQeql6bmg4p+qRbyyAZUZ67QZu8StHfB2SVbaI/0m72dmSj1tsUa+O3gYSVAoSYFuPFs4OMunCV89uuemN4Swk4cRAeff+2qMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTTUiOnuy5WfhGWrSCAMaWpvCBMVp3ybaMXi85IX3Vg=;
 b=RK7PfLIYFvGOKF824jpaCZD145Lo7lEX4Zcvx4qr8iEdbVR2Fmk4PIKd2nUvdB+DIW8fJr/R+f4yT3U7QXrZH/VexiGJbwV7pC7Aowl1btj9wHXgrxJ5w1NXMWWj7IIp7XUnvmffsyoPbHzOGWde/sOAoIi85isqa+PLuUCmgA4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2917.namprd15.prod.outlook.com (20.178.236.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 10 Sep 2019 08:37:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 08:37:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Sami Tolvanen <samitolvanen@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Kees Cook <keescook@chromium.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
Thread-Topic: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
Thread-Index: AQHVZ16IW5erCFqZOkia6/rUPUKqLqcklyQA
Date:   Tue, 10 Sep 2019 08:37:19 +0000
Message-ID: <4f4136f5-db54-f541-2843-ccb35be25ab4@fb.com>
References: <20190909223236.157099-1-samitolvanen@google.com>
In-Reply-To: <20190909223236.157099-1-samitolvanen@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0056.namprd21.prod.outlook.com
 (2603:10b6:300:db::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4636]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 085bf149-e471-47ea-a98e-08d735ca17e9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2917;
x-ms-traffictypediagnostic: BYAPR15MB2917:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB291783D8BE9047A3E94CF079D3B60@BYAPR15MB2917.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(396003)(376002)(366004)(53234004)(189003)(199004)(305945005)(102836004)(46003)(54906003)(6506007)(14454004)(6486002)(8676002)(81166006)(8936002)(31686004)(7736002)(66446008)(64756008)(66556008)(66476007)(4326008)(25786009)(66946007)(5660300002)(478600001)(229853002)(6436002)(6246003)(36756003)(31696002)(6512007)(53936002)(86362001)(81156014)(76176011)(15650500001)(446003)(11346002)(2616005)(71190400001)(256004)(2906002)(53546011)(6116002)(186003)(476003)(386003)(99286004)(486006)(316002)(14444005)(110136005)(71200400001)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2917;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Lsjjvkn+NZ/PtNmxFLq6I6XVV8qlBXo+lMxWCEhpNmySLXq0d9kOO5tOvvJqpGs641/Z6lMcUKM36+bBRQJpiI1WTw1AhcC4LmEEStZHUdAY//j1ulM0LB8VM2dO6kuFA2ttWwfDvctenqohCmIvUjc6cgzln8arlBXc2TGOGeM2rkBA1Zy169YaVqEq5qr94tJEHossZgQ9CNheaWo9sdlAzD4hP99UEXyyyqC1/TDzWWnBYI8aWm3fqsbJDFARkue4eV6nbuAwnqK6RYwXxruuANBEl24KYwwApBnYaPqm9SfmYEVpU9rd1wJD2le5DtUF+Y4levT0zjgs1rzLPNxMIlOxmgO4sUE3wKLGJ0KXlasjgT4G+bgDEAAkGOjVWN8Jdeb0Xnf7taSzuFZzAXrbiDgIXc3l4rEYE87PjVo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9868C14C6F8ADC45A7BCEEE2B4DE1192@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 085bf149-e471-47ea-a98e-08d735ca17e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 08:37:19.9968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rJpgb3WJlRidmbLMc5/WDPlIM9dj8F5+ugb0U1i0KTbVGUQXrKTaxgkCyhqVQaZH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2917
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_06:2019-09-09,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100086
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvOS8xOSAxMTozMiBQTSwgU2FtaSBUb2x2YW5lbiB3cm90ZToNCj4gV2l0aCBDT05G
SUdfQlBGX0pJVCwgdGhlIGtlcm5lbCBtYWtlcyBpbmRpcmVjdCBjYWxscyB0byBkeW5hbWljYWxs
eQ0KPiBnZW5lcmF0ZWQgY29kZS4gVGhpcyBjaGFuZ2UgYWRkcyBiYXNpYyBzYW5pdHkgY2hlY2tp
bmcgdG8gZW5zdXJlDQo+IHdlIGFyZSBqdW1waW5nIHRvIGEgdmFsaWQgbG9jYXRpb24sIHdoaWNo
IG5hcnJvd3MgZG93biB0aGUgYXR0YWNrDQo+IHN1cmZhY2Ugb24gdGhlIHN0b3JlZCBwb2ludGVy
LiBUaGlzIGFsc28gcHJlcGFyZXMgdGhlIGNvZGUgZm9yIGZ1dHVyZQ0KPiBDb250cm9sLUZsb3cg
SW50ZWdyaXR5IChDRkkpIGNoZWNraW5nLCB3aGljaCBhZGRzIGluZGlyZWN0IGNhbGwNCj4gdmFs
aWRhdGlvbiB0byBjYWxsIHRhcmdldHMgdGhhdCBjYW4gYmUgZGV0ZXJtaW5lZCBhdCBjb21waWxl
LXRpbWUsIGJ1dA0KPiBjYW5ub3QgdmFsaWRhdGUgY2FsbHMgdG8gaml0ZWQgZnVuY3Rpb25zLg0K
PiANCj4gSW4gYWRkaXRpb24sIHRoaXMgY2hhbmdlIGFkZHMgYSB3ZWFrIGFyY2hfYnBmX2ppdF9j
aGVja19mdW5jIGZ1bmN0aW9uLA0KPiB3aGljaCBhcmNoaXRlY3R1cmVzIHRoYXQgaW1wbGVtZW50
IEJQRiBKSVQgY2FuIG92ZXJyaWRlIHRvIHBlcmZvcm0NCj4gYWRkaXRpb25hbCB2YWxpZGF0aW9u
LCBzdWNoIGFzIHZlcmlmeWluZyB0aGF0IHRoZSBwb2ludGVyIHBvaW50cyB0bw0KPiB0aGUgY29y
cmVjdCBtZW1vcnkgcmVnaW9uLg0KDQpZb3UgZGlkIG5vdCBtZW50aW9uIEJQRl9CSU5BUllfSEVB
REVSX01BR0lDIGFuZCBhZGRlZCBtZW1iZXINCm9mIGBtYWdpY2AgaW4gYnBmX2JpbmFyeV9oZWFk
ZXIuIENvdWxkIHlvdSBhZGQgc29tZSBkZXRhaWxzDQpvbiB3aGF0IGlzIHRoZSBwdXJwb3NlIGZv
ciB0aGlzIGBtYWdpY2AgbWVtYmVyPw0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTYW1pIFRvbHZh
bmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9m
aWx0ZXIuaCB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ICAga2VybmVsL2JwZi9j
b3JlLmMgICAgICB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICAyIGZpbGVzIGNo
YW5nZWQsIDQ5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9maWx0ZXIuaCBiL2luY2x1ZGUvbGludXgvZmlsdGVyLmgNCj4gaW5k
ZXggOTJjNmUzMWZiMDA4Li5hYmZiMGUxYjIxYTggMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGlu
dXgvZmlsdGVyLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9maWx0ZXIuaA0KPiBAQCAtNTExLDcg
KzUxMSwxMCBAQCBzdHJ1Y3Qgc29ja19mcHJvZ19rZXJuIHsNCj4gICAJc3RydWN0IHNvY2tfZmls
dGVyCSpmaWx0ZXI7DQo+ICAgfTsNCj4gICANCj4gKyNkZWZpbmUgQlBGX0JJTkFSWV9IRUFERVJf
TUFHSUMJMHgwNWRlMGU4Mg0KPiArDQo+ICAgc3RydWN0IGJwZl9iaW5hcnlfaGVhZGVyIHsNCj4g
Kwl1MzIgbWFnaWM7DQo+ICAgCXUzMiBwYWdlczsNCj4gICAJLyogU29tZSBhcmNoZXMgbmVlZCB3
b3JkIGFsaWdubWVudCBmb3IgdGhlaXIgaW5zdHJ1Y3Rpb25zICovDQo+ICAgCXU4IGltYWdlW10g
X19hbGlnbmVkKDQpOw0KPiBAQCAtNTUzLDIwICs1NTYsMzkgQEAgc3RydWN0IHNrX2ZpbHRlciB7
DQo+ICAgDQo+ICAgREVDTEFSRV9TVEFUSUNfS0VZX0ZBTFNFKGJwZl9zdGF0c19lbmFibGVkX2tl
eSk7DQo+ICAgDQo+ICsjaWZkZWYgQ09ORklHX0JQRl9KSVQNCj4gKy8qDQo+ICsgKiBXaXRoIEpJ
VCwgdGhlIGtlcm5lbCBtYWtlcyBhbiBpbmRpcmVjdCBjYWxsIHRvIGR5bmFtaWNhbGx5IGdlbmVy
YXRlZA0KPiArICogY29kZS4gVXNlIGJwZl9jYWxsX2Z1bmMgdG8gcGVyZm9ybSBhZGRpdGlvbmFs
IHZhbGlkYXRpb24gb2YgdGhlIGNhbGwNCj4gKyAqIHRhcmdldCB0byBuYXJyb3cgZG93biBhdHRh
Y2sgc3VyZmFjZS4gQXJjaGl0ZWN0dXJlcyBpbXBsZW1lbnRpbmcgQlBGDQo+ICsgKiBKSVQgY2Fu
IG92ZXJyaWRlIGFyY2hfYnBmX2ppdF9jaGVja19mdW5jIGZvciBhcmNoLXNwZWNpZmljIGNoZWNr
aW5nLg0KPiArICovDQo+ICtleHRlcm4gdW5zaWduZWQgaW50IGJwZl9jYWxsX2Z1bmMoY29uc3Qg
c3RydWN0IGJwZl9wcm9nICpwcm9nLA0KPiArCQkJCSAgY29uc3Qgdm9pZCAqY3R4KTsNCj4gKw0K
PiArZXh0ZXJuIGJvb2wgYXJjaF9icGZfaml0X2NoZWNrX2Z1bmMoY29uc3Qgc3RydWN0IGJwZl9w
cm9nICpwcm9nKTsNCj4gKyNlbHNlDQo+ICtzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBicGZf
Y2FsbF9mdW5jKGNvbnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZywNCj4gKwkJCQkJIGNvbnN0IHZv
aWQgKmN0eCkNCj4gK3sNCj4gKwlyZXR1cm4gcHJvZy0+YnBmX2Z1bmMoY3R4LCBwcm9nLT5pbnNu
c2kpOw0KPiArfQ0KPiArI2VuZGlmDQo+ICsNCj4gICAjZGVmaW5lIEJQRl9QUk9HX1JVTihwcm9n
LCBjdHgpCSh7CQkJCVwNCj4gICAJdTMyIHJldDsJCQkJCQlcDQo+ICAgCWNhbnRfc2xlZXAoKTsJ
CQkJCQlcDQo+ICAgCWlmIChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZicGZfc3RhdHNfZW5hYmxl
ZF9rZXkpKSB7CVwNCj4gICAJCXN0cnVjdCBicGZfcHJvZ19zdGF0cyAqc3RhdHM7CQkJXA0KPiAg
IAkJdTY0IHN0YXJ0ID0gc2NoZWRfY2xvY2soKTsJCQlcDQo+IC0JCXJldCA9ICgqKHByb2cpLT5i
cGZfZnVuYykoY3R4LCAocHJvZyktPmluc25zaSk7CVwNCj4gKwkJcmV0ID0gYnBmX2NhbGxfZnVu
Yyhwcm9nLCBjdHgpOwkJCVwNCj4gICAJCXN0YXRzID0gdGhpc19jcHVfcHRyKHByb2ctPmF1eC0+
c3RhdHMpOwkJXA0KPiAgIAkJdTY0X3N0YXRzX3VwZGF0ZV9iZWdpbigmc3RhdHMtPnN5bmNwKTsJ
CVwNCj4gICAJCXN0YXRzLT5jbnQrKzsJCQkJCVwNCj4gICAJCXN0YXRzLT5uc2VjcyArPSBzY2hl
ZF9jbG9jaygpIC0gc3RhcnQ7CQlcDQo+ICAgCQl1NjRfc3RhdHNfdXBkYXRlX2VuZCgmc3RhdHMt
PnN5bmNwKTsJCVwNCj4gICAJfSBlbHNlIHsJCQkJCQlcDQo+IC0JCXJldCA9ICgqKHByb2cpLT5i
cGZfZnVuYykoY3R4LCAocHJvZyktPmluc25zaSk7CVwNCj4gKwkJcmV0ID0gYnBmX2NhbGxfZnVu
Yyhwcm9nLCBjdHgpOwkJCVwNCj4gICAJfQkJCQkJCQlcDQo+ICAgCXJldDsgfSkNCj4gICANCj4g
ZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvY29yZS5jIGIva2VybmVsL2JwZi9jb3JlLmMNCj4gaW5k
ZXggNjYwODhhOWU5YjllLi43YWFkNThmNjcxMDUgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYv
Y29yZS5jDQo+ICsrKyBiL2tlcm5lbC9icGYvY29yZS5jDQo+IEBAIC03OTIsNiArNzkyLDMwIEBA
IHZvaWQgX193ZWFrIGJwZl9qaXRfZnJlZV9leGVjKHZvaWQgKmFkZHIpDQo+ICAgCW1vZHVsZV9t
ZW1mcmVlKGFkZHIpOw0KPiAgIH0NCj4gICANCj4gKyNpZmRlZiBDT05GSUdfQlBGX0pJVA0KPiAr
Ym9vbCBfX3dlYWsgYXJjaF9icGZfaml0X2NoZWNrX2Z1bmMoY29uc3Qgc3RydWN0IGJwZl9wcm9n
ICpwcm9nKQ0KPiArew0KPiArCXJldHVybiB0cnVlOw0KPiArfQ0KPiArDQo+ICt1bnNpZ25lZCBp
bnQgYnBmX2NhbGxfZnVuYyhjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2csIGNvbnN0IHZvaWQg
KmN0eCkNCj4gK3sNCj4gKwljb25zdCBzdHJ1Y3QgYnBmX2JpbmFyeV9oZWFkZXIgKmhkciA9IGJw
Zl9qaXRfYmluYXJ5X2hkcihwcm9nKTsNCj4gKw0KPiArCWlmICghSVNfRU5BQkxFRChDT05GSUdf
QlBGX0pJVF9BTFdBWVNfT04pICYmICFwcm9nLT5qaXRlZCkNCj4gKwkJcmV0dXJuIHByb2ctPmJw
Zl9mdW5jKGN0eCwgcHJvZy0+aW5zbnNpKTsNCj4gKw0KPiArCWlmICh1bmxpa2VseShoZHItPm1h
Z2ljICE9IEJQRl9CSU5BUllfSEVBREVSX01BR0lDIHx8DQo+ICsJCSAgICAgIWFyY2hfYnBmX2pp
dF9jaGVja19mdW5jKHByb2cpKSkgew0KPiArCQlXQVJOKDEsICJhdHRlbXB0IHRvIGp1bXAgdG8g
YW4gaW52YWxpZCBhZGRyZXNzIik7DQo+ICsJCXJldHVybiAwOw0KPiArCX0NCj4gKw0KPiArCXJl
dHVybiBwcm9nLT5icGZfZnVuYyhjdHgsIHByb2ctPmluc25zaSk7DQo+ICt9DQoNClRoZSBhYm92
ZSBjYW4gYmUgcmV3cml0dGVuIGFzDQoJaWYgKElTX0VOQUJMRUQoQ09ORklHX0JQRl9KSVRfQUxX
QVlTX09OKSB8fCBwcm9nLT5qaXRlZCB8fA0KCSAgICBoZHItPm1hZ2ljICE9IEJQRl9CSU5BUllf
SEVBREVSX01BR0lDIHx8DQoJICAgICFhcmNoX2JwZl9qaXRfY2hlY2tfZnVuYyhwcm9nKSkpIHsN
CgkJV0FSTigxLCAiYXR0ZW1wdCB0byBqdW1wIHRvIGFuIGludmFsaWQgYWRkcmVzcyIpOw0KCQly
ZXR1cm4gMDsNCgl9DQoNCglyZXR1cm4gcHJvZy0+YnBmX2Z1bmMoY3R4LCBwcm9nLT5pbnNuc2kp
Ow0KDQpCUEZfUFJPR19SVU4oKSB3aWxsIGJlIGNhbGxlZCBkdXJpbmcgeGRwIGZhc3QgcGF0aC4N
CkhhdmUgeW91IG1lYXN1cmVkIGhvdyBtdWNoIHNsb3dkb3duIHRoZSBhYm92ZSBjaGFuZ2UgY291
bGQNCmNvc3QgZm9yIHRoZSBwZXJmb3JtYW5jZT8NCg0KPiArRVhQT1JUX1NZTUJPTF9HUEwoYnBm
X2NhbGxfZnVuYyk7DQo+ICsjZW5kaWYNCj4gKw0KPiAgIHN0cnVjdCBicGZfYmluYXJ5X2hlYWRl
ciAqDQo+ICAgYnBmX2ppdF9iaW5hcnlfYWxsb2ModW5zaWduZWQgaW50IHByb2dsZW4sIHU4ICoq
aW1hZ2VfcHRyLA0KPiAgIAkJICAgICB1bnNpZ25lZCBpbnQgYWxpZ25tZW50LA0KPiBAQCAtODE4
LDYgKzg0Miw3IEBAIGJwZl9qaXRfYmluYXJ5X2FsbG9jKHVuc2lnbmVkIGludCBwcm9nbGVuLCB1
OCAqKmltYWdlX3B0ciwNCj4gICAJLyogRmlsbCBzcGFjZSB3aXRoIGlsbGVnYWwvYXJjaC1kZXAg
aW5zdHJ1Y3Rpb25zLiAqLw0KPiAgIAlicGZfZmlsbF9pbGxfaW5zbnMoaGRyLCBzaXplKTsNCj4g
ICANCj4gKwloZHItPm1hZ2ljID0gQlBGX0JJTkFSWV9IRUFERVJfTUFHSUM7DQo+ICAgCWhkci0+
cGFnZXMgPSBwYWdlczsNCj4gICAJaG9sZSA9IG1pbl90KHVuc2lnbmVkIGludCwgc2l6ZSAtIChw
cm9nbGVuICsgc2l6ZW9mKCpoZHIpKSwNCj4gICAJCSAgICAgUEFHRV9TSVpFIC0gc2l6ZW9mKCpo
ZHIpKTsNCj4gDQo=
