Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99ECB1C762D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgEFQWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729602AbgEFQWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:22:48 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A0C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 09:22:48 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id z8so2304374qki.13
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 09:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pBaYS/zRDsmCVekc9n8QZVM5xQS1xxpuk4Dp4Gq4AxE=;
        b=koVZdzWisFYQQW4jtDFXuWwjdvFUO1kntTaogi7y4w/Aa0zCnSO92NJ4SSklZcCs+/
         G8E5qZwZ7S2f4HeqFWHhR8fBdudNSE6PKU4PuUOV5z60UGVmgRK46Kt3rfvZkoLpdzMV
         WDvgaut8PIYtO/Ve585eVVzaEiX+7qZZDQ6hDLWkiWTHg7Za7fz5ZgUlLDIIzkU6K2wz
         mVVzqaquQfdEE/7VnulsS4PpyvHKaOpBWCYeokh8BRbZT9vbKVkBd+pPkvp5Qzk3gwtk
         hChcHMuXfV5P7/RnZ14X+rKxHd1g41sn4YYTa7WF7s50/UWN1jvFK45XHLSTE5A7Xh+n
         bmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pBaYS/zRDsmCVekc9n8QZVM5xQS1xxpuk4Dp4Gq4AxE=;
        b=jkI28pI25O5Wf9R3BKewjJa+3DXc2f3veYhummLuUdBdulm0MH5CN7H7yE0lHTihsj
         sX+l+1A6i9wyzJ7XSXUz3fotkaI4Lc+OjrqZaUfsMtcvkGAq7m9B2CpsynwIp0dHEBM6
         yF4nnBMRTQgYwXoae0UX+VjDAl1wlDAehypPrOJUTlyiNIRkaJSH8NJYOH8Hu2s0UYNm
         Z3LWrBOMl0UWXqmGP7yYjhxOME1UwloL1AZghGt6Cb8Z2bithhW0Ufyjtsb1iOhjmBat
         gR+5j5uDoAYGWQYFt3uRujzFHGJeS67zmzX9XO7I+Ak9IFOPFh0szUGkngxNgrBXRXWQ
         2Mbg==
X-Gm-Message-State: AGi0PubcBr9jQ/ey3FcLhTbjOz1Qyhf+1uDokSeNPMFlNLtkSoiaCnED
        513hAsDkhwu1Ka15iqG3ympQiBI=
X-Google-Smtp-Source: APiQypLSmgKPqW/8zcAgEy32SmMjTd6pt/FHFwYYyD4BlLJ6jmQ800lv7GfFcxZmcYE9V3YwL/mI5YM=
X-Received: by 2002:ad4:4d06:: with SMTP id l6mr9033599qvl.34.1588782167494;
 Wed, 06 May 2020 09:22:47 -0700 (PDT)
Date:   Wed, 6 May 2020 09:22:45 -0700
In-Reply-To: <20200506062342.6tncscx63wz6udby@kafai-mbp>
Message-Id: <20200506162245.GG241848@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com> <20200505202730.70489-5-sdf@google.com>
 <20200506062342.6tncscx63wz6udby@kafai-mbp>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: allow any port in bpf_bind helper
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05, Martin KaFai Lau wrote:
> On Tue, May 05, 2020 at 01:27:29PM -0700, Stanislav Fomichev wrote:
> > We want to have a tighter control on what ports we bind to in
> > the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> > connect() becomes slightly more expensive. The expensive part
> > comes from the fact that we now need to call inet_csk_get_port()
> > that verifies that the port is not used and allocates an entry
> > in the hash table for it.
> >
> > Since we can't rely on "snum || !bind_address_no_port" to prevent
> > us from calling POST_BIND hook anymore, let's add another bind flag
> > to indicate that the call site is BPF program.
> >
> > v2:
> > * Update documentation (Andrey Ignatov)
> > * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> >
> > Cc: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/net/inet_common.h                     |   2 +
> >  include/uapi/linux/bpf.h                      |   9 +-
> >  net/core/filter.c                             |  18 ++-
> >  net/ipv4/af_inet.c                            |  10 +-
> >  net/ipv6/af_inet6.c                           |  12 +-
> >  tools/include/uapi/linux/bpf.h                |   9 +-
> >  .../bpf/prog_tests/connect_force_port.c       | 104 ++++++++++++++++++
> >  .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
> >  .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
> >  9 files changed, 192 insertions(+), 28 deletions(-)
> >  create mode 100644  
> tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> >  create mode 100644  
> tools/testing/selftests/bpf/progs/connect_force_port4.c
> >  create mode 100644  
> tools/testing/selftests/bpf/progs/connect_force_port6.c
> >
> > diff --git a/include/net/inet_common.h b/include/net/inet_common.h
> > index c38f4f7d660a..cb2818862919 100644
> > --- a/include/net/inet_common.h
> > +++ b/include/net/inet_common.h
> > @@ -39,6 +39,8 @@ int inet_bind(struct socket *sock, struct sockaddr  
> *uaddr, int addr_len);
> >  #define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
> >  /* Grab and release socket lock. */
> >  #define BIND_WITH_LOCK			(1 << 1)
> > +/* Called from BPF program. */
> > +#define BIND_FROM_BPF			(1 << 2)
> >  int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >  		u32 flags);
> >  int inet_getname(struct socket *sock, struct sockaddr *uaddr,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b3643e27e264..14b5518a3d5b 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1994,10 +1994,11 @@ union bpf_attr {
> >   *
> >   * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
> >   * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
> > - * 		**AF_INET6**). Looking for a free port to bind to can be
> > - * 		expensive, therefore binding to port is not permitted by the
> > - * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
> > - * 		must be set to zero.
> > + * 		**AF_INET6**). It's advised to pass zero port (**sin_port**
> > + * 		or **sin6_port**) which triggers IP_BIND_ADDRESS_NO_PORT-like
> > + * 		behavior and lets the kernel reuse the same source port
> Reading "zero port" and "the same source port" together is confusing.
Ack, let me try rephrase it a bit to make it more clear.

