Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E612E9F26
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfJ3Pdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:33:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35490 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfJ3Pds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:33:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id h6so3186126qkf.2;
        Wed, 30 Oct 2019 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=53/a68HbjXm5h243NIuNOZ/MpQpiNbW7zLD4BHdO7So=;
        b=ZrWm7+5wA6GqMCdZSKOgCpdRshQPV3prWQ7rK76LK8AdLOwueimqfFDIjmWTpbjDq/
         eLhDFOHlZOboDw/G40mnOANx1MIPDhlr6h72Vcym57Cj4p2ShmJYLFf6C/aES3/Glz8W
         14Hn29bnW2iY79axS8DM5Y3+Ew7GO03rPtYRhFvZyN85G1pTHPGOJboO7bj1OQn6LRB7
         f2B85Q6/NJ2lHBdCMWWTunL1Q3/OIktvpxs61k2fDBmzPhPsWI/c59oqypQFImxkxAgL
         L2kg6+tuyQuM/L3dcBDEMZoULy/zVobx32Nb6Z0nsm9A+m33/7y7BavcQbopmJHwInX3
         pr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=53/a68HbjXm5h243NIuNOZ/MpQpiNbW7zLD4BHdO7So=;
        b=mns7Bkqei3WMx8pmWD0Wl7lr+zhycWfdys/c4A6wMCeBEXGhZT+Ykt/EpV6JQ01sy3
         MRkscYm5mcztTE13JVwBVjKzurDdK3Wez7uRKSGGMRqigLLWGbltY/37EMbqbPu0ANtG
         OUHycFtqg76KF12ZuvMY3fFcZ02244uFlMkP8s/FnHxBKDctWoPxTwVI/J9nr16kvjME
         a46YHDtrPz+COOSf/L1IYiU9Drl93pRPuAh2XPT+4/u6IX6Htk2AmWBFQ+ekHLMUODjl
         MUl/vMJ52cR9HaVWHdNB6amN371KdLho71UzCjgaz1M93kuQMpo3efNwb6S+HHV08/z2
         B7TA==
X-Gm-Message-State: APjAAAXNrtCD7HZQ2TggZ0nabevYowgrgYeBgqogIxRzEqK/i3TKGIa0
        03mcd8NI3qUs4S3wQ5fGZtA=
X-Google-Smtp-Source: APXvYqwKSVqkTQnvptXku9PdjQcbmYOLOFSo7oxrfl8150djVEwrcD5QapAnqJnoAwySmD+TSgHtuw==
X-Received: by 2002:a37:8245:: with SMTP id e66mr476861qkd.355.1572449627088;
        Wed, 30 Oct 2019 08:33:47 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id 14sm253362qtb.54.2019.10.30.08.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 08:33:46 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 6A74E410D7; Wed, 30 Oct 2019 12:33:40 -0300 (-03)
Date:   Wed, 30 Oct 2019 12:33:40 -0300
To:     Daniel Borkmann <borkmann@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: Compile build issues with samples/bpf/ again
Message-ID: <20191030153340.GE27327@kernel.org>
References: <20191030114313.75b3a886@carbon>
 <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
 <20191030120551.68f8b67b@carbon>
 <d7d91ac5-a579-2ada-f96d-4239b8dc11b6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7d91ac5-a579-2ada-f96d-4239b8dc11b6@iogearbox.net>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Oct 30, 2019 at 04:07:32PM +0100, Daniel Borkmann escreveu:
