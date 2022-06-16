Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE30254E8BA
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiFPRlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFPRlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:41:19 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD0E43EEF
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:41:17 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id l9so716667uac.4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MhCxJsomFPv0etA9OwBx657A5+EQNQvXhWR2PLRDPYM=;
        b=hz2ZXDvh912fkpzzIT23pQAIhdt70f6VDtI8R6/O9TdK0+bQIbAAXY/TouLEkPOHUB
         atWfJhZmrH+5HchG6oXOt+FEcZqEqoRAxr5qv72CXXM7IQKc11XR4hVbxT+d5CsG0J7T
         4EN5wpS7QEp2iv+dl+DmSmgZjoZKNO9VaUIJR7ShFE8b4XNFER6/JlMA6IVhe3vFFn2r
         nEstytfosowB3lvCR8QAtIbvwszxqMmdI1Cih8LahUmtovxGOWSWcZ2zHZFJqdQKfo9P
         SmrSvfeiaX5n8N9WfhBzAkcpDdA2yKdr6K1kU84i7PYgVUjmmiaEHo+sxz9bygVZWadx
         RrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MhCxJsomFPv0etA9OwBx657A5+EQNQvXhWR2PLRDPYM=;
        b=YBaoUowb8KD1Sgpyck8E6BqlZjLeaocXzGClpnVT5S7GT/YV1FpqmVj21cpdqpA1ux
         dv1bveeP5ev/5u5pFBPIK2xV0txExfCmGovhf4jWJSrEst2fNuFTv7o+yrLom/aKNcEv
         /Ptxr67cDlLXfjxZRsB5KXxPYL+8HRNOVPNFTQFruvIafo6DSQ7CTQ1udytTsxCoHlxw
         Q4XNH0BXWTiafCY1mVAvTYLINBQd5IBgr7080b47/12UtJH3ZFvMXem0ZWzUvVWsvmbu
         C654BtdU7tta7y5akkxMTIq07L6vOuHPovAPBjJnnHt6nYYK51n8pLzi8FhSlVjJ0fQw
         md6A==
X-Gm-Message-State: AJIora+P/Lhzh0TtnDE5yyJ4lYxCMRSHVgmKFhrI6Z3hK3swcMgxp6N+
        K5IAUA5O6Y9Iu6cX0acqruha3Z7fa4CJt3W2MOc=
X-Google-Smtp-Source: AGRyM1sdfV/Nmk9QwVIzqvcVnkDD64IyAu7MTwL+4+l44JCDZtN8wqmEMf/Mea4wIpAQrG38OKGMdlC+a9xlUJq5nHM=
X-Received: by 2002:ab0:1343:0:b0:362:9e6c:74f5 with SMTP id
 h3-20020ab01343000000b003629e6c74f5mr2667645uae.15.1655401276735; Thu, 16 Jun
 2022 10:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
 <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
 <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
 <20220616101823.1a12e5d1@kernel.org> <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
In-Reply-To: <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 16 Jun 2022 10:41:05 -0700
Message-ID: <CAJnrk1YnGssapE0HCiwLd9DqDULVytYGT_TTqPJyXz1pRO5HtA@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 16, 2022 at 7:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 16 Jun 2022 12:01:36 +0200 Paolo Abeni wrote:
> > > > Do we really need to remove the test ? It is a benchmark, and should
> > > > not 'fail' on old kernels.
> > >
> > > I agree it's nice to keep the self-test alive.
> > >
> > > Side notes, not strictly related to the revert: the self test is not
> > > currently executed by `make run_tests` and requires some additional
> > > setup: ulimit -n <high number>, 2001:db8:0:f101::1 being a locally
> > > available address, and a mandatory command line argument.
> > >
> > > @Joanne: you should additionally provide a wrapper script to handle the
> > > above and update TEST_PROGS accordingly. As for this revert, could you
> > > please re-post it touching the kernel code only?
> >
> > Let me take the revert in for today's PR. Hope that's okay. We can
> > revive the test in -next with the wrapper/setup issue addressed.
> > I don't want more people to waste time bisecting the warnings this
> > generates.
I'll make sure to include a wrapper script when I resubmit it.
>
> Note we have missing Reported-... tags to please syzbot.
Jakub, please let me know if you want me to resubmit v2 of this with
the Reported- tag added, or if you'll add that part in.
