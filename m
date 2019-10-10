Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1151CD27BF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfJJLHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 07:07:34 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:59649 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726237AbfJJLHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 07:07:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CFD427C1;
        Thu, 10 Oct 2019 07:07:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 07:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=crpa8c
        gkn0UvvoPVIPRiEhbN37zPdlJU00CF3RkXTbw=; b=D0wus0eD7V7QRMH+/Uc18k
        KEEgrG499TEM2I9uSIIy354khmkJ4inBcxTUwaqxyoY2T2aQferMS5Kex0rnx+OS
        S+KqGumYWTBdxHPLs72X0HxI6cGrP/4p9rSCdSfX8VyMkkNA0FdUGCQE2CJUFaaV
        8DP1AwNbWf0d2ejGN0CzZ63gOPanrvBpI/c6EXY9Xf2oA7ABaBcjYS41rg2DZ0cJ
        86MMOYTq31xyXP0Yn1E6+U4DohiEMbqhx8oy7ip5dqjNHbyJTU3dmc01Vs8rdvSy
        q27cPVxVhaaXMpRWy4XqwOKH44ujyLFDYHR98bV03zqKHykxxbYQwc3GuPv8pzbQ
        ==
X-ME-Sender: <xms:8xCfXWm5BIYEZVWKrdo0yUrYrMvAsa92itxXH9z8jA6oMhIWitjS7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieefgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8xCfXS3liI9vUVcOFPfif9j8Po4HIl9_Kt1sG7DIS_joFXoj27lCwA>
    <xmx:8xCfXVjJGIIs3yCa2_5t2ILlPQ_NBxtbOfpMcDjw51uDLrKxn9qVAQ>
    <xmx:8xCfXQUOUWuPwMbNnnBxTPV3F099rXozRS9_cEkOaIQoE7c0I-oxKA>
    <xmx:9BCfXbIQLpp1AYhbwz2wyNZ9pvdgseqCz6mVEgBU_hikRRm-Ayc-1g>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2B62D60057;
        Thu, 10 Oct 2019 07:07:30 -0400 (EDT)
Date:   Thu, 10 Oct 2019 14:07:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 12/12] selftests/bpf: add kfree_skb raw_tp
 test
