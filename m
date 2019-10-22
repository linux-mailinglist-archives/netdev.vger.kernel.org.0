Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC8E012D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbfJVJxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:25 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:64688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWHUQ4jIfoGw/jAPb1orLJA+8E0/IuE+pCXovO4oxSdFpMOdsebr52rB2Wfm6WSRsvkNgtc03FOCOIb4iWwirZzZlbgpov36S5WgAIshZ1IYDBXBZmUJmpYp8kq7Z8JWwE9hP9TrwQ/eDOpbDpvK2cBA1TUXLUkOnG5yvyhm5HM2ov1tRt14bIj98zS4YIY9BHWMV7loCjVDdhC9tta5SYoO3yFdC5Ig5FJCmFzf9XrfqaajEIJK2fXP8MhI9D98WSGbg0DTWndlh50CYgGWh7i1Qkyfne9Px4bKAB9EXJFevgC91LZi7I+9i7mR0oGQkLshlIycNnj8e21brIysBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUyOEs0EO5g7n01amkQ2CxLKnMJpKqZio38ll/UVMrs=;
 b=Tq6vBpgqdl7ohSLG29oEEev+P8qTxlBPCcYllPhuXxFfob+eHBtHQA2gP9q+5U9H+nCuJ2XzVy2OzxiREBq27I2kth/4ewElIQfY/opo1ZhBsscK4ePLaOxsDUZcb1dc+M01dGg8z7BpKAjbw+KIGBDJ101V9bUlxFFTYgyenNAkhtWjM3ppNYiV1EFvQxK6KgTisA4wVddRrQ7dtJfLy5g/onjleeXn6egH3rTrbbq+7zf/2LBfLFUcnOajaExzQ0alUr0BRtfo8Utnu0i+W/0BABHRQVjwAg+f15GKZ2+HHidBEy1veWAHhuuT+o38APUq9rQFOUVaYmAeVnoYFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUyOEs0EO5g7n01amkQ2CxLKnMJpKqZio38ll/UVMrs=;
 b=GhmcuTaZ7I/a6bvtad1k2g3gIfenGbcghCC0Pn6633q4hl4grXDsPbBdmKqH/NNdQiAuBjLMAII096S8yMAOrzaW0fI+RWPEImEE199SKOdfcGTErUiQta4/WULMlOy9yGSVnoSyjb0+thEPdn6KAvqWs2w4Yt+vlobmGCZRpDs=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:20 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:20 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC devices
Thread-Topic: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC
 devices
Thread-Index: AQHViL6JpaiqbV9+r0Kgd1DtsoK9Ug==
Date:   Tue, 22 Oct 2019 09:53:20 +0000
Message-ID: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de122713-4fb0-49d4-a6f6-08d756d5ab5c
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37325E62E80589AB94BC5EA598680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(14444005)(256004)(71200400001)(3846002)(2906002)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWxfJ4BJjwGrF17d/bTONSIKuPaNzy3TgjHkKxg6UEpRPz6esZgteoWLV4JzZnGksOZSrLtv3OZLh3EbZ2LvDwoh4nqbZZyu0R3WWp0d8nxF6UkbhlmwhuVIMQD50Gft5lJ24m/vod3E1f6YpG+4QLEjBakTJdsEFcaqEszJVl6NND8DjpxmPUssegnpdSuSvMrVBxu3vOvWIPiYqj23YqLhVkhXGtvjy2V4jv4JFX0uQOnW6NOCGOMdb8o4B5YhPTWfVyr9OHGq/siBKutKZpgpBb1znTL7LXmWdajErrQpWwWWIogrJ/u9HJFv9dEMk6xGqmIPE/rFtWXTDuTfQ91vICkPujfOJr9YezLWp2VoThLds/Ctj3TFMbsok1NZ7KvZkHtfP+rhklU8HD7XFfqeeN62UOJZQp/JgCaQdRfxhB3QgLBFDE227b2hB5Bq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de122713-4fb0-49d4-a6f6-08d756d5ab5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:20.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8oeKQF7AHess0CdL7SjZIJ+QsW8mvgPc2GVWcGjXKcHqc6VoQC0qe2X1/HCwo1MAhNR0lUrnxoYRrJWpwMzCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
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

version3 updates:
- Review comments applied: error handling, various fixes

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
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 1390 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |   57 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   57 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  328 +++-
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |    9 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |   96 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   58 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  223 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  172 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   97 +-
 24 files changed, 2881 insertions(+), 134 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.h

--=20
2.17.1

