Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8F04EC9AF
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348814AbiC3QdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348813AbiC3QdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:33:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A767915281A
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:31:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso528414pjh.3
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qe6kVerZP6CX+iitrVtMkhPZt28vfozdtBBaPzKko38=;
        b=ZTrnuv/xZEvTfQVtSPetagjo5WJ5NW2kRByThdOXfGMtsmaMDqzu9U4FbxWXZHHbfJ
         fxHvxlLl3Ii1XAsWCErDS0epCswa0HK+jszcTvZ+VE6Frd9UqBX3Ei0SgI8ULH5TSdUb
         qDJkRgkRwdrAz3ANGPBU0MND19+y7CLtE9U4zY5O0NYRj04q5kvHzldjHw2U1e+R3r/n
         Zfpk9DOFOYaX/Rd85lbwGMXzcsZlV6QXflL5882Xx9vSEw6QwxEq5mxW8mZ/RzdBQr7N
         2QxtvSUffhdw+Ql/CMlbsb11xx6BBNYoXylx02DRczfLUPvz7TqCKwfebFPIfCNr1NbG
         AWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qe6kVerZP6CX+iitrVtMkhPZt28vfozdtBBaPzKko38=;
        b=YYM94Q2NNILIruZuqInw8ZCbj8EPRPbSGa/1ShbD2m0mDxciQDHgZRig3BMouQHi4J
         nqfe+hV4cyNVfT58UUGSxSFfMw+PzEiqYnSJEOSFmmh+1btpq/WcGw3qGtAV40RteBgw
         JwR0YDqT9wzVGHz44Dv4QKVdbEyYmBaSz0jzkDwJQ1/CwCnvS6Xo34x8nQsgiV35GZil
         3hVZCO81092AcwlmlXnX3y4mQBA7ouA2lJJEWkVqZF3EICMTWFpcvlP0L3mQhse6Cqa5
         VMWnr0N1sW8OuGzgYXT5okNis05cwhIYskEbF+h4pf7pGrGqUnNnHttC6e+kl4hVSGWw
         e+HQ==
X-Gm-Message-State: AOAM5326gC/bogQ1ASif3lftmaLUq1nSbnh0OJEhRD563qDiFfkYlm15
        jpRQfI9CivXhcKJ39d/WXHjuR42PYnqFFw==
X-Google-Smtp-Source: ABdhPJxj45nDX91pFc9IrGmKWf6W0H0Wl8Qb8w3H+ArDiR/iuz/NvZKL/r1NUiNa0K+h8r32EyICMg==
X-Received: by 2002:a17:90b:1b52:b0:1c6:b689:813d with SMTP id nv18-20020a17090b1b5200b001c6b689813dmr272439pjb.186.1648657884152;
        Wed, 30 Mar 2022 09:31:24 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 75-20020a62144e000000b004fae56c42a0sm23015209pfu.211.2022.03.30.09.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:31:23 -0700 (PDT)
Message-ID: <8a7b260a-4012-f73e-84e6-c449a73ed0ff@gmail.com>
Date:   Thu, 31 Mar 2022 01:31:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: sfc: add missing xdp queue reinitialization
Content-Language: en-US
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com
References: <20220330161019.5367-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220330161019.5367-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 01:10, Taehee Yoo wrote:
> After rx/tx ring buffer size is changed, kernel panic occurs when
> it acts XDP_TX or XDP_REDIRECT.
> 
> When tx/rx ring buffer size is changed(ethtool -G), sfc driver
> reallocates and reinitializes rx and tx queues and their buffers
> (tx_queue->buffer).
> But it misses reinitializing xdp queues and buffers.
> So, while it is acting XDP_TX or XDP_REDIRECT, it uses the uninitialized
> tx_queue->buffer.
> 
> A new function efx_set_xdp_channels() is separated from efx_set_channels()
> to handle only xdp queues.
> 
> Splat looks like:
>     BUG: kernel NULL pointer dereference, address: 000000000000002a
>     #PF: supervisor write access in kernel mode
>     #PF: error_code(0x0002) - not-present page
>     PGD 0 P4D 0
>     Oops: 0002 [#4] PREEMPT SMP NOPTI
>     RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
>     CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D           5.17.0+ #55 e8beeee8289528f11357029357cf
>     Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
>     RSP: 0018:ffff92f121e45c60 EFLAGS: 00010297
>     RIP: 0010:efx_tx_map_chunk+0x54/0x90 [sfc]
>     RAX: 0000000000000040 RBX: ffff92ea506895c0 RCX: ffffffffc0330870
>     RDX: 0000000000000001 RSI: 00000001139b10ce RDI: ffff92ea506895c0
>     RBP: ffffffffc0358a80 R08: 00000001139b110d R09: 0000000000000000
>     R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
>     R13: 0000000000000018 R14: 00000001139b10ce R15: ffff92ea506895c0
>     FS:  0000000000000000(0000) GS:ffff92f121ec0000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     Code: 48 8b 8d a8 01 00 00 48 8d 14 52 4c 8d 2c d0 44 89 e0 48 85 c9 74 0e 44 89 e2 4c 89 f6 48 80
>     CR2: 000000000000002a CR3: 00000003e6810004 CR4: 00000000007706e0
>     RSP: 0018:ffff92f121e85c60 EFLAGS: 00010297
>     PKRU: 55555554
>     RAX: 0000000000000040 RBX: ffff92ea50689700 RCX: ffffffffc0330870
>     RDX: 0000000000000001 RSI: 00000001145a90ce RDI: ffff92ea50689700
>     RBP: ffffffffc0358a80 R08: 00000001145a910d R09: 0000000000000000
>     R10: 0000000000000001 R11: ffff92ea414c0088 R12: 0000000000000040
>     R13: 0000000000000018 R14: 00000001145a90ce R15: ffff92ea50689700
>     FS:  0000000000000000(0000) GS:ffff92f121e80000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 000000000000002a CR3: 00000003e6810005 CR4: 00000000007706e0
>     PKRU: 55555554
>     Call Trace:
>      <IRQ>
>      efx_xdp_tx_buffers+0x12b/0x3d0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
>      __efx_rx_packet+0x5c3/0x930 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
>      efx_rx_packet+0x28c/0x2e0 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
>      efx_ef10_ev_process+0x5f8/0xf40 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
>      ? enqueue_task_fair+0x95/0x550
>      efx_poll+0xc4/0x360 [sfc 84c94b8e32d44d296c17e10a634d3ad454de4ba5]
> 
> Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/ethernet/sfc/efx_channels.c | 147 +++++++++++++-----------
>   1 file changed, 82 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index d6fdcdc530ca..271f3bdfc141 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -789,6 +789,86 @@ void efx_remove_channels(struct efx_nic *efx)
>   	kfree(efx->xdp_tx_queues);
>   }
>   
> +static inline int efx_set_xdp_tx_queue(struct efx_nic *efx,

I will send v2 patch to remove this inline keywork.

> +				       int xdp_queue_number,
> +				       struct efx_tx_queue *tx_queue)
> +{

