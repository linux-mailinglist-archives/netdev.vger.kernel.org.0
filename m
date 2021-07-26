Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F413D6835
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhGZT4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhGZT4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 15:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E68060F23;
        Mon, 26 Jul 2021 20:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627331795;
        bh=HfQsMWlTTFO+J6sGnODlHkVipfoWKzy95l9j0DhdDnk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=oFyLm5G3WEPynq1qxFE/fPymF0gEch8Sdv0Q7ZU1e199VBHimmAyAkrBgQfvRnigR
         izd10GlwoqHBLInSeauP7Ek2nH0HoL9/Bez0/YKS3P1KPZCRe7mlUdLWHOS266tI7G
         FH9I2+YP0ukFvhQFQGbo/JTVMbUDUmZdiv1PflQP/rPP29+g85JEUglBWnztwduj/p
         A9Ac2aRkLR8wSBD2hkNZ/07qUkJxNUId6Gg2i765eZwvzfjS0Ovb/DFNoO/iouMVw8
         Sr2qpfAiVGIuLOQCx+exqrIm0YqjtRFwwpQAbgWIZcRaQ043U7uIqenxnTDYHIQdz0
         opF5m0kPYlTuw==
Subject: Re: [PATCH v2 2/3] bnx2x: remove unused variable 'cur_data_offset'
To:     Bill Wendling <morbo@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20210714091747.2814370-1-morbo@google.com>
 <20210726201924.3202278-1-morbo@google.com>
 <20210726201924.3202278-3-morbo@google.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <d86ec071-00bf-e379-bdc6-c68da44ec5b7@kernel.org>
Date:   Mon, 26 Jul 2021 13:36:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726201924.3202278-3-morbo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/2021 1:19 PM, 'Bill Wendling' via Clang Built Linux wrote:
> Fix the clang build warning:
> 
>    drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1862:13: error: variable 'cur_data_offset' set but not used [-Werror,-Wunused-but-set-variable]
>          dma_addr_t cur_data_offset;
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

It has been unused since the function's introduction in commit 
67c431a5f2f3 ("bnx2x: Support statistics collection for VFs by the PF"), 
perhaps a leftover remnant from a previous version?

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index 27943b0446c2..f255fd0b16db 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -1858,7 +1858,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
>   {
>   	int i;
>   	int first_queue_query_index, num_queues_req;
> -	dma_addr_t cur_data_offset;
>   	struct stats_query_entry *cur_query_entry;
>   	u8 stats_count = 0;
>   	bool is_fcoe = false;
> @@ -1879,10 +1878,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
>   	       BNX2X_NUM_ETH_QUEUES(bp), is_fcoe, first_queue_query_index,
>   	       first_queue_query_index + num_queues_req);
>   
> -	cur_data_offset = bp->fw_stats_data_mapping +
> -		offsetof(struct bnx2x_fw_stats_data, queue_stats) +
> -		num_queues_req * sizeof(struct per_queue_stats);
> -
>   	cur_query_entry = &bp->fw_stats_req->
>   		query[first_queue_query_index + num_queues_req];
>   
> @@ -1933,7 +1928,6 @@ void bnx2x_iov_adjust_stats_req(struct bnx2x *bp)
>   			       cur_query_entry->funcID,
>   			       j, cur_query_entry->index);
>   			cur_query_entry++;
> -			cur_data_offset += sizeof(struct per_queue_stats);
>   			stats_count++;
>   
>   			/* all stats are coalesced to the leading queue */
> 
