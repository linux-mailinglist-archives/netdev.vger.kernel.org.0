Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88019ADA13
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfIINik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:40 -0400
Received: from mail-eopbgr770043.outbound.protection.outlook.com ([40.107.77.43]:63806
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfIINij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWx5GSO44aM+yKkGz6kdBqtFrpg4vExBVoRE/PmD97uV/6LrLT+bhWsfRKUlsSTm4HjkVlGRXYz1xumUxx6XXDtrgyf3W4hcjBZJDK6fvJJb7VqXUWZ95ri0RJBCS7vBVT1KIxWZKNSOWE8WXgs31v4XbDdT0vKDHMnolSs9PsJNvZ0moXWqbFEsLo6Ysn+L3bwmInogLTH+e0hlALHkGyg4fNo6ypI5LBkVzOpBcq+ykoWXxrWG+m2n/nJvyhno4R8zpDL/msoGJ9Nr6Ej20bQG8PcXImF2ZBBELCpuRfYiwGE8BJoVWJIViynsvjCLarScx5+9gSqVaaRbg6JkUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xfL6BAm1trTpCFpmmD7f5o4PrNKXDDYO1XJsW/Oe9Y=;
 b=MbOHK4ayAOHslE6oy1nnuHecoOWwhPOqaPrrkjQpBmmxGozCW7lOfeLnlAsYjhqbBEEhFoU6kHtP+TJ0ecwITDbVGP+wmkTpNPhdxTNbIL0zhoDFWACam0fb9DFgnA2VW47OvjnvHuVaKUo4ZntTVnpGRxMq7YxVGWFmCW1PtE0RsPHSCBJjs5fbvb+pzLqFTzI1MYh95u931X8sN3LddUdtnslQGfA8j8o/UCY+2nBQPyd5j1gJUJawvbef3eCSP+Jzsnmm1quQQE0uYI5v+klIFjazm5hGbGTtNXUKzRTxYXBkmX4GwOYgdKx7sDnPexL59HtP3XVj8mYmUiA2ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xfL6BAm1trTpCFpmmD7f5o4PrNKXDDYO1XJsW/Oe9Y=;
 b=Ml9qwpujWq9UUdFMRc8dddsIdxjmtTeAh0RF91CfRs5scOgIjG27MMHy8YRQUyF3Ni472Oq4QGnP0Qrdd3sUeSB0ttE6lNChaw5YJXdgA44FaZ41wmFzn/S/xcNBXYkP0kX+v5ZlX7n/9NVWd+FikxhrEAP90S7DHCgGdCBYOiU=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:38:35 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:35 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 00/11] net: aquantia: PTP support for AQC devices
Thread-Topic: [PATCH net-next 00/11] net: aquantia: PTP support for AQC
 devices
Thread-Index: AQHVZxPhmNEeO1mq/0GCxM3peHRP+Q==
Date:   Mon, 9 Sep 2019 13:38:35 +0000
Message-ID: <cover.1568034880.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0298.eurprd05.prod.outlook.com
 (2603:10a6:7:93::29) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6ef7cc5-b3bd-4e4a-c33d-08d7352b0384
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB174759BBEA7D10F6E6450ADF98B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39840400004)(346002)(366004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(305945005)(99286004)(5640700003)(14444005)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(4326008)(8676002)(86362001)(52116002)(66556008)(53936002)(186003)(2501003)(6506007)(386003)(476003)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7uVT5+8o2Slz/9dvWbvhHitL7B1a80EWokEuThDv9SPlSiuIVevfF+h36jaBdMy+E43TPbjpYb0BOY4XWusySKGlo8srv2wbFsu4lFJZtm279t3wmM0QBabghTC+ngEnYyaU2V3mfh4vbN5PzlgrUin69YxzuPuJvtQUdodiPpcz4/QVE7oUKfWHHb524kWvmg6wccPpztoc1NvPjj4C98G/1QAsDl9tJNg65nkuVvBIkQowNEzeyQM1dTi4Gox5Hw6DnBcwrlDsg8V9Egko/5hApIeDm7conJSDlmJFnZ4LA2AtAXEOCXtRqvj4rlzHu9m8vej6jnIJLUjnP5/ri2P5whYbz6qwpFhQaqgb6qfxIB6K0lQH50m2oXdtU3fq/cDWqx9GS29FJoUEksBROlY9LArBNy6TvveXIN0hLYY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ef7cc5-b3bd-4e4a-c33d-08d7352b0384
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:35.6152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8xx4Crc6hGWEbnign8SI1mPYoU6hgbb5DFGPThoBc6BZU2Su+gRFiRUrNqMRlixJRNZk/IfMbwfVIP0088HXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches introduce PTP feature support in Aquantia AQC atlantic driver.

This implementation is a joined effort from a number of aquantia developers=
:
Egor and Sergey are included as co-developers, Dmitry has implemented
PIN control functionality and helped me in the overall patchset preparation=
.

Feature was verified on AQC hardware with testptp tool, linuxptp,
gptp and with Motu hardware unit.

Dmitry Bezrukov (11):
  net: aquantia: PTP skeleton declarations and callbacks
  net: aquantia: unify styling of bit enums
  net: aquantia: add basic ptp_clock callbacks
  net: aquantia: add PTP rings infrastructure
  net: aquantia: styling fixes on ptp related functions
  net: aquantia: implement data PTP datapath
  net: aquantia: rx filters for ptp
  net: aquantia: add support for ptp ioctls
  net: aquantia: implement get_ts_info ethtool
  net: aquantia: add support for Phy access
  net: aquantia: add support for PIN funcs

 .../net/ethernet/aquantia/atlantic/Makefile   |    2 +
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |    4 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   35 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |   17 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   45 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  103 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   96 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   16 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |    5 +-
 .../net/ethernet/aquantia/atlantic/aq_phy.c   |  147 ++
 .../net/ethernet/aquantia/atlantic/aq_phy.h   |   32 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 1396 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |   57 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   63 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  318 +++-
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |    9 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |   96 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   58 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  223 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |    7 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  172 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   97 +-
 23 files changed, 2871 insertions(+), 134 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_phy.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_ptp.h

--=20
2.17.1

