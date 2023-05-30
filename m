Return-Path: <netdev+bounces-6231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B51927154B7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F7D7281038
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B000D46B9;
	Tue, 30 May 2023 05:08:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E676813
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:08:06 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73689E9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 22:08:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96ff9c0a103so576988166b.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 22:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685423282; x=1688015282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oENdb/PNBbVjDrw8mDPjI3X3sDQAuL7/2+YTKg1gLI=;
        b=jK1qinhrscF9yRG4/90vr45eZgsT2ysXHoBsCaZ4A3G7AEufVDzBzs1UJFg555zb1N
         LUNGebtodivwyceqp7XbX0d2gY/xcGcpUYVKrEBAc8Efk1eLBJo9MeMrGookAp3y3dXQ
         vjQ6Idf5gdeHHKzVNSS+dkKMnLSyeuiYevoQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685423282; x=1688015282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1oENdb/PNBbVjDrw8mDPjI3X3sDQAuL7/2+YTKg1gLI=;
        b=FT3+ehSdM/8jzOiRVRgwnSxhm5UgXjF6HEv5k/EYhMAfqiXpUNk2iCiZqOCQs3aNH6
         bzGublyvm9ZkYJoRLCcLxLqhx4BjQ2FwX/sZGQi+pa8xB76GjqMVPmlcbBW4S7GucBSt
         r+0dzruvfrQDzc3CLiH5Ac6sPOzwUGjJMYjwSj+I31z18AAbt0HPYQGXk6rQooxL+XmP
         Ogdbby8sG2a40mzqDH5Ny7LLEh5ATU1SFeaZRBQdnfIDZ2zVc5eZDIpA3gy3Bqy5g/iv
         i7Go5OnluzY5KMT52tthPFpS8MbAuSAcxxBuuVQsbyhwGLara8TmJz9yuVCDDKtFwUuV
         nVvg==
X-Gm-Message-State: AC+VfDx7iSZDLOMaqRj05n1DjwBmdcSS7u5Q8bNbaHcH+t45Kd8ngOPV
	W68SSSqHKEChkrKW2PskkYjQsD09ZhNIyxYf/t0=
X-Google-Smtp-Source: ACHHUZ7cKXf5FjJPblNSWxZbCvYdd4+YHdV/yej34rmBkgDekrrLbYXgUYTtP0qfHD1eXnN7dDn1lA==
X-Received: by 2002:a17:907:9805:b0:96f:5902:8c4d with SMTP id ji5-20020a170907980500b0096f59028c4dmr1307710ejc.27.1685423282533;
        Mon, 29 May 2023 22:08:02 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id b20-20020a17090636d400b0096fc35ca733sm6751422ejc.41.2023.05.29.22.08.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 22:08:01 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-30ad99fa586so3707852f8f.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 22:08:01 -0700 (PDT)
X-Received: by 2002:adf:dd92:0:b0:30a:b46a:a443 with SMTP id
 x18-20020adfdd92000000b0030ab46aa443mr462543wrl.51.1685423280911; Mon, 29 May
 2023 22:08:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522234154.2924052-1-yinghsu@chromium.org>
 <ZGyPt1GYGV2C2RQZ@corigine.com> <CABBYNZ+by-OQH2aPEMHpQ5cOLoKNpR7k111rJj6iOd2PGLx3gg@mail.gmail.com>
 <CAAa9mD3A+3uJzFK0EbTrn5hX42EOgeixehmxgkwdhp1KetxjVQ@mail.gmail.com>
 <CABBYNZKPv_0AaJJm2_c0F+4qX_vKXQ9BnVgR-kPy40YsDDqSRQ@mail.gmail.com> <CAAa9mD2e-WkuHshXf7ifOHcGEsgHb68xkRdaq5MRMeY7_jzkMg@mail.gmail.com>
In-Reply-To: <CAAa9mD2e-WkuHshXf7ifOHcGEsgHb68xkRdaq5MRMeY7_jzkMg@mail.gmail.com>
From: Ying Hsu <yinghsu@chromium.org>
Date: Tue, 30 May 2023 13:07:23 +0800
X-Gmail-Original-Message-ID: <CAAa9mD00VriG3utyedjwykuUUXaRU0SvXkr5+VPgmZFpiFokrA@mail.gmail.com>
Message-ID: <CAAa9mD00VriG3utyedjwykuUUXaRU0SvXkr5+VPgmZFpiFokrA@mail.gmail.com>
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
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Gentle ping, Luiz.


