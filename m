Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9663CC258
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfJDSMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:12:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45773 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbfJDSMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 14:12:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id y72so4333182pfb.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 11:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pdHMMpjel8RdnM2F9EJay3Hb/Al9qo9LoHLfxzvIKoE=;
        b=inXUd4wNquggiifhkn+Cj0FOZpRMvrFFRpP+lkZYHX3PyIaMfTIvmUgfWiXUR2U+Yf
         RHhWDHqUjsIjUsV3IjXU0/HazyVhE2FWrkaLRlkqXQp199PsF75x0s/frrRp3LNO4/YS
         BXgrKKAXbhi9i8XNyBP/imeY/sXNLjuS9Xgn/Y0xv/I9r1j9ZwQfdI1yibiJWmFS2rp8
         CL16aH4//HhaQdd981Wv/h8r7OA+2HUytgytKxqkSALM4LZk4RH0SX1C/c5wJCR4LBvt
         HrtgW541fEbYXL5WMP7kyLbCL4+ecp95BAXu+3ZTPuj7vaPDL8HNeKNgvEdcRTJyy+1Z
         6ZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdHMMpjel8RdnM2F9EJay3Hb/Al9qo9LoHLfxzvIKoE=;
        b=IOUT3TAr7CrILHrmi+TeE4hxMcL7E4JesayCGzpHnFmhvW9/DqdEtGDlEBz7XDAmfh
         WlFrHFK3ghtj3lrd90irJJur1TSagcR2bw1cXL9Eml1n5k4cIgHWyfOmOKvPrghH09rs
         1oO8qbS6u7++qz3H2liIk3TQOs4SMsyVcnSkyei1tsulYBeHGbMCkQwg5oTnrDVZ4Uza
         7syEqEIDBgdqcRCNNQTSkO14NhSN0N8OFzUXn+pRocfZvg4jYolFkkkmy7PyE+L7TarY
         oLxkLknY7nc4C8obyPgrjZPsgk1M+dIHUcHZGrxN2pqm3WYttfc7KqORy3OmLSQn7bud
         USEw==
X-Gm-Message-State: APjAAAX5YWnIYk3Z5P0NiwFQ3Dcu/dttHc4gCT3u0jsLjoEOOZIdqIyh
        Kqmf/mpQTMXbaUQkcmq7ceE=
X-Google-Smtp-Source: APXvYqzWFH8PlDVWHK4y0YrpOdGu5adUg4vuMqKdHsMcwL6VFU0rXiM2dsyWZ8E1dD352l2sgl++Mw==
X-Received: by 2002:a17:90a:3387:: with SMTP id n7mr17801977pjb.26.1570212732845;
        Fri, 04 Oct 2019 11:12:12 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id k5sm9471003pfp.109.2019.10.04.11.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 11:12:12 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Handle missing host route in __ipv6_ifa_notify
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        eric.dumazet@gmail.com, David Ahern <dsahern@gmail.com>
References: <20191004150309.4715-1-dsahern@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dfd4b59a-f0f0-21d8-7b94-a8985d724ae6@gmail.com>
Date:   Fri, 4 Oct 2019 11:12:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004150309.4715-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/19 8:03 AM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Rajendra reported a kernel panic when a link was taken down:
> 
>


> up. There is a race between addrcond_dad_work getting scheduled and
> taking the rtnl lock and a process taking the link down (under rtnl).
> The latter removes the host route from the inet6_addr as part of
> addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
> to use the host route in __ipv6_ifa_notify. If the down event removes
> the host route due to the race to the rtnl, then the BUG listed above
> occurs.
> 
> Since the DAD sequence can not be aborted, add a check for the missing
> host route in __ipv6_ifa_notify. The only way this should happen is due
> to the previously mentioned race. The host route is created when the
> address is added to an interface; it is only removed on a down event
> where the address is kept. Add a warning if the host route is missing
> AND the device is up; this is a situation that should never happen.
> 
> Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
> Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv6/addrconf.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>

This seems goot to me, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

