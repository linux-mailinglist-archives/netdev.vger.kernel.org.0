Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A6B229AA3
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbgGVOwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:52:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729642AbgGVOwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:52:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEkbTw016104;
        Wed, 22 Jul 2020 07:51:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RsbROyy9o5twnlyyPcyoUc615/SMC3uVIbiyIp12Dyc=;
 b=ODOAX3Vf1hr7wktTTss7qEjiVKy0WNTdLe80l5AgSOy3GetviRocF0VLf3bp30jEwfJ6
 OQIX10zNQCpMf5iUkP0UiNHhE4hPv/39pqX4CJDYRuTsYAQly2N6BHYwVjIipp/zidcg
 E/5yEwf53gjPcV9Aqw5wnRzQoEz79oC9T8uITAk4nvj4gkHDN3l+nqLGfhp1TECwVyuM
 gfZ1fqRySuI0vI0+/d/Yy5+pRev480zX40+ul+UjPJaQ65FU+NCjyNfsgGL4FjsNvYr0
 uY+Hrf4PHuvvY7/iPfXQbQIg2ZMsN/MurgNsB9afQKE0ziTSnA4jGr/3YyG8cmuN7IY4 ZA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxens71g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:51:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:51:57 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:51:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aq9JmuIBHScospIPRBNsAdbx/ABv+xy2J7mOXttr8IFOnsEYJDk5cUnigXbwE6sHEgSZbpOjHijyXTrchxx9B0jKSPzncM/0msOpDs0+Aikn8d490Vxv1eqcXGjRgUbwgqUoKd/SW+zLQ2K2b3SBr+ZGQ74M/jyZJ6H4AGYSO1uYlxOGsctQB/jg4ApGReFKE6KX/uSvxWeAp+PP/Np+k28NVfEPH3HoWqhroyIJkyyiLxZ6TJgBSScQW1rhyNmET7zjmOxkXLio9BDRFw6shd6+OWy2wOQ7Odk9EV26xdkQs+33CSbbBChPMcEpwIYew80SyI0JVH1O5fK7viO1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsbROyy9o5twnlyyPcyoUc615/SMC3uVIbiyIp12Dyc=;
 b=OsA52B3ve9YJO1ybKQB/LELddTeCXQh6fzu50dDJPI5u3t1ajr7KCTLVtNFvvzJnogfu/eRti3FIwp5RsQS6scZa8D10aO7oELhpBtOPcmt3cjlG6IRhxw5f0PNxVxVyTISs/e4u1395T8eecg/ilLUuRPbYECn/hKIxCe0w6BH1lk2ZPYo0SCnc8TzS66RnRiZN7QPlyxNMC6LCaxZUOKEbS5ML6aeMZWSB45z7XrGBW08aN+PBwAFpyo/YDNbeW9RHK4HSjAyCyLKnLCsqSTL0hGzONKHkwetIQXrZmQ4/YBF0/n4Vdf0VHmuo4Ln+qE1CoST7BwKD8k0APvynvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsbROyy9o5twnlyyPcyoUc615/SMC3uVIbiyIp12Dyc=;
 b=d9L+C/MSALNOF5jGgBwBWR3vJi3vXnGR/bQ13sjza16iIiOw3tCLGEoy7cE02TlRwD+uPwUwXNW9/XjX7GgwDHs8CYVKhqDSvIUx/cX6Dbxj9MLAw0poNwKwGk+K1fFgl6Wx6hZaccreImkeV9xdDhgxG52P3KKL+kvQK1CJnyM=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Wed, 22 Jul
 2020 14:51:56 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:51:55 +0000
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
Subject: [PATCH v4 05/13] task_isolation: Add xen-specific hook
Thread-Topic: [PATCH v4 05/13] task_isolation: Add xen-specific hook
Thread-Index: AQHWYDekSLC//sodZEC38w51R9lIxg==
Date:   Wed, 22 Jul 2020 14:51:55 +0000
Message-ID: <f1de0a5f9b0ad9305030b452e9fdc5b39c7e54b4.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 7271793c-7189-4ede-83f1-08d82e4ec748
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB215664BE19746B5DE47A31EBBC790@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:275;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0w6Wl33ySdDSmee1UhUmOqHM979ESxiJ+iWU3tE9IIgmXFKGeKV4pAn8vz/EuD5+QQnOLMALv8LGwRxSkBmLoOP58r3FWZ0zN3gQ8O64hXF2hkCw94uBTeah/Js5JuZJiq/YlfwdUdI8hON2sBzu6b7U70w2uDrNb5ggr30PL3dxlnEavTfJ/4w8yEzc6q2goF/omjnfyjVxi9jMg0fBOLfC+OJodEg9/81gFzAfvvvIJ/nQ7qUT3qEqGuEEYuTUUYMvwDZlTo8Mk4g7EEFu2Pdzq8cecfC57/9WITVtPhGblliLhX+BBFzwV8AMWthszq03UEiGo+/2uTwK9hW7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(4744005)(110136005)(6486002)(2906002)(6506007)(54906003)(66476007)(478600001)(6512007)(8936002)(2616005)(8676002)(316002)(4326008)(66946007)(186003)(64756008)(86362001)(76116006)(91956017)(5660300002)(66446008)(36756003)(66556008)(26005)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CtpYorwSaZrU3TLkn73oTe3fDxZ45Ucq3YfaVU2Uc6tu9ckjle7Gg6dqOuo61R6gCmxCxRsK1DXfyRoCu4+napVFKDrbQBTPljsVlpOQzaU3f103Z+EcupvWWAcQG54+HW2WMgCPZKSBF35ktZgRsC2Zx9D1UZqT7QyR2+COcF8+yyQtNQrO8mub1rzISHWjvtzhF4iDRfrSmC8hsrJCLLmhTYObWtBa9MnLpQi+dAvWWCRgMAIwveAZ37CVPP0ORColSZRbhsQwI1DVzkDfZw3qB02dakQ0VxwNyjNVoJizEcvJcTePgxMHdqs7UcJpMjU6wBa/cg0OYFcw5fS+AzsSzU6HW4AsX+zqni8jAAebnz+o1RMFOka2C582P3jMSrDR9XUUPQKuOlcrHMhdRI28Z6A8sWUhMjb30lvzJwJL163is2NewxEWydhCrIzpqEbp1FmJ+2JAqEBwYnBhHpNoSFmM1hd4yyqjU00tIw8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5764F27D073494DB2469C0D85F3B1A2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7271793c-7189-4ede-83f1-08d82e4ec748
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:51:55.7800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hnLOmDlqnd6vx3ULhpH1iGzMTkgonTFak3z5UTgLEF4lxASWkDtshf8ISoDfnzh+O9jWKG7tAcv6DRC/210zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eGVuX2V2dGNobl9kb191cGNhbGwoKSBzaG91bGQgY2FsbCB0YXNrX2lzb2xhdGlvbl9rZXJuZWxf
ZW50ZXIoKQ0KdG8gaW5kaWNhdGUgdGhhdCBpc29sYXRpb24gaXMgYnJva2VuIGFuZCBwZXJmb3Jt
IHN5bmNocm9uaXphdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxpdHNA
bWFydmVsbC5jb20+DQotLS0NCiBkcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRzX2Jhc2UuYyB8IDMg
KysrDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy94ZW4vZXZlbnRzL2V2ZW50c19iYXNlLmMgYi9kcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRz
X2Jhc2UuYw0KaW5kZXggMTQwYzdiZjMzYTk4Li40YzE2Y2Q1OGYzNmIgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3hlbi9ldmVudHMvZXZlbnRzX2Jhc2UuYw0KKysrIGIvZHJpdmVycy94ZW4vZXZlbnRz
L2V2ZW50c19iYXNlLmMNCkBAIC0zMyw2ICszMyw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3NsYWIu
aD4NCiAjaW5jbHVkZSA8bGludXgvaXJxbnIuaD4NCiAjaW5jbHVkZSA8bGludXgvcGNpLmg+DQor
I2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KIA0KICNpZmRlZiBDT05GSUdfWDg2DQogI2lu
Y2x1ZGUgPGFzbS9kZXNjLmg+DQpAQCAtMTIzNiw2ICsxMjM3LDggQEAgdm9pZCB4ZW5fZXZ0Y2hu
X2RvX3VwY2FsbChzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiB7DQogCXN0cnVjdCBwdF9yZWdzICpv
bGRfcmVncyA9IHNldF9pcnFfcmVncyhyZWdzKTsNCiANCisJdGFza19pc29sYXRpb25fa2VybmVs
X2VudGVyKCk7DQorDQogCWlycV9lbnRlcigpOw0KIA0KIAlfX3hlbl9ldnRjaG5fZG9fdXBjYWxs
KCk7DQotLSANCjIuMjYuMg0KDQo=
