Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9DB67D44C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjAZSgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAZSgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:36:51 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842F6474EB
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:36:47 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4d4b54d0731so29327817b3.18
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=58lrBFcBR5TWZbZ9jL4esaxWf2Sxchrgey/13n836bY=;
        b=KbLi+TEHTzDEd7z/Cc2LOrmHSmmp3cJqXpXZyXbc7tm2bmo3za9DRkpqfDi2BZr0b1
         +e/3EfrQ3xj1tD9eHXv1j4psuslMkPFsQcCsbA7O6pwjkVE2zHeRVkq3JphpjCFddb91
         m+UBN8JqV5dBZ8YsLZO+icYCO9OgpBS8btSssILikH+5H+kaJ31FK9PhKmSBd7FPl70q
         nSewcbfp3RV52xYH4kdHu5hxVVMHI3FDF9wsWlDYpzQueAwbTY2NOna+OjVTwfU549Kd
         vvoyzVcGVO1mgdBnkkjLvbo63UXxsT2XFFA7ZULkrnl8j+qCWgrg57Ntwgu05TWBfF+z
         ZJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=58lrBFcBR5TWZbZ9jL4esaxWf2Sxchrgey/13n836bY=;
        b=o89+pRVqEJA4h3Vj92RPlcxPHB8Uww94896nvvj5SNYEcoDstVVU5aVEdrz43zfhDz
         BnBz/1HxjF+rTzjqjBHqZkXfE51lG1b+5sH/VUsiWxYYb2NOI1bl8EoUNlZYKgtRnf4s
         PT8BsimIR4Pr+Th3/xxEDwwsnJO/fzXQAOFgu5eAc8EWFvqO4VKpbA56YH70DQNGdUcz
         O6zy3L5j/CXqpVtn2votCo9uw3PFPawlGwQn5ELo8pFV15HKW3mQVsYM9V3DY43uBbrY
         J/WoBWHGnjMhlTq3RMTvImk8zoxfEd0KK9s919XFOm1/ZiGj5qXL/y2amUovFe/xJi+v
         PxEg==
X-Gm-Message-State: AFqh2kqB0Tsg9ej0htMaWglR1//1ET+WwLmtVFMUB/57vl81UG/POcvM
        0O6Sa46UF/ERuey7YRFCkpNUHKk=
X-Google-Smtp-Source: AMrXdXuoiSo29QNA/BTFq0ucse1QlF7ScTEPU2ZsS8qXpvfSfSuZekbtgrCOue5gi6VIzsd8zsTJgq0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:4f0f:0:b0:501:85fb:a151 with SMTP id
 d15-20020a814f0f000000b0050185fba151mr2897681ywb.158.1674758206735; Thu, 26
 Jan 2023 10:36:46 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:36:45 -0800
In-Reply-To: <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
Mime-Version: 1.0
References: <cover.1674737592.git.lorenzo@kernel.org> <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
Message-ID: <Y9LIPaojtpTjYlNu@google.com>
Subject: Re: [PATCH v3 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
From:   sdf@google.com
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/26, Lorenzo Bianconi wrote:
> Introduce xdp_features tool in order to test XDP features supported by
> the NIC and match them against advertised ones.
> In order to test supported/advertised XDP features, xdp_features must
> run on the Device Under Test (DUT) and on a Tester device.
> xdp_features opens a control TCP channel between DUT and Tester devices
> to send control commands from Tester to the DUT and a UDP data channel
> where the Tester sends UDP 'echo' packets and the DUT is expected to
> reply back with the same packet. DUT installs multiple XDP programs on the
> NIC to test XDP capabilities and reports back to the Tester some XDP  
> stats.
> Currently xdp_features supports the following XDP features:
> - XDP_DROP
> - XDP_PASS
> - XDP_TX
> - XDP_REDIRECT
> - XDP_REDIRECT_TARGET

> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   tools/testing/selftests/bpf/.gitignore        |   1 +
>   tools/testing/selftests/bpf/Makefile          |  11 +-
>   .../selftests/bpf/progs/xdp_features.c        | 249 ++++++
>   .../selftests/bpf/test_xdp_features.sh        |  99 +++
>   tools/testing/selftests/bpf/xdp_features.c    | 736 ++++++++++++++++++
>   tools/testing/selftests/bpf/xdp_features.h    |  33 +
>   6 files changed, 1127 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_features.c
>   create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
>   create mode 100644 tools/testing/selftests/bpf/xdp_features.c
>   create mode 100644 tools/testing/selftests/bpf/xdp_features.h

> diff --git a/tools/testing/selftests/bpf/.gitignore  
> b/tools/testing/selftests/bpf/.gitignore
> index 4aa5bba956ff..116fecf80ca1 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -48,3 +48,4 @@ xskxceiver
>   xdp_redirect_multi
>   xdp_synproxy
>   xdp_hw_metadata
> +xdp_features
> diff --git a/tools/testing/selftests/bpf/Makefile  
> b/tools/testing/selftests/bpf/Makefile
> index 53eae7be8dff..b7c35dc7683f 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -73,7 +73,8 @@ TEST_PROGS := test_kmod.sh \
>   	test_bpftool.sh \
>   	test_bpftool_metadata.sh \
>   	test_doc_build.sh \
> -	test_xsk.sh
> +	test_xsk.sh \
> +	test_xdp_features.sh

>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh ima_setup.sh verify_sig_setup.sh \
> @@ -83,7 +84,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>   	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> -	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
> +	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata \
> +	xdp_features

>   TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
>   TEST_GEN_FILES += liburandom_read.so
> @@ -385,6 +387,7 @@ test_subskeleton_lib.skel.h-deps :=  
> test_subskeleton_lib2.bpf.o test_subskeleton
>   test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
>   xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
>   xdp_hw_metadata.skel.h-deps := xdp_hw_metadata.bpf.o
> +xdp_features.skel.h-deps := xdp_features.bpf.o

>   LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach  
> skel,$(LINKED_SKELS),$($(skel)-deps)))

