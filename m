Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B302217D3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGOWfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOWfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 18:35:40 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778CEC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:35:40 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w27so3231233qtb.7
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Awkw/2JAwqx0ybW5si+vH0X/DyLIxSnakUSW3oK3Jgw=;
        b=LOUa04qKaz/Ofcf+7hmtIod7M0nu+L4V6ALEKBSnPvwBrpWstPGKol0ZoZ7CpCc4ho
         8f+vAm4TlU9Q94isUQSM1oijBsrajq+4IyMT7YJJomWLl0icFaFnaE1UNK47LN/Uoe2v
         XsEom275tqbMGnLrmD8dw5eHCIgEwvlDWPvwpkcORZ1I6y8KVPFbmB46kuquSC92PW++
         f71PG3hbwn9P4Y50EpDPpobD/JvOqU/Ml0egLRtlu96Lxo0l3zPvNGxGRW23xOoMnkiO
         U5qU/fTViZtlUS6YBZ0ADkCNxrX/17d9N5ASPEj0q7T43QbfM2jrtT0HGJXV3m5pERr5
         SbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Awkw/2JAwqx0ybW5si+vH0X/DyLIxSnakUSW3oK3Jgw=;
        b=f+b4dzcPjU1c0AN4MR+7vOSW4M6ywIeHKIpEQcm42jp+xhOBfDtrVc5QFVqK+WUoxm
         hDL69ZnnvePDh7sbhWt8Lh8irN1b0NojJ4A0pCZ6KI3aNRs6WPcevwb1lvJNqegNkP+4
         xnAoYQ2qYx88Hyg+ZltvnTn+xXDdhCEF1JXhtjpTqBby9G4xdBrKmswKRLuHNwATvFUa
         tjV+brzjDsNn0puNXX2jSLVifA7YG8DFvWEGyOs8cYndjTHbptRJgUHbQPG2t6RFRigq
         Pyp5zNxpcvzQ7XDPtZP7Mngd+oO8BPo+AOaNG2jUrHmCvB2dSVqhqofAb3S2fRckNWNk
         994g==
X-Gm-Message-State: AOAM530uRR5bIwjilrjh/euPR77iQ7CdV+wMRCoVCblTeypw+LkI+nED
        eotTVTMWfY57e6LDk4wO0aqFPX4t
X-Google-Smtp-Source: ABdhPJy+JgYtlovhWgGDDXl65nYANtNBXtDzqPgcz9AGYyyGJWvb3X9VPUlGfapjJIZ1rEMmRnZ66A==
X-Received: by 2002:ac8:4c88:: with SMTP id j8mr2128030qtv.57.1594852539284;
        Wed, 15 Jul 2020 15:35:39 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id s128sm4352048qkd.108.2020.07.15.15.35.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 15:35:38 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id a15so1899375ybs.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:35:38 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr2058601ybg.428.1594852537696;
 Wed, 15 Jul 2020 15:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200707152204.10314-1-john.ogness@linutronix.de> <20200715132141.2c72ae75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715132141.2c72ae75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 15 Jul 2020 18:35:00 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe1WXLGKd2zNLmQiKTZeNN64R-vGJTNMuVD_4VA8AN5Fg@mail.gmail.com>
Message-ID: <CA+FuTSe1WXLGKd2zNLmQiKTZeNN64R-vGJTNMuVD_4VA8AN5Fg@mail.gmail.com>
Subject: Re: [PATCH] af_packet: TPACKET_V3: replace busy-wait loop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Ogness <john.ogness@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 4:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  7 Jul 2020 17:28:04 +0206 John Ogness wrote:
> > A busy-wait loop is used to implement waiting for bits to be copied
> > from the skb to the kernel buffer before retiring a block. This is
> > a problem on PREEMPT_RT because the copying task could be preempted
> > by the busy-waiting task and thus live lock in the busy-wait loop.
> >
> > Replace the busy-wait logic with an rwlock_t. This provides lockdep
> > coverage and makes the code RT ready.
> >
> > Signed-off-by: John Ogness <john.ogness@linutronix.de>
>
> Is taking a lock and immediately releasing it better than a completion?
> Seems like the lock is guaranteed to dirty a cache line, which would
> otherwise be avoided here.
>
> Willem, would you be able to take a look as well? Is this path
> performance sensitive in real life?

