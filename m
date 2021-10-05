Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7242233C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhJEKXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEKXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:23:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1F5C06161C;
        Tue,  5 Oct 2021 03:21:31 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bm13so26284592edb.8;
        Tue, 05 Oct 2021 03:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CEdQT+jhzePF09d5nxg+a3n37p9bPMyvS/B1hLl0BVQ=;
        b=jFvWsBAiTyS8OXf034COJKn66eyvGIoYzInkdVgrZ0VwMe7B515AlPLn5TiZF6kI6F
         vMFPy/wyGDqABQNsm5YzqTu+5uNwz95kH7d7cHOv7T3/2zYKcJnNiQL4eNlreha2Eu3W
         J3dn9KHaAC8CXjNnYrsW/eNj5Nr87XeRv21QcSS1+oqGdXmzZt2GXAKkEw8Ti7fQor/N
         Zr64NLZFM3kyvcXJSlxO+4H42KwncYYmQWYiTJnoUqJCpcLquM+dH7AzXkxY+wYgZqsj
         z3B9KmGCqtjEe1a5wGYjdqYB7dBAJK2EFnrQnphCV7KqDNcwhCoMizsPSlXN7Bp3jfaM
         49qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CEdQT+jhzePF09d5nxg+a3n37p9bPMyvS/B1hLl0BVQ=;
        b=bvGLroUjaTgETunygrZiBV/yI/X+O+c7ZfiYm5CRNXm45KW7x86sSM39NEcfJE2X6I
         a0whZ7Q4bnBaOWVwAtbyQmPAaDIw/KZ8HlD8h5N/r4kEynFXLXypz/eaODQInJceKANr
         u6jKCTBJNVYlUmK25BD5nDBykfXFJl57cS0lyvo5quzdUxrkNvCSAoOoc6ah9nJYZG/S
         WNUAlJVk1FR/d7RnK0ZG7OqvCmTNvuIvfZTyJzpY22k4Ce5sBu74JSFMvMqwPS/qWjrB
         xcKNK1zFaUy5HRR5QssCH4HH00yfMnH2F4pbgfpfIQ36rJIFmzWsBQAJtA/egUAbiXKT
         6X+A==
X-Gm-Message-State: AOAM532l6H+9Isv84o+fVFpbjNl/cNa/koAO7PW/sNB99FelB4WCmJpa
        /EOJJASEFbIeCMQ0rJ984o3I4eJQokU=
X-Google-Smtp-Source: ABdhPJyn7jACEly+vYhjZH8r7pf+3bruHxVjxCtVlCAKjiE/Ush2QE47ZAdy1nyZLiora2nRTztpBA==
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr23585545ejj.176.1633429289913;
        Tue, 05 Oct 2021 03:21:29 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id q11sm8476609edv.80.2021.10.05.03.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 03:21:29 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] mlx4: remove custom dev_addr clearing
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org
References: <20211004191446.2127522-1-kuba@kernel.org>
 <20211004191446.2127522-4-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <63e8f75a-7b24-0920-a57e-010ac76f8d69@gmail.com>
Date:   Tue, 5 Oct 2021 13:21:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004191446.2127522-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2021 10:14 PM, Jakub Kicinski wrote:
> mlx4_en_u64_to_mac() takes the dev->dev_addr pointer and writes
> to it byte by byte. It also clears the two bytes _after_ ETH_ALEN
> which seems unnecessary. dev->addr_len is set to ETH_ALEN just
> before the call.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

