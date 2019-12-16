Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D38121082
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfLPRD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:03:57 -0500
Received: from mail-eopbgr680072.outbound.protection.outlook.com ([40.107.68.72]:26598
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbfLPRDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ei2i/FALxCGPzhzGukdDKABna61vF2x8xhCZ5EjnIchpB311072Xof5lClDUAmIcIAnIa7PIiUf40vmtlC+mTKDhnmtCNLvbBIJOpYJXSS9dJZC7qil2vKI2/DK9Xs4rvvbU2htq/G7AxaHVLeDNTXiUlf6nJlLbROzpjDInJAJshL1yjhi5g5LWJYGjhN+q2Be/v8CoSMBttvm7+xxtd8OYQO5xVz4y4WICGuHXInywu4hANm7iLtQ1/JRp+sJqr4I7rnHUHXAi4uzPxEO7DE7VOatWFzfMzc5BMJMP5PxkxOqcejn+CulDfFTheBo2bzIRSXeIQTm8PjO6phtQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32kkhkvCRMNUoCtpHSw6b96yAbKv7LrEtiuaAg0mXZ4=;
 b=fkNFcezhpW/QZ6YuswKTvcW+w8kGYyNN/kIOSUrqgvRSGdj1oR+mSxuEzTpkf9cCFcp1tvNvyw4wJhBbo+7HipHdMK50Ir4pAT9toVQYYCCOYtfGrZZXg1ZClkSm/2UBmAiF1Y0Wjynz9BQyNOgypvLGOtgWwX7CDxi2ieNIwPptdVc9euHZtNWWnrLQhFXfg1BVMFvhYtoY7+BiII9gHnapZY5NWP/7Oi7bjeOS5Sp9+uMs/CAxAwe9EUuMtG1Y8x6D/rnisb++NrLn0pqxg04LO8j03QQam43GTJLfSoXTP2YUyWSqpqwQRXh/rJ3WNfm2td8xoX5XeV/M7Kd/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32kkhkvCRMNUoCtpHSw6b96yAbKv7LrEtiuaAg0mXZ4=;
 b=L/vK5DrO424GgP78KF6nMx6v/HtSsT8nTibp7OoM9nyfqTrUtdWJkYBX8po4ukmq4BQUzo663gQLLnJ26cKdE2uT7Hfp7V6XnAFtt/rtLI3s2ktcVUKV1D+w3yVHtHEXsoVKzp5ZRbUp+wYqUzXBrPN72jIL89ujduJimbpwEFQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 09/55] staging: wfx: fix hif_set_mfp() with big endian hosts
Thread-Topic: [PATCH 09/55] staging: wfx: fix hif_set_mfp() with big endian
 hosts
Thread-Index: AQHVtDLCg4OZV5pG80CM4ZuJNeR8pg==
Date:   Mon, 16 Dec 2019 17:03:37 +0000
Message-ID: <20191216170302.29543-10-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9f991c0-4377-49cc-eb2b-08d78249e974
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB38381E7A69663F9C8B05112B93510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(4744005)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(6666004)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003)(66574012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g+YnwtlBwgs6qqkfO0QKak3M2YhLiucyqpI0h26kqSALFw/CDlHLhimGEavGUoDksdh0f51sJ72pR+/x463BwhE78SWiKy+DRivbQ6KReeq3IiwIUndwQDvOH/3SOT2Y9vk2nkK9T9jseLRLPnBkG8H+TcRm2PkIQzsrPlkdaijA7t7pJmI1vkousxpvMHST4Lii7sqvHshJKzE1TZa/f9XaxboeWOn0C8KPHsqGMRDShoyWXX153p4N1qq7QmZqzo1G1DclK8bYWHXHSZXetgSfL+oZt9rfjUtXn4l9Gjo1InKpONKeNwQA7Heu6xEKa9dV3VYvDsC1ysGru5740+DTr1FedYUriecwsfxiVX40YWCdcR+IpyWeJUlGd+2u9Of7cRfinicGKQlGwyNKbz6p9U4PvO8DFoyN1aV+kctflU9DB0X3eLmkj0/K+u7e
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F0AA91A81FD894A8A07D763C121E7B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f991c0-4377-49cc-eb2b-08d78249e974
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:37.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oLEaSCo5R7LudfJa4I9MBK4+kEer8BP2rD8dEIpLjnBtWGi2/WmP2mtBr0SYf+feOaQCp4NK0rXa+evt3SCv1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpz
dHJ1Y3QgaGlmX21pYl9wcm90ZWN0ZWRfbWdtdF9wb2xpY3kgaXMgYW4gYXJyYXkgb2YgdTguIFRo
ZXJlIGlzIG5vDQpyZWFzb24gdG8gc3dhcCBpdHMgYnl0ZXMuDQoNClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMSAtDQogMSBmaWxlIGNoYW5nZWQsIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgNCmluZGV4IGJiMDkxZTM5NWZmNS4u
OWJlNzQ4ODFjNTZjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oDQpAQCAtMTQ3LDcgKzE0
Nyw2IEBAIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfbWZwKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBib29sIGNhcGFibGUsIGJvb2wgcmVxdWlyZWQpDQogCX0NCiAJaWYgKCFyZXF1aXJlZCkNCiAJ
CXZhbC51bnBtZl9hbGxvd2VkID0gMTsNCi0JY3B1X3RvX2xlMzJzKCh1MzIgKikgJnZhbCk7DQog
CXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2aWYtPmlkLA0KIAkJCSAgICAgSElG
X01JQl9JRF9QUk9URUNURURfTUdNVF9QT0xJQ1ksDQogCQkJICAgICAmdmFsLCBzaXplb2YodmFs
KSk7DQotLSANCjIuMjAuMQ0K
