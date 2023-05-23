Return-Path: <netdev+bounces-4794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D58070E519
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720BA281306
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E092099F;
	Tue, 23 May 2023 19:06:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669391F93C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:06:19 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF1391;
	Tue, 23 May 2023 12:06:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2af2c7f2883so2387411fa.3;
        Tue, 23 May 2023 12:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684868775; x=1687460775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJFRYUGcMe7LMj5nBQpYtgVrgLs7P4vK7RG89WbfsGw=;
        b=QykgS/BuU4h6WbXj5oxEQBuW/llGtZooI+t2jrzEc3uCX0FbFyX35iB08ErewuwgSv
         g06/wJj+S2AJM47CRYdHYcuir6o7TikahuilCfRoaNDRAGvIGPDmBO0nv8JKsgL6FXWL
         uU9B+DPEUZinciiYM3A+zy7z9lU9QqBs3Rh0TuNi5l5qPwUTcWqXGud3fGL0disLNoWJ
         lCWFct1xh8iQEQcI3OtMMXKccGve06VX2VLWbdNws5F77kAX5/F9+05fuaNhDeIcJjAr
         xLO3/tnD406WklSCJBffDIE2e0vxAUvAp/8p+wZrj161qok6bXhktnkWofb8+NOMkr/w
         G5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684868775; x=1687460775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJFRYUGcMe7LMj5nBQpYtgVrgLs7P4vK7RG89WbfsGw=;
        b=HQQAigm12wmney6PEZZM8HwiC7aMdlTFDZ8+vhK1rAWde8wP866hYUEPElzlT8amOX
         cgbaQ4oSSCp7aV8vxJOO3wOCUxppxBmzEeW0KZIcGL6REkHCtmsuuhHWY5lODpafEuqT
         /U/aW1o698f7SWOiGFCyAfS0hlolYyM8ChBtXm3jvqX/UQILx2xR6ZUTYVyz3IpdBPem
         h4UkpBY/DxbMP8kb4KKzyS3Mq9UQkibi5Jx1+ICrKYtXEy4Qc3QYxXXv/KbUxaEkwtnK
         RWGh7jLw/GIOetnEeRm+YsJ61ybnZba1hEBmiYsbVVsimWEio05ZcxHVqwk16AwPwWOH
         IC2w==
X-Gm-Message-State: AC+VfDyPktge34G9Pt1nUwYTdHZ5x3Avc0dVpom6T8Y849StF82SFShR
	+STTAVOHMfM4On9c/OBZRLEyXV/xd7ExKfzRaCU=
X-Google-Smtp-Source: ACHHUZ5Dqy8PO9xAS5RwVatcVQ043ssA5OHL/miSfayNbt0ml63GT8tXDcAaFVduhgz7JdKugblqhac3WEm/RmQvIso=
X-Received: by 2002:a2e:8788:0:b0:2ad:8929:e8f4 with SMTP id
 n8-20020a2e8788000000b002ad8929e8f4mr5370076lji.43.1684868775466; Tue, 23 May
 2023 12:06:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522234154.2924052-1-yinghsu@chromium.org> <ZGyPt1GYGV2C2RQZ@corigine.com>
In-Reply-To: <ZGyPt1GYGV2C2RQZ@corigine.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 23 May 2023 12:06:02 -0700
Message-ID: <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix l2cap_disconnect_req deadlock
To: Simon Horman <simon.horman@corigine.com>
Cc: Ying Hsu <yinghsu@chromium.org>, linux-bluetooth@vger.kernel.org, 
	chromeos-bluetooth-upstreaming@chromium.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Marcel Holtmann <marcel@holtmann.org>, Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon, Ying,

On Tue, May 23, 2023 at 3:04=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> > L2CAP assumes that the locks conn->chan_lock and chan->lock are
> > acquired in the order conn->chan_lock, chan->lock to avoid
> > potential deadlock.
> > For example, l2sock_shutdown acquires these locks in the order:
> >   mutex_lock(&conn->chan_lock)
> >   l2cap_chan_lock(chan)
> >
> > However, l2cap_disconnect_req acquires chan->lock in
> > l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> > before calling l2cap_chan_del. This means that these locks are
> > acquired in unexpected order, which leads to potential deadlock:
> >   l2cap_chan_lock(c)
> >   mutex_lock(&conn->chan_lock)
> >
> > This patch uses __l2cap_get_chan_by_scid to replace
> > l2cap_get_chan_by_scid and adjusts the locking order to avoid the
> > potential deadlock.

This needs the fixes tag so we can backport it properly.

> > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > ---
> > This commit has been tested on a Chromebook device.
> >
> > Changes in v2:
> > - Adding the prefix "Bluetooth:" to subject line.
> >
> >  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index 376b523c7b26..8f08192b8fb1 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req(struct l2=
cap_conn *conn,
> >
> >       BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
> >
> > -     chan =3D l2cap_get_chan_by_scid(conn, dcid);
> > +     mutex_lock(&conn->chan_lock);
> > +     chan =3D __l2cap_get_chan_by_scid(conn, dcid);
> > +     if (chan) {
> > +             chan =3D l2cap_chan_hold_unless_zero(chan);
> > +             if (chan)
> > +                     l2cap_chan_lock(chan);
> > +     }
> > +
> >       if (!chan) {
> > +             mutex_unlock(&conn->chan_lock);
> >               cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
> >               return 0;
> >       }
>
> Hi Ying,
>
> The conditional setting of chan and calling l2cap_chan_lock()
> is both non-trivial and repeated. It seems that it ought to be
> in a helper.
>
> Something like this (I'm sure a better function name can be chosen):
>
>         chan =3D __l2cap_get_and_lock_chan_by_scid(conn, dcid);
>         if (!chan) {
>                 ...
>         }
>
>         ...

Or perhaps we could do something like l2cap_del_chan_by_scid:

https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453

--=20
Luiz Augusto von Dentz

