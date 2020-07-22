Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFBB229AD7
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbgGVO6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:58:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732673AbgGVO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:58:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEmk7C012167;
        Wed, 22 Jul 2020 07:58:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=8vyugBPOdj7+7vqqpnHMWZbC7+ZwE+5fwk+wZ9JNKXw=;
 b=Sj5Yn0q4bYnNMYhbmqx9f4hyaLKEJV4Q/tO5SiCLERmPVXc6qXPETJbxNnusXSmzSZhW
 ds/4uoMKgHV4HPsTVseNNGJg9BehUPZxLBVAQ10X7ruS7kkwDXVJ4wXdTNH3qcDtEChn
 mXgSaFfWIZtL/XUCvRCDUT0yUxBVCccIqomRmSRYXHGIkrK0ID6VymVsOOKz3RUKkUe1
 FtaTnmGRfEdpbUzMr1o0y71JmEda1c7lhDkwjK5p/WoiQ+hTrjsjjSCa5neKUN4Ivsk5
 570jScY9HOVMVNGkURuXAjG55A70/vfZzdLJWODzFKsPjM6dfGyUmAmDUqeAfNHNAEES qg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrbtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:58:27 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:58:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:58:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1shl9hOeOKK/XKcLmraojzrBbZ4/VaxuQTkF6AL2dyMPRT2/mlv3xVu72q6t/5ZXEy3DueY0mWRmu51BMp50e5EcICEwgzudwlGdZVgFq6y9Ivi6fmxUzu32AvLyj2IK6PhV04kzMOCIP9xJ7LR9RzIbimPJAvoamJug3A5Va9KbO1jxhEpvPt2WAyiR/IBF7WtLlRJBM6vzvnL+h1Cc+J10jyvkHIyqrGCgNtoyKd45nT5PaV/7ekopGLnML7xXrLQ1FSc33GTg5g5FbzXbsyieRxj9ySRNp4RQlhXtfL2JNXu4F9ZbobtFaprLGY3w4P0ExAtZlSOjkcq/J0caQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vyugBPOdj7+7vqqpnHMWZbC7+ZwE+5fwk+wZ9JNKXw=;
 b=Vb6lVrhFFg8zQNkSSJYZDMhq6AtjIYC6mTMKvXzkZgZppc6shhkmrrn7N9/WVpv57eswjua+B+DaeSvDNWDJIiiZChsoCDkznOHL/PDlquIBmwKahe6neCK28ymxDjEQM8Y1OOzYitKQq5S+z+++x3JzDfFZoA7HLWDWeRFoLJwqhODlZOvHKZ6jXpq7gg173OqI1GTWPbfMFS/cEjBmKRqAoLcr+vsSQZqjY5E1LD38usOm6LJlQ6EyIupTKs3ZYP4hSyvbrefpn+kiXPLi5RGHJDF6tARsgY6x5HOIAuNKl69tuFWymwbi3D2JN3C12vkkPhxz63TShuyeHn8rRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vyugBPOdj7+7vqqpnHMWZbC7+ZwE+5fwk+wZ9JNKXw=;
 b=j7ProWtc+naO3FqYHU8C9eJ9fEiQKt+6a+Ff5w4ndyOfiRHRithJPC0tHcDU8+SWr4RUadp6Md9O5O5NxDQnkbQe944GLzk4rbpSLdM80aSXJHcIL8kdfPP5wZL8NYsmzptELra8BWvDay7CiXds/sRO7qaR25IHysEK4P0EY9Q=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Wed, 22 Jul
 2020 14:58:24 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:58:24 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v4 11/13] task_isolation: net: don't flush backlog on CPUs
 running isolated tasks
