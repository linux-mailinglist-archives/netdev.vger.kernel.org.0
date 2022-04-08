Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697DE4F9BBF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiDHRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbiDHRfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:35:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85E8331D3D;
        Fri,  8 Apr 2022 10:32:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h19so8968560pfv.1;
        Fri, 08 Apr 2022 10:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=16tDxidA0v5GNGXKR7zDe3Jj9oBA7zoBdGz+X8kPWL4=;
        b=Hejas1h1yqVUWDigGxguecdeHGVDjjvzd/ZFj2EOkQua+uiWf5Eh7yy+vUmeQTmRiN
         inqi9ml5u55jruJJp3WYsatyEc6ZA0YoPbYGAeHtg0TGQiVro2oTGpDqlQ7x0lna8XNk
         t8N3eNpn2agYGiJMMsJPXxIvuF7g7uCIcDG7Wt2yzaaxJWu7Kqy4bcPD6hzpE2inOT7+
         ttTjZ2GDk5WdfK1lD6JQKNkmqmehPNnJaF1tWxd8x1cYUsvyTCas6wHtx++TAGHbg1Qm
         XXJs6ERe+40m/mhL2J1tLxPH699xzMTh0AF/quuDrnLqzog92DGb7yCFNI3tfzRpfxhF
         0fOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=16tDxidA0v5GNGXKR7zDe3Jj9oBA7zoBdGz+X8kPWL4=;
        b=ypU/Jw8j6c7uswiTeUdCsVFHk8cAUtNqu5qndOAbAdRy+3WaVmmLHvd/Xg7/sdbU98
         NaS9TtQbqGt+X1/lbNfMQowBh2a0n6rvxwOkT9jK1n65Jv2zipms+YOIkhytYD5Gq+AI
         ttmEqX1y7xAnmtFab+PaRENGLskDqDk5uOYHG7vCE1v7F1aG3dvp/xlqPScRp1FodIeP
         ChaBoHpn0b2hj+UzqlMaKZqS8XNHlaiXI0PPw++9BSVOnGlXt0waSBYZ8CC2RWySjGqD
         PwYu5enM1htQnuXAvGDDVlmRTpJ+9IpXYpnqgHmlrQvzL1Xe+5ZJxkEpHUrEaEhO68ys
         ABng==
X-Gm-Message-State: AOAM531OqeWPU/ujPnx2UkYSesf8p6MMgNlEjrtxEtaXLfnB05zXnKH9
        00VjUllhygqbKsEh7N+RD8k=
X-Google-Smtp-Source: ABdhPJz6rBRNCgwQxLTNaCL5F49InLDCflNG9v8dGK8THVuyrR4IfH1sTO1Yfy0AIC968JU6tPxJHQ==
X-Received: by 2002:a05:6a00:1786:b0:4fb:266f:b184 with SMTP id s6-20020a056a00178600b004fb266fb184mr20511839pfg.10.1649439176991;
        Fri, 08 Apr 2022 10:32:56 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id m8-20020a056a00080800b004faa4e113bfsm28080644pfk.154.2022.04.08.10.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 10:32:56 -0700 (PDT)
