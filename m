Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B92667C234
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 02:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjAZBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 20:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAZBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 20:09:19 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4D630B2F
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:09:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPLfUYWM1MXN4iGxm7DF2v/a/WLf3nQTQxTqYBIpmeB9UQUxVqPvrbhXzyksYN24i068r2jbHY1mGH7NvVDNSWYyoFIuG/lLmPbD+3HYFxp/bee1hauF42BWG4NRcg/PezKpXH6DG+PSKLXz1U6lhibK7wZN2QhqONn64/YEocDoI+J5O2eULsI4bCvAlWVXVyAv1Lkm2bcD5xOcORS3LTqo4g1NdtCKjRNeTnhptqqfbJptNKvrQTZr6bjUXTgbJkQPY2NrvkC/SIL3d7zI1vBtOIUAZlt/eG7YQljnn2g72Vpz6hMC9nLNKtm4MhZ53mGd6Gv35tuSbR/RqJaIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lT/BtVcL4C1Su1syStF2jac039iyI1T0QROLP+TYRIw=;
 b=LQAE217bFYa08df8N247JDrH/Ncw3peyqXb5u+kja+XFQ8hylhNJ3GSzMLdvJStxFZJDtZ8wfIknAP0Ci8ShYWCHfrY87aIg/fro71KcR/ZASVMUn0GZzXggsTUmUe6Kqsj4+8SFcGCh4XXB/uCJDfTxatEW4B3+mq8hJ1ua7a0s/xWX3J3nbGGExXsLZMkW/1NvMZRDWP5xWVihOXK+WnCoTfPa7zO6fwozO/zC2YMW62wnTMvd5VRKH4av/QLV6RVNgZHqhV35TZW+LfNXKYUDPyQ4Ik4U9vZSbu+SFmqI3K2ucLExtRj6GcRMioU1u4NKyNzMSubHQfx9uYkcLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT/BtVcL4C1Su1syStF2jac039iyI1T0QROLP+TYRIw=;
 b=anLkGxqVXVHSR8A43193MZJ9mD7KtUcz8m4TwlgnJT/s4sMVk+IrvT/ldf9beitG3eewvlstbA2mNz/AdSRqgjEO56rsU0srcPF8PyojLtpXnE0/IjuEWd4Gvbg8SI2rXV0F1oN/CfNgzx9TXAaJf1eXVKlG0Qq+CDjFeF10mnNLO28Np7qAmO5e0S/2Rv9JO7eNLWOwbXEmAtwBS2LyTizHdeKvWfwHezy1gwBsVha8IqGBYHVP43snzw9NxmYVUZGTXnP0khyANdfsFBdvItVUcwOfXhwo41V9oKTxR0zcdw38H52xJp4ryqUiRlc80ZKz2DYKNe9uJ2/SxhtEAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH0PR12MB7906.namprd12.prod.outlook.com (2603:10b6:510:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 01:09:16 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 01:09:16 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
References: <20230126010206.13483-1-vfedorenko@novek.ru>
        <20230126010206.13483-3-vfedorenko@novek.ru>
Date:   Wed, 25 Jan 2023 17:09:05 -0800
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru> (Vadim Fedorenko's
        message of "Thu, 26 Jan 2023 04:02:06 +0300")
Message-ID: <87lelqje4u.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::29) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH0PR12MB7906:EE_
X-MS-Office365-Filtering-Correlation-Id: a09d43ca-e86e-4668-2d0d-08daff39f1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7uClBVERJuItIgBqASVXxpne2gcxAaDyQzWLtpLobrWwWXR116foL3/Pt9hsnU4PlJ5aIJB+XcIc+ZDRTelTgvC/Q9TnRGODiB0k/2+jWMBjFGA4DnCvmhHSFMcAjlZIb3PKu+E6qtGpx5YsqlNbOmwyhGA9OiM6HIjvd9pCsl8pYJcEMUM0ydZTwSOd1XujCD9C5b9BXCIgJgFKzpqSssNZkSqGV+HM/EOVL2o6kDP7aO2/z4W1BmYlGH6blJQYl0Jh6A2FTOg35bO3bRcttcInzasmo0IaxoDh/C1mM2AVW62Zg7RM6LSeUtTwEdu6ccJ8RlkNLCkJujnrxEj24yO6ptYHwVidAmiTDJl5SIMFxiF+gej7093kP/omvTWj6FGBGmh00BkXwwihYBUHEdhXocKIeL3X1/Kborf+00065R9E9H+DTEjxPlckDiPkOCNt8AR3r4i82QTisUCAqWPlAZEdJz47tGpKK3Fo8y+JSs9/uzWfOVZaIHS6qDshbNIZby8M7bGJiG5NZOxyMDkR7M5wDPnIRKhxbIsPbLcUvs9A2zNKHIdD8xH4FOhOIl9o7xWx7AIIZwp2TxRIqsnrpCU63bGz04tJq8K0xyuYyH0URQCgXB1fm7exaqDZGE28oQd4BDUuLGkY/PAWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(66946007)(86362001)(8676002)(6512007)(54906003)(478600001)(6916009)(83380400001)(2616005)(6666004)(8936002)(186003)(5660300002)(6486002)(38100700002)(2906002)(41300700001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pn1NzbQY7k6MKPoNGt7z/WL0VTUh0fUZHahDFOlKgp3eCe4qwWzmC/8/3HRQ?=
 =?us-ascii?Q?KWZn+FNGJp0DQ7IE8hcWLd+DoIdA5EyMSHfjgj4iChNrK69beej/FYM/ev8/?=
 =?us-ascii?Q?DjZmRbDVUJR1uwvK9sisS1hQNXyDuYn7NrPIj6RSaIJmOz4hfqnGMHnbSQ6H?=
 =?us-ascii?Q?J/reA9PsQ5cd5NFRIAvAv37fnMFVDqbWH6NCZwh/10DgDwn7xh+KJR4R64k8?=
 =?us-ascii?Q?j1v5Lav3hI8wEyb6AOce45mJN/qtPyDWxhu7QYYRee+x2GQbUwReKf1vXf/V?=
 =?us-ascii?Q?fEiqnIbYTIiwBCULlb48FzDFmSUZICWINfXDtnvaTUYw4omS1F85Yar5xAul?=
 =?us-ascii?Q?JoWLMuoNCDSNB3NE5TV8B+IvWnJB2rupXjZcElsNvmf3q9xhkcqirl3bsUxk?=
 =?us-ascii?Q?MyGbgryjy7FgP2wDsDDc5M8VK6YIXSuydasiCKM+62fcwq84aSRJBrFTDa3b?=
 =?us-ascii?Q?GlJnhXx6pJoLtQVvhESyQbaWO71SXjsHlEeeTqYw4k4MWCKxthhjiyjM1f/p?=
 =?us-ascii?Q?nBJENHDFIGXeHY0aU84nZtqjBxJktmHteBWGqsI3ElKqnyAUVufHQv7U9uwE?=
 =?us-ascii?Q?982A91+839AHPZH7fGeoLAnCyMS8ytdknXf6QA8qOxUIlLG1itMw1nknqCMT?=
 =?us-ascii?Q?WddZgGQCRRLp6xkf9SyXNZAWc1mTpcoTyIAb+AL+JT2Ch5QFmeQSSmwFHtgw?=
 =?us-ascii?Q?HJfSMwRyfuCOzt/ztzsVldh9uKoKwLyDD1AiWUz4ON5vKq5N0UHxvG6l+xyw?=
 =?us-ascii?Q?eJx9XKUS5cz4vosbJXed/Nzd6wwHND3ejIX8D+R/7k1y5o6UAXNLJA3csbeA?=
 =?us-ascii?Q?j2PNMsn6672Y1qWo/ifHjgKM6Gd//yr1yneBmrbrd1ZP0gJqRnomiD+AweRX?=
 =?us-ascii?Q?k8Kqar+gY5/V8OkEGnS4tFhvKo905ow/fIJb7+gBuYI1DsM4aPvUX4umwqJ3?=
 =?us-ascii?Q?jT9QR/aZgJZTrj2c0tF8LE4l5Wfdv5B4hdtlHEF+wlTIiuihxZVw+3/SLTXP?=
 =?us-ascii?Q?T02eyJU72E5ETth06PvRoSDyhJ2jGq8mZ20zBQzVUD8xfw9YJ4KxU43CohUS?=
 =?us-ascii?Q?s4VUaEhH23Oilvk6bgEmfLc66iRypWnvtYtpZDEARQ7DH6Rhj2cM2MIJhOob?=
 =?us-ascii?Q?AHhxiegyOfu3jp76UvKqtEfbW2/S6JsiGMfUAsu0hXiPHJnncfrIkVe+5qkh?=
 =?us-ascii?Q?aB0ebBI+G0HVFjxRoBlKeJLHU0BdVjvel1/irn2FSRE3AE2JB15O2x7YcXny?=
 =?us-ascii?Q?25Hi7mU6g9y5BstLfmVrIyDmeeffZVnRH3kwXobIgsf1EvxOOEtefq9hRzfh?=
 =?us-ascii?Q?96GmORwEggavAr+iV6ficap6TaT/LM1DJaXJYbnifz/M3bpL7uxIqBPlRD97?=
 =?us-ascii?Q?vdDfwqMhSTJ3mNmJ1Fkp5vKBjo44JPRVCUEAOo1jT+cUAPtvmZQHa9Gxb3uY?=
 =?us-ascii?Q?rmG0Vbx0eBfTllfcLezWHM2KEJoZb1JCyNn4gFiY8LChj0ylY0OIyPU+bBNr?=
 =?us-ascii?Q?aBilRQ6HN2V6R8KhfodeOwGFvlqEe+3H4/8auueld81r2HJKBY9UHliMVlpC?=
 =?us-ascii?Q?IdnMwOSqReGGJh/+/Hx1FZ6NolrSaojpJClx9JjRn/qzVK0Inf57J8/Ormn9?=
 =?us-ascii?Q?oA8HwAfGdIUPiu//0AbUy/SFENIXCdrzBgx2lsIlGY5W/G/t/1lim8XCWmrA?=
 =?us-ascii?Q?Ar2kuA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09d43ca-e86e-4668-2d0d-08daff39f1c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 01:09:16.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdZBno4LMWqdX6R0Oa3fvwKXkBKKkmwTW3rpqfqaTyJpoeA4XT0//Ot2C9xFzEGIDFFpQkizlpvhfEUsMKVV0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7906
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan, 2023 04:02:06 +0300 Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index 15a5a57b47b8..6e559b856afb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -289,14 +289,19 @@ struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_skb_fifo *fifo, u16 i)
>  static inline
>  void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>  {
> -	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
> +	struct sk_buff **skb_item;
>  
> +	WARN_ONCE(mlx5e_skb_fifo_has_room(fifo), "ptp fifo overflow");

I think you meant 'WARN_ONCE(!mlx5e_skb_fifo_has_room(fifo), "ptp fifo overflow");'?

It is only safe to push in the fifo when the fifo has room. Therefore,
we should warn when a push is attempted with no more room in the fifo.
Does this warning, as is, not trigger for you during testing in normal
conditions?

> +	skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>  	*skb_item = skb;
>  }
