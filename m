Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D509DEB9B5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfJaWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:31:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbfJaWbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:31:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9VMURwb020224;
        Thu, 31 Oct 2019 15:31:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DI4vMo+ZOrmI0kh7tWW40t1Ej1TZIXITP+gXqMvqHdQ=;
 b=lck5yO7oXOr3RAxCfjTlEZ0UjzK6fkfwzD/hXuB9hklCU8J2RTggnLdNMD1U/vvS9LmF
 RLCIPHaEMUlQ5cY3w9mUDEpuPCeLEDvW9k35xEzcVc5BKb+UP8lkWzSDy3V60hFepRsk
 BQ1xYdI8a35BdXiFQitNtB0MyO/KcGUgzCw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vxwn948ea-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 31 Oct 2019 15:31:16 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 31 Oct 2019 15:31:08 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 31 Oct 2019 15:31:07 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 31 Oct 2019 15:31:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDm2i11jfKH4LjqLHj9H00RIFdS/Jr9bB07JbtrTAEyMVb4Pp0eWtZOowbTHxy6TLVbspegYv884LZfZXTZuJgSxBI9d+fQRrW0VC5z3+L4F9H5b17WFFT+k9JRI5FW6gXMHtKacQl6Zvl1aDoMVN1O9cJD5MK6Xs3PiNVf/lDAdiB9xNmeGenrZ6FU0BJSGCMqu5j9OARGOF7x2wSeWE5SNYgDoNzxeDge9KfGa18qGaHhGobvYLQ29KeU/YQ9WPWZDCxJ60Ma79RxG2SQva7ElZ+VP3JAadaKTKi0M0gw8sC2huMOCQObC5Yh8K3tYiTBHmgD+pFKy8DOG8ZtjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI4vMo+ZOrmI0kh7tWW40t1Ej1TZIXITP+gXqMvqHdQ=;
 b=jtgMIatRikYQOgJadZ3v2onUz4BzD0UjwQU98KvmbAV3L+gsFD5nOpGkUfT/ob817KeViakQidxc7Fkj858GBs3Fhxxt/ZUwFeyHrHEg336T1ZRJBTbNjTdEhfK5nCSfV9y5RsCp6Y2V2g26bDzEtDOI4nK2sDU2BduyDDVaQ4OqYlCfVtbduxsUN9wjRYWJPhO3WA6UvRTnpT58qRSIL87FQ6aWlyyL3L8mFG64AGHVBmglSAhoye0BKuc+7xKUDT3xltue+Rbn6MDdSGlBs+IklOzEZkIPyQavOqgXRnIV+V28h1iYcmAijBFcfDDSaGy0GGXIZ9KZWvvO35/ipA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI4vMo+ZOrmI0kh7tWW40t1Ej1TZIXITP+gXqMvqHdQ=;
 b=bfIR7SuXNEX9ll2s0fhE2u69+CAR67cISDMgTQOqdYiN8fruz/BRJIaOUMgSp/90qphqiQ9BjjxYVmedag9/w6Se+4Z3BGhg4IP0OWGFi1xFGwLUDIh3XPtJyc3v6Wo+8gaLuId5U4w0Srx2/umWbExNe11XZZrwhxFBMLydHuU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2583.namprd15.prod.outlook.com (20.179.157.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Thu, 31 Oct 2019 22:31:06 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.028; Thu, 31 Oct 2019
 22:31:06 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [Review Request] Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Topic: [Review Request] Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Index: AQHViQ10L4Sk4Hu3bUSGIRdEQH4YW6dnizGAgAitNYCABStAgA==
Date:   Thu, 31 Oct 2019 22:31:05 +0000
Message-ID: <01acf191-f1aa-bf01-0945-56e4f37af69b@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-2-cneirabustos@gmail.com>
 <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
 <63882673-849d-cae3-1432-1d9411c10348@fb.com>
In-Reply-To: <63882673-849d-cae3-1432-1d9411c10348@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0080.namprd17.prod.outlook.com
 (2603:10b6:300:c2::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2a49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ba6744d-5535-4c12-0376-08d75e5204cb
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-microsoft-antispam-prvs: <BYAPR15MB25839236B88356BD80BC5424D3630@BYAPR15MB2583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(446003)(86362001)(71200400001)(6506007)(14444005)(5660300002)(54906003)(53546011)(31696002)(186003)(6486002)(76176011)(102836004)(71190400001)(36756003)(256004)(46003)(386003)(2616005)(476003)(6436002)(486006)(11346002)(52116002)(31686004)(66476007)(478600001)(316002)(6512007)(66446008)(99286004)(2501003)(305945005)(64756008)(66946007)(7736002)(4326008)(6116002)(25786009)(110136005)(14454004)(8936002)(81166006)(81156014)(8676002)(66556008)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2583;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E6TzjUxp5nkU7J5vdwm1HatJ2yY9DGL9e6GQPYYosttX4C9kFfck9sFFDaRObTv0cqhAgpnmYz5sZIcOU2lneyRcsL6MhEfOJySGJbGp75pLsPSGDlwQRR+xLHP/DYxtuBmhYXRVVJlCiR9a4+nHIFcb3osl858v+UuMRhgR1sd01imuMV4R+3LeLc7pvBK6Ge4FyzJA/SSasbbfUqi3Zb8TFppTdlM6A3ig6M7VHYrE+Kvy9YgegqdimJiQvhqBT71S3SCijFdUG/g95qU01V4q0vQRG860kZtSOfdIDdndyNgfwYWCENMmfq8AgtqTCZWGkAdgmVjT1f96An2E8kMpCTnI2uV1zLunaNTOtrCKQlWcdNzxWInQ/HhNJb1e4mhSbGxWDtTct/GgGVUUVPfrVcefsHhcGE4OBJzUuB7OgVdtxHeW+O9DtuhuXaho
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9E2A9361570614685BDBE90994311A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba6744d-5535-4c12-0376-08d75e5204cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 22:31:06.1494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qUij7D5whp5GslGuJHQS4vszbO67OINJQD7uVHpK2ZgLGdKumEdCR56uXTBRDK8j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-31_08:2019-10-30,2019-10-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910310223
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpFcmljLA0KDQpJbiBjYXNlIHRoYXQgeW91IG1pc3NlZCB0aGUgZW1haWwsIEkgYWRkZWQgIltS
ZXZpZXcgUmVxdWVzdF0iDQphbmQgcGluZ2VkIGFnYWluLiBJdCB3b3VsZCBiZSBnb29kIGlmIHlv
dSBjYW4gdGFrZSBhIGxvb2sNCmFuZCBhY2sgaWYgaXQgbG9va3MgZ29vZCB0byB5b3UuDQoNClRo
YW5rcyENCg0KDQpPbiAxMC8yOC8xOSA4OjM0IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiBQ
aW5nIGFnYWluLg0KPiANCj4gRXJpYywgY291bGQgeW91IHRha2UgYSBsb29rIGF0IHRoaXMgcGF0
Y2ggYW5kIGFjayBpdCBpZiBpdCBpcyBva2F5Pw0KPiANCj4gVGhhbmtzIQ0KPiANCj4gDQo+IE9u
IDEwLzIyLzE5IDg6MDUgUE0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+Pg0KPj4gSGksIEVyaWMs
DQo+Pg0KPj4gQ291bGQgeW91IHRha2UgYSBsb29rIGF0IHRoaXMgcGF0Y2ggdGhlIHNlcmllcyBh
cyB3ZWxsPw0KPj4gSWYgaXQgbG9va3MgZ29vZCwgY291bGQgeW91IGFjayB0aGUgcGF0Y2ggIzE/
DQo+Pg0KPj4gVGhhbmtzIQ0KPj4NCj4+IE9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVp
cmEgd3JvdGU6DQo+Pj4gbnNfbWF0Y2ggcmV0dXJucyB0cnVlIGlmIHRoZSBuYW1lc3BhY2UgaW5v
ZGUgYW5kIGRldl90IG1hdGNoZXMgdGhlIG9uZXMNCj4+PiBwcm92aWRlZCBieSB0aGUgY2FsbGVy
Lg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21h
aWwuY29tPg0KPj4+IC0tLQ0KPj4+ICAgICBmcy9uc2ZzLmMgICAgICAgICAgICAgICB8IDE0ICsr
KysrKysrKysrKysrDQo+Pj4gICAgIGluY2x1ZGUvbGludXgvcHJvY19ucy5oIHwgIDIgKysNCj4+
PiAgICAgMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspDQo+Pj4NCj4+PiBkaWZmIC0t
Z2l0IGEvZnMvbnNmcy5jIGIvZnMvbnNmcy5jDQo+Pj4gaW5kZXggYTA0MzE2NDJjNmI1Li5lZjU5
Y2YzNDcyODUgMTAwNjQ0DQo+Pj4gLS0tIGEvZnMvbnNmcy5jDQo+Pj4gKysrIGIvZnMvbnNmcy5j
DQo+Pj4gQEAgLTI0NSw2ICsyNDUsMjAgQEAgc3RydWN0IGZpbGUgKnByb2NfbnNfZmdldChpbnQg
ZmQpDQo+Pj4gICAgIAlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4+PiAgICAgfQ0KPj4+ICAg
ICANCj4+PiArLyoqDQo+Pj4gKyAqIG5zX21hdGNoKCkgLSBSZXR1cm5zIHRydWUgaWYgY3VycmVu
dCBuYW1lc3BhY2UgbWF0Y2hlcyBkZXYvaW5vIHByb3ZpZGVkLg0KPj4+ICsgKiBAbnNfY29tbW9u
OiBjdXJyZW50IG5zDQo+Pj4gKyAqIEBkZXY6IGRldl90IGZyb20gbnNmcyB0aGF0IHdpbGwgYmUg
bWF0Y2hlZCBhZ2FpbnN0IGN1cnJlbnQgbnNmcw0KPj4+ICsgKiBAaW5vOiBpbm9fdCBmcm9tIG5z
ZnMgdGhhdCB3aWxsIGJlIG1hdGNoZWQgYWdhaW5zdCBjdXJyZW50IG5zZnMNCj4+PiArICoNCj4+
PiArICogUmV0dXJuOiB0cnVlIGlmIGRldiBhbmQgaW5vIG1hdGNoZXMgdGhlIGN1cnJlbnQgbnNm
cy4NCj4+PiArICovDQo+Pj4gK2Jvb2wgbnNfbWF0Y2goY29uc3Qgc3RydWN0IG5zX2NvbW1vbiAq
bnMsIGRldl90IGRldiwgaW5vX3QgaW5vKQ0KPj4+ICt7DQo+Pj4gKwlyZXR1cm4gKG5zLT5pbnVt
ID09IGlubykgJiYgKG5zZnNfbW50LT5tbnRfc2ItPnNfZGV2ID09IGRldik7DQo+Pj4gK30NCj4+
PiArDQo+Pj4gKw0KPj4+ICAgICBzdGF0aWMgaW50IG5zZnNfc2hvd19wYXRoKHN0cnVjdCBzZXFf
ZmlsZSAqc2VxLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpDQo+Pj4gICAgIHsNCj4+PiAgICAgCXN0
cnVjdCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7DQo+Pj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvcHJvY19ucy5oIGIvaW5jbHVkZS9saW51eC9wcm9jX25zLmgNCj4+PiBpbmRl
eCBkMzFjYjYyMTU5MDUuLjFkYTlmMzM0ODlmMyAxMDA2NDQNCj4+PiAtLS0gYS9pbmNsdWRlL2xp
bnV4L3Byb2NfbnMuaA0KPj4+ICsrKyBiL2luY2x1ZGUvbGludXgvcHJvY19ucy5oDQo+Pj4gQEAg
LTgyLDYgKzgyLDggQEAgdHlwZWRlZiBzdHJ1Y3QgbnNfY29tbW9uICpuc19nZXRfcGF0aF9oZWxw
ZXJfdCh2b2lkICopOw0KPj4+ICAgICBleHRlcm4gdm9pZCAqbnNfZ2V0X3BhdGhfY2Ioc3RydWN0
IHBhdGggKnBhdGgsIG5zX2dldF9wYXRoX2hlbHBlcl90IG5zX2dldF9jYiwNCj4+PiAgICAgCQkJ
ICAgIHZvaWQgKnByaXZhdGVfZGF0YSk7DQo+Pj4gICAgIA0KPj4+ICtleHRlcm4gYm9vbCBuc19t
YXRjaChjb25zdCBzdHJ1Y3QgbnNfY29tbW9uICpucywgZGV2X3QgZGV2LCBpbm9fdCBpbm8pOw0K
Pj4+ICsNCj4+PiAgICAgZXh0ZXJuIGludCBuc19nZXRfbmFtZShjaGFyICpidWYsIHNpemVfdCBz
aXplLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssDQo+Pj4gICAgIAkJCWNvbnN0IHN0cnVjdCBw
cm9jX25zX29wZXJhdGlvbnMgKm5zX29wcyk7DQo+Pj4gICAgIGV4dGVybiB2b2lkIG5zZnNfaW5p
dCh2b2lkKTsNCj4+Pg0K
