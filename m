Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1166341B5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbiKVQnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiKVQnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:43:03 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441032BB3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:43:01 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v184so2585832ybv.6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHT4DCbo+DcJODffplOjCqSG7U9PvpUlPkd4nhKCIdE=;
        b=AMWBCoeXTyKxh/ESVaqDAI8LVd7P5hefJdxBBp4hGsJ1tp6e6LEUcE+jQfnghAR6qM
         AqI7gHYPyYN0qBgfk1IIkdgCcNBJAIqhBznA36h14dQQvEkXF87pu/t7QJdYkc0krGNT
         L1pg9f/+w6QtenHrNOzdZDJV+C0VsBe3QVOrh8SzCKMa13JOrBhr1c+a7r6roLINbEGZ
         vsaZQ/5GiWKv7szQc3SBMuy5UkPsEU9CWkeX+Gr0c7jTm2Ynd8yVrg+Wpb2zuUK3zhlY
         5LZUk1i0H+N4olwXtHnNTUxYUHxge8UYbZ7Xr1Z8FxN05aEtRu19hRVDNrZKv12bCHwz
         RJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHT4DCbo+DcJODffplOjCqSG7U9PvpUlPkd4nhKCIdE=;
        b=jNu1xwFWymRrp+ABYpZkNmHYhoZhLzdBuOBsoIduoz1U/Sek/YkW2ekVLJdvnLn7MD
         AfuGlpNVmTcWURWzp0+O4jKwWl3pukbKtjZ87Jj2Es9K7iW3e/jwjGDu35cDlxn/aCb9
         0sbcpAjFHNg4SQLEUXZYDKlBh4T9IjqdSHLR3CIdqBO8HG4YX4wxfCdjRnpXs6LGqsah
         6UUWRsQRGwzikmxkIGOLUBlLiULcGGKpHzfrKk7T4XUmO62mZFlms5/9ffvnDMrYuTKn
         45Gi6Oc/A6PIewypsB8qKRb9zyh3hAJM/0tNfcHYw4r6tcY3lwxGB0MtDQj8+L+qqGbO
         OV4w==
X-Gm-Message-State: ANoB5pm/Ey0sss3/1twKfeY3pTEmwOZNJa6hyQHmKFpAeFpADJ0mGzxi
        c6uLfkLwLrKMF1q/kkAzlpdncsQE0tYEZHVssmhPEiJsz2c=
X-Google-Smtp-Source: AA0mqf4cLvW/bhQbAQ53/lz7iVu5VvduCqvKdroIloKO79fbiLVvT9xXtO8672tuDQwf1T1l8K3JIB/ox0iEWtqNehE=
X-Received: by 2002:a25:6641:0:b0:6ca:b03:7111 with SMTP id
 z1-20020a256641000000b006ca0b037111mr22155660ybm.598.1669135380429; Tue, 22
 Nov 2022 08:43:00 -0800 (PST)
MIME-Version: 1.0
References: <20221122093131.161499-1-saeed@kernel.org> <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
In-Reply-To: <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Nov 2022 08:42:49 -0800
Message-ID: <CANn89i+1JanTp=HacjfLkKR_nnC4vA4VJz2tMzAqEb+cFn_3tw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix build break when CONFIG_IPV6=n
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 1:37 AM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
>
> Hi Saeed,
>
> On Tue, Nov 22, 2022 at 10:31 AM Saeed Mahameed <saeed@kernel.org> wrote:
> > From: Saeed Mahameed <saeedm@nvidia.com>
> >
> > The cited commit caused the following build break when CONFIG_IPV6 was
> > disabled
> >
> > net/ipv4/tcp_input.c: In function =E2=80=98tcp_syn_flood_action=E2=80=
=99:
> > include/net/sock.h:387:37: error: =E2=80=98const struct sock_common=E2=
=80=99 has no member named =E2=80=98skc_v6_rcv_saddr=E2=80=99; did you mean=
 =E2=80=98skc_rcv_saddr=E2=80=99?
> >
> > Fix by using inet6_rcv_saddr() macro which handles this situation
> > nicely.
> >
> > Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
> Thanks for your patch!
>
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -6843,9 +6843,9 @@ static bool tcp_syn_flood_action(const struct soc=
k *sk, const char *proto)
> >
> >         if (!READ_ONCE(queue->synflood_warned) && syncookies !=3D 2 &&
> >             xchg(&queue->synflood_warned, 1) =3D=3D 0) {
> > -               if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family =3D=3D AF_=
INET6) {
> > +               if (sk->sk_family =3D=3D AF_INET6) {
>
> I think the IS_ENABLED() should stay, to make sure the IPV6-only
> code is optimized away when IPv6-support is disabled.

Agreed.
