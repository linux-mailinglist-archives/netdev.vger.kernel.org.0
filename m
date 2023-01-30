Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC44681626
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbjA3QPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjA3QPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:15:51 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AC92136
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:15:49 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 81F8C3F2F6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675095346;
        bh=PhHq+Ycbej3d4KYhLJP72cMynQrcbDuGLZK2reA+9Qc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=KB+cI2s7czhIKx9ZhMPL3+nxSk4tAcKD38br48QNBG/TkMH/O2AK+CqPRRNaZioWk
         dxy7zN3Feoarhxyt7j8eMeY25S3OHbHlK/aL/xZTMvIop4WAJFuhrWIoKfKelXriDm
         C2/BkjSravZqG8NlKID5PmbsYQmnRLJYTyRS8DWbV6t1rT1adoV6ZKe9WozX1wbm1w
         zz3fNalBM1B15U6RX4JSyscWEi4IqmU45nFES8XrQ8AQaqez8RX634pvb+aTlCITw1
         dENG69+9YHC3jWnuhUz0QIFr1zg8h977F9zIF4R6hsrzMcD0wM+db5vJ1u0WTxN0U4
         Y6murrpzuEW7g==
Received: by mail-wm1-f70.google.com with SMTP id j24-20020a05600c1c1800b003dc4480f7bdso4747678wms.5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PhHq+Ycbej3d4KYhLJP72cMynQrcbDuGLZK2reA+9Qc=;
        b=hO+LLO4sk61nmCzaZ5ifmd1gEd14+9wV5wxEVnT/crwe704qLADP7vEq7dWvowda2s
         Ge4c4PJRVrfcagw09GZOKb9yDiQzXJSq7/4KL+7a6X+jot/p7OvJyrcKhUZiWFboVZx+
         V+umBKKNjZBaFAjuYLcbymxZnDO1sUUR30Yuj83s2nNMk6kdv37RsTHztmGltKldqb6x
         VOovbg//p45BDsCZGXqCN7wz9ev8vdT67JuHwX+d/CmTCcAEHBjNDPt4WPFG1iOXaLZD
         5ruMNOK1ZO4tJ6LIa9np8CVYqkWGFnd1htdCkBimkD8ikLiRwiUOL/vT/DAIXuwQSP1t
         dFjQ==
X-Gm-Message-State: AO0yUKVN80u6sB4CIvwy797Jd4SVQYQtSOUR7PCWhiqTH4Y7xXzDR0cZ
        Pc1Sy/LJ6Bm1l0onJyUqZhfqj6ZKwVleRXXoCAf/OMAtIiTV33+yZ47vQZhhenuzusbLdi8a6f9
        YslK1euLntaf8ZOxsRU9KsLsfK39zQbcrfw==
X-Received: by 2002:a05:600c:ad4:b0:3dc:47d4:58d2 with SMTP id c20-20020a05600c0ad400b003dc47d458d2mr5114wmr.25.1675095346210;
        Mon, 30 Jan 2023 08:15:46 -0800 (PST)
X-Google-Smtp-Source: AK7set9fyJTl68upM4rfOAOBzxTOsPvwzOjZLDdq0b4y3tuA36UHt2WfvdM1Z7LBWRpq9EvqbsBWRA==
X-Received: by 2002:a05:600c:ad4:b0:3dc:47d4:58d2 with SMTP id c20-20020a05600c0ad400b003dc47d458d2mr5091wmr.25.1675095346028;
        Mon, 30 Jan 2023 08:15:46 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id m14-20020a5d6a0e000000b002bfd09f2ca6sm10363418wru.3.2023.01.30.08.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 08:15:45 -0800 (PST)
Date:   Mon, 30 Jan 2023 16:15:43 +0000
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
Message-ID: <Y9ftL5c4klThCi9Q@qwirkle>
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle>
 <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle>
 <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 11:03AM, Willem de Bruijn wrote:
> On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > <andrei.gherzan@canonical.com> wrote:
> > > >
> > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > >
> > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > least one of the following:
> > > > > > >
> > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > >
> > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > >
> > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > >
> > > > > > Synchronizing the two processes is indeed tricky.
> > > > > >
> > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > go.
> > > > >
> > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > alike what mptcp self-tests are doing.
> > > >
> > > > I like this idea. I have tested it and it works as expected with the
> > > > exeception of:
> > > >
> > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > >
> > > > Any ideas on how to handle this? I could retry and that works.
> > >
> > > This happens (also) without the zerocopy flag, right? That
> > >
> > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > expect this test to bump up against that limit.
> > >
> > > A few zerocopy specific reasons are captured in
> > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> >
> > I have dug a bit more into this, and it does look like your hint was in
> > the right direction. The fails I'm seeing are only with the zerocopy
> > flag.
> >
> > From the reasons (doc) above I can only assume optmem limit as I've
> > reproduced it with unlimited locked pages and the fails are transient.
> > That leaves optmem limit. Bumping the value I have by default (20480) to
> > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > tests started to fail with something like:
> >
> > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > expected    773707 received
> 
> More zerocopy completions than number of sends. I have not seen this before.
> 
> The completions are ranges of IDs, one per send call for datagram sockets.
> 
> Even with segmentation offload, the counter increases per call, not per segment.
> 
> Do you experience this without any other changes to udpgso_bench_tx.c.
> Or are there perhaps additional sendmsg calls somewhere (during
> initial sync) that are not accounted to num_sends?

Indeed, that looks off. No, I have run into this without any changes in
the tests (besides the retry routine in the shell script that waits for
rx to come up). Also, as a data point.

As an additional data point, this was only seen on the IPv6 tests. I've
never been able to replicate it on the IPv4 run.

-- 
Andrei Gherzan
