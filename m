Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71F2C09DA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbgKWNNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:13:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388498AbgKWNNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606137198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v4BfPNpfcJFVcy9T8T8avAv+N6xXpBHvxOtSVoygJe8=;
        b=CplmTs8sOirrc0blcovIx7tjxlyjcfKPb1SfxEeOzCIn5iIC3EQY+sZbYbvj1YxzTXpxIb
        qqwRcCj2l/uotkl79EHpFXPcCT0U3ry0MquCJYsv1Dc/wZefv4gDQKlZGa6OsmXjnydmLs
        GSKUTjTO8bh3h87xpEpFQTZ9xD2To6k=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-cvfTxuN2POuTO_ppYzt61A-1; Mon, 23 Nov 2020 08:13:16 -0500
X-MC-Unique: cvfTxuN2POuTO_ppYzt61A-1
Received: by mail-pl1-f199.google.com with SMTP id b4so2931242plk.17
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4BfPNpfcJFVcy9T8T8avAv+N6xXpBHvxOtSVoygJe8=;
        b=LusUAAWJrhPzKExYC8bjYO09CfWIpF10DHhT0Aq0odwnEBAC30Bl8txdo9m6/EX2vh
         3uq3QbIhzq7WUwcknks2T6TwtmRISBoV5hyf3ianp1K0O3fwWmEbK/pl4DKckx3KyEN9
         wb68SBwYC82jnaWsiCAalVGWg6GdfkmVIT0nEGNzAgICX8PeCoCgBv+wE9zgLsrb7SWa
         cxrpzf+6HSqMkk+CUe165wE2QnBjNZXX2AuCtiwEWu1dplPUraFJFlQKZnL9qBu4Rz6h
         p3Re2p283mRfIHE818au/9DPCOpDHB+wvzkTZXGyxE3TVXQARqFqHY+LTkJ81h5uRUj/
         U5Hw==
X-Gm-Message-State: AOAM531id2JJ3xkWZKWcA+PlvVkJkQhuJgTz7GPEPzJP6G/g0zJO1Et/
        L533RhSfpioHxL8NPcMAjben1Pf1sxWl1O3TXdU+0ztMt4trrUsmosMyLcIaQOl7Tls2pBh20y4
        BLtQRO0rtUE2PApY=
X-Received: by 2002:a17:902:b7c2:b029:d9:c8f:e06b with SMTP id v2-20020a170902b7c2b02900d90c8fe06bmr23722727plz.29.1606137194846;
        Mon, 23 Nov 2020 05:13:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywRULSwjG+Lnymeh7CH79HLiuWwk951kl0xl8Mvmb1o5zr72X/0xLCMIdbR/mUA7jCt0eSOg==
X-Received: by 2002:a17:902:b7c2:b029:d9:c8f:e06b with SMTP id v2-20020a170902b7c2b02900d90c8fe06bmr23722697plz.29.1606137194447;
        Mon, 23 Nov 2020 05:13:14 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 84sm12075505pfu.53.2020.11.23.05.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:13:13 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv6 iproute2-next 0/5] iproute2: add libbpf support
Date:   Mon, 23 Nov 2020 21:11:56 +0800
Message-Id: <20201123131201.4108483-1-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201116065305.1010651-1-haliu@redhat.com>
References: <20201116065305.1010651-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts iproute2 to use libbpf for loading and attaching
BPF programs when it is available. This means that iproute2 will
correctly process BTF information and support the new-style BTF-defined
maps, while keeping compatibility with the old internal map definition
syntax.

This is achieved by checking for libbpf at './configure' time, and using
it if available. By default the system libbpf will be used, but static
linking against a custom libbpf version can be achieved by passing
LIBBPF_DIR to configure. LIBBPF_FORCE can be set to on to force configure
abort if no suitable libbpf is found (useful for automatic packaging
that wants to enforce the dependency), or set off to disable libbpf check
and build iproute2 with legacy bpf.

The old iproute2 bpf code is kept and will be used if no suitable libbpf
is available. When using libbpf, wrapper code ensures that iproute2 will
still understand the old map definition format, including populating
map-in-map and tail call maps before load.

The examples in bpf/examples are kept, and a separate set of examples
are added with BTF-based map definitions for those examples where this
is possible (libbpf doesn't currently support declaratively populating
tail call maps).

At last, Thanks a lot for Toke's help on this patch set.

