Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08134CDD16
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 20:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiCDTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 14:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCDTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 14:02:25 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB811DCCD4;
        Fri,  4 Mar 2022 11:01:37 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id h3so1837782ila.3;
        Fri, 04 Mar 2022 11:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMObxS5tQRpIXhdLuaKHnJPSIqtS75Y/Ea33zVnrFrA=;
        b=mZ5QM5j86JbxeNUsctNPJs2h5GM3K2Dw9kts6l+FcBUQZ3Qy0g3dP158Z7pNgMtVAM
         uvcWl5dyCZzSiwI1UZFPLKbclf+afc8fUxvXgF8blVMmGvkU/8cRPkElhhDBoe9bBG34
         MvxsaAzYXvBLIquu0/jyTf9DCeQmDK+8QuPe+6/NYQUUvAFciOA39l2vh6HjXltzl4lP
         5HjFIleTs9dPvHzCfnjgKjPjzphUsnmmwFFsChv/xS+74xNUUWS+TtpozWUgv60qyYUD
         Rax4zk+DMvIYJWfsH5JBVgn3L/eyxGJHAAFSFEZq7fbcMKH02LLpC3wboyjO3qKl3HPY
         nWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMObxS5tQRpIXhdLuaKHnJPSIqtS75Y/Ea33zVnrFrA=;
        b=o9ZGsKhIQkgGxttC+iC+y5g2LL7sUZwiMeI/ESTHZcirhxjlRfEBo5ftImDdB/zxJx
         vjmyd8rseY4vb332itRe8sCWmLOHm7s8IwTYJgoOEOo3GQbt0WdINhvHQ+xN5/nhZepi
         dW56trn7vZHhXX4dkYV/IACVycs3ebi7c2KREJdIVdsvSE5NHNj+BnFXHrOGexj81Rpq
         xZLaSXHn3yDFMesSnGxX/2QaXG0m3mmMaNYdKtGLU6RO56IRRBRzOQXa0m0tj0CiUwsL
         VTxUx0LIDN68e01sNWS0W8Cggh/hZUuTWulciN3nn77cIZBGoFSNKGMYqoLloH5P1IdS
         lC5w==
X-Gm-Message-State: AOAM533+Rd8ywW2pEHOwVV1UW+QN1YzMGTRtK3s3WCGCj0FevGrEc8vx
        Q/w8CfGTTDzBN0qcOy3/TM2eP8nfo+y6m/XE6+Y=
X-Google-Smtp-Source: ABdhPJxwat1cmeRVPGGNQtoWgCgqTmhF8VbqCCXQM9bk6ciN94xEDGDtWz1U96KOAqowFCwzalM5Hu06nr4k5eo+v2Y=
X-Received: by 2002:a92:ca0d:0:b0:2c2:a846:b05a with SMTP id
 j13-20020a92ca0d000000b002c2a846b05amr51270ils.252.1646420496912; Fri, 04 Mar
 2022 11:01:36 -0800 (PST)
MIME-Version: 1.0
References: <20220227142551.2349805-1-james.hilliard1@gmail.com> <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
In-Reply-To: <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 11:01:26 -0800
Message-ID: <CAEf4Bza84V1hwknb9XR+cNz8Sy4BK2EMYB-Oudq==pOYpqV0nw@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Mon, Feb 28, 2022 at 7:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi James,
>
> On 2/27/22 3:25 PM, James Hilliard wrote:
> > This definition seems to be missing from some older toolchains.
> >
> > Note that the fcntl.h in libbpf_internal.h is not a kernel header
> > but rather a toolchain libc header.
> >
> > Fixes:
> > libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first use in this function); did you mean 'FD_CLOEXEC'?
> >     fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
> >                    ^~~~~~~~~~~~~~~
> >                    FD_CLOEXEC
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
>
> Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_CLOEXEC
> was added back in 2.6.24 kernel. When did libc add it?

It seems like it's guarded by __USE_XOPEN2K8 in glibc (from a quick
glance at glibc code). But it's been there since 2010 or so, at the
very least.

>
> Should we instead just add an include for <linux/fcntl.h> to libbpf_internal.h
> (given it defines F_DUPFD_CLOEXEC as well)?

yep, this is UAPI header so we can use it easily (we'll need to sync
it into Github repo, but that's not a problem)


>
> > ---
> >   tools/lib/bpf/libbpf_internal.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> > index 4fda8bdf0a0d..d2a86b5a457a 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -31,6 +31,10 @@
> >   #define EM_BPF 247
> >   #endif
> >
> > +#ifndef F_DUPFD_CLOEXEC
> > +#define F_DUPFD_CLOEXEC 1030
> > +#endif
> > +
> >   #ifndef R_BPF_64_64
> >   #define R_BPF_64_64 1
> >   #endif
> >
>
> Thanks,
> Daniel
