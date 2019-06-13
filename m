Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E466844E19
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfFMVG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:06:57 -0400
Received: from mail-eopbgr800118.outbound.protection.outlook.com ([40.107.80.118]:11235
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfFMVG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 17:06:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=kBbe3xnF9iirhIyzruNqFO4RqVTghkLCAejYhXEATUeF5iCUdDgvynJgI5/jIGqCktBxKfOr2oqxcqpkDmPYlIXeegyV0VEggu3RWfkXegYa36C9E9hs+hcFSJc1LPhnQymrceC7yENuT9NRjzmUS9siQdhK7c4rKiKfFiR1V1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xcrAXfZh81hwsmV+84Zt8evX32NvIi2whAfWwnjYHw=;
 b=aDeH4r2WeEb3FZP4CyCawQqcqoB9SnnXd5Az9F7J8UJ3DefwA/ZILQiq3IJpSlrwNCAZXCfzK+s6M7JZAuBpGFWyFvMIbvqCmvkpRo8S6Ne063YlIbnndXhQ0FnsDfRfEs/OjzZ97haC7N8zopegPH1ghtaWy9+U4A4ZnyApm0o=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xcrAXfZh81hwsmV+84Zt8evX32NvIi2whAfWwnjYHw=;
 b=NKN6US3r6k7zlYH+EeDAaPbMinkHkyokEKyeFOIVV15EuD2ASBeIC4o+Q3pAaeOCVJueYccGbFjAjgfjd6U3wmjm97qVkpEfaOvvpZYrpcZM+NVw6O826Qd8I00Br5jBmKNb/U48a1OU9gfUj9mJBjInK3qPdK07BexUHAokI0k=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (2603:10b6:5:169::22)
 by DM6PR21MB1258.namprd21.prod.outlook.com (2603:10b6:5:16b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.0; Thu, 13 Jun
 2019 21:06:54 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::b825:2209:d3e2:8f11]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::b825:2209:d3e2:8f11%8]) with mapi id 15.20.2008.002; Thu, 13 Jun 2019
 21:06:54 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net] hv_netvsc: Set probe mode to sync
Thread-Topic: [PATCH net] hv_netvsc: Set probe mode to sync
Thread-Index: AQHVIivt+c6DSWaC7keogthN7NhgTw==
Date:   Thu, 13 Jun 2019 21:06:53 +0000
Message-ID: <1560459955-37900-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:300:d4::32) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c604b83b-8e4b-4976-0499-08d6f0430fbc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1258;
x-ms-traffictypediagnostic: DM6PR21MB1258:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB125884F1729B6E8DA659ACF9ACEF0@DM6PR21MB1258.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(2906002)(5660300002)(50226002)(478600001)(66946007)(68736007)(4744005)(36756003)(66556008)(66446008)(64756008)(66476007)(6116002)(10090500001)(14454004)(53936002)(81166006)(10290500003)(81156014)(73956011)(2201001)(25786009)(3846002)(8676002)(7736002)(6506007)(6512007)(8936002)(2501003)(4326008)(52116002)(386003)(54906003)(99286004)(52396003)(6436002)(102836004)(6392003)(7846003)(14444005)(256004)(4720700003)(66066001)(26005)(316002)(186003)(22452003)(476003)(486006)(71200400001)(2616005)(71190400001)(305945005)(6486002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1258;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hc0emR2M+v0+sTdmpDGJu1SUoD+4vTY11qeQ3kFOxej0DJd6nKTfuVlEl5bzOKne7NJ20q5OclBFBJtsAQcKUje8SV2Z59TmI10kNw401NR0Q9KJ6ePKIr47nyBEiO5wPkQa5Ema2tlBXPqj27LOAEr9SkDfw0T8wJ7ARFcotCJNp2x0Fk+YmSR//jiWBZlTmocKXsjGPcpoQv61x1UY62oLCi6IKrV/y8NRYG7SicLWMetzVoN1kCVvejyel6ruLc1VFjQ+RvS0OB+4l0y2U29RUpSbCN3snA68+vzGrjVp4febL1ZEVJssa5Tb4jpY8MYTuZhn1oAWNKWXiK3BkVMMVAgplVIeZXOuglsffB5bRmdQKKFnOtzc4tfQ5L08EXzhu9tfP87Cgx23DajJnNDHc1cI0cDxzOppKtrYr3U=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c604b83b-8e4b-4976-0499-08d6f0430fbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 21:06:53.9697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lkmlhyz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1258
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rm9yIGJldHRlciBjb25zaXN0ZW5jeSBvZiBzeW50aGV0aWMgTklDIG5hbWVzLCB3ZSBzZXQgdGhl
IHByb2JlIG1vZGUgdG8NClBST0JFX0ZPUkNFX1NZTkNIUk9OT1VTLiBTbyB0aGUgbmFtZXMgY2Fu
IGJlIGFsaWduZWQgd2l0aCB0aGUgdm1idXMNCmNoYW5uZWwgb2ZmZXIgc2VxdWVuY2UuDQoNCkZp
eGVzOiBhZjBhNTY0NmNiOGQgKCJ1c2UgdGhlIG5ldyBhc3luYyBwcm9iaW5nIGZlYXR1cmUgZm9y
IHRoZSBoeXBlcnYgZHJpdmVycyIpDQpTaWduZWQtb2ZmLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5
YW5nekBtaWNyb3NvZnQuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvaHlwZXJ2L25ldHZzY19kcnYu
YyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2h5cGVydi9uZXR2c2NfZHJ2LmMgYi9kcml2ZXJz
L25ldC9oeXBlcnYvbmV0dnNjX2Rydi5jDQppbmRleCAwM2VhNWE3Li5hZmRjYzU2IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvaHlwZXJ2L25ldHZzY19kcnYuYw0KKysrIGIvZHJpdmVycy9uZXQv
aHlwZXJ2L25ldHZzY19kcnYuYw0KQEAgLTI0MDcsNyArMjQwNyw3IEBAIHN0YXRpYyBpbnQgbmV0
dnNjX3JlbW92ZShzdHJ1Y3QgaHZfZGV2aWNlICpkZXYpDQogCS5wcm9iZSA9IG5ldHZzY19wcm9i
ZSwNCiAJLnJlbW92ZSA9IG5ldHZzY19yZW1vdmUsDQogCS5kcml2ZXIgPSB7DQotCQkucHJvYmVf
dHlwZSA9IFBST0JFX1BSRUZFUl9BU1lOQ0hST05PVVMsDQorCQkucHJvYmVfdHlwZSA9IFBST0JF
X0ZPUkNFX1NZTkNIUk9OT1VTLA0KIAl9LA0KIH07DQogDQotLSANCjEuOC4zLjENCg0K
