Return-Path: <netdev+bounces-5709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DF6712829
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991CF1C210B2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2D524EA0;
	Fri, 26 May 2023 14:23:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF001EA6F;
	Fri, 26 May 2023 14:23:27 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DD1187;
	Fri, 26 May 2023 07:23:25 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-62388997422so5587336d6.1;
        Fri, 26 May 2023 07:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685111004; x=1687703004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7pzs+ot6GX0pOq4mV/zLM0VmkMsQYwQ+eUZRde1RBZM=;
        b=cFCQIBl0ggi1gGUWHZs/LNWdn4/1HIj/72aNXk74smSPYO/uZlPhI740g0qWhWr0/y
         iwY1ln2Me12qIoCXn9Wyd+TD1zQ6u89GxqkBAg36Qs19iVczflWfHxg8Th9/wziCcW2r
         JQbf2nkX6aXnDymflZtG6S15W3Hu0nPTe3GK0+qUij/jSsgo0xPTDXTzkKf4sYxM+mi3
         BtfOTXdhbAexDNmnu/D3GkV8tzGIxXzQ/iBSaxRHP/iVPOai8Tf7MoxGemtYzUW4JNkF
         9hSr/ZscpbKQs4B1zh7V0etL5Ft3ed/dz2Rf9VI5yXaQ2x2qSQ3uq50tjgl8GHL6qPzn
         +BHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685111004; x=1687703004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pzs+ot6GX0pOq4mV/zLM0VmkMsQYwQ+eUZRde1RBZM=;
        b=mDx/3115P/Qi5rgWrkNZsC+7M0Cl6siDoOuzR6JXVAX+EXz/00mCmd+kbDC2X7zeMJ
         EcDI9CIRY0uY0LQyqajvNkbt25Ga0ZpIKpvphTyn/STdsI6AbPp7tu1yxhupwTylGvg7
         tSZnP4WGWkScRapebm8sN0ksviNsdVgx7FF2XQQPKP/Rd3I7oBhfSVXn2Nhp4auAG5bC
         cj+QuyZY94QWBf6/bMwZwNqW6iyXiNB/MQwvjdGVqYUAL6MrAu1Hapf3f1g6SiAUGVk9
         Noq1gVfiChU+tdUcYBXK09nYBPNFHD0qtw5dWA3Dh7Per9d1M6NCFnMxgS9kjPchShwt
         fRpg==
X-Gm-Message-State: AC+VfDz6mz6bStQalVE6nOPPX1yU2fRO0F0Rf5zRlaD9QmTIOmod16dm
	KLEpikLjUHozZFOtVqulSxg=
X-Google-Smtp-Source: ACHHUZ5KpuTSlNgZ0/cWsJDoAuAed+vheTnYsDSRlM1M4taZdQvYWQpL33wUBbsKG6iU1HnDcKu7lg==
X-Received: by 2002:a05:6214:1bc5:b0:625:aa1a:937f with SMTP id m5-20020a0562141bc500b00625aa1a937fmr2271516qvc.59.1685111004457;
        Fri, 26 May 2023 07:23:24 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id x10-20020ae9f80a000000b00759333a57adsm1206937qkh.11.2023.05.26.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 07:23:23 -0700 (PDT)
Date: Fri, 26 May 2023 10:23:23 -0400
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
To: Yonghong Song <yhs@meta.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
Subject: Re: [PATCH 2/2] bpf: test table ID fib lookup BPF helper
Message-ID: <ZHDA21KGHCqdrHMb@fedora>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-2-fd99f7162e76@gmail.com>
 <924ee916-b7a4-a17f-30df-2e5ab4251d3f@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924ee916-b7a4-a17f-30df-2e5ab4251d3f@meta.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:02:54PM -0700, Yonghong Song wrote:
> 
> 
> On 5/25/23 7:28 AM, Louis DeLosSantos wrote:
> > Add additional test cases to `fib_lookup.c` prog_test.
> 
> For the subject line:
>   bpf: test table ID fib lookup BPF helper
> to
>   selftests/bpf: test table ID fib lookup BPF helper

Ack, will fix this on new rev.

