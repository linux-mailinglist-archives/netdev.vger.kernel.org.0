Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B883156D9
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhBITdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbhBITUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:20:04 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E84C061793
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:18:32 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id l8so6922449ybe.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IaTAbos0q8KK6jEXiNUdRnHa4lXYuSQxuVK4ImXFqEo=;
        b=rXIrVPzuGdU9fbdEcMPabND38fvK8xM9W7M2fmSr7xO5Lzt0/Y01oc3city4ECiRbA
         M2flAjzpP+hIRKjR/aRjDiMUIIezp5FGp9wE6BEapRkBYwAQntQEr5jhS7nTP+WMbIOn
         QSz2wtp46xkQjwZ2/Kbcl8M4wLi/g6g0nya4MO/URx/DM5wCtYqSQmOzbnXe2dXqVO47
         XiIfvzpnXkmFsgnIZRQWctdZe358tzQ7ZHROBv9COcZ2wCN+tGv/HcsSPHB5gqNE4V12
         7oPpB9EoJdxGUVtl92vBchjzc5sq/lnJBHah1lbJFe765/a74/cyVCm9bP+6qKoBrkex
         rXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IaTAbos0q8KK6jEXiNUdRnHa4lXYuSQxuVK4ImXFqEo=;
        b=VNABV2jN673ZMPAWOsPqVawrwO5Xk9JXeXoMtvb9b07gIxPXkZfMzt1RBE70Mjb44s
         hGKmfo6F6wB5BfdJq2FhgJrds/5s5+W71Rx0PkEYc6gIMitHUbIrAgsMfPe15fmNhAqD
         Ot0yHsJqv1DLDUP9AJ6cb6NBsmVavlnpDkS/LVxb3Z8MEKM3Y+8y9fqkNrB3HITCinrg
         gdcHvLTOQCeYaJNa7Un7jWkrWK20CRsHk+zlGB0uGTdVguX1b6eC34A9qQqYJkQFTTmn
         7wn/0eRdBaVazSTJiOaQUsFed6pkEEWlhjjrkz4u6LKT2+X+zUx3WNk7RN+cjuukTqJ/
         VGbg==
X-Gm-Message-State: AOAM5321neHBWKFhL/KT/cmspVpxbqPs/ji69trYtEdu8rvSTN9ENG6n
        HcyF7b2gKPEL78S6Az/fCF7vix/tTpWoTkMpTCLLkA==
X-Google-Smtp-Source: ABdhPJwRFVnxkY54Z0j9gN/wnYv2f1EOnHDvMpzv02PiqvRjRncENiKvZClqcxbO/6iJCyI3CHKCglV0fMYB4dgLXto=
X-Received: by 2002:a25:60d6:: with SMTP id u205mr34879564ybb.276.1612898311344;
 Tue, 09 Feb 2021 11:18:31 -0800 (PST)
MIME-Version: 1.0
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
 <87czx978x8.fsf@nvidia.com> <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com> <20210209110426.67df7617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209110426.67df7617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 9 Feb 2021 11:18:05 -0800
Message-ID: <CAF2d9jhQQs+MX4TRbd1c7A3YH5cLV7uaJcQDhE1LWzMAG8uKjA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 9 Feb 2021 10:49:23 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote:
> > > > This will break user scripts, and it fact breaks kernel's very own
> > > > selftest. We currently have this internally:
> > > >
> > > >     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tool=
s/testing/selftests/net/fib_nexthops.sh
> > > >     index 4c7d33618437..bf8ed24ab3ba 100755
> > > >     --- a/tools/testing/selftests/net/fib_nexthops.sh
> > > >     +++ b/tools/testing/selftests/net/fib_nexthops.sh
> > > >     @@ -121,8 +121,6 @@ create_ns()
> > > >       set -e
> > > >       ip netns add ${n}
> > > >       ip netns set ${n} $((nsid++))
> > > >     - ip -netns ${n} addr add 127.0.0.1/8 dev lo
> > > >     - ip -netns ${n} link set lo up
> > > >
> > > >       ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=3D1
> > > >       ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neig=
h=3D1
> > > >
> > > > This now fails because the ip commands are run within a "set -e" bl=
ock,
> > > > and kernel rejects addition of a duplicate address.
> > >
> > > Thanks for the report, could you send a revert with this explanation?
> > Rather than revert, shouldn't we just fix the self-test in that regard?
>
> The selftest is just a messenger. We all know Linus's stand on
> regressions, IMO we can't make an honest argument that the change
> does not break user space after it broke our own selftest. Maybe
> others disagree..

Actually that was the reason behind encompassing this behavior change
with a sysctl.
