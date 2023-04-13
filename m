Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE776E1270
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDMQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDMQhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:37:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CA47D81
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:37:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso15811664pjp.5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681403841; x=1683995841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6CA8xH6xpzGSTaAfB+7bPIElYhjC21sBnWRkmsqdd9Y=;
        b=dBm+oZhfqAnUccrZfkosPyJnN/qdA3MUvkXrUieofb/LvXfMtMtS6IVplgPDmvPatm
         s8BNUY4XKCnJVsDRsR8WgjUs+mnI6nMpM2vTNxFSFoIktE+WZGEJzYhGepK9VZwx89Z2
         rQOQ64NJgSLV4JYPWWm9Kqeza4sAjwCh38oHRKpgY/vwygh3KTEZ9JjzmymnTQd5xBvL
         l1UyEtRhXd+N7cnLTobfakrRu6ZAhI5szGVEntiVOLihqTZjTyivFJuhPibP5a7rpg0p
         Xmv+T6bcuc/Kl/gNWz0I++y5Nrkxeqb5i4HM4bDieEQUBJGv6iYlq+MlkIJ4EymTplrF
         1ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681403841; x=1683995841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6CA8xH6xpzGSTaAfB+7bPIElYhjC21sBnWRkmsqdd9Y=;
        b=NNEKPrjEiYcwtIlxq+VDxk+ejaT2yLioimCeUb95pe+zsuos8JJ0p9S8ELBLvFLC7H
         r6Cvxreuk3kxnUn64jEtW/opvcPxFraDJUaTbuOt19n5/WSUCjG/4aRyjHO6nW3L52YP
         qTxG6Dw3ShCho5qq3ehnhdHGzWbxvJDmvYqW+56uscTmCDGbs4PoeDQ2XGkxDXoIi9vo
         GSClRosUUs6bJxh2+LGWmpfCH8CF88oLv9CMxwbDKNXjXOxysZf5fAuBFKUWBbeD+u/Q
         AcRFS3hsP7J+blu8Ku/5kmeCCYV/hHZZA1B1GVUvoZLARGxHSbPlDZlVTNs5Sx1piS2z
         7HDw==
X-Gm-Message-State: AAQBX9dTWLRqbiq894hm+wzlKKNcNT75saP4eSYA2EK+5aE6N/Beyf3p
        rduHwTV6JTkRUhA68N8HYhpJnsj8bBAobNrmT3SxbA==
X-Google-Smtp-Source: AKy350ZbTcGWihbsBVI92ZrnU8vczpkwpChkP34j3DXn6CSEnqLGjswcFPVAGFEm+BT0tvAQpP1VH4EKqIGHsFBDY0A=
X-Received: by 2002:a17:90a:55cb:b0:246:6065:d2b5 with SMTP id
 o11-20020a17090a55cb00b002466065d2b5mr722784pjm.9.1681403840901; Thu, 13 Apr
 2023 09:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com> <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
In-Reply-To: <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 13 Apr 2023 09:37:09 -0700
Message-ID: <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
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

On Thu, Apr 13, 2023 at 7:38=E2=80=AFAM Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> On Thu, Apr 13, 2023 at 4:22=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Thu, Apr 13, 2023 at 3:35=E2=80=AFPM Alexander Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > >
> > > During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
> > > that bpf cgroup hook can cause FD leaks when used with sockopts which
> > > install FDs into the process fdtable.
> > >
> > > After some offlist discussion it was proposed to add a blacklist of
> >
> > We try to replace this word by either denylist or blocklist, even in ch=
angelogs.
>
> Hi Eric,
>
> Oh, I'm sorry about that. :( Sure.
>
> >
> > > socket options those can cause troubles when BPF cgroup hook is enabl=
ed.
> > >
> >
> > Can we find the appropriate Fixes: tag to help stable teams ?
>
> Sure, I will add next time.
>
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>
> I think it's better to add Stanislav Fomichev to CC.

Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
use it for tcp zerocopy, I'm assuming it should work in this case as
well?

> Kind regards,
> Alex
>
> >
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Leon Romanovsky <leon@kernel.org>
> > > Cc: David Ahern <dsahern@kernel.org>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Christian Brauner <brauner@kernel.org>
> > > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Cc: linux-arch@vger.kernel.org
> > > Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Suggested-by: Christian Brauner <brauner@kernel.org>
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical=
.com>
> >
> > Thanks.
