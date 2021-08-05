Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D423E1EFE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbhHEWoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhHEWoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:44:00 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4814C0613D5;
        Thu,  5 Aug 2021 15:43:44 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z5so9957728ybj.2;
        Thu, 05 Aug 2021 15:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=scjRLh8ZcXfO6SUHVoj14tEPc7VJ/CQloEmyH1MTO9E=;
        b=eal2D2FgZj49uAlBa3sbD10mG8zgKmCvf/LKCOpXtPUafUU8FXfb0y4f+UFhjDBmD3
         +eHJQxUPmsKRhcPLIccsj9VlpzNbpugA8gETONAJD9rSn5+BFtWyOL/eBU4RiC/r1KYJ
         QwNsn8VtnLMWL3QWB3L0/D/T4ncIwcAEIneSMcVcWlBxJWTYhHzmx/u06pDmf5rlU459
         Bw1aGxVXXrqSaNrOxEIvw7YqAlYOS5objwmG6rfluhRxOPiTIe8oky7h3LlLSwtJvFPQ
         aY2mZ8JGdG9UVR3iouO5m8VtJy8/xiLjK+4Br/ltdhxpkvorwt7+dstgvK6i5YCCSE6A
         VCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=scjRLh8ZcXfO6SUHVoj14tEPc7VJ/CQloEmyH1MTO9E=;
        b=Wp/ZaUw7no4gWqzpqw3iczM+cPdIh1HSrxAD2E9CzEXPGAsL+HvgsmXPWxcMGP8921
         6gGqISnK9VM0T6/SqH01Q7TAQyz6CWO/iwzGYQ3X0RJakHXdz4rLj08lMmS5E5RaIw6p
         Rf78g0UyGjge/KnGZhFiPofp/PcoScPlg300KChMVU4/99iFjanZ6/16ycrATEpvrftT
         C+p/wPXt4VKr1tBI/27PTmj0S0UrdZ3Pi54NXN31mWGqug3mExanGm7fb3VWBCArMhab
         DObMXDbvvkW1aXuXe+SGDaCK2TuxflEvVbwzkHrk4+2FjboraUnAgqoWQgI5J4JS0CH6
         Y3KA==
X-Gm-Message-State: AOAM533xyjBfeqdaTrX8lZs1ySf+OCala5UIlPqltJDNRjEL05GL7oNM
        16ljuTu3ORnvHNtVA1DIQuv/o2LVfdHcnCa7MrE=
X-Google-Smtp-Source: ABdhPJyl7Rq/gI+55e5fIAcZC4uTAcfUajdYmypUitxWoMMG2n4brfg+JhgZq21mTwre1vA8xXAtlH9IiZi+bFVLpFA=
X-Received: by 2002:a25:d691:: with SMTP id n139mr9306982ybg.27.1628203423989;
 Thu, 05 Aug 2021 15:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com> <20210704190252.11866-12-xiyou.wangcong@gmail.com>
In-Reply-To: <20210704190252.11866-12-xiyou.wangcong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Aug 2021 15:43:33 -0700
Message-ID: <CAEf4BzaccTCGeONN4MB5iRBZfmzfS3rR0R6XEPVmUKukrLSJ3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 11/11] selftests/bpf: add test cases for
 redirection between udp and unix
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 4, 2021 at 12:05 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Add two test cases to ensure redirection between udp and unix
> work bidirectionally.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 170 ++++++++++++++++++
>  1 file changed, 170 insertions(+)
>

[...]

> +       n = write(c1, "a", 1);
> +       if (n < 0)
> +               FAIL_ERRNO("%s: write", log_prefix);
> +       if (n == 0)
> +               FAIL("%s: incomplete write", log_prefix);
> +       if (n < 1)
> +               goto close;
> +
> +       key = SK_PASS;
> +       err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
> +       if (err)
> +               goto close;
> +       if (pass != 1)
> +               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> +
> +       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> +       if (n < 0)
> +               FAIL_ERRNO("%s: read", log_prefix);

Hey Cong,

This test is pretty flaky and quite frequently fails in our CIs (e.g., [0]):

./test_progs-no_alu32:unix_udp_redir_to_connected:1949: egress: read:
Resource temporarily unavailable
  unix_udp_redir_to_connected:FAIL:1949

Please send a fix to make it more reliable. Thanks!


  [0] https://github.com/anakryiko/libbpf/runs/3249152533?check_suite_focus=true


> +       if (n == 0)
> +               FAIL("%s: incomplete read", log_prefix);
> +
> +close:
> +       xclose(c1);
> +       xclose(p1);
> +close_cli0:
> +       xclose(c0);
> +       xclose(p0);
> +
> +}
> +

[...]
