Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF86491BA
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 03:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLKCD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 21:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLKCD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 21:03:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F7412618
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 18:03:56 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 124so6321282pfy.0
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 18:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ts1fy0Eif0ny2SMi4zcfUEN1YrWd0uUI3y9vBGtfsdw=;
        b=wrk5qO91ovAcxKz06WVV6WGUb0XqP35B0L806mEhx/y5ZO9hHbUhhJpMmdHzmVixef
         8N5iNPCB+soXR9CCeUD6m173o9/KZk9gbs7E6qpREM4xw7Lp8dpXZz+8Ctgp7iGPIDx1
         0VSZVUsVUuYLqEWDpJPD7AyEOVu7hdPsa12WrlxkLWwGksWV+X0j/7EI75Wn5zFpglZe
         pw8db38BZ3wTBFx9o5dtGNaFdibe2iQ+px+vHFVR+b4w3TrDa9CkeYm+GBoTAidR4pVD
         fHC59WwSnTO4rXoeHJhwkYITe75U/jkevAhhjdUgGsbZloWOko1yTN2JPpDPqVz1LTeW
         0VGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ts1fy0Eif0ny2SMi4zcfUEN1YrWd0uUI3y9vBGtfsdw=;
        b=tX86+l8qO7w8XHUHvgT5DgbqPewVSSe8qbnBcD8kx2ggyNFyvAuGHpSvdvt1C7f411
         7ETcZEWZ1TG3oteiBu9FqkW4TgoMfvpnosCTWwfB8jUUTSITacs0Yvj22u6B45raYU/K
         4s5arMYQFHx/GIDndypEOtko8OaWfgF2mLZP+O3YwLs91du5uF+xbEU8ldLAiTxDXkM5
         NOeJZ9rKr4wIKdoFzaBVDOdpajPj4f7I/d4XJWak7YpNsE6EJCWWUBpO1YymN7VzM/jS
         vmgAjc7snsM77mnpsDYablIfbxqkm5BbpnaVY9rn40czI4kOfGV6nQTJHIKpB32dOmlL
         Wbig==
X-Gm-Message-State: ANoB5pll9/PmdeAZi6GmIsAz0NbViuPGf9iQqgFOwUw0n1fatcLD1Uuj
        Tf7R+3eCzqNgGDQod+sdNNEZZw==
X-Google-Smtp-Source: AA0mqf7kVlVC7bIWH7GcHk3ORWQZ38H9HkOlizIq9Sk9a0uqO2tCrKZi9Mot1C3mEsE+KLA58iLyUA==
X-Received: by 2002:a05:6a00:2294:b0:577:7fe8:b916 with SMTP id f20-20020a056a00229400b005777fe8b916mr2513734pfe.0.1670724235807;
        Sat, 10 Dec 2022 18:03:55 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e188-20020a621ec5000000b00575f348aa3esm3264738pfe.122.2022.12.10.18.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 18:03:55 -0800 (PST)
Message-ID: <e48b3a8f-eabd-7c63-79cc-c58fb91aa990@kernel.dk>
Date:   Sat, 10 Dec 2022 19:03:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] Add support for epoll min wait time
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
 <CAHk-=whgzBzTR5t6Dc6gZ_XS1q=UrqeiBf62op_fahbwns+xvQ@mail.gmail.com>
 <CAHk-=wiT67DtHF8dSu8nJpA7h+T4jBxfAuR7rcp0iLpKfvF=tw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiT67DtHF8dSu8nJpA7h+T4jBxfAuR7rcp0iLpKfvF=tw@mail.gmail.com>
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

On 12/10/22 12:26?PM, Linus Torvalds wrote:
> On Sat, Dec 10, 2022 at 10:51 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Now, maybe there is some reason why the tty like VMIN/VTIME just isn't
>> relevant, but I do think that people have successfully used VMIN/VTIME
>> for long enough that it should be at least given some thought.
> 
> Side note: another thing the tty layer model does is to make this be a
> per-tty thing.
> 
> That's actually noticeable in regular 'poll()/select()' usage, so it
> has interesting semantics: if VTIME is 0 (ie there is no inter-event
> timeout), then poll/select will return "readable" only once you hit
> VMIN characters.
> 
> Maybe this isn't relevant for the epoll() situation, but it might be
> worth thinking about.

It really has to be per wait-index for epoll, which is the epoll
context...

> It's most definitely not obvious that any epoll() timeout should be
> the same for different file descriptors.

Certainly not, and that's where the syscall vs epoll context specific
discussion comes in. But I don't think you'll find many use cases where
this isn't a per epoll context kind of thing for networking.
Applications just don't mix and match like that and have wildly
different file descriptors in there. It's generally tens to hundreds of
thousands of sockets.

> Willy already mentioned "urgent file descriptors", and making these
> things be per-fd would very naturally solve that whole situation too.
> 
> Again: I don't want to in any way force a "tty-like" solution. I'm
> just saying that this kind of thing does have a long history, and I do
> get the feeling that the tty solution is the more flexible one.
> 
> And while the tty model is "per tty" (it's obviously hidden in the
> termios structure), any epoll equivalent would have to be different
> (presumably per-event or something).
> 
> So I'm also not advocating some 1:1 equivalence, just bringing up the
> whole "ttys do this similar thing but they seem to have a more
> flexible model".

Maybe this can be per-fd down the line when we have something like
urgent file descriptors. My hope there would be that we just use
io_uring for that, this series is very much just about eeking out some
more performance from it until that transition can be made anyway. I
don't have a lot of vested personal interest in improving epoll outside
of that, but it is a really big win that would be silly to throw away
while other more long term transitions are happening.

-- 
Jens Axboe

