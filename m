Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE4573CBE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiGMSup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiGMSuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:50:44 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA051EC45;
        Wed, 13 Jul 2022 11:50:43 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x91so15291462ede.1;
        Wed, 13 Jul 2022 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8E/OyqYy9txlAConCx9/kspkC33WOncOhQArDqoDeac=;
        b=CgP91qF4FbUD94PQCFiu3MbbFwUpmn1HD5PMPQbo5UxWzmQycN6shjM+/1VXNdzE5U
         KGOiVVX75ks1tBpZi9xr3RBhV12ELPBmcE9REUKtWZP/J0Z4X91dvYYkEm2W+ewLbnu6
         +qDAtHs7Bf28JTNXwJ9P+wcXSY8KumDQZTbrGTS+fGMxejL7w2CgzJnhpSU5Pr5yGSCc
         KNuwusocfVTeyV0YT6RkPpsmh7hYenHZiGphBc9TAl7MGNODT3XDS9M0REaFGxkM2QF5
         WTcKI/yMmk3Q+KwKFC10We9qcJR3zWPVsQi1Nq0IAsqdsU6tqtv+TUcN2UNS3mvyx4Jv
         XNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8E/OyqYy9txlAConCx9/kspkC33WOncOhQArDqoDeac=;
        b=MzOVENTlheuBPKWkeQmjVLTs1jde/7zDkujJNTsfp2Yu3m8PeJJXUwntyqDVU2Hlbu
         vO724vk0yj7A95K0pNFio0LmOoajpZqBVGIsXIOcZa0eRXg8ojTkGCLNJaLO3MUyLOFZ
         cheVHGgRGd5KfHBgrNkWI99rOl0L+LDZVeAPSvGTT4jgK7ivY/3NyILIoKvaiamsIbQ0
         kHNHY49FS13PPlDXe1MG2Q5aj7hpIFHgYM91HdtUPm0aXfkzExsVu3xvb1XrlL6gagGN
         aKHORXtie/zqOgyJ3LtY2RMLp1R6n5ykRdMzepCrVE2OuQHMjEuxNaHe5BlZ+Gv6x+Au
         cwIw==
X-Gm-Message-State: AJIora8FpgbUoZ9ycexlgTg7kItu3er3layC7/O6Z4CUeX8HlLgptktZ
        129OTXvGB/8Fhc/oFZXlHJzNPxu1SxEJm3WAiyY=
X-Google-Smtp-Source: AGRyM1tlLrzyytvtasiQDguZ273vasVow3m/fKNRqaKiLFh7PJY2r3qqkO/aUT2bkZyPsbRaT1lvl+M1lhJGgRJKbT8=
X-Received: by 2002:a05:6402:50d2:b0:43a:8487:8a09 with SMTP id
 h18-20020a05640250d200b0043a84878a09mr6856437edb.232.1657738242046; Wed, 13
 Jul 2022 11:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220712030813.865410-1-pulehui@huawei.com> <20220712030813.865410-2-pulehui@huawei.com>
 <e1dd40cd-647c-10b4-53f9-a313e509474e@isovalent.com> <0c8f6067-0d5b-c1f7-2048-0ed4add76e73@huawei.com>
In-Reply-To: <0c8f6067-0d5b-c1f7-2048-0ed4add76e73@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 11:50:30 -0700
Message-ID: <CAEf4BzYvLZcDD0dfYWnc_FNchJ=ptxwnkvca40Xo_LF7Lr+c5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: Fix cross-compiling error by
 using bootstrap bpftool
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
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

On Tue, Jul 12, 2022 at 4:32 AM Pu Lehui <pulehui@huawei.com> wrote:
>
>
>
> On 2022/7/12 18:11, Quentin Monnet wrote:
> > On 12/07/2022 04:08, Pu Lehui wrote:
> >> Currently, when cross compiling bpf samples, the host side cannot
> >> use arch-specific bpftool to generate vmlinux.h or skeleton. Since
> >> samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
> >> only, we can use lightweight bootstrap version of bpftool to handle
> >> these, and it's always host-native.
> >>
> >> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> >> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> >> ---
> >>   samples/bpf/Makefile | 16 +++++++++++-----
> >>   1 file changed, 11 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> index 5002a5b9a7da..57012b8259d2 100644
> >> --- a/samples/bpf/Makefile
> >> +++ b/samples/bpf/Makefile
> >> @@ -282,12 +282,18 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
> >>
> >>   BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
> >>   BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
> >> -BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
> >> +BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
> >> +ifeq ($(CROSS_COMPILE),)
> >>   $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> >> -        $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
> >> -            OUTPUT=$(BPFTOOL_OUTPUT)/ \
> >> -            LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
> >> -            LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
> >> +    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../             \
> >> +            OUTPUT=$(BPFTOOL_OUTPUT)/                                       \
> >> +            LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/                       \
> >> +            LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
> >> +else
> >> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
> >
> > Thanks for this! Just trying to fully understand the details here. When
> > cross-compiling, you leave aside the dependency on target-arch-libbpf,
> > so that "make -C <bpftool-dir> bootstrap" rebuilds its own host-arch
> > libbpf, is this correct?
> >
>
> You're right. libbpf may does get out-of-sync. So the best way is to
> compile both arch-specific libbpf simultaneously, and then attach to
> bpftool. But it will make this job more complicated. Could we just add
> back $(LIBBPF) to handle this?
>

Maybe let's keep it simple and let bpftool's Makefile deal with
cross-compile issue and building its own libbpf? So just request
bootstrap, but not try to share libbpf between samples/bpf and
bpftool? Especially that is this "samples", such complexity in
Makefile seems like a micro-optimization.

> >> +    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../             \
> >> +            OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
> >> +endif
> >>
> >>   $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
> >>      $(call msg,MKDIR,$@)
> >
> > .
> >
