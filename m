Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF1620D90
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiKHKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiKHKrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:47:52 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86F34093F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:47:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DX+n7OV3wTE507GXYNbFsn83P1tGBTjhcb0lhTbH07Ld2koRX15YK0Qt733gTAT1hvyMXaUzopd1S8y3xoKKjEwEoxdszrura1QRBxW15CjNQTB1GCzfuOwPCgGtuE8a7H72Ss1Wva5anWj1B2Qn7gJcZpFes2E+nQxPoO8iTSETe9p2slPE0pFLegCZ8Hz0vs/HsB9zIXcBJ//7u0PH/+9cGM06PuKVzOyJ0iDYlLfjOOVVsZI6U6ADwxuSiUNjPVq4VQAPlHjMay7UuSgPAZ9M3k7NPaM5Kpmzu4/PkLi3P/qqaEGJPycs0mIuQako+RI5M66SQaLuSpn6iqIyMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjSm/Gn6HoNmncxU1UAmoG6ogZjOGBFzR1j6mE7SU+s=;
 b=hc8kVZtyj5fFRirsBC/dnG6WcT9NDaMTHIA5QurgAg0wa3NW6fOhV0dUtezp2NcHhrKo1BURRz4McBNelMdbUt8evCixmFtDfhn+CcejuIt0bq+ffvjppGly1NbEZjeEH4jt6kQMekVVTQnbyJOOalh7+OpYQrOFIIxgFcK9ZlGJ45QRy0cWo30s5pR79d6tfVUkcJpHN8qSygrPe6lstYGOZPj/je8ctIcB3a+fK5pZkKjyvoUiI7ZoW+moSwuQOKP9PlNySmmI5dXSvb7CBtSyUJ86VLbxaGYw5+DeZtvAfcBIgMgA0FDpJmwIWPcZvbDDQV3N+0IYxkHxqO5kSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjSm/Gn6HoNmncxU1UAmoG6ogZjOGBFzR1j6mE7SU+s=;
 b=Dda8c19MjKTkm9ujhty8iPi+WZLoGyEr4YyNIeIiGMuR/2blnNavSeoedeBN6ruBiDTHDyTXruKY1if+YIPlbBz6weofFOE7Y1x3G7VNFMsCcm9V+aB22D5yTYYewyvlMKtAMCs7ffCYw7y+gt5jwA0MPxNcLWZBSJaVlH38nC9zgdOXtJ778CLrnjX3IyDGWzop7mDAVBSPKWcgZ5031hEsT/xtE91N8pkfHs2NODTzW4PLlAQcdtaf079rsUDytLeoMy8dAieIqh5z9VjNWNB+OMIjnBNBQg0BI/gaOyvuWD1VpzvFB5QDcHrRWEDTr8hAuZuUXOZ8XA0e75gwmQ==
