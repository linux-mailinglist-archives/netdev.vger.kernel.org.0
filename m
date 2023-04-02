Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861636D375C
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 12:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjDBKlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 06:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDBKlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 06:41:49 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E091311EBA;
        Sun,  2 Apr 2023 03:41:47 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id p2so20698070qtw.13;
        Sun, 02 Apr 2023 03:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680432107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYiHPvxkJqdldllj/O9cu/4mZjCb2J8H635dPazE8S8=;
        b=HTtxKL7atbG37OEGnzXegASPeJg/gzzvy6NOehVplC9SZeLGzGRnW+laT5PgQ7Q8HB
         kdKEPWZ5k7OnWXVxfoTb0Tfb96n6jWo0lfHujVX45qchw09Lc00pig9btnTSmAIPBflI
         ejkNJhYT+zcactwoIKXp2VtImu5QY/66DKZlRBDzW4r7/seOm0h0yos6mF9CmUIwGbWK
         Z62I3+5asVTcLcokGzy+aXafP2bWPY6FELQYtq6p8ClRDt9loUcCeFUkqJ+RMMm59puR
         vRjW+/6I2J+iGmFzMhiwPRUYTtnVj4D05IYcHWAYWV8cN/kbWpqOLXlv4Temjg04Few2
         jhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680432107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYiHPvxkJqdldllj/O9cu/4mZjCb2J8H635dPazE8S8=;
        b=HSMALwM2aA108pYFd0EddG7TjjPOhM2Ds9dNuVoqXp5ZMRGPy0LxmBX8F5zTIpie7l
         yGHg4HQUR7uChSH0jvES6lGphAgOQ/7UtLqvutSHPl12fvqchRBk232jsiTNGnhTJuoj
         qEG74qsSnZQjjeQpd/bYDbGbJ/pBnrGDgEtXgX5DDQm9+cOEygGqYvmtDVhQ2uEaCOTi
         tN2Fxr5Yyv69I94GPnKdPmlqXTOc6YikOAvEpsHjVl0c0i9mOANRoOH9V+6PHw7IdgsX
         ABKni7XDVB0Cw7EiMUn0+AsFjreAFllp25XhcE/lSe2HDEeRSZJ5eedzvrCd5kGQjIfm
         F02g==
X-Gm-Message-State: AO0yUKVB4BPv+RB1R7xGUDCQ0Xwj66r/vA9CSsax+jsA+64QCqjH0ji6
        wAu94T9DpkW019Oqr0qCQw9CIOKkxeumqc8/etU=
X-Google-Smtp-Source: AKy350beh9Rw0Gwj3MwIuXWgy1KwchjXrfwJ6XH3/Yjht3aIlPzyGRyzfd86F4EwA+a+ZcY58W6kqM9ql44zDm9D/oA=
X-Received: by 2002:a05:622a:199a:b0:3db:c138:ae87 with SMTP id
 u26-20020a05622a199a00b003dbc138ae87mr12616783qtc.6.1680432107082; Sun, 02
 Apr 2023 03:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230326221612.169289-1-xiyou.wangcong@gmail.com>
 <CALOAHbCyGJzp1yH2NTsikre0RuQ+4WoZCsAc110_+tW=L8FgQg@mail.gmail.com> <6427844176538_c503a208e4@john.notmuch>
In-Reply-To: <6427844176538_c503a208e4@john.notmuch>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 2 Apr 2023 18:41:08 +0800
Message-ID: <CALOAHbAtUUs7OOEyj+-o_wfLo1P9Yf1tab9k61wCrP0tv15gUQ@mail.gmail.com>
Subject: Re: [Patch bpf-next] sock_map: include sk_psock memory overhead too
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 1, 2023 at 9:09=E2=80=AFAM John Fastabend <john.fastabend@gmail=
.com> wrote:
>
> Yafang Shao wrote:
> > On Mon, Mar 27, 2023 at 6:16=E2=80=AFAM Cong Wang <xiyou.wangcong@gmail=
.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > When a socket is added to a sockmap, sk_psock is allocated too as its
> > > sk_user_data, therefore it should be consider as an overhead of sockm=
ap
> > > memory usage.
> > >
> > > Before this patch:
> > >
> > > 1: sockmap  flags 0x0
> > >         key 4B  value 4B  max_entries 2  memlock 656B
> > >         pids echo-sockmap(549)
> > >
> > > After this patch:
> > >
> > > 9: sockmap  flags 0x0
> > >         key 4B  value 4B  max_entries 2  memlock 1824B
> > >         pids echo-sockmap(568)
> > >
> > > Fixes: 73d2c61919e9 ("bpf, net: sock_map memory usage")
> > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/core/sock_map.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > > index 7c189c2e2fbf..22197e565ece 100644
> > > --- a/net/core/sock_map.c
> > > +++ b/net/core/sock_map.c
> > > @@ -799,9 +799,17 @@ static void sock_map_fini_seq_private(void *priv=
_data)
> > >
> > >  static u64 sock_map_mem_usage(const struct bpf_map *map)
> > >  {
> > > +       struct bpf_stab *stab =3D container_of(map, struct bpf_stab, =
map);
> > >         u64 usage =3D sizeof(struct bpf_stab);
> > > +       int i;
> > >
> > >         usage +=3D (u64)map->max_entries * sizeof(struct sock *);
> > > +
> > > +       for (i =3D 0; i < stab->map.max_entries; i++) {
> >
> > Although it adds a for-loop, the operation below is quite light. So it
> > looks good to me.
>
> We could track a count from update to avoid the loop?
>

I prefer adding a count into struct bpf_stab. We can also get the
number of socks easily with this new count, and it should be
acceptable to modify this count in the update/delete paths.

--=20
Regards
Yafang
