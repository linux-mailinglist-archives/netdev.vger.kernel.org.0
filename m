Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAEB2ADA60
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbgKJPZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbgKJPZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:25:54 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C068CC0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 07:25:52 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id g15so12448489ilc.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ZnDnxTpo+rmJxU7hh3B42tjjVaQURXAePdd8apkzhQ=;
        b=lPWN3VKxP581OTN1+eDJMVKmu08pfXa/DuPrPojcurd2D4L2XgXI3PHUAuhdGXhmfj
         hkK5273BcGFIshyvYv3fLQleF7NY7Iv5hyLy7uQc47ehbMULh2N+u9YAtzzy/UcFXqV7
         bxCYqHh9xW9jqyyaSkomMTUiJtHAsmHda1xFBhYjknC0lviaxqTO1NFrhUKet3nFCucQ
         ZCuAYXum/5mPw0QW7kp54QkMCvxdKeyZ29qTCrzYJBFR22It9jBBJOH8ItKxtqnxIvwZ
         Tm9YHg7yT/rbF/Ks6uAgIp+PPoglwpcdv8HWuuM3vwT+Jct4Nr+t7Ythd+v8Kk+8AIk3
         GKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ZnDnxTpo+rmJxU7hh3B42tjjVaQURXAePdd8apkzhQ=;
        b=BeO6+0/hdQEh9KVWmqKbd1qkgPrs/VFTOHi8RsxWczWrukVCn4Aw9HkvkfBU1HEjry
         ZSzDyfxiqDl/pXLjiGfgPX9nNi9q6droaV2RR6TDEn+jG49Z+Iz66OHsljz5Bu9+vki+
         de2eu3v04FwEi9ngo62BkhQY/1Qf8sPqVBDkas8tGOjg1Zivd1AxSJWZq/yfAQOcenw0
         HFt3KRXF9PxZaQiYaGHWXoMWyJUwqdG7ZDDxrbckkLj8q4z19MZ02B+7ZtAhAtZC1BCC
         2cYUSp+nzc6HguQUaabnjOf6kZp0tB1lYD3p8hgI9oRdIXqWfMNDMhgBKUjsLtKbrGAa
         rk5A==
X-Gm-Message-State: AOAM531DIWY9tE3qOHIbIYOzXzF1KCK1PGaG6IUdp7f7B+0wa/hq0bhl
        jhJTVJTJm4xzjpQNY0C5vx2PB7x1xsc=
X-Google-Smtp-Source: ABdhPJy3UlvpPbceAsd3wPAo49ZF7Qh0aRSbCwc2Qpk4yHly1fPcUalkPwP/BCNey1cssqHylRwxZA==
X-Received: by 2002:a92:ae0e:: with SMTP id s14mr13427817ilh.94.1605021951965;
        Tue, 10 Nov 2020 07:25:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id 192sm9703747ilc.31.2020.11.10.07.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 07:25:50 -0800 (PST)
Subject: Re: [PATCH net-next] ipv4: Set nexthop flags in a more consistent way
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20201110102553.1924232-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <53a29984-1767-2017-ccae-5b821fd5fbdf@gmail.com>
Date:   Tue, 10 Nov 2020 08:25:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201110102553.1924232-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 3:25 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Be more consistent about the way in which the nexthop flags are set and
> set them in one go.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> RTNH_F_DEAD and RTNH_F_LINKDOWN are set separately above, so I decided
> to keep them as-is.
> ---
>  net/ipv4/fib_semantics.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


