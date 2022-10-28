Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15B661191A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJ1RSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 13:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiJ1RSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 13:18:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF481DDDE3;
        Fri, 28 Oct 2022 10:18:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6TPNW8TwMCfrtUKtM4MhMCs55KVrFHjbgW4IA2loTHFDOYYKRFhr7IMa0EgsKbfdrfscOAvutbfUHtjcmMuw+yAVOyXDW8BPu3ADraYYFb/7Ecx8iRp6xJXnDcTTiA8AuMBAMIz4r+ON5dt/wGq+xFeQGt7TcvUGPGIq9TCrG/vPGtauRQugw43UT+U3FkdaI0scDxV6cRfUAOrTeudZ7n4RDAfSorcN0kmCV3bmjdfbGWy+2rxW2L6JM6UtQ5YaUGLWw74Mm1e7964YZkBM3sCJ/o0JfzLQSt2HqSkz4ZQnKS+g4BXk8+uMyfTxrVKYZ9Qcw3O3FceApfV9CRgzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmtnkLIYnSgtNykn7k2R7pJDsfk6tT8sX7LBV5KTP+M=;
 b=HCCVRCdtoHGG1Qvzs0I7qr4F49hnU/IhkOITrVbIf+T+BipQNfkNQCIPg7XkM101WaSICUD93eeSlZAy7xZohY4dRM8/gIyJGqUt6lymO0y7vCyJMo2AsJvXbQgj3ykGAGxfHyZDmTygAGzfUaGD6+uQGsaE2qM7OUdFLfo/fBlyGOGO6mKYczcWBkEJPdIZk8v0KXKSMk8yPR/vKIIZhZWc4yp19rYh2+JedXm8mEN87IoxvXP3KtWe6evK+8ieq47XybainJDXFgSQYVXfCSWm0orPXI1Sskmyja3RrtKE8mkr6/Ozs5NKFDKPC+QOXY4Y+yEB8T2CaONaKvfxdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmtnkLIYnSgtNykn7k2R7pJDsfk6tT8sX7LBV5KTP+M=;
 b=QOT9lt9NaUE+9DgPuEnJUREo9fZAGINjhgm1Xz3qxsCGTxJYtW5MzNh/bi2jt37OIT61PS/3KV+msd2eX0SFgWK7ZYHld2jF1fKyC6WUNVLg81SwPZFZr0f64oUxY4uOKRNs14NruywnYXN5S5d88iW4yTUh+DeaOcIolRfjanXl/IE5ImEpQq4BTsdq4v7JFzX0Ex6B+zvavbuJ8+ppABIaLXJhhADPocsTSu/5s2WlrAql22RPjGIDWxmw8oK/S3kblV4qNrbrxWjoXbE6MavsEWo+UjSFWCvUHRCgzVsEwPrxLhqt5MqB9K/DAboK2zubtMt0ENI7g98a65viiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 28 Oct
 2022 17:18:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 17:18:21 +0000
