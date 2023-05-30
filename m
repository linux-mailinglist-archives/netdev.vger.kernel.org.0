Return-Path: <netdev+bounces-6565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A63C2716F19
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A1C42812D4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CBB200B4;
	Tue, 30 May 2023 20:51:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B772B7E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:51:18 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCFC10A;
	Tue, 30 May 2023 13:50:52 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2afb2875491so53109891fa.1;
        Tue, 30 May 2023 13:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685479850; x=1688071850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ylkw/NLGjRglYYdjZVPg6YRfMOUcFgiFJEPQkmObYw=;
        b=cFeZHxd72eQLJPqj0Y71fYxUtkh8Dk/Phgzhw0QsSbGrd/Pe/FpZ6uQDp/By20Jlg/
         UsHX5VUl0Ssyt1hDQGvCmJiEA+8R0OR5XzNus2Dt/Z0QcYp20N7Db8k0PTvpJLNepQuI
         zVUL1c+NAmac87l+XYMO3m4Z9YiXDWIk3tdXD0JIEypNeR+0pcWgN7Z8jCbR5MYkiJh9
         Wgbf6DtiAyjD3/GhoYVjeHEkBY+UiE0T8tvQ2eQfMIPf9egwoMD8NperlKCzvfK9h1xm
         9rumJuOXHplb7WZWgoicto6WQGBizH1BS0v6asUz/35CMpvIJdWo9B+4W+QT2j3qXgFo
         52KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685479850; x=1688071850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ylkw/NLGjRglYYdjZVPg6YRfMOUcFgiFJEPQkmObYw=;
        b=EFOqolcQgbZKEBT8tffs7iGZR43jJl2oUaEtipLaqDIwX7TCztX+Cp9EUvSi97L42L
         2cVjWYC6sPZEgNQm8KEOW6LlxQeeTwzHjOzX28tVEFzyheEi3b14UL5RSI0KeVpub/D+
         vWfDlRJr/c/qwcx1LsfEMKKjU/PkUTwuoO/X2zoLIGPDxoWyjNHTurMFt+Yqxo9vrpXP
         ynhtx9LbkBl6r46G4eJKdKoIx45Tvx9qdnM7sLMzrrEIdHeZgItbgzZG9BP1pjHwOjuV
         dn4JGkztKMwKfm9gXg5dxdBhnVCBzrYJG8jFQeE55kOKovvlBjekJ8kMlnifUfc4R1ud
         FSfQ==
X-Gm-Message-State: AC+VfDwx2hwjWFnAKfcpqPa09S7XWBZDWSx+yIYfmJ6hgxv7P/uBDxvs
	veWAXaNQsiqkJ4l2AKuasPuYZzzAEomFge1X2Yo12sHM
X-Google-Smtp-Source: ACHHUZ5n5Jmrhmc1kh/SJJ708j1DWzaUZSdp/68VKKs1M1037UKPw0vinzDJmL971eSMr/3StPc9MMa2hJHfJxJBo7U=
X-Received: by 2002:a2e:9f09:0:b0:2aa:481b:b439 with SMTP id
 u9-20020a2e9f09000000b002aa481bb439mr1525949ljk.21.1685479850206; Tue, 30 May
 2023 13:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522234154.2924052-1-yinghsu@chromium.org>
 <ZGyPt1GYGV2C2RQZ@corigine.com> <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
 <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
 <CABBYNZKPv_0AaJJm2_c0F+4qX_vKXQ9BnVgR-kPy40YsDDqSRQ@mail.gmail.com>
 <CAAa9mD2e-WkuHshXf7ifOHcGEsgHb68xkRdaq5MRMeY7_jzkMg@mail.gmail.com> <CAAa9mD00VriG3utyedjwykuUUXaRU0SvXkr5+VPgmZFpiFokrA@mail.gmail.com>
In-Reply-To: <CAAa9mD00VriG3utyedjwykuUUXaRU0SvXkr5+VPgmZFpiFokrA@mail.gmail.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 30 May 2023 13:50:37 -0700
Message-ID: <CABBYNZLpNbYDrP9aZqx9dm=XMh2KdRDAy+2gXX0wexMBHiQQUA@mail.gmail.com>
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

On Mon, May 29, 2023 at 10:08=E2=80=AFPM Ying Hsu <yinghsu@chromium.org> wr=
ote:
>
> Gentle ping, Luiz.
>
>
> On Thu, May 25, 2023 at 12:16=E2=80=AFPM Ying Hsu <yinghsu@chromium.org> =
wrote:
> >
> > Hi Luiz,
> >
> > The proposal solves the deadlock but might introduce other problems as
> > it breaks the order of l2cap_chan_del.
> > There are another way to resolve the deadlock:
> > ```
> > @@ -4663,7 +4663,9 @@ static inline int l2cap_disconnect_req(struct
> > l2cap_conn *conn,
> >
> >         chan->ops->set_shutdown(chan);
> >
> > +       l2cap_chan_unlock(chan);
> >         mutex_lock(&conn->chan_lock);
> > +       l2cap_chan_lock(chan);
> >         l2cap_chan_del(chan, ECONNRESET);
> >         mutex_unlock(&conn->chan_lock);
> >  ```

