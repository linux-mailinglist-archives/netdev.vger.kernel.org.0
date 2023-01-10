Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B28A664ECF
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjAJWaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjAJWaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:30:23 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2182010F0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:30:22 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s67so9263097pgs.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yE8skgR2vX+yb2fPa7BN3N6o3jz4hgxf3tGwQwJUQwo=;
        b=QHjQvbEbpSy0LfVxCVTDZvZpiafqVY3qJz0DNkQ/xLyq1SlCZNTihCR4225a0SX/sm
         5uXvHU434ei0RrQfIlGGAJTkyGVhDtNrg1Dh3gmH1ij2ssY2H7ACZxMI552KZjPdxZ0r
         ePaBOWekVM1LAAfoHFNtbXW00iR/IMDGuZ3rGweTek8uQVLJ0ZyhISmfl9EvfbqZUgDO
         RWVcNj9zY8bgCSV5TeTUBqLnnkQh8+iv+Ei+SPs0G1XEJ5j56vexS9ty4wW9P+eWgQzU
         cFkr0vkw6/OLZ/do+2ZWJaZpQ2EKQ6dgGQNmCk8rFGqsbS81L9qER9PDMC82sgfvXxMH
         4RnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yE8skgR2vX+yb2fPa7BN3N6o3jz4hgxf3tGwQwJUQwo=;
        b=hq2py1DyAEqQRhyXja4RlPSEX4WNEQ9jCekcuznW8L+xa7jZqsW9cJ8/wYRISYp/UY
         /P0m7GePVo6TQIMhaXdj2Za49Tg3qyQvProQ6PLKgn5UpJKtmwmuQbU4MMd9+N1vFkRi
         ERbhHa9SLzLTkDbqsMkPs/bQl7sT0fNtbA7pcwLCQnJrbJpqVbR/Xx27nIHV3w8sZUK3
         pQV7vbMi66XlNeLf8CaT9ZE4s+e2KePeGoySM9Lztw6eCoXHT2hfGUex/PsDnyUN1Ie0
         Qcj+RTc/mA2K/5vSKYEqxoSQ0Lq2ieWhUEcBLxKXX5+U+tvct7/TqEr5OumYFSWUxpSM
         0x3A==
X-Gm-Message-State: AFqh2kppLEMFm4+UFxMpPoHfaPj8ByMWLvW92cSJmW5VeNmQfdZkQdlG
        KhJB45HqDnN1XptsrKDElSHMJnXYxHDvBlODhug=
X-Google-Smtp-Source: AMrXdXv923F+OBnIxeMmvRe19wPE2hpTW0gNJLupfYtCPWNntR6tsZM+rEsyodY2l0+nqA/JlDpgxXA7qvwt7zd+4Jo=
X-Received: by 2002:a63:1f44:0:b0:476:d2d9:5151 with SMTP id
 q4-20020a631f44000000b00476d2d95151mr5030228pgm.487.1673389821535; Tue, 10
 Jan 2023 14:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-10-gerhard@engleder-embedded.com> <c5e39384f185fcb8788e7723498702b0235e367e.camel@gmail.com>
 <a78d3011-738c-2289-7a70-cd046cde12d5@engleder-embedded.com>
In-Reply-To: <a78d3011-738c-2289-7a70-cd046cde12d5@engleder-embedded.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Jan 2023 14:30:10 -0800
Message-ID: <CAKgT0UcEMDZXUeEVJdVTDOFRvG9uhkVZe252psyASiNN8XqqvQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 09/10] tsnep: Add XDP RX support
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
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

On Tue, Jan 10, 2023 at 1:28 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On 10.01.23 18:40, Alexander H Duyck wrote:
> > On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> >> If BPF program is set up, then run BPF program for every received frame
> >> and execute the selected action.
> >>
> >> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> >> ---
> >>   drivers/net/ethernet/engleder/tsnep_main.c | 122 ++++++++++++++++++++-
> >>   1 file changed, 120 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> >> index 451ad1849b9d..002c879639db 100644
> >> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> >> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> >> @@ -27,6 +27,7 @@
> >>   #include <linux/phy.h>
> >>   #include <linux/iopoll.h>
> >>   #include <linux/bpf.h>
> >> +#include <linux/bpf_trace.h>
> >>
> >>   #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
> >>   #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
> >> @@ -44,6 +45,9 @@
> >>   #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
> >>                                    ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
> >>
> >> +#define TSNEP_XDP_TX                BIT(0)
> >> +#define TSNEP_XDP_REDIRECT  BIT(1)
> >> +
> >>   enum {
> >>      __TSNEP_DOWN,
> >>   };
> >> @@ -625,6 +629,28 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
> >>      iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
> >>   }
> >>
> >> +static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
> >> +                            struct xdp_buff *xdp,
> >> +                            struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> >> +{
> >> +    struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
> >> +    bool xmit;
> >> +
> >> +    if (unlikely(!xdpf))
> >> +            return false;
> >> +
> >> +    __netif_tx_lock(tx_nq, smp_processor_id());
> >> +
> >> +    /* Avoid transmit queue timeout since we share it with the slow path */
> >> +    txq_trans_cond_update(tx_nq);
> >> +
> >> +    xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
> >> +
> >
> > Again the trans_cond_update should be after the xmit and only if it is
> > not indicating it completed the transmit.
>
> tsnep_xdp_xmit_frame_ring() only adds xpdf to the descriptor ring, so it
> cannot complete the transmit. Therefore and in line with your previous
> comment trans_cond_update() should be called here if xpdf is
> successfully placed in the descriptor ring. Is that right?

Yes, that is what I meant by "complete the transmit" is if it places
the xdpf on the descriptor ring then you can update this. Basically
the idea is we should be updating the timer any time a frame goes onto
the ring. It shouldn't be an unconditional update as a stalled ring
could then go undetected.
