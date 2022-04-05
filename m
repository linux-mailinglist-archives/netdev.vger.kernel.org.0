Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79F04F53CD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361287AbiDFE0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847721AbiDFCUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:20:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EEA269378;
        Tue,  5 Apr 2022 16:37:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJMHFDb385Pk1INiFJy/jKPgalLqLf2lNzGcBdnP5uLd9ofJuWSuarwNUH2bpcv1m/GdQIl9fiFnL09rY6rVL1UMEsMn1MS7sq4xcOeI6vbbOrUzDf3IzSauTJ9eYhe08rUHlNUDZZf1zabClOLrnm0VlM2oEfVAPJP0+Jko1yemQ+wPcpNGQ6EyV6l+jUvw2qH6sqKLjWPW05S2uVOh17qyuGSkc2U6itgKI6+qq8PsTtLd/C8+o65W0StKSkWK5K9BSfz51PVvf9XqOhos+3/QZtGR+gcIAJL4tS7Ce/4lkhgPr0+AYbvlCbT9Mmm6Ntn8ko412myyuic1ikV92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ8fkqQRyvccGEjfChcVHQG6wLPS1HHzdhMQ9kB0mN4=;
 b=GiltZAq4YGpmmdVYNgkZFYFDX7NSqpMsaTL+q/4lrWH631TkfXU2ovTLZRp9UzNuhvTUPLcqyX1R4rYmyjiVmm0urZmvG/lz8gXXeTgMA9UgxAETWZPoGUG1XRlAixRnTHH10+ZqT4lZkmhlCedqnUFNJuGxqFvUFoZCkKsJXlQPfFp8Rsc0aMf4nxBbevdV5/ETCIvgZoDm3Em7lSnbDOTdzRt2UMVFLcMD8XR1QD9URqSUXtd9/BRYdkWNNwv9K2wWr+71JVJ8u2wP+yFZRvCd6zauEexe/v+vG2yUXmtiTLk89J7b3g33njMlDJBOfOkGb+lc1qIZhY4UiriTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJ8fkqQRyvccGEjfChcVHQG6wLPS1HHzdhMQ9kB0mN4=;
 b=dYpE+BB/+QfGiZN1QE+46xVgkxjBT5HT8WvjLHAEgEtv/taaJRvldZb8/j4w6zRnlm5pKYx7uj+Dmjcf5xFI+3ZsfaC4ZxGPGNcCycmnb5UBPP6IHPNTph7EdpzGgs+/dsCfZXFEF5O4QZmHztEaabFbtPwMU9gM9RVNxPWrvqgEduQhG9jA/wT/fYn8LIXB6kQAeGdHGIrrTXCueJCRzmbOHV+4A9a1nz4NQDLy0IOKW0MNS4fBLIdeYaRDuG5bCtCC5fNZJmsq6OYZJPcp5Z6dzyHl+xguOPUP71WP7eCF0Btp3pM3m2B1tBvL6JaFB4WV3GLXzxEzLSllGYGvpA==
