Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81F515CD9E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgBMVzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:55:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgBMVzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:55:21 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DLt5rg011794;
        Thu, 13 Feb 2020 13:55:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=w+ZpeMBU1hB/Nrkq/AL6VzRac6eVm/Ou2rR7idpOT/I=;
 b=hdFUsVYoiWRcrp+NQpusAXuqWPO58Sz7KFa9IejMCk0AQvRJImxU3jg0JpXuPPw8Xvz9
 d2uDC1uOUfZ3y10cvx31KNFQ1f31n9MhY1/2r44om6NDPV0L7BuNNiNGdrk+4G350PPc
 1kjKDafGokJBEk19WfbGL3Yva9n6BhCAZgg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y4qv66exk-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Feb 2020 13:55:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 13 Feb 2020 13:55:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goTh5S5Mspxok8JmTQoHqJmWzxWl4DG3u5BUlFXHivi+WYuRrv9QNYWk5exoWx1SfcqHhjB7dCktVBjcV3yWSDg0NorMpiLZ5VQV1M0cGldDcoLZmFQvn9mtkWSVXHsBoWJghzaXkEghcp1eGpWUAfnv82DpAvaZPUFFs3FJxYxCmZ9KndAgLdqOqQUrODALi8VoojSJvDcT6icy4OiesRg0iPTF8UyZK+qwqmt8Knbcwl9IWF9KgXfW4D3t9+cPz6Syn9suXq3jnHRQCbWsD0Hjonc9x9KcKFOvc0m452V9Q/qbW7BMtnQlTx3ddt7kYByQK41WngheOtM4zl/kWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+ZpeMBU1hB/Nrkq/AL6VzRac6eVm/Ou2rR7idpOT/I=;
 b=B+9BO4iarCqXy7WZGkF4tFkRwKhsi9CpZ74jHdOm5VLUgU149BWZNI7Yj9t9duok9fADuohl7z2YtdIFJENspXmOBOl0Hv0oYx/ePB1iBCc93MDD8DmbqrORJhJtPw2/Lfz/YNHnDsIKc4vRKukjxFrOOb1XyaKUbpIE8oDwudsGPek9ituhwb9n8/H5wZK7gUyd1iv4642Ozp4gjc13aNvxc46bKoqZgvxSqGgLoNtVKiri4qxg4NoqqH0sNQJU7aaMU44xWYFZqsVPt1cUDfBeAV5nw/758uRAPSecdADpWnwBUEOCgjpaIe0z5R3NSp1/yiz25NOzL17ARSbR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+ZpeMBU1hB/Nrkq/AL6VzRac6eVm/Ou2rR7idpOT/I=;
 b=ep5k/Cihd5WzV7sRt0nMGpXBFyG9GoStHsknAi0M6y7jLIrAePIbjCiCh8uBYAZmAQrdoflzG7RdibZm92CAQ0dqDyn/NwtrdDBOYDnQVOT83GlvSMYRNC9s27S9XHukDEvv0KA3tWyT8dwWgSTJ6QUXDq+WA9+G4ZCiFCwXavA=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2057.namprd15.prod.outlook.com (52.132.151.159) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Thu, 13 Feb 2020 21:55:04 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 21:55:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Thread-Topic: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Thread-Index: AQHV4rD13dwh4/0hXUSMa6ZitJFaYKgZqbkAgAABYoA=
Date:   Thu, 13 Feb 2020 21:55:04 +0000
Message-ID: <6C487C26-1037-4CE5-8FA2-0BD67DA5F3F7@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com>
 <20200213210115.1455809-4-songliubraving@fb.com> <87o8u2dunl.fsf@toke.dk>
