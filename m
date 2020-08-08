Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF31B23F81A
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHHP4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 11:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgHHP4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 11:56:08 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0E0C061756;
        Sat,  8 Aug 2020 08:56:07 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z18so3981151otk.6;
        Sat, 08 Aug 2020 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=taQVmt3q+KyxOZvgQSQZhABom8lU0tR+qr1/r1Bt7kY=;
        b=gsjMH45s+DOPfq+U2WbHrRS7XqStzA4bsr2SKII26MM+no7XC7FQOcQfad8Wz+BRBm
         g3vpMRceYwbJFWeCc+FAHqD3CF6jDGs5vph+AVKzkE6EjMEcL/iv1nDENvBZiYDYX3ps
         2FIGWNVb2p9WCWBlkbh1baGlgDSLvSBNCNlQcDwxahXUjN76cJ4Psjm6Z5lje8xwgDNS
         /gdHstXAtYMARvn8WFxnBrK93gtAjysb17WE+tXAmb5u0DPyGPQyrNTZvqq4mTH0sywU
         A9ZxraJCfRQANXh1GriTdbTnWsjphfaEqJRy1uAH/IloEKbW0eUpwrbJAffH6QKlrcA0
         2BpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=taQVmt3q+KyxOZvgQSQZhABom8lU0tR+qr1/r1Bt7kY=;
        b=rXX23OcSsMgNoV0AMF2x+IOWC1a/a1uuhudM4U74pOf+QkqLd6B9u5kPuZNXAVQjK8
         6zu5Hk6cQWp4AJB2vVCu4xK/0p0U+iN3SVJfGRQ0eWTjgUDyOSDuqV32DMqNY6pgGZqD
         xzRVzZFGYrVt1slCc/9BSNs4InpgPuS+cM7khluZcUGTwYMFIs0EaNg7cLByNPzn5owW
         TCRKjO9qYppgOIaHDys4ga9EVDtpKLu6qwUaE7uH9PoEt+YK+oeGsi1Fb0M7HIDxqfJK
         V4nijwWmOrXJiDOX+cgDXpUZXUY4zuWlmAKlnk38jngQ8s+zh6SnAOYoOKdA+cA+5xil
         apTg==
X-Gm-Message-State: AOAM5322c0ZvEz/khtuOrFlFNkiTa4AelIrnjT2MrarqKY8OEkMjhIny
        5DedB+D9Gqdm+j+U1IomWiY=
X-Google-Smtp-Source: ABdhPJxC3sjpn1v8lb8QU9aaBh/IbDrpWNl+VFgf0LxpicT+nn8QfOTcgKpGYuT9OGE4/JC51BAj6Q==
X-Received: by 2002:a05:6830:1d3:: with SMTP id r19mr15371323ota.27.1596902167303;
        Sat, 08 Aug 2020 08:56:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2d6d:708e:ac93:f86b])
        by smtp.googlemail.com with ESMTPSA id v21sm1532760oou.29.2020.08.08.08.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 08:56:06 -0700 (PDT)
Subject: Re: [PATCH] xdp: ensure initialization of txq in xdp_buff
To:     Paul Hollinsky <phollinsky@holtechnik.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andriin@fb.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, songliubraving@fb.com, yhs@fb.com
References: <20200808071600.1999613-1-phollinsky@holtechnik.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7cb5fff6-3fa4-3caa-ca57-040cd77d5c24@gmail.com>
Date:   Sat, 8 Aug 2020 09:56:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200808071600.1999613-1-phollinsky@holtechnik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/20 1:16 AM, Paul Hollinsky wrote:
> xdp->txq was uninitialized and could be used from within a bpf program.

The verifier prevents access to txq except by programs of type
BPF_XDP_DEVMAP and those can not be run via xdp generic. ie., generic
can not access txq.


> 
> https://syzkaller.appspot.com/bug?id=a6e53f8e9044ea456ea1636be970518ae6ba7f62
> 
> Signed-off-by: Paul Hollinsky <phollinsky@holtechnik.com>
> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7df6c9617321..12be8fef8b7e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4649,6 +4649,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	rxqueue = netif_get_rxqueue(skb);
>  	xdp->rxq = &rxqueue->xdp_rxq;
>  
> +	xdp->txq = NULL;
> +
>  	act = bpf_prog_run_xdp(xdp_prog, xdp);
>  
>  	/* check if bpf_xdp_adjust_head was used */
> 

