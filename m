Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F684EAFCE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiC2PJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 11:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbiC2PJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 11:09:12 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33031D97E1;
        Tue, 29 Mar 2022 08:07:28 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id d7so9920848vkd.11;
        Tue, 29 Mar 2022 08:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6dL8ykdo2TpdicCbVFJ+b9rPqwKy1QzxLEm2fg/qf9s=;
        b=a5i1Ei9XQv2AtldpcYmJQ1uaqHsitwi3Ic7P9FWjeKGuGXrSLWX6iFokuPRzEEBXcZ
         NvkrsrjCfxbnLSV94c+wzaLzlb6oncfWm2JEOLISqP5kCdmpNadL0D68H8pq7W1LS9yc
         uJnnOFkoI9u6iKB39/KnzEazJA9pT61fuhsrEFz6TKWMHBgLEXVycm522YszhVycCYLV
         XSQXDVL4JeB54gMvfy20vN+oU+R2VZduV1vmGkRlvWnQ2CEwB/+1hB6x8ST++w0B8f/p
         M1AnT99traHABCsyJqlxQLWxXcnI52IvjbsROUqNTnQXsI5cv0vaak5pqBRzH+UPNi3t
         YKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6dL8ykdo2TpdicCbVFJ+b9rPqwKy1QzxLEm2fg/qf9s=;
        b=rQzWtsjE/O1XBYLjRP3Wlwx6bUdIL7inVJZwfKJQCtHC+5J++kjCKKC0Ah6EvMV0+Y
         sOx87Yb8ENqRqO4cW7T0GeiqdlfdimKoYcNqQYW/VUBsCrlTtm/1gMLV9Fk/mgCcStOc
         eA7xBk/FMD47rcxvsFih9c0i7jOFpbZrNvV9Xch7Iq0ZAuhkVcDtbN058/1u0WIFdXnp
         OQjP8oUeC88HlUhDYJhI9dvu02rtHwnbLIPBT4npOh2wwM/Y8f4TmQffQRKV50/5WAKo
         c90j0v3fWglnUoSdT54F7wO6dBcoPrPbBtUszrOk2twNFbjK8K5LJxcjb5+Dgp0vL/jH
         4O0w==
X-Gm-Message-State: AOAM533IcVnhyLanBZx9fqQfaEUnebSY2cjstCKj665OgfPm8vZpyafn
        Ti9KJiiXag46IGavYhFblc2Zp6VtaQYSLYtDaZY=
X-Google-Smtp-Source: ABdhPJy1bmeShH0XQoqyWcNVAEnZEepMRmKvZPL9Ixw8YVdO2TSoKkfwtLPxd6qO/mPx5Fxn3/WDrlCb1ejRZK+jw5s=
X-Received: by 2002:a1f:da47:0:b0:33f:1398:210e with SMTP id
 r68-20020a1fda47000000b0033f1398210emr17942890vkg.12.1648566446434; Tue, 29
 Mar 2022 08:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220310045358.224350-1-jeremy.linton@arm.com>
