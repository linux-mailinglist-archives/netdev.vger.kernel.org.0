Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528F82FF850
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbhAUW7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbhAUW6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:58:49 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE9C061794
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:57:46 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id w5so2477559qts.9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=rEs8+RjNlPMDkUBf1H7i/FQ61Cs6J/f8dFWTg7YHb34=;
        b=N26WO7H/zjK7LmKo9gNIltRKUFFdv8GjmFcwDmtNIEB2bP4tqxfWEsaeb3BoldBcjM
         mAx8HX7rCovDL8HzBFMdxq6eKlBVej6EScBKxt19AK+PhRfq4k4d/vOfr5sVT67cRaJH
         AhTpwino5wTh5JTQ9LsVp05VqYC3CK6mzuWImx147MzjWtbBvCRiHXvr7PksfNt6qFB+
         +Xz6AnDEj3gTwF1ntiyiGKr3jjnMsJ0dikH+ufGo1jnTRpVej7b3tVd69VGM1mRAHiDO
         CL3ectFMGKwP9fpkE2FiBFOTX8DKJ6pkfd4qxLWS8ddmIEsVS2ZkceBajHFikgCTLiNQ
         lI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rEs8+RjNlPMDkUBf1H7i/FQ61Cs6J/f8dFWTg7YHb34=;
        b=R86aADAryaLwkVvPt772pc6EEVAGysIZ4OH++BwBIt0O+D1rE1tg6LJ25SuL5npO5L
         GxiW2nFll6rdx1kPLBvmaZstDGZG2ckUPxlc4+dXGrKxiVAXRlMfQhEA/ehnZRL5tZ2X
         xldgKzut0+jCFO0VHkUS1hFG/otYtFxutuMUc+MQGYJzAozZBnq0PGI+C6lZF7t+0kxw
         W4/L1c2JaSnfYWQSCx5889RRbCH7EQnIvucA/T8mNgK10rb0FZGGwVDiC92nuUPdKRq9
         oDbKuul1JHWMcmUOZYhhziyY5ZZmZrcysE4pf4h1/AW3nKfXgGSTXqt8dMUoxwngZCOt
         xKnA==
X-Gm-Message-State: AOAM533CN8iKFbnvMT6uUO3klUpzr9Ab60+MNJNhT1JDJgJWJ2IDJN/C
        mBh0Bsy1tV9iUkbp3RcW/gyvYaY=
X-Google-Smtp-Source: ABdhPJzIkOwKG42KcXxS834I4A3iJwjvPiTo9oGyr0xAgKozY4O/+6Ipn2VjvUyT3PtRxe5nKqjhrH8=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:57ab:: with SMTP id g11mr1917054qvx.38.1611269865897;
 Thu, 21 Jan 2021 14:57:45 -0800 (PST)
