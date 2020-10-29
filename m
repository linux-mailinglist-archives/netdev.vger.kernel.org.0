Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AD929F911
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ2X1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2X1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:27:17 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C9EC0613D2;
        Thu, 29 Oct 2020 16:27:15 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a4so3581506ybq.13;
        Thu, 29 Oct 2020 16:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfhUb6juWx0qOFMhcmc849Id4BoUV7O1zRgvTwJqMO0=;
        b=Wj6KM8/Pn26bl/HIB2I/E2e1DDHlPoRZ1fyPw27dsUbwbtnWSrm0VYF/9Aaxmw7OnA
         ib0BAuQns7KMqCur+mbrW6tj+lsZQII/d9uoauXL9eAOfNllFgT7OpHRrC9mnfz+iPWm
         IB5PRcSG1VigRl6Q3hjpK31StZtJIXEZH3SJhIfWZWQj3vRh3tAJ2CLZI+GCZ+0jtTun
         wB/8vjk4Ww3CXQdm5/5tXNo3dA23cA2AB65BeRhXqyOt76gdPxVkR/LZw8xqwiMzrX0M
         nyHpDzHFgbyKtgUW/ODroNHFMDYyaCzzw3OMwqVSCdDe0tTv4U0AUQ7Cy+t4cQdAJIMl
         0SnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfhUb6juWx0qOFMhcmc849Id4BoUV7O1zRgvTwJqMO0=;
        b=P15iPQ0rMeMf2M+JbL+P9QIbWcj7h5xJAJtwfSi9YlzSg7U5Uu/WcQtPCroQEwRiqK
         aAoygtXp3VExfWBDqqBfvxxHFzE4K2y/Mf1zYRdJkLRqXBpELi2aXwU3CT58yqz9bz8c
         UfCR7HjzvQWRlMpzrCwgsHbo3aGvG8i+yMhcLCcU5aUdCoEMZqF7oKBzpReDnO4lVqKY
         ANsCzOO4tA9bAWvHxkgbHUA0J2uic6OpQNnY1nN1QzeFEZ4pdQfv3a0EXtJ5v8va25+6
         8QgX6vYazuG6KZYGxV4DUeaMqSXJWeYl07CetYkUWSzxkl2+iEfpto58S0pCtlhJFfU3
         qXZg==
X-Gm-Message-State: AOAM531NxjwyvF8OOJlh5d8thEVYm/MV9boo+NtNOzDrpRPvZPoo8tq0
        jwZ/8hLfum5JMYVR7n+kIuZ5rL/CNBi9ElHMUqE=
X-Google-Smtp-Source: ABdhPJyJ59AItadnJmSEJ284yQXT3hSaQWvUvZxre6aEA8LEPTrRiI1Ca5GvyRLF7JG8VUTUvGV1RX6QpUlk0CxfbWo=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr9737762ybe.403.1604014034793;
 Thu, 29 Oct 2020 16:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384962569.698509.4528110378641773523.stgit@localhost.localdomain>
In-Reply-To: <160384962569.698509.4528110378641773523.stgit@localhost.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 16:27:04 -0700
Message-ID: <CAEf4BzZxevcUHurBQ49006g87CzztDdWn6pWZRWzpL+_97R4qg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/4] selftests/bpf: Move test_tcppbf_user into test_progs
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 4:50 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> Recently a bug was missed due to the fact that test_tcpbpf_user is not a
> part of test_progs. In order to prevent similar issues in the future move
> the test functionality into test_progs. By doing this we can make certain
> that it is a part of standard testing and will not be overlooked.
>
> As a part of moving the functionality into test_progs it is necessary to
> integrate with the test_progs framework and to drop any redundant code.
> This patch:
> 1. Cleans up the include headers
> 2. Dropped a duplicate definition of bpf_find_map
> 3. Replaced printf calls with fprintf to stderr
> 4. Renamed main to test_tcpbpf_user
> 5. Dropped return value in favor of CHECK calls to check for errors
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile               |    3
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  138 +++++++++++++++++
>  tools/testing/selftests/bpf/test_tcpbpf_user.c     |  165 --------------------

Please remove the binary from .gitignore as well

>  3 files changed, 139 insertions(+), 167 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
>  delete mode 100644 tools/testing/selftests/bpf/test_tcpbpf_user.c

if this file is mostly the same, then Git should be able to detect
that this is a file rename. That will be captured in a diff explicitly
and will minimize this patch significantly. Please double-check why
this was not detected properly.

[...]
