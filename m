Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4753A31FC
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFJR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:27:16 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:56133 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhFJR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:27:15 -0400
Received: by mail-wm1-f54.google.com with SMTP id g204so6611970wmf.5;
        Thu, 10 Jun 2021 10:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gHUSjbESYNfD7sG28gBLSykvdruQjgsFLHrNm+2HmfQ=;
        b=emflGDuQWMyQVmaReahmSphhsN3tGq/01vqu6RyLp5Axnm+528aJAiwHnxjq+x+799
         cmpg+bS8CflQUI6AO1f5ERbbfejwjnAFrpDyUXsJ/K5CvPIshDAZfh03ia6DUXm84Mbn
         GEEeIKPyy0hH73WIJtWFc7G49QT9mQHthBxWLQqBtM0VNmpqXZF4H/fChX+dBKA6D1xi
         GPcQloo24VIQ2z7F7nmAW6GdD83xhxL9IPoBN++47/8QwVt51XPKb1kfwdDQS6QN2B75
         cG3/Hgfpp8hebVs5paQ+r9s1wzuCiH1cRWyvlV8WiL40nrtSEJw2FDXoFpzPA95dbeGK
         hGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gHUSjbESYNfD7sG28gBLSykvdruQjgsFLHrNm+2HmfQ=;
        b=JfmynvajxoWxnUzv4bZIIIm3ElGokr4EZJmZKFZg1OrcsuNBthfUzgiARBPulWO7Ml
         9DLuLZgJA7K3DPMkOqKGvgYDgFsHeH4wn06JcCB0snqd4EB20dOoKWnJPPsKczapS/xg
         sG3oC5QLfhRkn1SxLgqpePjSGYLTcoP5dHFqv4Yx8uIgMJeftlIvE8b5cVjjVp4I1PT+
         5l8UNJW/Od2UWuxiN1Yuo49BJ3VdN0gyDgL1iUoR9RXSSSvxlVCfTyIAo19GrV/24SSE
         ZX7mDS0zeeCZapYxPxEIq/eYSy4+uAa8f4Vpy4jK0ReQ2i9k674Uy8ugIWbPijSzv7q4
         FpwA==
X-Gm-Message-State: AOAM532gkjkiqD0iskan4386ysIsIexJeYK56seypHQlKQeNkaP2WxQf
        p9jZQttaCdkmz8OYS73pG9qbfipujTAq8g==
X-Google-Smtp-Source: ABdhPJywlX06vBk6jltAnNjUFb5g1wiIIz5kiuW5Yo4w+tKby+/h5S0v09iWGBmzSvqcqV5BUF+rdA==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr3816566wmq.70.1623345857699;
        Thu, 10 Jun 2021 10:24:17 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id x125sm4033996wmg.37.2021.06.10.10.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:24:17 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 01/11] net: Introduce
 net.ipv4.tcp_migrate_req.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-2-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3a9ecbe4-fe7e-1acf-36b7-1f999f8f01d6@gmail.com>
Date:   Thu, 10 Jun 2021 19:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> This commit adds a new sysctl option: net.ipv4.tcp_migrate_req. If this
> option is enabled or eBPF program is attached, we will be able to migrate
> child sockets from a listener to another in the same reuseport group after
> close() or shutdown() syscalls.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 25 +++++++++++++++++++++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  3 files changed, 35 insertions(+)

Reviewed-by: Eric Dumazet <edumazet@google.com>

