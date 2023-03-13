Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A946B7F37
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCMRRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCMRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:17:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E7E4690;
        Mon, 13 Mar 2023 10:17:02 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t15so12021445wrz.7;
        Mon, 13 Mar 2023 10:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678727776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47d6taB7/MZ6YZbSesVGjWTXifSAYTZlkflqE0tXlfM=;
        b=Yq+O+O/j6/AxYf44A9hDFiCW0W92T6XjbAiMJV2vJK1leFN5jYpefJ/oqX6jfbggbS
         GlqBFkCO9VZPLBsVpsSndWwgVCjLKs0CU/zdUV/aRtglqI5vbfLpZbamMvu3xPPpxehQ
         UC0JdKeCx6tIBKakeuhdq4CSOHumnHZzpTjAIu9BdnTWsk2qdwmsMc/oyhKRBZIx0wy+
         a7Ad3WB5ymtjDmaM3YUQw6A01NBcILiePMhfdRNtfjRrEQ3k8s/ah3jjMgXVzLqFIFGf
         XT231hoXeB9qBtfMHspRGzqgR8UUZc/VRtFVdrS1s0dmsNJoAPArmd5vPapLfDbB0Kfb
         5XgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678727776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47d6taB7/MZ6YZbSesVGjWTXifSAYTZlkflqE0tXlfM=;
        b=xU48qSU8rgRLT9NEfM/PHMXWjk8k9HZBQaJXm9IqDtMTUhABrEDkaIfXNDkg91A836
         MhH0W7oaIZRYzBxymE1LT+2ZMAuuoZnH+88DWgLNskc6OJzAhGm6SxBWsvxDT5ZD8Vu+
         x7kjg8SzSDoWAzNY/JhFiqcfQZiDn2FXScOWd1//vquRP2A8C8Vlbusm295odyhyDVxB
         i5sDv8hd7Oo7OWeRLTiZvdzgZqEP9Yg0k8Qb3q3CCAK7oUKEj5oGVEH8XhFBAgT5rzms
         9yLbJWD6Cv61FZRjchZK/0wcT1eV1JG78xB8DOY/k0A42cuo+r24q86e9FECLALuXcF8
         sJqw==
X-Gm-Message-State: AO0yUKWL+2PFGXxN3SX4JgpcQkg+CN+7NyoCBgcI/8sIGAeVpHWtR4y/
        xJvZZW2QZDRaWy3LyJdTNlYVK92XTKW1+Ah6Fnc=
X-Google-Smtp-Source: AK7set8lxbNMKIKwoVxMiSXTcq+UiBKK0Gj1lKTABg5wdq3FcR72lilFXdQfWnuRjRuOHLMdecY/hfHlARsqjJmdwsY=
X-Received: by 2002:adf:f452:0:b0:2ce:a631:4a0 with SMTP id
 f18-20020adff452000000b002cea63104a0mr1173907wrp.14.1678727776071; Mon, 13
 Mar 2023 10:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
 <CAL+tcoAchbTk9ibrAVH-bZ-0KHJ8g3XnsQHFWiBosyNgYJtymA@mail.gmail.com> <CANn89i+uS7-mA227g6yJfTK4ugdA82z+PLV9_74f1dBMo_OhEg@mail.gmail.com>
In-Reply-To: <CANn89i+uS7-mA227g6yJfTK4ugdA82z+PLV9_74f1dBMo_OhEg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 01:15:39 +0800
Message-ID: <CAL+tcoCsQ18ae+hUwqFigerJQfhrusuOOC63Wc+ZGyGWEvSFBQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:59=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Mon, Mar 13, 2023 at 6:16=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > On Mon, Mar 13, 2023 at 8:34=E2=80=AFPM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > On Sat, Mar 11, 2023 at 7:18=E2=80=AFAM Jason Xing <kerneljasonxing@g=
mail.com> wrote:
> > > >
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > Sometimes we need to know which one of backlog queue can be exactly
> > > > long enough to cause some latency when debugging this part is neede=
d.
> > > > Thus, we can then separate the display of both.
> > > >
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > ---
> > > >  net/core/net-procfs.c | 17 ++++++++++++-----
> > > >  1 file changed, 12 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > > > index 1ec23bf8b05c..97a304e1957a 100644
> > > > --- a/net/core/net-procfs.c
> > > > +++ b/net/core/net-procfs.c
> > > > @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq,=
 void *v)
