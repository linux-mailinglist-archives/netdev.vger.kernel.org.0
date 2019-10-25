Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF938E5667
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJYWPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:15:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45529 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:15:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so5520525qtj.12;
        Fri, 25 Oct 2019 15:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=joesBbaqP51C8NuUO1Ag0t+fXGW/HMlG5uWQ822XdcA=;
        b=P7A8ArOrLb5onKzZ8I4cqrqA+MQr/67I3KS9AAeQRYtaSVng5qIju54AZlcQ/MP13u
         Tbjzx7wpsaWSSuY3l/vqdvWPJOYlqs3u1dIUo23ChsMxu5yn2fSRG000yidPkZOU1oIg
         1vpRBLJTYOeROU3BCA52nlr4dxVIo6a+fAlaj88fsy42C11r0TyWlmjm/Z9hAmXh7kbO
         c2AnZd8547OMYzydTXkaffKICSjlm5wjL6KTuZslEuSINuZjsa34XyN3LWrh7o+engd4
         OjrGPk6PDwq1ibtLJpYp0iA9Qm7JlPZiVbgmwVlrM9Enj1Ol541oTKjTRqRI+Mz44uv2
         jI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=joesBbaqP51C8NuUO1Ag0t+fXGW/HMlG5uWQ822XdcA=;
        b=Qch+K4k6zqjQH1O6q2DqpYb/DIIgsv+mDgPTYMLmECqx0ZHpiSXFYoES+f+MG7PnBt
         VT5uTZyUUIQx6gjJ05Vt5mD7EgVgqOr2MLlnnfAec9oj9TE2gVCsvgb55hDs8Ezg6GdT
         avAoVNPFqG+xfDKraqY9q+U39a8XMn37Cl4Nl5ezeQ+ky6qM9RHjglhNk/lsdziYPyEb
         0cMd1w/6W1zQvWGPk+0yjq5DPVBihJoNy3W7Iw1iHq1ksIBFLjyux9dNxiB5iM4318yH
         +IchBCz7stckMgf7MGJar16hzr+v3UtesvPdQcRpQ8S2QnA/2XQZZbhygZmPehq8K1OS
         4Qtw==
X-Gm-Message-State: APjAAAUYC0nGQqQB/HsscFsBy0G9E6ECR1wjXZksNfqSGF15omdH0vpt
        PTrCr79rMbBilVMvgpzYVSJeyA6sn7YyNe/LpTU=
X-Google-Smtp-Source: APXvYqyaM0oiIlLNtWFHa9UrP2ARXy7n4U0ropvVo2HyiQKUL+849q0FYhWEhFL02wuDH5nqf5GzYYeVG7gyoupD8vQ=
X-Received: by 2002:ac8:66d9:: with SMTP id m25mr5550377qtp.117.1572041700502;
 Fri, 25 Oct 2019 15:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 15:14:49 -0700
Message-ID: <CAEf4BzajMmYLe8tY9NGV-34iYUFC_FrBp00a1uSgN-oW_F=+eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] bpf, testing: Add selftest to read/write
 sockaddr from user space
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Tested on x86-64 and Ilya was also kind enough to give it a spin on
> s390x, both passing with probe_user:OK there. The test is using the
> newly added bpf_probe_read_user() to dump sockaddr from connect call
> into BPF map and overrides the user buffer via bpf_probe_write_user():
>
>   # ./test_progs
>   [...]
>   #17 pkt_md_access:OK
>   #18 probe_user:OK
>   #19 prog_run_xattr:OK
>   [...]
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  .../selftests/bpf/prog_tests/probe_user.c     | 80 +++++++++++++++++++
>  .../selftests/bpf/progs/test_probe_user.c     | 33 ++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> new file mode 100644
> index 000000000000..e37761bda8a4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +void test_probe_user(void)
> +{
> +#define kprobe_name "__sys_connect"
> +       const char *prog_name = "kprobe/" kprobe_name;
> +       const char *obj_file = "./test_probe_user.o";
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +               .relaxed_maps = true,

do we need relaxed_maps in this case?

> +       );
> +       int err, results_map_fd, sock_fd, duration;
> +       struct sockaddr curr, orig, tmp;
> +       struct sockaddr_in *in = (struct sockaddr_in *)&curr;
> +       struct bpf_link *kprobe_link = NULL;
> +       struct bpf_program *kprobe_prog;
> +       struct bpf_object *obj;
> +       static const int zero = 0;
> +

[...]

> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, int);
> +       __type(value, struct sockaddr_in);
> +} results_map SEC(".maps");
> +
> +SEC("kprobe/__sys_connect")
> +int handle_sys_connect(struct pt_regs *ctx)
> +{
> +       void *ptr = (void *)PT_REGS_PARM2(ctx);
> +       struct sockaddr_in old, new;
> +       const int zero = 0;
> +
> +       bpf_probe_read_user(&old, sizeof(old), ptr);
> +       bpf_map_update_elem(&results_map, &zero, &old, 0);

could have used global data and read directly into it :)

> +       __builtin_memset(&new, 0xab, sizeof(new));
> +       bpf_probe_write_user(ptr, &new, sizeof(new));
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.21.0
>
