Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3303FD832
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbhIAKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:53:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236140AbhIAKxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630493529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lm4mR3JYlL5ip2He+sEf0zphXUTsvwT6BkT7jCH1eyc=;
        b=ZGVYoHmBsTYdlDbrUdJjEQNfL0+FMnTEaJ/rUTjrxrO5he+3J/tfaDsKwJXSqaq/hsLIj6
        AvzohNT1vQEcbN0GWEec/AQl2EAVuFa+LT5lE1cSo0tXXuZIjC12DqEWq61stgTxqbHMrh
        bo+7HBtr9ip712BjNkDxcv9I3QoVgL8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-StD2ON3UPvmQKzPmbsHymQ-1; Wed, 01 Sep 2021 06:52:08 -0400
X-MC-Unique: StD2ON3UPvmQKzPmbsHymQ-1
Received: by mail-wr1-f70.google.com with SMTP id z16-20020adfdf90000000b00159083b5966so634860wrl.23
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lm4mR3JYlL5ip2He+sEf0zphXUTsvwT6BkT7jCH1eyc=;
        b=H2cKFijuKj2kUkD8qOSXuSdqyJapBHxYgFYYS6JzmikfeOiVmfooDmrD68Rm0hHnV3
         P1QfGm4+/R2qAQqT2rRGA//VcQtZiJOHfO0eXiGXIko6kCVU9D8a20HunNxE+OUZpIbb
         kvBWfi8FbNbvlyDR1xtC8Vx2TS+gBy2Y1E41GqeNpgDlDhI+etx4I81rU/fLYmoUdS2N
         +VLLv7vhznDMYl/jnJ/1fNgwdGkfOUUmGjwY1pGcN4Wih6nYbnLaNsGWjJv8R85v22Yg
         f884xvWHn3ME7pXAdOHga+ZVTBDtoKK3n61Zi7EL7odb9eLwlDJrMa/s6n2FzCfPo5gp
         a3ng==
X-Gm-Message-State: AOAM532Ta2qp/X6jOBa4+crYQQ0oSz/ThP30Do1yZ7R3IATLAsBdYgUU
        xjapApovbBLurFHgH5QvErDQ62e74OUhgdp/n/dHQ3F7rRi93M/1uFLf1Jw0/Qk4RG96HRzP0tQ
        NiWH3ai3ocf9m+Uz/
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr35464984wrw.415.1630493526918;
        Wed, 01 Sep 2021 03:52:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyAY00ddiyzLDaqJY4HYxreDLtYrqdI7O3mR8VxvpDttJ01uAFBJixyKRBDKpoz3ljAanyXg==
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr35464967wrw.415.1630493526747;
        Wed, 01 Sep 2021 03:52:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-233-185.dyn.eolo.it. [146.241.233.185])
        by smtp.gmail.com with ESMTPSA id a10sm4932882wmj.44.2021.09.01.03.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:52:06 -0700 (PDT)
Message-ID: <9c9ef2228dfcb950b5c75382bd421c6169e547a0.camel@redhat.com>
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in
 sk_stream_alloc_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, MPTCP Upstream <mptcp@lists.linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Date:   Wed, 01 Sep 2021 12:52:05 +0200
In-Reply-To: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-01 at 18:39 +0800, Yunsheng Lin wrote:
> Since tcp_tx_skb_cache is disabled by default in:
> commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
> 
> Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
> avoid possible branch-misses.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Note that MPTCP is currently exploiting sk->sk_tx_skb_cache. If we get
this patch goes in as-is, it will break mptcp.

One possible solution would be to let mptcp usage enable sk-
>sk_tx_skb_cache, but that has relevant side effects on plain TCP. 

Another options would be re-work once again the mptcp xmit path to
avoid using sk->sk_tx_skb_cache.

Cheers,

Paolo