v6:
a) print runtime libbpf version in ip -V and tc -V

v5:
a) Fix LIBBPF_DIR typo and description, use libbpf DESTDIR as LIBBPF_DIR
   dest.
b) Fix bpf_prog_load_dev typo.
c) rebase to latest iproute2-next.

v4:
a) Make variable LIBBPF_FORCE able to control whether build iproute2
   with libbpf or not.
b) Add new file bpf_glue.c to for libbpf/legacy mixed bpf calls.
c) Fix some build issues and shell compatibility error.

v3:
a) Update configure to Check function bpf_program__section_name() separately
b) Add a new function get_bpf_program__section_name() to choose whether to
use bpf_program__title() or not.
c) Test build the patch on Fedora 33 with libbpf-0.1.0-1.fc33 and
   libbpf-devel-0.1.0-1.fc33

v2:
a) Remove self defined IS_ERR_OR_NULL and use libbpf_get_error() instead.
b) Add ipvrf with libbpf support.


Here are the test results with patched iproute2:
== Show libbpf version
# ip -V
ip utility, iproute2-5.9.0, libbpf 0.1.0
# tc -V
tc utility, iproute2-5.9.0, libbpf 0.1.0

== setup env
# clang -O2 -Wall -g -target bpf -c bpf_graft.c -o btf_graft.o
# clang -O2 -Wall -g -target bpf -c bpf_map_in_map.c -o btf_map_in_map.o
# clang -O2 -Wall -g -target bpf -c bpf_shared.c -o btf_shared.o
# clang -O2 -Wall -g -target bpf -c legacy/bpf_cyclic.c -o bpf_cyclic.o
# clang -O2 -Wall -g -target bpf -c legacy/bpf_graft.c -o bpf_graft.o
# clang -O2 -Wall -g -target bpf -c legacy/bpf_map_in_map.c -o bpf_map_in_map.o
# clang -O2 -Wall -g -target bpf -c legacy/bpf_shared.c -o bpf_shared.o
# clang -O2 -Wall -g -target bpf -c legacy/bpf_tailcall.c -o bpf_tailcall.o
# rm -rf /sys/fs/bpf/xdp/globals
# /root/iproute2/ip/ip link add type veth
# /root/iproute2/ip/ip link set veth0 up
# /root/iproute2/ip/ip link set veth1 up


== Load objs
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_graft.o sec aaa
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 4 tag 3056d2382e53f27c jited
# ls /sys/fs/bpf/xdp/globals
jmp_tc
# bpftool map show
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
4: xdp  name cls_aaa  tag 3056d2382e53f27c  gpl
        loaded_at 2020-10-22T08:04:21-0400  uid 0
        xlated 80B  jited 71B  memlock 4096B
        btf_id 5
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_map_in_map.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 8 tag 4420e72b2a601ed7 jited
# ls /sys/fs/bpf/xdp/globals
jmp_tc  map_inner  map_outer
# bpftool map show
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
2: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
3: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
8: xdp  name imain  tag 4420e72b2a601ed7  gpl
        loaded_at 2020-10-22T08:04:23-0400  uid 0
        xlated 336B  jited 193B  memlock 4096B  map_ids 3
        btf_id 10
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_shared.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 12 tag 9cbab549c3af3eab jited
# ls /sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef /sys/fs/bpf/xdp/globals
/sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef:
map_sh

/sys/fs/bpf/xdp/globals:
jmp_tc  map_inner  map_outer
# bpftool map show
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
2: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
3: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
4: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
12: xdp  name imain  tag 9cbab549c3af3eab  gpl
        loaded_at 2020-10-22T08:04:25-0400  uid 0
        xlated 224B  jited 139B  memlock 4096B  map_ids 4
        btf_id 15
# /root/iproute2/ip/ip link set veth0 xdp off


== Load objs again to make sure maps could be reused
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_graft.o sec aaa
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 16 tag 3056d2382e53f27c jited
# ls /sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef /sys/fs/bpf/xdp/globals
/sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef:
map_sh

/sys/fs/bpf/xdp/globals:
jmp_tc  map_inner  map_outer
# bpftool map show
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
2: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
3: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
4: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
16: xdp  name cls_aaa  tag 3056d2382e53f27c  gpl
        loaded_at 2020-10-22T08:04:27-0400  uid 0
        xlated 80B  jited 71B  memlock 4096B
        btf_id 20
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_map_in_map.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 20 tag 4420e72b2a601ed7 jited
# ls /sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef /sys/fs/bpf/xdp/globals
/sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef:
map_sh

