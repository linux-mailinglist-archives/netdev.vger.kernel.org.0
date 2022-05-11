Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD4A522C18
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiEKGKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiEKGKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:10:01 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B3115EE6F
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:09:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so1375284wrg.12
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/V0thnglgg8v9kLoGFMDSRN5kMgFeRAWP+Z/jm5zaA8=;
        b=pN1de61Vk9/riBS5YHnn5r1uHhD+WRbn3ik8b4Lr96SfYaSlicftXiUB26Gv5LHTjx
         q88rGn2j+N8c252V7wGZCMIOFFfiaGDvoQqq96osKpOOM+sCJw171sqP4ltY40PlzELh
         vYOI6ctF6pC8z8Q6EGRCAKIUUxs4E4jleT5JsW1ySgel8JHeGg5KKHDyx1LHwyXlILRk
         edq5goUCWwjPRVln6K9ffiWlrxEZZx4TB//rJrsE+0Vja7Rn6NxMjCtrbPN+qFs7aOqz
         i+3sOFULT+79Birjimo8F4O1nKJNTsHjE0TosG09wGJOmiBNl2WUV6gKYAcdJq31b9td
         Z3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=/V0thnglgg8v9kLoGFMDSRN5kMgFeRAWP+Z/jm5zaA8=;
        b=TEcFGKZ0ITV+Ppq7+df9QQy75jRlE4QyNEyWdfX7sLhS5TQya+w1H/ffL7VyJUPeue
         8+e0pVOby+nQIelLPzrpD48/ZTSlG08yXG/uep6KiipzbkTigHBWFiLWLMs/LEE3V9b/
         pHIkwv4VKg1EddoMKoPPHfYWbBuJ5aSCo25RWmwKi+zRcGeUhHg6yVTC1HOg/K6ITFZi
         xI4dd0UDHESz/YLEbNkIw5WeZ/z7qBcX4SC/5WIlmNcW/0rfcdgORILbdhujR9QYMNl2
         lJbY51yuR8Wg/aM+UkeP/R+37eT8znZ9M16n1aH5oqesaeuf65m0pnhQkLDhWXv6hfBT
         xw9A==
X-Gm-Message-State: AOAM533TDKClq/IcaPHpJxjBEk+Tt21v+165IrfyPrOdX86o0GCd9x0e
        Z8TMoR2ybs8AZfQUx0ZsLlk=
X-Google-Smtp-Source: ABdhPJz+i+g4fhji4tz3Rw/tzZ4poR3fOmdBDnCs7TTwLo9nyVBI2eX43VwgQiLavoRxvQFk5c1CHQ==
X-Received: by 2002:a05:6000:1843:b0:20c:57b2:472c with SMTP id c3-20020a056000184300b0020c57b2472cmr20986385wri.142.1652249397054;
        Tue, 10 May 2022 23:09:57 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f15-20020a056000128f00b0020c5253d8dbsm110081wrx.39.2022.05.10.23.09.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 May 2022 23:09:56 -0700 (PDT)
Date:   Wed, 11 May 2022 07:09:54 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: sfc: ef10: fix memory leak in
 efx_ef10_mtd_probe()
Message-ID: <20220511060954.byiw5sem4vkwhjhr@gmail.com>
Mail-Followup-To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org
References: <20220510153619.32464-1-ap420073@gmail.com>
 <20220510153619.32464-2-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510153619.32464-2-ap420073@gmail.com>
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

Hi Taehee,

On Tue, May 10, 2022 at 03:36:18PM +0000, Taehee Yoo wrote:
> In the NIC ->probe() callback, ->mtd_probe() callback is called.
> If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
> In the ->mtd_probe(), which is efx_ef10_mtd_probe() it allocates and
> initializes mtd partiion.
> But mtd partition for sfc is shared data.
> So that allocated mtd partition data from last called
> efx_ef10_mtd_probe() will not be used.
> Therefore it must be freed.
> But it doesn't free a not used mtd partition data in efx_ef10_mtd_probe().

Your analysis is correct for X2, where the 2nd port does not have
any MTD partitions.
Note that on 7000 series the 2nd (and possibly 3rd and 4th) port do have
MTD partitions. On those efx_mtd_remove() will free the data.

On X2 efx_mtd_remove() returns too early for the 2nd port due to:
        if (list_empty(&efx->mtd_list))
                return;

I don't see an easy way to fix that code, since it does not know
the memory address. So your fix is the best we can do.

> 
> kmemleak reports:
> unreferenced object 0xffff88811ddb0000 (size 63168):
>   comm "systemd-udevd", pid 265, jiffies 4294681048 (age 348.586s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffffa3767749>] kmalloc_order_trace+0x19/0x120
>     [<ffffffffa3873f0e>] __kmalloc+0x20e/0x250
>     [<ffffffffc041389f>] efx_ef10_mtd_probe+0x11f/0x270 [sfc]
>     [<ffffffffc0484c8a>] efx_pci_probe.cold.17+0x3df/0x53d [sfc]
>     [<ffffffffa414192c>] local_pci_probe+0xdc/0x170
>     [<ffffffffa4145df5>] pci_device_probe+0x235/0x680
>     [<ffffffffa443dd52>] really_probe+0x1c2/0x8f0
>     [<ffffffffa443e72b>] __driver_probe_device+0x2ab/0x460
>     [<ffffffffa443e92a>] driver_probe_device+0x4a/0x120
>     [<ffffffffa443f2ae>] __driver_attach+0x16e/0x320
>     [<ffffffffa4437a90>] bus_for_each_dev+0x110/0x190
>     [<ffffffffa443b75e>] bus_add_driver+0x39e/0x560
>     [<ffffffffa4440b1e>] driver_register+0x18e/0x310
>     [<ffffffffc02e2055>] 0xffffffffc02e2055
>     [<ffffffffa3001af3>] do_one_initcall+0xc3/0x450
>     [<ffffffffa33ca574>] do_init_module+0x1b4/0x700
> 
> Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef10.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 50d535981a35..f8edb3f1b73a 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
>  		n_parts++;
>  	}
>  
> +	if (!n_parts) {
> +		kfree(parts);
> +		return 0;
> +	}
> +
>  	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
>  fail:
>  	if (rc)
> -- 
> 2.17.1
