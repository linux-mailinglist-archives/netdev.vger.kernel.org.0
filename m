Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E58D68179E
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbjA3Rbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237494AbjA3Rbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:31:33 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60380F762
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:31:31 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 72006423CE
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675099889;
        bh=91+DfYQMicDTMAyqOQABo+i06zKxgv3+SZbX3v9tZKQ=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=ovJX29n22vIPMqjYEIGhurNxCCNjIQ82kPpLdQ0sAF9jZtym916a/l/5/5NfN1YVA
         QPH2Zl7g9mXabvCZhrUqcRfMWfVmoExOm4R5Xu3tdnvThv11KnosIINn9q0P9V6Z2w
         IzUl0pmHD4aS/V3wB74r8QZ61rr8onzdeqwr3xJlmMVqCNm3295hx7RqyW25/21Upr
         kQQRvO0tR7/IW/81dKjRVF6rswRo2eZj6vRTbmg2L0KD6+NrWySqFM/uAOnCvclbGi
         mzvTcvDb5IYM0+0Lc67RDb+l3SzJTKjluSeDJLuazrwQsVml5WZFKI7QH6hfwslb+T
         K5mzs9PQTw6WA==
Received: by mail-wm1-f70.google.com with SMTP id bg24-20020a05600c3c9800b003db0ddddb6fso7538777wmb.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:31:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91+DfYQMicDTMAyqOQABo+i06zKxgv3+SZbX3v9tZKQ=;
        b=ESa26fE+45SHBNR4wZT7UXYEAd0YuM8aOKw1YjXRuNf7LVeMQNqZSE/mFsEu54o0+3
         Pzt647P7XVQsrk0T5JxNX+YOr/GzgyCa6AB9bxSPuL8RAgMeoFLyHqybUfnaNxyK9X4r
         KbCt7XtgKeaK2CKH4or2gZog2xKdopKn0B7p8HwLOgDvlw8pY8j/xtwKcVE9Per34UAv
         j4syZ3gDB8m1eum6lmygRaE+X9+8Hp3abfoyhBtXbgab5fJLJYlbYmg0fBi/HOErpgPo
         UACQ2+vCNcstHMrwEqQ4uxhRGa9ZGbbW6K4NrrebQN2bY2lo9kbcahQ4q9BTR99KOTTc
         EUYQ==
X-Gm-Message-State: AFqh2krcjXWb7pTc/gqi+Xkp5rB9ItSTQHKTgPyXV4ZYd89uT2aslJVJ
        j0pjIqdFIXBgsR3XoVdWAqlJ9RqyQwxJ9T7T7oUXAMxoseId4gTGtwyxMb5P9z1PYa4W5YNKiNx
        Vbfxe6ILlTbiRGKbd3gPTLiz8ZjfyNztWXg==
X-Received: by 2002:a05:6000:1c08:b0:2bd:f5bd:5482 with SMTP id ba8-20020a0560001c0800b002bdf5bd5482mr52761590wrb.28.1675099889037;
        Mon, 30 Jan 2023 09:31:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtUAs2VP7pSZTa1pCs13hcGycrXuxvSeBNypISFdYaUGfztB8PQpg01nlheHhEC2kNpsQV0VQ==
X-Received: by 2002:a05:6000:1c08:b0:2bd:f5bd:5482 with SMTP id ba8-20020a0560001c0800b002bdf5bd5482mr52761577wrb.28.1675099888859;
        Mon, 30 Jan 2023 09:31:28 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d4d0e000000b002bde537721dsm12380088wrt.20.2023.01.30.09.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:31:28 -0800 (PST)
Date:   Mon, 30 Jan 2023 17:31:26 +0000
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
Message-ID: <Y9f+7tMWMtPACLz9@qwirkle>
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle>
 <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle>
 <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle>
 <Y9fu7TR5VC33j+EP@qwirkle>
 <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSf1tJ7kw+GCXf0YBRv0HaR8v7=iy6b36hrsmx8hEr5knQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 11:29AM, Willem de Bruijn wrote:
> On Mon, Jan 30, 2023 at 11:23 AM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > On 23/01/30 04:15PM, Andrei Gherzan wrote:
> > > On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > > > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > > > <andrei.gherzan@canonical.com> wrote:
> > > > >
> > > > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > >
> > > > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > > > >
> > > > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > > > least one of the following:
> > > > > > > > > >
> > > > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > > > >
> > > > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > > > >
> > > > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > > > >
> > > > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > > > >
> > > > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > > > go.
> > > > > > > >
> > > > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > > > alike what mptcp self-tests are doing.
> > > > > > >
> > > > > > > I like this idea. I have tested it and it works as expected with the
> > > > > > > exeception of:
> > > > > > >
> > > > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > > > >
> > > > > > > Any ideas on how to handle this? I could retry and that works.
> > > > > >
> > > > > > This happens (also) without the zerocopy flag, right? That
> > > > > >
> > > > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > > > expect this test to bump up against that limit.
> > > > > >
> > > > > > A few zerocopy specific reasons are captured in
> > > > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > > > >
> > > > > I have dug a bit more into this, and it does look like your hint was in
> > > > > the right direction. The fails I'm seeing are only with the zerocopy
> > > > > flag.
> > > > >
> > > > > From the reasons (doc) above I can only assume optmem limit as I've
> > > > > reproduced it with unlimited locked pages and the fails are transient.
> > > > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > > > tests started to fail with something like:
> > > > >
> > > > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > > > expected    773707 received
> > > >
> > > > More zerocopy completions than number of sends. I have not seen this before.
> > > >
> > > > The completions are ranges of IDs, one per send call for datagram sockets.
> > > >
> > > > Even with segmentation offload, the counter increases per call, not per segment.
> > > >
> > > > Do you experience this without any other changes to udpgso_bench_tx.c.
> > > > Or are there perhaps additional sendmsg calls somewhere (during
> > > > initial sync) that are not accounted to num_sends?
> > >
> > > Indeed, that looks off. No, I have run into this without any changes in
> > > the tests (besides the retry routine in the shell script that waits for
> > > rx to come up). Also, as a data point.
> >
> > Actually wait. I don't think that is the case here. "expected" is the
> > number of sends. In this case we sent 1076 more messages than
> > completions. Am I missing something obvious?
> 
> Oh indeed.
> 
> Receiving fewer completions than transmission is more likely.

Exactly, yes.

> This should be the result of datagrams still being somewhere in the
> system. In a qdisc, or waiting for the network interface to return a
> completion notification, say.
> 
> Does this remain if adding a longer wait before the final flush_errqueue?

Yes and no. But not realiably unless I go overboard.

> Or, really, the right fix is to keep polling there until the two are
> equal, up to some timeout. Currently flush_errqueue calls poll only
> once.

That makes sense. I have implemented a retry and this ran for a good
while now.

-               flush_errqueue(fd, true);
+               while (true) {
+                       flush_errqueue(fd, true);
+                       if ((stat_zcopies == num_sends) || (delay >= MAX_DELAY))
+                               break;
+                       usleep(delay);
+                       delay *= 2;
+               }

What do you think?

-- 
Andrei Gherzan
