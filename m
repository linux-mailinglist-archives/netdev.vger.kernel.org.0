Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A1A4355E5
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhJTWfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTWfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:35:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D858C06161C;
        Wed, 20 Oct 2021 15:33:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y4so17182498plb.0;
        Wed, 20 Oct 2021 15:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCO2YUZhVI0TRet8Nhcc4fhejghhYJvuV7zGl6nvP8Q=;
        b=NszdnfDyJcaGJsvVjEHahegvncmmymPSXNTdwnbuBoTVzqwVd7321t3SepeAgUvwjW
         jFjYrGXlHTFALFl0B+Pin5MbXGX9ME/rEIQ0Q/rDJa0AbrPfhbngdewiTwh3i9yeJcgU
         F+Ptclt8fg+N/TKjJKjypNwBK7UWpuu5KWJmr136nOtYF9RNjtrCzXiLhXpYQbJ0v8yG
         ArpXn+k7H3PB/3pNRRZr1VCrH/caij39qWU9pTvxQFsPoOcngxc6HmRYIv8PbSKtwICz
         sHJzmhAC8hnpRDnEyBhkHPO1rgsywdIE3ZMgXv2BDmklvmTXcjNPIQTS68VGOSCOY+Jd
         bhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCO2YUZhVI0TRet8Nhcc4fhejghhYJvuV7zGl6nvP8Q=;
        b=AXQPk5EVCKBxCkfTIkg9kOpbMQmUYUmiCgAs8ifZcG/ebV1NKONSpKvSu4oBk0kVBN
         Plr+C0opNYFaVcEVTs2FQ0RrDOqdcSb3S2g0hjFqD1Ei/AXIlyshQqRJTH2mD0cdqY0j
         Ld8OGVzg1ukMhfWKzA3YVsx5hyt/7wB2vcBBMt8Zmr7CUk8vhAb/lz6MLiBYJClNV8gl
         i2NUPZngYIhs856FLRkDT5+0NhgmE9iNwedG7abQD6FtT9jkry5E4NPYkEc5mVfugoxJ
         oG66IHFmCw6oHGExE5r4mOwoyBb3tlpdFDzprAIG2hhpvjnbbwk68Xj7gpZisZ3qvsGK
         qItg==
X-Gm-Message-State: AOAM532WNeWbjlXi1HKzcPRrYbjvbjMbz+/49K3t78Z5Xq/IFSVi/GgD
        I37GqkV7LLOS0EMszTYkZLjI8dUkJJS7mw==
X-Google-Smtp-Source: ABdhPJwEhMirOVEibvPoqKM8mxQ9E62M2Q0+xEHUjHL0kGEL5Dh+8N8E3d71UjRgOWeV/n47jHWQVw==
X-Received: by 2002:a17:902:6bc5:b0:13f:f585:4087 with SMTP id m5-20020a1709026bc500b0013ff5854087mr528735plt.32.1634769205177;
        Wed, 20 Oct 2021 15:33:25 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id m15sm668097pjd.24.2021.10.20.15.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 15:33:24 -0700 (PDT)
Date:   Thu, 21 Oct 2021 04:03:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 4/8] libbpf: Ensure that BPF syscall fds are
 never 0, 1, or 2
Message-ID: <20211020223322.luzn2ptajxhi2keo@apollo.localdomain>
References: <20211020191526.2306852-1-memxor@gmail.com>
 <20211020191526.2306852-5-memxor@gmail.com>
 <CAEf4BzbWeVOATjjRTdoKUvrwdmObcRO1X_FBKOm4zHjP5Rie4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbWeVOATjjRTdoKUvrwdmObcRO1X_FBKOm4zHjP5Rie4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 03:39:08AM IST, Andrii Nakryiko wrote:
