Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5F1DB549
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgETNkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgETNkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:40:16 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06BEC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:40:15 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c3so2418389otr.12
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BgFIK6BO50eoXZzXN/dahygQXV+kjM/HRYvcly2owtw=;
        b=awKjqb/7Be2bEt9oDDlL2CzH6tiIj5cUrMQMCraIb3TAUn7qImRX2nOD/GulrhURZX
         TH0vdB3TSWailPP5O1AlHA3XgUq8dhz3QKBP0ZZG2/H5gX+Jn2y9gbVsc+kzjJoPxs5j
         ByRNtM+NFtCBM4FStq1Rxa4LlvkyubkMu+o4RB8QjRLSynpzWJGp6LFjOVWFyQ/SW+bp
         9vhXfEgJsoVUpXmJQKIg0yYdkEhUP3rliK8P188xK/0Wr4+zWsgI/3GHyV2e9gXHe/pL
         qfgXuHzrPFDs8zud9K9pKfl/VV6ujtKLAHs0Ag3kbnlRUTtz2jzNRA7OqUX2Zi3mTGYk
         tvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BgFIK6BO50eoXZzXN/dahygQXV+kjM/HRYvcly2owtw=;
        b=biiDEiz9a8yirXoqvCUAlphSoLJZjG2JVAcTu1gBeu6sHP5KWk+QHVx2uOefP/GQz3
         4zLO15DOp/G82BMRGgdlCvGCAV1u1e7llQLuG9AabKSD6w68aYDrtCmcY7d0NrQE2t9D
         uaTZr6yYrzilyo9JUI9KOTnxPui6GLFIbC17GxmqKXMRx7ylwSiBTDuRZkBKqjx8xNGs
         US2Xh2zCZqyfsdAfRaU5jwS0WLv2SB7o1JJfhEpC8kOXFX18Bb+0u2+QzrNAj27YRBRz
         RhDHciwqqdWKi1H0bx8jYFfPp3JViDyc0oooWiK+WSfv9+FpbvIyrXJH8wQmLMEO4HI2
         fRQQ==
X-Gm-Message-State: AOAM531LeZG5R4fsfIMWnf4V/iFkuiDXSYbWSzXVMLtpeqwon1r2vXCY
        DBYC5l59k01ZubEchrBA/euehuWH
X-Google-Smtp-Source: ABdhPJx/CBYgSA2zPshbPeljlulW7eUZ21dBWGORZtX5jftkzfzx7SbUVg216OgmPkz/I4U9ImZtlA==
X-Received: by 2002:a05:6830:22d6:: with SMTP id q22mr3156782otc.274.1589982015126;
        Wed, 20 May 2020 06:40:15 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d5aa:9958:3110:547b? ([2601:282:803:7700:d5aa:9958:3110:547b])
        by smtp.googlemail.com with ESMTPSA id z7sm788097oib.17.2020.05.20.06.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:40:14 -0700 (PDT)
Subject: Re: [PATCH net] net: don't return invalid table id error when we fall
 back to PF_UNSPEC
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
References: <fc61912d585ccf3999c3cba5e481c1920af17ca6.1589961603.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b129a24-57a8-4240-07c2-bfaa6231bf92@gmail.com>
Date:   Wed, 20 May 2020 07:40:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fc61912d585ccf3999c3cba5e481c1920af17ca6.1589961603.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 3:15 AM, Sabrina Dubroca wrote:
> In case we can't find a ->dumpit callback for the requested
> (family,type) pair, we fall back to (PF_UNSPEC,type). In effect, we're
> in the same situation as if userspace had requested a PF_UNSPEC
> dump. For RTM_GETROUTE, that handler is rtnl_dump_all, which calls all
> the registered RTM_GETROUTE handlers.

...

> Instead, this patch removes dump_all_families and updates the
> RTM_GETROUTE handlers to check if the family that is being dumped is
> their own. When it's not, which covers both the intentional PF_UNSPEC
> dumps (as dump_all_families did) and the fallback case, ignore the
> missing table id error.
> 
> Fixes: cb167893f41e ("net: Plumb support for filtering ipv4 and ipv6 multicast route dumps")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  include/net/ip_fib.h    | 1 -
>  net/ipv4/fib_frontend.c | 3 +--
>  net/ipv4/ipmr.c         | 2 +-
>  net/ipv6/ip6_fib.c      | 2 +-
>  net/ipv6/ip6mr.c        | 2 +-
>  5 files changed, 4 insertions(+), 6 deletions(-)
> 

Thanks for the detailed analysis and commit message.

Reviewed-by: David Ahern <dsahern@gmail.com>


