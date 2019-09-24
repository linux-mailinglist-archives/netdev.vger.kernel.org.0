Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09FBD094
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbfIXR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 13:27:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40788 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729883AbfIXR1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 13:27:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8OHK2TF019779;
        Tue, 24 Sep 2019 10:26:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h8Q4F8eezugsr5weNnKhptLbffREhARy57Ig5U4cGVk=;
 b=J3oJEU/yOWH/Lq5HA7oUpwlOLzNC8zwhKLBVKmv6qmWDHBC0I9geRcx5+u4AWS6wlAgR
 oqqYqckjZ0+TfWwXd3fY6cMWDnMFzPZ2Hzy2M1ITPSOXRX/ffJ63+pVwadf70L3z1R4j
 QIdy/QzAOs3dS5ygNpd1duYvMEP7WhOJoj4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v7q74846c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 10:26:03 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 24 Sep 2019 10:26:02 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 24 Sep 2019 10:26:02 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Sep 2019 10:26:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApLe0JGOKGqKxQ+53Xm0AaYESojgdRFEQmkJYVVxvKE05E5w4G9FSwDu/qAKHLvpX3On2qA1bYDCJ8iGNrxvwEw/gURPjJH3jRoxqDeqWxRayJ8JNtWIMLxvjELiaYHb0JQwvgnKT9Kj2KLQv2NaOq7EUoAAOYKoVbqmTZuE6LQQ4owO4tGzpf9gQ81jsH6s+tJyMDN1FEJ0i9uvGsDJEubFjW/gdcnbjizC6lo3N7NSP3ctNYOY0YTNzsr/eWtUXF6yj19GN/YuSp+BpxqzUAr4gyByMUVU15EVbJVA69Ys4/R75ky1GBxH1U18Dmbc+DVik/phsPFiOximsNeogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8Q4F8eezugsr5weNnKhptLbffREhARy57Ig5U4cGVk=;
 b=Cl8iew7/gX/Hdg80K9+K33oAylSxOFMMyG4FtST/C3qqp6s439aTt14Gi5Dj+XfzsSKQ35ZQ3Uyttsfyis4r/4GM+Pz4S4IAZcc3ECLjWy3AB+6EE8/pcUlBYxOeER93VTA0lUs1ZYq51SpSQOyjGH0li6MWo4j8EbPoVlPd8/vr1HXDfjTx6DLPedRs9AEa8ypJiJyvqEdU9hjgbr8ohJN70Y3PG/w3Bl4XQ/WsjKcLmg+YvQv3gqGwYrhiUzskUEhs/XvzoSaOPWCEN6blORnqYmCGI94mBLqw3G0LQRSBJ9pkqj/QzTztDXr6vaFFCTz3gkN9qUl93zxMj2b6Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8Q4F8eezugsr5weNnKhptLbffREhARy57Ig5U4cGVk=;
 b=P5FrKCDt3BRtmjk6KUo0KOm0OQxgxzwt9hFOtrahJ5PY9I/PadpTF4DOwErw4ekDncT9cOhz3A3+127EqgFHEKNp3kTCMnVVHChYTGLsOfWpnJw8YmgeOI3rp1XZTYPALLNwXj24bpNG9qSnNPTrvLFjVmxC7XHjpIdPz0YirA4=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3524.namprd15.prod.outlook.com (52.133.252.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.26; Tue, 24 Sep 2019 17:26:01 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::bc3e:c80f:b59e:98aa]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::bc3e:c80f:b59e:98aa%6]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 17:26:01 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaNxN2w/kFAC/x0er+VWda7SKWKcv1qsAgArchwA=
Date:   Tue, 24 Sep 2019 17:26:00 +0000
Message-ID: <D8D8FCD0-4C30-4734-B2BD-4BCF2D90950B@fb.com>
References: <20190911194453.2595021-1-vijaykhemka@fb.com>
 <8C4C62C8-8835-4D33-B317-A75DD1DBB7A3@fb.com>
