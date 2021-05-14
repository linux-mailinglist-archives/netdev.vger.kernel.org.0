Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A35380188
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 03:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhENBoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 21:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhENBoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 21:44:17 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E156C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 18:43:07 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id v14-20020a4ae6ce0000b02901fe68cd377fso6047751oot.13
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 18:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xA1yMV+gYd+1v63sQA1fJ5CeWQRGnxlGtM5vF7nxCiQ=;
        b=nGqH7YUi9vcuSZUCdeI7AdTxTP4hhyPcf0a0GFni3Bv9zzHYZN4aDhZxgNsT+B7Hmq
         3ZAWEJPJ93zhYYIDW3Artdht89j28jdvjvAPtIp8U85Dh35ziI+wATXiPxi+bTHicVWr
         wYxSV9QXVWNnLytxImr219CEvDV6hzoLeNiMb2kIujrbtwEdcywyJim2g8R9I4xh0KfL
         SP9YjcpfQYDNKg6WFjUsLHb4wynE5clFcbMV7407aECN82q3cDpTZOGdzbEVOfDBMHpi
         p3fJXPVV2+hZJwxcwjsCldIsoFyctyesGy4+RDt1VuxJgjA+YY0tjhKiZrW5Dspq+5rp
         58fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xA1yMV+gYd+1v63sQA1fJ5CeWQRGnxlGtM5vF7nxCiQ=;
        b=oVWmZDOeQM/LmQiUMOoyYkOcr+Dpccm2DzmOQ5HofKkRi1cAyCX5nGFzkpoc9f6Kyl
         KPhqPOyVu5+amGr7crkn2QAxZ1El8cI4s/3624Xmc4rSdoz+j+Qf3cuvclVzm5AH8oFL
         akzxn3e/Et1SObtD3tUHZk/VWgZ2bowgk2xeo/AyqFweUF5sGp9uJwexPmgq8cDILXhE
         7RVDQsZWg03O2QSb3zm9EuvsI1MAzqx/JQwGI8kF6a3bu8bT6PYVPHV1DU9qaVvNqzHF
         UlaY/RguJYIg3DV6vFfhZAwqGdD/HLn5OjJFvPM+tAEFF5RA1V1hQK6zZIWaYYKOzLbw
         7ecQ==
X-Gm-Message-State: AOAM531ZuciIFS8g5WzNo57xE9uZwZ6KJYtrXQPKa8V/wO1haFPpMRPQ
        uVIHUVK+w4dz5cKCTjXzbqA=
X-Google-Smtp-Source: ABdhPJxIv+z1gEzKvi2UfPLUJm88+RNqRXYMal7PyTkmnJ8jUSJ+LWZ9lB+GRfTRq8/MjhuwHR5sVw==
X-Received: by 2002:a4a:e5d5:: with SMTP id r21mr34868655oov.1.1620956586091;
        Thu, 13 May 2021 18:43:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id g5sm962051oiy.24.2021.05.13.18.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 18:43:05 -0700 (PDT)
Subject: Re: [RESEND PATCH net-next 1/2] ip: Treat IPv4 segment's lowest
 address as unicast
To:     Seth David Schoen <schoen@loyalty.org>, netdev@vger.kernel.org,
        John Gilmore <gnu@toad.com>, Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
References: <20210513043625.GL1047389@frotz.zork.net>
 <20210513043749.GM1047389@frotz.zork.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f59a83c4-838f-ebf8-72d6-e1d66967c596@gmail.com>
Date:   Thu, 13 May 2021 19:43:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513043749.GM1047389@frotz.zork.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/21 10:37 PM, Seth David Schoen wrote:
> Treat only the highest, not the lowest, IPv4 address within a local
> subnet as a broadcast address.
> 
> Signed-off-by: Seth David Schoen <schoen@loyalty.org>
> Suggested-by: John Gilmore <gnu@toad.com>
> Acked-by: Dave Taht <dave.taht@gmail.com>
> ---
>  net/ipv4/fib_frontend.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