/sys/fs/bpf/xdp/globals:
jmp_tc  map_inner  map_outer
# bpftool map show                                                                                                                                                                   [236/4518]
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
2: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
3: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
4: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
20: xdp  name imain  tag 4420e72b2a601ed7  gpl
        loaded_at 2020-10-22T08:04:29-0400  uid 0
        xlated 336B  jited 193B  memlock 4096B  map_ids 3
        btf_id 25
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj bpf_shared.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 24 tag 9cbab549c3af3eab jited
# ls /sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef /sys/fs/bpf/xdp/globals
/sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef:
map_sh

/sys/fs/bpf/xdp/globals:
jmp_tc  map_inner  map_outer
# bpftool map show
1: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
2: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
3: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
4: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
24: xdp  name imain  tag 9cbab549c3af3eab  gpl
        loaded_at 2020-10-22T08:04:31-0400  uid 0
        xlated 224B  jited 139B  memlock 4096B  map_ids 4
        btf_id 30
# /root/iproute2/ip/ip link set veth0 xdp off
# rm -rf /sys/fs/bpf/xdp/7a1422e90cd81478f97bc33fbd7782bcb3b868ef /sys/fs/bpf/xdp/globals

== Testing if we can load new-style objects (using xdp-filter as an example)
# /root/iproute2/ip/ip link set veth0 xdp obj /usr/lib64/bpf/xdpfilt_alw_all.o sec xdp_filter
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 28 tag e29eeda1489a6520 jited
# ls /sys/fs/bpf/xdp/globals
filter_ethernet  filter_ipv4  filter_ipv6  filter_ports  xdp_stats_map
# bpftool map show
5: percpu_array  name xdp_stats_map  flags 0x0
        key 4B  value 16B  max_entries 5  memlock 4096B
        btf_id 35
6: percpu_array  name filter_ports  flags 0x0
        key 4B  value 8B  max_entries 65536  memlock 1576960B
        btf_id 35
7: percpu_hash  name filter_ipv4  flags 0x0
        key 4B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
8: percpu_hash  name filter_ipv6  flags 0x0
        key 16B  value 8B  max_entries 10000  memlock 1142784B
        btf_id 35
9: percpu_hash  name filter_ethernet  flags 0x0
        key 6B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
# bpftool prog show
28: xdp  name xdpfilt_alw_all  tag e29eeda1489a6520  gpl
        loaded_at 2020-10-22T08:04:33-0400  uid 0
        xlated 2408B  jited 1405B  memlock 4096B  map_ids 9,5,7,8,6
        btf_id 35
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj /usr/lib64/bpf/xdpfilt_alw_ip.o sec xdp_filter
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 32 tag 2f2b9dbfb786a5a2 jited
# ls /sys/fs/bpf/xdp/globals
filter_ethernet  filter_ipv4  filter_ipv6  filter_ports  xdp_stats_map
# bpftool map show
5: percpu_array  name xdp_stats_map  flags 0x0
        key 4B  value 16B  max_entries 5  memlock 4096B
        btf_id 35
6: percpu_array  name filter_ports  flags 0x0
        key 4B  value 8B  max_entries 65536  memlock 1576960B
        btf_id 35
7: percpu_hash  name filter_ipv4  flags 0x0
        key 4B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
8: percpu_hash  name filter_ipv6  flags 0x0
        key 16B  value 8B  max_entries 10000  memlock 1142784B
        btf_id 35
9: percpu_hash  name filter_ethernet  flags 0x0
        key 6B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
# bpftool prog show
32: xdp  name xdpfilt_alw_ip  tag 2f2b9dbfb786a5a2  gpl
        loaded_at 2020-10-22T08:04:35-0400  uid 0
        xlated 1336B  jited 778B  memlock 4096B  map_ids 7,8,5
        btf_id 40
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj /usr/lib64/bpf/xdpfilt_alw_tcp.o sec xdp_filter
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 36 tag 18c1bb25084030bc jited
# ls /sys/fs/bpf/xdp/globals
filter_ethernet  filter_ipv4  filter_ipv6  filter_ports  xdp_stats_map
# bpftool map show
5: percpu_array  name xdp_stats_map  flags 0x0
        key 4B  value 16B  max_entries 5  memlock 4096B
        btf_id 35
