Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241FD4F9AE6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiDHQsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiDHQsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:48:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439F010E9;
        Fri,  8 Apr 2022 09:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeAwrP3a+ZqldNERfWZsBgHs5SvTEJf4R3vMe8QUuhkUlX315kAxJDOuygeZlrE61N4IcpIPRKRd8lr1AqY5cr7pyFapV0VZSnnMY/Kl+S2wCmXggQF+TXELLNP71iTDIgcUkzMZVQHWRBqIc1Pp+JVtYy/eAfp0eY4+s37pIrY3zseSWgASgVxtXPPgu4CdcMolQDqQjAigxwQ8+VRGSki4VbKtnqL8HCVzWAguchS1tTneGnkvFZn2IosgsuYKAhPGVPwcXFZb9xuTrpLl27D2rsscxagCIUTHHWecJEgNOuLCVKOWbqwMsdJq4CjLkYLZT89YnJvQ+Li06SYVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsvgP0R4fYdofrXzMBQP1CyBGLLlYrcmWJbGPS0mv+0=;
 b=NGN6yUhHSFrWClu05LPY9+kzRsEpGHQheauhsd6PJE8aIEYNIbFocH3o2fq7AAupfSS07/zC1mVPZv1E1FW5oQ6QIuQzfd/R5OqXq7DOL+nmkb1lwgukqlOfGJfj4BaQfyR8o0jEgg5ki0btJDLl+3afSoslrHnnYEs1RC0X59UbPCB0Hrwi148Gx89C2qYiqH4I/MiurwXnJenTSNpGDHc2mOw7L8/HZyP/d5ufcWNEdTiGEvHOHOfbKOq9QIFaTLM7IYHWpuzNoSVZ73l/nPuRWsJToCIBxveUPSVZm3ScZZ5fDp0O2bZ+LB5YVDlsiKujbpU8JIrL081NrofMnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsvgP0R4fYdofrXzMBQP1CyBGLLlYrcmWJbGPS0mv+0=;
 b=ghsZiI2xW9Ssy/hJUvLmCBESa6j5f5+gz36SKuySmf1rwqbLF8BlcL5NEIF5y7nvVtP7/TpS4d8hp9JfMfYOJ3Uwxt0y+62mZ7GGMfL+wbdaqDo9VDGGvzuaTW57TlsYSW00uvFnxrawwMfkTlaF1lWaAfXfUeAD+x+UpsvyGYQPv+nE0/a+d4T8yab48gXV3ac3SL28aTAykUV6HKYmQJQIa8evxroW2ydEm9Y9sJfa1ALKhHgXp2O/3KlxObJ+ukl08R30u0fODNZ2NDaWCVsPJFE85c3e98SomJYev/U/VOiudsByysrL++z/TRr7fuFXaEU+Nn37Uo6/T5GQkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 16:45:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 16:45:56 +0000
Date:   Fri, 8 Apr 2022 13:45:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
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
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
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
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from
 uverbs device caps
