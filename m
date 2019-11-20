Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26570103AA4
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfKTNFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:17 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbfKTNFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX6n8eDxKniTd1J+sqX8mulPyJblMmZasswWL0EQ4XwhdchqnHxYlyNoylNM8SiSgntkBG3/VcIrreQE3k47uacEGrttro5Rm0tOx1dMP0xxJ0LVcuIKJHuFlBeDD+2S69jryWUU3XsGWO6IhhGrTHDntw1o79M2PX0qKmIP3NnGhFIlkgyAN+WAmEaGUAeXLR5fCsTmE01K0HBIYzLdyyFxuPsfm2C7HkbEb2WnRIWvsodmi6SsV6NNPzcEUhCCxxVP8vltTMKiTfQE2HzsVtavNFzo7lRAgbPLE0nCUB2tjYq7tQG3ldvt2muomInCpsCN/K0iYchFvspElucZDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6qv94OMgAsXL0Qa6dEVHpIIN3he7aRUDWUnHqJNoKo=;
 b=mXLcz7PTd2E+T5jtc9l5Gsl9paDiIACZEfKixOAwr/Yt9Ah5vmcWg6ivf/kfw93QpbsAM1oAButkPAYNwIj8qyK6e7b+MvFKi6g6UZwNk0yQuXxUlSJ4GeOiplmpkMl2w2e3IeronBn2NlRnpqI2SUmuE4UQnG+X8pnWKkiJGg8lPCyWFRMnZomqA2OC3OehRtN+wD67rkh48zc49jW3B9iX/AF/jDRQ6/YP4P0PpsvbjG7DaXPCeBpw24pfYDXIZgtGsb6cnzQEehEDkZ12WboiMffirt5xwIJyblQQJxWye1l32vg99kAPlZmaVms1oJac5yd0Zu5aE4RNrV70MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6qv94OMgAsXL0Qa6dEVHpIIN3he7aRUDWUnHqJNoKo=;
 b=jxsSqwyKEMTEVQu4DoHJ0pIimsHHv4z5E+nzAfWEKGZYsPir2PRCejz496kWSMCpjHr/0EVH3L4/n05Hnp3FaB1lvuJWAcD9P53f9PAtX3/53QRw7seS3ANPKWPSPbCFAoTOQqaJdU2OV6fOUS3UDI4OdvPs25T5jfnIc+hu9IQ=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:09 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:08 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 00/10] Add a new Qdisc, ETS
