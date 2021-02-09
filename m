Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40663315780
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhBIUKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhBITq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:46:58 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F0AC06121F
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:20:09 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p193so5556168yba.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9OAY/kfCyItwqgHsQk4/qreHOsUO53N3pvV9roG+OlE=;
        b=vfMxdIU+EmN+Shl5VmXRftlkPSLfkmCamQVkkv78/HCnA2H2sklchmd3ZWZASGDVEp
         R5aYrhwpSUvtdRVPJcJqG5jsNyhrD87kcu4jtbq/dfqitzjZSYj678KRTgzf55zqShBi
         AMYNv9Wk0bPti4HMkHDy2o1Gt+ge/KMFUZT/g41UpR8teppeQ5M9BVyoPt7ElOtDBjK1
         7UAPwOeJAUXlgPwM+sNJDeRhHq3vNoFY3DVGD5hLKwEgKhRrlDKxQ3FAGnYOodu+/dbZ
         Q2pTDtMthEV4opj5FhjuVh2nqYxLvtthIpfS5MfaqXzM98nv/t5Mx92b2wYQk/wcvoTI
         SHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9OAY/kfCyItwqgHsQk4/qreHOsUO53N3pvV9roG+OlE=;
        b=JIZGyrSmzAV8Q0WqIrgM1v9ahkdyqbMaYGYmnjX6I2IsRERtaEGb5nLbJSjr9M2Yfo
         uJy+8tCYwo3kdlXD9kz2kVVI26wFyqgNHTM0mPIATU2rIIs/yWC9Gu6WpdxepH4U1jIr
         pJB3t0N9YaEK54sgEWKK3ww65ps6z3zrlmU8tc2OyroRSJf3smayLVqwR2Hqvz/Mmrsf
         jQ+kyoguPT6CafYRINjWaXm5q2NVZatGkWLkD8Cjfbrt7niZZNMxNqvIm5uzKBwBWS8V
         nfAaRAyjPYToOls6C2yPMwPaxiplxi/r2PW2KUUKLBTNCGrnG7lE/SRveMxp2dXp/EbA
         +kgA==
X-Gm-Message-State: AOAM530pgG2JSlKDUZ+H2lnHRxJ6qiNKn2XfTq3cyTMNJlhfzqxB1DEw
        AdyOR1p60kWkBmrpUiZdJM1hY7YreapRLZJhIHoG+RbR7Xefkw==
X-Google-Smtp-Source: ABdhPJwPOS/t3IkXJxFJiFnMWlioQAGNQpb/RsIudC8YXnl7iy0yHg7WUznjUDZBSjoPGt+OiIl56HuY4IemTZW3ntI=
X-Received: by 2002:a25:aa43:: with SMTP id s61mr9339212ybi.32.1612898408958;
 Tue, 09 Feb 2021 11:20:08 -0800 (PST)
MIME-Version: 1.0
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
 <87czx978x8.fsf@nvidia.com> <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com> <20210209190627.GA267182@shredder.lan>
In-Reply-To: <20210209190627.GA267182@shredder.lan>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 9 Feb 2021 11:19:43 -0800
Message-ID: <CAF2d9jhbe6snruTPKO0LHYqiY+Fny=nse-MusNTm5H58O0jFDg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:06 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Tue, Feb 09, 2021 at 10:49:23AM -0800, Mahesh Bandewar (=E0=A4=AE=E0=
=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=
=A4=BE=E0=A4=B0) wrote:
> > On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote:
> > > > Jian Yang <jianyang.kernel@gmail.com> writes:
> > > >
> > > > > From: Jian Yang <jianyang@google.com>
> > > > >
> > > > > Traditionally loopback devices come up with initial state as DOWN=
 for
> > > > > any new network-namespace. This would mean that anyone needing th=
is
> > > > > device would have to bring this UP by issuing something like 'ip =
link
> > > > > set lo up'. This can be avoided if the initial state is set as UP=
.
> > > >
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
> I reviewed such a patch internally and asked Petr to report it as a
> regression instead. At the time the new behavior was added under a
> sysctl, but nobody had examples for behavior that will break, so the
> sysctl was removed. Now we have such an example, so the revert / sysctl
> are needed.

OK, in that case I would prefer to send an incremental patch to
enclose the new behavior with the sysctl (proposed earlier) rather
than the revert. Would that help?
