Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A351E83F2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE2Qp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:45:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgE2Qpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:45:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590770752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yE8l6C2K45Oxr0sOHCOBb823XM1ml++647bWXMKlUuM=;
        b=Nb3oPaptEXBw/PrPohP4yVI2JwaZRAeh/xoW0U5alpa4cuvOK/A1vzG82eOJNcRKc5CeNk
        TjEou2AlqOsi9ewL7krLWWvb0VZdgsvex6J+T9dSj9h467Gnyb1AsfWoQee3JVg0Fd4tLh
        S7yU6C+lEBdGJx9cbH14HgIIogCjSGQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-O9sDJgrBNZW_GmQMZGrR-Q-1; Fri, 29 May 2020 12:45:41 -0400
X-MC-Unique: O9sDJgrBNZW_GmQMZGrR-Q-1
Received: by mail-ed1-f69.google.com with SMTP id s14so1416479edr.7
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 09:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yE8l6C2K45Oxr0sOHCOBb823XM1ml++647bWXMKlUuM=;
        b=MlYeU23ia7iwUrgtjOzqUZvd77s7mMAbPKEJWwbp9NjtXoEgxKrpSYbmIqDfsR9VmQ
         T+MR2LOAXdDIhpdRga6INm3/qm4tJ5PkgdRXY42DTLx3Y+TEksWhO+CWR0V63t2qvCCu
         i9d/EFVVhplMupblGfsFKItg6PYO2LF0mpwjzHMncLpqVfAh2SiDMoXgJANLCZ4yaj2w
         n4mzOtL8VCFAJleadm1f+Dfpely9nQrPqOMZ7fQ0A9nWO4BmV9lGtDMs2a4EGFRk7o3b
         8ZFpNTlz8KMAnAzDWQCMptS6b47xMH1fVoopI5nzjvRi/QaInEXRAHHn4yYm4OzJDLU2
         sPrA==
X-Gm-Message-State: AOAM5300/pFMd/vTUOQpnIPdQ0PUaYLHGPv9TnGS/SlukBGsnZs1NQ8W
        ooxsqZbHohn/7HkigZxVsNmAh2At11bFQ2yu/dkaVAUx6f0S4FFcHEuRfZ+oaruQCvijb2oqlVa
        09IgdTTKkO7vOiAX0
X-Received: by 2002:a50:fe94:: with SMTP id d20mr8864795edt.254.1590770740086;
        Fri, 29 May 2020 09:45:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy29o1SyK1kQ/VtUputSZEkjA211i1wWO8oFhQyEzI436uRzWFnvZ9AcHjOFvCnS3VXYJFpwA==
X-Received: by 2002:a50:fe94:: with SMTP id d20mr8864766edt.254.1590770739873;
        Fri, 29 May 2020 09:45:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z10sm7019193ejb.9.2020.05.29.09.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:45:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 723AC182019; Fri, 29 May 2020 18:45:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, lorenzo@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 bpf-next 5/5] selftest: Add tests for XDP programs in devmap entries
In-Reply-To: <20200529052057.69378-6-dsahern@kernel.org>
References: <20200529052057.69378-1-dsahern@kernel.org> <20200529052057.69378-6-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 May 2020 18:45:37 +0200
Message-ID: <87r1v2zo3y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Add tests to verify ability to add an XDP program to a
> entry in a DEVMAP.
>
> Add negative tests to show DEVMAP programs can not be
> attached to devices as a normal XDP program, and accesses
> to egress_ifindex require BPF_XDP_DEVMAP attach type.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  .../bpf/prog_tests/xdp_devmap_attach.c        | 89 +++++++++++++++++++
>  .../bpf/progs/test_xdp_devmap_helpers.c       | 22 +++++
>  .../bpf/progs/test_xdp_with_devmap_helpers.c  | 43 +++++++++
>  3 files changed, 154 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> new file mode 100644
> index 000000000000..caeea19f2772
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <uapi/linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <test_progs.h>
> +
> +#include "test_xdp_devmap_helpers.skel.h"
> +#include "test_xdp_with_devmap_helpers.skel.h"
> +
> +#define IFINDEX_LO 1
> +
> +void test_xdp_with_devmap_helpers(void)
> +{
> +	struct test_xdp_with_devmap_helpers *skel;
> +	struct bpf_prog_info info = {};
> +	struct bpf_devmap_val val = {
> +		.ifindex = IFINDEX_LO,
> +	};
> +	__u32 id, len = sizeof(info);
> +	__u32 duration, idx = 0;
> +	int err, dm_fd, map_fd;
> +
> +
> +	skel = test_xdp_with_devmap_helpers__open_and_load();
> +	if (CHECK_FAIL(!skel)) {
> +		perror("test_xdp_with_devmap_helpers__open_and_load");
> +		return;
> +	}
> +
> +	/* can not attach program with DEVMAPs that allow programs
> +	 * as xdp generic
> +	 */
> +	dm_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
> +	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
> +	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
> +	      "should have failed\n");
> +
> +	dm_fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
> +	map_fd = bpf_map__fd(skel->maps.dm_ports);
> +	err = bpf_obj_get_info_by_fd(dm_fd, &info, &len);
> +	if (CHECK_FAIL(err))
> +		goto out_close;
> +
> +	val.bpf_prog_fd = dm_fd;
> +	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
> +	CHECK(err, "Add program to devmap entry",
> +	      "err %d errno %d\n", err, errno);
> +
> +	err = bpf_map_lookup_elem(map_fd, &id, &val);
> +	CHECK(err, "Read devmap entry", "err %d errno %d\n", err, errno);
> +	CHECK(info.id != val.bpf_prog_id, "Expected program id in devmap entry",
> +	      "expected %u read %u\n", info.id, val.bpf_prog_id);
> +
> +	/* can not attach BPF_XDP_DEVMAP program to a device */
> +	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
> +	CHECK(err == 0, "Attach of BPF_XDP_DEVMAP program",
> +	      "should have failed\n");
> +
> +	val.ifindex = 1;
> +	val.bpf_prog_fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
> +	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
> +	CHECK(err == 0, "Add non-BPF_XDP_DEVMAP program to devmap entry",
> +	      "should have failed\n");
> +
> +out_close:
> +	test_xdp_with_devmap_helpers__destroy(skel);
> +}
> +
> +void test_neg_xdp_devmap_helpers(void)
> +{
> +	struct test_xdp_devmap_helpers *skel;
> +	__u32 duration;
> +
> +	skel = test_xdp_devmap_helpers__open_and_load();
> +	if (CHECK(skel,
> +		  "Load of XDP program accessing egress ifindex without attach type",
> +		  "should have failed\n")) {
> +		test_xdp_devmap_helpers__destroy(skel);
> +	}
> +}
> +
> +
> +void test_xdp_devmap_attach(void)
> +{
> +	if (test__start_subtest("DEVMAP with programs in entries"))
> +		test_xdp_with_devmap_helpers();
> +
> +	if (test__start_subtest("Verifier check of DEVMAP programs"))
> +		test_neg_xdp_devmap_helpers();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
> new file mode 100644
> index 000000000000..b360ba2bd441
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* fails to load without expected_attach_type = BPF_XDP_DEVMAP
> + * because of access to egress_ifindex
> + */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +SEC("xdp_dm_log")

Guess this should be xdp_devmap_log now?

-Toke

