Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4C8556CE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfFYSJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:09:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39213 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFYSJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:09:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so18927195wrt.6;
        Tue, 25 Jun 2019 11:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZecqvOpYjVE4Qmy3iXx46r1+0juBwCPcIwmCKG2SPQo=;
        b=ec+kKmKZbzDX7Zfqdhmxrx2YsnL4UQMEAcBHEVXnDm9Oyg9TktxFuNuPzyhJoO/5AR
         vtCvPowZ3sDh/R6kWqh72byj6M2c/oA7Nx+PHxC6gh04tc29HswFHyEo2h/qyv7rzsah
         sFrTVdMifkYhbqGTcAaCT2yCKf4PIDA5ujIqxtsePpkCJrFBSH2AhVdmt2y6YDVpTSKk
         31RezxlmomvcVpvRvpHBPJFeqij0pMlJ+lAxSwg2E5s/mv6jeK6NWQZvByqCeku/NO7Z
         0UUQcmk+zGSaR6FSFYsnOTiJW6E3GFNye7NaylMoYs074POeeq66EWNxpatFiiF85l8V
         YMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZecqvOpYjVE4Qmy3iXx46r1+0juBwCPcIwmCKG2SPQo=;
        b=EO6xEW9G3WlKp81iL4jI0EhgFqYSyVzppemhGbR6bf+yR88H5BeE4JHesFiK50HaSx
         zZOHzwP/AiH8rUljiYzMvFVoVuGtdLetpXdY9ksBjLgUZ6GihpWqKq5xB03tRaepeYKW
         qkbPWLPSHahWsTntKwweLUCyRKC8S7sV38kpiZlz3mXiyZBZ2g06akdzpAvqHj5kHca6
         TMNx2b+FA9sw6W8/OQWeN2kvuiIaLAxMzi3fUVQ/jURFWXmeHEF7U1V/mTHBqFv2ZML3
         QEyU17F25kzuhjUgJEda2UxvzCWdRQ0pQdl0sHy9tzbfExOyI+qDS6yvnHbPUtg7gnQj
         Uyeg==
X-Gm-Message-State: APjAAAUKX3ZMIpTx72gtRm09FczbzNXyuOaDi0WA4WEdcxRwZtTPFNgY
        UM9XkoJBLJTGoOvrQIXCEVQ1EjmogyWIKZLCnvY=
X-Google-Smtp-Source: APXvYqzhw69SkgOFk6LlkFmcnGAmxWjlPvy8XxMX2I7wJr8oGq7fwAAROAwIP+2Osw/KavN2yFmN1KPRvYp3fRiLe00=
X-Received: by 2002:a5d:5386:: with SMTP id d6mr19819643wrv.207.1561486158264;
 Tue, 25 Jun 2019 11:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190616153804.3604-1-hdanton@sina.com> <20190617134913.GL3436@localhost.localdomain>
 <20190617144331.GE3500@localhost.localdomain>
In-Reply-To: <20190617144331.GE3500@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 26 Jun 2019 02:09:06 +0800
Message-ID: <CADvbK_fWmRFs_wfcttH+1y6D_0zzZzKgpEOb64wYSGBA+1j86g@mail.gmail.com>
Subject: Re: general protection fault in sctp_sched_prio_sched
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 10:43 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Jun 17, 2019 at 10:49:13AM -0300, Marcelo Ricardo Leitner wrote:
> > Hi,
> >
> > On Sun, Jun 16, 2019 at 11:38:03PM +0800, Hillf Danton wrote:
> > >
> > > Hello Syzbot
> > >
> > > On Sat, 15 Jun 2019 16:36:06 -0700 (PDT) syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > ...
> > > Check prio_head and bail out if it is not valid.
> > >
> > > Thanks
> > > Hillf
> > > ----->8---
> > > ---
> > > net/sctp/stream_sched_prio.c | 2 ++
> > > 1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> > > index 2245083..db25a43 100644
> > > --- a/net/sctp/stream_sched_prio.c
> > > +++ b/net/sctp/stream_sched_prio.c
> > > @@ -135,6 +135,8 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
> > >     struct sctp_stream_priorities *prio, *prio_head;
> > >
> > >     prio_head = soute->prio_head;
> > > +   if (!prio_head)
> > > +           return;
> > >
> > >     /* Nothing to do if already scheduled */
> > >     if (!list_empty(&soute->prio_list))
> > > --
> >
> > Thanks but this is not a good fix for this. It will cause the stream
> > to never be scheduled.
> >
> > The problem happens because of the fault injection that happened a bit
> > before the crash, in here:
> >
> > int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
> > {
> >         struct sctp_stream_out_ext *soute;
> >
> >         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
> >         if (!soute)
> >                 return -ENOMEM;
> >         SCTP_SO(stream, sid)->ext = soute;  <---- [A]
> >
> >         return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> >                       ^^^^^^^^^^^^---- [B] failed
> > }
> >
> > This causes the 1st sendmsg to bail out with the error. When the 2nd
> > one gets in, it will:
> >
> > sctp_sendmsg_to_asoc()
> > {
> > ...
> >         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
> >                                                                  ^^^^^--- [C]
> >                 err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
> >                 if (err)
> >                         goto err;
> >         }
> >
> > [A] leaves ext initialized, despite the failed in [B]. Then in [C], it
> > will not try to initialize again.
> >
> > We need to either uninitialize ->ext as error handling for [B], or
> > improve the check on [C].
>
> The former one, please. This should be enough (untested):
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 93ed07877337..25946604af85 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -153,13 +153,20 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>  int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
>  {
>         struct sctp_stream_out_ext *soute;
> +       int ret;
>
>         soute = kzalloc(sizeof(*soute), GFP_KERNEL);
>         if (!soute)
>                 return -ENOMEM;
>         SCTP_SO(stream, sid)->ext = soute;
>
> -       return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +       ret = sctp_sched_init_sid(stream, sid, GFP_KERNEL);
> +       if (ret) {
> +               kfree(SCTP_SO(stream, sid)->ext);
> +               SCTP_SO(stream, sid)->ext = NULL;
> +       }
> +
> +       return ret;
>  }
>
>  void sctp_stream_free(struct sctp_stream *stream)
>

Tested-by: Xin Long <lucien.xin@gmail.com>

Hi, Marcelo, please feel free to move forward with this patch, :-)
