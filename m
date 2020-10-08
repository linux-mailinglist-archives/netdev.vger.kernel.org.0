Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E25D287AE8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731978AbgJHRXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729476AbgJHRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:23:02 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3118C061755;
        Thu,  8 Oct 2020 10:23:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so4897343pgm.0;
        Thu, 08 Oct 2020 10:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3V0mLS0s4CJgn1kQBjygX8jXur/PK/9Sdmb5D/NO1oU=;
        b=JC8+1YPK8N6nuYWVLgduPvVvTE1LrLt0G7RdJZtZtLuM9HuV8QwXwwZ9E18f9Z9agP
         IcQaJhcpE7uKzn2BBBVHzCSgE19QbQ07TFooWh5RqP3uW9v9p40dY4i8rrDaxmH7JU4p
         v40Mw4e4pQt9+V+410WxEyNypNtN8sxJN/xR6nz8rI6MBq6JHwPFfr9Z02V80VPkjsbB
         ixmRxgp31pUIBKZ5aogmc0UOQV2fgySM/hKT0UZN5uW8M0383tzQD+Srb0KBeXUGBSS9
         V1xEdPhOp/HNuph4Va6ealWryHDsxXh97XhlBcaSMWBpic1PKxCLJpypRi/ueo+spYdr
         /zXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3V0mLS0s4CJgn1kQBjygX8jXur/PK/9Sdmb5D/NO1oU=;
        b=WfhAwaIxT8OZMbi4SEAf/GVJOpxVKcotDPc0v49A2q/V2SJhE0MvTKPj6hlJ+vl2GT
         yjavJpQ5tXUj53Qj5sMl/2WICKozYihO+3YTEsEaLbZsODORoGeI7pnhOfvMO9HY0M09
         VpHJN3ejoOLEZ5XI2+Plle7vvZNuE7BL7JtU2RQacSgamDk2o/Oe1HxB6Zc2pdGrjCtj
         X6un1i/2nuExce8hLdomsBAdmxgRNAadGFcZc1y6v2ndf59ZXA7t4Swl4Xw7AE9pI/TE
         AfOmJ7XZ/lUbfttELxgso8GlekhDPzafhmBxT214DNgc6q8/SZGU+Q2GbhWkuh6jHm2O
         CLDA==
X-Gm-Message-State: AOAM5338Hk0A26IHZNL3tHJPH24GWfo7w21yDtNSH6eb5N2N8ujKV5cP
        +QCt1y4xXXH4xDFAKAdHzD63lK7O1xU=
X-Google-Smtp-Source: ABdhPJyxqP0R3hkoCHwwqlFgg3FNgBRx7TQaadovUF0A0CTVq+33dW3HxDDXCwcytZUHaEXCuIQ65w==
X-Received: by 2002:a05:6a00:888:b029:13f:f7eb:578c with SMTP id q8-20020a056a000888b029013ff7eb578cmr8754273pfj.10.1602177781205;
        Thu, 08 Oct 2020 10:23:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id j8sm6230113pfj.68.2020.10.08.10.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 10:23:00 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf_fib_lookup: return target ifindex even if
 neighbour lookup fails
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20201008145314.116800-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <da1b5e5f-edb3-4384-c748-8170f51f6f6d@gmail.com>
Date:   Thu, 8 Oct 2020 10:22:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008145314.116800-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 7:53 AM, Toke Høiland-Jørgensen wrote:
> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
> that the BPF program will pass the packet up the stack in this case.
> However, with the addition of bpf_redirect_neigh() that can be used instead
> to perform the neighbour lookup.
> 
> However, for that we still need the target ifindex, and since
> bpf_fib_lookup() already has that at the time it performs the neighbour
> lookup, there is really no reason why it can't just return it in any case.
> With this fix, a BPF program can do the following to perform a redirect
> based on the routing table that will succeed even if there is no neighbour
> entry:
> 
> 	ret = bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
> 	if (ret == BPF_FIB_LKUP_RET_SUCCESS) {
> 		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
> 		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
> 
> 		return bpf_redirect(fib_params.ifindex, 0);
> 	} else if (ret == BPF_FIB_LKUP_RET_NO_NEIGH) {
> 		return bpf_redirect_neigh(fib_params.ifindex, 0);
> 	}
> 

There are a lot of assumptions in this program flow and redundant work.
fib_lookup is generic and allows the caller to control the input
parameters. direct_neigh does a fib lookup based on network header data
from the skb.

I am fine with the patch, but users need to be aware of the subtle details.
