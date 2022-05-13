Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361695260AE
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379725AbiEMLHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245323AbiEMLH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:07:28 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E05134E36
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:07:27 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so6726147wms.3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=U+QvnmZjDlTQ/EnsXd72QQuIzSYGlVJNscb9BFKkBns=;
        b=qUP6U0TFIfMUKrn3KRUUK1i/w+0k63czFfMqpvzFPHmnjG1OZNpuX78UpJMZ6aeEA1
         4Vy6OdjdZ0GU6NyqPJH/JxZWD5r9UvW58iYgRkv89bU37C/Tk4aVZQ4mSTjfar2NOoTy
         EsKGbGoJtWwVUjl36yPNSy0EmwC0dKL6QTTHJuypk8PD58FnmdfkhdrdI+K5OjX2Vo14
         rQ1t20wdIIieQRKnaCQVNNOm3CTNVcs0gu4VpDzJ63sLrYFfCtQHdjFG+YJrFSWYSluh
         vdnefjb7+Ip6j2KrE7rWSR+XJwdxevJMJ9lmr1Zl4uiFAXaT2KdY67wieTHT1roe/C41
         fwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=U+QvnmZjDlTQ/EnsXd72QQuIzSYGlVJNscb9BFKkBns=;
        b=eYlCnAtj8olGCB9hFLPosNJj5NpUf9i1G4eQ96kccbGCzHdAU+u/2jlgissoJFGpcP
         u8TZ4qmgk2u/25rP28Cd8HFlALOe4AWwSkw1b//PFpsm32gLDwlbyRzyZNwsenzQzx47
         6gCnAqzGxsVgYzG6MpL9ARFrmBjQr+xxnnVptRzjSP446JgrCnyK3qDNPtZgjJXSKslF
         jerKjXBlIexYIqSP5+TPJ3HYTw/0v3U+vev+4PZiL9gz5RrRjtKhSUKe8W0ORKKancej
         fhyHETy0hEUz5V+6O8eEVecHyzS1YZtmhK4flpXW2Zboa+juKCv9cu4dmAJ40USMyOB5
         QOzA==
X-Gm-Message-State: AOAM531KvbXiZVLUlNyGmU1y1GCh5uT5IbyrLbx/IpWJW4VfZO9jLWZ2
        OGG/OfJ89MtV26ptojFzMCc=
X-Google-Smtp-Source: ABdhPJw6oh2RulETuRtF6FmxNnv8rJ2oWdY7o5Bn9RtvAV79NdonUrjghHfvJSMt4bf9hXFxwCJpqA==
X-Received: by 2002:a05:600c:6005:b0:394:7ba4:5e62 with SMTP id az5-20020a05600c600500b003947ba45e62mr14753247wmb.25.1652440046166;
        Fri, 13 May 2022 04:07:26 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id l5-20020adfa385000000b0020ce015ed48sm1829850wrb.103.2022.05.13.04.07.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 May 2022 04:07:25 -0700 (PDT)
Date:   Fri, 13 May 2022 12:07:23 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, amaftei@solarflare.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
Subject: Re: [PATCH net 2/2] sfc: do not initialize non existing queues with
 efx_separate_tx_channels
Message-ID: <20220513110723.dorpu2wgrutcske2@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, amaftei@solarflare.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>
References: <20220511125941.55812-1-ihuguet@redhat.com>
 <20220511125941.55812-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220511125941.55812-3-ihuguet@redhat.com>
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

On Wed, May 11, 2022 at 02:59:41PM +0200, Íñigo Huguet wrote:
> If efx_separate_tx_channels is used, some error messages and backtraces
> are shown in the logs (see below). This is because during channels
> start, all queues in the channels are init asumming that they exist, but
> they might not if efx_separate_tx_channels is used: some channels only
> have RX queues and others only have TX queues.

Thanks for reporting this. At first glance I suspect there may be more callers
of efx_for_each_channel_tx_queue() which is why it is not yet working for you
even with this fix.
Probably we need to fix those macros themselves.

I'm having a closer look, but it will take some time.

Martin

> 
> Avoid that by checking if the channel has TX, RX or both queues.
> However, even with this patch the NIC is unusable when using
> efx_separate_tx_channels, so there are more problems that I've not
> identified. These messages are still shown at probe time many times:
>  sfc 0000:03:00.0 (unnamed net_device) (uninitialized): MC command 0x92 inlen 8 failed rc=-71 (raw=0) arg=0
>  sfc 0000:03:00.0 (unnamed net_device) (uninitialized): failed to link VI 4294967295 to PIO buffer 1 (-71)
> 
> Those messages were also shown before these patch.
> 
> And then this other message and backtrace were also shown many times,
> but now they're not:
>  sfc 0000:03:00.0 ens6f0np0: MC command 0x82 inlen 544 failed rc=-22 (raw=0) arg=0
>  ------------[ cut here ]------------
>  netdevice: ens6f0np0: failed to initialise TXQ -1
>  WARNING: CPU: 1 PID: 626 at drivers/net/ethernet/sfc/ef10.c:2393 efx_ef10_tx_init+0x201/0x300 [sfc]
>  [...] stripped
>  RIP: 0010:efx_ef10_tx_init+0x201/0x300 [sfc]
>  [...] stripped
>  Call Trace:
>   efx_init_tx_queue+0xaa/0xf0 [sfc]
>   efx_start_channels+0x49/0x120 [sfc]
>   efx_start_all+0x1f8/0x430 [sfc]
>   efx_net_open+0x5a/0xe0 [sfc]
>   __dev_open+0xd0/0x190
>   __dev_change_flags+0x1b3/0x220
>   dev_change_flags+0x21/0x60
>  [...]
> 
> At remove time, these messages were shown. Now they're neither shown:
>  sfc 0000:03:00.0 ens6f0np0: failed to flush 10 queues
>  sfc 0000:03:00.0 ens6f0np0: failed to flush queues
> 
> Fixes: 7ec3de426014 ("sfc: move datapath management code")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index da2db6791907..b6b960e2021c 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -1139,17 +1139,21 @@ void efx_start_channels(struct efx_nic *efx)
>  	struct efx_channel *channel;
>  
>  	efx_for_each_channel_rev(channel, efx) {
> -		efx_for_each_channel_tx_queue(tx_queue, channel) {
> -			efx_init_tx_queue(tx_queue);
> -			atomic_inc(&efx->active_queues);
> +		if (channel->channel >= efx->tx_channel_offset) {
> +			efx_for_each_channel_tx_queue(tx_queue, channel) {
> +				efx_init_tx_queue(tx_queue);
> +				atomic_inc(&efx->active_queues);
> +			}
>  		}
>  
> -		efx_for_each_channel_rx_queue(rx_queue, channel) {
> -			efx_init_rx_queue(rx_queue);
> -			atomic_inc(&efx->active_queues);
> -			efx_stop_eventq(channel);
> -			efx_fast_push_rx_descriptors(rx_queue, false);
> -			efx_start_eventq(channel);
> +		if (channel->channel < efx->n_rx_channels) {
> +			efx_for_each_channel_rx_queue(rx_queue, channel) {
> +				efx_init_rx_queue(rx_queue);
> +				atomic_inc(&efx->active_queues);
> +				efx_stop_eventq(channel);
> +				efx_fast_push_rx_descriptors(rx_queue, false);
> +				efx_start_eventq(channel);
> +			}
>  		}
>  
>  		WARN_ON(channel->rx_pkt_n_frags);
> -- 
> 2.34.1
