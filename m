Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE879D08
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfG2XuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:24 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728062AbfG2XuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cb1zTO86yONx1h/JrZL4tDiFpwEMsJeFUciWEezZ1aVWPFq2rsHvOIXknQYlujTGtOZNbs8R8TmGB+gC2DpLOHpDqdk7Hi5j5brCm8LTZb+JGzoXxFVPoF0GhknrUQW7sk5NW9t40lIiCdvujSreK53iTLvnsUO1jT4u+lhkZjS0a3o0RxtSEbxDdC20nbhJagNE06W1yzhnsHVikWc7R2TvtDywmeLXz9lAWS0ybQSRzHLB9UDm7F/24uq6ubafG64XnLCX0WWSpMfmgIK6j7yer6r+gc8dut1/2Yk4EZDVTRC1iTXyp6csiWn/4fLWKj9Ll6Y9v4fGYz3jGx0yUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoyVcBjDFa5FYp23cMiqDViksUcHsUHot+54RWMKujw=;
 b=JQOQ4f3OqRnVT5+tNlcT1GZncFXNxDL6AaDzI6e/u/FZy6EqIPHLIlmvLv7Dg3iNDZ9nVX0KURZ5xWIC2l4GXnPcXjww0brkW35jbApVl1IVcduT6R/lr8Epmb5LAKSTDrexA+ixBZXPSNy3pSYEaOWyx3fdZiZsJRUtb3ReamqaenzZV8luOFCDv8dStdseYBbBYJLKX8OzSyl7trXnPf+c4sQwAXVNVC3bQd57DALTJAoDUahmrTHVMpIvAgQVh0acDIJ8dTRLEF3IbdhMlS8iB1WgYz7nXCTWuZ4m90xJF3Id4DNCZYBjy3rPxLST+Cs7gREN8+nop2e8b6Fkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoyVcBjDFa5FYp23cMiqDViksUcHsUHot+54RWMKujw=;
 b=EVzt44Mq6rSW3sYX4JqdKOM3ekpE39KcHYapvcsvOi6DjmhQ5V8Ys7861H2T4HJ9Ld2K7sJIJJkZdQ6Ply/AcKZ5F3yUSa+lzkcSj94msaVIufoS37ittk2ik/43hIEpP+uB0GNr+ByTmMoLSmK422qBnBpdYQ6OQxH/p5boAkE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:14 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/13] Mellanox, mlx5 tc flow handling for
 concurrent execution (Part 1)
Thread-Topic: [pull request][net-next 00/13] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 1)
Thread-Index: AQHVRmheXD4RJMQU9kayks+jVFwZPg==
Date:   Mon, 29 Jul 2019 23:50:14 +0000
Message-ID: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ff56b2b-bad8-429e-deff-08d7147f805e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB23432418C2BC821BCD8756E8BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(2616005)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cuEjBf9sHM4Oe1B+9FcCk14ELXvCzOEnDpzZZpMnPMtW++uC0XBWjJ2K1M+I6dHxs3987zBwf5RWjkxt+iJAeP9DQUvHPQKt+xTFoAjHO4tFfTiuLpoCJM4uEOKm39U4r9+eAA2v9xs2RQg6LLDxvQDkBGnAXczPyn1433Km/iGdcLswRqJf05M0mr82sQchkOozP3zeJw6vWTvcjauaJNTnKqty5ZgXx9KfGVi1lVPj/ssrASX9fzM86nULyZxoxrN3qd4JJcNxMkXZQLHr+Ap+iJQGav8JkcEqNjXZqI2cbw7IbPyqrIjQdLHvHheB8mRgHs52eMsrx3kWIQzkedFmtOJyQ3P4NLpgOwacCSsBvU0dXoQuCZOySCpWEo6iIAfY3badEXoF9sFSdgp4nkF37Jhb1AxpbkGexLR9Y9I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff56b2b-bad8-429e-deff-08d7147f805e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:14.7785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series, mostly from Vlad, is the first part of ongoing work to
improve mlx5 tc flow handling by removing dependency on rtnl_lock and
providing a more fine-grained locking and rcu safe data structures.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 85fd8011475e86265beff7b7617c493c247f5356=
:

  Merge branch 'bnxt_en-TPA-57500' (2019-07-29 14:19:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-07-29

for you to fetch changes up to b6fac0b46a1a76024698d240f0f9aac552f897b7:

  net/mlx5e: Protect tc flow table with mutex (2019-07-29 16:40:26 -0700)

----------------------------------------------------------------
mlx5-updates-2019-07-29

This series includes updates to mlx5 driver,
1) Simplifications, cleanup and warning prints improvements

