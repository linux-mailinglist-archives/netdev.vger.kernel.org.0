Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608FD37085E
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhEASVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhEASVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 14:21:53 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5434FC06174A;
        Sat,  1 May 2021 11:21:03 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3385043wmy.5;
        Sat, 01 May 2021 11:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6sKudlOsl1E5v5OKZfkGBtnQCMpZsVSoRa3EoGC31s=;
        b=G9uB8TmhAi1iadOTruSkphOWzDCSfIa/vYszdAxx/K5ONca3CjqUoywh9oCQVmYbpD
         6mPSlZpX/uZRhjYmmf5QHRgM0qD03nghTWVsYL09wAcsA/02WJ8B8e/sskRFSb15cOv6
         Xxn2bKZIDP1xiSST87j/GTL0HAWLQg5YlkRyR/Z5GZq2zTaMjTxZUTmqyYk6zdcrAg6k
         U/Md1p7hs+0tm56qWgQPkbodLDfdAbcqBAGHhat/kKQAnuKNhx12jZ2ssROIWi065r8x
         EPMdHdixLZ6B2xhvdrMNuOQbDt5bv6Jl/LszIQ2WbF33Sq38OtBmxVnVTd28CTTdnNy3
         B5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6sKudlOsl1E5v5OKZfkGBtnQCMpZsVSoRa3EoGC31s=;
        b=nmJ9lUZI9KbiYO9NpyYQwGA/m+XFSSo6T9iUX1iJCxwRt4Y8wuLOetGH2J0EKewKcO
         YCvcJLmHxB5q/S1pfFK0JyEPePZ2WBmh8xMzCuMJFMnTJbMzAYJ9ceElnhNG/JhFvvHT
         t+rJ4CiCpDmhzee10XD6C4Irfn/3wSLnMg9lWGuDsIj9GFfCjS1yq6EaHzlR+ozbNm8p
         nhV6UY3+J8rzb9KsHd+PrG2ZA89/KaBcdzSszNa+lzE7SG4piZ9uJ1w8gYF/Y6vrL0On
         14Y9U/YTLjs2b1pIKMdN9pmc0x5xMAjScOxL5cLA1CzX1WtFSlhj722QLtc0UvKe3L/Z
         rYMQ==
X-Gm-Message-State: AOAM530WOYz5NmyLlEKv2wiDcUt5fSE7fpgbiqaG2l0/iO/BOYtd/PcX
        9NJ36zwES3AHwznyeJR15dU0InUre7C6sEyxJes=
X-Google-Smtp-Source: ABdhPJxayEJuPuG1XSPIBkBAoha8FSd7hdLqMO4RgYFcb842ivFkrRj1HzUdgIZADIPC7uzABJuokAGLF0uBVyh4KMQ=
X-Received: by 2002:a1c:7402:: with SMTP id p2mr23021719wmc.88.1619893261907;
 Sat, 01 May 2021 11:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1619812899.git.lucien.xin@gmail.com> <371d885e4d50b379aff56babe77517f6ccc32651.1619812899.git.lucien.xin@gmail.com>
 <HE1PR0702MB38180121DAFDF7D7FEA001D5EC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB38180121DAFDF7D7FEA001D5EC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 1 May 2021 14:20:50 -0400
