Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FAF68191D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbjA3S2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbjA3S23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:28:29 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9164673A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 10:26:32 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CC1A43F2F7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675103099;
        bh=8UFl0BB/+EqxZ0AY+dFboreesk9jsr8DPikFfJhc9vU=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=nv6qZb9NhEW6IP0t4328myPNYjSHPcT/DFO0IysVdYemcteWkb8GNU4rUm4mpplpY
         Md8JF+KgS0ELd0Zckbms27Taosht00TLdPcGBD5QJI1qWy7rvNJ/MUV1n7Wj5FP1IL
         9KUld5y7HqXWGE7RoKjpAmqzsLoTlOv+qDda0XAMHJG5g7acdoDER/fFLDrh+MRnsQ
         rU68buSSrObfAXTwmAhdqOxECWsoPOVKX4MAOfk8aShlgYlt6iyqhB41oRHtW5ERYK
         nLrOBqFEiZAdkMmfYUXKnw7GW6SSBwDhln2S/ruX1Ve9XiVVBv+GfJ3NPZPPc09Lzb
         SPV+JHlbZ7Cbw==
Received: by mail-wm1-f69.google.com with SMTP id bg24-20020a05600c3c9800b003db0ddddb6fso7617657wmb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 10:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UFl0BB/+EqxZ0AY+dFboreesk9jsr8DPikFfJhc9vU=;
        b=z5Z60aG14QL8pMRmgj2odbPc+lEPYx4gC5QbQvU7Iz67VgxWxHvJYUB8Uawfojqx+K
         n6t4ew1Bdu548a42wjPKt1pDL6ZV3O8o6G/3NrQWovaQNhRZLE6UrzHHynmiI0nFFeA2
         ymMMK9ggnyhT3JGBmqSXeOi3nL/TQBIGJf8d7BuD9LxrrLzaxxrFJWjau1/BpGJWi4cY
         i+33PT08xR3fo/qpL7OTZiFF/RaWhz85JyweY9dggvnTw+I0O/xghxu1TSEtHIOjpgkj
         LaFY4m5a13o1LekWjuJShk7fB6z3OE0xEQiPXd3vheCP3Qo28hGvkh8O1l0yNQqFq+K1
         C/wQ==
X-Gm-Message-State: AFqh2koRN0PkqF/DMVgOVfhKcT0U3r/4UTezyaFsnyGkUZnhfSsKbg68
        r+khrSvM1nSDlreg5lxXfKdmu7613/QXAjSm9yinj5cWBb5S7zf1lv5ljIgLTLfE7mvcnkyBHgZ
        bT2mh8o+bDxQCb2956SYVgzwPtzk0P/UO4A==
X-Received: by 2002:a05:6000:a03:b0:244:48b3:d138 with SMTP id co3-20020a0560000a0300b0024448b3d138mr49149895wrb.54.1675103099501;
        Mon, 30 Jan 2023 10:24:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuKKG26EhahK2hLJsrCzdr3xskHuWfLDgUO+X0LmvlGNXwEwfDzz4SrfD0/lShClsCgCJ2PmA==
X-Received: by 2002:a05:6000:a03:b0:244:48b3:d138 with SMTP id co3-20020a0560000a0300b0024448b3d138mr49149880wrb.54.1675103099250;
        Mon, 30 Jan 2023 10:24:59 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id q3-20020adff503000000b002bfae1398bbsm12789223wro.42.2023.01.30.10.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 10:24:58 -0800 (PST)
Date:   Mon, 30 Jan 2023 18:24:56 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Willem de Bruijn <willemb@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: udpgso_bench_tx: Introduce exponential
 back-off retries
Message-ID: <Y9gLeNqorZNQ1gjp@qwirkle>
References: <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle>
 <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle>
 <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle>
 <Y9fu7TR5VC33j+EP@qwirkle>
 <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
 <Y9f+7tMWMtPACLz9@qwirkle>
 <CA+FuTScThEWVevZ+KVgLOZ6zb4Ush6RtKL4FmC2cFMg+Q-OWpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScThEWVevZ+KVgLOZ6zb4Ush6RtKL4FmC2cFMg+Q-OWpw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 12:35PM, Willem de Bruijn wrote:
