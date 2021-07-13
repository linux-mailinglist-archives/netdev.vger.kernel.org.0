Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67BD3C7279
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbhGMOn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhGMOnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:43:55 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C4C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 07:41:05 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i94so30793303wri.4
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 07:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vkpkGpMl8fEe0v/aoiqVm+2ENuKxaGa56iiN/bP3PDk=;
        b=MC7bwdSsfL8CXUsGK1oeRGUBaoeJ4emfINUPrEHHNGudtTb5PlI0+F19liw5szK3qJ
         lqESYpWQPfu5hmACwqklMfLrQZoJTsgkrIBweMw71TquH6r3XQzKnLFAZEzZU2UkQX1Z
         83wsFFd9oEuwuCdp9HX9PXxp3Mpb0N2qU1mDXcBIt3rsZ489M3Rb2QHGo+ZrRQ/uIWxE
         /kcgg4XLfBmBfqQZuXeB93OCm/LGd51B41yhJZRiqf7YRxwhNSJoU1JvcqaxjsLgTnub
         kZc+pgAXgDtDM/lY0iQPCPWbaQGVUKjl7eOTwwlcTXrlW3pNZt3tArwrOTvEkRJlGo01
         Acvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkpkGpMl8fEe0v/aoiqVm+2ENuKxaGa56iiN/bP3PDk=;
        b=ET37togZ2Gw1sTNk7Svu6gZi9aqMZdYtsbvZyycG2AsNWxJpfOXPHt0sXXwaLtltsM
         J4gkx/Sqdl5TvKndRnfhki/tYhBTdBdd71MzKpgufl52GogRt5QzNLpc4NyAx6deZqn8
         pu1wBsQIbnk4+I1HmxPb8EPFS1cSqShFo1x5CGI7Y0kRRvbRUxeTICJttexh6D8ZUvwg
         LQHh4G36bIYNUN4kTOg3RwnZA2yoOZkIelJJnBOkh3voas0wcECEpLsjileRZks1EhLB
         9v22FN+mRE2Fe7S+xe1++O+OmUnlDjiPgMIFVQaeKtjGvHBUbxNKwMI9lAh0Tqy5jbv5
         svfA==
X-Gm-Message-State: AOAM530nVsyLz5I0bxNqn3kNlq2seHFO9XXStTWAaXSjH4ebvmsXv5py
        5WBbZM29Yz6JK33kKEEHnot+vAX8theupA==
X-Google-Smtp-Source: ABdhPJzLzicN9G+GXprz12KLZQZSF+FlXISwv6fOvOI/iD0Eny7BBh4l6psS7g9wPrTGEewctuIxGQ==
X-Received: by 2002:adf:e0c4:: with SMTP id m4mr1849647wri.312.1626187264080;
        Tue, 13 Jul 2021 07:41:04 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id y3sm16729311wrh.16.2021.07.13.07.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 07:41:03 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] Fix lack of XDP TX queues
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <20210713142129.17077-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <88f91273-b498-2beb-d6a2-bf1b6b6d8472@gmail.com>
Date:   Tue, 13 Jul 2021 15:41:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210713142129.17077-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/07/2021 15:21, Íñigo Huguet wrote:
> A change introduced in commit e26ca4b53582 ("sfc: reduce the number of
> requested xdp ev queues") created a bug in XDP_TX and XDP_REDIRECT
> because it unintentionally reduced the number of XDP TX queues, letting
> not enough queues to have one per CPU, which leaded to errors if XDP
> TX/REDIRECT was done from a high numbered CPU.
> 
> This patchs make the following changes:
> - Fix the bug mentioned above
> - Revert commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with
>   the real number of initialized queues") which intended to fix a related
>   problem, created by mentioned bug, but it's no longer necessary
> - Add a new error log message if there are not enough resources to make
>   XDP_TX/REDIRECT work
> 
> V1 -> V2: keep the calculation of how many tx queues can handle a single
> event queue, but apply the "max. tx queues per channel" upper limit.
> V2 -> V3: WARN_ON if the number of initialized XDP TXQs differs from the
> expected.
> 
> Íñigo Huguet (3):
>   sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
>   sfc: ensure correct number of XDP queues
>   sfc: add logs explaining XDP_TX/REDIRECT is not available
> 
>  drivers/net/ethernet/sfc/efx_channels.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 

For the series:
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
