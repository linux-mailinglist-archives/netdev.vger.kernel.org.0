Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BBF419D45
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbhI0Rrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbhI0Rrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 13:47:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2F2C061604;
        Mon, 27 Sep 2021 10:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=nupAYdVd/L9EJ9TKD+Kr1KJXgckH0yIhskHZjtigLq4=; b=YCSbayd/IXfFev4BOg+sI0IMgf
        DGrnCgHR+/iiUZdxn9NT7LO54pxmHqPD2GisW2GT7+rjLh8AmMeG/GluK9DNrUGsIME0oDtFyCiiY
        lHfA8xtw40JH3jhlMPGbuQcITHQWUjXg18y/t7zAsvGnEzjrcmOoeP+o89BKhgjjNZc1PENEPh4D5
        R63dr0G1z9FIXV0dUX4HTUJxeMt8rYNPmhTCmpw8+pDdmVaEIQg4lpjM+Lk5qHfiXyw1ns2HMAVZ0
        4IDFKxKM1lzN0R55SVCvyBQr3pSFX0bdqjQ71HmZG2xauet9bifcAaqz6B62Y+OLuSsXDKtCHipNA
        fQ6KtviA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUuUw-003chs-Vy; Mon, 27 Sep 2021 17:33:03 +0000
Subject: Re: [PATCH] igc: fix PTP dependency
To:     Arnd Bergmann <arnd@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Dave Ertman <david.m.ertman@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210927131730.1587671-1-arnd@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <938261c5-62c7-dc0d-d4bb-fd45f20063bf@infradead.org>
Date:   Mon, 27 Sep 2021 10:33:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927131730.1587671-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 6:17 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The igc driver was accidentally left out of the Kconfig rework for PTP,
> it needs the same dependency as the others:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_tsync_interrupt':
> igc_main.c:(.text+0x1b288): undefined reference to `ptp_clock_event'
> arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b308): undefined reference to `ptp_clock_event'
> arm-linux-gnueabi-ld: igc_main.c:(.text+0x1b8cc): undefined reference to `ptp_clock_event'
> arm-linux-gnueabi-ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':
> 
> Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Same patch is already merged in mainline.
Thanks.

(Sorry if someone receives my reply 2x. I had an email glitch.)

> ---
>   drivers/net/ethernet/intel/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index b0b6f90deb7d..ed8ea63bb172 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -335,6 +335,7 @@ config IGC
>   	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
>   	default n
>   	depends on PCI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>   	help
>   	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
>   	  family of adapters.
> 


-- 
~Randy
