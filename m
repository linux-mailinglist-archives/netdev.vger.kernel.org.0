Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1FE4F53A0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1850732AbiDFEYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389147AbiDEV6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 17:58:42 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2D127157;
        Tue,  5 Apr 2022 13:53:09 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id 8so488355ilq.4;
        Tue, 05 Apr 2022 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HWywLCnuBJENyaVSzau6oxayEHnan1gP5wOiyTjE0lE=;
        b=Ng44QPog2Ob/33Nb0XtIXGcPgdZSTaph4xEENN/niuAvs1XHftuk3AiE+wROi1S91x
         +qyBC+xryehcvY7GgAXctFkS0i30tzWT9cJZ2IY9SbAu1OQDSXF1lwoZ8RVsJTP8Zdlh
         oORwXapaqbAf095fE95h2NMHWuJVP1DT2ZY5xWszPc3nLX5hLtvCLzN9gaONPgrtBgWq
         uXU7Du/63P9BA7d8bl+o2wIcUACJhBziQZ4SPq3T1e9uVwmXjJftcVnbHEQdYDVbvIZY
         Z/1yuyJkRKKkLS5PlOUeobcM10zJreDMReU7dgKl+Eo75E0diBtmI7Vjv7kQEVNo5D1O
         +lyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWywLCnuBJENyaVSzau6oxayEHnan1gP5wOiyTjE0lE=;
        b=gg8UyswW3gUoU8WEW8io7sIxw7R7Ua5k+nyEnMto7uLAMeCVV6Jah8ULNifeQBiyHG
         YN+p2vte+M0zch8YRoa7R4lqYwI73WuGqfVGfl430EyGkupjOvr/giC2Sk1UGRP543d5
         0i1LOGWKMr31Wrowh2+vrlm1tTINNPq32yEj/vIOCILDRFY4t4JIfhaQ4+pX+AbjvTiw
         gjGaave5izrCe72zdlddFt11fLKN9KqPYzRGcG7Lc+c/tQMzt4ruesX2jKjWSNEoV4Ts
         ugpFJt1XxfaZpv/ozArbcfjoSd0XnaRXlLgLth11BSoDKz1Hsv/DqVgraVZXUI3i5lsN
         ielw==
X-Gm-Message-State: AOAM53392hwkCU1rtTF3EIlztSMh1fn5elE4kWiuhg2iGh6Q7sw6jMB6
        LwTpAhi6Kicndm0bgctfM14AtrmKY4THm+ir4dg=
X-Google-Smtp-Source: ABdhPJz9lFsa85feLlcxpsJ+S0S26P8Czc++xSyLlg83sTnhPX3YqPTZX+i0zsIMFIG7GldpdkV0pSyxmeljw1ElklI=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr2538171ilb.305.1649191989003; Tue, 05
 Apr 2022 13:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220405130858.12165-1-laoar.shao@gmail.com>
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 13:52:58 -0700
Message-ID: <CAEf4BzaEF013kPkV=gkN6fw7e9hO_h0MLWuDbx4Qd68ZCr=5pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/27] bpf: RLIMIT_MEMLOCK cleanups
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 5, 2022 at 6:09 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> We have switched to memcg based memory accouting and thus the rlimit is
> not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
> libbpf for backward compatibility, so we can use it instead now.
>
> This patchset cleanups the usage of RLIMIT_MEMLOCK in tools/bpf/,
> tools/testing/selftests/bpf and samples/bpf. The file
> tools/testing/selftests/bpf/bpf_rlimit.h is removed. The included header
> sys/resource.h is removed from many files as it is useless in these files.
>
> - v3: Get rid of bpf_rlimit.h and fix some typos (Andrii)
> - v2: Use libbpf_set_strict_mode instead. (Andrii)
> - v1: https://lore.kernel.org/bpf/20220320060815.7716-2-laoar.shao@gmail.com/
>
> Yafang Shao (27):
>   bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
>     xdping
>   bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
>     xdpxceiver
>   bpf: selftests: No need to include bpf_rlimit.h in test_tcpnotify_user
>   bpf: selftests: No need to include bpf_rlimit.h in flow_dissector_load
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     get_cgroup_id_user
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     test_cgroup_storage
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     get_cgroup_id_user
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lpm_map
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lru_map
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     test_skb_cgroup_id_user
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock_addr
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sockmap
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sysctl
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in test_tag
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     test_tcp_check_syncookie_user
>   bpf: selftests: Set libbpf 1.0 API mode explicitly in
>     test_verifier_log
>   bpf: samples: Set libbpf 1.0 API mode explicitly in hbm
>   bpf: selftests: Get rid of bpf_rlimit.h
>   bpf: selftests: No need to include sys/resource.h in some files
>   bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
>     xdpsock_user
>   bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
>     xsk_fwd
>   bpf: samples: No need to include sys/resource.h in many files
>   bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
>   bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
>   bpf: bpftool: remove RLIMIT_MEMLOCK
>   bpf: runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
>

