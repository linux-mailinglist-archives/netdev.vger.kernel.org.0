Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70E954FEC6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383565AbiFQUjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383623AbiFQUjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:39:43 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0569969CF3;
        Fri, 17 Jun 2022 13:36:34 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2IhL-0001TO-Tf; Fri, 17 Jun 2022 22:36:07 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2IhL-000P9I-Hn; Fri, 17 Jun 2022 22:36:07 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: add lwt ip encap tests to
 test_progs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, posk@google.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220607133135.271788-1-eyal.birger@gmail.com>
 <f80edf4f-c795-1e1e-bac2-414189988156@iogearbox.net>
 <CAHsH6GvWkyDg5mXnSNoyY0H2V2i4iMsucydB=RZB100czc-85A@mail.gmail.com>
 <CAEf4BzYMqXZ6H-Mv=xSvRTJ0o8okrLQjVVYzgpG1D-8+3HNj1w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <588753e1-0a05-8d74-23f2-24fd7e9888ad@iogearbox.net>
Date:   Fri, 17 Jun 2022 22:36:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYMqXZ6H-Mv=xSvRTJ0o8okrLQjVVYzgpG1D-8+3HNj1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26575/Fri Jun 17 10:08:05 2022)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

On 6/16/22 1:31 AM, Andrii Nakryiko wrote:
[...]
>> What's the next step - should I submit a PR to libbpf on Github for adding
>> CONFIG_NET_VRF?
> 
> Yes, please, for [0] and [1]:
> 
>   [0] https://github.com/libbpf/libbpf
>   [1] https://github.com/kernel-patches/vmtest

Thanks a lot for getting the needed configs in.

The CI looks better now, but there is one small failure on s390 (big endian):

   https://github.com/kernel-patches/bpf/runs/6932751303?check_suite_focus=true

These:

1) "Failed to cycle device vethX; route tables might be wrong!" is this expected?
2) test_gso:FAIL:recv from server unexpected recv from server: actual 7140 != expected 9000

Please take a look and fix in a v2 when you get a chance.

