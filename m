Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3954199B7
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhI0Qzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 12:55:33 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:35086
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235295AbhI0Qzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 12:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9u6Iq9S9HneU0LXNA/VnvktG2OL/K4zs1avqBopx1uEHJFx4ZlQciJmpNn83ePERZ2JB1uPJzU2Fa7VCxHeH5gGZY1Su3enyivBBnjL0aLNm8i2W3zQ8vEkwU/5xUoSbpB/ZWaAy9EVRGu+vDpXpFVmkaJJ7rfW3V2urC/egklCs4qjH00aFCA4Y/v1EWB8/35IsPTagBct42Unup5icnlCPfotV8juaBfFDmzkoMdbHa1ZPY2/SAR38lHErYrq34Ww4NUc8gqy8xtoBwcmDW789ycnOYXiiQCTZCwctXObp9fkXU8pee3yfVIoEKmzY6Yv7E5Xz2+JRbfsH4DpYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rjWVqA+nsUSTN3WZXT22MhzX0KmmzsaWqgYN8LWn3hA=;
 b=R3Ejc1+H3liZzUEJbJFLfzThFwOeIVEdExqRGuyJ6IVBNJJ4j8GD1bubuIEGSTJizHk63qiqWyJDOdYWEK9Zvv6SM3h0EOyQ+cn4w5oEA8fUfvaW/FvbSOloW3AsC+7lkHzgiHzG8lu7DujpSe7o5uyavaxwhjNkMabR6neHu3ZdmOcfOnemOKtc7KjBxZb5UrQRLu/s/qvGKTZhqd9L/0gPfQN5eys79qH4JcinBbwBqjy4CYDCjRsnfC+11Cy5eJkNxLO3IdGBsqBpPiZkxb96JzDlHn0Fe7idSAVZ9/8LCl6TMa0AHMxtMVGma07Ih25nmvMzB+wmiDB7vfqymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjWVqA+nsUSTN3WZXT22MhzX0KmmzsaWqgYN8LWn3hA=;
 b=IeLbuICrwG5cy9W1uvPMLEb1mfbZo6MBoGlgNfhtopzi7HA9TcUhDFPhphElEJARE4PUBteuz7nwuMyOOvCMLuyV0vZHjtZkhTwjctII7KR/isaNa2pDA4FgpgLS0bBknKiNcke8e0S12GCgAW4SdW4tiltf5fiN7ZgviQigrDfBeQmEgpIgE+mFW1jaRe5dAXFhVBTOmoMc5IBMZUkW7/91h/TCiBUOzJNJiuENSoNsLGpIPQhsqtM3SXln02ycqZ5exgUSya5N9qciWVh8f2ydsUFXIADxO69excU+LhuMJs3Cmxwws5JjaFzChHTp7hRHzOe7b1OaH6losiG3ag==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 16:53:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:53:53 +0000
Date:   Mon, 27 Sep 2021 13:53:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v1 04/11] RDMA/counter: Add an is_disabled
 field in struct rdma_hw_stats
