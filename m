Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12B4F6CF5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiDFVkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237927AbiDFVir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:38:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545D8FCBC6;
        Wed,  6 Apr 2022 14:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=milaaV2bMvTb8TCtfEf1HHQuEz7Mu6y203lNSFP32ApxKVCCR8j2eXCf4LuwsU/kT5cdZuis9fSJop0UbGaxLTnrlw/5qg/8CIyyQJTFSAmgZ8i7i/8IlrkGJR9YSjWEkqj+0N5MQBpgwxiHEthmr9IY7XPfEDK5pIUjOECaamsrl0qPmxosYko88F/B5j9R1ZtzHCL5C8paZJLJcycCbvnMw7ernS8CKb3GN0ph6p93uOQuLJ4XExuRwX5EegVWIhR8+2RRfr8BVwUVpHzdPzkaVM5yrKqeVjvve7exokRlfa1MwZvfzoQszkLIxNNxMSDmAm6lz7CEXynQAPHkdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPK7rt01u8gto4hyOuyfw3gyHuxzgnySn0lZ8guAPmA=;
 b=jwdWAsqlPzFyHsCdLTDzbCxvFQlZK938q9ZcO2Yb4UmAoPIGdf30bDEW6/TM8WP6UwHkFIMjy1zxWI5W3x+9/bkjFsC/1cbgfnNOKlo7kx5lQHkQQpuVsJ4UQE9uVLG0Tw5IZ0v/SiGHskEbsUso1D7yj/SOTn5mVLicCgMND3EvnJwapMBMbGyf+ELusPa4HHsC4ohu2eRksoEx78Mns+AF3JxfXQ9CdyRGIJysgYA/wRoQlZoY3YEAg3lBe3Rv7GgM00Zy9v4F4OhiVkV8okNBd4RV3qVDrRCMfAlrJdYkBeYwm1TLVXTWAIyxsqSVvp8u9RKYh4vVNpW/mNnigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPK7rt01u8gto4hyOuyfw3gyHuxzgnySn0lZ8guAPmA=;
 b=eanBvRLj6Ha2uZ3LJoyWmDsZ8hz+CNymkqgvBfGIyQdczAAugSf7q2Hb3xPdndWr2AmLrTWKG3NvpFl7xRpcAHtZpLHwSAfkbYzIG4umOMWxTBfN11XuOq4gwt90zpZeZi1sjaAlwsmccq1C6E6BipKBJ+Mf0w2Y1Pxzpm3y6/M07aJfQl3xvF4OU5IrrSPHPj+oZ0OWIcST1Aj19koejmxHt8/+ZroE3CmUJJSuc42PKyLrNT32etS9Ese/32v9P55l0msNVgzTuO7WQdK6IrAdlIhT/JwlflVQv0yJUvwT+PGX62Xmi7hSvSai5Onc31YcreVhJ3J4rlFo96RI/A==
