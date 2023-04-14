Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B436E23B9
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDNM4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNM4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:56:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DE56E9D;
        Fri, 14 Apr 2023 05:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTtmKt3CIOwrpeEWCtbOsG/8zMw43H9Fin/0PMbgl/Jhl1n++NkHdNOiAvlUO3mukChx0srapLSdvRlO6c23GmMr4SDjjVk2mJANbxuTZFMknb7vBljFD3xPWRUX3Lz7PETl3UrvWw3BFOpqqJcCzKEn6ZfqItxLeBMfv4SYpk0g8iNwC/QXQY7DX74QsIFuT086vKmCi/ANLXfSyeVfI+qwUaD0JVqn4EdH4630BzqBN+hv9lGRXqy7c/V2S0tVC+Be2Vl0KoahiwXF3nb/VuT02BtHNDOsIh61m1XxXQS1cw5I/M6hNVLBumsp58VUa/mkAqK0aVYhMjxemYUJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7UaF/Oub/EEWbH4HRFsjgzeJyvLB7cqAtxIJWVz9qc=;
 b=RArXsTxP5g7QW/okpVuCjHx0f2lr1cIe5szMpSFslqi3ua6zNc9OH8STf23khmS+P7p66fw+ozg4aFsJs5Dcl6yQulmExNtyTrBimolIJfpYyQL6VKKEV+n9WyoSE0XwsPlNRCRoqzzulcmLcoMOyN6i1hsta+kWOYfTy+txwDaXC4eur1/O6a7Rly81j0ePUkCMcUqbxqtNEu604dvnSQGspYWs5H5BaqWWBmpgytKvyIBQlWGaLA4h5y0B1OtL8hKS0CA8zd0eQBbLVNNNy81lW0gVB/FVGKvihhtdTALsdvZdCpyQuP4WVnZRBo/OHG7+KsQ4iBn0HYichghW9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7UaF/Oub/EEWbH4HRFsjgzeJyvLB7cqAtxIJWVz9qc=;
 b=osmcH0KXG7F9D43bHnsUCn/DXU+mCtRqU89eevdXfUdU8BDS1Z/R7s1lqV59nRp3UO9INP5HKDGTGS9jmW4euFNHso7XFrUo6EbTY8pBgTyQ9n7H+vQOGljrWXCZ0b91rifj0BRmJS3OnRrilRVbkCHmov1BFRwPTICBsIaP783/tdxBnSLy/l+6X6q0wt1VSdZ0ZjVWfmq2RfpS0BarztofHXrnc5Bn5guSa6EkJzzb6Y+0yFtEc47KjkQaxKkmZcf5c0ToTlHrkmKYzVcqeT5NKrhf4gx6xi3mcSj1PfRH+dCkVR0KPKo9Cb7LrhhTUVqstk0Gy+X5XCA0OjKLBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 12:56:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:56:30 +0000
