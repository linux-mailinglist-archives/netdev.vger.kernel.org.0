Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEF20FB7C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390695AbgF3SNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390691AbgF3SNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:13:54 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90518C061755;
        Tue, 30 Jun 2020 11:13:53 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r22so19502985qke.13;
        Tue, 30 Jun 2020 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ruj5LJP+8IGIFFHV5ah4S49XphCE1TPAnDbJPClbIM=;
        b=bulh0z8Qu6d1UqBMpc+1Au9lawh36ibbtlgkwsG8AweH8rDcloznXNBLyFJIlfPe8P
         8yqelKrC+eFysHcE29Qa6WtCxYBttV3JuCcP4FqsIdFiM7x2RT/pIibe8tGOffF1gSv1
         c0tvJEPX815zXKHdE0cTAQNq1QFYOmeN0XF2ed53fAHwyn5hN2nPTlFsNIM8cieWznnV
         kgPmbt2aGVCPp4AtLNuYqkcRObTjVBt+znCdIhw7KpVIy6Vq7sQc/vIqSOkhRq0TgmLu
         4Mgaa1DblzpSq53k2yL2Wa/HYvKir6++WwYUrpfJV0GEO0nifBZOWLOUCx3bask2Ojra
         gHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ruj5LJP+8IGIFFHV5ah4S49XphCE1TPAnDbJPClbIM=;
        b=pkYqUXJQTGHy4lSqWrSC04na2wltERXzsB8x+xawBdGq8vKiv1IqACVtx//C4Ekvbs
         IZYt/OkBgjhWuE0BdXJmKvjs6jxj2X46CpOXEC82cYS2U2I47n50tPGK0z+MKJzQbhof
         ZJMPNvE5SQktL0PHhIhTfqqHAjSTqlvf/nreUaugJl4b6HCPu1Lw2Lod/BHQhyqaPQXM
         zmemlRKkM2TkaAWejBpeJBWTOKTRD/qyZ6x+ZcZKeFwhhG78nePGcv6ZtKzjJOzIiFYw
         3n9jsXEK/mrYFHHFCsJAngAEB2Vq/AKprD+zrOUd7Rtvzp8LCX8er/z+QrqYNe1tMxB7
         V3Ww==
X-Gm-Message-State: AOAM531rwzkCOd0lWq4V5oigT1eygTp2XW1hkTGtj5q/cb7rEqUfxaaV
        fwwJp+ScO3rNyBdkujmVZWX4bFYfU+cvaQ639XA=
X-Google-Smtp-Source: ABdhPJwKiLoIbF+kkm2QhOtixcHOc/4baMzwd7o7F8K5+eTFp0HolZ7NvClttHmYeWd2k4fGbSs0qC9M0+D72byME/0=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr22038043qkn.36.1593540832584;
 Tue, 30 Jun 2020 11:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-15-jolsa@kernel.org>
 <CAEf4BzZXE7-SmSbG6=T=oLObBTBUhx9yC9SJbSj3tDJLpy93AQ@mail.gmail.com> <20200630142727.GC3071036@krava>
In-Reply-To: <20200630142727.GC3071036@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 11:13:41 -0700
Message-ID: <CAEf4BzaxZ83CVvqp-UNnFAW13Bu=thepw+sA7bB_u03iBkLSrw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 14/14] selftests/bpf: Add test for resolve_btfids
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jun 29, 2020 at 06:43:51PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding test to resolve_btfids tool, that:
> > >   - creates binary with BTF IDs list and set
> > >   - process the binary with resolve_btfids tool
> > >   - verifies that correct BTF ID values are in place
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  20 +-
> > >  .../selftests/bpf/test_resolve_btfids.c       | 201 ++++++++++++++++++
> > >  2 files changed, 220 insertions(+), 1 deletion(-)
> > >  create mode 100644 tools/testing/selftests/bpf/test_resolve_btfids.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 22aaec74ea0a..547322a5feff 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -37,7 +37,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> > >         test_cgroup_storage \
> > >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> > >         test_progs-no_alu32 \
> > > -       test_current_pid_tgid_new_ns
> > > +       test_current_pid_tgid_new_ns \
> > > +       test_resolve_btfids
> > >
> > >  # Also test bpf-gcc, if present
> > >  ifneq ($(BPF_GCC),)
> > > @@ -427,6 +428,23 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
> > >         $(call msg,BINARY,,$@)
> > >         $(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> > >
> > > +# test_resolve_btfids
> > > +#
> >
> > useless comment, please drop
>
> ok
>
> >
> > > +$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ) FORCE
> > > +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids \
> > > +                   OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
> >
> > Why do you need FORCE here? To force building this tool every single
> > time, even if nothing changed? See what we did for bpftool rebuilds.
>
> no, the build framework will recognize if the rebuild is needed,
> and trigger it..  but it needs to be invoked, hence the FORCE

And that's exactly what we tried to avoid with bpftool, to not invoke
sub-make (for good or bad reasons, not sure, and don't remember
anymore). In this case, it seems especially easy to ensure that
relevant resolve_btfids source code changes are captured properly, so
I'd probably just keep everything consistent and not use FORCE.


