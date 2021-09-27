Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8225E419BF4
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhI0RY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:24:29 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:31581
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236935AbhI0RVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaWk5wURpccpOoeOf1Vqor+BHhGhdCC+oKu2V4qHTQ9VDslIL0K1y8CsDdKrfg8Lxw5xzSd3BcBYfXcByl6yxvFFhJx90wcA3EDgRz5h9OKdWVmKrNY4Nmy/r0sv1xz3LjKsPjDzrjhBFNvFb1ZGYJmONWWVjxZBmS866AYvDuPqADr4bkaqxCrOgekzMltZOxJNEwZu/i46ac9SvIYf1ajYG34+LA9duJ9EsSwghQSTlcME+JCAwacvqeM90ZdW5W7+2Yp+1x62AsppO3zmO8WOxhX64fD78kXddSMuqEbf64TlILfs3hSxR4QkiAxLKq1XDSkqkgGhWSol8esqqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bAMUPDQfKbJMbldc7+ksQyPvmXokb2ax/0EphFC7XiM=;
 b=ULyDEHbcd935JcOS2b8QYmkWdeBwcJ82Rapb6GqQpQaH8fPE5Dbc2Woe8Hycwvbr8w89nfQzvl4Q0t+8bL7ZfHU1FgnmEj0yxKOqU+s6Tne0rd0eOsY11nnkPqAGIJ5jAm+v5MVrIiJKw3gsPPl0quMzun0FM9xM4/lkJYLkF6CL7PToytJCSaKMbtdv5rNe3uelHwcQaK9X+ntBs7NTo25smceAKgHwH6HCLYjXAknp5+DPAYlNZG1SKgKGE+KKOQqq3S1EgbwxlTsoslDug7bZadZIkqi719iRVXs0uf1A2gTUbCJpnceocl+yR3Soa+XADTjiBDTrCzgGYuuT2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAMUPDQfKbJMbldc7+ksQyPvmXokb2ax/0EphFC7XiM=;
 b=MTyACgUwkfCwME6TvrTBzC5XhTo4+OsOsWKcposXowY6I2aPY+xF814F9KrA3a2/ar19rp2dgWB01a26apRbF+dviWL+vj6YcoJOgPF36PPP/1MAKMxdhZ/N6pzyuxBy+Wk1FktvgajFjj/ZgPz/H5TXye5YFT+fTpkeV7jlcRhxEz8DZW49JJrLh7cD6HIe0GUSjto1b9D5xFUrGMbuZgc+Sh5Y++AZ603+frIVeFYhz8IH3RbYbEuLAT4yqh7Uy4nCbOasM/JEZdVOdytngdjnaVrqDOUCe8ITnpIMxuWMduV+wII9aa0PthYNSMh/g+oAInc7jiQM7hHC4gl+TA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 17:20:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 17:20:08 +0000
Date:   Mon, 27 Sep 2021 14:20:06 -0300
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
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v1 07/11] RDMA/nldev: Allow optional-counter
 status configuration through RDMA netlink
