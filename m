Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12E2A008F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgJ3I7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3I7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 04:59:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C2C0613D2;
        Fri, 30 Oct 2020 01:59:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r186so4668223pgr.0;
        Fri, 30 Oct 2020 01:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFyha+jVWs3vNAUNnCwlqigcK5fuTIaB3MtArdLXUM0=;
        b=D3eRChZMk3Ya3kNvefizgHTyq1bXsF7+MKPHNGuBnYSiseVZapuqwII/RifglV4+yG
         kP5IhURWpWVadOMYibOzQ8YpDo5JAz+6nPcMGtXN0HeWbgIBzXVMxXCvm/XCg+lPvy8K
         nHTyidfA/0A0jWRLxeOsIgeTGNh65E9T+xy093U7V9Y57GH0a+7CJzyZlAHHNv5808IS
         KMU4/vfsuORPz7RqybcpihpXLy5t9bm20t4OGTgIxX7RWod0/jqjHu+Zzf0psLj/zW+I
         oDCr3OdYF4vELku89NtEq6YEhvbUjLPnJfWHXmQReUUfDRIU+XFSKN63/VVYk1L/NC1t
         6VQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFyha+jVWs3vNAUNnCwlqigcK5fuTIaB3MtArdLXUM0=;
        b=WHcoDXSKmlrV2IgvqlU9oXqF6QdWyYpDRGycQzalwqYfJe5oApruB4GyvbaCZ+OCo4
         ICw4MupRK5EmH4nf8//rAglQ0JhBvXKt5+mqSpWSWexn32EORQfLbeLmYcAHtPVa1YrJ
         i/N0VilYico4htGiCgrzzP7Tma2rXT1WvU47tAAKX0Xjl3f1Iiu4vD0MYhHv9eCPFYX2
         ipYk6Ku6567xp+G/5Mn+aBVk3CIB024I/YRL5+IwvMEsi5seDYSS0mj2Zth8ZD4ZEZgK
         OeuUUxmdqpgvOs61/eUTWGU16PVbo4eirU3Fc4GV2ZG2UwuYejOW+T9O37JX1xQpRGpV
         HH4g==
X-Gm-Message-State: AOAM531SduqThDlVt80VLBZgHsFSUscuGR3rsGC2LutkuyAZ65i4FQYp
        lh9y1vzTJ1RvYoxun4jnDG0=
X-Google-Smtp-Source: ABdhPJz/R9c4Iy6G4XviW5KzXZZpA0IND4BWkLkmfiWXAU4xIK7t+Ur7Nr8rLnlySsy0SIOXC1MNbw==
X-Received: by 2002:a17:90a:1f0b:: with SMTP id u11mr1596212pja.105.1604048354235;
        Fri, 30 Oct 2020 01:59:14 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:33f6:681c:5049:8b27])
        by smtp.gmail.com with ESMTPSA id n19sm5200786pfu.24.2020.10.30.01.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:59:13 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: wan: sdla: Use bitwise instead of arithmetic
Date:   Fri, 30 Oct 2020 01:58:59 -0700
Message-Id: <20201030085859.448125-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <1603873191-106077-1-git-send-email-zou_wei@huawei.com>
References: <1603873191-106077-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fix the following coccinelle warnings:
>
> ./drivers/net/wan/sdla.c:841:38-39: WARNING: sum of probable bitmasks, consider |
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/wan/sdla.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
> index bc2c1c7..cf43f4c 100644
> --- a/drivers/net/wan/sdla.c
> +++ b/drivers/net/wan/sdla.c
> @@ -838,7 +838,8 @@ static void sdla_receive(struct net_device *dev)
>  		case SDLA_S502A:
>  		case SDLA_S502E:
>  			if (success)
> -				__sdla_read(dev, SDLA_502_RCV_BUF + SDLA_502_DATA_OFS, skb_put(skb,len), len);
> +				__sdla_read(dev, SDLA_502_RCV_BUF | SDLA_502_DATA_OFS,
> +					    skb_put(skb, len), len);
>  
>  			SDLA_WINDOW(dev, SDLA_502_RCV_BUF);
>  			cmd->opp_flag = 0;

No, this is not a bit-OR. This is a sum. The argument is an address,
SDLA_502_RCV_BUF is a base address, SDLA_502_DATA_OFS is an offset.
They should be sumed instead of bit-OR'ed.
