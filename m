Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E8121C49
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfLPWGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:06:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfLPWGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:06:09 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGLrvfC017599;
        Mon, 16 Dec 2019 14:05:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W3CHp8b87hWgEwhw7RRvCpcuVUKL+LaijwH/GydwDj0=;
 b=IhtEGGwbTZP2oBZA9TI95SYEsQtRP8s6UydYSG3tW8j/tA+brRB6GI5gIeOgTXu/FBHj
 1e74MZZVFG90ixzdc4V5hgW4x9xODGr5pkMR5qJzMvgGsNqJ7qx0wJzmvJMNGvZV+y9U
 nz4aqgWvubALMtUOwbqb71Px+mRaIeqVfEE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgaypehm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 14:05:50 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 14:05:50 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 14:05:49 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 14:05:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzU3yjZu1O3DuwnLeSsRtlIORxizE6u9NQldQP+ToNgzapjDMdNk+uEFOWo7UrOdCnx1RfbuyC0Yq535Jz2zT/XuWZGZBvnkZR7i1LvVYVHtR2lwnGDtC9vodYsDef/8jha1r1heMWHqUOhjc+uqxFWzrduv8ZmQMlhl9e6vf2LNOZ8mbjPaLeU3J41ZZdsMbVupWOABsYHNp8wvWZwZe+KT22dfRaz2TI6gb8W1EnjuIK3fp646/k9mX5aGRvRfDFL3b1Q8KTJrKKGytKFInrzK0vR3SQw1UvJA41kQ71X4etVKZFm70ASESomqPcTHGBEWERt1SjTKLweTHZtSeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3CHp8b87hWgEwhw7RRvCpcuVUKL+LaijwH/GydwDj0=;
 b=L7EaWCfcDjNTa0s95I84lreIqYz2jywhFuBxzBFv9lmLTcBgVATFbcfddaQmarkijgkftmsAqQOghMU9xZn9WzcapFeebMPidQ9zXmafSQ8zL6x5LPDZ2sMRM3Ey7D7MqrSbHsywl4kG6S7OikKGjlEZdHhJ1M1g4lKmhHCr/MSUEG1QTvZ0WKYjNqcbcGt8txMfc39snvicjBCp3hgp5I5dpVgn24Ho22w6WyYQwGySintkJ1DLtvb8Cr+LhIF2Rk0/b/O9tthvUd+Kxyd1nrn9JhU2uRzg2TfZ8US3TOhZtXsQ0y9iPDFvKYRfsTBrH5RsIQsyA8En/ftpgzWPwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3CHp8b87hWgEwhw7RRvCpcuVUKL+LaijwH/GydwDj0=;
 b=Lh68ijFwlnWXm0137sgBFk7BK8EyJg18W/giyCCjhc956Euo51jTFvqYa7wjNlgHcBobT/oOK9SimOwEqkgUzErcA6BAw2dPaMCOHFTyyPh4HFpd/TU8YoJTi8KkLzRpViKBayToRYGO9/ixwgX+VUlEv/LYI9sKBI+ZQBJYBV8=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1515.namprd15.prod.outlook.com (10.173.223.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 22:05:47 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 22:05:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 04/13] bpf: Support bitfield read access in
 btf_struct_access
Thread-Topic: [PATCH bpf-next 04/13] bpf: Support bitfield read access in
 btf_struct_access
