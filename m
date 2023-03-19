Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DC36BFFC5
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 08:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCSHYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 03:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCSHYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 03:24:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6343C05
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 00:24:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kzl0492pNuMLvofV4QvbqB8w8rg67XpVGeY4X/u7liH+5MwvDaX2cuYqvX62PrYVuzxSl5pg1XOCpqjp+bajzVDkbI6kr+hhWBouHiZcCbxOGtxqKD5HTOqJGAuQb+awKR9VVWWEjCsOdEjbIeiyZ8utORmUxY68y1/5KSZ0QwddeY6yNSNOP3bW8zNLcVOBNHt/yLSd8clSAdMYbix7spL93W7rXxwW59wmNUpHLmN/Hi27H0f38ecZwJBYmZ8JT6191ng3ppch61DSOCllsfFF+nrchT+Eatf6xHcc1aUiCurRxJe9A+DHM+Kzz9DjkpR6KvkFXNyskd2Q3bQ1YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZfdEw9L6dRcTU++sJK1V4dSidfFm8uktee+Ps8b8sA=;
 b=Ul22iut3v73qm4+hs4A+HYfYTQWXt6iRfYdAuqCAfl9GUGALzTa3uYI6Pm3l97Gk+C0kTFig/jZXBeRApgYlsBpbwMZE8ZdIIR+NUXNeRBv8QWS5XPsJ0+DYMz3yDAA1xyW2UVyoUNkDxjuq49ozFEBNN7s2V4pnQLOZSmNGNuEKgj9Ud/JHb4o0a0Fjj67U5w59omYDNqqiHE90Xmhef3a6BO2sc5dvWFoQl6oX2T3IqWNw39/m0geaC+31FIAmKv2162d4C85Gf6p9TgwUbmvG8estRKJXJiMIBUYDxXDFO3KxrMAPiby1hxxxZ0ou2hCbmT7KIEQqdUEfOS3f3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=secunet.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZfdEw9L6dRcTU++sJK1V4dSidfFm8uktee+Ps8b8sA=;
 b=PxvEaML+cCHgZjmKTcY/P6DwXxpmjt2HsWjDKiU/Hli9/Eksulz+7EkQFF4xrbohnCkYOIgIQhSIgOZuNdYxD0IBhhMgIgyQGWA+viCN+maD/X8ZhRLq3B8kg2WBnU2dBEVashcCAdOK143i9cIMzFqcL9ayP3urOe7PbxlW06WkXT7w1VKNEbB1lcXwx24jYyYQa1lltSf/iRajUpg12kqMxpgRtExmmWOPTzs7LhWITi7qhrhrofN9BHtAji8K+MKntzYqKwQ0xT093Fqt8QVmd6pR6z9Suiml3NJV/YGyMFKeADiGrsL9kuAEETAwuDM7UYKeT0deufm6sUX3qQ==
Received: from DM6PR21CA0015.namprd21.prod.outlook.com (2603:10b6:5:174::25)
 by DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Sun, 19 Mar 2023 07:24:07 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::3d) by DM6PR21CA0015.outlook.office365.com
 (2603:10b6:5:174::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.0 via Frontend
 Transport; Sun, 19 Mar 2023 07:24:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.11 via Frontend Transport; Sun, 19 Mar 2023 07:24:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 19 Mar 2023
 00:23:56 -0700
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 19 Mar
 2023 00:23:55 -0700
Date:   Sun, 19 Mar 2023 09:23:52 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next 0/9] Extend packet offload to fully support
 libreswan
Message-ID: <20230319072352.GZ36557@unreal>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|DM4PR12MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: 33013027-98d8-4b4d-b32d-08db284aec90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WADaK4HDUw0q1KlBbzOsTrsPpVhiDbMf1qQAxwd0D8ArjJ0fjWErN72rREb+23hKOPtQVaQ3sieWu6S08iSTeMO2Ol5Txm/97JFf7nUsEvErPx2srsvISZiqnc5If3aAe8KclqgdRaRG+oFTHMc1UhgI8RI5NEbjpN9MI6RTYliZjamiC7VgqLNQWPSQKs7WolxzOwNtCMe5jnBSE40EKzWtyCgtWc5JEM5QtbzLMpEMtMY9HXGV7rYNue4zXKnGJd2OTVw6F5IkagmZEMPpFb728HE8zIRMryJExKvI7R66vLXJMJbNknO35uxo1hwIv9LR23fJcAV10jXeiVoWmYd5NYuBu+AbC4rFIbpsD3/I4j7B2liRwbEfSwAtAh+f9zFtQrrDLg0Y2I4VMcPX8TgUdKtepCYjpHbzfKk7lqdH/seVM+puolN9n37KuBMuzM1RLtZiQs/1mGFjFTXIL+lMQf6QZEe8VGRoxb7bCOS0EryCikvV+c9Lki3XfKI9wQ07w92VQj/9ua0PSX2bni9KRdqlBl7B0AKaf0I0l5eXNDHYsog8t/q70zFYPlaMek+CzDdjQwmtEKZZhXXhAoY9+svvHKe7ELXEf2H8iRoTAwpnCGxkw9RYa6ZhUijRN/s6cNr8Hpl9HFteQwc8mK8WMN4OlNT5afYLr1p7SSYvDxpAW9ze6kIg488cTHJDEXsu/hVqkpELxYfE12ixFpR75EQ6SzdfMv8URd9Uecz+RM4HbLQSLnhl8nwgKDKWBwCi3yFO4QpyYPShl3AWN1hj2Mg9wb7oGvZuKXElDVYqMeIJ1lPh9GyszouAbpmAlBYDWvwoEziiCS/8nIzYQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(8936002)(5660300002)(41300700001)(4326008)(36860700001)(356005)(40480700001)(33656002)(86362001)(33716001)(82310400005)(40460700003)(82740400003)(7636003)(2906002)(6916009)(966005)(426003)(47076005)(336012)(6666004)(107886003)(83380400001)(478600001)(16526019)(186003)(1076003)(26005)(9686003)(54906003)(316002)(8676002)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 07:24:06.3091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33013027-98d8-4b4d-b32d-08db284aec90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:58:35AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi Steffen,

<...>

> So how do you want me to route the patches, as they have a dependency between them?
> xfrm-next/net-next/mlx5-next?

Can you please share your opinion and/or ack/nack xfrm patches, so we
will be able to progress?

Thanks

> 
> Thanks
> 
> [1] https://github.com/libreswan/libreswan/pull/986q
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> 
> Paul Blakey (3):
>   net/mlx5: fs_chains: Refactor to detach chains from tc usage
>   net/mlx5: fs_core: Allow ignore_flow_level on TX dest
>   net/mlx5e: Use chains for IPsec policy priority offload
> 
> Raed Salem (6):
>   xfrm: add new device offload acquire flag
>   xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
>   net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
>   net/mlx5e: Support IPsec acquire default SA
>   net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
>   net/mlx5e: Update IPsec per SA packets/bytes count
> 
>  .../mellanox/mlx5/core/en_accel/ipsec.c       |  71 ++-
>  .../mellanox/mlx5/core/en_accel/ipsec.h       |  13 +-
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 528 ++++++++++++++----
>  .../mlx5/core/en_accel/ipsec_offload.c        |  32 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  20 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     |   6 +-
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c |   5 +-
>  .../mellanox/mlx5/core/lib/fs_chains.c        |  89 ++-
>  .../mellanox/mlx5/core/lib/fs_chains.h        |   9 +-
>  include/net/xfrm.h                            |   5 +
>  net/xfrm/xfrm_state.c                         |   1 +
>  net/xfrm/xfrm_user.c                          |   2 +
>  12 files changed, 553 insertions(+), 228 deletions(-)
> 
> -- 
> 2.39.2
> 
