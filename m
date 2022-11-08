Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA79621F44
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiKHWaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiKHW3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:29:54 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CAF1FF91
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:29:18 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 78so14578001pgb.13
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iw8zQOSB1EwwYJkuWC4Gw7hpw4rYDWi3Hqzc/4Lbh7o=;
        b=PFGSZkKXJsa9OpJcwbSIHAaZ6KpHJxR+nJWtR8ZzOvaqJFwd4WjV4oy3liidEisi6c
         v/pLIu99kKO/mutfZ2CRE+mSUypBKGiIEC6eM/FebisrMsxbdMOOICIxMOzscdBLOnD/
         tqVFDymlA/o7qQG/MQcxmDSFgnqruT8vf0qdNZSfSnh/MmGOzxu440dZdM9+6eCL2/im
         QxPRiepYMMGADwe8+bNVRdz9FZ8Fa+bN1GHAQ9QkVYXLOrccMMl++kxdyCsalDuw6P7U
         kVe538dbI3Yozmpl6x/6QfJdxKcXtUeM5UGLyTeE2hE2Tnt0MVh9taquUqhh8GSnWc0q
         6zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iw8zQOSB1EwwYJkuWC4Gw7hpw4rYDWi3Hqzc/4Lbh7o=;
        b=kIGDeBjM1IhgScOd6vZ6x95dW+weRyLlEdG+8g/TOJFoqjM4bs/VRAPupXvBuik9Yd
         Cod43pRjMVQDRvXEUqJqMsQGWGfVVOG5pWSVEK9VQZBFPcT/CkWTSDuB8HehOm9Rm4Xt
         nrHUx2eiIHaytl1ImrNN1NGClLZajjI7Ui5cPMUkBCxYD168bNvkjxwTOn/b8cmWmTQt
         q9SLhZGftScY17IN51UyVpTsSj+9wigNNiPtsHSG8bQslpygyjqZu1D36zAISG+zDPwu
         dIizGOdVPVZ0nal1Yq3p3Kx/nRJ7HfC/b7CCMCszzzq7eVQpNfLYEVGilafteqiiILrx
         HWTA==
X-Gm-Message-State: ACrzQf1RjopKN0TFNqqut/l33f3fbMETBBDSCvrWnxbsmd9fb7gadvYq
        L5ZP2KBxaEHPHjGKDwYum2tfcI4mptw7KyDj
X-Google-Smtp-Source: AMsMyM4EsHIPPFFrmKQJyvx12tsoJWdaa1o+pwBSqtRTUKdav2i1ILnHBR5mof/tvTh//YKJsW4Tog==
X-Received: by 2002:a63:85c8:0:b0:46f:5bbb:737f with SMTP id u191-20020a6385c8000000b0046f5bbb737fmr51097348pgd.93.1667946557870;
        Tue, 08 Nov 2022 14:29:17 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b00187197c499asm7504411plb.164.2022.11.08.14.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 14:29:17 -0800 (PST)
Message-ID: <33832500-ddf3-dc2b-a765-046d46031991@kernel.dk>
Date:   Tue, 8 Nov 2022 15:29:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
References: <20221030220203.31210-1-axboe@kernel.dk>
 <20221030220203.31210-7-axboe@kernel.dk> <Y2rUsi5yrhDZYpf/@google.com>
 <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
 <CA+FuTSdawNGXhW0DEf0-R6--1bDh7qByO=ViD_h=BfRe3XaFkw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSdawNGXhW0DEf0-R6--1bDh7qByO=ViD_h=BfRe3XaFkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/22 3:25 PM, Willem de Bruijn wrote:
>>> This would be similar to the approach that willemb@google.com used
>>> when introducing epoll_pwait2.
>>
>> I have, see other replies in this thread, notably the ones with Stefan
>> today. Happy to do that, and my current branch does split out the ctl
>> addition from the meat of the min_wait support for this reason. Can't
>> seem to find a great way to do it, as we'd need to move to a struct
>> argument for this as epoll_pwait2() is already at max arguments for a
>> syscall. Suggestions more than welcome.
> 
> Expect an array of two timespecs as fourth argument?

Unfortunately even epoll_pwait2() doesn't have any kind of flags
argument to be able to do tricks like that... But I guess we could do
that with epoll_pwait3(), but it'd be an extra indirection for the copy
at that point (copy array of pointers, copy pointer if not NULL), which
would be unfortunate. I'd hate to have to argue that API to anyone, let
alone Linus, when pushing the series.

-- 
Jens Axboe
