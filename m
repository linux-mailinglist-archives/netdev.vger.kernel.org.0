Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B364462CEAA
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiKPXV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiKPXV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:21:26 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1971467118;
        Wed, 16 Nov 2022 15:21:26 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id kt23so901115ejc.7;
        Wed, 16 Nov 2022 15:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9v9KjvYMfYuTZZObzWPVSoHalRR1EWtRwEfMTCTaSFo=;
        b=Qsr5I2XqsW9BwuNUyKdr+xjQLtybgvSw4QYSrd2kpChNRA13MjYRQq80kjhzWi1rL+
         aG0CT0NDXqbbXBFnATuTZ1DNfoZ1RbfQhJiD4qxpP1JYCHTHEFHEWbH0fmeouYh0IkSF
         WhNLhi1j6qE17NF6YreyxRv0509zyelSyFuhhxLRpowpjuuA2ovSLDYY4aa3HIiLsreV
         GWxcegF0eGcakizUrmTiNznMBLudTothyH0ZpSsng+yWjuzvZN4UztmVhvFv7j0tKwXc
         xC6lWslW9DM/D3bYORhSJ2YA96h2Yi9UhZyEYYcA0EcGsSm5ThOibo3T7D227uSA9gg0
         /xaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9v9KjvYMfYuTZZObzWPVSoHalRR1EWtRwEfMTCTaSFo=;
        b=g9YTHmV4ISYZb2gWE45tcOStP3bjrdY/b2uF3RxUtlG6uV2TaPbL7wxTesG56zyvIR
         5mHYsW8WxCI+MWIbfh8mkPkmECgwrBIqhu+VUe9RNoPnftgTFf/kFXi402sVVkmS/Z3J
         w7a+8M8rbNDQfPUTyIjoK57fUdZKhz+7Vp6v+wDu+gPVBXzP3TvOJarFW3Y4xKWYxNPa
         VtzhqfSAzNc/pmhqJrJc+PbgBEduT2SNhFpF5dmWL/t4j+zctSjHSqqiFjdggoCuuyxA
         0LvEIGnL0GZlkwJ/RhkwJS4KA6iYnwBtUZzq+l7Wwt0YRze+ZkX3yjBmT6P67UEZ8t8F
         dtpw==
X-Gm-Message-State: ANoB5plxbZ4tBM7Rkl1FBid4oaOaKBNp6DqQIpXCkEnHAHjOlglN5Ehs
        bOgmqgWQEy1oQM3c5o69Gqg=
X-Google-Smtp-Source: AA0mqf7EhvKSNq/bcK0SzBtcWmHqh6Pt2BmbVJOxVJRVNjJNk8Sl6HYXjh07Z5DDNia+KVvjmb3JMQ==
X-Received: by 2002:a17:906:19d5:b0:780:93d2:8510 with SMTP id h21-20020a17090619d500b0078093d28510mr37067ejd.457.1668640884478;
        Wed, 16 Nov 2022 15:21:24 -0800 (PST)
Received: from skbuf ([188.26.57.53])
        by smtp.gmail.com with ESMTPSA id n15-20020a17090695cf00b0078c213ad441sm7349252ejy.101.2022.11.16.15.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 15:21:24 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:21:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-14 (i40e)
Message-ID: <20221116232121.ahaavt3m6wphxuyw@skbuf>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 14, 2022 at 04:03:22PM -0800, Tony Nguyen wrote:
> This series contains updates to i40e driver only.
> 
> Sylwester removes attempted allocation of Rx buffers when AF_XDP is in Tx
> only mode.
> 
> Bartosz adds helper to calculate Rx buffer length so that it can be
> used when interface is down; before value has been set in struct.
> 
> The following are changes since commit ed1fe1bebe18884b11e5536b5ac42e3a48960835:
>   net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> Bartosz Staszewski (1):
>   i40e: fix xdp_redirect logs error message when testing with MTU=1500
> 
> Sylwester Dziedziuch (1):
>   i40e: Fix failure message when XDP is configured in TX only mode
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 48 +++++++++++++++------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> -- 
> 2.35.1
> 

Sorry to interject, but there might be a potential bug I noticed a while
ago in the i40e driver, and I didn't find the occasion to bring it up,
but remembered just now.

Is it correct for i40e_run_xdp_zc() to call i40e_xmit_xdp_tx_ring() on
the XDP_TX action? If I'm reading the code correctly, this will map the
buffer to DMA before sending it. But since this is a zero-copy RX buffer,
it has already been mapped to DMA in i40e_xsk_pool_enable().

Since I don't have the hardware, I can't be 100% sure if I'm following
the code correctly. However if I compare with i40e_xmit_zc(), the latter
does not map buffers to DMA, so I think neither should the former.
