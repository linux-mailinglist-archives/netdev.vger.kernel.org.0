Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB83123217
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfLQQOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:54 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:54665
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728562AbfLQQOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9YyL0umP8eXsBm6DeKSmPSNwQaNP6/4LMuD6eck9nS6xrOoAIQJui8gICBVcB+fAcT3/mw3W6OonPqvIHdFeUNjeYuFOBTL/GHswLE+/f+Stsim7uvZKOCai4kXkIP8HxWvC5XkvdJkIGPc5O57IvjSToOL9DY7USttf4ZezcALmn7+NPNZyNGH9WiamCVqVk7AJI1UUhRHqhdF/3arzMlTS97eXP/oollo4KhyBGNSR9TQUgcBMix8P30l7HCtO046komsVKtmhJAAJulFghMKHBrOvhmRdCNxlNZ+k6GQx5JoalOtNcq/reTUJL4+JNZFo9QGluAJt0mshdQADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTZ2mHQAOdzhtudBdg9k79F/qN3A9xgRWs5Gtagwc+o=;
 b=Apcv8yEXJ5clOcxl00VVz1pe07PtC5tNX87LLm3emCyzyd0yngIs4GQHL/WWQSAFErzrqHfYZIwydI/K00BDAnVemkcjGmUC/NKWldjlyYjkQGW0dkvGzrSdj9n2lEVTl0HdqUTyqf8VmU61XyZqprgYkDAd2AS1WZMbm6RzYU8XBoDkw1IPwEKEjgqkilcfLaXz+Sr3DlSZPSPNWC6OUvJbXLMqzz2cFyzdTXQkL3z2RqWjDtaqpXKY/Vosl/Ns50jB6636ugO5UvkmaBdUXdiFrMuWNowGxz6zBhX2ZCJznlLP0HcJI3xD+i+TKIJyP4i/X9lhiavH0UuYLOiwUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTZ2mHQAOdzhtudBdg9k79F/qN3A9xgRWs5Gtagwc+o=;
 b=piWa2k2MOdZDWxbbFnW98taVevwWoHD8syzugx2ogpRwmDeJ3F1p56eioJrMcWZUBrv0ws/x/4pStHM+G/gA3VDUS5wiFOrTt4h78diMey6SpddYQD3D0yfG6kKr5tjlhcAG9OKvZarU+yakeP6mBsqWBvpW8FMt+joPv9uSORQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:50 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:49 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 15/55] staging: wfx: take advantage of IS_ERR_OR_NULL()
Thread-Topic: [PATCH v2 15/55] staging: wfx: take advantage of
 IS_ERR_OR_NULL()
Thread-Index: AQHVtPUaVu3WG5LOh0qy2MRcQq8tLg==
Date:   Tue, 17 Dec 2019 16:14:48 +0000
Message-ID: <20191217161318.31402-16-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: bbfdf93d-df18-4ed4-ca78-08d7830c3c70
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3678A516D3CB1EE3FFE2000193500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(6512007)(66574012)(1076003)(4744005)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fpdou2V8nGI1bBriUaUXEmHqtrjOrSCr9WF8qv2THZWElxfnFfUA1zmpLPN/zFlQEcSfqxbpFHdiFmODXDjwymo2xfcbGH0zGzDGQx7OeM56GDjLlmuEpH5i5ypbDcAivd05HC10G0aAMh5aXLUEfrCPqypM+aWFaAKopQhnk8HgC1L4kAhIzqgR2DZ7taODKD0CG8P8PJN4SI1K6LDgrEKYnGr6e4piW46AzIGiNKuCEamlDLHHtu+JNmS9HAYS6Tz4aTDjZH9XWXMF+GijkRUOp2rwj4UUVDIoyRc+8cFrvA6KRT+Vu+La7sWDUlxGuKlk32o0KgJ+DQXS0k0iQQr/RIDYNeXJ50O7s21AeMYytwQxGdPcWzSmrTntlWrlWpasoU2ujhaZ9JDSsJsi/CkK+5Ua50FVBgLr1c5z/a0IKHZ32J7f+akQ4UBA0+q2
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E738CADD67D264EBBB70178CC175465@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbfdf93d-df18-4ed4-ca78-08d7830c3c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:49.0296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZg7BUnnSR73qQaL+duV7rxSMLP8+8ePOMyG4Xyqepqun8W/CXtp2vs7J3pSy1dIkPdiHFh7mqiKKP9xFDbw/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT2J2
aW91c2x5LCBjdXJyZW50IGNvZGUgY2FuIGJlIHJlcGxhY2VkIGJ5IElTX0VSUl9PUl9OVUxMKCku
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgfCAyICstCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCmluZGV4IDNi
NDdiNmMyMWVhMS4uY2Y0YmNiMTRhMTJkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAtMTgyLDcgKzE4Miw3
IEBAIHN0cnVjdCBncGlvX2Rlc2MgKndmeF9nZXRfZ3BpbyhzdHJ1Y3QgZGV2aWNlICpkZXYsIGlu
dCBvdmVycmlkZSwKIAl9IGVsc2UgewogCQlyZXQgPSBkZXZtX2dwaW9kX2dldChkZXYsIGxhYmVs
LCBHUElPRF9PVVRfTE9XKTsKIAl9Ci0JaWYgKElTX0VSUihyZXQpIHx8ICFyZXQpIHsKKwlpZiAo
SVNfRVJSX09SX05VTEwocmV0KSkgewogCQlpZiAoIXJldCB8fCBQVFJfRVJSKHJldCkgPT0gLUVO
T0VOVCkKIAkJCWRldl93YXJuKGRldiwgImdwaW8gJXMgaXMgbm90IGRlZmluZWRcbiIsIGxhYmVs
KTsKIAkJZWxzZQotLSAKMi4yNC4wCgo=
