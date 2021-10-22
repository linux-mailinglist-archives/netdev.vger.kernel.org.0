Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C884379FF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhJVPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:38:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:42037 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhJVPiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 11:38:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="226778478"
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="226778478"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:36:06 -0700
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="569231223"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:36:03 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1mdwa4-000917-Nn;
        Fri, 22 Oct 2021 18:35:40 +0300
Date:   Fri, 22 Oct 2021 18:35:40 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com
Subject: Re: [PATCH 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
Message-ID: <YXLaTOIydG6mML0m@smile.fi.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 01:27:24PM -0700, Ricardo Martinez wrote:
> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which is based on MediaTek's T700 modem to provide WWAN connectivity.
> The driver uses the WWAN framework infrastructure to create the following control ports and network interfaces:
> * /dev/wwan0mbim0 - Interface conforming to the MBIM protocol. Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards with [3][4] can use it to enable data communication towards WWAN.
> * /dev/wwan0at0 - Interface that supports AT commands.
> * wwan0 - Primary network interface for IP traffic.
> 
> The main blocks in t7xx driver are:
> * PCIe layer - Implements driver probe, removal, and power management callbacks.
> * Port-proxy - Provides a common interface to interact with different types of ports such as WWAN ports.
> * Modem control & status monitor - Implement the entry point for modem initialization, reset and exit, as well as exception handling.
> * CLDMA (Control Layer DMA) - Manages the HW used by the port layer to send control messages to the modem using MediaTek's CCCI (Cross-Core Communication Interface) protocol.
> * DPMAIF (Data Plane Modem AP Interface) - Controls the HW that provides uplink and downlink queues for the data path. The data exchange takes place using circular buffers to share data buffer addresses and metadata to describe the packets.
> * MHCCIF (Modem Host Cross-Core Interface) - Provides interrupt channels for bidirectional event notification such as handshake, exception, PM and port enumeration.
> 
> The compilation of the t7xx driver is enabled by the CONFIG_MTK_T7XX config option which depends on CONFIG_WWAN.
> This driver was originally developed by MediaTek. Intel adapted t7xx to the WWAN framework, optimized and refactored the driver source in close collaboration with MediaTek. This will enable getting the t7xx driver on Approved Vendor List for interested OEM's and ODM's productization plans with Intel 5G 5000 M.2 solution.
> 

Something wrong with indentation here. Please, be sure that you have it packed
to ~76 characters per line.

> List of contributors:
> Amir Hanania <amir.hanania@intel.com>
> Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
> Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Dinesh Sharma <dinesh.sharma@intel.com>
> Eliot Lee <eliot.lee@intel.com>
> Haijun Liu <haijun.liu@mediatek.com>
> M Chetan Kumar <m.chetan.kumar@intel.com>
> Mika Westerberg <mika.westerberg@linux.intel.com>
> Moises Veleta <moises.veleta@intel.com>
> Pierre-louis Bossart <pierre-louis.bossart@intel.com>
> Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Muralidharan Sethuraman <muralidharan.sethuraman@intel.com>
> Soumya Prakash Mishra <Soumya.Prakash.Mishra@intel.com>
> Sreehari Kancharla <sreehari.kancharla@intel.com>
> Suresh Nagaraj <suresh.nagaraj@intel.com>

You mentioned all these people and only few are in Cc list.
Note, you may utilize `git format-patch --cc ...` for that.

> [1] https://www.freedesktop.org/software/libmbim/
> [2] https://www.freedesktop.org/software/ModemManager/
> [3] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/582
> [4] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/523
> 
> Ricardo Martinez (14):
>   net: wwan: Add default MTU size
>   net: wwan: t7xx: Add control DMA interface
>   net: wwan: t7xx: Add core components
>   net: wwan: t7xx: Add port proxy infrastructure
>   net: wwan: t7xx: Add control port
>   net: wwan: t7xx: Add AT and MBIM WWAN ports
>   net: wwan: t7xx: Data path HW layer
>   net: wwan: t7xx: Add data path interface
>   net: wwan: t7xx: Add WWAN network interface
>   net: wwan: t7xx: Introduce power management support
>   net: wwan: t7xx: Runtime PM
>   net: wwan: t7xx: Device deep sleep lock/unlock
>   net: wwan: t7xx: Add debug and test ports
>   net: wwan: t7xx: Add maintainers and documentation
> 
>  .../networking/device_drivers/wwan/index.rst  |    1 +
>  .../networking/device_drivers/wwan/t7xx.rst   |  120 ++
>  MAINTAINERS                                   |   11 +
>  drivers/net/wwan/Kconfig                      |   14 +
>  drivers/net/wwan/Makefile                     |    1 +
>  drivers/net/wwan/t7xx/Makefile                |   24 +
>  drivers/net/wwan/t7xx/t7xx_cldma.c            |  270 +++
>  drivers/net/wwan/t7xx/t7xx_cldma.h            |  162 ++
>  drivers/net/wwan/t7xx/t7xx_common.h           |   69 +
>  drivers/net/wwan/t7xx/t7xx_dpmaif.c           | 1515 +++++++++++++++
>  drivers/net/wwan/t7xx/t7xx_dpmaif.h           |  160 ++
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c        | 1653 +++++++++++++++++
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.h        |  148 ++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c       |  630 +++++++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h       |  271 +++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c    | 1553 ++++++++++++++++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h    |  110 ++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c    |  834 +++++++++
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h    |   74 +
>  drivers/net/wwan/t7xx/t7xx_mhccif.c           |  118 ++
>  drivers/net/wwan/t7xx/t7xx_mhccif.h           |   29 +
>  drivers/net/wwan/t7xx/t7xx_modem_ops.c        |  741 ++++++++
>  drivers/net/wwan/t7xx/t7xx_modem_ops.h        |   84 +
>  drivers/net/wwan/t7xx/t7xx_monitor.h          |  140 ++
>  drivers/net/wwan/t7xx/t7xx_netdev.c           |  535 ++++++
>  drivers/net/wwan/t7xx/t7xx_netdev.h           |   56 +
>  drivers/net/wwan/t7xx/t7xx_pci.c              |  779 ++++++++
>  drivers/net/wwan/t7xx/t7xx_pci.h              |  114 ++
>  drivers/net/wwan/t7xx/t7xx_pcie_mac.c         |  270 +++
>  drivers/net/wwan/t7xx/t7xx_pcie_mac.h         |   29 +
>  drivers/net/wwan/t7xx/t7xx_port.h             |  155 ++
>  drivers/net/wwan/t7xx/t7xx_port_char.c        |  416 +++++
>  drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c    |  142 ++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.c       |  819 ++++++++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.h       |   94 +
>  drivers/net/wwan/t7xx/t7xx_port_tty.c         |  185 ++
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c        |  271 +++
>  drivers/net/wwan/t7xx/t7xx_reg.h              |  389 ++++
>  drivers/net/wwan/t7xx/t7xx_skb_util.c         |  354 ++++
>  drivers/net/wwan/t7xx/t7xx_skb_util.h         |  102 +
>  drivers/net/wwan/t7xx/t7xx_state_monitor.c    |  620 +++++++
>  drivers/net/wwan/t7xx/t7xx_tty_ops.c          |  200 ++
>  drivers/net/wwan/t7xx/t7xx_tty_ops.h          |   39 +
>  include/linux/wwan.h                          |    5 +
>  44 files changed, 14306 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/wwan/t7xx.rst
>  create mode 100644 drivers/net/wwan/t7xx/Makefile
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_common.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_monitor.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_char.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_tty.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.h
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.c
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.h
> 
> -- 
> 2.17.1
> 
> 

-- 
With Best Regards,
Andy Shevchenko


