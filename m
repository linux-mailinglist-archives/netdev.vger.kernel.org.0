Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5D594E7B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240599AbiHPCIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiHPCHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:07:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47AE10E7A1;
        Mon, 15 Aug 2022 15:00:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y3so11202754eda.6;
        Mon, 15 Aug 2022 15:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T3BNXnM8/uSXVm7gYnNlnagKr/r09Wg9R1KlljM+2MI=;
        b=Ru+YRuUfY4mqjyaatb7nZlVXi+2e4yAddoTV+qYz70z9AsblRHunci931h5+VVqL8q
         xYFTQGRQywswIpVid50GCCRKELYsMCMIcpgsXT34sYX42AQOByUpmBG5oIUlKWD0Pn86
         pGonC4R1iZMkbYDLcMkgTjE0zlkk7Fg+KotGF61lrCDtZsud8W1hsWVMoaCwKjQLgcCC
         CFMtEZqdlDf3S+lQZz7UdCoNTb0mylVkYS0Y81KVYbnsSrLggG86u+lz30jkuOOVlujF
         F2lRzrdsV5Vnh5gbyQrfyBegB4qQceqXOXygo7bO2q/I4Ywx32azEfYAY1drn/laqwEq
         zsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T3BNXnM8/uSXVm7gYnNlnagKr/r09Wg9R1KlljM+2MI=;
        b=Kl/YqiXQrOnkMQDOFaysuAgqMJpnauWhxY8xAExJ8d9GjqCLBS/PBUloiiJAkjrEzk
         rZ010J3EJ6PeIq7OgctH9m1NxH4wKmGIrTsTkYkGonzKOWAmFYspM9gxYqxolrxLBsD3
         xxQ+lc43I8FPo1HZ8hPQiiGxX69GGZdPlvKAz8T3iOcLhCaAo/xy27s+wob8hPcLZ+8V
         +izVS+oPt0TeblPQzlsfFQAeyxn9YJ7bOEtRVBRIHdVQwQKjl7pVUzshnh9AxQo66YzO
         uPcl3wi9ZUftjStiGQrorq0skmPqq6/38a89/iLKNXhAODU8cjMVAqL9jQb4UkbR+aDg
         da9g==
X-Gm-Message-State: ACgBeo06bNcVGpfYAp2fEqg3L26kY8jplF7pXaZET11xbbAKK/hN5sv1
        mQvF5RJ4r+1+OaRcpQDYJGZ2m7iEUSlU7Dg5prs=
X-Google-Smtp-Source: AA6agR4Xpty0a0xX36T/oYkX/50SCihLUbIHHrh4aJgB/OVvGj11f25UJ08jEFHcYWKLZnRnU5RJZtHmYKRi44b2rx4=
X-Received: by 2002:a50:ed82:0:b0:43d:5334:9d19 with SMTP id
 h2-20020a50ed82000000b0043d53349d19mr16025224edr.232.1660600801439; Mon, 15
 Aug 2022 15:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220813000936.6464-1-liuhangbin@gmail.com> <a3c23cfe-061a-1722-8521-26e57b4b2cf4@isovalent.com>
