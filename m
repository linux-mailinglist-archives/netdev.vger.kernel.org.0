Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4082894FD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 01:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfHKXzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 19:55:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726655AbfHKXzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 19:55:14 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7BNrQqh022390;
        Sun, 11 Aug 2019 16:54:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=E1lht+pgPjVvlAK6o58eb6uC4qODToxWxyqzBUd0BGI=;
 b=EOVOO6xArpG3EpftkC/YwhoR3mkE8SGbZR4Y9SqJewnS2jvLoHmA0ItL1FnA2x5E8+xa
 5IJBtpe08HFr10y63yu8yTUhMnn8lmgWozD6y94/qwHXOUeAGwcbwwW8fVFcntOeLTCn
 /uqRgiOHm5Sl8QMLVAVVuo282G9wYJXQAYQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u9w7jcmqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 11 Aug 2019 16:54:51 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 11 Aug 2019 16:54:50 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 11 Aug 2019 16:54:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk/Rh1B+fXGwSsSpLByhr6Aqu+oIQcjIUl9x9JNmbPx722eeM2W+vjK9gGnfxyP/TwmMrECrV29Lrpz5OCL0gSiXHv+bUzaZvNpYbZEibSuuZ/K5P5JWDJe+qEVBx586jK+I5gxNPutpd4kZm5eLDfhsdrcsfJlkBcFx70H3VCUXCeyxzPgZI6KQyMUd5FuLJ9pqqCTiEHWzEW3TQkyCfeZ7dobpomMUnJWFc9XPSiDfusClTKlMx+kqBbBVR3X14sQzVwdowscevWBUHjmxxJTNxDIRWF+4MoES2OrFwZsXXrCAdPjz5TnghlUATewP5rFqLyuZvEtcZnl54EoCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1lht+pgPjVvlAK6o58eb6uC4qODToxWxyqzBUd0BGI=;
 b=XKQxFHxKQWX33VigwvyQq06a/urmxqO3Mx5sJkEFu4yjsq6lpKKbJvxoxvIsgbO37OPF59cfz9ktezmBQUwRT1rgSL028uZpkLIYSygCqm/anJ9fejGaj68LIO+/zeBOfP+kYbJ1tQwfOGApywl0dfWzFebwjSYpjQ9bjJaZmzE3wdcvTUDMIyPdjojwC4nRoiSoURLd40uL7fACO1xdM/ARnoEyeKKRsJ6GMLqAQ9D3yQ74H/Gl+DcMlUWBYFkjU5zv7RsKzJnQwLul23mWpJ+epBE2F+406c7rZcSwQsTOig+3wuO2wf5sPHa85l3QeWN3WGVSa+8roo6slN1Pyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1lht+pgPjVvlAK6o58eb6uC4qODToxWxyqzBUd0BGI=;
 b=ctPLsg80rhDIs5TA3+28jicm8OXeYHHO1ILUzDRMjGWc2/qMQmMx3tlVsRTs/GgMh8fdGvqLWRqy5iPVoWqKM3MMPJnOr8P6CAR6594PEvh7vg5PnXUDMttyQ3IdgqNmpCRt3ji9kG5+wuBf+feW+MTwYa1+imYBYYCaCjbEhYw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2583.namprd15.prod.outlook.com (20.179.155.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Sun, 11 Aug 2019 23:54:48 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.020; Sun, 11 Aug 2019
 23:54:48 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 4/4] selftests/bpf: add sockopt
 clone/inheritance test
Thread-Topic: [PATCH bpf-next v2 4/4] selftests/bpf: add sockopt
 clone/inheritance test
