Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA728173336
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 09:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgB1IrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 03:47:21 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:53144 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1IrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 03:47:21 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 03:47:19 EST
Received: from localhost.localdomain (p200300E9D71B9939E2C0865DB6B8C4EC.dip0.t-ipconnect.de [IPv6:2003:e9:d71b:9939:e2c0:865d:b6b8:c4ec])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 53515C087E;
        Fri, 28 Feb 2020 09:41:49 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [PATCH] net: ieee802154: ca8210: Use new structure for SPI
 transfer delays
To:     Sergiu Cuciurean <sergiu.cuciurean@analog.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org, davem@davemloft.net,
        alex.aring@gmail.com, h.morris@cascoda.com
References: <20200227131245.30309-1-sergiu.cuciurean@analog.com>
Message-ID: <70e215d7-b523-8aff-d0bc-eea6bfce3dac@datenfreihafen.org>
Date:   Fri, 28 Feb 2020 09:41:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227131245.30309-1-sergiu.cuciurean@analog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 27.02.20 14:12, Sergiu Cuciurean wrote:
> In a recent change to the SPI subsystem [1], a new `delay` struct was added
> to replace the `delay_usecs`. This change replaces the current
> `delay_usecs` with `delay` for this driver.
> 
> The `spi_transfer_delay_exec()` function [in the SPI framework] makes sure
> that both `delay_usecs` & `delay` are used (in this order to preserve
> backwards compatibility).
> 
> [1] commit bebcfd272df6 ("spi: introduce `delay` field for
> `spi_transfer` + spi_transfer_delay_exec()")
> 
> Signed-off-by: Sergiu Cuciurean <sergiu.cuciurean@analog.com>
> ---
>   drivers/net/ieee802154/ca8210.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 430c93786153..e04c3b60cae7 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -946,7 +946,8 @@ static int ca8210_spi_transfer(
>   	cas_ctl->transfer.bits_per_word = 0; /* Use device setting */
>   	cas_ctl->transfer.tx_buf = cas_ctl->tx_buf;
>   	cas_ctl->transfer.rx_buf = cas_ctl->tx_in_buf;
> -	cas_ctl->transfer.delay_usecs = 0;
> +	cas_ctl->transfer.delay.value = 0;
> +	cas_ctl->transfer.delay.unit = SPI_DELAY_UNIT_USECS;
>   	cas_ctl->transfer.cs_change = 0;
>   	cas_ctl->transfer.len = sizeof(struct mac_message);
>   	cas_ctl->msg.complete = ca8210_spi_transfer_complete;
> 


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
