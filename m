Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A895D8857C
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfHIWEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:38 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfHIWEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxZKUxm+TlVM4kPQmeknL+mndnpuhkABqyyEW67jKjQnz86wXonA+Oa5bnbZGCc4/8ixdMsBCcrIfEMB3rxy99PS1x2g/wnqs94e63n5d1EgTdgCYll+4beLeXIR+laMA4SvJel0h5B/WROC3efdpp46K7U1F01lk3mabAZnqynRq335LGeCnXko2mmqy7qWyPGTFOUZ07L5FCGwMp3fYgbwp6NTFHT4SwnnKk7C9mCaCUiOLvninVinXZ60oeukEfwttGXC318VTt7g1s9/xvExEQk5MlIsX4mPl4vey7z9qJXkmAXWTMtpPLnVNTEJ/3tI027ybE3uQmPItRMUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBztdKVWLQ7KFBB61r47tTNrQYjIr7gd/XVn82bKNAM=;
 b=UshqZvwFRsSrKZGTwZqz+AnlFIp4tzEHP4u7eHTHDbkYGuASdOvGegoidoUeX/Lp+SBrWIlDDvOU1WbSBgbt8spf4uKMebDOpZQ4nABBssWJ0zwmI31unW3iqK+Px2+42d4Yvehtwmxm+pVgkRpbVtgKhQerZzCYYXSGa/vi9qe+FIg/SYogvXnEW1lqpdxsQIfPs3FH6IgaaReS1EGfHG95QWwpMJx8Va+Ub/gLiYayf4P6uyHz3jHx11vTxyK2QJrcLl6dCVv5vyIXtuPxIm0Ogy0I3i6hG4Eds3k2HTKrcjcbndeEzl78Hp6DXAzzqjeTYTp2xpS9LyCQxjOqUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBztdKVWLQ7KFBB61r47tTNrQYjIr7gd/XVn82bKNAM=;
 b=HhKU3gL2LjNdKOzFhSkow8x/EKtzRSxekR+hKDHee05p1N3H2+Xgn7gIcw25ypXp242jUcwgPg+8Qiv5Tm3G/HnRfBNijdlqyjByAgxHTNw3lv+B9H+EpcuXGcy9uHOs3vun4aEVuIHB1SzT+97sSxRerW7WOTB/3HQXxLqWcxA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:17 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] Mellanox, mlx5 tc flow handling for
 concurrent execution (Part 2)
Thread-Topic: [pull request][net-next 00/15] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 2)
Thread-Index: AQHVTv5jNded9wnQpUSkIxefG5B8Kw==
Date:   Fri, 9 Aug 2019 22:04:17 +0000
Message-ID: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9644992-6d34-4404-babb-08d71d1585ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB28568B3F13936F3889A018F5BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 49bcAzbEX4xCBO9tggOWz8N60RcbL4xCa4FYHbDvpevvh0/IH+g0pu3JaX/RlAafXRObdlOq7YbT+e5+oP5ZN78zcsdbsBOkfQruiY7bv9p9knDhpBKouyy4OArZ4zZ4zpzDul8trXpeWyWcnRMJqva3iYA/QxMAYheZ6VyFz30zKBiVoFRdROMhkN7508+nabhUpwisWCNW+Rgi55JMyeUnB7FDWge0jtYnBAvBoTL35mm1bKKxja5FJYbJh6rvxQoB7gB5Oo/ab74T0+VFVfM4JYlR226VJqikU6g0Jsfo9vEa3yOJYxuNGJNK7lhLaTAs7oL2luhz7+kIyxEz9Gwn4Y+mWJ1aC+CeRnC8+BsEWC3nTnEO90iVDRWEaEL4HyrzkCQxIsk9EuWygXIuG2h3JzejZ3xIycxd+/TsKMI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9644992-6d34-4404-babb-08d71d1585ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:17.7612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WM91MB2z+Go5xX7Omeic98zYQwKsK8sJyB/Ji3KvNl0ejAXXJOSSLPtM9mCg943uxJ3zUFTQgZv+bdScRQKtSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series, mostly from Vlad, is the 2nd part of 3 part series to
improve mlx5 tc flow handling by removing dependency on rtnl_lock and
providing a more fine-grained locking and rcu safe data structures to
allow tc flow handling for concurrent execution.

In this part Vlad handles hairpin, header rewrite and encapsulation
offloads.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


---
The following changes since commit ca497fb6aa9fbd3b0a87fd0a71e9e1df2600ac30=
:

  taprio: remove unused variable 'entry_list_policy' (2019-08-09 13:41:24 -=
0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-09

for you to fetch changes up to b51c225e6c4e987e131b8b1332f66969382bf328:

  net/mlx5e: Use refcount_t for refcount (2019-08-09 14:54:11 -0700)

----------------------------------------------------------------
mlx5-updates-2019-08-09

This series includes update to mlx5 ethernet and core driver:

In first #11 patches, Vlad submits part 2 of 3 part series to allow
TC flow handling for concurrent execution.

1) TC flow handling for concurrent execution (part 2)