> @@ -586,6 +589,10 @@ $(OUTPUT)/xdp_hw_metadata: xdp_hw_metadata.c  
> $(OUTPUT)/network_helpers.o $(OUTPU
>   	$(call msg,BINARY,,$@)
>   	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@

> +$(OUTPUT)/xdp_features: xdp_features.c $(OUTPUT)/xdp_features.skel.h |  
> $(OUTPUT)
> +	$(call msg,BINARY,,$@)
> +	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
> +
>   # Make sure we are able to include and link libbpf against c++.
>   $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h  
> $(BPFOBJ)
>   	$(call msg,CXX,,$@)
> diff --git a/tools/testing/selftests/bpf/progs/xdp_features.c  
> b/tools/testing/selftests/bpf/progs/xdp_features.c
> new file mode 100644
> index 000000000000..a729d07fac59
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdp_features.c
> @@ -0,0 +1,249 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include <linux/netdev.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <bpf/bpf_tracing.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <linux/udp.h>
> +#include <asm-generic/errno-base.h>
> +
> +#include "xdp_features.h"
> +
> +#define ipv6_addr_equal(a, b)	((a).s6_addr32[0] == (b).s6_addr32[0] &&	\
> +				 (a).s6_addr32[1] == (b).s6_addr32[1] &&	\
> +				 (a).s6_addr32[2] == (b).s6_addr32[2] &&	\
> +				 (a).s6_addr32[3] == (b).s6_addr32[3])
> +
> +struct xdp_cpumap_stats {
> +	unsigned int redirect;
> +	unsigned int pass;
> +	unsigned int drop;
> +};
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +	__uint(max_entries, 1);
> +} stats SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +	__uint(max_entries, 1);
> +} dut_stats SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_CPUMAP);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(struct bpf_cpumap_val));
> +	__uint(max_entries, 1);
> +} cpu_map SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_DEVMAP);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(struct bpf_devmap_val));
> +	__uint(max_entries, 1);
> +} dev_map SEC(".maps");
> +
> +const volatile __u32 expected_feature = XDP_FEATURE_PASS;
> +const volatile __be32 tester_ip;
> +const volatile __be32 dut_ip;
> +const volatile struct in6_addr tester_ip6;
> +const volatile struct in6_addr dut_ip6;
> +
> +static __always_inline int xdp_process_echo_packet(struct xdp_md *xdp,  
> bool dut)
> +{
> +	void *data_end = (void *)(long)xdp->data_end;
> +	void *data = (void *)(long)xdp->data;
> +	struct ethhdr *eh = data;
> +	struct tlv_hdr *tlv;
> +	struct udphdr *uh;
> +	__be16 port;
> +	__u8 *cmd;
> +
> +	if (eh + 1 > (struct ethhdr *)data_end)
> +		return -EINVAL;
> +
> +	if (eh->h_proto == bpf_htons(ETH_P_IP)) {
> +		struct iphdr *ih = (struct iphdr *)(eh + 1);
> +		__be32 saddr = dut ? tester_ip : dut_ip;
> +		__be32 daddr = dut ? dut_ip : tester_ip;
> +
> +		ih = (struct iphdr *)(eh + 1);
> +		if (ih + 1 > (struct iphdr *)data_end)
> +			return -EINVAL;
> +
> +		if (saddr != ih->saddr)
> +			return -EINVAL;
> +
> +		if (daddr != ih->daddr)
> +			return -EINVAL;
> +
> +		if (ih->protocol != IPPROTO_UDP)
> +			return -EINVAL;
> +
> +		uh = (struct udphdr *)(ih + 1);
> +	} else if (eh->h_proto == bpf_htons(ETH_P_IPV6)) {
> +		struct in6_addr saddr = dut ? tester_ip6 : dut_ip6;
> +		struct in6_addr daddr = dut ? dut_ip6 : tester_ip6;
> +		struct ipv6hdr *ih6 = (struct ipv6hdr *)(eh + 1);
> +
> +		if (ih6 + 1 > (struct ipv6hdr *)data_end)
> +			return -EINVAL;
> +
> +		if (!ipv6_addr_equal(saddr, ih6->saddr))
> +			return -EINVAL;
> +
> +		if (!ipv6_addr_equal(daddr, ih6->daddr))
> +			return -EINVAL;
> +
> +		if (ih6->nexthdr != IPPROTO_UDP)
> +			return -EINVAL;
> +
> +		uh = (struct udphdr *)(ih6 + 1);
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	if (uh + 1 > (struct udphdr *)data_end)
> +		return -EINVAL;
> +
> +	port = dut ? uh->dest : uh->source;
> +	if (port != bpf_htons(DUT_ECHO_PORT))
> +		return -EINVAL;
> +
> +	tlv = (struct tlv_hdr *)(uh + 1);
> +	if (tlv + 1 > data_end)
> +		return -EINVAL;
> +
> +	return bpf_htons(tlv->type) == CMD_ECHO ? 0 : -EINVAL;
> +}
> +
> +SEC("xdp")
> +int xdp_tester(struct xdp_md *xdp)
> +{
> +	__u32 *val, key = 0;
> +
> +	switch (expected_feature) {
> +	case XDP_FEATURE_NDO_XMIT:
> +	case XDP_FEATURE_TX:
> +		if (xdp_process_echo_packet(xdp, true))
> +			goto out;
> +		break;
> +	case XDP_FEATURE_DROP:
> +	case XDP_FEATURE_PASS:
> +	case XDP_FEATURE_REDIRECT:
> +		if (xdp_process_echo_packet(xdp, false))
> +			goto out;
> +		break;
> +	default:
> +		goto out;
> +	}
> +
> +	val = bpf_map_lookup_elem(&stats, &key);
> +	if (val)
> +		__sync_add_and_fetch(val, 1);
> +
> +out:
> +	return XDP_PASS;
> +}
> +
> +SEC("xdp")
> +int xdp_do_pass(struct xdp_md *xdp)
> +{
> +	__u32 *val, key = 0;
> +
> +	val = bpf_map_lookup_elem(&dut_stats, &key);
> +	if (val)
> +		__sync_add_and_fetch(val, 1);
> +
> +	return XDP_PASS;
> +}
> +
> +SEC("xdp")
> +int xdp_do_drop(struct xdp_md *xdp)
> +{
> +	__u32 *val, key = 0;
> +
> +	if (xdp_process_echo_packet(xdp, true))
> +		return XDP_PASS;
> +
> +	val = bpf_map_lookup_elem(&dut_stats, &key);
> +	if (val)
> +		__sync_add_and_fetch(val, 1);
> +
> +	return XDP_DROP;
> +}
> +
> +SEC("xdp")
> +int xdp_do_tx(struct xdp_md *xdp)
> +{
> +	void *data = (void *)(long)xdp->data;
> +	struct ethhdr *eh = data;
> +	__u8 tmp_mac[ETH_ALEN];
> +	__u32 *val, key = 0;
> +
> +	if (xdp_process_echo_packet(xdp, true))
> +		return XDP_PASS;
> +
> +	__builtin_memcpy(tmp_mac, eh->h_source, ETH_ALEN);
> +	__builtin_memcpy(eh->h_source, eh->h_dest, ETH_ALEN);
> +	__builtin_memcpy(eh->h_dest, tmp_mac, ETH_ALEN);
> +
> +	val = bpf_map_lookup_elem(&dut_stats, &key);
> +	if (val)
> +		__sync_add_and_fetch(val, 1);
> +
> +	return XDP_TX;
> +}
> +
> +SEC("xdp")
> +int xdp_do_redirect(struct xdp_md *xdp)
> +{
> +	if (xdp_process_echo_packet(xdp, true))
> +		return XDP_PASS;
> +
> +	return bpf_redirect_map(&cpu_map, 0, 0);
> +}
> +
> +SEC("tp_btf/xdp_cpumap_kthread")
> +int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
> +	     unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
> +{
> +	__u32 *val, key = 0;
> +
> +	val = bpf_map_lookup_elem(&dut_stats, &key);
> +	if (val)
> +		__sync_add_and_fetch(val, 1);
> +
> +	return 0;
> +}
> +
> +SEC("xdp/cpumap")
> +int xdp_do_redirect_cpumap(struct xdp_md *xdp)
> +{
> +	void *data = (void *)(long)xdp->data;
> +	struct ethhdr *eh = data;
> +	__u8 tmp_mac[ETH_ALEN];
> +
> +	if (xdp_process_echo_packet(xdp, true))
> +		return XDP_PASS;
> +
> +	__builtin_memcpy(tmp_mac, eh->h_source, ETH_ALEN);
> +	__builtin_memcpy(eh->h_source, eh->h_dest, ETH_ALEN);
> +	__builtin_memcpy(eh->h_dest, tmp_mac, ETH_ALEN);
> +
> +	return bpf_redirect_map(&dev_map, 0, 0);
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_xdp_features.sh  
> b/tools/testing/selftests/bpf/test_xdp_features.sh
> new file mode 100755
> index 000000000000..98b8fd2b6c16
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xdp_features.sh
> @@ -0,0 +1,99 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Create 2 namespaces with two veth peers, and
> +# check reported and detected XDP capabilities
> +#
> +#   NS0(v00)              NS1(v11)
> +#       |                     |
> +#       |                     |
> +# (v01, id:111)  ------  (v10,id:222)
> +
> +readonly NS0="ns1-$(mktemp -u XXXXXX)"
> +readonly NS1="ns2-$(mktemp -u XXXXXX)"

Why do we need the namespaces? Why not have two veth peers in the
current namespace?

(not sure it matters, just wondering)

> +ret=1
> +
> +setup() {
> +	{
> +		ip netns add ${NS0}
> +		ip netns add ${NS1}
> +
> +		ip link add v01 index 111 type veth peer name v00 netns ${NS0}
> +		ip link add v10 index 222 type veth peer name v11 netns ${NS1}
> +
> +		ip link set v01 up
> +		ip addr add 10.10.0.1/24 dev v01
> +		ip link set v01 address 00:11:22:33:44:55
> +		ip -n ${NS0} link set dev v00 up
> +		ip -n ${NS0} addr add 10.10.0.11/24 dev v00
> +		ip -n ${NS0} route add default via 10.10.0.1
> +		ip -n ${NS0} link set v00 address 00:12:22:33:44:55
> +
> +		ip link set v10 up
> +		ip addr add 10.10.1.1/24 dev v10
> +		ip link set v10 address 00:13:22:33:44:55
> +		ip -n ${NS1} link set dev v11 up
> +		ip -n ${NS1} addr add 10.10.1.11/24 dev v11
> +		ip -n ${NS1} route add default via 10.10.1.1
> +		ip -n ${NS1} link set v11 address 00:14:22:33:44:55
> +
> +		sysctl -w net.ipv4.ip_forward=1
> +		# Enable XDP mode
> +		ethtool -K v01 gro on
> +		ethtool -K v01 tx-checksumming off
> +		ip netns exec ${NS0} ethtool -K v00 gro on
> +		ip netns exec ${NS0} ethtool -K v00 tx-checksumming off
> +		ethtool -K v10 gro on
> +		ethtool -K v10 tx-checksumming off
> +		ip netns exec ${NS1} ethtool -K v11 gro on
> +		ip netns exec ${NS1} ethtool -K v11 tx-checksumming off
> +	} > /dev/null 2>&1
> +}
> +
> +cleanup() {
> +	ip link del v01 2> /dev/null
> +	ip link del v10 2> /dev/null
> +	ip netns del ${NS0} 2> /dev/null
> +	ip netns del ${NS1} 2> /dev/null
> +	[ "$(pidof xdp_features)" = "" ] || kill $(pidof xdp_features) 2>  
> /dev/null
> +}
> +
> +test_xdp_features() {
> +	setup
> +
> +	## XDP_PASS
> +	ip netns exec ${NS1} ./xdp_features -f XDP_PASS -D 10.10.1.11 -T  
> 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_PASS -D 10.10.1.11 -C  
> 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	# XDP_DROP
> +	ip netns exec ${NS1} ./xdp_features -f XDP_DROP -D 10.10.1.11 -T  
> 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_DROP -D 10.10.1.11 -C  
> 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	## XDP_TX
> +	./xdp_features -f XDP_TX -D 10.10.0.1 -T 10.10.0.11 v01 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_TX -D 10.10.0.1 -C  
> 10.10.0.1 -T 10.10.0.11 v00
> +
> +	## XDP_REDIRECT
> +	ip netns exec ${NS1} ./xdp_features -f XDP_REDIRECT -D 10.10.1.11 -T  
> 10.10.0.11 v11 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_REDIRECT -D 10.10.1.11 -C  
> 10.10.1.11 -T 10.10.0.11 v00
> +
> +	[ $? -ne 0 ] && exit
> +
> +	## XDP_NDO_XMIT
> +	./xdp_features -f XDP_NDO_XMIT -D 10.10.0.1 -T 10.10.0.11 v01 &
> +	ip netns exec ${NS0} ./xdp_features -t -f XDP_NDO_XMIT -D 10.10.0.1 -C  
> 10.10.0.1 -T 10.10.0.11 v00
> +
> +	ret=$?
> +	cleanup
> +}
> +
> +set -e
> +trap cleanup 2 3 6 9
> +
> +test_xdp_features
> +
> +exit $ret
> diff --git a/tools/testing/selftests/bpf/xdp_features.c  
> b/tools/testing/selftests/bpf/xdp_features.c
> new file mode 100644
> index 000000000000..82dc5dd143bf
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xdp_features.c
> @@ -0,0 +1,736 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <uapi/linux/bpf.h>
> +#include <uapi/linux/netdev.h>
> +#include <linux/if_link.h>
> +#include <signal.h>
> +#include <argp.h>
> +#include <net/if.h>
> +#include <sys/socket.h>
> +#include <netinet/in.h>
> +#include <netinet/tcp.h>
> +#include <unistd.h>
> +#include <arpa/inet.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#include <pthread.h>
> +
> +#include "xdp_features.skel.h"
> +#include "xdp_features.h"
> +
> +#define RED(str)	"\033[0;31m" str "\033[0m"
> +#define GREEN(str)	"\033[0;32m" str "\033[0m"
> +#define YELLOW(str)	"\033[0;33m" str "\033[0m"
> +
> +static struct env {
> +	bool verbosity;
> +	int ifindex;
> +	unsigned int feature;
> +	bool tester;
> +	in_addr_t dut_ctrl_ip;
> +	in_addr_t dut_ip;
> +	in_addr_t tester_ip;
> +} env;
> +
> +#define BUFSIZE		128
> +
> +static int libbpf_print_fn(enum libbpf_print_level level,
> +			   const char *format, va_list args)
> +{
> +	if (level == LIBBPF_DEBUG && !env.verbosity)
> +		return 0;
> +	return vfprintf(stderr, format, args);
> +}
> +
> +static volatile bool exiting;
> +
> +static void sig_handler(int sig)
> +{
> +	exiting = true;
> +}
> +
> +const char *argp_program_version = "xdp-features 0.0";
> +const char argp_program_doc[] =
> +"XDP features detecion application.\n"
> +"\n"
> +"XDP features application checks the XDP advertised features match  
> detected ones.\n"
> +"\n"
> +"USAGE: ./xdp-features [-vt] [-f <xdp-feature>] [-D <dut-data-ip>] [-T  
> <tester-data-ip>] [-C <dut-ctrl-ip>] <iface-name>\n"
> +"\n"
> +"XDP features\n:"
> +"- XDP_PASS\n"
> +"- XDP_DROP\n"
> +"- XDP_ABORTED\n"
> +"- XDP_REDIRECT\n"
> +"- XDP_NDO_XMIT\n"
> +"- XDP_TX\n";
> +
> +static const struct argp_option opts[] = {
> +	{ "verbose", 'v', NULL, 0, "Verbose debug output" },
> +	{ "tester", 't', NULL, 0, "Tester mode" },
> +	{ "feature", 'f', "XDP-FEATURE", 0, "XDP feature to test" },
> +	{ "dut_data_ip", 'D', "DUT-DATA-IP", 0, "DUT IP data channel" },
> +	{ "dut_ctrl_ip", 'C', "DUT-CTRL-IP", 0, "DUT IP control channel" },
> +	{ "tester_data_ip", 'T', "TESTER-DATA-IP", 0, "Tester IP data channel"  
> },
> +	{},
> +};
> +
> +static int get_xdp_feature(const char *arg)
> +{
> +	if (!strcmp(arg, "XDP_PASS"))
> +		return XDP_FEATURE_PASS;
> +	else if (!strcmp(arg, "XDP_DROP"))
> +		return XDP_FEATURE_DROP;
> +	else if (!strcmp(arg, "XDP_ABORTED"))
> +		return XDP_FEATURE_ABORTED;
> +	else if (!strcmp(arg, "XDP_REDIRECT"))
> +		return XDP_FEATURE_REDIRECT;
> +	else if (!strcmp(arg, "XDP_NDO_XMIT"))
> +		return XDP_FEATURE_NDO_XMIT;
> +	else if (!strcmp(arg, "XDP_TX"))
> +		return XDP_FEATURE_TX;
> +
> +	return -EINVAL;
> +}
> +
> +static char *get_xdp_feature_str(int feature)
> +{
> +	switch (feature) {
> +	case XDP_FEATURE_PASS:
> +		return YELLOW("XDP_PASS");
> +	case XDP_FEATURE_DROP:
> +		return YELLOW("XDP_DROP");
> +	case XDP_FEATURE_ABORTED:
> +		return YELLOW("XDP_ABORTED");
> +	case XDP_FEATURE_TX:
> +		return YELLOW("XDP_TX");
> +	case XDP_FEATURE_REDIRECT:
> +		return YELLOW("XDP_REDIRECT");
> +	case XDP_FEATURE_NDO_XMIT:
> +		return YELLOW("XDP_NDO_XMIT");
> +	default:
> +		return "";
> +	}
> +}
> +
> +static error_t parse_arg(int key, char *arg, struct argp_state *state)
> +{
> +	switch (key) {
> +	case 'v':
> +		env.verbosity = true;
> +		break;
> +	case 't':
> +		env.tester = true;
> +		break;
> +	case 'f':
> +		env.feature = get_xdp_feature(arg);
> +		if (env.feature < 0) {
> +			fprintf(stderr, "Invalid xdp feature: %s\n", arg);
> +			argp_usage(state);
> +			return ARGP_ERR_UNKNOWN;
> +		}
> +		break;
> +	case 'D':
> +		env.dut_ip = inet_addr(arg);
> +		if (env.dut_ip < 0)
> +			return ARGP_ERR_UNKNOWN;
> +		break;
> +	case 'C':
> +		env.dut_ctrl_ip = inet_addr(arg);
> +		if (env.dut_ctrl_ip < 0)
> +			return ARGP_ERR_UNKNOWN;
> +		break;
> +	case 'T':
> +		env.tester_ip = inet_addr(arg);
> +		if (env.tester_ip < 0)
> +			return ARGP_ERR_UNKNOWN;
> +		break;
> +	case ARGP_KEY_ARG:
> +		errno = 0;
> +		if (strlen(arg) >= IF_NAMESIZE) {
> +			fprintf(stderr, "Invalid device name: %s\n", arg);
> +			argp_usage(state);
> +			return ARGP_ERR_UNKNOWN;
> +		}
> +
> +		env.ifindex = if_nametoindex(arg);
> +		if (!env.ifindex)
> +			env.ifindex = strtoul(arg, NULL, 0);
> +		if (!env.ifindex) {
> +			fprintf(stderr,
> +				"Bad interface index or name (%d): %s\n",
> +				errno, strerror(errno));
> +			argp_usage(state);
> +			return ARGP_ERR_UNKNOWN;
> +		}
> +		break;
> +	default:
> +		return ARGP_ERR_UNKNOWN;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct argp argp = {
> +	.options = opts,
> +	.parser = parse_arg,
> +	.doc = argp_program_doc,
> +};
> +
> +static void set_env_defaul(void)
> +{
> +	env.feature = XDP_FEATURE_PASS;
> +	env.ifindex = -ENODEV;
> +	env.dut_ctrl_ip = inet_addr("127.0.0.1");
> +	env.dut_ip = inet_addr("127.0.0.1");
> +	env.tester_ip = inet_addr("127.0.0.1");
> +}
> +
> +static void *dut_echo_thread(void *arg)
> +{
> +	unsigned char buf[sizeof(struct tlv_hdr)];
> +	int sockfd = *(int *)arg;
> +
> +	while (!exiting) {
> +		unsigned int len = sizeof(struct sockaddr_in);
> +		struct sockaddr_in addr;
> +		struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
> +		size_t n;
> +
> +		n = recvfrom(sockfd, buf, sizeof(buf), MSG_WAITALL,
> +			     (struct sockaddr *)&addr, &len);
> +		if (n != ntohs(tlv->len))
> +			continue;
> +
> +		if (ntohs(tlv->type) != CMD_ECHO)
> +			continue;
> +
> +		sendto(sockfd, buf, sizeof(buf), MSG_NOSIGNAL | MSG_CONFIRM,
> +		       (struct sockaddr *)&addr, sizeof(addr));
> +	}
> +
> +	pthread_exit((void *)0);
> +	close(sockfd);
> +
> +	return NULL;
> +}
> +
> +static int dut_run_echo_thread(pthread_t *t, int *echo_sockfd)
> +{
> +	struct sockaddr_in addr = {
> +		.sin_family = AF_INET,
> +		.sin_addr.s_addr = htonl(INADDR_ANY),
> +		.sin_port = htons(DUT_ECHO_PORT),
> +	};
> +	int err, sockfd, optval = 1;
> +

[..]

> +	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (sockfd < 0) {
> +		fprintf(stderr, "Failed to create echo socket\n");
> +		return -errno;
> +	}
> +
> +	err = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optval,
> +			 sizeof(optval));
> +	if (err < 0) {
> +		fprintf(stderr, "Failed sockopt on echo socket\n");
> +		return -errno;
> +	}
> +
> +	err = bind(sockfd, (struct sockaddr *)&addr, sizeof(addr));
> +	if (err) {
> +		fprintf(stderr, "Failed to bind echo socket\n");
> +		return -errno;
> +	}

IIRC, Martin mentioned IPv6 support in the previous version. Should we
also make the userspace v6 aware by at least using AF_INET6 dualstack
sockets? I feel like listening on inaddr_any with AF_INET6 should
get us there without too much pain..

> +
> +	/* start echo channel */
> +	*echo_sockfd = sockfd;
> +	err = pthread_create(t, NULL, dut_echo_thread, echo_sockfd);
> +	if (err) {
> +		fprintf(stderr, "Failed creating dut_echo thread: %s\n",
> +			strerror(-err));
> +		close(sockfd);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dut_attach_xdp_prog(struct xdp_features *skel, int feature,
> +			       int flags)
> +{
> +	struct bpf_program *prog;
> +	unsigned int key = 0;
> +	int err, fd = 0;
> +
> +	switch (feature) {
> +	case XDP_FEATURE_TX:
> +		prog = skel->progs.xdp_do_tx;
> +		break;
> +	case XDP_FEATURE_DROP:
> +	case XDP_FEATURE_ABORTED:
> +		prog = skel->progs.xdp_do_drop;
> +		break;
> +	case XDP_FEATURE_PASS:
> +		prog = skel->progs.xdp_do_pass;
> +		break;
> +	case XDP_FEATURE_NDO_XMIT: {
> +		struct bpf_devmap_val entry = {
> +			.ifindex = env.ifindex,
> +		};
> +
> +		err = bpf_map__update_elem(skel->maps.dev_map,
> +					   &key, sizeof(key),
> +					   &entry, sizeof(entry), 0);
> +		if (err < 0)
> +			return err;
> +
> +		fd = bpf_program__fd(skel->progs.xdp_do_redirect_cpumap);
> +	}
> +	case XDP_FEATURE_REDIRECT: {
> +		struct bpf_cpumap_val entry = {
> +			.qsize = 2048,
> +			.bpf_prog.fd = fd,
> +		};
> +
> +		err = bpf_map__update_elem(skel->maps.cpu_map,
> +					   &key, sizeof(key),
> +					   &entry, sizeof(entry), 0);
> +		if (err < 0)
> +			return err;
> +
> +		prog = skel->progs.xdp_do_redirect;
> +		break;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
> +	if (err)
> +		fprintf(stderr,
> +			"Failed to attach XDP program to ifindex %d\n",
> +			env.ifindex);
> +	return err;
> +}
> +
> +static int __recv_msg(int sockfd, void *buf, size_t bufsize,
> +		      unsigned int *val, unsigned int val_size)
> +{
> +	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
> +	int len, n = sizeof(*tlv), i = 0;
> +
> +	len = recv(sockfd, buf, bufsize, 0);
> +	if (len != ntohs(tlv->len))
> +		return -EINVAL;
> +
> +	while (n < len && i < val_size) {
> +		val[i] = ntohl(tlv->data[i]);
> +		n += sizeof(tlv->data[0]);
> +		i++;
> +	}
> +
> +	return i;
> +}
> +
> +static int recv_msg(int sockfd, void *buf, size_t bufsize)
> +{
> +	return __recv_msg(sockfd, buf, bufsize, NULL, 0);
> +}
> +
> +static int dut_run(struct xdp_features *skel)
> +{
> +	int flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
> +	int state, err, sockfd, ctrl_sockfd, echo_sockfd, optval = 1;
> +	struct sockaddr_in ctrl_addr, addr = {
> +		.sin_family = AF_INET,
> +		.sin_addr.s_addr = htonl(INADDR_ANY),
> +		.sin_port = htons(DUT_CTRL_PORT),
> +	};
> +	unsigned int len = sizeof(ctrl_addr);
> +	pthread_t dut_thread;
> +

[..]

> +	sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +	if (sockfd < 0) {
> +		fprintf(stderr, "Failed to create DUT socket\n");
> +		return -errno;
> +	}
> +
> +	err = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optval,
> +			 sizeof(optval));
> +	if (err < 0) {
> +		fprintf(stderr, "Failed sockopt on DUT socket\n");
> +		return -errno;
> +	}
> +
> +	err = bind(sockfd, (struct sockaddr *)&addr, sizeof(addr));
> +	if (err < 0) {
> +		fprintf(stderr, "Failed to bind DUT socket\n");
> +		return -errno;
> +	}
> +
> +	err = listen(sockfd, 5);
> +	if (err) {
> +		fprintf(stderr, "Failed to listen DUT socket\n");
> +		return -errno;
> +	}

Should we use start_server from network_helpers.h here?

> +
> +	ctrl_sockfd = accept(sockfd, (struct sockaddr *)&ctrl_addr, &len);
> +	if (ctrl_sockfd < 0) {
> +		fprintf(stderr, "Failed to accept connection on DUT socket\n");
> +		close(sockfd);
> +		return -errno;
> +	}
> +
> +	/* CTRL loop */
> +	while (!exiting) {
> +		unsigned char buf[BUFSIZE] = {};
> +		struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
> +
> +		err = recv_msg(ctrl_sockfd, buf, BUFSIZE);
> +		if (err)
> +			continue;
> +
> +		switch (ntohs(tlv->type)) {
> +		case CMD_START: {
> +			if (state == CMD_START)
> +				continue;
> +
> +			state = CMD_START;
> +			/* Load the XDP program on the DUT */
> +			err = dut_attach_xdp_prog(skel, ntohl(tlv->data[0]), flags);
> +			if (err)
> +				goto out;
> +
> +			err = dut_run_echo_thread(&dut_thread, &echo_sockfd);
> +			if (err < 0)
> +				goto out;
> +
> +			tlv->type = htons(CMD_ACK);
> +			tlv->len = htons(sizeof(*tlv));
> +			err = send(ctrl_sockfd, buf, sizeof(*tlv), 0);
> +			if (err < 0)
> +				goto end_thread;
> +			break;
> +		}
> +		case CMD_STOP:
> +			if (state != CMD_START)
> +				break;
> +
> +			state = CMD_STOP;
> +
> +			exiting = true;
> +			bpf_xdp_detach(env.ifindex, flags, NULL);
> +
> +			tlv->type = htons(CMD_ACK);
> +			tlv->len = htons(sizeof(*tlv));
> +			err = send(ctrl_sockfd, buf, sizeof(*tlv), 0);
> +			goto end_thread;
> +		case CMD_GET_XDP_CAP: {
> +			LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> +			size_t n;
> +
> +			err = bpf_xdp_query(env.ifindex, XDP_FLAGS_DRV_MODE,
> +					    &opts);
> +			if (err) {
> +				fprintf(stderr,
> +					"Failed to query XDP cap for ifindex %d\n",
> +					env.ifindex);
> +				goto end_thread;
> +			}
> +
> +			tlv->type = htons(CMD_ACK);
> +			n = sizeof(*tlv) + sizeof(opts.fflags);
> +			tlv->len = htons(n);
> +			tlv->data[0] = htonl(opts.fflags);
> +
> +			err = send(ctrl_sockfd, buf, n, 0);
> +			if (err < 0)
> +				goto end_thread;
> +			break;
> +		}
> +		case CMD_GET_STATS: {
> +			unsigned int key = 0, val;
> +			size_t n;
> +
> +			err = bpf_map__lookup_elem(skel->maps.dut_stats,
> +						   &key, sizeof(key),
> +						   &val, sizeof(val), 0);
> +			if (err) {
> +				fprintf(stderr, "bpf_map_lookup_elem failed\n");
> +				goto end_thread;
> +			}
> +
> +			tlv->type = htons(CMD_ACK);
> +			n = sizeof(*tlv) + sizeof(val);
> +			tlv->len = htons(n);
> +			tlv->data[0] = htonl(val);
> +
> +			err = send(ctrl_sockfd, buf, n, 0);
> +			if (err < 0)
> +				goto end_thread;
> +			break;
> +		}
> +		default:
> +			break;
> +		}
> +	}
> +
> +end_thread:
> +	pthread_join(dut_thread, NULL);
> +out:
> +	bpf_xdp_detach(env.ifindex, flags, NULL);
> +	close(ctrl_sockfd);
> +	close(sockfd);
> +
> +	return err;
> +}
> +
> +static bool tester_collect_advertised_cap(unsigned int cap)
> +{
> +	switch (env.feature) {
> +	case XDP_FEATURE_ABORTED:
> +	case XDP_FEATURE_DROP:
> +	case XDP_FEATURE_PASS:
> +	case XDP_FEATURE_TX:
> +		return cap & NETDEV_XDP_ACT_BASIC;
> +	case XDP_FEATURE_REDIRECT:
> +		return cap & NETDEV_XDP_ACT_REDIRECT;
> +	case XDP_FEATURE_NDO_XMIT:
> +		return cap & NETDEV_XDP_ACT_NDO_XMIT;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool tester_collect_detected_cap(struct xdp_features *skel,
> +					unsigned int dut_stats)
> +{
> +	unsigned int err, key = 0, val;
> +
> +	if (!dut_stats)
> +		return false;
> +
> +	err = bpf_map__lookup_elem(skel->maps.stats, &key, sizeof(key),
> +				   &val, sizeof(val), 0);
> +	if (err) {
> +		fprintf(stderr, "bpf_map_lookup_elem failed\n");
> +		return false;
> +	}
> +
> +	switch (env.feature) {
> +	case XDP_FEATURE_PASS:
> +	case XDP_FEATURE_TX:
> +	case XDP_FEATURE_REDIRECT:
> +	case XDP_FEATURE_NDO_XMIT:
> +		return val > 0;
> +	case XDP_FEATURE_DROP:
> +	case XDP_FEATURE_ABORTED:
> +		return val == 0;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static int __send_and_recv_msg(int sockfd, enum test_commands cmd,
> +			       unsigned int *val, unsigned int val_size)
> +{
> +	unsigned char buf[BUFSIZE] = {};
> +	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
> +	int n = sizeof(*tlv), err;
> +
> +	tlv->type = htons(cmd);
> +	switch (cmd) {
> +	case CMD_START:
> +		tlv->data[0] = htonl(env.feature);
> +		n += sizeof(*val);
> +		break;
> +	default:
> +		break;
> +	}
> +	tlv->len = htons(n);
> +
> +	err = send(sockfd, buf, n, 0);
> +	if (err < 0)
> +		return err;
> +
> +	err = __recv_msg(sockfd, buf, BUFSIZE, val, val_size);
> +	if (err < 0)
> +		return err;
> +
> +	return ntohs(tlv->type) == CMD_ACK ? 0 : -EINVAL;
> +}
> +
> +static int send_and_recv_msg(int sockfd, enum test_commands cmd)
> +{
> +	return __send_and_recv_msg(sockfd, cmd, NULL, 0);
> +}
> +
> +static int send_echo_msg(void)
> +{
> +	struct sockaddr_in addr = {
> +		.sin_family = AF_INET,
> +		.sin_addr.s_addr = env.dut_ip,
> +		.sin_port = htons(DUT_ECHO_PORT),
> +	};
> +	unsigned char buf[sizeof(struct tlv_hdr)];
> +	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
> +	int sockfd, n;
> +
> +	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (sockfd < 0) {
> +		fprintf(stderr, "Failed to create echo socket\n");
> +		return -errno;
> +	}
> +
> +	tlv->type = htons(CMD_ECHO);
> +	tlv->len = htons(sizeof(*tlv));
> +
> +	n = sendto(sockfd, buf, sizeof(*tlv), MSG_NOSIGNAL | MSG_CONFIRM,
> +		   (struct sockaddr *)&addr, sizeof(addr));
> +	close(sockfd);
> +
> +	return n == ntohs(tlv->len) ? 0 : -EINVAL;
> +}
> +
> +static int tester_run(struct xdp_features *skel)
> +{
> +	int flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
> +	struct sockaddr_in addr = {
> +		.sin_family = AF_INET,
> +		.sin_addr.s_addr = env.dut_ctrl_ip,
> +		.sin_port = htons(DUT_CTRL_PORT),
> +	};
> +	bool advertised_cap;
> +	int i, err, sockfd;
> +	bool detected_cap;
> +	unsigned int val[1];
> +

[..]

> +	sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +	if (sockfd < 0) {
> +		fprintf(stderr, "Failed to create tester socket\n");
> +		return -errno;
> +	}
> +
> +	for (i = 0; i < 10; i++) {
> +		/* connect ctrl channel */
> +		if (!connect(sockfd, (struct sockaddr *)&addr, sizeof(addr)))
> +			break;
> +		sleep(1);
> +	}

There is also connect_to_fd, maybe we can use that? It should take
care of the timeouts.. (requires plumbing server_fd, not sure whether
it's a problem or not)

> +
> +	if (i == 10) {
> +		fprintf(stderr, "Failed to connect to the DUT\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	err = __send_and_recv_msg(sockfd, CMD_GET_XDP_CAP, val,  
> ARRAY_SIZE(val));
> +	if (err < 0) {
> +		close(sockfd);
> +		return err;
> +	}
> +
> +	advertised_cap = tester_collect_advertised_cap(val[0]);
> +
> +	err = bpf_xdp_attach(env.ifindex,
> +			     bpf_program__fd(skel->progs.xdp_tester),
> +			     flags, NULL);
> +	if (err) {
> +		fprintf(stderr, "Failed to attach XDP program to ifindex %d\n",
> +			env.ifindex);
> +		goto out;
> +	}
> +
> +	err = send_and_recv_msg(sockfd, CMD_START);
> +	if (err)
> +		goto out;
> +
> +	for (i = 0; i < 10 && !exiting; i++) {
> +		err = send_echo_msg();
> +		if (err < 0)
> +			goto out;
> +
> +		sleep(1);
> +	}
> +
> +	err = __send_and_recv_msg(sockfd, CMD_GET_STATS, val, ARRAY_SIZE(val));
> +	if (err)
> +		goto out;
> +
> +	/* stop the test */
> +	err = send_and_recv_msg(sockfd, CMD_STOP);
> +	/* send a new echo message to wake echo thread of the dut */
> +	send_echo_msg();
> +
> +	detected_cap = tester_collect_detected_cap(skel, val[0]);
> +
> +	fprintf(stdout, "Feature %s: [%s][%s]\n",  
> get_xdp_feature_str(env.feature),
> +		detected_cap ? GREEN("DETECTED") : RED("NOT DETECTED"),
> +		advertised_cap ? GREEN("ADVERTISED") : RED("NOT ADVERTISED"));
> +out:
> +	bpf_xdp_detach(env.ifindex, flags, NULL);
> +	close(sockfd);
> +	return err < 0 ? err : 0;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct xdp_features *skel;
> +	int err;
> +
> +	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> +	libbpf_set_print(libbpf_print_fn);
> +
> +	signal(SIGINT, sig_handler);
> +	signal(SIGTERM, sig_handler);
> +
> +	set_env_defaul();
> +
> +	/* Parse command line arguments */
> +	err = argp_parse(&argp, argc, argv, 0, NULL, NULL);
> +	if (err)
> +		return err;
> +
> +	if (env.ifindex < 0) {
> +		fprintf(stderr, "Invalid ifindex\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Load and verify BPF application */
> +	skel = xdp_features__open();
> +	if (!skel) {
> +		fprintf(stderr, "Failed to open and load BPF skeleton\n");
> +		return -EINVAL;
> +	}
> +
> +	skel->rodata->expected_feature = env.feature;
> +	skel->rodata->dut_ip = env.dut_ip;
> +	skel->rodata->tester_ip = env.tester_ip;
> +
> +	/* Load & verify BPF programs */
> +	err = xdp_features__load(skel);
> +	if (err) {
> +		fprintf(stderr, "Failed to load and verify BPF skeleton\n");
> +		goto cleanup;
> +	}
> +
> +	err = xdp_features__attach(skel);
> +	if (err) {
> +		fprintf(stderr, "Failed to attach BPF skeleton\n");
> +		goto cleanup;
> +	}
> +
> +	if (env.tester) {
> +		/* Tester */
> +		fprintf(stdout, "Starting tester on device %d\n", env.ifindex);
> +		err = tester_run(skel);
> +	} else {
> +		/* DUT */
> +		fprintf(stdout, "Starting DUT on device %d\n", env.ifindex);
> +		err = dut_run(skel);
> +	}
> +
> +cleanup:
> +	xdp_features__destroy(skel);
> +
> +	return err < 0 ? -err : 0;
> +}
> diff --git a/tools/testing/selftests/bpf/xdp_features.h  
> b/tools/testing/selftests/bpf/xdp_features.h
> new file mode 100644
> index 000000000000..28d7614c4f02
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xdp_features.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/* test commands */
> +enum test_commands {
> +	CMD_STOP,		/* CMD */
> +	CMD_START,		/* CMD + xdp feature */
> +	CMD_ECHO,		/* CMD */
> +	CMD_ACK,		/* CMD + data */
> +	CMD_GET_XDP_CAP,	/* CMD */
> +	CMD_GET_STATS,		/* CMD */
> +};
> +
> +#define DUT_CTRL_PORT	12345
> +#define DUT_ECHO_PORT	12346
> +
> +struct tlv_hdr {
> +	__be16 type;
> +	__be16 len;
> +	__be32 data[];
> +};
> +
> +enum {
> +	XDP_FEATURE_ABORTED,
> +	XDP_FEATURE_DROP,
> +	XDP_FEATURE_PASS,
> +	XDP_FEATURE_TX,
> +	XDP_FEATURE_REDIRECT,
> +	XDP_FEATURE_NDO_XMIT,
> +	XDP_FEATURE_XSK_ZEROCOPY,
> +	XDP_FEATURE_HW_OFFLOAD,
> +	XDP_FEATURE_RX_SG,
> +	XDP_FEATURE_NDO_XMIT_SG,
> +};
> --
> 2.39.1

