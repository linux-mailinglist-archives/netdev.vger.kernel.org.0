Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84D35A9A07
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiIAOVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiIAOVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:21:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE23C32EC1;
        Thu,  1 Sep 2022 07:21:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsMpd31u76Lcy3CJXzSaNrsjiz7VhYz6nqJfP2806iUFnxHOtClClBRbQal2uRWW1qydN0/O9DOEB6T5fUgdA4LByszRy+1Ht2iOZhlHg5xxAywD8q142YWlFoQcxbfERGfICSr3LXlSmh+nFgSUTGO9ltMRWsayWTKAZOgcedOqaDFpJ+EUIIh/EBtmY7joPYj1Dk3gxMu7nfa4DvNLHnrmig+uy2HzDw66uxFAlikotBXpJtvJT6KBdlHSXm22vS/15Jik2+JE+sU2v7pfFE+gcWdIMo54cWi9+VJOdKi1NOjm/dfNJBd2Yi6vmDl3Uh3NAa4+F5HFf+6ldLfHAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0my+09iX+XmJxjirxVH5rAlp7t1qEUwcjsQqAflNrw=;
 b=A+kI73Cc1C+QH+7uEk3bO+J5/XYcfNs/d02iQXvRYIUtI/RE7p0Wc+O9JnvumrxChgXHV+Wsg0gFn2JgIacMqML0Mp6qH8MmJXa4AfsU4nMBZmX5rzUjLt/KX+aHKUslNtwx1o2QdUNUGLlCCHSAhSc0Gg+6vlKKSPuoTrIcOK+reu5DEd6Ck0YfE/1w2MWX+P/3t3aVlU31PBSaLhKCxCeGIFB/6U8Z1MGHff03JRf8J2rWhCZcTeizW5UuhBbA3sW4xJKlP+i0vs7RQjTD8b3oBBQys0iRIjjYqTlsW9t0bSo8lKeIDJUOPIEm60MuIWpfMCoehQhsc+pSmbj2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0my+09iX+XmJxjirxVH5rAlp7t1qEUwcjsQqAflNrw=;
 b=J0vJJo/R96v0w4kvSsYNAbrR0bfagBC7nS+57oD30fEOmNRF14Kus3sNLP/Qbr9Y+hIF4ILvzt2yWszcRQqRpp3qXL1s3v44WUSMqQ9ld/r/N5+R/ULyK2UjJ/R4U3jevLD9IsRIUoyTBIMi9iMZpwAF/znHOtIWTcN4Njh0agHeN6qzN5HI7Vsh/gZddDlcIUs7uzaJzhgiIry7zAY8LoA5vkmIQJn5OXDwdPrGXi9+OrMfHGwYS1Ip0Qpyh41h9c++HIFcAbvPhFmvjjnDohl51ZqZKkdvEvKsTLlILeg2Fzg8GltO0CQJACJ3bvXQL9L/cJJT73sqeOZVD6AMdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 14:20:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 14:20:59 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, Leon Romanovsky <leon@kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Mohammad Kabat <mohammadkab@nvidia.com>
