Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10BC6D596F
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbjDDHXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjDDHXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:23:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CB81BCB
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:23:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t4so26455536wra.7
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 00:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680593007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoJWjo13w7BIQd0gW6vXgkjISBUr7VMdp3a+1tPahdo=;
        b=bs9aR/IBR7HDFqSKKSAjVD1nFCqHome6BWXr7ELZ1RlnC8ynoxwY6DWX9Voy79Vetl
         VfPZR8hGc+B4Gy+nOMgclor3AG4iPOkebslAJ6mbwY11CCzYjb/BlQrUtWekRQLbOdnY
         3i54VA3Nzid8JknFGtlXUqrFce3Nak44t1FqMxEcZA1BCxS7ilwI68E/aoFOspeiImFS
         5AjtXmthNIj0ZdC2GEIb1mi5gMV+MWlGv9r3EbtKr09Nbs++j3/WpjQgO7JHJFr4h0EO
         1ChxlHT3+xgnwW+p3ZltUjP2ehG468hux0u+6RbojJDRX3Z4W4aqfgyKxTwYolODn9hA
         QiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GoJWjo13w7BIQd0gW6vXgkjISBUr7VMdp3a+1tPahdo=;
        b=csHDPORMMsUEDECQc2Y3Q+NwLzoPsrb+DlognFT/ZZ32fKY+09zp2Xc0UmHzf7afHp
         ufmjHA4Hl/8yvCSSwjzl/Mun6yI0lWLp0JiQxZAcY7RhjLCcQGSUftIe4NT9+yb8/EL5
         gbApEy8n1JFtARstFxKJip2fTVth51VrrkF2qS6v4tLLPBWd9ifsHt/w9/e23LeDARxN
         PSGM9gNgz/LTI5HozNAsUd7nwqpYOHOh1wJPquEg84QafjdAWh2z7K03IUijwL3o/0vg
         BDIjg4yIDlLj4r2qljIebEZechEPbEOc8WlrRGCWmyvvcYV0bbomaXjQUxiFK4vOsRai
         /Yag==
X-Gm-Message-State: AAQBX9dkEGbl8/TDkC436jcI7yuvSG31sMRxKHoPU1zr0dVmrfotxCej
        zia9M8hXSZk0TZmkuvadoEeleiJwRBkI5AqjOX2ltg==
X-Google-Smtp-Source: AKy350Z8nD4jz9GFypqt+CuI5P0huIJOQvPzJF047o+zqH+ZVSQusQ6vFxJ5tqaoTts8BcFS3KdweykMKpLStdihMqU=
X-Received: by 2002:a5d:564e:0:b0:2ce:ae7e:c4a3 with SMTP id
 j14-20020a5d564e000000b002ceae7ec4a3mr258091wrw.12.1680593007212; Tue, 04 Apr
 2023 00:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
 <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com>
 <CANn89iKO9xtHoa39815OyAbTQ_mYr8DMBYu4QX6bs_uDBaT9Tg@mail.gmail.com> <CAL+tcoC-PNJqhZhDbtJ3O5kTJov5HoxSoy9K30o_HW5fSbVg4Q@mail.gmail.com>
In-Reply-To: <CAL+tcoC-PNJqhZhDbtJ3O5kTJov5HoxSoy9K30o_HW5fSbVg4Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 09:23:15 +0200
Message-ID: <CANn89iJqGZyk6QCG46PpUs9L0HUMQL425vx3ETPwXy7xUjGu9Q@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 8:56=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.co=
m> wrote:
>
> On Tue, Apr 4, 2023 at 12:07=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Tue, Apr 4, 2023 at 4:46=E2=80=AFAM Jason Xing <kerneljasonxing@gmai=
l.com> wrote:
> > >
> > > I would like to ask two questions which make me confused:
> > > 1) Why would we use spin_lock to protect the socket in a raw hashtabl=
e
> > > for reader's safety under the rcu protection? Normally, if we use the
> > > RCU protection, we only make sure that we need to destroy the socket
> > > by calling call_rcu() which would prevent the READER of the socket
> > > from getting a NULL pointer.
> >
> > Yes, but then we can not sleep or yield the cpu.
>
> Indeed. We also cannot sleep/yield under the protection of the spin
> lock. And I checked the caller in fs/seq_file.c and noticed that we
> have no chance to sleep/yield between ->start and ->stop.
>

You missed my point.
The spinlock can trivially be replaced by a mutex, now the fast path
has been RCU converted.
This would allow raw_get_idx()/raw_get_first() to use cond_resched(),
if some hosts try to use 10,000 raw sockets :/
Is it a real problem to solve right now ?  I do not think so.

> So I wonder why we couldn't use RCU directly like the patch[1] you
> proposed before and choose deliberately to switch to spin lock? Spin
> lock for the whole hashinfo to protect the reader side is heavy, and
> RCU outperforms spin lock in this case, I think.

spinlock is just fine enough, most hosts have less than 10 raw sockets,
because raw sockets make things _much_ slower.

RCU 'just because' does not make sense, it would suggest that RAW sockets
scale, while they do not.
