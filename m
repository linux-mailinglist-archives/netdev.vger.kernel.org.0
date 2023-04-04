Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4DD6D5905
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbjDDG5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDG46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:56:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E3B1FE9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:56:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b20so126462162edd.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680591415; x=1683183415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ixnw7Wq75whPxHbpzuaWEj9A1KxsEXSTubcex+rYGcQ=;
        b=UwaZyIz7OOQD6Z5wTQprGBgVab10uNPDOH2gwX9BTr5C1zUwSvlmFIEpNTmeLn1MeX
         Ot5/4MXtuW/VZI5xvL+N/NIbcDzoPu/T5N0ntib5nIcUZYNMKgQBqEXOdjCP36iayxvT
         MIffuE0WIWT/NUDiTRkpD6Rcz2Am4wcpMwzAQPtrJps/XGtq67qW1DMZdYyMWd52PYZl
         ML9ab5ysrxvs/8yRQLGbCOsgYjTDaP2LnuN8/6FFkhi4xlPOfnQ0Cpm/tfeDqQKhIHrl
         +DyL6ZH93MYDe6seU/phpfvhVNmHLt6vTLxT/VWzpigBRauei+V1N1CSf6eBg5DLxv+t
         isVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680591415; x=1683183415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ixnw7Wq75whPxHbpzuaWEj9A1KxsEXSTubcex+rYGcQ=;
        b=KWXDEn8/aTetO9Ycm3jAkeoxj1xqVs3ywTyofbJWSx80Zrl+if4nYQDKsotiNypnvj
         XhVNQ2BuNdG/hoLrX1GgOLffC+vOgT/V0Ls/L8/iixSJfjfWM0oiH8lBQL6jXCyZZCpD
         q8aFCkbtEHLXeJ4x425t+m918EQKbJhvCyWTnmY8JHRrgBGob7ZxSbaqBBxQGSUaM04u
         KZtljgfrAViFywG4HH5sqfQBRbD4cooYwD3X+e0S+xiRsL2+PFMjwPQ8RS1s9LILTH4C
         FsrJwA5YAxEC9nvk6f8c2ZAiNkM2BIRffOi5itIp2lDQBDJCmYJ8Y8Gk8YKELd1ng3ey
         iINg==
X-Gm-Message-State: AAQBX9er7mVt/90MJSmnFV35BNEL+PUMY1KyvchgZsUhJVk9ZxVFQb1E
        M41LKjs+NkMVwB+X+9nl+yY5CuLe2sMIKw4BFDE=
X-Google-Smtp-Source: AKy350ZSEizJ5sv+6voEfV72Oq3SoIWzLwOkGn5S4su9oJmxJKrgte5czowHEuQHYSWDhvjurzks3x/JUW5EylTe23U=
X-Received: by 2002:a17:907:76fc:b0:948:fe00:77f0 with SMTP id
 kg28-20020a17090776fc00b00948fe0077f0mr687790ejc.11.1680591414856; Mon, 03
 Apr 2023 23:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
 <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com> <CANn89iKO9xtHoa39815OyAbTQ_mYr8DMBYu4QX6bs_uDBaT9Tg@mail.gmail.com>
In-Reply-To: <CANn89iKO9xtHoa39815OyAbTQ_mYr8DMBYu4QX6bs_uDBaT9Tg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 4 Apr 2023 14:56:18 +0800
Message-ID: <CAL+tcoC-PNJqhZhDbtJ3O5kTJov5HoxSoy9K30o_HW5fSbVg4Q@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
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

On Tue, Apr 4, 2023 at 12:07=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Apr 4, 2023 at 4:46=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.=
com> wrote:
> >
> > I would like to ask two questions which make me confused:
> > 1) Why would we use spin_lock to protect the socket in a raw hashtable
> > for reader's safety under the rcu protection? Normally, if we use the
> > RCU protection, we only make sure that we need to destroy the socket
> > by calling call_rcu() which would prevent the READER of the socket
> > from getting a NULL pointer.
>
> Yes, but then we can not sleep or yield the cpu.

Indeed. We also cannot sleep/yield under the protection of the spin
lock. And I checked the caller in fs/seq_file.c and noticed that we
have no chance to sleep/yield between ->start and ->stop.

So I wonder why we couldn't use RCU directly like the patch[1] you
proposed before and choose deliberately to switch to spin lock? Spin
lock for the whole hashinfo to protect the reader side is heavy, and
RCU outperforms spin lock in this case, I think.

[1]: commit 0daf07e52709 ("raw: convert raw sockets to RCU")

Thanks,
Jason
>
> > 2) Using spin lock when we're cating /proc/net/raw file may
> > block/postpone the action of hashing socket somewhere else?
>
> /proc/net/raw file access is rare, and limited in duration (at most
> one page filled by system call)
>
> Use of RCU was only intended in my original patch to solve deadlock issue=
s
> under packet floods, like DOS attacks.
>
> Really using RCU in the data/fast path makes sense (and we did that alrea=
dy).
> For control paths (or /proc/.... files), not so much.