Received: from BN8PR12MB3426.namprd12.prod.outlook.com (2603:10b6:408:4a::14)
 by CY4PR12MB1688.namprd12.prod.outlook.com (2603:10b6:910:8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:37:28 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3426.namprd12.prod.outlook.com (2603:10b6:408:4a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:37:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 23:37:27 +0000
Date:   Tue, 5 Apr 2022 20:37:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
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
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH] RDMA: Split kernel-only global device caps from uvers
 device caps
Message-ID: <20220405233725.GY2120790@nvidia.com>
References: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
 <20220405044331.GA22322@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405044331.GA22322@lst.de>
X-ClientProxiedBy: CH0PR03CA0407.namprd03.prod.outlook.com
 (2603:10b6:610:11b::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e110783-3c5c-4ab9-6add-08da175d3e25
X-MS-TrafficTypeDiagnostic: BN8PR12MB3426:EE_|CY4PR12MB1688:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB34262BBA6A0C4A4A389A602CC2E49@BN8PR12MB3426.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UPwiVvLTw6Qw6p80buxNeQNC0wVMbAHRUpjjyKYq5/+OMFjQmjM4nH6K7wrTQFHNf8eJW7pW9RABaM7gQpdsSYFEsdcaQLZuIhJCZhASDkOWGqwQKfFfmvN3te/DRG9mBuz/e833tP3fhJCrjIzOf1JH/XKiB9b9KVAXE1OPOMDHlkQi9smHESoCs8KuRTvnw2OGP0JZS84sLbkvJ3qUDIc50IhvPjp0f9bK/e0SAxs5q+lVoKldthXpE2ZxDXwWUoMwf3P9ywrDQ9YyHtU1YW5CoeYHlHd502dvqL7o8wxBWIxSd+A8pL32/dAlr70D4e5C/FbPOJDgSMKCcbl0f5bRQsYhoRKzaf6D9QuMG3OzJrvPjn2yrOdo4v9/jHBsb67O+NShYDXlEXSHXCKBwZI8scCdR/y3urU4DxFZNknbAMtLQgu4acOGQTAMUKaueGDO/2aFxb9Nc4KoopCNIZLclstjaGOgXA8+KpJX3AenMah/imx80n6DPdV/klLJYXsCvh6dEMqAFOFRGw+g03eSn875cQYEsQR/IIXE00MPwmNb+PfhdbvlhdgssltNmTHYs8LafelVnzqEvJApNIzoVvu3Dx6Jq2rZkKghL3ut/n5SIkbpo7twRfXybPv0p40rhh8ldimGhskFTtI6LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3426.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(36756003)(1076003)(6486002)(5660300002)(83380400001)(2906002)(26005)(508600001)(7416002)(7406005)(2616005)(38100700002)(4326008)(66946007)(8676002)(33656002)(316002)(66556008)(66476007)(86362001)(54906003)(6506007)(6512007)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lao9NZvIpLqgmWrkf1RuQ1CaTOkjzxQnRf/hbeY5sn38rBp+xyky79tnkug9?=
 =?us-ascii?Q?P5o71mA/QpNJ1d+Zoxq2Z9jlBPbdOhFWDTpy2o5g+eodMCnxtjQdKkvFCA4Y?=
 =?us-ascii?Q?/o+IDKHc79ZhPtNQjeq/UU/DoVfTP/wJsUbVrTQU/5u2WAGYoLOSDNKUF31B?=
 =?us-ascii?Q?6pyUgYFquHnsHnGXivBua4iOmByWUIvP2gIB6ML9BNhiNC3s73vBiD338Px5?=
 =?us-ascii?Q?FRCQiRtA5h3NkFp0GHwKKgMg57DZKzh65R5tH46JukAYP9BMgeJHoqiCV+js?=
 =?us-ascii?Q?bulw5cWXGw5UKKK2w3HFxUf5jFmEwSCdtS3YPMofDNfw6ePULsSe4BUrAsfE?=
 =?us-ascii?Q?AjO/qiu1rGn8rUG3AUtbHCXeszeWSRNI9PO+OuNeWlBSHykktQj2DPOBaMCB?=
 =?us-ascii?Q?YWEFxtaIg04VC1eoKos533u6b9Yb6XLpzayEk3+51CJ2D593Q8Th5nBos+Ti?=
 =?us-ascii?Q?KbaUl4amf0JJJ7ugpm5nBCOb42V2Xoe6rnmVfN9Dt6kCJv4mT2MG8qqstL2B?=
 =?us-ascii?Q?eb5x3vYo4TqaDzg7Ai9oS+8vDdfa5FYAzWvpRb+0ZP2dQAXHVGD4fu5KDLy1?=
 =?us-ascii?Q?kbcJTDjoUV7nWrzzyUyqLj0M+Y/MuvGbhqhUfj1Hyj+Z3pQwqA4uiUj8sAWV?=
 =?us-ascii?Q?217UHGVOHrQtybGS3ORFlLirgXnJ3rnv0gtzSJIwNz9l1+cjO2XRNJiMd5WD?=
 =?us-ascii?Q?f2oJQTTzoK/pDqoPT03QnvnDEi585LP0DenMTb9ruWubH6kqZAiq3+vSM1Z+?=
 =?us-ascii?Q?rD+i8SNoHY6DskxKtmtndB2zXVLzHly8hoVrHX+xUmlGezVinyj4Xi4Ynt4o?=
 =?us-ascii?Q?X7WDpDovhXnMKq4/OYxPOWgxpbOPIoD6C59fadWCWlWsB1nnusQIQRqWMHRm?=
 =?us-ascii?Q?x9fBFPUrz23+x2lAlxmJNaL0JhebT2ASFP7m7DwgP1RqYIznXc2EUgV8lAb7?=
 =?us-ascii?Q?qy+FNdVlG03aen86BoWXbHt0b2EWJKJ4cSJGs33nxIrxSpKcPdcmsG2+XdOa?=
 =?us-ascii?Q?vXRu6ROZG9PB7cE1CCi0HBmmyb+SwMtuSGT1BRFMKZplCtmzMQ9Wh9pDBcoI?=
 =?us-ascii?Q?y5a75B8+aeNjKfjcFc3zeA6GrF2B6j1ZSlP0EeHa9xHhCstyYcJ3NOBGTyIl?=
 =?us-ascii?Q?eKjJSS2Fex/TAsneViQt7XYZ16R9ZxNHXNhDQmmM8tijOwZ7hmTieCPRk1wA?=
 =?us-ascii?Q?szSh11GeIKeHIqFPnGNGkFgIhex7kWtm/hFTV7rl5kYOcJQTJSPUVecN5Osx?=
 =?us-ascii?Q?SrxrO/hPvxA2423u8RDynqQ7ePyk0hwvmEHLv0PF36gPTBB7/heLfBho17qx?=
 =?us-ascii?Q?uzS+GrWQCqrZJ+XotbPlImTMVpMgzEYGNcdUrIHD4IDM0XXP4HP51ey6e9Uy?=
 =?us-ascii?Q?5kd1UGwxN+Wps4cI7QgNqvGcH6UdgbFMQxg6WadC7Z5XrDB0dGfTQMorZjKp?=
 =?us-ascii?Q?i1BqF7m+hdQQIsyDuEaKQgn/iIf+m6D4+urOyMteWVY8Rrj/FbZLL3GsAZaB?=
 =?us-ascii?Q?BnF+82EJ+UXQhI+sI3hKtQEoeQ2xb5ay650yGmJV773EM7XNwSmUo0Lg11mn?=
 =?us-ascii?Q?lWBFP4AKqZxxpY4hmD42x5TMVURhFOO+0KXL1ap61d5I6L7kJ3WloP7OTavP?=
 =?us-ascii?Q?1eaiguMuVHWZDtfskWWtkogQbuLEo0lt7Ron1DivPGnGpxIZBYKUkRRroSS7?=
 =?us-ascii?Q?D3QZrkk3p/OjWM54S82envn0dNyLE++LZk8Kuxg9WJEytnjdroTTr2EERBC4?=
 =?us-ascii?Q?SL359FARMQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e110783-3c5c-4ab9-6add-08da175d3e25
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:37:27.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hULMmrwIXqJVIB82KVPbe3UZEVQ8HOMSeJYD0tz0vb2BuiIns3rnG+hLGkBMjBqO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1688
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 06:43:31AM +0200, Christoph Hellwig wrote:

> > -	if (!(device->attrs.device_cap_flags & IB_DEVICE_ALLOW_USER_UNREG)) {
> > +	if (!(device->attrs.kernel_cap_flags & IB_KDEVICE_ALLOW_USER_UNREG)) {
> 
> Maybe shorten the prefix to IBD_ ?

Sure
 
> > +enum ib_kernel_cap_flags {
> > +	/*
> > +	 * This device supports a per-device lkey or stag that can be
> > +	 * used without performing a memory registration for the local
> > +	 * memory.  Note that ULPs should never check this flag, but
> > +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> > +	 * which will always contain a usable lkey.
> > +	 */
> > +	IB_KDEVICE_LOCAL_DMA_LKEY = 1 << 0,
> > +	IB_KDEVICE_UD_TSO = 1 << 1,
> > +	IB_KDEVICE_BLOCK_MULTICAST_LOOPBACK = 1 << 2,
> > +	IB_KDEVICE_INTEGRITY_HANDOVER = 1 << 3,
> > +	IB_KDEVICE_ON_DEMAND_PAGING = 1ULL << 4,
> > +	IB_KDEVICE_SG_GAPS_REG = 1ULL << 5,
> > +	IB_KDEVICE_VIRTUAL_FUNCTION = 1ULL << 6,
> > +	IB_KDEVICE_RDMA_NETDEV_OPA = 1ULL << 7,
> > +	IB_KDEVICE_ALLOW_USER_UNREG = 1ULL << 8,
> > +};
> 
> And maybe not in this patch, but if you touch this anyway please add
> comments to document allthe flags.

Wouldn't that be nice.. I know what some of these do at least and can
try

The 'ULL' should go away too..

Jason