Date:   Fri, 28 Oct 2022 14:18:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <Y1wO27F3OVqre/iM@nvidia.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666396889-31288-13-git-send-email-longli@linuxonhyperv.com>
X-ClientProxiedBy: MN2PR20CA0063.namprd20.prod.outlook.com
 (2603:10b6:208:235::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: c736db67-f7db-4aaa-9539-08dab9086967
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vobwj2y8oiBClqXm5JRkAcQLCK8NYYXahqXlenKlU+pIAv3wMUh4vIz9tn1AF/4e7MWjnFR0C5CjE7mhXPClfQ4XGxp/XAF4zp0NfunwL3hsMoELp8Cdt8LkoBnXyszicC7EMQVYEArqkVR8xda0osjCqb13890Rb3Go2X+0PATMZ/laweV4C87YoqLUtvJFiIYfMlGuqEkQ4i5jyXYU1bvYCNB+Ar+iGMq8WHVKG4SZrZ4AbB80x5vW7C/azda/xxLIedaVJiviDESMjhJGv4POOuEv2zLcj2LiNGhN9vhdNyJ5ytwrs7QksqRU52et1oetFNt+21graPCbThnUROyv0zzWWJ4XozdjnjOmVWQi7ms4QdBhuYcpwm75cSIftT+LNuM9a7PYXhZ8GLcR2M/ZhqKhGOh15KUpaIfVIw5JTA9syxi9nXiwDMclBBqBtF3H0fFZVoXzZNFXUAIBFs5EbEE3e6C9APFFnZNpXgNKgVwYwXPW2Lg+8PV8MPfaOTrNgY/CJ2RxUuJ1tefCZLGe/z1OZt9Y0F1/uPf2vozara9Eg+NhaRk9uWEk5i4RVAk6Nwyl34LC36YjnqcD3rSmp6ouP1tFqQUgzGwwUeNre7ir6SkATA34eoFV8PiQfpdlMTw7PC83T6qus2/nltT4OmBuiXnQhXsLjF6EYeoo0jgwhJUlHcaNIHlPOqKHEOS8FzaCkQlJY0w7iyVcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(47530400004)(451199015)(36756003)(2906002)(86362001)(45080400002)(186003)(5660300002)(2616005)(52230400001)(83380400001)(66556008)(26005)(7416002)(6506007)(66946007)(316002)(66476007)(54906003)(38100700002)(8676002)(4326008)(6512007)(478600001)(6486002)(6916009)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWfTF1I5ACXNclKVUnz2HTIdYBuKhNp1SHqNxzasvDn2H7mOwFHelT4iq2qu?=
 =?us-ascii?Q?d0pIEmvVJqHvjOQOmF2j8JXYqAFrX9Mxe/td4LLaiVfIqfkCHX2bQ3wkQWor?=
 =?us-ascii?Q?69ia/H3PrUMmQoxlN2IC8LnQ1tI0xGl0aGcjt434vaxgFejEXfFDZfcvqo7s?=
 =?us-ascii?Q?M2CImjyuHwNM19+L6bAmPg4iWwuvP5ucSeA1k5UpKlqKojCzjBmHkniYQgWT?=
 =?us-ascii?Q?k4lcgAe4xQzo6oGSe1pMqW57kcgsess/AlZJSGo7YFrAeOUVbEifBaZUq5YS?=
 =?us-ascii?Q?b127ctkugY+9dMVxhp+QYMawYPW3WzFjlFZUIpYkdEjOm8oKa2cfv65cC4u+?=
 =?us-ascii?Q?LNzjLs7EIy5wjzRrRhG5p68+sW6vG0rBALafk9v8dqFpQA7kqtsEpYSH5MzA?=
 =?us-ascii?Q?XCsK+Ad6YlUdZmQw6eJpZ4li7r9rGcFVtfzK5SrXxilaZB3UInAxqD6fjtR5?=
 =?us-ascii?Q?2Ywm1CbLgfugs608hYJ4//vvLP63PhIAJka/YV+TNJVauMt9sPWqeokQiADv?=
 =?us-ascii?Q?DpztziJI3yEd61RziH5Gao5Slbs7Hw9w/3nIxEg+MI4mTaEd3AODZ1iPYp26?=
 =?us-ascii?Q?+ekO0T3Yib4myixFpRHloxhs5TDeaNtmLOPKHqvGOUdYIjI8GHV7v/yOvHak?=
 =?us-ascii?Q?rpG82n1XyII0wRTC4u19JUrb8Boh9sWZzHHJjuBNDU3S4FaRWBSwxIjQbAWD?=
 =?us-ascii?Q?frCig5t7i3i0ieQ6EXoSr0McQcsqrH2J0IFuzKZpJY0LCk3IeAbZw4+SVQoz?=
 =?us-ascii?Q?wI8PXqAm1q4CqUc6z+4v4PZUmMrI03TLnfezFXfD+/DR6ARTUAikEf/wMfQY?=
 =?us-ascii?Q?j4yH/Sk+IcONnA07ZVlQXsdvL+Mfg+bv4BlpjSBaLIQm8A1l+ad/fMes0vg9?=
 =?us-ascii?Q?Zs1TwS7v/toIo19yNS3wk1UAXNy1ujnyOYJPPCVHyVYb0eJZRqnddjI4ctXO?=
 =?us-ascii?Q?brLk3Q7K5pjCb7yzwzPZieFyw/gHupa8TizsvPP/y5Y6bV+2WfP5puKTHPTD?=
 =?us-ascii?Q?SkQXwkIufWyKfc7OuycZdcN05OsO5FmqxLX7JqK3FkxiuCVPbNTyuYbnsjFE?=
 =?us-ascii?Q?kZbA7V8TCa8iYpIF3xxDf2Gvh/FNFGmAYkgXR+84IUTG8rwbHC8SietJIJ+Y?=
 =?us-ascii?Q?nrvBvbQTXJxR2EuhCWbWa32gmBuMOIZLR0GYAaYpPmxRfdnNJH8TtW03nKqu?=
 =?us-ascii?Q?fns5lX8bFOMS1uEuAu40pVrJq/45XAtE2XUSu26xBEfILTqM2Zpymg8WPIuJ?=
 =?us-ascii?Q?9haXPmH91ZyoSOHWNLv2zI7zdPsWsK18XtALRC2h5MKmGOrccHFsGXEyzV2q?=
 =?us-ascii?Q?zvr1pa1Ly+kj9Km3Ws4p3wVlcXb4vIzX77o/WPJCZfl/KxKFwxG9lT71WcDk?=
 =?us-ascii?Q?yHQfRfTFW5j7STmIfgxwpt0/z+j6Oit7CGiXAQSM6r3f9n0qUse1mR75/QgB?=
 =?us-ascii?Q?nqqX9w965XdfNMhfDHPiWHJsr9beJ9mnoOgKF9IXt5d3fmFO/ExvMRFKj8fV?=
 =?us-ascii?Q?WMvlkfy2gnXrOZnroE7WUiB1LQ7IiNKuOA7g/fa/IbXqYsS6IYYhf1jjAIji?=
 =?us-ascii?Q?6KB/kmHWsYctC5nHsS0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c736db67-f7db-4aaa-9539-08dab9086967
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 17:18:20.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjGrDXR1DwrDvo/n87soY38Jiv9+jRaBukv8B/GyjG1rjF40Zm9EhpAAZCMbSvHh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 05:01:29PM -0700, longli@linuxonhyperv.com wrote:
> +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
> +				 mana_handle_t *gdma_region)
> +{
> +	struct gdma_dma_region_add_pages_req *add_req = NULL;
> +	struct gdma_create_dma_region_resp create_resp = {};
> +	struct gdma_create_dma_region_req *create_req;
> +	size_t num_pages_cur, num_pages_to_handle;
> +	unsigned int create_req_msg_size;
> +	struct hw_channel_context *hwc;
> +	struct ib_block_iter biter;
> +	size_t max_pgs_create_cmd;
> +	struct gdma_context *gc;
> +	size_t num_pages_total;
> +	struct gdma_dev *mdev;
> +	unsigned long page_sz;
> +	void *request_buf;
> +	unsigned int i;
> +	int err;
> +
> +	mdev = dev->gdma_dev;
> +	gc = mdev->gdma_context;
> +	hwc = gc->hwc.driver_data;
> +
> +	/* Hardware requires dma region to align to chosen page size */
> +	page_sz = ib_umem_find_best_pgsz(umem, PAGE_SZ_BM, 0);

Does your HW support arbitary MR offsets in the IOVA?

struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
				  u64 iova, int access_flags,
				  struct ib_udata *udata)
{
[..]

