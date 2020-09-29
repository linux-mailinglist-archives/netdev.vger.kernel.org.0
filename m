Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6527D491
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgI2Rfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Rfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:35:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508BCC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 10:35:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a9so3047863pjg.1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=191VLtGvYgPEmdDfVGTuPTZ4TGb6WyzsyQHIOZ9CmLI=;
        b=hQm4jQi4In0uA/qCIE7o/X07zROeOAFOqk06QfAPECWS1w2byxxONXDrl7ViN0CtcB
         HZ1AlGeU0xVk6pS9rUOlotOaN0SQ8ny8j7bTAdTPnbUCtzgc6rpMoAeSJ5bAe4uihgtf
         ynX4751VxYwhMTveJeBiDxj3J90y4g8Thek/ySAgH2fWiYOvYuDyebseBtY+EPIXArzN
         CMxsQF5QHy975oMXQ2/LEtifZcNc51fZACz09Brupl4VZPemEmest0VBe8L1vin3ecj2
         j8ZtVOBXhfwR6zVlW2yRiL0G5DsWbVpTyQ5GDSLLzTvxYZaMRoAeDSrMOiEKMZFAMhkG
         gAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=191VLtGvYgPEmdDfVGTuPTZ4TGb6WyzsyQHIOZ9CmLI=;
        b=VVh9Uuka9XXEevsBoMW0jGAB/NfHW6SzMfSchEeXU7c5rU33pjIN3avxHfUWC9vFuz
         7USZktk/8AuM5U0firM5BMms42d/GMwJtf2Uoq+Qxz/9yQ2KM4uSBmlvFyYAHwbfCWeg
         z1T+DI8uvVpTnkGm1MDEJs80LgnlCHEmgBP8zbiW91qGNkDz8lljiFsyrQeVrPrL5cVD
         FrvIzgtcDKP05Wsazs/hD7yuMDUMb7bhIzNwO/S0/RiXiSOkhK1LqInKhJQ16kFDbveh
         /Rf84u7lz6T5k/zJJK9wnsmZhGpcGVe08+N2KHbirCd0cBL4cj/BSNqlQOc1zAlD5Guf
         fW0w==
X-Gm-Message-State: AOAM5317yUQlC40syWGHUUOsNGq7MDHdCyfC7v+FyIplchP3m1Qc7Nlq
        GCPsi90zBp8IM7GqKQTvyIUByI1zxNg4dA==
X-Google-Smtp-Source: ABdhPJz+GJPpZutsvKKEPXgvwDSOgk8DLvQSTqp6RVFfqzgr8ND//YjXVZVM9QDK8KsUY9k74EvmeQ==
X-Received: by 2002:a17:90a:528a:: with SMTP id w10mr4803592pjh.107.1601400940426;
        Tue, 29 Sep 2020 10:35:40 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n7sm5848497pfq.114.2020.09.29.10.35.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:35:40 -0700 (PDT)
Date:   Tue, 29 Sep 2020 10:35:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 209427] New: Incorrect timestamp cause packet to be
 dropped
Message-ID: <20200929103532.0ecbc3b3@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 29 Sep 2020 17:15:23 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209427] New: Incorrect timestamp cause packet to be dropped


https://bugzilla.kernel.org/show_bug.cgi?id=209427

            Bug ID: 209427
           Summary: Incorrect timestamp cause packet to be dropped
           Product: Networking
           Version: 2.5
    Kernel Version: 5.8.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: abt-admin@mail.ru
        Regression: No

After upgrading from my 3.10 to 5.8.10 I found out some of my packets are
getting dropped by ipvlan interface (I'm using qdisk fq). Debugging session led
me to the place where this happens

net/sched/sch_fq.c:464
...
        if (fq_packet_beyond_horizon(skb, q)) {
                if (q->horizon_drop) {
                        q->stat_horizon_drops++;
                        return qdisc_drop(skb, sch, to_free);
                }
                q->stat_horizon_caps++;
                skb->tstamp = q->ktime_cache + q->horizon;
        }
...

then I noticed that in some cases skb->tstamp is equal to real ts whereas in
the regular cases where a packet pass through it's time since kernel boot. This
doesn't make any sense for me as this condition is satisfied constantly

net/sched/sch_fq.c:439
static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
                                    const struct fq_sched_data *q)
{
        return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
}

Any ideas on what it can be?

