Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061EF19316B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCYTsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:48:10 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38859 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYTsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:48:10 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so1441475pje.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gNRk+AqHgbXI95es83rWVUIu+SAdUK4LqSHgrKC0U/A=;
        b=idXhkfkRTzW/YU35N2RHQoAWbNQ8TgDGenwD6d35Bu+J11tN77O5UX0CtlkVCR1fvz
         gpUg36VydnIvN8mAYpMkKhQ9UyFD+6WD5rC2+uw7rbhXBoN4tg/d1XHoU+LsTXQ3+7Iy
         /WHvPiV/0E9wZ1Jangg9K223n8joWGB8x3XNXh8Jtc/7+dvZ3xwjCFZzZvt4GAw7thMU
         Q4oHI0DWXIRamR0fm+eOH6zqOtMnqN45h8R9ETVWJYg3p1Mu6G5x6012U6jNysrEdNwn
         y5xui2FzK9jkteISc9IvagqYRiOmIM+IKDNmwMxRcMJJe8sdOKEqL65afXxgk0EARmmM
         UFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gNRk+AqHgbXI95es83rWVUIu+SAdUK4LqSHgrKC0U/A=;
        b=aXIiomV0fN4b8LSvisn1MIIUyfeyOj1XPIZ6tQlygNYB3UiKU8ikEpQH5p96nZCSCG
         JGsI2N19HJVVtp6bmn+JimyGAOF/7p1+64UQ4o7lht7waaOl+Exfg4lomI5LBQJGKlSH
         C59rzH44JmCLn2F2uA67rbz7BXSELjlyhKuNfWEBGn0aiP0BBzVulCBrtV7NK8kilaVo
         VhAzKs1pvasvbwd3ct27lvAWprw47Gc4SBg5FS/1rqH6D2T94j1X3BIlxqslX3R/Tz9U
         KUBYVZb+A6ju4p67mTEK5WmAxyVSk3eoad/kl5pC8z96Uz8sFSkcuSFUwBpJ84VsvSYK
         sezw==
X-Gm-Message-State: ANhLgQ3fu/omC0oyGUTpIWyG8hUDLlD/KGE4lkzB0qgMROIT2+foUonK
        2ONSoKBgF4DLHWvDak5LosD4mg==
X-Google-Smtp-Source: ADFU+vsZjYZXQ0igbU1mabKTgvelhgYxrvogp20XzVi/eoGE0KTKsg5vF2H1Y8KqZlhurIYEC0I6oA==
X-Received: by 2002:a17:90a:36e5:: with SMTP id t92mr5644174pjb.51.1585165688666;
        Wed, 25 Mar 2020 12:48:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g16sm18274201pgb.54.2020.03.25.12.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 12:48:08 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:48:07 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2] libbpf: don't allocate 16M for log buffer by
 default
Message-ID: <20200325194807.GB2805006@mini-arch.hsd1.ca.comcast.net>
References: <20200325162026.254799-1-sdf@google.com>
 <CAEf4BzbEuWdb-77nm=o5doGfYbpWxbTe+U2mM+KH1hw6CnYuww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbEuWdb-77nm=o5doGfYbpWxbTe+U2mM+KH1hw6CnYuww@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/25, Andrii Nakryiko wrote:
> On Wed, Mar 25, 2020 at 9:20 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > For each prog/btf load we allocate and free 16 megs of verifier buffer.
> > On production systems it doesn't really make sense because the
> > programs/btf have gone through extensive testing and (mostly) guaranteed
> > to successfully load.
> >
> > Let's assume successful case by default and skip buffer allocation
> > on the first try. If there is an error, start with BPF_LOG_BUF_SIZE
> > and double it on each ENOSPC iteration.
> >
> > v2:
> > * Don't allocate the buffer at all on the first try (Andrii Nakryiko)
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/lib/bpf/btf.c    | 20 +++++++++++++++-----
> >  tools/lib/bpf/libbpf.c | 22 ++++++++++++++--------
> >  2 files changed, 29 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 3d1c25fc97ae..bfef3d606b54 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -657,22 +657,32 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
> >
> >  int btf__load(struct btf *btf)
> >  {
> > -       __u32 log_buf_size = BPF_LOG_BUF_SIZE;
> > +       __u32 log_buf_size = 0;
> >         char *log_buf = NULL;
> >         int err = 0;
> >
> >         if (btf->fd >= 0)
> >                 return -EEXIST;
> >
> > -       log_buf = malloc(log_buf_size);
> > -       if (!log_buf)
> > -               return -ENOMEM;
> > +retry_load:
> > +       if (log_buf_size) {
> > +               log_buf = malloc(log_buf_size);
> > +               if (!log_buf)
> > +                       return -ENOMEM;
> >
> > -       *log_buf = 0;
> > +               *log_buf = 0;
> > +       }
> >
> >         btf->fd = bpf_load_btf(btf->data, btf->data_size,
> >                                log_buf, log_buf_size, false);
> >         if (btf->fd < 0) {
> > +               if (!log_buf || errno == ENOSPC) {
> > +                       log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
> > +                                          log_buf_size << 1);
> > +                       free(log_buf);
> > +                       goto retry_load;
> > +               }
> > +
> >                 err = -errno;
> >                 pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
> >                 if (*log_buf)
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 085e41f9b68e..b2fd43a03708 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4855,8 +4855,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >  {
> >         struct bpf_load_program_attr load_attr;
> >         char *cp, errmsg[STRERR_BUFSIZE];
> > -       int log_buf_size = BPF_LOG_BUF_SIZE;
> > -       char *log_buf;
> > +       size_t log_buf_size = 0;
> > +       char *log_buf = NULL;
> >         int btf_fd, ret;
> >
> >         if (!insns || !insns_cnt)
> > @@ -4896,22 +4896,28 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >         load_attr.prog_flags = prog->prog_flags;
> >
> >  retry_load:
> > -       log_buf = malloc(log_buf_size);
> > -       if (!log_buf)
> > -               pr_warn("Alloc log buffer for bpf loader error, continue without log\n");
> > +       if (log_buf_size) {
> > +               log_buf = malloc(log_buf_size);
> > +               if (!log_buf)
> > +                       pr_warn("Alloc log buffer for bpf loader error, continue without log\n");
> > +
> 
> considering that log_buf is not allocated first time, if it fails to
> allocate on retry then it should be an error, no?
> 
> Otherwise looks good, please add my ack after fixing this:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
Thx, will respin a v3. Returning -ENOMEM also makes it more consistent with
btf retry logic.

> > +               *log_buf = 0;
> > +       }
> >
> >         ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
> >
> >         if (ret >= 0) {
> > -               if (load_attr.log_level)
> > +               if (log_buf && load_attr.log_level)
> >                         pr_debug("verifier log:\n%s", log_buf);
> >                 *pfd = ret;
> >                 ret = 0;
> >                 goto out;
> >         }
> >
> > -       if (errno == ENOSPC) {
> > -               log_buf_size <<= 1;
> > +       if (!log_buf || errno == ENOSPC) {
> > +               log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
> > +                                  log_buf_size << 1);
> > +
> >                 free(log_buf);
> >                 goto retry_load;
> >         }
> > --
> > 2.25.1.696.g5e7596f4ac-goog
> >
