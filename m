Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8164A4D80
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381101AbiAaRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379995AbiAaRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:49:06 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65CC061714;
        Mon, 31 Jan 2022 09:49:05 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p63so17074650iod.11;
        Mon, 31 Jan 2022 09:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nNGCzkv6NyCSXM2+5tyOUFI7y2uK9Tss8SGh1iEIk7w=;
        b=htGB5/BkWPRWN1Y5bvGpfvADqRb+6Ud5NS4b4u9ZmItvUREEBKwPbS177S52LURGq3
         pIf9Qu0CA/YP3wR8YQg3POvLe3gLvgVRZt8aiGtGlanNvrVntppEGMnaVCAdCovdDPGH
         u9aG3qaml4dEY+9fEPtKbroK71D4yo3Jlh1E23K27ELl7yij4VQBiCO+SgQiw66b5quL
         HVil9XgRbY5QHuBgYQhuhX2Q4mbl1lAQ4hXhEch2fkdu5FdOlx0E/unqqVLMvUuiOVir
         HJppYBavStihTqW+SUWVqdCM3l83PhVLIcY9VGuwRKku9Rs3LM1Q8MZJZ2ZeZZaw3qyl
         IAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nNGCzkv6NyCSXM2+5tyOUFI7y2uK9Tss8SGh1iEIk7w=;
        b=gLuUP3yxZYAgZnNafMwBOE0W9Ofoo7XGEe8+VyuL4uyeVYytidLWuhPL0fR5UvAhmj
         DbNGvlhe/8IbHBgdoqEci7bvZHta8PwfsJJYxOEXGkD5XnLhBu//Pj9yFlS6fyuxBgrG
         vVqFAhGedFCYfszs/BpkcCCMJtvtHgpIJ65x0tfBvAgkaoE+j4Zl237EZAxzdILFYLdM
         N/+CjiYpsShySZiFZdxYtDc+0PxxblrdZIcvJgfxGttGUxoBFLRlCeOFk7D6GSQNxZs6
         LJJp/CVfKXQxfn4AcXNNL87rk3i1hyPAX2dGCWpQNos8slJox/X9tNZdqtXdQbLj234S
         Vo5w==
X-Gm-Message-State: AOAM532on7D1Zg/7Fd9QqmdX1wHzIibfnbflH9nX6KVxVEkb2eAQvc7m
        Nc/lxmqPQpyy2T5djhU1Upc=
X-Google-Smtp-Source: ABdhPJye6Ml2eCaUjrPOerm+ZoA6J7x6MviAAWdeVJBSeGNaZp2AToLoNYihw9vPAro144d5n8fimg==
X-Received: by 2002:a02:7f02:: with SMTP id r2mr11142997jac.148.1643651345209;
        Mon, 31 Jan 2022 09:49:05 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id f4sm5657927iow.53.2022.01.31.09.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:49:04 -0800 (PST)
Message-ID: <1a89b1ca-bab8-2ae5-668a-d9b89730fb8d@gmail.com>
Date:   Mon, 31 Jan 2022 10:49:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 5/7] net: ipv4: use kfree_skb_reason() in
 ip_protocol_deliver_rcu()
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
 <20220128073319.1017084-6-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-6-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in ip_protocol_deliver_rcu().
> Following new drop reasons are introduced:
> 
> SKB_DROP_REASON_XFRM_POLICY
> SKB_DROP_REASON_IP_NOPROTO
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v2:
> - add document for the introduced drop reasons
> ---
>  include/linux/skbuff.h     | 2 ++
>  include/trace/events/skb.h | 2 ++
>  net/ipv4/ip_input.c        | 5 +++--
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

