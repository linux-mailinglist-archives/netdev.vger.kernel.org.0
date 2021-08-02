Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB81E3DDED0
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhHBR7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhHBR7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:59:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1C9C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:58:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ec13so25123547edb.0
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wIh9xwk4yoJVJdYDaG6O3THDhBy6HG87wo/8DEOrPYY=;
        b=cyTRgn9OQoW6vQ0Qj/xCo3tSZxLwwXDZEz77gkpjDGNNCnq88k5/GRU7DMGU8o/XXz
         UtF20yRLSAdpDpk5gMGggbQz2xz9cBI1+rkfFbu9JeL3HVMouKkH85tasuO6t0RpJvbn
         Ty6jPqNiO1JMXv+pLQy6x5vRxmGYAGr7wVUbZZry+KUbxt2T6mJY2RhN+HlgRtjGf3Xq
         y7QkHCLz96wp16B6SoXT+M2uR58l/FLhPm/75E7QG4TJk4R+LdbyVyn/F/P+6NnyTPG7
         NSoId2pjtUCQZEZfWIqgolxjhG3C3I8CCIXcC2hmXMPMTGHbbgo4tXdxATg+Am3HCesp
         IBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wIh9xwk4yoJVJdYDaG6O3THDhBy6HG87wo/8DEOrPYY=;
        b=UkBaWYgem7AQMGB+GFqUPg0LoiWALSeDu+Plr7j3SFGZJfBevJFMm3f0BOjYTlTHKj
         VdsMvDP/n0fSq2ruUCf9qhdv1DEpV91ZsGzPHHiJKGrA2tVKd2aVnhWvoYAxgIAqJhI5
         lMgxT5LvtYFPh0Cy4tSzfgx5qQqgme8hSUMCe2rlOeA+9hrNd1pqyhq9V/O74pfUS4n2
         kFNe6FtKY1UAOzBdkht602dCfoob0i/yU2NjsqFkdNZiYjUXDOe/jXda30/P6Dexr5ZN
         UR+/Y2bpxGS6C2gJF0gnc9ryN589JmB0OsD6PQV82oR23jJ1cb9L8uFIE+zRBoSffv9M
         q0Hg==
X-Gm-Message-State: AOAM533OhTjob8XFxZs3ByW+/lg/l76XlBMf4kp5Ue40VxVc2n2SAbae
        noYKzKCns3GeUvagjI2ajEv/6A==
X-Google-Smtp-Source: ABdhPJxwU8d5SPecVEgSVpXusEZ2kzHByM0/OuLT8rhwokO5tnyII2Hr/eqALhZdGZLrq1I3IG0V7w==
X-Received: by 2002:aa7:cc83:: with SMTP id p3mr21053547edt.365.1627927134326;
        Mon, 02 Aug 2021 10:58:54 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([109.201.130.12])
        by smtp.gmail.com with ESMTPSA id mf11sm3925571ejb.27.2021.08.02.10.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 10:58:53 -0700 (PDT)
To:     David Ahern <dsahern@kernel.org>
Cc:     ciorneiioana@gmail.com, Yajun Deng <yajun.deng@linux.dev>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20210802160221.27263-1-dsahern@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next] ipv4: Fix refcount warning for new fib_info
Message-ID: <332304e5-7ef7-d977-a777-fd513d6e7d26@tessares.net>
Date:   Mon, 2 Aug 2021 19:58:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802160221.27263-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 02/08/2021 18:02, David Ahern wrote:
> Ioana reported a refcount warning when booting over NFS:
> 
> [    5.042532] ------------[ cut here ]------------
> [    5.047184] refcount_t: addition on 0; use-after-free.
> [    5.052324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xa4/0x150
> ...
> [    5.167201] Call trace:
> [    5.169635]  refcount_warn_saturate+0xa4/0x150
> [    5.174067]  fib_create_info+0xc00/0xc90
> [    5.177982]  fib_table_insert+0x8c/0x620
> [    5.181893]  fib_magic.isra.0+0x110/0x11c
> [    5.185891]  fib_add_ifaddr+0xb8/0x190
> [    5.189629]  fib_inetaddr_event+0x8c/0x140
> 
> fib_treeref needs to be set after kzalloc. The old code had a ++ which
> led to the confusion when the int was replaced by a refcount_t.

Thank you for the patch!

My CI was also complaining of not being able to run kernel selftests [1].
Your patch fixes the issue, thanks!

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt

[1] https://cirrus-ci.com/task/5688032394215424
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
