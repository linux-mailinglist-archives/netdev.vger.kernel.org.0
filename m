Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A63414F87
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhIVSCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbhIVSCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:02:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6FEC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:01:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 203so3346025pfy.13
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qzRlQTkWXIbHOVaqQQ1pimD7uO9pukpfdV8XJIfvW+8=;
        b=MPOSuVrlv2DkfTnLAjfqgzr0KdSi+5RAQ8AN8B6q8AYvTH29jJuPSInmkv9G5an2K+
         SefUrvOF5TTgNMDY+HkWm+cj2ZOo0Jnv4E+647lObAKQocs3gbuzRVStzdsTYLnUcDmv
         a1tgxSjbw7G5Ta7ANeyD+yU3TdyW0LSYCo/6wNfKUivfiQ1FeEYOpy/Lg3zdzHhQElpc
         YZ86VNPVWdCZV9gT+rAwFgkgehTkuOLu4KS3B47POdD+9Ed02gj82FxO3x1bLNmuAla7
         XHr5Ymtpx/aiNyXoz6VaN1zj9j1LcVIVFf199TfMrWxzsmL4WvXJFqOvksQxpsGDRqgg
         JuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qzRlQTkWXIbHOVaqQQ1pimD7uO9pukpfdV8XJIfvW+8=;
        b=lpqlVp1OGBQodSXYi1WbfrYw2vHC94Dsm933XvZUBgR9qhIkgX5FbbKAH/rc/EbeNO
         QfhHTq4wEjq8nW5aos1cdAgSxW2D/WO1ahkQOlrXp/ho196XltQHSJYyKH7+yohdcTr1
         zaHVkrXwPXTdwHiBiglfi6L+75fqYwN4SQm+FxXYkB1vZ5CusHPAagRMRX3B8tPDfaD7
         yXsH7sfettPX+yxbOj2m949pRSx8wPuHnZFoBbYGtddP06R7AJlo8EK6QrEAbx5WlBU0
         gjUra6TXfW061EFCJet5Wh7j8NS9Nu1NWAh/8huk6fRdogCySzes5AETff2OZ98qAMGo
         noSg==
X-Gm-Message-State: AOAM533MD7cbB7FYCSx81SRltwLzeCOL9C9J7xL1zHr2Mx2haLmKK2zL
        RNVUHpobPKKcQjW1Xa+y+v0=
X-Google-Smtp-Source: ABdhPJyhBIjK0YNDGDZm6Z7GkU9V+OhRU2RDQyz6bKkcGadr94hV+6EGlL9T3KNj0sPgo0TG5NllUw==
X-Received: by 2002:a63:f62:: with SMTP id 34mr164054pgp.159.1632333680419;
        Wed, 22 Sep 2021 11:01:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o20sm3113201pfd.188.2021.09.22.11.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:01:20 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] tcp: remove sk_{tr}x_skb_cache
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
References: <cover.1632318035.git.pabeni@redhat.com>
 <f14bcb96638a4bccc5763233153702be689749e1.1632318035.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c475a970-82ae-f4e0-a424-afe24c182f2d@gmail.com>
Date:   Wed, 22 Sep 2021 11:01:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f14bcb96638a4bccc5763233153702be689749e1.1632318035.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/21 10:26 AM, Paolo Abeni wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts the following patches :
> 
> - commit 2e05fcae83c4 ("tcp: fix compile error if !CONFIG_SYSCTL")
> - commit 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
> - commit 472c2e07eef0 ("tcp: add one skb cache for tx")
> - commit 8b27dae5a2e8 ("tcp: add one skb cache for rx")
> 
> Having a cache of one skb (in each direction) per TCP socket is fragile,
> since it can cause a significant increase of memory needs,
> and not good enough for high speed flows anyway where more than one skb
> is needed.
> 
> We want instead to add a generic infrastructure, with more flexible
> per-cpu caches, for alien NUMA nodes.
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Thanks Paolo for taking care of MPTCP bits.