	err = mana_ib_gd_create_dma_region(dev, mr->umem,&dma_region_handle);
  ..
	mr_params.gva.virtual_address = iova;

Eg if I set iova to 1 and length to PAGE_SIZE and pass in a umem which
is fully page aligned, will the HW work, or will it DMA to the wrong
locations?

All other RDMA HW requires passing iova to the
ib_umem_find_best_pgsz() specifically to reject/adjust the
misalignment of the IOVA relative to the selected pagesize.

> +	__rdma_umem_block_iter_start(&biter, umem, page_sz);
> +
> +	for (i = 0; i < num_pages_to_handle; ++i) {
> +		dma_addr_t cur_addr;
> +
> +		__rdma_block_iter_next(&biter);
> +		cur_addr = rdma_block_iter_dma_address(&biter);
> +
> +		create_req->page_addr_list[i] = cur_addr;
> +	}

This loop is still a mess, why can you not write it as I said for v6?

 Usually the way these loops are structured is to fill the array and
 then check for fullness, trigger an action to drain the array, and
 reset the indexes back to the start.

so do the usual

 rdma_umem_for_each_dma_block() {
   page_addr_list[tail++] = rdma_block_iter_dma_address(&biter);
   if (tail >= num_pages_to_handle) {
      mana_gd_send_request()
      reset buffer
      tail = 0
   }
  }
 
 if (tail)
      mana_gd_send_request()

Jason