> > > >         return 0;
> > > >  }
> > > >
> > > > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > > > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> > > >  {
> > > > -       return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > > > -              skb_queue_len_lockless(&sd->process_queue);
> > > > +       return skb_queue_len_lockless(&sd->input_pkt_queue);
> > > > +}
> > > > +
> > > > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > > > +{
> > > > +       return skb_queue_len_lockless(&sd->process_queue);
> > > >  }
> > > >
> > > >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > > > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *=
seq, void *v)
> > > >          * mapping the data a specific CPU
> > > >          */
> > > >         seq_printf(seq,
> > > > -                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %0=
8x %08x %08x %08x\n",
> > > > +                  "%08x %08x %08x %08x %08x %08x %08x %08x %08x %0=
8x %08x %08x %08x "
> > > > +                  "%08x %08x\n",
> > > >                    sd->processed, sd->dropped, sd->time_squeeze, 0,
> > > >                    0, 0, 0, 0, /* was fastroute */
> > > >                    0,   /* was cpu_collision */
> > > >                    sd->received_rps, flow_limit_count,
> > > > -                  softnet_backlog_len(sd), (int)seq->index);
> > > > +                  0,   /* was len of two backlog queues */
> > >
> > > You can not pretend the sum is zero, some user space tools out there
> > > would be fooled.
> > >
> > > > +                  (int)seq->index,
> > > > +                  softnet_input_pkt_queue_len(sd), softnet_process=
_queue_len(sd));
> > > >         return 0;
> > > >  }
> > > >
> > > > --
> > > > 2.37.3
> > > >
> > >
> > > In general I would prefer we no longer change this file.
> >
> > Fine. Since now, let this legacy file be one part of history.
> >
> > >
> > > Perhaps add a tracepoint instead ?
> >
> > Thanks, Eric. It's one good idea. It seems acceptable if we only need
> > to trace two separate backlog queues where it can probably hit the
> > limit, say, in the enqueue_to_backlog().
>
>
[...]
> Note that enqueue_to_backlog() already uses a specific kfree_skb_reason()=
 reason
> (SKB_DROP_REASON_CPU_BACKLOG) so existing infrastructure should work just=
 fine.

Sure, I noticed that. It traces all the kfree_skb paths, not only
softnet_data. If it isn't proper, what would you recommend where to
put the trace function into? Now I'm thinking of resorting to the
legacy file we discussed above :(

>
>
> >
> > Similarly I decide to write another two tracepoints of time_squeeze
> > and budget_squeeze which I introduced to distinguish from time_squeeze
> > as the below link shows:
> > https://lore.kernel.org/lkml/CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZ=
aQHjrx0Hw@mail.gmail.com/.
> > For that change, any suggestions are deeply welcome :)
> >
>
> For your workloads to hit these limits enough for you to be worried,
> it looks like you are not using any scaling stuff documented
> in Documentation/networking/scaling.rst

Thanks for the guidance. Scaling is a good way to go really. But I
just would like to separate these two kinds of limits to watch them
closely. More often we cannot decide to adjust accurately which one
should be adjusted. Time squeeze may not be clear and we cannot
randomly write a larger number into both proc files which may do harm
to some external customers unless we can show some proof to them.

Maybe I got something wrong. If adding some tracepoints for those
limits in softnet_data is not elegant, please enlighten me :)

Thanks,
Jason
