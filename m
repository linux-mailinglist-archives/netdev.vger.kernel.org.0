Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACF7421605
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhJDSFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:05:04 -0400
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:5852
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236808AbhJDSFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk9OAdnEv8kvZSJTyvuVEE9/ZMPBGZL4cuy7S7iq9so+TKgg9jT9wAlQcmNH5mvsEt5jZtlm2eVhLa4tZtIWrta1j139Aq3TF53Y81MFe6s7oXa3MBoIgVVj9DzkZ0u6uObP3RUcXvZHNSeWC6cUZvmu/IJ+qLSQ49qkVDki1xPqdqQErFMNHENmHugzqv2Gm0hHTAK8lBZ1y7Y5a9AZuqi+3lpVcQQNYwp6FkDXrkhrVKa3kF01OQ0mpIoq8P9IeOGnSP1URE84AjIwUYLYr8iohZYGDb3ilUewOXOu3Q3PGjvjYn4GXQSoT4Ln4H7pMIfnWdRucykc0I6Oc5ICZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljnKGtGY+rVsEn7SxOQthUiTymeX5JxetYLiexS3mPQ=;
 b=JIJkhQSv1ZbVAhZkROYpRrI0bgEOtozoLNHmeJECL35/o6phqaRHbaYVt6cAzrWbd4ZF964yrbQvtpgKNqKJIszjWLnmrIbVZYpjiVujQPbVHcsK7KjbEkI5eFENkkurzPSN3+raylcz0FpUPh8FZSKxsgFQljLbN5owAt8+ymZv9esO2cLG2yZbHOWqKKsUavqr4OlpsUv8m4aa+MzhV2LVChIX/ubf8JZX2dsR9zwncqZISMQ9zg6hzUrbARwEjyLYWLlyfiJLTmX6X63T4mPivbYevlt5wBlxqAmAapYnRGf6h+mrJ8Xy4FdIH/G33XI4ChxHrshcH3YBm+Fv+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljnKGtGY+rVsEn7SxOQthUiTymeX5JxetYLiexS3mPQ=;
 b=SFrhpHIuLUElwJPA+6HdibnRW66gmprD1EZ1EMCu+6j5TuHpahmxsY8ZvoSu+XL2g2kJF6lzhl9cOu4APpbwVcvPt43LaacFe2D50KceDho1kfmRuWxpjmvloxpW5tM/IRxMq7r2FoDNTB6eV47JZ/kHOQs7LfaZv+wYZCh2JZgSFYtL4TGnAgXJizGPFxPczXQ3f5E2dOYVFpIvBnfXwjp86KmkxJZ7ASxGjfZRKs3lOCxJiS7It1DyMj/SoFNTPY7WpSNq3OQyI84WhvUidmM68lXKDF+/anSYJXqLJNW0MI87DyVssg6zlIzycdaQFFPoZk6j3GoaLMAhFPD5XQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Mon, 4 Oct
 2021 18:03:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:03:12 +0000
Date:   Mon, 4 Oct 2021 15:03:11 -0300
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
Subject: Re: [PATCH rdma-next v2 08/13] RDMA/nldev: Allow optional-counter
 status configuration through RDMA netlink
