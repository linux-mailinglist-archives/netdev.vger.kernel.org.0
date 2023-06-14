Return-Path: <netdev+bounces-10858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1EB73091D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE0121C20D2E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3D6125AC;
	Wed, 14 Jun 2023 20:20:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869D11CAD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:20:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231D32101
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686774042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1DBr2ONz+wXUhM4DC1kd13x5cdbKVHZ3vYKXElwfTc=;
	b=K/GB/kZukq4RvpmEh7809c1t73En3PnAtZTZ3eInklJvk4Xsl9K5voe2dnHwGGmVDFAeSz
	aASpTq5F576nBsPbqF7GFkhCTPkT+SZhpeekhwUf5iOABPxX0rV+YDdbDgJ5Qve/Hzcw8K
	1AZuZC1NHyVldWS/twSv4RI65VgAeZ4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-uOI2VXNyNjC0XLB-emlxuw-1; Wed, 14 Jun 2023 16:20:41 -0400
X-MC-Unique: uOI2VXNyNjC0XLB-emlxuw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-777a93b3277so739388539f.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774040; x=1689366040;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y1DBr2ONz+wXUhM4DC1kd13x5cdbKVHZ3vYKXElwfTc=;
        b=B/t+Ox/7yF6Zg21IHbQjlgE4p4o6ge0EBUnOjalp7FhR2JP2nq0ew/9B4La0HPtNZU
         geu7uMZFcR7J3mlnDA7xBvzrAMKPDlST+o/RkYlmGc1/a61GUa46kjNGVSDAvc1Cq2is
         JA6WbQlN7i+eddCSb/oMcFpyTEGfQAz6FUDLdquG/CyXBBtaTdSNMBd0GPCb3qstETJ2
         Z0/Dsf7dyZ+OuroPP2kGTqwFjzDFnKqdnpgGr+S4N9JgM5HjJQ8SihtxO/m5VgNUjKdj
         4AEMjDZRu2hdCrHV3IbTYKPQvThWtqTvlt1WCY8GAx0wLy3kAg5Fh1AKYEi5li73LzKE
         aXfA==
X-Gm-Message-State: AC+VfDwdhAQro7Uh6LxkGWPzoVcHgTST+ysBjhTt+srQcbcR/8Qr/2Rz
	+hZQk7KUhpO5eq7NkUNSHdYAZHIpnOb68pJt0bE91grBMuABseGqnO8SZWrLxJfao5RJP6mC4h9
	TYZfr+p2kH0sN53nn
X-Received: by 2002:a6b:7b45:0:b0:77b:1c57:7e78 with SMTP id m5-20020a6b7b45000000b0077b1c577e78mr7673229iop.16.1686774040152;
        Wed, 14 Jun 2023 13:20:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Yt9dHj19FasAc/N5we0zsveyc5D79o8SG1C3GT3kxM87LJkoG0Yl3wOfn4WZ3qGqIvd+xMQ==
X-Received: by 2002:a6b:7b45:0:b0:77b:1c57:7e78 with SMTP id m5-20020a6b7b45000000b0077b1c577e78mr7673219iop.16.1686774039822;
        Wed, 14 Jun 2023 13:20:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n28-20020a02cc1c000000b0040bbfad3e28sm5074702jap.96.2023.06.14.13.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 13:20:39 -0700 (PDT)
Date: Wed, 14 Jun 2023 14:20:36 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
Cc: Brett Creeley <brett.creeley@amd.com>, <kvm@vger.kernel.org>,
 <netdev@vger.kernel.org>, <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 0/7] pds_vfio driver
Message-ID: <20230614142036.3632d16b.alex.williamson@redhat.com>
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[sorry, not-sorry for the top post]

Thanks Jason and Shameer for prior review comments, I hope you both can
find time to check v10 as well.

Others that previously stepped up to be reviewers for new vfio-pci
variant drivers, please jump in.  Thanks,

Alex

