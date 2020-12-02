Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D982CB18C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgLBA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgLBA1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:27:36 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A999C0613CF;
        Tue,  1 Dec 2020 16:26:56 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id o71so38538ybc.2;
        Tue, 01 Dec 2020 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vfCF2rrgBv4Qtm98WE1uwXxGb7ee+2ZYnfEmg2VySPE=;
        b=Lx0ntsOgTlCheqLAQiMrZXM0n1USD7f5oQf/FsL3s87zOyYRGgvULQOIU8Nr+b032u
         joW3d9jxBpb1YzfF3mTvKJKFK4/29DIJoP1IJgGRMrMxiivqFEnaQ1p4fee/tjijFbW6
         bW4MWlx6kCAKvls4J1tF4BFRn+XxNl6DEzHKKng0OZaaH95VbV+PJiHxFNY+TrZkbj6q
         9vNmwsfvgiw284pEGNAcBGjdPuAL1Y1LMQKmJwppm7CuhoYN+zwyvo0778koDxyFx6vN
         2PecywuGaQYjNNjtK4+9nGA1NljxWLwsqeYuGnVINVO8Ewlc+comMPGI+Dv0MEx61N6m
         n+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vfCF2rrgBv4Qtm98WE1uwXxGb7ee+2ZYnfEmg2VySPE=;
        b=pha+CbRPgAFeKYLZ3oqPdA43EfRzSY9ZIIlweginton02lsppkCkDvHMVuZy3kD+ba
         A/XsNeeXC7vwXtILtJGJnXeN5eTUH1cBjcDrSHxDgWBYCbJEHz6pZYu8zeRWm3E4p8B6
         WrKa2ZVG/0Y3AoBNpLHZ/sxyyshu0GIoqikoOGPuvBYDhC4eMmmhGGQ01K+VQ/kEk5p6
         GTuS/tIY48VL8Q3ISshzoEGaz5MdeXAMmTYKHsB/NevyA2cH/b3/ANWxoSzMhFVOChIH
         HhVXuwh9ZJyVp6FrnrxiryqD0tHZAGehjVCYjf5bNg5z9+uouRPu/6S78dT7PTK+qzXT
         mTcQ==
X-Gm-Message-State: AOAM531Mk3xrWzF9D37KJvWFEtxXM6xraB8WyJCv+NMXmhG8b4Lvs+vc
        tEJrOAeRJvMrCf74jgK01T8g+JmNTToUdA6oBJ4=
X-Google-Smtp-Source: ABdhPJxog44/VOr67JY6HNC903NDUE8Kw2I1Wc4DYYxrc0gUlLwGgmecdPKIsoWt3kCMVpHarTWIDGsGmfHKigeMzyg=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr6691097ybd.27.1606868815940;
 Tue, 01 Dec 2020 16:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-2-sdf@google.com>
In-Reply-To: <20201118001742.85005-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 16:26:45 -0800
Message-ID: <CAEf4BzaQGJCAdbh3CYPK=z1XPBpqbWkXJLgHaEJc+O7R5dt9vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: rewrite test_sock_addr bind
 bpf into C
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 4:20 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> I'm planning to extend it in the next patches. It's much easier to
> work with C than BPF assembly.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

With nits below:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  .../testing/selftests/bpf/progs/bind4_prog.c  |  73 +++++++
>  .../testing/selftests/bpf/progs/bind6_prog.c  |  90 ++++++++
>  tools/testing/selftests/bpf/test_sock_addr.c  | 196 ++----------------
>  3 files changed, 175 insertions(+), 184 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
> new file mode 100644
> index 000000000000..ff3def2ee6f9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <string.h>
> +
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <sys/socket.h>
> +#include <netinet/tcp.h>
> +#include <linux/if.h>
> +#include <errno.h>
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +#define SERV4_IP               0xc0a801feU /* 192.168.1.254 */
> +#define SERV4_PORT             4040
> +#define SERV4_REWRITE_IP       0x7f000001U /* 127.0.0.1 */
> +#define SERV4_REWRITE_PORT     4444
> +
> +int _version SEC("version") = 1;

not needed, let's not add it to a new test prog

> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
> new file mode 100644
> index 000000000000..97686baaae65
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <string.h>
> +
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <sys/socket.h>
> +#include <netinet/tcp.h>
> +#include <linux/if.h>
> +#include <errno.h>
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +#define SERV6_IP_0             0xfaceb00c /* face:b00c:1234:5678::abcd */
> +#define SERV6_IP_1             0x12345678
> +#define SERV6_IP_2             0x00000000
> +#define SERV6_IP_3             0x0000abcd
> +#define SERV6_PORT             6060
> +#define SERV6_REWRITE_IP_0     0x00000000
> +#define SERV6_REWRITE_IP_1     0x00000000
> +#define SERV6_REWRITE_IP_2     0x00000000
> +#define SERV6_REWRITE_IP_3     0x00000001
> +#define SERV6_REWRITE_PORT     6666
> +
> +int _version SEC("version") = 1;

same

> +
> +SEC("cgroup/bind6")
> +int bind_v6_prog(struct bpf_sock_addr *ctx)
> +{

[...]
