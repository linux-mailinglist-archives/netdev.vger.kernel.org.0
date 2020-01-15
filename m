Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D250213CA3E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAOREV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:04:21 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39741 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbgAOREU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:04:20 -0500
Received: by mail-qk1-f195.google.com with SMTP id c16so16309316qko.6;
        Wed, 15 Jan 2020 09:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsbLbABTXD4Qu8uF7aDisjexRCEsD7P+Awjc7QJgJUw=;
        b=Eo4HtcVscULVTpaG/1LjQidAei7dqGDxHcUhwgZVaBaEBtb7iJqyT3e9M4hVy+mHF0
         YVWlpSN4jtZQ0UiPh/sZ14/KoxRmOEZzhlZbxoxCQIe7AKf5raKJ2Tr8TFVrmYy+4eKs
         09RMWMc0q+QTorhgMMEl3lr5FhvrtT/tY/4lG55ZIcYyMcL/k5iZ4WUUDJ3QpYyOHRbB
         F4Y6NeNP6JzGFspCNTEb/bDd3447FKh42vIrGDXQGVYD0Qbc1EsZ3bDQ+julBXQEYeSZ
         VY6hlzoyLkFKrT2dW6jJfoq1BvEiQtFFcBslQ+o+e/VX/DRnWO2k2yDcC3NMfIe53qaZ
         q4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsbLbABTXD4Qu8uF7aDisjexRCEsD7P+Awjc7QJgJUw=;
        b=ETjsFRguGsM4+IOnE3BEfeB9qEbDBpH0wxQIHKdgbeCETFaWmzbAcY8AanyeS3kkLE
         lU5wlw4byfm1ANRjEmbOrotstAI4FxbPuZHrnVaSW9O35O9b31vPZkRr9FmFKjcud59Z
         rh2CptepeloRio8nMOPUk+oyQhkD7r9tKlq+d6JYM09WGDKAXTJRq2JgI+tPfASJu2M8
         zX5y4vAJAF7Ihn3WuKkizna5boGZI8LLTLqJMOr3qc5Y74XwiOQKEg8p3dDl+sfI4HrW
         gmmFp+DqVPQ7tFg1lsrZQL8XMD5qRnMz5xrAkH2qMGlLyMHHk+5sU3tgsLWo05544TU1
         bEXw==
X-Gm-Message-State: APjAAAVzEJ8SSr+ShOmA7fdUNp8o6rdw1lf+PmEaj7+MwBcU26kOhqGh
        mSZY56I3E+xNQ70W2mIzpf031sD+OOuOz6Z83qI=
X-Google-Smtp-Source: APXvYqzptmX1rBDUY9rB4KsDHZntegLIwW/mLcolZ/1Oh/d7XIJPguREmTWwL1SoylwLuCJs/VkbVm/XXDKyILZVS+4=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr24318793qkq.437.1579107859535;
 Wed, 15 Jan 2020 09:04:19 -0800 (PST)
MIME-Version: 1.0
References: <157909410480.47481.11202505690938004673.stgit@xdp-tutorial>
In-Reply-To: <157909410480.47481.11202505690938004673.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 09:04:08 -0800
Message-ID: <CAEf4BzZmF6TUtGkmcWAP8T5+JH=CEqAvu-q=LntsoYbuZbePgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, maciej.fijalkowski@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 5:15 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Add a test that will attach a FENTRY and FEXIT program to the XDP test
> program. It will also verify data from the XDP context on FENTRY and
> verifies the return code on exit.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Looks good, thanks! You are just missing one CHECK() for
bpf_map_update_elem below, please add it. With that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> v2 -> v3:
>   - Incorporated review comments from Andrii and Maciej
>
> v1 -> v2:
>   - Changed code to use the BPF skeleton
>   - Replace static volatile with global variable in eBPF code
>
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   65 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 ++++++++++++++
>  2 files changed, 109 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> new file mode 100644
> index 000000000000..6b56bdc73ebc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <net/if.h>
> +#include "test_xdp.skel.h"
> +#include "test_xdp_bpf2bpf.skel.h"
> +
> +void test_xdp_bpf2bpf(void)
> +{
> +       __u32 duration = 0, retval, size;
> +       char buf[128];
> +       int err, pkt_fd, map_fd;
> +       struct iphdr *iph = (void *)buf + sizeof(struct ethhdr);
> +       struct iptnl_info value4 = {.family = AF_INET};
> +       struct test_xdp *pkt_skel = NULL;
> +       struct test_xdp_bpf2bpf *ftrace_skel = NULL;
> +       struct vip key4 = {.protocol = 6, .family = AF_INET};
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
> +
> +       /* Load XDP program to introspect */
> +       pkt_skel = test_xdp__open_and_load();
> +       if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton failed\n"))
> +               return;
> +
> +       pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_tx_iptunnel);
> +
> +       map_fd = bpf_map__fd(pkt_skel->maps.vip2tnl);
> +       bpf_map_update_elem(map_fd, &key4, &value4, 0);

CHECK()? Sorry, didn't spot first time.


> +
> +       /* Load trace program */
> +       opts.attach_prog_fd = pkt_fd,
> +       ftrace_skel = test_xdp_bpf2bpf__open_opts(&opts);
> +       if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
> +               goto out;
> +

[...]
