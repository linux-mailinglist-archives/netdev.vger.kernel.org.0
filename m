Return-Path: <netdev+bounces-4939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E0670F49B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F5671C20C78
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C133CC2C5;
	Wed, 24 May 2023 10:54:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F88471
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:54:11 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F168CB7
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:54:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-510ea8d0bb5so1483181a12.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684925648; x=1687517648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/qi+dHgB0OUou2fTatsWKxVpRKt0hH2Bcu1Do/nAuA=;
        b=GftWbWECWQFLbvcv03JoAPeER0zJrtOqVthatc1RpHrmOLrBOX8yVtEf+Dhl2PqNUu
         YdodgmdA/Ge5MR5vz3mUJQsQ9NhIdN3ivxeb87HNRa4MX7baDVrvPaZSmC+smSRKbFx/
         n6BlgiMG2y8MBuWi3oF78vr00bVu6KKuhjYcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684925648; x=1687517648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/qi+dHgB0OUou2fTatsWKxVpRKt0hH2Bcu1Do/nAuA=;
        b=d1OBG8DWIRdaWpD5MGeOeYN0Nurmzhr0q3Dm3a9+GtafnZqJTYghBwVjhkQEWERzf1
         MVXSuQ59RaG9fH+3ZpQNIyHD9HB+QVaT9bigVSoolceVsXJAspDkoDNO0qJsFCayOqXx
         wLHopeHLK0T04PXx7Aw+0I0Jmjqs37c2MuRRAQd72s6PAXk6RcJXtz6ASoepkpwlSC5R
         pvlPze5/8oNA8vGY3NFkv2nnrIQWicuvowO5RjOTYGFA80rfwnOgSxhlQ3rjemURQVn8
         cg1Fj4y4M02uJluLwhH6NMbBjLq9OWuYqBCnqMMo51ibgs0+JbZcjj8bM45p1GJHy6aw
         90Bw==
X-Gm-Message-State: AC+VfDynmIXGXrcuNRmP0MPDzNncYGLYHOYVD4twIVhzoevko3Kx86wo
	jt9e6kMnwUYGJ0DMxl+jNwKpZh2iL25OfEkaAAI=
X-Google-Smtp-Source: ACHHUZ6Ez++yn+ij/7PonrzYR6UlrzO1LKTbBEk8BAQTmvPxiUE353OEIQfxfixwkSzkPtLcOX0O/w==
X-Received: by 2002:a05:6402:10d0:b0:506:741e:5c14 with SMTP id p16-20020a05640210d000b00506741e5c14mr1717594edu.30.1684925648064;
        Wed, 24 May 2023 03:54:08 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id bf23-20020a0564021a5700b0050d83a39e6fsm5067200edb.4.2023.05.24.03.54.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 03:54:07 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3078a3f3b5fso642046f8f.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:54:06 -0700 (PDT)
X-Received: by 2002:a5d:5348:0:b0:306:2ef0:d223 with SMTP id
 t8-20020a5d5348000000b003062ef0d223mr11847562wrv.62.1684925646235; Wed, 24
 May 2023 03:54:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522234154.2924052-1-yinghsu@chromium.org>
 <ZGyPt1GYGV2C2RQZ@corigine.com> <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
In-Reply-To: <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
From: Ying Hsu <yinghsu@chromium.org>
Date: Wed, 24 May 2023 18:53:29 +0800
X-Gmail-Original-Message-ID: <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
Message-ID: <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix l2cap_disconnect_req deadlock
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Simon Horman <simon.horman@corigine.com>, linux-bluetooth@vger.kernel.org, 
	chromeos-bluetooth-upstreaming@chromium.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Marcel Holtmann <marcel@holtmann.org>, Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

I understand your concern about the repeated code.
However, simply hiding the locking logic in another function
introduces hidden assumptions.
For this patch, I would like to fix the deadlock in a simple and easy
to understand way.
We can always refactor the l2cap_chan utility functions later.

Hi Luis,

I'll add a fixes tag in the next version.

Best regards,
Ying


On Wed, May 24, 2023 at 3:06=E2=80=AFAM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Simon, Ying,
>
> On Tue, May 23, 2023 at 3:04=E2=80=AFAM Simon Horman <simon.horman@corigi=
ne.com> wrote:
> >
> > On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> > > L2CAP assumes that the locks conn->chan_lock and chan->lock are
> > > acquired in the order conn->chan_lock, chan->lock to avoid
> > > potential deadlock.
> > > For example, l2sock_shutdown acquires these locks in the order:
> > >   mutex_lock(&conn->chan_lock)
> > >   l2cap_chan_lock(chan)
> > >
> > > However, l2cap_disconnect_req acquires chan->lock in
> > > l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> > > before calling l2cap_chan_del. This means that these locks are
> > > acquired in unexpected order, which leads to potential deadlock:
> > >   l2cap_chan_lock(c)
> > >   mutex_lock(&conn->chan_lock)
> > >
> > > This patch uses __l2cap_get_chan_by_scid to replace
> > > l2cap_get_chan_by_scid and adjusts the locking order to avoid the
> > > potential deadlock.
>
> This needs the fixes tag so we can backport it properly.
>
> > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > > ---
> > > This commit has been tested on a Chromebook device.
> > >
> > > Changes in v2:
> > > - Adding the prefix "Bluetooth:" to subject line.
> > >
> > >  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
> > >  1 file changed, 20 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > index 376b523c7b26..8f08192b8fb1 100644
> > > --- a/net/bluetooth/l2cap_core.c
> > > +++ b/net/bluetooth/l2cap_core.c
> > > @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req(struct =
l2cap_conn *conn,
> > >
> > >       BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
> > >
> > > -     chan =3D l2cap_get_chan_by_scid(conn, dcid);
> > > +     mutex_lock(&conn->chan_lock);
> > > +     chan =3D __l2cap_get_chan_by_scid(conn, dcid);
> > > +     if (chan) {
> > > +             chan =3D l2cap_chan_hold_unless_zero(chan);
> > > +             if (chan)
> > > +                     l2cap_chan_lock(chan);
> > > +     }
> > > +
> > >       if (!chan) {
> > > +             mutex_unlock(&conn->chan_lock);
> > >               cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
> > >               return 0;
> > >       }
> >
> > Hi Ying,
> >
> > The conditional setting of chan and calling l2cap_chan_lock()
> > is both non-trivial and repeated. It seems that it ought to be
> > in a helper.
> >
> > Something like this (I'm sure a better function name can be chosen):
> >
> >         chan =3D __l2cap_get_and_lock_chan_by_scid(conn, dcid);
> >         if (!chan) {
> >                 ...
> >         }
> >
> >         ...
>
> Or perhaps we could do something like l2cap_del_chan_by_scid:
>
> https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
>
> --
> Luiz Augusto von Dentz