In-Reply-To: <87o8u2dunl.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c092:180::1:4fa7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 266c0656-c7b8-4624-8dc2-08d7b0cf61fa
x-ms-traffictypediagnostic: MW2PR1501MB2057:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB205771078D2FBA47B01ED3FAB31A0@MW2PR1501MB2057.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39850400004)(136003)(396003)(366004)(376002)(189003)(199004)(316002)(2906002)(54906003)(5660300002)(2616005)(8676002)(8936002)(81156014)(66574012)(81166006)(86362001)(36756003)(66476007)(66446008)(33656002)(478600001)(71200400001)(64756008)(66556008)(4326008)(186003)(6486002)(76116006)(53546011)(6506007)(91956017)(6512007)(66946007)(6916009)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2057;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLpy2RWitcLNZP8Fw2FX9Fh1o6BG9b9dky6epTzZ/z8cy+WV3BnvrUvfntgthH9E3x2srvEL4NzSIsE6Ku7W+ZN7clX6qJFpn8UMtdXGYtL9yIkS/nC3cv87scEvCmPvmYZGmuKLFzjkP2SxPFSElGCnKO/vYVFp9TZIbCGJpkMnHkdO7r3Ph5syh/K3AovBAeADvJlye8qFO4jV5Lf4V1CcU/xf6vb7zaN8oI/vGy3DW2a3FPzclya1NldssmrQtb2Qzn7Xh0m28trnaNLBJniJCS41VwofGIvUhBEBkC9V15cw8+JMG1ABgtG5HkkmGbI87yjFvMeJ1Q400ca94tGcQHY+bmpmvGcttNp1DzGbgEVrsqTGiGz9fRPRzBhUSvccVod6pguMiTBdUKu37fANYe8HrDgIKDZCs4xzb+kRQfS99niddcrAEWYStj/s/M+uoomSuQ5+j9sEf9RKareo11fao6eXCC0CwNC3RpM=
x-ms-exchange-antispam-messagedata: L/zkA6W2lPKCk3gvMEp6KYBGoauAjvhbiaQVUJlwwuudKH8I2VjlrFEjlUlCVLeqzReB5U8wkenvqn7qP+eMloX2TbKmYb3LTREI1de7qtdSb8qujFU3N2/AD2PMhwfBaZCqKmwU2tOJJZEvvhqVvDtbjbfQBMDFBXAAwlbqJuqiSxIvT/MwHbwrt6qR0hGK
Content-Type: text/plain; charset="utf-8"
Content-ID: <A63BE3A459AC214D966CB4C2F59EEB30@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 266c0656-c7b8-4624-8dc2-08d7b0cf61fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 21:55:04.3574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StxsgA1Xj8mH+nsainVpT3Ek+TUk0/IxZzOZQ+i2iaYJmcXd8U1+4HAmmITyM2kha9QLJUnKLJaNNwgmOmn5nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2057
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0
 spamscore=0 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRmViIDEzLCAyMDIwLCBhdCAxOjUwIFBNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5z
