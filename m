Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F1B5638
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfIQTfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 15:35:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbfIQTfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 15:35:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8HJP2xK029594;
        Tue, 17 Sep 2019 12:34:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=A9Rb1spyFXeYfaCwnA7nVvgKXYCryzBGBzB0ThS665g=;
 b=lKo2WpnGp4CKA5hnaReesfNxvcJV6X+yU4mvTDjLPGk4/8SotmEfE/GhgaaV+geE93pH
 NKEzP+ye7oItDeV9FdNDw7StZIuRyGmp5sPaaDBCfk6+9yVzMHGJtMcfokzigpfx6rTh
 KfNuCsERMxMMPwa2R8A91KPRvLa8lU+pki0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v2bum6q3y-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 12:34:22 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Sep 2019 12:34:09 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Sep 2019 12:34:08 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Sep 2019 12:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsYB5fs6eEBYOUa/5J1ATH2cyHkuqv5YJTZYU6OFWdTB3E+L+RKGPSnmdOVSpH/CkQxWLecF4hXO+jf4YMc0UX4Oc4soJxD90RW2M4C2Nh8ovS0K88BtBUA0eG629RCT6gSCAosTiIZ8Ml9sk44cSZis95J3FSl23UGG6H04kQgwIaCfvKZKrDT8imiAo9Ria8EsQbXvUuS3hsrR9aL31aLadJOlI3t4YI/hRn1lMJtkcTGFThATefbveT029xZh91mbHFD4KnaL7T/gaeNm727D087+OefTas/VuCdXBTafMSw21xuCKqGYX3dRgjchmyWa9HUipTrL+N6e8MQtlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9Rb1spyFXeYfaCwnA7nVvgKXYCryzBGBzB0ThS665g=;
 b=NYf6mjXJvRF8womMSz8rXysXuIeAF7DgF3k3MJz6caDv+299nFxPaYMRXs8B3b8ars7OyBrHAdUEhqe5OveWX51DGl/EYxGPg9MaOsvnIoTm4D3HJvCs2XaLoPSgL6yXP7JV8GiJyGGr74/AOPFUEU+UXepTVtE79bZ64tsdo10Kov4IHTWfGZGKHKvOi7j83A2btIeo0uLKtArcg7KazJYE7E19ngfYlmre7keaVWxbSMio3zNFvYy890FD1hHizscz/iDI7kXW6oTuxWgpWttWbGodYoIO5mYx1O15IEpbGQbXLA+BSBOivOoLlYRrRfwVTifPH3RxU1VkL9MGEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9Rb1spyFXeYfaCwnA7nVvgKXYCryzBGBzB0ThS665g=;
 b=h7F7h2E1FV+ciSf25lyK1gX+bdP38jyN6E/Esn3X65R0LWxT4EpPlOYiNs4zujXHaikFs2YTwS+cqcASzzA5kXpNZiJnt/a25p2tVC78JmQ31iTzw2GI5Wag672p/cD0D6UpP8c7Rt+n9dlNw7OmZR99Kw+tqRrd+Zeph4jjdOc=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3553.namprd15.prod.outlook.com (10.255.245.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Tue, 17 Sep 2019 19:34:07 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::bc3e:c80f:b59e:98aa]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::bc3e:c80f:b59e:98aa%6]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 19:34:07 +0000
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
Thread-Index: AQHVaNxN2w/kFAC/x0er+VWda7SKWKcv1qsA
Date:   Tue, 17 Sep 2019 19:34:07 +0000
Message-ID: <8C4C62C8-8835-4D33-B317-A75DD1DBB7A3@fb.com>
References: <20190911194453.2595021-1-vijaykhemka@fb.com>
In-Reply-To: <20190911194453.2595021-1-vijaykhemka@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:850b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21e36bf4-f30c-4c09-7870-08d73ba601c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BY5PR15MB3553;
x-ms-traffictypediagnostic: BY5PR15MB3553:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB355396F84360EDA9AAAE8E11DD8F0@BY5PR15MB3553.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(446003)(305945005)(229853002)(8936002)(14444005)(4326008)(256004)(46003)(5660300002)(36756003)(476003)(6486002)(66556008)(64756008)(66476007)(66946007)(33656002)(66446008)(2616005)(110136005)(2201001)(76116006)(14454004)(25786009)(91956017)(498600001)(11346002)(486006)(6116002)(76176011)(81166006)(81156014)(6506007)(2501003)(102836004)(8676002)(7736002)(71190400001)(54906003)(6436002)(6246003)(86362001)(71200400001)(186003)(2906002)(99286004)(6512007)(7416002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3553;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2qjReDIztzxXteREHUA5S+xKVmDMIUJBNc5bdUPXdldC3ys9/l7keeUY65Eh4T4ukIdOheOEJY41bmHpxhnvUiwmWgjeqxmUlvkXj2g6B26/+gL5PeFGfTuRBjTJB9fr5GItTjcguSEacaKTygVg3SHKbSbPCVlfanlCHvayxoNjEAaROn9P31SCrIGtUlhXXeMVNzxNHolhyNDn7Ub+22qC1XEJoQ2DClo7TkkYPfXddHtxrAg3tVzIUfNJZaqTjyX+R3p28uY/AGy8AswznkTH35qPM0k+CmlHfwrYutySMExI1BixVtr1ygqHySMr5rXtugrCR79HnaC0iyIkQ2QtBrtwDKEVH8xjZd8m6jUfYkx637i1VVxmzNZ3zKDyqBMEjAJPzrvGSAwm7OOJDgxKeQNP8GD+MKVQndWeNjs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84B921CBF477464AB2F14B5A72E5DA16@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e36bf4-f30c-4c09-7870-08d73ba601c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 19:34:07.5120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZxlRhpJOf5ERQeFFxv/NEciIww+bLYrOLU9gQkJu0dxSODFuTh4kfKytDNcx+IWY84s8YhkZemWuGmeXTKrrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3553
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_10:2019-09-17,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 mlxlogscore=905
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909170185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGxlYXNlIHJldmlldyBiZWxvdyBwYXRjaCBhbmQgcHJvdmlkZSB5b3VyIHZhbHVhYmxlIGZlZWRi
YWNrLg0KDQpSZWdhcmRzDQotVmlqYXkNCg0K77u/T24gOS8xMS8xOSwgMTowNSBQTSwgIlZpamF5
IEtoZW1rYSIgPHZpamF5a2hlbWthQGZiLmNvbT4gd3JvdGU6DQoNCiAgICBIVyBjaGVja3N1bSBn
ZW5lcmF0aW9uIGlzIG5vdCB3b3JraW5nIGZvciBBU1QyNTAwLCBzcGVjaWFsbHkgd2l0aCBJUFY2
DQogICAgb3ZlciBOQ1NJLiBBbGwgVENQIHBhY2tldHMgd2l0aCBJUHY2IGdldCBkcm9wcGVkLiBC
eSBkaXNhYmxpbmcgdGhpcw0KICAgIGl0IHdvcmtzIHBlcmZlY3RseSBmaW5lIHdpdGggSVBWNi4g
QXMgaXQgd29ya3MgZm9yIElQVjQgc28gZW5hYmxlZA0KICAgIGh3IGNoZWNrc3VtIGJhY2sgZm9y
IElQVjQuDQogICAgDQogICAgVmVyaWZpZWQgd2l0aCBJUFY2IGVuYWJsZWQgYW5kIGNhbiBkbyBz
c2guDQogICAgDQogICAgU2lnbmVkLW9mZi1ieTogVmlqYXkgS2hlbWthIDx2aWpheWtoZW1rYUBm
Yi5jb20+DQogICAgLS0tDQogICAgQ2hhbmdlcyBzaW5jZSB2MToNCiAgICAgRW5hYmxlZCBJUFY0
IGh3IGNoZWNrc3VtIGdlbmVyYXRpb24gYXMgaXQgd29ya3MgZm9yIElQVjQuDQogICAgDQogICAg
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCAxMyArKysrKysrKysr
KystDQogICAgIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQogICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRn
bWFjMTAwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAg
aW5kZXggMDMwZmVkNjUzOTNlLi4wMjU1YTI4ZDI5NTggMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICBAQCAtMTg0Miw4ICsxODQyLDE5IEBA
IHN0YXRpYyBpbnQgZnRnbWFjMTAwX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
DQogICAgIAkvKiBBU1QyNDAwICBkb2Vzbid0IGhhdmUgd29ya2luZyBIVyBjaGVja3N1bSBnZW5l
cmF0aW9uICovDQogICAgIAlpZiAobnAgJiYgKG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAi
YXNwZWVkLGFzdDI0MDAtbWFjIikpKQ0KICAgICAJCW5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfk5F
VElGX0ZfSFdfQ1NVTTsNCiAgICArDQogICAgKwkvKiBBU1QyNTAwIGRvZXNuJ3QgaGF2ZSB3b3Jr
aW5nIEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gZm9yIElQVjYNCiAgICArCSAqIGJ1dCBpdCB3b3Jr
cyBmb3IgSVBWNCwgc28gZGlzYWJsaW5nIGh3IGNoZWNrc3VtIGFuZCBlbmFibGluZw0KICAgICsJ
ICogaXQgZm9yIG9ubHkgSVBWNC4NCiAgICArCSAqLw0KICAgICsJaWYgKG5wICYmIChvZl9kZXZp
Y2VfaXNfY29tcGF0aWJsZShucCwgImFzcGVlZCxhc3QyNTAwLW1hYyIpKSkgew0KICAgICsJCW5l
dGRldi0+aHdfZmVhdHVyZXMgJj0gfk5FVElGX0ZfSFdfQ1NVTTsNCiAgICArCQluZXRkZXYtPmh3
X2ZlYXR1cmVzIHw9IE5FVElGX0ZfSVBfQ1NVTTsNCiAgICArCX0NCiAgICArDQogICAgIAlpZiAo
bnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHctY2hlY2tzdW0iLCBOVUxMKSkNCiAgICAt
CQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH4oTkVUSUZfRl9IV19DU1VNIHwgTkVUSUZfRl9SWENT
VU0pOw0KICAgICsJCW5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfihORVRJRl9GX0hXX0NTVU0gfCBO
RVRJRl9GX1JYQ1NVTQ0KICAgICsJCQkJCSB8IE5FVElGX0ZfSVBfQ1NVTSk7DQogICAgIAluZXRk
ZXYtPmZlYXR1cmVzIHw9IG5ldGRldi0+aHdfZmVhdHVyZXM7DQogICAgIA0KICAgICAJLyogcmVn
aXN0ZXIgbmV0d29yayBkZXZpY2UgKi8NCiAgICAtLSANCiAgICAyLjE3LjENCiAgICANCiAgICAN
Cg0K
