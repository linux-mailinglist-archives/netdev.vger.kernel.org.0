Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511414A4D92
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245662AbiAaRxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiAaRxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:53:42 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09CDC061714;
        Mon, 31 Jan 2022 09:53:42 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id c188so17951356iof.6;
        Mon, 31 Jan 2022 09:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=U19SOwgEN9NWU8jRTy76U3BvJNJSKaGDXy3EURqG428=;
        b=DiVA9KgYG2K0UUj+cEBwdYN2YkQqnNNLVGyMMtcSsnK3g7IPzoBVQqt2JSn/bR+nGt
         z06tLmLdo4qB5hqU0nBo4ueGIu4CoxmawPFCJKICXAV3fjtXZwvCeompFpWqF82fWw0N
         GmE4wzCywzV+BXOrKniZJ9/yvGsNmyqhud2CUyy7HTuMYNa+/El32l69Zj/rsEkMYeTk
         hDudCYttv5Q1+678OBZvjQICIFLaNryso7saxAOoJ7t37cB7jT8J+8HAeV2mg7sB3qK6
         crK5mWxxUtw6oPvaf6QooCyN/KlXXqhcMwsu9KxgzOzm48Gm14nUh6WrbUIJMw5ppdtI
         3Mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U19SOwgEN9NWU8jRTy76U3BvJNJSKaGDXy3EURqG428=;
        b=YcPKCWcCrrFpRwcbszXWG9QRAreCwFkJwXnltkwYo606DhkQBSxQfdbisDU6HtLFGV
         UowuQFX8Wt5bALmIK+5B7TTfMo5lH9ASsS2dBjexTuvXjH13Pc92U0XsrAf/zo9CZ5Dn
         ietAqnqAP+pKI/4IDjdzeFU8nH3NwjLZ7Bdo66kmyjlh7DT+3HImb/4030agyg/D2LON
         Cwd9ndQr4o+cZTQNOg5XlrCacInaigQiEq8yG/XyRM6JJxLmP/ZYdzgfAlwC+ix+0D/A
         B5njjvw583HgCn3OnHuKpbsnKAJ0ROmRhFySHHaTPTABfDQ+QWoGuLiLEpGCzJHsAcKQ
         XWPQ==
X-Gm-Message-State: AOAM532rvbQ9vyItpP9xBAqKFqbRQIRJlJnJCUXe6HI4qemMdhAPvNf2
        tobFVQ5j+BoIrdMHk93LJS8=
X-Google-Smtp-Source: ABdhPJwLmntUtgQBn8Jt9z3nqUWg2DkWFh63AJYcZ25u9+GyXgGDoc5XI05TP0qY0rAjTcBE7Wen/g==
X-Received: by 2002:a05:6638:53a:: with SMTP id j26mr3204202jar.136.1643651622115;
        Mon, 31 Jan 2022 09:53:42 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id i15sm18585139iog.14.2022.01.31.09.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:53:41 -0800 (PST)
Message-ID: <4fa7b7bc-6d86-1ed5-8f9b-04cfef5f13ee@gmail.com>
Date:   Mon, 31 Jan 2022 10:53:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 7/7] net: udp: use kfree_skb_reason() in
 __udp_queue_rcv_skb()
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
 <20220128073319.1017084-8-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-8-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in __udp_queue_rcv_skb().
> Following new drop reasons are introduced:
> 
> SKB_DROP_REASON_SOCKET_RCVBUFF
> SKB_DROP_REASON_PROTO_MEM
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     |  5 +++++
>  include/trace/events/skb.h |  2 ++
>  net/ipv4/udp.c             | 10 +++++++---
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

