Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81CB4AB1CC
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 20:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiBFTtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 14:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiBFTtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 14:49:06 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC6C06173B;
        Sun,  6 Feb 2022 11:49:05 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id t199so14900147oie.10;
        Sun, 06 Feb 2022 11:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xuH5LwjSVIt+LugVjeOkEcTu2jDeLj5HZjqsIfKe4BA=;
        b=S2Bbf4aN8jx/xxrQtVbjJ2ghQeyY53ajzovnB+JEO6A8rLtG+FO7XDFmES+C7yxhJS
         Q/SdQ95T/ngpglJQBcVi46FBobH3Do1bXrfw7Qv68odgpJMymG4lhojxyjAy8Hqgvi52
         D99S8Asf2qYuxlaN13FjzPbDIg1iKZq2Z2nWt+tiXznpM7IIIhmx0WxFuXeIYe8px5R4
         mSpsc2koSoMDOxGFGwCnAkl++SqhqADVnFO8aD+LkpbEkxzZ6eRJaO7mCmAlX/eGfnpi
         twHVIMOWn7NMLTDxkzqbZPGc/tTR+qn+5lpKEIdEITaqM93ZXa1EXDVoasuOSWO0N+Bp
         ErfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xuH5LwjSVIt+LugVjeOkEcTu2jDeLj5HZjqsIfKe4BA=;
        b=g+uQ2gjt0kt/UZo1Fgv5zh1APBPm/p/a0KKaP6KzxQwP6dXr7XD4jS1Nuvk737mrxe
         WTwnf5E5vub1if+ckxHpg40xlnsvqKVET/CA8lvzoGsQRDWheC7ZwVbZc3TdMd2MiqM8
         rzXDE4r67SqjBvF1WV05AKbP2eJ0d3NYrlZ/hyFFWwxqrFiJe+t7OnAbgrGQzWk3HoQ4
         8wGpnetK0gKh+VquOizeUNlNzHFcnru2xyJCy+mHpPy/EjNfH+fjyTzO0S6+EcutUsvO
         835Cre/zT2TpW0R4QOQh8h/r6kyBjRT5nYIvx9ns5ufEGaCaHC9Xr+PbO4i7L2FCgw7o
         ncyw==
X-Gm-Message-State: AOAM530QrXTSQydulp0tHv85eq6LpwdpqyfVRAFuCBewtQje/UU+Rxdd
        5oTMEsAFOOb3JP8lPg8thWY=
X-Google-Smtp-Source: ABdhPJz5mRLQNKL7AlkHq0WgVz0BNSpHW135n7KrqYzeFLpMxE36ZJC5sE651VJ6YS1a+fqDbbLQXA==
X-Received: by 2002:a05:6808:1647:: with SMTP id az7mr5073891oib.148.1644176945192;
        Sun, 06 Feb 2022 11:49:05 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id t25sm3122296otk.31.2022.02.06.11.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 11:49:04 -0800 (PST)
Message-ID: <0a561b4c-1ed2-4090-34a2-09bf7908c5b4@gmail.com>
Date:   Sun, 6 Feb 2022 12:49:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v4 net-next 3/7] net: ipv4: use kfree_skb_reason() in
 ip_rcv_core()
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, edumazet@google.com, alobakin@pm.me, ast@kernel.org,
        imagedong@tencent.com, pabeni@redhat.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        paulb@nvidia.com, cong.wang@bytedance.com, mengensun@tencent.com
References: <20220205074739.543606-1-imagedong@tencent.com>
 <20220205074739.543606-4-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220205074739.543606-4-imagedong@tencent.com>
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

On 2/5/22 12:47 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in ip_rcv_core(). Three new
> drop reasons are introduced:
> 
> SKB_DROP_REASON_OTHERHOST
> SKB_DROP_REASON_IP_CSUM
> SKB_DROP_REASON_IP_INHDR
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v4:
> - stop making assumptions about the value of
>   SKB_DROP_REASON_NOT_SPECIFIED
> 
> v3:
> - add a path to SKB_DROP_REASON_PKT_TOO_SMALL
> 
> v2:
> - remove unrelated cleanup
> - add document for introduced drop reasons
> ---
>  include/linux/skbuff.h     |  9 +++++++++
>  include/trace/events/skb.h |  3 +++
>  net/ipv4/ip_input.c        | 12 ++++++++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


