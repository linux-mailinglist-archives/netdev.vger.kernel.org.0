Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6074814E5D6
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgA3XDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 18:03:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:5595 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgA3XDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 18:03:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 15:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="230089217"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 30 Jan 2020 15:03:37 -0800
Subject: Re: [RFC PATCH 00/13] devlink direct region reading
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <bc7e6daf-d8b7-5e52-1911-24b6791d2390@intel.com>
Date:   Thu, 30 Jan 2020 15:03:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/30/2020 2:58 PM, Jacob Keller wrote:
> 
> Jacob Keller (12):
>   devlink: prepare to support region operations
>   devlink: add functions to take snapshot while locked
>   devlink: add operation to take an immediate snapshot
>   netdevsim: support taking immediate snapshot via devlink
>   ice: use __le16 types for explicitly Little Endian values
>   ice: create function to read a section of the NVM and Shadow RAM
>   ice: enable initial devlink support for function zero
>   ice: add basic handler for devlink .info_get
>   ice: add board identifier info to devlink .info_get
>   ice: add a devlink region to dump shadow RAM contents
>   devlink: support directly reading from region memory
>   ice: support direct read of the shadow ram region
> 
> Jesse Brandeburg (1):
>   ice: implement full NVM read from ETHTOOL_GEEPROM
> 
>  drivers/net/ethernet/intel/Kconfig            |   1 +
>  drivers/net/ethernet/intel/ice/Makefile       |   1 +
>  drivers/net/ethernet/intel/ice/ice.h          |   7 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
>  drivers/net/ethernet/intel/ice/ice_common.c   |  61 +++
>  drivers/net/ethernet/intel/ice/ice_common.h   |   5 +-
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 427 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |  20 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  37 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |  22 +
>  drivers/net/ethernet/intel/ice/ice_nvm.c      | 211 +++------
>  drivers/net/ethernet/intel/ice/ice_nvm.h      |   7 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>  drivers/net/ethernet/mellanox/mlx4/crdump.c   |  25 +-
>  drivers/net/netdevsim/dev.c                   |  44 +-
>  include/net/devlink.h                         |  28 +-
>  include/uapi/linux/devlink.h                  |   2 +
>  net/core/devlink.c                            | 246 +++++++---
>  18 files changed, 918 insertions(+), 230 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h
> 

Woops, I forgot to re-create the cover letter after some reworks. All of
the following patches should have also been tagged with 'RFC'. Here's
the correct cover letter summary for this:

> 
> Jacob Keller (14):
>   devlink: prepare to support region operations
>   devlink: add functions to take snapshot while locked
>   devlink: add operation to take an immediate snapshot
>   netdevsim: support taking immediate snapshot via devlink
>   ice: use __le16 types for explicitly Little Endian values
>   ice: create function to read a section of the NVM and Shadow RAM
>   devlink: add devres managed devlinkm_alloc and devlinkm_free
>   ice: enable initial devlink support
>   ice: add basic handler for devlink .info_get
>   ice: add board identifier info to devlink .info_get
>   ice: add a devlink region to dump shadow RAM contents
>   devlink: support directly reading from region memory
>   ice: support direct read of the shadow ram region
>   ice: add ice.rst devlink documentation file
> 
> Jesse Brandeburg (1):
>   ice: implement full NVM read from ETHTOOL_GEEPROM
> 
>  .../networking/devlink/devlink-region.rst     |  17 +-
>  Documentation/networking/devlink/ice.rst      |  76 ++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  drivers/net/ethernet/intel/Kconfig            |   1 +
>  drivers/net/ethernet/intel/ice/Makefile       |   1 +
>  drivers/net/ethernet/intel/ice/ice.h          |   6 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   3 +
>  drivers/net/ethernet/intel/ice/ice_common.c   |  66 ----
>  drivers/net/ethernet/intel/ice/ice_common.h   |   6 -
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 373 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |  17 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  36 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |  30 +-
>  drivers/net/ethernet/intel/ice/ice_nvm.c      | 340 +++++++++-------
>  drivers/net/ethernet/intel/ice/ice_nvm.h      |  12 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>  drivers/net/ethernet/mellanox/mlx4/crdump.c   |  25 +-
>  drivers/net/netdevsim/dev.c                   |  44 ++-
>  include/net/devlink.h                         |  32 +-
>  include/uapi/linux/devlink.h                  |   2 +
>  lib/devres.c                                  |   1 +
>  net/core/devlink.c                            | 300 +++++++++++---
>  .../drivers/net/netdevsim/devlink.sh          |   5 +
>  23 files changed, 1091 insertions(+), 304 deletions(-)
>  create mode 100644 Documentation/networking/devlink/ice.rst
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h
> 

Thanks,
Jake