Received: from CH2PR12MB4197.namprd12.prod.outlook.com (2603:10b6:610:ab::9)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 21:01:59 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by CH2PR12MB4197.namprd12.prod.outlook.com (2603:10b6:610:ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 21:01:57 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::313b:8981:d79a:52d0]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::313b:8981:d79a:52d0%5]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 21:01:57 +0000
Message-ID: <810e22f7-a48c-dd65-5665-8db757f3ae29@nvidia.com>
Date:   Thu, 7 Apr 2022 00:01:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from uverbs
 device caps
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Ariel Elior <aelior@marvell.com>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::23) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81d5bbb2-8b06-43f7-0a19-08da1810afc5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4197:EE_|DM4PR12MB5182:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB41977D3D41CEC906A9A4FAB9DEE79@CH2PR12MB4197.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VY/Bq2aIvVM5/xsqTyqoIYrrxhqXuns5iiwxB6JIYotrdukwxes/1apTckHqqtb+YiX7p21HIbs2YkHGi95brX5F8xPdnVtTMmVc/Wv8QIPOY2N4JL/5Qxf5C/p74bhRC1uBTOeCNDWqxtC4gmixt50dEaf+Lzx3rcyqc0Wb1jaNh8bpGGHTCDWrhTJmZia+APMxPWmwkwSGQaXiyl0qTpfzHo48Zp7Atws+ayNrpnu1ytAWQkeHphGCnLbfS8RwefulFs8qqiTVxE2QbjEIoVuXbN8kM4OO046sd7FeUZvUU2Rkg65NPIv/XHIyUN1OcSNl0n7Z08/fjcCzgRdaxpH77jZE8q0Yu6LZqDT+DHMIfii1izFZi6u6AN123GpubT65J32mGMheYt4+0ZRRyy+ntnN+ntC9Wcp1XbvI0bCgQp59KCoreV3LB6y47tJhaP2UU5mEI/xm1X4lsN8Y0dF51azSm2M3Bc8ksVqOsBwm196mxdC4OAqEBS8qCA6RbgnmO8ehO4DkmKiHvCYRz0Sd5uuyE1L5eQpfQzjdezMRbmhmvFY+etr1XSF0bhs++46SOuouoGawhSbbtJfsilt7kZnUMM/3WvjNDSNIA3jCHRMk6HZqKGelZcesxsobnYsPwOHK9IngV5yEoNVrSVFU9uOJBOVbFgd13gV2jtjo2ZWNL8roc5uIFpkISSMB8RPB2Drb7ucam6aka+Bc+YJ8czez5OxHQQ6SWvtlRFpnUgIBK3dPktuyitO1qJfuCmr1ZLK8oZN8lx18udNadw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4197.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(186003)(2616005)(5660300002)(2906002)(110136005)(316002)(921005)(26005)(30864003)(6512007)(8676002)(36756003)(53546011)(66476007)(6666004)(508600001)(31686004)(66946007)(7416002)(7406005)(6506007)(8936002)(31696002)(86362001)(83380400001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG9vOGRBMnd1dmZqdkszaWpwRGNGZ3QwQnJROEdSSE55azFJU1cxb2pRVDMz?=
 =?utf-8?B?a1U3STRKdzVyakx5RFhzdFBwSmJWWFA5RGJRZmVsUGFpNjNNamlTYjRMaDdY?=
 =?utf-8?B?RkNmRXlsU2tnWjBZZnlEY2xHS2VyemtOS3ZadzFyVVZrSk5wWW1kUjhBTGZ0?=
 =?utf-8?B?YmUzNzFXRmdBaTJhbE1HTXc5a2NxeHpSaHM4QUtMQzRsazMvdEZqdHZaSkRT?=
 =?utf-8?B?VnVJMnJNTWFoRjhoSEk2amhYek1Ea0d6eUJyb1lUcHF4eHVGNmJFL0UrV2pZ?=
 =?utf-8?B?NnNwR0JIMWNOMHpqblMvQko1eWlEd2ZyenZkU0wyWU5rcjg5WmNPbFZjb2xp?=
 =?utf-8?B?dUhzUEg0YjR6em1aN0V5MGR0NmdzZTRiRUlOSzUyZ0s4N2xxRkcxNmwvM1k3?=
 =?utf-8?B?VlduTEZBYVZjbnFpb2s4cnB2VWduNGpTY0xoZGpWaXg1WXJsNmlsNmo5VTNv?=
 =?utf-8?B?Rm1KQzR1YUh0Ky90VWlTVzRJSzU1bEkwNXAzQWRrR3Z5ckhuZEZyWGRjMjk1?=
 =?utf-8?B?WnZ1WHNIdUdXT0VnSFNUSkVPTkxZb2cwbzNybVpValRJcUVYbzR5UnhJVVFv?=
 =?utf-8?B?QXBVSXhmSHRqOEJkVWtPOXNSQ3B6Vm8vdDQxSVk2LzRocVZoU3AzSUg3VlhV?=
 =?utf-8?B?UkIrVTBCQ3N5MjZjeHBpdzlHVFBpUStZQm5XM3ljdUpDVWl6d2ZTSkRmckRP?=
 =?utf-8?B?QzVyRTBuZDRLVGlmM1BBaGp3UVRMTDhXclNrYmxoc1JBaFNJZitJaWZncUQ0?=
 =?utf-8?B?NHAvQS9wQWJISnBZdlp5VTF6OHQ5WmFCV2x0RW90R1RabTUyZ3BDSFN2clFr?=
 =?utf-8?B?dGppdDFqdWFzZWpNbW5JUG95REUyTlI1cW5sUm9GL0NIQUcwTVkvMTN3dG5Y?=
 =?utf-8?B?dGRpRGxrc2pocE9KUFpCZ3lDOC9FU2t5Tk5FQTNnak14d2swWFlpVFNFbGIv?=
 =?utf-8?B?Q1dzc1k3U1ZnRzNmOWVvNU9ZWkVYZTVydlN4dnhzdUZQQXE4ejZsOExveWFT?=
 =?utf-8?B?aHBYM1c5Q0NnNkdGZStKdndNZzVZbVVhRm1QcXN2YVJIdnNMSUZjYll5M29D?=
 =?utf-8?B?N25pcVFZa21zWnlkNkFqQ2RTMU9pbHBpU1h0T0lMVlM2QWFWckJNNXo5TTlZ?=
 =?utf-8?B?SFBkMDJyZ0hUY2ZMWENOb0VJYUNQVnNseWluaTN6bEY3Q3pvbXRKYWR6QVk1?=
 =?utf-8?B?bXhkb3N4cFhWVFY1dnpLdEs4eENNUzdvL08zVnBpSWw4RUM0OXRUZUVMZmFt?=
 =?utf-8?B?azJGY3JuamV6NUMrbUtKREVuWUx3cnE0c21CNEF1RTFtd21pODlWN29ZK3Ni?=
 =?utf-8?B?TnRzNjRGbm1YTzlQSnZsSmNnQ0VNK3VHbmV2NXZvWVppUmhlZUZlNGoxelkz?=
 =?utf-8?B?TTR2MXlnR3ZRWURVdFVuRDdaQWUwYk9SM3JRY2M2ZjJCYXZHTklOMlZQblR0?=
 =?utf-8?B?TlpqREZ2eGpPK1M3c3c2YndVbndYRWF2dEtzanRzVTEyM2cvZzNtakRuTVlz?=
 =?utf-8?B?cVYwbFhsN3pNWWVmZFRmK0IxZXgrTDQyREtRQWIzQ3luV0szVTRWbHRhQlRs?=
 =?utf-8?B?eTJMeExLSEYwUGh6YWZkVzVLc2JtNUE1V1BHQVdyeFRDeEo3ZytoRWV1TDNX?=
 =?utf-8?B?NWZ5dWx3dUprdzNLSENuSGVQNVNGN0ZpMnRKcEh5d1lqdzduMGg4WEFZTm5z?=
 =?utf-8?B?TTVicnp2ZGNMSDY3emcyUUppVm93SXB0WTJqWG9xbWpnTHBkYlB4UFhuMm14?=
 =?utf-8?B?cXFzcmdxVWhwWHU3UWk2SGpOWldMaG5lM0pFaW1UZDQzUzBuZzlnUncrR2Mr?=
 =?utf-8?B?SEFiT0tISnloZ1VjeHFSZWtRMFdyaEFQb25NRWxzdEhRMzdiMmNpNlZZemxi?=
 =?utf-8?B?dmU1cWdxM2k3M095KzdmMEphQzBsemN3VVhHTXYwMXNWRWJLMWd3bU9oWkdV?=
 =?utf-8?B?VTFWeXQrK2sxZWRyeFIzZThtWktVTDBzOWpyeVR5YU1tU0ZuQ2ZGYkRtVU9w?=
 =?utf-8?B?ZUpnS0Z3V000UmpHemtKc2ZGRzdyQVZXSi9RVDFrRi9Yb2ZaMVZEYVY3cVdH?=
 =?utf-8?B?c3FMcXRjL2ZTMXY3YUQ2cENXT3ltd1JoMzRBSnJpUmh2dFlnSjhCbTFsUFdE?=
 =?utf-8?B?NS90Q0FGRldTT1pRbkNndE9NTG1pdDhoL202VmgxWHQvTm5PUzNsTW1RdW91?=
 =?utf-8?B?REhEanFhcC96TmQxRXhHOU5hVG1sdlRscWhwZnNiUDVaSU5HV0NmeCtYbG1u?=
 =?utf-8?B?M2lWWThXd2tERDg3bGZsQk1GQzhnaUl0TnVmc1hEcU5xaFdueU82YUJ4dkNZ?=
 =?utf-8?B?SC80SDFaWEN2YmNRMHdNRGZoa29yVU0xamliY0MxMGpyNnE5eG1DTUVLdUI3?=
 =?utf-8?Q?JqhL4NKPYaInPjVA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d5bbb2-8b06-43f7-0a19-08da1810afc5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 21:01:57.7711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vvlaLI5zMJioJkZKOvKqIajA93ovLg+qNNrVTaCAZ70qDQKrS8HFS147Le7ZdZks+VlLNDbu55th+FGqhobuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/6/2022 10:27 PM, Jason Gunthorpe wrote:
> Split out flags from ib_device::device_cap_flags that are only used
> internally to the kernel into kernel_cap_flags that is not part of the
> uapi. This limits the device_cap_flags to being only flags exposed by the
> driver toward userspace.
>
> This cleanly splits out the uverbs flags from the kernel flags to avoid
> confusion in the flags bitmap.
>
> Add some short comments describing which each of the kernel flags is
> connected to. Remove unused kernel flags.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/infiniband/core/nldev.c              |  2 +-
>   drivers/infiniband/core/uverbs_cmd.c         |  6 +-
>   drivers/infiniband/core/verbs.c              |  8 +-
>   drivers/infiniband/hw/bnxt_re/ib_verbs.c     |  2 +-
>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  1 -
>   drivers/infiniband/hw/cxgb4/provider.c       |  8 +-
>   drivers/infiniband/hw/hfi1/verbs.c           |  4 +-
>   drivers/infiniband/hw/irdma/hw.c             |  4 -
>   drivers/infiniband/hw/irdma/main.h           |  1 -
>   drivers/infiniband/hw/irdma/verbs.c          |  4 +-
>   drivers/infiniband/hw/mlx4/main.c            |  8 +-
>   drivers/infiniband/hw/mlx5/main.c            | 15 ++--
>   drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
>   drivers/infiniband/hw/qedr/verbs.c           |  3 +-
>   drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 +-
>   drivers/infiniband/sw/rxe/rxe.c              |  1 +
>   drivers/infiniband/sw/rxe/rxe_param.h        |  1 -
>   drivers/infiniband/sw/siw/siw_verbs.c        |  4 +-
>   drivers/infiniband/ulp/ipoib/ipoib.h         |  1 +
>   drivers/infiniband/ulp/ipoib/ipoib_main.c    |  5 +-
>   drivers/infiniband/ulp/ipoib/ipoib_verbs.c   |  6 +-
>   drivers/infiniband/ulp/iser/iscsi_iser.c     |  2 +-
>   drivers/infiniband/ulp/iser/iser_verbs.c     |  8 +-
>   drivers/infiniband/ulp/isert/ib_isert.c      |  2 +-
>   drivers/infiniband/ulp/srp/ib_srp.c          |  8 +-
>   drivers/nvme/host/rdma.c                     |  4 +-
>   drivers/nvme/target/rdma.c                   |  4 +-
>   fs/cifs/smbdirect.c                          |  2 +-
>   include/rdma/ib_verbs.h                      | 84 ++++++++------------
>   include/rdma/opa_vnic.h                      |  3 +-
>   include/uapi/rdma/ib_user_verbs.h            |  4 +
>   net/rds/ib.c                                 |  4 +-
>   net/sunrpc/xprtrdma/frwr_ops.c               |  2 +-
>   33 files changed, 100 insertions(+), 116 deletions(-)
>
> v2:
>   - Use IBK_ as the flag prefix for brevity
>   - Remove unneeded ULLs
>   - Spelling
>   - Short documentation for each of the kernel flags
>
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index ca24ce34da7661..b92358f606d007 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -1739,7 +1739,7 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	if (!device)
>   		return -EINVAL;
>   
> -	if (!(device->attrs.device_cap_flags & IB_DEVICE_ALLOW_USER_UNREG)) {
> +	if (!(device->attrs.kernel_cap_flags & IBK_ALLOW_USER_UNREG)) {
>   		ib_device_put(device);
>   		return -EINVAL;
>   	}
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index a1978a6f8e0c28..046376bd68e27d 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -337,8 +337,7 @@ static void copy_query_dev_fields(struct ib_ucontext *ucontext,
>   	resp->hw_ver		= attr->hw_ver;
>   	resp->max_qp		= attr->max_qp;
>   	resp->max_qp_wr		= attr->max_qp_wr;
> -	resp->device_cap_flags	= lower_32_bits(attr->device_cap_flags &
> -		IB_UVERBS_DEVICE_CAP_FLAGS_MASK);
> +	resp->device_cap_flags  = lower_32_bits(attr->device_cap_flags);
>   	resp->max_sge		= min(attr->max_send_sge, attr->max_recv_sge);
>   	resp->max_sge_rd	= attr->max_sge_rd;
>   	resp->max_cq		= attr->max_cq;
> @@ -3619,8 +3618,7 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
>   
>   	resp.timestamp_mask = attr.timestamp_mask;
>   	resp.hca_core_clock = attr.hca_core_clock;
> -	resp.device_cap_flags_ex = attr.device_cap_flags &
> -		IB_UVERBS_DEVICE_CAP_FLAGS_MASK;
> +	resp.device_cap_flags_ex = attr.device_cap_flags;
>   	resp.rss_caps.supported_qpts = attr.rss_caps.supported_qpts;
>   	resp.rss_caps.max_rwq_indirection_tables =
>   		attr.rss_caps.max_rwq_indirection_tables;
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index a9819c40a14067..e54b3f1b730e00 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -281,7 +281,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
>   	}
>   	rdma_restrack_add(&pd->res);
>   
> -	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
> +	if (device->attrs.kernel_cap_flags & IBK_LOCAL_DMA_LKEY)
>   		pd->local_dma_lkey = device->local_dma_lkey;
>   	else
>   		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
> @@ -308,7 +308,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
>   
>   		pd->__internal_mr = mr;
>   
> -		if (!(device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY))
> +		if (!(device->attrs.kernel_cap_flags & IBK_LOCAL_DMA_LKEY))
>   			pd->local_dma_lkey = pd->__internal_mr->lkey;
>   
>   		if (flags & IB_PD_UNSAFE_GLOBAL_RKEY)
> @@ -2131,8 +2131,8 @@ struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>   	struct ib_mr *mr;
>   
>   	if (access_flags & IB_ACCESS_ON_DEMAND) {
> -		if (!(pd->device->attrs.device_cap_flags &
> -		      IB_DEVICE_ON_DEMAND_PAGING)) {
> +		if (!(pd->device->attrs.kernel_cap_flags &
> +		      IBK_ON_DEMAND_PAGING)) {
>   			pr_debug("ODP support not available\n");
>   			return ERR_PTR(-EINVAL);
>   		}
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 3224f18a66e575..989edc78963381 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -146,13 +146,13 @@ int bnxt_re_query_device(struct ib_device *ibdev,
>   				    | IB_DEVICE_RC_RNR_NAK_GEN
>   				    | IB_DEVICE_SHUTDOWN_PORT
>   				    | IB_DEVICE_SYS_IMAGE_GUID
> -				    | IB_DEVICE_LOCAL_DMA_LKEY
>   				    | IB_DEVICE_RESIZE_MAX_WR
>   				    | IB_DEVICE_PORT_ACTIVE_EVENT
>   				    | IB_DEVICE_N_NOTIFY_CQ
>   				    | IB_DEVICE_MEM_WINDOW
>   				    | IB_DEVICE_MEM_WINDOW_TYPE_2B
>   				    | IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	ib_attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
>   	ib_attr->max_send_sge = dev_attr->max_qp_sges;
>   	ib_attr->max_recv_sge = dev_attr->max_qp_sges;
>   	ib_attr->max_sge_rd = dev_attr->max_qp_sges;
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 12f33467c6728f..50cb2259bf8743 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -314,7 +314,6 @@ enum db_state {
>   struct c4iw_dev {
>   	struct ib_device ibdev;
>   	struct c4iw_rdev rdev;
> -	u32 device_cap_flags;
>   	struct xarray cqs;
>   	struct xarray qps;
>   	struct xarray mrs;
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
> index 89f36a3a9af00d..246b739ddb2b21 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -269,7 +269,10 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
>   			    dev->rdev.lldi.ports[0]->dev_addr);
>   	props->hw_ver = CHELSIO_CHIP_RELEASE(dev->rdev.lldi.adapter_type);
>   	props->fw_ver = dev->rdev.lldi.fw_vers;
> -	props->device_cap_flags = dev->device_cap_flags;
> +	props->device_cap_flags = IB_DEVICE_MEM_WINDOW;
> +	props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
> +	if (fastreg_support)
> +		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
>   	props->page_size_cap = T4_PAGESIZE_MASK;
>   	props->vendor_id = (u32)dev->rdev.lldi.pdev->vendor;
>   	props->vendor_part_id = (u32)dev->rdev.lldi.pdev->device;
> @@ -529,9 +532,6 @@ void c4iw_register_device(struct work_struct *work)
>   	pr_debug("c4iw_dev %p\n", dev);
>   	addrconf_addr_eui48((u8 *)&dev->ibdev.node_guid,
>   			    dev->rdev.lldi.ports[0]->dev_addr);
> -	dev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_WINDOW;
> -	if (fastreg_support)
> -		dev->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
>   	dev->ibdev.local_dma_lkey = 0;
>   	dev->ibdev.node_type = RDMA_NODE_RNIC;
>   	BUILD_BUG_ON(sizeof(C4IW_NODE_DESC) > IB_DEVICE_NODE_DESC_MAX);
> diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
> index 99d0743133cac7..6988f6f21bdebb 100644
> --- a/drivers/infiniband/hw/hfi1/verbs.c
> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> @@ -1300,8 +1300,8 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
>   			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
>   			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
>   			IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE |
> -			IB_DEVICE_MEM_MGT_EXTENSIONS |
> -			IB_DEVICE_RDMA_NETDEV_OPA;
> +			IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	rdi->dparms.props.kernel_cap_flags = IBK_RDMA_NETDEV_OPA;
>   	rdi->dparms.props.page_size_cap = PAGE_SIZE;
>   	rdi->dparms.props.vendor_id = dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
>   	rdi->dparms.props.vendor_part_id = dd->pcidev->device;
> diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
> index 3dc9b5801da153..ec477c4474cf51 100644
> --- a/drivers/infiniband/hw/irdma/hw.c
> +++ b/drivers/infiniband/hw/irdma/hw.c
> @@ -1827,10 +1827,6 @@ int irdma_rt_init_hw(struct irdma_device *iwdev,
>   			rf->rsrc_created = true;
>   		}
>   
> -		iwdev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY |
> -					  IB_DEVICE_MEM_WINDOW |
> -					  IB_DEVICE_MEM_MGT_EXTENSIONS;
> -
>   		if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
>   			irdma_alloc_set_mac(iwdev);
>   		irdma_add_ip(iwdev);
> diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
> index 5123f5feaa2fcb..ef862bced20f31 100644
> --- a/drivers/infiniband/hw/irdma/main.h
> +++ b/drivers/infiniband/hw/irdma/main.h
> @@ -338,7 +338,6 @@ struct irdma_device {
>   	u32 roce_ackcreds;
>   	u32 vendor_id;
>   	u32 vendor_part_id;
> -	u32 device_cap_flags;
>   	u32 push_mode;
>   	u32 rcv_wnd;
>   	u16 mac_ip_table_idx;
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
> index 46f475394af5f5..f70ddf9b45bf9a 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -25,7 +25,9 @@ static int irdma_query_device(struct ib_device *ibdev,
>   			    iwdev->netdev->dev_addr);
>   	props->fw_ver = (u64)irdma_fw_major_ver(&rf->sc_dev) << 32 |
>   			irdma_fw_minor_ver(&rf->sc_dev);
> -	props->device_cap_flags = iwdev->device_cap_flags;
> +	props->device_cap_flags = IB_DEVICE_MEM_WINDOW |
> +				  IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
>   	props->vendor_id = pcidev->vendor;
>   	props->vendor_part_id = pcidev->device;
>   
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 93b1650eacfab0..c448168375db12 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -479,8 +479,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>   	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
>   		IB_DEVICE_PORT_ACTIVE_EVENT		|
>   		IB_DEVICE_SYS_IMAGE_GUID		|
> -		IB_DEVICE_RC_RNR_NAK_GEN		|
> -		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> +		IB_DEVICE_RC_RNR_NAK_GEN;
> +	props->kernel_cap_flags = IBK_BLOCK_MULTICAST_LOOPBACK;
>   	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR)
>   		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
>   	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
> @@ -494,9 +494,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>   	if (dev->dev->caps.max_gso_sz &&
>   	    (dev->dev->rev_id != MLX4_IB_CARD_REV_A0) &&
>   	    (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH))
> -		props->device_cap_flags |= IB_DEVICE_UD_TSO;
> +		props->kernel_cap_flags |= IBK_UD_TSO;
>   	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
> -		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
> +		props->kernel_cap_flags |= IBK_LOCAL_DMA_LKEY;
>   	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
>   	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
>   	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 32a0ea82057342..203950b4eec85e 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -855,13 +855,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
>   		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
>   		/* We support 'Gappy' memory registration too */
> -		props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
> +		props->kernel_cap_flags |= IBK_SG_GAPS_REG;
>   	}
>   	/* IB_WR_REG_MR always requires changing the entity size with UMR */
>   	if (!MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
>   		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
>   	if (MLX5_CAP_GEN(mdev, sho)) {
> -		props->device_cap_flags |= IB_DEVICE_INTEGRITY_HANDOVER;
> +		props->kernel_cap_flags |= IBK_INTEGRITY_HANDOVER;
>   		/* At this stage no support for signature handover */
>   		props->sig_prot_cap = IB_PROT_T10DIF_TYPE_1 |
>   				      IB_PROT_T10DIF_TYPE_2 |
> @@ -870,7 +870,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   				       IB_GUARD_T10DIF_CSUM;
>   	}
>   	if (MLX5_CAP_GEN(mdev, block_lb_mc))
> -		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> +		props->kernel_cap_flags |= IBK_BLOCK_MULTICAST_LOOPBACK;
>   
>   	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) && raw_support) {
>   		if (MLX5_CAP_ETH(mdev, csum_cap)) {
> @@ -921,7 +921,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   
>   	if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
>   		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
> -		props->device_cap_flags |= IB_DEVICE_UD_TSO;
> +		props->kernel_cap_flags |= IBK_UD_TSO;
>   	}
>   
>   	if (MLX5_CAP_GEN(dev->mdev, rq_delay_drop) &&
> @@ -997,7 +997,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   
>   	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
>   		if (dev->odp_caps.general_caps & IB_ODP_SUPPORT)
> -			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
> +			props->kernel_cap_flags |= IBK_ON_DEMAND_PAGING;
>   		props->odp_caps = dev->odp_caps;
>   		if (!uhw) {
>   			/* ODP for kernel QPs is not implemented for receive
> @@ -1018,11 +1018,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   		}
>   	}
>   
> -	if (MLX5_CAP_GEN(mdev, cd))
> -		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
> -
>   	if (mlx5_core_is_vf(mdev))
> -		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
> +		props->kernel_cap_flags |= IBK_VIRTUAL_FUNCTION;
>   
>   	if (mlx5_ib_port_link_layer(ibdev, 1) ==
>   	    IB_LINK_LAYER_ETHERNET && raw_support) {
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index acf9970ec245fa..dd4021b1196300 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -90,8 +90,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
>   					IB_DEVICE_RC_RNR_NAK_GEN |
>   					IB_DEVICE_SHUTDOWN_PORT |
>   					IB_DEVICE_SYS_IMAGE_GUID |
> -					IB_DEVICE_LOCAL_DMA_LKEY |
>   					IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
>   	attr->max_send_sge = dev->attr.max_send_sge;
>   	attr->max_recv_sge = dev->attr.max_recv_sge;
>   	attr->max_sge_rd = dev->attr.max_rdma_sge;
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index a53476653b0d9b..f0f43b6db89ee9 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -134,7 +134,8 @@ int qedr_query_device(struct ib_device *ibdev,
>   	attr->max_qp_wr = max_t(u32, qattr->max_sqe, qattr->max_rqe);
>   	attr->device_cap_flags = IB_DEVICE_CURR_QP_STATE_MOD |
>   	    IB_DEVICE_RC_RNR_NAK_GEN |
> -	    IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	    IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
>   
>   	if (!rdma_protocol_iwarp(&dev->ibdev, 1))
>   		attr->device_cap_flags |= IB_DEVICE_XRC;
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index d3a9670bf9719a..71fa7dc3cc6acc 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -305,7 +305,8 @@ int usnic_ib_query_device(struct ib_device *ibdev,
>   	props->max_qp = qp_per_vf *
>   		kref_read(&us_ibdev->vf_cnt);
>   	props->device_cap_flags = IB_DEVICE_PORT_ACTIVE_EVENT |
> -		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
> +		IB_DEVICE_SYS_IMAGE_GUID;
> +	props->kernel_cap_flags = IBK_BLOCK_MULTICAST_LOOPBACK;
>   	props->max_cq = us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ] *
>   		kref_read(&us_ibdev->vf_cnt);
>   	props->max_pd = USNIC_UIOM_MAX_PD_CNT;
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index 2dae7538a2ea95..51daac5c4feb75 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -46,6 +46,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
>   	rxe->attr.max_qp			= RXE_MAX_QP;
>   	rxe->attr.max_qp_wr			= RXE_MAX_QP_WR;
>   	rxe->attr.device_cap_flags		= RXE_DEVICE_CAP_FLAGS;
> +	rxe->attr.kernel_cap_flags		= IBK_ALLOW_USER_UNREG;
>   	rxe->attr.max_send_sge			= RXE_MAX_SGE;
>   	rxe->attr.max_recv_sge			= RXE_MAX_SGE;
>   	rxe->attr.max_sge_rd			= RXE_MAX_SGE_RD;
> diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
> index 918270e34a35cf..a717125f8cf5a5 100644
> --- a/drivers/infiniband/sw/rxe/rxe_param.h
> +++ b/drivers/infiniband/sw/rxe/rxe_param.h
> @@ -50,7 +50,6 @@ enum rxe_device_param {
>   					| IB_DEVICE_RC_RNR_NAK_GEN
>   					| IB_DEVICE_SRQ_RESIZE
>   					| IB_DEVICE_MEM_MGT_EXTENSIONS
> -					| IB_DEVICE_ALLOW_USER_UNREG
>   					| IB_DEVICE_MEM_WINDOW
>   					| IB_DEVICE_MEM_WINDOW_TYPE_2A
>   					| IB_DEVICE_MEM_WINDOW_TYPE_2B,
> diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
> index 54ef367b074aba..09316072b7890e 100644
> --- a/drivers/infiniband/sw/siw/siw_verbs.c
> +++ b/drivers/infiniband/sw/siw/siw_verbs.c
> @@ -132,8 +132,8 @@ int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
>   
>   	/* Revisit atomic caps if RFC 7306 gets supported */
>   	attr->atomic_cap = 0;
> -	attr->device_cap_flags =
> -		IB_DEVICE_MEM_MGT_EXTENSIONS | IB_DEVICE_ALLOW_USER_UNREG;
> +	attr->device_cap_flags = IB_DEVICE_MEM_MGT_EXTENSIONS;
> +	attr->kernel_cap_flags = IBK_ALLOW_USER_UNREG;
>   	attr->max_cq = sdev->attrs.max_cq;
>   	attr->max_cqe = sdev->attrs.max_cqe;
>   	attr->max_fast_reg_page_list_len = SIW_MAX_SGE_PBL;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 44d8d151ff9041..35e9c8a330e257 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -411,6 +411,7 @@ struct ipoib_dev_priv {
>   	struct dentry *path_dentry;
>   #endif
>   	u64	hca_caps;
> +	u64	kernel_caps;
>   	struct ipoib_ethtool_st ethtool;
>   	unsigned int max_send_sge;
>   	const struct net_device_ops	*rn_ops;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 9934b8bd7f56cf..2a8961b685c2da 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1850,11 +1850,12 @@ static void ipoib_parent_unregister_pre(struct net_device *ndev)
>   static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
>   {
>   	priv->hca_caps = priv->ca->attrs.device_cap_flags;
> +	priv->kernel_caps = priv->ca->attrs.kernel_cap_flags;
>   
>   	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
>   		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
>   
> -		if (priv->hca_caps & IB_DEVICE_UD_TSO)
> +		if (priv->kernel_caps & IBK_UD_TSO)
>   			priv->dev->hw_features |= NETIF_F_TSO;
>   
>   		priv->dev->features |= priv->dev->hw_features;
> @@ -2201,7 +2202,7 @@ int ipoib_intf_init(struct ib_device *hca, u32 port, const char *name,
>   
>   	priv->rn_ops = dev->netdev_ops;
>   
> -	if (hca->attrs.device_cap_flags & IB_DEVICE_VIRTUAL_FUNCTION)
> +	if (hca->attrs.kernel_cap_flags & IBK_VIRTUAL_FUNCTION)
>   		dev->netdev_ops	= &ipoib_netdev_ops_vf;
>   	else
>   		dev->netdev_ops	= &ipoib_netdev_ops_pf;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> index 5a150a080ac217..368e5d77416de9 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -197,16 +197,16 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
>   	init_attr.send_cq = priv->send_cq;
>   	init_attr.recv_cq = priv->recv_cq;
>   
> -	if (priv->hca_caps & IB_DEVICE_UD_TSO)
> +	if (priv->kernel_caps & IBK_UD_TSO)
>   		init_attr.create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
>   
> -	if (priv->hca_caps & IB_DEVICE_BLOCK_MULTICAST_LOOPBACK)
> +	if (priv->kernel_caps & IBK_BLOCK_MULTICAST_LOOPBACK)
>   		init_attr.create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
>   
>   	if (priv->hca_caps & IB_DEVICE_MANAGED_FLOW_STEERING)
>   		init_attr.create_flags |= IB_QP_CREATE_NETIF_QP;
>   
> -	if (priv->hca_caps & IB_DEVICE_RDMA_NETDEV_OPA)
> +	if (priv->kernel_caps & IBK_RDMA_NETDEV_OPA)
>   		init_attr.create_flags |= IB_QP_CREATE_NETDEV_USE;
>   
>   	priv->qp = ib_create_qp(priv->pd, &init_attr);
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index f8d0bab4424cf3..321949a570ed6f 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -650,7 +650,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   						   SHOST_DIX_GUARD_CRC);
>   		}
>   
> -		if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
> +		if (!(ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
>   			shost->virt_boundary_mask = SZ_4K - 1;
>   
>   		if (iscsi_host_add(shost, ib_dev->dev.parent)) {
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 5dbad68c739032..c08f2d9133b69b 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -115,7 +115,7 @@ iser_create_fastreg_desc(struct iser_device *device,
>   	if (!desc)
>   		return ERR_PTR(-ENOMEM);
>   
> -	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +	if (ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
>   		mr_type = IB_MR_TYPE_SG_GAPS;
>   	else
>   		mr_type = IB_MR_TYPE_MEM_REG;
> @@ -517,7 +517,7 @@ static void iser_calc_scsi_params(struct iser_conn *iser_conn,
>   	 * (head and tail) for a single page worth data, so one additional
>   	 * entry is required.
>   	 */
> -	if (attr->device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +	if (attr->kernel_cap_flags & IBK_SG_GAPS_REG)
>   		reserved_mr_pages = 0;
>   	else
>   		reserved_mr_pages = 1;
> @@ -562,8 +562,8 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
>   
>   	/* connection T10-PI support */
>   	if (iser_pi_enable) {
> -		if (!(device->ib_device->attrs.device_cap_flags &
> -		      IB_DEVICE_INTEGRITY_HANDOVER)) {
> +		if (!(device->ib_device->attrs.kernel_cap_flags &
> +		      IBK_INTEGRITY_HANDOVER)) {
>   			iser_warn("T10-PI requested but not supported on %s, "
>   				  "continue without T10-PI\n",
>   				  dev_name(&ib_conn->device->ib_device->dev));
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 636d590765f957..181e39e2a67311 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -230,7 +230,7 @@ isert_create_device_ib_res(struct isert_device *device)
>   	}
>   
>   	/* Check signature cap */
> -	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_INTEGRITY_HANDOVER)
> +	if (ib_dev->attrs.kernel_cap_flags & IBK_INTEGRITY_HANDOVER)
>   		device->pi_capable = true;
>   	else
>   		device->pi_capable = false;
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 285b766e4e7049..6058abf42ba74d 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -430,7 +430,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
>   	spin_lock_init(&pool->lock);
>   	INIT_LIST_HEAD(&pool->free_list);
>   
> -	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +	if (device->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
>   		mr_type = IB_MR_TYPE_SG_GAPS;
>   	else
>   		mr_type = IB_MR_TYPE_MEM_REG;
> @@ -3650,7 +3650,7 @@ static ssize_t add_target_store(struct device *dev,
>   	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
>   	target_host->max_segment_size = ib_dma_max_seg_size(ibdev);
>   
> -	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
> +	if (!(ibdev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
>   		target_host->virt_boundary_mask = ~srp_dev->mr_page_mask;
>   
>   	target = host_to_target(target_host);
> @@ -3706,8 +3706,8 @@ static ssize_t add_target_store(struct device *dev,
>   	}
>   
>   	if (srp_dev->use_fast_reg) {
> -		bool gaps_reg = (ibdev->attrs.device_cap_flags &
> -				 IB_DEVICE_SG_GAPS_REG);
> +		bool gaps_reg = ibdev->attrs.kernel_cap_flags &
> +				 IBK_SG_GAPS_REG;
>   
>   		max_sectors_per_mr = srp_dev->max_pages_per_mr <<
>   				  (ilog2(srp_dev->mr_page_size) - 9);
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index d9f19d90131398..5a69a45c5bd689 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -867,8 +867,8 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
>   	ctrl->ctrl.numa_node = ibdev_to_node(ctrl->device->dev);
>   
>   	/* T10-PI support */
> -	if (ctrl->device->dev->attrs.device_cap_flags &
> -	    IB_DEVICE_INTEGRITY_HANDOVER)
> +	if (ctrl->device->dev->attrs.kernel_cap_flags &
> +	    IBK_INTEGRITY_HANDOVER)
>   		pi_capable = true;
>   
>   	ctrl->max_fr_pages = nvme_rdma_get_max_fr_pages(ctrl->device->dev,
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 2fab0b219b255d..09fdcac87d1770 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1221,8 +1221,8 @@ nvmet_rdma_find_get_device(struct rdma_cm_id *cm_id)
>   	ndev->inline_data_size = nport->inline_data_size;
>   	ndev->inline_page_count = inline_page_count;
>   
> -	if (nport->pi_enable && !(cm_id->device->attrs.device_cap_flags &
> -				  IB_DEVICE_INTEGRITY_HANDOVER)) {
> +	if (nport->pi_enable && !(cm_id->device->attrs.kernel_cap_flags &
> +				  IBK_INTEGRITY_HANDOVER)) {
>   		pr_warn("T10-PI is not supported by device %s. Disabling it\n",
>   			cm_id->device->name);
>   		nport->pi_enable = false;
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 31ef64eb7fbb98..b3a1265711cc7d 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -649,7 +649,7 @@ static int smbd_ia_open(
>   		smbd_max_frmr_depth,
>   		info->id->device->attrs.max_fast_reg_page_list_len);
>   	info->mr_type = IB_MR_TYPE_MEM_REG;
> -	if (info->id->device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +	if (info->id->device->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
>   		info->mr_type = IB_MR_TYPE_SG_GAPS;
>   
>   	info->pd = ib_alloc_pd(info->id->device, 0);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ada4a5226dbd91..b3bb4dd068b6f3 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -236,14 +236,6 @@ enum ib_device_cap_flags {
>   	IB_DEVICE_SRQ_RESIZE = IB_UVERBS_DEVICE_SRQ_RESIZE,
>   	IB_DEVICE_N_NOTIFY_CQ = IB_UVERBS_DEVICE_N_NOTIFY_CQ,
>   
> -	/*
> -	 * This device supports a per-device lkey or stag that can be
> -	 * used without performing a memory registration for the local
> -	 * memory.  Note that ULPs should never check this flag, but
> -	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> -	 * which will always contain a usable lkey.
> -	 */
> -	IB_DEVICE_LOCAL_DMA_LKEY = 1 << 15,
>   	/* Reserved, old SEND_W_INV = 1 << 16,*/
>   	IB_DEVICE_MEM_WINDOW = IB_UVERBS_DEVICE_MEM_WINDOW,
>   	/*
> @@ -254,7 +246,6 @@ enum ib_device_cap_flags {
>   	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
>   	 */
>   	IB_DEVICE_UD_IP_CSUM = IB_UVERBS_DEVICE_UD_IP_CSUM,
> -	IB_DEVICE_UD_TSO = 1 << 19,
>   	IB_DEVICE_XRC = IB_UVERBS_DEVICE_XRC,
>   
>   	/*
> @@ -267,59 +258,53 @@ enum ib_device_cap_flags {
>   	 * stag.
>   	 */
>   	IB_DEVICE_MEM_MGT_EXTENSIONS = IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,

MEM_MGT_EXTENSIONS is used also in the kernel ULPs (storage)

> -	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = 1 << 22,
>   	IB_DEVICE_MEM_WINDOW_TYPE_2A = IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A,
>   	IB_DEVICE_MEM_WINDOW_TYPE_2B = IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B,
>   	IB_DEVICE_RC_IP_CSUM = IB_UVERBS_DEVICE_RC_IP_CSUM,
>   	/* Deprecated. Please use IB_RAW_PACKET_CAP_IP_CSUM. */
>   	IB_DEVICE_RAW_IP_CSUM = IB_UVERBS_DEVICE_RAW_IP_CSUM,
> -	/*
> -	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
> -	 * support execution of WQEs that involve synchronization
> -	 * of I/O operations with single completion queue managed
> -	 * by hardware.
> -	 */
> -	IB_DEVICE_CROSS_CHANNEL = 1 << 27,
>   	IB_DEVICE_MANAGED_FLOW_STEERING =
>   		IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING,
> -	IB_DEVICE_INTEGRITY_HANDOVER = 1 << 30,
> -	IB_DEVICE_ON_DEMAND_PAGING = 1ULL << 31,
> -	IB_DEVICE_SG_GAPS_REG = 1ULL << 32,
> -	IB_DEVICE_VIRTUAL_FUNCTION = 1ULL << 33,
>   	/* Deprecated. Please use IB_RAW_PACKET_CAP_SCATTER_FCS. */
>   	IB_DEVICE_RAW_SCATTER_FCS = IB_UVERBS_DEVICE_RAW_SCATTER_FCS,
> -	IB_DEVICE_RDMA_NETDEV_OPA = 1ULL << 35,
>   	/* The device supports padding incoming writes to cacheline. */
>   	IB_DEVICE_PCI_WRITE_END_PADDING =
>   		IB_UVERBS_DEVICE_PCI_WRITE_END_PADDING,
> -	IB_DEVICE_ALLOW_USER_UNREG = 1ULL << 37,
>   };
>   
> -#define IB_UVERBS_DEVICE_CAP_FLAGS_MASK	(IB_UVERBS_DEVICE_RESIZE_MAX_WR | \
> -		IB_UVERBS_DEVICE_BAD_PKEY_CNTR | \
> -		IB_UVERBS_DEVICE_BAD_QKEY_CNTR | \
> -		IB_UVERBS_DEVICE_RAW_MULTI | \
> -		IB_UVERBS_DEVICE_AUTO_PATH_MIG | \
> -		IB_UVERBS_DEVICE_CHANGE_PHY_PORT | \
> -		IB_UVERBS_DEVICE_UD_AV_PORT_ENFORCE | \
> -		IB_UVERBS_DEVICE_CURR_QP_STATE_MOD | \
> -		IB_UVERBS_DEVICE_SHUTDOWN_PORT | \
> -		IB_UVERBS_DEVICE_PORT_ACTIVE_EVENT | \
> -		IB_UVERBS_DEVICE_SYS_IMAGE_GUID | \
> -		IB_UVERBS_DEVICE_RC_RNR_NAK_GEN | \
> -		IB_UVERBS_DEVICE_SRQ_RESIZE | \
> -		IB_UVERBS_DEVICE_N_NOTIFY_CQ | \
> -		IB_UVERBS_DEVICE_MEM_WINDOW | \
> -		IB_UVERBS_DEVICE_UD_IP_CSUM | \
> -		IB_UVERBS_DEVICE_XRC | \
> -		IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS | \
> -		IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A | \
> -		IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B | \
> -		IB_UVERBS_DEVICE_RC_IP_CSUM | \
> -		IB_UVERBS_DEVICE_RAW_IP_CSUM | \
> -		IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING | \
> -		IB_UVERBS_DEVICE_RAW_SCATTER_FCS | \
> -		IB_UVERBS_DEVICE_PCI_WRITE_END_PADDING)
> +enum ib_kernel_cap_flags {
> +	/*
> +	 * This device supports a per-device lkey or stag that can be
> +	 * used without performing a memory registration for the local
> +	 * memory.  Note that ULPs should never check this flag, but
> +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> +	 * which will always contain a usable lkey.
> +	 */
> +	IBK_LOCAL_DMA_LKEY = 1 << 0,
> +	/* IB_QP_CREATE_INTEGRITY_EN is supported to implement T10-PI */
> +	IBK_INTEGRITY_HANDOVER = 1 << 1,
> +	/* IB_ACCESS_ON_DEMAND is supported during reg_user_mr() */
> +	IBK_ON_DEMAND_PAGING = 1 << 2,
> +	/* IB_MR_TYPE_SG_GAPS is supported */
> +	IBK_SG_GAPS_REG = 1 << 3,
> +	/* Driver supports RDMA_NLDEV_CMD_DELLINK */
> +	IBK_ALLOW_USER_UNREG = 1 << 4,
> +
> +	/* ipoib will use IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK */
> +	IBK_BLOCK_MULTICAST_LOOPBACK = 1 << 5,
> +	/* iopib will use IB_QP_CREATE_IPOIB_UD_LSO for its QPs */
> +	IBK_UD_TSO = 1 << 6,
> +	/* iopib will use the device ops:
> +	 *   get_vf_config
> +	 *   get_vf_guid
> +	 *   get_vf_stats
> +	 *   set_vf_guid
> +	 *   set_vf_link_state
> +	 */
> +	IBK_VIRTUAL_FUNCTION = 1 << 7,
> +	/* ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
> +	IBK_RDMA_NETDEV_OPA = 1 << 8,
> +};
>   
>   enum ib_atomic_cap {
>   	IB_ATOMIC_NONE,
> @@ -417,6 +402,7 @@ struct ib_device_attr {
>   	int			max_qp;
>   	int			max_qp_wr;
>   	u64			device_cap_flags;
> +	u64			kernel_cap_flags;
>   	int			max_send_sge;
>   	int			max_recv_sge;
>   	int			max_sge_rd;
> @@ -4344,7 +4330,7 @@ static inline int ib_check_mr_access(struct ib_device *ib_dev,
>   		return -EINVAL;
>   
>   	if (flags & IB_ACCESS_ON_DEMAND &&
> -	    !(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
> +	    !(ib_dev->attrs.kernel_cap_flags & IBK_ON_DEMAND_PAGING))
>   		return -EINVAL;
>   	return 0;
>   }
> diff --git a/include/rdma/opa_vnic.h b/include/rdma/opa_vnic.h
> index cbe3c281145501..f3d5377b217a68 100644
> --- a/include/rdma/opa_vnic.h
> +++ b/include/rdma/opa_vnic.h
> @@ -90,8 +90,7 @@ struct opa_vnic_stats {
>   
>   static inline bool rdma_cap_opa_vnic(struct ib_device *device)
>   {
> -	return !!(device->attrs.device_cap_flags &
> -		  IB_DEVICE_RDMA_NETDEV_OPA);
> +	return !!(device->attrs.kernel_cap_flags & IBK_RDMA_NETDEV_OPA);
>   }
>   
>   #endif /* _OPA_VNIC_H */
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index 06a4897c4958a5..7dd903d932e54f 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -1298,6 +1298,10 @@ struct ib_uverbs_ex_modify_cq {
>   
>   #define IB_DEVICE_NAME_MAX 64
>   
> +/*
> + * bits 9, 15, 16, 19, 22, 27, 30, 31, 32, 33, 35 and 37 may be set by old
> + * kernels and should not be used.
> + */
>   enum ib_uverbs_device_cap_flags {
>   	IB_UVERBS_DEVICE_RESIZE_MAX_WR = 1 << 0,
>   	IB_UVERBS_DEVICE_BAD_PKEY_CNTR = 1 << 1,
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 24c9a9005a6fba..9826fe7f9d0086 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -154,8 +154,8 @@ static int rds_ib_add_one(struct ib_device *device)
>   	rds_ibdev->max_sge = min(device->attrs.max_send_sge, RDS_IB_MAX_SGE);
>   
>   	rds_ibdev->odp_capable =
> -		!!(device->attrs.device_cap_flags &
> -		   IB_DEVICE_ON_DEMAND_PAGING) &&
> +		!!(device->attrs.kernel_cap_flags &
> +		   IBK_ON_DEMAND_PAGING) &&
>   		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
>   		   IB_ODP_SUPPORT_WRITE) &&
>   		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index 3fcd8e1b255088..de0bdb6b729f89 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -195,7 +195,7 @@ int frwr_query_device(struct rpcrdma_ep *ep, const struct ib_device *device)
>   	ep->re_attr.cap.max_recv_sge = 1;
>   
>   	ep->re_mrtype = IB_MR_TYPE_MEM_REG;
> -	if (attrs->device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +	if (attrs->kernel_cap_flags & IBK_SG_GAPS_REG)
>   		ep->re_mrtype = IB_MR_TYPE_SG_GAPS;
>   
>   	/* Quirk: Some devices advertise a large max_fast_reg_page_list_len
>
> base-commit: 22cbc6c2681a0a4fe76150270426e763d52353a4
