Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5839A1D6F17
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 04:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgERCoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 22:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgERCoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 22:44:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A889AC05BD0A
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 19:44:43 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id e2so7534641eje.13
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 19:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8K0sJqpLsIUnKAf2a0bGvl0VcjUMX3pFm+WYrpBq63U=;
        b=bal608dPtmHgZjr230fo5HEIQmZpWNKbe748W5U7xWtCbMjZR+nm3oALJ/HWSvd00x
         83Wr8YV8MLCO4AybYUDW7NOBlyfw1CrXTNq0We7cDoJwgzwt3P6Lz+g7EDAp9PxqyPXv
         i3ImAkB3WHEXwi7X6SfYulCiLO1feN+hFQhesKRoawqlcX7mtVgElmQ56aZ0asEczKmB
         hBUVItIYqiY+w0vbptHflC6eieNVeHjtNd3dShU8xW2hAnKqy7ZLWe5vl9vxhCAhQBoy
         yNLIx++JyjzrrmoSnZ6lGx7w/q0GB2d/ld+CzDsrU/X2eU4wIBOh9WPL4rw/0kM/6RNx
         YByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8K0sJqpLsIUnKAf2a0bGvl0VcjUMX3pFm+WYrpBq63U=;
        b=aXso3xKZTQgYT9VCjzs+ux0ehQIQ+ZWuH+VmPfCSOCLlv3lJ02oIVFBiR6B+iyTinF
         Z406ZMK/8KUI5pxEVdF3su0d5ufrxVTnjcihzlbecQXhC+HjC1QsHH3Mv4fS5h7HqSSt
         R6fB7rh1IvJrEH1ZSB8CM6RvJ+kP+bg6YzqKo1JFc76LNo2XM01k9zY3eNk0u7aUhz4j
         n+rTYbF3Ih1uyjiMlMAXlHMis0FDmKhi6DUoKuhQDQZoftIjh8fWnkaINgPYQNezvaPA
         CoFIW6ZbQUcth0LsXxipsgrUQ1ver9IPS0IV4jlkywjb74rNG9n0zOQKxpDhSrO3/Ldh
         8VQA==
X-Gm-Message-State: AOAM5311L4YMOiUSyph42CDYocVHbLH4w4p6ksxOazzu3zOQbgV0ejUz
        FlIzTuyUMylEIB3ZoRWgrT6HPScmXhkaFDYNru+Hcw==
X-Google-Smtp-Source: ABdhPJx2MV4ozWTjAy3YkqSEAkabXYFR7xDpxOWtddtOc7wQFoLofcxQF1JcxJiDynszv4GIEWR6UtA2NTgGyNxrpSw=
X-Received: by 2002:a17:906:3952:: with SMTP id g18mr13610750eje.191.1589769882137;
 Sun, 17 May 2020 19:44:42 -0700 (PDT)
MIME-Version: 1.0
From:   Qian Cai <cai@lca.pw>
Date:   Sun, 17 May 2020 22:44:31 -0400
Message-ID: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
Subject: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Clang 9.0.1,

return array->value + array->elem_size * (index & array->index_mask);

but array->value is,

char value[0] __aligned(8);

[  506.031548][ T4134] LTP: starting bpf_prog02
[  506.125326][ T4352]
================================================================================
[  506.134603][ T4352] UBSAN: array-index-out-of-bounds in
kernel/bpf/arraymap.c:177:22
[  506.142521][ T4352] index 8 is out of range for type 'char [0]'
[  506.148613][ T4352] CPU: 222 PID: 4352 Comm: bpf_prog02 Tainted: G
           L    5.7.0-rc5-next-20200515 #2
[  506.158632][ T4352] Hardware name: HPE Apollo 70
/C01_APACHE_MB         , BIOS L50_5.13_1.11 06/18/2019
[  506.169084][ T4352] Call trace:
[  506.172256][ T4352]  dump_backtrace+0x0/0x22c
[  506.176634][ T4352]  show_stack+0x28/0x34
[  506.180666][ T4352]  dump_stack+0x104/0x194
[  506.184877][ T4352]  __ubsan_handle_out_of_bounds+0xf0/0x120
[  506.190565][ T4352]  array_map_lookup_elem+0x90/0x94
[  506.195560][ T4352]  bpf_map_lookup_elem+0x48/0x60
[  506.200383][ T4352]  ___bpf_prog_run+0xe9c/0x2840
[  506.205109][ T4352]  __bpf_prog_run32+0x80/0xac
[  506.209673][ T4352]  __bpf_prog_run_save_cb+0x104/0x46c
[  506.214919][ T4352]  sk_filter_trim_cap+0x21c/0x2c4
[  506.219823][ T4352]  unix_dgram_sendmsg+0x45c/0x860
[  506.224725][ T4352]  sock_sendmsg+0x4c/0x74
[  506.228935][ T4352]  sock_write_iter+0x158/0x1a4
[  506.233584][ T4352]  __vfs_write+0x190/0x1d8
[  506.237874][ T4352]  vfs_write+0x13c/0x1b8
[  506.241992][ T4352]  ksys_write+0xb0/0x120
[  506.246108][ T4352]  __arm64_sys_write+0x54/0x88
[  506.250747][ T4352]  do_el0_svc+0x128/0x1dc
[  506.254957][ T4352]  el0_sync_handler+0xd0/0x268
[  506.259594][ T4352]  el0_sync+0x164/0x180
[  506.263747][ T4352]
