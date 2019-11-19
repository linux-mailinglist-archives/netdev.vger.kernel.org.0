Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C320110283E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfKSPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:39:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36827 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbfKSPjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:39:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so12363988pfd.3
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iCPyTdpy3mrTKl/PDrg5SrSr8N3q/XMSyCR1P6wNd/E=;
        b=fsh6qKmHhbqBykttv7VyH+P89m3jgHHSZEdlki036pc/i7eiS2tyyeJASQVR2g0A9+
         j8GVe4JPw5FfM+/FAxsjAm/zby4moCjvUiZp7YSU+4FooIgxQhDquNKHZ8kyJLbacIUM
         llrL59ssJ8KZXU+v2Tkuh9h1dNMDc5uhP52osiawpCBBdE7Tbf661Vi7dXeeqvHmah5X
         iRqA58YF26SZwa1UZ0NOqv7g1lb1InZ/G613GzBBpXXhKG/jDfrN7JxDb5aG2kYOhR2c
         Z4sbu3/8SKq89OqayUQfAiZuTahXAxcMyiy8zYA+2rFQBpkUwqIvZImup9LRHFGXxRtL
         PnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iCPyTdpy3mrTKl/PDrg5SrSr8N3q/XMSyCR1P6wNd/E=;
        b=DKqfSy4DGwoqWIciDoLKdzBziQKQ/bAZ633D4x7XTdzdV+riNSZf4h+o46Tc9lMDuZ
         lVS4+uNe96Aj1mtLZu7OArJuudVG2SonXBTpcGJxPoBc+WsyGjjLsPvyZaiEUJ829XST
         t+D6TzUZI6p1KtzFi8qFdApCkCZIwi/H1ImfPHYjADTLjpj0pEqjMRfkljWnGoWV4c0w
         5YvXPmM3xLG9fPiUf8VPKKXuFoSFzbuOmam6Ccq0MoWIp4K0we1sOiaDcViw5TmLDFRS
         +/T3jqNs3RWy3XWYH5WmIvXQpaTTlUuY41yNhDFM5PNV8rfoeZMBQcZB2L86u3TFHIUr
         LTXg==
X-Gm-Message-State: APjAAAULC1LrR/pKjmGcP0B8SvSQD0G7M+pjBJBFkLbay4j9VpDSvlTD
        75ROfRWJwtRIH2tXdqf1xRo=
X-Google-Smtp-Source: APXvYqyN6x5LGg/Q8mBLJTu2ZlR8oFaFES8CDeEwB3hlowK/eSxVGLIn9E7nzceM+lfHLUOPoYIvhA==
X-Received: by 2002:a63:d854:: with SMTP id k20mr318985pgj.305.1574177942420;
        Tue, 19 Nov 2019 07:39:02 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id a28sm27409445pfg.51.2019.11.19.07.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 07:39:01 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5bb4b0b2-cc12-2cce-0122-54bd72ab04e7@gmail.com>
Date:   Tue, 19 Nov 2019 08:39:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 7:38 AM, Paolo Abeni wrote:
> When doing RX batch packet processing, we currently always repeat
> the route lookup for each ingress packet. If policy routing is
> configured, and IPV6_SUBTREES is disabled at build time, we
> know that packets with the same destination address will use
> the same dst.
> 
> This change tries to avoid per packet route lookup caching
> the destination address of the latest successful lookup, and
> reusing it for the next packet when the above conditions are
> in place. Ingress traffic for most servers should fit.
> 
> The measured performance delta under UDP flood vs a recvmmsg
> receiver is as follow:
> 
> vanilla		patched		delta
> Kpps		Kpps		%
> 1431		1674		+17

That's a nice boost...

> +static struct sk_buff *ip6_extract_route_hint(struct net *net,
> +					      struct sk_buff *skb)
> +{
> +	if (IS_ENABLED(IPV6_SUBTREES) || fib6_has_custom_rules(net))

... but basing on SUBTREES being disabled is going to limit its use. If
no routes are source based (fib6_src is not set), you should be able to
re-use the hint with SUBTREES enabled. e.g., track fib6_src use with a
per-namespace counter - similar to fib6_rules_require_fldissect.


