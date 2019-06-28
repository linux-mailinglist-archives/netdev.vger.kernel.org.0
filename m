Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0653F5A56D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfF1Tui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:50:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35351 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfF1Tua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:50:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so7708150qto.2;
        Fri, 28 Jun 2019 12:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Xn18lnB6NiDq0QlwOmDWR2KRYMzbT2+w3Vk6jrhoPY=;
        b=rLglfyo3TWdmKFDzOneBzD601R8mOFy+h8nMHi/3SRfwgGjtiL107z2a9rKoBE9Mvu
         zJObbz5fewG9qgNilgITQpdTAhjTY+uP8gUrIO9K3Bmrq2nX0+frb6FFS09UxFjq+R6q
         idwK5FNRNyakAj+mSwBaG+tZ0mZgyJoTNq95KPoFmUOKnFMwcf8h197sWfJHpV7qCffG
         dLSPz73NXm1qJHntrdLNSx1MXVo4qyKP3sAph1Ap3NXw73r8q63jPvYrEp/StKWGAr32
         8L7Bt0C1X5NKtfDujSPq/OoIw0NAsSrbbPIK7om3mr8WyAVUlsI9qa8xAnOoCrQtVjfG
         r44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Xn18lnB6NiDq0QlwOmDWR2KRYMzbT2+w3Vk6jrhoPY=;
        b=G0vgLIZG3B6gz/vO3clEuzFtNIgeMgf3cctu12NbjTEGcpSXvgErH3B3U1rT9cuq+r
         JQv8RyXLXxMB/+zsT6tTywyT0hCbgJ1vlc1u9gxGmLYly2Vu+siDmvv79nc3S5ZZH/yL
         RHCxhpfYrc5UMjbQmdvY3zQVqPhADwPSEA1WkxHaHqHp4/X06aBPzTFXjgZOshCZ2uMh
         N1ukVXKa8ug/LnlFlGpauZZvG3me8n/sjJJZ3VmrRJ+h/3cXcHJNDrTCKvWsiDHOnnrs
         GxwO99XKW2A0K5XF5AacZBNs4sP+7kQUwTXE8cPWNvXxZWBhCYLjNpXMeCNmd+Doj4b0
         PFhg==
X-Gm-Message-State: APjAAAUPcsDQzik/VeeZmEq8AFLOX37uOccJk32DR1V6sByimJs2M+Rn
        FbgZA+m92K2s00xboINZHJLjKAV/9bgLgn8Pqqu9dQ==
X-Google-Smtp-Source: APXvYqzF2nlutE93zKV4dTbzD4T2inmcSAT5gwQWGVzz6bnsANulNKnKb6Ro+AA3wbOkmf3guorG/KMfYgvuU3XcbH8=
X-Received: by 2002:a0c:9695:: with SMTP id a21mr10080326qvd.24.1561751429069;
 Fri, 28 Jun 2019 12:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-6-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-6-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 12:50:18 -0700
Message-ID: <CAPhsuW6zLEY=3tc6Ja5Cnam_RJ=eUFdfmMnN4mfjWn18O5Rbgg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/9] libbpf: add tracepoint attach API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Allow attaching BPF programs to kernel tracepoint BPF hooks specified by
> category and name.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 78 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  4 +++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 83 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 65d2fef41003..76d1599a7d56 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4229,6 +4229,84 @@ struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
>         return link;
>  }
>
> +static int determine_tracepoint_id(const char* tp_category, const char* tp_name)
> +{
> +       char file[PATH_MAX];
> +       int ret;
> +
> +       ret = snprintf(file, sizeof(file),
> +                      "/sys/kernel/debug/tracing/events/%s/%s/id",
> +                      tp_category, tp_name);
> +       if (ret < 0)
> +               return -errno;
> +       if (ret >= sizeof(file)) {
> +               pr_debug("tracepoint %s/%s path is too long\n",
> +                        tp_category, tp_name);
> +               return -E2BIG;
> +       }
> +       return parse_uint_from_file(file);
> +}
> +
> +static int perf_event_open_tracepoint(const char* tp_category,
> +                                     const char* tp_name)
> +{
> +       struct perf_event_attr attr = {};
> +       char errmsg[STRERR_BUFSIZE];
> +       int tp_id, pfd, err;
> +
> +       tp_id = determine_tracepoint_id(tp_category, tp_name);
> +       if (tp_id < 0){
> +               pr_warning("failed to determine tracepoint '%s/%s' perf ID: %s\n",
> +                          tp_category, tp_name,
> +                          libbpf_strerror_r(tp_id, errmsg, sizeof(errmsg)));
> +               return tp_id;
> +       }
> +
> +       attr.type = PERF_TYPE_TRACEPOINT;
> +       attr.size = sizeof(attr);
> +       attr.config = tp_id;
> +
> +       pfd = syscall( __NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
> +                       -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> +       if (pfd < 0) {
> +               err = -errno;
> +               pr_warning("tracepoint '%s/%s' perf_event_open() failed: %s\n",
> +                          tp_category, tp_name,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return err;
> +       }

Similar to the 4/9, I guess we can remove some duplicated pr_warning().

Thanks,
Song

> +       return pfd;
> +}
> +
> +struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
> +                                               const char *tp_category,
> +                                               const char *tp_name)
> +{
> +       char errmsg[STRERR_BUFSIZE];
> +       struct bpf_link *link;
> +       int pfd, err;
> +
> +       pfd = perf_event_open_tracepoint(tp_category, tp_name);
> +       if (pfd < 0) {
> +               pr_warning("program '%s': failed to create tracepoint '%s/%s' perf event: %s\n",
> +                          bpf_program__title(prog, false),
> +                          tp_category, tp_name,
> +                          libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(pfd);
> +       }
> +       link = bpf_program__attach_perf_event(prog, pfd);
> +       if (IS_ERR(link)) {
> +               close(pfd);
> +               err = PTR_ERR(link);
> +               pr_warning("program '%s': failed to attach to tracepoint '%s/%s': %s\n",
> +                          bpf_program__title(prog, false),
> +                          tp_category, tp_name,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return link;
> +       }
> +       return link;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>                            void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bd767cc11967..60611f4b4e1d 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -178,6 +178,10 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
>                            pid_t pid, const char *binary_path,
>                            size_t func_offset);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_tracepoint(struct bpf_program *prog,
> +                              const char *tp_category,
> +                              const char *tp_name);
>
>  struct bpf_insn;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 57a40fb60718..3c618b75ef65 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -171,6 +171,7 @@ LIBBPF_0.0.4 {
>                 bpf_object__load_xattr;
>                 bpf_program__attach_kprobe;
>                 bpf_program__attach_perf_event;
> +               bpf_program__attach_tracepoint;
>                 bpf_program__attach_uprobe;
>                 btf_dump__dump_type;
>                 btf_dump__free;
> --
> 2.17.1
>