Thread-Index: AQHVTs0NQ2lRvRgBpkG3GpV3YF6Vg6b2orOA
Date:   Sun, 11 Aug 2019 23:54:48 +0000
Message-ID: <000cc025-dd23-46d9-0607-800154043152@fb.com>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-5-sdf@google.com>
In-Reply-To: <20190809161038.186678-5-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0029.prod.exchangelabs.com (2603:10b6:300:101::15)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f361]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc9df57d-c301-4739-390b-08d71eb74b0a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2583;
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2583BC0EFA3726843E8FCEDFD3D00@BYAPR15MB2583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(366004)(346002)(39860400002)(199004)(189003)(66556008)(53936002)(66446008)(66946007)(31686004)(64756008)(316002)(478600001)(229853002)(7736002)(186003)(76176011)(8936002)(14454004)(8676002)(81156014)(81166006)(6512007)(110136005)(66476007)(4744005)(6116002)(305945005)(54906003)(6486002)(6436002)(2906002)(36756003)(2201001)(86362001)(25786009)(52116002)(486006)(2501003)(71190400001)(71200400001)(46003)(14444005)(446003)(476003)(2616005)(11346002)(99286004)(4326008)(102836004)(6246003)(53546011)(6506007)(386003)(31696002)(5660300002)(256004)(218113003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2583;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pRlyoZzSTu9Fg6F/20pgzP56F0SzvBVFGr39zLcoKwXAaHw+rH+5g80o837W70g2umTFvANGGz1zd+4EbbSO4553LldGmLgvu7Z8J5ltw1FdZMVFVetevdOweIsWaKBZr2JDdgeklQ/joGtxaC0M039tfevV+6efj7PjJ8mfka34arTyADjOM6TeG4gdHNSWnM2KL1nfsRMrcCcNLL2vJbINQismVgUfxue4TYrnQ005cONT1GXncB3H915Eon7CVyEXWkp4wy7ZLqiVsr5ZjsS7zwcm844wJYcBwNWenAMkrqSsp1sxCW1U5VLlUiJr6F4hHiJyVtAn+DD2ViREhF3znmEcSxKsQ4Rf07TqXXFbz2wcfQHuwYhaakH51gXLnPUvYeNdK+iWmrE8zg8TWP8OizAh/hW1BBmxQb0AH7Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA0396A27BE115459A3F4AE4674BB3D6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9df57d-c301-4739-390b-08d71eb74b0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 23:54:48.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2ziAB8FpT9REg5tmU/+ba+CBIqYJ26FdUqvrMzKxPRIi64LPUaMdpT4OSNgJRUK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-11_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=702 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908110267
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvOS8xOSA5OjEwIEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IEFkZCBh
IHRlc3QgdGhhdCBjYWxscyBzZXRzb2Nrb3B0IG9uIHRoZSBsaXN0ZW5lciBzb2NrZXQgd2hpY2gg
dHJpZ2dlcnMNCj4gQlBGIHByb2dyYW0uIFRoaXMgQlBGIHByb2dyYW0gd3JpdGVzIHRvIHRoZSBz
ayBzdG9yYWdlIGFuZCBzZXRzDQo+IGNsb25lIGZsYWcuIE1ha2Ugc3VyZSB0aGF0IHNrIHN0b3Jh
Z2UgaXMgY2xvbmVkIGZvciBhIG5ld2x5DQo+IGFjY2VwdGVkIGNvbm5lY3Rpb24uDQo+IA0KPiBX
ZSBoYXZlIHR3byBjbG9uZWQgbWFwcyBpbiB0aGUgdGVzdHMgdG8gbWFrZSBzdXJlIHdlIGhpdCBi
b3RoIGNhc2VzDQo+IGluIGJwZl9za19zdG9yYWdlX2Nsb25lOiBmaXJzdCBlbGVtZW50IChza19z
dG9yYWdlX2FsbG9jKSBhbmQNCj4gbm9uLWZpcnN0IGVsZW1lbnQocykgKHNlbGVtX2xpbmtfbWFw
KS4NCj4gDQo+IENjOiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQo+IENjOiBZb25n
aG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGFuaXNsYXYgRm9taWNo
ZXYgPHNkZkBnb29nbGUuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT4NCg==
