Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FC7562C61
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiGAHL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiGAHL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:11:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0F9568A2B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656659515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhpqJ1SJvKpelaCb4CbN+m8twbhunlhXJ55DqPwFTvM=;
        b=OLbWpxqBFE50ld906isg7MnJnKI+b2r8jyMW2+dGFbE+2jeXR5E8sBlNBR8bVfjc1eHm2B
        BrelU1Jebx4ulEloUHZPdmUpVIUgNIyNyUA2h8Z7Ts1Z69utqc6i6VHQTYI+qvCJ05CQ9N
        JPbOOnwzrMEqSEoW7ks66uM6vF3Bk2Q=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-zu3B9CAJPY6dAoS4Ap84xg-1; Fri, 01 Jul 2022 03:11:53 -0400
X-MC-Unique: zu3B9CAJPY6dAoS4Ap84xg-1
Received: by mail-lj1-f200.google.com with SMTP id k2-20020a2e8882000000b0025a96a32388so211376lji.13
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 00:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=bhpqJ1SJvKpelaCb4CbN+m8twbhunlhXJ55DqPwFTvM=;
        b=zM5fUn3RkQ0L6RBtqTwgiBeHSOosJMJUkvNil2J7/GaHnLoh27bBtN0DkhEU8rgW6v
         gDkIm4i+vEw7wuDOhzQBizuI64NVGrkOxO3fnjr033Kk5OQL0HFrKPtTuSmokeodNOCT
         GC6TBai/FsWqls73fWGKHGiblyoNSTuOpBC1R14128DCC4zKp+fnbAgEGJNi5Cpu02qo
         BSf1cgStpUCGXgup2Xo0+a2vFg3XkISvHYLZrwY9S7YMaQpcwkN4269iFq45Pcf9NGiC
         TLkd/HCkDhEI5LsmmCEajrtChHbYBxzE1HbSLE2zJMiD7PrPJ3S6F/iFGO1SaMq29Ob9
         LbKw==
X-Gm-Message-State: AJIora8YOFhePSCl/NuKW3cjFDhEQRoxnjN5GRxItIqjFqsE6H62PGrY
        zXa+O9QY7L22dajBiCy8iKY+/GMfFvCh9SGPPQH41pww8Oiap9toCQabWnx0ryRItqNNKHCRAB4
        JU9cHpu5fqORFO+9d
X-Received: by 2002:ac2:55ba:0:b0:47f:a02c:d98d with SMTP id y26-20020ac255ba000000b0047fa02cd98dmr7749246lfg.620.1656659512312;
        Fri, 01 Jul 2022 00:11:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ubBOAK6tjjdc8FVzvJs8S3xwhfQIRP1ivQvdj7qZrmnKp9NUvey36zU5GoqI0qAIKBK/YSXQ==
X-Received: by 2002:ac2:55ba:0:b0:47f:a02c:d98d with SMTP id y26-20020ac255ba000000b0047fa02cd98dmr7749238lfg.620.1656659512078;
        Fri, 01 Jul 2022 00:11:52 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id m10-20020a19710a000000b0047f68b11329sm3477322lfc.266.2022.07.01.00.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 00:11:51 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e863a394-a2af-505b-5c5c-cbf8b4a1819f@redhat.com>
Date:   Fri, 1 Jul 2022 09:11:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, doshir@vmware.com, jbrouer@redhat.com,
        lorenzo.bianconi@redhat.com, gyang@vmware.com,
        William Tu <tuc@vmware.com>
Subject: Re: [RFC PATCH 1/2] vmxnet3: Add basic XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
References: <20220629014927.2123-1-u9012063@gmail.com>
In-Reply-To: <20220629014927.2123-1-u9012063@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/06/2022 03.49, William Tu wrote:
> The patch adds native-mode XDP support: XDP_DROP, XDP_PASS, and XDP_TX.
> The vmxnet3 rx consists of three rings: r0, r1, and dataring.
> Buffers at r0 are allocated using alloc_skb APIs and dma mapped to the
> ring's descriptor. If LRO is enabled and packet size is larger than
> 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> allocated using alloc_page. So for LRO packets, the payload will be
> in one buffer from r0 and multiple from r1, for non-LRO packets,
> only one descriptor in r0 is used for packet size less than 3k.
> 
[...]
> 
> Need Feebacks:
[...]

> e. I should be able to move the run_xdp before the
>     netdev_alloc_skb_ip_align() in vmxnet3_rq_rx_complete
>     so avoiding the skb allocation overhead.

Yes please!

Generally speaking the approach of allocating an SKB and then afterwards
invoking XDP BPF-prog goes against the principle of native-XDP.

[...]> Signed-off-by: William Tu <tuc@vmware.com>
> ---
>   drivers/net/vmxnet3/vmxnet3_drv.c     | 360 +++++++++++++++++++++++++-
>   drivers/net/vmxnet3/vmxnet3_ethtool.c |  10 +
>   drivers/net/vmxnet3/vmxnet3_int.h     |  16 ++
>   3 files changed, 382 insertions(+), 4 deletions(-)
> 

--Jesper
(sorry for the short feedback)

