Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F62D579B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgLJJzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgLJJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:55:19 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ADAC0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:54:38 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id d9so4852278iob.6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PGz4NarWuf6bnnC4F66j8rQJHANbbohx5EwHe/89Tso=;
        b=T4YVKnfQFPHTkOXqdUv9hdwXdWIIiA9k48RJBOOSsfngFaXyG1DURiZx2+QOeI5nVM
         NceHBgbRL4WFS5qo3+DZr76D9BpiFnDB1qpiTrVlnVC3+kLgHUfcWveMKvVcG4jIrri2
         6JfGYgMLMN0+ix4bPRFGOAsRjP+OpfE7DJ33PBlxwrkDFfdLSNn+oICeA7lVku+TguGl
         rXqWs88Gjww/rkVHZsBeUe0DHc8JCAtJ3ZguGADbRLfUfjCorWkwE/Vkau6lTcRdbJM8
         tzQ3ODjYlEWJW3QvElfIyDoVANLDOIMlVXzEqxhoH8WKzvxj50nOKk7rlEQUsjeOqQ2V
         wKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PGz4NarWuf6bnnC4F66j8rQJHANbbohx5EwHe/89Tso=;
        b=Q9itIzz361nJT17FqYLLkFIXzaQQmEVhEpgK3LBmQotSBZ5sdbcCe+afQTuia/QQ0F
         I6SK3TDNRuUNx1ljrEiY9zqPiwu+uZA/tuH4EYUKc1WcGLBhHF/rSjAS8ff2ozfyv6LU
         54Ouu+Bn5dd7p9ggonlJKKXtg/FCdG7Pr0q6eWF3G8VWDZlN+YmUwQVEWbgcwd0LaNlC
         ZrfDwp5ZtB2XIYWNCGFuxVzcqDyrbIwR/SIPaCQZF2Dz/OpddBJT46HB8EQOsntT/wg7
         t6b21b1VEYqAMS5rz2/P4yEgDJIhEJpgJmWqj2A5zQGb1QX+UcJuqni6Cl9jP3HKE+CE
         6wSA==
X-Gm-Message-State: AOAM531jVh6p0GDivDWqs3JNbqrg7R3S6xPv7wUqSS4X5QyfjBolCS2L
        9wyfn+iwQ+myTr/xPCijd4ZixKjaVapJNEkU4C4K+w==
X-Google-Smtp-Source: ABdhPJzmLDI2nRM0U+SUETlua81Oc6POKIrcdkCYRxLfgscmeh3YSEsL1uJJ29oDrdoNsSfbR5UjPKqzitKSS90TDcw=
X-Received: by 2002:a02:e87:: with SMTP id 129mr5504755jae.34.1607594077564;
 Thu, 10 Dec 2020 01:54:37 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
 <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
 <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
 <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
 <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
 <ygnhsg8ek8dr.fsf@nvidia.com> <20201209142256.3e4a08fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <ygnhpn3ijbyb.fsf@nvidia.com>
In-Reply-To: <ygnhpn3ijbyb.fsf@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Dec 2020 10:54:25 +0100
Message-ID: <CANn89iKuUrYGwg7=xuf0CypLKhfjMN9Jy0QO1s5G8HvRmkwuSg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTAuMC1yYzYgKG1haQ==?=
        =?UTF-8?B?bmxpbmUua2VybmVsLm9yZyk=?=
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
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

On Thu, Dec 10, 2020 at 9:35 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> On Thu 10 Dec 2020 at 00:22, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 9 Dec 2020 22:54:40 +0200 Vlad Buslov wrote:
> >> > Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
> >> > dropped ;)
> >> >
> >> > I am testing this before offical patch submission.
> >>
> >> Your patch fixed TC geneve tests for me, but some of more complex OVS
> >> tests are still failing. I'll try to provide details tomorrow.
> >
> > Does a revert of Eric's patch fix it? For OvS is could also well be:
> > 9c2e14b48119 ("ip_tunnels: Set tunnel option flag when tunnel metadata is present")
>
> The tests pass with Eric's commit reverted.
>

Thanks a lot for testing, I am truly sorry for the inconvenience :/
