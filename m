Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D79386F8D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346114AbhERBpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbhERBpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:45:41 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBBFC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:44:24 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so7297460otg.2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ztw99eJm1/Mcoh63DPLbehNELWywVVuQpipf6ICDqH4=;
        b=BDNhdsfeGxM6ZcrjR6tKnCdYdxRgZsGkbM9q6k9cnNESeTlC4v3jJD02+vXAfotbT7
         cIhcMi5Qafstk10axbMIQ/zVGG/MOo3l1c9hiNmd+NvDN46BWU3UrffZNXkIgw3L5irU
         4o3VZ0zLhCKzPSuJZ3ZofrnGxOOih6kDipwsemXrnw3Ls3sF78LHNpXVkNIa1YEi89/k
         T0xup19DVDkiqAB7Dha8y2SYvQTQ1hBBqXQUETR3HmXDlOcwR7nvFk3sjYgzbHtjo07g
         WiNY0a3LgzRmex6DjJ/NQWpvpZps82mwB3xLkLO5En58Wvct0PQr8yAHiFZ1/jEpZTiR
         p3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ztw99eJm1/Mcoh63DPLbehNELWywVVuQpipf6ICDqH4=;
        b=Ny+g41T71y+atPiOK/TwfxQ7lNM73/N1ChaFCbCCCqQCzt9rhe+NsbQKc4gVcGu4CY
         sTqFxtVwvjoqLTYU3yYdfzqjdN5ETA77MPbfv0RjTh5/hlR8HegiNDY0YgvyoU0yt2Bc
         Bqjmab5ID85yc9TYWyOAoqOv+U0oDElVo/tJemNTmZD05bozPCQl9xDnOP0iKlbR8xr+
         A5YZ1mfXHx0ZMFHKt52NkA/O4uOUCuzIGElvlaAGeP/zUnD3lIqLHeifVmRNMKQKm/Gn
         B7xVcO+2i1uAGKuIZr7usvnvROLggjm54zFVLiiTeyUIiE76s8mzU70Knt62XTdmnxEu
         SnhQ==
X-Gm-Message-State: AOAM533D2pJtF/JBhChbLpDBF9y0k3JKtBPgx+JTZt4cHBEd/Y7RZB4h
        MVKoF1OqjVikIUyU7mK9bMs=
X-Google-Smtp-Source: ABdhPJyntvzQFsVCzfdIxaU+/fiHUm3O3dU2qS1Cu9IsgRBWd0/pMYnfepstxXitCWS8ht8xrmPcSg==
X-Received: by 2002:a05:6830:cc:: with SMTP id x12mr2143187oto.343.1621302263771;
        Mon, 17 May 2021 18:44:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id e7sm3527676oos.15.2021.05.17.18.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:44:23 -0700 (PDT)
Subject: Re: [PATCH net-next 06/10] ipv6: Add a sysctl to control multipath
 hash fields
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-7-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5c17daeb-cc26-852f-01df-ca83ffbb3970@gmail.com>
Date:   Mon, 17 May 2021 19:44:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-7-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> A subsequent patch will add a new multipath hash policy where the packet
> fields used for multipath hash calculation are determined by user space.
> This patch adds a sysctl that allows user space to set these fields.
> 
> The packet fields are represented using a bitmask and are common between
> IPv4 and IPv6 to allow user space to use the same numbering across both
> protocols. For example, to hash based on standard 5-tuple:
> 
>  # sysctl -w net.ipv6.fib_multipath_hash_fields=0x0037
>  net.ipv6.fib_multipath_hash_fields = 0x0037
> 
> To avoid introducing holes in 'struct netns_sysctl_ipv6', move the
> 'bindv6only' field after the multipath hash fields.
> 
> The kernel rejects unknown fields, for example:
> 
>  # sysctl -w net.ipv6.fib_multipath_hash_fields=0x1000
>  sysctl: setting key "net.ipv6.fib_multipath_hash_fields": Invalid argument
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++++++++++++
>  include/net/ipv6.h                     |  8 ++++++++
>  include/net/netns/ipv6.h               |  3 ++-
>  net/ipv6/ip6_fib.c                     |  5 +++++
>  net/ipv6/sysctl_net_ipv6.c             | 12 ++++++++++++
>  5 files changed, 54 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


