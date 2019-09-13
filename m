Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB45B26DA
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbfIMUtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:49:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbfIMUtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:49:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DKU7XV003527;
        Fri, 13 Sep 2019 13:48:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/kgJQVJI5PltMBtkBUqXemU0A8i8JbMOYOgcTCCnyGY=;
 b=T0fdnbby2G/4x9wHEQ9vVC25UPWVQ4f7+vbhbu1YszDhNZDE/z4HS70OVU8LX4fAsIHo
 kWVan2FeRtpZM852sDC39cWViJECHehF0vc+yvtLxHiXI6LYJzdcOqNQubQjvE2CGWdH
 UyUkrWxZ43nSgcysZASMhZ8gU3juhWGgXsQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytd25vqn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 13:48:39 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 13:48:38 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 13:48:38 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 13:48:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5lfoQdu3rZBPQVwLLtkXrSn80GVVypYWq6/YBeIWnfGydsPrMwugQD0UR9B+sLDFg31nmhyN3LcnILhmQ9/q0ZiDxHgqwk34V9HvsP9ahtRQ8FwRnlMD4yJQXwSyq4QAginHykHr36KQ7rr6wHPSX3V2mWf0xjEq5jDTa8RZzTmBurmrezbPAB2DlzZOiS+gMO9SGu2Kx2kfWB1O4Vr97eYqvlQE2Cb9Vzgzu01vfcxEGuUZnliUSRs1RePbiceB5GVKRLdHIWS+oU2sNnWyGKIwunyoWIYS4LIZhzenkSBw9HT9KIHGQ7aGvlmX7KLOqGUXOtyNqM8fD9K2PN7/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kgJQVJI5PltMBtkBUqXemU0A8i8JbMOYOgcTCCnyGY=;
 b=LBsDKXWl0xYR0UI6F8gdZD1boboeXtzJn3IgePhnBMxYm5zxAFIKwoewQsWME5LEteuON4AbO83ZoE+6TdOQ1Lgsulzg/UHyWhULeApbdzLgff9owYTULr0J95NakNC6iwN4+Eqn4BrsKUUhMbhZvFabhiO4kHEk6Q+0Vc9VFZ2n3oLAbdgLcfCfAtdD133xPmCy7HmRGt1mayUicrjDpsZoM64DvZl59lXGXaRvTuc4bA1hZ9EHLINGcIP4V4LWoR6Y79PHKi56fcu8Z3SllBKvYz2lAQEMoXSaMoe3rlO4p6dD/qnyKaOURd24schd/3o7+IESduxTJNXHeI4DSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kgJQVJI5PltMBtkBUqXemU0A8i8JbMOYOgcTCCnyGY=;
 b=Nm90uHAaAHEFxlBrkGKVwaUK9QkqYqB6/I3X2T6uckaGej9uTOx5aEPYDzbkXYtMnsViL7S4CymlYKmqDgokJ3iH8gypLmN9uREJxkkvP8dU1KxtrMk2Z0yVw29UkmKIPJKTF1vIkpDbRKHLwT/UpqEETG2cbSV2PAnUpQ1nYaE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2485.namprd15.prod.outlook.com (52.135.194.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 13 Sep 2019 20:48:37 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 20:48:37 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 02/11] samples: bpf: makefile: fix
 cookie_uid_helper_example obj build
Thread-Topic: [PATCH bpf-next 02/11] samples: bpf: makefile: fix
 cookie_uid_helper_example obj build
