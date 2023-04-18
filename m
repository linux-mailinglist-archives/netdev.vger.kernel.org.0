Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0CC6E69AE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjDRQhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjDRQhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:37:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEAB13F80
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:36:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a52677bd54so15807495ad.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 09:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681835817; x=1684427817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9YRxXD8puKeodnRmfFR1vS7nIa0MLvGxReiWsVsB114=;
        b=cP9Wb3q0J2RsMS47VpvSRwLb2B0BplMhzW8SNTEmI+Ecr6kMR/FsvOBMcvuyjq1iOB
         FMfMo26jKaZdP9cu9+3gm4wySriV8mMRvyy2tVpB/l1/G+GJ708Ewx+XB1cN+2IdaSr6
         V8J80jOqA+eTIPqCmLk7P4JLiwrwY6aD12jjb5eE/hSFyIKb185C1m8NLEaOYheJalWd
         wz5MCF9IF1ERD78Pq57bO7qp/5KVQv+Cx6mDkEFMPumXXSqMQgXQJiHr9HvI+28pPG5o
         wxA+EIPuAGoGmSLR+H13CSkEOjP/HM9Rose2ge8/4v7bzV+NbTIrX93bqG8Q+gZFGKzi
         YmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835817; x=1684427817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9YRxXD8puKeodnRmfFR1vS7nIa0MLvGxReiWsVsB114=;
        b=B7RNKhud5Gk2yr/dJ3pvG8Fl9UP8QS1ZW2rQNBhWFAt0uT3LXypmBqU3CZ3WImJ4Mc
         lv8qtp8eugUmMch7aDtTchrpDrNyz8xfWlj1G4y1TOOz8lS0QnrBsAhwOd8UZdQOufnn
         qveXXwQgDkTHG3Ppedz8EFOrz7qLWOg1037/T04hRLQAYrvaacXVNjGU9F0al4fpug7A
         jzEWJXvWvdCkikfx9a8GtYHtEwu0V5N5B2CSk2y18j9cSpdY3ZED1r9Dq5WhLeVK9eeh
         uEwFNed0YJR8CzVBi+ls1bBThgB/OIctroPvc3Zh92FRM6odPtj+ZpRQaVxYnsCN3wFX
         WOcg==
X-Gm-Message-State: AAQBX9e+QZUcpLN0dOLPHfTvJKvIJFUWNoVr2sAEdAB8aUbJ7OLTERdi
        IiC1kGPVS36eNmQjUjT5efoCAcpQTmsAolJ+KwP58CFM4xwKb69EOEiWpuh4i1Qx0iqnnfgA/go
        cvr26oUll
X-Google-Smtp-Source: AKy350a6vJspedkwteHPLHHvL3ump5hEvinsRyPF72ZBoiGG5SHEuf7kzAx9m6Py0RtIDJ8Cvm6CXkE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:d3:b0:1a6:cac9:e434 with SMTP id
 x19-20020a17090300d300b001a6cac9e434mr941835plc.13.1681835817204; Tue, 18 Apr
 2023 09:36:57 -0700 (PDT)
Date:   Tue, 18 Apr 2023 09:36:55 -0700
In-Reply-To: <168182466298.616355.2544377890818617459.stgit@firesoul>
Mime-Version: 1.0
References: <168182460362.616355.14591423386485175723.stgit@firesoul> <168182466298.616355.2544377890818617459.stgit@firesoul>
Message-ID: <ZD7HJ3hdDdOSm/lK@google.com>
Subject: Re: [PATCH bpf-next V2 5/5] selftests/bpf: xdp_hw_metadata track more timestamps
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org,
        "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>,
        netdev@vger.kernel.org, martin.lau@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        yoong.siang.song@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset="us-ascii"
X-ccpol: medium
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/18, Jesper Dangaard Brouer wrote:
> To correlate the hardware RX timestamp with something, add tracking of
> two software timestamps both clock source CLOCK_TAI (see description in
> man clock_gettime(2)).
> 
> XDP metadata is extended with xdp_timestamp for capturing when XDP
> received the packet. Populated with BPF helper bpf_ktime_get_tai_ns(). I
> could not find a BPF helper for getting CLOCK_REALTIME, which would have
> been preferred. In userspace when AF_XDP sees the packet another
> software timestamp is recorded via clock_gettime() also clock source
> CLOCK_TAI.
> 
> Example output shortly after loading igc driver:
> 
>   poll: 1 (0) skip=1 fail=0 redir=2
>   xsk_ring_cons__peek: 1
>   0x12557a8: rx_desc[1]->addr=100000000009000 addr=9100 comp_addr=9000
>   rx_hash: 0x82A96531 with RSS type:0x1
>   rx_timestamp:  1681740540304898909 (sec:1681740540.3049)
>   XDP RX-time:   1681740577304958316 (sec:1681740577.3050) delta sec:37.0001 (37000059.407 usec)
>   AF_XDP time:   1681740577305051315 (sec:1681740577.3051) delta sec:0.0001 (92.999 usec)
>   0x12557a8: complete idx=9 addr=9000
> 
> The first observation is that the 37 sec difference between RX HW vs XDP
> timestamps, which indicate hardware is likely clock source
> CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
> with a 37 sec offset.
> 
> The 93 usec (microsec) difference between XDP vs AF_XDP userspace is the
> userspace wakeup time. On this hardware it was caused by CPU idle sleep
> states, which can be reduced by tuning /dev/cpu_dma_latency.
> 
> View current requested/allowed latency bound via:
>   hexdump --format '"%d\n"' /dev/cpu_dma_latency
> 
> More explanation of the output and how this can be used to identify
> clock drift for the HW clock can be seen here[1]:
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    4 +-
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |   47 ++++++++++++++++++--
>  tools/testing/selftests/bpf/xdp_metadata.h         |    1 
>  3 files changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> index e1c787815e44..b2dfd7066c6e 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -77,7 +77,9 @@ int rx(struct xdp_md *ctx)
>  	}
>  
>  	err = bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp);
> -	if (err)

