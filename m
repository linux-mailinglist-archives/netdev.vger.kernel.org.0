Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6215A2BFB
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiHZQH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240638AbiHZQHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:07:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DEDD51E8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfQ6NfrMXVJqYMAYE+CxdJmL4zjbLOAmSXuWlsHcK62wcIkfX6kJLEGIlp7ns5vN+rd2i0qVtZOUCh7iqrr2svjp8oPUdO8TBnxoHYGKhXT+m9kVj6QlTQdyj/8JxkWhIEqZ9TXhj21U18xYh88pcnCjGNUMOXNVaAyv3Ks16bCnFgtUl5XMAubzPqKscwRzvTQLxMArN56hViuqCcT8ra2fM1qlz+jcXQ3GPMnYJz+3nWZmGcy/KlkGT+N2v3+veo0JdBqegi9ZIL6P4xoJI6TCQdliRUVU7iL80xEzGYPcn4zsT16oosoFmRm6flWEn9tNOq0UG8ziXYKxuN2pLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNNGn6uMr3lb7h9rhzX6y6/AJCeE7meKCYX6rj0cbTo=;
 b=Z/5UTATyGI6GmgHE7xkCa0CjtmNGENgIjYXc31ylnS35MFKHMMt1xfylgrWZWjL2TRUyf3OIrHHtYsffHFwlXQnUh9LeCqtXNRoKW4/qnRPxG4VnTHtje5ozOzM7bu2pBMvy/4d7Pp9ww+mgNz2M5ae309s7D/CYIm/9OxRw4ZnuJOWiO3RubgS7wMrYnOWgwp7Pixc7enlSw1Ma30lZvVyNBpRgL8vMliGdY9EvlR2/ql3tYrRa107KoDAD5+z7L3wsMcBRRhbZx6XPoD3RKfzhBTcSHEPbHWvRx/ih21bdTxZEetRSqpojvU5dSFdF4PSAE/1HUBd6QF/hHIPUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNNGn6uMr3lb7h9rhzX6y6/AJCeE7meKCYX6rj0cbTo=;
 b=VCI5SECGweUkwXZimitkPbpeETOvslQRabcZvwM+Tiw2ujYQKDnAQ6SRQbywooVMVbyYdsfwBmS6dSGSw9Y6n8Jg+by9reNWl+SniPo1mkx5eiBi0YpJCySdLIZGTJzl1H5nguO3pf0cwVkNmoC/it1IvH9QNW/LFMdXBJcaNuU6P/SmYNSxUJUFRYI0mTndYLhycQxYKH40HjHnzZ3Aqz5APgJUO4KmVMTMAYebiXAELlzF227YY02aZ2D7jcmnKB1Uv34szDZ+fFF+uYlpcsLKOujpcR3lo8vNgK67/Ox+gPaR+CEAe4vowxVENTlOBPSPTregRPoJP6UXwjKUYw==
Received: from BN8PR04CA0032.namprd04.prod.outlook.com (2603:10b6:408:70::45)
 by DM5PR1201MB0044.namprd12.prod.outlook.com (2603:10b6:4:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:07:20 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::af) by BN8PR04CA0032.outlook.office365.com
 (2603:10b6:408:70::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Fri, 26 Aug 2022 16:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:07:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:07:18 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:07:15 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/4] mlxsw: Configure max LAG ID for Spectrum-4
Date:   Fri, 26 Aug 2022 18:06:48 +0200
Message-ID: <cover.1661527928.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4369fe4-ce48-4b3c-1ab2-08da877d0d78
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZ9W91MFnTEdljEBF6qXvVWZgn/Fo5b+cTVJ56DYET8TmGybK2jBW3sUHBlnOd1qMa17zyk1AptUT9F22kC8TqPSvS/Q+mNc7mIaTQboSQEuGaFzIgl6/ytxBwjOog29SvomajRm/JK7RMDMAv3CJ1HN+LzNQOKloijVzMpHP7wCZ2JzMDVQ4IaWqRXgMOiUOsdF5x7bFBclEH1pbYX30+M0XRxYKr2ACwktJp+5d2sSRkp53Y2LzGzjtZEtrByNCV7N6w23aIuBiDotetu/ea6x7EhKhBuT9pcs/qpbZjVfZZXSs9JAtaYqXZO4h65EOpTymPG0xYS34ixx6L1Jj1dJAsmgGOniANTJfR1nv03heJN6GA3ttxmpNonB9BKEnUAW3ux/884/4PzN7JtmOgklO2uNmEyO+MlPLKxBvSunkt/i88KXof89wryhPl4e55FQ4gjxnX9w0Crp1G5+Uy14hO989fNOgQGBz+11s5NID+bTqrHs8B3Iz0b3RJZey1Ri079xdzkBBomCLZIBcJiIbSmEMvPGTcX+sYgnz48B8bNrektkcOYCop0vIZFivYLopSnNfEeXbWg+Ftg895WL2D5XodibJ+GQ4wV1LndDIYG64GGbrTc45Th1r2RY89/9I4SDV5Rgyc4DDvkKLSWVkmcIi32qPNLGTrLiDxgWNk2YDCvqjPdGxqRRtSmM5SoNMJX9KYdsncYxz/eyvv/dbok1KAQaKQ5hXuJLbABSCv5BtycF8vWfMDZYSepEAZxyxPo7nVB4QbnaLEzBvsWpmFOKUTnIujyjdOP5PE1T7bycztReRS96VYp5UxaX
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(40470700004)(41300700001)(63350400001)(8676002)(82310400005)(478600001)(83380400001)(186003)(336012)(36756003)(26005)(36860700001)(2906002)(426003)(47076005)(6666004)(107886003)(70206006)(16526019)(40460700003)(2616005)(63370400001)(82740400003)(5660300002)(81166007)(70586007)(8936002)(86362001)(316002)(40480700001)(110136005)(54906003)(356005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:07:19.1108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4369fe4-ce48-4b3c-1ab2-08da877d0d78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0044
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Cohen writes:

In the device, LAG identifiers are stored in the port group table (PGT).
During initialization, firmware reserves a certain amount of entries at
the beginning of this table for LAG identifiers.

In Spectrum-4, the size of the PGT table did not increase, but the
maximum number of LAG identifiers was doubled, leaving less room for
others entries (e.g., flood entries) that also reside in the PGT.

Therefore, in order to avoid a regression and as long as there is no
explicit requirement to support 256 LAGs, configure the firmware to
allocate the same amount of LAG entries (128) as in Spectrum-{2,3}.

This can be done via the 'max_lag' field in CONFIG_PROFILE command.

Patch set overview:
Patch #1 edits the comment of the existing 'max_lag' field.
Patch #2 adds support for configuring 'max_lag' field via CONFIG_PROFILE
command.
Patch #3 adds an helper function to get the actual 'max_lag' in the
device.
Patch #4 adjusts Spectrum-4 to configure 'max_lag' field.

Amit Cohen (4):
  mlxsw: cmd: Edit the comment of 'max_lag' field in CONFIG_PROFILE
  mlxsw: Support configuring 'max_lag' via CONFIG_PROFILE
  mlxsw: Add a helper function for getting maximum LAG ID
  mlxsw: spectrum: Add a copy of 'struct mlxsw_config_profile' for
    Spectrum-4

 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 25 ++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  4 ++
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 49 ++++++++++++++++---
 5 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.35.3