>
> > It's not perfect, but works fine in practice.
>
> we don't need to put the sources as dependency in here,
> as you do for bpftool, the build system will take care
> of that
>
> >
> > > +
> > > +$(OUTPUT)/test_resolve_btfids.o: test_resolve_btfids.c
> > > +       $(call msg,CC,,$@)
> > > +       $(CC) $(CFLAGS) -I$(TOOLSINCDIR) -D"BUILD_STR(s)=#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))" -c -o $@ $<
> > > +
> > > +.PHONY: FORCE
> > > +
> > > +$(OUTPUT)/test_resolve_btfids: $(OUTPUT)/test_resolve_btfids.o $(SCRATCH_DIR)/resolve_btfids
> > > +       $(call msg,BINARY,,$@)
> > > +       $(CC) -o $@ $< $(BPFOBJ) -lelf -lz && \
> > > +       $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) $@
> > > +
> >
> > Wouldn't it be better to make this just one of the tests of test_progs
> > and let resolve_btfids process test_progs completely? That should
> > still work, plus statically resolved BTF IDs against kernel would be
> > available for other tests immediately. And you will have all the
> > infrastructure of test_progs available. And this will be tested very
> > regularly. Win-win-win-win?
>
> ok, sounds good ;-)
>
> >
> > >  EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)                     \
> > >         prog_tests/tests.h map_tests/tests.h verifier/tests.h           \
> > >         feature                                                         \
> > > diff --git a/tools/testing/selftests/bpf/test_resolve_btfids.c b/tools/testing/selftests/bpf/test_resolve_btfids.c
> > > new file mode 100644
> > > index 000000000000..48aeda2ed881
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/test_resolve_btfids.c
> > > @@ -0,0 +1,201 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <string.h>
> > > +#include <stdio.h>
> > > +#include <sys/stat.h>
> > > +#include <stdio.h>
> > > +#include <sys/stat.h>
> > > +#include <fcntl.h>
> > > +#include <unistd.h>
> > > +#include <linux/err.h>
> > > +#include <stdlib.h>
> > > +#include <bpf/btf.h>
> > > +#include <bpf/libbpf.h>
> > > +#include <linux/btf.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/btf_ids.h>
> > > +
> > > +#define __CHECK(condition, format...) ({                               \
> > > +       int __ret = !!(condition);                                      \
> > > +       if (__ret) {                                                    \
> > > +               fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);     \
> > > +               fprintf(stderr, format);                                \
> > > +       }                                                               \
> > > +       __ret;                                                          \
> > > +})
> > > +
> > > +#define CHECK(condition, format...)                                    \
> > > +       do {                                                            \
> > > +               if (__CHECK(condition, format))                         \
> > > +                       return -1;                                      \
> > > +       } while (0)
> >
> > it's better to make CHECK return value, makes its use more flexible
> >
> > > +
> > > +static struct btf *btf__parse_raw(const char *file)
> >
> > How about adding this as a libbpf API? It's not the first time I see
> > this being re-implemented. While simple, libbpf already implements
> > this internally, so there should be no need to require users do this
> > all the time. Follow up patch is ok, no need to block on this.
>
> yea, I copied that code around few times already,
> I'll add it to libbpf

Awesome, thanks!

>
> >
> > > +{
> > > +       struct btf *btf;
> > > +       struct stat st;
> > > +       __u8 *buf;
> > > +       FILE *f;
> > > +
> > > +       if (stat(file, &st))
> > > +               return NULL;
> > > +
> > > +       f = fopen(file, "rb");
> > > +       if (!f)
> > > +               return NULL;
> > > +
> > > +       buf = malloc(st.st_size);
> > > +       if (!buf) {
> > > +               btf = ERR_PTR(-ENOMEM);
> > > +               goto exit_close;
> > > +       }
> > > +
> > > +       if ((size_t) st.st_size != fread(buf, 1, st.st_size, f)) {
> > > +               btf = ERR_PTR(-EINVAL);
> > > +               goto exit_free;
> > > +       }
> > > +
> > > +       btf = btf__new(buf, st.st_size);
> > > +
> > > +exit_free:
> > > +       free(buf);
> > > +exit_close:
> > > +       fclose(f);
> > > +       return btf;
> > > +}
> > > +
> >
> > [...]
> >
> > > +
> > > +static int
> > > +__resolve_symbol(struct btf *btf, int type_id)
> > > +{
> > > +       const struct btf_type *type;
> > > +       const char *str;
> > > +       unsigned int i;
> > > +
> > > +       type = btf__type_by_id(btf, type_id);
> > > +       CHECK(!type, "Failed to get type for ID %d\n", type_id);
> >
> > return otherwise you'll get crash on few lines below; it's unpleasant
> > to debug crashes in VM in Travis CI
>
> the CHECK macro does 'return' on error

ah, right, confusing. But it will change once you convert to test_progs :)

>
> >
> > > +
> > > +       for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
> > > +               if (test_symbols[i].id != -1)
> > > +                       continue;
> > > +
> > > +               if (BTF_INFO_KIND(type->info) != test_symbols[i].type)
> > > +                       continue;
> > > +
> > > +               str = btf__name_by_offset(btf, type->name_off);
> > > +               if (!str) {
> >
> > CHECK?
>
> ok
>
> >
> > > +                       fprintf(stderr, "failed to get name for BTF ID %d\n",
> > > +                               type_id);
> > > +                       continue;
> > > +               }
> > > +
> > > +               if (!strcmp(str, test_symbols[i].name))
> > > +                       test_symbols[i].id = type_id;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int resolve_symbols(void)
> > > +{
> > > +       const char *path = VMLINUX_BTF;
> > > +       struct btf *btf;
> > > +       int type_id;
> > > +       __u32 nr;
> > > +       int err;
> > > +
> > > +       btf = btf_open(path);
> > > +       CHECK(libbpf_get_error(btf), "Failed to load BTF from %s\n", path);
> > > +
> >
> > exit, crash othewise
>
> the CHECK macro does 'return' on error
>
> >
> > > +       nr = btf__get_nr_types(btf);
> > > +
> > > +       for (type_id = 0; type_id < nr; type_id++) {
> >
> > type_id = 1; type_id <= nr
>
> damn.. not again ;-) sry

no worries :)

>
> thanks,
> jirka
>
