Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFD3D4E2F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhGYORe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhGYORd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 10:17:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB61C061764
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 07:58:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gt31so11792253ejc.12
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 07:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTpP+ceuRLJoSYd5/RLRXP0WWBH8HGVrnJWFQZSuKr0=;
        b=dvwcY7cRO9jZIVvU8x0/AGQfyDKo+9MUEuB7fbJvCGnWLXKzQ89XuCAqymXCyXqbfF
         lFnHhpUb5E9HYT4WWkDpLxNpB4zwMreQ5DuRqiFTyUsox+Wx5Loli/hnaSME7jBp32ji
         cA7RJJlyn0nj8J80pgvPxksJKH3gTiGfCPfhPwZ6i146APgD8NA6e87nnZWGq6G0CWA7
         771uAK+NN74q30SPgsTL9Il7CLcFBem7Gy9qjD0+C6Yfhl21Yv/j8eMxLmwodeUv0uQk
         6PMe6dBWcwhDnKDna7BvRMTDvYYojzSfapV88hDZjqVOFH/K35BcIrOwSNdkraFIuuR0
         Kvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTpP+ceuRLJoSYd5/RLRXP0WWBH8HGVrnJWFQZSuKr0=;
        b=g9nmFhIE2sz84RVlWwNbLoGu9/Xq1Rt87jSdZwW3wNFdAoPPHuhFooUTEvC0VVHZWi
         m5KuhNjq8EbIpdl6TIAZEMpu3+r2qMG4xYQ+4aF8Dl2hQwJQ02XOMvSIyqezYAS7+jvE
         EAC0f7uWhQ19CW2uzOYD72i+3SoMiEsAhBk6RgzJA3RUilxC4sIBvsVe18aiqanNjawr
         o7orF9qDx8ZsTj8ht3gkokNyS+pod3h1t1hZfBUAWps+pnYePxQhKbsucRLAcfRUntZL
         +sT3x5lnj4r+odl10PKxD+kXdEutG1JQL7bvQMPElMeVPgybMAEfpIW1rQBdNwLvYEqP
         VLqQ==
X-Gm-Message-State: AOAM531cXGb4zwyBgObmdJnJMCSiD7XstJZoh7tkfPlYo00Dpk0uCMZD
        h4Bka+tnwYFSk1mWIraNCqyAudpRm6oGUvaKBAru
X-Google-Smtp-Source: ABdhPJwXtbiJ4ZHr7JqwUOzgfUp4xOZNkzvJ4OYKiTRCH7/AWtfUli1vwjlyeXjr8dxZ4U2Yzqf+romthxh0BVelXL0=
X-Received: by 2002:a05:6402:b79:: with SMTP id cb25mr16443238edb.164.1627225081919;
 Sun, 25 Jul 2021 07:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1626879395.git.pabeni@redhat.com> <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com> <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com> <20210724185141.GJ9904@breakpoint.cc>
In-Reply-To: <20210724185141.GJ9904@breakpoint.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 25 Jul 2021 10:57:50 -0400
Message-ID: <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Florian Westphal <fw@strlen.de>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 2:51 PM Florian Westphal <fw@strlen.de> wrote:
> Paul Moore <paul@paul-moore.com> wrote:
>  > Tow main drivers on my side:
> > > - there are use cases/deployments that do not use them.
> > > - moving them around was doable in term of required changes.
> > >
> > > There are no "slow-path" implications on my side. For example, vlan_*
> > > fields are very critical performance wise, if the traffic is tagged.
> > > But surely there are busy servers not using tagget traffic which will
> > > enjoy the reduced cachelines footprint, and this changeset will not
> > > impact negatively the first case.
> > >
> > > WRT to the vlan example, secmark and nfct require an extra conditional
> > > to fetch the data. My understanding is that such additional conditional
> > > is not measurable performance-wise when benchmarking the security
> > > modules (or conntrack) because they have to do much more intersting
> > > things after fetching a few bytes from an already hot cacheline.
> > >
> > > Not sure if the above somehow clarify my statements.
> > >
> > > As for expanding secmark to 64 bits, I guess that could be an
> > > interesting follow-up discussion :)
> >
> > The intersection between netdev and the LSM has a long and somewhat
> > tortured past with each party making sacrifices along the way to get
> > where we are at today.  It is far from perfect, at least from a LSM
> > perspective, but it is what we've got and since performance is usually
> > used as a club to beat back any changes proposed by the LSM side, I
> > would like to object to these changes that negatively impact the LSM
> > performance without some concession in return.  It has been a while
> > since Casey and I have spoken about this, but I think the prefered
> > option would be to exchange the current __u32 "sk_buff.secmark" field
> > with a void* "sk_buff.security" field, like so many other kernel level
> > objects.  Previous objections have eventually boiled down to the
> > additional space in the sk_buff for the extra bits (there is some
> > additional editorializing that could be done here, but I'll refrain),
> > but based on the comments thus far in this thread it sounds like
> > perhaps we can now make a deal here: move the LSM field down to a
> > "colder" cacheline in exchange for converting the LSM field to a
> > proper pointer.
> >
> > Thoughts?
>
> Is there a summary disucssion somewhere wrt. what exactly LSMs need?

My network access is limited for the next week so I don't have the
ability to dig through the list archives, but if you look through the
netdev/LSM/lists over the past decade (maybe go back ~15 years?) you
will see multiple instances where we/I've brought up different
solutions with the netdev folks only to hit a brick wall.  The LSM ask
for sk_buff is really the same as any other kernel object that we want
to control with LSM access controls, e.g. inodes; we basically want a
void* blob with the necessary hooks so that the opaque blob can be
managed through the skb's lifetime.

> There is the skb extension infra, does that work for you?

I was hopeful that when the skb_ext capability was introduced we might
be able to use it for the LSM(s), but when I asked netdev if they
would be willing to accept patches to leverage the skb_ext
infrastructure I was told "no".

-- 
paul moore
www.paul-moore.com
