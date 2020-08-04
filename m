Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3F23BB7B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgHDNyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgHDNyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 09:54:38 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749C9C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 06:54:38 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id x6so1301831ooe.8
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 06:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SbFLau90VkmFykCWcM/p7pD/+rZRK0y6hRKnU2wBXXk=;
        b=HuHB3pxEdCwtAMXyLiqThHxQXZLYJqKO3G5RVETgtmXGLmYOCsAgK2BaKq6G2d764w
         p4q5qu0u2MrK8bsVKbXUKLF7ZZGy+zXreKOFI/mtBiYutrbZZ4jgM3Ytu5zFq+ANR5ed
         9Zww4IEqoUaCNDB73pk7ey7vvT4DiNXP70r3AFs41HHqHRJ02SSu8unIruUzuT69QckD
         ZP/K5FfZdsxDVkmiU1x7KAmJmTpTwElpCZIBxn8Skc1y0Aq/1MEv4siShghhOQIJN4yr
         MFhjklU5jCkrwbQOGf8gGjHgKkdDCkPVxl93HLgY4unpNq88G0SPEwq4R0hpyhiLwMA3
         4Jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SbFLau90VkmFykCWcM/p7pD/+rZRK0y6hRKnU2wBXXk=;
        b=T0k+/mlJrmdb3G/UpMkWr3r3rGE79CKwROj7JTdwQCjUOzHuft3W87zbo8aKokAnEl
         GLk9XxhqfSnrr/58TYFHkZ9dFLDztAWobENMocyrEAMwRFKUuxC2ZP7N/f0KmBCPgJg2
         qIUojM7mm8/1mv20xt9ww/77FqIKWGsXSMx5arwqChy655dka4cun2wvsMz992iEmN0i
         wpXy3/sR0ovhhUukjDEPembdg9eKR1u56sACxrEgl0WtZ+hkI6DGnQd8Cv6YGPyfS8m5
         5GN38weIO3tuG0/O8yZfUp2ylUwlfvtbwr/CtqmZg09kaxm23LwvYJ2BJpY8rUh7rWU6
         T0zw==
X-Gm-Message-State: AOAM533rDRMcZbnmjePK6HT3h3T52Ag8AogUFMI3bFBAOxdxO75FlLCh
        xW5U2p9/fg8f8uyW4A0lNhZbSajt
X-Google-Smtp-Source: ABdhPJy5VBMttANJqc60TNXab4/2yE6xcIQCldaF8IZAjt0qiTMWEDFu6CsCPmROlLVhu8c5E2ID7g==
X-Received: by 2002:a4a:e70a:: with SMTP id y10mr11749237oou.44.1596549277540;
        Tue, 04 Aug 2020 06:54:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:14ac:dc81:c028:3eca])
        by smtp.googlemail.com with ESMTPSA id t21sm1080186ooc.43.2020.08.04.06.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 06:54:37 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/6] ipv4: route: Ignore output interface in
 FIB lookup for PMTU route
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596520062.git.sbrivio@redhat.com>
 <ec94f1f590e6cb57d128ce10e4306e589544944d.1596520062.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <702d24b9-0186-15bb-b6dc-c4ec5118d446@gmail.com>
Date:   Tue, 4 Aug 2020 07:54:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ec94f1f590e6cb57d128ce10e4306e589544944d.1596520062.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:53 PM, Stefano Brivio wrote:
> Currently, processes sending traffic to a local bridge with an
> encapsulation device as a port don't get ICMP errors if they exceed
> the PMTU of the encapsulated link.
> 
> David Ahern suggested this as a hack, but it actually looks like
> the correct solution: when we update the PMTU for a given destination
> by means of updating or creating a route exception, the encapsulation
> might trigger this because of PMTU discovery happening either on the
> encapsulation device itself, or its lower layer. This happens on
> bridged encapsulations only.
> 
> The output interface shouldn't matter, because we already have a
> valid destination. Drop the output interface restriction from the
> associated route lookup.
> 
> For UDP tunnels, we will now have a route exception created for the
> encapsulation itself, with a MTU value reflecting its headroom, which
> allows a bridge forwarding IP packets originated locally to deliver
> errors back to the sending socket.
> 
> The behaviour is now consistent with IPv6 and verified with selftests
> pmtu_ipv{4,6}_br_{geneve,vxlan}{4,6}_exception introduced later in
> this series.
> 
> v2:
> - reset output interface only for bridge ports (David Ahern)
> - add and use netif_is_any_bridge_port() helper (David Ahern)
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  include/linux/netdevice.h | 5 +++++
>  net/ipv4/route.c          | 5 +++++
>  2 files changed, 10 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