In-Reply-To: <8C4C62C8-8835-4D33-B317-A75DD1DBB7A3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:d29f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb39c2a-f84a-4ffb-b601-08d741144536
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR15MB3524;
x-ms-traffictypediagnostic: BY5PR15MB3524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3524A32CEA8402AF4D230D97DD840@BY5PR15MB3524.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(39860400002)(396003)(189003)(199004)(14444005)(229853002)(6506007)(478600001)(316002)(256004)(53546011)(476003)(2616005)(2906002)(71200400001)(102836004)(86362001)(7416002)(6116002)(486006)(2501003)(46003)(99286004)(14454004)(5660300002)(186003)(6436002)(71190400001)(446003)(305945005)(54906003)(6246003)(33656002)(66446008)(76176011)(6486002)(66556008)(2201001)(11346002)(64756008)(7736002)(25786009)(81166006)(66946007)(110136005)(66476007)(6512007)(8936002)(36756003)(81156014)(4326008)(8676002)(91956017)(76116006)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3524;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2b4b61OlhaN/ZIccfMqqpKVyU6dQOgd0KIMz+i1qP+RVkx2PjxORao9IbpA9oYCso/HUNEeR8kh6WZE5HKRGcRt5tDKJ5U0flgEEhcRFdKKmvDFFasaMM9pmFzulrDZk2Hkbz3L74SXW+BXoNAsOw8znyw6oWqZ05swBOLgOYIb5LuMEHNtX+O7OFpmOV/BfvHl+Mt6s3pCmdLaaOUJxOp/WwGbFm74ld8+MM8CVkNRmFYqhzoiiJWJg5FBkoqJNSg1tENQZhyqDkcpeG5a26BQOEqPFwyaL7ayNwS5Mo3zOWo58xqwHXRReaOClanjenHPAkNTGOztJgYVVVISTYE6djQjofzyinOE1ix898NHT9YBAMYWkdzYi48bw7FoIDrFD3zVwoObrUP/OfcaCvFGKmo7hcf+hzLp4V3XyNo8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F546C34149EB2C438CC2E7F3EDE9E547@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb39c2a-f84a-4ffb-b601-08d741144536
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 17:26:00.9501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ovmbaMilkLgnaE9LojwdBz3aZT65qiH6kRuUjegfAnK2vOVKy1juqU27I6MM+6hCmspmEv/LQtwA9RWdijrQWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3524
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_07:2019-09-23,2019-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909240151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rmxvcmlhbi9Kb2VsLA0KQ2FuIHlvdSBwbGVhc2UgbG9vayBpbnRvIGJlbG93IHBhdGNoIGFuZCBs
ZXQgbWUga25vdyB3aG8gY2FuIGFwcGx5IHRoaXMuDQoNClJlZ2FyZHMNCi1WaWpheQ0KDQrvu79P
biA5LzE3LzE5LCAxMjozNCBQTSwgIlZpamF5IEtoZW1rYSIgPHZpamF5a2hlbWthQGZiLmNvbT4g
d3JvdGU6DQoNCiAgICBQbGVhc2UgcmV2aWV3IGJlbG93IHBhdGNoIGFuZCBwcm92aWRlIHlvdXIg
dmFsdWFibGUgZmVlZGJhY2suDQogICAgDQogICAgUmVnYXJkcw0KICAgIC1WaWpheQ0KICAgIA0K
ICAgIE9uIDkvMTEvMTksIDE6MDUgUE0sICJWaWpheSBLaGVta2EiIDx2aWpheWtoZW1rYUBmYi5j
b20+IHdyb3RlOg0KICAgIA0KICAgICAgICBIVyBjaGVja3N1bSBnZW5lcmF0aW9uIGlzIG5vdCB3
b3JraW5nIGZvciBBU1QyNTAwLCBzcGVjaWFsbHkgd2l0aCBJUFY2DQogICAgICAgIG92ZXIgTkNT
SS4gQWxsIFRDUCBwYWNrZXRzIHdpdGggSVB2NiBnZXQgZHJvcHBlZC4gQnkgZGlzYWJsaW5nIHRo
aXMNCiAgICAgICAgaXQgd29ya3MgcGVyZmVjdGx5IGZpbmUgd2l0aCBJUFY2LiBBcyBpdCB3b3Jr
cyBmb3IgSVBWNCBzbyBlbmFibGVkDQogICAgICAgIGh3IGNoZWNrc3VtIGJhY2sgZm9yIElQVjQu
DQogICAgICAgIA0KICAgICAgICBWZXJpZmllZCB3aXRoIElQVjYgZW5hYmxlZCBhbmQgY2FuIGRv
IHNzaC4NCiAgICAgICAgDQogICAgICAgIFNpZ25lZC1vZmYtYnk6IFZpamF5IEtoZW1rYSA8dmlq
YXlraGVta2FAZmIuY29tPg0KICAgICAgICAtLS0NCiAgICAgICAgQ2hhbmdlcyBzaW5jZSB2MToN
CiAgICAgICAgIEVuYWJsZWQgSVBWNCBodyBjaGVja3N1bSBnZW5lcmF0aW9uIGFzIGl0IHdvcmtz
IGZvciBJUFY0Lg0KICAgICAgICANCiAgICAgICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFk
YXkvZnRnbWFjMTAwLmMgfCAxMyArKysrKysrKysrKystDQogICAgICAgICAxIGZpbGUgY2hhbmdl
ZCwgMTIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KICAgICAgICANCiAgICAgICAgZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgICAgIGluZGV4IDAzMGZl
ZDY1MzkzZS4uMDI1NWEyOGQyOTU4IDEwMDY0NA0KICAgICAgICAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgICAgICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICAgICAgQEAgLTE4NDIsOCArMTg0MiwxOSBA
QCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KICAgICAgICAgCS8qIEFTVDI0MDAgIGRvZXNuJ3QgaGF2ZSB3b3JraW5nIEhXIGNoZWNrc3Vt
IGdlbmVyYXRpb24gKi8NCiAgICAgICAgIAlpZiAobnAgJiYgKG9mX2RldmljZV9pc19jb21wYXRp
YmxlKG5wLCAiYXNwZWVkLGFzdDI0MDAtbWFjIikpKQ0KICAgICAgICAgCQluZXRkZXYtPmh3X2Zl
YXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07DQogICAgICAgICsNCiAgICAgICAgKwkvKiBBU1Qy
NTAwIGRvZXNuJ3QgaGF2ZSB3b3JraW5nIEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gZm9yIElQVjYN
CiAgICAgICAgKwkgKiBidXQgaXQgd29ya3MgZm9yIElQVjQsIHNvIGRpc2FibGluZyBodyBjaGVj
a3N1bSBhbmQgZW5hYmxpbmcNCiAgICAgICAgKwkgKiBpdCBmb3Igb25seSBJUFY0Lg0KICAgICAg
ICArCSAqLw0KICAgICAgICArCWlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAs
ICJhc3BlZWQsYXN0MjUwMC1tYWMiKSkpIHsNCiAgICAgICAgKwkJbmV0ZGV2LT5od19mZWF0dXJl
cyAmPSB+TkVUSUZfRl9IV19DU1VNOw0KICAgICAgICArCQluZXRkZXYtPmh3X2ZlYXR1cmVzIHw9
IE5FVElGX0ZfSVBfQ1NVTTsNCiAgICAgICAgKwl9DQogICAgICAgICsNCiAgICAgICAgIAlpZiAo
bnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHctY2hlY2tzdW0iLCBOVUxMKSkNCiAgICAg
ICAgLQkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+KE5FVElGX0ZfSFdfQ1NVTSB8IE5FVElGX0Zf
UlhDU1VNKTsNCiAgICAgICAgKwkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+KE5FVElGX0ZfSFdf
Q1NVTSB8IE5FVElGX0ZfUlhDU1VNDQogICAgICAgICsJCQkJCSB8IE5FVElGX0ZfSVBfQ1NVTSk7
DQogICAgICAgICAJbmV0ZGV2LT5mZWF0dXJlcyB8PSBuZXRkZXYtPmh3X2ZlYXR1cmVzOw0KICAg
ICAgICAgDQogICAgICAgICAJLyogcmVnaXN0ZXIgbmV0d29yayBkZXZpY2UgKi8NCiAgICAgICAg
LS0gDQogICAgICAgIDIuMTcuMQ0KICAgICAgICANCiAgICAgICAgDQogICAgDQogICAgDQoNCg==
