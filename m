Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979B9424753
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbhJFTmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbhJFTm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 15:42:27 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9741C0613AB;
        Wed,  6 Oct 2021 12:39:10 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id r1so7961868ybo.10;
        Wed, 06 Oct 2021 12:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NmDMNuWO4pWWfzJSrJto6wjNblj6XuYNiHG4Rj1w6eE=;
        b=BIMdNqMsJokZgE2uQV2Y2HTlr0zh9x4D6dcEao4jfWSdmkRO7h2sjG947VKnCGG/hW
         6AZW/RalwjV5ZuJ4Nuh3pIZ+r6TjElQSr2gqOsf8/FSYYD3iGAMdesmBTW8D7exVQSs5
         To+WR7KQnMVq+OYoLe7UPPL/k7/5G6E1GsnkULdxPYB8EE0khp/1X2cw/RUMr5R6gPJY
         0HFTstpGw7rPqD0/MN5/zAuYSDVE2V4nM7bFc1nvlmtxXLPUmkM6LLNfPiVS8Tc2An72
         RFj0BDNe71eRp8xDnsYdWs1tc66d+f36Isu6fv4Q0Ua1TsZmqgce5WMlI3V+MEExiFUq
         Q7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NmDMNuWO4pWWfzJSrJto6wjNblj6XuYNiHG4Rj1w6eE=;
        b=5evLl25LGvl4sE9oRWGUvekVbgh22g+q8Wris46PAYrrP5Z2I0+B8Z0SWwzEm/U0AE
         rBXKwcNjP0sPL3uoP0JkXwPz2Rw0eBCYNH6NRqBPhXn+UnO5952kUKn8sR4WhUnGTYMQ
         tFBCL2fH2ZbRgaBzMAgywAh6LmUhjsbcn1FNcXXHhZndjJXerK3l9jSLnR+Na16sVJvH
         PLmLHJbd1I2KtPlO/0ANwcC0+fcmRksWd2fVCRg9bSmfN0xhzZTTfHIo9ORm5EhegUQ8
         ud5nkFtQHdVEZHG+ozybOgOpwFDz897ordk9PwwGYgOJYUdY+GxmhUxbvfzHUnjuPl3Z
         B0wg==
X-Gm-Message-State: AOAM530gaAo5rienpLpS6bWS93PLl4Y0iP3+Q+P6n6tLur19vuZ4zQAS
        Ci/hQgjvb/4EmtFgxqCyPCP+4BEiGzCtCaalgxw=
X-Google-Smtp-Source: ABdhPJzMfkJyOhYHp/H7LiKFYKciOcDob1/MAe/Tr3b46A6+427TEFqGaIYBL4SCRxF/ic3D3eM6/6eGyYSGn/H+GsE=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr8632ybk.2.1633549149846;
 Wed, 06 Oct 2021 12:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
 <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain> <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
 <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
In-Reply-To: <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 12:38:58 -0700
Message-ID: <CAEf4Bza186k8BeRG8XrUGaUb4_6hf0dCB4a1A5czcS69aBMffw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 12:09 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 6, 2021 at 9:43 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> > > > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > > >
> > > > > Since the code assumes in various places that BTF fd for modules is
> > > > > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> > > > > fd 0 being free for allocation is usually an application error, it is
> > > > > still possible that we end up getting fd 0 if the application explicitly
> > > > > closes its stdin. Deal with this by getting a new fd using dup and
> > > > > closing fd 0.
> > > > >
> > > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > > ---
> > > > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> > > > >  1 file changed, 14 insertions(+)
> > > > >
> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > index d286dec73b5f..3e5e460fe63e 100644
> > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
> > > > >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> > > > >                         return err;
> > > > >                 }
> > > > > +               /* Make sure module BTF fd is never 0, as kernel depends on it
> > > > > +                * being > 0 to distinguish between vmlinux and module BTFs,
> > > > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> > > > > +                */
> > > > > +               if (!fd) {
> > > > > +                       fd = dup(0);
> > > >
> > > > This is not the only place where we make assumptions that fd > 0 but
> > > > technically can get fd == 0. Instead of doing such a check in every
> > > > such place, would it be possible to open (cheaply) some FD (/dev/null
> > > > or whatever, don't know what's the best file to open), if we detect
> > > > that FD == 0 is not allocated? Can we detect that fd 0 is not
> > > > allocated?
> > > >
> > >
> > > We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
> > > open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I
> >
> > yeah, I like this idea, let's go with it
>
> FYI some production environments may detect that FDs 0,1,2 are not
> pointing to stdin, stdout, stderr and will force close whatever files are there
> and open 0,1,2 with canonical files.
>
> libbpf doesn't have to resort to such measures, but it would be prudent to
> make libbpf operate on FDs > 2 for all bpf objects to make sure other
> frameworks don't ruin libbpf's view of FDs.

oh well, even without those production complications this would be a
bit fragile, e.g., if the application temporarily opened FD 0 and then
closed it.

Ok, Kumar, can you please do it as a simple helper that would
dup()'ing until we have FD>2, and use it in as few places as possible
to make sure that all FDs (not just module BTF) are covered. I'd
suggest doing that only in low-level helpers in btf.c, I think
libbpf's logic always goes through those anyways (but please
double-check that we don't call bpf syscall directly anywhere else).
