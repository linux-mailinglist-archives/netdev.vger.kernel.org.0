Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7565F386F7E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346073AbhERBnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbhERBnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:43:02 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4189CC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:41:44 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id j75so8260975oih.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7tmaMrj0UlP0oYfvLieKkUTFvfOmVEFtF54H/AyQKA4=;
        b=WgA2K9J6BPDgaLjDgcvsKpoOIdfLR3z8pTrlva5PpNwRSn//NAaYuhuP8NWzzxTeKh
         6zB904WIzyIEGy5wp7/KAgxj7FRWr5Z+qIlEFgZeXiag+Lcb5sCp5GuBr/vg8Gk+OXZE
         lB7+NXvenuZ2x9A+D+jQX06F5VSIsfMzPUZEntIBfOKvXrIEkEQZQD9niRUKtX1/3pR/
         JruiZzTaLSOmhivieJ5/0UWqCL13Uj8qJt4Su2AkMAOIBdlPbZjnSRRZhhU7ihBIwtQr
         g1iR9T5BNVHgveLfU/bi0t9xuEy3RH15NoumCJ2GVyE7TtyuC02wBzGN7fdS/QB7TpKs
         FJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7tmaMrj0UlP0oYfvLieKkUTFvfOmVEFtF54H/AyQKA4=;
        b=Y9QpisRZ6Upz51NBbosG1OX2CSRhBYOH6jvNe/zrF50D5eXjHU0ixUw0ak2SWIh/Cx
         /7sBDaSv5gF4mxhAI9dVxdOv6fb4nJr02hbUKrCB+nyxrscFtrtUCTWu80OeFRvETTo6
         CeSv8ByZJUfxtrdQcKGrD+jsOhqpmcg1JYEQKXFdAGYTAH9J8vgvJ0BGSOv3fJB1tWgP
         ZI9YlRWuYD4Qdck9Iq91xxbwTfbgMKjhywzydKjoy8sIfpcUTYJ1HBtcWaKYOoLiebMi
         ArZS46IH+dnYRqwx/KjXoJBQRhHDf5DQiIBZQw6wSrMge72WwF9+NkVzjk60/gTFvumD
         S87g==
X-Gm-Message-State: AOAM531w7hWjW1Hp0KUJUIacR/6PItn2rqgpfvHUeriYAT8kZEdsf71+
        XJZaR/FWaqfPFWCjDcz+6+s=
X-Google-Smtp-Source: ABdhPJz1eG7yBxFkUYWt0C4zYCo6eq0pYX5H9iua46VTlKc+FlPfY0AzQQpVOf0zsb95g2tONbCeOw==
X-Received: by 2002:aca:1a05:: with SMTP id a5mr1544958oia.26.1621302103689;
        Mon, 17 May 2021 18:41:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id v9sm3545128otn.44.2021.05.17.18.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:41:43 -0700 (PDT)
Subject: Re: [PATCH net-next 02/10] ipv4: Add a sysctl to control multipath
 hash fields
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-3-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c7b0c0c5-7c65-28de-44c6-1ddd7f918574@gmail.com>
Date:   Mon, 17 May 2021 19:41:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-3-idosch@nvidia.com>
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
>  # sysctl -w net.ipv4.fib_multipath_hash_fields=0x0037
>  net.ipv4.fib_multipath_hash_fields = 0x0037
> 
> The kernel rejects unknown fields, for example:
> 
>  # sysctl -w net.ipv4.fib_multipath_hash_fields=0x1000
>  sysctl: setting key "net.ipv4.fib_multipath_hash_fields": Invalid argument
> 
> More fields can be added in the future, if needed.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++
>  include/net/ip_fib.h                   | 43 ++++++++++++++++++++++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/fib_frontend.c                |  6 ++++
>  net/ipv4/sysctl_net_ipv4.c             | 12 +++++++
>  5 files changed, 89 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
