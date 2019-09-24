Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9ABCBB9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389720AbfIXPon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:44:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388100AbfIXPon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:44:43 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8OFiQMA015318;
        Tue, 24 Sep 2019 08:44:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=c2FLLeUiOBYrqUpntnexEtnUKBA2VbqNNcsN2ME/u+M=;
 b=kJ56bexFGL1txrZ1q0tENHzMAT9grZgWNxF32p2fNnAFBKEWH3gfL/QwV66YGy5YKDCk
 0H3oXz9PYmoC4KHVWUNJx5yLe4mKOjksUifk7umGfoQiv0xIq6rgpiWl15RqkHzjmEjP
 ZJXc7v03CgAR7JhBgvUNMPJ9N+Qdtc2UGGM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2v752kvb81-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Sep 2019 08:44:26 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Sep 2019 08:43:55 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Sep 2019 08:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vp7WlLScFa6ZMtgw6rEuI0H47CP3ZlUhEGtrmTF6mxLwUA1X7gcxzG88P0oYrnj+BrdNUa4qqGFnSvF+pEaVUg4TZbhsrhCCWgmq6uDrvM4owW4qgWqmeSPNep6ewdnOTn0zAnIYflE3eKIZY5RALAuGTDRBUQhnGvmG12/3wf9fltJ72FelriUDwtixnD+KWAV++Hcw/hXtc6PY7eOZgN6ulEIUMyvKy7yjem+9rWiv1Ws1GCFtrnflpXgCqgmcCgz+6DDbVQQ0t6318+JnRhJYU4RCuSVGiFEyEqLltgtX7/nqGgxBmqLG8FmHgQlZvFCxpB+0LRLwf7PqHgVMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2FLLeUiOBYrqUpntnexEtnUKBA2VbqNNcsN2ME/u+M=;
 b=CtbS3EG6ixSkqTvF+q45MmT3dIldWuCwnFAtbO1189BsKZN3k4BB4xBl3TDIgT9LAaR98FtBwukQz8wNhMsEFoy/MdPSYN3APA8RN9pKC7W61jIeCIBiB2tiNds6mA839BrVri7vy/hBf0HViaGwFtp4xnacuX+Oh31Y8Mbrl84OWWqkT5yVr/PjOLJFqmAwSCREJ/nzIeV/jGReKhLYxJ7qypDrGRSpDV9FkH1QRtFcbTBHDPAV5Sp5fNl5Vqbj842U5K+cMcZQmRU1nklM+23tdqisc99ZcTWn2xhUC+kj0yzD8XNGqfqiGQED8vJRX4b13wA39z/khRk6dSUzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2FLLeUiOBYrqUpntnexEtnUKBA2VbqNNcsN2ME/u+M=;
 b=ZH3yKwQZKmB40X1An/8TrElaLiHvtYCyc4FSco1IqNryVjb6IlzSqkBYBBxb8pKSGcjnrrCQMfMTRiNzLtpmAC9xVId/rl8TSZJvSgRA8Qn8pSYm4aS//vGv/oO4Rf8pwx4UvEKQLnN4zpNQiZGUOGVVvbgtM+kl7X9fMu8VWXc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3463.namprd15.prod.outlook.com (20.179.59.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Tue, 24 Sep 2019 15:43:54 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 15:43:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: Linux 5.4 - bpf test build fails
Thread-Topic: Linux 5.4 - bpf test build fails
Thread-Index: AQHVcux0fiF/RKNyi0SFtg1VPPP8vqc6998A
Date:   Tue, 24 Sep 2019 15:43:54 +0000
Message-ID: <0a5bf608-bb15-c116-8e58-7224b6c3b62f@fb.com>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
In-Reply-To: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0054.namprd19.prod.outlook.com
 (2603:10b6:300:94::16) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:72dd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62017da5-dcc9-4369-f6ac-08d7410600fc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3463;
