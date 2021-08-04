Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8CA3E099E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhHDUvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhHDUu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 16:50:59 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58380C0613D5;
        Wed,  4 Aug 2021 13:50:45 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id g13so6647379lfj.12;
        Wed, 04 Aug 2021 13:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KuX2nZN6oxnkjT2+Ul+G9XcJgN0y9zUMTpdYgLkps1M=;
        b=aLLT2WMnJaB4DDV9rb0esrzta5Rq13NILvpwdHxvjGhlE+kLPbtxtQu2VsJd/jUuYv
         kZfiXsRJjhdj4Jv53r2XMsYFy90mMKmktwPPEw2rmC0d24QH2ma1IQs8upvbmqmpDf/m
         pCn6yGFOJfnnzYbP/jDW/SEUJE3YMjjF8SWP8fPSv2XhlxmlMa2Rc8uPG6ah9l8/0Ib/
         LYpUarKcDdb2ixFZ8qDens2Wsa8/HTE/xnmPynLhZ3M+q17MhUr1I+6KJe6UKfYKhYPF
         n7Ys5wft1Drm+McE+wT9erDJy90CdCYnNBZWQZpWRtp85egrvOzt3KdT9WapACdhOGOT
         NClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KuX2nZN6oxnkjT2+Ul+G9XcJgN0y9zUMTpdYgLkps1M=;
        b=Rg2RUrNVOu3/z7GM+HA3ew7K6dUYtEpVIAYlTWqFj1/FM8bS74R9kgiUWStzHjqEji
         J8K+lF3e/joVjzI9QaDBMjhWyVwxaz4JNmY1sgnNTAnXEdbNpRGSoOGFP94VLB57LBTc
         SupLgvsf6Z4y3ftrp2u44SSI2WoNPFnjKFEYS78czQrkvIjaY8ECQmb4xZkcaZPWDG3T
         3V8+A7jxXwaK6RW8BNa3hsetifDakNKN/YD4hcEsFEggsXdH3f8khfc+O5NyGKSaj+ZS
         PbaSB8fB6VUKrA5NOIXSSUGUQexETsZCL3EExcOymaBhMmA4MV/Z1ErRRluNW98+B432
         qjHw==
X-Gm-Message-State: AOAM5332fRonko0h7sLfscDxIXCn5L0F1X7Pjtx6GBmGqdgSv849NYnB
        eoz0ZXoPo7Oy7/1kj3zQ2ys=
X-Google-Smtp-Source: ABdhPJzazXFRKR4ajGz5yML6j2znPd12Aw229fJqxkzLbr8fkB0qzCN8FJTWx09o8pfA6beF3QR9QQ==
X-Received: by 2002:a19:d609:: with SMTP id n9mr808225lfg.198.1628110243660;
        Wed, 04 Aug 2021 13:50:43 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.221])
        by smtp.gmail.com with ESMTPSA id z25sm295465lfh.283.2021.08.04.13.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:50:43 -0700 (PDT)
Subject: Re: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <24d63e2c-8f3b-9f75-a917-e7dc79085c84@gmail.com>
Date:   Wed, 4 Aug 2021 23:50:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> The register for retrieving TX drop counters is present only on R-Car Gen3
> and RZ/G2L; it is not present on R-Car Gen2.
> 
> Add the tx_drop_cntrs hw feature bit to struct ravb_hw_info, to enable this
> feature specifically for R-Car Gen3 now and later extend it to RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> v2:
>  * Incorporated Andrew and Sergei's review comments for making it smaller patch
>    and provided detailed description.
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 0d640dbe1eed..35fbb9f60ba8 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1001,6 +1001,7 @@ struct ravb_hw_info {
>  
>  	/* hardware features */
>  	unsigned internal_delay:1;	/* RAVB has internal delays */
> +	unsigned tx_drop_cntrs:1;	/* RAVB has TX error counters */

   I suggest 'tx_counters' -- this name comes from the sh_eth driver for the same regs
(but negated meaning). And please don't call the hardware RAVB. :-)

[...]

MBR, Sergei
