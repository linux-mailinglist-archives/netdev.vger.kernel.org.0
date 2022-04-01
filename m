Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F29B4EE507
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbiDAAL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiDAAL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:11:57 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C0E3C732;
        Thu, 31 Mar 2022 17:10:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g20so1111445edw.6;
        Thu, 31 Mar 2022 17:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQ35mcHW9PpHQYH0T0kI8l/DH4WYfOppOS30rqmBEbs=;
        b=btc/twgw5RlR+yat5KbCqymtiEM/wuE9wnD6UaafOxguLb1AjOIZqAz2abP/yKurZr
         DcdNPGkFq/Q/ftQOYt9LtkyWEKuGiYTGk4JFi6ElkZSOs4G369jhffT3AG7JpzYLylde
         ntJCo067c/rNwfhYbOqz/f2G0zGK9MbMiIIrEnIvSC0TwacTH6BriCi831jWo7fLJL1W
         /qJXnUNN1w3d9dedJYiDzP9VPqyCbnEa+2Ysi3s9lwhqQ+jmmzd7/UoBn46nx/Twqr1J
         0kIncpALbxxARdrcHjsA9SG60BAAV85qDKOKnlrCtZfvO3YNsOKADjqdyB4GDl3JV7WB
         ZTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQ35mcHW9PpHQYH0T0kI8l/DH4WYfOppOS30rqmBEbs=;
        b=NDp+wM36euPSsZY1WYtBmGC4gdrxuNnYjTjpn7hqE6VJ7sRmphOpyvdA0l/0UPzqZh
         as38XWM3wi8+0eAu1v9daqr0EXvN+d95U+6Vn8u0N/ehkBPBXrbStiVh0DFMaiERb2XS
         kGuoF4v9a1VtJEwqpySh57XMiqiJclJdQY+gjiVnK/7XB2rkxB4/dHly1Lb7IAAvYaKK
         3aO30jQ5uMQpQjVrLnCm/s/3jZzd4VlP8H7PrfA5f6IMJps5CRBZm4eAt3w2G6t3+BoT
         0wbZhhodF8zoH9+7fpZqwT14j8E88y6sElvOGmBpKDcgcqt8buRY3GG+QsSgNrePzUq3
         z7lg==
X-Gm-Message-State: AOAM531SvxFf5AaV5e5mDisWlKPxQFkULhdKX39UgxteeTZxZZXGof7t
        bX0me5hPCvf/9FRVyPCFqu/TYYQXzrYMw1GFrKw=
X-Google-Smtp-Source: ABdhPJyHhPquQJAF43FHs2QL0FzQYEQoV+71yuTm2UT9QUAaWqMXek9tYvze6kAgf0o9WaluBRBZxaVsmcZwgmkedvs=
X-Received: by 2002:a05:6402:454:b0:416:2db7:685b with SMTP id
 p20-20020a056402045400b004162db7685bmr18669177edw.43.1648771807089; Thu, 31
 Mar 2022 17:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <0dfee8c9d17c20f9a87c39dbc57f635d998b08d2.1648609552.git.jamie.bainbridge@gmail.com>
 <YkSzLJ72M5f5EL2L@t14s.localdomain>
In-Reply-To: <YkSzLJ72M5f5EL2L@t14s.localdomain>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Fri, 1 Apr 2022 10:09:56 +1000
Message-ID: <CAAvyFNgL1_YsnkGdJM8t9L1zT60AEfUMeReVx=2DTtLZ_WLScQ@mail.gmail.com>
Subject: Re: [PATCH v3 net] sctp: count singleton chunks in assoc user stats
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 at 05:44, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Mar 30, 2022 at 01:06:02PM +1000, Jamie Bainbridge wrote:
> > Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
> > COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> > counter available to the assoc owner.
> >
> > These are all control chunks so they should be counted as such.
> >
> > Add counting of singleton chunks so they are properly accounted for.
> >
> > Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
> > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > ---
> >  net/sctp/outqueue.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > index a18609f608fb786b2532a4febbd72a9737ab906c..bed34918b41f24810677adc0cd4fbd0859396a02 100644
> > --- a/net/sctp/outqueue.c
> > +++ b/net/sctp/outqueue.c
> > @@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
> >                               ctx->asoc->base.sk->sk_err = -error;
> >                               return;
> >                       }
> > +                     ctx->asoc->stats.octrlchunks++;
> >                       break;
> >
> >               case SCTP_CID_ABORT:
> > @@ -939,6 +940,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
> >               case SCTP_CID_HEARTBEAT:
> >                       if (chunk->pmtu_probe) {
> >                               sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
> > +                             ctx->asoc->stats.octrlchunks++;
>
> sctp_packet_singleton can fail. It shouldn't be propagated to the
> socket but octrlchunks shouldn't be incremented then. Not too diferent
> from the one above.

Ah, thanks for the catch! Is this syntax assigning to error okay?

error = sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
if (!error)
          ctx->asoc->stats.octrlchunks++;
break;

> >                               break;
> >                       }
> >                       fallthrough;
> > --
> > 2.35.1
> >
