Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD52483636
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiACRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiACRfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:35:09 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FADC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:35:09 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id b1so26458032ilj.2
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h7Il2J8I6bIZlgWvBvtzK0EJcR5ptLU1xP6vKhaNc58=;
        b=VTRyZ6jr+vUQXW3nv/Yic0LHkTfj1tgypr6D6VXPnUnDmkOKUd5cqFg1VtKvnv3nGA
         /mp/M2h2RkT/1S5SGsyqosTOhN5aO9ng+4fFJq7gSovys5BlswfZG8Sm8RqzSmsAbz68
         QgSxpTJoOOGiCiNLbx5IZZ2wmr8zWZRSzezyusxpJNvgrn2IZ+VkstBxbG/pbfeVY8J1
         O2GDH9jUk+nfN8+xe1Ugd/nKalag5oYxnD5IAMwEKNfhKErCUHOMdzwGevBkJ01DxGrN
         UrDXegwrqAzKONCvQY8bMbfDnFUjVoc05DoCbPNo4ZWbKPtgy0eHe1onKu5cicSG0RSt
         TRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h7Il2J8I6bIZlgWvBvtzK0EJcR5ptLU1xP6vKhaNc58=;
        b=FQ5xf/M3FYeVgGXOiEfl8R9a9A7JMBAZONhOmg0+qT0WqPmTPgKVjV0u1ozub9dIgo
         jbdZ8C2ARJtM+PzUGZJzsBc+iqJ+nFikK+372SA2WU8c6PX6718QhOo4yobl72IKMk4b
         vQ4TOONEd95L3f+0dsPj8NRtkADC4brru3jcD+ZkIf+BAtb0VbOPYFx+IK9UqoI/q8cM
         BoBUqPkVe4MLvStgz9bYf+w7XqjZiLqvBp020IDJsoxFX4gN1nbUzWHEMeCOgTjFlfrz
         8NCDcPsJW66dr1mdgcnGVYtTRa3TABDSD8Y2/fmZz+6c5hG5WTdS7nSQdThnM1kFS7qj
         ZAtw==
X-Gm-Message-State: AOAM5304QhBytV4sVOiBtnF6ZzB6Yijw6qd0YbaGEvF6sOSQR4V0XJl9
        teTIqUQSUsaBzveHto2jcLJS6RgkhOg=
X-Google-Smtp-Source: ABdhPJxWyelgVOtepdRBg+YJZpKv3/8Hr8OKf1gPVpzPRJ9bTPmHplQnrNlWExlG8Z5U9EtjhU9ekQ==
X-Received: by 2002:a05:6e02:1cae:: with SMTP id x14mr21146073ill.237.1641231308925;
        Mon, 03 Jan 2022 09:35:08 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g1sm23718882ila.26.2022.01.03.09.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:35:08 -0800 (PST)
Message-ID: <174b5c36-c42b-cff3-7608-58b95af50604@gmail.com>
Date:   Mon, 3 Jan 2022 10:35:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v5 net-next 3/3] udp6: Use Segment Routing Header for dest
 address if present
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20220103171132.93456-1-andrew@lunn.ch>
 <20220103171132.93456-4-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220103171132.93456-4-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/22 10:11 AM, Andrew Lunn wrote:
> When finding the socket to report an error on, if the invoking packet
> is using Segment Routing, the IPv6 destination address is that of an
> intermediate router, not the end destination. Extract the ultimate
> destination address from the segment address.
> 
> This change allows traceroute to function in the presence of Segment
> Routing.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/seg6.h | 19 +++++++++++++++++++
>  net/ipv6/udp.c     |  3 ++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