> On Wed, Oct 20, 2021 at 12:15 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > Add a simple wrapper for passing an fd and getting a new one >= 3 if it
> > is one of 0, 1, or 2. There are two primary reasons to make this change:
> > First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
> > most recently noticed in [0]). Second, Alexei pointed out in [1] that
> > some environments reset stdin, stdout, and stderr if they notice an
> > invalid fd at these numbers. To protect against both these cases, switch
> > all internal BPF syscall wrappers in libbpf to always return an fd >= 3.
> > We only need to modify the syscall wrappers and not other code that
> > assumes a valid fd by doing >= 0, to avoid pointless churn, and because
> > it is still a valid assumption. The cost paid is two additional syscalls
> > if fd is in range [0, 2].
> >
> > This is only done for fds that are held by objects created using libbpf,
> > or returned from libbpf functions, not for intermediate fds closed soon
> > after their use is over. This implies that one of the assumptions is
> > that the environment resetting fds in the starting range [0, 2] only do
> > so before libbpf function call or after, but never in parallel, since
> > that would close fds while we dup them.
> >
> > [0]: e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
> > [1]: https://lore.kernel.org/bpf/CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/bpf.c             | 28 ++++++++++++-------------
> >  tools/lib/bpf/libbpf.c          | 36 ++++++++++++++++-----------------
> >  tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++++++
> >  tools/lib/bpf/linker.c          |  2 +-
> >  tools/lib/bpf/ringbuf.c         |  2 +-
> >  tools/lib/bpf/skel_internal.h   | 35 +++++++++++++++++++++++++++++++-
> >  6 files changed, 91 insertions(+), 35 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 7d1741ceaa32..0e1dedd94ebf 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -74,7 +74,7 @@ static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
> >                 fd = sys_bpf(BPF_PROG_LOAD, attr, size);
> >         } while (fd < 0 && errno == EAGAIN && retries-- > 0);
> >
> > -       return fd;
> > +       return ensure_good_fd(fd);
> >  }
> >
> >  int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
> > @@ -104,7 +104,7 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
> >                 attr.inner_map_fd = create_attr->inner_map_fd;
> >
> >         fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
>
> I think it will be cleaner in all the places to do
>
> fd = ensure_good_fd(fd);
>
> That's especially true for more complicated multi-line invocations,
> like the ones with perf_event_open syscall.
>

Ok, will fix.

> But also, I feel like adding a sys_bpf_fd() wrapper to use for all bpf
> syscalls that can return FDs would be cleaner still and will make it
> more obvious which APIs return "objects" (that is, FDs). Then you'll
> have ensure_good_fd() business in one or maybe just a few places,
> instead of spread around a dozen functions.
>

Can you give a short example?

> >  }
> >
> >  int bpf_create_map_node(enum bpf_map_type map_type, const char *name,
> > @@ -182,7 +182,7 @@ int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
> >         }
> >
> >         fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_create_map_in_map(enum bpf_map_type map_type, const char *name,
> > @@ -330,7 +330,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
> >         /* free() doesn't affect errno, so we don't need to restore it */
> >         free(finfo);
> >         free(linfo);
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
>
> this is "higher-level" function, it uses sys_bpf_prog_load() which
> already ensured "good" fd, so no need for ensure_good_fd() here
>

Correct, no need here.

> >  }
> >
> >  int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
> > @@ -610,7 +610,7 @@ int bpf_obj_get(const char *pathname)
> >         attr.pathname = ptr_to_u64((void *)pathname);
> >
> >         fd = sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
> > @@ -721,7 +721,7 @@ int bpf_link_create(int prog_fd, int target_fd,
> >         }
> >  proceed:
> >         fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_link_detach(int link_fd)
> > @@ -764,7 +764,7 @@ int bpf_iter_create(int link_fd)
> >         attr.iter_create.link_fd = link_fd;
> >
> >         fd = sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
> > @@ -922,7 +922,7 @@ int bpf_prog_get_fd_by_id(__u32 id)
> >         attr.prog_id = id;
> >
> >         fd = sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_map_get_fd_by_id(__u32 id)
> > @@ -934,7 +934,7 @@ int bpf_map_get_fd_by_id(__u32 id)
> >         attr.map_id = id;
> >
> >         fd = sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_btf_get_fd_by_id(__u32 id)
> > @@ -946,7 +946,7 @@ int bpf_btf_get_fd_by_id(__u32 id)
> >         attr.btf_id = id;
> >
> >         fd = sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_link_get_fd_by_id(__u32 id)
> > @@ -958,7 +958,7 @@ int bpf_link_get_fd_by_id(__u32 id)
> >         attr.link_id = id;
> >
> >         fd = sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
> > @@ -989,7 +989,7 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
> >         attr.raw_tracepoint.prog_fd = prog_fd;
> >
> >         fd = sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
> > @@ -1015,7 +1015,7 @@ int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_s
> >                 goto retry;
> >         }
> >
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
> >  }
> >
> >  int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
> > @@ -1051,7 +1051,7 @@ int bpf_enable_stats(enum bpf_stats_type type)
> >         attr.enable_stats.type = type;
> >
> >         fd = sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
> > -       return libbpf_err_errno(fd);
> > +       return libbpf_err_errno(ensure_good_fd(fd));
>
> this FD is never passed as prog_fd/bpf_fd/etc, so no need here
>

