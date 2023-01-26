Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880F967D42D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjAZS23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjAZS20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:28:26 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692B666F9F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:28:07 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z10-20020a170902ccca00b001898329db72so1484972ple.21
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ld20xsyiZsj/yGK6ZQBfBsop69pskhzagkZqynpGOQA=;
        b=GtQlPly1uVqV0wcw/g6KN62470vt5yZirA4UyYqnFORo4FwcD6ZPOLYNaI26yMilnf
         bEpTSPcloCvGLbhO/lmxCJMImyzManV6aTG9gNsk7xZnWEioE3td7qFW0iOoMY1GZrBo
         8MQjLQak0JdvkyVTXdYzOnD6gHJbk98/3p/RLCURVpI2Q3g0seVoaTxOxZg+GHTGsfrD
         d1/sSbBe3wq1D/uqE/0SufWxcvcNNPTRvxr1U2VUVJCEWgKGtgA7th6tCz4Us6LOgBVE
         L8wEIZBVW0wb86Owr66E9/gkaZifAvM3s6E8JSaYotDkJzkD/tnGDyqGMbRF3H5cEyjO
         1Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ld20xsyiZsj/yGK6ZQBfBsop69pskhzagkZqynpGOQA=;
        b=Kg2hMyfudxPPEsThMRkziSm0WqKHduXxMf9FLAUK6/j+mHfYsx9dU47k1ViiOyPJnY
         xNVHJ3OkV+qlnYiwolpAjSpkJhjD9Nrhasn1Be3/1/q+49MacBczAREKhrTAEvJn5xST
         aV67XWttJV2I/xOJFF65BabOE+qIjU0VieWuMRu67tYG0r2SljH6mNm/b2X6Q+9X1/ls
         zZ2nQcn7CBz7a44tMGm09i7a3evjLZQ3SnlnIVG2wHuyutjNymtpdF6RiBwNQ0hzZh4p
         qdjrvOhpbkUW0Sjg5YYS4fcir+0aDn6GbEMTGDm8/l7+X1cRzA/JaUhSNBQuGFw/FQuU
         ps+w==
X-Gm-Message-State: AFqh2kplbPng0MpESMf3ahWjcq0KwQYGFYDWlEtgBCEyKwA3NM4Cx/O/
        ynA9WgjKLfZEo8ixugt2bed7YNU=
X-Google-Smtp-Source: AMrXdXunEGBjDJiFy8IxYeVUll+D1mOg1FfSCwgIObDvYJ4+F7/NWy7UM9q0o00RTcibjLte1wl9kn0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e8d1:b0:195:8b77:6643 with SMTP id
 v17-20020a170902e8d100b001958b776643mr2724060plg.21.1674757683690; Thu, 26
 Jan 2023 10:28:03 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:28:02 -0800
In-Reply-To: <7c403a3a043554df3ebe4b4a94b8e0d97414cb7e.1674737592.git.lorenzo@kernel.org>
Mime-Version: 1.0
References: <cover.1674737592.git.lorenzo@kernel.org> <7c403a3a043554df3ebe4b4a94b8e0d97414cb7e.1674737592.git.lorenzo@kernel.org>
Message-ID: <Y9LGMha3+jPLBXsb@google.com>
Subject: Re: [PATCH v3 bpf-next 7/8] selftests/bpf: add test for bpf_xdp_query
 xdp-features support
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
> Introduce a self-test to verify libbpf bpf_xdp_query capability to dump
> the xdp-features supported by the device (lo and veth in this case).

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>   .../bpf/prog_tests/xdp_do_redirect.c          | 27 ++++++++++++++++++-
>   .../selftests/bpf/prog_tests/xdp_info.c       |  8 ++++++
>   2 files changed, 34 insertions(+), 1 deletion(-)

> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c  
> b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> index a50971c6cf4a..e15fb3f0306c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> @@ -4,10 +4,12 @@
>   #include <net/if.h>
>   #include <linux/if_ether.h>
>   #include <linux/if_packet.h>
> +#include <linux/if_link.h>
>   #include <linux/ipv6.h>
>   #include <linux/in6.h>
>   #include <linux/udp.h>
>   #include <bpf/bpf_endian.h>
> +#include <uapi/linux/netdev.h>
>   #include "test_xdp_do_redirect.skel.h"

>   #define SYS(fmt, ...)						\
> @@ -92,7 +94,7 @@ void test_xdp_do_redirect(void)
>   	struct test_xdp_do_redirect *skel = NULL;
>   	struct nstoken *nstoken = NULL;
>   	struct bpf_link *link;
> -
> +	LIBBPF_OPTS(bpf_xdp_query_opts, query_opts);
>   	struct xdp_md ctx_in = { .data = sizeof(__u32),
>   				 .data_end = sizeof(data) };
>   	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> @@ -153,6 +155,29 @@ void test_xdp_do_redirect(void)
>   	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
>   		goto out;

> +	/* Check xdp features supported by veth driver */
> +	err = bpf_xdp_query(ifindex_src, XDP_FLAGS_DRV_MODE, &query_opts);
> +	if (!ASSERT_OK(err, "veth_src bpf_xdp_query"))
> +		goto out;
> +
> +	if (!ASSERT_EQ(query_opts.fflags,
> +		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> +		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
> +		       NETDEV_XDP_ACT_NDO_XMIT_SG,
> +		       "veth_src query_opts.fflags"))
> +		goto out;
> +
> +	err = bpf_xdp_query(ifindex_dst, XDP_FLAGS_DRV_MODE, &query_opts);
> +	if (!ASSERT_OK(err, "veth_dst bpf_xdp_query"))
> +		goto out;
> +
> +	if (!ASSERT_EQ(query_opts.fflags,
> +		       NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> +		       NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
> +		       NETDEV_XDP_ACT_NDO_XMIT_SG,
> +		       "veth_dst query_opts.fflags"))
> +		goto out;
> +
>   	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
>   	skel->rodata->ifindex_out = ifindex_src; /* redirect back to the same  
> iface */
>   	skel->rodata->ifindex_in = ifindex_src;
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_info.c  
> b/tools/testing/selftests/bpf/prog_tests/xdp_info.c
> index cd3aa340e65e..8397468a9e74 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_info.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_info.c
> @@ -8,6 +8,7 @@ void serial_test_xdp_info(void)
>   {
>   	__u32 len = sizeof(struct bpf_prog_info), duration = 0, prog_id;
>   	const char *file = "./xdp_dummy.bpf.o";
> +	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
>   	struct bpf_prog_info info = {};
>   	struct bpf_object *obj;
>   	int err, prog_fd;
> @@ -61,6 +62,13 @@ void serial_test_xdp_info(void)
>   	if (CHECK(prog_id, "prog_id_drv", "unexpected prog_id=%u\n", prog_id))
>   		goto out;

> +	/* Check xdp features supported by lo device */
> +	opts.fflags = ~0;
> +	err = bpf_xdp_query(IFINDEX_LO, XDP_FLAGS_DRV_MODE, &opts);
> +	if (!ASSERT_OK(err, "bpf_xdp_query"))
> +		goto out;
> +
> +	ASSERT_EQ(opts.fflags, 0, "opts.fflags");
>   out:
>   	bpf_xdp_detach(IFINDEX_LO, 0, NULL);
>   out_close:
> --
> 2.39.1

