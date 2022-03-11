Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8944D6860
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 19:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244181AbiCKSVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 13:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiCKSVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 13:21:07 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B101088
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 10:20:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJn1009GXFWwMXISeKe2d9DcJPtVJ55cTxX7PVWfCiPFYeyF6673tmEFxO3y4+R2WwGagyTclCVaPRitvE6TcPSvmfDBK+ZJof8n4BH6FNUvB5KYqMKhHQ4ZnhIIMGchOXQxp3a1I/qzlnBqoK/zKWLA8bk+hpxIshrD2E6oA2EigVHoVHdnAy4BdoeuO39FTEqcoXjky3Aa9yasGX4uLE3QwrjyjClAOGB0+apXcY3JsjQZfglr0o4UvFoMdZvRx99XHFOf7/FShOSxssawS7mzH0zFarQNrVBdsZH9gfl3lCUqp19WkIwNSJXMx1N6BK8YPYMfzh5ZDEt4ytZtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAlnB/9ggqeXM7ZvupLGcv3ARIrG6qveAgoq3Q5CeF8=;
 b=Ow5NPbUh5QRz9NtZRxELhYqAE2a4fj3LcGMPKLoJFyBFG8cuOt3c8frVB6tlOXzt5dHSM+pM50ZDBxszeosv8F+dJB6gxCym75rgyu1fMP/08IcOITp9g/Pp2FxCZNdihJTZBjt8NDVvyl/2Za734TIcNYMfMgtbuDiLboxZ+P50LQq/rHEETAIUeODiKCK/EBmmRGYac5jtXcuh+AGT6OvJJLaLE1cVlp6MSrhrVd4nxBacoUBO9rAaL82iknwsMSyR6xEI6UbLsgSm/1yEvqFCOy0SlprlSktdtH3wFgvcUlVgHoJYWtY2VOriUNSmHbKvHWTbebHPvTU37cGjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAlnB/9ggqeXM7ZvupLGcv3ARIrG6qveAgoq3Q5CeF8=;
 b=MvcQT/PhNaA/C4qo8vLHmQuGT+72XV2Mp2947u3W2TWGOZnd+gra9v9Ll9WpQXmC1oIq7nNFpf8fOzK+6NK47gYemZmgoYZBv0izBdHXeYvfwLWlmCXNz/IAJyosm4Kdsx7GXu8hvUGv+N68KLztvvonnmflUD60w8TQoAy97LY7PEO1Vf/UkKJFmwltJxITskRp1LcnmYsDUTkqGarOjZhJLIPSQJX+yVoAJ5d7F/p6EC1BwLSUVwux4fOH/WxHhjem/A+nC5xxiPfjzndFFA6EktEnglvA+qX5cCD6aGoOlShExpBi1MWoX2WhWZkEhAb5zPit0iVwa4UHOwbevQ==
Received: from BN9PR03CA0551.namprd03.prod.outlook.com (2603:10b6:408:138::16)
 by CH2PR12MB4873.namprd12.prod.outlook.com (2603:10b6:610:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 18:20:02 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::7b) by BN9PR03CA0551.outlook.office365.com
 (2603:10b6:408:138::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Fri, 11 Mar 2022 18:20:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 18:20:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 18:19:46 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 10:19:45 -0800
Date:   Fri, 11 Mar 2022 20:19:42 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YiuSvkjcYL15TGru@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
 <Yit0QFjt7HAHFNnq@unreal>
 <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yit/f9MQWusTmsJW@unreal>
 <20220311093913.60694baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YiuLsDa4jej7bVEz@unreal>
 <20220311100611.2993ff4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220311100611.2993ff4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d39cadc-7f53-4828-5de7-08da038bc21f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4873:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4873CCEEB3D78B48BFBE353EBD0C9@CH2PR12MB4873.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m8GTXW44b77k1wbb6fdILrKivPYv/kf5eI0P+pQA9Bj0T4j0vlNE7MnQydTiLqOqShMUWnHBkVajvhdLQFj50YcPkFuSsRfp+cSBAepuOOPi/9dKRV1hfCp7gs6SLuzNoMsknHl6Wwjg82F/lFhgrrjk8iBm5LmeLBq9sLhskdKZk4I7QrikuuuXaFKKfK3148JZPJoelgHmTUT3xKpJRx0J9JAPwHpXRj0J6or5+kVHbP9NuzhHXucs58uOfgjf5yg5uNIkOX+zd81G2tc2lJhc1qcuoOBJ2jUgcdEPpbnHSk2m2+qrmflCGQPvig90MXPPI4HMJKdBuwFMGni81ivkjRBQc9a3bhRRnLQE5HWIOma1MUHId/4kUqFuMJFfTKEdKRcGwq6Gxa8U6HR0M6QUQW+uHkNlVh33Gm1RYVN3K2YkEO1YckFe37gNzbM4yCI3uN4fvqXZpgcelLpczhNrQxQMZz8O16h27brhvfpJ7rgfQRap5WEB0aJB2CJOq2C/syNU8jIX8wqXZb2jTR9THTZDsKv+zx55a8rPUDn261KuaGAJqGrr9Zg++LDd4NQxb/KWxqxRVhyc3zGm88PVwaRePCfAc+CCVI495RuxUyBvAM2SY2uACshMQbAM4KF6FaEBBdCb6Pg0DS9jGTFLZSYEK5dP5BV3L9V/IF+va5ZQrRhvQXRPVibMsYxAkKyxFR//U9qpNlj/3PQng==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(36840700001)(40470700004)(46966006)(36860700001)(47076005)(426003)(82310400004)(336012)(16526019)(186003)(26005)(83380400001)(9686003)(2906002)(4326008)(8676002)(70586007)(70206006)(508600001)(54906003)(40460700003)(6916009)(86362001)(316002)(33716001)(8936002)(5660300002)(6666004)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 18:20:01.6800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d39cadc-7f53-4828-5de7-08da038bc21f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4873
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 10:06:11AM -0800, Jakub Kicinski wrote:
> On Fri, 11 Mar 2022 19:49:36 +0200 Leon Romanovsky wrote:
> > > No, no, that function is mostly for rcu dereference checking.
> > > The calls should be eliminated as dead code on production systems.  
> > 
> > On systems without LOCKDEP, the devl_lock_is_held function will be
> > generated to be like this:
> > bool devl_lock_is_held(struct devlink *devlink)
> > {
> > 	return WARN_ON_ONCE(true);
> > }
> > EXPORT_SYMBOL_GPL(devl_lock_is_held);
> 
> I think you missed my first sentence. Anyway, this is what I'll do in
> v1:
> 
> #ifdef CONFIG_LOCKDEP
> /* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
> bool devl_lock_is_held(struct devlink *devlink)
> {
> 	return lockdep_is_held(&devlink->lock);
> }
> EXPORT_SYMBOL_GPL(devl_lock_is_held);
> #endif

Because you put EXPORT_SYMBOL_GPL, this function will be used by drivers
too, which will need to write something like this:

if (IS_ENABLED(CONFIG_LOCKDEP))
     devl_lock_is_held(devlink)

Otherwise, they will get linkage error in systems without LOCKDEP.

Thanks
