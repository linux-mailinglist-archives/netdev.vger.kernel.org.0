Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ABA5FD6F0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJMJXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJMJXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:23:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33EAFA002
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:23:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foDDa3BO8Q2LCiEE7cBBJAxQCgEDHHqAHzS0WkWUopXBPtKOBhoc0usop++pcD+AJ2Y7vFxBIccmI0yjx/Dfw3LXzDs5nfNwQ1WRTkuvLbOF7dWnnjTRYzlON0A2y1dC4VEEfLHVIiDjOcZmj9dXDk72Q6TBCdGTpLrNV4pX6A9d9TjYyZ3pdZCoeylTS29puDmcQDTmuA++ppVafCsqyiO/6+xGu/lFPT71uJ/yxQqI4A+0fUu4CM+ryuh/k78GAdsgzD23RdjkrvmyiB/o3lJhEoMVKtkzbt4r+jjGT2p3fkDG9WDpODzIHbBWqaTHcxAy4ABARQ2zMArOCyWKAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VtS4U2lJsamU7Z35ZKL9HfQWhKppLQ9EGze7Zp7y6s=;
 b=gTfeEm5cAOgpZQzHLnj1xj5O4qy0GB602tHb6tTMkGl1mnYHyHdjmfxJL9zpV/VXuJK4AGfqFokmN2mFSHIitgFLjBwHU1GW6bRNJEVfz0+Kso2Ne7EeI/3CXJ6QEiDr/eTUQ90oDWbL7WZrOmFaphdctcGstVwFdS44ckNd49V8/zgpiYiZbydFpKv2VEyYufPn1FGD2J16RcKNnhut0m54RYQAAtemmHLOIGjVIAe0/B3QvpRRuY5vLiYPFDN+4vpIsUbA08uVy0aveD7PtO+hqIKIdyvtFoqbVYBhI7Dwo1zunNSMYKpokVutUQhudaD2dn6gDgGlg7JT4jhcBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VtS4U2lJsamU7Z35ZKL9HfQWhKppLQ9EGze7Zp7y6s=;
 b=nli/NNb9UpLxdkxjQSoBddparcgk2O7qrM8xfrmcRRqna6bf0LYUOlb2LeFN9qxzEHCSy7RUG90pCCNQHX83mUtmVXID8OQWlNRuv0iF/fZmSodx3kBAtZDxUUAaNLt/rNUuFigI7CqTjOB+NkEjwelTzg4xJEuBLz7uIvqxbxk=
Received: from MW4P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::16)
 by PH7PR12MB7282.namprd12.prod.outlook.com (2603:10b6:510:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Thu, 13 Oct
 2022 09:23:25 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::a9) by MW4P220CA0011.outlook.office365.com
 (2603:10b6:303:115::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26 via Frontend
 Transport; Thu, 13 Oct 2022 09:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 09:23:25 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:23:24 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 02:23:24 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 04:23:22 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH v2 net-next 0/3] netlink: formatted extacks
Date:   Thu, 13 Oct 2022 10:22:59 +0100
Message-ID: <cover.1665567166.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT054:EE_|PH7PR12MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: 44100a70-900f-423d-3a20-08daacfc94d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpRZHACJxqQiVY5VcQu7IP4fu7LvZaF/0qi0agKeJFA1EUGl3uRBWjHK6UuFU3Ugsns2/oB0NS0SNN7drkvUi0KYT7pzfpas9CQbPuepCxOGT0Of15G6g1c2wmmtioUSvcVw8x8oCEIQA0kweK6zh4yMbqQxNg3hXAER7p7Ii6U7wS1H/uwGvJPMraJUE9WyFxbifxnNR6VJeWqmy3tyWZ18Zpoa2YxuVJvkLZ1VsUKSKHf/gDF1LO9TzikoWx89zDGDxkC8c9vQHB2MctEfinSd0f2ioQbBTskxj4dcO2HndpAac22Hz+CXFhwnS5tYITvKnKtQ9trB33CAWSr9tel9qEEuCD8b2Zh/tDGKMalZAsbPXWFWPNzHybAUWnrNvFNQzdNKJwSg0mPCeWMtnMZhOSJx3zNwJ2Gzhk8Y9KI4psjU8WfvFMVPExKHQaewEnE+a1M6M72PAZa4o/2n+lUmcz9qcTiTsX9lYG+lZvIBsr06bO31uHMqw88ZuyXgYY58hko1f9jN44cOLB+fEVpgNQGf/8WV3M9ttcum60ZBpp9NuphDvSMT44UYil27L0Hx4n23kIQCW4qN74o45Qc4k8wjdd0W79riLl7QbvUbEa3eBh+XOieXd0ubUaB7yAQ50E9MTILPbVparpT0jyZkBjfj+JfFl2gJC+jw/WvxTWCdzRRaF9l5TGxc50ywlbQawP6I501o3WEVGiuM/sGfd30Grgon8wwm2KJSGjjt+8OoPpxqER6E7RXi5FXdgNtg+c4a8rmK3Ek63sZr7/EidSIBNp0bBPYHiHCXWuc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(2876002)(70586007)(186003)(81166007)(9686003)(316002)(6636002)(83380400001)(356005)(2906002)(5660300002)(40480700001)(6666004)(26005)(8936002)(54906003)(40460700003)(36756003)(336012)(4326008)(8676002)(86362001)(426003)(70206006)(55446002)(47076005)(36860700001)(82310400005)(110136005)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 09:23:25.3169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44100a70-900f-423d-3a20-08daacfc94d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Currently, netlink extacks can only carry fixed string messages, which
 is limiting when reporting failures in complex systems.  This series
 adds the ability to return printf-formatted messages, and uses it in
 the sfc driver's TC offload code.
Formatted extack messages are limited in length to a fixed buffer size,
 currently 80 characters.  If the message exceeds this, the full message
 will be logged (ratelimited) to the console and a truncated version
 returned over netlink.
There is no change to the netlink uAPI; only internal kernel changes
 are needed.

Changed in v2:
* fixed null-checking of extack (with break; as suggested by kuba)
* added logging of full string on truncation (Johannes)

Edward Cree (3):
  netlink: add support for formatted extack messages
  sfc: use formatted extacks instead of efx_tc_err()
  sfc: remove 'log-tc-errors' ethtool private flag

 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 -
 drivers/net/ethernet/sfc/ethtool_common.c | 37 ------------------
 drivers/net/ethernet/sfc/ethtool_common.h |  2 -
 drivers/net/ethernet/sfc/mae.c            |  5 +--
 drivers/net/ethernet/sfc/net_driver.h     |  2 -
 drivers/net/ethernet/sfc/tc.c             | 47 ++++++++++-------------
 drivers/net/ethernet/sfc/tc.h             | 18 ---------
 include/linux/netlink.h                   | 25 +++++++++++-
 8 files changed, 46 insertions(+), 92 deletions(-)

