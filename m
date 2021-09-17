Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396864100F7
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhIQV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:58:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:18040 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhIQV61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 17:58:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="308425861"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="308425861"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:57:02 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="510091610"
Received: from jfetherl-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.77.105])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:57:01 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Ederson de Souza <ederson.desouza@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH -net] igc: fix build errors for PTP
In-Reply-To: <20210917210547.12578-1-rdunlap@infradead.org>
References: <20210917210547.12578-1-rdunlap@infradead.org>
Date:   Fri, 17 Sep 2021 14:57:01 -0700
Message-ID: <8735q2yifm.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> When IGC=y and PTP_1588_CLOCK=m, the ptp_*() interface family is
> not available to the igc driver. Make this driver depend on
> PTP_1588_CLOCK_OPTIONAL so that it will build without errors.
>
> Various igc commits have used ptp_*() functions without checking
> that PTP_1588_CLOCK is enabled. Fix all of these here.
>
> Fixes these build errors:
>
> ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_msix_other':
> igc_main.c:(.text+0x6494): undefined reference to `ptp_clock_event'
> ld: igc_main.c:(.text+0x64ef): undefined reference to `ptp_clock_event'
> ld: igc_main.c:(.text+0x6559): undefined reference to `ptp_clock_event'
> ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':
> igc_ethtool.c:(.text+0xc7a): undefined reference to `ptp_clock_index'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_feature_enable_i225':
> igc_ptp.c:(.text+0x330): undefined reference to `ptp_find_pin'
> ld: igc_ptp.c:(.text+0x36f): undefined reference to `ptp_find_pin'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_init':
> igc_ptp.c:(.text+0x11cd): undefined reference to `ptp_clock_register'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_stop':
> igc_ptp.c:(.text+0x12dd): undefined reference to `ptp_clock_unregister'
> ld: drivers/platform/x86/dell/dell-wmi-privacy.o: in function `dell_privacy_wmi_probe':
>
> Fixes: 64433e5bf40ab ("igc: Enable internal i225 PPS")
> Fixes: 60dbede0c4f3d ("igc: Add support for ethtool GET_TS_INFO command")
> Fixes: 87938851b6efb ("igc: enable auxiliary PHC functions for the i225")
> Fixes: 5f2958052c582 ("igc: Add basic skeleton for PTP")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ederson de Souza <ederson.desouza@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


-- 
Vinicius
