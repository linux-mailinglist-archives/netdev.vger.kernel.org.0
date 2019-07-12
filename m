Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D6266815
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfGLICk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:02:40 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:39331
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbfGLICk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:02:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgRnM+J1eDw8S2/zzFmWwYux60+LqbPWSPUYt3s76BeZE+s5NNiySEwB8i7XPsUpguOb9tPvMGihK3KK546NYJUwxSXkhBBOrF80nsFr5jsl7/EEMkkwlKaQJ/kg6fXcVjt2tB5W40LWmQKJgEbFE4mS4dmJKUG1HHYJB9hg7b/QVON39qq0e4EcWqXE1OOG4ZJ4oAOz/y2+mINJDRUckkVDl8bw9UIxSme+ZS8SXCgRr2YtVycMPaHYleLwiUI+AXu6QdxiUbsy7snBNXn48yIXzinLIFqjjvvSj8nmQsnzmGqoUvfE5CiKdCMOyuNjNb7GS8uq+O/4VqFo8Dz67A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=697k/cUOJCUOmYjU5aDdBHCnJjoUoJ0T2UgjlD2RmoI=;
 b=dh2p0bFV2OIdoHnCm2om+BiGeJBw1jGu9ed2fG/9L/AoEIyZyjyZCqdnP2yZzuX5DUvsUrY/W0uCj/PrjFLClbfTvy6Zh9fW2D/YWCjkMn3C9sjZ3io8unGNK0k/7w2HbhYoayQek+Xk1g0Lo0DY6TkwQMXu9nuqYQwpZsxQP96SKBLof3HptRb1sJPE8UHg1ZfVFn9vSwe4m2S+nSynRQjBi+zfIJj7OjZBaiaGJIqMnGv61JrHqI8vUx/ChzgJ6QwTrBlWJoMcjbsMRpMZm17LB2tKAN8c/9PTan9ZuMkfpmzMZCvkGkrklxx3uQDzZ89UxvYmF0G3bNM1evkB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=697k/cUOJCUOmYjU5aDdBHCnJjoUoJ0T2UgjlD2RmoI=;
 b=nAC/bgRiqWqRaI1R+xiaBzwDBrmYA2TrbocOx6yAS8fhjmQEJ99Wau4jqRMO3oq/QDqylJCgEZAf0Uj+2zmE7AUvFT27Nhfnv1t3yIoh/NbveHgJVg25H4Hpp54zzfU2/C0waUBQZx+kzNlSWbloRjaTZS60QiwUi0/HwV00AHw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:35 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Topic: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Thread-Index: AQHVOIgqonFULiHPO0eSKFSJ3ULGeg==
Date:   Fri, 12 Jul 2019 08:02:35 +0000
Message-ID: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a23544b-24a9-4b15-6043-08d7069f4c89
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4889;
x-ms-traffictypediagnostic: DB7PR04MB4889:
x-microsoft-antispam-prvs: <DB7PR04MB4889490763C653FD74F4AB09E6F20@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(50226002)(66066001)(2906002)(71190400001)(2616005)(476003)(71200400001)(8936002)(25786009)(1076003)(478600001)(53936002)(305945005)(2501003)(14454004)(486006)(7736002)(6512007)(4744005)(36756003)(52116002)(8676002)(99286004)(102836004)(86362001)(256004)(5660300002)(14444005)(81156014)(81166006)(26005)(64756008)(66556008)(66446008)(66476007)(386003)(6506007)(66946007)(3846002)(110136005)(4326008)(6116002)(54906003)(186003)(316002)(6486002)(68736007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2pbYbHBEKW9KIhl+C88TeUoagM9LU52GtSWKjKWu4B0JAwpMLM7qA0See+TievsU5FUGIwHeE3wxWVR2ySC+RA4teCMXHCJYboVEXvUk+YOM9S9Rhp6drY5tmB2i0/GFlyrw6UZx4lBcEz1vu59xj56PX6COfSUDJ2kggWUad1ivrdXG9fjaxVRJ4/AX/xJoul/r6xz/SHXxaxrCJkhAHQnwmqCCcnTtUDDKesJX33w034ElqvgUzuAX0NvioxBsDsTxorRYQUgbuRvWOHZmp+dKCCbkXmLDuKUdRKLsOCuwF1ZBohRyqLDWkoIoxh7qXhmKyrkYrQ7BNY/z9zHHc/SX94LA7bD8f5w7VGCsHeBvpD28eDcJzrKOkWWmTvwCVI9PbgkcsHIgLNUcvLuwEs3NW5ioFwGHm+MIV12u8zo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a23544b-24a9-4b15-6043-08d7069f4c89
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:35.4330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

This patch set intends to add support for NXP Flexcan CAN FD, it has
been validated on three NXP platform(i.MX8QM/QXP, S32V234, LX2160AR1).
After discussed with another two Fexcan owner, we sorted out this
version.

I hope you can pick up the patch set as it can fully meet requirement of
above three platform. And after that, we can start to do upstream about
CAN FD.

Thanks a lot!

BRs,
Joakim Zhang

Joakim Zhang (8):
  can: flexcan: allocate skb in flexcan_mailbox_read
  can: flexcan: use struct canfd_frame for CAN classic frame
  can: flexcan: add CAN FD mode support
  can: flexcan: add CANFD BRS support
  can: flexcan: add ISO CAN FD feature support
  can: flexcan: add Transceiver Delay Compensation suopport
  can: flexcan: add imx8qm support
  can: flexcan: add lx2160ar1 support

 drivers/net/can/flexcan.c      | 340 ++++++++++++++++++++++++++++-----
 drivers/net/can/rx-offload.c   |  33 +---
 include/linux/can/rx-offload.h |   5 +-
 3 files changed, 305 insertions(+), 73 deletions(-)

--=20
2.17.1

