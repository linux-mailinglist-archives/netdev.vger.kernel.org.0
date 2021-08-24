Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17D23F591A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhHXHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhHXHhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:37:22 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A920DC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 00:36:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id x11so42468662ejv.0
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 00:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ohQP/1UpMRPWfOIH909jZeqhXx82KjuL1nCKK9Lczqs=;
        b=ScIf9fPFFbRhexoClHs4VFnCx1ReIkjSsslA5dqpARKNb9Bvx6NPJHAG3IQ3iHHBkk
         g+xLJWQWBZ2q/KxmLc3zV7tQnwK9wCpM6e2/CAA0f9DMlka7YGekua8AX/HwypywrLFJ
         wIs8rJML38TA2btLMJWXCw9buJ9I6loVZntwUHFpW9ObNnZS3pFh81RHSrGSTioZsynD
         89v0IH/KI2rMd/ErkUAS/QQ02lZVD6tBEiAYdWGDKm6kKvdFdm2H6+t+GNjcKiIcMwTy
         VieSQzRqhjDzO8ojaYX4Ar4GFvm80aF+aGoh+87ktxOk2/fuOw7WD9JOaUdjhjJxCvUk
         E1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohQP/1UpMRPWfOIH909jZeqhXx82KjuL1nCKK9Lczqs=;
        b=ulY9aw9/V0b2UWo2nRTNzGaUp0YH5WgHmx9Oc69F7Y3Ls1G54tVT0yD58zcQuZvVjd
         4VY8zMnl9dq4YZ0FBSCyT8+b+5nOxpZScdfOVJXBAo5g4xl10IFyRiSUSueWjJXaeNyc
         i0XMzAdDqOdcutq8VH9wh21uymgDrrLeLfsLeyM+8exR61MWx9tA9/VjxlKbXmPD3/6K
         1ixup8Mz0DvJApG69E8FK8/igql47k70FesHiWXGC0vZ5Ffs16v7b8vy513rQ6tRl7GQ
         rMxlkz3ySHGOjMfhKFcxHTXrzrXx7iDWn7igmQcmBWRpzk3NppWQsSMUSfootTrNU9aE
         VH3Q==
X-Gm-Message-State: AOAM531ddE4iXZvJdCPwm/E5Zj9Opf6ODJjSgYeOrXtVYoLa3fOf3FSv
        mgbgDlJAfwLyreuyhWoY88zMlQ==
X-Google-Smtp-Source: ABdhPJyKKboCkA1UwhTOouJjkqZjzqafar68hOnaLrflOftkHOt3FPI2uvaCwaaO+K8OjSNol3CJxg==
X-Received: by 2002:a17:907:2492:: with SMTP id zg18mr7398248ejb.233.1629790597326;
        Tue, 24 Aug 2021 00:36:37 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (94.105.103.227.dyn.edpnet.net. [94.105.103.227])
        by smtp.gmail.com with ESMTPSA id p3sm9032454ejy.20.2021.08.24.00.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 00:36:37 -0700 (PDT)
To:     Jiang Biao <benbjiang@gmail.com>,
        mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, benbjiang@tencent.com,
        Jiang Biao <tcs_robot@tencent.com>
References: <20210824071926.68019-1-benbjiang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH] ipv4/mptcp: fix divide error
Message-ID: <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net>
Date:   Tue, 24 Aug 2021 09:36:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824071926.68019-1-benbjiang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiang,

On 24/08/2021 09:19, Jiang Biao wrote:

(...)

> There is a fix divide error reported,
> divide error: 0000 [#1] PREEMPT SMP KASAN
> RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
> RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992

Thank you for this patch and validating MPTCP on your side!

This issue is actively tracked on our Github project [1] and a patch is
already in our tree [2] but still under validation.
> It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
> Fix it by adding protection in mptcp_push_release.

Indeed, you are right, info->mss_now can be set to 0 in some cases but
that's not normal.

Instead of adding a protection here, we preferred fixing the root cause,
see [2]. Do not hesitate to have a look at the other patch and comment
there if you don't agree with this version.
Except if [2] is difficult to backport, I think we don't need your extra
protection. WDYT?

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/issues/219
[2]
https://patchwork.kernel.org/project/mptcp/patch/286de8f451b32f60e75d3b8bcc4df515e186b930.1629481305.git.pabeni@redhat.com/
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
