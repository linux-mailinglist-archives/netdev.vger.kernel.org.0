Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118332FF923
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbhAUXyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbhAUXya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:54:30 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FA7C061786;
        Thu, 21 Jan 2021 15:53:49 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y128so3766633ybf.10;
        Thu, 21 Jan 2021 15:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YBbeAQjArD6ZjokVU+UNvTOWw/xXKfc1Rf/reqB0iBY=;
        b=ii0GsPTx0vYXNrICowMiiIHXJJcgviYatgVlGT1XAF6bZJQytTPv0mtXSd48t01PB/
         /fkxLeUdfHzGxp++5MmI1XPr1QtZ4O/Z4yN05CtuJfxEWILvW/PJkjAjcXEGsLFWGghJ
         JC9pQoD0eYbhllKM8p0oY86twjPLw5bPLeEryaB0Myxt6S8qHj8qOB/dKTpT2bROW1Qb
         /49Fvh/IYbi7eAgAka+HYqyoLm6xiwTGIkuXcxZQwuSqCqKLGZ7a8cKibT1vCkF5tEAa
         lMvSMEuyURCz2bM+EJjQ040fjEOgMUzcQvmArx0EjSavCXVmAIjJLGBMq8ld5V+pnUjj
         cZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YBbeAQjArD6ZjokVU+UNvTOWw/xXKfc1Rf/reqB0iBY=;
        b=JGA55Y84dPFLIXAF74c6FwXQz0URxRbhi9mC4yVhQKICyx5wyZ5sQj23od/2xeaAjY
         lRFHwC1emaAwZ7+cgdwsjMPe/rGsbqwMFfPo39BJZt1fopULzQ410ZPNL2S0Z1BFk24A
         /kUK3eddVUy++Zhmp5bk/EU6GmahzkbZqP0s7EeMDlioLFfGu//9VdcxhA1u6fo9IyaX
         mREdh2Q+pn5NA4lzgNa5aCdW1C3+FGQIZCUm4utEQqOYmjcfNBkSOleXxsYTnhQ0ma4o
         HUnsguF2w8a1wu3rrvJ9b54mMW4xuSEbgWrF6zS1Ae1NYuf2sOD4YgLve0x9cZL1nrjT
         MvJg==
X-Gm-Message-State: AOAM531XYSFMniF7K4RDru5nf9tKY81Dv15iqfdQSji5C5/7yb/gML0O
        BXvtbiuj8TJVrfA7pa2oSx5PuH8uO2YDCY+Ktg0=
X-Google-Smtp-Source: ABdhPJzfe3EgAWfCkyu57pCAq8KdHYx4raou/ej38NeFF1zuwd5bnnlOsBv/1itxlr5pBYBmOIzajloaRZq9eNdhp20=
X-Received: by 2002:a25:48c7:: with SMTP id v190mr2630207yba.260.1611273228443;
 Thu, 21 Jan 2021 15:53:48 -0800 (PST)
MIME-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com> <20210121012241.2109147-2-sdf@google.com>
In-Reply-To: <20210121012241.2109147-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Jan 2021 15:53:37 -0800
Message-ID: <CAEf4BzaOjBN=C=zjmhP-nLJbtm-FKBdpQbJmxtavn6r9VC3eiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to port
 < 1024 from BPF works
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 7:16 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> BPF rewrites from 111 to 111, but it still should mark the port as
> "changed".
> We also verify that if port isn't touched by BPF, it's still prohibited.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
>  2 files changed, 124 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> new file mode 100644
> index 000000000000..840a04ac9042
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "bind_perm.skel.h"
> +
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <sys/capability.h>
> +
> +static int duration;
> +
> +void try_bind(int port, int expected_errno)
> +{
> +       struct sockaddr_in sin = {};
> +       int fd = -1;
> +
> +       fd = socket(AF_INET, SOCK_STREAM, 0);
> +       if (CHECK(fd < 0, "fd", "errno %d", errno))
> +               goto close_socket;
> +
> +       sin.sin_family = AF_INET;
> +       sin.sin_port = htons(port);
> +
> +       errno = 0;
> +       bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> +       CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> +             errno, expected_errno);

ASSERT_NEQ() is nicer

> +
> +close_socket:
> +       if (fd >= 0)
> +               close(fd);
> +}
> +
> +void cap_net_bind_service(cap_flag_value_t flag)
> +{
> +       const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> +       cap_t caps;
> +
> +       caps = cap_get_proc();
> +       if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> +               goto free_caps;
> +
> +       if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> +                              CAP_CLEAR),
> +                 "cap_set_flag", "errno %d", errno))
> +               goto free_caps;
> +
> +       if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> +                              CAP_CLEAR),
> +                 "cap_set_flag", "errno %d", errno))
> +               goto free_caps;
> +
> +       if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> +               goto free_caps;
> +
> +free_caps:
> +       if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> +               goto free_caps;
> +}
> +
> +void test_bind_perm(void)
> +{
> +       struct bind_perm *skel;
> +       int cgroup_fd;
> +
> +       cgroup_fd = test__join_cgroup("/bind_perm");
> +       if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> +               return;
> +
> +       skel = bind_perm__open_and_load();
> +       if (CHECK(!skel, "skel-load", "errno %d", errno))
> +               goto close_cgroup_fd;

errno is irrelevant; also use ASSERT_PTR_OK() instead

> +
> +       skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> +       if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> +                 "cg-attach", "bind4 %ld",
> +                 PTR_ERR(skel->links.bind_v4_prog)))

try using ASSERT_PTR_OK instead

> +               goto close_skeleton;
> +
> +       cap_net_bind_service(CAP_CLEAR);
> +       try_bind(110, EACCES);
> +       try_bind(111, 0);
> +       cap_net_bind_service(CAP_SET);
> +
> +close_skeleton:
> +       bind_perm__destroy(skel);
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +}

[...]
