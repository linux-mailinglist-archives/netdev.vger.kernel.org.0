Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323012537C4
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHZTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHZTCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:02:05 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBEAC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:02:05 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s2so3285149ioo.2
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XnVCITvuyRZGEPvUfOPw9wTtaM7rO+zmAxjzhI58uRM=;
        b=nPOgqIsXsQCzFg31duu3FoxvR4udgNF9iHsEjzBi77DrlkKKHgwPXYaws/y6z0As1K
         WAaddRh8cQTo+NOt+W8mz1KgN/EE2wB2IOLzLrRaHoNCtLGx4gse5EairzBeelMrHKBV
         5/hdbL9uS9VnH2C1gTG23c7+zRmam7pFLMZzwGuKi/LlAUj+Pusfk8gXWZTZ3Z6vLrHV
         /aMaz5/ZXhPbrfX8Ut2aF91mDCy0VkfFPJOctuJ9wXQZOfIx6JHWvgsDFfTfr7EEA97e
         24J6WY6XgZeiDoRhLB7a+H75jvTBaDomYIICJa9BlVRzjHzdS0puTKqNiIOXl+DZlrwJ
         Ingw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnVCITvuyRZGEPvUfOPw9wTtaM7rO+zmAxjzhI58uRM=;
        b=MFtRyyMtwI4+zja/F08zSJ2Y1SWw9odlU44TVxEY4EDfrimxSOZoBIQE0To0nq0Qom
         KIHTAHvA2RcxC83H/CVjp0S83N8yoDy/vfGIwDrFX1iKbI23l1FspxFPfU63X0EQU0d4
         SeVtQ0jhIrE1MzXZzrGrT80NH4G02EnwxWuTHYuu6SJXAccwcGdi+tZobNsGb1XZZJJJ
         KE3z00L1Z4PqMPgfooIwDxY2pxQQB1UytMqXfxauh/cx3Dzzqvvpy3Tqbli7c2zF5jRZ
         1R0q3XMPYIVjBiSZGeM8okyQ2HSjjZi3cUeByKaYPN6RVNWI72KIrhIiccY/aftg7/Kd
         Kw3Q==
X-Gm-Message-State: AOAM533SRzkLJtyqf2IPbm9a2pYec/ogV7bx+UXyyj17khpps3TzktEW
        QA8Ilrp9x9pkqcqdpemMIVw=
X-Google-Smtp-Source: ABdhPJzI38Oukb0HFKpA4bU+TnhNxi0YO7iljD7t2J2yEMuirum/D8wTE+tt/3jjVthbI7uGfGwnAQ==
X-Received: by 2002:a5d:9943:: with SMTP id v3mr13707750ios.51.1598468524903;
        Wed, 26 Aug 2020 12:02:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id v6sm1911624ila.57.2020.08.26.12.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:02:04 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Silence suspicious RCU usage warning
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164810.1029595-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e2e8e329-0d3b-a910-5c40-d63600b6ba14@gmail.com>
Date:   Wed, 26 Aug 2020 13:02:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164810.1029595-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> fib_info_notify_update() is always called with RTNL held, but not from
> an RCU read-side critical section. This leads to the following warning
> [1] when the FIB table list is traversed with
> hlist_for_each_entry_rcu(), but without a proper lockdep expression.
> 
> Since modification of the list is protected by RTNL, silence the warning
> by adding a lockdep expression which verifies RTNL is held.
> 

...

> 
> Fixes: 1bff1a0c9bbd ("ipv4: Add function to send route updates")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_trie.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Thanks, Ido.

Reviewed-by: David Ahern <dsahern@gmail.com>


