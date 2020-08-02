Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE04235A70
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgHBUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgHBUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:19:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A1EC06174A;
        Sun,  2 Aug 2020 13:19:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so9820562pjb.4;
        Sun, 02 Aug 2020 13:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/3zJvwzJp0+XQVNWPI/xcJ++7CcvrKHM6OKsI9tGVNM=;
        b=MnfFiSyN6BdDLnSxX3m9XkgwfSXXm9jUovCFGUpRjmA49FusuBzuSZDKRodBMm0vpR
         SnNKl+m2CtnFeoqIbs+ld4x2DNhpEVh5FV/W8CnbVRb6wJ2pZFhXvHOaiuRqBLuqYW6Q
         xkwSPk86hNgHIoYmGJNDsjqhCHyuPI6iYkq0oFnWVW9P1XIMonrTNBxW3bb+89daBL8c
         q+FC5gsUYMfir7pzdq8eezQWuEvMAvAH1S204jCI+THXAPkaRAg9EdgUUIrE7ghj7fzw
         DfdWa7jbQdMOsBgwFFELyi5LxwSQeKD3zxNsDSlebyjk75ke+p4xumFVaNBQORR/zUC+
         SVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/3zJvwzJp0+XQVNWPI/xcJ++7CcvrKHM6OKsI9tGVNM=;
        b=V8QgJoxmUj2OsvIoFCAs/GIpo3VWNToUSn3u+Fa6i/CRsweCCGTdcgjwHxLG76ZH5s
         BboHjEUNq0r09IgxeDaZ7JVJbGosnqrgU5Q6b7L8TXNu12u7Bdc9W3PdFXXK5+nYNdDx
         i1aK1ZKjM1BJIQhnwHc36uNlyeNcdQD7ezAX08kdlZrntta17iQ5L4b7YYgFf8qZank/
         jmovvkEVDDquJd191Kkd7qAk7YuLS3q+wEVYxuEfLNFi+ujs5rNiDV/gr0zK1wk6Gs/e
         dCD4pp2s0QhTokOe293b6RE1m34kfYGCADFTUcpFQitEp2ONFNIMA2W8HVZ8SS161Y/7
         bNSA==
X-Gm-Message-State: AOAM530tz6V2bBPumcQ66YH1eChmencjDmxorxmpUi/M5EBauV1DZaeR
        rartKF/JSvwseQVbsbe69/Q=
X-Google-Smtp-Source: ABdhPJxyxuDwQpzHloPJ7HSvqoxM/Ymi3io2mSEdqcnT4GafkzAfNQtKG4JEDj4uQuqtvmik5VkX1w==
X-Received: by 2002:a17:90a:2525:: with SMTP id j34mr15191072pje.208.1596399542523;
        Sun, 02 Aug 2020 13:19:02 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x18sm10065138pfm.201.2020.08.02.13.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:19:01 -0700 (PDT)
Subject: Re: [PATCH bpf-next v4 1/2] bpf: setup socket family and addresses in
 bpf_prog_test_run_skb
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
References: <20200802182638.77377-1-zeil@yandex-team.ru>
 <20200802182638.77377-2-zeil@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6d96e856-c47f-bdfc-8a6d-8836577e6200@gmail.com>
Date:   Sun, 2 Aug 2020 13:19:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200802182638.77377-2-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 11:26 AM, Dmitry Yakunin wrote:
> Now it's impossible to test all branches of cgroup_skb bpf program which
> accesses skb->family and skb->{local,remote}_ip{4,6} fields because they
> are zeroed during socket allocation. This commit fills socket family and
> addresses from related fields in constructed skb.
> 
> v2:
>   - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  net/bpf/test_run.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index b03c469..2521b27 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -449,6 +449,23 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
>  	skb_reset_network_header(skb);
>  

At this point, there is no guarantee the skb contains these headers.

You will have to add safety checks against skb->len

> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		sk->sk_family = AF_INET;
> +		sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
> +		sk->sk_daddr = ip_hdr(skb)->daddr;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case htons(ETH_P_IPV6):
> +		sk->sk_family = AF_INET6;
> +		sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
> +		sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
> +		break;
> +#endif
> +	default:
> +		break;
> +	}
> +
>  	if (is_l2)
>  		__skb_push(skb, hh_len);
>  	if (is_direct_pkt_access)
> 