> > + * 		as long as 4-tuple is unique. Passing non-zero port might
> > + * 		lead to degraded performance.
> Is the "degraded performance" also true for UDP?
I suppose everything that is "allocating" port at bind time can lead
to a faster port exhaustion, so UDP should be also affected.
Although, looking at udp_v4_get_port, it looks less involved than
its TCP counterpart.

> >   * 	Return
> >   * 		0 on success, or a negative error in case of failure.
> >   *

> [ ... ]

> > diff --git  
> a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c  
> b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> > new file mode 100644
> > index 000000000000..97104e6410b6
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> > @@ -0,0 +1,104 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <test_progs.h>
> > +#include "cgroup_helpers.h"
> > +#include "network_helpers.h"
> > +
> > +static int verify_port(int family, int fd, int expected)
> > +{
> > +	struct sockaddr_storage addr;
> > +	socklen_t len = sizeof(addr);
> > +	__u16 port;
> > +
> > +
> > +	if (getsockname(fd, (struct sockaddr *)&addr, &len)) {
> > +		log_err("Failed to get server addr");
> > +		return -1;
> > +	}
> > +
> > +	if (family == AF_INET)
> > +		port = ((struct sockaddr_in *)&addr)->sin_port;
> > +	else
> > +		port = ((struct sockaddr_in6 *)&addr)->sin6_port;
> > +
> > +	if (ntohs(port) != expected) {
> > +		log_err("Unexpected port %d, expected %d", ntohs(port),
> > +			expected);
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int run_test(int cgroup_fd, int server_fd, int family)
> > +{
> > +	struct bpf_prog_load_attr attr = {
> > +		.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> > +	};
> > +	struct bpf_object *obj;
> > +	int expected_port;
> > +	int prog_fd;
> > +	int err;
> > +	int fd;
> > +
> > +	if (family == AF_INET) {
> > +		attr.file = "./connect_force_port4.o";
> > +		attr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
> > +		expected_port = 22222;
> > +	} else {
> > +		attr.file = "./connect_force_port6.o";
> > +		attr.expected_attach_type = BPF_CGROUP_INET6_CONNECT;
> > +		expected_port = 22223;
> > +	}
> > +
> > +	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
> > +	if (err) {
> > +		log_err("Failed to load BPF object");
> > +		return -1;
> > +	}
> > +
> > +	err = bpf_prog_attach(prog_fd, cgroup_fd, attr.expected_attach_type,
> > +			      0);
> > +	if (err) {
> > +		log_err("Failed to attach BPF program");
> > +		goto close_bpf_object;
> > +	}
> > +
> > +	fd = connect_to_fd(family, server_fd);
> > +	if (fd < 0) {
> > +		err = -1;
> > +		goto close_bpf_object;
> > +	}
> > +
> > +	err = verify_port(family, fd, expected_port);
> > +
> > +	close(fd);
> > +
> > +close_bpf_object:
> > +	bpf_object__close(obj);
> > +	return err;
> > +}
> > +
> > +void test_connect_force_port(void)
> > +{
> > +	int server_fd, cgroup_fd;
> > +
> > +	cgroup_fd = test__join_cgroup("/connect_force_port");
> > +	if (CHECK_FAIL(cgroup_fd < 0))
> > +		return;
> > +
> > +	server_fd = start_server_thread(AF_INET);
> > +	if (CHECK_FAIL(server_fd < 0))
> > +		goto close_cgroup_fd;
> > +	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET));
> > +	stop_server_thread(server_fd);
> > +
> > +	server_fd = start_server_thread(AF_INET6);
> > +	if (CHECK_FAIL(server_fd < 0))
> > +		goto close_cgroup_fd;
> > +	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6));
> > +	stop_server_thread(server_fd);
> Thanks for testing both v6 and v4.

> The UDP path should be tested also.
Good point, will do!
