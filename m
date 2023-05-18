Return-Path: <netdev+bounces-3708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D61770863E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEFD92815B4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE2424121;
	Thu, 18 May 2023 16:53:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3F23C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:53:36 +0000 (UTC)
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4529F0;
	Thu, 18 May 2023 09:53:34 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-ba878d5e75fso2722998276.3;
        Thu, 18 May 2023 09:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684428814; x=1687020814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lthi/IgkGX61/6lNRYlDHdQ6u2UdUukY+zN9UfNReaQ=;
        b=khRh5ZFn9/3BihSKp5QWKz89vQvdTdYcLyhNhoMZvrS3GZClbt3q67nAg/EU4nMj1a
         4RV7hoUmGsLCUfuG9xxFRgjVk33OWd3/PCEVb1GsMg1GAPkpvnGLCu0GQJcuYS2cASea
         OMgguup+ISIT+0yc/S5ERNxPoTGpNqZ6QzilBnXwyKM54QqCsuRMHSSbsudEaeKvLrp8
         9cL2HHPkB+RFYNSvVGF5UW1hSvpnk/o0E3fg/2UwMjP2nYfBFaMAI+wWPj3xXDPu5z50
         VV5kSetzwv4fKZ1U4YU2dOQN+QKNfmiVvZ+hn4WnNc8wvPzPxW0a9JZSkAdT9jGBsbxe
         gYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684428814; x=1687020814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lthi/IgkGX61/6lNRYlDHdQ6u2UdUukY+zN9UfNReaQ=;
        b=FFPDonTuQD7GevtHyNhh6+fpyV4es2mmuyJqhAy+7nEJHdWulQ8q/pqjtlBAPEzo7Y
         3DEh373y9x16y8r+r7z2sZzwD2D0uFQfaJFZYDlz4AtG3qnz0KJRvDFpJ0yZdNcVeGOy
         NFE17kmArxZwX+lfpRdWwSXlC4GUAF78DaKqV43rTePgTXR9bDA2HRx5/ij1EbAGqjgk
         dXpWjWoYYdWMnXtd7uy6QlMGdyyVZ0A9wHPBRIMWkq/h3qCfXrGIMsWfPm2a0rr0pXBK
         HKAS76IkknU3U0ybINIRt5U0/jX8tsyCzbEkd/+jjfTDPCphgJoOOYmg8wCK/KShc7OJ
         L58w==
X-Gm-Message-State: AC+VfDwuSq77mBmFVw9cRx8VwmQ8grjRLcy3W2go1GesG58KK4bRQmUR
	ks3IEfqvd/7WbSaeYmStjsaNbyxxEQqztpw6FGQ=
X-Google-Smtp-Source: ACHHUZ4iYDXXwFM15yI+s1PoLRsrutc3rZUCiX9Kvii3mQIrXmpwm5O0dtDdJWJsZgr0rYAvnopy+AvZo0TPv0Alxho=
X-Received: by 2002:a25:bce:0:b0:b92:3ed2:1cae with SMTP id
 197-20020a250bce000000b00b923ed21caemr2011368ybl.12.1684428813930; Thu, 18
 May 2023 09:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e72cc6c6ac5699659bb550fe04ec215ba393dd48.1684286522.git.lucien.xin@gmail.com>
 <5a49aee53de52cf3c24246ccf18391aabc0c5e50.camel@redhat.com>
In-Reply-To: <5a49aee53de52cf3c24246ccf18391aabc0c5e50.camel@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 18 May 2023 12:53:03 -0400
Message-ID: <CADvbK_e-J5YKjX6SAx_LZhshqzgi8vZQ0cv-YgS6FvaF5MJPDA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix an issue that plpmtu can never go to
 complete state
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 6:18=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Tue, 2023-05-16 at 21:22 -0400, Xin Long wrote:
> > When doing plpmtu probe, the probe size is growing every time when it
> > receives the ACK during the Search state until the probe fails. When
> > the failure occurs, pl.probe_high is set and it goes to the Complete
> > state.
> >
> > However, if the link pmtu is huge, like 65535 in loopback_dev, the prob=
e
> > eventually keeps using SCTP_MAX_PLPMTU as the probe size and never fail=
s.
> > Because of that, pl.probe_high can not be set, and the plpmtu probe can
> > never go to the Complete state.
> >
> > Fix it by setting pl.probe_high to SCTP_MAX_PLPMTU when the probe size
> > grows to SCTP_MAX_PLPMTU in sctp_transport_pl_recv(). Also, increase
> > the probe size only when the next is less than SCTP_MAX_PLPMTU.
> >
> > Fixes: b87641aff9e7 ("sctp: do state transition when a probe succeeds o=
n HB ACK recv path")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/transport.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> > index 2f66a2006517..b0ccfaa4c1d1 100644
> > --- a/net/sctp/transport.c
> > +++ b/net/sctp/transport.c
> > @@ -324,9 +324,11 @@ bool sctp_transport_pl_recv(struct sctp_transport =
*t)
> >               t->pl.probe_size +=3D SCTP_PL_BIG_STEP;
> >       } else if (t->pl.state =3D=3D SCTP_PL_SEARCH) {
> >               if (!t->pl.probe_high) {
> > -                     t->pl.probe_size =3D min(t->pl.probe_size + SCTP_=
PL_BIG_STEP,
> > -                                            SCTP_MAX_PLPMTU);
> > -                     return false;
> > +                     if (t->pl.probe_size + SCTP_PL_BIG_STEP < SCTP_MA=
X_PLPMTU) {
> > +                             t->pl.probe_size +=3D SCTP_PL_BIG_STEP;
> > +                             return false;
> > +                     }
> > +                     t->pl.probe_high =3D SCTP_MAX_PLPMTU;
>
> It looks like this way the probed mtu can't reach SCTP_MAX_PLPMTU
> anymore, while it was possible before.
indeed.

>
> What about something alike:
>
>                 if (!t->pl.probe_high) {
>                         if (t->pl.probe_size < SCTP_MAX_PLPMTU) {
>                                 t->pl.probe_size =3D min(t->pl.probe_size=
 + SCTP_PL_BIG_STEP,
>                                                        SCTP_MAX_PLPMTU);
>                                 return false;
>                         }
>                         t->pl.probe_high =3D SCTP_MAX_PLPMTU;
looks good.

will post v2.

Thanks.

> >               }
> >               t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
> >               if (t->pl.probe_size >=3D t->pl.probe_high) {
> > @@ -341,7 +343,8 @@ bool sctp_transport_pl_recv(struct sctp_transport *=
t)
> >       } else if (t->pl.state =3D=3D SCTP_PL_COMPLETE) {
> >               /* Raise probe_size again after 30 * interval in Search C=
omplete */
> >               t->pl.state =3D SCTP_PL_SEARCH; /* Search Complete -> Sea=
rch */
> > -             t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
> > +             if (t->pl.probe_size + SCTP_PL_MIN_STEP < SCTP_MAX_PLPMTU=
)
> > +                     t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
>
> In a similar way, should the above check be:
>
>                 if (t->pl.probe_size + SCTP_PL_MIN_STEP <=3D SCTP_MAX_PLP=
MTU)
>                         t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
>
> or simply:
>                 t->pl.probe_size =3D min(t->pl.probe_size + SCTP_PL_MIN_S=
TEP, SCTP_MAX_PLPMTU)
> >
> Cheers,
>
> Paolo
>