Thread-Topic: [RFC PATCH 00/10] Add a new Qdisc, ETS
Thread-Index: AQHVn6MipeEL1zH+9Uqkum7uhiStHg==
Date:   Wed, 20 Nov 2019 13:05:08 +0000
Message-ID: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4204d49d-0d73-4527-f1c0-08d76dba44fa
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982F716D595BF900F7C9986DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(43544003)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(14444005)(5024004)(486006)(6116002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0RZdBVfKW/tkSCbKmm0Rhjdw5KfKmWqTHi4O5ciSFC7PtFXQ1ioHZrOF8KOYcnlLUVga2rZ4EtNf21hvjLznXnr4Pi+W2iAHUh/fciBi3VHMcdiDmP7RLbHl5QRkOtpsiZmpudPpi5X9mxQfB1yLk7ZbZrk7c1Jlb8cjIBGn4s36DQcKlc0s8bhJRe0VNZaujyhsdkOmZTnj33KtNhB1e+1ScJZGeoWvNIyw+HSF7ez1EUHTY4SxzZpHkdA+1KRJld0DFg+Kk0q40A5tUVOfkcWF5fr91fftGpsswIY/8E1M91/bFKPDOzkAtkyvqnbrcwyFyeKe1fAgRoAcmZ402yNcYywad80dMX99giJUE1X3qXMn1qCgJwPdcV4XJW2tp9SD2KaonPOtmJPuBoS1BP79F0OWjxFPHZt0WTVHXeHFY65XJC2hooCE4UvLRwf6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4204d49d-0d73-4527-f1c0-08d76dba44fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:08.7704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2gyyso988HyjjDDObDQUU4WPT77IsCU3gFxu1N2/HzpGdiCTkxa0wIxivoVMERk7UgsN/Nv9DPxnKaQo9AFIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
transmission selection algorithms: strict priority, credit-based shaper,
ETS (bandwidth sharing), and vendor-specific. All these have their
corresponding knobs in DCB. But DCB does not have interfaces to configure
RED and ECN, unlike Qdiscs.

In the Qdisc land, strict priority is implemented by PRIO. Credit-based
transmission selection algorithm can then be modeled by having e.g. TBF or
CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
placing a DRR Qdisc under the last PRIO band.

The problem with this approach is that DRR on its own, as well as the
combination of PRIO and DRR, are tricky to configure and tricky to offload
to 802.1Qaz-compliant hardware. This is due to several reasons:

- As any classful Qdisc, DRR supports adding classifiers to decide in which
  class to enqueue packets. Unlike PRIO, there's however no fallback in the
  form of priomap. A way to achieve classification based on packet priority
  is e.g. like this:

    # tc filter add dev swp1 root handle 1: \
		basic match 'meta(priority eq 0)' flowid 1:10

  Expressing the priomap in this manner however forces drivers to deep dive
  into the classifier block to parse the individual rules.

  A possible solution would be to extend the classes with a "defmap" a la
  split / defmap mechanism of CBQ, and introduce this as a last resort
  classification. However, unlike priomap, this doesn't have the guarantee
  of covering all priorities. Traffic whose priority is not covered is
  dropped by DRR as unclassified. But ASICs tend to implement dropping in
  the ACL block, not in scheduling pipelines. The need to treat these
  configurations correctly (if only to decide to not offload at all)
  complicates a driver.

  It's not clear how to retrofit priomap with all its benefits to DRR
  without changing it beyond recognition.

- The interplay between PRIO and DRR is also causing problems. 802.1Qaz has
  all ETS TCs as a last resort. I believe switch ASICs that support ETS at
  all will handle ETS traffic likewise. However the Linux model is more
  generic, allowing the DRR block in any band. Drivers would need to be
  careful to handle this case correctly, otherwise the offloaded model
  might not match the slow-path one.

  In a similar vein, PRIO and DRR need to agree on the list of priorities
  assigned to DRR. This is doubly problematic--the user needs to take care
  to keep the two in sync, and the driver needs to watch for any holes in
  DRR coverage and treat the traffic correctly, as discussed above.

  Note that at the time that DRR Qdisc is added, it has no classes, and
  thus any priorities assigned to that PRIO band are not covered. Thus this
  case is surprisingly rather common, and needs to be handled gracefully by
  the driver.

- Similarly due to DRR flexibility, when a Qdisc (such as RED) is attached
  below it, it is not immediately clear which TC the class represents. This
  is unlike PRIO with its straightforward classid scheme. When DRR is
  combined with PRIO, the relationship between classes and TCs gets even
  more murky.

  This is a problem for users as well: the TC mapping is rather important
  for (devlink) shared buffer configuration and (ethtool) counters.

So instead, this patch set introduces a new Qdisc, which is based on
802.1Qaz wording. It is PRIO-like in how it is configured, meaning one
needs to specify how many bands there are, how many are strict and how many
are ETS, quanta for the latter, and priomap.

The new Qdisc operates like the PRIO / DRR combo would when configured as
per the standard. The strict classes, if any, are tried for traffic first.
When there's no traffic in any of the strict queues, the ETS ones (if any)
are treated in the same way as in DRR.

The chosen interface makes the overall system both reasonably easy to
configure, and reasonably easy to offload. The extra code to support ETS in
mlxsw (which already supports PRIO) is about 150 lines, of which perhaps 20
lines is bona fide new business logic.

Credit-based shaping transmission selection algorithm can be configured by
adding a CBS Qdisc under one of the strict bands (e.g. TBF can be used to a
similar effect as well). As a non-work-conserving Qdisc, CBS can't be
hooked under the ETS bands. This is detected and handled identically to DRR
Qdisc at runtime. Note that offloading CBS is not subject of this patchset.

The patchset proceeds in four stages:

- Patches #1-#3 are cleanups.
- Patches #4 and #5 contain the new Qdisc.
- Patches #6 and #7 update mlxsw to offload the new Qdisc.
- Patches #8-#10 add selftests for ETS.

Examples:

- Add a Qdisc with 6 bands, 3 strict and 3 ETS with 45%-30%-25% weights:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 4500 3000 2500 priom=
ap 0 1 1 1 2 3 4 5 0 0 0 0 0 0 0 0=20

- Tweak quantum of one of the classes of the previous Qdisc:

    # tc class ch dev swp1 classid 1:4 ets quantum 1000
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 1000 3000 2500 priom=
ap 0 1 1 1 2 3 4 5 0 0 0 0 0 0 0 0=20
    # tc class ch dev swp1 classid 1:3 ets quantum 1000
    Error: Strict bands do not have a configurable quantum.

- Purely strict Qdisc with 1:1 mapping between priorities and TCs:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 0 0=
 0 0 0 0 0 0=20

- Use "bands" to specify number of bands explicitly. Underspecified bands
  are implicitly ETS and their quantum is taken from MTU. The following
  thus gives each band the same weight:

    # tc qdisc add dev swp1 root handle 1: \
	ets bands 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514=
 1514 1514 priomap 7 6 5 4 3 2 1 0 0 0 0 0 0 0 0 0=20

Petr Machata (10):
  net: pkt_cls: Clarify a comment
  mlxsw: spectrum_qdisc: Clarify a comment
  mlxsw: spectrum: Fix typos in MLXSW_REG_QEEC_HIERARCHY_* enumerators
  net: sch_ets: Add a new Qdisc
  net: sch_ets: Make the ETS qdisc offloadable
  mlxsw: spectrum_qdisc: Generalize PRIO offload to support ETS
  mlxsw: spectrum_qdisc: Support offloading of ETS Qdisc
  selftests: forwarding: Move start_/stop_traffic from mlxsw to lib.sh
  selftests: forwarding: sch_ets: Add test coverage for ETS Qdisc
  selftests: qdiscs: Add test coverage for ETS Qdisc

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  26 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 205 ++++-
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  36 +-
 include/uapi/linux/pkt_sched.h                |  29 +
 net/sched/Kconfig                             |  11 +
 net/sched/Makefile                            |   1 +
 net/sched/sch_ets.c                           | 796 ++++++++++++++++++
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  46 +-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  54 ++
 tools/testing/selftests/net/forwarding/lib.sh |  18 +
 .../selftests/net/forwarding/sch_ets.sh       |  30 +
 .../selftests/net/forwarding/sch_ets_core.sh  | 229 +++++
 .../selftests/net/forwarding/sch_ets_tests.sh | 230 +++++
 .../tc-testing/tc-tests/qdiscs/ets.json       | 709 ++++++++++++++++
 18 files changed, 2371 insertions(+), 78 deletions(-)
 create mode 100644 net/sched/sch_ets.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_ets.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_core.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_tests.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.=
json

--=20
2.20.1

