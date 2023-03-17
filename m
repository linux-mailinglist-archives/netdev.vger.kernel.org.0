Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9D6BF393
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQVJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCQVJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:09:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B3312049
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 14:09:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536d63d17dbso58888737b3.22
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679087354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QX9P4WNhAiimp8bMVI7pbGpexEm1CSWbcups6XutsBs=;
        b=CRn/98En5qfyN4MiAzQyp3orDvGhevB2bsfsTXD/iSqgiKk5IErgvvQHSm5CjjtyRV
         kMhG+E8HBRAaEjhxFAU3hZY9SkfUsTHDCMyQGWvpoMqGF8Dl65Ee4g6xebnLiAUj2pcJ
         JrOxU9SEy8d9uD3p0eAGbgKSpjWewV4c6qJjyWls47Yd00W2ExjLgEI5qL/YHTD8cSO+
         VtdqZt2hcJc3brmSol1RWbxkqTbWQAYvoScQvtCPjVzjpQHgtLhKB9DqSBvEqltMn0sj
         WZIpNBzTvlqzfRZvXemkkHkEAsKLxNbXM/22tZKFINYMmIkr8V2DsU7YpxzH14UW30bu
         Wv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679087354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QX9P4WNhAiimp8bMVI7pbGpexEm1CSWbcups6XutsBs=;
        b=HVxogYJljSeuJm7IL0ku0w6nEqRxjFJ1ZnU4H2xfiXilYoHXQ6IlKCyQoseMm+KuyV
         hCK10F3udTizmZXLUSws9/OIVOjMjVvpp1R6o8rOLbMfQbhRK1wCUM9Me2StjXQP7LRH
         oe3dQUTcDS7fCOqJ5vQZ3DIMe7902/lLq2QmdkSmNr2O8cRCq2r9vbGEYKJHqp6G27f7
         0ZSr8GlrU+6frIGrO2OvK1P06FgBL4Y+bP1GACMZiMvh5orxraBp0ZLAj644+uu2So2l
         pl3Jmxs3QqunTFh22qaRwsMMN5Og2SArnGlVozvmlRx3Inlp968YuaU2fmYCrvRueeOI
         /53Q==
X-Gm-Message-State: AO0yUKXQs62GySzBYjT91Gb6dzFFu4VTwPuRrAHjEcYjdozDt1+WvLmr
        r8EQfgLF9lR2MRoTuuphxFi6umk=
X-Google-Smtp-Source: AK7set9p/saix2JDOUGzrqPV0lqYjOfCIZCKDJWI3pqUDlD39c2PxuVf/4OiqY4JENYN7TUKXu9Hlmc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:1d0:b0:a5f:0:bf12 with SMTP id
 u16-20020a05690201d000b00a5f0000bf12mr515676ybh.13.1679087353838; Fri, 17 Mar
 2023 14:09:13 -0700 (PDT)
Date:   Fri, 17 Mar 2023 14:09:12 -0700
In-Reply-To: <167906360589.2706833.6188844928251441787.stgit@firesoul>
Mime-Version: 1.0
References: <167906343576.2706833.17489167761084071890.stgit@firesoul> <167906360589.2706833.6188844928251441787.stgit@firesoul>
Message-ID: <ZBTW+NP1pLPlXRqa@google.com>
Subject: Re: [PATCH bpf-next V1 3/7] selftests/bpf: xdp_hw_metadata track more timestamps
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com
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

On 03/17, Jesper Dangaard Brouer wrote:
> To correlate the hardware RX timestamp with something, add tracking of
> two software timestamps both clock source CLOCK_TAI (see description in
> man clock_gettime(2)).

> XDP metadata is extended with xdp_timestamp for capturing when XDP
> received the packet. Populated with BPF helper bpf_ktime_get_tai_ns(). I
> could not find a BPF helper for getting CLOCK_REALTIME, which would have
> been preferred. In userspace when AF_XDP sees the packet another
> software timestamp is recorded via clock_gettime() also clock source
> CLOCK_TAI.

> Example output shortly after loading igc driver:

>    poll: 1 (0)
>    xsk_ring_cons__peek: 1
>    0x11fc958: rx_desc[7]->addr=10000000000f000 addr=f100 comp_addr=f000
>    rx_hash: 0x00000000
>    rx_timestamp:  1676297171760293047 (sec:1676297171.7603)
>    XDP RX-time:   1676297208760355863 (sec:1676297208.7604) delta  
> sec:37.0001
>    AF_XDP time:   1676297208760416292 (sec:1676297208.7604) delta  
> sec:0.0001 (60.429 usec)
>    0x11fc958: complete idx=15 addr=f000

> The first observation is that the 37 sec difference between RX HW vs XDP
> timestamps, which indicate hardware is likely clock source
> CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
> with a 37 sec offset.

> The 60 usec (microsec) difference between XDP vs AF_XDP userspace is the
> userspace wakeup time. On this hardware it was caused by CPU idle sleep
> states, which can be reduced by tuning /dev/cpu_dma_latency.

> View current requested/allowed latency bound via:
>    hexdump --format '"%d\n"' /dev/cpu_dma_latency

> More explanation of the output and how this can be used to identify
> clock drift for the HW clock can be seen here[1]:

