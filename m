Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB01416F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfEER2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:28:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbfEER2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:28:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x45HMlbE001103;
        Sun, 5 May 2019 10:27:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oW1AQ64HhO72HLxYqEhEQdIc3H9XwsnDjacyB4NC1dM=;
 b=Tz7WMSgRZu9cD6g4j8TMmM6Q9SNAXtBVV8kWoM7ImHiBLINMOMggqDw5S+nJoAHwLmrw
 +bvsMkrlThxIB+zvlygkAj0/WuZ5ySPgZ8Nc38jJjcdV7EBjlio+66PIY+eWjdcm/HcY
 N6IGsyK1YWuWpdHHjfxcscL/lztozw/tXmo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s9a1j2qex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 05 May 2019 10:27:47 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 5 May 2019 10:27:45 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 5 May 2019 10:27:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW1AQ64HhO72HLxYqEhEQdIc3H9XwsnDjacyB4NC1dM=;
 b=LXNUG7bb+XzJfuwUXdJCE95a/Tu6WmIvsLQQFPoAqWtmqV5bvL68N5xh7Qvxp+aKYgYoMIQ52zcbtWKP/3wZxBjd65jOMKsKki5PwSTyPryqbmBvqDkLvl9BlaHTW8xDyQOq06uu0Ga37TCcovpRxiHfvogBr8VrVjR20a7HPcI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3175.namprd15.prod.outlook.com (20.179.56.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Sun, 5 May 2019 17:27:25 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 17:27:25 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal()
 helper
Thread-Topic: [RFC PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal()
 helper
Thread-Index: AQHVAURQC8DMPz/7EEC5srmARMc2V6ZcJgUAgACnCAA=
Date:   Sun, 5 May 2019 17:27:24 +0000
Message-ID: <6ce705c0-135a-bbd0-7bb5-551c468f0198@fb.com>
References: <20190503000806.1340927-1-yhs@fb.com>
 <20190503000806.1340997-1-yhs@fb.com>
 <CAADnVQLJvK5Pr_-RAizrSSKBp80+RJQ3TDeyfTWU6wX2W6gxZg@mail.gmail.com>
In-Reply-To: <CAADnVQLJvK5Pr_-RAizrSSKBp80+RJQ3TDeyfTWU6wX2W6gxZg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:300:69::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e091]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45b1a142-e38f-46a8-2c83-08d6d17ef04a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3175;
x-ms-traffictypediagnostic: BYAPR15MB3175:
x-microsoft-antispam-prvs: <BYAPR15MB3175A2A230D55A294A8BB095D3370@BYAPR15MB3175.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(136003)(396003)(376002)(346002)(189003)(199004)(36756003)(99286004)(71190400001)(76176011)(256004)(52116002)(14444005)(53546011)(66446008)(73956011)(66556008)(53936002)(64756008)(8676002)(81156014)(81166006)(66476007)(66946007)(5660300002)(31686004)(6246003)(7736002)(305945005)(8936002)(102836004)(6436002)(14454004)(186003)(4326008)(6116002)(229853002)(6486002)(6506007)(386003)(6916009)(316002)(2616005)(478600001)(476003)(486006)(71200400001)(54906003)(2906002)(6512007)(11346002)(25786009)(446003)(46003)(86362001)(31696002)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3175;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JTFoOcyECRYN3+8Xe0myAk2dVfW8bWP9coPnSnDx12Xh+TdecoZ9777gnPlhgzeOkO8guREfGNalKeDRF4vl55R593WV0SkjJvburwu72CrpLU/4Jo+tMaPXp9LTk2Se+2Lsa+I9OaP7b7osEj2TnVkcLpODlAskrKQAJaMwolzWCR3+WqayCq6N9JDz2sBJDjuD4K0RAzMUTGaWnGCR7C+yn6elp0vEeC1A5FjfsYcOn3PHyWZ5YFPENVmUv82xqCkS3JcAAzRxvfbwM0h1H20Km4FBgcH0J29wlh1aCjZcFEZse6IDYpxTkowoc/nexTMWvyzrr+cCyQMDdU/X+Q8jo/pK6RXQx6tLFwjjVB2S9+fWEun0LgDAre3LPAIdrqxghV3EN3aLXfWfw/KpL4b7KHdNJVLE3TzueWD2m4s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F62079EAC5275A44B48A524230D9A697@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b1a142-e38f-46a8-2c83-08d6d17ef04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 17:27:25.0043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3175
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-05_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905050155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNS8xOSAxMjoyOSBBTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiBU
aHUsIE1heSAyLCAyMDE5IGF0IDU6MDggUE0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gVGhpcyBwYXRjaCB0cmllcyB0byBzb2x2ZSB0aGUgZm9sbG93aW5nIHNwZWNp
ZmljIHVzZSBjYXNlLg0KPj4NCj4+IEN1cnJlbnRseSwgYnBmIHByb2dyYW0gY2FuIGFscmVhZHkg
Y29sbGVjdCBzdGFjayB0cmFjZXMNCj4+IHdoZW4gY2VydGFpbiBldmVudHMgaGFwcGVucyAoZS5n
LiwgY2FjaGUgbWlzcyBjb3VudGVyIG9yDQo+PiBjcHUgY2xvY2sgY291bnRlciBvdmVyZmxvd3Mp
LiBUaGVzZSBzdGFjayB0cmFjZXMgY2FuIGJlDQo+PiB1c2VkIGZvciBwZXJmb3JtYW5jZSBhbmFs
eXNpcy4gRm9yIGppdHRlZCBwcm9ncmFtcywgZS5nLiwNCj4+IGhodm0gKGppdGVkIHBocCksIGl0
IGlzIHZlcnkgaGFyZCB0byBnZXQgdGhlIHRydWUgc3RhY2sNCj4+IHRyYWNlIGluIHRoZSBicGYg
cHJvZ3JhbSBkdWUgdG8gaml0IGNvbXBsZXhpdHkuDQo+Pg0KPj4gVG8gcmVzb2x2ZSB0aGlzIGlz
c3VlLCBoaHZtIGltcGxlbWVudHMgYSBzaWduYWwgaGFuZGxlciwNCj4+IGUuZy4gZm9yIFNJR0FM
QVJNLCBhbmQgYSBzZXQgb2YgcHJvZ3JhbSBsb2NhdGlvbnMgd2hpY2gNCj4+IGl0IGNhbiBkdW1w
IHN0YWNrIHRyYWNlcy4gV2hlbiBpdCByZWNlaXZlcyBhIHNpZ25hbCwgaXQgd2lsbA0KPj4gZHVt
cCB0aGUgc3RhY2sgaW4gbmV4dCBzdWNoIHByb2dyYW0gbG9jYXRpb24uDQo+Pg0KPj4gVGhlIGZv
bGxvd2luZyBpcyB0aGUgY3VycmVudCB3YXkgdG8gaGFuZGxlIHRoaXMgdXNlIGNhc2U6DQo+PiAg
ICAuIHByb2ZpbGVyIGluc3RhbGxzIGEgYnBmIHByb2dyYW0gYW5kIHBvbGxzIG9uIGEgbWFwLg0K
Pj4gICAgICBXaGVuIGNlcnRhaW4gZXZlbnQgaGFwcGVucywgYnBmIHByb2dyYW0gd3JpdGVzIHRv
IGEgbWFwLg0KPj4gICAgLiBPbmNlIHJlY2VpdmluZyB0aGUgaW5mb3JtYXRpb24gZnJvbSB0aGUg
bWFwLCB0aGUgcHJvZmlsZXINCj4+ICAgICAgc2VuZHMgYSBzaWduYWwgdG8gaGh2bS4NCj4+IFRo
aXMgbWV0aG9kIGNvdWxkIGhhdmUgbGFyZ2UgZGVsYXlzIGFuZCBjYXVzaW5nIHByb2ZpbGluZw0K
Pj4gcmVzdWx0cyBza2V3ZWQuDQo+Pg0KPj4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzIGJwZl9zZW5k
X3NpZ25hbCgpIGhlbHBlciB0byBzZW5kIGEgc2lnbmFsIHRvDQo+PiBoaHZtIGluIHJlYWwgdGlt
ZSwgcmVzdWx0aW5nIGluIGludGVuZGVkIHN0YWNrIHRyYWNlcy4NCj4+DQo+PiBSZXBvcnRlZC1i
eToga2J1aWxkIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+IA0KPiB2MiBhZGRyZXNzaW5n
IGJ1aWxkYm90IGlzc3VlIGRvZXNuJ3QgbmVlZCB0byBoYXZlIHN1Y2ggdGFnLg0KDQpJIHdpbGwg
ZHJvcCB0aGlzIGluIHRoZSBuZXh0IHJldmlzaW9uLiBUaGUgaW50ZW50aW9uIGlzLCBhcyBzdWdn
ZXN0ZWQNCmJ5IGJ1aWxkYm90IGVtYWlsLCBpcyB0byBnaXZlIGNyZWRpdCB0byBidWlsZGJvdCBh
bmQgbGV0IGl0IGtub3cgdGhlIGJ1ZyANCmlzIHRha2VuIGNhcmUgb2YuDQoNCj4gDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4gLS0tDQo+PiAgIGluY2x1
ZGUvdWFwaS9saW51eC9icGYuaCB8IDE1ICsrKysrKy0NCj4+ICAga2VybmVsL3RyYWNlL2JwZl90
cmFjZS5jIHwgODUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4g
ICAyIGZpbGVzIGNoYW5nZWQsIDk5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+
PiB2MSAtPiB2MjoNCj4+ICAgZml4ZWQgYSBjb21waWxhdGlvbiB3YXJuaW5nIChtaXNzaW5nIHJl
dHVybiB2YWx1ZSBpbiBjYXNlKQ0KPj4gICByZXBvcnRlZCBieSBrYnVpbGQgdGVzdCByb2JvdC4N
Cj4+ICAgYWRkZWQgUmVwb3J0ZWQtYnkgaW4gdGhlIGFib3ZlIHRvIG5vdGlmeSB0aGUgYm90Lg0K
Pj4NCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3Vh
cGkvbGludXgvYnBmLmgNCj4+IGluZGV4IDcyMzM2YmFjNzU3My4uZTNlODI0ODQ4MzM1IDEwMDY0
NA0KPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+PiArKysgYi9pbmNsdWRlL3Vh
cGkvbGludXgvYnBmLmgNCj4+IEBAIC0yNjY3LDYgKzI2NjcsMTggQEAgdW5pb24gYnBmX2F0dHIg
ew0KPj4gICAgKiAgICAgICAgICAgICAwIG9uIHN1Y2Nlc3MuDQo+PiAgICAqDQo+PiAgICAqICAg
ICAgICAgICAgICoqLUVOT0VOVCoqIGlmIHRoZSBicGYtbG9jYWwtc3RvcmFnZSBjYW5ub3QgYmUg
Zm91bmQuDQo+PiArICoNCj4+ICsgKiBpbnQgYnBmX3NlbmRfc2lnbmFsKHUzMiBwaWQsIHUzMiBz
aWcpDQo+PiArICogICAgIERlc2NyaXB0aW9uDQo+PiArICogICAgICAgICAgICAgU2VuZCBzaWdu
YWwgKnNpZyogdG8gKnBpZCouDQo+PiArICogICAgIFJldHVybg0KPj4gKyAqICAgICAgICAgICAg
IDAgb24gc3VjY2VzcyBvciBzdWNjZXNzZnVsbHkgcXVldWVkLg0KPj4gKyAqDQo+PiArICogICAg
ICAgICAgICAgKiotRU5PRU5UKiogaWYgKnBpZCogY2Fubm90IGJlIGZvdW5kLg0KPj4gKyAqDQo+
PiArICogICAgICAgICAgICAgKiotRUJVU1kqKiBpZiB3b3JrIHF1ZXVlIHVuZGVyIG5taSBpcyBm
dWxsLg0KPj4gKyAqDQo+PiArICogICAgICAgICAgICAgT3RoZXIgbmVnYXRpdmUgdmFsdWVzIGZv
ciBhY3R1YWwgc2lnbmFsIHNlbmRpbmcgZXJyb3JzLg0KPj4gICAgKi8NCj4+ICAgI2RlZmluZSBf
X0JQRl9GVU5DX01BUFBFUihGTikgICAgICAgICAgXA0KPj4gICAgICAgICAgRk4odW5zcGVjKSwg
ICAgICAgICAgICAgICAgICAgICBcDQo+PiBAQCAtMjc3Nyw3ICsyNzg5LDggQEAgdW5pb24gYnBm
X2F0dHIgew0KPj4gICAgICAgICAgRk4oc3RydG9sKSwgICAgICAgICAgICAgICAgICAgICBcDQo+
PiAgICAgICAgICBGTihzdHJ0b3VsKSwgICAgICAgICAgICAgICAgICAgIFwNCj4+ICAgICAgICAg
IEZOKHNrX3N0b3JhZ2VfZ2V0KSwgICAgICAgICAgICAgXA0KPj4gLSAgICAgICBGTihza19zdG9y
YWdlX2RlbGV0ZSksDQo+PiArICAgICAgIEZOKHNrX3N0b3JhZ2VfZGVsZXRlKSwgICAgICAgICAg
XA0KPj4gKyAgICAgICBGTihzZW5kX3NpZ25hbCksDQo+Pg0KPj4gICAvKiBpbnRlZ2VyIHZhbHVl
IGluICdpbW0nIGZpZWxkIG9mIEJQRl9DQUxMIGluc3RydWN0aW9uIHNlbGVjdHMgd2hpY2ggaGVs
cGVyDQo+PiAgICAqIGZ1bmN0aW9uIGVCUEYgcHJvZ3JhbSBpbnRlbmRzIHRvIGNhbGwNCj4+IGRp
ZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3Ry
YWNlLmMNCj4+IGluZGV4IDg2MDdhYmExZDg4Mi4uNDlhODA0ZDU5YmZiIDEwMDY0NA0KPj4gLS0t
IGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+PiArKysgYi9rZXJuZWwvdHJhY2UvYnBmX3Ry
YWNlLmMNCj4+IEBAIC01NTksNiArNTU5LDc2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1
bmNfcHJvdG8gYnBmX3Byb2JlX3JlYWRfc3RyX3Byb3RvID0gew0KPj4gICAgICAgICAgLmFyZzNf
dHlwZSAgICAgID0gQVJHX0FOWVRISU5HLA0KPj4gICB9Ow0KPj4NCj4+ICtzdHJ1Y3Qgc2VuZF9z
aWduYWxfaXJxX3dvcmsgew0KPj4gKyAgICAgICBzdHJ1Y3QgaXJxX3dvcmsgaXJxX3dvcms7DQo+
PiArICAgICAgIHUzMiBwaWQ7DQo+PiArICAgICAgIHUzMiBzaWc7DQo+PiArfTsNCj4+ICsNCj4+
ICtzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrLCBzZW5k
X3NpZ25hbF93b3JrKTsNCj4+ICsNCj4+ICtzdGF0aWMgaW50IGRvX2JwZl9zZW5kX3NpZ25hbF9w
aWQodTMyIHBpZCwgdTMyIHNpZykNCj4+ICt7DQo+PiArICAgICAgIHN0cnVjdCB0YXNrX3N0cnVj
dCAqdGFzazsNCj4+ICsgICAgICAgc3RydWN0IHBpZCAqcGlkcDsNCj4+ICsNCj4+ICsgICAgICAg
cGlkcCA9IGZpbmRfdnBpZChwaWQpOw0KPiANCj4gaXQgdGFrZXMgcGlkbnMgZnJvbSBjdXJyZW50
IHdoaWNoIHNob3VsZCBiZSB2YWxpZA0KPiB3aGljaCBtYWtlcyBicGYgcHJvZyBkZXBlbmQgb24g
Y3VycmVudCwgYnV0IGZyb20gbm1pDQo+IHRoZXJlIGFyZSBubyBndWFyYW50ZWVzLg0KDQpUaGlz
IGlzIHJpZ2h0LiBGb3Igbm1pLCBJIGhhdmUgZm91bmQgc29tZSBmaWVsZHMgb2YgImN1cnJlbnQi
IG1heSBub3QgYmUgDQp2YWxpZC4NCg0KPiBJIHRoaW5rIGZpbmRfcGlkX25zKCkgd291bGQgYmUg
Y2xlYW5lciwgYnV0IHRoZW4gdGhlIHF1ZXN0aW9uDQo+IHdvdWxkIGJlIGhvdyB0byBwYXNzIHBp
ZG5zLi4uDQoNClRoZSAiY3VycmVudCIgaXMgbW9zdGx5IHVzZWQgdG8gZmluZCBwaWQgbmFtZXNw
YWNlIA0KYHRhc2tfYWN0aXZlX3BpZF9ucyhjdXJyZW50KWAuIFllcywgd2UgY2FuIHVzZSBmaW5k
X3BpZF9ucygpLCBidXQgd2UNCm5lZWQgdG8gZ2V0IHBpZF9uYW1lc3BhY2UgaW4gYWR2YW5jZSB0
aGVuIHBpZCwgbWF5YmUgYnkgaW50cm9kdWNpbmcNCmEgbmV3IG1hcCBvciBzb21ldGhpbmcsIG9y
IG1heSBiZSBkaXJlY3RseSB1c2luZyB0aGUgYmVsb3cgcGlkZmQNCmJhc2VkIGFwcHJvYWNoIHRv
IGhvbGQgdGhlIHJlZmVyZW5jZSBjb3VudCBpbiBhIG1hcC4NCg0KPiBBbm90aGVyIGlzc3VlIGlz
IGluc3RhYmlsaXR5IG9mIHBpZCBhcyBhbiBpbnRlZ2VyLi4uDQo+IHVwY29taW5nIHBpZGZkIGNv
dWxkIGJlIHRoZSBhbnN3ZXIuDQoNCldpbGwgdGFrZSBhIGxvb2sgYXQgdGhlIGRldGFpbHMuIFRo
YW5rcyBmb3IgcmVmZXJlbmNpbmcuDQoNCj4gQXQgdGhpcyBwb2ludCBJIHRoaW5rIGl0J3MgY2xl
YW5lciB0byBtYWtlIHN1Y2ggYXBpIHRvIHNlbmQgc2lnbmFsDQo+IHRvIGV4aXN0aW5nIHByb2Nl
c3Mgb25seSB1bmRlciB0aGUgc2FtZSBjb25kaXRpb25zIGFzIGluIGJwZl9wcm9iZV93cml0ZV91
c2VyLg0KPiBXb3VsZCB0aGF0IHdvcmsgZm9yIHlvdXIgdXNlIGNhc2U/DQoNCkxldCBtZSBkb3Vi
bGUgY2hlY2sgdGhpcy4NCg==
