Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1951682D74
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjAaNLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjAaNLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:11:25 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678503AAB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:10:51 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2679C41AC9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675170650;
        bh=Q741xVNPxljikF40G1tYF49pa5Q5XmgVMznZqucbJ7U=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=fAca59CdFOSnI/YHCepxXwoKlsHzm+RNDZyqzd3kFwhrLQklSAVekOSa7uDlOnjzm
         JZEWQWTjVnvCr3KDmLqr5oLH+jprmRUdg3U0WkB+aW5gaG39JSy4f5j3CnSrFabq2s
         RAi7/ozAa6yU4RxFhamOANCuGWe2nOjXqmWew6DtqQI+XtqfCKzIPsVaLSSgbJoZ+R
         kjYy67aGFAZsplJQu93bL4kWKZBkpmLY82idjtmP6JrpmnFHQ+Gsgi3RB8bDDLvoAR
         9Ep/yEPFODkTGWDPZlhz89qgGrbK4WSPm45fotYh43KxaNLUWrnbLbZld5Fix/cTR1
         /Al3OU7Vj4erw==
Received: by mail-wm1-f70.google.com with SMTP id n7-20020a05600c3b8700b003dc55dcb298so3391420wms.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:10:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q741xVNPxljikF40G1tYF49pa5Q5XmgVMznZqucbJ7U=;
        b=5lfVU4I5sk31f8dJNTeZlxI/QzRBgzmiJ1DMgs2H3DndGljU1m1hoorLfh2GVLtlw0
         2b6OKmyiaGwe4QPRxtbQPYtimM7b6ly+UxktTFNUo9q10yZnylTIv4FvHuLRjNgXTD9s
         S8MzItY9G4rFF4HpHKT9m9h7I0STBJcoty3f3ql/ezRKEx+8LDqBIHXmzk2/eLubt87K
         oevZWHYwiye1iLLWBGZo95YY4BF/oGE1F3DwdfukifSTcN9/LNotobZYemzTb6lZN7ql
         E/VZPfRT4/ifToUK54jj2lQquDjWz87JLx3V9PYG6XrUBCh9Y7YVOfGp0TD5yG555Bhj
         ZH6Q==
X-Gm-Message-State: AO0yUKXwLQyKShf9xWSU6/YvWDbF/5In/aIMvUjUCufsGTKUgGcvCCdB
        AQNveMEKjGlZT9HsL0Hrl5KjLokJKp0y0Pz34ddVQ9bX/GMfU+DIEo2uUDNQ9JvMPMBEZX0PUVy
        WH991CjQj1Ro9xFKEeFhLEf1D75NT4Z1lAw==
X-Received: by 2002:a05:600c:4b1c:b0:3dc:5bd7:62ec with SMTP id i28-20020a05600c4b1c00b003dc5bd762ecmr6352551wmp.32.1675170645253;
        Tue, 31 Jan 2023 05:10:45 -0800 (PST)
X-Google-Smtp-Source: AK7set9Ugoyg1AvpTA39S5u6IM1/+onmzCaM4fhfsMAW0FXiPhLGAHpTn5QJOXYOy3L9Jftn4bO8uQ==
X-Received: by 2002:a05:600c:4b1c:b0:3dc:5bd7:62ec with SMTP id i28-20020a05600c4b1c00b003dc5bd762ecmr6352527wmp.32.1675170644924;
        Tue, 31 Jan 2023 05:10:44 -0800 (PST)
Received: from qwirkle ([2001:67c:1560:8007::aac:c4dd])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600c354100b003dc4050c97bsm2331886wmq.3.2023.01.31.05.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 05:10:44 -0800 (PST)
Date:   Tue, 31 Jan 2023 13:10:42 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: udpgso_bench_tx: Introduce exponential
 back-off retries
