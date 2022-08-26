Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7935A2BFA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiHZQH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiHZQH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:07:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D330D4BEA
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRj08sYN225JuUQmRdIvxMY4E/y0zPepxUIPEr/DIeQVDCEC/BoKlxEvNmj68R5n5xayzNKiCD83CJlIm6v9jnc3snB7FTIU/rs4kMXhQeHqqt1BDmQSrw6OQbTRMELwNIfRZkFbnT/xxAZW7MQPtiwag8Q9XsCK329ymyuaqTUtuvxWU+DQ+3rYkmhurV1cOPD+F4BZbgSOCbYcmZdWUxmxqt2bspomljZx1W7s9HYxak2Lpccg35i4u/OntQY4sVNOdeSzGvjK89j2IctJhi0PyKSJmnOqfHABTf08DLzRX2kbd3jNmOGqQQBX9wRPgt1BpAto96ihdQHO9ABvLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZA4fPBGZYwURL4Rpgmh7ekwKJ8+5FafEKf9xYPDVtE=;
 b=fWmlEgAcu/5zpvOSakObK6KO5K+iEPUJyk6hc/YZ4mcJu7F4VE/bNhAv8YkZWKaFFrbBxFqGicMJRl/rFZslyLehGFHOSQmYj/H+jKTmpTgr6lZJ4BBhil5Ls68Prlqk0qo/1WeX7J/KaEx1qtIC0Vke9Qpj7zDYj8vkgnjIqneW3mxZPdn92QOq8mhgdah819ZGnP/VTpwJMa0/8mpEcHJIMXHgZjJdEbXXAdv8IH6L2HgD7d69estzfn0Jm1D3b26ZyvLReGXXJ58ZaXxo9RSXlsRl+M4Obk3sd8QsJMMnNmSJ5LrnjbaPWXs5gclErImfl5uNDcRb1gxu4+RbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZA4fPBGZYwURL4Rpgmh7ekwKJ8+5FafEKf9xYPDVtE=;
 b=JqXQQBzI8ofwhOltiK6DsWsa1uxrD+rr5fAiIje0whxTlQf8lgfwEOoauf6oSvjk/kxQXnOqEaJyH2j5eCZvH9LatKKW6mBwaBJN0/oxjlL7e9SVhl4oEZkyqlfEhQyQatg0gmvC/VfZf4hdCjL6fUEQSyQ1heX7PuW9zVeAqOikIBETknmXkumOrd4nxQoZWuf+dNHBKXFHeqY4l9AKx08NAsrXU6OZo3+qYDueEe5gyYI3DEB75+udJF0TBXe2lIzlt6EUU1WvC6JggTmoWGr5zjmLA4H0LOfK5foHBbZP0iBU7SwtiP3AZD4RtSltD6Ske7BeYHdwJkoHGbpeTg==
Received: from BN9PR03CA0329.namprd03.prod.outlook.com (2603:10b6:408:112::34)
 by PH8PR12MB6940.namprd12.prod.outlook.com (2603:10b6:510:1bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:07:23 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::f6) by BN9PR03CA0329.outlook.office365.com
 (2603:10b6:408:112::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16 via Frontend
 Transport; Fri, 26 Aug 2022 16:07:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:07:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:07:21 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:07:18 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/4] mlxsw: cmd: Edit the comment of 'max_lag' field in CONFIG_PROFILE
Date:   Fri, 26 Aug 2022 18:06:49 +0200
Message-ID: <cd4ddf9d7b6825072402f0c7e0f02d518dac5e3a.1661527928.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661527928.git.petrm@nvidia.com>
References: <cover.1661527928.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c40900a-10a6-4d78-121c-08da877d0f99
X-MS-TrafficTypeDiagnostic: PH8PR12MB6940:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHth6RXQ0DpLZTVNQ0LMEdz4t2BzikRkKIO2MvJ1RSejt8plm06KSfHvs2hBdWYJ+VUCt3kBuCanIrqkxtXKmyMA8P1k/XfmZt1uOoFuGQp9+ltVLeGT+ojOysSw5S6CY4g+YjlUZ9jlmSVZzR8XN+hb3wo6FMaL6oOazogSs9wxAyhYDzovMbSQzBKXLxspMw60CfqSaCpUafDGdTLRh2253RRP4eu7X6Cqqo6IHNkhVj3ogJtmedLX9BEAskvFt2CWgi0VqwP1JqDWGh6Sy8W7UZHXNuQO/uuqttqTURUHWtAeNgbrdVQpj6jh6H7r/bTCv8hVNmavthrFlfzUassJOmyIqkRnePRj3U8IfEHFz0CTuhYsvjoPFNCCGcGS9NBovEPhCYFsYkcWwqvfnEQ8mZHV2/vI4a1xre4WE65btnJQz1oHeKuLRusuar/hxC1H6++V7iLKYOeMw6h6BFb7EkEudyDzX1VtgXnvtjYIJRY44vbZoHEO088byI+MRU9RFyU+pVeq/Vby4QtbhrioSYSHaR6SQCSUvghpny2VzBJbPMigY3tOdhrKDWkFO4Ku7ehH/BK3PD6riBVvgK6gk24/KelehJ9q6yzDux640CZcU1iYB7hRKDq8kTUxq+V8K6l/PTQnYN9RMpK0ed4GRMSTFJl5hBY0HKe/9E/Nc6amioyJH6XNbNngtvKNGVuyFhIxKLo12HbuBh9VXB4dA6R3Ny77g9HnTtaAb6WT+fIUsBTxdZEq5epdYYNV0BYigc1m34C3oe9bkOQnFsy6TC4rmr0i8iGcNNV5qJL/AWwT02549jk5Or6r/Zad
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(46966006)(40470700004)(36840700001)(36860700001)(4326008)(70206006)(8676002)(83380400001)(2906002)(8936002)(5660300002)(316002)(70586007)(36756003)(54906003)(110136005)(40480700001)(26005)(478600001)(16526019)(186003)(336012)(2616005)(426003)(47076005)(82310400005)(41300700001)(82740400003)(81166007)(356005)(40460700003)(6666004)(107886003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:07:22.6979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c40900a-10a6-4d78-121c-08da877d0f99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6940
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Starting from Spectrum-4, the maximum number of LAG IDs can be configured
by software via CONFIG_PROFILE command during driver initialization.

Edit the comment of 'max_lag' field to mention that this field is reserved
in Spectrum-1/2/3 and describe firmware behavior.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 60232fb8ccd7..09bef04b11d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -703,6 +703,9 @@ MLXSW_ITEM32(cmd_mbox, config_profile, max_vepa_channels, 0x10, 0, 8);
 
 /* cmd_mbox_config_profile_max_lag
  * Maximum number of LAG IDs requested.
+ * Reserved when Spectrum-1/2/3, supported from Spectrum-4 and above.
+ * For Spectrum-4, firmware sets 128 for values between 1-128 and 256 for values
+ * between 129-256.
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, max_lag, 0x14, 0, 16);
 
-- 
2.35.3

