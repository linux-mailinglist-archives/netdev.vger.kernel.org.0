Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4192BB899
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKTVvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgKTVvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 16:51:05 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A423C0613CF;
        Fri, 20 Nov 2020 13:51:05 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 131so9153696pfb.9;
        Fri, 20 Nov 2020 13:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=15x9oN4lE6NCr7rYJM+9lvk6nGck27y4SvqopIZJ3PQ=;
        b=THK0TbFwuzsee6mbWjIucclFaHTMomCGZTxoUhLrMb3NGYhUuDrxum8OLfg1Zoxpn6
         e4wQybO+q9cByd+M8E1Lg0NHV/lIyVa+1EHZkVS57IY1SyR1ETsohP3n7U9y6+IIPpRm
         CfMfbh4aiYlTGYcTIyrLJ8YiOj4fV4qh9sg0CqKs6Uz+1OWvRACzsoeFrQMtjWvjWmbn
         q/OlhFAx49EAYS/hUL9i+IuE6UzPe5auIObR1W2XV1gUBkixJ/qmsMZUKzh8eRO9m9m8
         iIYB/JluQlK5Mw9S072P4R+sgsMrNEV+pj/bVbLYv78iJGANjReRgAqHmAJDh2EG8F9l
         PURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15x9oN4lE6NCr7rYJM+9lvk6nGck27y4SvqopIZJ3PQ=;
        b=haU0DeBV+8MVD1tVav2J+M0FTifYsRMzs++gk584mkrTNyADOvXQft+pvtZ2iS30pS
         q71oUmsrc0GbVljEZruLGc/4RUgh1C+6482yncwdYY26JJgVYFEcN1I4bYTLKyH7OOvs
         AL7gMBNddmjqdUvLgTcIRkdWaMQA6U7R0UUu69lty/3RJ0iMCXJn0zsLKiG5U/WHFxit
         ++xgeWgYPsJjY5fyhYYQ9JQ145c1SMEUa0Iw5xpFHuoPIrZPUWGB1aW9vYIFft1Iym7+
         Sz4+qPnLOBPa+1Zodrkhwrlu9rm+IlTFKqTIz+xwtgCxhi2yDviF7kh0pTTGq3g/iMt6
         DUgA==
X-Gm-Message-State: AOAM532JgFL6qOkF5QDXnXG9Nh6oSs3iClV0AaimW2JQ27fWpiWqG1pK
        kcKkqMhk1XBLh1lB2bcgIc8=
X-Google-Smtp-Source: ABdhPJyXGNnXKP2eLXQWcS0KTs9mHTDGi+ekXKR3UEZBi8+qpBZxvFg+2JZFRzgxtAEepV+R3mhDgw==
X-Received: by 2002:a05:6a00:13a3:b029:18b:d5d2:196 with SMTP id t35-20020a056a0013a3b029018bd5d20196mr16378156pfg.62.1605909064902;
        Fri, 20 Nov 2020 13:51:04 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:501])
        by smtp.gmail.com with ESMTPSA id n10sm4291091pgb.45.2020.11.20.13.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 13:51:03 -0800 (PST)
Date:   Fri, 20 Nov 2020 13:50:51 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>, maze@google.com,
        lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Subject: Re: [PATCH bpf-next V7 8/8] bpf/selftests: activating bpf_check_mtu
 BPF-helper
Message-ID: <20201120215051.cqrlmxtujrgaidc6@ast-mbp>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
 <160588912738.2817268.9380466634324530673.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160588912738.2817268.9380466634324530673.stgit@firesoul>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 05:18:47PM +0100, Jesper Dangaard Brouer wrote:
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |   37 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |   33 ++++++++++++++++++
>  2 files changed, 70 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> new file mode 100644
> index 000000000000..09b8f986a17b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Red Hat */
> +#include <uapi/linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <test_progs.h>
> +
> +#include "test_check_mtu.skel.h"
> +#define IFINDEX_LO 1
> +
> +void test_check_mtu_xdp(struct test_check_mtu *skel)
> +{
> +	int err = 0;
> +	int fd;
> +
> +	fd = bpf_program__fd(skel->progs.xdp_use_helper);
> +	err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
> +	if (CHECK_FAIL(err))
> +		return;
> +
> +	bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
> +}
> +
> +void test_check_mtu(void)
> +{
> +	struct test_check_mtu *skel;
> +
> +	skel = test_check_mtu__open_and_load();
> +	if (CHECK_FAIL(!skel)) {
> +		perror("test_check_mtu__open_and_load");
> +		return;
> +	}
> +
> +	if (test__start_subtest("bpf_check_mtu XDP-attach"))
> +		test_check_mtu_xdp(skel);
> +
> +	test_check_mtu__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> new file mode 100644
> index 000000000000..ab97ec925a32
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Red Hat */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#include <stddef.h>
> +#include <stdint.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("xdp")
> +int xdp_use_helper(struct xdp_md *ctx)
> +{
> +	uint32_t mtu_len = 0;
> +	int delta = 20;
> +
> +	if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
> +		return XDP_ABORTED;
> +	}
> +	return XDP_PASS;
> +}
> +
> +SEC("classifier")
> +int tc_use_helper(struct __sk_buff *ctx)
> +{
> +	uint32_t mtu_len = 0;
> +	int delta = -20;
> +
> +	if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
> +		return BPF_DROP;
> +	}
> +	return BPF_OK;
> +}

Patches 7 and 8 are not adequate as tests.
They do not testing the functionality of earlier patches.
bpf_check_mtu() could be returning random value and "tests" 7 and 8 would still pass.
Please fix.
