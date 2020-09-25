Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9E1277D54
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgIYBBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 21:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgIYBBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 21:01:43 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC96C0613CE;
        Thu, 24 Sep 2020 18:01:42 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id v20so1077201oiv.3;
        Thu, 24 Sep 2020 18:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kt+hNZx047uYOhaOrG3/butqSHDLBY4uLauS11601jo=;
        b=TdMZi27zjVfwxlXt3+7GRcfeS3gMwTMHNl/UZbQqNnXF2pYgtXgx3qWzahOpqr5Syp
         sySuiW+09I9feFxg5Vbzk18qMPM3T3J7RZKHphGBESNvgctmljpN850EbhgVNCZBLy0z
         7eVT0A/FYDQAMHLECe3JeUGiAtMC57kE47dPV1Fg4S4Za2xX4n+8k89RZDsx6CGXqBpJ
         TNkg8EbP9Rx7xq/4i6oguXysbDhWaLj2xf2lkBT/GoD0CWCz6I7MmyoElmhQRfAfW/nA
         hIgHctpuSQ7qjB+BAS6CJGiheqVaGmOt6HbVcfPaay+VEMpbiNOBAf3D3seoX1MSw3XQ
         7RRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kt+hNZx047uYOhaOrG3/butqSHDLBY4uLauS11601jo=;
        b=hg2cebw5CnkVNrXDITyoX42TzV/D82rnxrEorCWRngBFGr3rf9sM8eVlTvGXn4b5bI
         8u/BdLBl2MniJOfvtGkl8MEKh6NFbQHP31gUVTG94QVhXkvYjEppYSUYPGucx2/+xOze
         QQu64qTFL0bsk6VQtsVtXi6HxKgJTasJAWoEW5oSof841peDmy2/+RwZZUXI04uobvvp
         9pKNUXKmd9hkJy5nUjjb9+msAvbqqgxYP0BHZD0kGiKyxaW1jW8HeNxIoI7D8aHhONSp
         akAt8vt7HBIN9WS7wm4KJ61OFD5fBV+6P2BGyOyr5Ib6OmgMbVQ511vSUMg01sy4kCsV
         +aVQ==
X-Gm-Message-State: AOAM531Ro06F1qMVVUtu+IoAHLvZfsOPP6EPTXR235PRZGGy099e2yIg
        QBHiOcDR1nVVOXv+SG8jTyk=
X-Google-Smtp-Source: ABdhPJwgGTgP2QVbIjSx5JlKVlcnedXXMWkjYgEmhRLokgkmUTtKU0bm/0BBtPxgBSZaXql+gb/3Gw==
X-Received: by 2002:aca:388:: with SMTP id 130mr170958oid.145.1600995702176;
        Thu, 24 Sep 2020 18:01:42 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t84sm254087oif.32.2020.09.24.18.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 18:01:41 -0700 (PDT)
Date:   Thu, 24 Sep 2020 18:01:33 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f6d416d1b396_634ab20836@john-XPS-13-9370.notmuch>
In-Reply-To: <20200924230209.2561658-4-songliubraving@fb.com>
References: <20200924230209.2561658-1-songliubraving@fb.com>
 <20200924230209.2561658-4-songliubraving@fb.com>
Subject: RE: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> This test runs test_run for raw_tracepoint program. The test covers ctx
> input, retval output, and running on correct cpu.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

[...]

> +void test_raw_tp_test_run(void)
> +{
> +	struct bpf_prog_test_run_attr test_attr = {};
> +	int comm_fd = -1, err, nr_online, i, prog_fd;
> +	__u64 args[2] = {0x1234ULL, 0x5678ULL};
> +	int expected_retval = 0x1234 + 0x5678;
> +	struct test_raw_tp_test_run *skel;
> +	char buf[] = "new_name";
> +	bool *online = NULL;
> +
> +	err = parse_cpu_mask_file("/sys/devices/system/cpu/online", &online,
> +				  &nr_online);
> +	if (CHECK(err, "parse_cpu_mask_file", "err %d\n", err))
> +		return;
> +
> +	skel = test_raw_tp_test_run__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		goto cleanup;
> +
> +	err = test_raw_tp_test_run__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	comm_fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
> +	if (CHECK(comm_fd < 0, "open /proc/self/comm", "err %d\n", errno))
> +		goto cleanup;
> +
> +	err = write(comm_fd, buf, sizeof(buf));
> +	CHECK(err < 0, "task rename", "err %d", errno);
> +
> +	CHECK(skel->bss->count == 0, "check_count", "didn't increase\n");
> +	CHECK(skel->data->on_cpu != 0xffffffff, "check_on_cpu", "got wrong value\n");
> +
> +	prog_fd = bpf_program__fd(skel->progs.rename);
> +	test_attr.prog_fd = prog_fd;
> +	test_attr.ctx_in = args;
> +	test_attr.ctx_size_in = sizeof(__u64);
> +
> +	err = bpf_prog_test_run_xattr(&test_attr);
> +	CHECK(err == 0, "test_run", "should fail for too small ctx\n");
> +
> +	test_attr.ctx_size_in = sizeof(args);
> +	err = bpf_prog_test_run_xattr(&test_attr);
> +	CHECK(err < 0, "test_run", "err %d\n", errno);
> +	CHECK(test_attr.retval != expected_retval, "check_retval",
> +	      "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
> +
> +	for (i = 0; i < nr_online; i++) {
> +		if (online[i]) {
> +			DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> +				.ctx_in = args,
> +				.ctx_size_in = sizeof(args),
> +				.flags = BPF_F_TEST_RUN_ON_CPU,
> +				.retval = 0,
> +				.cpu = i,
> +			);
> +
> +			err = bpf_prog_test_run_opts(prog_fd, &opts);
> +			CHECK(err < 0, "test_run_opts", "err %d\n", errno);
> +			CHECK(skel->data->on_cpu != i, "check_on_cpu",
> +			      "expect %d got %d\n", i, skel->data->on_cpu);
> +			CHECK(opts.retval != expected_retval,
> +			      "check_retval", "expect 0x%x, got 0x%x\n",
> +			      expected_retval, opts.retval);
> +
> +			if (i == 0) {
> +				/* invalid cpu ID should fail with ENXIO */
> +				opts.cpu = 0xffffffff;
> +				err = bpf_prog_test_run_opts(prog_fd, &opts);
> +				CHECK(err != -1 || errno != ENXIO,
> +				      "test_run_opts_fail",
> +				      "should failed with ENXIO\n");
> +			} else {

One more request...

How about pull this if/else branch out of the for loop here? It feels a bit
clumsy as-is imo. Also is it worthwhile to bang on the else branch for evey
cpu I would think testing for any non-zero value should be sufficient.

> +				/* non-zero cpu w/o BPF_F_TEST_RUN_ON_CPU
> +				 * should fail with EINVAL
> +				 */
> +				opts.flags = 0;
> +				err = bpf_prog_test_run_opts(prog_fd, &opts);
> +				CHECK(err != -1 || errno != EINVAL,
> +				      "test_run_opts_fail",
> +				      "should failed with EINVAL\n");
> +			}
> +		}
> +	}
> +cleanup:
> +	close(comm_fd);
> +	test_raw_tp_test_run__destroy(skel);
> +	free(online);
> +}