Received: from DM6PR06CA0094.namprd06.prod.outlook.com (2603:10b6:5:336::27)
 by SN7PR12MB7021.namprd12.prod.outlook.com (2603:10b6:806:262::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 10:47:48 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::c2) by DM6PR06CA0094.outlook.office365.com
 (2603:10b6:5:336::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:47:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:47:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:47:37 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:47:34 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: Add 802.1X and MAB offload support
Date:   Tue, 8 Nov 2022 11:47:06 +0100
Message-ID: <cover.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|SN7PR12MB7021:EE_
X-MS-Office365-Filtering-Correlation-Id: b7cd1379-0c74-4244-50b1-08dac176ad01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8roZdfs2nqwlCTYaj64HWCeVjy0fK1GmfQi/R2az7KLhoSW7G+f868E7UJXAHtrA75wXhXHcwRaLCFbUcVlJCkNaBl5vAyBACFV4AMmoGyzghHHofe98aJXqoIVnBpCGgzQJeLtnDTfXvQ0+CeLp3KMTfcJGo6NA8SZnN+ixaUG6w2uOoVYIQIFhBiqKoXtnEZrGpcxt85b01Ku4sIYifXog9IQzsnMcPVsBOembnWubLY20VtH0U6ZoI/HTIdaUIVSbofuUASl6daXIK2FsjROwMsDhrCyI2rErjZWtByyghpFvJphtlph7QUb4XA72znaElZEjRmwWIP5RyVEh5lhthnVdFG9PC9De7BoYHZm6R85ASfZGABR3HEa4CFsrjw8FPNqiPLLOG/kgLc1fIyU0XT7BcbAhvyfm5oQRBvwNonTRV8fGAhwz029NUN7RGwBV3cR7mvmIW1rXii78OdylPBn2mR60M/4dC6UdLmTEHxXYPFtSljjLH79FLgz6P8FdWWnMhEc9MJxMhGLrwS70ubO3DA+s/btJgQmdGndlpilt8KA5OiCTogtr7zjtYAIgXK0bCL5IrUK4g/qyYUvryX/x/G/fCcmF2QN1+Qs5BjdE+yNtNpSZzkqYKObzDiGj5KIgo5Zi3m3TqKIV6tQeZurOj/G0aobbr1S6mSwUmRh6xwI2V+OIasCOBoW9XizjnLQcPchm9bjkkheDn/kc6UJbd7t8KxxxTarIbf8cHc8GJT7YbtOWF7n4A/EABVNg/ZoBTuB1w7A7ZBGkZtP9GLMHJov0HWxhcW3BqHwVf/NcBfN5TSIGW875kXK9ynon6R9lJk8Zv29x1r5B8wbRO2E6wyDaBNTd89TF4J+I1/0h2RqZYKc3jeb9ceF2uSwbBmsq8q40/XUYulYpRw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(86362001)(83380400001)(36860700001)(82740400003)(356005)(478600001)(7636003)(336012)(8936002)(966005)(5660300002)(40480700001)(41300700001)(4326008)(8676002)(186003)(316002)(54906003)(110136005)(70586007)(2616005)(70206006)(426003)(26005)(40460700003)(47076005)(6666004)(107886003)(16526019)(2906002)(7696005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:47:47.7630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cd1379-0c74-4244-50b1-08dac176ad01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7021
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@nvidia.com> writes:

This patchset adds 802.1X [1] and MAB [2] offload support in mlxsw.

Patches #1-#3 add the required switchdev interfaces.

Patches #4-#5 add the required packet traps for 802.1X.

Patches #6-#10 are small preparations in mlxsw.

Patch #11 adds locked bridge port support in mlxsw.

Patches #12-#15 add mlxsw selftests. The patchset was also tested with
the generic forwarding selftest ('bridge_locked_port.sh').

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a21d9a670d81103db7f788de1a4a4a6e4b891a0b
[2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a35ec8e38cdd1766f29924ca391a01de20163931

Hans J. Schultz (1):
  bridge: switchdev: Allow device drivers to install locked FDB entries

Ido Schimmel (14):
  bridge: switchdev: Let device drivers determine FDB offload indication
  bridge: switchdev: Reflect MAB bridge port flag to device drivers
  devlink: Add packet traps for 802.1X operation
  mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
  mlxsw: reg: Add Switch Port FDB Security Register
  mlxsw: spectrum: Add an API to configure security checks
  mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
  mlxsw: spectrum_switchdev: Add support for locked FDB notifications
  mlxsw: spectrum_switchdev: Use extack in bridge port flag validation
  mlxsw: spectrum_switchdev: Add locked bridge port support
  selftests: devlink_lib: Split out helper
  selftests: mlxsw: Add a test for EAPOL trap
  selftests: mlxsw: Add a test for locked port trap
  selftests: mlxsw: Add a test for invalid locked bridge port
    configurations

 .../networking/devlink/devlink-trap.rst       |  13 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  35 ++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  22 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  64 +++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  25 +++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 include/net/devlink.h                         |   9 ++
 include/net/switchdev.h                       |   1 +
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  22 +++-
 net/bridge/br_private.h                       |   2 +-
 net/bridge/br_switchdev.c                     |   6 +-
 net/core/devlink.c                            |   3 +
 .../drivers/net/mlxsw/devlink_trap_control.sh |  22 ++++
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 105 ++++++++++++++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  31 ++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  19 ++--
 18 files changed, 366 insertions(+), 25 deletions(-)

-- 
2.35.3

