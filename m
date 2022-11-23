Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32D1636CAE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiKWV7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiKWV7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:59:00 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F060657E5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:58:58 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n20so343556ejh.0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EVgEISxn+olXyUZTOYbql2L83D41O9OBBtAPAhbpS3s=;
        b=Ks2MV+YHMRu2gaLNo0qFhgiAZS3tYcF5iUOw9Gakp6ybDhILLTmK/DkkwVZMtEAR3S
         iDFibWM1mwA/dPmJYdq3SOnu0nbNQusA7pdf/+7Bjhfsw2EUnVhcVvv0uePjEAwfCb7Q
         Ft+mT6PqDy+h09qWc0BXG2jP3wbbFUiHzPeyLzYEyyeJ41UzEepwY9FXKeqesBL3tYM4
         qjy++NKbLaDTbPdzDmZC9kK7I4EFk1xcahVtOLURtpVzZi2rEh8okHvpAi6T2QY4YyBW
         TA67WGbhCZjajN39qVTBo62hF4i9fdtu1wQcYdd4taKizMknuEGQXy7maEg0uMCFk7Q3
         PEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVgEISxn+olXyUZTOYbql2L83D41O9OBBtAPAhbpS3s=;
        b=hmPFuFDvKDLJJL2DLiuGzB/WRMQxn1G2BnAYVGfGl0f0xaXt82NJGxvFmR6ZTTfOei
         Eqmy10fVus9jpAExnbZhkuhyeaYkkqdP6LscAZCAu7/r3aYzCIJ8zUbd17rJbO4Xewfa
         KUD//mIcQl8919X2EmDEcosFWbDdULML22X958CZYjIYQZl/+bFfkdw8OTwuhkPlQ8Fy
         rmNBupOqOSV+YnfSRemd+ILJKWTxSXjoqp9L6ywQR3VI0Jv5o1T6rwgXPU0nOXj+ySAk
         p+ABKRxRbgnqkNLRRdvlFoL25bbHGoRkDl79cHB2mqiQnIwikIhTcuMgqI8BZhbyOOqA
         igEQ==
X-Gm-Message-State: ANoB5pkU/L8RLz17RDEbASjvkIyGDwB/Z99KKEnNGk/Ublwno01fk5I5
        O41pKkKlfBTEXEYCUQ9N3Cg=
X-Google-Smtp-Source: AA0mqf7QhqScGe+26t0QLUMqa3+31KAQA/QrQf5lr+BzjVzUo4lBfYg/TwVBQUk4F4KzM7Npo/Wd8Q==
X-Received: by 2002:a17:906:ca0e:b0:78c:1f2f:233e with SMTP id jt14-20020a170906ca0e00b0078c1f2f233emr10882298ejb.307.1669240736833;
        Wed, 23 Nov 2022 13:58:56 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id gq20-20020a170906e25400b007aece68483csm7571523ejb.193.2022.11.23.13.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 13:58:55 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id B7AB0BE2DE0; Wed, 23 Nov 2022 22:58:54 +0100 (CET)
Date:   Wed, 23 Nov 2022 22:58:54 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, didi.debian@cknow.org
Subject: Re: [PATCH net 2/4] net: wwan: iosm: fix dma_alloc_coherent
 incompatible pointer type
Message-ID: <Y36XniABNqw+7NNO@eldamar.lan>
References: <20221122174657.3496826-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122174657.3496826-1-m.chetan.kumar@linux.intel.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Nov 22, 2022 at 11:16:57PM +0530, m.chetan.kumar@linux.intel.com wrote:
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

The patch resolves the build failure we did notice. Only was able to
test the build though, no functional test on armhf.

Regards,
Salvatore
