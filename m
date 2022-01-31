Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90164A4D89
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381126AbiAaRvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381120AbiAaRvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:51:07 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ACFC06173B;
        Mon, 31 Jan 2022 09:50:58 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id z7so12092966ilb.6;
        Mon, 31 Jan 2022 09:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TKO8y1qSdLIKch3b1v9WYdHjEs86qCAXlfLNQVKqV5A=;
        b=TWAb7sn96e9On3v+k3CtLLU36XJCGDBLGhmevMRdMQ2Shovy3wXIhc7zSsPJ2WAtoh
         SOzsI4naZjvfjPmgLLHRU/01t7LauOXeIkiTq4LdepgKU9ftty+x3TYXU6/NBaX3sh3F
         ninr1Tvu09+6C/yvR4dBP/rajaYJQU4LMW/HiAv3i2TbguGcTiT+lsUSxl/FG0oynzYZ
         lUfgskq1SyWEE9KtrUCjvEdqKsdDW+a9wv4zf39TR2xfDU5WH7KjLlloJW2IBa0fhnnK
         14cC94o9TCckBLlVU23T4980gnhb8Dpl9f3CKQfnzMhhm+XbNex4wCE+C4F7XFS4JtVo
         Kmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TKO8y1qSdLIKch3b1v9WYdHjEs86qCAXlfLNQVKqV5A=;
        b=cGANed/DyKwdjrwkDekgqXglOlgbxC9C5Kzwq0Fu4WUP9kfES4oo1dOidYj9g9tFrt
         AssY1aPEUNqWQAL3PfEqNTWkst/ctXlAQOxptu9hVwiCwHW6xuuWhAzx8suoYZZSJ6//
         xQb0h1yEaPn5/mRCK5fkK9oq+Qq6WjGEhK0SXPBrI42nBc1tmKC0w4+AejDCjb2tZ2DZ
         iwdlO3iI7ErwgirG8ahaWzuRDsNRs1VtDPrYWe4T26Pv/5ZPq8W326EgL9Ut5AI0bJty
         ZaQfy/xmcHHNHgddYWXqtX6HkZ5/HpcN2PB+r39oiEIxpC3uiKeYef4ukmpAfhkVM6Lz
         7FXQ==
X-Gm-Message-State: AOAM531Vwc0IV4ZkhbXCwRH1+SFPDKQMoFra9XjVLJM44fxnjOmV2uyg
        NBwrLYEY93g+RZQpTadJkF4=
X-Google-Smtp-Source: ABdhPJxaT/Q1EXE0wr5jCKiS6z59gDW7huwzkdaku4pBS7X2g/IXhqLsnClKoVzkzU0lTDUzfdw3lQ==
X-Received: by 2002:a05:6e02:1ba1:: with SMTP id n1mr12885031ili.99.1643651458055;
        Mon, 31 Jan 2022 09:50:58 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id t15sm12650904ioj.24.2022.01.31.09.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:50:57 -0800 (PST)
Message-ID: <d2916b79-9252-861c-2992-5f36e30ef611@gmail.com>
Date:   Mon, 31 Jan 2022 10:50:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 6/7] net: udp: use kfree_skb_reason() in
 udp_queue_rcv_one_skb()
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-7-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-7-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in udp_queue_rcv_one_skb().
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v2:
> - use SKB_DROP_REASON_SOCKET_FILTER instead of
>   SKB_DROP_REASON_UDP_FILTER
> ---
>  net/ipv4/udp.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

