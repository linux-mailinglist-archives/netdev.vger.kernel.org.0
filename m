Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44E7370111
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhD3TR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhD3TRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:17:24 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6909FC06174A;
        Fri, 30 Apr 2021 12:16:35 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l14so1906061wrx.5;
        Fri, 30 Apr 2021 12:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yLdUQlKZpoqTrZvveomd5tmMvK3hnrlcj+SYUvyIlAE=;
        b=ccFpyBmzmOTK9okYEOsUgGeZysMVIEOtCP59dX5TiO1pZLgrEAt5PGXLkUIZlxKYJl
         Ng9GwRy/qVvhKc/z01zc2vznajGmz286eBRqZ0LEuGqsa5v+cmzvMLVZBZ1ac3xhs0bW
         mJMRu4X27dAAHUmluBL7EsTGp9Q8Z932Iw+LuJBH3x7j2Fm30OKzPsJxAjXkdh8cM3Kb
         1mSurv3eLYMhdMp8aoernu3KDOkoS7oHuFjYbcVyNoPymTMKcBsCr/TSisQGjipqlKq0
         yFgjRXtJbiFHAO95nKOaXdzU0qLXR6iDF5Pe/mtCGKPdZnIG3I94HRoKjWnXmcc3+SCP
         rJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yLdUQlKZpoqTrZvveomd5tmMvK3hnrlcj+SYUvyIlAE=;
        b=uKcaR/W9lD34ifs22YQUnbelCRuTw9yNfbP02Gc7Lt6NxEN5Mf7FzfOKM6pspY2fHp
         GPbdiJDWvscfMp38h6GxLYQ+H6tMTOQhIjmS92TmW8ry5JsJTE7QBENvLuuoYuoK471Y
         kzToyoCT23xJ65AOXFhrmzEcW63Y7gVOExKGRDzGoOdkH/UwURKkPREMxaSXtt93FiUw
         4w7RsJZmzNF2olC9mONVQHsMPr8QLIKDG0gjmbsCX5tNiKowPM4ueOYCDOnrsLrk5paK
         0uTt6vuprP131RujiSEdbgV7zlxM7ghITfRc0Y/kIpp4JwG7Xt7OhuYp0wejcBAITl42
         WftQ==
X-Gm-Message-State: AOAM531hvGsnPSGL0Xy+jQvpFMNe/bPA79I3dnz8Vno6duYd+u3jRy/V
        RiJ4txjSST4ExqO8pTIj/bmOV8Ci15dllM8NsNbZvz9/KfT6xBNx
X-Google-Smtp-Source: ABdhPJwnfByDgaM+DYf+7lt5xlPkU718yK0OizcRpKMf+ApGcPj6WjlV7HPRjH28AemZpepcW0kRuY847d8SUXPoV1Y=
X-Received: by 2002:adf:f451:: with SMTP id f17mr8907594wrp.330.1619810193657;
 Fri, 30 Apr 2021 12:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <ab7a35c9888202a34079baaa835294422bc3b5b3.1619806333.git.lucien.xin@gmail.com>
 <cover.1619806333.git.lucien.xin@gmail.com> <8a5afb3b24785e8837332dbec388ddf4f40c2297.1619806333.git.lucien.xin@gmail.com>
 <bfe29b3751cb5d0d65e79ba0fb5bbd897cd35a50.1619806333.git.lucien.xin@gmail.com>
