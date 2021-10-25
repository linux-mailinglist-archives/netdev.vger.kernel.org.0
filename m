Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24270439874
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhJYO1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhJYO1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:27:43 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF213C061745;
        Mon, 25 Oct 2021 07:25:20 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so15116371otq.12;
        Mon, 25 Oct 2021 07:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vRgEtGzx40O4TbRtcI16IlOxhOcPfXzwzL+EHMundGg=;
        b=Nz6RWqNXMNwO+SwtV0thnT7K6GWVqzI15UgZZkH1VPiXzovZwWyJz/010w1mdPXk20
         KAHk4nz1nhK+6iA8tyUhV8LU8xIFX0O/QET8lP8XaQn45ohlKGhSEOCKZdnh4gwGf6n/
         4bE8isPZmwESDzNUqS/96yMW6hQ1qLBmNYYVL9o6se7uAPfZs20m8c4nw7QgsXvCmcPN
         HadoJbPtA2/kk1EkxppVKxG6jbfjVB53Da1rS/0Fcp7QtdA8k0TxIWcc69kUAJ4yFWXD
         tMaGgwRf0f2yFGzqe7D9B9LGDZwRuKu23Jq8+RD5P8ApsUq6RKgH8XPZCNly+B0wOese
         yvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vRgEtGzx40O4TbRtcI16IlOxhOcPfXzwzL+EHMundGg=;
        b=WMNTGKyPOXF/WGjd++vYtiWQzK9n784zpXkT4dieisrOhvqw6T7d2/Ib+ZQ+HyzF+N
         KneFqTQEe4E55JaJ1WTqB515r0Ac9FXBlHE3hOoeOnfwQhdXvJooOAENkKJKRsJWgRcZ
         p/8kjkDHXwQrfIO8E8Cqqf7zjP/ERDi+hPZMTRc3Gu/yx7pBMw7543v4UPty7w8+8pQD
         Jy/q1VPJDyKlhkbACWkTjCWqn5N56nfy3P6ZV7HmKKM9m35NFtl0iIqHw21hgLxL9ia3
         6j7O8OomkVYgLX+LxUArEga86I9z8doKPWO2u7Sna+3gc1mnRpjnyMPoxeCdWUtXZf6s
         VFnw==
X-Gm-Message-State: AOAM531AlSbl9h0a61aJTJJb5kpxCxSZDoMGp5DjyJUbdsAhFJ55fd6m
        ydyw6PIXNBpbMFFgDNsPtHUk0UnWnqM=
X-Google-Smtp-Source: ABdhPJzeBmBtRAxTseSNCuoNQj+oH6JXIR5QoD+GZIiR7UBFxZj4FWLBf6E+dGOOaOBJarQnaF3nSQ==
X-Received: by 2002:a9d:6d03:: with SMTP id o3mr14582738otp.87.1635171920292;
        Mon, 25 Oct 2021 07:25:20 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l2sm3606526otl.61.2021.10.25.07.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:25:20 -0700 (PDT)
Message-ID: <b148c973-c4e9-e4ea-6045-2111f00eaa79@gmail.com>
Date:   Mon, 25 Oct 2021 08:25:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v2 net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, lschlesinger@drivenets.com,
        dsahern@kernel.org, pablo@netfilter.org, crosser@average.org
References: <20211025141400.13698-1-fw@strlen.de>
 <20211025141400.13698-3-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211025141400.13698-3-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 8:14 AM, Florian Westphal wrote:
> The VRF driver invokes netfilter for output+postrouting hooks so that users
> can create rules that check for 'oif $vrf' rather than lower device name.
> 
> This is a problem when NAT rules are configured.
> 
> To avoid any conntrack involvement in round 1, tag skbs as 'untracked'
> to prevent conntrack from picking them up.
> 
> This gets cleared before the packet gets handed to the ip stack so
> conntrack will be active on the second iteration.
> 
> One remaining issue is that a rule like
> 
>   output ... oif $vrfname notrack
> 
> won't propagate to the second round because we can't tell
> 'notrack set via ruleset' and 'notrack set by vrf driver' apart.
> However, this isn't a regression: the 'notrack' removal happens
> instead of unconditional nf_reset_ct().
> I'd also like to avoid leaking more vrf specific conditionals into the
> netfilter infra.
> 
> For ingress, conntrack has already been done before the packet makes it
> to the vrf driver, with this patch egress does connection tracking with
> lower/physical device as well.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  drivers/net/vrf.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 

Acked-by: David Ahern <dsahern@kernel.org>


