Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705351E4462
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388779AbgE0NuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388603AbgE0NuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:50:11 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB67C08C5C1;
        Wed, 27 May 2020 06:50:11 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id 23so20540274oiq.8;
        Wed, 27 May 2020 06:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a1TUEw5/JsL8gsEryhTxvgCweegsIr/EsyDfyV7zWRU=;
        b=E4KWr1Kau5Hs04onkGjtjlT4R9Jjt7r1vDz7F0LoI6WqRXl6lu4jovEXkZucrcd+jh
         5zbo9UbDZWxm3LFBVtxlUUpHdjpYSttORWN07WVTZ1RaVDDx651Eqfh9jXXrOz2l2AG5
         fo5aIn7gF1Hhig7C1AzXQLfuK6BzoD1QlifSNtI8aUVw5jzG/4wSrmYMc181bG/bq+QN
         mO6h00F6dZXNWCS2C5k6MBLL0JLy1Hflz0lm/eSFTJXFGC4XTBHF305y8hyimyul0UEo
         FH8Xe2MBSogrEhjjUoj9C+4xyxrrkfNPz9SPUR4a4CDqWU+3sRebKP0bkjDb2FntZSuA
         gQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a1TUEw5/JsL8gsEryhTxvgCweegsIr/EsyDfyV7zWRU=;
        b=JpxvcbQMUGzgnfnhbe0t5JU2YGSn5JQhGPfE0dlP+4pLBUgnnBhcOAjNaibybpTgKM
         6af8+ESfj5Pp8QfyXyYEWcP/Y2lRFMRCz9OGSjFf9I7or3ocRwEEP0q+KXtg7X94pXQL
         lBcr3qhK4y5ZPtqMP3DDuYQroA/pIUXBzaejiH6tfOFMGJGrDBUl9bvSY778cOceyVJx
         pGVkG+5/KSRv2H2AlWxzHREvGZqbLXowHf/Cs+F/Z89e1W2h7r4cPr2yNjuB6XwsJ54U
         ZLjd5bwghZ6k6/+xWDcx5bQuPH/pb85QJe+L9R2JhDYAvtNTW3UQhQqqJNuvBMCQBGLC
         z87Q==
X-Gm-Message-State: AOAM533D2/7ey8WGyrB6LcAY0Wi5zwNNS3UrjsZsh61ZFl6AOQpdacDp
        05dM/AMpLRVlUozeWVmvP4o=
X-Google-Smtp-Source: ABdhPJz65Q2NTQJ4atIhwWi87TRdmRTdbuEf2CHdPJZDlL4vao7TDLPuo0VowaBDj4b05oR35IMqmg==
X-Received: by 2002:aca:ba86:: with SMTP id k128mr2884972oif.60.1590587411208;
        Wed, 27 May 2020 06:50:11 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id w8sm828792oie.12.2020.05.27.06.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 06:50:10 -0700 (PDT)
Subject: Re: [PATCH] [net-next] nexthop: fix enum type confusion
To:     Arnd Bergmann <arnd@arndb.de>, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20200527134755.978758-1-arnd@arndb.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3722aa2b-667d-eef2-b901-ef0ae943f8f2@gmail.com>
Date:   Wed, 27 May 2020 07:50:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527134755.978758-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 7:47 AM, Arnd Bergmann wrote:
> Clang points out a mismatch between function arguments
> using a different enum type:
> 
> net/ipv4/nexthop.c:841:30: error: implicit conversion from enumeration type 'enum nexthop_event_type' to different enumeration type 'enum fib_event_type' [-Werror,-Wenum-conversion]
>         call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
>         ~~~~~~~~~~~~~~~~~~~~~~      ^~~~~~~~~~~~~~~~~
> 
> This looks like a copy-paste error, so just use the intended
> type instead.
> 
> Fixes: 8590ceedb701 ("nexthop: add support for notifiers")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Nate sent a fix a few hours ago:
https://lore.kernel.org/netdev/20200527080019.3489332-1-natechancellor@gmail.com/T/#u