Thread-Topic: [PATCH v4 11/13] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
Thread-Index: AQHWYDiMpgobFulKPk24EMbX9A+yKQ==
Date:   Wed, 22 Jul 2020 14:58:24 +0000
Message-ID: <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74c4544b-bd8d-4e50-26e4-08d82e4faf14
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2156B95F3BEC7881EB3866F3BC790@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ltkLcEpv1VSPZTCvJIW5W7QVbfePRWVNMV8TANb3XPuyGQj2+W7pd5QZivs2VnY9DxEtBaYgHg3f9fcmfVH5o0HToMMDPSX/9F17NRnbzh+lDhtP4cr8VSIuX5HQMfUueA157kvnr7Di2ZxYW5LNk/WIYlyoOqXMrW2XiH+UlOyOegr/0bV7E0wWdCGC+utp7msuttRGB2s4nJN2a9vzL6f21VhW1f0TYsjnJDAI7vRnMVOkDd2cGLL1+V79pTs/6rwLXqbEkNEDiQeEw8eqIoNd8RAVAdsLV9vtVGxYswCjgeDiL48Ui6p/h/V5pG5K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(110136005)(6486002)(2906002)(6506007)(54906003)(66476007)(478600001)(6512007)(8936002)(2616005)(8676002)(316002)(4326008)(66946007)(186003)(64756008)(86362001)(83380400001)(76116006)(91956017)(5660300002)(66446008)(36756003)(66556008)(26005)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gYDiOzNkI0/JljNr0ydprnR8hKP/Rm/OgsFIuEEas5Xu+zNYuP4eiXHveilvamrS9VO9ai14A+wQyFcjuN6h00vPy7XslYq1M04vrCzb7R5hAWafLSsWuXx9qoRCs3bEBhvHGBrUvxQ+x84G6GTXNo0qd4RNogOk4dESUlfpA/gNKvjmB6x8S7L+wB2vZuiH2dtElyfvS+pX6+tYCLL5xmlZBsT5NHzTfPbyUrYLxfsliKjcEEt57MJMEyY6wYyAxAnAdDN/8aHuRflVyWWtaktLtxoQ0SRu7lAP1PkfWzGIrJS0dFi25aCWwu77wOih9RP2fwwQ8kolqN6bL4Q0PYz7iWbRJgiqoa8LSHy1f4zL8fpLxYU8AO0XVg6Nq8GblIFilLVXSnQreEff+FAaklcY/regrCQXZ98lTN7+dPRMZg+Dr8vxacEq4vdxhFSzcUF08/hXFLvVzkcR0PA4fCjym1rN3tJHpjaqZrdQ2u2kRC9w1sGxhNyXQfI95WyQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <392AE7C4E756DC44BB5350C22441BE67@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c4544b-bd8d-4e50-26e4-08d82e4faf14
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:58:24.6373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5aQYoVeUE6y4IndylvkwJ0rzvKg513No9iUPycQ8IAWR+JGajkoAOWxfHpPYd4YdmYkyMW0wlvXraI1CHNgIRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpJZiBDUFUgcnVucyBpc29s
YXRlZCB0YXNrLCB0aGVyZSdzIG5vIGFueSBiYWNrbG9nIG9uIGl0LCBhbmQNCnNvIHdlIGRvbid0
IG5lZWQgdG8gZmx1c2ggaXQuIEN1cnJlbnRseSBmbHVzaF9hbGxfYmFja2xvZ3MoKQ0KZW5xdWV1
ZXMgY29ycmVzcG9uZGluZyB3b3JrIG9uIGFsbCBDUFVzIGluY2x1ZGluZyBvbmVzIHRoYXQgcnVu
DQppc29sYXRlZCB0YXNrcy4gSXQgbGVhZHMgdG8gYnJlYWtpbmcgdGFzayBpc29sYXRpb24gZm9y
IG5vdGhpbmcuDQoNCkluIHRoaXMgcGF0Y2gsIGJhY2tsb2cgZmx1c2hpbmcgaXMgZW5xdWV1ZWQg
b25seSBvbiBub24taXNvbGF0ZWQgQ1BVcy4NCg0KU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8
eW5vcm92QG1hcnZlbGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVzZSBzYWZlIHRhc2tf
aXNvbGF0aW9uX29uX2NwdSgpIGltcGxlbWVudGF0aW9uXQ0KU2lnbmVkLW9mZi1ieTogQWxleCBC
ZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBuZXQvY29yZS9kZXYuYyB8IDcgKysr
KysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0K
ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMNCmluZGV4IDkwYjU5
ZmM1MGRjOS4uODNhMjgyZjc0NTNkIDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvZGV2LmMNCisrKyBi
L25ldC9jb3JlL2Rldi5jDQpAQCAtNzQsNiArNzQsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9jcHUu
aD4NCiAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+
DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+
DQogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCkBA
IC01NjI0LDkgKzU2MjUsMTMgQEAgc3RhdGljIHZvaWQgZmx1c2hfYWxsX2JhY2tsb2dzKHZvaWQp
DQogDQogCWdldF9vbmxpbmVfY3B1cygpOw0KIA0KLQlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkN
CisJc21wX3JtYigpOw0KKwlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KKwkJaWYgKHRhc2tf
aXNvbGF0aW9uX29uX2NwdShjcHUpKQ0KKwkJCWNvbnRpbnVlOw0KIAkJcXVldWVfd29ya19vbihj
cHUsIHN5c3RlbV9oaWdocHJpX3dxLA0KIAkJCSAgICAgIHBlcl9jcHVfcHRyKCZmbHVzaF93b3Jr
cywgY3B1KSk7DQorCX0NCiANCiAJZm9yX2VhY2hfb25saW5lX2NwdShjcHUpDQogCQlmbHVzaF93
b3JrKHBlcl9jcHVfcHRyKCZmbHVzaF93b3JrcywgY3B1KSk7DQotLSANCjIuMjYuMg0KDQo=
