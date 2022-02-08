Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C774AD100
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiBHFdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiBHFDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:03:31 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B232C0401DC;
        Mon,  7 Feb 2022 21:03:30 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 10so4981877plj.1;
        Mon, 07 Feb 2022 21:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D7TPg7igy8jX8i2IC5l48LueyTmlMqu2/RJJ5raSOkc=;
        b=nYoWxiV0dpeHGymcX1/LiH0Q2uLhPdSw9W1eorADlHjdoaGELcCZ4EEHCJECi2sCOu
         63cLRobdP2k2KEH9g2zkBuUU+yXU+DUGvk4esMKLOQvFP1VJ3PnY6IhvmUXLUo2sU/mH
         Fj05qx2iGcLgYkhzS/b1yK5tn6UJX/KIXWxwQp/zkK4S+3qh1RgkKBpJpBuYCU99dP5a
         Q9R1EY3jcKqLcnep3Dw0jwTf5anuxpP+G7TlFFPnkjJDBG+A/QN3NYSE7WykIxJ/LlAJ
         wEa1XekRbvsU0SkYiJpx+XmCV3L4FZBROV8sdxk98rLfvOjWSdN2pqpGxVy5cVdiBMZl
         K+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D7TPg7igy8jX8i2IC5l48LueyTmlMqu2/RJJ5raSOkc=;
        b=bSMeRPFiB4O4FMjryCjDdq09DLAHhGVMYao6q/yaRWF2iE7/3RYxhIOYaS6a9z48AY
         BN0yvQg2CEZtdQaL/r6liRWvJ7aL3M+ZdU6ZkHKePscliBjDcYp/OVNlKToteOTHGHvJ
         KW3Tm24sBMtSDXQ/354zpmgwO2HgH3Dz7/E32m6IDWMPNgVtUpAK3YtUZw3PQf0JNsHh
         3MHyStGi+aw2R39e4/t4epK0z/l5FlmC4PCvtkTWRbLTKOBtjNgGCT49QAkUa9wC1ASE
         OebA3NdMK9cb0mM28Brxtw/g4wnHxE6KLdtH35vGTzykB6I6+6fbMO9ThDMqS6S852n4
         1sgg==
X-Gm-Message-State: AOAM533NdJaaa2abVInsDSxDUb42AS8UoqOooiyIXRAKjQcC8vAcJu1R
        Gt4D3fJ3WXSVkMx9jSA+bcU=
X-Google-Smtp-Source: ABdhPJx8O5PSUs5MOOvZEKvj+v+OcwylIZAba/0DAfzEACWL/FTp9ttHKw0a0Uductr+7QzFLHFKIQ==
X-Received: by 2002:a17:902:7ec8:: with SMTP id p8mr2850589plb.165.1644296609885;
        Mon, 07 Feb 2022 21:03:29 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id a38sm1862369pfx.121.2022.02.07.21.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 21:03:29 -0800 (PST)
Message-ID: <f1d1f29b-45e8-1ba3-bdbd-4c892b6a4e0f@gmail.com>
Date:   Mon, 7 Feb 2022 21:03:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 2/2] net: tun: track dropped skb via kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
 <20220208035510.1200-3-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220208035510.1200-3-dongli.zhang@oracle.com>
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

On 2/7/22 7:55 PM, Dongli Zhang wrote:
> The TUN can be used as vhost-net backend. E.g, the tun_net_xmit() is the
> interface to forward the skb from TUN to vhost-net/virtio-net.
> 
> However, there are many "goto drop" in the TUN driver. Therefore, the
> kfree_skb_reason() is involved at each "goto drop" to help userspace
> ftrace/ebpf to track the reason for the loss of packets.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/net/tun.c          | 33 +++++++++++++++++++++++++--------
>  include/linux/skbuff.h     |  6 ++++++
>  include/trace/events/skb.h |  6 ++++++
>  3 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fed85447701a..d67f2419dbb4 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct netdev_queue *queue;
>  	struct tun_file *tfile;
>  	int len = skb->len;
> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;


>  
>  	rcu_read_lock();
>  	tfile = rcu_dereference(tun->tfiles[txq]);
>  
>  	/* Drop packet if interface is not attached */
> -	if (!tfile)
> +	if (!tfile) {
> +		drop_reason = SKB_DROP_REASON_DEV_NOT_ATTACHED;

That is going to be a confusing reason code (tap device existed to get
here) and does not really explain this error.


>  		goto drop;
> +	}
>  
>  	if (!rcu_dereference(tun->steering_prog))
>  		tun_automq_xmit(tun, skb);
> @@ -1078,19 +1081,27 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	/* Drop if the filter does not like it.
>  	 * This is a noop if the filter is disabled.
>  	 * Filter can be enabled only for the TAP devices. */
> -	if (!check_filter(&tun->txflt, skb))
> +	if (!check_filter(&tun->txflt, skb)) {
> +		drop_reason = SKB_DROP_REASON_TAP_RUN_FILTER;

just SKB_DROP_REASON_TAP_FILTER

>  		goto drop;
> +	}
>  
>  	if (tfile->socket.sk->sk_filter &&
> -	    sk_filter(tfile->socket.sk, skb))
> +	    sk_filter(tfile->socket.sk, skb)) {
> +		drop_reason = SKB_DROP_REASON_SKB_TRIM;

SKB_DROP_REASON_SOCKET_FILTER

The remainder of your changes feels like another variant of your
previous "function / line" reason code. You are creating new reason
codes for every goto failure with a code based name. The reason needs to
be the essence of the failure in a user friendly label.
