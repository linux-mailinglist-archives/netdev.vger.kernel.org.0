Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C98F204547
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgFWAZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbgFWAYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:24:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0DFC061573;
        Mon, 22 Jun 2020 17:24:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id jz3so707135pjb.0;
        Mon, 22 Jun 2020 17:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yAEyjq/JNyJP7uSbKOdpv01lLUkb3wgH1Jl7u5iMWD0=;
        b=Bc7WZNBTLajK/WN/L2BEbD7yuMaov3KmP+LSG2dHLv6aj4p282Jvlp0FHk8IL3rHyw
         QMc9EwVsqYD3j993NXG2GRlsNV2TAT08OtRGKOpT+Ra3G//7prE41XV7DAiZY9PdOvYp
         QSIxPAIzjGfxqmQdD2oKy5AF9Zb0myFlSoy2YhzBnJuAhUQGgae5AW7JLwahfHPjxKl5
         3a2Zv66+Oo/4RCTDxzkq4/MkCr8TUzk7+Lz+7Gu1NG/wh+7VHVyQ2YkVGl0ITgvvx7R+
         LG+0KWH1XDPLYYLar1D33qwbbiglCage9pb/V9YZt8jyimKJxN3NWCjVwBA09bQWVFNi
         ydcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yAEyjq/JNyJP7uSbKOdpv01lLUkb3wgH1Jl7u5iMWD0=;
        b=NLbKW7+mYsnVGFNVGxKdc532aUXtjNmVvJSjWBpDW3UwnwdGd0Ob3gMk5BAC0+sadB
         6Oy36PqIQop31eYhH10LgjRuh3SPq9pKRW4ZRswV7alvTRAySj6PdYxso0JShAdbZ52a
         1MpwReLuWT8n0eBJH375D7TE9wqowWNcGp0FusDvafUDX9JJYjchCeqS0/V6I9ZkpA/U
         96AyGq72NuiBrDb6zNWvrC3qLqNTFzbHQFc71JTF4NU7hLsZLni2jMlD9pxCMClU6zq7
         fwwx7ZbH4znuXwfvTBELH5p/8j6bU33vHXysDt+H4xhxry95M4+ZKDV3L+kkmggrzQne
         94qQ==
X-Gm-Message-State: AOAM533DKXzptcWphF4oJMNyiqr9hYjKGebNzhtOUlFnsHtRVSSPY8tq
        vE8OVMrQJEWHAqZbz8i8HnE=
X-Google-Smtp-Source: ABdhPJx1WdeaWl17PhYPKGwCFeDrrWeCanzwdiOB3SC2A8v9jXT32bUmsFJc0B7KXeSX06/3MYK2Aw==
X-Received: by 2002:a17:90b:fc8:: with SMTP id gd8mr20946736pjb.142.1592871894651;
        Mon, 22 Jun 2020 17:24:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:739c])
        by smtp.gmail.com with ESMTPSA id e124sm14655581pfh.140.2020.06.22.17.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 17:24:53 -0700 (PDT)
Date:   Mon, 22 Jun 2020 17:24:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [PATCH v3 bpf-next 8/9] tools/bpftool: show info for processes
 holding BPF map/prog/link/btf FDs
Message-ID: <20200623002451.egxxppsm35q2dg5l@ast-mbp.dhcp.thefacebook.com>
References: <20200619231703.738941-1-andriin@fb.com>
 <20200619231703.738941-9-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619231703.738941-9-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 04:17:02PM -0700, Andrii Nakryiko wrote:
> Add bpf_iter-based way to find all the processes that hold open FDs against
> BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> Process name and PID are emitted for each process (task group).
> 
> Sample output for each of 4 BPF objects:
> 
> $ sudo ./bpftool prog show
> 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>         loaded_at 2020-06-16T15:34:32-0700  uid 0
>         xlated 648B  jited 409B  memlock 4096B
>         pids systemd(1)
> 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
>         loaded_at 2020-06-16T18:06:54-0700  uid 0
>         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 
> $ sudo ./bpftool map show
> 2436: array  name test_cgr.bss  flags 0x400
>         key 4B  value 8B  max_entries 1  memlock 8192B
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 2445: array  name pid_iter.rodata  flags 0x480
>         key 4B  value 4B  max_entries 1  memlock 8192B
>         btf_id 1214  frozen
>         pids bpftool(2239612)

Overall it's a massive improvement, so I've applied the set.

But above 'map show' probably needs a comment in the output.
bpftool is showing a map that was loaded temporarily.
It doesn't do so for programs though.
I think somehow highlighting that above map is bpftool's own map
that was used to generate this output would be good.
Filtering it completely out is probably not correct.

> $ sudo ./bpftool btf show
> 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
>         pids test_progs(2238417), test_progs(2238445)
> 1242: size 34684B
>         pids bpftool(2258892)

similar.

I've also noticed that 'test_progs -t btf_map_in_map' leaks 'inner_map2'.
Doesn't look like the test is pinning it, so I'm guessing
a recent kernel regression? I haven't debugged it.
