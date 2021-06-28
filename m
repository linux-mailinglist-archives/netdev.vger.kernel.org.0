Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369C13B65DB
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhF1PlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 11:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238687AbhF1Pk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 11:40:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F68C0698D2;
        Mon, 28 Jun 2021 07:51:03 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w15so11128238pgk.13;
        Mon, 28 Jun 2021 07:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sz00xB/CBnbFkaNT+eum17/r+lT+KuJJ0l4RORkmOQo=;
        b=U3EPMTILqQL2pEwv9LxpQ/fkISYR5ixQ5FIKmoxvrC66/JIg3yzRVAqwlWp2w3gGX4
         bqpTPhefj9bD7nAGaVrEdx/VV/ynl1IDfWdnF+Ubtczv5GcBorrZOxU08qs+SYlN4TTA
         lRpKuZ4CQycyOe8ElFN8DIe0YiUlPiBF8XR3VOF2f3NECrnnRt/kHQpHJaqHL6GBJWHl
         byWoFOCeRcAD7tube/9YNeWFtsWQLf/XBpbbhveRiCr0MV5dEaXFA57RXEetwey1OMvD
         MjPRXFid99SXqLwV8kvp7KVXcj5WJMvs91OU4DLH+DcxDHI0Y/QnYcGCAwEcbmtGwheD
         NjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sz00xB/CBnbFkaNT+eum17/r+lT+KuJJ0l4RORkmOQo=;
        b=UBq4Rqk3+uj1IHEWLPkGOLjMznCleNvrCsN/3vw7vch9VnfPoCI1jccLaRJJ2zrJwb
         HMnQEslq3Dmkos+nqqH18aWJDx0shCgYdPTJ4SHw1uFPHd4AqISSKoDmBbSycNJDP5Q4
         c/7pBPb+ZGmTgSJp+54NBbOocyKbERQPH1e9AheOw83+dQ+YMqwSgiIepZYMTVvSh/Zr
         i9VAPfUef3fUvI5I1TEWxlpHYbTi6OnnIdb155lXRVYSXFeimwZUmzALFrUV7l4Q8tKp
         LzJOnH3CmYzuQxz44/fcTCsjKDdVa7fTw7yNqF0kVGL83Fne0f9+6MAXY2xQ9x3sCC2g
         oOcw==
X-Gm-Message-State: AOAM5331nI0nlIamcmncWpYS4QwUZO6cwMKEo3c6VBRt2p/+jSXBYI/z
        amBzVrbDjH65xFfbpp7O0+V73dpeY2pU2AnIcbc=
X-Google-Smtp-Source: ABdhPJzU0FNp2WJ4wnSSl98EmcyPbtIbrpZha/OTvuUbCv86d7I76YAgwDFPb3sCkFWVqtxj6rgcw4RqHtFmJFC5mX8=
X-Received: by 2002:a63:191d:: with SMTP id z29mr24131077pgl.126.1624891863079;
 Mon, 28 Jun 2021 07:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210628091815.2373487-1-wanghai38@huawei.com>
In-Reply-To: <20210628091815.2373487-1-wanghai38@huawei.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 28 Jun 2021 16:50:52 +0200
Message-ID: <CAJ8uoz37m=J+2s7v9PBMqYZNyso7f_MseKQYZjvM2pyDYx1FbA@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: Fix xdpsock with '-M' parameter missing
 unload process
To:     Wang Hai <wanghai38@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 11:20 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> Execute the following command and exit, then execute it again, the
> following error will be reported.
>
> $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
> ^C
> $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
> libbpf: elf: skipping unrecognized data section(16) .eh_frame
> libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
> libbpf: Kernel error message: XDP program already attached
> ERROR: link set xdp fd failed
>
> commit c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock")
> removed the unload prog code because of the presence of bpf_link. This
> is fine if XDP_SHARED_UMEM is disable, but if it is enable, unload prog
> is still needed.

Thank you Wang.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  samples/bpf/xdpsock_user.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 53e300f860bb..33d0bdebbed8 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -96,6 +96,7 @@ static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
>  static int opt_timeout = 1000;
>  static bool opt_need_wakeup = true;
>  static u32 opt_num_xsks = 1;
> +static u32 prog_id;
>  static bool opt_busy_poll;
>  static bool opt_reduced_cap;
>
> @@ -461,6 +462,23 @@ static void *poller(void *arg)
>         return NULL;
>  }
>
> +static void remove_xdp_program(void)
> +{
> +       u32 curr_prog_id = 0;
> +
> +       if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
> +               printf("bpf_get_link_xdp_id failed\n");
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       if (prog_id == curr_prog_id)
> +               bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
> +       else if (!curr_prog_id)
> +               printf("couldn't find a prog id on a given interface\n");
> +       else
> +               printf("program on interface changed, not removing\n");
> +}
> +
>  static void int_exit(int sig)
>  {
>         benchmark_done = true;
> @@ -471,6 +489,9 @@ static void __exit_with_error(int error, const char *file, const char *func,
>  {
>         fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
>                 line, error, strerror(error));
> +
> +       if (opt_num_xsks > 1)
> +               remove_xdp_program();
>         exit(EXIT_FAILURE);
>  }
>
> @@ -490,6 +511,9 @@ static void xdpsock_cleanup(void)
>                 if (write(sock, &cmd, sizeof(int)) < 0)
>                         exit_with_error(errno);
>         }
> +
> +       if (opt_num_xsks > 1)
> +               remove_xdp_program();
>  }
>
>  static void swap_mac_addresses(void *data)
> @@ -857,6 +881,10 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
>         if (ret)
>                 exit_with_error(-ret);
>
> +       ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
> +       if (ret)
> +               exit_with_error(-ret);
> +
>         xsk->app_stats.rx_empty_polls = 0;
>         xsk->app_stats.fill_fail_polls = 0;
>         xsk->app_stats.copy_tx_sendtos = 0;
> --
> 2.17.1
>
