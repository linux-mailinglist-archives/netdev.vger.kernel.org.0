Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFC209847
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgFYBpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:45:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A0C061573;
        Wed, 24 Jun 2020 18:45:44 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q19so4711179lji.2;
        Wed, 24 Jun 2020 18:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ALVNKGiM3CJvd8q/KVeerYAKvNB9aY24L8Fa5c/hTAQ=;
        b=D1Z6klhf3Dp4ZRcLUn7g3mmWaia+8zR7HGM6qursEq7yXcEEaw47z/L1W/v4S+8PIU
         DdIiBJQGFePS+EY3tr3oSaj5/9ZNR57DMr9eBYvAzl5x8CPAW8A6YDQD2vJ5+dODuA+B
         UQ+4t5YQ5e3lNgdaYkll5N+s2URCOv8rAU0rcyPw9YyuPg9bKA9nDmt0snUAZhPdkxpO
         o4W24duLAOVplW3wDv4Qf/TViJWLUjfikKskkUZK3YgBzLMdFj5AuZRw2ygl1gLTlElU
         XpeTSFw2pj2RSQpZfumn3v6phSIVfPerEVCbH+4BCP9S5abCRTAgpE9o3oPvaW+6/ocv
         OnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ALVNKGiM3CJvd8q/KVeerYAKvNB9aY24L8Fa5c/hTAQ=;
        b=nwMsgOnPqEH8qE6r3y+WOOzZCHGFGDGNYKbaPRSxmTGsGu34brRo3kKr4M+yuHWSIF
         JTEw/eOiSIw2MNkuqVy5+jXDGOyyl0/B0zGlJnLr8J4sU2Nswve3n2yV9Iyx7MBDsbRl
         T6OVkt4sYl14nb8C3S8S43zrFQa3okh+cUClba6hSCzsk4QVKJU0XW2m5ioAQIc3kGsZ
         nm4MF/K8Ot0AecPnKJFne8wQntH7sALx3Eu39npI461nAS/jzx7D5aJS+ai6jjviDCAf
         TvnVAVXErFG0gYenLw3D9lm00IQGMBGBEctCIXnLpVBfKiWaN6oCwsxB3XbFYwjN30kT
         SRYA==
X-Gm-Message-State: AOAM533dvWoJpdutRaYOO9e/ECOCyBqvdGQKLpCC2XZmFTbK1OV71T2i
        hs0E5YAcpkGUajPsFdcXZh+jfxBR6TOrarfgjS0=
X-Google-Smtp-Source: ABdhPJznpa1c96xDNPmJW4jYrrBEIOS6bVFFPsDJZ8+dYZ6+fmygFvWhSo/tWiYyd3uXoiifINfomPlIwrj5QEI4X4o=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr15772176ljg.450.1593049543222;
 Wed, 24 Jun 2020 18:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200623230803.3987674-1-yhs@fb.com>
In-Reply-To: <20200623230803.3987674-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Jun 2020 18:45:31 -0700
Message-ID: <CAADnVQJiEeZe1v=612etTLpawZ1hHmTFWbJau1UBX_KegTX1Mg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/15] implement bpf iterator for tcp and udp sockets
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 4:08 PM Yonghong Song <yhs@fb.com> wrote:
>
> bpf iterator implments traversal of kernel data structures and these
> data structures are passed to a bpf program for processing.
> This gives great flexibility for users to examine kernel data
> structure without using e.g. /proc/net which has limited and
> fixed format.
>
> Commit 138d0be35b14 ("net: bpf: Add netlink and ipv6_route bpf_iter targets")
> implemented bpf iterators for netlink and ipv6_route.
> This patch set intends to implement bpf iterators for tcp and udp.
>
> Currently, /proc/net/tcp is used to print tcp4 stats and /proc/net/tcp6
> is used to print tcp6 stats. /proc/net/udp[6] have similar usage model.
> In contrast, only one tcp iterator is implemented and it is bpf program
> resposibility to filter based on socket family. The same is for udp.
> This will avoid another unnecessary traversal pass if users want
> to check both tcp4 and tcp6.
>
> Several helpers are also implemented in this patch
>   bpf_skc_to_{tcp, tcp6, tcp_timewait, tcp_request, udp6}_sock
> The argument for these helpers is not a fixed btf_id. For example,
>   bpf_skc_to_tcp(struct sock_common *), or
>   bpf_skc_to_tcp(struct sock *), or
>   bpf_skc_to_tcp(struct inet_sock *), ...
> are all valid. At runtime, the helper will check whether pointer cast
> is legal or not. Please see Patch #5 for details.
>
> Since btf_id's for both arguments and return value are known at
> build time, the btf_id's are pre-computed once vmlinux btf becomes
> valid. Jiri's "adding d_path helper" patch set
>   https://lore.kernel.org/bpf/20200616100512.2168860-1-jolsa@kernel.org/T/
> provides a way to pre-compute btf id during vmlinux build time.
> This can be applied here as well. A followup patch can convert
> to build time btf id computation after Jiri's patch landed.
>
> Changelogs:
>   v4 -> v5:
>     - fix bpf_skc_to_udp6_sock helper as besides sk_protocol, sk_family,
>       sk_type == SOCK_DGRAM is also needed to differentiate from
>       SOCK_RAW (Eric)

Applied. Thanks
