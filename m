Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAAA28AC06
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgJLCYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLCYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:24:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFB5C0613CE;
        Sun, 11 Oct 2020 19:24:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j7so2092821pgk.5;
        Sun, 11 Oct 2020 19:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QTY4U4+6Sbw73VZ7+xXUxoGTOblZuC8XJ4f2Cm9gN2M=;
        b=RUrhrwlvqSDsUPNCIbmcRUckVMfC4Enu9Ygq4L5yDTueMlxkTbAGTdtYm7jOMebNvN
         IGFDiyl8LSrAOBxcBCv35gZOYRY6vQ8kePJEb1xCCy3gIOVp8bWtZ1BCnYu+0rxzdkUz
         mrf4Y7fvmeMqmQ1jXkQquPdOeOPTwyH7CftVKKQmBH+i1DRB0cbaZgM5UMquot1I0PH7
         UqvSV0uD4p7fvQlH8Lrf4dv0BNQxxU0e+fFQGanxh/QxQJ+/2sLOq6cV4pVCcFToPB3b
         +4GeMQFleabVe1MC9JhEeu/golZWD5SM6X+DwYgtKxV+lhiEUPj6urer9KjKjNx4gT5Y
         WqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QTY4U4+6Sbw73VZ7+xXUxoGTOblZuC8XJ4f2Cm9gN2M=;
        b=c466/3KdztEFexmPXjTCSvG/hicnxexkXmzJhRaUn8sRBgBOcRvURPhI7Cn0q+sjUL
         EBrLOAKeRpLbLQ8XAcxx9TyGZJIX9icLT3BMeX4Ic5R59tjNtjdLNr8VT6a6Azmws0Ua
         TQWoXRhNIPJJTwnvP76FbV4qW2oJLHhrNvAu1DGOfNi3X+4SWzaFwbBoQfi704yTmXnv
         KLpXXvM05tHTGA52iHU94tfWG1HERrmzkqLfv3OzJkujXI/RzaaUrcglC5/BpAS4oAai
         XL8XOTwqKzkmQKpu68hTSJgSCpl1CCwRHURIZQ/w0UnLA5c0L+mqPhFcQbRj46mL5r0E
         SyZQ==
X-Gm-Message-State: AOAM533NECaVt4/rkjhq4ZepRmA6jjhbo9eX5pXrNblZvqDtlsOc+AMY
        rMfbf0w6CrLx5zS1CjeZSqlcr6WbJbI=
X-Google-Smtp-Source: ABdhPJzZjUPvgYWPF02xUtu6ivhmaimfPJKfU7fIKnA+i72lKbKpgN3Pry3uz73SMdubM2fF5E4XxQ==
X-Received: by 2002:a17:90b:1392:: with SMTP id hr18mr3040539pjb.182.1602469471193;
        Sun, 11 Oct 2020 19:24:31 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45e1:2200::1])
        by smtp.gmail.com with ESMTPSA id n67sm17206369pgn.14.2020.10.11.19.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 19:24:30 -0700 (PDT)
Date:   Sun, 11 Oct 2020 19:24:28 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     trix@redhat.com
Cc:     yhchuang@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rtw88: fix fw_fifo_addr check
Message-ID: <20201012022428.GA936980@ubuntu-m3-large-x86>
References: <20201011155438.15892-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201011155438.15892-1-trix@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 08:54:38AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The clang build reports this warning
> 
> fw.c:1485:21: warning: address of array 'rtwdev->chip->fw_fifo_addr'
>   will always evaluate to 'true'
>         if (!rtwdev->chip->fw_fifo_addr) {
> 
> fw_fifo_addr is an array in rtw_chip_info so it is always
> nonzero.  A better check is if the first element of the array is
> nonzero.  In the cases where fw_fifo_addr is initialized by rtw88b
> and rtw88c, the first array element is 0x780.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 042015bc8055..b2fd87834f23 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1482,7 +1482,7 @@ static bool rtw_fw_dump_check_size(struct rtw_dev *rtwdev,
>  int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
>  		     u32 *buffer)
>  {
> -	if (!rtwdev->chip->fw_fifo_addr) {
> +	if (!rtwdev->chip->fw_fifo_addr[0]) {
>  		rtw_dbg(rtwdev, RTW_DBG_FW, "chip not support dump fw fifo\n");
>  		return -ENOTSUPP;
>  	}
> -- 
> 2.18.1
> 