some outputs:
    [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1081131982. all:
q->ktime_cache 328453964122, skb->tstamp 1601391546982793177 <<
    [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1485308564. all:
q->ktime_cache 334998110463, skb->tstamp 335012588783
    ...
    [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: -1010372082. all:
q->ktime_cache 335873778729, skb->tstamp 335741726080
    [Tue Sep 29 14:59:06 2020] DBG: TIME: trid: 192888327. all: q->ktime_cache
335860696387, skb->tstamp 335870531339
    [Tue Sep 29 14:59:07 2020] DBG: TIME: trid: -1463571809. all:
q->ktime_cache 335305774517, skb->tstamp 1601391548109319017 <<

  perf trace: 
    curl 32613 [014]  1546.957467: skb:kfree_skb: skbaddr=0xffff888f57159ae0
protocol=2048 location=0xffffffff817bfdad
                  9bfd56 kfree_skb (/lib/modules/5.8.10/build/vmlinux)
                  9bfd56 kfree_skb (/lib/modules/5.8.10/build/vmlinux)
                  9bfdad kfree_skb_list (/lib/modules/5.8.10/build/vmlinux)
                  9da2b1 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                    1f39 vlan_dev_open ([8021q])
                  9d9851 dev_hard_start_xmit
(/lib/modules/5.8.10/build/vmlinux)
                  9d9d05 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  9d9d05 __dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  9da380 dev_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  9e32c3 neigh_connected_output
(/lib/modules/5.8.10/build/vmlinux)
                  a68cdb ip_finish_output2 (/lib/modules/5.8.10/build/vmlinux)
                  a69b77 __ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
                  a69cad ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
                  a6b65a ip_output (/lib/modules/5.8.10/build/vmlinux)
                    f2e4 ip_vs_tunnel_xmit ([ip_vs])
                    536a ip_vs_nat_icmp ([ip_vs])
                    5913 ip_vs_out_icmp ([ip_vs])
                    59c6 ip_vs_out_icmp ([ip_vs])
                  a58255 nf_hook_slow (/lib/modules/5.8.10/build/vmlinux)
                  a656f1 ip_local_deliver (/lib/modules/5.8.10/build/vmlinux)
                  a64e07 ip_rcv_finish (/lib/modules/5.8.10/build/vmlinux)
                  b717bb ip_sabotage_in (/lib/modules/5.8.10/build/vmlinux)
                  a58255 nf_hook_slow (/lib/modules/5.8.10/build/vmlinux)
                  a657a0 ip_rcv (/lib/modules/5.8.10/build/vmlinux)
                  9db608 __netif_receive_skb_one_core
(/lib/modules/5.8.10/build/vmlinux)
                  9db658 __netif_receive_skb
(/lib/modules/5.8.10/build/vmlinux)
                  9db6e9 netif_receive_skb (/lib/modules/5.8.10/build/vmlinux)
                  b5c5b6 br_netif_receive_skb
(/lib/modules/5.8.10/build/vmlinux)
                  b5c7d3 br_pass_frame_up (/lib/modules/5.8.10/build/vmlinux)
                  b5c94d br_handle_frame_finish
(/lib/modules/5.8.10/build/vmlinux)
                  b7253b br_nf_hook_thresh (/lib/modules/5.8.10/build/vmlinux)
                  b72fb0 br_nf_pre_routing_finish
(/lib/modules/5.8.10/build/vmlinux)
                  b733bc br_nf_pre_routing (/lib/modules/5.8.10/build/vmlinux)
                  b5cdf1 br_handle_frame (/lib/modules/5.8.10/build/vmlinux)
                  9da8c8 __netif_receive_skb_core
(/lib/modules/5.8.10/build/vmlinux)
                  9db5bf __netif_receive_skb_one_core
(/lib/modules/5.8.10/build/vmlinux)
                  9db658 __netif_receive_skb
(/lib/modules/5.8.10/build/vmlinux)
                  9db8a9 process_backlog (/lib/modules/5.8.10/build/vmlinux)
                  9dd337 net_rx_action (/lib/modules/5.8.10/build/vmlinux)
                  e000e1 __do_softirq (/lib/modules/5.8.10/build/vmlinux)
                  c010c2 asm_call_on_stack (/lib/modules/5.8.10/build/vmlinux)
                  235bef do_softirq_own_stack
(/lib/modules/5.8.10/build/vmlinux)
                  297f86 do_softirq.part.0 (/lib/modules/5.8.10/build/vmlinux)
                  297fe0 __local_bh_enable_ip
(/lib/modules/5.8.10/build/vmlinux)
                  a68cef ip_finish_output2 (/lib/modules/5.8.10/build/vmlinux)
                  a69b77 __ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
                  a69cad ip_finish_output (/lib/modules/5.8.10/build/vmlinux)
                  a6b65a ip_output (/lib/modules/5.8.10/build/vmlinux)
                  a6ad4d ip_local_out (/lib/modules/5.8.10/build/vmlinux)
                  a6b097 __ip_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  a8f740 ip_queue_xmit (/lib/modules/5.8.10/build/vmlinux)
                  a89746 __tcp_transmit_skb (/lib/modules/5.8.10/build/vmlinux)
                  a8a5de tcp_connect (/lib/modules/5.8.10/build/vmlinux)
                  a90f73 tcp_v4_connect (/lib/modules/5.8.10/build/vmlinux)
                  aad59a __inet_stream_connect
(/lib/modules/5.8.10/build/vmlinux)
                  aad88b inet_stream_connect
(/lib/modules/5.8.10/build/vmlinux)
                  9b3e3f __sys_connect_file (/lib/modules/5.8.10/build/vmlinux)
                  9b3ef1 __sys_connect (/lib/modules/5.8.10/build/vmlinux)
                  9b3f3a __x64_sys_connect (/lib/modules/5.8.10/build/vmlinux)
                  b896b2 do_syscall_64 (/lib/modules/5.8.10/build/vmlinux)
                  c0008c entry_SYSCALL_64 (/lib/modules/5.8.10/build/vmlinux)
                   53878 [unknown] (/lib/ld-musl-x86_64.so.1)
                       0 [unknown] ([unknown])
                       0 [unknown] ([unknown])

-- 
You are receiving this mail because:
You are the assignee for the bug.
