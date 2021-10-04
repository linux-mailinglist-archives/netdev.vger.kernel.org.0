Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0895A4215D3
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhJDSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:02:13 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:32225
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234465AbhJDSCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3de+X2UatLAyDIZ8Te8wf265ap34rqCaMuDBx0JwcVgi/sK+6ntgUEVxkvoXdyqKTN5pzJrlPuaNQmXbSbnL8F7dgW5ojoazadCrPq6jRroko1s4QSaTDzS1sUYmEIoeM5LtHOHbXLJh7IYt7zvIrVsINQqESsOkrnXHoYoFb00FWh/MywlU9CjzFf1UWdKiIGId3YkxbP3q71Dff1DxnftSOyu9Fo8AfROj/QiY4K469V0DfqVPtYitrh8Zl1O1EW+Ku05Qx85Jskp80u/ukRBWYD7Ay15VpirTMEIEoetHEZ2hyq4PYACHJ5Ji/Um7VUZ5FjvhiyNjbW/hTAjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtBg5p8PComzGqpQl88ODPxI9d4rR8kB9MG5bROgqhQ=;
 b=N5wc85OwfIQO4Uk1Ff4y7tPMlFf1+K6MRg7Uwd0oiVgmB7/Bir4J8sDfl91HagdKzwNJMGhAJ1uryDkr2Mw81TqhqhT1z1Gwmce8GwkksQinbSH8P7unt87v5LIEmM/niLL9S5c70XquDXXAi9VODz7uQ0uwegzbEz5IyY6TFTdHed6nY3RZLKjNny/vLqN/lUqoqMF5goX5VxpWYgyfdKMIDN8oxaa+HcNG45YoNqNlKRbNWkwZeZhfiTWSMbt7A6MGL/kaT/FhrA2wdRNITixn9Di1q68CxCvNP4/Z7S+30LWvg3aL90f0Esmk/gd5xHSwJeKuuZ4pMJeQ4im6iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtBg5p8PComzGqpQl88ODPxI9d4rR8kB9MG5bROgqhQ=;
 b=BPIIMsQyTypbF6yX8J/TdSzJdqbkn9NTWeRsZ5YK5wNEye3YczpB+nuF+0Ad5EELRZQ+hZorWccBeXKjYnBXixXkyy/rBKuZmtN1TuE1/J0mJ6/LFFxH65VGhaWqo3zizXvd/r+2DhTX6lJETLbrN01ivkTmJ28fVtC9FfGqBWCFgg27jV+ZVBDJFz3jbJ9c7HP9Mr+TNj9Q4izsEoYCWdiJRFzVFLr3WNnudfY8Tca3b4vDPISV/3nyIDUoLZy/8Kjxlf+KjzYAZ1PvE8vaj0WbmQNzOk1kO4FJNE2/Piz+wwkwdEdADdZZYHGK6ZwkMuShHVi3YMgCQWpKvt/KPQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 18:00:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:00:21 +0000
Date:   Mon, 4 Oct 2021 15:00:20 -0300
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
Subject: Re: [PATCH rdma-next v2 05/13] RDMA/counter: Add an is_disabled
 field in struct rdma_hw_stats
