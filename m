Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B74C312B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiBXQZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiBXQZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:25:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFD51E111A;
        Thu, 24 Feb 2022 08:25:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXSmfL9ugb1HMyyCAdu5iqX//MCqfkMrJ8sjrFJV5qmVC6nkql8plLziKF2oA08f2/LaA+ePpTM5rmvaK+uhhp2EYh6w00GEh1BSp8oODZxKgMvOSueXIdFgLIjvY6pYQHXOjFcWhLM+q6brTam21qPlU8yoIWxi62EPHU7ZkvE8d2EVNcNFEOuo0UKZVvzB2ziJC6iDA/jXz+3P1ZEBCt1bT0MXpcwzS/gxYU74bjJFaUp5ZD5kTYWbQV6UgTr4AyNYxCzbUA6NSdQxQpVce+X/9YLMSisCLe6bJI2in+kIKSdxLxPAzwYBmx/lDBXdhfclPsSfJMHKDgpck/sZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff4BvZ6o1s2XHDpW7T1brFVz/WbFgTZL3LyqKnZmVt8=;
 b=G6VYqmec3to+9f0kGhRdP22UN4JxisRPWLBFomZVYUD+xwHMM3ov+3UN2d3aWkit8l8ath6mVLVo74e7lavjx1sPih5yMxNiQvN/soTuJUqb+dTHpfzXZnkltQrRrEs0u8S/3+Ervjw21kHwmrhncsRwP9aTuj34LTIud4QGZea6X9npij5eSkPNXoShO63vfQzEktFJ+zSi3UpGhOHNHNXqeJh53OmEMhgEWF7jRpoAfPGL72Aj0PTi1JUOwMNKB7YZxJrlJ9Brr2m729AqwrXXbYv6ZhLGD4UnYvrGzWa39hU+l/2VoSMcCPnYN3vdjL3vTG3a8dGDxZsmOU1uKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff4BvZ6o1s2XHDpW7T1brFVz/WbFgTZL3LyqKnZmVt8=;
 b=TR2jPVQwzSsgRZ5Ohy4VQ+idp/X+JDR/yw345fDOngR25P30Ncm4HzG7Dxfknlcdqc9ubC1XOB/TLEPiqhN439/zLWsBSZLsLAA6u5wZ5jL1EgsKD96UwBjvU55woMhszaiuxANYcwNmdyXJketCSosQq89CxMutjunok844/1Sdd0Xl1YjAJysUMl1WgWiK3rHYgr/jQ3cGlh3zqInx5VXnq7XsMhx8KnTK272EhFN54Ib1ASNAmtmmaDFEZhOQDlvH9vuKId8a2y3oRf6pRoY9RZf5/WYLrqAHZAopAZgrXkZ4ZxZ8XHb5LVjOJuxHezZ8QKmb9LDF898ofrPXdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH0PR12MB5388.namprd12.prod.outlook.com (2603:10b6:610:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 16:13:32 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%3]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 16:13:32 +0000