In-Reply-To: <20220310045358.224350-1-jeremy.linton@arm.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Tue, 29 Mar 2022 15:07:15 +0000
Message-ID: <CALeDE9MU=YrXD04zCamEgY9fYT_cxGBV5Cu0_hetoVb6Mwrp4Q@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
To:     Jeremy Linton <jeremy.linton@arm.com>, stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 4:54 AM Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> GCC12 appears to be much smarter about its dependency tracking and is
> aware that the relaxed variants are just normal loads and stores and
> this is causing problems like:
>
> [  210.074549] ------------[ cut here ]------------
> [  210.079223] NETDEV WATCHDOG: enabcm6e4ei0 (bcmgenet): transmit queue 1 timed out
> [  210.086717] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:529 dev_watchdog+0x234/0x240
> [  210.095044] Modules linked in: genet(E) nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat]
> [  210.146561] ACPI CPPC: PCC check channel failed for ss: 0. ret=-110
> [  210.146927] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E     5.17.0-rc7G12+ #58
> [  210.153226] CPPC Cpufreq:cppc_scale_freq_workfn: failed to read perf counters
> [  210.161349] Hardware name: Raspberry Pi Foundation Raspberry Pi 4 Model B/Raspberry Pi 4 Model B, BIOS EDK2-DEV 02/08/2022
> [  210.161353] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  210.161358] pc : dev_watchdog+0x234/0x240
> [  210.161364] lr : dev_watchdog+0x234/0x240
> [  210.161368] sp : ffff8000080a3a40
> [  210.161370] x29: ffff8000080a3a40 x28: ffffcd425af87000 x27: ffff8000080a3b20
> [  210.205150] x26: ffffcd425aa00000 x25: 0000000000000001 x24: ffffcd425af8ec08
> [  210.212321] x23: 0000000000000100 x22: ffffcd425af87000 x21: ffff55b142688000
> [  210.219491] x20: 0000000000000001 x19: ffff55b1426884c8 x18: ffffffffffffffff
> [  210.226661] x17: 64656d6974203120 x16: 0000000000000001 x15: 6d736e617274203a
> [  210.233831] x14: 2974656e65676d63 x13: ffffcd4259c300d8 x12: ffffcd425b07d5f0
> [  210.241001] x11: 00000000ffffffff x10: ffffcd425b07d5f0 x9 : ffffcd4258bdad9c
> [  210.248171] x8 : 00000000ffffdfff x7 : 000000000000003f x6 : 0000000000000000
> [  210.255341] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000001000
> [  210.262511] x2 : 0000000000001000 x1 : 0000000000000005 x0 : 0000000000000044
> [  210.269682] Call trace:
> [  210.272133]  dev_watchdog+0x234/0x240
> [  210.275811]  call_timer_fn+0x3c/0x15c
> [  210.279489]  __run_timers.part.0+0x288/0x310
> [  210.283777]  run_timer_softirq+0x48/0x80
> [  210.287716]  __do_softirq+0x128/0x360
> [  210.291392]  __irq_exit_rcu+0x138/0x140
> [  210.295243]  irq_exit_rcu+0x1c/0x30
> [  210.298745]  el1_interrupt+0x38/0x54
> [  210.302334]  el1h_64_irq_handler+0x18/0x24
> [  210.306445]  el1h_64_irq+0x7c/0x80
> [  210.309857]  arch_cpu_idle+0x18/0x2c
> [  210.313445]  default_idle_call+0x4c/0x140
> [  210.317470]  cpuidle_idle_call+0x14c/0x1a0
> [  210.321584]  do_idle+0xb0/0x100
> [  210.324737]  cpu_startup_entry+0x30/0x8c
> [  210.328675]  secondary_start_kernel+0xe4/0x110
> [  210.333138]  __secondary_switched+0x94/0x98
>
> The assumption when these were relaxed seems to be that device memory
> would be mapped non reordering, and that other constructs
> (spinlocks/etc) would provide the barriers to assure that packet data
> and in memory rings/queues were ordered with respect to device
> register reads/writes. This itself seems a bit sketchy, but the real
> problem with GCC12 is that it is moving the actual reads/writes around
> at will as though they were independent operations when in truth they
> are not, but the compiler can't know that. When looking at the
> assembly dumps for many of these routines its possible to see very
> clean, but not strictly in program order operations occurring as the
> compiler would be free to do if these weren't actually register
> reads/write operations.
>
> Its possible to suppress the timeout with a liberal bit of dma_mb()'s
> sprinkled around but the device still seems unable to reliably
> send/receive data. A better plan is to use the safer readl/writel
> everywhere.
>
> Since this partially reverts an older commit, which notes the use of
> the relaxed variants for performance reasons. I would suggest that
> any performance problems with this commit are targeted at relaxing only
> the performance critical code paths after assuring proper barriers.
>
> Fixes: 69d2ea9c79898 ("net: bcmgenet: Use correct I/O accessors")
> Reported-by: Peter Robinson <pbrobinson@gmail.com>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

This is now in Linus's tree as commit 8d3ea3d402db would be good to
get it int 5.17.x

> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 87f1056e29ff..e907a2df299c 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -76,7 +76,7 @@ static inline void bcmgenet_writel(u32 value, void __iomem *offset)
>         if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>                 __raw_writel(value, offset);
>         else
> -               writel_relaxed(value, offset);
> +               writel(value, offset);
>  }
>
>  static inline u32 bcmgenet_readl(void __iomem *offset)
> @@ -84,7 +84,7 @@ static inline u32 bcmgenet_readl(void __iomem *offset)
>         if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>                 return __raw_readl(offset);
>         else
> -               return readl_relaxed(offset);
> +               return readl(offset);
>  }
>
>  static inline void dmadesc_set_length_status(struct bcmgenet_priv *priv,
> --
> 2.35.1
>
