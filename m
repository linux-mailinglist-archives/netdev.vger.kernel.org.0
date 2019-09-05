Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F277AAF0D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 01:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbfIEXXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 19:23:01 -0400
Received: from mail-eopbgr720126.outbound.protection.outlook.com ([40.107.72.126]:59923
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfIEXXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 19:23:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHWuJyTfsruI8TDPc9bPnLu7G/xIz+9scWvNX0xtnUmin4OUnpfnIyIoiK9SggJvmztrKEvjwZV1DDNvYayLU4kwvO6qtln2+Gdt7f3X3yKgaLsJ6834jj5VFU6+A+6qi8QUF4untGIdiN8/539zCg/Y//Ut76DPjnClDfXbM/UZiL629MvhsAox2uJbTfyL/L44o1kRqKaKlf/p6t6fkAGI+IVqN/HKoPhv/0h06c6i6x2a92E3b4hRUX6krxCT+EiqDr5vupUL1reG1GroXiTl+UhmiJdoJlmZgKQWM1mVK3uBe0NRJO1k+csvLtWEFw+iNonD8l7722PL6e4dlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBc7LhUE5SPHAyUPylzINEdBWXYsyaXFwz+XV+FlD4Y=;
 b=fYZ/pT2haYjkjZMs0zAxAoZ+I0kwD4NybJNlMQTOBt6hf+NgncHeyZrz+zCKcjSqvvX/hf6clQIgfapW/cS9fLYL3fNfI4AOP/e57jSzY1b4CZa6gor91JnXuUw+NGqlvevXzcOTXYYWqszAfKF4g7LulGPFXo2SBbGYKEfIN/5IoOOIe8AwBBdOxwviD9mxbcflFR7GVgs/R6XRN5NY7waSOT2cYAAP7hRuaxs+2cjpM65tcqvRdP5FaZdDjL2jq5QH3dOq2rQ4U9M0ZlYlCCOHp5+9V8mGUaj8Zcdq3bM3dzVemWvG/IS4yKra5Qq233J8DwT9qdT+4Osg32X+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBc7LhUE5SPHAyUPylzINEdBWXYsyaXFwz+XV+FlD4Y=;
 b=W/t7/xOsgOMhJvZuPX/cY5YLq+WN++yOKBk4iy/zgHgq1rpGGLzYm/Okf/zLl/4EQ6jCtA1599w6r5hFzj2eYMcsKDc8bRg9Mdg9LOMPhYHXBk41U/w4ZPb8KyQN0Si4Y9U30sJIDLX4b3gxcQHbSFZ3nQx39fRo58+f7Lh82VI=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1241.namprd21.prod.outlook.com (20.179.50.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Thu, 5 Sep 2019 23:22:58 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b%5]) with mapi id 15.20.2263.005; Thu, 5 Sep 2019
 23:22:58 +0000
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
Subject: [PATCH net-next,v2, 0/2] Enable sg as tunable, sync offload settings
 to VF NIC
Thread-Topic: [PATCH net-next,v2, 0/2] Enable sg as tunable, sync offload
 settings to VF NIC
Thread-Index: AQHVZEDaXPUQsRVOwUmTVfCYB79oxA==
Date:   Thu, 5 Sep 2019 23:22:58 +0000
Message-ID: <1567725722-33552-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0082.namprd17.prod.outlook.com
 (2603:10b6:300:c2::20) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26af89da-e175-4928-749e-08d73257fcfe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1241;
x-ms-traffictypediagnostic: DM6PR21MB1241:|DM6PR21MB1241:|DM6PR21MB1241:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1241AC9B5C28BA511AC74F1EACBB0@DM6PR21MB1241.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(7846003)(6392003)(4720700003)(6436002)(66066001)(10290500003)(305945005)(25786009)(6512007)(8676002)(256004)(36756003)(8936002)(81156014)(81166006)(5660300002)(52116002)(4326008)(53936002)(478600001)(99286004)(2201001)(7736002)(10090500001)(22452003)(3846002)(71200400001)(6116002)(316002)(71190400001)(66476007)(66556008)(64756008)(66946007)(66446008)(14454004)(2906002)(2616005)(486006)(476003)(186003)(26005)(6486002)(386003)(54906003)(4744005)(110136005)(50226002)(2501003)(6506007)(102836004)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1241;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bmDmmT91m+1Fxs2ofh1aGqpX8ylaHlvT2cnucaS4RbW9aIhevUhZHbGlqSwWtJo0VHhGMSCjg6deM6f38En/g/on3+g+xLaJDb1UWkhrNg0x9/0Sbca9f0VZZBwRkX5GZybI8uum5HyrJv6EoRR7yZpXjEBsgfXgVTUuLvVuJfCIbP9Va3eRcnzgPz0LHbtWTr13nLHslORLdR/yW7r5JsXwyhsegA2MMH2UYNfiRFnMjfJeTeH4AmTKfa/okr+2aKqBGN8SjVOdZxOghmY3PEpNsp1tlvId8vrRHqz9e3qs76LC+mtUqqXaIVigopXZ+2YM1R/pAW7J87H7jtIfeRNeZHOOEpkbcPfDHgO1YRwISP3VohQjzxQv6pgmDx4agLq3qi2DjMiaTgUYlsundOZtpMBmsDe3XEMsbyZ3Ucw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26af89da-e175-4928-749e-08d73257fcfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 23:22:58.7040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/a6MxXueo8QSX84jm6Ncjko0eAvsBxdCC1DB3KiyUOJkYxQY6T5zoho75wJbsLNVjObRIS/Mnogwk2023Vflg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes an issue in SG tuning, and sync
offload settings from synthetic NIC to VF NIC.

Haiyang Zhang (2):
  hv_netvsc: hv_netvsc: Allow scatter-gather feature to be tunable
  hv_netvsc: Sync offloading features to VF NIC

 drivers/net/hyperv/hyperv_net.h   |  2 +-
 drivers/net/hyperv/netvsc_drv.c   | 26 ++++++++++++++++++++++----
 drivers/net/hyperv/rndis_filter.c |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

--=20
1.8.3.1

