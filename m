Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DC02B747F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgKRDCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKRDCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:02:53 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429FAC0613D4;
        Tue, 17 Nov 2020 19:02:52 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id x17so282374ybr.8;
        Tue, 17 Nov 2020 19:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uwJLq/RnNkpRMWjppuRw7i/Xapt5zew99odvdbwkOeQ=;
        b=YOFaCaIAFo+VcZKIb/IelePNRIKiBwQ4NQY3y2b3w6AjUFxttX8YmoYZeEHUdAoayx
         KCxvCUSyy6cUOV7xjQi6nK87m4/DihhZtGQ0vbARcP3YJIFdiFaeuBER3M+b6c54Yvdf
         Rrx3oLz1zr3hiII4NtcLDUKHKz3babQSxy4HZIZvhdg27gtbtpcFyYVZXaMBuaYdjyTb
         nNZ+CAohzMhjpifLqqK4hDnzRUx/ognpOwCzgLS8jsyBMI3kn6XGoiv29LzOWxwz05f5
         9mnSFLhxz9+x+EcL5W3wt8DXUbQifrz3mTC82p5VWtQu7rZIaPiPjJozHSh3s90OyMen
         WF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwJLq/RnNkpRMWjppuRw7i/Xapt5zew99odvdbwkOeQ=;
        b=bosnMu7aR7X6sQ+6ktFjNca7ndb35mEoV+BBykvkCa9+LT+P5wBjYMlTDWXueTEqte
         429mov8LWfZCfCJ4vJ5Zm3DMlr6jZhEKYEPHuTGNCrwv5g3zqxcSpAIpv1MUIyAcdBuv
         qqpdY1oeYYoi6P50p5MKFF+IsPp78lL5E7A26oj4rbZpqlV8de9bHyiH5fCRFKX9NI5z
         pecuwogrZw2VSbIW6WcPTu5VwWv3helzLPKxUU3Vo8sTCAlMPbnO1PwUK9z9c3voQjzc
         DUBpzScQzBZ7uEphdLbjRaboTJ9niEzaWBCO7aEJqqh8xmMO+1wQK6YsMkedgHfKWv7l
         sMwA==
X-Gm-Message-State: AOAM531Ruq3JPpKWlHBPHENnDC5rFnC9d8ZpO9nYMtvER3sF5yDI0eRU
        H1ZWn4CkUeQvWiM7rD1bpUw2XN4xwGPKzu+nvVY=
X-Google-Smtp-Source: ABdhPJwOxTqD6/PPVNKKwXxqcQuryaC1n1V2lLwBpr8cKx89XoIofkgOo+NhfXCb4aFnf1OpxhbtNE0XddvwgjOEkXU=
X-Received: by 2002:a25:7717:: with SMTP id s23mr4663296ybc.459.1605668571590;
 Tue, 17 Nov 2020 19:02:51 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-4-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-4-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 19:02:40 -0800
Message-ID: <CAEf4BzbBT38n8YQNco7yfijahaKXWQWLqxiNGEq1q7Lj7N+_vA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] samples: bpf: refactor test_cgrp2_sock2
 program with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit refactors the existing cgroup program with libbpf bpf
> loader. The original test_cgrp2_sock2 has keeped the bpf program
> attached to the cgroup hierarchy even after the exit of user program.
> To implement the same functionality with libbpf, this commit uses the
> BPF_LINK_PINNING to pin the link attachment even after it is closed.
>
> Since this uses LINK instead of ATTACH, detach of bpf program from
> cgroup with 'test_cgrp2_sock' is not used anymore.
>
> The code to mount the bpf was added to the .sh file in case the bpff
> was not mounted on /sys/fs/bpf. Additionally, to fix the problem that
> shell script cannot find the binary object from the current path,
> relative path './' has been added in front of binary.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile            |  2 +-
>  samples/bpf/test_cgrp2_sock2.c  | 63 ++++++++++++++++++++++++---------
>  samples/bpf/test_cgrp2_sock2.sh | 21 ++++++++---
>  3 files changed, 64 insertions(+), 22 deletions(-)
>

[...]

>
> -       return EXIT_SUCCESS;
> +       err = bpf_link__pin(link, link_pin_path);
> +       if (err < 0) {
> +               printf("err : %d\n", err);

more meaningful error message would be helpful

> +               goto cleanup;
> +       }
> +
> +       ret = EXIT_SUCCESS;
> +
> +cleanup:
> +       if (ret != EXIT_SUCCESS)
> +               bpf_link__destroy(link);
> +
> +       bpf_object__close(obj);
> +       return ret;
>  }

[...]

>
>  function attach_bpf {
> -       test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
> +       ./test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1

Can you please add Fixes: tag for this?

>         [ $? -ne 0 ] && exit 1
>  }
>
>  function cleanup {
> -       if [ -d /tmp/cgroupv2/foo ]; then
> -               test_cgrp2_sock -d /tmp/cgroupv2/foo
> -       fi
> +       rm -rf $LINK_PIN
>         ip link del veth0b
>         ip netns delete at_ns0
>         umount /tmp/cgroupv2
> @@ -42,6 +51,7 @@ cleanup 2>/dev/null
>  set -e
>  config_device
>  config_cgroup
> +config_bpffs
>  set +e
>
>  #
> @@ -62,6 +72,9 @@ if [ $? -eq 0 ]; then
>         exit 1
>  fi
>
> +rm -rf $LINK_PIN
> +sleep 1                 # Wait for link detach
> +
>  #
>  # Test 2 - fail ping
>  #
> --
> 2.25.1
>