Yeah, I kind of like this better, that said I don't think changing the
order of l2cap_chan_del matters that much but it does change the
callback teardown sequence so perhaps we should stick to a simpler
solution for now.

Please submit an updated version so we can move forward with it.

> > If you're okay with it, I'll do some verification and post a full patch=
.
> >
> > Best regards,
> > Ying
> >
> > On Thu, May 25, 2023 at 2:56=E2=80=AFAM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Ying,
> > >
> > > On Wed, May 24, 2023 at 3:54=E2=80=AFAM Ying Hsu <yinghsu@chromium.or=
g> wrote:
> > > >
> > > > Hi Simon,
> > > >
> > > > I understand your concern about the repeated code.
> > > > However, simply hiding the locking logic in another function
> > > > introduces hidden assumptions.
> > > > For this patch, I would like to fix the deadlock in a simple and ea=
sy
> > > > to understand way.
> > > > We can always refactor the l2cap_chan utility functions later.
> > > >
> > > > Hi Luis,
> > > >
> > > > I'll add a fixes tag in the next version.
> > >
> > > And how about doing this:
> > >
> > > https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
> > >
> > > > Best regards,
> > > > Ying
> > > >
> > > >
> > > > On Wed, May 24, 2023 at 3:06=E2=80=AFAM Luiz Augusto von Dentz
> > > > <luiz.dentz@gmail.com> wrote:
> > > > >
> > > > > Hi Simon, Ying,
> > > > >
> > > > > On Tue, May 23, 2023 at 3:04=E2=80=AFAM Simon Horman <simon.horma=
n@corigine.com> wrote:
> > > > > >
> > > > > > On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> > > > > > > L2CAP assumes that the locks conn->chan_lock and chan->lock a=
re
> > > > > > > acquired in the order conn->chan_lock, chan->lock to avoid
> > > > > > > potential deadlock.
> > > > > > > For example, l2sock_shutdown acquires these locks in the orde=
r:
> > > > > > >   mutex_lock(&conn->chan_lock)
> > > > > > >   l2cap_chan_lock(chan)
> > > > > > >
> > > > > > > However, l2cap_disconnect_req acquires chan->lock in
> > > > > > > l2cap_get_chan_by_scid first and then acquires conn->chan_loc=
k
> > > > > > > before calling l2cap_chan_del. This means that these locks ar=
e
> > > > > > > acquired in unexpected order, which leads to potential deadlo=
ck:
> > > > > > >   l2cap_chan_lock(c)
> > > > > > >   mutex_lock(&conn->chan_lock)
> > > > > > >
> > > > > > > This patch uses __l2cap_get_chan_by_scid to replace
> > > > > > > l2cap_get_chan_by_scid and adjusts the locking order to avoid=
 the
> > > > > > > potential deadlock.
> > > > >
> > > > > This needs the fixes tag so we can backport it properly.
> > > > >
> > > > > > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > > > > > > ---
> > > > > > > This commit has been tested on a Chromebook device.
> > > > > > >
> > > > > > > Changes in v2:
> > > > > > > - Adding the prefix "Bluetooth:" to subject line.
> > > > > > >
> > > > > > >  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
> > > > > > >  1 file changed, 20 insertions(+), 6 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap=
_core.c
> > > > > > > index 376b523c7b26..8f08192b8fb1 100644
> > > > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > > > @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req=
(struct l2cap_conn *conn,
> > > > > > >
> > > > > > >       BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
> > > > > > >
> > > > > > > -     chan =3D l2cap_get_chan_by_scid(conn, dcid);
> > > > > > > +     mutex_lock(&conn->chan_lock);
> > > > > > > +     chan =3D __l2cap_get_chan_by_scid(conn, dcid);
> > > > > > > +     if (chan) {
> > > > > > > +             chan =3D l2cap_chan_hold_unless_zero(chan);
> > > > > > > +             if (chan)
> > > > > > > +                     l2cap_chan_lock(chan);
> > > > > > > +     }
> > > > > > > +
> > > > > > >       if (!chan) {
> > > > > > > +             mutex_unlock(&conn->chan_lock);
> > > > > > >               cmd_reject_invalid_cid(conn, cmd->ident, dcid, =
scid);
> > > > > > >               return 0;
> > > > > > >       }
> > > > > >
> > > > > > Hi Ying,
> > > > > >
> > > > > > The conditional setting of chan and calling l2cap_chan_lock()
> > > > > > is both non-trivial and repeated. It seems that it ought to be
> > > > > > in a helper.
> > > > > >
> > > > > > Something like this (I'm sure a better function name can be cho=
sen):
> > > > > >
> > > > > >         chan =3D __l2cap_get_and_lock_chan_by_scid(conn, dcid);
> > > > > >         if (!chan) {
> > > > > >                 ...
> > > > > >         }
> > > > > >
> > > > > >         ...
> > > > >
> > > > > Or perhaps we could do something like l2cap_del_chan_by_scid:
> > > > >
> > > > > https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
> > > > >
> > > > > --
> > > > > Luiz Augusto von Dentz
> > >
> > >
> > >
> > > --
> > > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz

