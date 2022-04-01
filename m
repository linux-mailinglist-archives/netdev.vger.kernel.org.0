Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8541E4EE54A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbiDAAYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbiDAAYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:24:09 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FEE24B5DC;
        Thu, 31 Mar 2022 17:22:20 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id z11-20020a4a9c8b000000b00328fdb15e4aso259860ooj.6;
        Thu, 31 Mar 2022 17:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HcEfpUQ3ounoEk46WpuTl4ogomoHLXuRyy0X+DJ0MeA=;
        b=JSgJKyOpJs0xV3p+zEHc4PIOtGNQpU0SC3R4Fm4w0pjs+USel1zNkXnecZYa+hrD2q
         DyXfwoxngF6ZfKcvBAeuZGtmxzU+ftNi5d8BLmnBJwluC1XX4av9zrcMl4KAlW3uErit
         AXRY0eyZKFZx1sNOOOxJ4f1qvoX2YfrOLQs7WQm7+eVq7jXcTfOI1ykvxoXSTJIXZTy6
         Bk9O6trJeCj9OdWm0H1RFYx3RWYeXTD5sK2BXXhCC5Ly8DM7yAoBd5xeAGdtglXh6NhE
         4kd53qDBcJnQ3+GzlTy3qu5Kf+C5LjBuFQoNMF1UYHWBI5ccneOFJu/8CwV65ffEBzPN
         Z/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HcEfpUQ3ounoEk46WpuTl4ogomoHLXuRyy0X+DJ0MeA=;
        b=xsO7iT5NXrx9HgwcA9f8eJ/4e7UIlVTPwhHQC3/jWYztIvLS4N+9AFAAMoyfVFIEHx
         HUqKTTU43wLUDkoMoP27juaevVrWqKdN++rtzOYEVmvgs6hxpsA3feaVqK9jFvC8V8XQ
         V2kjwYa0U0dpNs1X42CEcVIWVvL2AKzzLXR0IZ9uFLZdd0hGWSFOQEchIYQZwIbCfhDP
         LVQb3T7nNz4nFka0wn+9eKjY1ANSKHFxF/+fQaTEr0PaoMHA0sKt/LsjMOdpb61ep7kv
         QFSNbJPiW4C/E14FZUD1jNnj1N5MKDCG1PyrISm420+QAux3Qe2XqO1Ob54E74BkSm9A
         vwqQ==
X-Gm-Message-State: AOAM531yKa6SP05TFuGSpMOsihVGJDQTa07JSp7emwxjpLkE07Dp8GVF
        BE5CbfDG1BPPEhPhse9fwgQ=
X-Google-Smtp-Source: ABdhPJyeuGZz9Lv5rSihUtjPQgKyt4h9XysfgN4ssHGxZ5s/zKbKdhYYaGxEux7uoRoQcDlORiTWAg==
X-Received: by 2002:a4a:4245:0:b0:2da:d703:5561 with SMTP id i5-20020a4a4245000000b002dad7035561mr6019708ooj.57.1648772539475;
        Thu, 31 Mar 2022 17:22:19 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:f748:287d:843:bb36:1a30])
        by smtp.gmail.com with ESMTPSA id s82-20020acadb55000000b002d9ce64bea0sm403698oig.48.2022.03.31.17.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 17:22:19 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 943811D69B8; Thu, 31 Mar 2022 21:22:17 -0300 (-03)
Date:   Thu, 31 Mar 2022 21:22:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net] sctp: count singleton chunks in assoc user stats
Message-ID: <YkZFuWQOEh5webSr@t14s.localdomain>
References: <0dfee8c9d17c20f9a87c39dbc57f635d998b08d2.1648609552.git.jamie.bainbridge@gmail.com>
 <YkSzLJ72M5f5EL2L@t14s.localdomain>
 <CAAvyFNgL1_YsnkGdJM8t9L1zT60AEfUMeReVx=2DTtLZ_WLScQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAvyFNgL1_YsnkGdJM8t9L1zT60AEfUMeReVx=2DTtLZ_WLScQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 10:09:56AM +1000, Jamie Bainbridge wrote:
> On Thu, 31 Mar 2022 at 05:44, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Mar 30, 2022 at 01:06:02PM +1000, Jamie Bainbridge wrote:
> > > Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
> > > COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> > > counter available to the assoc owner.
> > >
> > > These are all control chunks so they should be counted as such.
> > >
> > > Add counting of singleton chunks so they are properly accounted for.
> > >
> > > Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
> > > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > > ---
> > >  net/sctp/outqueue.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > > index a18609f608fb786b2532a4febbd72a9737ab906c..bed34918b41f24810677adc0cd4fbd0859396a02 100644
> > > --- a/net/sctp/outqueue.c
> > > +++ b/net/sctp/outqueue.c
> > > @@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
> > >                               ctx->asoc->base.sk->sk_err = -error;
> > >                               return;
> > >                       }
> > > +                     ctx->asoc->stats.octrlchunks++;
> > >                       break;
> > >
> > >               case SCTP_CID_ABORT:
> > > @@ -939,6 +940,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
> > >               case SCTP_CID_HEARTBEAT:
> > >                       if (chunk->pmtu_probe) {
> > >                               sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
> > > +                             ctx->asoc->stats.octrlchunks++;
> >
> > sctp_packet_singleton can fail. It shouldn't be propagated to the
> > socket but octrlchunks shouldn't be incremented then. Not too diferent
> > from the one above.
> 
> Ah, thanks for the catch! Is this syntax assigning to error okay?
> 
> error = sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
> if (!error)
>           ctx->asoc->stats.octrlchunks++;
> break;

Yes. :-)

> 
> > >                               break;
> > >                       }
> > >                       fallthrough;
> > > --
> > > 2.35.1
> > >
