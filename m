Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE066B7207
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCMJG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCMJG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:06:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4578737B7D;
        Mon, 13 Mar 2023 02:03:45 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r15so18413420edq.11;
        Mon, 13 Mar 2023 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678698223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwWLM1c6cX4XHwV/ZwB+mDKGh28PG3T/6mefEaH6q0M=;
        b=Bpjs6KBnFscOkDJM5hSSfIcHBRueG1ngUF1VJRG9l3HVsLw38wRmabTOdPi67QqnmE
         Bzeoxb8g7f0RnNcG1GttjGXBdI8jQjiuLzaRoQ/ynb+llymfj2SEReqk9RRjH3Fuo/yT
         15J/cqxWqN5AJFSHzJ4Ln7yqMC3BPFC2335ukKtmhTeEd6sOsWk/xCd/pmFvipTbTaL0
         ZvFSfh+S7GaUp6rmBieBe73HJeOfcoQRjbI3TacX7Gx6O/7fphZ3kwx5Xl3lOOSc7Jri
         vqVrR3yGKszQo0cHaH/eyf5RmkP12o/Yy51Zab/dKnaoKFK+jauAeDxstnvTSZhItSAl
         ft8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678698223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AwWLM1c6cX4XHwV/ZwB+mDKGh28PG3T/6mefEaH6q0M=;
        b=UxyPnpwDbLE09HcSpnXHv2uKHfyOylW7H7gnLSCrIr2a2fEkxvcjPB8Ikp+YZ9q3gI
         LW1gFzWhSl+WjbK5AFXk3v1PoX77ow6x5YpUO3ddnHOATEi39yOCdEqCV/LLsoKkJ2wD
         ftIBcwYfqeuIw5i2N7qMQM8NhlDf7vtHxm2N+Waew83PAYZ0aM0CdYhFsmL7v6d1av5R
         ToPAL3M97CwDA09E754bpbqd637cDmMrEf1gHzxr3atz7mNmbZCFTQGjpv97/oaFUPMf
         bHWBz4opOiJ94+DoKMEAeTEwuMfubaFwY4P+3RlyvbK0NwMUXVmiuWFACrHNVwUvDV3Z
         kArQ==
X-Gm-Message-State: AO0yUKXPvshz0bN2dfkzFYqz4TXN1nEVCBqJnhV1efDYkfRnY+7PZNJV
        vdISStrAlwDmK1wOSUvy+rAIhAv9PF2al1ggkgc=
X-Google-Smtp-Source: AK7set84gtYJT9WuzY+KEDCbm7sTVykpIB9+gV6Ha3jQ9CVs29zaKVgb98IMfsKfgGgVQghx5TcXH7rpJULTTZMv4wU=
X-Received: by 2002:a17:906:60f:b0:8dd:70a:3a76 with SMTP id
 s15-20020a170906060f00b008dd070a3a76mr17503917ejb.11.1678698223649; Mon, 13
 Mar 2023 02:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <ZA4huzYKK/tdT3Ep@corigine.com> <CAL+tcoDi5fVWjyTX6wjJGKrszqL6JWkEgDBajhZchYSW7kyhGQ@mail.gmail.com>
 <20230312192847.0d58155e@hermes.local>
In-Reply-To: <20230312192847.0d58155e@hermes.local>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 13 Mar 2023 17:03:07 +0800
Message-ID: <CAL+tcoAqAFxLJyXCSX_=2zPLWuEZ_WhbA04FC1UG+KisE_UNYA@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Simon Horman <simon.horman@corigine.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

On Mon, Mar 13, 2023 at 10:28=E2=80=AFAM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 13 Mar 2023 09:55:37 +0800
> Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> > On Mon, Mar 13, 2023 at 3:02=E2=80=AFAM Simon Horman <simon.horman@cori=
gine.com> wrote:
> > >
> > > On Sat, Mar 11, 2023 at 11:17:56PM +0800, Jason Xing wrote:
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
> > > >       return 0;
> > > >  }
> > > >
> > > > -static u32 softnet_backlog_len(struct softnet_data *sd)
> > > > +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
> > > >  {
> > > > -     return skb_queue_len_lockless(&sd->input_pkt_queue) +
> > > > -            skb_queue_len_lockless(&sd->process_queue);
> > > > +     return skb_queue_len_lockless(&sd->input_pkt_queue);
> > > > +}
> > > > +
> > > > +static u32 softnet_process_queue_len(struct softnet_data *sd)
> > > > +{
> > > > +     return skb_queue_len_lockless(&sd->process_queue);
> > > >  }
> > > >
> > > >  static struct softnet_data *softnet_get_online(loff_t *pos)
> > > > @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *=
seq, void *v)
> > > >        * mapping the data a specific CPU
> > > >        */
> > > >       seq_printf(seq,
> > > > -                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x=
 %08x %08x %08x\n",
> > > > +                "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x=
 %08x %08x %08x "
> > > > +                "%08x %08x\n",
> > > >                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> > > >                  0, 0, 0, 0, /* was fastroute */
> > > >                  0,   /* was cpu_collision */
> > > >                  sd->received_rps, flow_limit_count,
> > > > -                softnet_backlog_len(sd), (int)seq->index);
> > > > +                0,   /* was len of two backlog queues */
> > > > +                (int)seq->index,
> > >
> > > nit: I think you could avoid this cast by using %llx as the format sp=
ecifier.
> >
> > I'm not sure if I should change this format since the above line is
> > introduced in commit 7d58e6555870d ('net-sysfs: add backlog len and
> > CPU id to softnet data').
> > The seq->index here manifests which cpu it uses, so it can be
> > displayed in 'int' format. Meanwhile, using %8x to output is much
> > cleaner if the user executes 'cat /proc/net/softnet_stat'.
> >
> > What do you think about this?
> >
> > Thanks,
> > Jason
>
> I consider sofnet_data a legacy API (ie don't change).
[...]
> Why not add to real sysfs for network device with the one value per file?

Well, I'm wondering if the way you suggested is probably not proper
because this structure is per cpu which means that we have 'num_cpus'
* 'how many members we should print' files. It's too many, I think.

/proc/net/softnet_stat is still a good choice :) I need more advice on this=
.

Thanks,
Jason