Message-ID: <20211004180311.GD2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
 <7adfe2abf1f5403c54036ca1b0d9478f4e39ed6c.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7adfe2abf1f5403c54036ca1b0d9478f4e39ed6c.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:208:257::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0050.namprd13.prod.outlook.com (2603:10b6:208:257::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Mon, 4 Oct 2021 18:03:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSIx-00AYah-6G; Mon, 04 Oct 2021 15:03:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15da3013-30f2-4c6a-d3e9-08d987613ae0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143C177E1178E2BA76D4A27C2AE9@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydGbRh9nCe5goUp3aOCNvXOHM4m3jwAdYXeaIwwZjp9wNHuv2CBW4vDD1jclm+hifzRvarcQhFs2QkytYotHLHkc2nOzItBAy50tPpvPlIRp5HbTTKBqRsH2Suqbgg6gp6bTrH/iJbUXQgDCrMGFKYOrrQpVbDcSXoWyRca/RlUVXStt4uLWxtSE2BSQkg5YGdJcmQV9N2/o/g12tVOmy+zUDP9eAwOyUCiW8iNg0O9DoeyDE5kdbDJG4fmOLm4vCcFTNweMEDRGEHYgUlG1BXGOaUpvd/ehdrRvi2j6c2NFVMukxR2jEJUQiCYJBPIaTDvXS35KjvCHeTZh1zoTXAKWb/Eg0ztrLe4lFH9yw7mBg5Lb/ChDVX4Tc6I0XOC5PjlaL0RtGWofQVJfUD88Yh2E+EtjeHWmYexGgvtarpOR4greu4zyfoB16uzL7qTEKypn8ckmoqKeEMbbEn1+DtJL7CAf8N8Ou7khFDvT+NXAkljFF7Km328wLnv0aox/gh0EFKLtuYp34KQkiO4JyvkRsJKKVnwo40gIMgtYLkcJFefcpXbwe+85moKPVsQWwcZpsBWxkcawg9khC0CuiJjpqxCc3M7ebnwNjJwYF+uIGP7XzFKb7FzvgW8ohCHdZDr2j3cR4XbAcFshxg2WFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(7416002)(1076003)(186003)(508600001)(54906003)(9786002)(9746002)(8936002)(86362001)(6916009)(316002)(4326008)(38100700002)(66946007)(66476007)(33656002)(66556008)(426003)(36756003)(2906002)(8676002)(5660300002)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cd4Jk6DP60Uaq4Zm0NS0wP9/sDYw0zN6CzUaqD+WNZ6B35R67/BsRN9FMB1g?=
 =?us-ascii?Q?19mex3HOVmAe4OHSW+eXfcyPaE4kCFDu1dt2/6Dcvo8c7D1ghQrq5W1DbSBs?=
 =?us-ascii?Q?Fq73P+ZuGVpudkmyW3OYDcjPZomcX0fnc//4MEt2eWFSuolh9tnv/6PK7N7w?=
 =?us-ascii?Q?P6Km+7oluUkgKob+wAzTVSNYWqs9U5hqFkPWt7tncY7VYvYAUnokjKfVQrbA?=
 =?us-ascii?Q?F96i9+mlc0RnsI2EZm6iazhHk/f5CGRR/priTb9O1QpH+LhFcIOLeFmd5jp3?=
 =?us-ascii?Q?4e8/mEFjHEs87yE5Md8087UKaen7CFVVD5VHSr0xqGTRYOyd7tHY8TofxraC?=
 =?us-ascii?Q?65DT3osfvHWgcbm5QlsiSIdt9nmP9WhHDl37eTVCzqGxfB7ay/zr7Ix7Pu0x?=
 =?us-ascii?Q?3sa+OMedXd+RZGzreNZ3PYETbL+UtPaiQd3sDAEALDUQFv6XuIu9d0Q/vcuM?=
 =?us-ascii?Q?sUjiyn1x+ZdNJC4EAjOFSOYljiBHGr54DWy1sOyQ5aUNfbGOegdFdIXcR9bp?=
 =?us-ascii?Q?laPL243kbiEqF5L3AfZ7SYY+UqCS2Q24H290o37IPazODDHAsLUexchPUtL5?=
 =?us-ascii?Q?ysahAhcEBM24RazbEVoaqD56Pb/RdquuZy8XPN1t4qKP31jghUm3OSE4j8Z1?=
 =?us-ascii?Q?bk5onez0fhWqG2QRlGTvpVx+l1ahN3Lq/69PRCPsBcm7679KpnJreCBsQZEK?=
 =?us-ascii?Q?mAWwzG32SD9pSs1SDhMyD7oR0ca/x4lQK/v8haq4nOpFkbKUX2ZfbP2uwMKU?=
 =?us-ascii?Q?I0QrLILoLEUWd/aIXkjkFTEPwucoNCCfR4ZXnGyner3TOL8uQdpZvEHsfB1z?=
 =?us-ascii?Q?cusujiCzMYRg6JJwmP4KkEXRXMkQVlVoyxQcQPyP3whsPyQnpRs4uUW1m8w5?=
 =?us-ascii?Q?aIby6+K7fR6BoD1iUh+ICjY87rK9+tRmqm03wiiOe9GGjzhHUk7JznyukG5k?=
 =?us-ascii?Q?JY1S4yPnReeGDdnsed/4RbkW+kWaTdpMf6w3gp56VP5SNqnRXiFnEPvkT2/b?=
 =?us-ascii?Q?aNDVo2f6APRcCMEusbGrJKOGw9c1FhTIw53LKRJ6KAp0l0lQt1IaggxuuduV?=
 =?us-ascii?Q?PiaGpXH/qAw1GGzJ12+CJQ/LFNNVWgxIvOLLITo2zIz+l2dCRBIHwVSs2G2X?=
 =?us-ascii?Q?7AuB42XIdAx+o6B8OX+8NtlZ8oJHp9qlgO1FGi7bRcLyzPVg9ptnK6rcN+Rq?=
 =?us-ascii?Q?+mdLovFaSPNsp0WgY+TwUlAv8dvffGzpDTIqgFq2Oo5xwcoaaMuM5Z+IjVAf?=
 =?us-ascii?Q?oYHvp2wSTVYsEIm03xgcuI9s1sYgBXo/DUQtjhmVN+Ars0uaDZpv8PcpE2XC?=
 =?us-ascii?Q?9Tn09gJLSgYU/tp0r9F27eiQY9vUMZAqubR53rYQzsL0rQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15da3013-30f2-4c6a-d3e9-08d987613ae0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 18:03:12.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: docSfwPkfW2Ptj5rtEfv0QeqHWaKUc0bYE6ygoCBJGiiAROb9MjQlY8ERWohjNxq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:24AM +0300, Leon Romanovsky wrote:
> -	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
> -		return -EINVAL;
> +	target = kcalloc(BITS_TO_LONGS(stats->num_counters),
> +		       sizeof(long), GFP_KERNEL);
> +	if (!target)
> +		return -ENOMEM;

Same comment about the type here

This almost wants to be two patches to split up the set_doit then add
the new setter, it is hard to read..

Jason