On Fri, 2 Jun 2023 15:03:11 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> This is a patchset for a new vendor specific VFIO driver
> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> (DSC). This driver makes use of the pds_core driver.
> 
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
> 
> In order to receive events from pds_core, the pds_vfio driver
> registers to a private notifier. This is needed for various events
> that come from the device.
> 
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
> 
>                                .------.  .-----------------------.
>                                | QEMU |--|  VM  .-------------.  |
>                                '......'  |      |   Eth VF    |  |
>                                   |      |      .-------------.  |
>                                   |      |      |  SR-IOV VF  |  |
>                                   |      |      '-------------'  |
>                                   |      '------------||---------'
>                                .--------------.       ||
>                                |/dev/<vfio_fd>|       ||
>                                '--------------'       ||
> Host Userspace                         |              ||
> ===================================================   ||
> Host Kernel                            |              ||
>                                   .--------.          ||
>                                   |vfio-pci|          ||
>                                   '--------'          ||
>        .------------------.           ||              ||
>        |   | exported API |<----+     ||              ||
>        |   '--------------|     |     ||              ||
>        |                  |    .-------------.        ||
>        |     pds_core     |--->|   pds_vfio  |        ||
>        '------------------' |  '-------------'        ||
>                ||           |         ||              ||
>              09:00.0     notifier    09:00.1          ||
> == PCI ===============================================||=====
>                ||                     ||              ||
>           .----------.          .----------.          ||
>     ,-----|    PF    |----------|    VF    |-------------------,
>     |     '----------'          '----------'  |       VF       |
>     |                     DSC                 |  data/control  |
>     |                                         |      path      |
>     -----------------------------------------------------------
> 
> 
> The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.
> 
> Changes:
> 
> v10:
> - Various fixes/suggestions by Jason Gunthorpe
> 	- Simplify pds_vfio_get_lm_file() based on fpga_mgr_buf_load()
> 	- Clean-ups/fixes based on clang-format
> 	- Remove any double goto labels
> 	- Name goto labels baesed on what needs to be cleaned/freed
> 	  instead of a "call from" scheme
> 	- Fix any goto unwind ordering issues
> 	- Make sure call dma_map_single() after data is written to
> 	  memory in pds_vfio_dma_map_lm_file()
> 	- Don't use bitmap_zalloc() for the dirty bitmaps
> - Use vzalloc() for dirty bitmaps and refactor how the bitmaps are DMA'd
>   to and from the device in pds_vfio_dirty_seq_ack()
> - Remove unnecessary goto in pds_vfio_dirty_disable()
> 
> v9:
> https://lore.kernel.org/netdev/20230422010642.60720-1-brett.creeley@amd.com/
> - Various fixes/suggestions by Alex Williamson
> 	- Fix how ID is generated in client registration
> 	- Add helper functions to get the VF's struct device and struct
> 	  pci_dev pointers instead of caching the struct pci dev
> 	- Remove redundant pds_vfio_lm_state() function and remove any
> 	  places this was being called
> 	- Fix multi-line comments to follow standard convention
> 	- Remove confusing comments in
> 	  pds_vfio_step_device_state_locked() since the driver's
> 	  migration states align with the VFIO documentation
> 	- Validate pdsc returned from pdsc_get_pf_struct()
> - Various fixes/suggestions by Jason Gunthorpe
> 	- Use struct pdsc instead of void *
> 	- Use {} instead of {0} for structure initialization
> 	- Use unions on the stack instead of casting to the union when
> 	  sending AQ commands, which required including pds_lm.h in
> 	  pds_adminq.h
> 	- Replace use of dma_alloc_coherent() when creating the sgl DMA
> 	  entries for the LM file
> 	- Remove cached struct device *coredev and instead use
> 	  pci_physfn() to get the pds_core's struct device pointer
> 	- Drop the recovery work item and call pds_vfio_recovery()
> 	  directly from the notifier callback
> 	- Remove unnecessary #define for "pds_vfio_lm" and just use the
> 	  string inline to the anon_inode_getfile() argument
> - Fix LM file reference counting
> - Move initialization of some struct members to when the struct is being
>   initialized for AQ commands
> - Make use of GFP_KERNEL_ACCOUNT where it makes sense
> - Replace PDS_VFIO_DRV_NAME with KBUILD_MODNAME
> - Update to latest pds_core exported functions
> - Remove duplicated prototypes for
>   pds_vfio_dma_logging_[start|stop|report] from lm.h
> - Hold pds_vfio->state_mutex while starting, stopping, and reporting
>   dirty page tracking in pds_vfio_dma_logging_[start|stop|report]
> - Remove duplicate PDS_DEV_TYPE_LM_STR define from pds_lm.h that's
>   already included in pds_common.h
> - Replace use of dma_alloc_coherent() when creating the sgl DMA
>   entries for the dirty bitmaps
> 
> v8:
> https://lore.kernel.org/netdev/20230404190141.57762-1-brett.creeley@amd.com/
> - provide default iommufd callbacks for bind_iommufd, unbind_iommufd, and
>   attach_ioas for the VFIO device as suggested by Shameerali Kolothum
>   Thodi
> 
> v7:
> https://lore.kernel.org/netdev/20230331003612.17569-1-brett.creeley@amd.com/
> - Disable and clean up dirty page tracking when the VFIO device is closed
> - Various improvements suggested by Simon Horman:
> 	- Fix RCT in vfio_combine_iova_ranges()
> 	- Simplify function exit paths by removing unnecessary goto
> 	  labels
> 	- Cleanup pds_vifo_print_guest_region_info() by adding a goto
> 	  label for freeing memory, which allowed for reduced
> 	  indentation on a for loop
> 	- Where possible use C99 style for loops
> 
> v6:
> https://lore.kernel.org/netdev/20230327200553.13951-1-brett.creeley@amd.com/
> - As suggested by Alex Williamson, use pci_domain_nr() macro to make sure
>   the pds_vfio client's devname is unique
> - Remove unnecessary forward declaration and include
> - Fix copyright comment to use correct company name
> - Remove "." from struct documentation for consistency
> 
> v5:
> https://lore.kernel.org/netdev/20230322203442.56169-1-brett.creeley@amd.com/
> - Fix SPDX comments in .h files
> - Remove adminqcq argument from pdsc_post_adminq() uses
> - Unregister client on vfio_pci_core_register_device() failure
> - Other minor checkpatch issues
> 
> v4:
> https://lore.kernel.org/netdev/20230308052450.13421-1-brett.creeley@amd.com/
> - Update cover letter ASCII diagram to reflect new driver architecture
> - Remove auxiliary driver implementation
> - Use pds_core's exported functions to communicate with the device
> - Implement and register notifier for events from the device/pds_core
> - Use module_pci_driver() macro since auxiliary driver configuration is
>   no longer needed in __init/__exit
> 
> v3:
> https://lore.kernel.org/netdev/20230219083908.40013-1-brett.creeley@amd.com/
> - Update copyright year to 2023 and use "Advanced Micro Devices, Inc."
>   for the company name
> - Clarify the fact that AMD/Pensando's VFIO solution is device type
>   agnostic, which aligns with other current VFIO solutions
> - Add line in drivers/vfio/pci/Makefile to build pds_vfio
> - Move documentation to amd sub-directory
> - Remove some dead code due to the pds_core implementation of
>   listening to BIND/UNBIND events
> - Move a dev_dbg() to a previous patch in the series
> - Add implementation for vfio_migration_ops.migration_get_data_size to
>   return the maximum possible device state size
> 
> RFC to v2:
> https://lore.kernel.org/all/20221214232136.64220-1-brett.creeley@amd.com/
> - Implement state transitions for VFIO_MIGRATION_P2P flag
> - Improve auxiliary driver probe by returning EPROBE_DEFER
>   when the PCI driver is not set up correctly
> - Add pointer to docs in
>   Documentation/networking/device_drivers/ethernet/index.rst
> 
> RFC:
> https://lore.kernel.org/all/20221207010705.35128-1-brett.creeley@amd.com/
> 
> 
> Brett Creeley (7):
>   vfio: Commonize combine_ranges for use in other VFIO drivers
>   vfio/pds: Initial support for pds_vfio VFIO driver
>   vfio/pds: register with the pds_core PF
>   vfio/pds: Add VFIO live migration support
>   vfio/pds: Add support for dirty page tracking
>   vfio/pds: Add support for firmware recovery
>   vfio/pds: Add Kconfig and documentation
> 
>  .../device_drivers/ethernet/amd/pds_vfio.rst  |  79 +++
>  .../device_drivers/ethernet/index.rst         |   1 +
>  MAINTAINERS                                   |   7 +
>  drivers/vfio/pci/Kconfig                      |   2 +
>  drivers/vfio/pci/Makefile                     |   2 +
>  drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
>  drivers/vfio/pci/pds/Kconfig                  |  20 +
>  drivers/vfio/pci/pds/Makefile                 |  11 +
>  drivers/vfio/pci/pds/cmds.c                   | 487 +++++++++++++++
>  drivers/vfio/pci/pds/cmds.h                   |  25 +
>  drivers/vfio/pci/pds/dirty.c                  | 577 ++++++++++++++++++
>  drivers/vfio/pci/pds/dirty.h                  |  38 ++
>  drivers/vfio/pci/pds/lm.c                     | 421 +++++++++++++
>  drivers/vfio/pci/pds/lm.h                     |  41 ++
>  drivers/vfio/pci/pds/pci_drv.c                | 206 +++++++
>  drivers/vfio/pci/pds/pci_drv.h                |   9 +
>  drivers/vfio/pci/pds/vfio_dev.c               | 234 +++++++
>  drivers/vfio/pci/pds/vfio_dev.h               |  45 ++
>  drivers/vfio/vfio_main.c                      |  47 ++
>  include/linux/pds/pds_adminq.h                | 395 ++++++++++++
>  include/linux/pds/pds_common.h                |   2 +
>  include/linux/vfio.h                          |   3 +
>  22 files changed, 2653 insertions(+), 47 deletions(-)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
>  create mode 100644 drivers/vfio/pci/pds/Kconfig
>  create mode 100644 drivers/vfio/pci/pds/Makefile
>  create mode 100644 drivers/vfio/pci/pds/cmds.c
>  create mode 100644 drivers/vfio/pci/pds/cmds.h
>  create mode 100644 drivers/vfio/pci/pds/dirty.c
>  create mode 100644 drivers/vfio/pci/pds/dirty.h
>  create mode 100644 drivers/vfio/pci/pds/lm.c
>  create mode 100644 drivers/vfio/pci/pds/lm.h
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
> 