See below.

> >  }
> >
> >  int bpf_prog_bind_map(int prog_fd, int map_fd,
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 02cd7a6738da..d4d2842e31ea 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -1223,7 +1223,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
> >                 obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
> >                                             obj->efile.obj_buf_sz);
> >         } else {
> > -               obj->efile.fd = open(obj->path, O_RDONLY);
> > +               obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY));
>
> no need here, it's just internal ELF file FD
>

See below.

> >                 if (obj->efile.fd < 0) {
> >                         char errmsg[STRERR_BUFSIZE], *cp;
> >
> > @@ -9310,10 +9310,10 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >         attr.config2 = offset;           /* kprobe_addr or probe_offset */
> >
> >         /* pid filter is meaningful only for uprobes */
> > -       pfd = syscall(__NR_perf_event_open, &attr,
> > -                     pid < 0 ? -1 : pid /* pid */,
> > -                     pid == -1 ? 0 : -1 /* cpu */,
> > -                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > +       pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
> > +                            pid < 0 ? -1 : pid /* pid */,
> > +                            pid == -1 ? 0 : -1 /* cpu */,
> > +                            -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC));
>
> see above, pfd = ensure_good_fd(pfd) on a separate line after
> syscall() is much cleaner
>
> but thinking about this some more... do we ever pass perf_event_fd
> into BPF UAPI? I don't think so, so there is no need to enforce FD >
> 0. Let's drop that everywhere for perf_event_open().
>

I thought it was not just about BPF UAPI anymore, but also the first three fds
that can be closed by the runtime. So any fds held across calls, inside objects,
or returned from libbpf syscall functions needed to go through this. For fds
that are temporarily open and then closed later, it doesn't matter (because even
when duplicating the fd, we temporarily open an fd in the invalid slot, so if
someone was closing it in parallel, it would already be a problem).