Date:   Thu, 21 Jan 2021 14:57:44 -0800
In-Reply-To: <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
Message-Id: <YAoG6K37QtRZGJGy@google.com>
Mime-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com> <20210121012241.2109147-2-sdf@google.com>
 <20210121223330.pyk4ljtjirm2zlay@kafai-mbp>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to port
 < 1024 from BPF works
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/21, Martin KaFai Lau wrote:
> On Wed, Jan 20, 2021 at 05:22:41PM -0800, Stanislav Fomichev wrote:
> > BPF rewrites from 111 to 111, but it still should mark the port as
> > "changed".
> > We also verify that if port isn't touched by BPF, it's still prohibited.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
> >  2 files changed, 124 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c  
> b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > new file mode 100644
> > index 000000000000..840a04ac9042
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
> > @@ -0,0 +1,88 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "bind_perm.skel.h"
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <sys/capability.h>
> > +
> > +static int duration;
> > +
> > +void try_bind(int port, int expected_errno)
> > +{
> > +	struct sockaddr_in sin = {};
> > +	int fd = -1;
> > +
> > +	fd = socket(AF_INET, SOCK_STREAM, 0);
> > +	if (CHECK(fd < 0, "fd", "errno %d", errno))
> > +		goto close_socket;
> > +
> > +	sin.sin_family = AF_INET;
> > +	sin.sin_port = htons(port);
> > +
> > +	errno = 0;
> > +	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
> > +	CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
> > +	      errno, expected_errno);
> > +
> > +close_socket:
> > +	if (fd >= 0)
> > +		close(fd);
> > +}
> > +
> > +void cap_net_bind_service(cap_flag_value_t flag)
> > +{
> > +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> > +	cap_t caps;
> > +
> > +	caps = cap_get_proc();
> > +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> > +		goto free_caps;
> > +
> > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > +			       CAP_CLEAR),
> > +		  "cap_set_flag", "errno %d", errno))
> > +		goto free_caps;
> > +
> > +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> > +			       CAP_CLEAR),
> > +		  "cap_set_flag", "errno %d", errno))
> > +		goto free_caps;
> > +
> > +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> > +		goto free_caps;
> > +
> > +free_caps:
> > +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> > +		goto free_caps;
> > +}
> > +
> > +void test_bind_perm(void)
> > +{
> > +	struct bind_perm *skel;
> > +	int cgroup_fd;
> > +
> > +	cgroup_fd = test__join_cgroup("/bind_perm");
> > +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> > +		return;
> > +
> > +	skel = bind_perm__open_and_load();
> > +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> > +		goto close_cgroup_fd;
> > +
> > +	skel->links.bind_v4_prog =  
> bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> > +	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
> > +		  "cg-attach", "bind4 %ld",
> > +		  PTR_ERR(skel->links.bind_v4_prog)))
> > +		goto close_skeleton;
> > +
> > +	cap_net_bind_service(CAP_CLEAR);
> > +	try_bind(110, EACCES);
> > +	try_bind(111, 0);
> > +	cap_net_bind_service(CAP_SET);
> > +
> > +close_skeleton:
> > +	bind_perm__destroy(skel);
> > +close_cgroup_fd:
> > +	close(cgroup_fd);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c  
> b/tools/testing/selftests/bpf/progs/bind_perm.c
> > new file mode 100644
> > index 000000000000..2194587ec806
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/bind_perm.c
> > @@ -0,0 +1,36 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/stddef.h>
> > +#include <linux/bpf.h>
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +
> > +SEC("cgroup/bind4")
> > +int bind_v4_prog(struct bpf_sock_addr *ctx)
> > +{
> > +	struct bpf_sock *sk;
> > +	__u32 user_ip4;
> > +	__u16 user_port;
> > +
> > +	sk = ctx->sk;
> > +	if (!sk)
> > +		return 0;
> > +
> > +	if (sk->family != AF_INET)
> > +		return 0;
> > +
> > +	if (ctx->type != SOCK_STREAM)
> > +		return 0;
> > +
> > +	/* Rewriting to the same value should still cause
> > +	 * permission check to be bypassed.
> > +	 */
> > +	if (ctx->user_port == bpf_htons(111))
> > +		ctx->user_port = bpf_htons(111);
> iiuc, this overwrite is essentially the way to ensure the bind
> will succeed (override CAP_NET_BIND_SERVICE in this particular case?).
Correct. The alternative might be to export ignore_perm_check
via bpf_sock_addr and make it explicit.

> It seems to be okay if we consider most of the use cases is rewriting
> to a different port.

> However, it is quite un-intuitive to the bpf prog to overwrite with
> the same user_port just to ensure this port can be binded successfully
> later.
I'm testing a corner case here when the address is rewritten to the same
value, but the intention is to rewrite X to Y < 1024.

> Is user_port the only case? How about other fields in bpf_sock_addr?
Good question. For our use case only the port matters because
we rewrite both port and address (and never only address).

It does feel like it should also work when BPF rewrites address only
(and port happens to be in the privileged range). I guess I can
apply the same logic to the user_ip4 and user_ip6?