No objections from me.

I guess this resolves the issue on preempt_rt, because the spinlocks act as
mutexes. It will still spin on write_lock otherwise, no huge difference from
existing logic.





>
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 29bd405adbbd..dd1eec2dd6ef 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -593,6 +593,7 @@ static void init_prb_bdqc(struct packet_sock *po,
> >                                               req_u->req3.tp_block_size);
> >       p1->tov_in_jiffies = msecs_to_jiffies(p1->retire_blk_tov);
> >       p1->blk_sizeof_priv = req_u->req3.tp_sizeof_priv;
> > +     rwlock_init(&p1->blk_fill_in_prog_lock);
> >
> >       p1->max_frame_len = p1->kblk_size - BLK_PLUS_PRIV(p1->blk_sizeof_priv);
> >       prb_init_ft_ops(p1, req_u);
> > @@ -659,10 +660,9 @@ static void prb_retire_rx_blk_timer_expired(struct timer_list *t)
> >        *
> >        */
> >       if (BLOCK_NUM_PKTS(pbd)) {
> > -             while (atomic_read(&pkc->blk_fill_in_prog)) {
> > -                     /* Waiting for skb_copy_bits to finish... */
> > -                     cpu_relax();
> > -             }
> > +             /* Waiting for skb_copy_bits to finish... */
> > +             write_lock(&pkc->blk_fill_in_prog_lock);
> > +             write_unlock(&pkc->blk_fill_in_prog_lock);
> >       }
> >
> >       if (pkc->last_kactive_blk_num == pkc->kactive_blk_num) {
> > @@ -921,10 +921,9 @@ static void prb_retire_current_block(struct tpacket_kbdq_core *pkc,
> >                * the timer-handler already handled this case.
> >                */
> >               if (!(status & TP_STATUS_BLK_TMO)) {
> > -                     while (atomic_read(&pkc->blk_fill_in_prog)) {
> > -                             /* Waiting for skb_copy_bits to finish... */
> > -                             cpu_relax();
> > -                     }
> > +                     /* Waiting for skb_copy_bits to finish... */
> > +                     write_lock(&pkc->blk_fill_in_prog_lock);
> > +                     write_unlock(&pkc->blk_fill_in_prog_lock);
> >               }
> >               prb_close_block(pkc, pbd, po, status);
> >               return;
> > @@ -944,7 +943,8 @@ static int prb_queue_frozen(struct tpacket_kbdq_core *pkc)
> >  static void prb_clear_blk_fill_status(struct packet_ring_buffer *rb)
> >  {
> >       struct tpacket_kbdq_core *pkc  = GET_PBDQC_FROM_RB(rb);
> > -     atomic_dec(&pkc->blk_fill_in_prog);
> > +
> > +     read_unlock(&pkc->blk_fill_in_prog_lock);
> >  }
> >
> >  static void prb_fill_rxhash(struct tpacket_kbdq_core *pkc,
> > @@ -998,7 +998,7 @@ static void prb_fill_curr_block(char *curr,
> >       pkc->nxt_offset += TOTAL_PKT_LEN_INCL_ALIGN(len);
> >       BLOCK_LEN(pbd) += TOTAL_PKT_LEN_INCL_ALIGN(len);
> >       BLOCK_NUM_PKTS(pbd) += 1;
> > -     atomic_inc(&pkc->blk_fill_in_prog);
> > +     read_lock(&pkc->blk_fill_in_prog_lock);
> >       prb_run_all_ft_ops(pkc, ppd);
> >  }
> >
> > diff --git a/net/packet/internal.h b/net/packet/internal.h
> > index 907f4cd2a718..fd41ecb7f605 100644
> > --- a/net/packet/internal.h
> > +++ b/net/packet/internal.h
> > @@ -39,7 +39,7 @@ struct tpacket_kbdq_core {
> >       char            *nxt_offset;
> >       struct sk_buff  *skb;
> >
> > -     atomic_t        blk_fill_in_prog;
> > +     rwlock_t        blk_fill_in_prog_lock;
> >
> >       /* Default is set to 8ms */
> >  #define DEFAULT_PRB_RETIRE_TOV       (8)
>
