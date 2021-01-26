Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6C23057EE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313867AbhAZXGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbhAZSGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:06:24 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A80C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:05:44 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id c1so12914241qtc.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fowtb0fVlW00m6SywxoRx2TU/MEIjVOePVjPPtv6l+s=;
        b=axMYcUusiQOitoa+4p4nJ8Ne56s3qsgPCGXzeddX9d2801UHb9DMw+LB5UYz0h+KzL
         RNhtZA04Skkkymkqct2GavHKXWLAJMgShwi7fajnWS6OycDDe+HWkp7ybL82qfj+hhFP
         VsS1KXvyB5ywRGvYaGh2VyXwWexVFAcVPmeSxKTTD51TYEq6vDV4TE+D/YY9+q2TMIzN
         mMfzWWl4jDj7pzhqIqyxHFRvqRebGNqxPVw/S4j4D65QqYGYg8O/hjLh0kxjyN1u6ehC
         yUcCC+PuzrMSIUl4y3VAlJg5lnBwK7hgVod856K2X/NGRn1XETCgWhx4hb1jRh+eE/5G
         bckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fowtb0fVlW00m6SywxoRx2TU/MEIjVOePVjPPtv6l+s=;
        b=HGjo/QFGS8kxK9GOvtQ+aTWX3rfcQVy54RtnpDdKOb+wGXKTkhoFCon8cn6BFE2JSD
         fJZmepklkjI6eEMY7staUipx6OOsJz9jqRJyW68qwjUOMGjXVqZGocicPSuw/zQhSb2u
         pUxzl4xqG55gCqbei6UM/dPlMG7/SHIuhP767o7Q3gR282s6flrW6ttwcwwVjRyht9jP
         jjrcvcd/MxCkgtsiFuvVzSs14VroxPVz0VdHDGEumaNxZz5lMj0MTT8hJgnijzkTnxRV
         iigjozC9+WkUjSzLzn2OWMn9QYiBUDCOXU81pSNvAH9L6XjagqBFHj696+HZj22Y52hZ
         J9ng==
X-Gm-Message-State: AOAM530TMaGVJmKj+M9Du/fLUYhtOdQNGzQb40z9tr/scJNJWcDKlcpH
        FRsofoz9p1apzfsiqfdoCP+A4TXZz5xf9G9sPQp7ZA==
X-Google-Smtp-Source: ABdhPJwSngOso0IVnqNqzAvythTbBQh/Cjfx8RoSiFa3DhxO+lPs4LSY2j0ZXd3hQ9UoBOUfUtmd2YZw7c7CHU+YqCY=
X-Received: by 2002:ac8:71ca:: with SMTP id i10mr6300016qtp.20.1611684343634;
 Tue, 26 Jan 2021 10:05:43 -0800 (PST)
MIME-Version: 1.0
References: <20210126165104.891536-1-sdf@google.com> <20210126180055.a5vg7vnng2u6r7te@kafai-mbp>
In-Reply-To: <20210126180055.a5vg7vnng2u6r7te@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 26 Jan 2021 10:05:32 -0800
Message-ID: <CAKH8qBvwQOvfPnJMrkecgRdh+F9Uwk-iijiu=EE_G7_YwR-aPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: allow rewriting to ports under ip_unprivileged_port_start
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 26, 2021 at 08:51:03AM -0800, Stanislav Fomichev wrote:
> > At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> > to the privileged ones (< ip_unprivileged_port_start), but it will
> > be rejected later on in the __inet_bind or __inet6_bind.
> >
> > Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> > check should be ignored. Use the same idea as we currently use
> > in cgroup/egress where bit #1 indicates CN. Instead, for
> > cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> > be bypassed.
> >
> > v3:
> > - Update description (Martin KaFai Lau)
> > - Fix capability restore in selftest (Martin KaFai Lau)
> >
> > v2:
> > - Switch to explicit return code (Martin KaFai Lau)
> >
>
> [ ... ]
>
> > @@ -499,7 +501,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >
> >       snum = ntohs(addr->sin_port);
> >       err = -EACCES;
> > -     if (snum && inet_port_requires_bind_service(net, snum) &&
> > +     if (!(flags & BIND_NO_CAP_NET_BIND_SERVICE) &&
> > +         snum && inet_port_requires_bind_service(net, snum) &&
> The same change needs to be done on __inet6_bind()
> and also adds a test for IPv6 in patch 2.
Oh, damn, I did add the flag but forgot to handle it. Thanks for
catching this, will do!