In-Reply-To: <bfe29b3751cb5d0d65e79ba0fb5bbd897cd35a50.1619806333.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 30 Apr 2021 15:16:21 -0400
Message-ID: <CADvbK_ccFXTPLORPi9efLQp-z9Kgu+urVJOgkNR14NFh1gC7fQ@mail.gmail.com>
Subject: Re: [PATCH net 3/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_b
To:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 2:16 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> The same thing should be done for sctp_sf_do_dupcook_b().
> Meanwhile, SCTP_CMD_UPDATE_ASSOC cmd can be removed.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/command.h |  1 -
>  net/sctp/sm_sideeffect.c   | 26 -------------------------
>  net/sctp/sm_statefuns.c    | 47 +++++++++++++++++++++++++++++-----------------
>  3 files changed, 30 insertions(+), 44 deletions(-)
>
> diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> index e8df72e..5e84888 100644
> --- a/include/net/sctp/command.h
> +++ b/include/net/sctp/command.h
> @@ -68,7 +68,6 @@ enum sctp_verb {
>         SCTP_CMD_ASSOC_FAILED,   /* Handle association failure. */
>         SCTP_CMD_DISCARD_PACKET, /* Discard the whole packet. */
>         SCTP_CMD_GEN_SHUTDOWN,   /* Generate a SHUTDOWN chunk. */
> -       SCTP_CMD_UPDATE_ASSOC,   /* Update association information. */
>         SCTP_CMD_PURGE_OUTQUEUE, /* Purge all data waiting to be sent. */
>         SCTP_CMD_SETUP_T2,       /* Hi-level, setup T2-shutdown parms.  */
>         SCTP_CMD_RTO_PENDING,    /* Set transport's rto_pending. */
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 0948f14..ce15d59 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -826,28 +826,6 @@ static void sctp_cmd_setup_t2(struct sctp_cmd_seq *cmds,
>         asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
>  }
>
> -static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,
> -                                 struct sctp_association *asoc,
> -                                 struct sctp_association *new)
> -{
> -       struct net *net = asoc->base.net;
> -       struct sctp_chunk *abort;
> -
> -       if (!sctp_assoc_update(asoc, new))
> -               return;
> -
> -       abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> -       if (abort) {
> -               sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> -               sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> -       }
> -       sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> -       sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
> -                       SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> -       SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> -       SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> -}
> -
>  /* Helper function to change the state of an association. */
>  static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
>                                struct sctp_association *asoc,
> @@ -1301,10 +1279,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
>                         sctp_endpoint_add_asoc(ep, asoc);
>                         break;
>
> -               case SCTP_CMD_UPDATE_ASSOC:
> -                      sctp_cmd_assoc_update(commands, asoc, cmd->obj.asoc);
> -                      break;
> -
>                 case SCTP_CMD_PURGE_OUTQUEUE:
>                        sctp_outq_teardown(&asoc->outqueue);
>                        break;
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index e8ccc4e..d0b6036 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1773,6 +1773,30 @@ enum sctp_disposition sctp_sf_do_5_2_3_initack(
>                 return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
>  }
>
> +static int sctp_sf_do_assoc_update(struct sctp_association *asoc,
> +                                  struct sctp_association *new,
> +                                  struct sctp_cmd_seq *cmds)
> +{
> +       struct net *net = asoc->base.net;
> +       struct sctp_chunk *abort;
> +
> +       if (!sctp_assoc_update(asoc, new))
> +               return -ENOMEM;
sorry, sctp_assoc_update returns errors, and here it should return 0;

> +
> +       abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> +       if (abort) {
> +               sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> +               sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> +       }
> +       sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> +       sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,
> +                       SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> +       SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> +       SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> +
> +       return 0;
return ENOMEM;

will post v2.
> +}
> +
>  /* Unexpected COOKIE-ECHO handler for peer restart (Table 2, action 'A')
>   *
>   * Section 5.2.4
> @@ -1853,21 +1877,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
>         sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
>
>         /* Update the content of current association. */
> -       if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
> -               struct sctp_chunk *abort;
> -
> -               abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
> -               if (abort) {
> -                       sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
> -                       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> -               }
> -               sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
> -               sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
> -                               SCTP_PERR(SCTP_ERROR_RSRC_LOW));
> -               SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
> -               SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
> +       if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
>                 goto nomem;
> -       }
>
>         repl = sctp_make_cookie_ack(asoc, chunk);
>         if (!repl)
> @@ -1940,14 +1951,16 @@ static enum sctp_disposition sctp_sf_do_dupcook_b(
>         if (!sctp_auth_chunk_verify(net, chunk, new_asoc))
>                 return SCTP_DISPOSITION_DISCARD;
>
> -       /* Update the content of current association.  */
> -       sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
>         sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
>                         SCTP_STATE(SCTP_STATE_ESTABLISHED));
>         SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);
>         sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
>
> -       repl = sctp_make_cookie_ack(new_asoc, chunk);
> +       /* Update the content of current association.  */
> +       if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_asoc, commands))
> +               goto nomem;
> +
> +       repl = sctp_make_cookie_ack(asoc, chunk);
>         if (!repl)
>                 goto nomem;
>
> --
> 2.1.0
>
