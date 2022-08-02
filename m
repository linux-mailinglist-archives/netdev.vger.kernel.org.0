Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA24588333
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 22:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiHBUpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 16:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiHBUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 16:45:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3380F12AD6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 13:45:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i13so19084912edj.11
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 13:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jMQM6VWyA3CuAQPGaHRQWygks7/MUcQQvwWnradQtgg=;
        b=MpVRqwCozKZeTI7BkLJqljkb4Luwlll5StDqkKg9RV97NFRcNXlqusJpPcXBk3PcVM
         0oziPeObokr9ZY5vlam9TORe8RlxIVu/QfF0rmLQ6IH4+Ql3ntLZMzg39oO+VDFZF3IT
         hTOzOxjR8SEjng6sRcTB0qS0TMPL2M+futjG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jMQM6VWyA3CuAQPGaHRQWygks7/MUcQQvwWnradQtgg=;
        b=07mPPQ8tbd+esv315d/oMWnhCBWMYlyOn2F6KKkJfinN5fZWgZiKpgFNH6i/MaU84J
         k40yKif2XGJmeFIJsrCO/FkcsHWSZdQjBWotMLJWVhsTynGIWV9zs6G8iglTgKHY00s+
         9ODcv+AQhrKf+CgFyvhICPDpw571xJcqF5q2YQetgXzCbV5Jh1gQOkgo4KOls6FAIYGo
         1ugoawppKO+ffP7gNoOVHNVZBCJq4WwMc3X9RmMrlggypKBVSvMLpCkS95d7pt7IoN6R
         O7L80hA/W4DbgckIrnLpqcTeCg98qmQsDNrLTwyoA0PpT62ju3YjDBIEoNgjRKqGe7uO
         RikA==
X-Gm-Message-State: AJIora8xYPG6YXgmXT93UE9hNnXPZCbkUsEWPP+O6pnL/ywu82GCKkiU
        XsW2t2Wl4ZsfUMfCnLa8jL2BbhQnKmdJJyxv
X-Google-Smtp-Source: AGRyM1stiSWWCcjhbzIIGDBSOJgz1I6RQsH1b2oeu1jWuorfVh07seoVLcK6zgy/usZ9e/HmFmocDg==
X-Received: by 2002:a05:6402:424f:b0:43c:12e7:36dc with SMTP id g15-20020a056402424f00b0043c12e736dcmr22134296edb.243.1659473148576;
        Tue, 02 Aug 2022 13:45:48 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b00724261b592esm6565753ejc.186.2022.08.02.13.45.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 13:45:47 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id n185so7755813wmn.4
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 13:45:47 -0700 (PDT)
X-Received: by 2002:a05:600c:2211:b0:3a3:2149:88e1 with SMTP id
 z17-20020a05600c221100b003a3214988e1mr716886wml.8.1659473147217; Tue, 02 Aug
 2022 13:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
In-Reply-To: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Aug 2022 13:45:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
Message-ID: <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring support for zerocopy send
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 31, 2022 at 8:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On top of the core io_uring changes, this pull request adds support for
> efficient support for zerocopy sends through io_uring. Both ipv4 and
> ipv6 is supported, as well as both TCP and UDP.

I've pulled this, but I would *really* have wanted to see real
performance numbers from real loads.

Zero-copy networking has decades of history (and very much not just in
Linux) of absolutely _wonderful_ benchmark numbers, but less-than
impressive take-up on real loads.

A lot of the wonderful benchmark numbers are based on loads that
carefully don't touch the data on either the sender or receiver side,
and that get perfect behavior from a performance standpoint as a
result, but don't actually do anything remotely realistic in the
process.

Having data that never resides in the CPU caches, or having mappings
that are never written to and thus never take page faults are classic
examples of "look, benchmark numbers!".

Please?

           Linus
