Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3423A904
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHCO6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHCO6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:58:50 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B6BC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 07:58:50 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 77so3065141qkm.5
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 07:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lAyP55RHF0VLvvH4hNQzlLv965GPkKI9hN+PsbFzt0Q=;
        b=ZsSPsijiFUrjIu4vexkTJ4SmX6+5mV41eAhK0oJjUijaCBdKaovqfCwtCi3R9TwJDe
         uX0NlasWOfaPW/8HOVALVixU+qWPNUzwhjcDTHcmhTZK/JecQF5ROoVjmJggP1cGdDRr
         cSgPJQE1E0hFA9De2Hs8Ne9xlXQkfHeHekPzNjtgEO0hZqY7kOiCox8LuiIS33Po9x1a
         gB6ZyOQAgpfda5RSWl4bZmxj689spjNbAubx4DWedxJuRAz4eIDZMWaFDI0IFAYy+pLq
         DmZjPL+xjqPlAq1vtlAW++Xtcwn9gFZIZvNTqH6JEvAEB0dTAbR+3HePxCjOx6e4nZKR
         doPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lAyP55RHF0VLvvH4hNQzlLv965GPkKI9hN+PsbFzt0Q=;
        b=j8LRAGQx1yefzFHTUFsWvTXVSJbX56CVBxu1jFlsajmJ/pEVDi0uhTP/A3vR+n1fS2
         1qerzeQcmIX4SK4ZBKJHqh+JH+8gPO8W2TC/9wpADAtjljx0z/PorbLe8cnQOBBvsIMa
         LPoArV97ojuJ4VRlHDPRH0SymZOjMjqEzezXAtZUFwk2AvqQoUFcma5Wvjg+GoV4sakp
         XPdjgkQ//soPd6oFPj0Sq1FavbiCZqZddAN7ldu2dHejx9y+TKfjIYsZDowesHH6QhQm
         iTk+hapDflRoGa8bDVu7IQdw1sdEoRSeuzeK4bQYp1YOMznwer+2vUlP1p58WD6++BlJ
         GoyA==
X-Gm-Message-State: AOAM531HbMlexx/GfICAXpYS8Qm6kilVY/B50c9BbNKrirK6CBtT3Smk
        LLbB1FzQk/d9Fmak0mg4XX8b6zup
X-Google-Smtp-Source: ABdhPJx9n+YYPoA+IFZWZzJi9Q1DJOAFMhM1vDNf/3aFlfRfJFwXe4YyqYn6Dj5tB+euvIUlBWEWbg==
X-Received: by 2002:a37:62cc:: with SMTP id w195mr17181202qkb.33.1596466729491;
        Mon, 03 Aug 2020 07:58:49 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id a6sm20368104qka.5.2020.08.03.07.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 07:58:48 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip-xfrm: add support for oseq-may-wrap
 extra flag
To:     =?UTF-8?Q?Petr_Van=c4=9bk?= <pv@excello.cz>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
References: <20200731071259.GA3192@atlantis>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b02dc24a-beb6-f333-7bdf-2339a3a58bb1@gmail.com>
Date:   Mon, 3 Aug 2020 08:58:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200731071259.GA3192@atlantis>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 1:12 AM, Petr Vaněk wrote:
> This flag allows to create SA where sequence number can cycle in
> outbound packets if set.
> 
> Signed-off-by: Petr Vaněk <pv@excello.cz>
> ---
>  include/uapi/linux/xfrm.h | 1 +
>  ip/ipxfrm.c               | 3 +++
>  ip/xfrm_state.c           | 4 +++-
>  man/man8/ip-xfrm.8        | 2 +-
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 

applied to iproute2-next

