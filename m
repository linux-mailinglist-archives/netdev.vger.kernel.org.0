Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59784BCB0B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 23:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbiBSWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 17:47:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiBSWrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 17:47:24 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3553810DA;
        Sat, 19 Feb 2022 14:47:04 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s5so7018809oic.10;
        Sat, 19 Feb 2022 14:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8eVuoRv9oIoTPmNw9cVPdHoz2GCqKqv49eYWyY9ccgI=;
        b=N72LaZCqZpgq0CicUvXeUQQVYC1uQuCo8YWCnec7VR2qabm/2YBKG/T+nHpOOvRkUq
         7YrraUwTVyY3KbtcptO/djBwGSYeXAizkvW9pRp3hFdTjqGcM1cHufX1W5L/AhLX2OQo
         edVsyBZxiIo6ldIPJ9Ix5q1c+TqaHtPKwQbYAS0wAtgm5/RD46jOZ9jDzwkbtFlPX9nD
         Kp62JbEfPkCeY9FqWMPCY3gnXjm4jRhit3h2yL/cNyj+R9SovNc11gds4XUPe20MFYkb
         57KZfYA33bUWLi/58TovhfTThokdSYSN298PvQ8+AWBtwwxYsCfWccz6Wc7YOQyZP7dZ
         3e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8eVuoRv9oIoTPmNw9cVPdHoz2GCqKqv49eYWyY9ccgI=;
        b=h0dXhBVfjF+KIBJ9ZfyJjfy6panzPhon6/no364hY9W/fYzxaxnA445+B5dy8tTHmH
         Bf1tyqRfE+jG+us3wGtJ+AYHQGRc2MHWXhnR+0iSjgEbqsaBuu2lVNWPXgvugXjaI0Xi
         9CL/8yFcEFdfwdkUVDc7wMX6t2c8yq3f3eaG/5WZErxyWHu5ih29V+5fe/mDEVkpEPdz
         e8Fm9vR5Il6G5QCM09KBZO+fen/QWpuJQtIifTfxRmq9p8F+FSukEPXuvWMcsX1Fw4tC
         29LO17ixYsd4DN/zkCV6651hsZVW55ACyrR+mhROR1CWYNSfepLPzpHUuk08U8k1W/xo
         kzGg==
X-Gm-Message-State: AOAM533eGb0LIzHhtPQqbWWtZ5yE5pn0s/eSx/r70KGkI3ZI1j2fzuEH
        eWLNP37UhNp8d59gGAcJsSjMaBFVeBY=
X-Google-Smtp-Source: ABdhPJzZS9kKYFIKq1AAPDGbDiW22D1JZznPWRi2Muf7VwLZT5kPQaV3VPAeXXST3bF4cu1qNtzlUA==
X-Received: by 2002:a05:6808:168d:b0:2d3:65f0:582f with SMTP id bb13-20020a056808168d00b002d365f0582fmr7836292oib.152.1645310823571;
        Sat, 19 Feb 2022 14:47:03 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:75f1:ca3:f2d4:114e? ([2601:284:8200:b700:75f1:ca3:f2d4:114e])
        by smtp.googlemail.com with ESMTPSA id c9sm2628916otd.26.2022.02.19.14.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 14:47:03 -0800 (PST)
Message-ID: <a76d0c63-f747-d33c-d782-0b2f696e7de9@gmail.com>
Date:   Sat, 19 Feb 2022 15:46:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 1/3] net: tap: track dropped skb via kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
 <20220219191246.4749-2-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220219191246.4749-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/22 12:12 PM, Dongli Zhang wrote:
> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
> the interface to forward the skb from TAP to vhost-net/virtio-net.
> 
> However, there are many "goto drop" in the TAP driver. Therefore, the
> kfree_skb_reason() is involved at each "goto drop" to help userspace
> ftrace/ebpf to track the reason for the loss of packets.
> 
> The below reasons are introduced:
> 
> - SKB_DROP_REASON_SKB_CSUM
> - SKB_DROP_REASON_SKB_COPY_DATA
> - SKB_DROP_REASON_SKB_GSO_SEG
> - SKB_DROP_REASON_DEV_HDR
> - SKB_DROP_REASON_FULL_RING
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
>  include/linux/skbuff.h     |  9 +++++++++
>  include/trace/events/skb.h |  5 +++++
>  3 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..ab3592506ef8 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  	struct tap_dev *tap;
>  	struct tap_queue *q;
>  	netdev_features_t features = TAP_FEATURES;
> +	int drop_reason;

enum skb_drop_reason drop_reason;

>  
>  	tap = tap_dev_get_rcu(dev);
>  	if (!tap)
> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>  		struct sk_buff *next;
>  
> -		if (IS_ERR(segs))
> +		if (IS_ERR(segs)) {
> +			drop_reason = SKB_DROP_REASON_SKB_GSO_SEG;
>  			goto drop;
> +		}
>  
>  		if (!segs) {
> -			if (ptr_ring_produce(&q->ring, skb))
> +			if (ptr_ring_produce(&q->ring, skb)) {
> +				drop_reason = SKB_DROP_REASON_FULL_RING;
>  				goto drop;
> +			}
>  			goto wake_up;
>  		}

you missed the walk of segs and calling ptr_ring_produce.

>  