[..]

> +	if (!err)
> +		meta->xdp_timestamp = bpf_ktime_get_tai_ns();

nit: why not set it unconditionally?

> +	else
>  		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
>  
>  	err = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_hash_type);
> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> index 987cf0db5ebc..613321eb84c1 100644
> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -27,6 +27,7 @@
>  #include <sys/mman.h>
>  #include <net/if.h>
>  #include <poll.h>
> +#include <time.h>
>  
>  #include "xdp_metadata.h"
>  
> @@ -134,18 +135,52 @@ static void refill_rx(struct xsk *xsk, __u64 addr)
>  	}
>  }
>  
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
>  {
>  	struct xdp_meta *meta;
>  
>  	meta = data - sizeof(*meta);
>  
> -	printf("rx_timestamp: %llu\n", meta->rx_timestamp);
>  	if (meta->rx_hash_err < 0)
>  		printf("No rx_hash err=%d\n", meta->rx_hash_err);
>  	else
>  		printf("rx_hash: 0x%X with RSS type:0x%X\n",
>  		       meta->rx_hash, meta->rx_hash_type);
> +
> +	printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
> +	       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
> +	if (meta->rx_timestamp) {
> +		__u64 usr_clock = gettime(clock_id);
> +		__u64 xdp_clock = meta->xdp_timestamp;
> +		__s64 delta_X = xdp_clock - meta->rx_timestamp;
> +		__s64 delta_X2U = usr_clock - xdp_clock;
> +
> +		printf("XDP RX-time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f usec)\n",
> +		       xdp_clock, (double)xdp_clock / NANOSEC_PER_SEC,
> +		       (double)delta_X / NANOSEC_PER_SEC,
> +		       (double)delta_X / 1000);
> +
> +		printf("AF_XDP time:   %llu (sec:%0.4f) delta sec:%0.4f (%0.3f usec)\n",
> +		       usr_clock, (double)usr_clock / NANOSEC_PER_SEC,
> +		       (double)delta_X2U / NANOSEC_PER_SEC,
> +		       (double)delta_X2U / 1000);
> +	}
> +
>  }
>  
>  static void verify_skb_metadata(int fd)
> @@ -193,7 +228,7 @@ static void verify_skb_metadata(int fd)
>  	printf("skb hwtstamp is not found!\n");
>  }
>  
> -static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
> +static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t clock_id)
>  {
>  	const struct xdp_desc *rx_desc;
>  	struct pollfd fds[rxq + 1];
> @@ -243,7 +278,8 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
>  			addr = xsk_umem__add_offset_to_addr(rx_desc->addr);
>  			printf("%p: rx_desc[%u]->addr=%llx addr=%llx comp_addr=%llx\n",
>  			       xsk, idx, rx_desc->addr, addr, comp_addr);
> -			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr));
> +			verify_xdp_metadata(xsk_umem__get_data(xsk->umem_area, addr),
> +					    clock_id);
>  			xsk_ring_cons__release(&xsk->rx, 1);
>  			refill_rx(xsk, comp_addr);
>  		}
> @@ -370,6 +406,7 @@ static void timestamping_enable(int fd, int val)
>  
>  int main(int argc, char *argv[])
>  {
> +	clockid_t clock_id = CLOCK_TAI;
>  	int server_fd = -1;
>  	int ret;
>  	int i;
> @@ -443,7 +480,7 @@ int main(int argc, char *argv[])
>  		error(1, -ret, "bpf_xdp_attach");
>  
>  	signal(SIGINT, handle_signal);
> -	ret = verify_metadata(rx_xsk, rxq, server_fd);
> +	ret = verify_metadata(rx_xsk, rxq, server_fd, clock_id);
>  	close(server_fd);
>  	cleanup();
>  	if (ret)
> diff --git a/tools/testing/selftests/bpf/xdp_metadata.h b/tools/testing/selftests/bpf/xdp_metadata.h
> index 0c4624dc6f2f..938a729bd307 100644
> --- a/tools/testing/selftests/bpf/xdp_metadata.h
> +++ b/tools/testing/selftests/bpf/xdp_metadata.h
> @@ -11,6 +11,7 @@
>  
>  struct xdp_meta {
>  	__u64 rx_timestamp;
> +	__u64 xdp_timestamp;
>  	__u32 rx_hash;
>  	union {
>  		__u32 rx_hash_type;
> 
> 