> 
> > 
> > These test cases add a new /24 network to the previously unused veth2
> > device, removes the directly connected route from the main routing table
> > and moves it to table 100.
> > 
> > The first test case then confirms a fib lookup for a remote address in this
> > directly connected network, using the main routing table fails.
> > 
> > The second test case ensures the same fib lookup using table 100
> > succeeds.
> > 
> > An additional pair of tests which function in the same manner are added
> > for IPv6.
> > 
> > Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
> > ---
> >   .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 58 +++++++++++++++++++---
> >   1 file changed, 50 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> > index a1e7121058118..e8d1f35780d75 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
> > @@ -1,6 +1,8 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   /* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
> > +#include "linux/bpf.h"
> > +#include <linux/rtnetlink.h>
> >   #include <sys/types.h>
> >   #include <net/if.h>
> > @@ -15,14 +17,23 @@
> >   #define IPV4_IFACE_ADDR		"10.0.0.254"
> >   #define IPV4_NUD_FAILED_ADDR	"10.0.0.1"
> >   #define IPV4_NUD_STALE_ADDR	"10.0.0.2"
> > +#define IPV4_TBID_ADDR		"172.0.0.254"
> > +#define IPV4_TBID_NET		"172.0.0.0"
> > +#define IPV4_TBID_DST		"172.0.0.2"
> > +#define IPV6_TBID_ADDR		"fd00::FFFF"
> > +#define IPV6_TBID_NET		"fd00::"
> > +#define IPV6_TBID_DST		"fd00::2"
> >   #define DMAC			"11:11:11:11:11:11"
> >   #define DMAC_INIT { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, }
> > +#define DMAC2			"01:01:01:01:01:01"
> > +#define DMAC_INIT2 { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, }
> >   struct fib_lookup_test {
> >   	const char *desc;
> >   	const char *daddr;
> >   	int expected_ret;
> >   	int lookup_flags;
> > +	__u32 tbid;
> >   	__u8 dmac[6];
> >   };
> > @@ -43,6 +54,18 @@ static const struct fib_lookup_test tests[] = {
> >   	{ .desc = "IPv4 skip neigh",
> >   	  .daddr = IPV4_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
> >   	  .lookup_flags = BPF_FIB_LOOKUP_SKIP_NEIGH, },
> > +	{ .desc = "IPv4 TBID lookup failure",
> > +	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
> > +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT },
> > +	{ .desc = "IPv4 TBID lookup success",
> > +	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
> > +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
> > +	{ .desc = "IPv6 TBID lookup failure",
> > +	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
> > +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, },
> > +	{ .desc = "IPv6 TBID lookup success",
> > +	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
> > +	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
> >   };
> >   static int ifindex;
> > @@ -53,6 +76,7 @@ static int setup_netns(void)
> >   	SYS(fail, "ip link add veth1 type veth peer name veth2");
> >   	SYS(fail, "ip link set dev veth1 up");
> > +	SYS(fail, "ip link set dev veth2 up");
> >   	err = write_sysctl("/proc/sys/net/ipv4/neigh/veth1/gc_stale_time", "900");
> >   	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.neigh.veth1.gc_stale_time)"))
> > @@ -70,6 +94,17 @@ static int setup_netns(void)
> >   	SYS(fail, "ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
> >   	SYS(fail, "ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
> > +	/* Setup for tbid lookup tests */
> > +	SYS(fail, "ip addr add %s/24 dev veth2", IPV4_TBID_ADDR);
> > +	SYS(fail, "ip route del %s/24 dev veth2", IPV4_TBID_NET);
> > +	SYS(fail, "ip route add table 100 %s/24 dev veth2", IPV4_TBID_NET);
> > +	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV4_TBID_DST, DMAC2);
> > +
> > +	SYS(fail, "ip addr add %s/64 dev veth2", IPV6_TBID_ADDR);
> > +	SYS(fail, "ip -6 route del %s/64 dev veth2", IPV6_TBID_NET);
> > +	SYS(fail, "ip -6 route add table 100 %s/64 dev veth2", IPV6_TBID_NET);
> > +	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV6_TBID_DST, DMAC2);
> > +
> >   	err = write_sysctl("/proc/sys/net/ipv4/conf/veth1/forwarding", "1");
> >   	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.conf.veth1.forwarding)"))
> >   		goto fail;
> > @@ -83,7 +118,7 @@ static int setup_netns(void)
> >   	return -1;
> >   }
> > -static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
> > +static int set_lookup_params(struct bpf_fib_lookup *params, const struct fib_lookup_test *test)
> >   {
> >   	int ret;
> > @@ -91,8 +126,9 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
> >   	params->l4_protocol = IPPROTO_TCP;
> >   	params->ifindex = ifindex;
> > +	params->tbid = test->tbid;
> > -	if (inet_pton(AF_INET6, daddr, params->ipv6_dst) == 1) {
> > +	if (inet_pton(AF_INET6, test->daddr, params->ipv6_dst) == 1) {
> >   		params->family = AF_INET6;
> >   		ret = inet_pton(AF_INET6, IPV6_IFACE_ADDR, params->ipv6_src);
> >   		if (!ASSERT_EQ(ret, 1, "inet_pton(IPV6_IFACE_ADDR)"))
> > @@ -100,7 +136,7 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
> >   		return 0;
> >   	}
> > -	ret = inet_pton(AF_INET, daddr, &params->ipv4_dst);
> > +	ret = inet_pton(AF_INET, test->daddr, &params->ipv4_dst);
> >   	if (!ASSERT_EQ(ret, 1, "convert IP[46] address"))
> >   		return -1;
> >   	params->family = AF_INET;
> > @@ -154,13 +190,12 @@ void test_fib_lookup(void)
> >   	fib_params = &skel->bss->fib_params;
> >   	for (i = 0; i < ARRAY_SIZE(tests); i++) {
> > -		printf("Testing %s\n", tests[i].desc);
> > +		printf("Testing %s ", tests[i].desc);
> > -		if (set_lookup_params(fib_params, tests[i].daddr))
> > +		if (set_lookup_params(fib_params, &tests[i]))
> >   			continue;
> >   		skel->bss->fib_lookup_ret = -1;
> > -		skel->bss->lookup_flags = BPF_FIB_LOOKUP_OUTPUT |
> > -			tests[i].lookup_flags;
> > +		skel->bss->lookup_flags = tests[i].lookup_flags;
> >   		err = bpf_prog_test_run_opts(prog_fd, &run_opts);
> >   		if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
> > @@ -175,7 +210,14 @@ void test_fib_lookup(void)
> >   			mac_str(expected, tests[i].dmac);
> >   			mac_str(actual, fib_params->dmac);
> > -			printf("dmac expected %s actual %s\n", expected, actual);
> > +			printf("dmac expected %s actual %s ", expected, actual);
> > +		}
> > +
> > +		// ensure tbid is zero'd out after fib lookup.
> > +		if (tests[i].lookup_flags & BPF_FIB_LOOKUP_DIRECT) {
> > +			if (!ASSERT_EQ(skel->bss->fib_params.tbid, 0,
> > +					"expected fib_params.tbid to be zero"))
> > +				goto fail;
> >   		}
> >   	}
> > 

