Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B131681639
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbjA3QXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbjA3QXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:23:14 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089FE3A853
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:23:13 -0800 (PST)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C64073F2D1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675095791;
        bh=EKh99Av2dVI8br/juDJKkzbI27Y8Tv0MgpqioM20Ax8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=d8qvpAuw3iuOJK5+LkUKDWhL0JS/Rb+wcI4C/JpdxK9uB6EHWHtKEUfkcsKeXwVT+
         u5ac6TSWS6zAEcTi7BJcprR/a31NttZXlcCxiIR0YmQn4mj9VGheIaearPrmnBf2AW
         LrjEOFF+BaP97LhKBChJBXQ+1mkFtusMxVmq0MxnhdEQRK2no9NreKRCC0J/04fsIa
         g2k0PxDmvpGA5pQ7V17scsv/jJogNUz+tnsGM3B5/d4i53mxHwSEK+qQVQeouO6WKy
         eyGLyFSOodhJYyzcz/KacczviL1g9j1SmXBY9iIUYdZGKVP5iqFrXrkZ972n7aZJMb
         yd8h30aWaWZvQ==
Received: by mail-wr1-f69.google.com with SMTP id m13-20020a5d4a0d000000b002bfe777a97aso968668wrq.22
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:23:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKh99Av2dVI8br/juDJKkzbI27Y8Tv0MgpqioM20Ax8=;
        b=nl2mux4BG9PTXuvHZg/UZeYgSNFNfzfIMw582woTo6Sxa1+g/a/SqdORkSh0YZ1h74
         jkkv35wPyGlg2UMwDMcIkBAtXERPrwg5Mz79h5mef32aaa8rnWu6T7AaiEZGsFV2zZIa
         1MRiiHOBGGLplZag7IFdmKDq1uet/w5aew2H6XxhKBrTbEjObdGQXB5799TvcbGq0DMR
         678o7+ZiYg7o7GWQcFtqaunckhapHs1oEeZVr0QI9gKJ+9CnBgoa2AaAwIvKoChf6LFy
         O/HrFSJSVnthBiHJNH2u+Q+HJPpEh4bfDagjIC2LdgPbXljZzkzD1KuQt6fhDxmkEsbO
         WwkQ==
X-Gm-Message-State: AFqh2kpT/CUEoNgbULbAztWknxHiVKkqAHtWWF+HqUjGGUItn3PYUOog
        gCxqlxv3lv6YBQq/Js9En6gO9e6j4YaflgZBcU2SrjaipGYzAwll18CfXa7FiToEhfKYa1Z5No9
        ibcVCcAzfQzmK8HyuTkvZHxseYgjdChothg==
X-Received: by 2002:a05:600c:34d1:b0:3db:1434:c51a with SMTP id d17-20020a05600c34d100b003db1434c51amr44052402wmq.40.1675095791479;
        Mon, 30 Jan 2023 08:23:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv94g3xcpSkCieUluATJV/IVwfPvR4IZ+IgwNWXiloi8TwBETu25mp6RUhJ8NieWs4+Q2LF9A==
X-Received: by 2002:a05:600c:34d1:b0:3db:1434:c51a with SMTP id d17-20020a05600c34d100b003db1434c51amr44052387wmq.40.1675095791314;
        Mon, 30 Jan 2023 08:23:11 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id l10-20020a05600c47ca00b003dc58637163sm4063283wmo.45.2023.01.30.08.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 08:23:10 -0800 (PST)
Date:   Mon, 30 Jan 2023 16:23:09 +0000
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
Message-ID: <Y9fu7TR5VC33j+EP@qwirkle>
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
 <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
 <a762638b06684cd63d212d1ce9f65236a08b78b1.camel@redhat.com>
 <Y9e9S3ENl0oszAH/@qwirkle>
 <CA+FuTSe_NMm6goSmCNfKjUWPGYtVnnBMv6W54a_GOeLJ2FqyOQ@mail.gmail.com>
 <Y9fT+LABhW+/3Nal@qwirkle>
 <CA+FuTScSfLG7gXS_YqJzsC-Teiryj3jeSQs9w0D1PWJs8sv5Rg@mail.gmail.com>
 <Y9ftL5c4klThCi9Q@qwirkle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ftL5c4klThCi9Q@qwirkle>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/30 04:15PM, Andrei Gherzan wrote:
> On 23/01/30 11:03AM, Willem de Bruijn wrote:
> > On Mon, Jan 30, 2023 at 9:28 AM Andrei Gherzan
> > <andrei.gherzan@canonical.com> wrote:
> > >
> > > On 23/01/30 08:35AM, Willem de Bruijn wrote:
> > > > On Mon, Jan 30, 2023 at 7:51 AM Andrei Gherzan
> > > > <andrei.gherzan@canonical.com> wrote:
> > > > >
> > > > > On 23/01/30 09:26AM, Paolo Abeni wrote:
> > > > > > On Fri, 2023-01-27 at 17:03 -0500, Willem de Bruijn wrote:
> > > > > > > On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
> > > > > > > <andrei.gherzan@canonical.com> wrote:
> > > > > > > >
> > > > > > > > The tx and rx test programs are used in a couple of test scripts including
> > > > > > > > "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> > > > > > > > are invoked subsequently, there is a chance that the rx one is not ready to
> > > > > > > > accept socket connections. This racing bug could fail the test with at
> > > > > > > > least one of the following:
> > > > > > > >
> > > > > > > > ./udpgso_bench_tx: connect: Connection refused
> > > > > > > > ./udpgso_bench_tx: sendmsg: Connection refused
> > > > > > > > ./udpgso_bench_tx: write: Connection refused
> > > > > > > >
> > > > > > > > This change addresses this by adding routines that retry the socket
> > > > > > > > operations with an exponential back off algorithm from 100ms to 2s.
> > > > > > > >
> > > > > > > > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > > > > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > > >
> > > > > > > Synchronizing the two processes is indeed tricky.
> > > > > > >
> > > > > > > Perhaps more robust is opening an initial TCP connection, with
> > > > > > > SO_RCVTIMEO to bound the waiting time. That covers all tests in one
> > > > > > > go.
> > > > > >
> > > > > > Another option would be waiting for the listener(tcp)/receiver(udp)
> > > > > > socket to show up in 'ss' output before firing-up the client - quite
> > > > > > alike what mptcp self-tests are doing.
> > > > >
> > > > > I like this idea. I have tested it and it works as expected with the
> > > > > exeception of:
> > > > >
> > > > > ./udpgso_bench_tx: sendmsg: No buffer space available
> > > > >
> > > > > Any ideas on how to handle this? I could retry and that works.
> > > >
> > > > This happens (also) without the zerocopy flag, right? That
> > > >
> > > > It might mean reaching the sndbuf limit, which can be adjusted with
> > > > SO_SNDBUF (or SO_SNDBUFFORCE if CAP_NET_ADMIN). Though I would not
> > > > expect this test to bump up against that limit.
> > > >
> > > > A few zerocopy specific reasons are captured in
> > > > https://www.kernel.org/doc/html/latest/networking/msg_zerocopy.html#transmission.
> > >
> > > I have dug a bit more into this, and it does look like your hint was in
> > > the right direction. The fails I'm seeing are only with the zerocopy
> > > flag.
> > >
> > > From the reasons (doc) above I can only assume optmem limit as I've
> > > reproduced it with unlimited locked pages and the fails are transient.
> > > That leaves optmem limit. Bumping the value I have by default (20480) to
> > > (2048000) made the sendmsg succeed as expected. On the other hand, the
> > > tests started to fail with something like:
> > >
> > > ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    774783
> > > expected    773707 received
> > 
> > More zerocopy completions than number of sends. I have not seen this before.
> > 
> > The completions are ranges of IDs, one per send call for datagram sockets.
> > 
> > Even with segmentation offload, the counter increases per call, not per segment.
> > 
> > Do you experience this without any other changes to udpgso_bench_tx.c.
> > Or are there perhaps additional sendmsg calls somewhere (during
> > initial sync) that are not accounted to num_sends?
> 
> Indeed, that looks off. No, I have run into this without any changes in
> the tests (besides the retry routine in the shell script that waits for
> rx to come up). Also, as a data point.

Actually wait. I don't think that is the case here. "expected" is the
number of sends. In this case we sent 1076 more messages than
completions. Am I missing something obvious?

> 
> As an additional data point, this was only seen on the IPv6 tests. I've
> never been able to replicate it on the IPv4 run.

I was also fast to send this but it is not correct. I managed to
reproduce it on both IPv4 and IPv6.

-- 
Andrei Gherzan
