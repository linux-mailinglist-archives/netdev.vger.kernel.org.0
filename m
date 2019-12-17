Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFA312315F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfLQQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:01 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728670AbfLQQO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGA83A61ch+Vrpg7Yw0guCekonQgY8LCFUYB+R8CkRKunMaeEo83+QnoEJxRTuft+46rWJZ5gv7IXNuzi0iLMZhklUd4PyQa5GTWaeeLTnkZwUtnsMCj1LRQUiEsft927p1lXcp9HGMUZ8DEGWf2CqtpJr50mEOWJktVoJB7X7VEoDUpUtzL4xjqfAem9VvJLcygSkYxtleMDKHkIcMfn3LlY/AKAMQVbQLb4tEPUi0hHY/1gS+t+/HuzDWSdf+JQU/0yvlJEhWUAlr+K7QOaZYT6Rfs0UWYewk8/rbBvCV2qat/J/VigGxGezqkQzxkQA75IjwR0/50RtEgQMR7tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkwSEUaf5FikMTEMAHVJod2eWxzYWbjceVKMN0/ePGk=;
 b=k7EuMPay8x+ekaExwubrvjjeg433RUT/GOcoxLK4TwoXECP0yZIXokJfIP8W+IdhxRgJ/5gBwrLkPPQJn+ecV30LOvw1x4e+nMrP7kItCZYFDhPkY4eGRD2wiaxfb7DaXUHVvXOYLTxblWFzioYAdBi6snnR7ImOFyn1T2BDXicDLYH+eb8wq6hV0szyNQKnfq/xNA6nq6GGtTtxwXyuFFEWnK85obbtyr4zxPssQnCUdUusC4rT+K9X9Umwc4Ucqhz+29NE5qqs1SVOo//4t8FDhGRseKltVX8vH7WJYXf1mHQWYF2ptAfTdg96M8dnZWHDP+CSeC8kP4MJp4iQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkwSEUaf5FikMTEMAHVJod2eWxzYWbjceVKMN0/ePGk=;
 b=hxAM4kRxg1V/DCpaKQORD3HnKDFbgkO6O4gOwiBIpuV+Chvq6cqcnKXG7VD2mF/Mrq9CdFD1K94j7fQ7GW+wKJM8FGwFpWZJ+nnZ8DRIK5GAZWn81MAATe+ywkLXlauYciFGpk3qBRjz/5IS+n9lKaucxrYFBHVSvS2TJVBeWm8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:41 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:41 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 11/55] staging: wfx: increase SPI bus frequency limit
Thread-Topic: [PATCH v2 11/55] staging: wfx: increase SPI bus frequency limit
Thread-Index: AQHVtPUWDHamnJNHP0yOm8KShv5Mvg==
Date:   Tue, 17 Dec 2019 16:14:41 +0000
Message-ID: <20191217161318.31402-12-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fed71f0c-1140-44e8-ed37-08d7830c38c2
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37918B412869ED314864FA3593500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(4744005)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: beCKLkzOFcHlbTOI3IzFKRYqceginWwUu7GYysEhcHyfoXfKYUwbLRjTTLWSqpFV+CzNUEVVRZPQFalIhbSGn8lSNVbxmGqXoZZTF+IlmUjIckq7GdP3jzfy/bYLE5DFRsvE/yxuNCuOX30QzPZWtHIQ/gV0nucC2MnTn9jnlZxY61EbdNtyDA7lFEexV2tGcV57sP94QgCqeauScl2ipK5rB7onfiXnoOLjXdw66jLVtfU1hvXVtMQ0SVkF70PcwmdB+j3jsRyeqyyv323voWUoRsyIOnATsfs5jk7mk9ZAA29+LNySeXLt6ZDep118T4xs71YUncOQkF4NeonBnKbiR+0XQUuCJiHTjMOUmlgYCD7DdPz81kwG1Gam0RfBsTnCjHOuCFXY6LOxXsrA+TwIhXOBIBLjaRWup6LKEQBIFGjoM9h/srvC3Qx0mxlr
Content-Type: text/plain; charset="utf-8"
Content-ID: <78E09B3BB21AF541BF46B514C85B1F6F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed71f0c-1140-44e8-ed37-08d7830c38c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:41.3948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HaEtZTObbRx9XqrYdtWEV9U1SccLRTm5Ue67jani0YSw3OXBUyO3IBR0HaY9G/BVb+6r/dVeKeIF4pPyUW3bKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGNoaXAgaGFzIG5vdyBwcm92ZW4gdGhhdCBpdCBjYW4gcnVuIGF0IDUwTUh6IG9uIGFueSBib2Fy
ZHMgd2l0aG91dAphbnkgcHJvYmxlbS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1
c19zcGkuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKaW5kZXggYWIwY2RhMWUxMjRmLi40NGZjNDJiYjQzYTAg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvYnVzX3NwaS5jCkBAIC0xODMsNyArMTgzLDcgQEAgc3RhdGljIGludCB3Znhf
c3BpX3Byb2JlKHN0cnVjdCBzcGlfZGV2aWNlICpmdW5jKQogCWlmIChmdW5jLT5iaXRzX3Blcl93
b3JkICE9IDE2ICYmIGZ1bmMtPmJpdHNfcGVyX3dvcmQgIT0gOCkKIAkJZGV2X3dhcm4oJmZ1bmMt
PmRldiwgInVudXN1YWwgYml0cy93b3JkIHZhbHVlOiAlZFxuIiwKIAkJCSBmdW5jLT5iaXRzX3Bl
cl93b3JkKTsKLQlpZiAoZnVuYy0+bWF4X3NwZWVkX2h6ID4gNDkwMDAwMDApCisJaWYgKGZ1bmMt
Pm1heF9zcGVlZF9oeiA+IDUwMDAwMDAwKQogCQlkZXZfd2FybigmZnVuYy0+ZGV2LCAiJWRIeiBp
cyBhIHZlcnkgaGlnaCBzcGVlZFxuIiwKIAkJCSBmdW5jLT5tYXhfc3BlZWRfaHopOwogCi0tIAoy
LjI0LjAKCg==