Subject: [PATCH 0/4] RDMA/mlx5: Support DMABUF in umems and enable ATS
Date:   Thu,  1 Sep 2022 11:20:52 -0300
Message-Id: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0021.prod.exchangelabs.com (2603:10b6:208:10c::34)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd6c9c99-a69d-4b58-877d-08da8c253031
X-MS-TrafficTypeDiagnostic: BY5PR12MB5000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KokJOkdrOCDCHp5EGrhn+eEJMlf3XPdRQ4Ktan1y1aKfJq98USLl5lAn9RyQA0M+UoOoEVJdSpnq3VOgcjoX6itD8FWhFkXd4F1Al2ND57LUjwA//uHAuJv7w0Owj0LNrZo1ksCUlCUTBLf52TTs2Oo/JrYliI5/kzbh/JoGBP5mxpUUR2f6JJz8+kvCvWRjtR2c3YaQtBcsTv2EWeHDhLwUtie46myHOrJrmO7tZJkD+riTflOFgCa57VvtYaAfJQekGkoK5uLwclpFxzKKm5mpDrxoG1rebfKBmBPYx7465UHiIGnTY2FTmlh6WVIlJIhEZ5EKoGoh6Ck8DdW/3HBNMvriS5fSuSzSPextWFj+ZQGJY6lIbRXlSDiSGpx4+pqaB+DPQLdWSJGQdOTViMzw6PTjY97JZ7foptdDhBVjmiuzrJAw4rIzh/QPrbK/pBmsWQ3r0+Y+4A+HKLEGiih7rhDbTuuzbiQYw6dFYfkupJQLjihGReEs5KwMTj4sVG4BeG5Z0palT1u2Kj6Yd20reI2CO0MKZEHaG8PEm+CJF0cNapUFED377l02TkrsAHxEFTuFh8tQAg3eugJMF1ZNYWka1yhv7NRYmwH9jIBLnzLwr+TwnhX/VkQK0jjRdYa1M5PvHT2BTv+0V9sz2rph5Fx9JO2UPcXCPc/HY18w9PIjHjgSAvAxvEXz5S65mCj1NAm56H7t60SRx8SHnOi6YtsUg5ErheqUkK/lmNP0OTLBf2oThYGVU7yzZFPp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(6512007)(66946007)(4326008)(5660300002)(66476007)(6666004)(6506007)(478600001)(107886003)(8676002)(66556008)(6486002)(8936002)(86362001)(41300700001)(83380400001)(2906002)(2616005)(26005)(38100700002)(186003)(316002)(36756003)(110136005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OV4JMjYJxzJZnMLJL69UzVTNciWyOjA9mo8VrFMpYYtShhbMs/U4i+zWbtmw?=
 =?us-ascii?Q?9atG1wlhNijf41YRSQ6i7t5XgLStFJKU2U4bnCmUAjI7Z+VE7g9v7YBYlHju?=
 =?us-ascii?Q?0EzQPpLZETUX3Skb089CiEb5YtyP5cKittuE0xxFXZWlzuJY7FA5neV980vS?=
 =?us-ascii?Q?rLDwpzWT7x0UEh72f5Yu31MwvRoNJwlkfNcoJvSstJEc136ScLKtqlAnKCW9?=
 =?us-ascii?Q?nk5RJGivxlYxaezYBf6ieYHt/7SfMZJ2RwFyVGPQ7LK7N2FqhmlV7R9bYQQu?=
 =?us-ascii?Q?wnMysGbhui/3FTZjSVN7DT7gHU8YQ1NCnUvrUnYqCFChkV0VLPIBejMkEvLF?=
 =?us-ascii?Q?ZzDcOf4/Y46+5kiPF7Y46XHoHXdb1w+/dN5uFdX85r/u4SslokaSLgvIRuPd?=
 =?us-ascii?Q?Cj9xY8fBQsFouPk6r3t0OxlSUEhDWZQFPyhdDLc1onmoTtFCNHD1Tk0ZG/yX?=
 =?us-ascii?Q?gTWDs9jkCBYKlMCw+7WV98hJUTu5NzwX093iXsh9doIrVttRC/FcR6hkCqU5?=
 =?us-ascii?Q?2Vdf9Mhbbuwh0RZBIv7kxATWXI77mzjrmmTxZN1L9Ow9EVpgQnK7yLxk09Dz?=
 =?us-ascii?Q?1JLYpbPTWYSXKgOjqe0X7f1Lo/MPI1T9rD/Y8Eflz36mHEZmqGTrwpM0vOy5?=
 =?us-ascii?Q?QgEtVU7cQJ6+zMjEQlkEeb2FSJ1c0mlTqj4otXq1/H9DtquMr3ZX6liRK4Bh?=
 =?us-ascii?Q?FVFDGlROMoF7eHykazhLMxxxFjY2e1l5cdvsZZ0qjHL+pFB8OTxScEJP/Rg2?=
 =?us-ascii?Q?x5uI4Y1VzVZAdalqMzSabGbBcL+tN7IvPxXajZUFtyPgx74H1yJwIUCcYTT6?=
 =?us-ascii?Q?RMrCEsklPr7BAYZPF+Agvcah0x+1Vjok2T7HrkecrsLBaTfFI6NgHRDUUZ3M?=
 =?us-ascii?Q?OjXZYFEEUIQTAUkXRUvv+jsMtOjNgBZ+p8EZ7swJsG0MZ5mvEeNL8I71srJH?=
 =?us-ascii?Q?ElrxZH46qyLN7rmECAQCGtvs6E+v+b29T4823CBP56oEWGyXrTXELHK27fXF?=
 =?us-ascii?Q?08qQmhyp4TkxUBM0xARXx166c5ymvpnx8f4PzzqFUMRnMTgJX9uLpwl8Ah/t?=
 =?us-ascii?Q?0lrrh61z9mH+3nBLwQcI4ZcX8PqA1X7G+kRgyjm5GFbhgM5fmWoM35/9JCTE?=
 =?us-ascii?Q?AJ6EthHlJLa3PzZ6+Q7c8hoDwUetuP0E3g3RVVqNQHVwAU65lwd11FRDFWe9?=
 =?us-ascii?Q?C7McxVZTbI4MlpM+NTftQwOqqEgCP8IrdrSyzGTbhPI5vRln0omwE/mwvsTo?=
 =?us-ascii?Q?Y6r0s2x1YFqhnwT94j8+xxidy2+cb+ZQuf55Rh2SUyEl9d/KqShK67S/ny0d?=
 =?us-ascii?Q?GO0OODwstKkcGUnQsN6QGqB92QQrEdCaWGzqt7RXzZAkO7njakansDBd+FAq?=
 =?us-ascii?Q?2h1nEz2xGPnRjIUOgQFetLsDkRjDFi2bRzeF71StEgUegrhTV3LHJqwk3rrb?=
 =?us-ascii?Q?deqGOT5Vd6+wfTbGsbgZrgukKYETbLU9/TO1jAgsxxzEZoP9a5Jl14NU65OR?=
 =?us-ascii?Q?+uBO2HPrE8SI9FlNEx9JPpjx8yO8/O3I4EVxKFIyuXrLsdyxhQ56O3wp82bY?=
 =?us-ascii?Q?d8BKGGriciVwC3nhq3H+5pRjBp7Va3bBnvaYQYLM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6c9c99-a69d-4b58-877d-08da8c253031
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 14:20:57.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqlkdnCT/PLlpewNqFLuufHKQYxuZTOiYeK9EMJCrmlzbXdAub8CY9EKHJgb/ahY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for DMABUF when creating a devx umem. devx umems
are quite similar to MR's execpt they cannot be revoked, so this uses the
dmabuf pinned memory flow. Several mlx5dv flows require umem and cannot
work with MR.

The intended use case is primarily for P2P transfers using dmabuf as a
handle to the underlying PCI BAR memory from the exporter. When a PCI
switch is present the P2P transfers can bypass the host bridge completely
and go directly through the switch. ATS allows this bypass to function in
more cases as translated TLPs issued after an ATS query allows the request
redirect setting to be bypassed in the switch.

Have mlx5 automatically use ATS in places where it makes sense.

Jason Gunthorpe (4):
  net/mlx5: Add IFC bits for mkey ATS
  RDMA/core: Add UVERBS_ATTR_RAW_FD
  RDMA/mlx5: Add support for dmabuf to devx umem
  RDMA/mlx5: Enable ATS support for MRs and umems

 drivers/infiniband/core/uverbs_ioctl.c   |  8 ++++
 drivers/infiniband/hw/mlx5/devx.c        | 55 +++++++++++++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h     | 36 ++++++++++++++++
 drivers/infiniband/hw/mlx5/mr.c          |  5 ++-
 include/linux/mlx5/mlx5_ifc.h            | 11 +++--
 include/rdma/uverbs_ioctl.h              | 13 ++++++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  1 +
 7 files changed, 109 insertions(+), 20 deletions(-)


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.2

