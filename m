Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9891B7F59
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgDXTvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:51:02 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:61855
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgDXTvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:51:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIC2laSduaqtZ1L7wJ12AOnuY78LbTPftfOzOlnWxYO0lQvmPn5KzsdM3l6yyj3V8BpOX73dt+sRUghVMmeYnGzBm7nZbkqs8xVO/IISLz0iUU6CgP0faXvv3Q4rOlywzRN6YKkHJtan6LbcRJsPt39h+3xGNLpfHo5Yyi9boaginfX4nHKLaq2TdalaOPzY1gDqtEQrvP7hEwvSpdCQz9Vr+ySIf5HDggJ5YlNMciXid5fxKVhSUaQYarsOSCCc902DsgXvMKzCmthAntW1RNY5G9bj7YjE3Nj1jmJFSBxKo9WwZ1c5HZf9A/fdcDxkC3nMZZRPKgN7O0goJPtMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDaqkboB7hg4RNMZxPNe2YR9OvZrdEcSQTXpZaal+yg=;
 b=V2XrvqEhLiEyghq0smBE3kd1V1zWxRvSspPQ2xhfRFezD4YHqxQ20WmLexgsIJ1C8qsD7HuFjq7TkC6qLRtaPsY1pNboXW/hEvIL9qH2+cCCX/1da5tOIuGytGQDGD2gb6IJGquyWMkpqUfjEgLfCtO08DOuj2NONzaSlhUxbrNlvYKh35ZJK5jYn3SDS1drhaFAM/jkvETWIYS90ds/3hmwi2OCrjxUFm9E6qDkYHVqsQL6sLc+9AuSz9g332PLY5ohZ3CNcBdqnvxPXIXq2dW6vGm7gbmiQD41QceJvW5/1hcE3M5o3nQ8nmhlXbcSJcv+G/YD61fGOZgVngRmcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDaqkboB7hg4RNMZxPNe2YR9OvZrdEcSQTXpZaal+yg=;
 b=EUtVaVkeMzgtVmEMw5gZZ8sdXcYcxCFW0gTa16UZfZlfcirPA9hCp7WKqhDrE4yESOE/4lb6gca1yY6cILACC6U95BB3dChANBGCN/l5NNxPZ+v0ckxXRloUFKwZ3qHM/xlDQ6KXFsqp5IMonM2ovSGdrQeQJ24WWNBmu1hxbPM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB6007.eurprd05.prod.outlook.com (2603:10a6:20b:b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 19:50:58 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:50:58 +0000
Date:   Fri, 24 Apr 2020 22:50:54 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Huy Nguyen <huyn@mellanox.com>, Raed Salem <raeds@mellanox.com>
Subject: Re: [PATCH mlx5-next 1/9] net/mlx5: Add support for COPY steering
 action
Message-ID: <20200424195054.GA15990@unreal>
References: <20200424194510.11221-1-saeedm@mellanox.com>
 <20200424194510.11221-2-saeedm@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424194510.11221-2-saeedm@mellanox.com>
X-ClientProxiedBy: AM4PR0902CA0012.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::22) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM4PR0902CA0012.eurprd09.prod.outlook.com (2603:10a6:200:9b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:50:58 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e132a36b-e068-48ad-9266-08d7e888cf0f
X-MS-TrafficTypeDiagnostic: AM6PR05MB6007:|AM6PR05MB6007:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB60078E5A0895EBD26822100FB0D00@AM6PR05MB6007.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(6666004)(6486002)(4744005)(2906002)(6862004)(6636002)(8936002)(5660300002)(52116002)(6496006)(107886003)(9686003)(86362001)(54906003)(33716001)(1076003)(316002)(186003)(66946007)(16526019)(33656002)(478600001)(66476007)(8676002)(66556008)(4326008)(81156014)(450100002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uxjw/+p1Dc7+F0rhY8fj5t7bjRG7tyw2sNq3HfUK1gkuTI3TV+HfG1uCEup+QXOaFXRBCv8dvNF4N/YoePAsDWJ96TbJ/Y1BgQ3Wf6s5NUU+3fJJLnLEMfe81pLCTrFHbIG4TJCVb/2tUMSg3zwKl/XOfeS0K3B+eV4qQMvgRPXV7GmWgxdhQM0EWjJ4fNbnZmTiXVfMPE/QegNDaw6p0VcwvgV/RqEds5pXFWDY+ZjerK+GIIm4R48Z7/AWajgURw74Z4sbnS8FX3MHHw3TjVyyqBad7H6ezKAqS3Xqaw2i5nFbtUWeaHohvP/9b1CNbmC99FwMyRZ262H2uzjIyyOxjUEh/xmnqHZZYgBt+caOVKCo0dOe4g0LewRPiI2B2cNo5hQZVv/BMf+FBHDeZ6DZlq3zhBaGgA3FKZZUYcYKIRPOOCZ3Isa5C+9xeFHe
X-MS-Exchange-AntiSpam-MessageData: ZzH0Q5MHTj9dVSamOHp8vy11gh640Uj0oqBr2I6u+KojxNa5REHY3HTg3nuYCCGjrGyv0wv85JbNdX5mPFker6IZfT4etAxdpeOX8bYJxgf0jM/LXKkk2vv3FnDcI1EHk226phAYDkqBatyWtPU8sz4UDwA036o628YNb7+EDiA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e132a36b-e068-48ad-9266-08d7e888cf0f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:50:58.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0LTxgYWMxLVtf4IxlymUFKsHC5x5EyFhncfqW8EMoD2zTS8RRodovPVHznnXNTPoyyj/61nbENYT3OKuARRFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6007
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:45:02PM -0700, Saeed Mahameed wrote:
> From: Huy Nguyen <huyn@mellanox.com>
>
> Add COPY type to modify_header action. IPsec feature is the first
> feature that needs COPY steering action.
>
> Signed-off-by: Huy Nguyen <huyn@mellanox.com>
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/flow.c                         | 4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c        | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 6 +++---
>  drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c      | 2 +-
>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c          | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c  | 2 +-
>  include/linux/mlx5/mlx5_ifc.h                             | 8 ++++----
>  8 files changed, 15 insertions(+), 15 deletions(-)
>

Looks goods to me.

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
