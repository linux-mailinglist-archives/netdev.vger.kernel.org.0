Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E56EFBE9
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbjDZUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjDZUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:49:51 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2250D270E
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:49:34 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-54fb9384c2dso90495597b3.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1682542174; x=1685134174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4rJdKQ7xY8jpnF0AffukVPnUu/ms1dIRsJxDMqyrkc=;
        b=Rgdq0t7hxHEPm1qLjVg3CBZYJc6G1wpnFDHqA1BpBJLIBTW/vQxbQAe+qv+C0FC7dJ
         e5X2ElxCAfjdTneKY3KmjYyZp5g7E/qcF7Y7OfNqh0fIaqAF7KvNjlX/cwNnJ0ilFie6
         TPX+91L0tbyvAMpB/UceUQomZGyeTNLOUbJekFUqRsSkyOPEoACnsyVSWrJKoih8STzf
         zfmNiucl/dyrh9M6gp/BjyJZJHi4vACYi3jPtRm1e4bzqVIW4N8Efgt6/Hh7swhEHZdz
         3KmbkltpQL6onE23Q25wEEkQm5xHMXIh/Z+p1fFa4XpYS6MhdCrJGwNqC61o5lk+9Nfj
         EPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542174; x=1685134174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4rJdKQ7xY8jpnF0AffukVPnUu/ms1dIRsJxDMqyrkc=;
        b=ldzvr9pWEtIpR150g3W5x5DacpobGIa2oRE1jiR/52obahIhUmqxsXcmyU6Z0RY+LI
         mjZzRKDo+Sh1PgPOaagXMHiDh0fHMtsozofKoCWtYlFOUijVr8xom/9d3I8BBQYJszJD
         1Z9A4AKDpJ5WlnGQlvwZfFukA7VE98dwlfJxOYcMq7eKIkou8+Kr91+TCUC4x5ZCXZUQ
         LxSlSpgQXWJaR/7HwiE65wBS6RCSt2T3KLjNi0ootkJxWZiofa7Nb7yKAuLB8wGazwl6
         3IQq6I5D0mbd+F3hmT0ZqepbHwN5TWrKOofe3cUnticyOFpVx5XwPAvIFIjrUPp0+sKZ
         06TQ==
X-Gm-Message-State: AAQBX9d99bu2jYExaTsUjz77Vb7L9D9ady1edyRqLGCW0hi0+fWTKln9
        5UfY78FPJ050GX5GYZefV1E9/r9O4ZCT3p4gxN6E
X-Google-Smtp-Source: AKy350a12tvjCY07iukVLD60nWTYZGRcAFv0h8Sj3IbRUahlkzdfNqgEHT4Va4jn8DOd0csVprbdJ3OXk0s+6pdmkbM=
X-Received: by 2002:a81:4fd2:0:b0:54f:8b2b:adec with SMTP id
 d201-20020a814fd2000000b0054f8b2badecmr14188403ywb.33.1682542173844; Wed, 26
 Apr 2023 13:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
 <CAHC9VhR68fw+0oaenL08tRecLEC_oCdYcfGaN_m6PW3KZYtdTQ@mail.gmail.com> <f251507a-517e-b703-aa1d-50f6b3de8c8d@tessares.net>
In-Reply-To: <f251507a-517e-b703-aa1d-50f6b3de8c8d@tessares.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 26 Apr 2023 16:49:23 -0400
Message-ID: <CAHC9VhQqgau3rL2182bVzONHqnfN2CtCT5hz29CVzYi=gpX6+A@mail.gmail.com>
Subject: Re: [PATCH LSM 0/2] security: SELinux/LSM label with MPTCP and accept
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:55=E2=80=AFPM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
> On 19/04/2023 23:30, Paul Moore wrote:
> > On Wed, Apr 19, 2023 at 1:44=E2=80=AFPM Matthieu Baerts
> > <matthieu.baerts@tessares.net> wrote:
> >>
> >> In [1], Ondrej Mosnacek explained they discovered the (userspace-facin=
g)
> >> sockets returned by accept(2) when using MPTCP always end up with the
> >> label representing the kernel (typically system_u:system_r:kernel_t:s0=
),
> >> while it would make more sense to inherit the context from the parent
> >> socket (the one that is passed to accept(2)). Thanks to the
> >> participation of Paul Moore in the discussions, modifications on MPTCP
> >> side have started and the result is available here.
> >>
> >> Paolo Abeni worked hard to refactor the initialisation of the first
> >> subflow of a listen socket. The first subflow allocation is no longer
> >> done at the initialisation of the socket but later, when the connectio=
n
> >> request is received or when requested by the userspace. This was a
> >> prerequisite to proper support of SELinux/LSM labels with MPTCP and
> >> accept. The last batch containing the commit ddb1a072f858 ("mptcp: mov=
e
> >> first subflow allocation at mpc access time") [2] has been recently
> >> accepted and applied in netdev/net-next repo [3].
> >>
> >> This series of 2 patches is based on top of the lsm/next branch. Despi=
te
> >> the fact they depend on commits that are in netdev/net-next repo to
> >> support the new feature, they can be applied in lsm/next without
> >> creating conflicts with net-next or causing build issues. These two
> >> patches on top of lsm/next still passes all the MPTCP-specific tests.
> >> The only thing is that the new feature only works properly with the
> >> patches that are on netdev/net-next. The tests with the new labels hav=
e
> >> been done on top of them.
> >>
> >> It then looks OK to us to send these patches for review on your side. =
We
> >> hope that's OK for you as well. If the patches look good to you and if
> >> you prefer, it is fine to apply these patches before or after having
> >> synced the lsm/next branch with Linus' tree when it will include the
> >> modifications from the netdev/net-next repo.
> >>
> >> Regarding the two patches, the first one introduces a new LSM hook
> >> called from MPTCP side when creating a new subflow socket. This hook
> >> allows the security module to relabel the subflow according to the owi=
ng
> >> process. The second one implements this new hook on the SELinux side.
> >
> > Thank you so much for working on this, I really appreciate the help!
>
> Thank you for the review!
>
> We are working on a v2 addressing your comments.

Thanks for getting v2 out so quickly.  I'm getting caught up on other
issue while we're in the merge window right now, but I'll give the v2
patchset a look in the not-to-distant future.  I'm fairly confident
we'll get it merged this dev cycle.

> Just one small detail regarding these comments: I hope you don't mind if
> we use "MPTCP socket" instead of "main MPTCP socket". Per connection,
> there is one MPTCP socket and possibly multiple subflow (TCP) sockets.
> There is then no concept of "main MPTCP socket".

Sure, no problem.

> > As far as potential merge issues with netdev/net-next and lsm/next, I
> > think we'll be okay.  I have a general policy[1] of not accepting new
> > patchsets, unless critical bugfixes, past rc5/rc6 so this would be
> > merged into lsm/next *after* the current merge window closes and
> > presumably after the netdev/net-next branch finds its way into Linus'
> > tree.
>
> It makes sense, we understand. These two patches were ready for a bit of
> time but we wanted to send them only after the prerequisite commits
> applied in net-next first. But that got delayed because we had a couple
> of nasty issues with them :)
>
> We hope it will not be an issue for you to maintain them in your tree
> for a couple of months but we tried to minimised the modifications in
> MPTCP code. Do not hesitate to reach us if there are some issues with the=
m!

No worries, I'm happy to maintain them in either the LSM or the
SELinux tree (I'll need to remind myself of the changes to see which
is the best fit).

--
paul-moore.com
