Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95270473F7A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 10:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhLNJcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 04:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhLNJcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 04:32:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CECFC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 01:32:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y12so60001987eda.12
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 01:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7fwVpUOaodKaM1HiiY3Hyq1TyISHZ2AYLMJfZDUkWAQ=;
        b=71KLJdM6lHcUy7qUZGxXRU+h3DmKZjKoJjQ8xBtmTsnjpJ+l4P1I8oDFTuwJRGDXCg
         y8v4cL1sh8msuNXKeJnwAogYBTxRW8mQe6O0aikq0aRQUKdCm1J1z80+qBFEqjPhjus3
         6WzUcSOm5DevA2tMiqIgw7+f7YJsRBktL0J3g6L997N5EKpJWVQ6V9OBoQAG4ULhznYg
         6aah/W520k7pB3N+VWT+qtDTj5uR0YshpURo4np1or90qDr8QwjFSOv/2JLcYE9z8kyI
         lCr5bkLBWZk7MWugxqmsDI12+vvvKfO+KGYoi5tm9c/P57dFnsRJDdhuCKbLHmp9/qoJ
         oaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7fwVpUOaodKaM1HiiY3Hyq1TyISHZ2AYLMJfZDUkWAQ=;
        b=saeXLiddpXisPt8z2NL2kFsV1ExzWcXO8rTwca9EOf67kIQ2+2LzN363kEYmoY95DE
         /mVUhDH4K3VYkgLpa7AE6JssfIFcqzy0CTL/9+gkdAoYL2Is09rFopapTKgk+inMCtfq
         WQ79GKCkFWl+N2EzyVitRnPZJWWHE/Pz4WT+ybOs3BxqC4Nf0LgWmp4amRj8u2FSTLEd
         +cFN1+mxWXbD4Apk81thJVWIqoAzA778L8jQMBhGjH1K7mHX6KziHP//K5AgMAIO9kub
         M6ZNeO31Mr2GKCBDbaqbBfU63yMK43OBUJ0i9swxbo6FekBrmJOPCHe+ABhLGdtw4gsq
         fCmA==
X-Gm-Message-State: AOAM531eBU7rvYNPbex4nLMSPgZVw9MGRWWbKVxB15yvSvCBo8Wm2Q5y
        AaLdBFVrXyJEUqetoSOXU5EAiQ==
X-Google-Smtp-Source: ABdhPJy3ksNPqGkvwoTkcRk0gUHfzeOLqcskXSY8MiUKUWlel4ZJGMNu64BJubGTEGHCz2A28cKiaQ==
X-Received: by 2002:a50:ff10:: with SMTP id a16mr6385771edu.275.1639474364767;
        Tue, 14 Dec 2021 01:32:44 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:6ccb:ff63:52c1:4a46? ([2a02:578:8593:1200:6ccb:ff63:52c1:4a46])
        by smtp.gmail.com with ESMTPSA id f16sm550057edd.19.2021.12.14.01.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 01:32:44 -0800 (PST)
Message-ID: <d577aafc-4b2a-1b1c-ef14-8d670395055c@tessares.net>
Date:   Tue, 14 Dec 2021 10:32:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next] mptcp: adjust to use netns refcount tracker
Content-Language: en-GB
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
References: <20211214043208.3543046-1-eric.dumazet@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20211214043208.3543046-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 14/12/2021 05:32, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> MPTCP can change sk_net_refcnt after sock_create_kern() call.

Thank you for the fix and the new tracking infra!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
