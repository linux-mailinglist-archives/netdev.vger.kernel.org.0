Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C6E7AEB
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390271AbfJ1VGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:06:51 -0400
Received: from mail-eopbgr750117.outbound.protection.outlook.com ([40.107.75.117]:7891
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389764AbfJ1VGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:06:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbEGSbGBwaVR6untkf8uJV6G4EqhbrwZcxR6jzZcalQInxwTNRQSseU4bIKkSKSI3e8dzr7RtTcRCcPSQltLRO1lnw8s1Qxzgi3awSbVinJr0wXJs9IsONEsbHVSbFmQ4xbIf376Ro3d/Y46Xdk7cHHPVJREHvfj8Xhw/ldiITLMl+zoPcREme4ZnoT9xtzEyXNl0H2uUVWZnd5sTyBjVCmtIh6S+W70HUaNfHkH8nwb23gJiVq4gPhPVAZmBFUsm984bwt50Bw57StHfUJ8ia5paY6p/jd1cMxMu4qCZPZ7NIIlK/nKzieEh/rDoJKaaOyWJEnvvjnPs2mpDVo0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMQHH992GH6xm7PefP3WLRh4uhfxzuoIrpD1II7fCHU=;
 b=KjOVWwQhYgvEyI/nWGo2TfiHfPoOJBaKuDT0jgtO7HhnoSYMT6Sl69ZkYglUhauFusmIyCUPDN2Rh8EOpTGhhxJtbjxl9WMUqSwqW1dSUbzsNM/BMwhXVFGoJ/cCPiVctKyd33/w1j/9RPbPjUSPiqbaP++tpOKWgR7b0Io20vzZAnuTfKGNxT+gWP8AfN50v+HqM8nl83nKExE/ncjWJ1nXEcy475ke5EU/98Y8QxlXQx0qNJq7YJME24g0Qpt10a1mOVfOXbAVfp1R084GtbJE151BpB83fERTYTnKcjjisHdtLMWut7vRJb6GQuS2dmzkoN4eAAyOQpJoUyFZxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMQHH992GH6xm7PefP3WLRh4uhfxzuoIrpD1II7fCHU=;
 b=FZToOhpqg4oo1fjAAPe4KTW9tmhM4a7sds2ZwmVoryH8rz7nNY2h+/+LItSa9hIR1/+sdhLIgQgOiqD8e3BViaLg/sAh3vezHtG7QRpPKwDPCtFhSawvyL2QKW7rUjFGBC1ALOVBnvtaDbqMGwgGBRiB43RWH0QL/zMZU6dJpL0=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1404.namprd21.prod.outlook.com (20.180.22.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:06:48 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:06:48 +0000
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
Subject: [PATCH net-next, 0/4] hv_netvsc: Add XDP support and some error
 handling fixes
Thread-Topic: [PATCH net-next, 0/4] hv_netvsc: Add XDP support and some error
 handling fixes
Thread-Index: AQHVjdOcwPSvQDuAFkynC/HiNk9eug==
Date:   Mon, 28 Oct 2019 21:06:48 +0000
Message-ID: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:102:1::44) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a56b86f-245f-46d8-4087-08d75beabece
x-ms-traffictypediagnostic: DM6PR21MB1404:|DM6PR21MB1404:|DM6PR21MB1404:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14046413FE5ED57964733B84AC660@DM6PR21MB1404.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(6512007)(4744005)(36756003)(54906003)(50226002)(486006)(22452003)(2616005)(476003)(305945005)(14454004)(478600001)(2501003)(6392003)(66066001)(7846003)(66476007)(66446008)(64756008)(66556008)(66946007)(10290500003)(6436002)(386003)(10090500001)(102836004)(7736002)(99286004)(52116002)(5660300002)(14444005)(186003)(26005)(6506007)(256004)(5024004)(8936002)(81156014)(81166006)(6116002)(6486002)(3846002)(4326008)(8676002)(2201001)(316002)(110136005)(25786009)(2906002)(4720700003)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1404;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQWEy85z6s2XSYoeUoDrdY8VyEbMO46slAPFHpD1CwPtAMcTiHT2JD1PvkFS5nGaQ9Ml/cVtWnL3yBqVhGtqBMOuKXjCBBmRs/vMaslVn84gENPe8BBzo625nUwY0ysb3Rs5RTTPCA79DGZ940Zl/CVyvwcsGZiYHEovedr0dwNDFYI6tJRRnXChRtD8cT2GHklx07ZT/iy+9MH5tEOS6to9k6NiTr4Tw7e5Beb4OUigJZl7W8RQjxpPkghR0TEDi7zWZhynkwaCN4uz1NYyPF+POTNr2txb6gk7MIsYHpUBVqIaVVxsKClog0XmH9GLRG4tWCZuYyii5TyHqI4E+Zmgp+Yw2ckz+enx81SOu5UaJRj2XwnRvACiiWgCknaT96fdmTuufVqWFRngY2RaE+tOJ/a6njcr601FJdm4wYiVdIVCGk2Tqz3geF5XTMZJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a56b86f-245f-46d8-4087-08d75beabece
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:06:48.0176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VE6fkoSvQz96pacajjniyVqUL6mvF37YPeFMNM43tnperl7AesJY2wKCeptO1zB5EHaY/2AAQInHH01Ha4cuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes some error handling issues in netvsc driver,
and add XDP support.

Haiyang Zhang (4):
  hv_netvsc: Fix error handling in netvsc_set_features()
  hv_netvsc: Fix error handling in netvsc_attach()
  hv_netvsc: Add XDP support
  hv_netvsc: Update document for XDP support

 .../networking/device_drivers/microsoft/netvsc.txt |  14 ++
 drivers/net/hyperv/Makefile                        |   2 +-
 drivers/net/hyperv/hyperv_net.h                    |  15 ++
 drivers/net/hyperv/netvsc.c                        |   8 +-
 drivers/net/hyperv/netvsc_bpf.c                    | 211 +++++++++++++++++=
++++
 drivers/net/hyperv/netvsc_drv.c                    | 150 ++++++++++++---
 6 files changed, 374 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/hyperv/netvsc_bpf.c

--=20
1.8.3.1

