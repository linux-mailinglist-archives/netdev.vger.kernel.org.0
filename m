Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5835ECC36
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiI0Siw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiI0Siu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:38:50 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEF81C0548
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 11:38:49 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id j7so13267283ybb.8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 11:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=xSZ682w5ERrO6R78wwV44UGgVoXiwfq6LpXxDud2rDY=;
        b=IURYt96xDYtZV9opxCfSq+4rnSgKylXiwC1PiVyyiuQXJmbyB/0IGBI9+reK6nGcBa
         yxMX0ReVRDgYyHRf6Yy/26Kmpz4DJGM3QK+ADwIFkAAu0Kw2ZZg+FqlyNSIcgFpbIfhd
         L7VRqXOPq+pJNWzzg2lh4UttTrBx8MogHgkSJcTP43LW18zUIahVAhEE2DkgoAjOe9bg
         OFADdSY4YHA5HlHZkOVW4A+bh1ekHURGgpa0pUf/ilbt1N+9bBLQhOVcPT5ty0KJ/9Ze
         WFD6ATM0SKgZ+78tMSCyOoXzadWXXpo/UeCsvcjs0OH5xYkpk0WdvGurbUDq53ooB/kN
         m0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xSZ682w5ERrO6R78wwV44UGgVoXiwfq6LpXxDud2rDY=;
        b=79/4QYcPH0mM3jY3HcVgf4bmdoTLYdZlPLMLLEByHiW0NEdjrvZGwnHHi7J0FywpYe
         ngGL6XymUkedQ2slG+Rjrs+gmx0KLCmgItWrPSv//aoe/8NgllmB5UmUvKdEQ8Vcj+gP
         w7utLVyRDicL1GEyqlA/hU9dIVJ2hYmgIRBcwI7pbdcvKuZKUgXIEjVT+WaNa5Zy68hD
         5Df704017SOXgXia66y+5RTgS4ZgQYAfx+M8BnwvWVXa8CeeEIlVumEny+/P519XH5wt
         nRxguJlMdRAzLGA5yYtGnnydSZOKJg7n8yquagaspNY7xQt4jEpASewMBqpXCrfVFqm3
         ywsA==
X-Gm-Message-State: ACrzQf3Biw1kcXC3hQV+MF3Wnyzn3+7gqSEZO81a8nkL7FcgdsBp5QNp
        sK0NxPalmTFMrP28ks4yM200/+74KAt6EG6MSnbDoQ==
X-Google-Smtp-Source: AMsMyM6EAyx1KtBq0OHlzDt8j7V4mlXCOPhW8Hj5txMUS7MzkJ/ifqhgJuTqhiXpS5OjnWv66oRC+avZHCQHcpvS0VM=
X-Received: by 2002:a25:404:0:b0:6b0:21b0:44cc with SMTP id
 4-20020a250404000000b006b021b044ccmr26112980ybe.407.1664303928189; Tue, 27
 Sep 2022 11:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220927132753.750069-1-kuba@kernel.org> <CANn89iL4m=aMjZ1XWFNWDyyyDBF1uhNocN0OFqhm2VMm_JQOog@mail.gmail.com>
 <20220927111758.1d25ea0f@kernel.org>
In-Reply-To: <20220927111758.1d25ea0f@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 11:38:36 -0700
Message-ID: <CANn89iKujNcWC7jLRN_6cTCwadyt7Hid6i39i3g3gKwBUvGovg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: drop the weight argument from netif_napi_add
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        kvalo@kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
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

On Tue, Sep 27, 2022 at 11:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 27 Sep 2022 10:54:49 -0700 Eric Dumazet wrote:
> > On Tue, Sep 27, 2022 at 6:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > We tell driver developers to always pass NAPI_POLL_WEIGHT
> > > as the weight to netif_napi_add(). This may be confusing
> > > to newcomers, drop the weight argument, those who really
> > > need to tweak the weight can use netif_napi_add_weight().
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >
> > Sure, but this kind of patch makes backports harder.
> > Not sure how confused are newcomers about this NAPI_POLL_WEIGHT....
>
> I maintained this patch in my tree for a couple of releases (because
> I was waiting for the _weight() version to propagate to non-netdev
> trees) and the conflicts were minor. Three or so cases of new features
> added to drivers which touched the NAPI calls (WiFi and embedded) and
> the strlcpy -> strscpy patch, and, well, why did we take that in if we
> worry about backports...
>
> NAPI weight was already dead when I started hacking on the kernel
> 10 years ago. I don't think it's reasonable to keep dead stuff
> in our APIs for backport's sake. Adding Jiri to CC in case I need
> someone to back me up :)
>
> The idea for this patch came because I was reviewing a driver which
> was trying to do something clever with the weight.
>

No hard feelings, but the recent removal of netif_tx_napi_add() added
extra work for some of us ;)

Keeping around few helpers to keep API a bit stable would help I think.
