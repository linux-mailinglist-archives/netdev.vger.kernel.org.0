Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF775A2829
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbiHZNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344059AbiHZNBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:01:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECFD792EC;
        Fri, 26 Aug 2022 06:01:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lh61FUgKwOhG5mrp3BjpYOoUZrk17SNmyY1tIPBKgoBwZ7VGomY+Z+YuecIidHeEl3U0hgdkmReyV248UrLvwYQOh3wFSjrEpmiBbBbnaUKsVXwC2RIX74Mvx8947HOqpYMFUYJyz+F1LmriXMxkRCj8r4TlDF/Q9zXPrHA7f4gvWQkFOjK0rTFchaFABETwgby59Vmj3grVT0XNnW++87FV+I94oBZZ+SuVMDho7MHnMMCVu/zsgGlFZcJP1xCq2sMlcY6Rvl4N6i5NoqLFOk/toRcuSxkidrwjeNosj2+w6YMsvuajlyIuw5tIxy9ee9IreoYUR1MaMspS6GgLmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPpW+6WdslqKUmZbk2mbHxCIFhkdsMIXlPq2K1U7pwo=;
 b=YCv7K5gC1rKV0XIL6l0F83OYaoohDUa6KRR9/t8WeNHfscVR1K4I9l0k7xpsZYOe7JS1PloohWSW8MbW0eXMmu3Y0eYd5bRqodOgBZY72pjh1QkiYROC1i4iTWtI8SdClIc65ybd8OufohR1ntIql5a5okUdLEsvqX46G0jk9UgfhlWKdg/ky8JWbij4j/kuGw0AwMyyoBDMGaOsuTGJmeeDgWF++Gd9LLfRzBrGA8YuC6NnSu/xpeDhwHbgJ/ZfmvQnRybcXXJSqlX5JnqIF5aR6zkwpyBuIGOFNcub7O/2ORZEGVTI2HtPYIcC3DMYBr2w/AcgzMQ94T6rGzvi/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPpW+6WdslqKUmZbk2mbHxCIFhkdsMIXlPq2K1U7pwo=;
 b=BOZEPNd+MTAllfumBvhSu3dvbgp7yK0+ycdZq4wrR37sdcxQy845cgzfGKk8EeMaR8RKN2+hPXZQNaJvsfCtk/CSSpLaMNFC5+qDv9PJiF73B5d4VXG3utKGTJfkXA3Ski6qAp3bx4W+/P0Wcv77Zj8khB0NRBK+K/mxKiobrEGE9cBQCg2eAQNx+YVZFke4bJuZCZZlwevZ7rCfGoKTkUSoI+5ahm6FV95W4yq2dydISWdPW3sS9ruzMGKm4oXN7BtfsX7GIaSI+CDLLRyTlH/RCmhH0VHNGR1TDhWMQHn2EA3+c3VFd710X3+Qzp/IRW8xLKAogZ2Zj67nFD1yJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB0068.namprd12.prod.outlook.com (2603:10b6:405:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Fri, 26 Aug
 2022 13:01:01 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 13:01:01 +0000
Date:   Fri, 26 Aug 2022 10:01:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <YwjEDIT+IyyW5Aok@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-5-yishaih@nvidia.com>
 <20220825132701.07f9a1c3.alex.williamson@redhat.com>
 <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
 <20220825171532.0123cbac.alex.williamson@redhat.com>
 <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
X-ClientProxiedBy: BLAP220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd41845c-01f8-4260-c6da-08da87630694
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GQ4cqmImxusN3cc01hVxa+75lN+xly/Tx5UTXuMOt4qJ2dRFv8RxIXS0SGOJN39NaxBdL8ghqfJGhb4DnHz7qQ2Mmn5pc2WbCF3lvGaBSeDBCsSQe/+8XxZ0KKh2GLWGVcWda2UiXnVGkj7z50URrzStHsoEMy65y3HyPsZfXnZ3PekiG7m+W02O+WUn49LTccdnnUxv0xcZ4xIJaRP8SjOk6kx1Z0sEk5lpqxAbn0NA0SPnS+obB0WXkCNibyfKq0AdMliVYLPrOmAmkm+6KeAm3MMK40C4QpTzD8jDvHcvmHX05QeAUT0a5PyY9qPbtOkCPCTe4r+1VxgKSPAikLfZhPJ5bFV+/VorhNPvB9DlFuEvTMPcbTsY1WTL7nja5yFwTFpOBzwbIrk3gn9a4BSP/2At+MZkChzytR5mCkIbRqUAXvZp2Sq8UHquOZNDVCfcAQcWDYlERYjjmc8EfY/LV3YVMrupKGqziKvPB2KnTd5MuMdWjvuwm31nEEJDsGRNx5nwtqJmOPKfUMK/HSzO02Y5YC9bncxSIz3hxyoK5shSKFnCrvRU9bXZw92HzGyFg/jOSEMwLo0eo5pbg2HrdfQHPCANFBhtQgAE8A3NzdnHNYU6iSUGAV6spGWPpmTBfz8DYp/G7BJuu0z3DVU8ZTp6A1rwMrtynKP9dA7rgRfzpihjTfvqCpSmDXJADEZYD5dJdy4Z3AAyjfLUKP+mNX6yvDKpukOj69IeEaQOGI7MUxsdo8Af4KTOc5Jq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(4326008)(66556008)(66476007)(8676002)(6916009)(8936002)(66946007)(186003)(2906002)(316002)(5660300002)(54906003)(36756003)(4744005)(41300700001)(86362001)(6506007)(6512007)(478600001)(26005)(6486002)(83380400001)(2616005)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?duZND9Q9MileBA6eEmvNUCOtzQUjkGGUVlWQ5NfURyNzveXCqDFIxEQd5H1i?=
 =?us-ascii?Q?G/78BjaQCiW2adEotCS8Dlvs9jgo+T1P0iyuaDOdXQH0/dUkJBuZG0CNhfqC?=
 =?us-ascii?Q?tPqWiGNnSyP8wvC/M8ulBYzT7ij7yb2CIoUNHOsHr5+W6fWGrK6Skomq0JZX?=
 =?us-ascii?Q?wmTt96pZHTXfcRsGGON1gaizEqnojOnkWiqCF265cHQbjnyyel1HIjCiGi+6?=
 =?us-ascii?Q?QhadGkNwTxW1/AcZnMdbLWyJ7ny9G9xdIfz832BqLsoRxLpPbKbyI43i1riN?=
 =?us-ascii?Q?HhQ6bQfdsdBsgipq+UFTzHnQAjy+2vjkSqSu8dB4EDi2Q9BKP1w5O/zAcZba?=
 =?us-ascii?Q?H0+Y5CohT8xXcfDix4JSHCgQ3kUPkSD03iBNQ1xdEnVqcN3dwWVqqXB+qECX?=
 =?us-ascii?Q?0jD00DXelh7qG+6yOG4Y2ByOe9kMebIbBZxMNaLVnRvtBee0/g+Si/hFbJ8F?=
 =?us-ascii?Q?vxRvV8lyPoxkGLcl7KXh+3543IS8XzVjlHkB5MBIayGnUMy+3gbHcEk0T7Il?=
 =?us-ascii?Q?u6Hl88daHz1G2yg062FKdZA3WsKCXc4iAOdEeF8f3dPgXMRHURuqenMpblKT?=
 =?us-ascii?Q?UxMDGAu0jl4J50ISesfvvq2fghRk5TceWyRoaKXWDI55LdIHuSGND759+OEo?=
 =?us-ascii?Q?5po1Jpwe+bK5Vx9p4ifTIVi9M2jH5c1XTbQfYL6cIort9z2hjIMQ00xvNZiy?=
 =?us-ascii?Q?YQ7nvF2PyT4T2ppXlYjKaZ8nX7XiltNNbG1KHNoeyqU9AbTuMSZWsj8GGHb8?=
 =?us-ascii?Q?xHLHz9Z5vOoCC6SpC/FECbvY2zpjxiJES4e6PD3xB4UlyYZK6WvHNla0/zrS?=
 =?us-ascii?Q?3KvnHfwLC2zOZH4vDUxJkMcUlwH4HXyGuXUHzrWBBmA/XSqpT39pz6HIjYb0?=
 =?us-ascii?Q?N+uHNN37Mo9+U17tcm4F+GqEMiWEOtQF9i6spL8RnhGiAuBVpQsFV4nnEv32?=
 =?us-ascii?Q?iVWzy+DpCKvE2cIrNw2qoUWiZaiJ29cltl7km+dVLxyWoCJ7MheieVcFnjpy?=
 =?us-ascii?Q?/Vq1ydXtmZIvjFGLYjLuRsUB3gVxVt4jmSZfyxDXeqZdVh2YdWmm7EVSWb6z?=
 =?us-ascii?Q?+cv3PvGfy2jyfu43yrCLzOEeD/9avLVnl1zy8ITBZX4IhkzYC0wBqt6AXO52?=
 =?us-ascii?Q?wzvOk1c+eIY/cYe8sD04635Htp1iJ8iAN9u+NKq2HrlHJhZnvgTv79+KKEPz?=
 =?us-ascii?Q?2Py49c+4mhfOOL4QsAA6LsswjqHf+pLEMMlnum6E0pooC+Vhal6o5VL63BPv?=
 =?us-ascii?Q?nz86uF2yeUUh1ePHwLaaxcycAzpQVNHRS9Opx4qmS8eW/0j5vpbsbv1KVv3a?=
 =?us-ascii?Q?g5BfMKmmUB155DVNAbm/ShM+6AW7aFYSqr4C4kIdxP6b/WhUyL4juP/d3Qgb?=
 =?us-ascii?Q?e9Nb2npYxSCLeYqV80uI1nc+p2YAZ0bD2EC3SaAJmrlPWzZk7SkDULhf2+WG?=
 =?us-ascii?Q?UMgcqEAvHwjhqb7+cyMSnSI/++mwBaqAyQrt02Dr/EkdUMc4l4cSgwoD7tRp?=
 =?us-ascii?Q?1/cAZeH/SPZOQGpSJcFoEYnp0VEtQc/QX0fklU6Jnf36ivTY3T6782AL4qP0?=
 =?us-ascii?Q?cK4ZcYji+t+B2JKdm7xym6g1x5Ep4UJ7D4+jOTkU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd41845c-01f8-4260-c6da-08da87630694
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 13:01:00.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aUw86S3o6F4KpQjHppyGaOCr8Pona/q2t1ldduhIiX6kFKLN86EN57vWJYioG6R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0068
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 10:37:26AM +0100, Joao Martins wrote:

> >> It's already wrapped (by my editor) and also at 75 columns. I can do a
> >> bit shorter if that's hurting readability.
> > 
> > 78 chars above, but git log indents by another 4 spaces, so they do
> > wrap.  Something around 70/72 seems better for commit logs.
> > 
> OK, I'll wrap at 70.

We have a documented standard for this:

Documentation/process/submitting-patches.rst:

The canonical patch format
--------------------------
  - The body of the explanation, line wrapped at 75 columns, which will
    be copied to the permanent changelog to describe this patch.

Please follow it - it always bugs me when people randomly choose to
wrap at something alot less than 75 columns for some reason.

Jason
