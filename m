Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF80513D247
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 03:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgAPCmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 21:42:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41487 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgAPCmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 21:42:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so14317337lfp.8;
        Wed, 15 Jan 2020 18:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HI+xV3bsEIgulj7uKMX2W6C7zKygWyvz6NNY/styFTY=;
        b=BKdjjZNMr7gUJbajEu6uDlpuDWmV+FZ9mX4RTHaaayZxgfW+bvItK+gh4cg6+fKj3J
         mEe+EsEK8BNBi9iEBBGTqedI2dOtYXcvF4WBbL0eJmN8vFh/LFfeRLz+JzmzkU7fiutt
         ulUR7gsVyO/fnDA1NuXhsoFz9e7ZDuLkhvsNtOucvc2Wv3t6h8NDweHoiFX1x/kKXRXB
         ZaOvvA92FuY57ygzSExQXyE870M6VApZlDU7zcg5SSESkdXOaXx3wUXKTB6XoxwP3LTS
         vFPxqcMFg8wkUqPahqpKF4EZ2XGVM7oQStLRVyazZYEO5SjNfisxkO1kPy0oQ6YR0RMP
         JK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HI+xV3bsEIgulj7uKMX2W6C7zKygWyvz6NNY/styFTY=;
        b=qF3eQ7CYZ7p4L2rvdui9CB8w4bwAClWqJy2YsKsdvwNe3dHsEEeIkRHvZK1wlJ/yzD
         Ry/DbBum/+xw+J7tuOteOnkiGYIOpAT7F+o8+zHNObZaK4tj2neJjhXEY1amci/6Vc86
         8ZQYKqiFIVYB9sIDIOQWpPjQFFyunKIOEysuut6ZOmRc3qzn2BH6Zo1dkAoQPdUpu1fK
         iYC5CJxS+wXNgbK3NY1ciwZDWH2vdDrbh2//2SWTwOYZ3qy4KTmLLXGcdDB2KP2L2zub
         qBnMbugRwJx234fZUwxgs2uAhNzN4v6w6wN/SE/gmZuBOd/tjOHYdz5+etohSOZJ6/3S
         p9tw==
X-Gm-Message-State: APjAAAXY26B8ariyM2skQRLAjw6AZgcmjD4S6avtxF+tCkaiTWxImQYI
        dsiUfiQv1AHlJa6SGiZED+bG0+P3xJ8d7+Rttt0=
X-Google-Smtp-Source: APXvYqzcYQG7zGfFpsRr10PuOrm81bu/T9LhblAmPepC32I/97Mxn4kcpZ5yQ0UVii6Vl/pkhkE007k5xX7O8JNe4AY=
X-Received: by 2002:a19:c80a:: with SMTP id y10mr1027154lff.177.1579142553893;
 Wed, 15 Jan 2020 18:42:33 -0800 (PST)
MIME-Version: 1.0
References: <20200116005549.3644118-1-andriin@fb.com>
In-Reply-To: <20200116005549.3644118-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jan 2020 18:42:22 -0800
Message-ID: <CAADnVQ++qp83cW_1M4WyD8qiGzyPBDC5a-DJLLwgU97rh_EvSg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: add whitelist/blacklist of
 test names to test_progs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Julia Kartseva <hex@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 6:16 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add ability to specify a list of test name substrings for selecting which
> tests to run. So now -t is accepting a comma-separated list of strings,
> similarly to how -n accepts a comma-separated list of test numbers.
>
> Additionally, add ability to blacklist tests by name. Blacklist takes
> precedence over whitelist. Blacklisting is important for cases where it's
> known that some tests can't pass (e.g., due to perf hardware events that are
> not available within VM). This is going to be used for libbpf testing in
> Travis CI in its Github repo.
>
> Example runs with just whitelist and whitelist + blacklist:
>
>   $ sudo ./test_progs -tattach,core/existence
>   #1 attach_probe:OK
>   #6 cgroup_attach_autodetach:OK
>   #7 cgroup_attach_multi:OK
>   #8 cgroup_attach_override:OK
>   #9 core_extern:OK
>   #10/44 existence:OK
>   #10/45 existence___minimal:OK
>   #10/46 existence__err_int_sz:OK
>   #10/47 existence__err_int_type:OK
>   #10/48 existence__err_int_kind:OK
>   #10/49 existence__err_arr_kind:OK
>   #10/50 existence__err_arr_value_type:OK
>   #10/51 existence__err_struct_type:OK
>   #10 core_reloc:OK
>   #19 flow_dissector_reattach:OK
>   #60 tp_attach_query:OK
>   Summary: 8/8 PASSED, 0 SKIPPED, 0 FAILED
>
>   $ sudo ./test_progs -tattach,core/existence -bcgroup,flow/arr
>   #1 attach_probe:OK
>   #9 core_extern:OK
>   #10/44 existence:OK
>   #10/45 existence___minimal:OK
>   #10/46 existence__err_int_sz:OK
>   #10/47 existence__err_int_type:OK
>   #10/48 existence__err_int_kind:OK
>   #10/51 existence__err_struct_type:OK
>   #10 core_reloc:OK
>   #60 tp_attach_query:OK
>   Summary: 4/6 PASSED, 0 SKIPPED, 0 FAILED
>
> Cc: Julia Kartseva <hex@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Nice. Even things like "test_progs -n 11-16 -b exit" work as expected.
Applied. Thanks!
