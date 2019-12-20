Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32885128069
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLTQOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:14:12 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:39933 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTQOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:14:12 -0500
Received: by mail-il1-f170.google.com with SMTP id x5so8394611ila.6
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 08:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KWjKfPyGMU352QfI30All8tFlThagt63W9WPDwacWcw=;
        b=MJiYmo4HfVwnRvwic1DQmXng4mN5pC0UlcEtYbXok9MzsCQeLkPBp02l8RUn4xlh8X
         4iPslTgrgGIPrtlUzw70a8P4jl4f4WXAAJAMNLfckmiOgM1Oe3YpvA6uCeBD7e10xfPK
         TSdUHHlsDpo5TfRbNmKaw8b4pWoCkdSR24Z9N2Hw16nhxg+N4cSODHM6lBRf/Tw5GiBM
         CciHmYf4K5XfBFlEEqrJs0p2OG3U5IQbatRE4dnk5R8teyim6iJ2C3TZ9b9Pt/YQw6yo
         vM3cahEpjEDE9aiYwUHNPEkdXDkJ5RTjX27QyZ7Wb7GWIO0M4E0NoQUmTjYewgZRy4J6
         5O+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KWjKfPyGMU352QfI30All8tFlThagt63W9WPDwacWcw=;
        b=j7YrEgrww8Nf6o899IWfaxJDYXsBgFCAbsufI2KNESbrzHArz0NhV88R8vNotb5SZy
         Zy26cl/RnOIiPWZYxtEQG4nZbNd2O+zFMVxB/VROSDgOfzeFZv5p+i1ryDU7JE4j3crq
         pojEuudHLLZZT85ozxulvR348RkgiI0WPCx6EcdjB4oM97Cjyq0uY/HKadn/ABHnJNSg
         jUPaGpTvCqnCE0YRvDgRs460lnY+8hJLcrGhktmV0I6qKpRmO8ZF/0mrUDJWXrxYhQkK
         +FT2l3IFlHGm6jb19Yo5UOv95FHNqK3YbSoXm3UdycOnpKLlFnF7yv6+hLu6hihMsn5p
         xibA==
X-Gm-Message-State: APjAAAWwZZzUIY33fg+0uGI8ojGdtLggGZegd++n5VvPweVtpSnm7KXH
        YGkGM81VXHHzoSPsW5hAwdg=
X-Google-Smtp-Source: APXvYqz81elKkzYFXp0R5XOrB9k1iLpOodE6sOXdArMzs0HeSdFbRP51Bc9jv2mcrOo1xzPT07tn+Q==
X-Received: by 2002:a92:3996:: with SMTP id h22mr12647694ilf.129.1576858451233;
        Fri, 20 Dec 2019 08:14:11 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:d462:ea64:486f:4002? ([2601:282:800:fd80:d462:ea64:486f:4002])
        by smtp.googlemail.com with ESMTPSA id c1sm3456029ioi.50.2019.12.20.08.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 08:14:10 -0800 (PST)
Subject: Re: [PATCHv4 net 0/8] disable neigh update for tunnels during pmtu
 update
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2e9e485e-c400-3463-9095-013c5ae1df85@gmail.com>
Date:   Fri, 20 Dec 2019 09:14:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191220032525.26909-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 8:25 PM, Hangbin Liu wrote:
> When we setup a pair of gretap, ping each other and create neighbour cache.
> Then delete and recreate one side. We will never be able to ping6 to the new
> created gretap.
> 
> The reason is when we ping6 remote via gretap, we will call like
> 
> gre_tap_xmit()
>  - ip_tunnel_xmit()
>    - tnl_update_pmtu()
>      - skb_dst_update_pmtu()
>        - ip6_rt_update_pmtu()
>          - __ip6_rt_update_pmtu()
>            - dst_confirm_neigh()
>              - ip6_confirm_neigh()
>                - __ipv6_confirm_neigh()
>                  - n->confirmed = now
> 
> As the confirmed time updated, in neigh_timer_handler() the check for
> NUD_DELAY confirm time will pass and the neigh state will back to
> NUD_REACHABLE. So the old/wrong mac address will be used again.
> 
> If we do not update the confirmed time, the neigh state will go to
> neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
> neigh later, which is what IPv4 does.
> 
> We couldn't remove the ip6_confirm_neigh() directly as we still need it
> for TCP flows. To fix it, we have to pass a bool parameter to
> dst_ops.update_pmtu() and only disable neighbor update for tunnels.
> 

seems reasonable to me.

Acked-by: David Ahern <dsahern@gmail.com>


