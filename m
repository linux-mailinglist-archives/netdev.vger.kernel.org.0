Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B1103071
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKSX43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:56:29 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34134 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfKSX42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:56:28 -0500
Received: by mail-lj1-f195.google.com with SMTP id 139so25408865ljf.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0jp7ymXVHF/WM+oFEqNZ5VbCf4HcI/0TFnKc4tfkuds=;
        b=Ihcmnpgnu8MYmNNJl3RS4VGiMd5bnE4X6TuJI7Ck0HrEV1hRAu9McjfP/EFmcRP7LX
         560sS0MWxuJTawwvWFOQeVCT1pXN2wpWEZ/pDCZmIiMmvW1QCDHBg+TEDMN+7FG6t+8s
         lseEG2LvDUGY29KyZNPrtJqA6jWuv0YVnAEcaoxu3gCMsR2C8Ib42oE6IrdB6IplvHs5
         My+6Dfks4celMvnlMWyEBdJg+/oAQFLuzMMuT5fcXIivrIwSUmtIe4OFt/hkkDV+qpNJ
         LHmd5Gu2O0eux43V2TaAYlHZdZsmhrWW2LxpjaYIkh3/Wn3zZInsSuGfwGjHeEK5Eqf8
         WX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0jp7ymXVHF/WM+oFEqNZ5VbCf4HcI/0TFnKc4tfkuds=;
        b=GYK1J9RcH07cqSBpo7Y9DCE/Wl5V3Xhwru5MCiYKVAKDnW+qJYuz/j85OW8ODuT2rt
         qIdcwgal/Q0Hayz4N6NGrL01T/pJ73isF5Vi7LqjvVM2NbGDMDAKviy7BwkKsp+bdNnE
         5VEG6hS2bEYYlIuU2eO8IJyE4D8Jmz58Cmc7wGFbxmE+pWC4y7lPUXw2yKK0yxqAP5tP
         ikuXZJw2OwFvTaAdYO0wPDRSH47f9diaF4JL0BXP9q/DALANF7Zt9y4lJEXWitfGSRm1
         pMbj4shqXTHEMiTZyo/0caF1weilaJ43S9OPK1G+02JcOj3S+kPtsD8oXPuAmQ3sodjG
         I2pA==
X-Gm-Message-State: APjAAAXnT4v3MJ/lcVs57DN5T+DfuDbue6lM36D5P4L2haoy70vikOA4
        +09CMqk+s1sFOvSMackDenXNwA==
X-Google-Smtp-Source: APXvYqz/pNFKY4zQZHmOGbtpSDuBwhiMNpS62XtoswkQT0B7JlJz2aHe0kR5lZVGNyMRfqfBPXwX1g==
X-Received: by 2002:a2e:2a42:: with SMTP id q63mr108780ljq.180.1574207786905;
        Tue, 19 Nov 2019 15:56:26 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r15sm5821493lfp.36.2019.11.19.15.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 15:56:26 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:56:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next v2 2/3] net: ena: Implement XDP_TX action
Message-ID: <20191119155609.4a4c54d7@cakuba.netronome.com>
In-Reply-To: <20191119133419.9734-3-sameehj@amazon.com>
References: <20191119133419.9734-1-sameehj@amazon.com>
        <20191119133419.9734-3-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 15:34:18 +0200, sameehj@amazon.com wrote:
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 35f766d9c..087f132e0 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -35,7 +35,6 @@
>  #ifdef CONFIG_RFS_ACCEL
>  #include <linux/cpu_rmap.h>
>  #endif /* CONFIG_RFS_ACCEL */
> -#include <linux/bpf_trace.h>
>  #include <linux/ethtool.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -47,6 +46,7 @@
>  #include <net/ip.h>
>  
>  #include "ena_netdev.h"
> +#include <linux/bpf_trace.h>
>  #include "ena_pci_id_tbl.h"


Perhaps just add this header include where you want it in the first
patch? :/

> @@ -190,6 +194,17 @@ struct ena_tx_buffer {
>  	/* num of buffers used by this skb */
>  	u32 num_of_bufs;
>  
> +	/* XDP buffer structure which is used for sending packets in
> +	 * the xdp queues
> +	 */
> +	struct xdp_buff *xdp;

Isn't this structure declared on the stack of ena_clean_rx_irq()?
Perhaps you should consider using xdp_frame..

> +	/* The rx page for the rx buffer that was received in rx and
> +	 * re transmitted on xdp tx queues as a result of XDP_TX action.
> +	 * We need to free the page once we finished cleaning the buffer in
> +	 * clean_xdp_irq()
> +	 */
> +	struct page *xdp_rx_page;
> +
>  	/* Indicate if bufs[0] map the linear data of the skb. */
>  	u8 map_linear_data;
>  
