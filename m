Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F2D68133F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbjA3O37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbjA3O3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:29:19 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B417144
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:28:14 -0800 (PST)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2FE6540259
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675088892;
        bh=8tldsSMHjz/KGcubN74VP3m6mSViWeoZ+GXrdbkATG4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=Xtva5QHr4fCV9JrnEwUcsfVjaMoeQT12m8Ss1f3ZXSxONSGjEFZ+j0MwwQ6LfWAGb
         XNxqqWKYm9T0FwHWA4ndVDIDq1WffTAOv30eeRTDpjXdGLSpyk6pbHJyMQEItrsxCj
         srQKk80DpJ1C69kImw+CDuNtZ9Ydm/gx04nqO8oM7mgQ9gyBt+XxSUOjoh/pPOKF1k
         zLxKcHbO9E9eugEAePx+ElmBSUbnn1aEUJ8RR2sUXsk0MK0gvjiHcugLyX6iODKRJJ
         g4zB2Bixs4azFO8clMfzTpXtOb/wuiYlLgfFHLnBGNWcnaGrIFXP1R0sEi0UMf7tRN
         frGlmjcPDjaXg==
Received: by mail-wr1-f69.google.com with SMTP id i8-20020a05600011c800b002bfb6712623so1989211wrx.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tldsSMHjz/KGcubN74VP3m6mSViWeoZ+GXrdbkATG4=;
        b=zi3n0qvpcJqNc6ZP7YG/Ny0txHB6IWIp5AQrgapfBnQBAHv9R/1BNAu21ULm2Gj90j
         SG33fJMCNY+kX9xvx3Rtj0gKQWOrNjXrFHV/gHK6/i96OimuT5YKNrmzjjkgDap4E1lZ
         u/t7Vnwi4B03oOKgIWPSPGIZVeNWu8kXHXBFHsx5uixF/paHay1/6p2/pU1yyW6hzmjr
         lNcOWaAp/zs8dmoaH4EQsCNsbcg8V+6+cz79fo47wf12Z48Lu6MdFJEgbbXv4YP6+SMn
         +xAuYTx5r6bnSJzAItmzy+3PQLy0shryn+QZcWqJl1zNCtOjpJ2SmczTWTYY/C6cva48
         N/yQ==
X-Gm-Message-State: AO0yUKWOC8OyDJ37Ux0gavUofmmgv4Hv3egWKQiT9/rf6GrXHLwhLYS7
        mUr7Mc2zOPvNB4fx0sfxxEAhywAO1qejls4SDYUhQHhAHDWpkcqBim1T6A/DfG2vMl/Be9cdt6y
        3E347sAGHQgk2/K0ZlE8H4TfgaJ3b9XFwSg==
X-Received: by 2002:a05:600c:3ba6:b0:3dc:58d5:3a80 with SMTP id n38-20020a05600c3ba600b003dc58d53a80mr4007475wms.24.1675088891320;
        Mon, 30 Jan 2023 06:28:11 -0800 (PST)
X-Google-Smtp-Source: AK7set9RXHwyV38sXXqZOIzwMAAznKaTCBHLsXPHnS8yXwbmHLuyZd3o4xjfz5sCXZ+8TzS3OT06TA==
X-Received: by 2002:a05:600c:3ba6:b0:3dc:58d5:3a80 with SMTP id n38-20020a05600c3ba600b003dc58d53a80mr4007457wms.24.1675088891083;
        Mon, 30 Jan 2023 06:28:11 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c434700b003dc3f195abesm9540902wme.39.2023.01.30.06.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 06:28:10 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:28:08 +0000
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
Message-ID: <Y9fT+LABhW+/3Nal@qwirkle>
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle>
 <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 08:35AM, Willem de Bruijn wrote:
> On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > <andrei.gherzan@canonical.com> wrote:
> > > > >
> > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > accept socket connections. This racing bug could fail the test with at
> > > > > least one of the following:
> > > > >
> > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > ./udpgso_bench_tx: write: Connection refused
> > > > >
> > > > > This change addresses this by adding routines that retry the socket
> > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > >
> > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > >
> > > > Synchronizing the two processes is indeed tricky.
> > > >
> > > > Perhaps more robust is opening an initial TCP connection, with
> > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > go.
> > >
> > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > socket to show up in 'ss' output before firing-up the client - quite
> > > alike what mptcp self-tests are doing.
> >
> > I like this idea. I have tested it and it works as expected with the
> > exeception of:
> >
> > ./udpgso_bench_tx: sendmsg: No buffer space available
> >
> > Any ideas on how to handle this? I could retry and that works.
> 
> This happens (also) without the zerocopy flag, right? That
> 
> It might mean reaching the sndbuf limit, which can be adjusted with
> SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> expect this test to bump up against that limit.
> 
> A few zerocopy specific reasons are captured in
> https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.

I have dug a bit more into this, and it does look like your hint was in
the right direction. The fails I'm seeing are only with the zerocopy
flag.

From the reasons (doc) above I can only assume optmem limit as I've
reproduced it with unlimited locked pages and the fails are transient.
That leaves optmem limit. Bumping the value I have by default (20480) to
(2048000) made the sendmsg succeed as expected. On the other hand, the
tests started to fail with something like:

./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
expected    773707 received

Also, this audit fail is transient as with the buffer limit one.

-- 
Andrei Gherzan
