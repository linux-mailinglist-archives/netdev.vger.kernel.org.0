Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA372CF79A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfJHK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:56:45 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730016AbfJHK4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myv3gkvG9oylDQ3885YN+riMdUWHMd6Y8pHxg+jgybfGbq7sIKQnj22LyHxsKEpeCJwkzOz8OsBdzJX2bY5ktrHI/6x8/OIG7vhKR4S8i3bwM9clL35w1+iQ4zIrg0ijKWf7PiP5nWQoiAzFjVfJJMKSsIZC6/gmwqgLuYg2/WYrVrrAr4/QpipUkUNxLv80kO1CAwoXBZ9I3XDP/AN9nWU1fHxx9/bvgnJt3X/BdkWm9FBrUgsbipkv7zfqlpff/AYvNJkTjL41odz2DbEWqrHnw5IqdKj0dldQRAtlZNURrdOOrRAc1qZ1v0wmuocV3YuFxVAWFdRpCSlfhshq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9hYHroulyhGTIUQ8EU0fIXDnC7xIi9Wi/OsvkELgbQ=;
 b=aTQ6yulBB5nJFAfIHEngWw1BgzzSv1WZ30rgwYvRPnxTcXlBPoGkSA1OMGbGrR6Y8QZpMT99b9oBTssGk9+PVEilkPTgFgk2gKqzM5/F5aYFbCWMqUgSde8tGwVXvFeuAd+QvzxXE1gjGm9h5emcf/ggUc93UoPxnB9lN8EDZDbHoRGB51VMaNyFwTrDwsqDuy5q/DFK7hFHTVZj6q1T13/7jWDaHqbWufoXuRKFwsM5hZR+QkdugOYllQ+1ZMq84OCiBlCcAQs7+hvpc6RA1v0gpK+lxqzPikhw4tuWUItM8EaqLDMFyRdpRiauVHhT0k4Hg/OXKIPqG+1NexAwZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9hYHroulyhGTIUQ8EU0fIXDnC7xIi9Wi/OsvkELgbQ=;
 b=pjEpp8R3MWIisgXi1x1Ouo9q0fh8GgENSR/IeQ/5PIBGnoQXwIrPWFcZyzkDT8iG1f+rZZrtpboIGaM0MN6PSDxLTkMnh00Qvmraxc4j/HU5MQgxpBmidCmvrsYQXDozEiBxD0YKHsF02IxvRrR30hzjBDMzYBYimmzYMNuuHVc=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:34 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:34 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net-next 00/12] net: aquantia: PTP support for AQC devices
Thread-Topic: [PATCH v2 net-next 00/12] net: aquantia: PTP support for AQC
 devices
Thread-Index: AQHVfccMcRm3gI8+aEqcGdQaLx7IMg==
Date:   Tue, 8 Oct 2019 10:56:33 +0000
Message-ID: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94992895-c076-4790-791b-08d74bde2ecf
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666AD997ABA0BC93FBC0C0B989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xzjoHXD1wXfKvROOuw0O03i1RvU0kmrwtlqtc+zJP+c4PQITXVldUFtiSlStIGnho2mV2gFGOs+aKOM7XM5bpyIADN18yxn+8kK2D+lZ45pMIX4YlINozx2uVcOs0BnGPRnQR+a4yp1afwj9rbVAL3pJpPXbijdpknSdUXBuuP9fspfKX/INK6nr+ylFPSwh8Y1W6MKajz8jQdLZxigyPJ8Km7Wdck3YrAle+/c5/LMNYser7C9W8I45e7XRpxMg71iXcNhxCJEPWLn558rKstBWrtI/aaFWk9X+A7aLlNIAELhMONxUnTEWFJzkWg/pm+9kNMgHA+jpN90HxCeqJvWUsHoYI5GHp2NTYtrw2cVrWexC01ygt+YzlFT3WNsTa/fTlGLFctIDMb167HPp+SXksZhLzODINn7ri2j6zS4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94992895-c076-4790-791b-08d74bde2ecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:33.9894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NO4fV+bo+JxLxUewaNBS0i4tX3qxLr9fZ3Qv/pChz8OmzgbbMCJv36J04mO86FFVa9pFVDUqT4E7zjL318E4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces PTP feature support in Aquantia AQC atlantic drive=
r.

This implementation is a joined effort of aquantia developers:
Egor is the main designer and driver/firmware architect on PTP,
Sergey and Dmitry are included as co-developers.
Dmitry also helped me in the overall patchset preparations.

Feature was verified on AQC hardware with testptp tool, linuxptp,
gptp and with Motu hardware unit.

version2 updates:
- Fixing issues from Andrew's review: replacing self with
  ptp var name, making ptp_clk_offset a field in the ptp instance.
  devm_kzalloc advice is actually non applicable, because ptp object gets
  created/destroyed on each network device close/open and it should not be
  linked with dev lifecycle.
- Rearranging commit authorship, adding Egor as a ptp module main maintaine=
r
- Fixing kbuild 32bit division issues

Dmitry Bezrukov (5):
  net: aquantia: unify styling of bit enums
  net: aquantia: styling fixes on ptp related functions
  net: aquantia: rx filters for ptp
  net: aquantia: add support for Phy access
  net: aquantia: add support for PIN funcs

Egor Pomozov (6):
  net: aquantia: PTP skeleton declarations and callbacks
  net: aquantia: add basic ptp_clock callbacks
  net: aquantia: add PTP rings infrastructure
  net: aquantia: implement data PTP datapath
  net: aquantia: add support for ptp ioctls
  net: aquantia: implement get_ts_info ethtool

Igor Russkikh (1):
  net: aquantia: adding atlantic ptp maintainer

 MAINTAINERS                                   |    7 +
 .../net/ethernet/aquantia/atlantic/Makefile   |    2 +
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |    4 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   35 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |   17 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   48 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  105 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   96 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   16 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |    5 +-
 .../net/ethernet/aquantia/atlantic/aq_phy.c   |  147 ++
 .../net/ethernet/aquantia/atlantic/aq_phy.h   |   32 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 1397 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |   57 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   64 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  328 +++-
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |    9 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |   96 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   58 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  223 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  172 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   97 +-
 24 files changed, 2895 insertions(+), 134 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.h

--=20
2.17.1