Hey Yafang, thanks for the clean up! It looks good, but please make it
a bit more manageable in terms of number of patches. There is no need
to have so many tiny patches. Can you squash together all the
samples/bpf changes into one patch, all the selftests/bpf changes into
another, bpftool ones still can be just one patch. runqslower makes
sense to keep separate. Please also use customary subject prefixes for
those: "selftests/bpf: ", "bpftool: ", "samples/bpf: ". For runqslower
probably "tools/runqslower: " would be ok as well.

>  samples/bpf/cpustat_user.c                    |  1 -
>  samples/bpf/hbm.c                             |  5 ++--
>  samples/bpf/ibumad_user.c                     |  1 -
>  samples/bpf/map_perf_test_user.c              |  1 -
>  samples/bpf/offwaketime_user.c                |  1 -
>  samples/bpf/sockex2_user.c                    |  1 -
>  samples/bpf/sockex3_user.c                    |  1 -
>  samples/bpf/spintest_user.c                   |  1 -
>  samples/bpf/syscall_tp_user.c                 |  1 -
>  samples/bpf/task_fd_query_user.c              |  1 -
>  samples/bpf/test_lru_dist.c                   |  1 -
>  samples/bpf/test_map_in_map_user.c            |  1 -
>  samples/bpf/test_overhead_user.c              |  1 -
>  samples/bpf/tracex2_user.c                    |  1 -
>  samples/bpf/tracex3_user.c                    |  1 -
>  samples/bpf/tracex4_user.c                    |  1 -
>  samples/bpf/tracex5_user.c                    |  1 -
>  samples/bpf/tracex6_user.c                    |  1 -
>  samples/bpf/xdp1_user.c                       |  1 -
>  samples/bpf/xdp_adjust_tail_user.c            |  1 -
>  samples/bpf/xdp_monitor_user.c                |  1 -
>  samples/bpf/xdp_redirect_cpu_user.c           |  1 -
>  samples/bpf/xdp_redirect_map_multi_user.c     |  1 -
>  samples/bpf/xdp_redirect_user.c               |  1 -
>  samples/bpf/xdp_router_ipv4_user.c            |  1 -
>  samples/bpf/xdp_rxq_info_user.c               |  1 -
>  samples/bpf/xdp_sample_pkts_user.c            |  1 -
>  samples/bpf/xdp_sample_user.c                 |  1 -
>  samples/bpf/xdp_tx_iptunnel_user.c            |  1 -
>  samples/bpf/xdpsock_user.c                    |  9 ++----
>  samples/bpf/xsk_fwd.c                         |  7 ++---
>  tools/bpf/bpftool/common.c                    |  8 ------
>  tools/bpf/bpftool/feature.c                   |  2 --
>  tools/bpf/bpftool/main.c                      |  6 ++--
>  tools/bpf/bpftool/main.h                      |  2 --
>  tools/bpf/bpftool/map.c                       |  2 --
>  tools/bpf/bpftool/pids.c                      |  1 -
>  tools/bpf/bpftool/prog.c                      |  3 --
>  tools/bpf/bpftool/struct_ops.c                |  2 --
>  tools/bpf/runqslower/runqslower.c             | 18 ++----------
>  tools/testing/selftests/bpf/bench.c           |  1 -
>  tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
>  .../selftests/bpf/flow_dissector_load.c       |  6 ++--
>  .../selftests/bpf/get_cgroup_id_user.c        |  4 ++-
>  tools/testing/selftests/bpf/prog_tests/btf.c  |  1 -
>  .../selftests/bpf/test_cgroup_storage.c       |  4 ++-
>  tools/testing/selftests/bpf/test_dev_cgroup.c |  4 ++-
>  tools/testing/selftests/bpf/test_lpm_map.c    |  4 ++-
>  tools/testing/selftests/bpf/test_lru_map.c    |  4 ++-
>  .../selftests/bpf/test_skb_cgroup_id_user.c   |  4 ++-
>  tools/testing/selftests/bpf/test_sock.c       |  4 ++-
>  tools/testing/selftests/bpf/test_sock_addr.c  |  4 ++-
>  tools/testing/selftests/bpf/test_sockmap.c    |  5 ++--
>  tools/testing/selftests/bpf/test_sysctl.c     |  4 ++-
>  tools/testing/selftests/bpf/test_tag.c        |  4 ++-
>  .../bpf/test_tcp_check_syncookie_user.c       |  4 ++-
>  .../selftests/bpf/test_tcpnotify_user.c       |  1 -
>  .../testing/selftests/bpf/test_verifier_log.c |  5 ++--
>  .../selftests/bpf/xdp_redirect_multi.c        |  1 -
>  tools/testing/selftests/bpf/xdping.c          |  8 ++----
>  tools/testing/selftests/bpf/xdpxceiver.c      |  6 ++--
>  61 files changed, 57 insertions(+), 142 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
>
> --
> 2.17.1
>
