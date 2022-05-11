Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EEF523380
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241214AbiEKM60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiEKM6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:58:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EF495DFE
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:58:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k126so1172648wme.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=NrpRK8AQVtooYclQQJrz162MpFfoF9t0R7qf9WTv27c=;
        b=Dt4TetKMIA2i8LbPPhbSfGDokCxCkvNssG8nb2SCKpM4Xr+/mFDQPlAzXYrMLDaEOL
         IzrAVv+2vDYatkHIeUOlE/SCL5V5E0BJYSROYGMIg2KkdrM1QVuiDUUJgvSwEvI6Hmvq
         kjnidikvgUU1F6TL84aJ/0NayfwzyIjRUf6kVs2r8luDNnubU5xzh7h78HhZrLdOh7mh
         Ky39rP9fHKwP+x87oqyKz9CzNQAtxPeZj7BAZ9B57yJyxTVKS2Tlo3qDkPO5v7cDQd5F
         vtTwac+IuSvMJEzTKZhDt/loZCEYWzt07hEKx2PqF21E1NJ3u5EXizoYYG/8n+bhl4UV
         h0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=NrpRK8AQVtooYclQQJrz162MpFfoF9t0R7qf9WTv27c=;
        b=KpATZCDuJmvAIbjxywjo0/8nCKisCguy+u7xtR89mhyi5ST5gzUIebrGDMbm62gLer
         uR4Rc+RKAMRkpYQKVRGqxKvBUUEgNfuXvtBGLAASE+iWoLZbmqFwYT4xU6wq790rRQ7j
         cxNqu8Zq28LKHmW8T+PJx0Ut6oM6fLUoA505ub1UpRjrFHCOVI91jBRg9S5ZZWztsg0m
         71I6IRyGH8my2dg2zwU/IEVJBaKGGPo22+3thnABcoypOImg750vOozVtVgp0cHg9rY4
         lqvAhZA2Bco8yaHowoDZiISrpANQN44lyOrfiUvVy7mqSSEJVfopRaEZCes1VCjtPO0P
         rMKQ==
X-Gm-Message-State: AOAM531SlkOdsZCTRAfcsYxG2hBuPwqR/o2/RA9QstvXsd/h2ikHk9gY
        pIcIL0cXf4IGs2OYvyDHbQR73v5LZnY=
X-Google-Smtp-Source: ABdhPJxi/QM1NhQqy+ckLbPXPvCkQoNsUaIVjhoJrgUSoGQKJlHduIxkMg84TklAsZEudiVqY8ezxg==
X-Received: by 2002:a05:600c:1e28:b0:394:8f2a:e266 with SMTP id ay40-20020a05600c1e2800b003948f2ae266mr4769353wmb.112.1652273902217;
        Wed, 11 May 2022 05:58:22 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id r6-20020a5d4986000000b0020c5253d8f6sm1610153wrq.66.2022.05.11.05.58.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 May 2022 05:58:21 -0700 (PDT)
Date:   Wed, 11 May 2022 13:58:19 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Liang Li <liali@redhat.com>
Subject: Re: [PATCH net-next 1/2] sfc: fix memory leak on mtd_probe
Message-ID: <20220511125819.nz6ethnd2yyljdj6@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Liang Li <liali@redhat.com>
References: <20220511103604.37962-1-ihuguet@redhat.com>
 <20220511103604.37962-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220511103604.37962-2-ihuguet@redhat.com>
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

The same patch was submitted earlier, see
https://lore.kernel.org/netdev/20220510153619.32464-1-ap420073@gmail.com/

Martin

On Wed, May 11, 2022 at 12:36:03PM +0200, Íñigo Huguet wrote:
> In some cases there is no mtd partitions that can be probed, so the mtd
> partitions list stays empty. This happens, for example, in SFC9220
> devices on the second port of the NIC.
> 
> The memory for the mtd partitions is deallocated in efx_mtd_remove,
> recovering the address of the first element of efx->mtd_list and then
> deallocating it. But if the list is empty, the address passed to kfree
> doesn't point to the memory allocated for the mtd partitions, but to the
> list head itself. Despite this hasn't caused other problems other than
> the memory leak, this is obviously incorrect.
> 
> This patch deallocates the memory during mtd_probe in the case that
> there are no probed partitions, avoiding the leak.
> 
> This was detected with kmemleak, output example:
> unreferenced object 0xffff88819cfa0000 (size 46560):
>   comm "kworker/0:2", pid 48435, jiffies 4364987018 (age 45.924s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000000f8e92d9>] kmalloc_order_trace+0x19/0x130
>     [<0000000042a03844>] efx_ef10_mtd_probe+0x12d/0x320 [sfc]
>     [<000000004555654f>] efx_pci_probe.cold+0x4e1/0x6db [sfc]
>     [<00000000b03d5126>] local_pci_probe+0xde/0x170
>     [<00000000376cc8d9>] work_for_cpu_fn+0x51/0xa0
>     [<00000000141f8de9>] process_one_work+0x8cb/0x1590
>     [<00000000cb2d8065>] worker_thread+0x707/0x1010
>     [<000000001ef4b9f6>] kthread+0x364/0x420
>     [<0000000014767137>] ret_from_fork+0x22/0x30
> 
> Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
> Reported-by: Liang Li <liali@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c        | 5 +++++
>  drivers/net/ethernet/sfc/siena/siena.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index c9ee5011803f..15a229731296 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
>  		n_parts++;
>  	}
>  
> +	if (n_parts == 0) {
> +		kfree(parts);
> +		return 0;
> +	}
> +
>  	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
>  fail:
>  	if (rc)
> diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
> index 741313aff1d1..32467782e8ef 100644
> --- a/drivers/net/ethernet/sfc/siena/siena.c
> +++ b/drivers/net/ethernet/sfc/siena/siena.c
> @@ -943,6 +943,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
>  		nvram_types >>= 1;
>  	}
>  
> +	if (n_parts == 0) {
> +		kfree(parts);
> +		return 0;
> +	}
> +
>  	rc = siena_mtd_get_fw_subtypes(efx, parts, n_parts);
>  	if (rc)
>  		goto fail;
> -- 
> 2.34.1
