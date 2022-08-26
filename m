Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8D5A2822
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiHZM6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245543AbiHZM6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:58:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72FF550A3;
        Fri, 26 Aug 2022 05:58:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik8EW9xF4mXgH6iYjPk9q5ipnxZeBbJLpQ5k11GqijgAdq83irGEmySOddlWRlA/jfCrtOagP/MIrkqC1r7iaEhsUBqUmpJnKEOh4KPf9yktN/VRR9LjI2nYJHBVhtao1bzZkH8C+Omoqe09S2n+YzlMSe6W7rpE3AQDeoBjFpYixPRkP4Ol+VmYlYPz/3WqbcrjOKdMMXV/19yLm1UG3AAen9KeJAjDdHlcfarxYTttdtiqPjeGZoMGz4ojbhjgpfHyp5wq3e7PuqlEZ0w9htcdpU8c8X1JrED/8YM1mldpH7AA4A1YvCoJXP9+zHYmbjQbCFckrEMDZHn80CwZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIOq7V7H//rULVlabaW4VmeeXYRcZ3M47eJyplbprmo=;
 b=YSUb5x1Q/ngbu28yMOMU1QuM4GP1c+BEQc7lvVJli77IVkG6nKNowebF/Nti+XHE1GOgktRMbSD86zjntA1UK4enToVgqzhlspkWRf0kwAh6OFzCmIO2piaUQQrfzbuq2tovZPWMq4ZDWNTEYZpJUKXSuUxLQNXuTkz0QhkOlfMXhpFiDfa93E+xce3O6EnvnwlD1ngTYBAKli9ifN6BlAqHnFAekpq2a7LYJ967rRLQPON27vkLj53wjGlXIYv8hZ58esmm9rjLbg3ilLtwB/NZDPCMQuKKnXVup+rPEydaG+caTRT9fxynZ0t45aFPhcRCibT/REMc43tOeRsVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIOq7V7H//rULVlabaW4VmeeXYRcZ3M47eJyplbprmo=;
 b=StE9jvpLAxkYzONz0eH4bWMr/lWP0sh5tZMMnHSxhzSFfjAqaBR+yECU1w7AFfaTJHYdg1z8oAw/V039X7WUxFJKJUpDaW2S+puabnhtOZzvAkdwi+uULj3kssPxCwheDe+6g1z2ZDZ8xbya1zp9gms2HO5vZpr0vlKzLDZa1o19vok8yhLyYeRjBvr88yFYhC9kffwHL51vX16g8h8VUfG4+pikGmhDZqQAAHgxVa/nQbkACVrQu0gIMAKIutQri0xyCiyCw+TmiAEA4ihURUpTMYWWq5+mMP3fJ0Lvuw3mPZ4mjbIU1MBwUu0HHatzBKdI+BMbJlvKKOTo2xeJSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5049.namprd12.prod.outlook.com (2603:10b6:408:132::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 12:58:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 12:58:03 +0000
Date:   Fri, 26 Aug 2022 09:58:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <YwjDWqNblA2gZRpi@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-5-yishaih@nvidia.com>
 <20220825132701.07f9a1c3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825132701.07f9a1c3.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:d4::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0afa87b9-2f45-4689-f48e-08da87629ccf
X-MS-TrafficTypeDiagnostic: BN9PR12MB5049:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWEwax7l5gOX7AyzLJ8z8Fre9c22Iz3UHSrpcyhDYiJSVu9VsIWuaTsopN8GuDHMcWGLhiSjUzo71MlahVQYIZa4MzRmV9Q0g3x6ccHiVOUpZf5KA7K4GpJDBo2XV8n8m5+Usr2NPii1rNobV/aW1A+SOWZ8pC1D1S89NJFIYnJpLEL0hLRHGGXrPV64/cW3zfLP0FDsJgEkiKq7Cs5hjoKps35S9PFHisVVtrXjEiNXO19kc3cjjwQkCLII1j4q5S5C5n38blWyZGAfeifXMadOgGI+afPfc7oniTj+Zc1qbp8lcX8kYJI2LmXkLoqdx96uGXjrlGDTiV7pokpMdgmwZiiGdxxzUQOeCkDYixv1zMReQBnr90K/lBs0BTKGjVTr71xz4U0zZc5P9ohCHWCpf0UkXXFSjSxk8cW0RA/KPPSDSV3FxXn8V46h0Rq1q0p/cdZAfhvHO+j+39yfndXe38P9PtMjf14kVMMqAM0sT9xR/8LX7Rf7yW4HiAOn/ruQK/tj5gwOXrLPhy1fKeKX2LI91UoYJXzwew+rRVW74BPZzWZzYZa4/eiRdf92GpuWBfgOcjqhs5v/jn5nCcFCa2yKJO1Wcf5zKO5drm3M284b0I5UoIteA57q4FiIwt94PPmzzi+LTM6uS3yzivJl6310G1Y+kdGQ2bczVRkhCagPZ0XSivCPLkHq/kVdQFOUa940BKnjcbT98kYFdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(6486002)(6506007)(478600001)(2616005)(186003)(6512007)(26005)(8936002)(2906002)(4744005)(5660300002)(41300700001)(6916009)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(86362001)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bJIwHwLLo6rXW0nVbWxjc305fDbFTxhuh+IB9yknJ4kwzsh8C+w+pgr2Hoys?=
 =?us-ascii?Q?6X3BBOWbIhxUVVjfzubgrtx4k/IHSpjOiQoXsW/rfKRs1i7eeQvS/2hAZvfp?=
 =?us-ascii?Q?yWLc9/OcwZvtGf1G3yy2ask/jexJv8/XDOo4KrbxU3KgoU801AC0ILg/xd9y?=
 =?us-ascii?Q?XvmTPPEW3MkUs031f2YnAGcKDQYge/KxFSWrETT3XShozeiiXjBA3Uhz9K07?=
 =?us-ascii?Q?P0eC0oUqwjTAoROrhjCFAKMVZjz6dg3fWpsqsrV6RNiHJX1kmV8X00y68nQy?=
 =?us-ascii?Q?36Kz69dzbB1LmiaLTwqSz3K4ZeAqhoqluqacNmVgnCp95F53FMd7lg03iNHD?=
 =?us-ascii?Q?uNxks3LwPcArSnP8086NujRsMtruDKilcNbuooi+QNwha0svXAnSNHOCOeiZ?=
 =?us-ascii?Q?7uqFc84dL8dwIft7vFcF5gX05u6wCqf9BSWHeZJoUxEzCAC22CTNcFXu6V6u?=
 =?us-ascii?Q?2XN1FS2URGoqVoIMXVFac81GUxIFznNTrDDgHbvYH07vm/vKlez+3YM/c79P?=
 =?us-ascii?Q?Je1K3gk1R6ee/fj5SG/5E4TlGenOyuS2OPOjDhTWaClQn9fmynWn9WDUBfM4?=
 =?us-ascii?Q?Ood/L5VIPeOptxcX+ZF0pFQsbjk7ElFmdcTosFVzDliegUSB3pmxUht/sFiQ?=
 =?us-ascii?Q?1JFlF4zQnduYAaMks1NSSX9Tdmj3P2kr/GYjSAy8nxEWyn5ZqAQCddIfPDcR?=
 =?us-ascii?Q?M9nkiPSXx5UDlR8QcGbOgCW4eVytvI6HFZ5qrbkf7OrKaKgRz2JPO71RBU+g?=
 =?us-ascii?Q?7mugQird9/T33w+05/lNsn1trjThvjewTY4AITikfXRFe+V6LoRvZlf1RK7z?=
 =?us-ascii?Q?sdmWMYZ6+kVMMJpbnBh1RUOsvV2vEXJsjMjlT+ph9JvmZ7V9WkSP6CObyH1G?=
 =?us-ascii?Q?2KgGyymKFZ7icXwq8M0n6zev/iWwGvmc/qZsMoTDDqjluPzLHUSgMiLmkGYW?=
 =?us-ascii?Q?H/dJ2SxwOFTbuQQp1MSTr41WZsKQKa4BMbIUBUWe0pj//UHk5GDaahd0lD/M?=
 =?us-ascii?Q?jNenvdKTny7xcUdPtlMPztEknGrf7eE8EUGL/PPTDgFn9PFnCokQIC3PYB6C?=
 =?us-ascii?Q?lQknD0FPxY8aAjZRqChrigxyLzh4qztWG81W6aOrdejy6knFSN6gSk79V1Gt?=
 =?us-ascii?Q?GrgalrbUQAwsTDZYBLLMclcp68xlsRNWnD203gSnk3NBkkl6ApBXmeYh39AZ?=
 =?us-ascii?Q?cVWlXZRBLZyyeBonGtJ8NDYTpDKft70Hl6H3nWHVMArEg+Cy8yUG4V/ohipl?=
 =?us-ascii?Q?aqzM8isNmg18e1zitd4t33o+gDvrXLaaTFVQuvCbgoirrCto8yQ1lr/RDPcy?=
 =?us-ascii?Q?oGP3xo/ihdWOj7xL9iaE1dMBpSo49ucqTZQCZqIRQtjBHCVt+uuTIFHRQvSp?=
 =?us-ascii?Q?Tjcmobi9/IAV9VV6MfZn9JZeKrrn7ygqwAxRJ6elRBm/06t+HQyKNG1g1IVi?=
 =?us-ascii?Q?i63m6f44/B3wOyzpSZAfC4n0RGdhQgPRLEIlzv+TsuIQukndDiZyZqJJQQI1?=
 =?us-ascii?Q?rq/0m6/cNvWZb97lsR6E5hW000jiDDMzv7SXF5FgNwqM/vpk+SBlRjN3JWLu?=
 =?us-ascii?Q?6+50sYJj6CyIFaiU31a1c0b7C1Bgf8zffuta6OTm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afa87b9-2f45-4689-f48e-08da87629ccf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 12:58:03.4859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzI9gjRSvWUYDInK+O1a5b9zwrKBTx/hCTnszzrQ8DQZuVJzWy5lHmiozQvm+k8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5049
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:27:01PM -0600, Alex Williamson wrote:

> > +	/* length of the IOVA range for the whole bitmap */
> > +	unsigned long length;
> 
> OTOH this could arguably be size_t and iova dma_addr_t.  Thanks,

iova, for the purposes of iommu, is always unsigned long:

	int (*map)(struct iommu_domain *domain, unsigned long iova,
		   phys_addr_t paddr, size_t size, int prot, gfp_t gfp);

The use of dma_addr_t is something vfio does, which is sort of
problematic because vfio also assumes that dma_addr_t can safely be
implicitly cast to unsigned long, and on some 32 bit configurations
this is not true.

As this is intended to move to the drives/iommu some day it should
remain aligned to the iommu scheme.

And also make sure there are the proper checks when casting from u64
at the uAPI boundary to unsigned long internally that the user
provided u64 doesn't overflow the unsigned long.

Jason
