Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE16815DE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjA3QDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbjA3QDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:03:45 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B91093D4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:03:43 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4fda31c3351so165473007b3.11
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kRnVG2nFTl4BwwenWUJgDtW21KKjiHwQU7q0KoM8lwU=;
        b=fmy99mpVYplzHItVV0gIU7OdiZlttPxcrt/KnNdXQNOWmWxYmnB/WCKhz4K8EBEGXt
         a5igaK3FNXLKMzHBEzfPPeYeV/IVcNeJuZOldRgf4WXt2Uc4Ytfa8IgUocobC9ryhrgQ
         /Y5aWaietYFmNytacnPCjqKzBhfhyOSph6Ff5EIiLvSXOR8p+5kNRKrZA86ji2oUKd0b
         KXSDTV/lz2YYzW+b9PnnlP6VUWiOnrK6JyLRWpuxGDlmjFQsofaF+iqkh7EBvrUXXVnn
         edUwAZIwEcc3QwYD7LdiYWvtDcWWe+L2Lzit10SscOUAvTC5CCwQnc3EdBjjeHuLWnsy
         H1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRnVG2nFTl4BwwenWUJgDtW21KKjiHwQU7q0KoM8lwU=;
        b=hPgfKf9F3Lqdn1HCXIOdHv+BcEPCf8u1VyA1KI2ibACFS9dpdS6FTI3x0ubw657pgQ
         B5xKEO0qnPCefIbwm+oPWuY0eFOWgtDFiID2LMPpPtWPuxgQkIvCy/7NRKJtzwM/cN14
         sbHJDRQtkKuEX4RmNL9r7ZdZNM4iz5FjqG1HKbw6gQ/vmE2Lmr+R4q0V0Hdei5HdKrbA
         9BVWVCtb8fTcIJCqt/JhC7/MGvwTkKSVzBQ6btpKQsYshBhQIu9X9CtoMjFjl0v4FrDk
         /yns8zGldA0qyF4vAhFuIexTpz0sGN4yl97J0ue/gD4lbhMW17Btui+GbR6ClGa/+s+9
         97LA==
X-Gm-Message-State: AFqh2krBsHVbGTZtJxPEfRrX2uCQGds0gAH/nBNZxVfMXet6VUCK1W8Y
        2KTj9BpUlI1WfH/Pv1RdTPnIgNEkKi4DjCfM8PcgPQ==
X-Google-Smtp-Source: AMrXdXvILrB2xzvcs4JWtChQeHtXR/03YwCUY753A7xYVSr+kSIcmJU0sRWmI+QKZ2CoZyM0GDYqqeq1Y8umluN2zW0=
X-Received: by 2002:a81:4006:0:b0:46b:c07c:c1d9 with SMTP id
 l6-20020a814006000000b0046bc07cc1d9mr3775924ywn.56.1675094622259; Mon, 30 Jan
 2023 08:03:42 -0800 (PST)
MIME-Version: 1.0
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle> <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle>
In-Reply-To: <Y9fT+LABhW+/3Nal@qwirkle>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 30 Jan 2023 11:03:06 -0500
Message-ID: <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
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

On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > <andrei.gherzan@canonical.com> wrote:
> > >
> > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > >
> > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > least one of the following:
> > > > > >
> > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > >
> > > > > > This change addresses this by adding routines that retry the socket
> > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > >
> > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > >
> > > > > Synchronizing the two processes is indeed tricky.
> > > > >
> > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > go.
> > > >
> > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > alike what mptcp self-tests are doing.
> > >
> > > I like this idea. I have tested it and it works as expected with the
> > > exeception of:
> > >
> > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > >
> > > Any ideas on how to handle this? I could retry and that works.
> >
> > This happens (also) without the zerocopy flag, right? That
> >
> > It might mean reaching the sndbuf limit, which can be adjusted with
> > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > expect this test to bump up against that limit.
> >
> > A few zerocopy specific reasons are captured in
> > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
>
> I have dug a bit more into this, and it does look like your hint was in
> the right direction. The fails I'm seeing are only with the zerocopy
> flag.
>
> From the reasons (doc) above I can only assume optmem limit as I've
> reproduced it with unlimited locked pages and the fails are transient.
> That leaves optmem limit. Bumping the value I have by default (20480) to
> (2048000) made the sendmsg succeed as expected. On the other hand, the
> tests started to fail with something like:
>
> ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> expected    773707 received

More zerocopy completions than number of sends. I have not seen this before.

The completions are ranges of IDs, one per send call for datagram sockets.

Even with segmentation offload, the counter increases per call, not per segment.

Do you experience this without any other changes to udpgso_bench_tx.c.
Or are there perhaps additional sendmsg calls somewhere (during
initial sync) that are not accounted to num_sends?

> Also, this audit fail is transient as with the buffer limit one.
