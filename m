Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88F455F11
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKRPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:12:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:21502 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhKRPMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 10:12:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="214916215"
X-IronPort-AV: E=Sophos;i="5.87,245,1631602800"; 
   d="scan'208";a="214916215"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 07:09:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,245,1631602800"; 
   d="scan'208";a="455357569"
Received: from mylly.fi.intel.com (HELO [10.237.72.56]) ([10.237.72.56])
  by orsmga006.jf.intel.com with ESMTP; 18 Nov 2021 07:09:36 -0800
Subject: Re: [PATCH net] can: m_can: pci: fix iomap_read_fifo() and
 iomap_write_fifo()
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Matt Kline <matt@bitbashing.io>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211118144011.10921-1-matthias.schiffer@ew.tq-group.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <ca1c6275-1609-466e-95b5-d7ad5083f666@linux.intel.com>
Date:   Thu, 18 Nov 2021 17:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211118144011.10921-1-matthias.schiffer@ew.tq-group.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 4:40 PM, Matthias Schiffer wrote:
> The same fix that was previously done in m_can_platform in commit
> 99d173fbe894 ("can: m_can: fix iomap_read_fifo() and iomap_write_fifo()")
> is required in m_can_pci as well to make iomap_read_fifo() and
> iomap_write_fifo() work for val_count > 1.
> 
> Fixes: 812270e5445b ("can: m_can: Batch FIFO writes during CAN transmit")
> Fixes: 1aa6772f64b4 ("can: m_can: Batch FIFO reads during CAN receive")
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
>   drivers/net/can/m_can/m_can_pci.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
I tested this on top of plain v5.15 (v5.16-rc1 has some rootfs 
regression on my EHL HW) where my test case was receiving zeros and this 
makes it working again like in v5.14 and earlier.

Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