Message-ID: <d4106b81-31cb-2569-6b49-9393bd2c2b34@gmail.com>
Date:   Sat, 9 Apr 2022 02:32:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 0/3] net: atlantic: Add XDP support
Content-Language: en-US
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
References: <20220408165950.10515-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220408165950.10515-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/22 01:59, Taehee Yoo wrote:
> This patchset is to make atlantic to support multi-buffer XDP.
> 
> The first patch implement control plane of xdp.
> The aq_xdp(), callback of .xdp_bpf is added.
> 
> The second patch implements data plane of xdp.
> XDP_TX, XDP_DROP, and XDP_PASS is supported.
> __aq_ring_xdp_clean() is added to receive and execute xdp program.
> aq_nic_xmit_xdpf() is added to send packet by XDP.
> 
> The third patch implements callback of .ndo_xdp_xmit.
> aq_xdp_xmit() is added to send redirected packets and it internally
> calls aq_nic_xmit_xdpf().
> 
> Memory model is MEM_TYPE_PAGE_ORDER0 so it doesn't reuse rx page when
> XDP_TX, XDP_PASS, XDP_REDIRECT.
> 
> Default the maximum rx frame size is 2K.
> If xdp is attached, size is changed to about 3K.
> It can be reused when XDP_DROP, and XDP_ABORTED.
> 
> Atlantic driver has AQ_CFG_RX_PAGEORDER option and it will be always 0
> if xdp is attached.
> 
> LRO will be disabled if XDP program supports only single buffer.
> 
> AQC chip supports 32 multi-queues and 8 vectors(irq).
> There are two options.
> 1. under 8 cores and maximum 4 tx queues per core.
> 2. under 4 cores and maximum 8 tx queues per core.
> 
> Like other drivers, these tx queues can be used only for XDP_TX,
> XDP_REDIRECT queue. If so, no tx_lock is needed.
> But this patchset doesn't use this strategy because getting hardware tx
> queue index cost is too high.
> So, tx_lock is used in the aq_nic_xmit_xdpf().
> 
> single-core, single queue, 80% cpu utilization.
> 
>    30.75%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
>    10.35%  [kernel]                  [k] aq_hw_read_reg <---------- here
>     4.38%  [kernel]                  [k] get_page_from_freelist
> 
> single-core, 8 queues, 100% cpu utilization, half PPS.
> 
>    45.56%  [kernel]                  [k] aq_hw_read_reg <---------- here
>    17.58%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
>     4.72%  [kernel]                  [k] hw_atl_b0_hw_ring_rx_receive
> 
> Performance result(64 Byte)
> 1. XDP_TX
>    a. xdp_geieric, single core
>      - 2.5Mpps, 100% cpu
>    b. xdp_driver, single core
>      - 4.5Mpps, 80% cpu
>    c. xdp_generic, 8 core(hyper thread)
>      - 6.3Mpps, 5~10% cpu
>    d. xdp_driver, 8 core(hyper thread)
>      - 6.3Mpps, 5% cpu
> 
> 2. XDP_REDIRECT
>    a. xdp_generic, single core
>      - 2.3Mpps
>    b. xdp_driver, single core
>      - 4.5Mpps
> 
> v3:
>   - Change wrong PPS performance result 40% -> 80% in single
>     core(Intel i3-12100)
>   - Separate aq_nic_map_xdp() from aq_nic_map_skb()
>   - Drop multi buffer packets if single buffer XDP is attached
>   - Disable LRO when single buffer XDP is attached
>   - Use xdp_get_{frame/buff}_len()
> 
> v2:
>   - Do not use inline in C file
> 
> Taehee Yoo (3):
>    net: atlantic: Implement xdp control plane
>    net: atlantic: Implement xdp data plane
>    net: atlantic: Implement .ndo_xdp_xmit handler
> 
>   .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   1 +
>   .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
>   .../net/ethernet/aquantia/atlantic/aq_main.c  |  87 ++++
>   .../net/ethernet/aquantia/atlantic/aq_main.h  |   2 +
>   .../net/ethernet/aquantia/atlantic/aq_nic.c   | 137 ++++++
>   .../net/ethernet/aquantia/atlantic/aq_nic.h   |   5 +
>   .../net/ethernet/aquantia/atlantic/aq_ring.c  | 415 ++++++++++++++++--
>   .../net/ethernet/aquantia/atlantic/aq_ring.h  |  17 +
>   .../net/ethernet/aquantia/atlantic/aq_vec.c   |  23 +-
>   .../net/ethernet/aquantia/atlantic/aq_vec.h   |   6 +
>   .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   6 +-
>   .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  10 +-
>   12 files changed, 675 insertions(+), 42 deletions(-)
> 

I will send v4 patch because of compile warning.

Thanks,

Taehee Yoo