Message-ID: <20220408164554.GA3613777@nvidia.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:208:15e::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e64985b-a5df-4d06-a5fe-08da197f4075
X-MS-TrafficTypeDiagnostic: BYAPR12MB3192:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3192BF8F41ECBF82F0C99837C2E99@BYAPR12MB3192.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwV6XYtWXA/Z1zLl9Yz52w9ZcFJVkkKKeh+DvKGA5gpwcoXf958LgdoSymA1N47O2Qh1zDyz9CpyZ0jY3rEM2NwAgfiNshNT+82I9Bwt6E3y+Fka+4mN296HElizMrkzXrVKdhoO/n3GAgBBPyRbAKUQxabywUWVW5JwR7/gqc/sc37HgCp4cD+k4Cst7eQBke+HtGupM+wEpvnZSMbDIWMdsYKCbfBvN+nK1ehIUk6UndpTFkN/p0AaFBLR4txMqUxPuZQZCyBaBFUm3rBUsi/QN6Q7TXLuPdOMe2JFhKG3mRKTNT1Hyl6Is4QnNRKyttrye2C3mFl0T3XWebQ1TW54mIwDg5MWpv4fRF75X3XIyThqAPACITf6yWtGk04O7haj8OMAkr1LHd68p4aD/SE2eGdjGY185WhGoXkCJy/09m7OoxIyv3bKRje86qxfoiu45ZAWBoKJ10RHi/dvnaomRw7lFkL4EckAq5/EWvDotMOeMe2JmU5KBHpBXCWLswgVCiiXPAfEJb/IZekG5CIdCUlFiBcTLrXzGdNj5fmfJQXpyfHsnGza++bUku3Tpy6knx+GgQcgN/fHtgBaIjNbP6re7m/5RldcJcKxwtL8GeUtC5Q0zMJVKPIreiDBCVVdykq3F20FXGi0KqDxvr1sPzPvGwNQac+RwmvdKxQAZHZg47tyEGkMJEFEP1Vz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(33656002)(83380400001)(186003)(86362001)(508600001)(7406005)(7416002)(921005)(8676002)(38100700002)(66476007)(66946007)(66556008)(8936002)(5660300002)(2616005)(26005)(6506007)(6486002)(1076003)(316002)(6512007)(36756003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8ny8kQG1JSfpBjCDsT4hVecYB1hwn5bXJvlyiqovQuaX9Gfr9I7rA3yKTLN?=
 =?us-ascii?Q?UCzFjx+ism8xF3r5v7laKJQssBPqlsSut1keZJ7hW7XUj2LstwjkZdfBOoYc?=
 =?us-ascii?Q?4dPqXt+DnU9RcpKihmjKUz20w4ACDWgwiVZMlrHtYsLWGfe8Ww7uvHxNvflz?=
 =?us-ascii?Q?MYrry7Wrb7XfUqmciEye1i8icX7mnpz8iFWRRaF57LlThsHiA3G8BU8h5L0v?=
 =?us-ascii?Q?9D4KDmQOfHQPE877dltW69bHvKnz/l7JxMEUU0duuC/6AxObs0vMEtdjfE3X?=
 =?us-ascii?Q?PbUqd7Z/iF7FlhtSs5iEv1V0Y4NBPLz7RES3E/pDltLxABDUgg9HDrUozixC?=
 =?us-ascii?Q?g/wm34ZmnSaRtC+0er/Fhhi/HEqotgMV628VG0rZS0kstWTin97Kcv97HyH/?=
 =?us-ascii?Q?Vi9d8VPGTc/7vmUvlC9RmsfU4gXAgo2Uwdy+vYn49WhsZOD2weuWJha0Bm9O?=
 =?us-ascii?Q?JO22y/T36HL0KXaMjnHDfettNnuJivN9YfWNlCBMoB/zflpQn/8vvJ9+A1q6?=
 =?us-ascii?Q?EJH5s6HaF+us6+b3JgodY7DOxoK604w7XQKza//BLVnFuDaa9+IIf+N/4mYp?=
 =?us-ascii?Q?wI9hEhcVLpvDh7rQf/x6qMPEbEP3Ww17tTLqdmobKZIvwBALWgwuVqNbCh+8?=
 =?us-ascii?Q?2ZbNxMwgYMT21Lw7lvXGRR+YuBs8V+7q5XJGNi8e7X0fr8a0PuFCDZnKfGeL?=
 =?us-ascii?Q?I3uI45gRzuIRyR1Gm0xTeJHnMvSvsbBIDAtV10qVon75rTgFncoUu/593v5q?=
 =?us-ascii?Q?8l6t6Pe4wpDOHtZLIICqcZ+s9naTCKl4oWOv68cwowaQ2aUli3x4T3Utixsh?=
 =?us-ascii?Q?sMB+MsfgTC9P6EYiVmAdEA+agcpfEcw6uPbfhHpabar9vNCMQEeY4XGqKKet?=
 =?us-ascii?Q?ILXjviKTA/YQSkEmOCShuENGohFTYmMq2M3R8dbSxbyFy0GstklItuIKLG5z?=
 =?us-ascii?Q?lM3Uwa8meOTjnRJ4rWjgqIo/Jr2s4iNfZ9ukmbGUCcgxsZtfLo+7C54CDDdx?=
 =?us-ascii?Q?C8yfQfhth7VrspS//PvdfBDAZ3KHGflqhAhH6b/95BX9Sv4ouF9GbHQaFR5r?=
 =?us-ascii?Q?Gou2iucJJeBbASG/YA7BpPkgaUXpQ0ogXSnwJ55OKKaOnM7O8EnWcqpmwMpZ?=
 =?us-ascii?Q?YCI2Aac9tUp9oxoZEXb5NDA7Oy0TIN3GuQIOUMTEU+dYW+ReIBO5dfyjKMP8?=
 =?us-ascii?Q?+ZjNo/QisS5MdM8Mq1qekjkdC3QXSDp7yQlCRtUDWzLzCqpWyl/3DsmS96Oq?=
 =?us-ascii?Q?Vjpvi54f0WS/zKdTneX6gaHv37Uq/LOBR1mtd4CZ/eVItqz8NwJCTH0dfSP9?=
 =?us-ascii?Q?TZaCvoV/GOrNitSs4puY9HxkqjHdWcr7effGLWM0RzAgX5AuoatV444Swpgo?=
 =?us-ascii?Q?wbQTlPbnU8BOYQjsiOSxp/cYhQHQ9dblFWO+n5dJDy9Y/UkIUoq74T/tNUxo?=
 =?us-ascii?Q?mvUo769XBDw8iS3K3gYARhaB9q0X11cdTLsf9imzr6Pi62Sk2EebWfcBCwme?=
 =?us-ascii?Q?V293/nKRn+L20KgahTF4n2ly7PJOCqfQiSeMVakGVMitJVgT5Y7rbea0ElIA?=
 =?us-ascii?Q?gQ8JlRLjRk8C+mJtVhshaiT0aiSEyauII90eN5BdyDlEgkh67PD9zoZIsc7O?=
 =?us-ascii?Q?ceVOlxgSURaTsJ67tnKeeqIZ/INGU3oNzH5EbfYkj89vjVoa0S1K9DClOd1N?=
 =?us-ascii?Q?E0DjEeqINhD5XOd1blDKwMp+WjbzV9Lq0T1MwQHH+/LgPfdN9JGGW8Ljb3jo?=
 =?us-ascii?Q?9rmT3Diy0w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e64985b-a5df-4d06-a5fe-08da197f4075
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 16:45:56.3088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPYcX5AMdZH4q/Lc2BVys/6g8LOnEeU/lpmzv0sj+NtQ5otsb5JqUfF84vlyiKlF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 04:27:18PM -0300, Jason Gunthorpe wrote:
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
>  drivers/infiniband/core/nldev.c              |  2 +-
>  drivers/infiniband/core/uverbs_cmd.c         |  6 +-
>  drivers/infiniband/core/verbs.c              |  8 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c     |  2 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  1 -
>  drivers/infiniband/hw/cxgb4/provider.c       |  8 +-
>  drivers/infiniband/hw/hfi1/verbs.c           |  4 +-
>  drivers/infiniband/hw/irdma/hw.c             |  4 -
>  drivers/infiniband/hw/irdma/main.h           |  1 -
>  drivers/infiniband/hw/irdma/verbs.c          |  4 +-
>  drivers/infiniband/hw/mlx4/main.c            |  8 +-
>  drivers/infiniband/hw/mlx5/main.c            | 15 ++--
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
>  drivers/infiniband/hw/qedr/verbs.c           |  3 +-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 +-
>  drivers/infiniband/sw/rxe/rxe.c              |  1 +
>  drivers/infiniband/sw/rxe/rxe_param.h        |  1 -
>  drivers/infiniband/sw/siw/siw_verbs.c        |  4 +-
>  drivers/infiniband/ulp/ipoib/ipoib.h         |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |  5 +-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c   |  6 +-
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |  2 +-
>  drivers/infiniband/ulp/iser/iser_verbs.c     |  8 +-
>  drivers/infiniband/ulp/isert/ib_isert.c      |  2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c          |  8 +-
>  drivers/nvme/host/rdma.c                     |  4 +-
>  drivers/nvme/target/rdma.c                   |  4 +-
>  fs/cifs/smbdirect.c                          |  2 +-
>  include/rdma/ib_verbs.h                      | 84 ++++++++------------
>  include/rdma/opa_vnic.h                      |  3 +-
>  include/uapi/rdma/ib_user_verbs.h            |  4 +
>  net/rds/ib.c                                 |  4 +-
>  net/sunrpc/xprtrdma/frwr_ops.c               |  2 +-
>  33 files changed, 100 insertions(+), 116 deletions(-)
> 
> v2:
>  - Use IBK_ as the flag prefix for brevity
>  - Remove unneeded ULLs
>  - Spelling
>  - Short documentation for each of the kernel flags

Applied to for-next, thanks everyone

Jason