Thread-Index: AQHVZ8P30GXRyJqQ+EOjvLACiMYPsqcqGa8A
Date:   Fri, 13 Sep 2019 20:48:37 +0000
Message-ID: <7f556c1c-abee-41a9-af83-1d72fc33af4b@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-3-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-3-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0077.namprd19.prod.outlook.com
 (2603:10b6:320:1f::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 251b9a0f-e14b-4cd9-7217-08d7388bc033
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2485;
x-ms-traffictypediagnostic: BYAPR15MB2485:
x-microsoft-antispam-prvs: <BYAPR15MB2485CA067C77DF96AA7636A2D3B30@BYAPR15MB2485.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(39860400002)(346002)(136003)(199004)(189003)(5660300002)(76176011)(46003)(53936002)(14454004)(6486002)(64756008)(71190400001)(2616005)(102836004)(7736002)(11346002)(8936002)(486006)(31696002)(386003)(6506007)(71200400001)(66446008)(6116002)(305945005)(8676002)(476003)(2501003)(53546011)(81156014)(81166006)(478600001)(86362001)(2201001)(14444005)(229853002)(25786009)(6436002)(66476007)(4326008)(66946007)(54906003)(66556008)(31686004)(2906002)(99286004)(6246003)(256004)(7416002)(316002)(52116002)(186003)(6512007)(110136005)(446003)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2485;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T9s7WpA8OJMHAYB8Xmhz04I7LTqYZkvgQD5i1j+9kkB71W0XDxu4onlrymCTLrqmWVAveM3hrkX18W47f9ElN8DcaK20mCTT8v0vMPQUnRGk7HisACX4CfI35uauM/bvxhbL9hksWQsdeYbqVTDgtpX52c3YzW9T1ZaYL8yQV6qG8502UMG1CWXnRNpKrO9KLc94uz5psVzkelhbisbo+QA3R2BeVx+OJtYpz4a5zfVJ1Qsblrx/kjdUTomIKTVUNGjFnpiHWQ8iHBYWpnh1GcJT5GgJUF0ffA2rWxlWrMQup3ElFSQQSzHmMpr7V/ps6lmlwzxgSQ6O0BjbLqP1JyNL2lPBzcN0GXCWtMkp6Rj1wipX3kuRJ6CCHYnn5BL4UCLKPEb7yFgLholTd/iV1mLImH67yAZmmamHSWqvb4g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2A4130F60035049999CBF7F2AFF1905@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 251b9a0f-e14b-4cd9-7217-08d7388bc033
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 20:48:37.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UppxYaG37wl58/lP7PpEgAJN9O1J+Zgfv+UJYz5cObni5YGgt/offyBKRgNUmZdn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2485
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gRG9uJ3Qg
bGlzdCB1c2Vyc3BhY2UgImNvb2tpZV91aWRfaGVscGVyX2V4YW1wbGUiIG9iamVjdCBpbiBsaXN0
IGZvcg0KPiBicGYgb2JqZWN0cy4NCj4gDQo+IHBlcl9zb2NrZXRfc3RhdHNfZXhhbXBsZS1vcGpz
IGlzIHVzZWQgdG8gbGlzdCBhZGRpdGlvbmFsIGRlcGVuZGVuY2llcw0KDQpzL29wanMvb2Jqcw0K
DQo+IGZvciB1c2VyIHNwYWNlIGJpbmFyeSBmcm9tIGhvc3Rwcm9ncy15IGxpc3QuIEtidWlsZCBz
eXN0ZW0gY3JlYXRlcw0KPiBydWxlcyBmb3Igb2JqZWN0cyBsaXN0ZWQgdGhpcyB3YXkgYW55d2F5
IGFuZCBubyBuZWVkIHRvIHdvcnJ5IGFib3V0DQo+IHRoaXMuIERlc3BpdGUgb24gaXQsIHRoZSBz
YW1wbGVzIGJwZiB1c2VzIGxvZ2ljIHRoYXQgaG9zdHBvcmdzLXkgYXJlDQo+IGJ1aWxkIGZvciB1
c2Vyc3BhY2Ugd2l0aCBpbmNsdWRlcyBuZWVkZWQgZm9yIHRoaXMsIGJ1dCAiYWx3YXlzIg0KPiB0
YXJnZXQsIGlmIGl0J3Mgbm90IGluIGhvc3Rwcm9nLXkgbGlzdCwgdXNlcyBDTEFORy1icGYgcnVs
ZSBhbmQgaXMNCj4gaW50ZW5kZWQgdG8gY3JlYXRlIGJwZiBvYmogYnV0IG5vdCBhcmNoIG9iaiBh
bmQgdXNlcyBvbmx5IGtlcm5lbA0KPiBpbmNsdWRlcyBmb3IgdGhhdC4gU28gY29ycmVjdCBpdCwg
YXMgaXQgYnJlYWtzIGNyb3NzLWNvbXBpbGluZyBhdA0KPiBsZWFzdC4NCg0KVGhlIGFib3ZlIGRl
c2NyaXB0aW9uIGlzIGEgbGl0dGxlIHRyaWNreSB0byB1bmRlcnN0YW5kLg0KTWF5YmUgc29tZXRo
aW5nIGxpa2U6DQogICAgJ2Fsd2F5cycgdGFyZ2V0IGlzIGZvciBicGYgcHJvZ3JhbXMuDQogICAg
J2Nvb2tpZV91aWRfaGVscGVyX2V4YW1wbGUubycgaXMgYSB1c2VyIHNwYWNlIEVMRiBmaWxlLCBh
bmQNCiAgICBjb3ZlcmVkIGJ5IHJ1bGUgYHBlcl9zb2NrZXRfc3RhdHNfZXhhbXBsZWAuDQogICAg
TGV0IHVzIHJlbW92ZSBgYWx3YXlzICs9IGNvb2tpZV91aWRfaGVscGVyX2V4YW1wbGUub2AsDQog
ICAgd2hpY2ggYXZvaWRzIGJyZWFraW5nIGNyb3NzIGNvbXBpbGF0aW9uIGR1ZSB0bw0KICAgIG1p
c21hdGNoZWQgaW5jbHVkZXMuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEl2YW4gS2hvcm9uemh1
ayA8aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIHNhbXBsZXMvYnBmL01h
a2VmaWxlIHwgMSAtDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9zYW1wbGVzL2JwZi9NYWtlZmlsZSBiL3NhbXBsZXMvYnBmL01ha2VmaWxlDQo+
IGluZGV4IGY1MGNhODUyYzJhOC4uNDNkZWU5MGRmZmE0IDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVz
L2JwZi9NYWtlZmlsZQ0KPiArKysgYi9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiBAQCAtMTQ1LDcg
KzE0NSw2IEBAIGFsd2F5cyArPSBzYW1wbGVpcF9rZXJuLm8NCj4gICBhbHdheXMgKz0gbHd0X2xl
bl9oaXN0X2tlcm4ubw0KPiAgIGFsd2F5cyArPSB4ZHBfdHhfaXB0dW5uZWxfa2Vybi5vDQo+ICAg
YWx3YXlzICs9IHRlc3RfbWFwX2luX21hcF9rZXJuLm8NCj4gLWFsd2F5cyArPSBjb29raWVfdWlk
X2hlbHBlcl9leGFtcGxlLm8NCj4gICBhbHdheXMgKz0gdGNwX3N5bnJ0b19rZXJuLm8NCj4gICBh
bHdheXMgKz0gdGNwX3J3bmRfa2Vybi5vDQo+ICAgYWx3YXlzICs9IHRjcF9idWZzX2tlcm4ubw0K
PiANCg==
