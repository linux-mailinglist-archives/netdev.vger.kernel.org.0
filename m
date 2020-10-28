Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7485F29D7F1
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbgJ1W2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387856AbgJ1W2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WHfZOtjSL72eHGoIxPiDYwnS6QN9E2pBSFJLdMT84r0=;
        b=PS1GFzNAleCPob/IKu3gPd+LJxFCUMAmRQzgC+sSbhj2oVqQwCHW0Kpl9w6+ylHrEuQulf
        IG7W0/oeS34gPukmveWJtSTjaXGpC5rZb+j/QjfCVN1QbGZ1/DlOvZscOWD+9/H/OQLfWs
        l5jL9uLekYsB4bx8NSehKD3jyydm//U=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-blM64rdtNSCLfjeRvrNYcw-1; Wed, 28 Oct 2020 09:25:46 -0400
X-MC-Unique: blM64rdtNSCLfjeRvrNYcw-1
Received: by mail-pg1-f199.google.com with SMTP id f2so2683898pgf.5
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 06:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WHfZOtjSL72eHGoIxPiDYwnS6QN9E2pBSFJLdMT84r0=;
        b=GCpKa5ivAqjDc/WiUbweKl3IwK5aMMhYBtOTiVryQasLLJoOwzblW9ExAH9I2Y7bx7
         8UAmI1C8RSDULbBwKMPD3atlH225d2khVjapdt6jAvJcZ6PsNskaupHLh/545UuV+AvI
         EmzuTeOIRYI51DHTvdWEdi3Oh3AsP9N8jFBIyWn2lYgyPNhCs1FpCVv/pU8rbSbdQahC
         lPjrTwZw9BJGjmZTZB6OEIjP1T+IyX+w6jpdJ/Am00rLJd2LNC0y/8JaiOGjHonPAV+d
         iRF6NUAQ1/EviqxuXmrVFUl61r2hAgn7veg8/6q7x1xBkQIt/j6EKwwhhGcmKKa0du/P
         Qrew==
X-Gm-Message-State: AOAM531ENAgmSKosnJctoy0pjz/SmrLz6fCwspTnRPwHSPYd1qX2/GY3
        cX10lNxZakyMA86yuNmhOJa1NYWzA7ZnmLquUTF0CmkqGhiAxJohplgL6pJfO/AnN4FrNDztYao
        168yMH37d/2JZZlI=
X-Received: by 2002:a17:90a:e50e:: with SMTP id t14mr6811482pjy.118.1603891544969;
        Wed, 28 Oct 2020 06:25:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzapmXre5A+o48xdJPGW3L02eFew2pnYSz8Vl2fcU0dQZEVoYJEoeE/6BbUI10iU81SadUL3g==
X-Received: by 2002:a17:90a:e50e:: with SMTP id t14mr6811439pjy.118.1603891544595;
        Wed, 28 Oct 2020 06:25:44 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z20sm6055521pfk.199.2020.10.28.06.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:25:44 -0700 (PDT)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Date:   Wed, 28 Oct 2020 21:25:24 +0800
Message-Id: <20201028132529.3763875-1-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201023033855.3894509-1-haliu@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
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
LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
abort if no suitable libbpf is found (useful for automatic packaging
that wants to enforce the dependency).

The old iproute2 bpf code is kept and will be used if no suitable libbpf
is available. When using libbpf, wrapper code ensures that iproute2 will
still understand the old map definition format, including populating
map-in-map and tail call maps before load.

The examples in bpf/examples are kept, and a separate set of examples
are added with BTF-based map definitions for those examples where this
is possible (libbpf doesn't currently support declaratively populating
tail call maps).

At last, Thanks a lot for Toke's help on this patch set.


v2:
a) Remove self defined IS_ERR_OR_NULL and use libbpf_get_error() instead.
b) Add ipvrf with libbpf support.


Here are the test results with patched iproute2:

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
  configure: add check_libbpf() for later libbpf support
  lib: rename bpf.c to bpf_legacy.c
  lib: add libbpf support
  examples/bpf: move struct bpf_elf_map defined maps to legacy folder
  examples/bpf: add bpf examples with BTF defined maps

 configure                                |  48 ++++
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
 include/bpf_util.h                       |  17 +-
 ip/ipvrf.c                               |  19 +-
 lib/Makefile                             |   6 +-
 lib/{bpf.c => bpf_legacy.c}              | 184 ++++++++++++-
 lib/bpf_libbpf.c                         | 332 +++++++++++++++++++++++
 16 files changed, 833 insertions(+), 48 deletions(-)
 rename examples/bpf/{ => legacy}/bpf_cyclic.c (95%)
 create mode 100644 examples/bpf/legacy/bpf_graft.c
 create mode 100644 examples/bpf/legacy/bpf_map_in_map.c
 create mode 100644 examples/bpf/legacy/bpf_shared.c
 rename examples/bpf/{ => legacy}/bpf_tailcall.c (98%)
 rename lib/{bpf.c => bpf_legacy.c} (94%)
 create mode 100644 lib/bpf_libbpf.c

-- 
2.25.4

