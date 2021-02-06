Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A1311E9A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBFQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhBFQTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:19:46 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EFCC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 08:19:06 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id t25so10086026otc.5
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 08:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zzh4AKKfiFLIZO6lzJuAuzHsB2zMaTdc91wbmlIdcdc=;
        b=Aev+PEQlg9cVSIQM8FkVYTLRjTzfZ9nSGG1pJ9Si0nNvqWi5i+qoslvpLMOsrhTso1
         CylZuCN1RiVO6elTV657xLbQqtUzVyTorZeqMKiEDoBZXRNwkIDKzVfvJBZUhfm3b/1W
         m1qlKCKDXAiu1tdaFIES/EDdcb0RF66mRnNfIItcoGdy4WREPQBZC1D+QGQdnMhdAHCg
         U5UUfq3NAHl23oJ3CrX23bavS3gta9+dxGw4zlcbcZV60nm0byDDp+YaWxZX+TS2MLVM
         +uNHCXMB7ohyHmK1IW/Vmyz3wb1o+N4ygGMcHJKLJ9+WdxR05ap6hqnekUE63O8xw3AT
         LMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zzh4AKKfiFLIZO6lzJuAuzHsB2zMaTdc91wbmlIdcdc=;
        b=JeAga6PsVZcToUQ9NDRw4fVbpl3H6tXSrqAf1pJNwtf51bXSXA3sX0/1SjYKR1xlkm
         7D5gMouyVA45dH3hxH8EUGivT2/vXFwyGzHLxNAbv7pMlT8ES1sYpmsm9MkAyExjlOzN
         ZPccFFkPvfiuJwqnB/2l6+fv7HajgZnQ/kGpH/V5hVDQLxFq0H3GMZ0AkCrB5Dy3IWNM
         U8TjvoPE/1x61pO5w1a0h+nKAjnCyuKLTCln7M+Wrbl166PyosXiCdSuroqBwo7csHbS
         OJXSDE+fsQmw7S1NStaBL6vALhNH1fXE2o7Mpj5pK+6s55xdFsqmY/PL2M1MixM/0Ewt
         SvDw==
X-Gm-Message-State: AOAM530NQjR0RzbDBUrMrVHhsSB9RWuksZBTSRPRFYZQXCenr0MlRiH3
        NHtFg4yjKw/MdQJfUJEfSOQ=
X-Google-Smtp-Source: ABdhPJzSEJtyIlJp9Ie3SoPLjhQzs86q/XHq/FovJkRe75OQvLOWIrARioZlShd2GKFWKolqaGZZ+g==
X-Received: by 2002:a05:6830:191:: with SMTP id q17mr6980295ota.110.1612628345731;
        Sat, 06 Feb 2021 08:19:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id l24sm2560178otq.5.2021.02.06.08.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 08:19:04 -0800 (PST)
Subject: Re: [net v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42d8a9a6-a449-ee78-c486-520df6052d1f@gmail.com>
Date:   Sat, 6 Feb 2021 09:19:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/21 12:02 AM, Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it to be 0-valued.
> 
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/tcp.h | 2 +-
>  net/ipv4/tcp.c           | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


