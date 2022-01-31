Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD54A4D76
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379696AbiAaRpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiAaRpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:45:50 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BA4C061714;
        Mon, 31 Jan 2022 09:45:49 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id o10so12119226ilh.0;
        Mon, 31 Jan 2022 09:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XfRJEY7E6FtQ5QEGYQNjBSXpk3DsX14VgtmalFnB7/Y=;
        b=Zb4RWOxv9WY04VuCKz6b83vyDqwMUROqaaqV7Oa63cgj7JBc8+NbeVhsppPC+h0JBO
         KFAwcbBzlUsaJMo6QgiYpl6uylV+G8OtwkHZpmxDUK1b4zK9Fo8qgHaMEJqDdHA9nGGy
         KFhMGXr+RWHy6hPRXrhfooRjNlVx714VjHrMvWrTNJwqeUqel7nIuiOQG4stGfKzmOUc
         EeTbWRSGZOjHKPNJQOqERMCPht6nPo5OFjGRA+ChwwG0EarXPtCSWCoQP104KBsxib2z
         IiLVtTwnuncKT6Szi48x2aKe3vAbX3xJ/7cEFRljBkSRyYaSQSADJPvri5NxCSNWgYDm
         PYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XfRJEY7E6FtQ5QEGYQNjBSXpk3DsX14VgtmalFnB7/Y=;
        b=zQT+sYaetMAUIlOq5T9bIzVsGr5rWoFDm4+dcL5MbR07fPi16llL8QNc6uWbUafHfl
         qcT1pHlVoVd5mqfzuCkVQrWCSgevRcdaWyLU/6MFfGNNWG23OdCLM5RY3lmQJjmFZPP7
         r3YqXR8E7UH0LyTmLQ6ABN19bdX2QODWTgELwPd7NKI/ekzYOG5nJYI+zCbs6C6uqJxR
         uGQqPo5iZzO0SvwkuSt8OZ3ZCbxuwXE+sHCAnpcMaASU8tn0PoCbN1FYSkxzBHG+pQJ2
         ExaMRK1fyPaHy4+DlpD2LSibZpka43Epj+/VoEwzJ/XdBPTPugWG3VYI3P6GLbX3KQbR
         y8eQ==
X-Gm-Message-State: AOAM531UfQLatUDtTmovQR92XrkHmzjxd0/kk4vxZOY/bqT2aMiea4gv
        QOENLo/ykOUZ8E6dJ827QA4=
X-Google-Smtp-Source: ABdhPJwQgXXnSbPrSIFTMtXSRiy63opJ3FieSJlfPw1cROxKkgXwhsSjMd23StzuSpxZILqVG6wZHA==
X-Received: by 2002:a05:6e02:1307:: with SMTP id g7mr2041943ilr.46.1643651149289;
        Mon, 31 Jan 2022 09:45:49 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id l12sm1848679ilh.36.2022.01.31.09.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:45:48 -0800 (PST)
Message-ID: <b1d3869f-fb8b-4396-a2fb-38d0c6d193de@gmail.com>
Date:   Mon, 31 Jan 2022 10:45:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 4/7] net: ipv4: use kfree_skb_reason() in
 ip_rcv_finish_core()
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
 <20220128073319.1017084-5-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-5-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in ip_rcv_finish_core(),
> following drop reasons are introduced:
> 
> SKB_DROP_REASON_IP_RPFILTER
> SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v2:
> - remove SKB_DROP_REASON_EARLY_DEMUX and SKB_DROP_REASON_IP_ROUTE_INPUT
> - add document for SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST and
>   SKB_DROP_REASON_IP_RPFILTER
> ---
>  include/linux/skbuff.h     |  9 +++++++++
>  include/trace/events/skb.h |  3 +++
>  net/ipv4/ip_input.c        | 14 ++++++++++----
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

