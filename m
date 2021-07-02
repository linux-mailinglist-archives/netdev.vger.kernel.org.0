Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5413BA475
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhGBTxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhGBTxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:53:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB36C061762;
        Fri,  2 Jul 2021 12:50:58 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a127so9934100pfa.10;
        Fri, 02 Jul 2021 12:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bahcwMUWxt9t1FIUJzwQa83jxzN+W1BTMiH1+vtrqyo=;
        b=q77VAq6DMoj4VY6s/sPg0cggnUhdGb07/5WffQxU0v6rn9HZwjcU2euiaz80UbF2PK
         uG/+jmUAPv+szOe+XYKXzOCfQyNFrlK2BfFSJfCIjdVJHAOu+Jc1cYzWa5zpEFUGON+W
         xn/PmjWhLpsHDQ8+5CbXZQW51EuWCS5bIjNZyNgIeQKWZvCPHh49rcNZpc6VzuVpAxoc
         9xuWudgodXQI6iBW0KqimaSFJJttAxkkB8v24UZaqX/NWBRL+jtiQsG7opWt/edgIIlH
         q5+PJMJRkjjnkStFNTwq4FzGtrXSImx2qvvjy1T8D2gElUMNkqZNPDRlo67EOwPWvKuP
         7bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bahcwMUWxt9t1FIUJzwQa83jxzN+W1BTMiH1+vtrqyo=;
        b=oysxhOwN1AnsUlT9QI3+B83KdJvFA2xzRPIjl6OZGLZVf+lpe6S+c/ZjEBJdGsNrX6
         mL2jV62QkvTL/UvhlaU1rkPcjMPvwZCCZcTuQxsmQ4mMMBnTON8taOfH245yqm5/f1QJ
         MV0lofbmGDD0Sgf1wxzUr2loVWUEsiiQVVBzLl6nhv1ZCcuszxBgP5RXjb04q0PuFo/a
         lJTOxTKOnWbX0xRinVfL6g2V8sYpoeG1pWAs7qeg50DE13NDfQ1jeuBdfMqCNJASelQ2
         3tIRTq+iWw1jYiL6kQTH/Wzw6lJRr9cDMt4myEO/KjcOZoB1s5zmNcmao9e6KC0KH3AA
         jhsw==
X-Gm-Message-State: AOAM532i4YUppCLgNrYk3zMgfUA9vDob0hhP/uqtIrM5uL39ks9onCKa
        SPcq9lmxJW3hUgcYjOE3PCLgrGTAaXAvNRv1ork=
X-Google-Smtp-Source: ABdhPJxbq6Rxlz/T92zatHe52rNYqu0G1TBa+8A3uQ8bV5z6RP9yY/k/JBdTdo/boRYXSBtfL3Wi/TZVi9uawoWdtVE=
X-Received: by 2002:a65:6788:: with SMTP id e8mr1629080pgr.18.1625255458508;
 Fri, 02 Jul 2021 12:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210702001123.728035-1-john.fastabend@gmail.com> <20210702001123.728035-3-john.fastabend@gmail.com>
In-Reply-To: <20210702001123.728035-3-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Jul 2021 12:50:47 -0700
Message-ID: <CAM_iQpWZnQ7A=U9JmzGZrOcOB2V1f22NmbFkcJ0SVdA3iHgSGA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 2/2] bpf, sockmap: sk_prot needs inuse_idx for proc stats
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 5:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/sock_map.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 60decd6420ca..016ea5460f8f 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -222,6 +222,9 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
>         struct bpf_prog *msg_parser = NULL;
>         struct sk_psock *psock;
>         int ret;
> +#ifdef CONFIG_PROC_FS
> +       int idx;
> +#endif
>
>         /* Only sockets we can redirect into/from in BPF need to hold
>          * refs to parser/verdict progs and have their sk_data_ready
> @@ -293,9 +296,15 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
>         if (msg_parser)
>                 psock_set_prog(&psock->progs.msg_parser, msg_parser);
>
> +#ifdef CONFIG_PROC_FS
> +       idx = sk->sk_prot->inuse_idx;
> +#endif
>         ret = sock_map_init_proto(sk, psock);
>         if (ret < 0)
>                 goto out_drop;
> +#ifdef CONFIG_PROC_FS
> +       sk->sk_prot->inuse_idx = idx;
> +#endif

I think it is better to put these into sock_map_init_proto()
so that sock_map_link() does not need to worry about the sk_prot
details.

Thanks.