Message-ID: <20191010110729.GA21703@splinter>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-13-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010041503.2526303-13-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 09:15:03PM -0700, Alexei Starovoitov wrote:
> Load basic cls_bpf program.
> Load raw_tracepoint program and attach to kfree_skb raw tracepoint.
> Trigger cls_bpf via prog_test_run.
> At the end of test_run kernel will call kfree_skb
> which will trigger trace_kfree_skb tracepoint.
> Which will call our raw_tracepoint program.
> Which will take that skb and will dump it into perf ring buffer.
> Check that user space received correct packet.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/kfree_skb.c      | 90 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/kfree_skb.c | 74 +++++++++++++++
>  2 files changed, 164 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> new file mode 100644
> index 000000000000..0cf91b6bf276
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +static void on_sample(void *ctx, int cpu, void *data, __u32 size)
> +{
> +	int ifindex = *(int *)data, duration = 0;
> +	struct ipv6_packet *pkt_v6 = data + 4;
> +
> +	if (ifindex != 1)
> +		/* spurious kfree_skb not on loopback device */
> +		return;
> +	if (CHECK(size != 76, "check_size", "size %u != 76\n", size))
> +		return;
> +	if (CHECK(pkt_v6->eth.h_proto != 0xdd86, "check_eth",
> +		  "h_proto %x\n", pkt_v6->eth.h_proto))
> +		return;
> +	if (CHECK(pkt_v6->iph.nexthdr != 6, "check_ip",
> +		  "iph.nexthdr %x\n", pkt_v6->iph.nexthdr))
> +		return;
> +	if (CHECK(pkt_v6->tcp.doff != 5, "check_tcp",
> +		  "tcp.doff %x\n", pkt_v6->tcp.doff))
> +		return;
> +
> +	*(bool *)ctx = true;
> +}
> +
> +void test_kfree_skb(void)
> +{
> +	struct bpf_prog_load_attr attr = {
> +		.file = "./kfree_skb.o",
> +		.log_level = 2,
> +	};
> +
> +	struct bpf_object *obj, *obj2 = NULL;
> +	struct perf_buffer_opts pb_opts = {};
> +	struct perf_buffer *pb = NULL;
> +	struct bpf_link *link = NULL;
> +	struct bpf_map *perf_buf_map;
> +	struct bpf_program *prog;
> +	__u32 duration, retval;
> +	int err, pkt_fd, kfree_skb_fd;
> +	bool passed = false;
> +
> +	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);
> +	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
> +		return;
> +
> +	err = bpf_prog_load_xattr(&attr, &obj2, &kfree_skb_fd);
> +	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
> +		goto close_prog;
> +
> +	prog = bpf_object__find_program_by_title(obj2, "raw_tracepoint/kfree_skb");
> +	if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
> +		goto close_prog;
> +	link = bpf_program__attach_raw_tracepoint(prog, NULL);
> +	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
> +		goto close_prog;
> +
> +	perf_buf_map = bpf_object__find_map_by_name(obj2, "perf_buf_map");
> +	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
> +		goto close_prog;
> +
> +	/* set up perf buffer */
> +	pb_opts.sample_cb = on_sample;
> +	pb_opts.ctx = &passed;
> +	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
> +	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
> +		goto close_prog;
> +
> +	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
> +				NULL, NULL, &retval, &duration);
> +	CHECK(err || retval, "ipv6",
> +	      "err %d errno %d retval %d duration %d\n",
> +	      err, errno, retval, duration);
> +
> +	/* read perf buffer */
> +	err = perf_buffer__poll(pb, 100);
> +	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
> +		goto close_prog;
> +	/* make sure kfree_skb program was triggered
> +	 * and it sent expected skb into ring buffer
> +	 */
> +	CHECK_FAIL(!passed);
> +close_prog:
> +	perf_buffer__free(pb);
> +	if (!IS_ERR_OR_NULL(link))
> +		bpf_link__destroy(link);
> +	bpf_object__close(obj);
> +	bpf_object__close(obj2);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
> new file mode 100644
> index 000000000000..fc25797cc64d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +} perf_buf_map SEC(".maps");
> +
> +#define _(P) (__builtin_preserve_access_index(P))
> +
> +/* define few struct-s that bpf program needs to access */
> +struct callback_head {
> +	struct callback_head *next;
> +	void (*func)(struct callback_head *head);
> +};
> +struct dev_ifalias {
> +	struct callback_head rcuhead;
> +};
> +
> +struct net_device /* same as kernel's struct net_device */ {
> +	int ifindex;
> +	struct dev_ifalias *ifalias;
> +};
> +
> +struct sk_buff {
> +	/* field names and sizes should match to those in the kernel */
> +	unsigned int len, data_len;
> +	__u16 mac_len, hdr_len, queue_mapping;
> +	struct net_device *dev;
> +	/* order of the fields doesn't matter */
> +};
> +
> +/* copy arguments from
> + * include/trace/events/skb.h:
> + * TRACE_EVENT(kfree_skb,
> + *         TP_PROTO(struct sk_buff *skb, void *location),
> + *
> + * into struct below:
> + */
> +struct trace_kfree_skb {
> +	struct sk_buff *skb;
> +	void *location;
> +};
> +
> +SEC("raw_tracepoint/kfree_skb")
> +int trace_kfree_skb(struct trace_kfree_skb *ctx)
> +{
> +	struct sk_buff *skb = ctx->skb;
> +	struct net_device *dev;
> +	int ifindex;
> +	struct callback_head *ptr;
> +	void *func;
> +
> +	__builtin_preserve_access_index(({
> +		dev = skb->dev;
> +		ifindex = dev->ifindex;

Hi Alexei,

The patchset looks very useful. One question: Is it always safe to
access 'skb->dev->ifindex' here? I'm asking because 'dev' is inside a
union with 'dev_scratch' which is 'unsigned long' and therefore might
not always be a valid memory address. Consider for example the following
code path:

...
__udp_queue_rcv_skb(sk, skb)
	__udp_enqueue_schedule_skb(sk, skb)
		udp_set_dev_scratch(skb)
		// returns error
	...
	kfree_skb(skb) // ebpf program is invoked

How is this handled by eBPF?

Thanks

> +		ptr = dev->ifalias->rcuhead.next;
> +		func = ptr->func;
> +	}));
> +
> +	bpf_printk("rcuhead.next %llx func %llx\n", ptr, func);
> +	bpf_printk("skb->len %d\n", _(skb->len));
> +	bpf_printk("skb->queue_mapping %d\n", _(skb->queue_mapping));
> +	bpf_printk("dev->ifindex %d\n", ifindex);
> +
> +	/* send first 72 byte of the packet to user space */
> +	bpf_skb_output(skb, &perf_buf_map, (72ull << 32) | BPF_F_CURRENT_CPU,
> +		       &ifindex, sizeof(ifindex));
> +	return 0;
> +}
> -- 
> 2.23.0
> 