Date:   Fri, 14 Apr 2023 09:56:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 6/7] vfio/pds: Add support for firmware recovery
Message-ID: <ZDlNeyv/HLG4SPwB@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-7-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-7-brett.creeley@amd.com>
X-ClientProxiedBy: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df55b07-5719-4a93-24e1-08db3ce7aab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //oDjXPEjjDn13s1i57tpPn3oYA+//v/BuuNcRKP0A9eu3d9EfJ79IRJ5/ej78KB7OQdnFc8q5pbXQMA7+em+SgiihVu4e/Y1nbrB73tL73NJzYpFI3y9OqKSkOiVtJCMy3/Y+eyYoMo3BreAcOCCXWiDqicLuXZ8U91fjOaUWzmWyt+wesw/fh9ob9BxbyoSakyOTgx+/M1n3/bQx+mTZKRjMpNy/5Ds6SbCc2vpqI/7A22zNWH0MLFUUnJKW/UuMG35YspsApJIcPd0JJPIUMKnH77Q+dqUkBN6w393s7V4aSZVCZv+z/tZVkCgJX3aLlKQMp4KeHnFodRMzVU5YHHv50y+mwjb29ubTttzMhCZI7uAjqoFfv/LiYPs8dw+82vGWfhbY6OhPhhqao1NLn7fHNh/tdsxqHU82SgzYzKQqW/hCmY9nFO5cYXqFY1YF6XgLl/dSFMb8/VzU4wjys1CjLLPYWWdGAHlOMoXOEsvApSp5cWLYK3szc0pIkmLsYfB35C/oDMV3P0wtxIFrs++hcTXtzNvRXJ8k7aa2vonOJwSjV5WKW73IWVxLWK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(38100700002)(478600001)(83380400001)(6512007)(2616005)(6506007)(186003)(26005)(36756003)(6486002)(6666004)(6916009)(2906002)(4326008)(66476007)(66556008)(8676002)(8936002)(86362001)(41300700001)(66946007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hgWjTIonl2lKrE5vQXP3Wg0qM2TB9LgsAbqWT62Ou3rgAqMPH8bb1VhgXQVP?=
 =?us-ascii?Q?pzZhOP3UFPSLUJ6p3QC+m5o3MA4EzAzMGbjGM/yyP+3wvr7UQBv5UX1MMskr?=
 =?us-ascii?Q?Q2EJSrp/2pgOXSQ1iwwPwaTxVrS6GxcYyVnGUNO/qqFZ3sNvu/xIbwEkpd5N?=
 =?us-ascii?Q?d0bqUdz2DsNfb8X5CFbTmVHjx3cCAXcOB5EhMGlpFCXR/I0FT3DYuoSJdSUd?=
 =?us-ascii?Q?FDajg+sMO5LadK/WTNLop/0gvlFKyzV0S5i6jp96BdwIXOlwsFVd0PSMp1TO?=
 =?us-ascii?Q?oj7lUpvil/LvO0AAQ/J3VTWuSc5+yyWmJhxTbZ/YLQEE6e4zp72jKlbQun6j?=
 =?us-ascii?Q?343YWsc6cp2pK8sYP0789QHKVdTom5KE0njSLffqRCZLNcfWBeIaY+yvhYjD?=
 =?us-ascii?Q?dtZxiZZ7lAJwhx40yAaayO/IMQRGwSooCTD/yQKVLnLqF+OZ+ZUzJ/+oeKcA?=
 =?us-ascii?Q?joDLzEq3lXsKJa9XXGRwZHrpjdAC3GUfFpD1trCjQtAkcUgt8vtNlC3U4gPc?=
 =?us-ascii?Q?VgO0fPietyy3l1/l2EM1pY76iLhzVzst9B1MxlgCgN9Gy3uOjzZ8mzau8Lgp?=
 =?us-ascii?Q?maQD592aXk8yTL++DPpwuhVBJlsUew/ipV1YXKglnvqFThjEaaTqE0CPRAUw?=
 =?us-ascii?Q?gvUr8q1V2jQSKGCngU8sQzFnPRY7pKhejofyG0B/z7pAu8jnSCFLUacKTlwf?=
 =?us-ascii?Q?KJC9dqXjo5F8PtuKBGooc6okf3PldftVI8X2Fb3VMcDJKj5LKncll2mVWA3Q?=
 =?us-ascii?Q?WBE8Dw/kyV4DupVTrOVUVxtI9wEiKC0uoqv8alrotuka7s4lC9WUKZkJCNXs?=
 =?us-ascii?Q?aqTgt2re+1Z1dErh0328iLYfan8cDYrh5STjuCT2H8A3VGF+Nv6AqfgoBGMb?=
 =?us-ascii?Q?Sqc/JLFJtVS9MlHNH/6eDPzCKJy8XIedQkY0iFlz0B2ZWgXTzYuXrDj+jv59?=
 =?us-ascii?Q?TEWziZcoFNSD4VgGxKIPlrHwa6vh+zsyHIIWGwAYiuVXRirhKu3Kd/eQ8tBx?=
 =?us-ascii?Q?nakBIbN/YDCUAjUdO1zvy0oKSNf0CkTKUBISoOsz0iHaVR95/oOg6xsarNoi?=
 =?us-ascii?Q?h+qoaS9AxTqni/fg8lmGPv9I4pjC0MP0giH1QEmxB6mXvVs4Ixj2jdgBb2H3?=
 =?us-ascii?Q?lnxm35nyTyF5FyFgXl8ULJmWUDUHcwc/BF9PljyXt1LnSWe0CBWBA/6pHUzf?=
 =?us-ascii?Q?z2LRVw3H66M1l2yhq6KuljucXd0nB3Wm+OxCHxPQlnOSnlr5M6xaifjbYRfP?=
 =?us-ascii?Q?Ae0WfT/tmh/YF7ud2IFq20Csn9vhoMQwkaKZxbnC9wM1bBx/LbO3JAyaxzOR?=
 =?us-ascii?Q?6YiBxuv1q9xuJjtAM+we/oiVu2G14AZcMDJ0itg+4/15+e7B4hbX8UkkAdlD?=
 =?us-ascii?Q?qBcDA8txlczK8IiK9QWwRUI18bHLEIQUj8vmICxmzmiEQXM3Rrrgm+Gg9ScX?=
 =?us-ascii?Q?nDmXZgH2Y6JpUCBlAyLxRE6/VzC1ypnXmDXbLjD4EhjkGlgmmUTz6PWZzFjD?=
 =?us-ascii?Q?nLGL/iraTnIOY2tk+0lbUli6bO1pYVBpmAYNrXnbEMXXCwit1Bnb+ze3rTp/?=
 =?us-ascii?Q?A1u/PccZPOdoLUp8s9m4iAfosCPMrhqi7e9drj63?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df55b07-5719-4a93-24e1-08db3ce7aab7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:56:30.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKmWO4aXyq2Ewh08FmgpvWYFivAKePleb9CIYPBD2gOHrWwmXXyqn56Z/Glmo8c+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:40PM -0700, Brett Creeley wrote:
> It's possible that the device firmware crashes and is able to recover
> due to some configuration and/or other issue. If a live migration
> is in progress while the firmware crashes, the live migration will
> fail. However, the VF PCI device should still be functional post
> crash recovery and subsequent migrations should go through as
> expected.
> 
> When the pds_core device notices that firmware crashes it sends an
> event to all its client drivers. When the pds_vfio driver receives
> this event while migration is in progress it will request a deferred
> reset on the next migration state transition. This state transition
> will report failure as well as any subsequent state transition
> requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
> VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
> reset is done, the migration state will be reset to
> VFIO_DEVICE_STATE_RUNNING and migration can be performed.
> 
> If the event is received while no migration is in progress (i.e.
> the VM is in normal operating mode), then no actions are taken
> and the migration state remains VFIO_DEVICE_STATE_RUNNING.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/pci_drv.c  | 110 +++++++++++++++++++++++++++++++-
>  drivers/vfio/pci/pds/vfio_dev.c |  34 +++++++++-
>  drivers/vfio/pci/pds/vfio_dev.h |   6 +-
>  3 files changed, 146 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> index b0781d9f4246..b155ac9b98ae 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -20,6 +20,104 @@
>  #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
>  #define PCI_VENDOR_ID_PENSANDO		0x1dd8
>  
> +static void
> +pds_vfio_recovery_work(struct work_struct *work)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(work, struct pds_vfio_pci_device, work);
> +	bool deferred_reset_needed = false;
> +
> +	/* Documentation states that the kernel migration driver must not
> +	 * generate asynchronous device state transitions outside of
> +	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
> +	 *
> +	 * Since recovery is an asynchronous event received from the device,
> +	 * initiate a deferred reset. Only issue the deferred reset if a
> +	 * migration is in progress, which will cause the next step of the
> +	 * migration to fail. Also, if the device is in a state that will
> +	 * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e. VM is
> +	 * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will clear
> +	 * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.
> +	 */
> +	mutex_lock(&pds_vfio->state_mutex);
> +	if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
> +	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
> +	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
> +	     pds_vfio_dirty_is_enabled(pds_vfio)))
> +		deferred_reset_needed = true;
> +	mutex_unlock(&pds_vfio->state_mutex);
> +
> +	/* On the next user initiated state transition, the device will
> +	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the user's
> +	 * responsibility to reset the device.
> +	 *
> +	 * If a VFIO_DEVICE_RESET is requested post recovery and before the next
> +	 * state transition, then the deferred reset state will be set to
> +	 * VFIO_DEVICE_STATE_RUNNING.
> +	 */
> +	if (deferred_reset_needed)
> +		pds_vfio_deferred_reset(pds_vfio, VFIO_DEVICE_STATE_ERROR);
> +}

Why is this a work? it is threaded on a blocking_notifier_chain so it
can call the mutex?

Why is the locking like this, can't you just call
pds_vfio_deferred_reset() under the mutex?

Jason