> On 10/30/19 12:05 PM, Jesper Dangaard Brouer wrote:
> > On Wed, 30 Oct 2019 11:53:21 +0100
> > Björn Töpel <bjorn.topel@gmail.com> wrote:
> > > On Wed, 30 Oct 2019 at 11:43, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> [...]
> > > > It is annoy to experience that simply building kernel tree samples/bpf/
> > > > is broken as often as it is.  Right now, build is broken in both DaveM
> > > > net.git and bpf.git.  ACME have some build fixes queued from Björn
> > > > Töpel. But even with those fixes, build (for samples/bpf/task_fd_query_user.c)
> > > > are still broken, as reported by Eric Sage (15 Oct), which I have a fix for.
> > > 
> > > Hmm, something else than commit e55190f26f92 ("samples/bpf: Fix build
> > > for task_fd_query_user.c")?
> > 
> > I see, you already fixed this... and it is in the bpf.git tree.
> > 
> > Then we only need your other fixes from ACME's tree.  I just cloned a
> > fresh version of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> > to check that 'make M=samples/bpf' still fails.
> 
> Correct, the two fixes from Bjorn which made the test_attr__* optional were
> taken by Arnaldo given the main change was under tools/perf/perf-sys.h. If
> you cherry pick these ...
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=06f84d1989b7e58d56fa2e448664585749d41221
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=fce9501aec6bdda45ef3a5e365a5e0de7de7fe2d
> 
> ... into bpf tree, then all builds fine. When Arnaldo took them, my assumption
> was that these fixes would have been routed by him to Linus' tree, and upon
> resync we pull them automatically into bpf tree again.
> 
> Look like didn't happen yet at this point, Arnaldo?

Yes, it will go to Linus, I was just unsure when was that it should go,
i.e. next or in the current window, so I've queued it up to next.

[acme@quaco perf]$ git tag --contains 06f84d1989b7e58d56fa2e448664585749d41221
perf-core-for-mingo-5.5-20191011
perf-core-for-mingo-5.5-20191021
[acme@quaco perf]$

So its in tip, but queued for 5.5, while I think you guys expect this to
fast track into 5.4, right? If so, please get that queued up or tell me
if you prefer for me to do it.
 
I agree with Jesper that when one changes something in common code, then
one does have to test all tools/ that may use that common code, but in
this specific case the breakage happened because tools/perf/ code was
used outside tools/perf/ which I completely didn't expect to happen,
whatever that is in tools/perf/perf-sys.h better go to tools/include or
tools/arch or some other common area, agreed?

- Arnaldo
 
> Build after cherry-pick:
> 
> root@foo1:~/bpf# make -j8 M=samples/bpf/ clean
>   CLEAN   samples/bpf/
>   CLEAN   samples/bpf//Module.symvers
> root@foo1:~/bpf# make -j8 M=samples/bpf/
>   AR      samples/bpf//built-in.a
> make -C /root/bpf/samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=/root/bpf/samples/bpf/../../ O=
>   HOSTCC  samples/bpf//bpf_load.o
>   HOSTCC  samples/bpf//xdp1_user.o
>   HOSTCC  samples/bpf//cookie_uid_helper_example.o
>   HOSTCC  samples/bpf//test_lru_dist
>   HOSTCC  samples/bpf//sock_example
>   HOSTCC  samples/bpf//fds_example.o
>   HOSTCC  samples/bpf//sockex1_user.o
>   HOSTCC  samples/bpf//sockex2_user.o
>   HOSTCC  samples/bpf//sockex3_user.o
>   HOSTCC  samples/bpf//tracex1_user.o
>   HOSTCC  samples/bpf//tracex2_user.o
>   HOSTCC  samples/bpf//tracex3_user.o
>   HOSTCC  samples/bpf//tracex4_user.o
>   HOSTCC  samples/bpf//tracex5_user.o
>   HOSTCC  samples/bpf//tracex6_user.o
>   HOSTCC  samples/bpf//tracex7_user.o
>   HOSTCC  samples/bpf//test_probe_write_user_user.o
>   HOSTCC  samples/bpf//trace_output_user.o
>   HOSTCC  samples/bpf//lathist_user.o
>   HOSTCC  samples/bpf//offwaketime_user.o
>   HOSTCC  samples/bpf//spintest_user.o
>   HOSTCC  samples/bpf//map_perf_test_user.o
>   HOSTCC  samples/bpf//test_overhead_user.o
>   HOSTCC  samples/bpf//test_cgrp2_array_pin.o
>   HOSTCC  samples/bpf//test_cgrp2_attach.o
>   HOSTCC  samples/bpf//test_cgrp2_sock.o
>   HOSTCC  samples/bpf//test_cgrp2_sock2.o
>   HOSTLD  samples/bpf//xdp1
>   HOSTLD  samples/bpf//xdp2
>   HOSTCC  samples/bpf//xdp_router_ipv4_user.o
>   HOSTCC  samples/bpf//test_current_task_under_cgroup_user.o
>   HOSTCC  samples/bpf//trace_event_user.o
>   HOSTCC  samples/bpf//sampleip_user.o
>   HOSTCC  samples/bpf//tc_l2_redirect_user.o
>   HOSTCC  samples/bpf//lwt_len_hist_user.o
>   HOSTCC  samples/bpf//xdp_tx_iptunnel_user.o
>   HOSTCC  samples/bpf//test_map_in_map_user.o
>   HOSTLD  samples/bpf//per_socket_stats_example
>   HOSTCC  samples/bpf//xdp_redirect_user.o
>   HOSTCC  samples/bpf//xdp_redirect_map_user.o
>   HOSTCC  samples/bpf//xdp_redirect_cpu_user.o
>   HOSTCC  samples/bpf//xdp_monitor_user.o
>   HOSTCC  samples/bpf//xdp_rxq_info_user.o
>   HOSTCC  samples/bpf//syscall_tp_user.o
>   HOSTCC  samples/bpf//cpustat_user.o
>   HOSTCC  samples/bpf//xdp_adjust_tail_user.o
>   HOSTCC  samples/bpf//xdpsock_user.o
>   HOSTCC  samples/bpf//xdp_fwd_user.o
>   HOSTCC  samples/bpf//task_fd_query_user.o
>   HOSTCC  samples/bpf//xdp_sample_pkts_user.o
>   HOSTCC  samples/bpf//ibumad_user.o
>   HOSTCC  samples/bpf//hbm.o
>   CLANG-bpf  samples/bpf//sockex1_kern.o
>   CLANG-bpf  samples/bpf//sockex2_kern.o
>   CLANG-bpf  samples/bpf//sockex3_kern.o
>   CLANG-bpf  samples/bpf//tracex1_kern.o
>   CLANG-bpf  samples/bpf//tracex2_kern.o
>   CLANG-bpf  samples/bpf//tracex3_kern.o
>   CLANG-bpf  samples/bpf//tracex4_kern.o
>   CC      samples/bpf//syscall_nrs.s
>   CLANG-bpf  samples/bpf//tracex6_kern.o
>   CLANG-bpf  samples/bpf//tracex7_kern.o
>   CLANG-bpf  samples/bpf//sock_flags_kern.o
>   CLANG-bpf  samples/bpf//test_probe_write_user_kern.o
>   CLANG-bpf  samples/bpf//trace_output_kern.o
>   CLANG-bpf  samples/bpf//tcbpf1_kern.o
>   CLANG-bpf  samples/bpf//tc_l2_redirect_kern.o
>   CLANG-bpf  samples/bpf//lathist_kern.o
>   CLANG-bpf  samples/bpf//offwaketime_kern.o
>   CLANG-bpf  samples/bpf//spintest_kern.o
>   CLANG-bpf  samples/bpf//map_perf_test_kern.o
>   CLANG-bpf  samples/bpf//test_overhead_tp_kern.o
>   CLANG-bpf  samples/bpf//test_overhead_raw_tp_kern.o
>   CLANG-bpf  samples/bpf//test_overhead_kprobe_kern.o
>   CLANG-bpf  samples/bpf//parse_varlen.o
>   CLANG-bpf  samples/bpf//parse_simple.o
>   CLANG-bpf  samples/bpf//parse_ldabs.o
>   CLANG-bpf  samples/bpf//test_cgrp2_tc_kern.o
>   CLANG-bpf  samples/bpf//xdp1_kern.o
>   CLANG-bpf  samples/bpf//xdp2_kern.o
>   CLANG-bpf  samples/bpf//xdp_router_ipv4_kern.o
>   CLANG-bpf  samples/bpf//test_current_task_under_cgroup_kern.o
>   CLANG-bpf  samples/bpf//trace_event_kern.o
>   CLANG-bpf  samples/bpf//sampleip_kern.o
>   CLANG-bpf  samples/bpf//lwt_len_hist_kern.o
>   CLANG-bpf  samples/bpf//xdp_tx_iptunnel_kern.o
>   CLANG-bpf  samples/bpf//test_map_in_map_kern.o
>   CLANG-bpf  samples/bpf//tcp_synrto_kern.o
>   CLANG-bpf  samples/bpf//tcp_rwnd_kern.o
>   CLANG-bpf  samples/bpf//tcp_bufs_kern.o
>   CLANG-bpf  samples/bpf//tcp_cong_kern.o
>   CLANG-bpf  samples/bpf//tcp_iw_kern.o
>   CLANG-bpf  samples/bpf//tcp_clamp_kern.o
>   CLANG-bpf  samples/bpf//tcp_basertt_kern.o
>   CLANG-bpf  samples/bpf//tcp_tos_reflect_kern.o
>   CLANG-bpf  samples/bpf//tcp_dumpstats_kern.o
>   CLANG-bpf  samples/bpf//xdp_redirect_kern.o
>   CLANG-bpf  samples/bpf//xdp_redirect_map_kern.o
>   CLANG-bpf  samples/bpf//xdp_redirect_cpu_kern.o
>   CLANG-bpf  samples/bpf//xdp_monitor_kern.o
>   CLANG-bpf  samples/bpf//xdp_rxq_info_kern.o
>   CLANG-bpf  samples/bpf//xdp2skb_meta_kern.o
>   CLANG-bpf  samples/bpf//syscall_tp_kern.o
>   CLANG-bpf  samples/bpf//cpustat_kern.o
>   CLANG-bpf  samples/bpf//xdp_adjust_tail_kern.o
>   CLANG-bpf  samples/bpf//xdp_fwd_kern.o
>   CLANG-bpf  samples/bpf//task_fd_query_kern.o
>   CLANG-bpf  samples/bpf//xdp_sample_pkts_kern.o
>   CLANG-bpf  samples/bpf//ibumad_kern.o
>   CLANG-bpf  samples/bpf//hbm_out_kern.o
>   CLANG-bpf  samples/bpf//hbm_edt_kern.o
>   HOSTLD  samples/bpf//fds_example
>   HOSTLD  samples/bpf//sockex1
>   HOSTLD  samples/bpf//sockex2
>   HOSTLD  samples/bpf//sockex3
>   HOSTLD  samples/bpf//tracex1
>   HOSTLD  samples/bpf//tracex2
>   HOSTLD  samples/bpf//tracex3
>   HOSTLD  samples/bpf//tracex4
>   HOSTLD  samples/bpf//tracex5
>   HOSTLD  samples/bpf//tracex6
>   HOSTLD  samples/bpf//tracex7
>   HOSTLD  samples/bpf//test_probe_write_user
>   HOSTLD  samples/bpf//trace_output
>   HOSTLD  samples/bpf//lathist
>   HOSTLD  samples/bpf//offwaketime
>   HOSTLD  samples/bpf//spintest
>   HOSTLD  samples/bpf//map_perf_test
>   HOSTLD  samples/bpf//test_overhead
>   HOSTLD  samples/bpf//test_cgrp2_array_pin
>   HOSTLD  samples/bpf//test_cgrp2_attach
>   HOSTLD  samples/bpf//test_cgrp2_sock
>   HOSTLD  samples/bpf//test_cgrp2_sock2
>   HOSTLD  samples/bpf//xdp_router_ipv4
>   HOSTLD  samples/bpf//test_current_task_under_cgroup
>   HOSTLD  samples/bpf//trace_event
>   HOSTLD  samples/bpf//sampleip
>   HOSTLD  samples/bpf//tc_l2_redirect
>   HOSTLD  samples/bpf//lwt_len_hist
>   HOSTLD  samples/bpf//xdp_tx_iptunnel
>   HOSTLD  samples/bpf//test_map_in_map
>   HOSTLD  samples/bpf//xdp_redirect
>   HOSTLD  samples/bpf//xdp_redirect_map
>   HOSTLD  samples/bpf//xdp_redirect_cpu
>   HOSTLD  samples/bpf//xdp_monitor
>   HOSTLD  samples/bpf//xdp_rxq_info
>   HOSTLD  samples/bpf//syscall_tp
>   HOSTLD  samples/bpf//cpustat
>   HOSTLD  samples/bpf//xdp_adjust_tail
>   HOSTLD  samples/bpf//xdpsock
>   HOSTLD  samples/bpf//xdp_fwd
>   HOSTLD  samples/bpf//task_fd_query
>   HOSTLD  samples/bpf//xdp_sample_pkts
>   HOSTLD  samples/bpf//ibumad
>   HOSTLD  samples/bpf//hbm
>   UPD     samples/bpf//syscall_nrs.h
>   CLANG-bpf  samples/bpf//tracex5_kern.o
>   Building modules, stage 2.
>   MODPOST 0 modules
> root@foo1:~/bpf#

-- 

- Arnaldo