In-Reply-To: <a3c23cfe-061a-1722-8521-26e57b4b2cf4@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Aug 2022 14:59:50 -0700
Message-ID: <CAEf4BzbXehQtWnocp5KnArd0dq-Wg0ddPOyJZCwGPLO_L7wByg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next] libbpf: making bpf_prog_load() ignore name if
 kernel doesn't support
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 8:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 13/08/2022 01:09, Hangbin Liu wrote:
> > Similar with commit 10b62d6a38f7 ("libbpf: Add names for auxiliary maps"),
> > let's make bpf_prog_load() also ignore name if kernel doesn't support
> > program name.
> >
> > To achieve this, we need to call sys_bpf_prog_load() directly in
> > probe_kern_prog_name() to avoid circular dependency. sys_bpf_prog_load()
> > also need to be exported in the libbpf_internal.h file.
> >
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > v2: move sys_bpf_prog_load definition to libbpf_internal.h. memset attr
> >     to 0 specifically to aviod padding.
> > ---
> >  tools/lib/bpf/bpf.c             |  6 ++----
> >  tools/lib/bpf/libbpf.c          | 12 ++++++++++--
> >  tools/lib/bpf/libbpf_internal.h |  3 +++
> >  3 files changed, 15 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 6a96e665dc5d..575867d69496 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -84,9 +84,7 @@ static inline int sys_bpf_fd(enum bpf_cmd cmd, union bpf_attr *attr,
> >       return ensure_good_fd(fd);
> >  }
> >
> > -#define PROG_LOAD_ATTEMPTS 5
> > -
> > -static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
> > +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts)
> >  {
> >       int fd;
> >
> > @@ -263,7 +261,7 @@ int bpf_prog_load(enum bpf_prog_type prog_type,
> >       attr.prog_ifindex = OPTS_GET(opts, prog_ifindex, 0);
> >       attr.kern_version = OPTS_GET(opts, kern_version, 0);
> >
> > -     if (prog_name)
> > +     if (prog_name && kernel_supports(NULL, FEAT_PROG_NAME))
> >               libbpf_strlcpy(attr.prog_name, prog_name, sizeof(attr.prog_name));
> >       attr.license = ptr_to_u64(license);
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 3f01f5cd8a4c..4a351897bdcc 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4419,10 +4419,18 @@ static int probe_kern_prog_name(void)
> >               BPF_MOV64_IMM(BPF_REG_0, 0),
> >               BPF_EXIT_INSN(),
> >       };
> > -     int ret, insn_cnt = ARRAY_SIZE(insns);
> > +     union bpf_attr attr;
> > +     int ret;
> > +
> > +     memset(&attr, 0, sizeof(attr));
> > +     attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> > +     attr.license = ptr_to_u64("GPL");
> > +     attr.insns = ptr_to_u64(insns);
> > +     attr.insn_cnt = (__u32)ARRAY_SIZE(insns);
> > +     libbpf_strlcpy(attr.prog_name, "test", sizeof(attr.prog_name));
> >
> >       /* make sure loading with name works */
> > -     ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, "test", "GPL", insns, insn_cnt, NULL);
> > +     ret = sys_bpf_prog_load(&attr, sizeof(attr), PROG_LOAD_ATTEMPTS);
> >       return probe_fd(ret);
> >  }
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 4135ae0a2bc3..377642ff51fc 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -573,4 +573,7 @@ static inline bool is_pow_of_2(size_t x)
> >       return x && (x & (x - 1)) == 0;
> >  }
> >
> > +#define PROG_LOAD_ATTEMPTS 5
> > +int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size, int attempts);
> > +
> >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
>
> Looks good to me, thanks!
>
> Acked-by: Quentin Monnet <quentin@isovalent.com>

I did a small adjustment to not fill out entire big bpf_attr union
completely (and added a bit more meaningful "libbpf_nametest" prog
name):

$ git diff --staged
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4a351897bdcc..f05dd61a8a7f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4415,6 +4415,7 @@ static int probe_fd(int fd)

 static int probe_kern_prog_name(void)
 {
+       const size_t attr_sz = offsetofend(union bpf_attr, prog_name);
        struct bpf_insn insns[] = {
                BPF_MOV64_IMM(BPF_REG_0, 0),
                BPF_EXIT_INSN(),
@@ -4422,12 +4423,12 @@ static int probe_kern_prog_name(void)
        union bpf_attr attr;
        int ret;

-       memset(&attr, 0, sizeof(attr));
+       memset(&attr, 0, attr_sz);
        attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
        attr.license = ptr_to_u64("GPL");
        attr.insns = ptr_to_u64(insns);
        attr.insn_cnt = (__u32)ARRAY_SIZE(insns);
-       libbpf_strlcpy(attr.prog_name, "test", sizeof(attr.prog_name));
+       libbpf_strlcpy(attr.prog_name, "libbpf_nametest",
sizeof(attr.prog_name));

Pushed to bpf-next, thanks!
