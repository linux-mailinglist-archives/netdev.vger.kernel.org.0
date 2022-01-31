Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFAA4A4CCF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380754AbiAaRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377208AbiAaRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:11:49 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6366FC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 09:11:49 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d188so17760037iof.7
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 09:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pkayHMMEBRyLscJCH3BWCLcDeffOFl+Ni0yOVSaFrtI=;
        b=QTEnm0tqZEG3XZ+Yj92YEUQcTN3hCU3BYhxO1lzWfVKXWf8QVbYaRLVea62m/Se67S
         HK5geupEBPkvmdkee7aEcHOEc1rESfzf07mggNIYNIML4s7bm6kYuB/P9SFCu9QAnczi
         Ts75bcFQQLpDcdFspvA0ylpEj7uCAnnfhu/7E6AcrNBg7v7t/0admBuedPaXpCyAXGLG
         ozodlcqGIZI2tDrBetZVTDr9QYqH1pE9Iw9p/omPiN8NU1GKNvf67X84GFiE4zrjl3od
         r/SI0Ua/5RnPI2MMOqA6S7UvjZ1UxfTMp4fnBFAz9iQutrJn2o9JWwFQCrfIp9ML+yCS
         FqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pkayHMMEBRyLscJCH3BWCLcDeffOFl+Ni0yOVSaFrtI=;
        b=TX+fqMxetSE5FBw7I5S7/QyV2tpEyNGvbus+yBlRVB38wOvSwz/wTG2AhqTlyhC4nl
         lUj6/XLJKT3BpnW/4g7d9DcaQV9xoxGPNIkzLQNlE0ZokMRan5xj9rt4aX8lu66A/A2Z
         DitCe9zbrEuNWUqBpf4K4nnCa9YortGI4RLAu7s3Ilq1ol8xvIeWMMF9Vs7exHtDjmR2
         34cmOTfZp+AEiL9unRbRo2HN8u44umdEj74bgFn6BuoezYBTnosofxqEr7SzEAkDOMKz
         XeyRG/OpJVrk1FbHv5df5O20BEJlyBULhygn32tMs9ToaOHik3C5BRzqQ4t5/wP9BrKk
         sJjA==
X-Gm-Message-State: AOAM531q+bd8mTjki10fe/zQBtPNCk2L4XmTlvJYYN9dcKQFs5zGW/pI
        2hs5hXQx2Yu2OXT7YAXeNu98oCHkGeU=
X-Google-Smtp-Source: ABdhPJwERgIePNuCL5J5dkaktOfx8EUnPEACg2STpaqgdSVvHvsx+4lm8r7xk3qVXm1lRDEBkxdomg==
X-Received: by 2002:a05:6602:2c8d:: with SMTP id i13mr12078014iow.181.1643649108914;
        Mon, 31 Jan 2022 09:11:48 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id w5sm12411374ilu.83.2022.01.31.09.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:11:48 -0800 (PST)
Message-ID: <4234bc5a-3e2a-1ac6-0e70-b24d39fad441@gmail.com>
Date:   Mon, 31 Jan 2022 10:11:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] ipv4: drop fragmentation code from
 ip_options_build()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20220128160654.1860428-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128160654.1860428-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 9:06 AM, Jakub Kicinski wrote:
> Since v2.5.44 and addition of ip_options_fragment()
> ip_options_build() does not render headers for fragments
> directly. @is_frag is always 0.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/ip.h      |  2 +-
>  net/ipv4/ip_options.c | 31 +++++++++----------------------
>  net/ipv4/ip_output.c  |  6 +++---
>  3 files changed, 13 insertions(+), 26 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


