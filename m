Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5681265CDCD
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbjADHqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjADHqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:46:10 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020112090;
        Tue,  3 Jan 2023 23:46:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3oTL+6Vfwo9ah3XJkdiE2Rue+w9UNeHzZsY0lT0iSOiglfo4S6dWYZso8Yf6z/NoUWCz+RodlJ2wvRAEvoPVjMFBimFN4f4X4WpzVUAjKTTIbz37/WsX3cxpDM3aSbLtglyDGVzmaK95b9OEmAMP4j9uRrTqzRNqhCws2bpQSJosZ47DHt+Kf9YxGv0RnGYMH4nQTvB6QcX6K4RGO7er1rryxB/VaC+bFl5O23yzB2QtpIopMtW8pwToy+RHBsU/h8xAqdMlE/8YfnEJMRDdkaV4G+pg2N6UxSNdbY0yI9lXq84hUzj22v1kIfsYrbVodWTWxvbw3AjEE9zggO0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bT/vIZVnNnfkBV88+kUVUCno0jTbRuUyBME6Y4+7Qvs=;
 b=IzyPotaPUhVlPmB4MrtNCG5p7OhfiKr6uXevUDJwsr2pTG9Il6qLjwiqs4P6lTEJWmZbc4OO+q85z0BmvHEE84xwbeW6ljv0r/3DzX6krNjRfOwahbtzP4p/cyKtUtNqJBNRbxgYJE6Wr5nn3tpABqurrVbGUYREF2IEh2oAsiBE+Pcmx4wCJknqXf3be2yX5XHIVwzywP+81kUbVIMsTg0NbO5wjyAKjz/H0NvWqRAlfB/G1csOBQyF6YidKTxJJcv2lEjJCAwrJGE6q62++T6NcYONwPHefUAHFTsbmhqa73y7pbABqL3ylM1chkV78Egs+4EE5DrfyJSHiS6/yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT/vIZVnNnfkBV88+kUVUCno0jTbRuUyBME6Y4+7Qvs=;
 b=FKk3MMdSRKYzbRRKMSIDl2dTbOzGnhdACdZX/ay+7YibmjmpUfIyHWnXgpf4yR/FjWVVA5ZSH9GpLXqITI6qrdsE7vbeAE8Yy1szirx89yprFS6eP6Mt2r9wKLDxe0QFBImfE3hPLtcyLNPKs0J6YARUInVGkuoAKz5KFF0p+6U+S5haKbXZTIqWpPfygOR2BzzWu7ugfqrPiiAvI16J3JBXJiJEimqSMzJt2RtglWriTmNY/pKY7vq/mWiBX8VuGbjHZELTFxppYty4bkUlAoiomhmsfu4Q3IHNyXs/GxfGPrXR+WBGjESLvlwGjNYtjueKvJ9fvbbeprS7SoZ9hw==
Received: from CY5PR13CA0043.namprd13.prod.outlook.com (2603:10b6:930:11::33)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 07:46:08 +0000
Received: from CY4PEPF0000B8ED.namprd05.prod.outlook.com
 (2603:10b6:930:11:cafe::78) by CY5PR13CA0043.outlook.office365.com
 (2603:10b6:930:11::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Wed, 4 Jan 2023 07:46:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8ED.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.14 via Frontend Transport; Wed, 4 Jan 2023 07:46:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 3 Jan 2023
 23:46:00 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 3 Jan 2023
 23:45:59 -0800
Date:   Wed, 4 Jan 2023 09:45:56 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, Dave Ertman <david.m.ertman@intel.com>,
        <netdev@vger.kernel.org>, <shiraz.saleem@intel.com>,
        <mustafa.ismail@intel.com>, <jgg@nvidia.com>,
        <linux-rdma@vger.kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v2 1/3] ice: Prevent set_channel from changing queues
 while RDMA active
Message-ID: <Y7UutHc/1QBH4ude@unreal>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
 <20230103230738.1102585-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230103230738.1102585-2-anthony.l.nguyen@intel.com>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8ED:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: e4de208c-d6c6-40b0-7b6e-08daee27bd86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWm/9M/21ImcodZtLxnmkehUDz8MUeTjsvmHiCfc0GKuFvisi5ba1RbuMfCCjrVb4l5Q5YFNQyr9Rkfm0d2KpqssZTfZStRhYDcpywFzzfa5XyHautysBGYQxyEM/CrkDZ9JUbhOCI8ta8SLte8q/iX7ZPkB3Drwq84YW/7uI2FeuiuDxHOX8lfY0bx3xeelH5HEPC0dxrNNxdED3/YYxeHNKyAarU+USpiV9P11285V1ifJ45Hr3d0EEmVgNmnhad1NV/6Q597T2XEsLrF54060NRNcAIInrvW7KdwipbwiLKASKWzUP/A1NMWGGtd6VqAnA88z4GEooP0xjIocEZi1w9BhvocZI5iyBNT6VG9fCnpApkHvDQPxS78GGtAHbPkFkgTUTQbQ8eO1etS1gNuQH4p8ljkWrQTiF4kVgScB6YkOemXEZqjJr7sXSFt06AcCb67UELTbMv6qVYng5/R6LC4PdkSe+dA8uk4Nt3DkKrxUYlbS9CSzzllO6syElDi+NYAdfygxmY2+pSWFl6UzPlmcTyLbCyPIx6BoKqOs6KupveqAITC2qrBJkAJHyFTc7bnQyPdQ+EgI/dQBQDDOCFnrVcxOTjzr0LAqdg4BeRaNmcDAKzwItROn4H1OvP5B89ITkivpNIY4mfHjkSnfaF8L3A1qlGyTLUJU+k3Dbm0INkzZyF+oU3imcaJUXYvQpe/RK9kojaPdhgeB7g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(16526019)(9686003)(70206006)(356005)(82740400003)(8936002)(4744005)(7636003)(40460700003)(40480700001)(478600001)(70586007)(5660300002)(26005)(336012)(8676002)(86362001)(36860700001)(6916009)(54906003)(41300700001)(6666004)(33716001)(316002)(186003)(82310400005)(426003)(7416002)(47076005)(2906002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 07:46:07.5626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4de208c-d6c6-40b0-7b6e-08daee27bd86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:07:36PM -0800, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The PF controls the set of queues that the RDMA auxiliary_driver requests
> resources from.  The set_channel command will alter that pool and trigger a
> reconfiguration of the VSI, which breaks RDMA functionality.
> 
> Prevent set_channel from executing when RDMA driver bound to auxiliary
> device.
> 
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
