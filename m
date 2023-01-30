Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D56681AF0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbjA3T6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbjA3T6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:58:32 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE7344BD1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:58:29 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-506609635cbso175271967b3.4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i03ptR9fFLW5fJH/wPMLlxTLMbIyvVbZn3SkcwYrQcQ=;
        b=h6MFIKg7fj6u5OaxCTbe48QrqZ0u9cN6VLysxptuK+Kqer56MahV7CjI0JTVFB7kpb
         rBaWQWvRu5aXlSh9BruBKkUp3A3zH59k13A5wAgFAjilytkzbTwsYPlIZE8ZdjpFVHXO
         r2Jpn8Btx/a9kycJESwKJ03IiD4In3f8gJjeA/FTV2tTdHWtAgI1gRZFrx4ZRBRty3CZ
         168sBvYd+mSFh8DSsKZL3H+QJBBg8zCC5aDgy1hKHRS4fuXNjuxHUeFV54MSFYq5mJMt
         qEJvKmTROBgRjB2CQA1a6IQ0w+trzu3pG9Vyj1Udqu6j5b1kVUHGsoDbpFtJOpmjdjTo
         tUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i03ptR9fFLW5fJH/wPMLlxTLMbIyvVbZn3SkcwYrQcQ=;
        b=AevqcvHFzPBjCMga3aovVWtT6vWExxwiIRlDrTbsH9w7MTxOfgWm7zMkYQNGXgDyl4
         zgcn5qLgVk13WLz609e/qNJNVxAcPnluXHxRbbZViCBldlNOtds00RTOjlfHvxTh2oxm
         UOHfuXj7JrEB/vLiL4Vy3raBZdXYD2rKjtbR8a2hcxlwampoBK3Uq0K3RWH5gNjNSnyT
         jC4a5Ml0IgszcO+bRKdP+eKydnC2FDVp7RTtbyamKkiKIWb70m3jUsjMDQwaofCoktGx
         0G18Uu22J+pI8DRRWmPu80z43sMIwtSItPObRIuu4MLU9lTUu5tnAZxDA9ysPoXOgHP7
         JevQ==
X-Gm-Message-State: AO0yUKVA6oJiJKLPnYX44xiQuknPh8nfzHHJQURLm2bGD7Q/dfQspIlo
        k279DautVTAV2GMz1LtDlfvj2T3XZ1VIqTa/doAotg==
X-Google-Smtp-Source: AK7set+84QqUVzPLTgiujO7cFK7Mj/KcKfR0HfahV7rS2yXkT9qnaCG6qVPvGnsQLBs759QmRN/eDZLWvB/s8zvlrlo=
X-Received: by 2002:a81:254b:0:b0:519:6acb:f25a with SMTP id
 l72-20020a81254b000000b005196acbf25amr313652ywl.480.1675108708820; Mon, 30
 Jan 2023 11:58:28 -0800 (PST)
MIME-Version: 1.0
References: <Y9e9S3ENl0oszAH/@qwirkle> <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle> <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle> <Y9fu7TR5VC33j+EP@qwirkle> <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
 <Y9f+7tMWMtPACLz9@qwirkle> <CA+FuTScThEWVevZ+KVgLOZ6zb4Ush6RtKL4FmC2cFMg+Q-OWpw@mail.gmail.com>
 <Y9gLeNqorZNQ1gjp@qwirkle> <Y9gfpa7vks5Ndl8q@qwirkle>