Thread-Index: AQHVshgnH/V/c8qloEeD+GQGX+M1EKe9VbwA
Date:   Mon, 16 Dec 2019 22:05:47 +0000
Message-ID: <906ffb48-1122-e63f-b8fc-e619e7be3310@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004746.1652586-1-kafai@fb.com>
In-Reply-To: <20191214004746.1652586-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:104:5::15) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 628b1717-a16d-46a2-1c56-08d782741a8b
x-ms-traffictypediagnostic: DM5PR15MB1515:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1515630B26A4F7A533456E78D3510@DM5PR15MB1515.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(31686004)(31696002)(110136005)(498600001)(6512007)(53546011)(6506007)(36756003)(81166006)(81156014)(54906003)(8676002)(66556008)(6486002)(64756008)(5660300002)(86362001)(52116002)(2906002)(8936002)(186003)(66446008)(66476007)(71200400001)(66946007)(2616005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1515;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4htIccMl93X5xUbBoc7V6yyIIzBSX9+ZGu9UaHkzIONDtUC++riXgkE3AAUCUzBmJIvrvJQjIAc9o7C88LHjJM0jC07E/mWFy6mhlewF3b1UujmQqHSxQkB9vrSwOUh25vGwTQkTWRvS66aZcxWsZvsFv8nSJiUI1tn3gA/tyVN4l+WvblduMgTDBHCPwnP9GVsKAVYsPZG3CBlMTyQZ9xS3YthBwped8gCh3dYfuDGpA2yxXCoS8nh97I85/6QqRjfGWWjE/tTzbNH6sfJBE7OBjVT1/xTrJEMyW+dpNRO2qsTv1IMXT2u9qbIQ2IxuxN9jft5cto4EsJ9qDHB6CyOKpsX6UYVHh7Isv7P7y6p4gkNtAwCroAtEQvyTzbk4Xbhp9YXlE3wOYh3aXh0PP2jWdFTC5+b/YxntR7r5cEHhDpXHdLv2VkEQ4BXZAksi
Content-Type: text/plain; charset="utf-8"
Content-ID: <D641AF5C5107544B8C5B41260C810CCF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 628b1717-a16d-46a2-1c56-08d782741a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 22:05:47.1904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6WQwUhlALfcgolwouglc3uvY0O7zCaAfyGX1nN4mlyJHQP1A8YX6G1EW/LMx7fK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1515
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEzLzE5IDQ6NDcgUE0sIE1hcnRpbiBLYUZhaSBMYXUgd3JvdGU6DQo+IFRoaXMg
cGF0Y2ggYWxsb3dzIGJpdGZpZWxkIGFjY2VzcyBhcyBhIHNjYWxhci4gIEl0IGN1cnJlbnRseSBs
aW1pdHMNCj4gdGhlIGFjY2VzcyB0byBzaXplb2YodTY0KSBhbmQgdXB0byB0aGUgZW5kIG9mIHRo
ZSBzdHJ1Y3QuICBJdCBpcyBuZWVkZWQNCj4gaW4gYSBsYXRlciBicGYtdGNwLWNjIGV4YW1wbGUg
dGhhdCByZWFkcyBiaXRmaWVsZCBmcm9tDQo+IGluZXRfY29ubmVjdGlvbl9zb2NrIGFuZCB0Y3Bf
c29jay4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNv
bT4NCj4gLS0tDQo+ICAga2VybmVsL2JwZi9idGYuYyB8IDEzICsrKysrKysrKy0tLS0NCj4gICAx
IGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2tlcm5lbC9icGYvYnRmLmMgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+IGluZGV4IDZl
NjUyNjQzODQ5Yi4uMDExMTk0ODMxNDk5IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2J0Zi5j
DQo+ICsrKyBiL2tlcm5lbC9icGYvYnRmLmMNCj4gQEAgLTM3NDQsMTAgKzM3NDQsNiBAQCBpbnQg
YnRmX3N0cnVjdF9hY2Nlc3Moc3RydWN0IGJwZl92ZXJpZmllcl9sb2cgKmxvZywNCj4gICAJfQ0K
PiAgIA0KPiAgIAlmb3JfZWFjaF9tZW1iZXIoaSwgdCwgbWVtYmVyKSB7DQo+IC0JCWlmIChidGZf
bWVtYmVyX2JpdGZpZWxkX3NpemUodCwgbWVtYmVyKSkNCj4gLQkJCS8qIGJpdGZpZWxkcyBhcmUg
bm90IHN1cHBvcnRlZCB5ZXQgKi8NCj4gLQkJCWNvbnRpbnVlOw0KPiAtDQo+ICAgCQkvKiBvZmZz
ZXQgb2YgdGhlIGZpZWxkIGluIGJ5dGVzICovDQo+ICAgCQltb2ZmID0gYnRmX21lbWJlcl9iaXRf
b2Zmc2V0KHQsIG1lbWJlcikgLyA4Ow0KPiAgIAkJaWYgKG9mZiArIHNpemUgPD0gbW9mZikNCj4g
QEAgLTM3NTcsNiArMzc1MywxNSBAQCBpbnQgYnRmX3N0cnVjdF9hY2Nlc3Moc3RydWN0IGJwZl92
ZXJpZmllcl9sb2cgKmxvZywNCj4gICAJCWlmIChvZmYgPCBtb2ZmKQ0KPiAgIAkJCWNvbnRpbnVl
Ow0KPiAgIA0KPiArCQlpZiAoYnRmX21lbWJlcl9iaXRmaWVsZF9zaXplKHQsIG1lbWJlcikpIHsN
Cj4gKwkJCWlmIChvZmYgPT0gbW9mZiAmJg0KPiArCQkJICAgICEoYnRmX21lbWJlcl9iaXRfb2Zm
c2V0KHQsIG1lbWJlcikgJSA4KSAmJg0KDQpUaGlzIGNoZWNrICchKGJ0Zl9tZW1iZXJfYml0X29m
ZnNldCh0LCBtZW1iZXIpICUgOCknIGlzIG5vdCBuZWVkZWQuDQoNCj4gKwkJCSAgICBzaXplIDw9
IHNpemVvZih1NjQpICYmDQoNClRoaXMgb25lIGlzIG5vdCBuZWVkZWQgc2luY2UgdmVyaWZpZXIg
Z2V0cyAnc2l6ZScgZnJvbSBsb2FkL3N0b3JlIA0KaW5zdHJ1Y3Rpb25zIHdoaWNoIGlzIGd1YXJh
bnRlZWQgdG8gYmUgPD0gc2l6ZW9mKHU2NCkuDQoNCj4gKwkJCSAgICBvZmYgKyBzaXplIDw9IHQt
PnNpemUpDQo+ICsJCQkJcmV0dXJuIFNDQUxBUl9WQUxVRTsNCj4gKwkJCWNvbnRpbnVlOw0KPiAr
CQl9DQo+ICsNCj4gICAJCS8qIHR5cGUgb2YgdGhlIGZpZWxkICovDQo+ICAgCQltdHlwZSA9IGJ0
Zl90eXBlX2J5X2lkKGJ0Zl92bWxpbnV4LCBtZW1iZXItPnR5cGUpOw0KPiAgIAkJbW5hbWUgPSBf
X2J0Zl9uYW1lX2J5X29mZnNldChidGZfdm1saW51eCwgbWVtYmVyLT5uYW1lX29mZik7DQo+IA0K
