Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6DD987D3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfHUX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:37 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728605AbfHUX2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1njbpk1pYJUbE6ZoTtZ16Y2nZhYd51+2R6yxSDAxjXMh0cbzgO1LVwXc8IUeRKKc4EAKt4IAWZ3XV9P8+nOgi/6F84X3zc6JzkDTc8DQuc/l7zE6kxJzV8JkAfnkB51KVu6YYl65vuL04U4sh3NiHmOncFYl7JAEDBUblDh9n+EKgUsNEaEAZSgq9gHsyDH7AHzIjlRMjofQ/vRB+wvGace2jumBbtowbRKCbouzp56r34FWrUHEApsQgD2vnxfD8D97Ea3LK8oWeaoedhEbBdKbQGFBheS9w7qLxwMbnAPyuTNLBA6IOHMALgOSO9ylgpV/U7hLbVaTEItXwLW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dk8uwN8vJAj0lmsgEMP8PMQXgn5iuH6zDEaBmAjfqs=;
 b=DtRz+q/YrEMkpjgTeXVA/KdEZ9hoCxhkRwG621ZyPV0jzsmRiYxr7OVG4D0m4iqYxsZJT4A4Qgh7wytIp0pOpDJbD5d/PvaB2jf4yFuZPDi0djuFY9hmKzXrucj+tVgDkhdG1xxVM2iFnkaoK0NxqCfknVzqKeCrEflpZ1yZK8JuCWv8D6FG8hMD/KyqIJZwXdKaajq2ldy1cUWvLTE4tz1GEkWBUt24yMPGi2hDspVK00QsX/LuFJvJjbsRQqkXbXoU8AuCjZKRNzTqbjDKIvYzEvSvwy7qD4omvb/lt55AmM7dF3Fx1MpSAFDkPygs82O6PScJzILjZR46Fje2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dk8uwN8vJAj0lmsgEMP8PMQXgn5iuH6zDEaBmAjfqs=;
 b=GQSxlsXfnMl8DzdTnteXNPj1ZRtcurIR2ESWbaQZeDfPeiIOAACSs3neZO+/ZeNh833pGl+BVRxgrEz23Ah7K4X1eLAZAlPmMMz11bV73bfIrX6QyFa0ql/Wi+qFSPY8QxohwvRobShElYAITKzrs/LhjMAFxw9scOG2zeq2Tto=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:32 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/11] Mellanox, mlx5 tc flow handling for
 concurrent execution (Part 3/3)
Thread-Topic: [pull request][net-next 00/11] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 3/3)
Thread-Index: AQHVWHgkTsZzQMRS+E+2iM34UIV/BQ==
Date:   Wed, 21 Aug 2019 23:28:31 +0000
Message-ID: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55dcb78f-29a7-42aa-ee82-08d7268f474c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674B5A0AE0A0AFD2AF02862BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(6436002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qzJphP2eDFMGJA7ZyNZhI4io8TLQWsRXBA4sHxv512XKfbtpPuLEap5Ql+bYnYwXPUguBtJWEI+orB9yZsGBs4bisKXUtmhCAnHw2NNAm17r/MW0RAf4QbVKBiBUdxv/zUsOpn7FJR938TvWs7DuDwFPPO3yxIv5pYCMrBRxF9gYiilH8/lKnJG/Zp5Ll52MrEZslXUzLh1pL7AnfWY25mmLdk6XdXgF1zoTgPlWU8tBqK7NUOxIyGnj3iihkcjl27dR6kNtTtHfxLv7tjfhuFW/fRi11EoQ2yO5Zi81KP5QXg0qfjXde/L2MGx34ffBWELFdPPoJqFP9r2y/lhLgsBPdSA/dtLXEPwscRucYcxjDtc6gXuXrcZJb16fEhqsLAsKw4cS8T2aJqvRbtrBH6MOSLpVRe62kOYWDA/7ry0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55dcb78f-29a7-42aa-ee82-08d7268f474c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:31.8115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utRCo8m1heYrC02Ps4zS8UhVpS0bZvt2VWW3i9UzZnL4MzDi4sNi9qKVvx8MJAPgnCLKA6TNlYkvKLwp5XuIAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series, mostly from Vlad, is the 3rd and last part of 3 part series
to improve mlx5 tc flow handling by removing dependency on rtnl_lock and
providing a more fine-grained locking and rcu safe data structures to
allow tc flow handling for concurrent execution.

2) In this part Vlad handles mlx5e neigh offloads for concurrent
execution.

