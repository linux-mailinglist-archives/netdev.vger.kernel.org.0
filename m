Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B161ADC32B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408465AbfJRK4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:56:43 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:55042 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390222AbfJRK4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 06:56:43 -0400
Received: from [167.98.27.226] (helo=[10.35.5.173])
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iLPw1-0008Fq-1S; Fri, 18 Oct 2019 11:56:41 +0100
Subject: Re: [PATCH] ptp_pch: include ethernet driver for external functions
To:     linux-kernel@lists.codethink.co.uk
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191018105128.4382-1-ben.dooks@codethink.co.uk>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <27a1e096-5bb6-a616-eee8-855e4fe424f7@codethink.co.uk>
Date:   Fri, 18 Oct 2019 11:56:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018105128.4382-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2019 11:51, Ben Dooks (Codethink) wrote:
> The driver uses a number of functions from the ethernet driver
> so include the header to remove the following warnings from
> sparse about undeclared functions:
> 
> drivers/ptp/ptp_pch.c:182:5: warning: symbol 'pch_ch_control_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:193:6: warning: symbol 'pch_ch_control_write' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:201:5: warning: symbol 'pch_ch_event_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:212:6: warning: symbol 'pch_ch_event_write' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:220:5: warning: symbol 'pch_src_uuid_lo_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:231:5: warning: symbol 'pch_src_uuid_hi_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:242:5: warning: symbol 'pch_rx_snap_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:259:5: warning: symbol 'pch_tx_snap_read' was not declared. Should it be static?
> drivers/ptp/ptp_pch.c:300:5: warning: symbol 'pch_set_station_address' was not declared. Should it be static?
> 
> Should we include the header file from the ethernet driver directly
> or if not, where should the declarations go?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/ptp/ptp_pch.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
> index dcd6e00c8046..2bb1184b6359 100644
> --- a/drivers/ptp/ptp_pch.c
> +++ b/drivers/ptp/ptp_pch.c
> @@ -20,6 +20,8 @@
>   #include <linux/ptp_clock_kernel.h>
>   #include <linux/slab.h>
>   
> +#include <../net/ethernet/oki-semi/pch_gbe/pch_gbe.h>

oops, missed saving the version with ../../drivers/net

> +
>   #define STATION_ADDR_LEN	20
>   #define PCI_DEVICE_ID_PCH_1588	0x8819
>   #define IO_MEM_BAR 1
> 


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