Message-ID: <CADvbK_eEiZb87wVAGrEDpHC-6MLZBBpMuZb2b=VUqnE7W-cHDg@mail.gmail.com>
Subject: Re: [PATCHv2 net 3/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_b
To:     "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 1, 2021 at 12:57 PM Leppanen, Jere (Nokia - FI/Espoo)
<jere.leppanen@nokia.com> wrote:
>
> On Fri, 30 Apr 2021, Xin Long wrote:
>
> > The same thing should be done for sctp_sf_do_dupcook_b().
> > Meanwhile, SCTP_CMD_UPDATE_ASSOC cmd can be removed.
> >
> > v1->v2:
> >  - Fix the return value in sctp_sf_do_assoc_update().
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > ---
> > include/net/sctp/command.h |  1 -
> > net/sctp/sm_sideeffect.c   | 26 -------------------------
> > net/sctp/sm_statefuns.c    | 47 +++++++++++++++++++++++++++++-----------------
> > 3 files changed, 30 insertions(+), 44 deletions(-)
> >
> > diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> > index e8df72e..5e84888 100644
> > --- a/include/net/sctp/command.h
> > +++ b/include/net/sctp/command.h
> > @@ -68,7 +68,6 @@ enum sctp_verb {
> >       SCTP_CMD_ASSOC_FAILED,   /* Handle association failure. */
> >       SCTP_CMD_DISCARD_PACKET, /* Discard the whole packet. */
> >       SCTP_CMD_GEN_SHUTDOWN,   /* Generate a SHUTDOWN chunk. */
> > -     SCTP_CMD_UPDATE_ASSOC,   /* Update association information. */
> >       SCTP_CMD_PURGE_OUTQUEUE, /* Purge all data waiting to be sent. */
> >       SCTP_CMD_SETUP_T2,       /* Hi-level, setup T2-shutdown parms.  */
> >       SCTP_CMD_RTO_PENDING,    /* Set transport's rto_pending. */
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index 0948f14..ce15d59 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -826,28 +826,6 @@ static void sctp_cmd_setup_t2(struct sctp_cmd_seq *cmds,
> >       asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
> > }
> >
> > -static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,
> > -                               struct sctp_association *asoc,
> > -                               struct sctp_association *new)
> > -{
> > -     struct net *net = asoc->base.net;
> > -     struct sctp_chunk *abort;
> > -
> > -     if (!sctp_assoc_update(asoc, new))
> > -             return;
> > -
> > -     abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> > -     if (abort) {
> > -             sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> > -             sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> > -     }
> > -     sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> > -     sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
> > -                     SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> > -     SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> > -     SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> > -}
> > -
> > /* Helper function to change the state of an association. */
> > static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> >                              struct sctp_association *asoc,
> > @@ -1301,10 +1279,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
> >                       sctp_endpoint_add_asoc(ep, asoc);
> >                       break;
> >
> > -             case SCTP_CMD_UPDATE_ASSOC:
> > -                    sctp_cmd_assoc_update(commands, asoc, cmd->obj.asoc);
> > -                    break;
> > -
> >               case SCTP_CMD_PURGE_OUTQUEUE:
> >                      sctp_outq_teardown(&asoc->outqueue);
> >                      break;
> > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > index e8ccc4e..a428449 100644
> > --- a/net/sctp/sm_statefuns.c
> > +++ b/net/sctp/sm_statefuns.c
> > @@ -1773,6 +1773,30 @@ enum sctp_disposition sctp_sf_do_5_2_3_initack(
> >               return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
> > }
> >
> > +static int sctp_sf_do_assoc_update(struct sctp_association *asoc,
> > +                                struct sctp_association *new,
> > +                                struct sctp_cmd_seq *cmds)
> > +{
> > +     struct net *net = asoc->base.net;
> > +     struct sctp_chunk *abort;
> > +
> > +     if (!sctp_assoc_update(asoc, new))
> > +             return 0;
> > +
> > +     abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> > +     if (abort) {
> > +             sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> > +             sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> > +     }
> > +     sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> > +     sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
> > +                     SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> > +     SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> > +     SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> > +
> > +     return -ENOMEM;
> > +}
> > +
> > /* Unexpected COOKIE-ECHO handler for peer restart (Table 2, action 'A')
> >  *
> >  * Section 5.2.4
> > @@ -1853,21 +1877,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
> >       sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
> >
> >       /* Update the content of current association. */
> > -     if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
> > -             struct sctp_chunk *abort;
> > -
> > -             abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> > -             if (abort) {
> > -                     sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> > -                     sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> > -             }
> > -             sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> > -             sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
> > -                             SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> > -             SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> > -             SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> > +     if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
> >               goto nomem;
> > -     }
> >
> >       repl = sctp_make_cookie_ack(asoc, chunk);
> >       if (!repl)
> > @@ -1940,14 +1951,16 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
> >       if (!sctp_auth_chunk_verify(net, chunk, new_asoc))
> >               return SCTP_DISPOSITION_DISCARD;
> >
> > -     /* Update the content of current association.  */
> > -     sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
> >       sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
> >                       SCTP_STATE(SCTP_STATE_ESTABLISHED));
> >       SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
> >       sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
> >
> > -     repl = sctp_make_cookie_ack(new_asoc, chunk);
> > +     /* Update the content of current association.  */
> > +     if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
> > +             goto nomem;
>
> Wouldn't it be better to do the update before SCTP_CMD_NEW_STATE?
> Or do we have some reason to move to SCTP_STATE_ESTABLISHED even
> if the update fails?
Yes, as sctp_sf_do_assoc_update() adds SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB),
and before that we have to keep SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB) added
in there, which is normally right after NEW_STATE cmd with ESTABLISHED.

>
> > +
> > +     repl = sctp_make_cookie_ack(asoc, chunk);
> >       if (!repl)
> >               goto nomem;
> >
> > --
> > 2.1.0
