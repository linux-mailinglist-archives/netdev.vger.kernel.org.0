Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C42D4C87
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgLIVIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbgLIVIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 16:08:47 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB3C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 13:08:07 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y9so3039344ilb.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 13:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpuqDtXXMpnY72P/EAHR6IqnS06f0VeKtnbAYGA9GKo=;
        b=ZGFa+amhEA1jElZh9amG8SwDyJt375Uh+8roIenvN2AUV7gYvjuvIrYK/6gLmD0RQt
         c/gU0RIghAhbisxGxIQteIM+Anbba3lRN5Sx1qdQI6vLmuL3c5mTPTYumGbEeG5GzMjW
         8gRzUVLNWosoE3y6/3esOWHXi0Cg91cUTAvWQx/lBB6yXa6poHzMwR83AFquJCzE5v4R
         U3P7BEP+Yr9obrdv6iNPGM/PUjLKqbbPVpfI0LxR2rvPTCjH76DusqVHZBaaBlNrug1T
         S9u8/0HBqbyKaB2OgjUNcEh+iektnSfEMr0i9sMVKMWF+Dy2Yhax91uT3tyfCOCZyNdg
         ZiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpuqDtXXMpnY72P/EAHR6IqnS06f0VeKtnbAYGA9GKo=;
        b=nuxqt0NqWMBdPJwvtdI1gq+c4BLcRjSSpgdcizGWmCLF0SVn4aLZvj59VKcnbFEjw3
         y53n1pgLj3zQ609VPpnKKtHXY1whiHTkMp6I2yy4ot5LKUQPHjiSqWrcCFSlCq+UNaeF
         sVF8s00oYXlUQ6MFgtrhxE+45tl7HhCAe1VejiBkQsFR+It9KT/xK5ub8630SvTVZVfP
         UA9SCl43MOtV3B+lm1icv8cQWI/ZCvhX9rcsK/15dTtwvQWrwcY8vN0pOXYd8uIDH0QO
         w9mJsofSQAZQSgT+sxM2TtIg+MtDcYDIvIIGXXgQAQDwv0THnMPL29eqXsT3TePoc029
         N0QA==
X-Gm-Message-State: AOAM5323R7niFjt95EC4AhDtX8FonEAavmUecNlGDXaC2hZ0YBdZBDdw
        8PxrgFMKEbFuejy5P7ALzRG8zNVQPDC6UGnNT1/I5w==
X-Google-Smtp-Source: ABdhPJwPDL+bHdEJnU8jj+M2st6uy35/KJNmnOwC5gDRxdetRaztANKxN3ZwCrR4khkTF0a4HMqvpnD4kP+lxbsyXSI=
X-Received: by 2002:a92:d0ca:: with SMTP id y10mr5796513ila.68.1607548086465;
 Wed, 09 Dec 2020 13:08:06 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
 <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
 <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
 <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
 <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com> <ygnhsg8ek8dr.fsf@nvidia.com>
In-Reply-To: <ygnhsg8ek8dr.fsf@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Dec 2020 22:07:54 +0100
Message-ID: <CANn89iJVWfb=2i7oU1=D55rOyQnBbbikf+Mc6XHMkY7YX-yGEw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTAuMC1yYzYgKG1haQ==?=
        =?UTF-8?B?bmxpbmUua2VybmVsLm9yZyk=?=
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 9:54 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> On Wed 09 Dec 2020 at 20:50, Eric Dumazet <edumazet@google.com> wrote:
> > On Wed, Dec 9, 2020 at 7:34 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >>
> >> On Wed, 2020-12-09 at 19:05 +0100, Eric Dumazet wrote:
> >> > On Wed, Dec 9, 2020 at 6:35 PM Eric Dumazet <edumazet@google.com>
> >> > wrote:
> >> > > Hmm... maybe the ECN stuff has always been buggy then, and nobody
> >> > > cared...
> >> > >
> >> >
> >> > Wait a minute, maybe this part was not needed,
> >> >
> >> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> >> > index
> >> > 8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd..896a7eb61d70340f69b9d3be0f7
> >> > 95fbaab1458dd
> >> > 100644
> >> > --- a/drivers/net/geneve.c
> >> > +++ b/drivers/net/geneve.c
> >> > @@ -270,7 +270,7 @@ static void geneve_rx(struct geneve_dev *geneve,
> >> > struct geneve_sock *gs,
> >> >                         goto rx_error;
> >> >                 break;
> >> >         default:
> >> > -               goto rx_error;
> >> > +               break;
> >> >         }
> >> >         oiph = skb_network_header(skb);
> >> >         skb_reset_network_header(skb);
> >> >
> >> >
> >> > > On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org>
> >> > > wrote:
> >> > > > Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull
> >> > > > IP
> >> > > > header before ECN decapsulation")?
> >> > > >
> >>
> >> We've bisected an issue in our CI to this patch, something about geneve
> >> TC offload traffic not passing, I don't have all the details, Maybe
> >> Vlad can chime in.
> >>
> >
> > Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
> > dropped ;)
> >
> > I am testing this before offical patch submission.
> >
> > Thanks !
>
> Hi Eric,
>
> Your patch fixed TC geneve tests for me, but some of more complex OVS
> tests are still failing. I'll try to provide details tomorrow.
>
> Regards,
> Vlad
>

I think I need to study a bit more the original syzbot report.

Apparently, network header should have been pulled already before
hitting geneve_rx()

Jakub, please revert my patch, I need to fix the syzbot issue differently.

Thanks !
