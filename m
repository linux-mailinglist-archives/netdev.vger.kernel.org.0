Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F1431867
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhJRMEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:04:49 -0400
Received: from mail-dm6nam08on2051.outbound.protection.outlook.com ([40.107.102.51]:4448
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229569AbhJRMEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:04:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWDJQzF1M4Krpck7kND2kLGIJMxXMDnYqmIUvx8QaYfjOF1dq1IG+TQwcNy42H27XNCymsekCFbZOnJ1JYS2OsnE9FtBuhZL5KabYPB2J+IDQCyljbJk5+bbA+AUI4vvGeydnKlUnHrdL7Xd/+K+3lXSlI1ZmdOS9+exHH0BVu+7yT07hodvSyjkQFm0nS5Xs7z67nDIgcEk96Pj86BHZPfp5I0xf1S3ySl48jtwG99SGryE1A/lLM7LsZ7xRjm0MlTaPQQ9hXnZHCMCLJi9TsSemHG9RA6FP7Ri2zu35KjQWUql/J2VZbPCtbN07lPXvKi1HSm/xgCDwnpFxSAfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZE61MLBW5gBmdW+pBIvBKiW+I/CORqTILy/5raHpW0=;
 b=btdYc80IL10zLfndTpxRxm7nrcJKduOc8IaLG6k1g3Arehx/cMyb+iBBkSqlEZ2MrJQGbQFC7JB4mPQHtzFJi7YMyngWnfO1xKZeRuMklHK4KZ9A63/lgrGfEJB1SSso6r+EZokNZNPRSCcoCjrLBYjhP/TxGt5l8Y4pkCRLK82z/skUkG+YMf3dSHv6nHuBePSsaOvXdHT14lFK8gFA43FMXtG6UJuwJNrG16GiEbAjzTy8DI4O0apAgEd4rwMTZ/UmCY70XYVl/e+3RNlaoYlwuqWg/nI8Y/xqgLNmhPChtF9/4YXmvVQFpT9A9iyw7xlejG3QYLcidJg0htXCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZE61MLBW5gBmdW+pBIvBKiW+I/CORqTILy/5raHpW0=;
 b=rOu6tRho9kZOyNHYa+1wKQXf0Pbx/JjMoI5j9nDBVQaB2ig+iW/TIVaczDewSLAeyGnII5l6niNAt/jXcr6h1TEUttiQZJuetXG0pDm88sxonpO0nYNQVciwxW/QsceAlTaw0BjmPXUdGSOAt4SG+nMfLGW94BbwaVI+tF+jZJSBs7URHeE37Y+kfta8t+gWQDxd1SlJbKkI5gWrC6yVdLHrP+Zy3vMqku3uXUOskkXhp3JO3cphksx21XcJ3VUZBebzCW1zMlwMwq/4PSGSwz0J1eYlSbVEtNkI32yL20AvOzUAWo4q/Mvgf0kirXctaowG1RhjAo6kaiLXV7hQjg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 12:02:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 12:02:35 +0000
Date:   Mon, 18 Oct 2021 09:02:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let
 vfio_pci_core drivers trap device RESET
Message-ID: <20211018120234.GN2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-13-yishaih@nvidia.com>
 <20211015135237.759fe688.alex.williamson@redhat.com>
 <20211015200328.GG2744544@nvidia.com>
 <20211015151243.3c5b0910.alex.williamson@redhat.com>
 <d91f729b-d547-406f-353f-04627d4e555c@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d91f729b-d547-406f-353f-04627d4e555c@nvidia.com>
X-ClientProxiedBy: MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 12:02:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcRLe-00GFT9-4m; Mon, 18 Oct 2021 09:02:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c88a3243-1a16-4c99-aad2-08d9922f2c48
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5380D67B38B3D021411A6A37C2BC9@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8MagBkfcI+Vsc8fPHIX1AMYmovETMymNWM9irppADrd7oKYIuoACAfJGIOz3QITS7M8RAIU7TPt79OrFq3gJNx0nNoLFiXXjDS/I0lMMktWh0qkxXIcTGclrDg/jcXGqzxfIrCoFKXQg3tbUgT+Tc3ttfMW08rPmRwZn4CHRhXVeM5xFBG3FA5rZ1z6tPB1vhWwT0Frv4pI8KuVbzI0T6nT8p5IhTV3Vw1dMMoLnmdxxn7ZWhAtrLR4UL8GqiZ7eRCu9zgjY5QhXTjMweX+8IX6yEKqZB1L7kvogWa+nI4rnVoPTbFoZQ8n7HE5LaVDXW4EryMsy07Fih8KrjhKwSEYXfbmZ2UnLDBRruG202flzaMjjOT5xFqBk0TyIsgrvbP1dHTTewSR0OS4Uln9d9hCpxi1lHA83FZGRe+NRcLzCZTzpHADjcHDTiuvCSnNFIx5+VwrYiYIG5QUFxUk1w5byLNBU/sGK6nAAswUjN76g6pl9XY9JtBo5C0XQ9p21WOEMAF8FSmHg4UhLDT233xxVkyjRrhXj3q84VhgvIrymjdaXYI0/ZCo/E6QDfiKU+ZXkoQ3jzknIvMaIk/yeLoemHc8DL4/kXRMmAoOVMqwtA15b+aktodX90fXH+sMsCn1g5DAXJu8zUgE7ntRQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(316002)(6636002)(6862004)(4326008)(33656002)(186003)(83380400001)(9786002)(66476007)(66556008)(8936002)(26005)(9746002)(37006003)(8676002)(66946007)(426003)(38100700002)(107886003)(1076003)(86362001)(2616005)(36756003)(53546011)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1pyd2UxcW80RTdqaXdCeTFGVGQ5TzY0L1dYMWxRV2xtRVNhM2pmM0ZIWURq?=
 =?utf-8?B?MHlOS0pVMDFXZkxGaXZTNS80SHRBNmNUZUxqVmgyWFlZSkJZODdtSXJteFNz?=
 =?utf-8?B?QVdBbzZuR0xSeDhFODV0WTNqOE9yeGZ5cE1PaEhnbHh3V3I1VkZLdEhSOXc1?=
 =?utf-8?B?aGhxekRnWlZUTm5kV2ViR3JUQ2JpQlVQbmhnRW95UEVUMjlEek1tNGZPTFhG?=
 =?utf-8?B?QWpsd3ZJREU0dytGeGJRb2VMN1dWSFNuRUtXZ2gySzY0a2g3K3NRVVBqQU5S?=
 =?utf-8?B?Um9kNk9rdThvOU9XU2hvZHpieGlJMlV3Vzk2N09aK1FGWlF1ajYrRzFLUkJD?=
 =?utf-8?B?L0srQktwbHpyYmhtZ21OZk1nT2Z3T2dmRm4xaDN3bk1vRDRPNWdaMjJuazZR?=
 =?utf-8?B?dFZCbjczOEd6NlJHQ085Z2ZmWUxaMFpISzUwSUlLL1NKWXg0cVY3MWt2Mlh2?=
 =?utf-8?B?T2x2eTl2YlJhSjJTRkZIRkxIdFRxK0YyTmkxS3hHWnA1MVFVOUtneTdIWG1h?=
 =?utf-8?B?bHdhT1A3ZnF2V1I5dExiYjRkTnZtZ29Ocm5pYUt0ekU4c0pFczQwZDRHZ2xQ?=
 =?utf-8?B?V3dZbExMaFJ6Qk9VL2pKbHhzeW4zeTVodUIwN2dWSGlGWml0ZUFrTmVSVW9x?=
 =?utf-8?B?Z3Q1K3J1bkUrTlNMemJwbHdxbkdPNWFralVXZU1xKzFFT0hIeXY1VmVHZGpM?=
 =?utf-8?B?RG1VdzVib1dWVGJNcjFCSE5sc3FMUzdWcStRSFNKVUFpc2I1OHFYNTBESXNV?=
 =?utf-8?B?RzA4TzVZMmtlSlE2c1d2eTlIYm9Ebk1Dbm94RkRmUldya2xTaStjVFhXRm40?=
 =?utf-8?B?dzVDSzlTbDBuWXRJUFFabEFXcG5rYkkvY1VQRzNwbTVDajJxbC9zQVFIZ282?=
 =?utf-8?B?VS9ReVNRUkhJaitDbEpPMy90bFhqMFBzWEErVlVxdGc2ejRkSHNZY3Q0ekZ1?=
 =?utf-8?B?M2JTTUk3SXE0Uzg4K0hZMkJHc2N0UWRlR3JFakVPcy9BMEQ4TXJKNE5KY0ho?=
 =?utf-8?B?aUl2ME1BR01OYVVoWHRjL0p2d2UxdWJ4bkphQnBuSzVhQkJ0bnZkOFZ5VE15?=
 =?utf-8?B?eCtEb2FKL2RURGZ5aFdURlVvY2ErSDZOV1llaUxObGVCMUZFZWowN3V3Qkg0?=
 =?utf-8?B?L1QybzNndWRuNy9HaUlGVndPZ1FQWUtUUHJmNHBYWWh3RkdQZk1aVVFmMkpv?=
 =?utf-8?B?MWdKTGNLVjhHNVVJV1lMRHN6cTJIL3F0NjcrZm00ZnUrZ1hadkFTV0lrK2c5?=
 =?utf-8?B?blBMRHF6cytJbjFDcjhxVmdybmZsRU1yY1l4dXMxOTNCZ3JrVnNXMzFUWjdo?=
 =?utf-8?B?V0RxVTJTSUhjZnhYdWJ3Tm9rMVc5MzhOWTBiUmVaK1AyWnZab3BxOEl6THRw?=
 =?utf-8?B?UGl6TFQ4aUovWFlZbmJ5RUNDa2xXWHNzK09DZm0raVczdEJ6N2dma3Y3OFdk?=
 =?utf-8?B?ZjA3bHhwaWp3TDF2cDFkRk9GNVZCSkVIUUNQQlFPc0hWVDBDaUpSNFJ0VFZu?=
 =?utf-8?B?TWxyYkVHUU9UMzBKQzY2anFJeVA1MGc4MGpKTkN5QTVHa2xrLzdzOThBSXBL?=
 =?utf-8?B?VmpnZXlqQ3hlbnY4MU15MmxXRWNCUTBEM3orai9FQTJvWHVjZC9WWW9aZHJW?=
 =?utf-8?B?V0wrVkRLUUkwb1NLUEUyc0NlOG1YQXhLK211TVRCNXBteTRzamZQK2lKRmla?=
 =?utf-8?B?WXJrMjl6VGlQbDdUUlVJU2xKZERpYW94OTF1djNZMC9wTmFQc3FFZ0ZLazNq?=
 =?utf-8?Q?x6b7AHFbEWkOw+vTbJKdaxJ3JGMIQanF2SMyMlX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c88a3243-1a16-4c99-aad2-08d9922f2c48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 12:02:35.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0QsWSEfgnngXWW8KOUi7NlNSNoIaBkyOBo3Cvk5T2MSQYP3lU1FTWkbHw8lOGwI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 05:29:39PM +0300, Yishai Hadas wrote:
> On 10/16/2021 12:12 AM, Alex Williamson wrote:
> > On Fri, 15 Oct 2021 17:03:28 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Fri, Oct 15, 2021 at 01:52:37PM -0600, Alex Williamson wrote:
> > > > On Wed, 13 Oct 2021 12:47:06 +0300
> > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > > Add infrastructure to let vfio_pci_core drivers trap device RESET.
> > > > > 
> > > > > The motivation for this is to let the underlay driver be aware that
> > > > > reset was done and set its internal state accordingly.
> > > > I think the intention of the uAPI here is that the migration error
> > > > state is exited specifically via the reset ioctl.  Maybe that should be
> > > > made more clear, but variant drivers can already wrap the core ioctl
> > > > for the purpose of determining that mechanism of reset has occurred.
> > > It is not just recovering the error state.
> > > 
> > > Any transition to reset changes the firmware state. Eg if userspace
> > > uses one of the other emulation paths to trigger the reset after
> > > putting the device off running then the driver state and FW state
> > > become desynchronized.
> > > 
> > > So all the reset paths need to be synchronized some how, either
> > > blocked while in non-running states or aligning the SW state with the
> > > new post-reset FW state.
> > This only catches the two flavors of FLR and the RESET ioctl itself, so
> > we've got gaps relative to "all the reset paths" anyway.  I'm also
> > concerned about adding arbitrary callbacks for every case that it gets
> > too cumbersome to write a wrapper for the existing callbacks.
> > 
> > However, why is this a vfio thing when we have the
> > pci_error_handlers.reset_done callback.  At best this ought to be
> > redundant to that.  Thanks,
> > 
> > Alex
> > 
> Alex,
> 
> How about the below patch instead ?
> 
> This will centralize the 'reset_done' notifications for drivers to one place
> (i.e. pci_error_handlers.reset_done)  and may close the gap that you pointed
> on.
> 
> I just followed the logic in vfio_pci_aer_err_detected() from usage and
> locking point of view.
> 
> Do we really need to take the &vdev->igate mutex as was done there ?
> 
> The next patch from the series in mlx5 will stay as of in V1, it may just
> set its ops and be called upon PCI 'reset_done'.
> 
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c
> index e581a327f90d..20bf37c00fb6 100644
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1925,6 +1925,27 @@ static pci_ers_result_t
> vfio_pci_aer_err_detected(struct pci_dev *pdev,
>         return PCI_ERS_RESULT_CAN_RECOVER;
>  }
> 
> +static void vfio_pci_aer_err_reset_done(struct pci_dev *pdev)
> +{
> +       struct vfio_pci_core_device *vdev;
> +       struct vfio_device *device;
> +
> +       device = vfio_device_get_from_dev(&pdev->dev);
> +       if (device == NULL)
> +               return;

Do not add new vfio_device_get_from_dev() calls, this should extract
it from the pci_get_drvdata.

> +
> +       vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +
> +       mutex_lock(&vdev->igate);
> +       if (vdev->ops && vdev->ops->reset_done)
> +               vdev->ops->reset_done(vdev);
> +       mutex_unlock(&vdev->igate);
> +
> +       vfio_device_put(device);
> +
> +       return;
> +}
> +
>  int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  {
>         struct vfio_device *device;
> @@ -1947,6 +1968,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
> 
>  const struct pci_error_handlers vfio_pci_core_err_handlers = {
>         .error_detected = vfio_pci_aer_err_detected,
> +       .reset_done = vfio_pci_aer_err_reset_done,
>  };
>  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);

Most likely mlx5vf should just implement a pci_error_handlers struct
and install vfio_pci_aer_err_detected in it.

Jason
