Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0202688D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfEVQnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:43:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729572AbfEVQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:43:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MGdejl014258;
        Wed, 22 May 2019 09:43:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1IFR5YE676gHdVJiz/W5C+1Gkf4ZhjthgzTiaUnkVXM=;
 b=KQGBEb3GZDdVJ66d9VXWgxC7xveq2Q2Nc7/1bYAk9+UIGXoJWFm+szn6mmk+4vDmAdD5
 RIOLWaBCdsMrBEIpRHOpSh8N5c3SIiX5FXBrzXMhs0IU9Ce/wWmyTBfFs1UFcCP/qKM+
 vpOQ1br3M92M1JGTApQjrShITG4qINu75fg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn1eghudb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 09:43:13 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 09:43:12 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 09:43:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IFR5YE676gHdVJiz/W5C+1Gkf4ZhjthgzTiaUnkVXM=;
 b=NEKhxiIDQK1u0bAw4DDXwUZ4EMrabTgnLUwlh5K2BL6gcy4w2DQRjoqJcmjwdbp1wR2WHMIHSfioAMSq/ueNIh3htHL+4KXYnD790kxZISxhVNNG1m2W8gnNbMMTmzD8qk571Bt5FirubVvNWUBJLkdjWLdv0N6iw7YEOlprWP4=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2247.namprd15.prod.outlook.com (52.135.197.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 16:43:09 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 16:43:09 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 0/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v2 0/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEGCz/iJ6EmErOEK2OgukopigTqZ3WO4AgAABLAA=
Date:   Wed, 22 May 2019 16:43:09 +0000
Message-ID: <01865520-1963-9acd-b404-8eac03905baf@fb.com>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522163854.GJ10244@mini-arch>
In-Reply-To: <20190522163854.GJ10244@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0023.namprd14.prod.outlook.com
 (2603:10b6:301:4b::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9fb6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 856cab79-e521-4f35-72b9-08d6ded49280
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2247;
x-ms-traffictypediagnostic: BYAPR15MB2247:
x-microsoft-antispam-prvs: <BYAPR15MB224736178533FB1A4720BDA4D7000@BYAPR15MB2247.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(136003)(376002)(366004)(199004)(189003)(64756008)(66946007)(66556008)(66476007)(73956011)(2906002)(6246003)(53936002)(5660300002)(14444005)(256004)(66446008)(4326008)(6436002)(476003)(71200400001)(71190400001)(25786009)(6512007)(486006)(2616005)(186003)(478600001)(6116002)(102836004)(36756003)(76176011)(7736002)(6486002)(46003)(54906003)(6636002)(11346002)(31686004)(229853002)(110136005)(52116002)(446003)(386003)(6506007)(99286004)(53546011)(14454004)(316002)(86362001)(81166006)(68736007)(31696002)(81156014)(305945005)(8676002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2247;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J+KzOrXKneXZmyu+m0nOJ1Fx8KtpUixOSNRZPF5QiFwjTpE9IhFyi6/mIVHKF8SGc+V0r80iczqMyWsYtPaX+FNpiocd03iJWoxByPEBQjbzbthR/pPeKFbNZXAEguVTWSksj6D5r057j3MEiFcn9fIFBouzU33SVX8vU8tybhKONGnRJCcmP7Tj06Pj1yP8aIQW5aG5RxtUNiatMcNEAjJiGaPaDmjIMKulVppRWS6QCcaHnW4sr6ObKXH0WWF1YISgOjP6wBhdDujFOgfgFKC/YrXdSYn15KNictFkbWm5gOrGeUniyAxzK5WxmSTKXl3/t4VHwVNzMQx86K2+FMmv3/sezRqThUU71q1m0jhkN2pUI92WwxxkS49Wjsv7CFezZmzTz9RfA68jqxuuENlW75iZkdWqDY0R6i7D93k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF328A32B8BBFC47AE51D5D74041047D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 856cab79-e521-4f35-72b9-08d6ded49280
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 16:43:09.5216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2247
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yMi8xOSA5OjM4IEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA1LzIx
LCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gVGhpcyBwYXRjaCB0cmllcyB0byBzb2x2ZSB0aGUg
Zm9sbG93aW5nIHNwZWNpZmljIHVzZSBjYXNlLg0KPj4NCj4+IEN1cnJlbnRseSwgYnBmIHByb2dy
YW0gY2FuIGFscmVhZHkgY29sbGVjdCBzdGFjayB0cmFjZXMNCj4+IHRocm91Z2gga2VybmVsIGZ1
bmN0aW9uIGdldF9wZXJmX2NhbGxjaGFpbigpDQo+PiB3aGVuIGNlcnRhaW4gZXZlbnRzIGhhcHBl
bnMgKGUuZy4sIGNhY2hlIG1pc3MgY291bnRlciBvcg0KPj4gY3B1IGNsb2NrIGNvdW50ZXIgb3Zl
cmZsb3dzKS4gQnV0IHN1Y2ggc3RhY2sgdHJhY2VzIGFyZQ0KPj4gbm90IGVub3VnaCBmb3Igaml0
dGVkIHByb2dyYW1zLCBlLmcuLCBoaHZtIChqaXRlZCBwaHApLg0KPj4gVG8gZ2V0IHJlYWwgc3Rh
Y2sgdHJhY2UsIGppdCBlbmdpbmUgaW50ZXJuYWwgZGF0YSBzdHJ1Y3R1cmVzDQo+PiBuZWVkIHRv
IGJlIHRyYXZlcnNlZCBpbiBvcmRlciB0byBnZXQgdGhlIHJlYWwgdXNlciBmdW5jdGlvbnMuDQo+
Pg0KPj4gYnBmIHByb2dyYW0gaXRzZWxmIG1heSBub3QgYmUgdGhlIGJlc3QgcGxhY2UgdG8gdHJh
dmVyc2UNCj4+IHRoZSBqaXQgZW5naW5lIGFzIHRoZSB0cmF2ZXJzaW5nIGxvZ2ljIGNvdWxkIGJl
IGNvbXBsZXggYW5kDQo+PiBpdCBpcyBub3QgYSBzdGFibGUgaW50ZXJmYWNlIGVpdGhlci4NCj4+
DQo+PiBJbnN0ZWFkLCBoaHZtIGltcGxlbWVudHMgYSBzaWduYWwgaGFuZGxlciwNCj4+IGUuZy4g
Zm9yIFNJR0FMQVJNLCBhbmQgYSBzZXQgb2YgcHJvZ3JhbSBsb2NhdGlvbnMgd2hpY2gNCj4+IGl0
IGNhbiBkdW1wIHN0YWNrIHRyYWNlcy4gV2hlbiBpdCByZWNlaXZlcyBhIHNpZ25hbCwgaXQgd2ls
bA0KPj4gZHVtcCB0aGUgc3RhY2sgaW4gbmV4dCBzdWNoIHByb2dyYW0gbG9jYXRpb24uDQo+Pg0K
PiANCj4gWy4uXQ0KPj4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzIGJwZl9zZW5kX3NpZ25hbCgpIGhl
bHBlciB0byBzZW5kDQo+PiBhIHNpZ25hbCB0byBoaHZtIGluIHJlYWwgdGltZSwgcmVzdWx0aW5n
IGluIGludGVuZGVkIHN0YWNrIHRyYWNlcy4NCj4gU2VyaWVzIGxvb2tzIGdvb2QuIE9uZSBtaW5v
ciBuaXQvcXVlc3Rpb246IG1heWJlIHJlbmFtZSBicGZfc2VuZF9zaWduYWwNCj4gdG8gc29tZXRo
aW5nIGxpa2UgYnBmX3NlbmRfc2lnbmFsX3RvX2N1cnJlbnQvYnBmX2N1cnJlbnRfc2VuZF9zaWdu
YWwvZXRjPw0KPiBicGZfc2VuZF9zaWduYWwgaXMgdG9vIGdlbmVyaWMgbm93IHRoYXQgeW91IHNl
bmQgdGhlIHNpZ25hbA0KPiB0byB0aGUgY3VycmVudCBwcm9jZXNzLi4NCg0KYnBmX3NlbmRfc2ln
bmFsX3RvX2N1cnJlbnQgd2FzIFlvbmdob25nJ3Mgb3JpZ2luYWwgbmFtZQ0KYW5kIEkgYXNrZWQg
aGltIHRvIHJlbmFtZSBpdCB0byBicGZfc2VuZF9zaWduYWwgOikNCkkgZG9uJ3Qgc2VlIGJwZiBz
ZW5kaW5nIHNpZ25hbHMgdG8gYXJiaXRyYXJ5IHByb2Nlc3Nlcw0KaW4gdGhlIG5lYXIgZnV0dXJl
Lg0K
