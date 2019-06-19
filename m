Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87304C138
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfFSTKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:10:15 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39894 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFSTKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:10:15 -0400
Received: by mail-io1-f65.google.com with SMTP id r185so1057592iod.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fAmFLnSMsnvQLlq+D5qRp2YHlP+Qbfata1Y9h/i5BuA=;
        b=TXs1tmCnobLiqUFg36C+kFsdaC1ZC8JzxgVgAwagcYU1oGFoRCqSmuGSdEvvtuCFTK
         iNv0R1b4X0h/QFEukcWO5c7LmdphgOOFVoAaU9xp8+SyohOTIS8P6XoOJfwRFZ7sR72B
         lnvroQ4u7Na0ugWh+qAMVG3xYn7lrBL2FoMr0vzeDHv1OEdpvwUW51O++DTPxZK+ebar
         MhNhF5NmsPHqvhUvzUgbGyJFXaz73Z/OwSIin4BXKx6oLQiT/4RXQ+b/hAxVVrk5SBAU
         Th0UVHNnMtVmzfoQxeGnBdeIPJbrJvetGYjzu/p7ui1oC29Gd5x72YNSi+qsjvbzfelv
         BnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fAmFLnSMsnvQLlq+D5qRp2YHlP+Qbfata1Y9h/i5BuA=;
        b=LCOXv+eTCyasYLpvSlWKDo+milanQz0EWZxKSimVucMnnlHi/pN9w0HtoHKm/CY2Mm
         uXNN4FBGyrU4h9jh89PYXKDrHfgOFYKdCGcg0N78f2yDKDjdXeSsGAKe+1a6Dfr6yoYh
         jQTEDS+ubgkwRAeAHMcPXRhutLn/XVDN6CgevMGdllBi+oA2bhWlzzOWV8yHbpQOsWy5
         S0cj6xU0swmiWSgQuRRJs2Tstvy+pOmnV/ebDebwApBwJxsIb2spW115R6Af1IYgNHCs
         CQBSoOL1TWe2W0rmceIC9iHUsC1KuSI/CaOPeYPw8NflleQ15thPEq8Q92pepuu5V66I
         Gf7A==
X-Gm-Message-State: APjAAAXOYcyotPLsV6zz1bXCaHSzpF0m6yV2TRgEOX1eMNBE2bzgDhyf
        ZQvH3el/4NV5TD8G1MXRS+Sk2Jq4
X-Google-Smtp-Source: APXvYqzUWXJP2l2pmmmc/JeY+nK3WaJUt7BzMa/R8fONFFSAuAlWCGxe0IbuEQ3Rm+8X+dBmwrXglg==
X-Received: by 2002:a5d:9f4a:: with SMTP id u10mr13346544iot.243.1560971414960;
        Wed, 19 Jun 2019 12:10:14 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30? ([2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30])
        by smtp.googlemail.com with ESMTPSA id r139sm25468548iod.61.2019.06.19.12.10.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 12:10:13 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Check if route exists before notifying it
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190619175500.7145-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <69f3262d-e6d0-943e-20a0-c711be4d35d7@gmail.com>
Date:   Wed, 19 Jun 2019 13:10:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190619175500.7145-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 11:55 AM, Ido Schimmel wrote:
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 1d16a01eccf5..241a0e9a07c3 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -393,6 +393,8 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
>  		.nsiblings = nsiblings,
>  	};
>  
> +	if (!rt)
> +		return -EINVAL;
>  	rt->fib6_table->fib_seq++;
>  	return call_fib6_notifiers(net, event_type, &info.info);
>  }

The call to call_fib6_multipath_entry_notifiers in
ip6_route_multipath_add happens without rt_notif set because the MPATH
spec is empty? It seems like that check should be done in
ip6_route_multipath_add rather than call_fib6_multipath_entry_notifiers
with an extack saying the reason for the failure.

My expectation for call_fib6_multipath_entry_notifiers is any errors are
only for offload handlers. (And we need to get extack added to that for
relaying reasons.)
