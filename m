Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05199E7AD2
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbfJ1VF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:05:58 -0400
Received: from mail-eopbgr720106.outbound.protection.outlook.com ([40.107.72.106]:61027
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728898AbfJ1VF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWbaYZXUAHAePcHlzoJAdCTi9p5esULjEN7Kg7ZzGDKvgqjCG+vfFbw4ntZcyO01zZoEZbdUQAEAduj0Bio7DL7n+7UuZOxl9ZKrndYWDlIDeOaAOdA1JyqE2uIYj9YqugfRUebNt1nYYyqlHhd7g2w3IzqtJdevgvr2OnNkDBIx1z/WXxGAXTfdBx1r9mJpXlry6O4c2OalF+KA8IRPMd+MoNBv/b2N3M3Pq10EKPvsLP99tFsJvgACO6PJ9iVc6M/6sNJvr3eEtXs94jNjFRVKKRiek7atP982APVzqLMtGkvhPrO9flHPI4nY58jVAtzSevY2a4yWs2ZyGmroWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMQHH992GH6xm7PefP3WLRh4uhfxzuoIrpD1II7fCHU=;
 b=SS22IwFBu0hUdtXQvGIX6sp2d8NCoT+QJgUViKJMIB0KTdAeG0r9GfA6N7/ImjQ6AVp3OXp1D50D9fH2PXO+rzgFItfkAP9VyCOWe32kfwjYVrUl4E3UN7SHz0O4itkEEb+dmjusXiz/Cn3TxJqh7c0J1/PyKADBVTOPTa/YrBRtHihqv8CpUTsRAQo8lHFo07i7AGP85/oVaVzHkEwwmetqoQvTf6tbIua8qaoeNNOrjdEGgxwl4EeRq8+Crtx36OTbqYFDGiNT5gNsp7gzs96CZHRcgwG0X+gBAgiV0rizX6msVtGhPL7S4hUlnucf0YXlKCBjXFKNEpca6+Fmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMQHH992GH6xm7PefP3WLRh4uhfxzuoIrpD1II7fCHU=;
 b=Pdz/q+9OxcdgRPo+wLFISnw0l7+tJhjPYtZoPP/RiB4d54Z10hGPdkhZ/aM5AE8HFWgpuYhgVWByBEBShzyT2snSu/z/kdekdO30wk5cID1ZlF8Vu76ZCIlDsmgGb2ppPisqeJDOznP8K79rvDdz+dmwZscrsIU/v38/dVBCBqg=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1291.namprd21.prod.outlook.com (20.179.52.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:05:55 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:05:55 +0000
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
Thread-Index: AQHVjdN8XpVK0YFZh0GRTvA7dQ24Yg==
Date:   Mon, 28 Oct 2019 21:05:55 +0000
Message-ID: <1572296693-4431-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f340c248-fe83-4a03-7952-08d75bea9f2e
x-ms-traffictypediagnostic: DM6PR21MB1291:|DM6PR21MB1291:|DM6PR21MB1291:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1291ACB9509B4C0FE7D32306AC660@DM6PR21MB1291.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(39860400002)(376002)(136003)(189003)(199004)(8936002)(26005)(10290500003)(5660300002)(256004)(7736002)(186003)(6116002)(10090500001)(6506007)(25786009)(386003)(102836004)(305945005)(71190400001)(14444005)(4326008)(3846002)(6436002)(36756003)(7846003)(6392003)(81156014)(81166006)(5024004)(8676002)(6486002)(66066001)(6512007)(54906003)(478600001)(2201001)(71200400001)(110136005)(22452003)(50226002)(52116002)(2616005)(4720700003)(14454004)(486006)(476003)(99286004)(66446008)(66946007)(64756008)(66556008)(66476007)(2906002)(2501003)(316002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1291;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7tiUchZFI0K+Qs0EKtQSrxPsl6RX7up3hD4pfIGCizN26cDFmMbmDeNk0dGklBEBQ1qrhJcO56p2EkFo+/30IZ7uFYhu2bFPVeXiSRiIto5eCC2cNlzyUO3rNmewlSAQeJn4PIBmK9mYGmuQZKA3gaJuHpPO0NMKPJGZI4FTlcke7rlKmG54bYbAggl2Zx4qDIPHimeutOHeFJCPoOzfK6wiN+bLuBFWp7K1DnlowmJ2ePFv8JcLEYS1rsTNtPHgRMIan/N5rF6rfeiW5WGLGNJgrIQoiBfG7guMoNDfe+kk1xRQW5sVcyG05ksjFNGLrgd9BYQDWbRGfBk6vheZ/nSIf4tvu0BNYpGNqKZlzG1pdnLbiE4I69R5YmuoW9nBP4LeWM3YJVnpZK0U7yTLR44iRPWCQHbr2y9jnnhUZzly+hkw8GEGLgidurK+S+AD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f340c248-fe83-4a03-7952-08d75bea9f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:05:55.0480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xz9xXICF4Ktzm+hFA8oR1wjppMEhCCWG6u2sY2treulsHrzE1wH7walR3KjHAO/c4RyKSKzp5dgD0BTW5CRzMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1291
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

