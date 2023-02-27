Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA66A3EC6
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjB0JzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0JzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:55:21 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADC11ACE1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:55:17 -0800 (PST)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3AC5F3F4B9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677491716;
        bh=tg5JUGrzf9zAyKPvBm2SxqJ3gGjUcKX+UWSCeqq+tvk=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=mrM1y/QNHfhJYcIQYqi8e/PVqZTqImJEzgdE24d1S9eSwv49ihercnJNj3s6xkaHR
         3TqFXlF6LzkYno1fB/kjVQn47z1Ovr8hY2GoQO7fgGX2InyslEVxyU0MmJYlQ9iO8G
         dEdiXO4hxFdRrTNL7VOtZ2JJ7AQNl+yM8BxAnPKKi4gsqcszwB2LRPLH3GOeTqPfzP
         FFX/8nfsoea7wMvVht8evm/iMSrvjI1MdE0F7/c9zKYnN58fGpOwc5gejzcRnf1shB
         XVipyQNvKMOlYz51Si0ADHqbGZA/6usEyT6/Q9HGgp7qOcXNPB1t46Xv9E8AFwwy2b
         a16A7D3av7PQw==
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-536e8d6d9ceso129189337b3.12
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:55:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tg5JUGrzf9zAyKPvBm2SxqJ3gGjUcKX+UWSCeqq+tvk=;
        b=RYJvE9RgdJjhlhgjPSzs386hYvQyfvSEIvpx4pUevbI5Gn4II5rghLNDdgEYMDAk6h
         YPSfckN4e7L/AJ+84UEbZ5yGChwqsEcWhvdyOpynh/YQLHPWHgaWP2dq6J8EovZcLVAP
         NUUN17pnGu3VhsMOgJIqeHwpE4j+IkKUJDUma/KWpqAXx/XyhwcqeRniwmwziVDLPM/P
         xKl9+p2fOpW6b5hZJgixrWVLijCyOnrlUQ/ApNhHT231niUYlsfRq9MXwxoq5VVLcviQ
         Vw2YvG/9jdEQ/obxu2F+oK9SSgg06MxwcDHD0Vh0xXhbGsTjo4vhKotCJbF1hD9Pgokq
         tyvg==
X-Gm-Message-State: AO0yUKWDkONHxepfSoB+lgF95HLpqBfOaHM7ofwJVsBPvnLfXS1gWAq1
        4+91pTsrHYvQKh3l4lWYSEL0kqAs4so4Xs3jrrResE1gSGIsbZ3NMKAuP8GZ6Nxk7dJexnVF+sk
        wfF2m2L6XoptrrM/3VQ2jZ0skYTHB3fxTpwWzE9vAIN/jsBKEkQ==
X-Received: by 2002:a5b:ecb:0:b0:a03:da3f:3e68 with SMTP id a11-20020a5b0ecb000000b00a03da3f3e68mr8668938ybs.12.1677491715355;
        Mon, 27 Feb 2023 01:55:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8WlubDkM1Faogvy9cX8bjJidGkXf+S6l1wxuHu2gKvS1jpHhjUX5yhJ76wvykGnTzky2R/5XHH8FkhD6NkQ+o=
X-Received: by 2002:a5b:ecb:0:b0:a03:da3f:3e68 with SMTP id
 a11-20020a5b0ecb000000b00a03da3f3e68mr8668935ybs.12.1677491715165; Mon, 27
 Feb 2023 01:55:15 -0800 (PST)
MIME-Version: 1.0
References: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com> <Y/x8H4qCNsj4mEkA@unreal>
In-Reply-To: <Y/x8H4qCNsj4mEkA@unreal>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 27 Feb 2023 10:55:04 +0100
Message-ID: <CAEivzxeorZoiE4VmJ45CoF4ZRoW3B+rkT0ufX7y1bxn510yzPQ@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:47=E2=80=AFAM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> On Sun, Feb 26, 2023 at 09:17:30PM +0100, Alexander Mikhalitsyn wrote:
> > Currently, we set MSG_CTRUNC flag is we have no
> > msg_control buffer provided and SO_PASSCRED is set
> > or if we have pending SCM_RIGHTS.
> >
> > For some reason we have no corresponding check for
> > SO_PASSSEC.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  include/net/scm.h | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
>
> Is it a bugfix? If yes, it needs Fixes line.

It's from 1da177e4c3 ("Linux-2.6.12-rc2") times :)
I wasn't sure that it's correct to put the "Fixes" tag on such an old
and big commit. Will do. Thanks!

>
> >
> > diff --git a/include/net/scm.h b/include/net/scm.h
> > index 1ce365f4c256..585adc1346bd 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock=
, struct msghdr *msg, struct sc
> >               }
> >       }
> >  }
> > +
> > +static inline bool scm_has_secdata(struct socket *sock)
> > +{
> > +     return test_bit(SOCK_PASSSEC, &sock->flags);
> > +}
> >  #else
> >  static inline void scm_passec(struct socket *sock, struct msghdr *msg,=
 struct scm_cookie *scm)
> >  { }
> > +
> > +static inline bool scm_has_secdata(struct socket *sock)
> > +{
> > +     return false;
> > +}
> >  #endif /* CONFIG_SECURITY_NETWORK */
>
> There is no need in this ifdef, just test bit directly.

The problem is that even if the kernel is compiled without
CONFIG_SECURITY_NETWORK
userspace can still set the SO_PASSSEC option. IMHO it's better not to
set MSG_CTRUNC
if CONFIG_SECURITY_NETWORK is disabled, msg_control is not set but
SO_PASSSEC is enabled.
Because in this case SCM_SECURITY will never be sent. Please correct
me if I'm wrong.

Kind regards,
Alex

>
> >
> >  static __inline__ void scm_recv(struct socket *sock, struct msghdr *ms=
g,
> >                               struct scm_cookie *scm, int flags)
> >  {
> >       if (!msg->msg_control) {
> > -             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
> > +             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> > +                 scm_has_secdata(sock))
> >                       msg->msg_flags |=3D MSG_CTRUNC;
> >               scm_destroy(scm);
> >               return;
> > --
> > 2.34.1
> >
