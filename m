Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABD8222DFD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGPVbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:31:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:57201 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgGPVbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:31:31 -0400
IronPort-SDR: NpHQXcjTYARRWCcUTKYp87hmWdRhgI5M8o+Bor5+t9hMuMZbmGnZCJwteDD1rJcDHblmzUIkU1
 6V7l0SGiB0PQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="211036082"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="211036082"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 14:31:30 -0700
IronPort-SDR: HqdD8ecSgkSaovWuYVA6b36KI2RJgrKEtJZW9F0wQSHS9LUf0qEDU1TFlXfZ2gKPhXZEtd2l2l
 c43D4B08nz3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361163179"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 14:31:30 -0700
Subject: Re: [PATCH net-next 0/3] Fully describe the waveform for PTP periodic
 output
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20200716212032.1024188-1-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <66d9ad0f-d808-77af-290a-ce1a4b3417e1@intel.com>
Date:   Thu, 16 Jul 2020 14:31:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716212032.1024188-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
> While using the ancillary pin functionality of PTP hardware clocks to
> synchronize multiple DSA switches on a board, a need arised to be able
> to configure the duty cycle of the master of this PPS hierarchy.
> 
> Also, the PPS master is not able to emit PPS starting from arbitrary
> absolute times, so a new flag is introduced to support such hardware
> without making guesses.
> 
> With these patches, struct ptp_perout_request now basically describes a
> general-purpose square wave.

Nice!

> 
> Vladimir Oltean (3):
>   ptp: add ability to configure duty cycle for periodic output
>   ptp: introduce a phase offset in the periodic output request
>   net: mscc: ocelot: add support for PTP waveform configuration
> 
>  drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
>  drivers/ptp/ptp_chardev.c              | 33 +++++++++---
>  include/uapi/linux/ptp_clock.h         | 34 ++++++++++--
>  3 files changed, 107 insertions(+), 34 deletions(-)
> 
