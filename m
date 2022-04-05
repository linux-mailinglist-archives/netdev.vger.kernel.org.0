Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31294F53C5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452841AbiDFEXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838569AbiDFAzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 20:55:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EAA19FF40;
        Tue,  5 Apr 2022 15:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkZ/4pBB5toWP6OeiU+1jwhJmWLMu1tH0B2xQFXb3zcBytlqLv8TxA6JuFZZb2ugYgnq3JU3XsHikuEVUcG/zRo8ufYIx/HBH/4OCgGZ5Fy4lmVzNTcsCAedjUVNh0N7/b3YWlTgrPUuoLmOyK56beHAU2cMdRIpJDmjlGQJeW1sbo7PJNSGMEDeHJ57mqOgWEBT6tmBVYzzz8fAmM5RP7tCz8zdUhsD0B7pkl1CNomkMdPY6g2ew7XXCjjrnL9V87QBnS9CkTT4DhVEcmmvNm+xuORk7Y7bxhrvvUeJ1LzFTrFn13RDcSNw5+VDhz9W3K59WZe3Q5+h5fCLebw8xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvnP56WZfmDZ8OOtSptEBTdkllR7kIl0OZ4FSadH0c8=;
 b=CZgreFZa11Ne8+7/I4B6mpb39ZkaX3xHEQMrYpsRsdoAvhJxZ+dFQX2ToQvREAOdyVyQ9TkVgY0yKeF5giNu77+V5mja0Uye00LcS+fJyykKXvtKXXG0kwuFPI7ywrb1Uxh3pHRb17qIk8sm60fuWMMN02ZOT6i416teIQn3HAhHtN6q8C08ZFHS6JDOHAjaPy8gKGYTq88rZgqywGwrElWQ8Qk6ThxEgpX4iKDskdtb99HLNESCzjoYBX+cw5z2OWES8ny0Q7JFNd2lUgTnDKlV6Th1Tlc4vYwZVzoWxPPb5BZpu1gMF+0qDp881F/BAMZpaFiOeTLotMW1LndNBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvnP56WZfmDZ8OOtSptEBTdkllR7kIl0OZ4FSadH0c8=;
 b=S0ceSEyLSP52sUjwpBtOq6OsZ7Fyxn+eVKkONs5q0lfWjdgjjPZMQduVv5sy3Y6BwySj9xZ1oHxWL0Q/UqVe+FqSvCmZFmmHJ0cydbPZV0cwUfhQuKOrtc9V88mXL9mSvYHco1e+N8+2uRna5WSPTLCNRR4f/54A56QRrgyBNOxYPI8SWEfDUWPQijWp7JL00x0kxh85BfNrhYTjjPYevA+3T01Os0lERkVvflz3vCOHWPSJ5HQCHSw7iIU/Xk8eIMEI4UjeN3ffbeFEIzsKwhKe29c1c998dGQlVzI6pUTmfaRBBUgrFpMYUMf1nn/qdYp9fCxUgHn4rjOZiCXgGA==
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by MW4PR12MB5666.namprd12.prod.outlook.com (2603:10b6:303:188::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Tue, 5 Apr
 2022 22:57:42 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 22:57:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 22:57:41 +0000
Date:   Tue, 5 Apr 2022 19:57:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Message-ID: <20220405225739.GW2120790@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405135036.4812c51e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405135036.4812c51e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:208:23b::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a7aae92-6df2-4873-52f6-08da1757aff6
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:EE_|MW4PR12MB5666:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB54271D0E7FB6366155518102C2E49@CO6PR12MB5427.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ix8JeI2N/Ndb9xmCk3NfY6f/gI6n9SLRVP3lEMwBQzmdGRJe4uriGAJDqGrdSiz1wxFSQarPBxlq8wjoUhftyiBGdvxvqwOYEDj81yx2GF9C6qcwt8v3ZP/ypuVEkgcIV/4AcEKb5tgQPL+voL4/Yzm3bQcs6IMv8/Z7bPy2Kbs9Q1PK8RCERgKr/WxPCEj2dXrdjXwtEg7opTT/FxXt9h4yPWoDtf7ygmOzNlwjVFNdA4PzBIRBEjaSdNgzwryVlcVonulYuxSYv5w2FWHz3TZxkf2Ybpav0km5iHwgy2ryS8xE91EJHBRvRLXnTAqhUXriSgaQF7UaUwpWmtDhBhJYVQprO8/qolLR0ekgdHxpyLyKVdFAm+qqfdmyswrVPF0iBz+2zAulZQfPIpWQcr6muo4YOHliYUKiF92tF33igB0odKpneDSvKyPTBwaNVCM/k4vkkbVM8Q5vLu8wgaQ8v9UbQZxarItslWfzL0Dv3pg5FeDNuWgOu8Q3d+npous4c7BUcSrLw/2TUP8rlUOhjhuFUeUM/qiVEhznTYPlOn1PLPJdc1bbB8f7VL44nt2ssQeEPfNwvSY7W1GZiG+FqzsYvrd0CJo4pluy5DtKKZ2KtOQInRTfRiyfSyyLX8j/DjHGcv4cj1RY9dApA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(2616005)(7416002)(8936002)(6486002)(1076003)(186003)(26005)(508600001)(6512007)(33656002)(6506007)(2906002)(38100700002)(83380400001)(66946007)(8676002)(86362001)(110136005)(4326008)(54906003)(316002)(66556008)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SBlTyarK3A5tNgPtSxiL4psvEoca/eFzwR2umuyfy+OxlUoW8kJ+yPz5yDy9?=
 =?us-ascii?Q?+4Z9P/nZWKpiOj63iThFK8GPDQxn9uoekE/dks+WQskHugk/m0ygZfx+PL2G?=
 =?us-ascii?Q?Vw6cJbILbHJEgY6Kz03rX403FR9ffiHulaJO5HADwYZYxjKIY3ZM//GZMxyU?=
 =?us-ascii?Q?bRrx1cZMRd5KKzdG9NEwi5w9PotryYxvY8kFZScrlKmiYqjTc4RfdpsSEHuO?=
 =?us-ascii?Q?oXELM7S7HoJQ1UaiVNny0gnhUL1kJHDMOunSbPL9YyGVaRpK9MuUxYw7umnU?=
 =?us-ascii?Q?ZpmQHGi3IxNgurXqcg62Bj0h4xdPJHQXPjh+lhDv+ErxO++/srxVeqzG7379?=
 =?us-ascii?Q?NuROx5rZAvIAxT9QKcsSYwncUWm8sUizC8+FFdoOq4Si5N0k/d/9zIZafEY7?=
 =?us-ascii?Q?BetKQsJ0ywG0zfGIxz8kFiG9PXb3RQ+mqxSifptDQDFYzFtO14c6ZgTAsPxt?=
 =?us-ascii?Q?TsFNY4E2wC1fyIeaVRIYA0Aiy9BU6jhdP3K6XpFuxKfvpoeH9Es9qx+NTNCq?=
 =?us-ascii?Q?GuyIAzzk5jWk0EbaxuoOZUbwE7TI2I6AIE62qi49S9KtzeVyejtFlb1xq2qt?=
 =?us-ascii?Q?wS3T0+2Z7jQopa/dGHRKAIB6zx7WPiO+LoAKGkEe93Q3sriPJ4knQi1qPnxX?=
 =?us-ascii?Q?bsXwAxv09TZczC5u6aDdiF1zB9yYB6ilC9npRATG7cfKO2BSS5dnHaTX6u+G?=
 =?us-ascii?Q?huosj9vDr/1puibqcFfPEGi323DxGAtR7JwEymA0tLhc5liw1kszP1bgR5Iz?=
 =?us-ascii?Q?ba89BDsudJSNUEgcWBqWM5r54tVG9fFjbsfyOYoBViYzMSiqpPVjhcXo4Jj2?=
 =?us-ascii?Q?7S5LU+VvdNgBtkVYvpIotIWzSl+WkTr/8Zdpu0gnZjEuW5BuAi71moyGToj4?=
 =?us-ascii?Q?hPp5S6vEtkGBsq8FQ26wsrD3BSjc/nuAhh+r8j9RI6jqukYSihQ9uz+u2ibL?=
 =?us-ascii?Q?e7vYLUAHuhal6LexDCBJnyLKRZg8tpJgixl6FvjKkRWZT1ugnKbNWBq0y4oV?=
 =?us-ascii?Q?0phWsdqVPAkxCrmPji7Dcvr6AjsNoOufSjFmhq0tzwjwb5aJfi9vvKmSE43z?=
 =?us-ascii?Q?Rjolum0jOwiPTmTTsTtny3xt2zURjsow7F3KLOpmz97Tjc4BIPeLCkXUoA14?=
 =?us-ascii?Q?AKdoKuKGeA+Ni0eXRA+9mzspXM2zgI35HL4ZhC47AOud4Nu3VHV2FGxaOmf3?=
 =?us-ascii?Q?6b97kz5pj/hgH8Dk8kF4H0SU6eI6aj5GawltfcjDcr0wTs4a9FJ/LQJdD3le?=
 =?us-ascii?Q?Np1e78emQI2O270Lw6EqbHdEc1HEFd8zbYakEgj/TTOjXwXwmwqbdVw6Zv+t?=
 =?us-ascii?Q?sfSZZwX8CSSuco1vr6GYCFxtfsHJ+DmkbE+akD4uQoXzyjnZhtADkv0Ocove?=
 =?us-ascii?Q?mWWbHNv5uif0lUg3x55194lyjnmgExt45zES2JFhUDSi5f6Vm0DloMxYZzxl?=
 =?us-ascii?Q?RLW2kRogIxx1wdIBGNgsKIuWvJBgT5p5CULlHmsbyOoz0uvKng17+Dc8NJou?=
 =?us-ascii?Q?A6CDhXkS+1GO0hOjK5XmShh/PB7mvklrDNVIt0ej/qD9el0VWOjGlh+3Kv+v?=
 =?us-ascii?Q?PXCKFt9vQAIJL6sMy3BE9XEFXi7MqY8fY5r3daKJLsebLjsnKiq2KXTmeMvD?=
 =?us-ascii?Q?rd1/8Ji78QKjBoAY6ILDs9s4GtDlNPOizMgy9t7LpMqzRwQPVoTKSKiY2mYp?=
 =?us-ascii?Q?82hfODiHSBWxlf5q3ZYTv8h/4y0wTwsxtAdhz/u2rDFHE+9kmmk/tEhvZRML?=
 =?us-ascii?Q?UqCIxqWHeg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7aae92-6df2-4873-52f6-08da1757aff6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 22:57:41.0126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxkYDUqfh83dJ3YBNn6EGEO1+fZcMjCY7DNnzmFxWgBSiLVnz8T+kprVf1zkj8Am
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5666
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 01:50:36PM -0600, Alex Williamson wrote:
> >  
> > +static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
> > +{
> > +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> > +
> > +	if (!dmar_domain->iommu_snooping)
> > +		return false;
> > +	dmar_domain->enforce_no_snoop = true;
> > +	return true;
> > +}
> 
> Don't we have issues if we try to set DMA_PTE_SNP on DMARs that don't
> support it, ie. reserved register bit set in pte faults?  

The way the Intel driver is setup that is not possible. Currently it
does:

 static bool intel_iommu_capable(enum iommu_cap cap)
 {
	if (cap == IOMMU_CAP_CACHE_COHERENCY)
		return domain_update_iommu_snooping(NULL);

Which is a global property unrelated to any device.

Thus either all devices and all domains support iommu_snooping, or
none do.

It is unclear because for some reason the driver recalculates this
almost constant value on every device attach..

> There's also a disconnect, maybe just in the naming or documentation,
> but if I call enforce_cache_coherency for a domain, that seems like the
> domain should retain those semantics regardless of how it's
> modified,

Right, this is how I would expect it to work.

> ie. "enforced".  For example, if I tried to perform the above operation,
> I should get a failure attaching the device that brings in the less
> capable DMAR because the domain has been set to enforce this
> feature.

We don't have any code causing a failure like this because no driver
needs it.

> Maybe this should be something like set_no_snoop_squashing with the
> above semantics, it needs to be re-applied whenever the domain:device
> composition changes?  Thanks,

If we get a real driver that needs non-uniformity here we can revisit
what to do. There are a couple of good options depending on exactly
what the HW behavior is.

Is it more clear if I fold in the below? It helps show that the
decision to use DMA_PTE_SNP is a global choice based on
domain_update_iommu_snooping():

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e5062461ab0640..fc789a9d955645 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -641,7 +641,6 @@ static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
 	domain_update_iommu_coherency(domain);
-	domain->iommu_snooping = domain_update_iommu_snooping(NULL);
 	domain->iommu_superpage = domain_update_iommu_superpage(domain, NULL);
 
 	/*
@@ -4283,7 +4282,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	domain->agaw = width_to_agaw(adjust_width);
 
 	domain->iommu_coherency = false;
-	domain->iommu_snooping = false;
 	domain->iommu_superpage = 0;
 	domain->max_addr = 0;
 
@@ -4549,7 +4547,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
-	if (!dmar_domain->iommu_snooping)
+	if (!domain_update_iommu_snooping(NULL))
 		return false;
 	dmar_domain->enforce_no_snoop = true;
 	return true;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 1f930c0c225d94..bc39f633efdf03 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -539,7 +539,6 @@ struct dmar_domain {
 
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
-	u8 iommu_snooping: 1;		/* indicate snooping control feature */
 	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
