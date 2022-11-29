Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B1963C86F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbiK2Tbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiK2Tbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:31:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644792186
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:31:24 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ml11so11383943ejb.6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eTC+17dz5iC2B/Hvo+LuxqCqxZ4LqBI2XEUyEg2XDmA=;
        b=ofYW+uv9UYJnP91ilZTdtGPhUR6B52UgXxKZPW94007FgbRp9GP4e0xLzVmcwfsQoZ
         YhaColrHgziQmndVFfDm41QXOiJb8IPijr8y36Qlcai1AelRWJrF3yn0hAejuh4JehaA
         ubbGe7Ty8ZXv8b7SWqiRLaIkcZNcg8dUt+8GcWOn5QXLjo7D5w1nL9aXjkLop4FHXof4
         EoltR7gqkVo9+bhIGbUa41rIRBBslxqWNRdJ6nCbJo5jZ2X5AUTOi+DmdSLuqFQD5rEF
         fTjCwtgEQlazwhsdD+Xgq7toHH4IhxIj5YKE++9dWyL6h4SRdg2UaTj/HRbnVJqBQI3g
         /Ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTC+17dz5iC2B/Hvo+LuxqCqxZ4LqBI2XEUyEg2XDmA=;
        b=aOqoKTnl08m+aEsySrbr/UnPxN+CrjR1gWMkqzvMyMyBFSHuqz6M/BK7JKUfiNCt74
         oM1zxbrmWMPz3wlHymkncOgMQI1rdbq/L5JfLMy9Efto8zrKLpjasq6RFTW1PT42En3t
         ekybZNB+utivIMQmfbYS9pFJckHgMLwbKR/CcnO70lktUgFoZkK+y7zBxvjJsgH/dIqZ
         D+mktIDAyJ3xOJaSCvS3V3zu4TXK309OL5nu6tMAObDlsvW9CEPPxKEoShzgztd3lrvz
         J+DZkpOyZzZ+NfDY9b7EmMSiH8xk3eSmRfB9FSC3t9jkJcjJUWiD8wPayl/eZ276GdIb
         beyA==
X-Gm-Message-State: ANoB5pkYuRLxgui6N6TDm4GVTq0YqqpwBeOgZdGM832LhtrdmFCIvZgA
        La6H/qg84G4d8mmsfdjnP+2ZFpd7tN8SFA==
X-Google-Smtp-Source: AA0mqf7Gn9KS+fEI8cUNR2mNdzWZ6hCwQ6dPvI6uIU/YZVBJQ7dw6gz77101wQ5blNwkcUzzgc9EvQ==
X-Received: by 2002:a17:906:ccd2:b0:7bd:fe2a:efef with SMTP id ot18-20020a170906ccd200b007bdfe2aefefmr14634788ejb.158.1669750282675;
        Tue, 29 Nov 2022 11:31:22 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b0078194737761sm6492385ejc.124.2022.11.29.11.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 11:31:21 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id E5D46BE2DE0; Tue, 29 Nov 2022 20:31:20 +0100 (CET)
Date:   Tue, 29 Nov 2022 20:31:20 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, edumazet@google.com, pabeni@redhat.com,
        didi.debian@cknow.org
Subject: Re: [PATCH v2 net 2/4] net: wwan: iosm: fix dma_alloc_coherent
 incompatible pointer type
Message-ID: <Y4ZeCIvLoVFFqrKz@eldamar.lan>
References: <20221124103803.1446000-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124103803.1446000-1-m.chetan.kumar@linux.intel.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 24, 2022 at 04:08:03PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Fix build error reported on armhf while preparing 6.1-rc5
> for Debian.
> 
> iosm_ipc_protocol.c:244:36: error: passing argument 3 of
> 'dma_alloc_coherent' from incompatible pointer type.
> 
> Change phy_ap_shm type from phys_addr_t to dma_addr_t.
> 
> Fixes: faed4c6f6f48 ("net: iosm: shared memory protocol")
> Reported-by: Bonaccorso Salvatore <carnil@debian.org>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> --
> v2: No Change.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_protocol.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.h b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
> index 9b3a6d86ece7..289397c4ea6c 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_protocol.h
> +++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
> @@ -122,7 +122,7 @@ struct iosm_protocol {
>  	struct iosm_imem *imem;
>  	struct ipc_rsp *rsp_ring[IPC_MEM_MSG_ENTRIES];
>  	struct device *dev;
> -	phys_addr_t phy_ap_shm;
> +	dma_addr_t phy_ap_shm;
>  	u32 old_msg_tail;
>  };

FTR, confirmed now as well on the official build infrastrcture, with
the commit applied:
https://buildd.debian.org/status/fetch.php?pkg=linux&arch=armhf&ver=6.1%7Erc6-1%7Eexp1&stamp=1669504139&raw=0

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Regards,
Salvatore