Message-ID: <20211004180020.GB2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
 <1d49884d3e77273fe714cc49d688cc0c1bae2e80.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d49884d3e77273fe714cc49d688cc0c1bae2e80.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0241.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0241.namprd13.prod.outlook.com (2603:10b6:208:2ba::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Mon, 4 Oct 2021 18:00:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSGC-00AYXh-H5; Mon, 04 Oct 2021 15:00:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78f12bc3-09b8-4b59-4e14-08d98760d529
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5094FFFB38C12305C44AE999C2AE9@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Go3w5/4+RLZ015s9MxMJS6JilYTOauuy78OSYWovFYFgzwu9u0psIRWwhYxtMuIpL1XszHKP+vDRQyLokyHRegPYSgP8KQzY+Gxo6lmP1LA7PddukX3Xja2EnAs6T70xedvVhgXn220XZp28kZUqG9fV9zsCI+w12DdNnBl/FPNVN682zzCHcIuRitnx5mRmUzABfzDXalnYuKNxn9bP+f1EiDMoJfkYRzx7agNDjCZfU86qmKn4YDFQ0/r7lVgWPaCDDVxoekJ5HOU9Tw0AnyKDHQZIuUk2rmICdouTji4exYgRKO4e6EslBEj6CNKvOCj9i2UIuGRbsaylLq679x9K5aBNiqNLmlUpGWyNPbnIqEslYBtQkOA1ZtqNXSGaJItPWIZ1eYrMuOyZPhvgY5kiWVLix086S2dfweatTUv2d36Il47Rpt/H39jZXtj50A1lPriHBw8CvmLkUwB6G4K9jdiqqo6KSMjRHU1rEE6Q+mGadF2OQBKtO0dZSLcpgrgVGLM3xJkXUZEC3K7I7Iodf0EjcHJX8Pyq46dVVcdIolQuYoxG5BT6oryrwdIX0Kf/Q/NzqiwD9KpmKVituN6sdPinMCxq8mYisYFMIt9UvohBK90umTFnsS2rtQcMrT2QcRb5kh4Wbd8qsNReNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(54906003)(5660300002)(4326008)(9786002)(26005)(186003)(33656002)(1076003)(9746002)(316002)(83380400001)(6916009)(2906002)(8936002)(36756003)(8676002)(426003)(508600001)(7416002)(66556008)(66946007)(66476007)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TloE0pcXU2wCF4X2LAJefUyady79VrWJfs73GjzU/Z9lX/+Jp0A5qXOCdlWm?=
 =?us-ascii?Q?Dom3pS0IC/Rg9xoSFtntCuaJDhIqLtv+Hwk7NHyl0JsSmnv5hjyJ6+wODrC1?=
 =?us-ascii?Q?SPm1c3r0+DFED+wAOyaC6qfhMazUR4TATkzQyyd/gaFhuiWsbFIGV0VeNE/n?=
 =?us-ascii?Q?hEMsGjrTjBYtRK5xHgZX92zOZI/NMeG0M1Wf8rdNRiUWKJG5Xnih7dJuxoVX?=
 =?us-ascii?Q?QlH4eBGQH/P++1LQwybvtpfc0DT+AbTb/HOEWtcphm+JNNafHXVIaGtPveJO?=
 =?us-ascii?Q?1GyLrp9FpUbd7SxBbObjHe1bD3hdLUlABm+lHGgSuW6tsswvplMWZ04Fft/G?=
 =?us-ascii?Q?ji62kIIut9c6MIZKCA17dFxNioJPpaE7GUw1m6zQUOhftEVNsYDz9pbV1Fqe?=
 =?us-ascii?Q?J9HwoHBNibojjOL6dZfmiFO5K0DoHh2iUuvo9yXdaIrpJdlXlFC6SpkpCtdh?=
 =?us-ascii?Q?ErB9RnNATVN+u+OK2Tfw6rfOPKwgdw2huf1IJBErfpz10mvE9Qu7wzRBRp/i?=
 =?us-ascii?Q?mu0mEznQ4Ah9BH1q/4x6S+JvA0q565qnYH6HwfHQIGBusENHHyVMQaDpdhs1?=
 =?us-ascii?Q?POtRABt2fKTvvTIBldFIJjeJkEdwsyrlBuJJUwInzke9qIQKe8AQ9E56QokS?=
 =?us-ascii?Q?yuV8P3DwNINtAQnIQLeGZJb9X/OIaQ0pIbg7kpqS8KlNjGVgU3eak2kCoSSi?=
 =?us-ascii?Q?F0Nell6fenARAXecFwSzrOPNTK+mqkzveXVmK2BzJsfmwK78q+AmBFiKFZFB?=
 =?us-ascii?Q?o4hKbdT9DySQLsnkClF9qiD9Eh+on7YHqhoaZ1PuLeCdUknzRMjR63hNB79n?=
 =?us-ascii?Q?7Ap+IRu6NglMynjyqOcG4N5sK56aMmyl8booFCRBPThkKpTKgUsjLT4Xzuhf?=
 =?us-ascii?Q?k6SLjH8Vz+NctRxYxsgd8SX7hmU8ghjpL7Q4DWoZuMA2qfYO6x80TTiZYTo/?=
 =?us-ascii?Q?7mPj2ae0MeWtfTLit4MWft6NYtegeQ9eE/4B+P3HEF4pa9dvxQBl5nTWpdc7?=
 =?us-ascii?Q?oFhlIc811EkNlz0IWAlAOVaV+CUp/9MwnrQ53RbpVFoTGeLvPcumlj5jId+m?=
 =?us-ascii?Q?3EDmrc5YyOaJR1vWo+uUicPaCCeV287w79oUoBRio8zydVapD65z2MvtqOxG?=
 =?us-ascii?Q?hn5qFvoW6Uzc2ukx6brZYOWN4rJVKbvR52pNb4HnBRsCBC8E3/oTTQb9APyE?=
 =?us-ascii?Q?eRvXa7ARHVrHl51kbuGj2Mv9Gt2nx3UDELWgLVMGWmyMv8IHKgZCgqZ3IQCp?=
 =?us-ascii?Q?A9rNb+ZJUXWGABYUcu3ysNYt5SPrWUCjFYMgbmG2xqkMBWe2tZD2C2WXrQ4I?=
 =?us-ascii?Q?nnXWTVON2KYoBM2w5FHpq7RTWkqW04wJ1JmnsGomz/1ReA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f12bc3-09b8-4b59-4e14-08d98760d529
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 18:00:21.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhCID13bcF+9US/nfg83UfJhBMIAR6gu5QMe6djAoGYD3+8jBHvMelDWhIlQmFuI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:21AM +0300, Leon Romanovsky wrote:
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 3f6b98a87566..67519730b1ac 100644
> +++ b/drivers/infiniband/core/nldev.c
> @@ -968,15 +968,21 @@ static int fill_stat_counter_hwcounters(struct sk_buff *msg,
>  	if (!table_attr)
>  		return -EMSGSIZE;
>  
> -	for (i = 0; i < st->num_counters; i++)
> +	mutex_lock(&st->lock);
> +	for (i = 0; i < st->num_counters; i++) {
> +		if (test_bit(i, st->is_disabled))
> +			continue;
>  		if (rdma_nl_stat_hwcounter_entry(msg, st->descs[i].name,
>  						 st->value[i]))
>  			goto err;
> +	}
> +	mutex_unlock(&st->lock);
>  
>  	nla_nest_end(msg, table_attr);
>  	return 0;
>  
>  err:
> +	mutex_unlock(&st->lock);
>  	nla_nest_cancel(msg, table_attr);
>  	return -EMSGSIZE;
>  }
> @@ -2104,6 +2110,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
>  		goto err_stats;
>  	}
>  	for (i = 0; i < num_cnts; i++) {
> +		if (test_bit(i, stats->is_disabled))
> +			continue;
> +
>  		v = stats->value[i] +
>  			rdma_counter_get_hwstat_value(device, port, i);
>  		if (rdma_nl_stat_hwcounter_entry(msg,
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 71ece4b00234..890593d5100d 100644
> +++ b/drivers/infiniband/core/verbs.c
> @@ -2987,16 +2987,28 @@ struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
>  	if (!stats)
>  		return NULL;
>  
> +	stats->is_disabled = kcalloc(BITS_TO_LONGS(num_counters),
> +				     sizeof(long), GFP_KERNEL);

is_disabled is an unsigned long, not a long

This should just be sizeof(*stats->is_disabled)

Jason
