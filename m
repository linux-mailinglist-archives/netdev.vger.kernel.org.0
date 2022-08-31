Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251A85A79B2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiHaJDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiHaJDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:03:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F31C00C0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3N0f6qeWJwthwNxMKL2Eq4eDbL65MmVAvSVJL3oExbNw1Di2koVJ8KvCtKqVCkvPld/chT7Nds9SlZB/D96PVFJnGdl7CayvuLTd8Nvc5MAQhnsG+q9UbjJBr3KllBC3Dt/eyz1SIHKFlDE4YK0CFsvlWv16lWJGjaYcsaJp0fk+rNbuegXjpcefNBJ4aaQzkrfZIzvkrctf/pEccw93EHwQWyvb8LtsU89Fq7Ahcrzz5cvSYyKGUz2v3SonXBxUuix5IRMF+6hPYK3b0mnUFEBQMSVI2r96Z4W7fH5fYH9J2Npa6DEfx7E2O5wVzBa4BLzfSMX2gVL4nHVgaPOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=bUmXEXBjYYBpmjqag8ylgsqFe3AWLobL8WE2eD/YzheIXEtLW0gE4GhHmrOfniB+eRHTpoZb6HoB0/qDEKTXAsys8+0nrNaSMf1fMWbCbuPrTR1Zmy9Jb/eJTw+2hn5lVGedjKCOlhYAwgTUJd6j4nBMkGUMaMhZ71KaxGSIGx85rSK4qGpCjlNMlO4mX2xe2UOgOSk9ifESMYuTeb44TkYP96gjJbJy5Q8jtHjKYqU+hBrhq7weXaX7WaM6OwxJXpcs3cQ9u6nm8C8JPj8meJRMwUIOuCxhZhhPYzLP2E+SU32pFEqHSQCfNV5sOhsXb7qIMlZkwOe6uhH1g7k6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=CMebB635LaU+qMx9P0t6H7qT2PNZT/UL+IyhY5zzh4YFyuqly9GYVJaKRdE16qGB2LzvxCWnarJXxgiTHDuaWafftcRXNd72RGGit4dpO4MaU0urC/wPwFr58w0mM25viU+CXsG+Xinrb7icCH/t6tuAo9wX/WC/pXC/c3naCrYZ7k+x911D83ygn73nHoEmsvu9FLOsaMzrE6F4nL6Yu+IyqQM6lIdwbz6HVRunJlB8Vs3pH73dREryKv3z7wyjn7S8dzuZHlp1baSJcd3iBwWP4nfXPMfZ6e4p085p6mDkp66E2Q8f0+5yjfFGmJgT6HResqltmOdLk7tl2A39ow==
Received: from MW4PR03CA0342.namprd03.prod.outlook.com (2603:10b6:303:dc::17)
 by PH7PR12MB7137.namprd12.prod.outlook.com (2603:10b6:510:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 31 Aug
 2022 09:03:31 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::98) by MW4PR03CA0342.outlook.office365.com
 (2603:10b6:303:dc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 31 Aug 2022 09:03:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 09:03:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 09:03:30 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 02:03:26 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v4 0/2] Improve virtio performance for 9k mtu
Date:   Wed, 31 Aug 2022 12:03:03 +0300
Message-ID: <20220831090305.63510-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3762efb-f531-4808-0c11-08da8b2fad1e
X-MS-TrafficTypeDiagnostic: PH7PR12MB7137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OjI+6N4GUwC3up4NFPmvPiYX1E6gntCPWwjmqFyuyMnXpvXe+g7P9y4lnUClXg9Mw83e+cwRBicVwMrxQPn1Xye2nbI87JcKvW3qb9QN0ozjC82d7tYcERV01fnfbhVEkU0kiyFVOQ+ETG1OyERoVU8Yqs14WhczervELx1GCCFjM0khbtgLzRs50IlFjw8VPRiD0lxU+OK5ocCFDgHMm6QVHFMY6ASb1Lqyo6xBQ+Cf7anlKxxaFiPL51w3iN50Gcsb4oTU9neryBfm4lCYkHYcDE32k8zhd9dfxqKQMhRZquvnfDIvxt2cPrsbs1X8IbVhW0S1IwLZhshb74anVOiRqU65MLARPqJzg4EPITscDvY+W3nZYup17jaHH9RKANbwQoZwNUfzTq9mKLPFIpj26Qs/DeE3Iq388W8n6omuy/R2IyP7/t396/fCsHvwJh/gqMHA/IGSCTwiXtmBSAGtI5hV2GsZBs9PrgOm3Kemfur3M4qZXCaTEcR+Tgngl/ykh4gXCY7UqRMy403hSrzdOfcK9UL81JDqhKN3SEEtwMERmBFqVZfUhJknh1IrWXig8NIELwDNnv99Z9AbD5crj7iCBOD0sdnjnAWMFGQv8Q0u0T4eOEgGnNXwO97sxQrBH1A8Z6hPsnrFerUbLcPgChpaXQCEphztGw69cNmqnisN02JHcysZaydPo6Xij46JmN0IqOKb6Tz1NmeTJforpYMbSRJ9+f/ZfhEVqUXTW4uisHRQhPbmpFPbqXkTffN+OODZsaoWhotmGHudRjXvFdmyvXkOAGSif/4Yo55jfmQBsDAyjtq+L+2sfhbQ
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966006)(40470700004)(36840700001)(82310400005)(316002)(40460700003)(4326008)(55016003)(8676002)(70206006)(40480700001)(110136005)(70586007)(5660300002)(7416002)(8936002)(82740400003)(36860700001)(4744005)(6666004)(107886003)(7696005)(2906002)(478600001)(921005)(86362001)(36756003)(356005)(81166007)(54906003)(336012)(83380400001)(1076003)(6286002)(186003)(16526019)(426003)(47076005)(2616005)(41300700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 09:03:30.9247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3762efb-f531-4808-0c11-08da8b2fad1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7137
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains two patches that improves virtio netdevice
performance for 9K mtu when GRO/ guest TSO is disabled.

Gavin Li (2):
  virtio-net: introduce and use helper function for guest gso support
    checks
  virtio-net: use mtu size as buffer length for big packets

 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

-- 
2.31.1

