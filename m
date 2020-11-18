Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F02B83DD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgKRSbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKRSbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:31:38 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E742C0613D4;
        Wed, 18 Nov 2020 10:31:38 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id n89so2741669otn.3;
        Wed, 18 Nov 2020 10:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9elEQn62+w0ubYLwBnAdtc+sFOJJh0vSOLoYTmHU8ok=;
        b=OPalrHrnNAc4IK4D4G5WWu7rYdsb15/NRxSflbqxoQ0wwvYD+NVhEySsL8VdFuI5lv
         EF4wmBLYIl1EfYmQnu76fItk80/Y1Lp1cCG1uaLdP1sTrAKknwB7WEOsgkcwJDyi4gRV
         igWrXu7V0QVnmNI2ALoeZIvTMz7CePap+J0LEWXtqbLiV/9LKZz/NdrMNZJlZ7M4KqiU
         uVZNz4owmsSVch08OmFJ4FZw02m4AxcXevLoG5YQXpMTLhpdDRA/65oLuvWFrfcAgKo7
         sxXTPEIibffQga9KHUsID09B+Wn3mgxKUNGWpdvChO9eBfNKxj7IATU9GCeh/qtF3UC8
         WVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9elEQn62+w0ubYLwBnAdtc+sFOJJh0vSOLoYTmHU8ok=;
        b=WpLEjcYGde/4Yv2GOnPwV56an+6lDr/M8uZm0cFqx5pW3YkowuCo/LuhbqJwMfWHjX
         TII5nRZ568v2jJvd6BptILXDrYuQzvufLgHt3fG3HS9QmNXAqLPC4iiAzFEmVz9hpgJP
         oydm2WxxsB9FtcCqS35PMjonxk5J7VFuyvVvR/A3wRPVKemqmPn2egttwLGhhdOxr5Zm
         SnErEll8jbBiJP8/QrawLgWeOrUnBiOIj+lQ656De9XPwG57BOgUDwXgxUBgtXq0ww9c
         O0Zuzm54M7KJW7Y2kBK3MAnWjRpWsDA3Sl+8FKiPwaIqscHbWGcjx1a3BfVCZw1e5K0K
         ffLg==
X-Gm-Message-State: AOAM530NCVN+eQCXGkjEImmpPrvvJDDHSpQlIdTItSKGPLBpBh7zhz/4
        RoE1yadNy3pedYW+2kHrNFe8+kCiDUkIjrYVuQ==
X-Google-Smtp-Source: ABdhPJwCpHNPP44OEZtbEjP0+6VAuYwQK3LY/EhnN/tUiXjKq1h+um791bUX7To4V9nk0r5wSkdf4UToiF9Px3gndmA=
X-Received: by 2002:a9d:438:: with SMTP id 53mr2097131otc.222.1605724296527;
 Wed, 18 Nov 2020 10:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-3-danieltimlee@gmail.com> <20201118021043.zck246i2jvbboqlu@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201118021043.zck246i2jvbboqlu@kafai-mbp.dhcp.thefacebook.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 18:31:19 +0900
Message-ID: <CAEKGpzgfVfevOi4R04_0SBznHPyXWLPoh3rkXB_E9eD_JKCc+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/9] samples: bpf: refactor hbm program with libbpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:10 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 17, 2020 at 02:56:37PM +0000, Daniel T. Lee wrote:
> [ ... ]
>
> > +
> > +cleanup:
> > +     if (rc != 0)
> so this test can be avoided.
>

Thanks for pointing me out! I will follow this approach.

> > +             bpf_object__close(obj);
> > +
> > +     return rc;
> >  }
> >
> > [...]
> >       if (!outFlag)
> > -             type = BPF_CGROUP_INET_INGRESS;
> > -     if (bpf_prog_attach(bpfprog_fd, cg1, type, 0)) {
> > -             printf("ERROR: bpf_prog_attach fails!\n");
> > -             log_err("Attaching prog");
> > +             bpf_program__set_expected_attach_type(bpf_prog, BPF_CGROUP_INET_INGRESS);
> > +
> > +     link = bpf_program__attach_cgroup(bpf_prog, cg1);
> There is a difference here.
> I think the bpf_prog will be detached when link is gone (e.g. process exit)
> I am not sure it is what hbm is expected considering
> cg is not clean-up on the success case.
>

I think you're right. As I did in the third patch, I will use the
link__pin approach to prevent the link from being cleaned up when the
process exit.

> > +     if (libbpf_get_error(link)) {
> > +             fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
> > +             link = NULL;
> not needed.  bpf_link__destroy() can handle err ptr.
>

Thank you for the detailed advice, but in order to make it more clear
that link is no longer used, how about keeping this approach?

> >               goto err;
> >       }
> > [...]
> > +
> >       if (cg1)
> This test looks wrong since cg1 is a fd.
>

I'll remove unnecessary fd compare.

-- 
Best,
Daniel T. Lee
