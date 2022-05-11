Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D2A522C42
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbiEKGZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiEKGZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:25:08 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227F622442D
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:25:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t6so1465996wra.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ObCZ7MnpdBI4o7emrmzCT2A3YCoOsYeRw9ONlu1emLE=;
        b=pHaJelVfxLeXa3UViuuV2NFr62eO3WSW0QZjjXGklVMsXicw4tQICpTsWlSS7M43/2
         j9zfzGryCZskyIVrbNceE07w0Aany8T40QP5owuxlh6LiQRGY3jD37dh/pxw9RSjK52o
         Pece9wctfOh0JfkxsnzlFaXosx0tXVy48eShEnumTU227ePT/uGQAfaS4O89dKEeHS70
         YKiFFtCHBrU0In3Rr0m1T5X26OS0343A4PuPhjLUoFOpHhCVzOhnxbbbeIs6/C0Mc4CR
         2+m7RkdmS6P3e0eiQ7kB+i1RxbJZbPlwSGZKTy93c6H5ceQ4+tviTwNHF6P3ipXyiG+X
         lXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=ObCZ7MnpdBI4o7emrmzCT2A3YCoOsYeRw9ONlu1emLE=;
        b=Oa/AvouxYdtVMTQfucnhpul1j/pGlBi+P+4i8nW/wHRvJGHEtmnEJSQMAOKSBEPxlG
         YgMmoLB1fwLmTE8FChGgGy4IGDQ7xYlb+DS8uEEHhT+meQ222ZcB7sUcTeqLWpliINuv
         fiOu+RJeqg7V23nN5PbEn/v7BDfGUnaZ4kQbJ3egzYTrPPdZtxB+ejT4VshOOfdWKX/+
         L1KMGld9RcnM6PRDpaQy6tqSxr9PpGdB6ojn0EhKI/lIO8908M5hiqhTz4FL15MIUB/2
         yLSK67CqU2sT2NOMYvtWdrOvBqkskVE5rbRF+EfAa9OME+jaMkemjwmneVoXbf1j9/pn
         jMkg==
X-Gm-Message-State: AOAM532gkWtT09byxbW6dM1Vc8Lfra0glsxOoMoqvwetV9Z9nXSoulX6
        mIIsgqy4E+9zzRCPpbh/Fs8=
X-Google-Smtp-Source: ABdhPJzU69kOeS5zdS0Bn+YCeb95zOhydE9ibDTbcFIQpb/nA/VKSkDxZDqUOuL1YSCQFhLoX8T60w==
X-Received: by 2002:a05:6000:18ac:b0:20c:ba84:1260 with SMTP id b12-20020a05600018ac00b0020cba841260mr15735984wri.379.1652250305771;
        Tue, 10 May 2022 23:25:05 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id m3-20020adffe43000000b0020c7fb81b0fsm776642wrs.46.2022.05.10.23.25.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 May 2022 23:25:05 -0700 (PDT)
Date:   Wed, 11 May 2022 07:25:03 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: sfc: siena: fix memory leak in
 siena_mtd_probe()
Message-ID: <20220511062503.s7ndwcvzxzkyyniq@gmail.com>
Mail-Followup-To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org
References: <20220510153619.32464-1-ap420073@gmail.com>
 <20220510153619.32464-3-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510153619.32464-3-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 03:36:19PM +0000, Taehee Yoo wrote:
> In the NIC ->probe callback, ->mtd_probe() callback is called.
> If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
> In the ->mtd_probe(), which is siena_mtd_probe() it allocates and
> initializes mtd partiion.
> But mtd partition for sfc is shared data.
> So that allocated mtd partition data from last called
> siena_mtd_probe() will not be used.

On Siena the 2nd port does have MTD partitions. In the output
from /proc/mtd below eth3 is the 1st port and eth4 is the 2nd
port:

mtd12: 00030000 00010000 "eth3 sfc_mcfw:0b"
mtd13: 00010000 00010000 "eth3 sfc_dynamic_cfg:00"
mtd14: 00030000 00010000 "eth3 sfc_exp_rom:01"
mtd15: 00010000 00010000 "eth3 sfc_exp_rom_cfg:00"
mtd16: 00120000 00010000 "eth3 sfc_fpga:01"
mtd17: 00010000 00010000 "eth4 sfc_dynamic_cfg:00"
mtd18: 00010000 00010000 "eth4 sfc_exp_rom_cfg:00"

So this patch is not needed, and efx_mtd_remove() will free
the memory for both ports.

Martin

> Therefore it must be freed.
> But it doesn't free a not used mtd partition data in siena_mtd_probe().
> 
> Fixes: 8880f4ec21e6 ("sfc: Add support for SFC9000 family (2)")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/ethernet/sfc/siena.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
> index ce3060e15b54..8b42951e34d6 100644
> --- a/drivers/net/ethernet/sfc/siena.c
> +++ b/drivers/net/ethernet/sfc/siena.c
> @@ -939,6 +939,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
>  		nvram_types >>= 1;
>  	}
>  
> +	if (!n_parts) {
> +		kfree(parts);
> +		return 0;
> +	}
> +
>  	rc = siena_mtd_get_fw_subtypes(efx, parts, n_parts);
>  	if (rc)
>  		goto fail;
> -- 
> 2.17.1
