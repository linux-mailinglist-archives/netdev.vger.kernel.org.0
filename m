Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3B609E02
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJXJ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiJXJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:29:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C26421838
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:29:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wo7MTMYbACxDsiIy/R6C6IVk0PEaTxXbSLDQR18PXV3qM8ewn9XPQdBt+7Q/H3zqUhNR7i0xl5Ymmt2u3CjbA8AhEl/uUX/QSSKIaXtmuGDon38zhVe4Fms8hxNz6/8f7OrLuls4YB/W/lx5+aXo2IfuVWxQ3Om+R9w0dyuXhwaZOs8x6VcgxpjseFxxbxIPcmbmVQcfhP8r/F2b3BrS414raF6cMpC5Bekj/uXkEAHpcobgiZZF7syOoqIL5k8Q+XkY1TdHECOIMpb4gzQEvVf9UW7IQbdVPmSC2DAMitP61qcql/7VAPPkFR/wO1Fm1yzPvv/qd7rrC1CAQBY1fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50FxXNKwhi43xB4HE+8uaZVWgMolTSZzQZ9rvGQpBdI=;
 b=k4hjkh63oOPUHtfmFHy+EcT62FiKiWoyqfR5fUCoV6K9XkIy0zBpdEiO88ATWR7Zbw9IeLNtBDT6aBOxuAnDcVBrRUgUh2PNb8z/YxLKnO7SXZCV1g3q48C94ESwuXeGLUyU49wYO1dBESQVwtiFA0c0CntLcAalyGGWPwXtXHDYtF9seFKCd3VkBXGHQ3eYVmEMZ5yzgA+StoOrRnzjhymwwRIr33KiiHW42vUtCyCdNViLHgTOLWsYArePBGlskbvcea8s6WqICw5IW4K+OolKxdGQHH9pbe2QBmiIWYMrEIXNCOVqVEBmocU5x3iwhk9+4NsUgvuPCldXaCYHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50FxXNKwhi43xB4HE+8uaZVWgMolTSZzQZ9rvGQpBdI=;
 b=uQhpzQF/ZWqVk/+bek6/dtA0IJnTQ9KBbDxwcMyjxDpkKpgJE6utnWcVeoizpASD7yEswRdcXD/iU+IjCAqEr8jAiDPcjjUOsqVU7/DkwMYdwUXCAVXMznWUXYb2yg4XVeOjHcsCSx6yE500Z1i7pSR3ZNd3kgDJPwWMi3n0vp0=
Received: from MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15) by
 PH8PR12MB6962.namprd12.prod.outlook.com (2603:10b6:510:1bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 09:29:48 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::61) by MW2PR16CA0002.outlook.office365.com
 (2603:10b6:907::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Mon, 24 Oct 2022 09:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 09:29:47 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:29:47 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:29:46 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 04:29:44 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 0/5] sfc: add basic flower matches to offload
Date:   Mon, 24 Oct 2022 10:29:20 +0100
Message-ID: <cover.1666603600.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT042:EE_|PH8PR12MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9d4daf-6a35-4598-e0b5-08dab5a24b71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8TPaCCoubTZH2o9v4Ie0lDvBo4N2d+4vrPlUcYZK9yQGCRNJ7Yehlh8GBGk23TRc/hhjXanusE5oKAs9h5WT/wGdb9iWoe9LBzCR1P9mNAos0bS7BSvcu1S7m5JU7KIQZ5l36JB4ei3MgzkUI1dL0po40Tvsaj6w2otPkfORBpUce+Ox8xVO4M0U7IoLyiZaF7ao4TzOv2KrbqO+1J8XS6CCIbmr7CwDfiQUyng9AQqLVG7qSIWmG9bLpvjaBRTe8k1z7dkPu+eAs7T+EEjEzxhKHLYDzasHR+g+7IQ5r53rr6hvEjsb5y1MWaQOF2eE5x+JxWFL4GWBd0z9n8dIo5RX3cuITeKHth59sU+e1EMP0O2kYon+xgKtS+kGWW3z8HWBRbROuJBj3bx1kEUAzbloTgARlyqvx3pg77QKfzOhJZNIN2BbKPO57b+1hd3WPd5Ot925V1j3Og3ENAXWCencrXYurgn59fsOaYCrH/H4xr0JVqgIUAoULcRx6Tz2tlPW6F6TUacpSmJEXF47vOaWk6SBjYSrKjDumgvZuoxr6ByzmW8wURZ2fNWHw/oDgTlSrgdYbyvu9NrhFuO/twMnlNzDWioYgbwVrKlVDXDtEoF4JD7tAO2J4xYvaenSqza26IzIZyCk6hrsm1kwyj5yPRPxxKD7DrF4t7ztuDqAynoJJ9rsAr4uvi4T3XRLxG97qz8Oi/0NK8dGq/k9IoEZRdqq3VUkiwH+pqTl1MQ+Wzn72v8IQEodOCLBoNVNSlfQvNL++t4X+Bf79Pg58qkT1xPzKVr8n8VT9NXospqLSG+0vhoZzTN34NAC2qfk
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(8936002)(5660300002)(4744005)(83380400001)(82740400003)(2906002)(54906003)(336012)(86362001)(70586007)(81166007)(4326008)(47076005)(426003)(82310400005)(70206006)(36756003)(356005)(41300700001)(55446002)(2876002)(186003)(8676002)(110136005)(316002)(6636002)(40480700001)(9686003)(26005)(36860700001)(6666004)(40460700003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 09:29:47.9867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9d4daf-6a35-4598-e0b5-08dab5a24b71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6962
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

Support offloading TC flower rules with matches on L2-L4 fields.

Edward Cree (5):
  sfc: check recirc_id match caps before MAE offload
  sfc: add Layer 2 matches to ef100 TC offload
  sfc: add Layer 3 matches to ef100 TC offload
  sfc: add Layer 3 flag matches to ef100 TC offload
  sfc: add Layer 4 matches to ef100 TC offload

 drivers/net/ethernet/sfc/mae.c  | 132 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  12 +++
 drivers/net/ethernet/sfc/tc.c   | 137 +++++++++++++++++++++++++++++---
 drivers/net/ethernet/sfc/tc.h   |  16 ++++
 4 files changed, 286 insertions(+), 11 deletions(-)