Message-ID: <20210927172006.GC1529966@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <ed88592c676c5926195a6f89926146acaa466641.1631660727.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed88592c676c5926195a6f89926146acaa466641.1631660727.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0124.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0124.namprd13.prod.outlook.com (2603:10b6:208:2bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Mon, 27 Sep 2021 17:20:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUuIQ-006QkU-Hw; Mon, 27 Sep 2021 14:20:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc452157-6950-400c-5606-08d981db0da0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB515960DAF05AB9771AABAFC4C2A79@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJxUjx1wmXqUXCYUNVLphC3PIszjgcItupTeA1VBP0zfIHFyZTnBmfLvUYQniV7Dkl7du/Xrq3PW85d/EvFctu/gvMhZRgSI15JiBbh/C8Sq/T5ek975DRZ7UusbiN9sZdQV77/aJxWaWXtbT2EXYEryC9A3mbtTeXLqyCJ9J79CnpRDeo3sBt0c1dbiDJxXmUiyBmLIVU5pU1Q17WxaYSXijJUtCy9QS6flsMm3jCwJn4Js/AUpppg0h1OSt2o5Vf/gZHHjqlHya3+v5eASzNl2GTvSM/HNeb7X9dhbTcU/r56xrxdIHdVSQnzhl0h9rgdwbyYFolcHe0WbPvZE9izM/DsHLfHIm78GHMV6lILKYz7GRvWN3IaG1gIJkJMsiKxSe5ICETtkCdRGhBog82vPZDY6gb+hhp6L4qIkt+SAa5H4RkGJ/EVu9Mk9hWtodpCjgMdPWd1v9kX4RaK6W4c91YH/1YlZa725R1mLUiIKlaglkss3jXMjuGMqPmzhhzJq53l0fqdzSN5WqcrCI+j0GNpQDf7EGZRJcFE5RbD0GA5CIroDcybVpGkWqs+nwor3WSahS1BCbJLE8hYb6ODha8WTM6NeNxuTdNVLoJnmBhPJz8DoyC83uJ07+A7XYq2c4uSrPBmSpEpGpqHbzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(2616005)(2906002)(316002)(6916009)(5660300002)(38100700002)(36756003)(7416002)(426003)(54906003)(66556008)(66476007)(66946007)(9746002)(9786002)(508600001)(83380400001)(8676002)(26005)(33656002)(186003)(8936002)(4326008)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rLK39boPqRRsCK8BPtvitsrTJQ5+h4sjlXxrQd/+z4DANjsZqJ7kcB4yLMQE?=
 =?us-ascii?Q?mD9sl/Btnck1DVox5FCfJtvTUxkIxjTBCnu2s8lhLdLKXz9K7QJRLcc5hc37?=
 =?us-ascii?Q?Whfoa22q0QaEqwpKB50WON4ejuYyTdw4sWQHJHUQhMM8jJJ9Mh7CeB2+y62H?=
 =?us-ascii?Q?7OvoMFM7NNxR5XNVxlTnVG7WvXWaEX+K60YNOfPxT+mSCRB0/bqv7dl6/qxb?=
 =?us-ascii?Q?fxnGXjA1ZXk5rz3dKcUccXhsWL0B3Y4hoDQlwb2IwHF6uLtPf2eFi6pLOsbY?=
 =?us-ascii?Q?oogZ9Fh8rL7+zam4y4wxwofn3JqSbxt0NysinwZ6F40Z4t1RfaQtahbr2PUo?=
 =?us-ascii?Q?EuDKm7HSLOpgjqBpVedtUWLVbQapo9JKZW3Qb24dumJESq5y3KzdPAy0laH1?=
 =?us-ascii?Q?/7+knpYQNgV+W0t5Bm8X57YO2775POaC1OvesxZNhh9Awrf8VNM6FxrJYQPx?=
 =?us-ascii?Q?8ob5h5UVcDijvl0UVS89iUxj456RxIuk/xIVMxR1ODy1W5ANmd6fxYgaAKCO?=
 =?us-ascii?Q?zp4EugPfb5LDvq3DKtx1cgnp103xXWogeW9aC6qSzTfwM9Al+6OD3+jaiuax?=
 =?us-ascii?Q?/Ew1YKDapOIvwKYqtH/AdNPU7vsA9XikaaDNtK8+sToOdc6TjhA7Mzw8I7Rg?=
 =?us-ascii?Q?MM5AaZLPtJ4HW9XxWZal3qsbiDG2antadVdpG1GjBwG0tJJy9tLD3TMDkW0a?=
 =?us-ascii?Q?wZYp3+w6vbws0fcf8ajruIyd+9nYAXVbexH9BOUVq0f+M7P7dVBbIxA7SCCY?=
 =?us-ascii?Q?Lq2Gz706QPk8TnF3kbLusfu6AGBB2N2HdfiWWd6nL+7+P5yviSkr2Lr8Es66?=
 =?us-ascii?Q?XdO7XxgtgBI2Oggc33OtfrsBnWki8RUCBh0MuNNVQoGsA31HUanQw825ohwl?=
 =?us-ascii?Q?8+g2LF8B/S5vn5hBBP4wXL+Yje4vl8dk/wd7Z3ZumgAoeZY+ouJURBdUmAE5?=
 =?us-ascii?Q?lSZAQt0FL3rhAYv2UTsPQTtrGaorlJpazQ3H4FCVsa2vxqmS8SkoHh0Uj9Ci?=
 =?us-ascii?Q?jJ1718qYjqz8sf7P36b/E2txPQ0YpAlrMyVgYpTKHbKwRsvPJMRWF61ZUlV5?=
 =?us-ascii?Q?jJBv0AYcpJd3oe9qUH2rBIm8XygS/V+r6vfGyrsparDx1JDXj+731iSq+UwG?=
 =?us-ascii?Q?5Tnpn/Pn7OnGuyoGdIlxVMni955YRqfeez+tfyIAxqBwdRlKxavjnVP69UsG?=
 =?us-ascii?Q?JfFJNft1dtqjPQw7csOJHQTtIw1FRqMS6ExvyG7tpDiqAu3RZd/4+qphVHK1?=
 =?us-ascii?Q?RtXPgkKKl+953nQ8FCiBBgcR+st69bIFCSKG1LnB/6SMpjpve6mkYfA4a4z2?=
 =?us-ascii?Q?6MBHyswTerjJdpLbkCzhPuKN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc452157-6950-400c-5606-08d981db0da0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 17:20:07.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSKMcRxp+BgND7Yr2JVQj1HPbxAkE+eQl/2ixHzyltjgInC3LTjNQoEx1klxRW+w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 02:07:26AM +0300, Leon Romanovsky wrote:
> -		return -EINVAL;
> +		need_enable = false;
> +		disabled = test_bit(i, stats->is_disabled);
> +		nla_for_each_nested(entry_attr,
> +				    tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], rem) {
> +			index = nla_get_u32(entry_attr);
> +			if (index >= stats->num_counters)
> +				return -EINVAL;
> +			if (i == index) {
> +				need_enable = true;
> +				break;
> +			}
> +		}
>  
> -	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> -	if (!rdma_is_port_valid(device, port)) {
> -		ret = -EINVAL;
> -		goto err;
> +		if (disabled && need_enable)
> +			ret = rdma_counter_modify(device, port, i, true);
> +		else if (!disabled && !need_enable)
> +			ret = rdma_counter_modify(device, port, i, false);

This disabled check looks racy, I would do the no-change optimization inside
rdma_counter_modify()

Also, this is a O(N^2) algorithm, why not do it in one pass with a
small memory allocation for the target state bitmap?

Jason
