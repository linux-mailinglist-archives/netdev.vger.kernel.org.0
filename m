Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE6239C05B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhFDTWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:22:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhFDTWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622834420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/OSjy7rj5MMtciwVjHGGLHvaE+7LxU3wiDX2YLz6FQ=;
        b=XFQnzxwyt/LPYyf/d4omDo8ssIcY9EacHN39bIpXQYjZ08K8q1kWfGzysvpzf8/lYBX267
        XcF62LO8YdFqR6lHG9Qg3R+e6PxspEUU6E/xxPcY4MZga7NH3cS3BULPehCLA+YjIOf6Gq
        bUi2gl0h1QfWpUvzAdYw7qwHXZmz+uA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-noAM9LYDMDirGMwIYbdO6g-1; Fri, 04 Jun 2021 15:20:19 -0400
X-MC-Unique: noAM9LYDMDirGMwIYbdO6g-1
Received: by mail-qt1-f198.google.com with SMTP id v13-20020ac8578d0000b02901e4f5d48831so5780625qta.14
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 12:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=v/OSjy7rj5MMtciwVjHGGLHvaE+7LxU3wiDX2YLz6FQ=;
        b=kqZI5MlplCHzEG9VAhJul6kJxiQf0ISNK4Yo1OJgMN/bTZpuQQMM/SUmcP4WYXJVQ2
         bu5mAh4h+GWkvdXnsE1AQfhUhPBSmLa3n9TIywqbx/2l7yFuW64O1BgUHs+HrgBRFuzE
         rDbhS6aHkwtBCD/vix0bFbHX2Kp2KLzCFBPFnPHSo4OCJoF6LFzFXd3vXl7r/ZmxroVZ
         Nx68W56aWNJq/pJ/BywILwInyusZgK6iiCwLu4dbRGBdtZ+SM1lUVqoGsaZsLt618qDf
         6C6G0ZaSnK1b5L7f3Xb7fK0iVXCpvUCnooP83jHZ2NhPy2uPeAiqfM68lRTQplb7UFx5
         NEFw==
X-Gm-Message-State: AOAM532zZYUH+Mjt95651XBYve1/3sgQF8b+sr+BRQhYll+ruGLPeR4E
        WydhwGeoxdxhyynCrcZkJDj3xwWs3gCyezzLYhH8GRdv51tL56cJVGiUqf/D5Dn42tsKKimrDw9
        0DJFDBs10QwERB7aw
X-Received: by 2002:ac8:5748:: with SMTP id 8mr6105578qtx.233.1622834418403;
        Fri, 04 Jun 2021 12:20:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxCiD4kWBi9CrjYC7k8NXIrBh7JN+pXxin/1Hf0f8UO8evbFVj+IiWqIzCKYP8sQKcMklujg==
X-Received: by 2002:ac8:5748:: with SMTP id 8mr6105562qtx.233.1622834418113;
        Fri, 04 Jun 2021 12:20:18 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id x66sm3152989qkc.100.2021.06.04.12.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 12:20:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
To:     menglong8.dong@gmail.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
Date:   Fri, 4 Jun 2021 15:20:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604074419.53956-1-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/21 3:44 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
>
> FB_MTU is used in 'tipc_msg_build()' to alloc smaller skb when memory
> allocation fails, which can avoid unnecessary sending failures.
>
> The value of FB_MTU now is 3744, and the data size will be:
>
>    (3744 + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
>      SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))
>
> which is larger than one page(4096), and two pages will be allocated.
>
> To avoid it, replace '3744' with a calculation:
>
> FB_MTU = (PAGE_SIZE - SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>            - SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))
>
> Fixes: 4c94cc2d3d57 ("tipc: fall back to smaller MTU if allocation of local send skb fails")
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---
>   net/tipc/bcast.c |  1 +
>   net/tipc/msg.c   |  8 +------
>   net/tipc/msg.h   |  1 -
>   net/tipc/mtu.h   | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 57 insertions(+), 8 deletions(-)
>   create mode 100644 net/tipc/mtu.h
>
> diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
> index d4beca895992..c641b68e0812 100644
> --- a/net/tipc/bcast.c
> +++ b/net/tipc/bcast.c
> @@ -41,6 +41,7 @@
>   #include "bcast.h"
>   #include "link.h"
>   #include "name_table.h"
> +#include "mtu.h"
>   
>   #define BCLINK_WIN_DEFAULT  50	/* bcast link window size (default) */
>   #define BCLINK_WIN_MIN      32	/* bcast minimum link window size */
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index ce6ab54822d8..ec70d271c2da 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -40,15 +40,9 @@
>   #include "addr.h"
>   #include "name_table.h"
>   #include "crypto.h"
> +#include "mtu.h"
>   
>   #define MAX_FORWARD_SIZE 1024
> -#ifdef CONFIG_TIPC_CRYPTO
> -#define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
> -#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
> -#else
> -#define BUF_HEADROOM (LL_MAX_HEADER + 48)
> -#define BUF_TAILROOM 16
> -#endif
>   
>   static unsigned int align(unsigned int i)
>   {
> diff --git a/net/tipc/msg.h b/net/tipc/msg.h
> index 5d64596ba987..e83689d0f0f6 100644
> --- a/net/tipc/msg.h
> +++ b/net/tipc/msg.h
> @@ -99,7 +99,6 @@ struct plist;
>   #define MAX_H_SIZE                60	/* Largest possible TIPC header size */
>   
>   #define MAX_MSG_SIZE (MAX_H_SIZE + TIPC_MAX_USER_MSG_SIZE)
> -#define FB_MTU                  3744
>   #define TIPC_MEDIA_INFO_OFFSET	5
>   
>   struct tipc_skb_cb {
> diff --git a/net/tipc/mtu.h b/net/tipc/mtu.h
> new file mode 100644
> index 000000000000..033f0b178f9d
> --- /dev/null
> +++ b/net/tipc/mtu.h
Please don't add any extra file just for this little fix. We have enough 
files.
Keep the macros in msg.h/c where they used to be.  You can still add 
your copyright line to those files.
Regarding the macros kept inside msg.c, they are there because we design 
by the principle of minimal exposure, even among our module internal files.
Otherwise it is ok.

Thanks
///jon

> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2021 ZTE Corporation.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in the
> + *    documentation and/or other materials provided with the distribution.
> + * 3. Neither the names of the copyright holders nor the names of its
> + *    contributors may be used to endorse or promote products derived from
> + *    this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2 as published by the Free
> + * Software Foundation.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> + * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
> + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> + * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> + * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + * POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#ifndef _TIPC_MTU_H
> +#define _TIPC_MTU_H
> +
> +#include <linux/tipc.h>
> +#include "crypto.h"
> +
> +#ifdef CONFIG_TIPC_CRYPTO
> +#define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
> +#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
> +#define FB_MTU	(PAGE_SIZE - \
> +		 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
> +		 SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))
> +#else
> +#define BUF_HEADROOM (LL_MAX_HEADER + 48)
> +#define BUF_TAILROOM 16
> +#define FB_MTU	(PAGE_SIZE - \
> +		 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - \
> +		 SKB_DATA_ALIGN(BUF_HEADROOM + 3))
> +#endif
> +
> +#endif

