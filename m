Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8538B253C1
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbfEUPU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:20:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:58986 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbfEUPU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:20:58 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6ZI-0005PY-5V; Tue, 21 May 2019 17:20:44 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6ZH-000SWf-Tp; Tue, 21 May 2019 17:20:44 +0200
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Matteo Croce <mcroce@redhat.com>
Cc:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20190518004639.20648-1-mcroce@redhat.com>
 <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
 <20190520133830.1ac11fc8@cakuba.netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dfb6cf40-81f4-237e-9a43-646077e020f7@iogearbox.net>
Date:   Tue, 21 May 2019 17:20:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190520133830.1ac11fc8@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/20/2019 10:38 PM, Jakub Kicinski wrote:
> On Mon, 20 May 2019 19:46:27 +0200, Matteo Croce wrote:
>> On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
>>>
>>> Fix the following error by removing a duplicate struct definition:
>>
>> Hi all,
>>
>> I forget to send a cover letter for this series, but basically what I
>> wanted to say is that while patches 1-3 are very straightforward,
>> patches 4-5 are a bit rough and I accept suggstions to make a cleaner
>> work.
> 
> samples depend on headers being locally installed:
> 
> make headers_install
> 
> Are you intending to change that?

+1, Matteo, could you elaborate?

On latest bpf tree, everything compiles just fine:

[root@linux bpf]# make headers_install
[root@linux bpf]# make -C samples/bpf/
make: Entering directory '/home/darkstar/trees/bpf/samples/bpf'
make -C ../../ /home/darkstar/trees/bpf/samples/bpf/ BPF_SAMPLES_PATH=/home/darkstar/trees/bpf/samples/bpf
make[1]: Entering directory '/home/darkstar/trees/bpf'
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
make -C /home/darkstar/trees/bpf/samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=/home/darkstar/trees/bpf/samples/bpf/../../ O=
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_lru_dist
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sock_example
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/fds_example.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/fds_example
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sockex1_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/sockex1
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sockex2_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/sockex2
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/bpf_load.o
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sockex3_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/sockex3
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex1_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex1
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex2_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex2
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex3_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex3
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex4_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex4
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex5_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex5
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex6_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex6
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tracex7_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tracex7
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_probe_write_user_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_probe_write_user
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/trace_output_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/trace_output
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/lathist_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/lathist
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/offwaketime_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/offwaketime
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/spintest_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/spintest
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/map_perf_test_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/map_perf_test
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_overhead_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_overhead
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_array_pin.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_array_pin
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_attach.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_attach
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_attach2.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_attach2
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_sock.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_sock
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_sock2.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_sock2
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp1_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp1
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp2
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_router_ipv4_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_router_ipv4
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_current_task_under_cgroup_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_current_task_under_cgroup
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/trace_event_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/trace_event
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sampleip_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/sampleip
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/tc_l2_redirect_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/tc_l2_redirect
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/lwt_len_hist_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/lwt_len_hist
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_tx_iptunnel_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_tx_iptunnel
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_map_in_map_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/test_map_in_map
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/cookie_uid_helper_example.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/per_socket_stats_example
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_map_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_map
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_cpu_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_cpu
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_monitor_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_monitor
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_rxq_info_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_rxq_info
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/syscall_tp_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/syscall_tp
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/cpustat_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/cpustat
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_adjust_tail_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_adjust_tail
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdpsock_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdpsock
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_fwd_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_fwd
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/task_fd_query_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/task_fd_query
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/xdp_sample_pkts_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/xdp_sample_pkts
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/ibumad_user.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/ibumad
  HOSTCC  /home/darkstar/trees/bpf/samples/bpf/hbm.o
  HOSTLD  /home/darkstar/trees/bpf/samples/bpf/hbm
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/sockex1_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/sockex1_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/sockex2_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/sockex2_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/sockex3_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/sockex3_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex1_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex1_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex2_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex2_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex3_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex3_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex4_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex4_kern.o
  CC      /home/darkstar/trees/bpf/samples/bpf/syscall_nrs.s
  UPD     /home/darkstar/trees/bpf/samples/bpf/syscall_nrs.h
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex5_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex5_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex6_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex6_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tracex7_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tracex7_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/sock_flags_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/sock_flags_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_probe_write_user_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_probe_write_user_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/trace_output_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/trace_output_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcbpf1_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcbpf1_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tc_l2_redirect_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tc_l2_redirect_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/lathist_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/lathist_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/offwaketime_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/offwaketime_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/spintest_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/spintest_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/map_perf_test_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/map_perf_test_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_overhead_tp_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_overhead_tp_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_overhead_raw_tp_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_overhead_raw_tp_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_overhead_kprobe_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_overhead_kprobe_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/parse_varlen.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/parse_varlen.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/parse_simple.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/parse_simple.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/parse_ldabs.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/parse_ldabs.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_tc_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_cgrp2_tc_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp1_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp1_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp2_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp2_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_router_ipv4_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_router_ipv4_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_current_task_under_cgroup_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_current_task_under_cgroup_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/trace_event_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/trace_event_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/sampleip_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/sampleip_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/lwt_len_hist_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/lwt_len_hist_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_tx_iptunnel_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_tx_iptunnel_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/test_map_in_map_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/test_map_in_map_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_synrto_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_synrto_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_rwnd_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_rwnd_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_bufs_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_bufs_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_cong_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_cong_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_iw_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_iw_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_clamp_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_clamp_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_basertt_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_basertt_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/tcp_tos_reflect_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/tcp_tos_reflect_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_map_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_map_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_cpu_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_redirect_cpu_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_monitor_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_monitor_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_rxq_info_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_rxq_info_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp2skb_meta_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp2skb_meta_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/syscall_tp_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/syscall_tp_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/cpustat_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/cpustat_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_adjust_tail_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_adjust_tail_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_fwd_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_fwd_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/task_fd_query_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/task_fd_query_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/xdp_sample_pkts_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/xdp_sample_pkts_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/ibumad_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/ibumad_kern.o
  CLANG-bpf  /home/darkstar/trees/bpf/samples/bpf/hbm_out_kern.o
pahole -J /home/darkstar/trees/bpf/samples/bpf/hbm_out_kern.o
make[1]: Leaving directory '/home/darkstar/trees/bpf'
make: Leaving directory '/home/darkstar/trees/bpf/samples/bpf'
[root@linux bpf]#