> On Mon, Jan 30, 2023 at 12:31 PM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > On 23/01/30 11:29AM, Willem de Bruijn wrote:
> > > On Mon, Jan 30, 2023 at 11:23 AM Andrei Gherzan
> > > <andrei.gherzan@canonical.com> wrote:
> > > >
> > > > On 23/01/30 04:15PM, Andrei Gherzan wrote:
> > > > > On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > > > > > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > >
> > > > > > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > > > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > >
> > > > > > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > > > > > least one of the following:
> > > > > > > > > > > >
> > > > > > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > > > > > >
> > > > > > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > > > > > >
> > > > > > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > > > > > >
> > > > > > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > > > > > >
> > > > > > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > > > > > go.
> > > > > > > > > >
> > > > > > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > > > > > alike what mptcp self-tests are doing.
> > > > > > > > >
> > > > > > > > > I like this idea. I have tested it and it works as expected with the
> > > > > > > > > exeception of:
> > > > > > > > >
> > > > > > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > > > > > >
> > > > > > > > > Any ideas on how to handle this? I could retry and that works.
> > > > > > > >
> > > > > > > > This happens (also) without the zerocopy flag, right? That
> > > > > > > >
> > > > > > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > > > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > > > > > expect this test to bump up against that limit.
> > > > > > > >
> > > > > > > > A few zerocopy specific reasons are captured in
> > > > > > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > > > > > >
> > > > > > > I have dug a bit more into this, and it does look like your hint was in
> > > > > > > the right direction. The fails I'm seeing are only with the zerocopy
> > > > > > > flag.
> > > > > > >
> > > > > > > From the reasons (doc) above I can only assume optmem limit as I've
> > > > > > > reproduced it with unlimited locked pages and the fails are transient.
> > > > > > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > > > > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > > > > > tests started to fail with something like:
> > > > > > >
> > > > > > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > > > > > expected    773707 received
> > > > > >
> > > > > > More zerocopy completions than number of sends. I have not seen this before.
> > > > > >
> > > > > > The completions are ranges of IDs, one per send call for datagram sockets.
> > > > > >
> > > > > > Even with segmentation offload, the counter increases per call, not per segment.
> > > > > >
> > > > > > Do you experience this without any other changes to udpgso_bench_tx.c.
> > > > > > Or are there perhaps additional sendmsg calls somewhere (during
> > > > > > initial sync) that are not accounted to num_sends?
> > > > >
> > > > > Indeed, that looks off. No, I have run into this without any changes in
> > > > > the tests (besides the retry routine in the shell script that waits for
> > > > > rx to come up). Also, as a data point.
> > > >
> > > > Actually wait. I don't think that is the case here. "expected" is the
> > > > number of sends. In this case we sent 1076 more messages than
> > > > completions. Am I missing something obvious?
> > >
> > > Oh indeed.
> > >
> > > Receiving fewer completions than transmission is more likely.
> >
> > Exactly, yes.
> >
> > > This should be the result of datagrams still being somewhere in the
> > > system. In a qdisc, or waiting for the network interface to return a
> > > completion notification, say.
> > >
> > > Does this remain if adding a longer wait before the final flush_errqueue?
> >
> > Yes and no. But not realiably unless I go overboard.
> >
> > > Or, really, the right fix is to keep polling there until the two are
> > > equal, up to some timeout. Currently flush_errqueue calls poll only
> > > once.
> >
> > That makes sense. I have implemented a retry and this ran for a good
> > while now.
> >
> > -               flush_errqueue(fd, true);
> > +               while (true) {
> > +                       flush_errqueue(fd, true);
> > +                       if ((stat_zcopies == num_sends) || (delay >= MAX_DELAY))
> > +                               break;
> > +                       usleep(delay);
> > +                       delay *= 2;
> > +               }
> >
> > What do you think?
> 
> Thanks for running experiments.
> 
> We can avoid the unconditional sleep, as the poll() inside
> flush_errqueue already takes a timeout.
> 
> One option is to use start_time = clock_gettime(..) or gettimeofday
> before poll, and restart poll until either the exit condition or
> timeout is reached, with timeout = orig_time - elapsed_time.

Yes, this was more of a quick draft. I was thinking to move it into the
flush function (while making it aware of num_sends via a parameter):

if (do_poll) {
  struct pollfd fds = {0};
  int ret;
  unsigned long tnow, tstop;

  fds.fd = fd;
  tnow = gettimeofday_ms();
  tstop = tnow + POLL_LOOP_TIMEOUT_MS;
  while ((stat_zcopies != num_sends) && (tnow < tstop)) {
    ret = poll(&fds, 1, 500);
    if (ret == 0) {
      if (cfg_verbose)
        fprintf(stderr, "poll timeout\n");
      } else if (ret < 0) {
        error(1, errno, "poll");
    }
    tnow = gettimeofday_ms();
  }
}

Does this make more sense?

-- 
Andrei Gherzan
