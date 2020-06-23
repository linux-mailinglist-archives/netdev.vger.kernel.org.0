Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE820544C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbgFWOUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:20:11 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:56513
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732657AbgFWOUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 10:20:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfFFsQNvJKDZaAMb+ZxkGWwk4RTYNOM8en0MzsrWPNi5Ts80PG4R8Qa7gUZlO3Ij4ZePVmZ0HWeia5zhAS9uTXpvIeGPezJKsXKcUVS9r9seZm/+AXJBQy0Vao5CDrq6P7oIb/sysng6wI7nJH17i8UWk7T4BpTB0JuRwbYIh5AQriH7pspfgIekSNSGReUgb8OKTdqa08EG9yX6SpAfOEHVYsQ9xAmF7G8yoBCA8VeWzZPa8s2AD6OQ4E/GlkYuRZIMDA0JTLA/+7LhHGfCZ88vvlTPeMJwhwfMZQRVRMDbB1q/3Pr/K1C2muXYA6dlQZM71P4kVLmDYtxaWPyS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZ4YNhkL+aQ89nKzBVhFqgXmcMkVkwA4B6sorGMYTfo=;
 b=Xx/cPS1uNi5wDAhqPBaF8xYzEQdi8Gr7eOGBIu1C5uQ8ZSMfwpLXO8v3BI4Rk7wARKSvTsseLZ1o/+C79WlzUrBhYZPJq2Xgs7tW7d+0lGiiwziuvjFVPCQcrLCEIlRcyvb7bzI/d2kDrIY4f0TA4t1hxNnb55Wt8aW0OsfObdLsh1FPrPpnuWgGgvR6nAkNdOoyL215TAPjkANZSUPyEdAKy6j90gx4gD7Nhn9qslKmsNf3roGxskm/qaImaXUboQtI70+hnridnROE17RYWQbJOMDIDkEkDzJQuZR/HICC0d3JtZNOGKfk88GpB/cqjgGo/35XqzJtnntt/piw1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZ4YNhkL+aQ89nKzBVhFqgXmcMkVkwA4B6sorGMYTfo=;
 b=FahlSoZeBftVFfAdHzsZGaXcxPwXK6OuJqvvBr62htgbO7t6+HxiaJgMqdvhHDpVck5+9fM+P9aE23xXUrH224IegaLhCvLcOqZkCdhmv7rPGtFQB9eNzLmdlQYSqa8V63HJHblQ4101ggJrvdG06gl/vTlqI5jDoVhYylIwU04=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6351.eurprd05.prod.outlook.com (2603:10a6:803:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 14:20:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3131.020; Tue, 23 Jun 2020
 14:20:05 +0000
Date:   Tue, 23 Jun 2020 11:19:57 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: Re: [PATCH rdma-next v3 00/11] RAW format dumps through RDMAtool
Message-ID: <20200623141957.GG2874652@mellanox.com>
References: <20200623113043.1228482-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623113043.1228482-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR0102CA0058.prod.exchangelabs.com
 (2603:10b6:208:25::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by BL0PR0102CA0058.prod.exchangelabs.com (2603:10b6:208:25::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 14:20:04 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@mellanox.com>)      id 1jnjmH-00CX0J-DI; Tue, 23 Jun 2020 11:19:57 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dda08833-bef1-4a0c-58ab-08d817808631
X-MS-TrafficTypeDiagnostic: VI1PR05MB6351:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6351A54D0E31651C282C764ACF940@VI1PR05MB6351.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKjIhOKvivxH1oZgeTBlqZsrHDoB1MDpY/Lyg+UaHdBhvG0QU5KV3rBirXxKjRZeX7Q5+EHaKD14GbZcfFYns0WHsco8G5K4+UO4/oD8C/z44WUrfxXwHuSBqtyP5I2O8TOOGlYS6rcwstvtjmqom7abxZi7PYF5nmKL5Hg0V3TR7SjTz0j3BPXJZMBuRpoleNd0AwlMKGJszETwhbyKfq8XHdwmZ9i1c2gA2cn5wcHRyvbZFxaltUHTPuDixE9hHgCUNztYsx5v33YYpYpCf7848MGhMQlj8wWDYn2F2C7qZqHuh6gtMQDyi+e1ok9TOvkMIgrqOI50+35kAbRKN1IcSxKyQ6kTAqz7J76IzvmaP/jiHV//APR6GMjXFqa7/uf1oLetcw485AMC65T1bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(54906003)(66556008)(66476007)(66946007)(26005)(186003)(4326008)(498600001)(36756003)(966005)(86362001)(2906002)(33656002)(9786002)(9746002)(5660300002)(1076003)(426003)(2616005)(8676002)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xXqslmNz/nz2fxQ1hoxiytMgyTQXNwb3mK07rpUJEuBFkMVLalBdkZ4m3zl3UK5FARFuFwJD6bwqjRDaNWoZKuiyj2BlSRF3EhR3nYVqKd0qHA+YO1DgmsBxNcPIWJ/gUGnDoDbqSpWxXsZXO8C8frvS5dvfZNcLMz4VeQtPg+ZLV7eolZ0LlQkzoZLcHMTglX6Qu+/YS8fSO/bttXRNOCRpbtXEp7Vh1wg1eJFS7lobailMAbHh0dsQAFfR8R98QcHDI28fLA6QdlM77xtAwgymPqqKWLAGfygKKb4Cezg9JsyxLT9JaLnjmuzTrVzl9tDmJNN9QycggQGgmm9p5SsrRhWvANuhZmsZeQzd5yy2uIRwsqJu+UZNSdyaZRVYOv/lIiKPAfYjapkVspD5A7mXeAThwm8wPlExwVWLnbni8CO/ufxAhogaQ8kM3xp9hnVUNXUzVswSZS1lYaPMVtPmV5RpjR/y3KgOmkVd35be2TuFrOhGRFoh4Su2EY0v
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda08833-bef1-4a0c-58ab-08d817808631
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 14:20:04.9407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ/4oX2g+meDAYfGZ8XxawiPDXJzWrECVczpMlhWyxgUtqhTG+vs9LhcA8O58BvGvFH+xirDuN+UX4mfB91USw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 02:30:32PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v3:
>  * Rewrote query interface in patch "RDMA: Add support to dump resource
>    tracker in RAW format"
> v2:
> https://lore.kernel.org/linux-rdma/20200616104006.2425549-1-leon@kernel.org
>  * Converted to specific nldev ops for RAW.
>  * Rebased on top of v5.8-rc1.
> v1:
> https://lore.kernel.org/linux-rdma/20200527135408.480878-1-leon@kernel.org
>  * Maor dropped controversial change to dummy interface.
> v0:
> https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org
> 
> 
> Hi,
> 
> The following series adds support to get the RDMA resource data in RAW
> format. The main motivation for doing this is to enable vendors to return
> the entire QP/CQ/MR data without a need from the vendor to set each
> field separately.
> 
> Thanks
> 
> 
> Maor Gottlieb (11):
>   net/mlx5: Export resource dump interface
>   net/mlx5: Add support in query QP, CQ and MKEY segments

It looks OK can you apply these too the shared branch?

Thanks,
Jason