ZW4gPHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBTb25nIExpdSA8c29uZ2xpdWJyYXZp
bmdAZmIuY29tPiB3cml0ZXM6DQo+IA0KPj4gV2l0aCBmZW50cnkvZmV4aXQgcHJvZ3JhbXMsIGl0
IGlzIHBvc3NpYmxlIHRvIHByb2ZpbGUgQlBGIHByb2dyYW0gd2l0aA0KPj4gaGFyZHdhcmUgY291
bnRlcnMuIEludHJvZHVjZSBicGZ0b29sICJwcm9nIHByb2ZpbGUiLCB3aGljaCBtZWFzdXJlcyBr
ZXkNCj4+IG1ldHJpY3Mgb2YgYSBCUEYgcHJvZ3JhbS4NCj4+IA0KPj4gYnBmdG9vbCBwcm9nIHBy
b2ZpbGUgY29tbWFuZCBjcmVhdGVzIHBlci1jcHUgcGVyZiBldmVudHMuIFRoZW4gaXQgYXR0YWNo
ZXMNCj4+IGZlbnRyeS9mZXhpdCBwcm9ncmFtcyB0byB0aGUgdGFyZ2V0IEJQRiBwcm9ncmFtLiBU
aGUgZmVudHJ5IHByb2dyYW0gc2F2ZXMNCj4+IHBlcmYgZXZlbnQgdmFsdWUgdG8gYSBtYXAuIFRo
ZSBmZXhpdCBwcm9ncmFtIHJlYWRzIHRoZSBwZXJmIGV2ZW50IGFnYWluLA0KPj4gYW5kIGNhbGN1
bGF0ZXMgdGhlIGRpZmZlcmVuY2UsIHdoaWNoIGlzIHRoZSBpbnN0cnVjdGlvbnMvY3ljbGVzIHVz
ZWQgYnkNCj4+IHRoZSB0YXJnZXQgcHJvZ3JhbS4NCj4+IA0KPj4gRXhhbXBsZSBpbnB1dCBhbmQg
b3V0cHV0Og0KPj4gDQo+PiAgLi9icGZ0b29sIHByb2cgcHJvZmlsZSAyMCBpZCA4MTAgY3ljbGVz
IGluc3RydWN0aW9ucw0KPj4gIGN5Y2xlczogZHVyYXRpb24gMjAgcnVuX2NudCAxMzY4IG1pc3Nf
Y250IDY2NQ0KPj4gICAgICAgICAgY291bnRlciA1MDMzNzcgZW5hYmxlZCA2NjgyMDIgcnVubmlu
ZyAzNTE4NTcNCj4+ICBpbnN0cnVjdGlvbnM6IGR1cmF0aW9uIDIwIHJ1bl9jbnQgMTM2OCBtaXNz
X2NudCA3MDcNCj4+ICAgICAgICAgIGNvdW50ZXIgMzk4NjI1IGVuYWJsZWQgNTAyMzMwIHJ1bm5p
bmcgMjcyMDE0DQo+PiANCj4+IFRoaXMgY29tbWFuZCBtZWFzdXJlcyBjeWNsZXMgYW5kIGluc3Ry
dWN0aW9ucyBmb3IgQlBGIHByb2dyYW0gd2l0aCBpZA0KPj4gODEwIGZvciAyMCBzZWNvbmRzLiBU
aGUgcHJvZ3JhbSBoYXMgdHJpZ2dlcmVkIDEzNjggdGltZXMuIGN5Y2xlcyB3YXMgbm90DQo+PiBt
ZWFzdXJlZCBpbiA2NjUgb3V0IG9mIHRoZXNlIHJ1bnMsIGJlY2F1c2Ugb2YgcGVyZiBldmVudCBt
dWx0aXBsZXhpbmcNCj4+IChzb21lIHBlcmYgY29tbWFuZHMgYXJlIHJ1bm5pbmcgaW4gdGhlIGJh
Y2tncm91bmQpLiBJbiB0aGVzZSBydW5zLCB0aGUgQlBGDQo+PiBwcm9ncmFtIGNvbnN1bWVkIDUw
MzM3NyBjeWNsZXMuIFRoZSBwZXJmX2V2ZW50IGVuYWJsZWQgYW5kIHJ1bm5pbmcgdGltZQ0KPj4g
YXJlIDY2ODIwMiBhbmQgMzUxODU3IHJlc3BlY3RpdmVseS4NCj4+IA0KPj4gTm90ZSB0aGF0LCB0
aGlzIGFwcHJvYWNoIG1lYXN1cmVzIGN5Y2xlcyBhbmQgaW5zdHJ1Y3Rpb25zIGluIHZlcnkgc21h
bGwNCj4+IGluY3JlbWVudHMuIFNvIHRoZSBmZW50cnkvZmV4aXQgcHJvZ3JhbXMgaW50cm9kdWNl
IG5vdGljYWJsZSBlcnJvcnMgdG8NCj4+IHRoZSBtZWFzdXJlbWVudCByZXN1bHRzLg0KPj4gDQo+
PiBUaGUgZmVudHJ5L2ZleGl0IHByb2dyYW1zIGFyZSBnZW5lcmF0ZWQgd2l0aCBCUEYgc2tlbGV0
b24uIEN1cnJlbnRseSwNCj4+IGdlbmVyYXRpb24gb2YgdGhlIHNrZWxldG9uIHJlcXVpcmVzIHNv
bWUgbWFudWFsIHN0ZXBzLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBTb25nIExpdSA8c29uZ2xp
dWJyYXZpbmdAZmIuY29tPg0KPj4gLS0tDQo+PiB0b29scy9icGYvYnBmdG9vbC9wcm9maWxlci5z
a2VsLmggICAgICAgICB8IDgyMCArKysrKysrKysrKysrKysrKysrKysrDQo+PiB0b29scy9icGYv
YnBmdG9vbC9wcm9nLmMgICAgICAgICAgICAgICAgICB8IDM4NyArKysrKysrKystDQo+PiB0b29s
cy9icGYvYnBmdG9vbC9za2VsZXRvbi9SRUFETUUgICAgICAgICB8ICAgMyArDQo+PiB0b29scy9i
cGYvYnBmdG9vbC9za2VsZXRvbi9wcm9maWxlci5icGYuYyB8IDE4NSArKysrKw0KPj4gdG9vbHMv
YnBmL2JwZnRvb2wvc2tlbGV0b24vcHJvZmlsZXIuaCAgICAgfCAgNDcgKysNCj4+IDUgZmlsZXMg
Y2hhbmdlZCwgMTQ0MSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiBjcmVhdGUgbW9k
ZSAxMDA2NDQgdG9vbHMvYnBmL2JwZnRvb2wvcHJvZmlsZXIuc2tlbC5oDQo+PiBjcmVhdGUgbW9k
ZSAxMDA2NDQgdG9vbHMvYnBmL2JwZnRvb2wvc2tlbGV0b24vUkVBRE1FDQo+PiBjcmVhdGUgbW9k
ZSAxMDA2NDQgdG9vbHMvYnBmL2JwZnRvb2wvc2tlbGV0b24vcHJvZmlsZXIuYnBmLmMNCj4+IGNy
ZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9icGYvYnBmdG9vbC9za2VsZXRvbi9wcm9maWxlci5oDQo+
PiANCj4+IGRpZmYgLS1naXQgYS90b29scy9icGYvYnBmdG9vbC9wcm9maWxlci5za2VsLmggYi90
b29scy9icGYvYnBmdG9vbC9wcm9maWxlci5za2VsLmgNCj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0
DQo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjEwZTk5OTg5YzAzZQ0KPj4gLS0tIC9kZXYvbnVsbA0K
Pj4gKysrIGIvdG9vbHMvYnBmL2JwZnRvb2wvcHJvZmlsZXIuc2tlbC5oDQo+PiBAQCAtMCwwICsx
LDgyMCBAQA0KPj4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiAoTEdQTC0yLjEgT1IgQlNE
LTItQ2xhdXNlKSAqLw0KPj4gKw0KPj4gKy8qIFRISVMgRklMRSBJUyBBVVRPR0VORVJBVEVEISAq
Lw0KPj4gKyNpZm5kZWYgX19QUk9GSUxFUl9CUEZfU0tFTF9IX18NCj4+ICsjZGVmaW5lIF9fUFJP
RklMRVJfQlBGX1NLRUxfSF9fDQo+PiArDQo+PiArI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPj4gKyNp
bmNsdWRlIDxicGYvbGliYnBmLmg+DQo+PiArDQo+PiArc3RydWN0IHByb2ZpbGVyX2JwZiB7DQo+
PiArCXN0cnVjdCBicGZfb2JqZWN0X3NrZWxldG9uICpza2VsZXRvbjsNCj4+ICsJc3RydWN0IGJw
Zl9vYmplY3QgKm9iajsNCj4+ICsJc3RydWN0IHsNCj4+ICsJCXN0cnVjdCBicGZfbWFwICpldmVu
dHM7DQo+PiArCQlzdHJ1Y3QgYnBmX21hcCAqZmVudHJ5X3JlYWRpbmdzOw0KPj4gKwkJc3RydWN0
IGJwZl9tYXAgKmFjY3VtX3JlYWRpbmdzOw0KPj4gKwkJc3RydWN0IGJwZl9tYXAgKmNvdW50czsN
Cj4+ICsJCXN0cnVjdCBicGZfbWFwICptaXNzX2NvdW50czsNCj4+ICsJCXN0cnVjdCBicGZfbWFw
ICpyb2RhdGE7DQo+PiArCX0gbWFwczsNCj4+ICsJc3RydWN0IHsNCj4+ICsJCXN0cnVjdCBicGZf
cHJvZ3JhbSAqZmVudHJ5X1hYWDsNCj4+ICsJCXN0cnVjdCBicGZfcHJvZ3JhbSAqZmV4aXRfWFhY
Ow0KPj4gKwl9IHByb2dzOw0KPj4gKwlzdHJ1Y3Qgew0KPj4gKwkJc3RydWN0IGJwZl9saW5rICpm
ZW50cnlfWFhYOw0KPj4gKwkJc3RydWN0IGJwZl9saW5rICpmZXhpdF9YWFg7DQo+PiArCX0gbGlu
a3M7DQo+PiArCXN0cnVjdCBwcm9maWxlcl9icGZfX3JvZGF0YSB7DQo+PiArCQlfX3UzMiBudW1f
Y3B1Ow0KPj4gKwkJX191MzIgbnVtX21ldHJpYzsNCj4+ICsJfSAqcm9kYXRhOw0KPj4gK307DQo+
PiArDQo+PiArc3RhdGljIHZvaWQNCj4+ICtwcm9maWxlcl9icGZfX2Rlc3Ryb3koc3RydWN0IHBy
b2ZpbGVyX2JwZiAqb2JqKQ0KPj4gK3sNCj4+ICsJaWYgKCFvYmopDQo+PiArCQlyZXR1cm47DQo+
PiArCWlmIChvYmotPnNrZWxldG9uKQ0KPj4gKwkJYnBmX29iamVjdF9fZGVzdHJveV9za2VsZXRv
bihvYmotPnNrZWxldG9uKTsNCj4+ICsJZnJlZShvYmopOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0
aWMgaW5saW5lIGludA0KPj4gK3Byb2ZpbGVyX2JwZl9fY3JlYXRlX3NrZWxldG9uKHN0cnVjdCBw
cm9maWxlcl9icGYgKm9iaik7DQo+PiArDQo+PiArc3RhdGljIGlubGluZSBzdHJ1Y3QgcHJvZmls
ZXJfYnBmICoNCj4+ICtwcm9maWxlcl9icGZfX29wZW5fb3B0cyhjb25zdCBzdHJ1Y3QgYnBmX29i
amVjdF9vcGVuX29wdHMgKm9wdHMpDQo+PiArew0KPj4gKwlzdHJ1Y3QgcHJvZmlsZXJfYnBmICpv
Ymo7DQo+PiArDQo+PiArCW9iaiA9ICh0eXBlb2Yob2JqKSljYWxsb2MoMSwgc2l6ZW9mKCpvYmop
KTsNCj4+ICsJaWYgKCFvYmopDQo+PiArCQlyZXR1cm4gTlVMTDsNCj4+ICsJaWYgKHByb2ZpbGVy
X2JwZl9fY3JlYXRlX3NrZWxldG9uKG9iaikpDQo+PiArCQlnb3RvIGVycjsNCj4+ICsJaWYgKGJw
Zl9vYmplY3RfX29wZW5fc2tlbGV0b24ob2JqLT5za2VsZXRvbiwgb3B0cykpDQo+PiArCQlnb3Rv
IGVycjsNCj4+ICsNCj4+ICsJcmV0dXJuIG9iajsNCj4+ICtlcnI6DQo+PiArCXByb2ZpbGVyX2Jw
Zl9fZGVzdHJveShvYmopOw0KPj4gKwlyZXR1cm4gTlVMTDsNCj4+ICt9DQo+PiArDQo+PiArc3Rh
dGljIGlubGluZSBzdHJ1Y3QgcHJvZmlsZXJfYnBmICoNCj4+ICtwcm9maWxlcl9icGZfX29wZW4o
dm9pZCkNCj4+ICt7DQo+PiArCXJldHVybiBwcm9maWxlcl9icGZfX29wZW5fb3B0cyhOVUxMKTsN
Cj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGlubGluZSBpbnQNCj4+ICtwcm9maWxlcl9icGZfX2xv
YWQoc3RydWN0IHByb2ZpbGVyX2JwZiAqb2JqKQ0KPj4gK3sNCj4+ICsJcmV0dXJuIGJwZl9vYmpl
Y3RfX2xvYWRfc2tlbGV0b24ob2JqLT5za2VsZXRvbik7DQo+PiArfQ0KPj4gKw0KPj4gK3N0YXRp
YyBpbmxpbmUgc3RydWN0IHByb2ZpbGVyX2JwZiAqDQo+PiArcHJvZmlsZXJfYnBmX19vcGVuX2Fu
ZF9sb2FkKHZvaWQpDQo+PiArew0KPj4gKwlzdHJ1Y3QgcHJvZmlsZXJfYnBmICpvYmo7DQo+PiAr
DQo+PiArCW9iaiA9IHByb2ZpbGVyX2JwZl9fb3BlbigpOw0KPj4gKwlpZiAoIW9iaikNCj4+ICsJ
CXJldHVybiBOVUxMOw0KPj4gKwlpZiAocHJvZmlsZXJfYnBmX19sb2FkKG9iaikpIHsNCj4+ICsJ
CXByb2ZpbGVyX2JwZl9fZGVzdHJveShvYmopOw0KPj4gKwkJcmV0dXJuIE5VTEw7DQo+PiArCX0N
Cj4+ICsJcmV0dXJuIG9iajsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGlubGluZSBpbnQNCj4+
ICtwcm9maWxlcl9icGZfX2F0dGFjaChzdHJ1Y3QgcHJvZmlsZXJfYnBmICpvYmopDQo+PiArew0K
Pj4gKwlyZXR1cm4gYnBmX29iamVjdF9fYXR0YWNoX3NrZWxldG9uKG9iai0+c2tlbGV0b24pOw0K
Pj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgaW5saW5lIHZvaWQNCj4+ICtwcm9maWxlcl9icGZfX2Rl
dGFjaChzdHJ1Y3QgcHJvZmlsZXJfYnBmICpvYmopDQo+PiArew0KPj4gKwlyZXR1cm4gYnBmX29i
amVjdF9fZGV0YWNoX3NrZWxldG9uKG9iai0+c2tlbGV0b24pOw0KPj4gK30NCj4+ICsNCj4+ICtz
dGF0aWMgaW5saW5lIGludA0KPj4gK3Byb2ZpbGVyX2JwZl9fY3JlYXRlX3NrZWxldG9uKHN0cnVj
dCBwcm9maWxlcl9icGYgKm9iaikNCj4+ICt7DQo+PiArCXN0cnVjdCBicGZfb2JqZWN0X3NrZWxl
dG9uICpzOw0KPj4gKw0KPj4gKwlzID0gKHR5cGVvZihzKSljYWxsb2MoMSwgc2l6ZW9mKCpzKSk7
DQo+PiArCWlmICghcykNCj4+ICsJCXJldHVybiAtMTsNCj4+ICsJb2JqLT5za2VsZXRvbiA9IHM7
DQo+PiArDQo+PiArCXMtPnN6ID0gc2l6ZW9mKCpzKTsNCj4+ICsJcy0+bmFtZSA9ICJwcm9maWxl
cl9icGYiOw0KPj4gKwlzLT5vYmogPSAmb2JqLT5vYmo7DQo+PiArDQo+PiArCS8qIG1hcHMgKi8N
Cj4+ICsJcy0+bWFwX2NudCA9IDY7DQo+PiArCXMtPm1hcF9za2VsX3N6ID0gc2l6ZW9mKCpzLT5t
YXBzKTsNCj4+ICsJcy0+bWFwcyA9ICh0eXBlb2Yocy0+bWFwcykpY2FsbG9jKHMtPm1hcF9jbnQs
IHMtPm1hcF9za2VsX3N6KTsNCj4+ICsJaWYgKCFzLT5tYXBzKQ0KPj4gKwkJZ290byBlcnI7DQo+
PiArDQo+PiArCXMtPm1hcHNbMF0ubmFtZSA9ICJldmVudHMiOw0KPj4gKwlzLT5tYXBzWzBdLm1h
cCA9ICZvYmotPm1hcHMuZXZlbnRzOw0KPj4gKw0KPj4gKwlzLT5tYXBzWzFdLm5hbWUgPSAiZmVu
dHJ5X3JlYWRpbmdzIjsNCj4+ICsJcy0+bWFwc1sxXS5tYXAgPSAmb2JqLT5tYXBzLmZlbnRyeV9y
ZWFkaW5nczsNCj4+ICsNCj4+ICsJcy0+bWFwc1syXS5uYW1lID0gImFjY3VtX3JlYWRpbmdzIjsN
Cj4+ICsJcy0+bWFwc1syXS5tYXAgPSAmb2JqLT5tYXBzLmFjY3VtX3JlYWRpbmdzOw0KPj4gKw0K
Pj4gKwlzLT5tYXBzWzNdLm5hbWUgPSAiY291bnRzIjsNCj4+ICsJcy0+bWFwc1szXS5tYXAgPSAm
b2JqLT5tYXBzLmNvdW50czsNCj4+ICsNCj4+ICsJcy0+bWFwc1s0XS5uYW1lID0gIm1pc3NfY291
bnRzIjsNCj4+ICsJcy0+bWFwc1s0XS5tYXAgPSAmb2JqLT5tYXBzLm1pc3NfY291bnRzOw0KPj4g
Kw0KPj4gKwlzLT5tYXBzWzVdLm5hbWUgPSAicHJvZmlsZXIucm9kYXRhIjsNCj4+ICsJcy0+bWFw
c1s1XS5tYXAgPSAmb2JqLT5tYXBzLnJvZGF0YTsNCj4+ICsJcy0+bWFwc1s1XS5tbWFwZWQgPSAo
dm9pZCAqKikmb2JqLT5yb2RhdGE7DQo+PiArDQo+PiArCS8qIHByb2dyYW1zICovDQo+PiArCXMt
PnByb2dfY250ID0gMjsNCj4+ICsJcy0+cHJvZ19za2VsX3N6ID0gc2l6ZW9mKCpzLT5wcm9ncyk7
DQo+PiArCXMtPnByb2dzID0gKHR5cGVvZihzLT5wcm9ncykpY2FsbG9jKHMtPnByb2dfY250LCBz
LT5wcm9nX3NrZWxfc3opOw0KPj4gKwlpZiAoIXMtPnByb2dzKQ0KPj4gKwkJZ290byBlcnI7DQo+
PiArDQo+PiArCXMtPnByb2dzWzBdLm5hbWUgPSAiZmVudHJ5X1hYWCI7DQo+PiArCXMtPnByb2dz
WzBdLnByb2cgPSAmb2JqLT5wcm9ncy5mZW50cnlfWFhYOw0KPj4gKwlzLT5wcm9nc1swXS5saW5r
ID0gJm9iai0+bGlua3MuZmVudHJ5X1hYWDsNCj4+ICsNCj4+ICsJcy0+cHJvZ3NbMV0ubmFtZSA9
ICJmZXhpdF9YWFgiOw0KPj4gKwlzLT5wcm9nc1sxXS5wcm9nID0gJm9iai0+cHJvZ3MuZmV4aXRf
WFhYOw0KPj4gKwlzLT5wcm9nc1sxXS5saW5rID0gJm9iai0+bGlua3MuZmV4aXRfWFhYOw0KPj4g
Kw0KPj4gKwlzLT5kYXRhX3N6ID0gMTgyNTY7DQo+PiArCXMtPmRhdGEgPSAodm9pZCAqKSJcDQo+
PiArXHg3Zlx4NDVceDRjXHg0Nlx4MDJceDAxXHgwMVwwXDBcMFwwXDBcMFwwXDBcMFx4MDFcMFx4
ZjdcMFx4MDFcMFwwXDBcMFwwXDBcMFwwXA0KPiANCj4gSG9seSBiaW5hcnkgYmxvYiwgQmF0bWFu
ISA6KQ0KPiANCj4gV2hhdCBpcyB0aGlzIGJsb2IsIGV4YWN0bHk/IFRoZSBieXRlY29kZSBvdXRw
dXQgb2YgYSBwcmVjb21waWxlZA0KPiBwcm9ncmFtPw0KDQpJdCBpcyB0aGUgc2tlbGV0b24gY29t
cGlsZWQgZnJvbSBwcm9maWxlci5icGYuYy4gUGxlYXNlIHJlZmVyIHRvIA0KdGhlIFJFQURNRSBm
aWxlIGZvciBzdGVwIHRvIGdlbmVyYXRlIGl0LiANCg0KSW4gbG9uZyB0ZXJtLCB3ZSBzaG91bGQg
aW5jbHVkZSB0aGUgZ2VuZXJhdGlvbiBvZiB0aGlzIGJsb2IgaW4gdGhlIA0KbWFrZSBwcm9jZXNz
LiBCdXQgZm9yIFJGQywgSSBrZXB0IGl0IHNpbXBsZSBmb3Igbm93LiA6KQ0KDQpUaGFua3MsDQpT
b25nDQoNCg0K