Message-ID: <Y9kTUlJLO/H0rbhp@qwirkle>
References: <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle>
 <Y9fu7TR5VC33j+EP@qwirkle>
 <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
 <Y9f+7tMWMtPACLz9@qwirkle>
 <CA+FuTScThEWVevZ+KVgLOZ6zb4Ush6RtKL4FmC2cFMg+Q-OWpw@mail.gmail.com>
 <Y9gLeNqorZNQ1gjp@qwirkle>
 <Y9gfpa7vks5Ndl8q@qwirkle>
 <CA+FuTSckAeDGSBYE3bv2qR9cXpqac8Vmu6YxC1HTJx7YLY7gnQ@mail.gmail.com>
 <Y9gnqNnkiPEw+Pp8@qwirkle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9gnqNnkiPEw+Pp8@qwirkle>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 08:25PM, Andrei Gherzan wrote:
> On 23/01/30 02:57PM, Willem de Bruijn wrote:
> > On Mon, Jan 30, 2023 at 2:51 PM Andrei Gherzan
> > <andrei.gherzan@canonical.com> wrote:
> > >
> > > On 23/01/30 06:24PM, Andrei Gherzan wrote:
> > > > On 23/01/30 12:35PM, Willem de Bruijn wrote:
> > > > > On Mon, Jan 30, 2023 at 12:31 PM Andrei Gherzan
> > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > >
> > > > > > On 23/01/30 11:29AM, Willem de Bruijn wrote:
> > > > > > > On Mon, Jan 30, 2023 at 11:23 AM Andrei Gherzan
> > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > >
> > > > > > > > On 23/01/30 04:15PM, Andrei Gherzan wrote:
> > > > > > > > > On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > > > > > > > > > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > > > > > > > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > > > > > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > > > > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > > > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > > > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > > > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > > > > > > > > > least one of the following:
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > > > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > > > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > > > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > > > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > > > > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > > > > > > > > > go.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > > > > > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > > > > > > > > > alike what mptcp self-tests are doing.
> > > > > > > > > > > > >
> > > > > > > > > > > > > I like this idea. I have tested it and it works as expected with the
> > > > > > > > > > > > > exeception of:
> > > > > > > > > > > > >
> > > > > > > > > > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > > > > > > > > > >
> > > > > > > > > > > > > Any ideas on how to handle this? I could retry and that works.
> > > > > > > > > > > >
> > > > > > > > > > > > This happens (also) without the zerocopy flag, right? That
> > > > > > > > > > > >
> > > > > > > > > > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > > > > > > > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > > > > > > > > > expect this test to bump up against that limit.
> > > > > > > > > > > >
> > > > > > > > > > > > A few zerocopy specific reasons are captured in
> > > > > > > > > > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > > > > > > > > > >
> > > > > > > > > > > I have dug a bit more into this, and it does look like your hint was in
> > > > > > > > > > > the right direction. The fails I'm seeing are only with the zerocopy
> > > > > > > > > > > flag.
> > > > > > > > > > >
> > > > > > > > > > > From the reasons (doc) above I can only assume optmem limit as I've
> > > > > > > > > > > reproduced it with unlimited locked pages and the fails are transient.
> > > > > > > > > > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > > > > > > > > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > > > > > > > > > tests started to fail with something like:
> > > > > > > > > > >
> > > > > > > > > > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > > > > > > > > > expected    773707 received
> > > > > > > > > >
> > > > > > > > > > More zerocopy completions than number of sends. I have not seen this before.
> > > > > > > > > >
> > > > > > > > > > The completions are ranges of IDs, one per send call for datagram sockets.
> > > > > > > > > >
> > > > > > > > > > Even with segmentation offload, the counter increases per call, not per segment.
> > > > > > > > > >
> > > > > > > > > > Do you experience this without any other changes to udpgso_bench_tx.c.
> > > > > > > > > > Or are there perhaps additional sendmsg calls somewhere (during
> > > > > > > > > > initial sync) that are not accounted to num_sends?
> > > > > > > > >
> > > > > > > > > Indeed, that looks off. No, I have run into this without any changes in
> > > > > > > > > the tests (besides the retry routine in the shell script that waits for
> > > > > > > > > rx to come up). Also, as a data point.
> > > > > > > >
> > > > > > > > Actually wait. I don't think that is the case here. "expected" is the
> > > > > > > > number of sends. In this case we sent 1076 more messages than
> > > > > > > > completions. Am I missing something obvious?
> > > > > > >
> > > > > > > Oh indeed.
> > > > > > >
> > > > > > > Receiving fewer completions than transmission is more likely.
> > > > > >
> > > > > > Exactly, yes.
> > > > > >
> > > > > > > This should be the result of datagrams still being somewhere in the
> > > > > > > system. In a qdisc, or waiting for the network interface to return a
> > > > > > > completion notification, say.
> > > > > > >
> > > > > > > Does this remain if adding a longer wait before the final flush_errqueue?
> > > > > >
> > > > > > Yes and no. But not realiably unless I go overboard.
> > > > > >
> > > > > > > Or, really, the right fix is to keep polling there until the two are
> > > > > > > equal, up to some timeout. Currently flush_errqueue calls poll only
> > > > > > > once.
> > > > > >
> > > > > > That makes sense. I have implemented a retry and this ran for a good
> > > > > > while now.
> > > > > >
> > > > > > -               flush_errqueue(fd, true);
> > > > > > +               while (true) {
> > > > > > +                       flush_errqueue(fd, true);
> > > > > > +                       if ((stat_zcopies == num_sends) || (delay >= MAX_DELAY))
> > > > > > +                               break;
> > > > > > +                       usleep(delay);
> > > > > > +                       delay *= 2;
> > > > > > +               }
> > > > > >
> > > > > > What do you think?
> > > > >
> > > > > Thanks for running experiments.
> > > > >
> > > > > We can avoid the unconditional sleep, as the poll() inside
> > > > > flush_errqueue already takes a timeout.
> > > > >
> > > > > One option is to use start_time = clock_gettime(..) or gettimeofday
> > > > > before poll, and restart poll until either the exit condition or
> > > > > timeout is reached, with timeout = orig_time - elapsed_time.
> > > >
> > > > Yes, this was more of a quick draft. I was thinking to move it into the
> > > > flush function (while making it aware of num_sends via a parameter):
> > > >
> > > > if (do_poll) {
> > > >   struct pollfd fds = {0};
> > > >   int ret;
> > > >   unsigned long tnow, tstop;
> > > >
> > > >   fds.fd = fd;
> > > >   tnow = gettimeofday_ms();
> > > >   tstop = tnow + POLL_LOOP_TIMEOUT_MS;
> > > >   while ((stat_zcopies != num_sends) && (tnow < tstop)) {
> > 
> > The new condition to loop until stat_zcopies == num_sends should only
> > be tested on the final call. This likely needs to become a separate
> > boolean. Or a separate flush_errqueue_last() function, and leave the
> > existing one as is.
> 
> Wouldn't a do/while be enough here?
> 
> > 
> > We can probably merge the outer for and inner while loops
> > 
> > > >     ret = poll(&fds, 1, 500);
> > 
> > Instead of 500, this becomes tstop - tnow.
> 
> Right. Missed this one.
> 
> > 
> > > >     if (ret == 0) {
> > > >       if (cfg_verbose)
> > > >         fprintf(stderr, "poll timeout\n");
> > 
> > Poll timeouts are now expected to an extent. Only report once at the
> > end of the function if the poll was only called once and timed out.
> 
> I had to think about this a bit but now I see your point and it makes
> sense.
> 
> > > >       } else if (ret < 0) {
> > > >         error(1, errno, "poll");
> > > >     }
> > > >     tnow = gettimeofday_ms();
> > > >   }
> > > > }
> > > >
> > > > Does this make more sense?
> > >
> > > Obviously, this should be a do/while. Anyway, this works as expected
> > > after leaving it for a around two hours.
> > 
> > Great to hear you found the cause.
> 
> Hats off for hints.

I have pushed a new version with a couple of other changes here and
there.

https://lore.kernel.org/netdev/20230131130412.432549-1-andrei.gherzan@canonical.com/T/#t

Paolo, for the synchronisation implementation I took your advice.

Looking forward for your feedback.

-- 
Andrei Gherzan
