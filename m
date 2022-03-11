Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809834D65CD
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345585AbiCKQKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbiCKQKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:10:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEB1177D1B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:09:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS2831o8x7Nr5atzcfIXc7YK2+dglHy4QZXuL5ldG1bsCyb7RBbMeb+lnsNw5ClxnchBHF1nr61DGfQEBjqFCrHpuoGXuVZDte7tlGX4/Me0B9ECgxFxogyWUF/MqGrCKjjT++Z1vscVPjdCwgZGixD/tg6sS9Cf98IZWMHsu//8qCOscrNqlEXkwxvsdF6uSKz0lRNF/DMuHAa+ei/SUGDfB5MtU23S/CiZTwId0V+tK89jabowewa57SdZaslAVhP23vq87uCAmBl70Tu/2g5bVaNaJUk+Q8NknsSCaWXVIuKcR1X5AuVvmWgFkVxF6xVhG9qlAJmp8QD7e1Ygqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jkm1A9R55CGC5KXjVW4si15mZ5ixzwj4v9qp3D3W1ZY=;
 b=Bp98Gn9i25YhBpBPjiHqsJg+0HRYbfcW6io2J58LQDORI2Y43EY8wxoH5eqsnkNeWcOt/GWzYxYNL92os0JnczFoyCpYqfmxdArYjNCPKHSU86cf66ylARA/OCkgn3zG02mX5Zll9jMVAAKUOnKjEBiJwuh7litFdVVKm/8DhZQ8v5KXBTW4bFTUFYMZYjWxnommBQbwyemrpG1jtTuYgZ8xnPz0nGIr/sxPdC2rxIz63DiixFm7RueanGRNAu5/xkpk/YuA8hwy9wpBMhX6HoOYTG4Z481qXGlwYv3BTknfzZs8p8R2vQeRA/VU1oo9+bfO3W6cx4WHQm7ya0fqXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jkm1A9R55CGC5KXjVW4si15mZ5ixzwj4v9qp3D3W1ZY=;
 b=CjWR4OAcrf3Gkxst5yTUDyvwwYx4mPUYwBu++e5tvNW9NdvOH21WlJQX1T4fAa3anii89eM41QEUWuKFzqaDUvXQ/3b2+TG6QXJxXEn8ycesjC2pvyaDXUk1QklHuMUvlHcWUW5aZ3u3Jgfl9XlKANLY3+cTmyJnMboBF7WNWgpuCJIOC3+JkqdRrex9pB1W1LlHjPyL20GaNa/KrwTdL1nv/YvGL18EGB/UdH3YMEjWXsIGVOAdNRHtMqtxL3WjEfh/lunzmsf1n9bpwwzOhn+tzT3GRvmHIACXtbVwW+IIXhYsGl3NO01bNOaVP3tqqFcEo+neHm8qKwZNiwXI5Q==
