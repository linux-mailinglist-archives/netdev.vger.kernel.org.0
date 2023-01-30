Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFCC6817C2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbjA3Rg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjA3RgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:36:12 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73DB27987
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:36:09 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-501c3a414acso169565397b3.7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m+5Aco0qJCfrl4zWbm7ukbBqx/x43FIwAWY/ybuRrqI=;
        b=bdycXBOQINEbS113o8JEyrzMPdFlzQOmfLSpaMUiZ+lMv+zso8J8z/FI8ZEiBn6wd5
         xIgAjY4Vb/qUW7MchSR+CQQPlatCda/HlsMNg9bZr0q+x35137cmOLHLJ3UE8onsa1b7
         B4F16g8JNvYZmqiLq18K0iqM+z3oyoXmynPpdmwyK3nqlmDO+gymqAV3AHSYqimYnoUz
         bZCsx20/SzGLeSxm6DAuwomlygUWVDu/QXwltZ6DPcMX3HpiaQts6IGAC0T/d3Gyq4I6
         K3hZsyxKbOIAFN/Pn4GSZ0svo6tdbYywiGZjy1tSmPhIXcB68tpGXqAw0RgBex0bgXt3
         LACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+5Aco0qJCfrl4zWbm7ukbBqx/x43FIwAWY/ybuRrqI=;
        b=upgabOrBgyJ846FFsDsVj/GW6nSTMK4TIwJ08OQSzk0wtIbMeX1J98bIE+fzBVDt78
         k5dBdFui4h3BELcH+qOgMsDkXf1UqusZS7kHX2LOtc2uoRxHZ72BOoOYCOa70qNGOxV2
         HiSLCkUo2vgI4pI9dsN+g5Q4za7kowOkDq69vMxe6sHb7nldLbVEDXPBQGmzXRLMHi6R
         vSPFFouNiX5Fm56mwtOLb+3RW7Bez5J53rMkuEZCM2SPOQgEMNqivGWfXsw6egDSxXUq
         RL7E2sgGyzJaf6O//nYDJmp5mHxQ3xi3MxglGlTGDddHDV33MSeu24+Ktw3xAE+WLezg
         scLQ==
X-Gm-Message-State: AO0yUKXnVz5b+gayyxbnHzbBFSJa3xJIhwL+fzpa0T94vUiwOeiNlUF8
        3V67g4ThM8BxjlD5Dj2dlyaiEvMm46yJQ/D9tJFN+lUDAuIf2Wpr
X-Google-Smtp-Source: AK7set+mBVQNfOo6ofzK74WnaA1MGiOk8evHZw8JoooCHjIvy3U9JUMFKEi3QSqmGlewen3tku4fjGLsfrBTIjg5yF8=
X-Received: by 2002:a81:dce:0:b0:508:a938:b992 with SMTP id
 197-20020a810dce000000b00508a938b992mr1985127ywn.184.1675100168821; Mon, 30
 Jan 2023 09:36:08 -0800 (PST)
MIME-Version: 1.0
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle> <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle> <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle> <Y9fu7TR5VC33j+EP@qwirkle> <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
 <Y9f+7tMWMtPACLz9@qwirkle>
In-Reply-To: <Y9f+7tMWMtPACLz9@qwirkle>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 30 Jan 2023 12:35:32 -0500
Message-ID: <CA+FuTScThEWVevZ+KVgLOZ6zb4Ush6RtKL4FmC2cFMg+Q-OWpw@mail.gmail.com>
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

On Mon, Jan 30, 2023 at 12:31 PM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> On 23/01/30 11:29AM, Willem de Bruijn wrote:
> > On Mon, Jan 30, 2023 at 11:23 AM Andrei Gherzan
> > <andrei.gherzan@canonical.com> wrote:
> > >
> > > On 23/01/30 04:15PM, Andrei Gherzan wrote:
> > > > On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > > > > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > >
> > > > > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > >
> > > > > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > > > > least one of the following:
> > > > > > > > > > >
> > > > > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > > > > >
> > > > > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > > > > >
> > > > > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > > > > >
> > > > > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > > > > >
> > > > > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > > > > go.
> > > > > > > > >
> > > > > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > > > > alike what mptcp self-tests are doing.
> > > > > > > >
> > > > > > > > I like this idea. I have tested it and it works as expected with the
> > > > > > > > exeception of:
> > > > > > > >
> > > > > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > > > > >
> > > > > > > > Any ideas on how to handle this? I could retry and that works.
> > > > > > >
> > > > > > > This happens (also) without the zerocopy flag, right? That
> > > > > > >
> > > > > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > > > > expect this test to bump up against that limit.
> > > > > > >
> > > > > > > A few zerocopy specific reasons are captured in
> > > > > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > > > > >
> > > > > > I have dug a bit more into this, and it does look like your hint was in
> > > > > > the right direction. The fails I'm seeing are only with the zerocopy
> > > > > > flag.
> > > > > >
> > > > > > From the reasons (doc) above I can only assume optmem limit as I've
> > > > > > reproduced it with unlimited locked pages and the fails are transient.
> > > > > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > > > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > > > > tests started to fail with something like:
> > > > > >
> > > > > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > > > > expected    773707 received
> > > > >
> > > > > More zerocopy completions than number of sends. I have not seen this before.
> > > > >
> > > > > The completions are ranges of IDs, one per send call for datagram sockets.
> > > > >
> > > > > Even with segmentation offload, the counter increases per call, not per segment.
> > > > >
> > > > > Do you experience this without any other changes to udpgso_bench_tx.c.
> > > > > Or are there perhaps additional sendmsg calls somewhere (during
> > > > > initial sync) that are not accounted to num_sends?
> > > >
> > > > Indeed, that looks off. No, I have run into this without any changes in
> > > > the tests (besides the retry routine in the shell script that waits for
> > > > rx to come up). Also, as a data point.
> > >
> > > Actually wait. I don't think that is the case here. "expected" is the
> > > number of sends. In this case we sent 1076 more messages than
> > > completions. Am I missing something obvious?
> >
> > Oh indeed.
> >
> > Receiving fewer completions than transmission is more likely.
>
> Exactly, yes.
>
> > This should be the result of datagrams still being somewhere in the
> > system. In a qdisc, or waiting for the network interface to return a
> > completion notification, say.
> >
> > Does this remain if adding a longer wait before the final flush_errqueue?
>
> Yes and no. But not realiably unless I go overboard.
>
> > Or, really, the right fix is to keep polling there until the two are
> > equal, up to some timeout. Currently flush_errqueue calls poll only
> > once.
>
> That makes sense. I have implemented a retry and this ran for a good
> while now.
>
> -               flush_errqueue(fd, true);
> +               while (true) {
> +                       flush_errqueue(fd, true);
> +                       if ((stat_zcopies == num_sends) || (delay >= MAX_DELAY))
> +                               break;
> +                       usleep(delay);
> +                       delay *= 2;
> +               }
>
> What do you think?

Thanks for running experiments.

We can avoid the unconditional sleep, as the poll() inside
flush_errqueue already takes a timeout.

One option is to use start_time = clock_gettime(..) or gettimeofday
before poll, and restart poll until either the exit condition or
timeout is reached, with timeout = orig_time - elapsed_time.
