Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18064DA2F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLOLWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLOLWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:22:38 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349761E708;
        Thu, 15 Dec 2022 03:22:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgDcCu18rNc6OclTRu87QOk/Qzym7X7yNDZ1lleNamr3VxeeGk3oBsuU0l2P0xyeTaVZnzoPZWPQlaH3HIm+wRmjBRmWBThwE5j/AnqiJpEcsfjh6mv9bBI9yFsOAI31EflG0m6m97ZLm21uxRR5G+FJJDLXVhsjyVa5SoFo7V8xV7iXkWLmkv8WB0h4SdMrLmQD8OGPgR2lXKqOB06vRVMotT0DczMo8U6V5llHvbH7z+4vx+r1VhnN23yTeieWilO+Vm/lZQByhoHK3tQfdk3XR1nlhxZ62sqml3iHR6viP9ehoVRr5MX28ETsy0rM+bFClUs6HRxsgotPlgWb5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhTHdYMVKrhX4EQAcmfzpoGJnxscsloVi4RUuC1BRe4=;
 b=MZoGyu73GeeO7HvwICyEd9Ea39lWwo+LN8PMVaQpgDhL3U94Eo0W3zsdxRE+V3MzJVG3imR8piKDawm2dVNdyA9UogRghgMKqGTqdkfRwD132A4tYuBkTRE5n/0G/iLQpUvVz5B7JAqoo+BDyiUgk58rbYJ5EicIH4ZyR0pMOcoN+dGu+YGFjRRAJNqDR5eeMcDpPzhVSaJ6TIAa6X2JPgcLEp5uqmwQu16PH6Fa2Udy0S4/Qs1CbT9JKGMfJg0DLbKyqubQ3zlqwXCYOs0LtNA6fBMzZbZ6/akdHsD+Ar0yj5mepDP+/888qJWFmc5wOQuJ5GnWzgk6J43Nwm1Kqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhTHdYMVKrhX4EQAcmfzpoGJnxscsloVi4RUuC1BRe4=;
 b=Akrt/aSbAhCMYUyBqaEhEdgQAEVvV1/jO2Z+I8p+/ftSsWaEAp7d0ntJYVr8bnO79W/+CDNS+BFqxohAbXrLy860qIsQRm1gCBPUdDR8ipsHMo8NNYalt7CtWw7TXhXBuYLGF83jFQrPJD3CXlEPqLyszb3OrhgSjXVF4eOyrgxm7O4YHInXoodha1nZDvG3xQ8dB2TfVdfYYYdTL4oAnfBCMnpM1fbAp9qFTv5aiCEGOjPV7RLp/Klm7Yrs7bMEJVvghrJ3y8aFSGhelig176w+2nwhH/aK9vMeUc7bZEQam3hNiQSE6VHMS2LbXw9BzMickTSMVbv9a6q6J4uo/g==
Received: from DM6PR04CA0002.namprd04.prod.outlook.com (2603:10b6:5:334::7) by
 PH7PR12MB7794.namprd12.prod.outlook.com (2603:10b6:510:276::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 11:22:35 +0000
Received: from DS1PEPF0000B075.namprd05.prod.outlook.com
 (2603:10b6:5:334:cafe::ac) by DM6PR04CA0002.outlook.office365.com
 (2603:10b6:5:334::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12 via Frontend
 Transport; Thu, 15 Dec 2022 11:22:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B075.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.8 via Frontend Transport; Thu, 15 Dec 2022 11:22:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 15 Dec
 2022 03:22:26 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 15 Dec
 2022 03:22:20 -0800
References: <20221215071551.421451-1-linmq006@gmail.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Miaoqian Lin <linmq006@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Fix documentation for
 unregister_netdevice_notifier_net
Date:   Thu, 15 Dec 2022 12:20:59 +0100
In-Reply-To: <20221215071551.421451-1-linmq006@gmail.com>
Message-ID: <87h6xwap3t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B075:EE_|PH7PR12MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a807613-f902-430c-23f0-08dade8eaa6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyI6w9qa+d2xjFSpgi2BO0dTgBquhzbDCP8bWIBElF900B+K8KdAXblFe7m+2O9V5LXtpdVVgzdfESS3yMYDAg5i3w2mabUzwM8QYeO3N8l75Xsn4iIMpcsYwRyVG/6Z2twhilgJ8wvhOo5EjRslejVDlijgnBsPKXB2DvWPG/ywAruzqwe7sXlJuMQdjSJ+mJmFMXwsgqjcochH8AEO6uLqpf8+888N+KjN+FVWTdfoXy9q6HG+9/PAE8PhkH0qF3WxVRMOCVRJrXQ0S73o89iBo2KQGcBL9HF/q5Hobv3U1moBUeOwWikYMNFmjpZzO/iEEWZdcmDyq4oWUOME3lZpQGyCOqz6qBic1OY1Mu3ifFy/zZZatGEK98he/nimLCJ+ErIW4dGQ7DVUmpghqb/cJZ6zXenVSXNmXco7yaDnzeLH78fzdWCo3XRzSIZTkG70Cl7g8wIKFm05+Dzm1vZS4QiHkbTqVniRfh+FB682DGWn3hWW9LfR6KRrrbsFXxhNCFrZ5SH6E/0ymkhl6iiBB0pAIsHzs70zpY+DzBOQEX16uF8AxRdPUz35REl1mXuYWdHoSoSJ2P/Yq0DCDlSpifFUA6lo6MPrwuD2+GclKZLbuCoHMCAkH0hyfcZYPmGOK4cWOfX0Qh6z5boxKLaM0eFbFlRl8MTC3Ipm5S2+yTberPV3zA1YC4Y+ECxd+GyDRPTp8TRmScThIsLLDg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(40460700003)(6666004)(41300700001)(478600001)(82310400005)(86362001)(36860700001)(82740400003)(40480700001)(356005)(7636003)(426003)(47076005)(336012)(16526019)(70206006)(316002)(8676002)(4326008)(83380400001)(6916009)(5660300002)(54906003)(70586007)(26005)(4744005)(186003)(8936002)(2616005)(7416002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 11:22:35.1007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a807613-f902-430c-23f0-08dade8eaa6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B075.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7794
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Miaoqian Lin <linmq006@gmail.com> writes:

> unregister_netdevice_notifier_net() is used for unregister a notifier
> registered by register_netdevice_notifier_net().
>
> Fixes: a30c7b429f2d ("net: introduce per-netns netdevice notifiers")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b76fb37b381e..85c6c095a1b6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1840,7 +1840,7 @@ EXPORT_SYMBOL(register_netdevice_notifier_net);
>   * @nb: notifier
>   *
>   * Unregister a notifier previously registered by
> - * register_netdevice_notifier(). The notifier is unlinked into the
> + * register_netdevice_notifier_net(). The notifier is unlinked into the

Since you are touching the line anyway, please also s/into/from/.
