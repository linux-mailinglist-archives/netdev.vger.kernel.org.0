Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37B53570AC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353678AbhDGPoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:44:44 -0400
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:53760
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234273AbhDGPom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:44:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig7YAmoUttFTxb+2+7pQepnpD+zmh6ew851QU/IFTIUxbe/Kij+3qWu3OhsHb8PiaPLzX4QwbfpNyC3DmwZXKGWzrTii9Nm/qDpcog2ZMA1Y3vFi2D//qU16Ql/y+U2wrpAUqiSJnY1dM/yjVd8UAStHmC0Pooh0OVQXoTFYq1Ifevxf57jHml5yFIimRVArhCPcnWqkzsW8KZ/IRrmUzEclzys9oFaKlUTQGIBcb81q7eA4mtSSOk4/skpLzkj22pK+sUpy2pCjfHFZ/W1b0rH80R2nX9bfNom4P/gBMH5zu1F/sN6xbeixVqENgH5VTDr0Sli1GIK6bQwsB88tHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTjyX9rlBqnjw1gpq5BB/It/IlhwIRpjsjhq7iKGwOc=;
 b=acaLJaOvFYrvxV32ma6hA6kPsbLDRVmMZwFsAFKouJMeP9au3q1XoRYpt3wjXGAauNYtpoA44c0JCTR+Bw3vBpEhdWCGnvfKNMwk/T2U/zHpmiRu9SgR3XQ1bkafzhl3l+r7cAqnk6QMgTgJDfsSDC7CNkA3OKBE6Hcg473fgC81+J+lAOg46I5k7HB1JioryMQJG10h5nyo+iFHKuBRO5hejZD4cC2pZDtsoSBVY477YqF3nZzl7vHveTXYWkkzR89ZV14VM5KDlZvXGBU5JIy4X/Ihqf/PLXBZEmVsrmeTjNtPAIZ2phrVpkUZLa704eCSAsSTnOfBnsxQgostqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTjyX9rlBqnjw1gpq5BB/It/IlhwIRpjsjhq7iKGwOc=;
 b=hal7bKKIvqXE/Xc/7rCfbL1EpIZjCK5k/I7vB6hdbsFaLeMeGFWpM/2TcFZVnWyhjXJM20YZ3XuzlckdeuWjjvEPZsSubAASQJTEmhBrqrgt6eaBUh5AW4gMA9wf6M1MdRwsy+5DVUbz27f9SeSGdGwXrJEDLhvfdUuInqs7YgSHEIFYmduOOC2U+Y7+tpkC6r4z3V6j33sxY7Lqx7c+yIbhpXg/R+LRA9F4jaZsLLewnu6YBrM1xL8FeYGU8TEjy6rc5y3hqWgbN0FmYsdct0rl+EyzJO/GoGcRXag1x77bICThIfys4Y3Ytg27NiYhohgnwpLdEiahMIM+M7yQGA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1338.namprd12.prod.outlook.com (2603:10b6:3:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 15:44:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 15:44:32 +0000
Date:   Wed, 7 Apr 2021 12:44:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <20210407154430.GA502757@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406210125.241-2-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:208:256::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0014.namprd13.prod.outlook.com (2603:10b6:208:256::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Wed, 7 Apr 2021 15:44:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUAM2-002E2x-KV; Wed, 07 Apr 2021 12:44:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca850f44-af90-4463-d7f5-08d8f9dc095a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1338:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1338E9CB6C0AC68A9A16FC03C2759@DM5PR12MB1338.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YVhAlg42Miul3PJp+jzV9r89n0kkZt5i0O2SN5FQQzuJSlTh9qifJtLDHohWfUbpXq9bqKR3hpiCvXYsTLTYwu54bUDfTx1T281V6zesjF7wsMe56zvWWj5yduv9uNBsJeQieCQKvRafbNbGg84a1/ns+4Dav3eYzzA7LIUrZlu4D/OkK1AIJufH9VFGHovooNg0lT8RXutso6GTfK88nYLduIvConxoFF7qj9S9rdYNJZ936fulic5+h626cae389dXszlmUYQaqs5hpucDZrI90u4Hdg3ogLlZe5LrSQkgaunNDR2JYDtoxNOoQyj7MYDkB2yVgxTqzp6e/FQ5fapZvyhC77xEVR03hsKmAjacbHJzP7cIctGHNuPfiZp5XCLCPyysBNDMorTsu/h18+W7aVy+rs3+N741p16Kxbd54MOHl219l2miDZ7HBR3HoUROYrIGUYmdNTIuCBL4FQOFIdV3Y8EHv40k/hboanbfLlZDtvyo9uAkZuwMEFyuyrtq49XVgcRyzf6DUrP69hSqmQtuVBj+33OKvwDSKFdFeLg6LMhFz9neo9GXrqk0qV4I5hXD9UoCNh8UH4YfbbOehu9dNv9mcT2u9XZDPGoUsPLUH55S+ipACr22UjUgmjQ5+D1yJlTdE58xKS9ioYEt4PkqFVd7NC7GAOG6Hxx67TRPMxYwwHU7yTb1LfHY9UkEq4IxcmIj2Ss8mLU9Z4rvkyDMQ1x4YJAWIZySFfQAtU1O/xy4B34l5QBebAq0y1PBpmhlWCzr/vgurp2rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(2616005)(66946007)(66556008)(86362001)(36756003)(66476007)(478600001)(966005)(426003)(5660300002)(2906002)(9746002)(9786002)(6916009)(26005)(4326008)(8936002)(38100700001)(33656002)(1076003)(316002)(186003)(83380400001)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IQxFnIhY1ngdvPk8G0oG+QpsqRQg0/FUMGN1FxYsXqj55QzAGyHp4C1+1GQI?=
 =?us-ascii?Q?KPyK84aL0JC+kbI18fSCJDrQglc73yXttW348O/lkY6J9319zG/Z9z4bj7uc?=
 =?us-ascii?Q?HloChKLTswgwoYQA4JZk9ArlBULyz/8f8ajkGY6DrFhF1K2xMw7SOeHEVu8M?=
 =?us-ascii?Q?/Jxvz1nzE93tJKf/uFCC3qcmijM5ngOJ0xXWkTIwrTVrQ2HzoLMGX/gCFFMu?=
 =?us-ascii?Q?irJYeSX+kCrabE/zLtCTWs/uCcbF4MrpA+vAa9KQtTPmnMb9fMQCaQMiSnez?=
 =?us-ascii?Q?DfgiX2KQ1wOgZtcM8KabrtYD2lSztOPsJ3/GivjUOBCy20u/Xo+zfARP/xow?=
 =?us-ascii?Q?tmH1EAhDTQ0VMwFQLBnFGnvqnex5rBag6Az7QQPP3c5DYvUPns461sDeYmO4?=
 =?us-ascii?Q?RcpYl7dj2nLVcy7m5LGITS1A3e5axX2jYECkZ4XkPNNhBKETnkvjqCJ8baxw?=
 =?us-ascii?Q?PTohAAZbs+XX3DO6PiMPyKhIuV6Rq2WiKGZJ5PzCK54Q3YKWPGZnNBjeSIRx?=
 =?us-ascii?Q?+MfLy66y3sFnG71YmP565FQUWkTJiH4V0JbQy8LQ3yC0cpsMrJVLnG4D2OA6?=
 =?us-ascii?Q?Qwt7UiDwInDVJ+i+00PnVV+ePI0h0CLCOTOpxON4cC30ZMbLJzOtpQYsm4m6?=
 =?us-ascii?Q?y1j0asKyMavok1c7d3ktzQJmqZDw/Ag+MJ3fjFdVhCrMCl1RtgGr0VdjS2U4?=
 =?us-ascii?Q?rfxlZO5mtWwwGvD1c+1ZAAaMhHjBBi3lnLtnk9kDGHKvM2Mirv+uaALbgLOn?=
 =?us-ascii?Q?GurcZobSuV2EQIARO56PtP+GODGgSYpggMxcjRopnc+nDit4kaDr3eXxKVi4?=
 =?us-ascii?Q?DRymUEjunfxxL6vvGdJIVuBHwl+ehdqzw/oE6TgXTs5xQzTXlUpHHPVJ1PCi?=
 =?us-ascii?Q?67SYQ/uh8ZcQZ+YMFqrkMM0ECLtuWymx4BhdA0CSR/eDy20LOpRWo7A7H7is?=
 =?us-ascii?Q?RE/O/4aRtexmT+F5sfoM10hK1NB4l/CZdDAJf5ZckWqr5UUju5wkjDDuBz86?=
 =?us-ascii?Q?D+oqViZd/T5Rr6EA7BHuV8ponopvAjHfFA1uqMTlALO9HbMB/mNqzmvjnCP1?=
 =?us-ascii?Q?4zIiC1JrMKPiICGSfH6KF7fcfuygiv3FF9n3lT6ENaAlWx9/nBD2tdSrFO6O?=
 =?us-ascii?Q?BDRDfFUs4UtsCR3YAV/cy0J6qoY0hx+eBbOQd8dbm3SrjO2OlgjmPmVPkMiA?=
 =?us-ascii?Q?k+GKlsNDHzovLw23gWywIvoOK9D3K7zKi8XaAAxODlqSEbKclyJrvY3lX3x9?=
 =?us-ascii?Q?ZVG60HG8SlHJ835B0H6unlN35DHLELmzVN8XDSg7jb0d0R3Vcw0krdkmlz8/?=
 =?us-ascii?Q?rkMVSv3/DBhIPwLpzIEq4giL+meTSBqZ9dT08/UU0HXdmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca850f44-af90-4463-d7f5-08d8f9dc095a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:44:31.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VHH+Avv6Bu3ySjGMaP7sWyzM+EGRuVj+Bd1buE0RlfDuXsCy6oi+g3WyRdvyqyY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1338
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:

> +/* Following APIs are implemented by core PCI driver */
> +struct iidc_core_ops {
> +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> +	 * completion queues, Tx/Rx queues, etc...
> +	 */
> +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> +			 struct iidc_res *res,
> +			 int partial_acceptable);
> +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> +			struct iidc_res *res);
> +
> +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> +			     enum iidc_reset_type reset_type);
> +
> +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> +				   u16 vport_id, bool enable);
> +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
> +		       u16 len);
> +};

What is this? There is only one implementation:

static const struct iidc_core_ops ops = {
	.alloc_res			= ice_cdev_info_alloc_res,
	.free_res			= ice_cdev_info_free_res,
	.request_reset			= ice_cdev_info_request_reset,
	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
	.vc_send			= ice_cdev_info_vc_send,
};

So export and call the functions directly.

We just had this very same discussion with Broadcom.

I notice there is no module dependency between irdma and the ethernet
driver because the above ops are avoiding it.

This entire idea was already NAK'd once:

https://lore.kernel.org/linux-rdma/20180522203831.20624-1-jeffrey.t.kirsher@intel.com/

So please remove it.

Jason
