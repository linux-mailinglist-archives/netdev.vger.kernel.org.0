Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC0B6D2C59
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 03:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjDABJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 21:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbjDABJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 21:09:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DFF1D869;
        Fri, 31 Mar 2023 18:09:23 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h14so14460265pgj.7;
        Fri, 31 Mar 2023 18:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680311363;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUN8WvczuQXpCgMPQnBz+ElNsxpaR9j0Hx9WkE+k5t4=;
        b=GlRUUXup8p2ycO4vuBSCG3aDKHl6BzkEOWMlmVvx3Nkn1AQoXzmDEtsB+acBUSITXr
         oBDvk/MlwQn1PrU/AkO4Ng0m0hrNC59FlNYT9LFyQGibGJd7l6xwUlA6NUl5HCopcKCz
         REHHsf8r0G2UzI/C0Yz0aGIBgd4XwfSCDg6PkngkDFHkIdtRxdAAqud2CeuptACtFIhZ
         h3I7c20r6bvq1gVKsaTAPmfGsBWi4xHtkfY0JG6x2WopAdRyQBjfjotolUyOvlO5+tt8
         QRIRBWN/+ti6FdjxSgXCy/1FD85Q/RoaPkhp/aPxzypYDlLfZjt2/dOwZiFS0ZQZnkgi
         vEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680311363;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cUN8WvczuQXpCgMPQnBz+ElNsxpaR9j0Hx9WkE+k5t4=;
        b=ZQTm5+wIefaHUe4lc/HZGgRX6HYeEdWOvCQeNkzB1fCdd95AQPHYy/pvSX/0+djhQG
         QcCRzsh3YPVsuAgV2SMvcnzqrLO0zRXq3zkrwqmRdAVUVqweiExUHOa/KmPEC6hnyuJT
         86Y4PqkIR2DztEWpjC1duP83si2d9L218IJT1zh7rgor+xtPHSj7d4k4W49EWjjeYFOe
         qlF8oRjHMXqj2S1etOrQ01X3qBpFgAw9BWGj8g0RHf/1ZNMokYuulHB/glAz5mKwqu94
         yq0w7cmC1Lnp7AwVKe3sBX+umoWfacmxwp3ZwrPZu6liTuNCNxl1IUaPsDVGw5+pYW7I
         LGvg==
X-Gm-Message-State: AAQBX9dBo4WzfkNbkaybeHU++nKTVEd9qqGIlr9LpOSH7fi6aBFpT7i8
        rjMECl9s1rqUjhM22CI0Ax4=
X-Google-Smtp-Source: AKy350YGJQEHDwSrG5wusbTZWUYMAKY+9JwSacuZukV0ZOT9ZlXSFjwfMFCld/vEe0862VEPE6+vrQ==
X-Received: by 2002:a62:1811:0:b0:62a:4503:53ba with SMTP id 17-20020a621811000000b0062a450353bamr26539907pfy.26.1680311363072;
        Fri, 31 Mar 2023 18:09:23 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7924d000000b006262520ac59sm2382826pfp.127.2023.03.31.18.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 18:09:22 -0700 (PDT)
Date:   Fri, 31 Mar 2023 18:09:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <6427844176538_c503a208e4@john.notmuch>
In-Reply-To: <CALOAHbCyGJzp1yH2NTsikre0RuQ+4WoZCsAc110_+tW=L8FgQg@mail.gmail.com>
References: <20230326221612.169289-1-xiyou.wangcong@gmail.com>
 <CALOAHbCyGJzp1yH2NTsikre0RuQ+4WoZCsAc110_+tW=L8FgQg@mail.gmail.com>
Subject: Re: [Patch bpf-next] sock_map: include sk_psock memory overhead too
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Yafang Shao wrote:
> On Mon, Mar 27, 2023 at 6:16=E2=80=AFAM Cong Wang <xiyou.wangcong@gmail=
.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > When a socket is added to a sockmap, sk_psock is allocated too as its=

> > sk_user_data, therefore it should be consider as an overhead of sockm=
ap
> > memory usage.
> >
> > Before this patch:
> >
> > 1: sockmap  flags 0x0
> >         key 4B  value 4B  max_entries 2  memlock 656B
> >         pids echo-sockmap(549)
> >
> > After this patch:
> >
> > 9: sockmap  flags 0x0
> >         key 4B  value 4B  max_entries 2  memlock 1824B
> >         pids echo-sockmap(568)
> >
> > Fixes: 73d2c61919e9 ("bpf, net: sock_map memory usage")
> > Cc: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/core/sock_map.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 7c189c2e2fbf..22197e565ece 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -799,9 +799,17 @@ static void sock_map_fini_seq_private(void *priv=
_data)
> >
> >  static u64 sock_map_mem_usage(const struct bpf_map *map)
> >  {
> > +       struct bpf_stab *stab =3D container_of(map, struct bpf_stab, =
map);
> >         u64 usage =3D sizeof(struct bpf_stab);
> > +       int i;
> >
> >         usage +=3D (u64)map->max_entries * sizeof(struct sock *);
> > +
> > +       for (i =3D 0; i < stab->map.max_entries; i++) {
> =

> Although it adds a for-loop, the operation below is quite light. So it
> looks good to me.

We could track a count from update to avoid the loop?

> =

> > +               if (stab->sks[i])
> =

> Nit, stab->sks[i] can be modified in the delete path in parallel, so
> there should be a READ_ONCE() here.
> =

> > +                       usage +=3D sizeof(struct sk_psock);
> > +       }
> > +
> >         return usage;
> >  }
> >
> > @@ -1412,7 +1420,7 @@ static u64 sock_hash_mem_usage(const struct bpf=
_map *map)
> >         u64 usage =3D sizeof(*htab);
> >
> >         usage +=3D htab->buckets_num * sizeof(struct bpf_shtab_bucket=
);
> > -       usage +=3D atomic_read(&htab->count) * (u64)htab->elem_size;
> > +       usage +=3D atomic_read(&htab->count) * ((u64)htab->elem_size =
+ sizeof(struct sk_psock));
> >         return usage;
> >  }
> >
> > --
> > 2.34.1
> >
> =

> =

> -- =

> Regards
> Yafang