6: percpu_array  name filter_ports  flags 0x0
        key 4B  value 8B  max_entries 65536  memlock 1576960B
        btf_id 35
7: percpu_hash  name filter_ipv4  flags 0x0
        key 4B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
8: percpu_hash  name filter_ipv6  flags 0x0
        key 16B  value 8B  max_entries 10000  memlock 1142784B
        btf_id 35
9: percpu_hash  name filter_ethernet  flags 0x0
        key 6B  value 8B  max_entries 10000  memlock 1064960B
        btf_id 35
# bpftool prog show
36: xdp  name xdpfilt_alw_tcp  tag 18c1bb25084030bc  gpl
        loaded_at 2020-10-22T08:04:37-0400  uid 0
        xlated 1128B  jited 690B  memlock 4096B  map_ids 6,5
        btf_id 45
# /root/iproute2/ip/ip link set veth0 xdp off
# rm -rf /sys/fs/bpf/xdp/globals


== Load new btf defined maps
# /root/iproute2/ip/ip link set veth0 xdp obj btf_graft.o sec aaa
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 40 tag 3056d2382e53f27c jited
# ls /sys/fs/bpf/xdp/globals
jmp_tc
# bpftool map show
10: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
40: xdp  name cls_aaa  tag 3056d2382e53f27c  gpl
        loaded_at 2020-10-22T08:04:39-0400  uid 0
        xlated 80B  jited 71B  memlock 4096B
        btf_id 50
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj btf_map_in_map.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 44 tag 4420e72b2a601ed7 jited
# ls /sys/fs/bpf/xdp/globals
jmp_tc  map_outer
# bpftool map show
10: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
11: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
13: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
44: xdp  name imain  tag 4420e72b2a601ed7  gpl
        loaded_at 2020-10-22T08:04:41-0400  uid 0
        xlated 336B  jited 193B  memlock 4096B  map_ids 13
        btf_id 55
# /root/iproute2/ip/ip link set veth0 xdp off
# /root/iproute2/ip/ip link set veth0 xdp obj btf_shared.o sec ingress
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
    prog/xdp id 48 tag 9cbab549c3af3eab jited
# ls /sys/fs/bpf/xdp/globals
jmp_tc  map_outer  map_sh
# bpftool map show
10: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
11: array  name map_inner  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
13: array_of_maps  name map_outer  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
14: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
48: xdp  name imain  tag 9cbab549c3af3eab  gpl
        loaded_at 2020-10-22T08:04:43-0400  uid 0
        xlated 224B  jited 139B  memlock 4096B  map_ids 14
        btf_id 60
# /root/iproute2/ip/ip link set veth0 xdp off
# rm -rf /sys/fs/bpf/xdp/globals


== Test load objs by tc
# /root/iproute2/tc/tc qdisc add dev veth0 ingress
# /root/iproute2/tc/tc filter add dev veth0 ingress bpf da obj bpf_cyclic.o sec 0xabccba/0
# /root/iproute2/tc/tc filter add dev veth0 parent ffff: bpf obj bpf_graft.o
# /root/iproute2/tc/tc filter add dev veth0 ingress bpf da obj bpf_tailcall.o sec 42/0
# /root/iproute2/tc/tc filter add dev veth0 ingress bpf da obj bpf_tailcall.o sec 42/1
# /root/iproute2/tc/tc filter add dev veth0 ingress bpf da obj bpf_tailcall.o sec 43/0
# /root/iproute2/tc/tc filter add dev veth0 ingress bpf da obj bpf_tailcall.o sec classifier
# /root/iproute2/ip/ip link show veth0
5: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:e6:fa:2b:4e:1f brd ff:ff:ff:ff:ff:ff
# ls /sys/fs/bpf/xdp/37e88cb3b9646b2ea5f99ab31069ad88db06e73d /sys/fs/bpf/xdp/fc68fe3e96378a0cba284ea6acbe17e898d8b11f /sys/fs/bpf/xdp/globals
/sys/fs/bpf/xdp/37e88cb3b9646b2ea5f99ab31069ad88db06e73d:
jmp_tc

/sys/fs/bpf/xdp/fc68fe3e96378a0cba284ea6acbe17e898d8b11f:
jmp_ex  jmp_tc  map_sh

