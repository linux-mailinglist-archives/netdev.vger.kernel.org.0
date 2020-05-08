Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287641CB26F
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgEHPEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgEHPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:04:00 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92148C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:04:00 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g16so705464qtp.11
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 08:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QeoWvumS9qi1Gy3H41jW6MV5mxSMg6K3dWIQfbfT1Yc=;
        b=Fpb39XBCNv95qUlSExlDtCMcEDHwu4OoU0W2XMmwNNeh7IxItgQjwUkeAKE/aOrub8
         IBp59G59+EeX2j0ZZsapFOh2PiWELw7GztOL4h4PXbPigjMbWTtcBLphDucK6f6VR7c4
         gZKAhrR7GsNHUGrN7QjbTs8zRdnUslwk6mGVJvIoWEBiZ4LfKt8K2SCx8bXxs5e9V6If
         Mjmbk8Cga80boOEj+6KfVG8iol3mpanjUu9mxBVWmkJqgT5JMu1e3Kki2nTdo04QtRlt
         eXSkPuSOF5Oj2PkmgNN5ncXPuSSkpCmdsMaTDsJ9iAGFYHhiirixCb8S9Ps0K4Yf0GYR
         W35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QeoWvumS9qi1Gy3H41jW6MV5mxSMg6K3dWIQfbfT1Yc=;
        b=fdVqChDyBORAt2eyjFxvQQZfwS08z6jcd85Ho+eXDsdLUAhmOazM8AEYWE3aMoROOp
         Ks4CVU9a72N6nHi+rMr2NcCeN+z2PfS8xBOUe0/v5PU+KOMtzMYbWTdvmCCi1bYemi0w
         XpynGvtj11Nn0dSSRqKbjL3c/VOwjBHdEdhjpzlVu7RV9aN7Wj4O4sq5uN8odIvzAbHQ
         mXJFhvYcfunHKL/dCZyaD2JW9k/8bW93FS4f56MGvprOqOQsclWf3NSaLtNN7Qy8duED
         v1lt/kOvDoeJ+CiqWnIGP+nkVVXEdT/S36GDkUqHHbfECP17j1FiGX+yKAcx3mH9Lb1f
         5Ncw==
X-Gm-Message-State: AGi0Pua80M60FCs5gI+3x/G1A66LP/ghL7jLbjtVXtga/g+IdzmMjewJ
        aBm2UcpBqsixRwBPhIuzMkM=
X-Google-Smtp-Source: APiQypJdCPhMBkOJ8TR22e30bgrMozKTo4YNjjnxgaayI4ZdVUFtvIkwPvfuhWcZlYoio4K1RDxU4g==
X-Received: by 2002:ac8:2f15:: with SMTP id j21mr3612458qta.259.1588950239851;
        Fri, 08 May 2020 08:03:59 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c09e:cbdc:b4a2:7243? ([2601:282:803:7700:c09e:cbdc:b4a2:7243])
        by smtp.googlemail.com with ESMTPSA id t15sm1669550qtc.64.2020.05.08.08.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 08:03:59 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
References: <20200508143414.42022-1-edumazet@google.com>
 <362c2030-6e7f-512d-4285-d904b4a433b6@gmail.com>
 <a5f381b0-e2bf-05f9-a849-d9d45aa38212@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <92c6ab11-3022-a01a-95db-13f6da8637cc@gmail.com>
Date:   Fri, 8 May 2020 09:03:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a5f381b0-e2bf-05f9-a849-d9d45aa38212@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 8:43 AM, Eric Dumazet wrote:
> This patch can be backported without any pains ;)

sure, but you tagged it as net-next, not net.

> 
> Getting rid of limits, even for exceptions ?

Running through where dst entries are created in IPv6:
1. pcpu cache
2. uncached_list
3. exceptions like pmtu and redirect

All of those match IPv4 and as I recall IPv4 does not have any limits,
even on exceptions and redirect. If IPv4 does not have limits, why
should IPv6? And if the argument is uncontrolled memory consumption, is
there an expectation that IPv6 generates more exceptions?

My argument really just boils down to consistency between them. IPv4
does not use DST_NOCOUNT, so why put that burden on v6?