Message-ID: <20210927165352.GA1529966@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <97ef07eab2b56b39f3c93e12364237d5aec2acb6.1631660727.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ef07eab2b56b39f3c93e12364237d5aec2acb6.1631660727.git.leonro@nvidia.com>
X-ClientProxiedBy: BL0PR1501CA0001.namprd15.prod.outlook.com
 (2603:10b6:207:17::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0001.namprd15.prod.outlook.com (2603:10b6:207:17::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 16:53:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUtt2-006Q4E-6O; Mon, 27 Sep 2021 13:53:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3c0b40d-bdc8-473d-7326-08d981d76315
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51762BF79E0236183AE2A123C2A79@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKbGRMULr+tSHT5KFLllHPMeFmC/wGhfeSWb2dEKLMd6JFBPcgxTd+LRkDnIrBi+6v69KFlr96Pz6sbZrJ95gZ0ZpsFV630Gha6/B+uGZWdhh6vo2pqWR6wJc654Ap6ePxoQO1als4yReSgErFC1d2Ly6F8tZYvzwsuPH/ok+yLgBRpUnpSbe7h5lHlovvOagTZL/ve/oU1YSKeukgeM7eXjcUQtmT5ajjQwgodQwqv3tPwNz8DShy9gm78Y8Z/71AGttyfbm5Paih7WwsXokTCuffaYYhbcaKdatEEtEHjOH/KPdRpFX0vgiZMLU52LyQs8L8kDloovvcqevqohkVR6zJD4N11yD8Ueb2S1gBv70nQ+ke439kukVFr8C6Rzy1nn9ED7DrBIPGoawx4JuGuQaZdnahny9Ip4D+tPKXepvEq6osPvy5B8HL9bHpVbPBZb0svQX4Xso04MvD2moAEZ5V/Ol24fDGxXeQUbtsqpzZE2FYECHUXY6mq/n+qnpymoJj56JV8xRx5hGuEFopMcF2hTRn+eB+0U6DKt8psCQS6AHXP+2Bz5E1WGCG03rgWjevTcqeoc23CFDo1tUpmy1gUSU8NqMKOZE/2qYlY2niRNaPDNNoRzh4uN7BPgxuX4O2PF3SDJolNkwKrfZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(8676002)(9746002)(9786002)(36756003)(8936002)(1076003)(7416002)(186003)(316002)(83380400001)(26005)(4326008)(5660300002)(2616005)(426003)(66946007)(33656002)(54906003)(4744005)(38100700002)(2906002)(66556008)(508600001)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jvu8T0EZ10+LS+J81aEVMi/E2gHFo/xKu/ND/JkLEMRboij0Cc8zlmVRkYlG?=
 =?us-ascii?Q?ptHKRKp1+he3F76jhKKYvcRQDUQpWj1VCwyDxFnnwQvtXZk5VvDwxgZz9MqL?=
 =?us-ascii?Q?XH1FVmglDga13xQWMtPHkwmeoYXENyLeZYedJWNxkpVEPjVN/cpFeOYWcvxv?=
 =?us-ascii?Q?loccCTjkl2rJu5lf2xPPZ2GjKTkuCWeSrWV3gz1zxXicDfQyGScnC9D9obVB?=
 =?us-ascii?Q?jpzzyRxWmRlsyNWQLyMMciZXh7CvMwcMaSDwXExII5pkd7ztRwm+kwIEmtAP?=
 =?us-ascii?Q?+y5NjZBE7S9VLB9bZ8+uy7edk62wqQeaqRvACKN6y2AP0Vnoc6DDlyR/wcAz?=
 =?us-ascii?Q?d3YDRAymp9uvvBtUw9n31Hmw8/gBwms+s7CfD4Ty3DpGfZ3zro52iaEdtLRM?=
 =?us-ascii?Q?EJmem6wTJ2woMGv/N9TcVWrlbYiR/ZCoTMI3yefMb4V/gwFGsrunLu76zJ08?=
 =?us-ascii?Q?gMXak+LO38mjUxJQ6sJwW3n3X1xOqk/EMGiSl1VJLkPF9p3/p8u4V5oUmIC1?=
 =?us-ascii?Q?XgQKc8nyg8alXHMi7GbH0IeBgFWEzAoy2cds7n1w93H7SMXjR0Xz/BMNCCAf?=
 =?us-ascii?Q?87RdlMUOTC6tbJQ2ym13Xhm1jKFzy7F2kppVs7fQVGs9RLfKXw2f9pTqHijK?=
 =?us-ascii?Q?KmwiS3b+wgYj/Im8fMxPCAt1tQ86K9m+7hJ/kZdHxBDVFXZY8xdYqlVkNsAC?=
 =?us-ascii?Q?Z+eNXRG1RdrbpcStr6TQXax4x6PN+KWZbo+CLGz2Qcc4iL8Sb4PuISx4bC+d?=
 =?us-ascii?Q?N/7Uz5qqNjlHN57GXidtZp1WX2AHYaCWz0WH2M7Ah62giBBHw3ZtMUBOPw7H?=
 =?us-ascii?Q?g9380n7t2Qs8CU02ns9+8c6F5F7j6tDtke/TbMH5xQ/AcmkaJ10aSkYgVmKk?=
 =?us-ascii?Q?I8ftdIgpUAgjlILcmbVz5JaANtbRp7GFZL9gF9+AUl/pEKTSdno57mCZei+u?=
 =?us-ascii?Q?9cHzFVf03Hj4Ua3PdTnn6cnvDt+xiEEL+Y6T8vbkgr2PXycCKn+pRQHXWCHz?=
 =?us-ascii?Q?gDLA+yJ7IFyFUhGtnOLk8EqLG2XjGn2rAVbkzJzqCyomh/GDBTEZszk/ooxA?=
 =?us-ascii?Q?cNLl/1vXDldCAQ6y/nWlfPOb93QSq30Z/Bf+SxTjUBB3FKEag8gWHtKSPxGs?=
 =?us-ascii?Q?Kcvn07JruqO6Mk88w5JAqfMOOlv65SYZeFsheX5uiJhcFNE+P6gdlJMdx3AU?=
 =?us-ascii?Q?pWjDK9922PLYTqootRXUmAmHz1ZV3uhHzTWHmpK68Ge1QZA+WKbI6BXGA4nq?=
 =?us-ascii?Q?XPqXxUtXepx0e/dz2fqjY/GF9DH7CyiYjEb8nDh105kP/IPjaztclSrWStQR?=
 =?us-ascii?Q?NLRAIy+feeo6AcUeAnm2VV9f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c0b40d-bdc8-473d-7326-08d981d76315
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:53:53.2247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egSF3UvrEk/0R3sZG3rMdiXivdbMO1jQwxLJGTn/2kvBc2i8R6xisdK8iZaMm3MR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 02:07:23AM +0300, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 3f6b98a87566..67519730b1ac 100644
> +++ b/drivers/infiniband/core/nldev.c
> @@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
>  	if (!table_attr)
>  		return -EMSGSIZE;
> @@ -601,11 +604,20 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
>  	if (!stats)
>  		return NULL;
>  
> +	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
> +				      sizeof(long), GFP_KERNEL);
> +	if (!stats->is_disabled)
> +		goto err;
> +

Please de-inline this function and make a rdma_free_hw_stats_struct()
call to pair with it. The hw_stats_data kfree should be in there. If
you do this as a precursor patch this patch will be much smaller.

Also, the 

        stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
                        GFP_KERNEL);

Should be using array_size

Jason