2) From Vlad Buslov:
Refactor mlx5 tc flow handling for unlocked execution (Part 1)

Currently, all cls API hardware offloads driver callbacks require caller
to hold rtnl lock when calling them. Cls API has already been updated to
update software filters in parallel (on classifiers that support
unlocked execution), however hardware offloads code still obtains rtnl
lock before calling driver tc callbacks. This set implements partial
support for unlocked execution that is leveraged by follow up
refactorings in specific mlx5 tc subsystems and patch to cls API that
implements API that allows drivers to register their callbacks as
rtnl-unlocked.

In mlx5 tc code mlx5e_tc_flow is the main structure that is used to
represent tc filter. Currently, code the structure itself and its
handlers in both tc and eswitch layers do not implement any kind of
synchronizations and assume external global synchronization provided by
rtnl lock instead. Implement following changes to remove dependency on
rtnl lock in flow handling code that are intended to be used a
groundwork for following changes to provide fully rtnl-independent mlx5
tc:

- Extend struct mlx5e_tc_flow with atomic reference counter and rcu to
  allow concurrent access from multiple tc and neigh update workqueue
  instances without introducing any additional locks specific to the
  structure. Its 'flags' field type is changed to atomic bitmask ops which
  is necessary for tc to interact with other concurrent tc instances or
  concurrent neigh update that need to skip flows that are not fully
  initialized (new INIT_DONE flow flag) and can change the flags
  according to neighbor state (flipping OFFLOADED flag).

- Protect unready flows list by new uplink_priv->unready_flows_lock
  mutex.

- Convert calls to netdev APIs that require rtnl lock in flow handling
  code to their rcu counterparts.

- Modify eswitch code that is called from tc layer and assume implicit
  external synchronization to be concurrency safe: change
  esw->offloads.num_flows type to atomic integer and re-arrange
  esw->state_lock usage to protect additional data.

Some of approaches to synchronizations presented in this patch set are
quite complicated (lockless concurrent usage of data structures with rcu
and reference counting, using fine-grained locking when necessary, retry
mechanisms to handle concurrent insertion of another instance of data
structure with same key, etc.). This is necessary to allow calling the
firmware in parallel in most cases, which is the main motivation of this
change since firmware calls are mach heavier operation than atomic
operations, multitude of locks and potential multiple retries during
concurrent accesses to same elements.

----------------------------------------------------------------
Eli Britstein (1):
      net/mlx5e: Simplify get_route_and_out_devs helper function

Huy Nguyen (1):
      net/mlx5e: Print a warning when LRO feature is dropped or not allowed

Saeed Mahameed (2):
      net/mlx5e: Avoid warning print when not required
      net/mlx5e: Improve ethtool rxnfc callback structure

Vlad Buslov (8):
      net/mlx5e: Extend tc flow struct with reference counter
      net/mlx5e: Change flow flags type to unsigned long
      net/mlx5e: Protect tc flows hashtable with rcu
      net/mlx5e: Protect unready flows with dedicated lock
      net/mlx5e: Eswitch, change offloads num_flows type to atomic64
      net/mlx5e: Eswitch, use state_lock to synchronize vlan change
      net/mlx5e: Rely on rcu instead of rtnl lock when getting upper dev
      net/mlx5e: Protect tc flow table with mutex

wenxu (1):
      net/mlx5e: Fix unnecessary flow_block_cb_is_busy call

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  33 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  28 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 492 +++++++++++++----=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  27 +-
 12 files changed, 424 insertions(+), 255 deletions(-)