x-ms-traffictypediagnostic: BYAPR15MB3463:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3463ED6F97BA9D53DD08573FD3840@BYAPR15MB3463.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(346002)(376002)(396003)(189003)(199004)(71200400001)(36756003)(256004)(14444005)(71190400001)(46003)(6436002)(5660300002)(52116002)(186003)(53546011)(6506007)(11346002)(102836004)(316002)(110136005)(386003)(31686004)(6246003)(76176011)(66446008)(25786009)(66556008)(81166006)(8936002)(476003)(66476007)(4326008)(2616005)(54906003)(446003)(64756008)(8676002)(66946007)(81156014)(478600001)(6116002)(6486002)(229853002)(486006)(305945005)(6512007)(7736002)(14454004)(2906002)(99286004)(31696002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3463;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /8figqam5PD6jJ8phXgTdvhLhrI44KpOOwkv43PtvH1ZP3orcTmn+ZKvoFuGi+UDUumpnNBnJW/uenjgvL2RUokIGEbnZYW7mMq40Z/W1vgf19wswrUoetr2P5eaAzc9zAK6Caeus/EAS4LaJDMdjHa/fRnqJI4LvBXmwr3+8wQ6cIdg2fWNPFYu/ROkO+0ZT3WA/jpJhYQA3mDkNv8mZFVUbs+1BCj7TZDEXTGc4omIZgu/toXuYQt2FG+hbpNns7o05/LWKQqRGhBbfvFp43oqyhTqPNZJt58Qv0X4JkvBvHzOCJRoKFjbs3R+UnoRZEE1aJzwDq+y/kgAEX2whjGF6VJ5EHjg1UQUmWjQpHrsoDb0Sz+w86pKGpEGXdZIQAD5emlcTDresfJlFMnazU/cAqtowb55Y1VARXKJc2g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC40EEDC400ECC4E82C0C4448991F703@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 62017da5-dcc9-4369-f6ac-08d7410600fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 15:43:54.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jomFQs7MB/wZhqWJhAxb/c11Jh0zX9Ehr1wtTMOteGE2FgIi3hLWfDnk689ri0Dl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3463
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_06:2019-09-23,2019-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1909240147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMjQvMTkgODoyNiBBTSwgU2h1YWggS2hhbiB3cm90ZToNCj4gSGkgQWxleGVpIGFu
ZCBEYW5pZWwsDQo+IA0KPiBicGYgdGVzdCBkb2Vzbid0IGJ1aWxkIG9uIExpbnV4IDUuNCBtYWlu
bGluZS4gRG8geW91IGtub3cgd2hhdCdzDQo+IGhhcHBlbmluZyBoZXJlLg0KPiANCj4gDQo+IG1h
a2UgLUMgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmLw0KPiANCj4gLWMgcHJvZ3MvdGVzdF9j
b3JlX3JlbG9jX3B0cl9hc19hcnIuYyAtbyAtIHx8IGVjaG8gImNsYW5nIGZhaWxlZCIpIHwgXA0K
PiBsbGMgLW1hcmNoPWJwZiAtbWNwdT1nZW5lcmljwqAgLWZpbGV0eXBlPW9iaiAtbyANCj4gL21u
dC9kYXRhL2xrbWwvbGludXhfNS40L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nv
cmVfcmVsb2NfcHRyX2FzX2Fyci5vIA0KPiANCj4gcHJvZ3MvdGVzdF9jb3JlX3JlbG9jX3B0cl9h
c19hcnIuYzoyNTo2OiBlcnJvcjogdXNlIG9mIHVua25vd24gYnVpbHRpbg0KPiAgwqDCoMKgwqDC
oCAnX19idWlsdGluX3ByZXNlcnZlX2FjY2Vzc19pbmRleCcgWy1XaW1wbGljaXQtZnVuY3Rpb24t
ZGVjbGFyYXRpb25dDQo+ICDCoMKgwqDCoMKgwqDCoCBpZiAoQlBGX0NPUkVfUkVBRCgmb3V0LT5h
LCAmaW5bMl0uYSkpDQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF4NCj4gLi9icGZfaGVscGVy
cy5oOjUzMzoxMDogbm90ZTogZXhwYW5kZWQgZnJvbSBtYWNybyAnQlBGX0NPUkVfUkVBRCcNCj4g
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fYnVpbHRpbl9w
cmVzZXJ2ZV9hY2Nlc3NfaW5kZXgoc3JjKSkNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIF4NCj4gcHJvZ3MvdGVzdF9jb3JlX3JlbG9jX3B0cl9hc19hcnIu
YzoyNTo2OiB3YXJuaW5nOiBpbmNvbXBhdGlibGUgaW50ZWdlciB0bw0KPiAgwqDCoMKgwqDCoCBw
b2ludGVyIGNvbnZlcnNpb24gcGFzc2luZyAnaW50JyB0byBwYXJhbWV0ZXIgb2YgdHlwZSAnY29u
c3Qgdm9pZCAqJw0KPiAgwqDCoMKgwqDCoCBbLVdpbnQtY29udmVyc2lvbl0NCj4gIMKgwqDCoMKg
wqDCoMKgIGlmIChCUEZfQ09SRV9SRUFEKCZvdXQtPmEsICZpblsyXS5hKSkNCj4gIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gLi9icGZf
aGVscGVycy5oOjUzMzoxMDogbm90ZTogZXhwYW5kZWQgZnJvbSBtYWNybyAnQlBGX0NPUkVfUkVB
RCcNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fYnVp
bHRpbl9wcmVzZXJ2ZV9hY2Nlc3NfaW5kZXgoc3JjKSkNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fg0KPiAxIHdhcm5pbmcgYW5kIDEgZXJyb3IgZ2VuZXJhdGVkLg0KPiBsbGM6IGVycm9yOiBs
bGM6IDxzdGRpbj46MToxOiBlcnJvcjogZXhwZWN0ZWQgdG9wLWxldmVsIGVudGl0eQ0KPiBjbGFu
ZyBmYWlsZWQNCj4gDQo+IEFsc28NCj4gDQo+IG1ha2UgVEFSR0VUUz1icGYga3NlbGZ0ZXN0IGZh
aWxzIGFzIHdlbGwuIERlcGVuZGVuY3kgYmV0d2Vlbg0KPiB0b29scy9saWIvYnBmIGFuZCB0aGUg
dGVzdC4gSG93IGNhbiB3ZSBhdm9pZCB0aGlzIHR5cGUgb2YNCj4gZGVwZW5kZW5jeSBvciByZXNv
bHZlIGl0IGluIGEgd2F5IGl0IGRvZXNuJ3QgcmVzdWx0IGluIGJ1aWxkDQo+IGZhaWx1cmVzPw0K
DQpUaGFua3MsIFNodWFoLg0KDQpUaGUgY2xhbmcgX19idWlsdGluX3ByZXNlcnZlX2FjY2Vzc19p
bmRleCgpIGludHJpbnNpYyBpcw0KaW50cm9kdWNlZCBpbiBMTFZNOSAod2hpY2gganVzdCByZWxl
YXNlZCBsYXN0IHdlZWspIGFuZA0KdGhlIGJ1aWx0aW4gYW5kIG90aGVyIENPLVJFIGZlYXR1cmVz
IGFyZSBvbmx5IHN1cHBvcnRlZA0KaW4gTExWTTEwIChjdXJyZW50IGRldmVsb3BtZW50IGJyYW5j
aCkgd2l0aCBtb3JlIGJ1ZyBmaXhlcw0KYW5kIGFkZGVkIGZlYXR1cmVzLg0KDQpJIHRoaW5rIHdl
IHNob3VsZCBkbyBhIGZlYXR1cmUgdGVzdCBmb3IgbGx2bSB2ZXJzaW9uIGFuZCBvbmx5DQplbmFi
bGUgdGhlc2UgdGVzdHMgd2hlbiBsbHZtIHZlcnNpb24gPj0gMTAuDQoNCkFuZHJpaSwgd2hhdCBk
byB5b3UgdGhpbms/DQoNCj4gDQo+IHRoYW5rcywNCj4gLS0gU2h1YWgNCg==
