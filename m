Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4BB26175A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731871AbgIHRaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:30:15 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:52103
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731651AbgIHQPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:15:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjVWiNMHfb7yVKZqBNegp5TkUw3bJeTG87WpxkulDchKQZWfLxcco7pDQXwx0f4zkDyWSeNXUOYQsTtWo0cLkERo+CtxNbaFVcc+2xHwP6WmcFOQ0JtBYvSWmBzJfkyRW4N4A8MfH4nKmP+QAlVBPj0BxbnmLIPbfoY6jmk2vIPSEq2C/9ffmj16B2D0bK/Krbg04rDStegT0q07AkRAB8zTGUII8eNVTOFDd/u0pRyjB/Z5g4BOd0KUDDw8dDq7niLKX1ntMVsgtkg+1eZ4ox2+r8fAYjAK8FSLfQ4DfpG/bJe0t3qsLeuxTs+EBakHv/YKek4MFrSXTL6+vJjf3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZnKNNB8s4yokc/4Goi91qULv0/IAk5yjmfhkIJZDpY=;
 b=DrbT7mkXuq6LPV+kLu/nXRQ/jpOHCacBnPLTXEcRFDFWH5MwZM3KKoC02/Kki++lDoEwL9+pqcgUAA+KetClgHHVnu3dV4ljE/2tIR4EVdwr5uDih9Q6wMY/PEJt/pRZPH+PipYE0SFuF19h0wWW+zZRF9EUdgTXAKgzueeNZM8QI0D4gz2eYUAfMziG64bk8sw1oRpzRlQFO+Zx4agCtiXfVzZ9M5rehiem1KOD/U5ewtnwfp72NSzgTXf9ylofJFY/4xfTnYedKCkPIBVy8J+xhLYaNErBZfq1uWjM3pzBB4tLV2ktq7ELWRxQsU2lWbEkMvvFnEYZ7RODuZz/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZnKNNB8s4yokc/4Goi91qULv0/IAk5yjmfhkIJZDpY=;
 b=ZjS3S/D7n/qsKnpODps8levAD6gPUgGn40TKxbvxHcRMfXYh2X5nQnp3/XLD5+k62IwOu4siyiR2zXT12ic/FqChu/KorDc1BuDeEY8Ks/LvStz3XZwgiNDDHHdndW6GJg9okJUko7edvp9MYs0fLBiLuRRAlreWge6z3gtUSBU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4353.eurprd05.prod.outlook.com (2603:10a6:208:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 14:43:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:08 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 0/6] devlink show controller number
