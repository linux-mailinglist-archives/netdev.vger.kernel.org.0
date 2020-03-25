Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5605F191E50
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCYBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:00:14 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34791 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgCYBAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 21:00:13 -0400
Received: by mail-qv1-f67.google.com with SMTP id o18so199504qvf.1;
        Tue, 24 Mar 2020 18:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jUB+tM0BFQZQdvpsyfwXsGAJ6YkiGjbSHP9EKj3nthY=;
        b=neDqIkxzrSmoJ/poPG3UWh3/Cn5KAuOiNLTdQb5Yw3DnffQ0tCDpq2qJf3m9TdPtaQ
         GloUCQqMTfKN8hn9veU4gdkU6Wo3uxZ5DbYY14x/Gvet4ksmzgqCaz+JMI3vBU8yG1yx
         PffIubn3JFcUNqyrvETDcmIsrBwC9evV43n1ff9uFwkkFRQZugPy5Z1Il7fE7+apUBcP
         y0H492laHbHHk9sucQqEI3HjxEkk1us4auxziF+3P0CW1B7X9QwsQYC8/WeXfomx5lSk
         5jUQh5Z2KTUCmFPBBKD0WoejbPu9ktUbgiL2Fee9XcJsBAXarMkkzDBpbdHXo8shiHno
         z7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jUB+tM0BFQZQdvpsyfwXsGAJ6YkiGjbSHP9EKj3nthY=;
        b=MfiRgP+OkqPUja9RQE0YYn8rGvexnERPguqsLfcg92jOhYzireitk7x7Ot+eyo/tUe
         9u18p+dlOOnDQKOBRhe9KREsGpsDETMKx5hEPu6wwDKy3yY6MYtoe1nwt9o7z8JPnyZH
         E4m5dWF9CVnzsj5za8ZINwp+CBBJ2dOIeVF8ne/+ZZ8q/Kcw/RZa6uc9u82UlzmTyD5K
         1PoMUZ0GrtefTRBGT/lYUAyTOuzLgXjj3JuYgOub0e4OC8SJhC+rbd62C1XIw0rF5jkx
         C7uOLIDb3qcAzmeicOaJJuFjd94KS0J3SmJ+rymqRNkchbiFS/CvIL9vUxeDUBca+EA9
         Z5NA==
X-Gm-Message-State: ANhLgQ2sgf3Qi9fkEyANLNbtbmpqdGYteFlLrjyNi2R4Z/huHplEPwXV
        oW4slps8qxxHRPAl6BnV6WA9WiAkMPu/UqZrjHwDfp4v
X-Google-Smtp-Source: ADFU+vvGW+v0pw42jPWnw2VMbH/UkWRIV/8in3Xz4c6T3eg19TNfaNnzq0CXKziyCLhTefcmKp30m+0feS6JJkgS9xc=
X-Received: by 2002:a0c:8444:: with SMTP id l62mr889092qva.239.1585097658979;
 Tue, 24 Mar 2020 17:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <158507357205.6925.17804771242752938867.stgit@toke.dk> <158507357313.6925.9859587430926258691.stgit@toke.dk>
In-Reply-To: <158507357313.6925.9859587430926258691.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 17:54:07 -0700
Message-ID: <CAEf4BzaXvTx5-bp8QygxScwEKjq8LYZqU4dgxo2C9USqHpGxKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> While it is currently possible for userspace to specify that an existing
> XDP program should not be replaced when attaching to an interface, there =
is
> no mechanism to safely replace a specific XDP program with another.
>
> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which can =
be
> set along with IFLA_XDP_FD. If set, the kernel will check that the progra=
m
> currently loaded on the interface matches the expected one, and fail the
> operation if it does not. This corresponds to a 'cmpxchg' memory operatio=
n.
> Setting the new attribute with a negative value means that no program is
> expected to be attached, which corresponds to setting the UPDATE_IF_NOEXI=
ST
> flag.
>
> A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
> request checking of the EXPECTED_ID attribute. This is needed for userspa=
ce
> to discover whether the kernel supports the new attribute.

Doesn't it feel inconsistent in UAPI that FD is used to specify XDP
program to be attached, but ID is used to specify expected XDP
program? Especially that the same cgroup use case is using
(consistently) prog FDs. Or is it another case where XDP needs its own
special way?

>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/netdevice.h    |    2 +-
>  include/uapi/linux/if_link.h |    4 +++-
>  net/core/dev.c               |   14 +++++++++-----
>  net/core/rtnetlink.c         |   13 +++++++++++++
>  4 files changed, 26 insertions(+), 7 deletions(-)
>

[...]
