Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188F6357347
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 19:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354909AbhDGRgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 13:36:02 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:39801
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354905AbhDGRgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 13:36:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdjiCFGfQJghkgDmznW0DFuRascLlvl1/zmQXpsU/i91bHplmdnfvN/5XS9UqiRLc7R2E4QNGfadaXxp+Qt7QCbrBOMnlZQ1qqqntN93a8w7Y728+2tbiEutRJ4Ch400lNxQFp2Ud3ODPg6nzz9lZl0txvPxFXbJ5WBmNkS9jW9waU3L6+BFpk+STErm1jeaox/bDMQDPf9f1a1qNT0eCphaxaW9rWzzNKjUVNwNx7YXxVo+j+HRD1Ne8n2fC4jWXJnO7QxHkp927q4/XKdF9h3wG4UujiC2gNuZYvXvHKz/Bo+4XREDZu/F7rVOMF9b7wmApqSqFzwvPWB7QyO2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMqBavBuFT+XXc+FNwIy7h6GRcmqOQtlZk77KG5rGu4=;
 b=VjdKAxsSRg0UYGCfL8vB85Z3gcl9wwZSk9BNtixUn1cox9TSD65M2G5/YzAMtcMuHaPEO4dDz8ZyvdvoRogJWj7ozDyTwY6eOK9H6TWx1xwCqDEc277F9b3tPwh7ev9ALnFgt3FoAOMknJ0HsV0vD8WzN/Yr/9gvKZ+8N0NZxRm9DuOXvqnxIScAAz6Dv5wC5bN/LS4+RHnxFlGWNY60+fapByGPXu8lgEJQfF1gOkRhIoIqU5AaJPYbgOldOybbLsEazxfvVOPMTptPO6v6BieOOH9SisvsQxYkTFUOpHdj8TPw1jqG/h61yzu6JKPfRYy9idYj5GmwmiCk++oJTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMqBavBuFT+XXc+FNwIy7h6GRcmqOQtlZk77KG5rGu4=;
 b=L05HWzqaAdSYDzP8w60l9r5AEfgRaH2wO96f/HRlH7nxC+jY+Z0jgG4MZka4UdAfG5odbEYZDaFTkD/z3c35/fbOkt8dXLpIvqBj8yZ6H7KOvObpbH1JPEJ/MyjbXCMbWyECWlJT6zU1471x2HI+myHrsZorA69hyNlL0dyb52WqtdUZejQd1GVnBnHoRU0vNnfUXG3M46vRmkHbdDE4Mgx9Fnaef4XEmjjnmVDv+yoQTCpCxvuw4g+DYBai/LRd0KV1GEJ1dre8vPseeg7cXGCfJc/n65sWlCIQdHrIdUV64mhFPDL+jrH0xpOMqrj4Yqt1vpsnZpo++8W1k90gFw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 7 Apr
 2021 17:35:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 17:35:49 +0000