> [1]  
> https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

With a small nit below.

> ---
>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    8 ++-
>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |   46  
> ++++++++++++++++++--
>   tools/testing/selftests/bpf/xdp_metadata.h         |    1
>   3 files changed, 47 insertions(+), 8 deletions(-)

> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c  
> b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 4c55b4d79d3d..f2a3b70a9882 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -69,9 +69,11 @@ int rx(struct xdp_md *ctx)
>   		return XDP_PASS;
>   	}

> -	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
> -		bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
> -	else
> +	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp)) {
> +		meta->xdp_timestamp = bpf_ktime_get_tai_ns();
> +		bpf_printk("populated rx_timestamp with  %llu", meta->rx_timestamp);
> +		bpf_printk("populated xdp_timestamp with %llu", meta->xdp_timestamp);
> +	} else
>   		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */

Nit: curly braces around else {} block as well?


>   	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c  
> b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> index 1c8acb68b977..400bfe19abfe 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -27,6 +27,7 @@
>   #include <sys/mman.h>
>   #include <net/if.h>
>   #include <poll.h>
> +#include <time.h>

>   #include "xdp_metadata.h"

> @@ -134,14 +135,47 @@ static void refill_rx(struct xsk *xsk, __u64 addr)
>   	}
>   }

> -static void verify_xdp_metadata(void *data)
> +#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
> +static __u64 gettime(clockid_t clock_id)
> +{
> +	struct timespec t;
> +	int res;
> +
> +	/* See man clock_gettime(2) for type of clock_id's */
> +	res = clock_gettime(clock_id, &t);
> +
> +	if (res < 0)
> +		error(res, errno, "Error with clock_gettime()");
> +
> +	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
> +}
> +
> +static void verify_xdp_metadata(void *data, clockid_t clock_id)
>   {
>   	struct xdp_meta *meta;

>   	meta = data - sizeof(*meta);

> -	printf("rx_timestamp: %llu\n", meta->rx_timestamp);
>   	printf("rx_hash: %u\n", meta->rx_hash);
> +	printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
> +	       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
> +	if (meta->rx_timestamp) {
> +		__u64 usr_clock = gettime(clock_id);
> +		__u64 xdp_clock = meta->xdp_timestamp;
> +		__s64 delta_X = xdp_clock - meta->rx_timestamp;
> +		__s64 delta_X2U = usr_clock - xdp_clock;
> +
> +		printf("XDP RX-time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f  
> usec)\n",
> +		       xdp_clock, (double)xdp_clock / NANOSEC_PER_SEC,
> +		       (double)delta_X / NANOSEC_PER_SEC,
> +		       (double)delta_X / 1000);
> +
> +		printf("AF_XDP time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f  
> usec)\n",
> +		       usr_clock, (double)usr_clock / NANOSEC_PER_SEC,
> +		       (double)delta_X2U / NANOSEC_PER_SEC,
> +		       (double)delta_X2U / 1000);
> +	}
> +
>   }

>   static void verify_skb_metadata(int fd)
> @@ -189,7 +223,7 @@ static void verify_skb_metadata(int fd)
>   	printf("skb hwtstamp is not found!\n");
>   }

> -static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
> +static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd,  
> clockid_t clock_id)
>   {
>   	const struct xdp_desc *rx_desc;
>   	struct pollfd fds[rxq + 1];
> @@ -237,7 +271,8 @@ static int verify_metadata(struct xsk *rx_xsk, int  
> rxq, int server_fd)
>   			addr = xsk_umem__add_offset_to_addr(rx_desc->addr);
>   			printf("%p: rx_desc[%u]->addr=%llx addr=%llx comp_addr=%llx\n",
>   			       xsk, idx, rx_desc->addr, addr, comp_addr);
> -			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr));
> +			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr),
> +					    clock_id);
>   			xsk_ring_cons__release(&xsk->rx, 1);
>   			refill_rx(xsk, comp_addr);
>   		}
> @@ -364,6 +399,7 @@ static void timestamping_enable(int fd, int val)

>   int main(int argc, char *argv[])
>   {
> +	clockid_t clock_id = CLOCK_TAI;
>   	int server_fd = -1;
>   	int ret;
>   	int i;
> @@ -437,7 +473,7 @@ int main(int argc, char *argv[])
>   		error(1, -ret, "bpf_xdp_attach");

>   	signal(SIGINT, handle_signal);
> -	ret = verify_metadata(rx_xsk, rxq, server_fd);
> +	ret = verify_metadata(rx_xsk, rxq, server_fd, clock_id);
>   	close(server_fd);
>   	cleanup();
>   	if (ret)
> diff --git a/tools/testing/selftests/bpf/xdp_metadata.h  
> b/tools/testing/selftests/bpf/xdp_metadata.h
> index f6780fbb0a21..260345b2c6f1 100644
> --- a/tools/testing/selftests/bpf/xdp_metadata.h
> +++ b/tools/testing/selftests/bpf/xdp_metadata.h
> @@ -11,5 +11,6 @@

>   struct xdp_meta {
>   	__u64 rx_timestamp;
> +	__u64 xdp_timestamp;
>   	__u32 rx_hash;
>   };


