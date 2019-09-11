Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E71AF716
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfIKHn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:43:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725379AbfIKHn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:43:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8B7gWZS029606;
        Wed, 11 Sep 2019 00:43:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oJJtfcesFoq9HigEG3xHXTvAtSyylwI1L7QArdo9Zc0=;
 b=jYHw4E7cvYFYXTxzjTVLktb6jsA0m75pk6HTBqxinoApy8rETVDlLueqqSquFZliGBp6
 45/gEgzDeePL593KzmGDu5aWL+kVfk9GiVUDLUk7vkJC+naND+YMVB13Hd0xZ1KQ/mWu
 hX/YcBmILd1QZoalP+jMZg2HpKayrpHgsIY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2uxf95ut1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Sep 2019 00:43:00 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Sep 2019 00:43:00 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Sep 2019 00:42:59 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 00:42:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLnwZweIf9gMQZ5QHBKojs/P5urrPPsLa8pDaMKD/MDrhkAgBC2qr3RT2DkVmnmI+PrC9rDrapg/cQ03LOtgwUu6/lvpGk5Y8MTmFuMw3RrWo8EndsgA/ej9/3Ln1Exb20iYIU+Bt6mVHsfMhzhjIKwftSwTn0VuU436UwMvsJW3de80gL1va1C0lbOOZ++eqiEbZ/DhU/4++RXCa3qIFCZZDbnNm0alI3PN8uDm5NKjVNFBMWLIi2FBl19WnVhN9XYPvQO1qfJONmRYC1A5CghsuXo1UoVUee8P1MsaZzXBV90O0WD9sIZ1Dx+3KuAFuv7KRn1Na/UdWWJOX3w3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJJtfcesFoq9HigEG3xHXTvAtSyylwI1L7QArdo9Zc0=;
 b=DPJ/fxpQt3twQ8t8TBhKG7jGDPbBBAlS9v2lxlxUECuiBLbWMxFWpjNT1v0p+M5H8p1ynQY+n3ag8JMyQNcVE2HOh31BhpUutYAgOEXgZNsOZx1Pe6042L/+HBOHZ8YlLD37schJUzAHD0zdq1vsZMnCRLRzhqNYkuCRzGFqLltn7qpiL1Kr8D0mgyLpTMQcntfHXeT/H/IhTnZ5Qx9P5lsnwdHXugDUsz3d4+j5FMSfPllRGQ01x8KOaUGsrY3VD85SGQgD10Tt5KLruodYH/faDzi9yiDLrkWPoL/Gg9rEV1MKK2ID9ro17IzsUvQsxF2OiagwuLAzvYUCEZXfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJJtfcesFoq9HigEG3xHXTvAtSyylwI1L7QArdo9Zc0=;
 b=NKygGa0RxYcZWkGWxyFKBOPq8esQm88N4YE24gI8esYdZF0FQCcJGKouUCVxgJqOF9USAlJSLsQAXmWN1OfU1gFotI9lJkR6kFbcDhKTUQxZzB1az+znD62DVyDCWc+fvrYATfA+Fx8DcU8qaJ3EGeEKjmhwB7SWWin0OnEFJq8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3447.namprd15.prod.outlook.com (20.179.59.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 11 Sep 2019 07:42:40 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.015; Wed, 11 Sep 2019
 07:42:40 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Sami Tolvanen <samitolvanen@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
Thread-Topic: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
Thread-Index: AQHVZ16IW5erCFqZOkia6/rUPUKqLqcklyQAgACS4ICAAPAvAA==
Date:   Wed, 11 Sep 2019 07:42:39 +0000
Message-ID: <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com>
References: <20190909223236.157099-1-samitolvanen@google.com>
 <4f4136f5-db54-f541-2843-ccb35be25ab4@fb.com>
 <20190910172253.GA164966@google.com>
In-Reply-To: <20190910172253.GA164966@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0043.namprd21.prod.outlook.com
 (2603:10b6:300:129::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d583]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a758702f-79fc-47ed-55ac-08d7368b9f40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB3447;
x-ms-traffictypediagnostic: BYAPR15MB3447:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3447242CEB093419276CB921D3B10@BYAPR15MB3447.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(376002)(346002)(53234004)(189003)(199004)(14444005)(486006)(186003)(6246003)(386003)(6116002)(25786009)(6506007)(2616005)(476003)(102836004)(11346002)(46003)(446003)(53546011)(8936002)(81166006)(8676002)(81156014)(76176011)(4326008)(66446008)(66476007)(66556008)(64756008)(7736002)(305945005)(66946007)(66574012)(36756003)(316002)(15650500001)(6916009)(99286004)(52116002)(71200400001)(71190400001)(53936002)(2906002)(31686004)(14454004)(478600001)(86362001)(31696002)(54906003)(229853002)(5660300002)(6486002)(6436002)(256004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3447;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w0YX7KZ4BCsLhBvP9Glt5Ajr75fLdI1Ket12Rc3Ucqdr2zZyue+os1r6T8nSdjTKIxJOhv7FRH6eOndYio6cNXqiRmZ5cnBt44Fs0wNU0+Ec7hOJL3VoM7KkgvJjcO3w4U1II76mHSkbQh9kgp9VnsmPXncMzdWsOUwjTfvcXEp7MfuQhBDsV7Qx09ayNvuM0zsW5V/BsipaEE8u8G+t1G3UgZLUbL8F8tE/OGDHgJKkJlOoJ2lUj2eFhUgfgurKnmIio3n1Uepc5KcAHFdN+8V0fo54uis4+7ZBZqmV6l77GnJb1wogx9uzPWoF4jaXk6usfMdmfvX1NUhkh7aYivBRZ1xIR0xl/9g3dNOn/xMeaM8KhdjFFsHVNYRC4v1t+pwXtIXAXQeOyhMIlQASENJrMX31YhF4SzUEtkok0U8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7F773D60F502D4D9323F2FFD42525B9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a758702f-79fc-47ed-55ac-08d7368b9f40
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 07:42:39.9040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kef0VsKSMZdRDpvDFkzS0IYOS5IFmXxsCnW9Q692bco0YlAaXMwzHuVTWBP8I661
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3447
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_05:2019-09-10,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110071
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgNjoyMiBQTSwgU2FtaSBUb2x2YW5lbiB3cm90ZToNCj4gT24gVHVlLCBT
ZXAgMTAsIDIwMTkgYXQgMDg6Mzc6MTlBTSArMDAwMCwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4+
IFlvdSBkaWQgbm90IG1lbnRpb24gQlBGX0JJTkFSWV9IRUFERVJfTUFHSUMgYW5kIGFkZGVkIG1l
bWJlcg0KPj4gb2YgYG1hZ2ljYCBpbiBicGZfYmluYXJ5X2hlYWRlci4gQ291bGQgeW91IGFkZCBz
b21lIGRldGFpbHMNCj4+IG9uIHdoYXQgaXMgdGhlIHB1cnBvc2UgZm9yIHRoaXMgYG1hZ2ljYCBt
ZW1iZXI/DQo+IA0KPiBTdXJlLCBJJ2xsIGFkZCBhIGRlc2NyaXB0aW9uIHRvIHRoZSBuZXh0IHZl
cnNpb24uDQo+IA0KPiBUaGUgbWFnaWMgaXMgYSByYW5kb20gbnVtYmVyIHVzZWQgdG8gaWRlbnRp
ZnkgYnBmX2JpbmFyeV9oZWFkZXIgaW4NCj4gbWVtb3J5LiBUaGUgcHVycG9zZSBvZiB0aGlzIHBh
dGNoIGlzIHRvIGxpbWl0IHRoZSBwb3NzaWJsZSBjYWxsDQo+IHRhcmdldHMgZm9yIHRoZSBmdW5j
dGlvbiBwb2ludGVyIGFuZCBjaGVja2luZyBmb3IgdGhlIG1hZ2ljIGhlbHBzDQo+IGVuc3VyZSB3
ZSBhcmUganVtcGluZyB0byBhIHBhZ2UgdGhhdCBjb250YWlucyBhIGppdGVkIGZ1bmN0aW9uLA0K
PiBpbnN0ZWFkIG9mIGFsbG93aW5nIGNhbGxzIHRvIGFyYml0cmFyeSB0YXJnZXRzLg0KPiANCj4g
VGhpcyBpcyBwYXJ0aWN1bGFybHkgdXNlZnVsIHdoZW4gY29tYmluZWQgd2l0aCB0aGUgY29tcGls
ZXItYmFzZWQNCj4gQ29udHJvbC1GbG93IEludGVncml0eSAoQ0ZJKSBtaXRpZ2F0aW9uLCB3aGlj
aCBHb29nbGUgc3RhcnRlZCBzaGlwcGluZw0KPiBpbiBQaXhlbCBrZXJuZWxzIGxhc3QgeWVhci4g
VGhlIGNvbXBpbGVyIGluamVjdHMgY2hlY2tzIHRvIGFsbA0KPiBpbmRpcmVjdCBjYWxscywgYnV0
IGNhbm5vdCBvYnZpb3VzbHkgdmFsaWRhdGUganVtcHMgdG8gZHluYW1pY2FsbHkNCj4gZ2VuZXJh
dGVkIGNvZGUuDQo+IA0KPj4+ICt1bnNpZ25lZCBpbnQgYnBmX2NhbGxfZnVuYyhjb25zdCBzdHJ1
Y3QgYnBmX3Byb2cgKnByb2csIGNvbnN0IHZvaWQgKmN0eCkNCj4+PiArew0KPj4+ICsJY29uc3Qg
c3RydWN0IGJwZl9iaW5hcnlfaGVhZGVyICpoZHIgPSBicGZfaml0X2JpbmFyeV9oZHIocHJvZyk7
DQo+Pj4gKw0KPj4+ICsJaWYgKCFJU19FTkFCTEVEKENPTkZJR19CUEZfSklUX0FMV0FZU19PTikg
JiYgIXByb2ctPmppdGVkKQ0KPj4+ICsJCXJldHVybiBwcm9nLT5icGZfZnVuYyhjdHgsIHByb2ct
Pmluc25zaSk7DQo+Pj4gKw0KPj4+ICsJaWYgKHVubGlrZWx5KGhkci0+bWFnaWMgIT0gQlBGX0JJ
TkFSWV9IRUFERVJfTUFHSUMgfHwNCj4+PiArCQkgICAgICFhcmNoX2JwZl9qaXRfY2hlY2tfZnVu
Yyhwcm9nKSkpIHsNCj4+PiArCQlXQVJOKDEsICJhdHRlbXB0IHRvIGp1bXAgdG8gYW4gaW52YWxp
ZCBhZGRyZXNzIik7DQo+Pj4gKwkJcmV0dXJuIDA7DQo+Pj4gKwl9DQo+Pj4gKw0KPj4+ICsJcmV0
dXJuIHByb2ctPmJwZl9mdW5jKGN0eCwgcHJvZy0+aW5zbnNpKTsNCj4+PiArfQ0KPiANCj4+IFRo
ZSBhYm92ZSBjYW4gYmUgcmV3cml0dGVuIGFzDQo+PiAJaWYgKElTX0VOQUJMRUQoQ09ORklHX0JQ
Rl9KSVRfQUxXQVlTX09OKSB8fCBwcm9nLT5qaXRlZCB8fA0KPj4gCSAgICBoZHItPm1hZ2ljICE9
IEJQRl9CSU5BUllfSEVBREVSX01BR0lDIHx8DQo+PiAJICAgICFhcmNoX2JwZl9qaXRfY2hlY2tf
ZnVuYyhwcm9nKSkpIHsNCj4+IAkJV0FSTigxLCAiYXR0ZW1wdCB0byBqdW1wIHRvIGFuIGludmFs
aWQgYWRkcmVzcyIpOw0KPj4gCQlyZXR1cm4gMDsNCj4+IAl9DQo+IA0KPiBUaGF0IGRvZXNuJ3Qg
bG9vayBxdWl0ZSBlcXVpdmFsZW50LCBidXQgeWVzLCB0aGlzIGNhbiBiZSByZXdyaXR0ZW4gYXMg
YQ0KDQpJbmRlZWQsIEkgbWFkZSBhIG1pc3Rha2UuIFlvdXIgYmVsb3cgY2hhbmdlIGlzIGNvcnJl
Y3QuDQoNCj4gc2luZ2xlIGlmIHN0YXRlbWVudCBsaWtlIHRoaXM6DQo+IA0KPiAJaWYgKChJU19F
TkFCTEVEKENPTkZJR19CUEZfSklUX0FMV0FZU19PTikgfHwNCj4gCSAgICAgcHJvZy0+aml0ZWQp
ICYmDQo+IAkgICAgKGhkci0+bWFnaWMgIT0gQlBGX0JJTkFSWV9IRUFERVJfTUFHSUMgfHwNCj4g
CSAgICAgIWFyY2hfYnBmX2ppdF9jaGVja19mdW5jKHByb2cpKSkNCj4gDQo+IEkgdGhpbmsgc3Bs
aXR0aW5nIHRoZSBpbnRlcnByZXRlciBhbmQgSklUIHBhdGhzIHdvdWxkIGJlIG1vcmUgcmVhZGFi
bGUsDQo+IGJ1dCBJIGNhbiBjZXJ0YWlubHkgY2hhbmdlIHRoaXMgaWYgeW91IHByZWZlci4NCg0K
SG93IGFib3V0IHRoaXM6DQoNCglpZiAoIUlTX0VOQUJMRUQoQ09ORklHX0JQRl9KSVRfQUxXQVlT
X09OKSAmJiAhcHJvZy0+aml0ZWQpDQoJCWdvdG8gb3V0Ow0KDQoJaWYgKHVubGlrZWx5KGhkci0+
bWFnaWMgIT0gQlBGX0JJTkFSWV9IRUFERVJfTUFHSUMgfHwNCgkgICAgIWFyY2hfYnBmX2ppdF9j
aGVja19mdW5jKHByb2cpKSkgew0KCQlXQVJOKDEsICJhdHRlbXB0IHRvIGp1bXAgdG8gYW4gaW52
YWxpZCBhZGRyZXNzIik7DQoJCXJldHVybiAwOw0KCX0NCm91dDoNCglyZXR1cm4gcHJvZy0+YnBm
X2Z1bmMoY3R4LCBwcm9nLT5pbnNuc2kpOw0KDQo+IA0KPj4gQlBGX1BST0dfUlVOKCkgd2lsbCBi
ZSBjYWxsZWQgZHVyaW5nIHhkcCBmYXN0IHBhdGguDQo+PiBIYXZlIHlvdSBtZWFzdXJlZCBob3cg
bXVjaCBzbG93ZG93biB0aGUgYWJvdmUgY2hhbmdlIGNvdWxkDQo+PiBjb3N0IGZvciB0aGUgcGVy
Zm9ybWFuY2U/DQo+IA0KPiBJIGhhdmUgbm90IG1lYXN1cmVkIHRoZSBvdmVyaGVhZCwgYnV0IGl0
IHNob3VsZG4ndCBiZSBzaWduaWZpY2FudC4gSXMNCj4gdGhlcmUgYSBwYXJ0aWN1bGFyIGJlbmNo
bWFyayB5b3UnZCBsaWtlIG1lIHRvIHJ1bj8NCg0KSSBhbSBub3QgYW4gZXhwZXJ0IGluIFhEUCB0
ZXN0aW5nLiBUb2tlLCBCasO2cm4sIGNvdWxkIHlvdSBnaXZlIHNvbWUNCnN1Z2dlc3Rpb25zIHdo
YXQgdG8gdGVzdCBmb3IgWERQIHBlcmZvcm1hbmNlIGhlcmU/DQoNCj4gDQo+IFNhbWkNCj4gDQo=
