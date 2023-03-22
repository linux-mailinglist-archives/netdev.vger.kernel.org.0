Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CC76C4749
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCVKOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCVKOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:14:39 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02252567B2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:14:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ek18so70620227edb.6
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679480075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fpf0go+qffs5DN4t3jky6HX6o3itqno0gW49kjRoxXY=;
        b=l3vSBn0ptk+YY8G0HqqYDkxnvvHKLCbWI0oopEGI1ZEEcfvK6CsBA90peNqAASHLue
         fXisRp68NdJLfnVeGyuBhsBpeG5ObbDTG1IzqZf79wt3z8aX4BSeEPJaD1j1LqJlFlnt
         1iKNK8vnpU6FOW5zbCt+96iktlJM5rfDoyjYYLX7JchTdFjhxF6roI0SnCMicZkAFcA2
         0aYFXhl9Roza05woSBtTFj4NlXXn8gbmJ2xLpwVWjYCf3gr5XEAHeoTtizoIwkK6EdjP
         5T/ZLq+imRL5KnrPOcCOogjTfRdUseQIMqxXhPoNNoPxk1hDYz5Kp2XFL16Eu/66tUaN
         GAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679480075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpf0go+qffs5DN4t3jky6HX6o3itqno0gW49kjRoxXY=;
        b=5BbQzElnGSuGSi0/bfcy4bJX2WBvoHzTOCNFWgT7QF0FVVWp44oQlL1CoJtBcxyIrq
         8hwdgnsX2dmM+uLG2glXXYAxkwtcUvKei8VnPl7NGn5xCT1QTlGv9fI05TZ23mNSBiOB
         O1WxiORXg6PMZH3JDAUTVUOOJTGmJcGzcC/U/6MQhxoa1oBP7XPTZqdr6/Ih0XCIkDc+
         jOFI9eTJ4bLFLOvaYIULtOQlnP2bw5E7dw26G1udJd72BsNBS5K9Box18FNGRrDs6EkV
         O2hvbxMyqThjlIIC2H3IIQPmetSQxSZyM8vz7CV9dyEHqhY9wk19V42HyuY/iSWe+nJy
         yZRA==
X-Gm-Message-State: AO0yUKWyh6N0JVyIPd/tY2xEvfNLJHANNZ6NFc7EMFyFIHWUxemMjq7c
        eleu91tXa5PF9ghC1M6YnGODwJr5Az2EC+U+SbvdnA==
X-Google-Smtp-Source: AK7set9tb80xq/VG1KxwmsWSbtUkgdUcwyX4lsdW+4UihJqm/5CKTT7kJRyaXDJkxmqJmnyPiyh3rA==
X-Received: by 2002:a17:906:f10c:b0:930:a3a1:bede with SMTP id gv12-20020a170906f10c00b00930a3a1bedemr6300652ejb.50.1679480075455;
        Wed, 22 Mar 2023 03:14:35 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id ha8-20020a170906a88800b0093a6c591743sm1573254ejb.69.2023.03.22.03.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 03:14:35 -0700 (PDT)
Message-ID: <00525b0b-84fe-16a9-5129-dbb87658447f@blackwall.org>
Date:   Wed, 22 Mar 2023 12:14:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
References: <20230321163550.1574254-1-eric.dumazet@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321163550.1574254-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 18:35, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> But with zero copy, we use order-0 pages.
> 
> For BIG TCP to show its full potential, we add a config option
> to be able to fit up to 45 segments per skb.
> 
> This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> does not support skbs with frag list.
> 
> We have used MAX_SKB_FRAGS=45 value for years at Google before
> we deployed 4K MTU, with no adverse effect, other than
> a recent issue in mlx4, fixed in commit 26782aad00cc
> ("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")
> 
> Back then, goal was to be able to receive full size (64KB) GRO
> packets without the frag_list overhead.
> 
> Note that /proc/sys/net/core/max_skb_frags can also be used to limit
> the number of fragments TCP can use in tx packets.
> 
> By default we keep the old/legacy value of 17 until we get
> more coverage for the updated values.
> 
> Sizes of struct skb_shared_info on 64bit arches
> 
> MAX_SKB_FRAGS | sizeof(struct skb_shared_info):
> ==============================================
>          17     320
>          21     320+64  = 384
>          25     320+128 = 448
>          29     320+192 = 512
>          33     320+256 = 576
>          37     320+320 = 640
>          41     320+384 = 704
>          45     320+448 = 768
> 
> This inflation might cause problems for drivers assuming they could pack
> both the incoming packet and skb_shared_info in half a page, using build_skb().
> 
> v2: fix two build errors assuming MAX_SKB_FRAGS was "unsigned long"
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/scsi/cxgbi/libcxgbi.c |  4 ++--
>  include/linux/skbuff.h        | 14 ++------------
>  net/Kconfig                   | 12 ++++++++++++
>  net/packet/af_packet.c        |  4 ++--
>  4 files changed, 18 insertions(+), 16 deletions(-)
> 

Nice! I was statically increasing it for our datapath performance tests
w/ BIG TCP and zerocopy, had to implement custom header-data split
for mlx to get it all working but the improvements are impressive as
expected.

FWIW,
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

