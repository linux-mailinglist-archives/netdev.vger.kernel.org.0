Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9552000CD
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgFSDda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:30 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbgFSDdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBPDcaCmarwc6eNvkPWulmZUDTxWl9gzbZe+/gr+aXgHNH7KJYQjPLYROe9gfcKBx6KywZ1r8s6Pun/JyKLWOWfVprwhOU7U6wWpuPZfj3nKVOT9+B8oIHpbc/zhfM9KCPTZSsaIPHjxNKTWAuh06iZDkFIqmdZVjALaO1lYWSFlFiiBN2MUWzp0PhCm68ldYc/IW571/jboTAE1PWasSC/2Tat3PC8R/EPbCYV5pGSKjuDqarwEXWtbgc3mmrkyHQTZ6ZY2rW9sUitBUIQ449F4N5nniLMkUpEzj4vk2n0ntlIjXJBR41duXadR4IGdKr3j5/Jk9VYKxeVD8tGTag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lq5V3GCokTVIZSM1dSoZd5eCusmNEjQ+caqALwXEZI=;
 b=SX/4XM+vyCpIce3Jusl0PkITe8eugT8iijg864/0Qv/1RhKnx4XA7J677JPW/jP+3tiaSdOZg9+EME+6vZbRPMscHqh1OaEE1EcKjZU+T2CayT2ReSeoWR1hy6qZSw1XStp1qAXkXUmP8M85BvrxnkJvFv7Z7h9cajrGCPrNCGMotBE3bf762LTd89zIXzIfKWYu/GPkdbIgcqmcdb/64rhf94r6pN9h35LnuAeWl1Dz6mBsf7wzm+J94b/EgMcblTddZL7mLOhtfZGRkIdQfMD6XLhrDe36Euur/VNlI8yYzXBDrTIesXpDQVpnn2zNKdJiG/0mn7gKyDtTTSmrTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lq5V3GCokTVIZSM1dSoZd5eCusmNEjQ+caqALwXEZI=;
 b=Zq2xXj3Xj2W9lJ8WA84iKdKSy0VcrE770eBqM0WOIwAee79jUiCTiQDgVCo8fX2bx4WaII0EufVNRtQcvb9pqtVtcqUbZR1/MeY9+HEh+YV09mM4Bj0If3rl6J5xSnaHbA6RPR0rr9zUfzV88LHuvyYL4cDc5acbH69BUER+pCA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:20 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:20 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 0/9] devlink: Support get,set mac address of a port function
Date:   Fri, 19 Jun 2020 03:32:46 +0000
Message-Id: <20200619033255.163-1-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:18 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8036fc4b-c136-469a-e9f3-08d814018314
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804A45546C37252A0F4C5C7D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCtMgxkh6O7OGBuV/MS4ePY4ABHyk4PkM4yKMEGF9cCeGPepeJzET5PD4seKM+2GgED77hXFJsdLJ6FQVyATrgNGZP7I+8mbbASVuTaUY+h9ARotVS/ahD43ybEP/4U9vbsdjtpSUqeYRs2EukXHdPs9xFp/2Kxpnccvzcj1oJK4W+VzVZUsJm9S3OXwBSZ+PvJQ0t7MUDPeiKJ1bTZtXE8B/poiQKhJF2wqnC2yoZCBp1b/yN6AZCsEWuXkZuckAwFL4jS4u8e7iJDyEt2bhjeWKh4A7p05x32oLvt1s57Rqb8WouWNxs++wvVB8/ZKe1h8eoLsORoiBl38lIMkwdMI+H7OiTnN7wp6c2tk4H0tBQLmTvc6YNSUn5C4/ceum28IRggZsdSv564LGij4g4bF6JG8lvP5ogPKdnZhxshOuRcObGLFGMkRnUP6xhsJqXb63YSt+1XdP49+r2C5ZlCxeBqYWO0xANFyzS3PcEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(966005)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(86362001)(52116002)(36756003)(1076003)(142933001)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bC7qO/EhufD5yc8CGUEsJUEGvkzFv/WB3N2u7zc5LKYYGG7WZOEjftgWtoXXVhYTFa0YyXyacBhYdzDO3XwBcayJvT+LyKzi9qr3rgTPhh8q1jazhECl7GjOY1KKhYJXpRnTounEcul7FCZ/OeXinzLMbj0F7Gj2z9zgdVOwBNLOgvQRErux38oYD5E8mHfHSQVLI4pI7oo0ceF525ax/Z7pmKba7uESJPTFsLkpxInq86ydk3tQt8AbR07WogFKPdwCuHYmXlljPFJiL1o5IrXFl/DbqTaxbgfJ0MzQqno8Zs/CbMPTykPyrV10zTwP1FKl6ZQGPRXXVEPlJEUqyGwwFFnUeqG4VvecTRG++Ghb5CzELzeHPZJyWVniGVmyWMDyx/Cm0nH3BRHHcAf6mG1dQMaATMvqRv+icJoL7IRREPJtgTAeLhqV7QzGWbLaiYtY2JsZZkxSvp5J7UhDLLq64NG9s+llgtlPEgHyxIKHIjPmotk8l0J8/5DYSe8U
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8036fc4b-c136-469a-e9f3-08d814018314
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:20.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHGkLaFV9g0DgALnWmZcsT0wbYevYeMztEY8kb3ZEb/Bb/EBZQkJU+C7e6C4Z8nIZDfUZjetVNMr99oy/iV+Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ip link set dev <pfndev> vf <vf_num> <param> <value> has
below few limitations.

