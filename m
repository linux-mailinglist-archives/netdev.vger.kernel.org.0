Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D34BF0A5
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240814AbiBVD3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:29:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiBVD3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:29:00 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248F722B1F;
        Mon, 21 Feb 2022 19:28:35 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id j5so8852682ila.2;
        Mon, 21 Feb 2022 19:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PJVXd6uPpgWdmHZEx7s8y7RU08UT5hr73kZpWlT93uI=;
        b=YYs0od3w0+7ABTLgw6mTJCMTVYS8FoUt4crhqeXiZKZB3IlDa7mZaEMskMLFUWucvg
         KW2hkB7rwLLdKz0Cet+dTHFS1cf8tJ+dtHmN6NVZ9+GRdkTSQ6E219oSm7/JqaQQgBuX
         z/KTTi99jI6Io2VnfIoGQwy1n39AueRtseipLfEfobRp7MIJqgnOLt48v0R446GAO6FX
         j2DHFg/I4xK8R2poZAjOjtg1hD5XrGmyw2FLLc0E8eU2momZRZ+wgwWdr0frTXK5J6uM
         pl5+AzTCgb/huTn5n4mnEt1r4ZsjcyHim2yZR9JdmIup5l2n42v7aB7sZsT3u42NYFDb
         WoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PJVXd6uPpgWdmHZEx7s8y7RU08UT5hr73kZpWlT93uI=;
        b=Nkb57JszOAVjLJpqCIavwDbx2lcxWVHThxztAtnKEmnNPk0UR0kglXAVqk/hTPd0uZ
         L9ZTCMTbvclPQLclaPB8QkRdPcgauz0v885HbtTog9ZdvCJTgXKzK7o6VOuTszQ4tceV
         4G7XijE4wWquBrPZEvu1zoAnFcclDDaQBVmMDcPwacQHvz0gaVlrB+O2dTr9DEcsgWkD
         nqDjqR/T/BMgquLCVRFsbYVmbnDHhFHJqHY66YZx1onZF0meQT9nZkATrt6csWQr7ERF
         gUb5Vu0rGbktbcrmHOEpbW4lIDWAWeV4h0IOWgmdYwaOVbj91Bk0I+6YcYbIE88EyM/D
         79RQ==
X-Gm-Message-State: AOAM5339mQycq0RaeF0t+xdtsmywDUxmWF5Dt7PMmz4d17RVLUXHQvhB
        YflvWBdw+avlPIrs1K/HLMY=
X-Google-Smtp-Source: ABdhPJz14bkgcNlvUTWpGLS2bzkE8NPCw56tyu6vl8k5rGRhQ4QGlUMl7b0zFUOEPoLaw5tbJHV9zg==
X-Received: by 2002:a05:6e02:19cf:b0:2b8:b53e:7aba with SMTP id r15-20020a056e0219cf00b002b8b53e7abamr18260121ill.258.1645500514587;
        Mon, 21 Feb 2022 19:28:34 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:fc7f:e53f:676e:280d? ([2601:284:8200:b700:fc7f:e53f:676e:280d])
        by smtp.googlemail.com with ESMTPSA id n15sm1379445ilo.26.2022.02.21.19.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:28:34 -0800 (PST)
Message-ID: <877dfc5d-c3a1-463f-3abc-15e5827cfdb6@gmail.com>
Date:   Mon, 21 Feb 2022 20:28:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-5-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220221053440.7320-5-dongli.zhang@oracle.com>
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

On 2/20/22 10:34 PM, Dongli Zhang wrote:
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index aa27268..bf7d8cd 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct netdev_queue *queue;
>  	struct tun_file *tfile;
>  	int len = skb->len;
> +	enum skb_drop_reason drop_reason;

this function is already honoring reverse xmas tree style, so this needs
to be moved up.

>  
>  	rcu_read_lock();
>  	tfile = rcu_dereference(tun->tfiles[txq]);
>  
>  	/* Drop packet if interface is not attached */
> -	if (!tfile)
> +	if (!tfile) {
> +		drop_reason = SKB_DROP_REASON_DEV_READY;
>  		goto drop;
> +	}
>  
>  	if (!rcu_dereference(tun->steering_prog))
>  		tun_automq_xmit(tun, skb);
> @@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	/* Drop if the filter does not like it.
>  	 * This is a noop if the filter is disabled.
>  	 * Filter can be enabled only for the TAP devices. */
> -	if (!check_filter(&tun->txflt, skb))
> +	if (!check_filter(&tun->txflt, skb)) {
> +		drop_reason = SKB_DROP_REASON_DEV_FILTER;
>  		goto drop;
> +	}
>  
>  	if (tfile->socket.sk->sk_filter &&
> -	    sk_filter(tfile->socket.sk, skb))
> +	    sk_filter(tfile->socket.sk, skb)) {
> +		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>  		goto drop;
> +	}
>  
>  	len = run_ebpf_filter(tun, skb, len);
> -	if (len == 0)
> +	if (len == 0) {
> +		drop_reason = SKB_DROP_REASON_BPF_FILTER;

how does this bpf filter differ from SKB_DROP_REASON_SOCKET_FILTER? I
think the reason code needs to be a little clearer on the distinction.

