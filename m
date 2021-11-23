Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3B459AB1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 04:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhKWDtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhKWDtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:49:51 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3988BC061574;
        Mon, 22 Nov 2021 19:46:44 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so978390pjb.5;
        Mon, 22 Nov 2021 19:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+1AZgKtbKfEWeKQ1prqv10vReizsTb02DH4HZ4EEh+Y=;
        b=bCwvvGWOC2LYOiJoFjAmsyjukIBPwhybxUnK+kzi3cSgIQLu182p/J690Dwri7JFs8
         U9DB6cu2x7DRMasTAbl5mf+QJXM0GssOgmIe83QQDUqw64wBtn18ZEu05hseGSZLNAAa
         CFNswmGd40iCp6L1SdNRKkgWGs/dJr6DpfYkjQa+vhkewP3GPEzWB/P+B20PjJNDTkOd
         ytxTHFqkJzCPthxpDSwcXUvPCteJ0Yq0/mOvdkJb4gDS3tTe8iXxJJlJLYaOZfWYxbPp
         O+H/7q3SOTwknVBq+kqa3EcUdlyaLkbbfEVvVPHcvvSnqfMv+fiRZ9iGtPII1X03y57D
         N+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+1AZgKtbKfEWeKQ1prqv10vReizsTb02DH4HZ4EEh+Y=;
        b=jKI0hrsYxWtdUZpNOEuqHGmallHWP+rtFGTr5Lauet2UuShziB9eZMIZHbXCc9ZNCY
         SCLblafYesPd8h26e6r4yO4uiNybB5a92GRUBh8ZWphzTWm66tVayM3N7WmuFXtx9fvW
         dAURFavDgb6ACyrnwAkigyE7NqqvZAKIdz/PjiXKUIJjQlZ5oYyq+q+5eyfN9cJtjGps
         7/3o33Rz6YWHKe+uogvHMCNQZTlI2yj+iq/CQtaKkQYS6WDdknQe98undvRfGe5/QY17
         CXT5y4RoTiPfMBFOmkPeQ81os/q0cHZxracgTnJi5mqMEI6XzyugHpuek6MpKS6kBEjZ
         9kJA==
X-Gm-Message-State: AOAM5331l0tc1WntcNnyMzpOfbH/3/+mGML3aN0Vci0ivHmYQP9KKW+h
        knbgPN/ePI0WzIW7tLp5EmOTrpuhWC4=
X-Google-Smtp-Source: ABdhPJwGcP0Ul/yd9l1lG/6cg89sxC6c3h4qHXbv6OWRNAJzo7RHsHRdDtgSJE2q0EOyLF/O1y/3mQ==
X-Received: by 2002:a17:903:2352:b0:142:76bc:de3b with SMTP id c18-20020a170903235200b0014276bcde3bmr3261583plh.36.1637639203639;
        Mon, 22 Nov 2021 19:46:43 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c3sm10827036pfv.67.2021.11.22.19.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 19:46:43 -0800 (PST)
Subject: Re: [PATCH net-next v2] neigh: introduce neigh_confirm() helper
 function
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     eric.dumazet@gmail.com, dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211123025430.22254-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bb4cfd2d-e2e8-3a1c-9e39-2d4a68737129@gmail.com>
Date:   Mon, 22 Nov 2021 19:46:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123025430.22254-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/21 6:54 PM, Yajun Deng wrote:
> Add neigh_confirm() for the confirmed member in struct neighbour,
> it can be called as an independent unit by other functions.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>

This seems good to me, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

