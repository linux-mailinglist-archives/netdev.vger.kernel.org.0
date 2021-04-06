Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A3355D9B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbhDFVFY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 17:05:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:6537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230395AbhDFVFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 17:05:21 -0400
IronPort-SDR: 2Xh+YU1NAG1CcZUvKFzaIDKbkpbklox5CMQOuxBlV+DxON520TeAiFAXtdwke7WSDOq2CuD66S
 RlXvnV0qsFSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="180288781"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="180288781"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 14:05:12 -0700
IronPort-SDR: o9rFf+icZjjDvubnl7SRpNXqhhN5pTdKS7mU/Pg7xALgRITVPuvkD46rssU8z/jdz783fuWCbm
 1bfUXeN/WdCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="441067511"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2021 14:05:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 14:05:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 14:05:10 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Tue, 6 Apr 2021 14:05:10 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Topic: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHXKyghWxg1YMB540GtculmvcetP6qn+haQ
Date:   Tue, 6 Apr 2021 21:05:10 +0000
Message-ID: <a76853a97dda4ccb96c35d4095e4866a@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
In-Reply-To: <20210406210125.241-1-shiraz.saleem@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA (irdma)
> 
> The following patch series introduces a unified Intel Ethernet Protocol Driver for
> RDMA (irdma) for the X722 iWARP device and a new E810 device which supports
> iWARP and RoCEv2. The irdma module replaces the legacy i40iw module for X722
> and extends the ABI already defined for i40iw. It is backward compatible with
> legacy X722 rdma-core provider (libi40iw).
> 
> X722 and E810 are PCI network devices that are RDMA capable. The RDMA block
> of this parent device is represented via an auxiliary device exported to 'irdma'
> using the core auxiliary bus infrastructure recently added for 5.11 kernel.
> The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA devices with
> private data/ops encapsulated that bind to auxiliary drivers registered in irdma
> module.
> 
> This patchset was initially submitted as an RFC where in we got feedback to come
> up with a generic scheme for RDMA drivers to attach to a PCI device owned by
> netdev PCI driver [1]. Solutions using platform bus and MFD were explored but
> rejected by the community and the consensus was to add a new bus infrastructure
> to support this usage model.
> 
> Further revisions of this series along with the auxiliary bus were submitted [2]. At
> this point, Greg KH requested that we take the auxiliary bus review and revision
> process to an internal mailing list and garner the buy-in of a respected kernel
> contributor, along with consensus of all major stakeholders including Nvidia (for
> mlx5 sub-function use-case) and Intel sound driver. This process took a while and
> stalled further development/review of this netdev/irdma series.
> The auxiliary bus was eventually merged in 5.11.
> 
> Between v1 to v2 of this submission, the IIDC went through a major re-write based
> on the feedback and we hope it is now more in alignment with what the community
> wants.
> 
> This series is built against rdma for-next and currently includes the netdev patches
> for ease of review. This includes updates to 'ice' driver to provide RDMA support
> and converts 'i40e' driver to use the auxiliary bus infrastructure.
> Once the patches are closer to merging, a shared pull request will be submitted.
> 
> v3-->v4:
> * Fixup W=1 warnings in ice patches
> * Fix issues uncovered by pyverbs for create user AH and multicast
> * Fix descriptor set issue for fast register introduced during port to FIELD_PREP
> in v2 submission
> 
> v2-->v3:
> * rebase rdma for-next. Adapt to core change '1fb7f8973f51 ("RDMA: Support
> more than 255 rdma ports")'
> * irdma Kconfig updates to conform with linux coding style.
> * Fix a 0-day build issue
> * Remove rdma_resource_limits selector devlink param. Follow on patch to be
> submitted for it with suggestion from Parav to use devlink resource.
> * Capitalize abbreviations in ice idc. e.g. 'aux' to 'AUX'
> 
> v1-->v2:
> * Remove IIDC channel OPs - open, close, peer_register and peer_unregister.
>   And all its associated FSM in ice PCI core driver.
> * Use device_lock in ice PCI core driver while issuing IIDC ops callbacks.
> * Remove peer_* verbiage from shared IIDC header and rename the structs and
> channel ops
>   with iidc_core*/iidc_auxiliary*.
> * Allocate ib_device at start and register it at the end of drv.probe() in irdma gen2
> auxiliary driver.
> * Use ibdev_* printing extensively throughout most of the driver
>   Remove idev_to_dev, ihw_to_dev macros as no longer required in new print
> scheme.
> * Do not bump ABI ver. to 6 in irdma. Maintain irdma ABI ver. at 5 for legacy i40iw
> user-provider compatibility.
> * Add a boundary check in irdma_alloc_ucontext to fail binding with < 4 user-space
> provider version.
> * Remove devlink from irdma. Add 2 new rdma-related devlink parameters added
> to ice PCI core driver.
> * Use FIELD_PREP/FIELD_GET/GENMASK on get/set of descriptor fields versus
> home grown ones LS_*/RS_*.
> * Bind 2 separate auxiliary drivers in irdma - one for gen1 and one for gen2 and
> future devices.
> * Misc. driver fixes in irdma
> 
> [1] https://patchwork.kernel.org/project/linux-rdma/patch/20190215171107.6464-2-
> shiraz.saleem@intel.com/
> [2] https://lore.kernel.org/linux-rdma/20200520070415.3392210-1-
> jeffrey.t.kirsher@intel.com/
> 

The irdma rdma-core provider will be send out shortly.

Shiraz