In-Reply-To: <Y9gfpa7vks5Ndl8q@qwirkle>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 30 Jan 2023 14:57:52 -0500
Message-ID: <CA+FuTSckAeDGSBYE3bv2qR9cXpqac8Vmu6YxC1HTJx7YLY7gnQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: udpgso_bench_tx: Introduce exponential
 back-off retries
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 2:51 PM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> On 23/01/30 06:24PM, Andrei Gherzan wrote:
> > On 23/01/30 12:35PM, Willem de Bruijn wrote:
> > > On Mon, Jan 30, 2023 at 12:31 PM Andrei Gherzan
> > > <andrei.gherzan@canonical.com> wrote:
> > > >
> > > > On 23/01/30 11:29AM, Willem de Bruijn wrote:
> > > > > On Mon, Jan 30, 2023 at 11:23 AM Andrei Gherzan
> > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > >
> > > > > > On 23/01/30 04:15PM, Andrei Gherzan wrote:
> > > > > > > On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > > > > > > > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > >
> > > > > > > > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > > > > > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > > > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > > > > > > > least one of the following:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > > > > > > > >
> > > > > > > > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > > > > > > > go.
> > > > > > > > > > > >
> > > > > > > > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > > > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > > > > > > > alike what mptcp self-tests are doing.
> > > > > > > > > > >
> > > > > > > > > > > I like this idea. I have tested it and it works as expected with the
> > > > > > > > > > > exeception of:
> > > > > > > > > > >
> > > > > > > > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > > > > > > > >
> > > > > > > > > > > Any ideas on how to handle this? I could retry and that works.
> > > > > > > > > >
> > > > > > > > > > This happens (also) without the zerocopy flag, right? That
> > > > > > > > > >
> > > > > > > > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > > > > > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > > > > > > > expect this test to bump up against that limit.
> > > > > > > > > >
> > > > > > > > > > A few zerocopy specific reasons are captured in
> > > > > > > > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > > > > > > > >
> > > > > > > > > I have dug a bit more into this, and it does look like your hint was in
> > > > > > > > > the right direction. The fails I'm seeing are only with the zerocopy
> > > > > > > > > flag.
> > > > > > > > >
> > > > > > > > > From the reasons (doc) above I can only assume optmem limit as I've
> > > > > > > > > reproduced it with unlimited locked pages and the fails are transient.
> > > > > > > > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > > > > > > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > > > > > > > tests started to fail with something like:
> > > > > > > > >
> > > > > > > > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > > > > > > > expected    773707 received
> > > > > > > >
> > > > > > > > More zerocopy completions than number of sends. I have not seen this before.
> > > > > > > >
> > > > > > > > The completions are ranges of IDs, one per send call for datagram sockets.
> > > > > > > >
> > > > > > > > Even with segmentation offload, the counter increases per call, not per segment.
> > > > > > > >
> > > > > > > > Do you experience this without any other changes to udpgso_bench_tx.c.
> > > > > > > > Or are there perhaps additional sendmsg calls somewhere (during
> > > > > > > > initial sync) that are not accounted to num_sends?
> > > > > > >
> > > > > > > Indeed, that looks off. No, I have run into this without any changes in
> > > > > > > the tests (besides the retry routine in the shell script that waits for
> > > > > > > rx to come up). Also, as a data point.
> > > > > >
> > > > > > Actually wait. I don't think that is the case here. "expected" is the
> > > > > > number of sends. In this case we sent 1076 more messages than
> > > > > > completions. Am I missing something obvious?
> > > > >
> > > > > Oh indeed.
> > > > >
> > > > > Receiving fewer completions than transmission is more likely.
> > > >
> > > > Exactly, yes.
> > > >
> > > > > This should be the result of datagrams still being somewhere in the
> > > > > system. In a qdisc, or waiting for the network interface to return a
> > > > > completion notification, say.
> > > > >
> > > > > Does this remain if adding a longer wait before the final flush_errqueue?
> > > >
> > > > Yes and no. But not realiably unless I go overboard.
> > > >
> > > > > Or, really, the right fix is to keep polling there until the two are
> > > > > equal, up to some timeout. Currently flush_errqueue calls poll only
> > > > > once.
> > > >
> > > > That makes sense. I have implemented a retry and this ran for a good
> > > > while now.
> > > >
> > > > -               flush_errqueue(fd, true);
> > > > +               while (true) {
> > > > +                       flush_errqueue(fd, true);
> > > > +                       if ((stat_zcopies == num_sends) || (delay >= MAX_DELAY))
> > > > +                               break;
> > > > +                       usleep(delay);
> > > > +                       delay *= 2;
> > > > +               }
> > > >
> > > > What do you think?
> > >
> > > Thanks for running experiments.
> > >
> > > We can avoid the unconditional sleep, as the poll() inside
> > > flush_errqueue already takes a timeout.
> > >
> > > One option is to use start_time = clock_gettime(..) or gettimeofday
> > > before poll, and restart poll until either the exit condition or
> > > timeout is reached, with timeout = orig_time - elapsed_time.
> >
> > Yes, this was more of a quick draft. I was thinking to move it into the
> > flush function (while making it aware of num_sends via a parameter):
> >
> > if (do_poll) {
> >   struct pollfd fds = {0};
> >   int ret;
> >   unsigned long tnow, tstop;
> >
> >   fds.fd = fd;
> >   tnow = gettimeofday_ms();
> >   tstop = tnow + POLL_LOOP_TIMEOUT_MS;
> >   while ((stat_zcopies != num_sends) && (tnow < tstop)) {

The new condition to loop until stat_zcopies == num_sends should only
be tested on the final call. This likely needs to become a separate
boolean. Or a separate flush_errqueue_last() function, and leave the
existing one as is.

We can probably merge the outer for and inner while loops

> >     ret = poll(&fds, 1, 500);

Instead of 500, this becomes tstop - tnow.

> >     if (ret == 0) {
> >       if (cfg_verbose)
> >         fprintf(stderr, "poll timeout\n");

Poll timeouts are now expected to an extent. Only report once at the
end of the function if the poll was only called once and timed out.
> >       } else if (ret < 0) {
> >         error(1, errno, "poll");
> >     }
> >     tnow = gettimeofday_ms();
> >   }
> > }
> >
> > Does this make more sense?
>
> Obviously, this should be a do/while. Anyway, this works as expected
> after leaving it for a around two hours.

Great to hear you found the cause.
