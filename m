Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780A422CEAB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgGXTb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:31:57 -0400
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:50304
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbgGXTb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 15:31:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6m1FJt0YV2bGSyAGl7jhTcDstCG8RL418+rJ4ckH66c05M9PEUYFpnK1rH0pw3+0X08ewnSQmRqmdqDgOsll1XM8eZr4cXf1+EtElcaKahkobqZQU7hOM9hNNYAz3EbRyuxPFKa+Gp55+su95M5PbCDWYFimXfqUAI+TL1alixTT5AOAk+u5GLGSt0KVnu2Ix8+Larg+b2prTqUtHZQXgJwVWLfP+OG/lPPXDk7z3lV/D2+K/EJxR9oGt+UWvnuCzJ3pk5Ksk9KOOy25vyOFZTDJfCCTw4fywMI7mIQ3MUexWXlh6RzfOh4knjgO0i5P1LNe/8vBSEqyB4DLKOYHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ng/TpK721EFdOxMGLMWZz8ZYA3qgMHh2yIJoe1ly34=;
 b=Ku6E1xViWLaDgpZRAln5RAvmKiGUazpN04ZE4cqX1zalM1DXJpzDugexgIEvB0mB++UOSXZFYozSfk6Ol+JoAvpFiIy1LJq44bawi4aLo+3Wk3zDTIZ3Bb4IGcOZgRILGJ8+0W6VTas6VAxpNAa/hjFhfyJxnk3XQoI+2e+O08RqFevCpnVzvBWWkZZ4OAgl6EjL7pUP3P9tjh39GVBU09IoZy139hASdrHetiDGnrhsKoMQWIbcfV0pi+Z1Rf4xUJSTBcJ4RqA+TxM86sRILiEWPrZF+zoSsJcbFdQQHk6YyhxxjkRliQbQp0hRwV7QajfRIdQNLUB7MErAOpmQOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ng/TpK721EFdOxMGLMWZz8ZYA3qgMHh2yIJoe1ly34=;
 b=mDhJRfq6SegcXdgv3afzUjiG5huzzXTNUzQfL3QkprVs15WYSDz+IT3IEo76FGue/MmAXUYFIBM9TbhtyUqOriirUqiPwHTEP1RLVNvdC1VK0OdwsvxfEQ70hi4yvx0vhdLrOvI+GYFRcn1Eg64idpAXLBQKJTMrbwVleSwbKjc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB4855.eurprd05.prod.outlook.com (2603:10a6:20b:12::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Fri, 24 Jul
 2020 19:31:53 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::15f4:b130:d907:ce72]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::15f4:b130:d907:ce72%6]) with mapi id 15.20.3195.028; Fri, 24 Jul 2020
 19:31:53 +0000
Date:   Fri, 24 Jul 2020 22:31:51 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/3] Create UMR with relaxed ordering
Message-ID: <20200724193151.GA64071@unreal>
References: <20200716105248.1423452-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716105248.1423452-1-leon@kernel.org>
X-ClientProxiedBy: AM3PR07CA0097.eurprd07.prod.outlook.com
 (2603:10a6:207:6::31) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (213.57.247.131) by AM3PR07CA0097.eurprd07.prod.outlook.com (2603:10a6:207:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Fri, 24 Jul 2020 19:31:52 +0000
X-Originating-IP: [213.57.247.131]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2369bca2-e75d-485c-9403-08d8300837ef
X-MS-TrafficTypeDiagnostic: AM6PR05MB4855:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB48558148FBC1B2FE322DED9CB0770@AM6PR05MB4855.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4XXNpDoU0kdFokKj9OmC7nwtEyj9engbuwE1BUDSEdfkdM6ZY1LBiJWcJol0CanYYfUu5RSkg/AH1b9Ky+mXEn5C1hf60bxeFo3lIN9wnyZy84vkIBuUqU93hcqAAEQJHe3lH38LyPbWZelroCeZZBQoG2WNkGlsASiwWcjN/96cdgRC2FxlnSaJEEV5WkwaQVEohGBTSoHJbWz0aUJbkDabsPjgwv/8ZjnQZcv3BGDPVVs/bSe/iMxBT7lXEOcYDC5trqYDfrp0d174Ej3yyYO+zuwfm8T/7l66obUWiQKVAmfNaVx6QudLTmB6U8xA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(396003)(376002)(136003)(366004)(346002)(39860400002)(5660300002)(26005)(110136005)(16526019)(316002)(4744005)(4326008)(8676002)(956004)(52116002)(33656002)(186003)(6496006)(66556008)(86362001)(66476007)(33716001)(66946007)(2906002)(9686003)(8936002)(54906003)(83380400001)(6486002)(6636002)(107886003)(478600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5GvpMlD/9WFvlaHhFSHP769MgXrCsDCs8pToBdt/VJmytzobos/8PyfzDEcQ1NhQJYqeH6hQB8CH4PXR17miOwec2Sd5gJXgpHiDyZfjrriZhCQxojX2HVJZj3EYsTFiw6iqVlzRydrXnByKJOi3DxSh42pcVuAcDTEbnQHgmDNFAh/2fjRDfteeVPaXhhFBxxsrKl4212rfYFvC0/voruPaQhOYFRwVcyhc+MrCS1Tr+z8bz/+Pn6PX3PfLvjX9tEPpjNKytLQMOL3xCxgC1OAc6/i/AJOP2a7uU9qv7dMYIWYnkuIsdZ/CNXXM1oj9P4qJ6dxcJ+ZldnLnWbQNn81hrdGw/Sbu6gQdW0pjwRdmnwP/43bARIGa/29tn72ei01ypTYSIml5Zq0vrzq7WKHKQBb9rwd5VJh7Gx8oCEL9kUZWnohsfIxMfNyobfgZkwciRi59VaO7IRKahUxdQPhZAEX6WG38gLIrfu3TxLaA1qS8fBpXxW19KZX8b5ep
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2369bca2-e75d-485c-9403-08d8300837ef
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB6408.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 19:31:53.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnuAWk4UhHGlUaIc8vXyqAxXW41fsDIiSiYuE9MbevtcV0tRYqc2ldK5tYHnJrprzNw4+Co1oeYhwVBM/4PyDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4855
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 01:52:45PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> ConnectX-7 supports setting relaxed ordering read/write mkey attribute by UMR,
> indicated by new HCA capabilities, so extend mlx5_ib driver to configure
> UMR control segment based on those capabilities.
>
> Thanks
>
> Meir Lichtinger (3):
>   RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR
>   RDMA/mlx5: Use MLX5_SET macro instead of local structure
>   RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7
>
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 18 +++-----
>  drivers/infiniband/hw/mlx5/wr.c      | 68 ++++++++++++++++++++--------
>  include/linux/mlx5/device.h          |  5 +-
>  include/linux/mlx5/mlx5_ifc.h        |  4 +-
>  4 files changed, 63 insertions(+), 32 deletions(-)

Thanks, first patch is applied to mlx5-next.
042dd05bddbd RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR


>
> --
> 2.26.2
>
