Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5795254E89F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiFPR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiFPR3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:29:02 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4DF218E
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:29:01 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 23so3304692ybe.8
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dM86s0VEgObqkoGAsL3o8XRqIS/tqPc4BKiBDoflWAQ=;
        b=eGsLxvIsB8pjt/fdBCOdKt1js7gwNjGWSV0zHnexwWzDOPLMARR5YLb07I7s72JisX
         dg3J0dEDzbU764bqODzfUfEVd+ukMdV2s+ErjqamSopKzJuGSTAMZ0V5gHFwC7VIEAtS
         D8YthWb2K/+veotykfvjF9rPdYq0YK3lPDOd5SFob4W16btI71mKOpaD2BRoUbfB3Pzs
         H+U0vIqL3k2M0F3NDMh8J5BdwT/9y1QxVcCZh191oxAUJmxZWzoD/FDHKWhGppWg3oWS
         OGeMZR1SZKLXyIMnPTtkhFrJ39agwSTXRFWsN0lGPqyzaSXB8XklCldGqqNJflfc6pLs
         mw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dM86s0VEgObqkoGAsL3o8XRqIS/tqPc4BKiBDoflWAQ=;
        b=Z7KGekxjE4W03LZIyvUdrXTKsJRJFR142FMFRosnAqePxb3mNNgY4MvLa+lVCXPGt3
         8x7YfOAyUv+HYKbG5bxfbckUam2KdIWqKK9hjk6gUo5NRipgEX0a3THavfmR4g/hqdPV
         PSzWtmhyuKj8Cwa0Kh2o8WcMwcjJiYdU6ii5dTcGxCpcyNS/aRd3/rAA0i7Jg0F3SNv8
         3ketd7UO7xh52fNat+S6fdoWgga5u8q9/p27s4MVpyqEpVBtCe+qjykpSSJNanPg6Wi+
         NXEhpHFQK1580DbCMktL/ykSmPzpKQqAMu5TmQWGWM5vwSIOkliC4QIk/IEL4gZQqcr+
         K1mw==
X-Gm-Message-State: AJIora9hC7DUb83/l5LAEoc4XA5tKOF/L5JkzYAyAZ89O6xQCQLXOjgO
        YDxHzF4eQD0YWs8eblN7x9hWBCuoeRsmuDAmUJhqHw==
X-Google-Smtp-Source: AGRyM1ttL8fYlONj5bjJp992Hije9TsR1YOOnvrAcC5XGJexdAoQnDlmyZt45myzdofDWisaHZRqp8opkfcd8L5KBdc=
X-Received: by 2002:a25:d649:0:b0:65c:9e37:8bb3 with SMTP id
 n70-20020a25d649000000b0065c9e378bb3mr6605476ybg.387.1655400540420; Thu, 16
 Jun 2022 10:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
 <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
 <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com> <20220616101823.1a12e5d1@kernel.org>
In-Reply-To: <20220616101823.1a12e5d1@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Jun 2022 19:28:49 +0200
Message-ID: <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 7:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Jun 2022 12:01:36 +0200 Paolo Abeni wrote:
> > > Do we really need to remove the test ? It is a benchmark, and should
> > > not 'fail' on old kernels.
> >
> > I agree it's nice to keep the self-test alive.
> >
> > Side notes, not strictly related to the revert: the self test is not
> > currently executed by `make run_tests` and requires some additional
> > setup: ulimit -n <high number>, 2001:db8:0:f101::1 being a locally
> > available address, and a mandatory command line argument.
> >
> > @Joanne: you should additionally provide a wrapper script to handle the
> > above and update TEST_PROGS accordingly. As for this revert, could you
> > please re-post it touching the kernel code only?
>
> Let me take the revert in for today's PR. Hope that's okay. We can
> revive the test in -next with the wrapper/setup issue addressed.
> I don't want more people to waste time bisecting the warnings this
> generates.

Note we have missing Reported-... tags to please syzbot.