Vald Says:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Refactor data structures that are shared between flows in tc.
Currently, all cls API hardware offloads driver callbacks require caller
to hold rtnl lock when calling them. Cls API has already been updated to
update software filters in parallel (on classifiers that support
unlocked execution), however hardware offloads code still obtains rtnl
lock before calling driver tc callbacks. This set implements support for
unlocked execution of tc hairpin, mod_hdr and encap subsystem. The
changed implemented in these subsystems are very similar in general.

The main difference is that hairpin is accessed through mlx5e_tc_table
(legacy mode), mod_hdr is accessed through both mlx5e_tc_table and
mlx5_esw_offload (legacy and switchdev modes) and encap is only accessed
through mlx5_esw_offload (switchdev mode).

1.1) Hairpin handling and structure mlx5e_hairpin_entry refactored in
following way:

- Hairpin structure is extended with atomic reference counter. This
  approach allows to lookup of hairpin entry and obtain reference to it
  with hairpin_tbl_lock protection and then continue using the entry
  unlocked (including provisioning to hardware).

- To support unlocked provisioning of hairpin entry to hardware, the entry
  is extended with 'res_ready' completion and is inserted to hairpin_tbl
  before calling the firmware. With this approach any concurrent users that
  attempt to use the same hairpin entry wait for completion first to
  prevent access to entries that are not fully initialized.

- Hairpin entry is extended with new flows_lock spinlock to protect the
  list when multiple concurrent tc instances update flows attached to
  the same hairpin entry.

1.2) Modify header handling code and structure mlx5e_mod_hdr_entry
are refactored in the following way:

- Mod_hdr structure is extended with atomic reference counter. This
  approach allows to lookup of mod_hdr entry and obtain reference to it
  with mod_hdr_tbl_lock protection and then continue using the entry
  unlocked (including provisioning to hardware).

- To support unlocked provisioning of mod_hdr entry to hardware, the entry
  is extended with 'res_ready' completion and is inserted to mod_hdr_tbl
  before calling the firmware. With this approach any concurrent users that
  attempt to use the same mod_hdr entry wait for completion first to
  prevent access to entries that are not fully initialized.

- Mod_Hdr entry is extended with new flows_lock spinlock to protect the
  list when multiple concurrent tc instances update flows attached to
  the same mod_hdr entry.

1.3) Encapsulation handling code and Structure mlx5e_encap_entry
are refactored in the following way:

- encap structure is extended with atomic reference counter. This
  approach allows to lookup of encap entry and obtain reference to it
  with encap_tbl_lock protection and then continue using the entry
  unlocked (including provisioning to hardware).

- To support unlocked provisioning of encap entry to hardware, the entry is
  extended with 'res_ready' completion and is inserted to encap_tbl before
  calling the firmware. With this approach any concurrent users that
  attempt to use the same encap entry wait for completion first to prevent
  access to entries that are not fully initialized.

- As a difference from approach used to refactor hairpin and mod_hdr,
  encap entry is not extended with any per-entry fine-grained lock.
  Instead, encap_table_lock is used to synchronize all operations on
  encap table and instances of mlx5e_encap_entry. This is necessary
  because single flow can be attached to multiple encap entries
  simultaneously. During new flow creation or neigh update event all of
  encaps that flow is attached to must be accessed together as in atomic
  manner, which makes usage of per-entry lock infeasible.

- Encap entry is extended with new flows_lock spinlock to protect the
  list when multiple concurrent tc instances update flows attached to
  the same encap entry.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

3) Parav improves the way port representors report their parent ID and
port index.

4) Use refcount_t for refcount in vxlan data base from  Chuhong Yuan

----------------------------------------------------------------
Chuhong Yuan (1):
      net/mlx5e: Use refcount_t for refcount

Parav Pandit (3):
      net/mlx5: E-switch, Removed unused hwid
      net/mlx5e: Simplify querying port representor parent id
      net/mlx5e: Use vhca_id in generating representor port_index

Vlad Buslov (11):
      net/mlx5e: Extend hairpin entry with reference counter
      net/mlx5e: Protect hairpin entry flows list with spinlock
      net/mlx5e: Protect hairpin hash table with mutex
      net/mlx5e: Allow concurrent creation of hairpin entries
      net/mlx5e: Extend mod header entry with reference counter
      net/mlx5e: Protect mod header entry flows list with spinlock
      net/mlx5e: Protect mod_hdr hash table with mutex
      net/mlx5e: Allow concurrent creation of mod_hdr entries
      net/mlx5e: Extend encap entry with reference counter
      net/mlx5e: Protect encap hash table with mutex
      net/mlx5e: Allow concurrent creation of encap entries

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  41 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 401 +++++++++++++++--=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |   9 +-
 include/linux/mlx5/eswitch.h                       |   1 -
 include/linux/mlx5/fs.h                            |   5 +
 11 files changed, 340 insertions(+), 140 deletions(-)
