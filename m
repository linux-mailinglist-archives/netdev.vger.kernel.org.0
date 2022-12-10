Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C17648FC8
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 17:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLJQXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 11:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLJQXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 11:23:34 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821DE262D
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 08:23:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s7so7918653plk.5
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 08:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PmZQ+2OuVpNbAMZAF8HQ9Wo8B4LQhqBG+y0v6wlrdS8=;
        b=28Cbvy1KKL/NOAZpDxDz6tBVo/uyT8JBmNTrlPqUi6HYBnLpB0ZHRnYK3Y4v+jm6xl
         3Uq9i1Hc2NFSqyc62pn70h/UABjcrRXuc0jZv0RyvsVb39GLhTH2TvBmtdxx9Io5awXP
         84AqhFBhdx7ZEg+3n05nfTwZ1OT7khFvdlZTw0ngdj+31r7BJwkJgHB84aOUbUZzyqOX
         FQ7xl7f4OWJ8VNBtNJxlsMALm9IL46hrGHd/rVyXz3CTDBa21GuBgEkbsKiX6VBwyk0T
         C416iXn+XLfPcLQhxAG+NI3C/68F4OgopJR5avAfh23aafiAjZLh4/cINjZC0wrw2GfR
         Bn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmZQ+2OuVpNbAMZAF8HQ9Wo8B4LQhqBG+y0v6wlrdS8=;
        b=EkuTmG2kZMXn+1uuFRcCuo3NB3fCkINuJzaLE+F3S2sOfDMXIzOdwH0Ftzmi8f1fDi
         G8XsiN8l+wOYAkPra+UZkmhcOEeFA1m9J0apv3bwPth0BTDU6wBwL+DkdhOlGWa8FSB9
         xVHx688gloq3Zwq3yaKYM5/bkopPeMMaVSoSNf13w2gYEcaBmqNJDp0CRBgO+zBAwkBX
         z8IqGViRAenhP5NXXWwJ6AKddT9XrlMJSoHsUgxQg0oF1lt9tZUpOYvXwrVl1uUDhhDS
         C6Xp2U3wQCl8wnzLfFtuCTvU31JidHxcdx2VD88sk8h8Dxm/N1g3Jaub9wQCHGM9DJHW
         MPiA==
X-Gm-Message-State: ANoB5pnpxRpl6N6lCr6ZnAcDBK8one0HF4YtaGO97egnQkfZ5ne3DYL1
        hWyu4e1wNYGlGLlww5aqTPlP2Q==
X-Google-Smtp-Source: AA0mqf4JUyJ2DCv8l1wDNr7dUqqBq84xsojWN7pcWoYcEohvfqUnJb+4SXpAihgF/Yj1f/BSiGgzOA==
X-Received: by 2002:a17:90a:6304:b0:219:ccc2:c0a5 with SMTP id e4-20020a17090a630400b00219ccc2c0a5mr2149757pjj.0.1670689409951;
        Sat, 10 Dec 2022 08:23:29 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090acc0700b00219eefe47c7sm2701889pju.47.2022.12.10.08.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 08:23:29 -0800 (PST)
Message-ID: <68cf6d34-037b-bf66-7c28-5bf6a65c494f@kernel.dk>
Date:   Sat, 10 Dec 2022 09:23:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] Add support for epoll min wait time
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
 <20221210155811.GA22540@1wt.eu>
 <e55d191b-d838-88a8-9cdb-e9b2e9ef4005@kernel.dk>
 <20221210161714.GA22696@1wt.eu>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221210161714.GA22696@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> This last patch fixes a bug introduced by the 5th one. Why not squash it
>>> instead of purposely introducing a bug then its fix ? Or maybe it was
>>> just overlooked when you sent the PR ?
>>
>> I didn't want to rebase it, so I just put the fix at the end. Not that
>> important imho, only issue there was an ltp case getting a wrong error
>> value. Hence didn't deem it important enough to warrant a rebase.
> 
> OK. I tend to prefer making sure that a bisect session can never end up
> in the middle of a patch set for a reason other than a yet-undiscovered
> bug, that's why I was asking.

If the bug in question is a complete malfunction, or a crash for
example, then I would certainly have squashed and rebased. But since
this one is really minor - checking for the return value in an error
condition, I didn't see it as important enough to do that. It's not
something you'd run into at runtime, except if you were running LTP...

-- 
Jens Axboe