1. Command is limited to set VF parameters only.
It cannot set the default MAC address for the PCI PF.

2. It can be set only on system where PCI SR-IOV capability exists.
In smartnic based system, eswitch of a NIC resides on a different
embedded cpu which has the VF and PF representors for the SR-IOV
functions of a host system in which this smartnic is plugged-in.

3. It cannot setup the function attributes of sub-function described
in detail in comprehensive RFC [1] and [2].

This series covers the first small part to let user query and set MAC
address (hardware address) of a PCI PF/VF which is represented by
devlink port pcipf, pcivf port flavours respectively.

Whenever a devlink port manages a function connected to a devlink port,
it allows to query and set its hardware address.

Driver implements necessary get/set callback functions if it supports
port function for a given port type.

Patch summary:
Patch-1 Prepares devlink port fill routines for extack
Patch-2 and 3 extended devlink interface to get/set port function
attributes, mainly hardware address to start with.

Patch-2 Extended port dump command to query port function hardware
address
Patch-3 Introduces a command to set the hardware address of a port
function

Patch-4 to 9 refactors and implement devlink callbacks in mlx5_core
driver.
Patch-4 Constify the mac address pointer in set routines
Patch-5 Introduces eswich check helper to use in devlink facing
callbacks
Patch-6 Moves port index, port number conversion routine to eswitch
header file
Patch-7 Implements port function query devlink callback
Patch-8 Refactors mac address setting routine to uniformly use
state_lock
Patch-9 Implements port function set devlink callback

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://marc.info/?l=linux-netdev&m=158555928517777&w=2

Parav Pandit (9):
  net/devlink: Prepare devlink port functions to fill extack
  net/devlink: Support querying hardware address of port function
  net/devlink: Support setting hardware address of port function
  net/mlx5: Constify mac address pointer
  net/mlx5: E-switch, Introduce and use eswitch support check helper
  net/mlx5: Move helper to eswitch layer
  net/mlx5: E-switch, Support querying port function mac address
  net/mlx5: Split mac address setting function for using state_lock
  net/mlx5: E-switch, Supporting setting devlink port function mac
    address

 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 142 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  25 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  66 ++++----
 .../net/ethernet/mellanox/mlx5/core/vport.c   |   2 +-
 include/linux/mlx5/vport.h                    |   2 +-
 include/net/devlink.h                         |  22 +++
 include/uapi/linux/devlink.h                  |  10 ++
 net/core/devlink.c                            | 133 +++++++++++++++-
 10 files changed, 343 insertions(+), 69 deletions(-)

-- 
2.19.2

