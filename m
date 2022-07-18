Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEB1578DB2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbiGRWqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiGRWql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:46:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA7A2494B;
        Mon, 18 Jul 2022 15:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cc+IDQ8m8ErS+rDrTgjcJMHdDMqKQTC+VbXShvPQHcgtdj1JvlOy0o1GYp/7xagRllPs38xw/5OyRC7c074ES8ShCXhnWmuaQVvdEKz+yOBqEuVtnCY/3Jlzdj+MIIvy/OPfBJX3NWTzchesjYlQ6MapRXunLx1uxGhzdlU2q+szSbZ1nDZBwmpQbvPSDWt0JJD+nMoPrr9g0hKblX8J71zGBUmV6SjvRFIZgmFTi0xVmg175BNGR2bbiBNsS2YAX7Bm/6Hi2T8lxogTFPjZb+33jvvJyG24G8x48IdoR0dI447gsjQNDW2qI0rb3BCacU8jS9xnuzHbIYwj+y+N7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HK4VVtGPcZLDA8LIHCct5IhGMEJJlO1BAYatCYJ9Tbg=;
 b=c6SwdyoPVhzner0Bbo8nE1b68eLW5DzYXDlBJrfB4yqdS+3yFjf0dsdhnI+bJyFSfadRS/1278l4is781xFvo81iq+CmimuYYXNs2AJHWollc19d1LbYKi+WQMGXY0OR7/bZwAqo4BUFOv8ryrhmpwcCVf+BtkCn8lsSP7lMGu0eCuR3EmU9ZK6Z1bm1Z9hWH9gppnz3iupRL8/O5MLv6od3Grw0kq1cLZwEO+oeWfUmXRH4Zyqvn5HIKU/1VEk/09aXJyIrJuV9i//C2yq0aFJemkThC3/DbkTR60EtgUP9VdC4ZeZgHpONygC4VI01mzLzA9SSmNzgDIj6qFyHXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HK4VVtGPcZLDA8LIHCct5IhGMEJJlO1BAYatCYJ9Tbg=;
 b=B2epAXtbE/RGTKCEmvmbdxV/YOkH0wM69hQcYqDK0ExhNIp5Pc+unf9cSKY/x0AOpCl3LZlUik3OrxV8+NRRdxX/VaXriUVz8WLI5/B5tFqfnok5TbvrGSuzGBWWdzyioKuFtuZNBxxJaVt4H6TCP9o2C1T8tVdm8yrLhzFRyWVxJA/kcbMpwg5Xm3lxsRqoTOLYifarTrTLBUHwlEnwJXlkwfoJKRD4X8AmV7uLdGgP7bPAmUTNv66mjovJg4ovj/zS35+ovsidJyGsF/Vxo/GWoIQER7aWXtYR/aawQA0ISkdzgGZu67pKZLHyUaFGJmiIuKRvT3E0PSJqru962Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6665.namprd12.prod.outlook.com (2603:10b6:510:1a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Mon, 18 Jul
 2022 22:46:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 22:46:37 +0000
Date:   Mon, 18 Jul 2022 19:46:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Message-ID: <20220718224635.GF4609@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-6-yishaih@nvidia.com>
 <20220718163010.01e11c20.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718163010.01e11c20.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0009.namprd15.prod.outlook.com
 (2603:10b6:207:17::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1b8afca-5857-45a1-3e1b-08da690f5f36
X-MS-TrafficTypeDiagnostic: PH7PR12MB6665:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ek8TnX/hbzhaMjJ9wEEb9Anww3oDtH9B4cMPpQ0FEACDluFwXmHzhvqDKluZclxZDNccpqTVPQkDc3JilyVbxJFbO3k8hcBoSeZLrZrY1VCSXOqMqZuhaPSPoM9ADhOah8NmMqR57HBu52CwkQqxySau0NvkCVlmyjvBY67o2uH43yF1kHXVfF8hJru2S/SQPSHsCkEXn6d/jB1kOX+jqtJz3ihQfZl/Et/z2yRe3q6hUYwJ0x30sEjv/f7UjdffIOx52ZSCrriE1JSzWPp1CEEV1aFI7ydq+HNNLdMx/h6/MEpK0cNJca/iu25DWXU3b47JRrO9eQIipdYOVV78/Q5G63p0V9hFE5jqg3Rt097GiCeKzOgful7fABJ066kza1nGGUxwCRVvqszzHvcCr6lDeX4UXWYmWbOpZBt1c4QKcRY/SL7IFDkrFuNtrAx7whJzc1HBrxrzP0MEbKWgKSO9TIabhBk4G2Q4mdfgEtxjiQMcPqvBnU6qmS7i3FXrodwTf85dJkdx5iW3gn058NzmK13MsslP5yvK06UZ4yFBhqlWUJeAU+pP+6ZGLAr97HpYe6dGTyliM+EHuyYvOjY/v4CUxkWmqAbIU1V4Dz0llw30czWKCKFTU0os98rkpjbpCIaTItBX6Q0J2Z8gL4Q5PgPbx2I766dNfWl+bz/lEQqpn0xMlmj3/wSDEtqlxBOzUVT5a4gh1tt8JNddYNAXkdY6ahpd9ITT95msZHa3XK7PEs9t7l550C/LVFv0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(8936002)(66476007)(4744005)(5660300002)(4326008)(8676002)(66556008)(66946007)(38100700002)(36756003)(33656002)(2906002)(86362001)(6486002)(41300700001)(478600001)(6512007)(6916009)(26005)(316002)(2616005)(1076003)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kCc3dpxffXLg5TXXSe9S5W395pukeaWv3mSj1uF0LNXHsto3WafPoghG9m1?=
 =?us-ascii?Q?OAXZ9WZvap2X5oMOGToqLRqM/rTQ8syJYROXC6X7GW13+kVvy45KJ6t0fPYV?=
 =?us-ascii?Q?DwzRM6JRudF64+WVzQ6beCxAayqi44JfVStd4PkhydvQTM6U/lFpUlk42SDJ?=
 =?us-ascii?Q?IF6ttCkQgEHa332YpRh5q6relOBsDLP+sGRhOnQWhZ3Tlxr4FyikWpOEXLPN?=
 =?us-ascii?Q?ns2rssRLYs8Tl3x07D+bO1cjUNlPcYSvW5StrKG76aCuLgIRlUcHqqAtYoqU?=
 =?us-ascii?Q?7+OcKJoHB96t5rTI/gyZ25kElL/Wfo7CYMBkY9KutzPDodaGYyRbn/s7e7U2?=
 =?us-ascii?Q?UbYSDS7LgaY5Q5Ko69Ei3Burw4LC4JaylJWGxrQoA43oAyaVBerZ9BABAeI2?=
 =?us-ascii?Q?Q6ZnOsS141zIXJWIvEYE1r7Yvmx0aKHs/cJoQKViIRtF5JldVleqNziTktm9?=
 =?us-ascii?Q?5iW4lMJsI2U99/7m9u+C/J/wlGqpc9At2kFbSOK4VisZjdXxnFp1fuYhmQux?=
 =?us-ascii?Q?j0KFnQqj/NSjbPlySNmAWWIhBCLXJwRkGsnqKpiGtRVa4TJYrDt8SyEpr15j?=
 =?us-ascii?Q?v6fdXijcse0EBT3Ubz7IX64R1YSbPFuPuBW6ysmQuVMSSePrqxuLzLSm/iP0?=
 =?us-ascii?Q?WJ5yKO0uxLENWCrSTgIunYIorPcRvkDTuuoI44zxURXvsWmvi4JByn5RcTAq?=
 =?us-ascii?Q?f3OA+mCoZIVawbe9zNnQINDyUd5wMDdfJgErZgoM20R/klIG8EbSmJ9x1QYF?=
 =?us-ascii?Q?KQwTKie2bFUTN+Z14Vj8md0XqZN0c7fXcNCW7Bs540tFDh2p+6JOgcMf/vER?=
 =?us-ascii?Q?Lr5FPRIe0/KGWGXXQKumsVKPKqTbGOqh3PStFS/ecYkdpMJ4lwK9whUk0DEG?=
 =?us-ascii?Q?K/f3jfxcnAEXVEAFEC+Br4CfGlTsD0UuP41XuQPWgjw7i+rLKVzeHld3pox4?=
 =?us-ascii?Q?G1/rlQSG2pvdArHfdhsihCh0Zy2UGRIr+iY5VflgrpMmtIYsyQAbwlG9R3j+?=
 =?us-ascii?Q?PvsrD70JS87CG91iLgGa0lGtR9k/8TIChgEvQXWEH8hEyP3SycP3C/4Ep8wY?=
 =?us-ascii?Q?QZzgsnjqgBYHcjkxxn/eNrmN0SuRYIh5ssaRP2SGdMXny86l5ZpmVPfYW84P?=
 =?us-ascii?Q?yaKoH5VKvJFDrhkcdEcVG+CfeFBwOhfZAenvi6v1SNRHI1Tjswz2gnD/v6zS?=
 =?us-ascii?Q?W6XuEzdKmdEHNfAYL5hQW/jfPyRgdUVRYUcpHCtOfctWswQ3kFzYMxlzrDPp?=
 =?us-ascii?Q?bTj4fcG4GPDcXilGLytF2tXtfRmk79Oy/8TAAS8Sz2Waz8nxBt92ceptGRdI?=
 =?us-ascii?Q?w7nu2w0JwzuFedYodqu8f5MNbaTUhHpkHhIREQMKI2iC2aYWXmfpOjBxhMBX?=
 =?us-ascii?Q?lfKmZThldi4vnh5noDRwRa5+ryP/Sh79OkSAexra7xonyLoJ0vzRkEBQvIAc?=
 =?us-ascii?Q?0BaeMvL4dPeIkiuNC2pjcUK6j3IiOX9KfG1jWdZkMYClp8jmAh/M3x/thrQR?=
 =?us-ascii?Q?+NgLTGjZAi4Qg9/4Trajkt5RpYtv3/QEZ5pvcKgMcfa8a2XXUS9MGwudrQ/9?=
 =?us-ascii?Q?pRARt7+dULuGVXkgOYSfTY1IBNwO0mPqgiXa+DqU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b8afca-5857-45a1-3e1b-08da690f5f36
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 22:46:37.0568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5RprBf1lf2UXJQehOHlLfYJmyg6DqeuEiC2Q4Z73SFEF9OWbzik/vveoo4S3xJk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6665
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 04:30:10PM -0600, Alex Williamson wrote:

> > Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > ---
> >  drivers/vfio/Makefile       |   6 +-
> >  drivers/vfio/iova_bitmap.c  | 164 ++++++++++++++++++++++++++++++++++++
> >  include/linux/iova_bitmap.h |  46 ++++++++++
> 
> I'm still working my way through the guts of this, but why is it being
> proposed within the vfio driver when this is not at all vfio specific,
> proposes it's own separate header, and doesn't conform with any of the
> namespace conventions of being a sub-component of vfio?  Is this
> ultimately meant for lib/ or perhaps an extension of iova.c within the
> iommu subsystem?  Thanks,

I am expecting when iommufd dirty tracking comes we will move this
file into drivers/iommu/iommufd/ and it will provide it. So it was
written to make that a simple rename vs changing everything.

Until we have that, this seems like the best place for it

Jason
