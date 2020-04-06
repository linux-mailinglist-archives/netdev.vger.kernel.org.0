Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38C19EF58
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 04:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDFCqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 22:46:51 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45039 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgDFCqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 22:46:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id j4so14739008qkc.11;
        Sun, 05 Apr 2020 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=56voqtFYeudq/VV/J/Sg075FrS52rvV+pYrlJWqB8HY=;
        b=WkVVGgWFJTYzEXNm/LIEDG1GuUzpOrz4DjCrAvs6wKize+qZNPWC8LlXA/6BG2CCeQ
         SJ9N1/YOs7HN1KAK8sDPTBaKUzmpGzvdiiIy7o/0MJsi7LkA+3TtqJa/tNCOztOMcBsK
         3S/8r7YXulhYeSCnqYYPCPbyhbCLgBGMa1b3XMGqI3yIqkBAPfQwpnGI/WMf7WUguVf3
         GCwBj4gNVCmUMijdwtz3UtUGPH55hLfUtJshRftvHkKkW5krkt3w4OK8x2dkBtDsUKj5
         /QP8/9hCmdMu8DaDDqtYiFq1YJA1pxs2KacuBdZCzo9jogRc2h0gA0/MG5LxNF6/4ujg
         uaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=56voqtFYeudq/VV/J/Sg075FrS52rvV+pYrlJWqB8HY=;
        b=JuntiiMeWgfxxcdlFbLTMWYM2jzwOu732HEhVuQh7jpmkv08HOr1UaWMDpFl46/35i
         iiLeyL37Ipr9JtdmwqqWxMvlsHD3bkLsx8TTY0T71Qt3vHvxtj9b0UBoRcqO+SVhZgpA
         V24Tcz8NuDh82KKeOScuONyHOOQejV1Q4kSCTWduFcTd+y1R2OUBkHTTDseI1K27LDZ9
         h6AUWn4iyEcFwIJJI0+Va012Qnqj1vMELxBh+mN3NngaktkRFMS/SWse3eZAE/KeNkaG
         OEs/fNEZ04tfBUb/x5Q/2bIdYp1APH+K61m7M+/kMO9sica1GwE8aMKIEHq815VYaKII
         Xxag==
X-Gm-Message-State: AGi0PuaQpL2LAypLb3KQ7pp1J+TvK75eBXyVCPVPTB8KytZv1G7wzuCw
        aZAjA1Qkf3amfoLusEem14x/EeU3OTD9r788dIk=
X-Google-Smtp-Source: APiQypLFRORlr4Vh0aYKObYp4Acq9iJezPZdOKLsC++BIczCfPtmRtzIkM7pLbLgyrnkXclrZIDRaUte9iHcVg1wXdc=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr20514490qka.449.1586141209712;
 Sun, 05 Apr 2020 19:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200404051430.698058-1-jcline@redhat.com>
In-Reply-To: <20200404051430.698058-1-jcline@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 5 Apr 2020 19:46:38 -0700
Message-ID: <CAEf4BzZmki+vzzC0j_uXWfPFs6BGqwxbJn2fYK83L5fpUm+UHg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Initialize *nl_pid so gcc 10 is happy
To:     Jeremy Cline <jcline@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 10:15 PM Jeremy Cline <jcline@redhat.com> wrote:
>
> Builds of Fedora's kernel-tools package started to fail with "may be
> used uninitialized" warnings for nl_pid in bpf_set_link_xdp_fd() and
> bpf_get_link_xdp_info() on the s390 architecture.
>
> Although libbpf_netlink_open() always returns a negative number when it
> does not set *nl_pid, the compiler does not determine this and thus
> believes the variable might be used uninitialized. Assuage gcc's fears
> by explicitly initializing nl_pid.
>
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1807781
> Signed-off-by: Jeremy Cline <jcline@redhat.com>
> ---

Yep, unfortunately compiler is not that smart.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/netlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 18b5319025e19..9a14694176de0 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -142,7 +142,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
>                 struct ifinfomsg ifinfo;
>                 char             attrbuf[64];
>         } req;
> -       __u32 nl_pid;
> +       __u32 nl_pid = 0;
>
>         sock = libbpf_netlink_open(&nl_pid);
>         if (sock < 0)
> @@ -288,7 +288,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>  {
>         struct xdp_id_md xdp_id = {};
>         int sock, ret;
> -       __u32 nl_pid;
> +       __u32 nl_pid = 0;
>         __u32 mask;
>
>         if (flags & ~XDP_FLAGS_MASK || !info_size)
> --
> 2.26.0
>