/sys/fs/bpf/xdp/globals:
jmp_tc
# bpftool map show
15: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
        owner_prog_type sched_cls  owner jited
16: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
        owner_prog_type sched_cls  owner jited
17: prog_array  name jmp_ex  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
        owner_prog_type sched_cls  owner jited
18: prog_array  name jmp_tc  flags 0x0
        key 4B  value 4B  max_entries 2  memlock 4096B
        owner_prog_type sched_cls  owner jited
19: array  name map_sh  flags 0x0
        key 4B  value 4B  max_entries 1  memlock 4096B
# bpftool prog show
52: sched_cls  name cls_loop  tag 3e98a40b04099d36  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 168B  jited 133B  memlock 4096B  map_ids 15
        btf_id 65
56: sched_cls  name cls_entry  tag 0fbb4d9310a6ee26  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 144B  jited 121B  memlock 4096B  map_ids 16
        btf_id 70
60: sched_cls  name cls_case1  tag e06a3bd62293d65d  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 328B  jited 216B  memlock 4096B  map_ids 19,17
        btf_id 75
66: sched_cls  name cls_case1  tag e06a3bd62293d65d  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 328B  jited 216B  memlock 4096B  map_ids 19,17
        btf_id 80
72: sched_cls  name cls_case1  tag e06a3bd62293d65d  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 328B  jited 216B  memlock 4096B  map_ids 19,17
        btf_id 85
78: sched_cls  name cls_case1  tag e06a3bd62293d65d  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 328B  jited 216B  memlock 4096B  map_ids 19,17
        btf_id 90
79: sched_cls  name cls_case2  tag ee218ff893dca823  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 336B  jited 218B  memlock 4096B  map_ids 19,18
        btf_id 90
80: sched_cls  name cls_exit  tag e78a58140deed387  gpl
        loaded_at 2020-10-22T08:04:45-0400  uid 0
        xlated 288B  jited 177B  memlock 4096B  map_ids 19
        btf_id 90

I also run the following upstream kselftest with patches iproute2 and
all passed.

test_lwt_ip_encap.sh
test_xdp_redirect.sh
test_tc_redirect.sh
test_xdp_meta.sh
test_xdp_veth.sh
test_xdp_vlan.sh


Hangbin Liu (5):
  iproute2: add check_libbpf() and get_libbpf_version()
  lib: make ipvrf able to use libbpf and fix function name conflicts
  lib: add libbpf support
  examples/bpf: move struct bpf_elf_map defined maps to legacy folder
  examples/bpf: add bpf examples with BTF defined maps

 configure                                | 113 ++++++++
 examples/bpf/README                      |  18 +-
 examples/bpf/bpf_graft.c                 |  14 +-
 examples/bpf/bpf_map_in_map.c            |  37 ++-
 examples/bpf/bpf_shared.c                |  14 +-
 examples/bpf/{ => legacy}/bpf_cyclic.c   |   2 +-
 examples/bpf/legacy/bpf_graft.c          |  66 +++++
 examples/bpf/legacy/bpf_map_in_map.c     |  56 ++++
 examples/bpf/legacy/bpf_shared.c         |  53 ++++
 examples/bpf/{ => legacy}/bpf_tailcall.c |   2 +-
 include/bpf_api.h                        |  13 +
 include/bpf_util.h                       |  30 +-
 ip/ip.c                                  |  10 +-
 ip/ipvrf.c                               |   6 +-
 lib/Makefile                             |   8 +-
 lib/bpf_glue.c                           |  86 ++++++
 lib/{bpf.c => bpf_legacy.c}              | 193 ++++++++++++-
 lib/bpf_libbpf.c                         | 348 +++++++++++++++++++++++
 tc/tc.c                                  |  10 +-
 19 files changed, 1017 insertions(+), 62 deletions(-)
 rename examples/bpf/{ => legacy}/bpf_cyclic.c (95%)
 create mode 100644 examples/bpf/legacy/bpf_graft.c
 create mode 100644 examples/bpf/legacy/bpf_map_in_map.c
 create mode 100644 examples/bpf/legacy/bpf_shared.c
 rename examples/bpf/{ => legacy}/bpf_tailcall.c (98%)
 create mode 100644 lib/bpf_glue.c
 rename lib/{bpf.c => bpf_legacy.c} (94%)
 create mode 100644 lib/bpf_libbpf.c

-- 
2.25.4

