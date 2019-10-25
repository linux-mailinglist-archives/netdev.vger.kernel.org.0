Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B358E5718
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 01:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfJYXgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 19:36:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45783 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJYXf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 19:35:59 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so5747030qtj.12;
        Fri, 25 Oct 2019 16:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PT1uW+UPXH5s80fbV0M8d3CvpPtDOX8Pf7N8yZ1InKI=;
        b=UGYVkc4yBASg5zNpnV9mmTKmiT3jBlPxOee4Af0sZ+aJZ8Np9caCh+466aq0GpKi0D
         T2cFBu8K+fpY7lEy6OMXgnZ+iW2GxljedjumNZIeoUax9myj5gUlftXY+zNEE+E+0SiT
         99iwLVRZQkuZmuGM04ENbTB9dyo+jevdpFyUt9l/TvjgxxDSYune+CBoqGBMq11rLIUa
         RVPFkO9+N6yWhvurwuhtfIyn2kIH3e53miSU23sGN5fh2YH6drrPEJwHb2DFVvQiAEs0
         kss0Fsr7wAnEh692yMRiJtCI+O+hVVlBIDM5L4fdEs5yhoyhm8TQs+JwbOBuw78eVunM
         0dhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PT1uW+UPXH5s80fbV0M8d3CvpPtDOX8Pf7N8yZ1InKI=;
        b=XBig7kMntLlaHWkS8J7hennTA2KO8D+6xBBXUPbOn/m+Wubnbd90x0ZDNzKSzdTY2a
         1xlyMT2wFmekA8g/BKHFvX2fLOyFFwBwRkuFMVFbP82163/dk3ZJH/VJDlu3+Z6jeXBj
         OOZFAvLnKWsdENElclhcbL1kYk7pw+WWtTARde3pLjtwJlfcb9XsaqiZu/IPTTTLkB27
         MIHLruO8Q8xQRYNXRqi/NZpuK9He1hT5PL/aSgvUZhSv73pFjgURFOia+JfJZxPJHXeZ
         mfjU0N9nnZtL+tt7t2IYe7tGG/JZ+i1lhXX5Drb1Wx7eMT1bNLSRVuJh4VifPvIwmVQ2
         8XHQ==
X-Gm-Message-State: APjAAAX7WKemNv7E/OSMomxQy5HrgoSincJf35Z/niBOXP4MmgTAwlYG
        rxcr+lW3dVMw6ylzFZOnhh1edOrMpe4RWG05HQJn97KL
X-Google-Smtp-Source: APXvYqz6K2XaKwFe3rB5/sy7QMkyJGuKnRcoYYF6URH97kBNjStsC/5g0VxJa6LGPLnyWz4b66zookSeJBCIe/6HYoQ=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr5889241qte.59.1572046558091;
 Fri, 25 Oct 2019 16:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
 <CAEf4BzajMmYLe8tY9NGV-34iYUFC_FrBp00a1uSgN-oW_F=+eg@mail.gmail.com> <20191025223835.GF14547@pc-63.home>
In-Reply-To: <20191025223835.GF14547@pc-63.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 16:35:47 -0700
Message-ID: <CAEf4BzaCnUSdXzs=ey7CRF8O3rEuZfOTsXH9bMPa7eFLFW9gdw@mail.gmail.com>
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

On Fri, Oct 25, 2019 at 4:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Fri, Oct 25, 2019 at 03:14:49PM -0700, Andrii Nakryiko wrote:
> > On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > Tested on x86-64 and Ilya was also kind enough to give it a spin on
> > > s390x, both passing with probe_user:OK there. The test is using the
> > > newly added bpf_probe_read_user() to dump sockaddr from connect call
> > > into BPF map and overrides the user buffer via bpf_probe_write_user():
> > >
> > >   # ./test_progs
> > >   [...]
> > >   #17 pkt_md_access:OK
> > >   #18 probe_user:OK
> > >   #19 prog_run_xattr:OK
> > >   [...]
> > >
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/probe_user.c     | 80 +++++++++++++++++++
> > >  .../selftests/bpf/progs/test_probe_user.c     | 33 ++++++++
> > >  2 files changed, 113 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> > > new file mode 100644
> > > index 000000000000..e37761bda8a4
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> > > @@ -0,0 +1,80 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <test_progs.h>
> > > +
> > > +void test_probe_user(void)
> > > +{
> > > +#define kprobe_name "__sys_connect"
> > > +       const char *prog_name = "kprobe/" kprobe_name;
> > > +       const char *obj_file = "./test_probe_user.o";
> > > +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> > > +               .relaxed_maps = true,
> >
> > do we need relaxed_maps in this case?
>
> Ah yeap, I'll remove. Test runs fine w/o it. Any particular reason you added it back in
> 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")?

Hmm, I'm not sure about those tests... probably just copy/pasted
something mechanically. We need .relaxed_maps for tests that add numa
fields, otherwise libbpf will reject them. I shouldn't have added
them.

>
> > > +       );
> > > +       int err, results_map_fd, sock_fd, duration;
> > > +       struct sockaddr curr, orig, tmp;
> > > +       struct sockaddr_in *in = (struct sockaddr_in *)&curr;
> > > +       struct bpf_link *kprobe_link = NULL;
> > > +       struct bpf_program *kprobe_prog;
> > > +       struct bpf_object *obj;
> > > +       static const int zero = 0;
> > > +
> >
> > [...]
> >
> > > +
> > > +struct {
> > > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > > +       __uint(max_entries, 1);
> > > +       __type(key, int);
> > > +       __type(value, struct sockaddr_in);
> > > +} results_map SEC(".maps");
> > > +
> > > +SEC("kprobe/__sys_connect")
> > > +int handle_sys_connect(struct pt_regs *ctx)
> > > +{
> > > +       void *ptr = (void *)PT_REGS_PARM2(ctx);
> > > +       struct sockaddr_in old, new;
> > > +       const int zero = 0;
> > > +
> > > +       bpf_probe_read_user(&old, sizeof(old), ptr);
> > > +       bpf_map_update_elem(&results_map, &zero, &old, 0);
> >
> > could have used global data and read directly into it :)
>
> Hehe, yeah sure, though that we have covered separately. :-) Wasn't planning to
> bug Ilya once again to recompile everything on his s390x box.

Oh, it's not to test global data, it's because global data make BPF
side of tests much cleaner. But it's minor, feel free to ignore. Once
we have a good interface to global data from user-space, though, there
will be a bigger motivation to switch them to global data, because
both BPF and user side will be much more succinct.

>
> > > +       __builtin_memset(&new, 0xab, sizeof(new));
> > > +       bpf_probe_write_user(ptr, &new, sizeof(new));
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > --
> > > 2.21.0
> > >