Date:   Wed, 7 Apr 2021 14:35:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <20210407173547.GB502757@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406210125.241-2-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR1501CA0014.namprd15.prod.outlook.com (2603:10b6:207:17::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 17:35:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUC5j-002H1D-UA; Wed, 07 Apr 2021 14:35:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2f6d144-af30-44b7-70ca-08d8f9eb956b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB020488378E763A14D8150A28C2759@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEyFvYgCIhldtw7LaX7YU0Fie8FBNhWmvEW4pQ7D3C3jWQoCbCCz4XrAwcwLl7lgmFY/7U7bITdb16lOWXMs7QjRy9JLuOY4PoMm+oojsbGms5WZygI7C1gnK7jm20HDEhIiQ7QxGK8JyypORyr0+W5I9jVk9T1AODmbXZmJeCi3rtKFLGtaiQj4pwHZqf0uGKh81wY+1LTv/86zYvaf41vqz/PTOT3zndzsL7mdz9x23P7ylFRJQB1RS6XUN7K00ydTgExpYPPFhfcpUkYOlHDaydHkG/GcUZtP32GH+YzHi4Ph7t9p8LVEOmGLEorqpPw7z6Aj2oAAzjz7UgZU8DiFHRjOD0KtMSf3zHEp4q05q6esoN7PAYUXD6tNzcV26xcCTC+TG2C8r36pF+l6sdvsOkfGJ/qEVJvCZgcRQQokBL4sQ+pW1ry6LSufKsjiV/JwiVXyrht3qYfpXEocK7/U5PVkXrFeHGIBTL+ajPKXlfnXJVcp6U/HLcUQDLGxJIQ5JtYE2UAxf+HkxnmbXeby1yMdNz91NlekhjzL2TMmbZUixCc0bmgdCntDAEHQCRxIAyQ2tYO8SeHO2UZ7ZND2uFVSDCcPYgkpZ4pmPgsKiT+E1AmXtcux8FlJ7eAZaBc9bgRICNH4tE1pZqdyZ87M9bkOfvJuZInCeIHyF1HQCt8Q/6J4vSU3AV4Xz4wO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(9786002)(9746002)(2616005)(1076003)(6916009)(66476007)(66946007)(66556008)(86362001)(478600001)(8936002)(8676002)(426003)(2906002)(38100700001)(186003)(83380400001)(5660300002)(26005)(36756003)(33656002)(4326008)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TKjdcmQjuRrYdmLfQ050j703XTkr8huaY2dnXrPJhNbeefXEStapagQY7zMS?=
 =?us-ascii?Q?5Hk5yt1xBIB2XgtcNga3Ogl9b+GfPL4ZJIQf7bBqwfEmdI2uOFE9bh0pk8T5?=
 =?us-ascii?Q?mQi+hD1V1WHpSd8Dr6LuiPWW//1CFcBd4gKVkkn3W6w/MPlhtB351KwAtkwV?=
 =?us-ascii?Q?xz6MDEuE/LbUKBeXROfIy9Zo/3O8eW0UXx/ywrab4L5DYROkSYFDAHahgOJl?=
 =?us-ascii?Q?f/o1q/GLduvDWoyYxy7S3Gg//4PuN2k0WCJPgiwr2X3WMjR4FKAVPn9l6/45?=
 =?us-ascii?Q?EEPrshjF64mczxJSSOpUHUXif1efeNvXqbpSWOnLNC2qiKxJyFuIEnq9Y5Al?=
 =?us-ascii?Q?ZW+KYDly6gmKYizfB1hA4YBmYqZTfpYO8v/hle+5AWSQ46BEoU3hTNyckncS?=
 =?us-ascii?Q?DFXI7ySMdeb3WFmKqVcmv4f1n8cU044y7hOH8BA+44bBrz+cARwshzC2YVKK?=
 =?us-ascii?Q?FZE9+Ysu5T7OGOHzH7OqqPhmGSIuM0V8TzdIIYyg9YPgIN3eMXMXFydKHxsT?=
 =?us-ascii?Q?q32Ma5Dm7hkMk8BAxj3w8EhmbeCOoHo22FbphPfYmWM43opS2YmtTaYSnqnq?=
 =?us-ascii?Q?U39DRbHhuVAC2L3L+6ZdBODq+lE0ESsQv0mT5fb0N6VGkhLc2zvVya0PMb28?=
 =?us-ascii?Q?dHNTkN6XBvcgtCU8nRrHWTYP4ZnC+b9AoUCRThpYrHghCkmB1fkR8d6F+Che?=
 =?us-ascii?Q?ELXaILjOWlLAOn9ly5Go4urjfOIDFwu2OpU4VmNATMp8naY3h1lzArlP7AMD?=
 =?us-ascii?Q?v1RI3BptiHMJdqsAFWzU64JOhugoMSq6LhiOZ4nCU7nhve6cFDpLbq7guQYA?=
 =?us-ascii?Q?9OdthiOpcpjPtja0TQ8HhEIohNH55BuEcL/ztRPB8VPZNblGolbMPJw5wi54?=
 =?us-ascii?Q?ZD/eQknXy054XOXt2J+vRNdURLdd2nt7/HLP9IXOhbI31P9quVYVgh3rvTru?=
 =?us-ascii?Q?DHmcvidFePqqjyRvmuQarOvBa1JUg0xdMTidqDv9FS5MS3Ihiq/G7mbxHHYw?=
 =?us-ascii?Q?96ggEVa1X7+CGF10K4UtK5W+VWmWCBZCxJNRPpcadrnubjQBw23YPZ9lW93V?=
 =?us-ascii?Q?u3BZePFGr3wQJKTw9Ku/vwQV9lc5LkefCLICwhQrWgJK1/HerhX7Mj/h6f80?=
 =?us-ascii?Q?t0YO0+/+dcb92dQXkIewgTgv3h19jZx4U5oiNXxvPVmmuD2u3ma19frCOItE?=
 =?us-ascii?Q?hJt5quC9MSsa3UVyCFsTWQtllo2BXdnPTQTBSRRQCJYY66PDpdGyfBZVn+DM?=
 =?us-ascii?Q?jB8bxHLPS5uHiYdhpHdptKqbIxw3Mjm4eJZ8scb1ANZIqullEChQZtEi+ZcL?=
 =?us-ascii?Q?RVdT4QhoyAFMtOPUw8hJJJGxOf2fO+pk8h2Cvai05zkysg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f6d144-af30-44b7-70ca-08d8f9eb956b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:35:49.3611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFwidIMyMuEOxYlKyU1xrm6oQCV3K0JCoajXAE2f1DKaOOFHsxyqloM6kcvueRIq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:

> +struct iidc_res_base {
> +	/* Union for future provision e.g. other res_type */
> +	union {
> +		struct iidc_rdma_qset_params qsets;
> +	} res;

Use an anonymous union?

There is alot of confusiong provisioning for future types, do you have
concrete plans here? I'm a bit confused why this is so different from
how mlx5 ended up when it already has multiple types.

> +};
> +
> +struct iidc_res {
> +	/* Type of resource. */
> +	enum iidc_res_type res_type;
> +	/* Count requested */
> +	u16 cnt_req;
> +
> +	/* Number of resources allocated. Filled in by callee.
> +	 * Based on this value, caller to fill up "resources"
> +	 */
> +	u16 res_allocated;
> +
> +	/* Unique handle to resources allocated. Zero if call fails.
> +	 * Allocated by callee and for now used by caller for internal
> +	 * tracking purpose.
> +	 */
> +	u32 res_handle;
> +
> +	/* Peer driver has to allocate sufficient memory, to accommodate
> +	 * cnt_requested before calling this function.

Calling what function?

> +	 * Memory has to be zero initialized. It is input/output param.
> +	 * As a result of alloc_res API, this structures will be populated.
> +	 */
> +	struct iidc_res_base res[1];

So it is a wrongly defined flex array? Confused

The usages are all using this as some super-complicated function argument:

	struct iidc_res rdma_qset_res = {};

	rdma_qset_res.res_allocated = 1;
	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
	rdma_qset_res.res[0].res.qsets.vport_id = vsi->vsi_idx;
	rdma_qset_res.res[0].res.qsets.teid = tc_node->l2_sched_node_id;
	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;

	if (cdev_info->ops->free_res(cdev_info, &rdma_qset_res))

So the answer here is to make your function calls sane and well
architected. If you have to pass a union to call a function then
something is very wrong with the design.

You aren't trying to achieve ABI decoupling of the rdma/ethernet
modules with an obfuscated complicated function pointer indirection,
are you?

Please use sane function calls 

> +/* Following APIs are implemented by auxiliary drivers and invoked by core PCI
> + * driver
> + */
> +struct iidc_auxiliary_ops {
> +	/* This event_handler is meant to be a blocking call.  For instance,
> +	 * when a BEFORE_MTU_CHANGE event comes in, the event_handler will not
> +	 * return until the auxiliary driver is ready for the MTU change to
> +	 * happen.
> +	 */
> +	void (*event_handler)(struct iidc_core_dev_info *cdev_info,
> +			      struct iidc_event *event);
> +
> +	int (*vc_receive)(struct iidc_core_dev_info *cdev_info, u32 vf_id,
> +			  u8 *msg, u16 len);
> +};

This is not the normal pattern:

> +struct iidc_auxiliary_drv {
> +	struct auxiliary_driver adrv;
> +	struct iidc_auxiliary_ops *ops;
> +};

Just put the two functions above in the drv directly:

struct iidc_auxiliary_drv {
        struct auxilary_driver adrv;
	void (*event_handler)(struct iidc_core_dev_info *cdev_info, *cdev_info,
			      struct iidc_event *event);

	int (*vc_receive)(struct iidc_core_dev_info *cdev_info, u32 vf_id,
			  u8 *msg, u16 len);
}

> +
> +#define IIDC_RDMA_NAME	"intel_rdma"
> +#define IIDC_RDMA_ID	0x00000010
> +#define IIDC_MAX_NUM_AUX	4
> +
> +/* The const struct that instantiates cdev_info_id needs to be initialized
> + * in the .c with the macro ASSIGN_IIDC_INFO.
> + * For example:
> + * static const struct cdev_info_id cdev_info_ids[] = ASSIGN_IIDC_INFO;
> + */
> +struct cdev_info_id {
> +	char *name;
> +	int id;
> +};
> +
> +#define IIDC_RDMA_INFO   { .name = IIDC_RDMA_NAME,  .id = IIDC_RDMA_ID },
> +
> +#define ASSIGN_IIDC_INFO	\
> +{				\
> +	IIDC_RDMA_INFO		\
> +}

I tried to figure out what all this was for and came up short. There
is only one user and all this seems unnecessary in this series, add it
later when you need it.

> +
> +#define iidc_priv(x) ((x)->auxiliary_priv)

Use a static inline function

Jason
