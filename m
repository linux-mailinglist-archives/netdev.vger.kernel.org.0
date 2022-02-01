Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC294A53A8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiBAACN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiBAACN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:02:13 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D624FC061714;
        Mon, 31 Jan 2022 16:02:12 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q204so19105978iod.8;
        Mon, 31 Jan 2022 16:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QyO86vvXrvsnYbM9ePprWtNUgK1VSac7vXnAuMxRjnM=;
        b=Nk/quBFO1BELsTpfs58wjw7GKNvRtuEERY8EEMkyufCHwI2PCskskqPpAm1e7YY2LA
         Ju9nKgNhP2TdLdrj98SoMcGxSu4esv/MKDYp5j79Q7y8oj7XmADeUwMfuvnmkzfJcY6v
         L1WQ5Jbd71ANVfnFu4VlJc0SyxOEjJZHE2eGAD/gVlSTROS89xJs/xQvmX+l4f2AeHth
         SW0HWKrC/rlTDn5YARGwXsrFH9ImkxNknd+MxzNH6oLG892ssGiUUgYdbTUKAkg1SP0e
         IFoMvb1nS7EvxoOYYySbxZ5vc3GqeQ619PlmqgiOw5+gHORZGZwvAv/8LWQ2UT+5hlt3
         7c8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QyO86vvXrvsnYbM9ePprWtNUgK1VSac7vXnAuMxRjnM=;
        b=yfJ8tob5briuBES+oi0c92zgLC5ApsyuyITnvTRGuE3dfoMmjRQz0GMChmTM0Fb2U0
         HJDGfQ6kjCBpzUSLJmfaXex2tfpLkxYmdJSlEyBFkR/t56yw9Sd9HKwiNivjg3m7+l2a
         Wg9sWOI4LPyrXi64N7iXcfFSfBBDEopxQkea5n9lKuPzWjE4vsagYyWVtPo4gKtfVCNj
         aaKIaZd35cBAK+vYhQJkcUEEoVLuoBOzDtqW5Bybzfka3R1euVr7LmGqu3jwdEu/bE1D
         fDUDq22U5GQNM6oXWaKjgmIgmeyknTenWP1KJGKHuVtVs/fEodJnFCgxeweXoIxKKroL
         BwJg==
X-Gm-Message-State: AOAM531xF6urFBYGHjz0IKZ4YXXOckqdzYm33JMHWqy+xB3O/ag5Vy74
        1fpTTtzQTv4aeJUEs6WPjsM9CFJ79MskLt69wcw=
X-Google-Smtp-Source: ABdhPJynksQgC7hnEFS7wyoTCvzTvG+zpxsgeWJTLDNUTwXwHDGfkGrUcngSUD+tLEGMr2L0wm31ZD9wy7WzgIMRFbw=
X-Received: by 2002:a05:6638:d88:: with SMTP id l8mr5018495jaj.234.1643673732190;
 Mon, 31 Jan 2022 16:02:12 -0800 (PST)
MIME-Version: 1.0
References: <20220127024939.364016-1-houtao1@huawei.com>
In-Reply-To: <20220127024939.364016-1-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 31 Jan 2022 16:02:00 -0800
Message-ID: <CAEf4BzYHggCfbSGb8autEDcHhZXabK-n36rggyjJeL0uLEr+DQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize
 ring buffer size
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 6:34 PM Hou Tao <houtao1@huawei.com> wrote:
>
> 4096 is OK for x86-64, but for other archs with greater than 4KB
> page size (e.g. 64KB under arm64), test_verifier for test case
> "check valid spill/fill, ptr to mem" will fail, so just use
> getpagesize() to initialize the ring buffer size. Do this for
> test_progs as well.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/d_path.c | 14 ++++++++++++--
>  .../testing/selftests/bpf/prog_tests/test_ima.c | 17 +++++++++++++----
>  tools/testing/selftests/bpf/progs/ima.c         |  1 -
>  .../bpf/progs/test_d_path_check_types.c         |  1 -
>  tools/testing/selftests/bpf/test_verifier.c     |  2 +-
>  5 files changed, 26 insertions(+), 9 deletions(-)
>

[...]

> @@ -86,5 +94,6 @@ void test_test_ima(void)
>         CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
>  close_prog:
>         ring_buffer__free(ringbuf);
> +destroy_skel:
>         ima__destroy(skel);
>  }
> diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> index 96060ff4ffc6..e192a9f16aea 100644
> --- a/tools/testing/selftests/bpf/progs/ima.c
> +++ b/tools/testing/selftests/bpf/progs/ima.c
> @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
>
>  struct {
>         __uint(type, BPF_MAP_TYPE_RINGBUF);
> -       __uint(max_entries, 1 << 12);

Should we just bump it to 64/128/256KB instead? It's quite annoying to
do a split open and then load just due to this...

I'm also wondering if we should either teach kernel to round up to
closes power-of-2 of page_size internally, or teach libbpf to do this
for RINGBUF maps. Thoughts?


>  } ringbuf SEC(".maps");
>
>  char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
> index 7e02b7361307..1b68d4a65abb 100644
> --- a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
> +++ b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
> @@ -8,7 +8,6 @@ extern const int bpf_prog_active __ksym;
>
>  struct {
>         __uint(type, BPF_MAP_TYPE_RINGBUF);
> -       __uint(max_entries, 1 << 12);
>  } ringbuf SEC(".maps");
>
>  SEC("fentry/security_inode_getattr")
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 29bbaa58233c..6acb5e747715 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -931,7 +931,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>         }
>         if (*fixup_map_ringbuf) {
>                 map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
> -                                          0, 4096);
> +                                          0, getpagesize());
>                 do {
>                         prog[*fixup_map_ringbuf].imm = map_fds[20];
>                         fixup_map_ringbuf++;
> --
> 2.29.2
>