I'm pasting the full log just in case:

   [...]
   #97      lookup_and_delete:OK
   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   veth3: Failed to cycle device veth3; route tables might be wrong!

   veth7: Failed to cycle device veth7; route tables might be wrong!

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   veth3: Failed to cycle device veth3; route tables might be wrong!

   veth7: Failed to cycle device veth7; route tables might be wrong!

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   veth3: Failed to cycle device veth3; route tables might be wrong!

   veth7: Failed to cycle device veth7; route tables might be wrong!

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   veth3: Failed to cycle device veth3; route tables might be wrong!

   veth7: Failed to cycle device veth7; route tables might be wrong!

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth6: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth5: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth2: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth4: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth8: link becomes ready

   IPv6: ADDRCONF(NETDEV_CHANGE): veth7: link becomes ready

   serial_test_lwt_ip_encap:PASS:pthread_create 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_3 0 nsec
   lwt_ip_encap_test:PASS:setup namespaces 0 nsec
   setup_links_and_routes:PASS:ip link add veth1 netns ns_lwt_1 type veth peer name veth2 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth3 netns ns_lwt_2 type veth peer name veth4 netns ns_lwt_3 0 nsec
   setup_links_and_routes:PASS:ip link add veth5 netns ns_lwt_1 type veth peer name veth6 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth7 netns ns_lwt_2 type veth peer name veth8 netns ns_lwt_3 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_ns1:PASS:ip link add gre_md type gre external 0 nsec
   setup_ns1:PASS:ip link add gre6_md type ip6gre external 0 nsec
   setup_device:PASS:ip addr add 172.16.1.100/24 dev veth1 0 nsec
   setup_device:PASS:ip -6 addr add fb01::1/128 nodad dev veth1 0 nsec
   setup_device:PASS:ip link set dev veth1 up 0 nsec
   setup_device:PASS:ip addr add 172.16.5.100/24 dev veth5 0 nsec
   setup_device:PASS:ip -6 addr add fb05::1/128 nodad dev veth5 0 nsec
   setup_device:PASS:ip link set dev veth5 up 0 nsec
   setup_device:PASS:ip addr add 172.16.1.100/24 dev gre_md 0 nsec
   setup_device:PASS:ip -6 addr add fb01::1/128 nodad dev gre_md 0 nsec
   setup_device:PASS:ip link set dev gre_md up 0 nsec
   setup_device:PASS:ip addr add 172.16.1.100/24 dev gre6_md 0 nsec
   setup_device:PASS:ip -6 addr add fb01::1/128 nodad dev gre6_md 0 nsec
   setup_device:PASS:ip link set dev gre6_md up 0 nsec
   setup_ns1:PASS:ip   route add  172.16.2.100/32 dev veth1 0 nsec
   setup_ns1:PASS:ip  -6 route add  fb02::1/128 dev veth1 0 nsec
   setup_ns1:PASS:ip   route add  default dev veth1 via 172.16.2.100 0 nsec
   setup_ns1:PASS:ip  -6 route add  default dev veth1 via fb02::1 0 nsec
   setup_ns1:PASS:ip   route add  172.16.6.100/32 dev veth5 0 nsec
   setup_ns1:PASS:ip   route add  172.16.7.100/32 dev veth5 via 172.16.6.100 0 nsec
   setup_ns1:PASS:ip   route add  172.16.8.100/32 dev veth5 via 172.16.6.100 0 nsec
   setup_ns1:PASS:ip  -6 route add  fb06::1/128 dev veth5 0 nsec
   setup_ns1:PASS:ip  -6 route add  fb07::1/128 dev veth5 via fb06::1 0 nsec
   setup_ns1:PASS:ip  -6 route add  fb08::1/128 dev veth5 via fb06::1 0 nsec
   setup_ns1:PASS:ip   route add  172.16.16.100/32 dev veth5 via 172.16.6.100 0 nsec
   setup_ns1:PASS:ip  -6 route add  fb10::1/128 dev veth5 via fb06::1 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_device:PASS:ip addr add 172.16.2.100/24 dev veth2 0 nsec
   setup_device:PASS:ip -6 addr add fb02::1/128 nodad dev veth2 0 nsec
   setup_device:PASS:ip link set dev veth2 up 0 nsec
   setup_device:PASS:ip addr add 172.16.3.100/24 dev veth3 0 nsec
   setup_device:PASS:ip -6 addr add fb03::1/128 nodad dev veth3 0 nsec
   setup_device:PASS:ip link set dev veth3 up 0 nsec
   setup_device:PASS:ip addr add 172.16.6.100/24 dev veth6 0 nsec
   setup_device:PASS:ip -6 addr add fb06::1/128 nodad dev veth6 0 nsec
   setup_device:PASS:ip link set dev veth6 up 0 nsec
   setup_device:PASS:ip addr add 172.16.7.100/24 dev veth7 0 nsec
   setup_device:PASS:ip -6 addr add fb07::1/128 nodad dev veth7 0 nsec
   setup_device:PASS:ip link set dev veth7 up 0 nsec
   setup_ns2:PASS:ip   route add  172.16.1.100/32 dev veth2 0 nsec
   setup_ns2:PASS:ip   route add  172.16.4.100/32 dev veth3 0 nsec
   setup_ns2:PASS:ip  -6 route add  fb01::1/128 dev veth2 0 nsec
   setup_ns2:PASS:ip  -6 route add  fb04::1/128 dev veth3 0 nsec
   setup_ns2:PASS:ip   route add  172.16.5.100/32 dev veth6 0 nsec
   setup_ns2:PASS:ip   route add  172.16.8.100/32 dev veth7 0 nsec
   setup_ns2:PASS:ip  -6 route add  fb05::1/128 dev veth6 0 nsec
   setup_ns2:PASS:ip  -6 route add  fb08::1/128 dev veth7 0 nsec
   setup_ns2:PASS:ip   route add  172.16.16.100/32 dev veth7 via 172.16.8.100 0 nsec
   setup_ns2:PASS:ip  -6 route add  fb10::1/128 dev veth7 via fb08::1 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_device:PASS:ip addr add 172.16.4.100/24 dev veth4 0 nsec
   setup_device:PASS:ip -6 addr add fb04::1/128 nodad dev veth4 0 nsec
   setup_device:PASS:ip link set dev veth4 up 0 nsec
   setup_device:PASS:ip addr add 172.16.8.100/24 dev veth8 0 nsec
   setup_device:PASS:ip -6 addr add fb08::1/128 nodad dev veth8 0 nsec
   setup_device:PASS:ip link set dev veth8 up 0 nsec
   setup_ns3:PASS:ip   route add  172.16.3.100/32 dev veth4 0 nsec
   setup_ns3:PASS:ip   route add  172.16.1.100/32 dev veth4 via 172.16.3.100 0 nsec
   setup_ns3:PASS:ip   route add  172.16.2.100/32 dev veth4 via 172.16.3.100 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb03::1/128 dev veth4 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb01::1/128 dev veth4 via fb03::1 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb02::1/128 dev veth4 via fb03::1 0 nsec
   setup_ns3:PASS:ip   route add  172.16.7.100/32 dev veth8 0 nsec
   setup_ns3:PASS:ip   route add  172.16.5.100/32 dev veth8 via 172.16.7.100 0 nsec
   setup_ns3:PASS:ip   route add  172.16.6.100/32 dev veth8 via 172.16.7.100 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb07::1/128 dev veth8 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb05::1/128 dev veth8 via fb07::1 0 nsec
   setup_ns3:PASS:ip  -6 route add  fb06::1/128 dev veth8 via fb07::1 0 nsec
   setup_ns3:PASS:ip tunnel add gre_dev mode gre remote 172.16.5.100 local 172.16.16.100 ttl 255 key 0 0 nsec
   setup_device:PASS:ip addr add 172.16.16.100/24 dev gre_dev 0 nsec
   setup_device:PASS:ip link set dev gre_dev up 0 nsec
   setup_ns3:PASS:ip tunnel add gre6_dev mode ip6gre remote fb05::1 local fb10::1 ttl 255 key 0 0 nsec
   setup_device:PASS:ip -6 addr add fb10::1/128 nodad dev gre6_dev 0 nsec
   setup_device:PASS:ip link set dev gre6_dev up 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   lwt_ip_encap_test:PASS:setup links and routes 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping -c 1 -W 1 -I veth1 172.16.4.100 > /dev/null 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping6 -c 1 -W 1 -I veth1 fb04::1 > /dev/null 0 nsec
   lwt_ip_encap_test:PASS:ip -netns ns_lwt_2  route del  172.16.4.100/32 dev veth3 0 nsec
   lwt_ip_encap_test:PASS:ip -netns ns_lwt_2 -6 route del  fb04::1/128 dev veth3 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping -c 1 -W 1 -I veth1 172.16.4.100 > /dev/null 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping6 -c 1 -W 1 -I veth1 fb04::1 > /dev/null 0 nsec
   lwt_ip_encap_test:PASS:ip -netns ns_lwt_1  route add  172.16.4.100/32 encap bpf xmit obj test_lwt_ip_encap.o sec encap_gre dev veth1 0 nsec
   lwt_ip_encap_test:PASS:ip -netns ns_lwt_1 -6 route add  fb04::1/128 encap bpf xmit obj test_lwt_ip_encap.o sec encap_gre dev veth1 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping -c 1 -W 1 -I veth1 172.16.4.100 > /dev/null 0 nsec
   test_ping:PASS:ip netns exec ns_lwt_1 ping6 -c 1 -W 1 -I veth1 fb04::1 > /dev/null 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   test_gso:PASS:setns 0 nsec
   test_gso:PASS:listen 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   test_gso:PASS:setns src 0 nsec
   test_gso:PASS:connect_to_fd 0 nsec
   test_gso:PASS:accept 0 nsec
   test_gso:PASS:settimeo 0 nsec
   test_gso:PASS:send to server 0 nsec
   test_gso:PASS:recv from server 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   test_gso:PASS:setns 0 nsec
   test_gso:PASS:listen 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   test_gso:PASS:setns src 0 nsec
   test_gso:PASS:connect_to_fd 0 nsec
   test_gso:PASS:accept 0 nsec
   test_gso:PASS:settimeo 0 nsec
   test_gso:PASS:send to server 0 nsec
   test_gso:FAIL:recv from server unexpected recv from server: actual 7140 != expected 9000
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   remove_routes_to_gredev:PASS:ip -netns ns_lwt_1  route del  172.16.16.100/32 dev veth5 0 nsec
   remove_routes_to_gredev:PASS:ip -netns ns_lwt_1 -6 route del  fb10::1/128 dev veth5 0 nsec
   remove_routes_to_gredev:PASS:ip -netns ns_lwt_2  route del  172.16.16.100/32 dev veth7 0 nsec
   remove_routes_to_gredev:PASS:ip -netns ns_lwt_2 -6 route del  fb10::1/128 dev veth7 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_3 0 nsec
   #98/1    lwt_ip_encap/lwt_ipv4_encap_egress:FAIL
   #98/2    lwt_ip_encap/lwt_ipv6_encap_egress:OK
   #98/3    lwt_ip_encap/lwt_ipv4_encap_egress_vrf:OK
   #98/4    lwt_ip_encap/lwt_ipv6_encap_egress_vrf:OK
   #98/5    lwt_ip_encap/lwt_ipv4_encap_ingress:OK
   #98/6    lwt_ip_encap/lwt_ipv6_encap_ingress:OK
   #98/7    lwt_ip_encap/lwt_ipv4_encap_ingress_vrf:OK
   #98/8    lwt_ip_encap/lwt_ipv6_encap_ingress_vrf:OK
   #98/9    lwt_ip_encap/lwt_ipv4_encap_egress_md:OK
   #98/10   lwt_ip_encap/lwt_ipv6_encap_egress_md:OK
   #98      lwt_ip_encap:FAIL
   [...]

Thanks,
Daniel