Received: from MWHPR13CA0008.namprd13.prod.outlook.com (2603:10b6:300:16::18)
 by CH0PR12MB5371.namprd12.prod.outlook.com (2603:10b6:610:d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 16:09:42 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::4b) by MWHPR13CA0008.outlook.office365.com
 (2603:10b6:300:16::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Fri, 11 Mar 2022 16:09:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:09:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:09:41 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:09:40 -0800
Date:   Fri, 11 Mar 2022 18:09:36 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <Yit0QFjt7HAHFNnq@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-2-kuba@kernel.org>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad880222-6fa6-41ff-df3d-08da03798d27
X-MS-TrafficTypeDiagnostic: CH0PR12MB5371:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5371BDF989DDE217C891AD77BD0C9@CH0PR12MB5371.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ffqCrdIuxxlMfZkzItuT+8ap39tXFswarL3v2rmLdCiuFtVctVfcb7jvVJ1mVhZZGCxxjzFLiaRQq2UtZX9t8TzJ2VI9GI95Mlgs1GsCIDukirj2LWdIgrXxRECkOzkeFvPJonzDGmcS1Q/MMpkkCrfKGzq+MPY9F2kPqG1gDbbFMSCCjNy3SrdSIwesiCKZewxSygFkMZDPEkevBIZmsbaqG2hXDN3Ns0VceFXB0ndf5/HuMKtB2P3oafRCbU01cVQWlDhTmKx5qFOVFOmX8lo2tQtnQ2KcM9j//+ORzwjQpoQWo2QVQL70/jtnafF4lOVW+rZqlFuQ7Xuz4nEtC0/li3h59dq84ZR2K2o2XaAa6uD/D03M4zAH8lPwEtPuUnXamiiib9UOOCfLIIuVrDqMYTQ7OB6Gr9U/3UTzRkDTBaipMsIcK7WZkDPSsKY57sVriMjHgYYC/dPyfA2xZiGhFjgQPq0LSXMkAKQetG+bIjwu8vo/tMBlm27zMGKL7gF37w+RDyUhKLPpRWUVP1L2rBgKukEfmnAJO3iNIYa84ltqPTNgknjapgXwh5q3x9Ewn8TFBva4U8HkH6ip8hJo7tUQ8puSVXiNYyw9jleikYJrH2DbJ9nd5h3gNQDiGcLN5X+/2ZG1RdsOLZ+/WbYNTCgC588YMQtrhv2RNPAS53lOmB7g5jNWvQHakbEPeyXX+18bkVdKk6rY2D2NvA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(7916004)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(356005)(2906002)(86362001)(70206006)(70586007)(81166007)(8676002)(40460700003)(4326008)(54906003)(82310400004)(33716001)(8936002)(316002)(16526019)(426003)(26005)(336012)(6916009)(186003)(508600001)(9686003)(6666004)(47076005)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:09:41.9223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad880222-6fa6-41ff-df3d-08da03798d27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5371
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:16:27PM -0800, Jakub Kicinski wrote:
> It should be familiar and beneficial to expose devlink instance
> lock to the drivers. This way drivers can block devlink from
> calling them during critical sections without breakneck locking.
> 
> Add port helpers, port splitting callbacks will be the first
> target.
> 
> Use 'devl_' prefix for "explicitly locked" API. Initial RFC used
> '__devlink' but that's too much typing.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/devlink.h | 11 +++++
>  net/core/devlink.c    | 99 ++++++++++++++++++++++++++++++++-----------
>  2 files changed, 86 insertions(+), 24 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 8d5349d2fb68..9de0d091aee9 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1479,6 +1479,17 @@ void *devlink_priv(struct devlink *devlink);
>  struct devlink *priv_to_devlink(void *priv);
>  struct device *devlink_to_dev(const struct devlink *devlink);
>  
> +/* Devlink instance explicit locking */
> +void devl_lock(struct devlink *devlink);
> +void devl_unlock(struct devlink *devlink);
> +void devl_assert_locked(struct devlink *devlink);
> +bool devl_lock_is_held(struct devlink *devlink);
> +
> +int devl_port_register(struct devlink *devlink,
> +		       struct devlink_port *devlink_port,
> +		       unsigned int port_index);
> +void devl_port_unregister(struct devlink_port *devlink_port);
> +
>  struct ib_device;
>  
>  struct net *devlink_net(const struct devlink *devlink);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index fcd9f6d85cf1..c30da1fc023d 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -225,6 +225,37 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  	return NULL;
>  }
>  
> +void devl_assert_locked(struct devlink *devlink)
> +{
> +	lockdep_assert_held(&devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devl_assert_locked);
> +
> +bool devl_lock_is_held(struct devlink *devlink)
> +{
> +	/* We have to check this at runtime because struct devlink
> +	 * is now private. Normally lock_is_held() should be eliminated
> +	 * as dead code in the caller and we can depend on the linker error.
> +	 */
> +	if (!IS_ENABLED(CONFIG_LOCKDEP))
> +		return WARN_ON_ONCE(true);
> +
> +	return lockdep_is_held(&devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devl_lock_is_held);

What about this?

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d5349d2fb68..33b47d1a6800 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1762,5 +1762,12 @@ devlink_compat_switch_id_get(struct net_device *dev,
 }
 
 #endif
-
+#if IS_ENABLED(CONFIG_LOCKDEP)
+bool devl_lock_is_held(struct devlink *devlink);
+#else
+static inline bool devl_lock_is_held(struct devlink *devlink)
+{
+       return true;
+}
+#endif
 #endif /* _NET_DEVLINK_H_ */

