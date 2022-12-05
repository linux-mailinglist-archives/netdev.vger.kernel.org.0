Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9E642347
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiLEHBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiLEHAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:00:48 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C118DBF78
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:00:46 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3c21d6e2f3aso108246787b3.10
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 23:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=coRXOHRNz//WTvn8iz/sAzTb1yJBt0dUNQrHlt2mpPs=;
        b=cp2c4vLvpDWA0mcSMbgN+VRWTA9DqaDSNKkxVBxIu7MdTZray7sSNLrIl20bdFnlL0
         KuswNgOgKZuar9qFfg3zDSP4eB3V30hL4u4a+vthyZ1dLzDdOwLeqFzDA1SxC2oD2F/K
         c5K1UCDm42XTnU8MaTGaMgVCR9zjcLmPb/VNuXAGVsFac9utRPXA7IvkYQ1vxJtAhX/z
         PkdIujfBoBkGmeir5HfFGNu1a0u5KsmdQEUE0YEc2CvTj7XseBcUhWCeqaREWYmEz8Ow
         6Hivt5EJmmtmp6I60cJKxtybuRswUNjkPAK69gPiKXRrGAl++llFBfg3Fyh5/C2ZxsSz
         xquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=coRXOHRNz//WTvn8iz/sAzTb1yJBt0dUNQrHlt2mpPs=;
        b=XFWPN3L0G7rADH+XkXF78Q1G46HDuHRC7BXynSF/cjGdSfZZ3qZ89KdOrOcji3Sxlv
         TnGfXCL6ABnPFzUXiT/oe4NQdhTUSABNT1gX8Pv+zGs98L0l2kTxZJvVNhsg5Ws3qWV+
         Op85V69GQezZK3QYCSxken1OgJ8RdsVXXAN4MPSJj5m/Zajak6qQVAp28yqva5Nl++he
         jlNpIyTGPLRjR6GssSTJPDEWDrTivoFLkDkrw3X5CTDf63m4c0LU/P1Z2TpXcjiBm8JR
         l5qtPnZpm9pJfIOs6Jf8LAG6osyRrsO9dSyONy2qHFaCwml2XHVoYzYIaLvaioHUR3L2
         u3yg==
X-Gm-Message-State: ANoB5pmKujJlI2k0bqFTEhVlSIOV+1/k5YpEDMcl/rXtoYhF8rWASTjz
        2QfQndih+86DN+xHO/JQrjucJHHfYE2i/sNkO7h82g==
X-Google-Smtp-Source: AA0mqf4ZStaU2n0mz3tYU7jDd0FFF3gERFNnwStcE0ObpDr+z9rd9bCvhr7OcdlOgWqCo28NPuV1ZIRM2HRWjs21t78=
X-Received: by 2002:a81:1915:0:b0:3bf:9e45:1139 with SMTP id
 21-20020a811915000000b003bf9e451139mr39230763ywz.267.1670223645646; Sun, 04
 Dec 2022 23:00:45 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
 <Y4e3WC4UYtszfFBe@codewreck.org> <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
 <Y4ttC/qESg7Np9mR@codewreck.org> <CANpmjNNcY0LQYDuMS2pG2R3EJ+ed1t7BeWbLK2MNxnzPcD=wZw@mail.gmail.com>
 <Y4vW4CncDucES8m+@codewreck.org>
In-Reply-To: <Y4vW4CncDucES8m+@codewreck.org>
From:   Marco Elver <elver@google.com>
Date:   Mon, 5 Dec 2022 08:00:00 +0100
Message-ID: <CANpmjNPXhEB6GeMT70UT1e-8zTHf3gY21E3wx-27VjChQ0x2gA@mail.gmail.com>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb / p9_client_rpc
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
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

On Sun, 4 Dec 2022 at 00:08, Dominique Martinet <asmadeus@codewreck.org> wrote:
>
> Marco Elver wrote on Sat, Dec 03, 2022 at 05:46:46PM +0100:
> > > But I can't really find a problem with what KCSAN complains about --
> > > we are indeed accessing status from two threads without any locks.
> > > Instead of a lock, we're using a barrier so that:
> > >  - recv thread/cb: writes to req stuff || write to req status
> > >  - p9_client_rpc: reads req status || reads other fields from req
> > >
> > > Which has been working well enough (at least, without the barrier things
> > > blow up quite fast).
> > >
> > > So can I'll just consider this a false positive, but if someone knows
> > > how much one can read into this that'd be appreciated.
> >
> > The barriers only ensure ordering, but not atomicity of the accesses
> > themselves (for one, the compiler is well in its right to transform
> > plain accesses in ways that the concurrent algorithm wasn't designed
> > for). In this case it looks like it's just missing
> > READ_ONCE()/WRITE_ONCE().
>
> Aha! Thanks for this!
>
> I've always believed plain int types accesses are always atomic and the
> only thing to watch for would be compilers reordering instrucions, which
> would be ensured by the barrier in this case, but I guess there are some
> architectures or places where this isn't true?
>
>
> I'm a bit confused though, I can only see five places where wait_event*
> functions use READ_ONCE and I believe they more or less all would
> require such a marker -- I guess non-equality checks might be safe
> (waiting for a value to change from a known value) but if non-atomic
> updates are on the table equality and comparisons checks all would need
> to be decorated with READ_ONCE; afaiu, unlike usespace loops with
> pthread_cond_wait there is nothing protecting the condition itself.
>
> Should I just update the wrapped condition, as below?
>
> -       err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
> +       err = wait_event_killable(req->wq,
> +                                 READ_ONCE(req->status) >= REQ_STATUS_RCVD);

Yes, this looks good!

> The writes all are straightforward, there's all the error paths to
> convert to WRITE_ONCE too but that's not difficult (leaving only the
> init without such a marker); I'll send a patch when you've confirmed the
> read looks good.
> (the other reads are a bit less obvious as some are protected by a lock
> in trans_fd, which should cover all cases of possible concurrent updates
> there as far as I can see, but this mixed model is definitely hard to
> reason with... Well, that's how it was written and I won't ever have time
> to rewrite any of this. Enough ranting.)

If the lock-protected accesses indeed are non-racy, they should be
left unmarked. If some assumption here turns out to be wrong, KCSAN
would (hopefully) tell us one way or another.

Thanks!

-- Marco