On Thu, May 25, 2023 at 12:16=E2=80=AFPM Ying Hsu <yinghsu@chromium.org> wr=
ote:
>
> Hi Luiz,
>
> The proposal solves the deadlock but might introduce other problems as
> it breaks the order of l2cap_chan_del.
> There are another way to resolve the deadlock:
> ```
> @@ -4663,7 +4663,9 @@ static inline int l2cap_disconnect_req(struct
> l2cap_conn *conn,
>
>         chan->ops->set_shutdown(chan);
>
> +       l2cap_chan_unlock(chan);
>         mutex_lock(&conn->chan_lock);
> +       l2cap_chan_lock(chan);
>         l2cap_chan_del(chan, ECONNRESET);
>         mutex_unlock(&conn->chan_lock);
>  ```
>
> If you're okay with it, I'll do some verification and post a full patch.
>
> Best regards,
> Ying
>
> On Thu, May 25, 2023 at 2:56=E2=80=AFAM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Ying,
> >
> > On Wed, May 24, 2023 at 3:54=E2=80=AFAM Ying Hsu <yinghsu@chromium.org>=
 wrote:
> > >
> > > Hi Simon,
> > >
> > > I understand your concern about the repeated code.
> > > However, simply hiding the locking logic in another function
> > > introduces hidden assumptions.
> > > For this patch, I would like to fix the deadlock in a simple and easy
> > > to understand way.
> > > We can always refactor the l2cap_chan utility functions later.
> > >
> > > Hi Luis,
> > >
> > > I'll add a fixes tag in the next version.
> >
> > And how about doing this:
> >
> > https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
> >
> > > Best regards,
> > > Ying
> > >
> > >
> > > On Wed, May 24, 2023 at 3:06=E2=80=AFAM Luiz Augusto von Dentz
> > > <luiz.dentz@gmail.com> wrote:
> > > >
> > > > Hi Simon, Ying,
> > > >
> > > > On Tue, May 23, 2023 at 3:04=E2=80=AFAM Simon Horman <simon.horman@=
corigine.com> wrote:
> > > > >
> > > > > On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> > > > > > L2CAP assumes that the locks conn->chan_lock and chan->lock are
> > > > > > acquired in the order conn->chan_lock, chan->lock to avoid
> > > > > > potential deadlock.
> > > > > > For example, l2sock_shutdown acquires these locks in the order:
> > > > > >   mutex_lock(&conn->chan_lock)
> > > > > >   l2cap_chan_lock(chan)
> > > > > >
> > > > > > However, l2cap_disconnect_req acquires chan->lock in
> > > > > > l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> > > > > > before calling l2cap_chan_del. This means that these locks are
> > > > > > acquired in unexpected order, which leads to potential deadlock=
:
> > > > > >   l2cap_chan_lock(c)
> > > > > >   mutex_lock(&conn->chan_lock)
> > > > > >
> > > > > > This patch uses __l2cap_get_chan_by_scid to replace
> > > > > > l2cap_get_chan_by_scid and adjusts the locking order to avoid t=
he
> > > > > > potential deadlock.
> > > >
> > > > This needs the fixes tag so we can backport it properly.
> > > >
> > > > > > Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > > > > > ---
> > > > > > This commit has been tested on a Chromebook device.
> > > > > >
> > > > > > Changes in v2:
> > > > > > - Adding the prefix "Bluetooth:" to subject line.
> > > > > >
> > > > > >  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
> > > > > >  1 file changed, 20 insertions(+), 6 deletions(-)
> > > > > >
> > > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_c=
ore.c
> > > > > > index 376b523c7b26..8f08192b8fb1 100644
> > > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > > @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req(s=
truct l2cap_conn *conn,
> > > > > >
> > > > > >       BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
> > > > > >
> > > > > > -     chan =3D l2cap_get_chan_by_scid(conn, dcid);
> > > > > > +     mutex_lock(&conn->chan_lock);
> > > > > > +     chan =3D __l2cap_get_chan_by_scid(conn, dcid);
> > > > > > +     if (chan) {
> > > > > > +             chan =3D l2cap_chan_hold_unless_zero(chan);
> > > > > > +             if (chan)
> > > > > > +                     l2cap_chan_lock(chan);
> > > > > > +     }
> > > > > > +
> > > > > >       if (!chan) {
> > > > > > +             mutex_unlock(&conn->chan_lock);
> > > > > >               cmd_reject_invalid_cid(conn, cmd->ident, dcid, sc=
id);
> > > > > >               return 0;
> > > > > >       }
> > > > >
> > > > > Hi Ying,
> > > > >
> > > > > The conditional setting of chan and calling l2cap_chan_lock()
> > > > > is both non-trivial and repeated. It seems that it ought to be
> > > > > in a helper.
> > > > >
> > > > > Something like this (I'm sure a better function name can be chose=
n):
> > > > >
> > > > >         chan =3D __l2cap_get_and_lock_chan_by_scid(conn, dcid);
> > > > >         if (!chan) {
> > > > >                 ...
> > > > >         }
> > > > >
> > > > >         ...
> > > >
> > > > Or perhaps we could do something like l2cap_del_chan_by_scid:
> > > >
> > > > https://gist.github.com/Vudentz/e513859ecb31e79c947dfcb4b5c60453
> > > >
> > > > --
> > > > Luiz Augusto von Dentz
> >
> >
> >
> > --
> > Luiz Augusto von Dentz

