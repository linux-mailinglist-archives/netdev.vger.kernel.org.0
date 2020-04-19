Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA461AFA5A
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDSNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 09:02:36 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:32549
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbgDSNCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 09:02:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG6AXnxS62itIFkWTZ7g3DOuI6x1Z0rPMe34BPAWlxVP5p9qzbsZMjxPDvDk32vUiZPqA2Owmu7eVAOJ4Swot10jByNeBUG1tp3tEo5891Ofp85ixso2boof6RSH0MfWz1u9ZB2M7EhJGGP2rkykO34fwNkcMAjbYMQkj5Eevd3fm7pUbr0vWBHGUZk6gYK7e8IYR+azzHR4bEaeRdSx4S3gBDgXRadahexTJL9p8zpmmElqI2/WqcJd5c/sCT3S/nITACFsFlCNQE/GfbBgXLJY+RaTrOpPGmj99K/Zcy20qIxMDZ9PROrtaE8GAeErsxPm5d3FareUFC9nnWUQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ANT6Yysg437UPtpLdU98TfYlW8Kh1uc3cB+lwc3Of8=;
 b=OPuyP9PUc49j1RbUqVY7okfnLjND3gVkajVcuUre5bONMiP0EhnkErzszZx/o6eNpSOE5TxR43+j4fQJRIgUV0SwJgsOG0c5Z91aLWXOI+s34IxElF+Ob2TbTpXg/fLUa/Q5FmNPXQZruTo+mjSknpY8FJDMuygqa8EuvrRPdNtiMp2/Mt9gOWkfoLOr6bybO8YgrKk37WtkMdpnB4U/+iwRJNxwydIzAvw4+HiARGmAZILgI7iqz9BmpBNF51+XUkVljJz5twk1uGKrp2irIQOmryGGoDyMlf+u+QKH8E8Eeg/qwabK5ZDBpM6uA5C2feH7uBirIDi1NTFvRYHg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ANT6Yysg437UPtpLdU98TfYlW8Kh1uc3cB+lwc3Of8=;
 b=AzmG2UO1CIHYAH3XF1daXvCU3IKjTZFK9AMlRRpjl6WLFGki0t8QhXwS1IowCTmtV0EeVBPpVnkb06tC+37p5wM48+MtRKfaJPrYdRwXe0TBFUg/xdh11UhQpady6NjSLhXN8yN4iycprpZGmm7fXYnvnQxOzMETsVqvuZ6Cuag=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB4344.eurprd05.prod.outlook.com (2603:10a6:209:42::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 13:02:29 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 13:02:29 +0000
Date:   Sun, 19 Apr 2020 16:02:26 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next v2 0/6] Set flow_label and RoCEv2 UDP source
 port for datagram QP
Message-ID: <20200419130226.GB121146@unreal>
References: <20200413133703.932731-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413133703.932731-1-leon@kernel.org>
X-ClientProxiedBy: FR2P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::13) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by FR2P281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Sun, 19 Apr 2020 13:02:28 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1575acb-17c5-4e44-21a9-08d7e461ea3f
X-MS-TrafficTypeDiagnostic: AM6PR05MB4344:|AM6PR05MB4344:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB43440C4A77B77CB032762009B0D70@AM6PR05MB4344.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(86362001)(316002)(4326008)(110136005)(8936002)(54906003)(966005)(1076003)(478600001)(107886003)(6496006)(16526019)(186003)(52116002)(8676002)(66556008)(66946007)(66476007)(6486002)(9686003)(6636002)(5660300002)(2906002)(33716001)(81156014)(33656002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qEOmytyggamtiNDZaB8KBpBLlKS9M5N0Obcy2ug8DCx3raYq1vxxTzShPlKkpi3R4haKtP2s2J0t1YhWV5Am3wuUrkPTEKkLKnFv8ev7aCBbjPXa69XAgCrPBvHh7Gtb99nJEgU0DNSPMvJ3qLMHBfFqKeFHh52Z4V2CSiaX5aC9hRlXKpMNM5p8lVtHMqlC6h7h/fuK1A2MuvlwWQXJUmFN2Zct5t2dc2fr8kvV7JbLNki78r6/zEGQSWJoxPt1NcYrnDFPYt1SFwm4povQ1e8bHqux/yaUIWyMT3qXwGcNyKLeh3kizRhy2KiYYbVvVFlGeZqe0oH7RJiYnE2GABooixf6Io0zi59RLFdcUTbQXdG/dWk0BNF2TBNEQ/Rwws/7sVinDoRexKZ5X7aN7kjd2T11Z0Rr+wmWettesbGe/BxY5ETM9SaDSi24E3ERy2D6SNmp/h95GqEJfJIrb+yXmY5nRQnwsrTxh/RL1tD4S+U6aldvrx25ofPj3680ghypmrJ5iggziPgFQlzcw==
X-MS-Exchange-AntiSpam-MessageData: PqVh/67qNr1pfHCqBpQHuuo5xTxhWcoPqtE1AXRvP9SVsHSgJlS8fa4Vx6RUuunxuj8X8PbWrLDmciUFqcv8VCRfZ8JqSpXA+H3m7VHUpcYrBqnKNIrr1BgKihTxhSS94gecuHp4b1EPSb8LbKsC8BSeUeWnCRWtcnwoW62Bxr4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1575acb-17c5-4e44-21a9-08d7e461ea3f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 13:02:29.2529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vp/BptffuOMFSgKRQZ50Irk5RK7DNhDVt5XctPD8QydsqEPnHsD4N44dE75yPiiPemfgF4wMOXSpOjQjJiVePw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4344
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 04:36:57PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog:
>  v2: Dropped patch "RDMA/cm: Set flow label of recv_wc based on primary
>  flow label", because it violates IBTA 13.5.4.3/13.5.4.4 sections.
>  v1: Added extra patch to reduce amount of kzalloc/kfree calls in
>  the HCA set capability flow.
>  https://lore.kernel.org/lkml/20200322093031.918447-1-leon@kernel.org
>  v0: https://lore.kernel.org/linux-rdma/20200318095300.45574-1-leon@kernel.org
> --------------------------------
>
> From Mark:
>
> This series provide flow label and UDP source port definition in RoCE v2.
> Those fields are used to create entropy for network routes (ECMP), load
> balancers and 802.3ad link aggregation switching that are not aware of
> RoCE headers.
>
> Thanks.
>
> Leon Romanovsky (1):
>   net/mlx5: Refactor HCA capability set flow
>
> Mark Zhang (5):
>   net/mlx5: Enable SW-defined RoCEv2 UDP source port

Those two patches were applied to the mlx5-next, please pull.

>   RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
>     source port
>   RDMA/mlx5: Define RoCEv2 udp source port when set path
>   RDMA/cma: Initialize the flow label of CM's route path record
>   RDMA/mlx5: Set UDP source port based on the grh.flow_label

Those patches need to go to the RDMA repo.

Thanks