Date:   Thu, 24 Feb 2022 12:13:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220224161330.GA19295@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-11-yishaih@nvidia.com>
 <87fso870k8.fsf@redhat.com>
 <20220224083042.3f5ad059.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224083042.3f5ad059.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0007.namprd19.prod.outlook.com
 (2603:10b6:208:178::20) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a6cb415-6282-45a7-4a41-08d9f7b09a4c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5388:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53886E5FADC1C0AFA64ECC0CC23D9@CH0PR12MB5388.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYjH9V0HFTTq6hxtfVoYFs3E9uLfDZdyccQ9MdGYXZIbRyjjHzFNuGL6UL/xP8zZX2Eh/+v1rNph4+FUlIHJH1/bvNFyBnxP+vzdNDd1KoaDackWOUtN/PZCyH06P7p3x0oCR0WczF1/1/nV+e82yhfQUlnpsuGWHlzLJrUIGC2/paWFNU3iHMeBD7fTvK5Wp5Lc6ynKzhuW483PHVN4mvZoMBKukFjnII1ANYW1umgOk1yrdmVUqgPsP+e7rN82fp/5qV2vwgnE6oFvNcZBSbIQJkDqKWSoc2C4b+cqAYII+OeukjbK3D0amXUECWFOzRAeVPgnyLNajt38JHZzsf3oBMNbLbTOz1jm2Yg1npZtmKduJPfr4ldzPoPXcl768GCaDYU+/d25+iJGpCPeBQ9hTnwQhR948N2OBywuK3LFWomnqpl7KJHkzK8oMpCDe5ztRh4gOSAuEq4yzE4fNUXnU7x/FoLmLxECmJmAynjnCOk5fq0NBtGhgoM7v4c8FICEdYC9ybvqsy5qE7lP7t2D7ybn5DqT2G8uyTl2H0kZ+/oM9BM325m4Z1xbJDQm23ZgWPKHphwNjKSKEYFAzxFQwRaexO+6YxcfvUM8p/jzJiI876wIClgviUhJB3AesZiG0M2OBSUo2dEIn7dk4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(6486002)(54906003)(6916009)(36756003)(38100700002)(7416002)(6512007)(186003)(6506007)(8936002)(5660300002)(26005)(2616005)(1076003)(2906002)(66556008)(83380400001)(86362001)(8676002)(66946007)(66476007)(4326008)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qRHyuxW/s9MZVE8jK1l42B6snQMWeGecWyWkOECZ5eHCpYJLN19yYsEhTGcS?=
 =?us-ascii?Q?+T8Vtc7mWZRQaL8HTzp1s2kbZHWdZ065/JMPR3yc0gCgkNFsSlXCFQjPIM81?=
 =?us-ascii?Q?TFmaZlgBMOE7NApqlEaOpU+DdNy24Lz/hTYOgHsyzEiz15vKngIqK0hobz9o?=
 =?us-ascii?Q?CqhpinM6JET6tQ9U2XwuwerUlDkuh4ScE0hpFg31/Ybgl8y8kIdjl1V0l+1G?=
 =?us-ascii?Q?bIcnishIPwL7smr87maVEUm4bjhS5UkhGfSAvL+Xpm2e4sXz62TlSNUQWE20?=
 =?us-ascii?Q?69a/Gs0qMwHHKnn9I7iGMJTBiK5yHOR1lOu+KPkQm5rh1xBhlaY24cuSY6hy?=
 =?us-ascii?Q?iiOHNbjzsEsA9zT1OL0WeoGfV1MHQrtZlotIK8Y8LOatffry536ysVRjHRfG?=
 =?us-ascii?Q?dc2La9QkN2uVVxuIBmbyQ/DwmWZJN7pb4Fbs17/9bYpbRzi7W+Nohf6i6K1F?=
 =?us-ascii?Q?ArzhMDG/CB3f5AyXWP5cDc8kLI6XSSszUoxDFon/WE0rKmgNItefXqttZMbZ?=
 =?us-ascii?Q?Uc2kliRHZTXOF1rvZRC0xIwchCQykeacY7ef21oQyxOM67u6PAyh58kzJLtI?=
 =?us-ascii?Q?cucCcJIoM+5XEA3WYtkfv6iLL6pFTWekn8VTwtX4SQsaKYN4rI7yr58/gEY4?=
 =?us-ascii?Q?zPtKlLrecRuPELmK9ECLYZ6ZIhq+yFmKtjp9GmSGXpjVjyZfrYWBJhdg3plv?=
 =?us-ascii?Q?7iEuAA4UUVIMkeg66CobIhZm3jv1RmS1tDnFshhKRirT7aJLT+C5LS2PVjft?=
 =?us-ascii?Q?HDhnWMipFii8xV4dGAAidKNqqdVTsUgSQ5iFqFiPfpkCgDJU3v2eD9I4BdXq?=
 =?us-ascii?Q?+a2YcW0UhCwYZK6rtYD+vkdK7UOMUDw8HPAdbuD4jxAzA96u30oIvGTkzwng?=
 =?us-ascii?Q?7WVtU3cyd8GQjt9HDBS8AlBwqlX4C+2Hg8WwiPMWG3Ce+WbqFZDivzmOjSuq?=
 =?us-ascii?Q?7tmuPnePY8PmtmuT52pHjF0s/HR2F1s/dlhSpPn+6Q25fgIDYDw9h/YKEVfZ?=
 =?us-ascii?Q?HSJauLAAHaReYoAQN6iKo9xcKwP+8BdfcAS1rWdDuRSxTNOE4BalnnLwAQlS?=
 =?us-ascii?Q?Hw0SkJPC7I5J7KeHZDSWIGPwqaqCHynWfeYIhjbpBg0QGApaGdhhLZsfjF7m?=
 =?us-ascii?Q?m0dik30o70ZJrdJSbSsE4Us3JcqCkS0HGlO8q4HSx8Qe41OgYQXjI1emvTj/?=
 =?us-ascii?Q?8M6EWFpG3iUveafcKChkyZQ4afHzuE/LSsYh8SMeHUwFtSbVuTxeup19PC+Y?=
 =?us-ascii?Q?dAp/pe+2gcF1F/as3laSucNLomvdMCdb7wt7cdoMpP1iB9fqd6AAnaXacPAR?=
 =?us-ascii?Q?39Uc6Zo4MpWLovOsdPSAYIOHs6Mj6tocrpB+8ufzd2op+hw1ATsOv55nvgPU?=
 =?us-ascii?Q?AdPQX98svstmQ2lrfnAmjOhBrcjZIBnuXgKqLAh2icDRZDir7igKpXkliPSa?=
 =?us-ascii?Q?RE8jIZfQchmAEn0hzH0A3mYKOWEQJShzOA4SDE60Yy+8LXeBs5sd/toZBIc2?=
 =?us-ascii?Q?RC7SKbG+qVhSqhCe2TlZfRHLm/Ctt9F2ebhUDvt6LgEp98IkqUtJmPU7kste?=
 =?us-ascii?Q?rcD5TyMN6D5z60QOGlg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6cb415-6282-45a7-4a41-08d9f7b09a4c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 16:13:32.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CD/2jRvleT4MuFTEtsk8i2gUjCBtj4K7Y6BJYRa8qdHAfnq7Ha8N52eZd4iThcfR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5388
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 08:30:42AM -0700, Alex Williamson wrote:
> On Thu, 24 Feb 2022 16:21:11 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> > 
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 22ed358c04c5..26a66f68371d 100644
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -1011,10 +1011,16 @@ struct vfio_device_feature {
> > >   *
> > >   * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> > >   * RESUMING are supported.
> > > + *
> > > + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
> > > + * is supported in addition to the STOP_COPY states.
> > > + *
> > > + * Other combinations of flags have behavior to be defined in the future.
> > >   */
> > >  struct vfio_device_feature_migration {
> > >  	__aligned_u64 flags;
> > >  #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> > > +#define VFIO_MIGRATION_P2P		(1 << 1)
> > >  };  
> > 
> > Coming back to my argument (for the previous series) that this should
> > rather be "at least one of the flags below must be set". If we operate
> > under the general assumption that each flag indicates that a certain
> > functionality (including some states) is supported, and that flags may
> > depend on other flags, we might have a future flag that defines a
> > different behaviour, but does not depend on STOP_COPY, but rather
> > conflicts with it. We should not create the impression that STOP_COPY
> > will neccessarily be mandatory for all time.
> 
> This sounds more like an enum than a bitfield. 

It is kind of working in both ways.

The comment enumerates all the valid tests of the flags. This is not
really a mandatory/optional scheme.

If userspace wants to check support for what is described by
VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P then it must test both
bits exactly as the comment says.

In this way the universe of valid tests is limited, and it acts sort
of like an enumeration.

Using a bit test, not an equality, allows better options for future
expansion.

The key takeaway is that userspace cannot test bit combinations that
are not defined in the comment and expect anything - which is exactly
what the comment says:

> * Other combinations of flags have behavior to be defined in the future.


> > conflicts with it. We should not create the impression that STOP_COPY
> > will neccessarily be mandatory for all time.

We really *should* create that impression because a userspace that
does not test STOP_COPY in the cases required above is *broken* and
must be strongly discouraged from existing.

The purpose of this comment is to inform the userspace implementator,
not to muse about possible future expansion options for kernel
developers. We all agree this expansion path exists and is valid, we
need to keep that option open by helping userspace implement
correctly.

Jason
