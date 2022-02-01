Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408124A55A1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 04:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiBADaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 22:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiBADap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 22:30:45 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6DFC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 19:30:45 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id c188so19568748iof.6
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 19:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ghrORYb0cplBa3jCtIM6MutvzcQJp3YrsjucCfWqaN0=;
        b=LXuHTNioCiMVU11Vmwobl0dIytDV1jXburULKeTuSLzIxllQK+VmYkAskdH1jsqoqX
         2djXf3e/af077uylcw360tCu1v/+49oGqdnfvV59zGnsKLyiHxZtBvIguRlSRNKNIeTi
         DQ+yW+n45r5QVXYicAUjBeXkD4Pe/ABOQKyX97CLNGBA+BSuYocEyv/yMFwEsxO9DOuU
         Z26j1NLfDYK/tYOLxqyA7ZCQY8fIomzidSOs0r4bmdhZrh0p1Bgo0Zt95CSZGYaft6LJ
         ZhXjOBxKYSdSl3PjumpimjiZnVnpnyQW2V59Q7nF8Yh9gcliEpKCLCVS/hvA7MmihyUc
         hQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ghrORYb0cplBa3jCtIM6MutvzcQJp3YrsjucCfWqaN0=;
        b=N3NLNSNcD7EDXxZ3ryncQBfMsOQL/dIUD70G7bN0VMzWt1ff2W1itYJCZArzBebuaO
         Lwk5yb3feNO7wEK2jn12yp+s2Dk/vEFA41Y3UVJEGX3D0sfNz1JunPSBt0k3ThUc5jE9
         a1FRugaeQQrZJEUsR4TO04k2kC4Ua1+GXY1UJbWUnlnDxVinKTqmt0ezSBDOMgnKU/JF
         LdKFGSr/SjOFXQUVfT7F475DEzLeVMFwOYCtgC5uxDE/n7RzaURnuncDY8VU6sy4I49A
         d5TnjY7Rd9MwD0fESQcGC8/R7ktIxBzYXJ7RkuAqOPBb2f5I3+exiBnw8OAnIzyiKjdD
         NUdg==
X-Gm-Message-State: AOAM5314RmU54Y+XHpuwudzl/krPPu1Ev/mgXMhDJZ2903xtXc96f5qk
        ZouJON0gZTx4taOnhF5ld3aiP6MhCNo=
X-Google-Smtp-Source: ABdhPJxKcSGGEz3z3HpVXG39usScfqfh0E3qC9jNpd8RFYh7iHg4ui73gLGnPVzDEZefu0zyizs/WQ==
X-Received: by 2002:a02:70c3:: with SMTP id f186mr12840306jac.155.1643686244904;
        Mon, 31 Jan 2022 19:30:44 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id n9sm20451756ilk.27.2022.01.31.19.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 19:30:44 -0800 (PST)
Message-ID: <c259be90-9aca-bf98-4553-7080c6ef1940@gmail.com>
Date:   Mon, 31 Jan 2022 20:30:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: allow SO_MARK with CAP_NET_RAW via cmsg
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, maze@google.com
References: <20220131233357.52964-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220131233357.52964-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 4:33 PM, Jakub Kicinski wrote:
> There's not reason SO_MARK would be allowed via setsockopt()
> and not via cmsg, let's keep the two consistent. See
> commit 079925cce1d0 ("net: allow SO_MARK with CAP_NET_RAW")
> for justification why NET_RAW -> SO_MARK is safe.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: maze@google.com
> ---
>  net/core/sock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


