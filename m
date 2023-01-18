Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F2267213C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjARP1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjARP1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:27:17 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D297A13D78
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:26:48 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id l125so16722205vsc.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aemURlTvFjeUyU8geGIQuPpUh0VECn/jnSnmiMJQr9E=;
        b=Rxp7qcrzhL75fKQ++siTYJI7CtkFrk6jL87ZrYXf1VhvPvGNGaDLqCDcjnZLYJMlgG
         H29Cu0sX/+6lcpBMFvuduYHAO4FZa7BRDSCqTDrBv2djLQDbWCbsgKjoL1x1/0Bj03Z0
         wZzEkjl4Apni9n/U7bDAoeM07WFT0OTCFuyTxLhq+X22LflhmYbdlZ2OWR+XLiQ0HuCI
         8l6fni2XfDBqnAQZgaVHCECeckUJypxMCR2tBp1ZcduaIPQMM2QF86F6LqiMa3ZXx0ZA
         QHzcIzCqbgj7YcWRX/Ob98D9ZJVbBGaQV+6dA7g785yTM6l4AT6MuJoDlclTvulv2L//
         yv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aemURlTvFjeUyU8geGIQuPpUh0VECn/jnSnmiMJQr9E=;
        b=a8z3Gc27v7g0wFj8m/t42N9R8LaG8Xj9GeJzjKMIpFHptiqtTTznyK+RewgS+logpV
         wKnyVvZ47I/IQKtJtV5+4leUOJM9MehvsaasaKxV3VHaWbQD0ybT483vKQvMLqs6CeUo
         1RqYKuvSgpKJz3iT6qnzoLYwEtDDuooa4vqgvF1uJhqZ4RqnxV3106pgMwMh6x1xs5iT
         /nvuiKwlVyPnwT+uNPqVPMNyPd87NqHPG11FdrGwkSFMB1CqVAjMU0O77X8G2aqIUOul
         fy4rRarJfA8SvB0FBXRp/dD2KmcgYCFOqNWqe/g8uc1a6uTxA6yX18YRsQxxzFZvKa2+
         4SkA==
X-Gm-Message-State: AFqh2kqGUdaQSXjtxT41FXf1ltbi9SYW/0X5YbKEXeUYQePQnkrNF4uE
        0jnRk1jEQHeQjXG6/MOOd/4QLjmPv80ollPyQui1S69U
X-Google-Smtp-Source: AMrXdXsgOCy1Mbg0u111SlZaOTaL8zho0NmGi2ujndkNmqqignsxkZMcvrZha02UhGATqpenFkReMujaTBZOcXTZ5xM=
X-Received: by 2002:a05:6102:5587:b0:3d1:2167:11ad with SMTP id
 dc7-20020a056102558700b003d1216711admr934622vsb.2.1674055607899; Wed, 18 Jan
 2023 07:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
 <5f494ec3-9435-b9dc-6dd8-9e1b7354430d@intel.com> <CAF=yD-LMO5Y1Uith1jsbh1kOO3t4oagTnKSdKoM=gQkfd61oAA@mail.gmail.com>
 <6573e9e23324291b83e81de9659a50c86b55502b.camel@perches.com>
In-Reply-To: <6573e9e23324291b83e81de9659a50c86b55502b.camel@perches.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Jan 2023 10:26:12 -0500
Message-ID: <CAF=yD-JaJUYEEGp7H41FeEr8U-cLKx6Ki5-8VchHRVmj6av2QQ@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3 block close
To:     Joe Perches <joe@perches.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 7:54 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2023-01-17 at 14:15 -0500, Willem de Bruijn wrote:
> > > On 1/16/2023 9:40 AM, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > Avoid race between process wakeup and tpacket_v3 block timeout.
> > > >
> > > > The test waits for cfg_timeout_msec for packets to arrive. Packets
> > > > arrive in tpacket_v3 rings, which pass packets ("frames") to the
> > > > process in batches ("blocks"). The sk waits for
> > > > req3.tp_retire_blk_tov
> > > > msec to release a block.
> > > >
> > > > Set the block timeout lower than the process waiting time, else
> > > > the process may find that no block has been released by the time
> > > > it
> > > > scans the socket list. Convert to a ring of more than one,
> > > > smaller,
> > > > blocks with shorter timeouts. Blocks must be page aligned, so >=
> > > > 64KB.
> > > >
> > > > Somewhat awkward while () notation dictated by checkpatch: no
> > > > empty
> > > > braces allowed, nor statement on the same line as the condition.
> > > >
> > > > Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > ---
> > > >  tools/testing/selftests/net/toeplitz.c | 13 ++++++++-----
> > > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/net/toeplitz.c
> > > > b/tools/testing/selftests/net/toeplitz.c
> > > > index 90026a27eac0c..66f7f6568643a 100644
> > > > --- a/tools/testing/selftests/net/toeplitz.c
> > > > +++ b/tools/testing/selftests/net/toeplitz.c
> > > > @@ -215,7 +215,7 @@ static char *recv_frame(const struct
> > > > ring_state *ring, char *frame)
> > > >  }
> > > >
> > > >  /* A single TPACKET_V3 block can hold multiple frames */
> > > > -static void recv_block(struct ring_state *ring)
> > > > +static bool recv_block(struct ring_state *ring)
> > > >  {
> > > >       struct tpacket_block_desc *block;
> > > >       char *frame;
> > > > @@ -223,7 +223,7 @@ static void recv_block(struct ring_state
> > > > *ring)
> > > >
> > > >       block = (void *)(ring->mmap + ring->idx * ring_block_sz);
> > > >       if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
> > > > -             return;
> > > > +             return false;
> > > >
> > > >       frame = (char *)block;
> > > >       frame += block->hdr.bh1.offset_to_first_pkt;
> > > > @@ -235,6 +235,8 @@ static void recv_block(struct ring_state
> > > > *ring)
> > > >
> > > >       block->hdr.bh1.block_status = TP_STATUS_KERNEL;
> > > >       ring->idx = (ring->idx + 1) % ring_block_nr;
> > > > +
> > > > +     return true;
> > > >  }
> > > >
> > > >  /* simple test: sleep once unconditionally and then process all
> > > > rings */
> > > > @@ -245,7 +247,8 @@ static void process_rings(void)
> > > >       usleep(1000 * cfg_timeout_msec);
> > > >
> > > >       for (i = 0; i < num_cpus; i++)
> > > > -             recv_block(&rings[i]);
> > > > +             while (recv_block(&rings[i]))
> > > > +                     ;
> > >
> > > I'd rather have one of
> > >
> > >   while (recv_block(&rings[i]));
> > >
> > > or
> > >
> > >   while (recv_block(&rings[i])) {}
> > >
> > > or even (but less preferred:
> > >
> > >   do {} (while (recv_block(&rings[i]));
> > >
> > > instead of  this ; on its own line.
> > >
> > > Even if this violates checkpatch attempts to catch other bad style
> > > this
> > > is preferable to the lone ';' on its own line.
> > >
> > > If necessary we can/should change checkpatch to allow the idiomatic
> > > approach.
>
> To me it's a 'Don't care'.
>
> There are many hundreds of these in the kernel and there is no
> valid reason to require a particular style.
>
> $ git grep -P  '^\t+;\s*$' -- '*.c' | wc -l
> 871

Interesting, thanks.

I had to send a v2 by now anyway, so changed to a "do {} while" as
evidently people found that more palatable.