>
> >         if (pfd < 0) {
> >                 err = -errno;
> >                 pr_warn("%s perf_event_open() failed: %s\n",
> > @@ -9404,10 +9404,10 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
> >         attr.config = type;
> >         attr.type = PERF_TYPE_TRACEPOINT;
> >
> > -       pfd = syscall(__NR_perf_event_open, &attr,
> > -                     pid < 0 ? -1 : pid, /* pid */
> > -                     pid == -1 ? 0 : -1, /* cpu */
> > -                     -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
> > +       pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
> > +                            pid < 0 ? -1 : pid, /* pid */
> > +                            pid == -1 ? 0 : -1, /* cpu */
> > +                            -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC));
> >         if (pfd < 0) {
> >                 err = -errno;
> >                 pr_warn("legacy kprobe perf_event_open() failed: %s\n",
> > @@ -9599,10 +9599,10 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
> >         attr.config = type;
> >         attr.type = PERF_TYPE_TRACEPOINT;
> >
> > -       pfd = syscall(__NR_perf_event_open, &attr,
> > -                     pid < 0 ? -1 : pid, /* pid */
> > -                     pid == -1 ? 0 : -1, /* cpu */
> > -                     -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
> > +       pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
> > +                            pid < 0 ? -1 : pid, /* pid */
> > +                            pid == -1 ? 0 : -1, /* cpu */
> > +                            -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC));
> >         if (pfd < 0) {
> >                 err = -errno;
> >                 pr_warn("legacy uprobe perf_event_open() failed: %d\n", err);
> > @@ -9731,8 +9731,8 @@ static int perf_event_open_tracepoint(const char *tp_category,
> >         attr.size = sizeof(attr);
> >         attr.config = tp_id;
> >
> > -       pfd = syscall(__NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
> > -                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > +       pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
> > +                            -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC));
> >         if (pfd < 0) {
> >                 err = -errno;
> >                 pr_warn("tracepoint '%s/%s' perf_event_open() failed: %s\n",
> > @@ -10251,8 +10251,8 @@ perf_buffer__open_cpu_buf(struct perf_buffer *pb, struct perf_event_attr *attr,
> >         cpu_buf->cpu = cpu;
> >         cpu_buf->map_key = map_key;
> >
> > -       cpu_buf->fd = syscall(__NR_perf_event_open, attr, -1 /* pid */, cpu,
> > -                             -1, PERF_FLAG_FD_CLOEXEC);
> > +       cpu_buf->fd = ensure_good_fd(syscall(__NR_perf_event_open, attr, -1 /* pid */, cpu,
> > +                                    -1, PERF_FLAG_FD_CLOEXEC));
> >         if (cpu_buf->fd < 0) {
> >                 err = -errno;
> >                 pr_warn("failed to open perf buffer event on cpu #%d: %s\n",
> > @@ -10378,7 +10378,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
> >         pb->mmap_size = pb->page_size * page_cnt;
> >         pb->map_fd = map_fd;
> >
> > -       pb->epoll_fd = epoll_create1(EPOLL_CLOEXEC);
> > +       pb->epoll_fd = ensure_good_fd(epoll_create1(EPOLL_CLOEXEC));
>
> same, no need
>

See above.

> >         if (pb->epoll_fd < 0) {
> >                 err = -errno;
> >                 pr_warn("failed to create epoll instance: %s\n",
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index f6a5748dd318..a4e776cafaaa 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -13,6 +13,8 @@
> >  #include <limits.h>
> >  #include <errno.h>
> >  #include <linux/err.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> >  #include "libbpf_legacy.h"
> >  #include "relo_core.h"
> >
> > @@ -472,4 +474,25 @@ static inline bool is_ldimm64_insn(struct bpf_insn *insn)
> >         return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
> >  }
> >
> > +/* if fd is stdin, stdout, or stderr, dup to a fd greater than 2
> > + * Takes ownership of the fd passed in, and closes it if calling
> > + * fcntl(fd, F_DUPFD_CLOEXEC, 3).
> > + */
> > +static inline int ensure_good_fd(int fd)
> > +{
> > +       int old_fd = fd, save_errno;
> > +
> > +       if (unlikely(fd >= 0 && fd < 3)) {
> > +               fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
> > +               if (fd < 0) {
> > +                       save_errno = errno;
> > +                       pr_warn("failed to dup FD %d to FD > 2: %d\n", old_fd, -errno);
> > +               }
> > +               close(old_fd);
> > +               if (fd < 0)
> > +                       errno = save_errno;
> > +       }
> > +       return fd;
>
> with all the if nestedness it looks more complicated than it needs to.
> How about something like this:
>
> if (fd < 0)
>     return fd;
>
> if (fd < 3) {
>     fd = fcnt(...);
>     save_errno = errno;
>     close(old_fd);
>     if (fd < 0) {
>        pr_warn(...);
>        errno = saved_errno;
>     }
> }
>
> return fd;
>
>
> WDYT?
>

Looks better, I'll do it like this.

> > +}
> > +
> >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> > diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> > index 2df880cefdae..6106a0b5572a 100644
> > --- a/tools/lib/bpf/linker.c
> > +++ b/tools/lib/bpf/linker.c
> > @@ -302,7 +302,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
> >         if (!linker->filename)
> >                 return -ENOMEM;
> >
> > -       linker->fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > +       linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644));
>
> again, nothing to do with BPF UAPI
>
> >         if (linker->fd < 0) {
> >                 err = -errno;
> >                 pr_warn("failed to create '%s': %d\n", file, err);
> > diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
> > index 8bc117bcc7bc..40bb33ae548b 100644
> > --- a/tools/lib/bpf/ringbuf.c
> > +++ b/tools/lib/bpf/ringbuf.c
> > @@ -173,7 +173,7 @@ ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
> >
> >         rb->page_size = getpagesize();
> >
> > -       rb->epoll_fd = epoll_create1(EPOLL_CLOEXEC);
> > +       rb->epoll_fd = ensure_good_fd(epoll_create1(EPOLL_CLOEXEC));
>
> here as well
>

See above.

> >         if (rb->epoll_fd < 0) {
> >                 err = -errno;
> >                 pr_warn("ringbuf: failed to create epoll instance: %d\n", err);
> > diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
> > index 9cf66702fa8d..1322c4de15e2 100644
> > --- a/tools/lib/bpf/skel_internal.h
> > +++ b/tools/lib/bpf/skel_internal.h
> > @@ -6,6 +6,7 @@
> >  #include <unistd.h>
> >  #include <sys/syscall.h>
> >  #include <sys/mman.h>
> > +#include <fcntl.h>
> >
> >  /* This file is a base header for auto-generated *.lskel.h files.
> >   * Its contents will change and may become part of auto-generation in the future.
> > @@ -60,11 +61,39 @@ static inline int skel_closenz(int fd)
> >         return -EINVAL;
> >  }
> >
> > +static inline int skel_reserve_bad_fds(struct bpf_load_and_run_opts *opts, int *fds)
> > +{
> > +       int fd, err, i;
> > +
> > +       for (i = 0; i < 3; i++) {
> > +               fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
> > +               if (fd < 0) {
> > +                       opts->errstr = "failed to reserve fd 0, 1, and 2";
> > +                       err = -errno;
> > +                       return err;
> > +               }
> > +               if (__builtin_expect(fd >= 3, 1)) {
>
> please drop the whole likely/unlikely business, we are not dealing
> with millions of FDs being open and closed, this micro optimization is
> completely unnecessary
>

Ok

>
> But also, why do still need to "reserve" bad FDs at all with all the
> ensure_good_fd() business?
>

This file is included in light skeleton, so it never goes through libbpf syscall
wrappers, also, not only will it invoke bpf syscall before calling
BPF_PROG_TEST_RUN, but also inside the syscall loader program. In there, doing
the fcntl stuff is much ugly (add a helper, more BPF assembly in gen_loader), so
I just reserve 3 fds in the beginning of the code sequence where fds are
acquired, and release them after we're done.

> > +                       close(fd);
> > +                       break;
> > +               }
> > +               fds[i] = fd;
> > +       }
> > +       return 0;
> > +}
> > +
> >  static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
> >  {
> > -       int map_fd = -1, prog_fd = -1, key = 0, err;
> > +       int map_fd = -1, prog_fd = -1, key = 0, err, i;
> > +       int res_fds[3] = { -1, -1, -1 };
> >         union bpf_attr attr;
> >
> > +       /* ensures that we don't open fd 0, 1, or 2 from here on out */
> > +       err = skel_reserve_bad_fds(opts, res_fds);
> > +       if (err < 0) {
> > +               errno = -err;
> > +               goto out;
> > +       }
> > +
> >         map_fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
> >                                      opts->data_sz, 1, 0);
> >         if (map_fd < 0) {
> > @@ -115,6 +144,10 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
> >         }
> >         err = 0;
> >  out:
> > +       for (i = 0; i < 3; i++) {
> > +               if (res_fds[i] >= 0)
> > +                       close(res_fds[i]);
> > +       }
> >         if (map_fd >= 0)
> >                 close(map_fd);
> >         if (prog_fd >= 0)
> > --
> > 2.33.1
> >

--
Kartikeya
