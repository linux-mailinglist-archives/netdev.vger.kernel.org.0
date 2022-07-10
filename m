Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505A656CFC9
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiGJP3L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 10 Jul 2022 11:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGJP3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 11:29:11 -0400
Received: from relay5.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C9CBC0B
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 08:29:09 -0700 (PDT)
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id 87FE8606D4;
        Sun, 10 Jul 2022 15:29:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 38F5B1C;
        Sun, 10 Jul 2022 15:28:59 +0000 (UTC)
Message-ID: <d278cf5d38235db92efa236cb1940a67e0e9a005.camel@perches.com>
Subject: Re: [PATCH v2] staging: qlge: Fix indentation issue under long for
 loop
From:   Joe Perches <joe@perches.com>
To:     Binyi Han <dantengknight@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Jul 2022 08:28:57 -0700
In-Reply-To: <20220710083657.GA3311@cloud-MacBookPro>
References: <20220710083657.GA3311@cloud-MacBookPro>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: ya9aox4dxt6jmokpwi3u4ibpj6fdjwfz
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 38F5B1C
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18MMIH/rAUYJLoy7RFAI1JS5jG+C9I8+Fg=
X-HE-Tag: 1657466939-484765
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-07-10 at 01:36 -0700, Binyi Han wrote:
> Fix indentation issue to adhere to Linux kernel coding style,
> Issue found by checkpatch. And change the long for loop into 3 lines.
> 
> Signed-off-by: Binyi Han <dantengknight@gmail.com>
> ---
> v2:
> 	- Change the long for loop into 3 lines.
> 
>  drivers/staging/qlge/qlge_main.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 1a378330d775..6e771d0e412b 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3007,10 +3007,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  		tmp = (u64)rx_ring->lbq.base_dma;
>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
>  
> -		for (page_entries = 0; page_entries <
> -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +		for (page_entries = 0;
> +			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> +			page_entries++)
> +			base_indirect_ptr[page_entries] =
> +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));

Better to align page_entries to the open parenthesis.

And another optimization would be to simply add DB_PAGE_SIZE to tmp
in the loop and avoid the multiply.

		for (page_entries = 0;
		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
		     page_entries++) {
			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
			tmp += DB_PAGE_SIZE;
		}

> @@ -3022,10 +3023,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  		tmp = (u64)rx_ring->sbq.base_dma;
>  		base_indirect_ptr = rx_ring->sbq.base_indirect;
>  
> -		for (page_entries = 0; page_entries <
> -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +		for (page_entries = 0;
> +			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> +			page_entries++)
> +			base_indirect_ptr[page_entries] =
> +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));

here too