Date:   Tue,  8 Sep 2020 17:42:35 +0300
Message-Id: <20200908144241.21673-1-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825135839.106796-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c752c7f1-92b4-44ba-10a3-08d854058076
X-MS-TrafficTypeDiagnostic: AM0PR05MB4353:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB43532CCAB9059F6760CD9099D1290@AM0PR05MB4353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hRYy5vyIx9fDQLBv7bbGlYzioeWyGQa+uL7Jp6qnUPVSR9YQ6EV+OUZk9if1bgLf1RQkUqVRjSmhI0wctOQK90ZPeNXrPjdb1i6BSSfeLfeoULK5KiKVPWSf1Vw3T66zhAv0eKTAAphuijM0DqEHTBjaoHyuTgJ/HqbRbLRtM5d6uLJRl7hlHmEuZ+up2GfGCf5+u1eQmigicMXfIZJISsgZqUTGghebXB2OQcMiNGnJDxaIOGDApLtn2jTTiCdj6r2WFRorwnFHBlEdtm/Gu4l95jH09wSaYG1eV/QRUKUmwfewKChVVQ99rQ4dUQGEtPILuVsMtRLDyI8iOhwRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(498600001)(26005)(1076003)(6512007)(6506007)(86362001)(4326008)(52116002)(5660300002)(2906002)(36756003)(66946007)(8676002)(83380400001)(66556008)(66476007)(956004)(16526019)(8936002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xw6hkHYRfv/qnEkSF4tFvmdy2Ui89fnpymZKlcpBk9zDu1/jFvsf8196yBPnibQ/dT+VJfvR41J4CWOX7fZBD1//L4WIr0VMxGA55oi6vGC7pBfZMOBvRTdPmzlYESMp7tg/Yhp78J/QwrSVo17h9XTKhraF+9pahEE6HiOrRpwnAVu2IhbbTm8hfMsatfThFPw7zfN1dI3HxkDhDxod5hF81ztW/Jvk/lMyplsWvb7LnXl2RphG1oLC2zbWmI71ascd5hAOC2//yIAHY8DFQo0QMYE0YXn7hSVUhKdT6MBL8FCeDjxeF+UV0jGVbwXrpaSHtmpya1RxR3dzKViLobX2jh0xH+D78ssju1fInCww7rSqfyiOExHz/lz+EeMFyLq5rpZ4YY40Bbo84Bi4IraTRPQx46wFDe2poy5fxE12lAG+xZAMp8zSSV/6+kgFfE/5nFu1VVFtFfiRxwckpVqVnKNAJphDda7U4UcaJjcZeduFrou3eIXBCXTg2qXDGH3FfQa7F1Y3mHnzqgbS44u1ABHElboqGGIpBu8VseZf+OTTIaWar3pRow2P/IYI39z/Zxa+Lsvv9gJJEzJo0F9+WyeIcKbnkluUCyM8nF8Pp0rpXnUloj0OyMw9OeOb8PFQR5M/JCK0K6QaymzozA==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c752c7f1-92b4-44ba-10a3-08d854058076
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:08.4433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Dq7H3VSfCQvw0eWU7j1NuffkuxlrV2gx09RbdH4xMrgbVqqLZQhsVVNWmdwCfoBs8MwDscSbObEpsAi1ZBDTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Hi Jakub, Dave,

Currently a devlink instance that supports an eswitch handles eswitch
ports of two type of controllers.
(1) controller discovered on same system where eswitch resides.
This is the case where PCI PF/VF of a controller and devlink eswitch
instance both are located on a single system.
(2) controller located on external system.
This is the case where a controller is plugged in one system and its
devlink eswitch ports are located in a different system. In this case
devlink instance of the eswitch only have access to ports of the
controller.
However, there is no way to describe that a eswitch devlink port
belongs to which controller (mainly which external host controller).
This problem is more prevalent when port attribute such as PF and VF
numbers are overlapping between multiple controllers of same eswitch.
Due to this, for a specific switch_id, unique phys_port_name cannot
be constructed for such devlink ports.

This short series overcomes this limitation by defining two new
attributes.
(a) external: Indicates if port belongs to external controller
(b) controller number: Indicates a controller number of the port

Based on this a unique phys_port_name is prepared using controller
number.

phys_port_name construction using unique controller number is only
applicable to external controller ports. This ensures that for
non smartnic usecases where there is no external controller,
phys_port_name stays same as before.

Patch summary:
Patch-1 Added mlx5 driver to read controller number
Patch-2 Adds the missing comment for the port attributes
Patch-3 Move structure comments away from structure fields
Patch-4 external attribute added for PCI port flavours
Patch-5 Add controller number
Patch-6 Use controller number to build phys_port_name

---
Changelog:
v5->v6:
 - Added mising code for ECPF check; occurred when split the net/mlx5
   patch to individual devlink patches.
v4->v5:
 - Removed controller abstract names 'A' and 'B', instead used
   controller numbers in the commit log description
v3->v4:
 - Split patch for controller number attribute addition and building
   phsy_port_name
 - Removed prefix net/mlx5
v2->v3:
 - Removed controller number setting invokation as it
   is part of different API


Parav Pandit (6):
  net/mlx5: E-switch, Read controller number from device
  devlink: Add comment block for missing port attributes
  devlink: Move structure comments outside of structure
  devlink: Introduce external controller flag
  devlink: Introduce controller number
  devlink: Use controller while building phys_port_name

 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 13 +++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 +++++++++
 include/net/devlink.h                         | 33 ++++++++++---
 include/uapi/linux/devlink.h                  |  2 +
 net/core/devlink.c                            | 47 +++++++++++++++----
 6 files changed, 99 insertions(+), 19 deletions(-)

-- 
2.26.2

