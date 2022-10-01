Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5E5F2060
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJAWhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJAWhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:37:22 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9186565D4
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:37:21 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-356abb37122so42713277b3.6
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 15:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4ZlGK7doOee8aHf/B8aMPnDnMKvXTwcD+0DsEe1TZQ8=;
        b=HwaSd4h3qwv94oNMhivlHJWbMNREmOwyy3C7y0LEvfpAlh0aQZBLJivOObhsJyG49E
         baYTVv0PLHqfBVNki2KyNynCvqSXeAKJqWnbNCYjw+gzDtE+/Qq91dOxWQqEa5BgS/y7
         hSNHUdyqO0meyzDm73Hje+vxyDx835zW1nYKX4fY6uw01xidYkKizD5g5394mkhH/Q9x
         kVyrPIUnqtYuSdTDDDI0LJIewgpHY9k107ijomlsHWnc1N7tT9aP3EgF29i2MQXs8Uuv
         xkKV182wa1+Mi5EPRh7zbHFfjYu/0TgsbT/Q3fMxluptD+erznTo0YvJ+H42iqhyriDS
         78iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4ZlGK7doOee8aHf/B8aMPnDnMKvXTwcD+0DsEe1TZQ8=;
        b=KpImjxndvhe22eBvd2aneRHwLV8xtEdA3QRyfdP7F0CabEGtW420O9ZYHptCznQC1+
         Jl8ifEa011UOPpsIDhcIkNKT/OmRljMxAUQ0357GukwuRAdtKc+QmCkSiBTzG4jE73yF
         e1oSwm5W7P00saWS8IQhakubDr0Via2LDN1eCC4Z0APHFgUj/AlISwCeLGXsG8sjNLq/
         WK3UlbAT3Kchbnpi6ySbjvChrfYT46Lt6rmf8cm2Wps5aml2WqEMO49vR8IDgzl2Ttl0
         OJp2mRKDBtc4BPP3EoVzh9OveGzuHbNHKZ6wALl/eaPQoJlg3ylP+7Md8Kq47ZnCP0qO
         HhBQ==
X-Gm-Message-State: ACrzQf0Rh/8wOxcDlfciPG/seqMwZN6MRpuv5i52VHyhj807qlo9Nzu5
        Ho2CCgkNNSp6R8VjisOZTYONF9DWSTINu4qz58lCvw==
X-Google-Smtp-Source: AMsMyM4hc4r0ayoymqWS3Z2TUOA0Zdw3Tjku/rt80dUAcgFChLYd0FuY4JXL/W31D+SfseG5blTAXCxFX2gGJ+Rkjho=
X-Received: by 2002:a0d:d807:0:b0:356:851e:b8eb with SMTP id
 a7-20020a0dd807000000b00356851eb8ebmr7597313ywe.489.1664663840501; Sat, 01
 Oct 2022 15:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
 <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
 <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com>
 <Yzi8Md2tkSYDnF1B@zx2c4.com> <YzjAfdip8giWBF4+@zx2c4.com>
In-Reply-To: <YzjAfdip8giWBF4+@zx2c4.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 1 Oct 2022 15:37:09 -0700
Message-ID: <CANn89iKTzqBsphc1=6fDbTH=gmA2nVfZTGObCFETfpg03gqb7A@mail.gmail.com>
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 1, 2022 at 3:34 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi again,
>
> Actually, ignore everything I said before. I looked more closely at the
> trace, and this seems like a bogus report. Let me explain:
>
> The part of the trace that concerns my last email is tiny:
>
>   CORSurv-352       0d..1.   36us : get_random_bytes <-__inet_hash_connect
>   CORSurv-352       0d..1.   45us : _get_random_bytes.part.0 <-__inet_hash_connect
>   CORSurv-352       0d..1.   55us : crng_make_state <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.   65us+: ktime_get_seconds <-crng_make_state
>   CORSurv-352       0d..1.   77us+: crng_fast_key_erasure <-crng_make_state
>   CORSurv-352       0d..1.   89us+: chacha_block_generic <-crng_fast_key_erasure
>   CORSurv-352       0d..1.  101us+: chacha_permute <-chacha_block_generic
>
> After those lines, crng_make_state() returns back into
> _get_random_bytes(), where _get_random_bytes() proceeds to call chacha20
> totally unlocked, having released all interrupts:
>
>   CORSurv-352       0d..1.  129us : chacha_block_generic <-_get_random_bytes.part.0
>   CORSurv-352       0d..1.  139us+: chacha_permute <-chacha_block_generic
>   ...
>   CORSurv-352       0d..1. 126275us : chacha_block_generic <-_get_random_bytes.part.0
>   CORSurv-352       0d..1. 126285us+: chacha_permute <-chacha_block_generic
>
> I guess it's generating a lot of blocks, and this is a slow board?
> Either way, no interrupts are held here, and no locks either.
>
> But then let's zoom out to see if we can figure out what is disabling
> IRQs. This time, pasting from the top and the bottom of the stack trace,
> rather than from the middle:
>
>   CORSurv-352       0d....    4us : _raw_spin_lock_irqsave
>   ...
>   CORSurv-352       0d..1. 126309us : _raw_spin_unlock_irqrestore <-__do_once_done
>   CORSurv-352       0d..1. 126318us+: do_raw_spin_unlock <-_raw_spin_unlock_irqrestore
>   CORSurv-352       0d..1. 126330us+: _raw_spin_unlock_irqrestore
>   CORSurv-352       0d..1. 126346us+: trace_hardirqs_on <-_raw_spin_unlock_irqrestore
>
> Oh, hello hello __do_once_done(). Let's have a look at you:
>
>   bool __do_once_start(bool *done, unsigned long *flags)
>       __acquires(once_lock)
>   {
>       spin_lock_irqsave(&once_lock, *flags);
>       if (*done) {
>           spin_unlock_irqrestore(&once_lock, *flags);
>           /* Keep sparse happy by restoring an even lock count on
>            * this lock. In case we return here, we don't call into
>            * __do_once_done but return early in the DO_ONCE() macro.
>            */
>           __acquire(once_lock);
>           return false;
>       }
>
>       return true;
>   }
>   EXPORT_SYMBOL(__do_once_start);
>
>   void __do_once_done(bool *done, struct static_key_true *once_key,
>               unsigned long *flags, struct module *mod)
>       __releases(once_lock)
>   {
>       *done = true;
>       spin_unlock_irqrestore(&once_lock, *flags);
>       once_disable_jump(once_key, mod);
>   }
>   EXPORT_SYMBOL(__do_once_done);
>
> Well then! It looks like DO_ONCE() takes an irqsave spinlock. So, as far
> as get_random_bytes() is concerned, interrupts are not being held
> abnormally long. This is something having to do with the code that's
> calling into it. So... doesn't seem like an RNG issue?

I guess you did not read my prior email sent hours ago :)

https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#m43fa0bac40dfda59c2b72cb3e844b41f3cdb949d
