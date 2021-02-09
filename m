Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B96315670
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhBIS7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbhBISux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:50:53 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E3AC06121E
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 10:49:51 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id k4so19197294ybp.6
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 10:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Pwipz8spD7rBJXW+QWOVX+uMB6eI49pQB20ICUAJFI=;
        b=Vt5EkqcnuQlFV4Hj8DoauwmByNRNU1f2wfgd+lD5GnZ6ZUnP6aiymbkbczhD86B6NB
         ln7hpiDXPWeSXeeyh9mfeD3MKSPlKftiQPnr1T5qalL7/6bovW6sZoIPMD84FfssplfG
         ekqK4pfe9tU4YB2cS4RurHS0wJr5EaTGj+1CDyz69pNrfr4Z3L+ZClK/mFETgdLCieAM
         g7m2AHJlf2/i/Y13oljsYdnY9keMfMhf1cj+XBBiINtPZyxCUyPb4d+3ivgmR+R2AI+8
         zummHm8C6R757YhAF/F1Uois97DD2avZicBpOpPJCsjxJx90ejK7F/PawuvIIetP/U++
         Hg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Pwipz8spD7rBJXW+QWOVX+uMB6eI49pQB20ICUAJFI=;
        b=HIKAqM5PPvDtSrAD6mkbFQ/dlxkOtBP+zxKtsE9f8CV1GixwFMh6nSQu9IppKO0LCM
         RL06Wgxo9gLYFlmnwOipFk1YbE5zHZF3TmVfm8nGXumTFbZUbGPN+Ac3zYHBneBw3OqR
         WDWD+qNyDAiLughQwkkeHu7ZpBf9Bj6Cz0KSG+zCB5vxic5gfJpdInRPI3eF419lqvii
         aNOZWXOj8qB8OlmrcbDQ2y2IrKZbT+RPTVsfP2e/0/9edm4AHj7Q6W1kpGrqGsTYkSVn
         x5CXd9FPjKOusflizRnp/ZqZ1vfVjbcnvwJ8Z0Vrk6bLH0I7IkWYWrrIYg+h0ETV0Kig
         aUtg==
X-Gm-Message-State: AOAM532SEl/IexCAmY1K5cdi9lyim+8zSuyVdcjkYkBCeaSjXTHneHRn
        Q1s+1W3eTdG031ylsyvpgvWResxej4yM46Z3gjhhbg==
X-Google-Smtp-Source: ABdhPJyqrocdj2+YG56jCmWvy2K4DKbNprhHZm7QCAZwZwiCM4bHY1MWjMKW1UsxqM11k4mXxpPC90krgrcYjfpuQBU=
X-Received: by 2002:a25:4fc3:: with SMTP id d186mr31982923ybb.343.1612896590054;
 Tue, 09 Feb 2021 10:49:50 -0800 (PST)
MIME-Version: 1.0
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
 <87czx978x8.fsf@nvidia.com> <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 9 Feb 2021 10:49:23 -0800
Message-ID: <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote:
> > Jian Yang <jianyang.kernel@gmail.com> writes:
> >
> > > From: Jian Yang <jianyang@google.com>
> > >
> > > Traditionally loopback devices come up with initial state as DOWN for
> > > any new network-namespace. This would mean that anyone needing this
> > > device would have to bring this UP by issuing something like 'ip link
> > > set lo up'. This can be avoided if the initial state is set as UP.
> >
> > This will break user scripts, and it fact breaks kernel's very own
> > selftest. We currently have this internally:
> >
> >     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> >     index 4c7d33618437..bf8ed24ab3ba 100755
> >     --- a/tools/testing/selftests/net/fib_nexthops.sh
> >     +++ b/tools/testing/selftests/net/fib_nexthops.sh
> >     @@ -121,8 +121,6 @@ create_ns()
> >       set -e
> >       ip netns add ${n}
> >       ip netns set ${n} $((nsid++))
> >     - ip -netns ${n} addr add 127.0.0.1/8 dev lo
> >     - ip -netns ${n} link set lo up
> >
> >       ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=1
> >       ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neigh=1
> >
> > This now fails because the ip commands are run within a "set -e" block,
> > and kernel rejects addition of a duplicate address.
>
> Thanks for the report, could you send a revert with this explanation?
Rather than revert, shouldn't we just fix the self-test in that regard?