2) Vlad with Dmytro's help, They add 3 new mlx5 tracepoints to track mlx5
 tc flower requests and neigh updates.

3) Added mlx5 documentation for the new tracepoints.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 2b9b5e74507fe8e6146b048c0dadbe2fe7b298e5=
:

  net: stmmac: dwc-qos: use devm_platform_ioremap_resource() to simplify co=
de (2019-08-21 13:52:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-21

for you to fetch changes up to 5970882a2510e8bffaef518a82ea207798187a93:

  net/mlx5e: Add trace point for neigh update (2019-08-21 15:55:18 -0700)

----------------------------------------------------------------
mlx5 tc flow handling for concurrent execution (Part 3)

This series includes updates to mlx5 ethernet and core driver:

Vlad submits part 3 of 3 part series to allow TC flow handling
for concurrent execution.

Vlad says:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Structure mlx5e_neigh_hash_entry code that uses it are refactored in
following ways:

- Extend neigh_hash_entry with rcu and modify its users to always take
  reference to the structure when using it (neigh_hash_entry has already
  had atomic reference counter which was only used when scheduling neigh
  update on workqueue from atomic context of neigh update netevent).

- Always use mlx5e_neigh_update_table->encap_lock when modifying neigh
  update hash table and list. Originally, this lock was only used to
  synchronize with netevent handler function, which is called from bh
  context and cannot use rtnl lock for synchronization. Use rcu read lock
  instead of encap_lock to lookup nhe in atomic context of netevent even
  handler function. Convert encap_lock to mutex to allow creating new
  neigh hash entries while holding it, which is safe to do because the
  lock is no longer used in atomic context.

- Rcu-ify mlx5e_neigh_hash_entry->encap_list by changing operations on
  encap list to their rcu counterparts and extending encap structure
  with rcu_head to free the encap instances after rcu grace period. This
  allows fast traversal of list of encaps attached to nhe under rcu read
  lock protection.

- Take encap_table_lock when accessing encap entries in neigh update and
  neigh stats update code to protect from concurrent encap entry
  insertion or removal.

This approach leads to potential race condition when neigh update and
neigh stats update code can access encap and flow entries that are not
fully initialized or are being destroyed, or neigh can change state
without updating encaps that are created concurrently. Prevent these
issues by following changes in flow and encap initialization:

- Extend mlx5e_tc_flow with 'init_done' completion. Modify neigh update
  to wait for both encap and flow completions to prevent concurrent
  access to a structure that is being initialized by tc.

- Skip structures that failed during initialization: encaps with
  encap_id<0 and flows that don't have OFFLOADED flag set.

- To ensure that no new flows are added to encap when it is being
  accessed by neigh update or neigh stats update, take encap_table_lock
  mutex.

- To prevent concurrent deletion by tc, ensure that neigh update and
  neigh stats update hold references to encap and flow instances while
  using them.

With changes presented in this patch set it is now safe to execute tc
concurrently with neigh update and neigh stats update. However, these
two workqueue tasks modify same flow "tmp_list" field to store flows
with reference taken in temporary list to release the references after
update operation finishes and should not be executed concurrently with
each other.

Last 3 patches of this series provide 3 new mlx5 trace points to track
mlx5 tc requests and mlx5 neigh updates.

----------------------------------------------------------------
Dmytro Linkin (1):
      net/mlx5e: Add tc flower tracepoints

Vlad Buslov (10):
      net/mlx5e: Extract code that queues neigh update work into function
      net/mlx5e: Always take reference to neigh entry
      net/mlx5e: Extend neigh hash entry with rcu
      net/mlx5e: Refactor mlx5e_neigh_update_table->encap_lock
      net/mlx5e: Protect neigh hash encap list with spinlock and rcu
      net/mlx5e: Refactor neigh used value update for concurrent execution
      net/mlx5e: Refactor neigh update for concurrent execution
      net/mlx5e: Only access fully initialized flows in neigh update
      net/mlx5e: Add trace point for neigh used value update
      net/mlx5e: Add trace point for neigh update

 .../networking/device_drivers/mellanox/mlx5.rst    |  46 +++++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../mellanox/mlx5/core/diag/en_rep_tracepoint.h    |  54 +++++
 .../mellanox/mlx5/core/diag/en_tc_tracepoint.c     |  58 ++++++
 .../mellanox/mlx5/core/diag/en_tc_tracepoint.h     | 114 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 224 +++++++++++++----=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 152 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   9 +-
 include/net/flow_offload.h                         |   1 +
 10 files changed, 545 insertions(+), 126 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tra=
cepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_trac=
epoint.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_trac=
epoint.h
