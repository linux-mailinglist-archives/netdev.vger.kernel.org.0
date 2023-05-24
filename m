Return-Path: <netdev+bounces-5164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D56D470FE14
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F431C20CB5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D534919E5D;
	Wed, 24 May 2023 18:56:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1467C13A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:56:48 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781C113;
	Wed, 24 May 2023 11:56:46 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2afb2875491so15274481fa.1;
        Wed, 24 May 2023 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684954604; x=1687546604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFc5+4hJmG80gbCGSLCg+YTvQ2ViynmFbtirUDeRW/w=;
        b=iPkNWloTpYUleJ4Yo/4U5PL0dlt5rktILW8viFrT7dTFzy8a5m1qLGVzEJMlre1M+2
         sAMDgB9mw4+i41Xg9qOGM1MIhiO2ehNaaFxEzLrqu8WBMEix5XlZDH7RyIvAw62sTVNY
         AZMfDZYR3MPot1NdIjWnPe2gLOkpfabb9pfRWLtMHbYQxXY6672oLNLsxarl1wf0KoAI
         nV2GWNUiwVsy+idgD0IjOa+K00JNPDC+CydKPi3zizB1l/GiebYo9lMVj2Bzb8dzlpvG
         IDKRzW/t6tawRf5W0jCyWf4pjufXbCWfjEb4tXSak7yIjsgMiDeEMDCHA6LAMS5vCxAc
         QYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684954604; x=1687546604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFc5+4hJmG80gbCGSLCg+YTvQ2ViynmFbtirUDeRW/w=;
        b=SK+kw6ylfbVZkmR0I7Bx/DEriWiV8nZ5LFn0BMn9yN6ok2GZhz96bT/UQ+ary6FsJR
         Sqvg5UBQmRggWOsWAdiFKkpY61fYKgwQCy3ntGT+2iByvFTC6xyn9CkCrViwLR9Nda6p
         QwtnxRbQSGPZGxjPa44PoQhTgo7FNwX5OyXxM40kSkrcy6vUDYgznhoguvleP94XnnfK
         /Vt1UgS2ruY8iNiInCVsl0BWglkQ115WiU5szzZkc30sBhgtc25ojcjwnIOjrXEp/95Y
         S2vcPuqMDd5uvAwPoLDyhNkjCHF873GPrApWjDA3JB5KOKPh2DL2yf2wGC7l3yHiM1oC
         4LQQ==
X-Gm-Message-State: AC+VfDyosZS4wXKLUFlp9OQjD6XhdfkqLteY0UdGnOhtK1ZrKwf7XQ/8
	gdfIS9K+AEvXzvDTZYvRY+2hvWxvG6SP1jQ81mg=
X-Google-Smtp-Source: ACHHUZ7U82Xbuq436/IWABbU91mpiCWN1wfiHa5KlG1XrdwoXANaosuwV0E0Vf3RRfXoNphnTgGv5pB/51aGiVd8e1U=
X-Received: by 2002:a2e:7215:0:b0:2a8:d13d:88fb with SMTP id
 n21-20020a2e7215000000b002a8d13d88fbmr221362ljc.11.1684954604217; Wed, 24 May
 2023 11:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522234154.2924052-1-yinghsu@chromium.org>
 <ZGyPt1GYGV2C2RQZ@corigine.com> <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
 <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
In-Reply-To: <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Wed, 24 May 2023 11:56:31 -0700
Message-ID: <CABBYNZKPv_0AaJJm2_c0F+4qX_vKXQ9BnVgR-kPy40YsDDqSRQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix l2cap_disconnect_req deadlock
To: Ying Hsu <yinghsu@chromium.org>
Cc: Simon Horman <simon.horman@corigine.com>, linux-bluetooth@vger.kernel.org, 
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

Hi Ying,

On Wed, May 24, 2023 at 3:54=E2=80=AFAM Ying Hsu <yinghsu@chromium.org> wro=
te:
>
> Hi Simon,
>
> I understand your concern about the repeated code.
> However, simply hiding the locking logic in another function
> introduces hidden assumptions.
> For this patch, I would like to fix the deadlock in a simple and easy
> to understand way.
> We can always refactor the l2cap_chan utility functions later.
>
> Hi Luis,
>
> I'll add a fixes tag in the next version.

And how about doing this:

https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453

> Best regards,
> Ying
>
>
> On Wed, May 24, 2023 at 3:06=E2=80=AFAM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Simon, Ying,
> >
> > On Tue, May 23, 2023 at 3:04=E2=80=AFAM Simon Horman <simon.horman@cori=
gine.com> wrote:
> > >
> > > On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> > > > L2CAP assumes that the locks conn->chan_lock and chan->lock are
> > > > acquired in the order conn->chan_lock, chan->lock to avoid
> > > > potential deadlock.
> > > > For example, l2sock_shutdown acquires these locks in the order:
> > > >   mutex_lock(&conn->chan_lock)
> > > >   l2cap_chan_lock(chan)
> > > >
> > > > However, l2cap_disconnect_req acquires chan->lock in
> > > > l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> > > > before calling l2cap_chan_del. This means that these locks are
> > > > acquired in unexpected order, which leads to potential deadlock:
> > > >   l2cap_chan_lock(c)
> > > >   mutex_lock(&conn->chan_lock)
> > > >
> > > > This patch uses __l2cap_get_chan_by_scid to replace
> > > > l2cap_get_chan_by_scid and adjusts the locking order to avoid the
> > > > potential deadlock.
> >
> > This needs the fixes tag so we can backport it properly.
> >
> > > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > > > ---
> > > > This commit has been tested on a Chromebook device.
> > > >
> > > > Changes in v2:
> > > > - Adding the prefix "Bluetooth:" to subject line.
> > > >
> > > >  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
> > > >  1 file changed, 20 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.=
c
> > > > index 376b523c7b26..8f08192b8fb1 100644
> > > > --- a/net/bluetooth/l2cap_core.c
> > > > +++ b/net/bluetooth/l2cap_core.c
> > > > @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req(struc=
t l2cap_conn *conn,
> > > >
> > > >       BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
> > > >
> > > > -     chan =3D l2cap_get_chan_by_scid(conn, dcid);
> > > > +     mutex_lock(&conn->chan_lock);
> > > > +     chan =3D __l2cap_get_chan_by_scid(conn, dcid);
> > > > +     if (chan) {
> > > > +             chan =3D l2cap_chan_hold_unless_zero(chan);
> > > > +             if (chan)
> > > > +                     l2cap_chan_lock(chan);
> > > > +     }
> > > > +
> > > >       if (!chan) {
> > > > +             mutex_unlock(&conn->chan_lock);
> > > >               cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
> > > >               return 0;
> > > >       }
> > >
> > > Hi Ying,
> > >
> > > The conditional setting of chan and calling l2cap_chan_lock()
> > > is both non-trivial and repeated. It seems that it ought to be
> > > in a helper.
> > >
> > > Something like this (I'm sure a better function name can be chosen):
> > >
> > >         chan =3D __l2cap_get_and_lock_chan_by_scid(conn, dcid);
> > >         if (!chan) {
> > >                 ...
> > >         }
> > >
> > >         ...
> >
> > Or perhaps we could do something like l2cap_del_chan_by_scid:
> >
> > https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz

