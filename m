Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7F3675B6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343720AbhDUXbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbhDUXbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 19:31:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE31C06174A;
        Wed, 21 Apr 2021 16:30:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id y32so31450130pga.11;
        Wed, 21 Apr 2021 16:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LH3YQrm9alMwd/oouV7Q8wcRhkhsbpWbuIIg9/vsUW0=;
        b=T3S92kXaE4QRpq07ItpjWT7subMLU6LFZwsnyzgX3sGvjyOxgWcfw4RF4SLgLKRtXC
         RO8dOSm0eZ+ChHWjngCxmGBJ1Hyvoi2k4rL+gzpxbS7CNY5KNs8O1Go388jo1ke+VV4F
         CMFXQPE3MZS+kL8ip7kLCiBty4DCBdRHP2NnDEQqdyJ0T99Y2Ywl7vM3EfMbh4j62fP6
         py2Gx0itBqXA+w3Rm7zCei50bU0RjsSDkbkA/m6SPXS558tLXUSbuZqKLLk9ZJ8pFFS5
         zHKtEpzulZUH9UYb2X3FQfSh8w9nnVaDAtxqyFKaOChEFxfskSgtt2ZDMqRxuxK1hGmA
         9HsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LH3YQrm9alMwd/oouV7Q8wcRhkhsbpWbuIIg9/vsUW0=;
        b=sPh2BZfqvLxYeOSPeDSOabIw8L8JGzMpPYC9gcyew4lVVY0A53SuYUUJF1KV3KT8cA
         JY1EmJtdQ8fxbnw2wLj25S/Fne1KCQxn0ikixs916Q9Nao/AWaTzIRHCjmTsCl7sAKXp
         rhdGk5k2bKwZKcxAVOcDyiwNLGHE0A94RZfB8e8Vxxht+GWUx0idVtkOeywJbqWljiEk
         DQklNHWQVGR/Gn0NR6zSSni3D0xefTFDIe91qPvKFco4FkrDs3v6qxTrGyqXw9mOKQnR
         iANq0VKZF0VS6NFQaXOyymdFGxCsFhKNJ+8KUU70VqRGmlmXyzSLnpBpQQnBLoKgeGfE
         86Tw==
X-Gm-Message-State: AOAM530qhtyNQf7EnlZ0jvzTxT83d3+G6QL4xZ3RO28Xh43bqsh6UqS/
        cegUWPuxVwXRF1FJWRYS4iePtbfJiHgqgQ==
X-Google-Smtp-Source: ABdhPJyT/o2Uc1qT7MdPEPnwnvrO99l175A/hnXxIokrwnu96T/m9fZyW9bsTjSnnvkg1w2ZBwvIZw==
X-Received: by 2002:a17:90a:c8:: with SMTP id v8mr14056164pjd.18.1619047858327;
        Wed, 21 Apr 2021 16:30:58 -0700 (PDT)
Received: from localhost ([47.9.167.200])
        by smtp.gmail.com with ESMTPSA id pc17sm376267pjb.19.2021.04.21.16.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:30:57 -0700 (PDT)
Date:   Thu, 22 Apr 2021 05:00:54 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shaun Crampton <shaun@tigera.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210421233054.sgs5lemcuycx4vjb@apollo>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
 <20210421230858.ruwqw5jvsy7cjioy@apollo>
 <21c55619-e26d-d901-076e-20f55302c2fd@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21c55619-e26d-d901-076e-20f55302c2fd@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 04:51:55AM IST, Daniel Borkmann wrote:
> On 4/22/21 1:08 AM, Kumar Kartikeya Dwivedi wrote:
> > On Thu, Apr 22, 2021 at 04:29:28AM IST, Daniel Borkmann wrote:
> > > On 4/20/21 9:37 PM, Kumar Kartikeya Dwivedi wrote:
> > > [...]
> > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > index bec4e6a6e31d..b4ed6a41ea70 100644
> > > > --- a/tools/lib/bpf/libbpf.h
> > > > +++ b/tools/lib/bpf/libbpf.h
> > > > @@ -16,6 +16,8 @@
> > > >    #include <stdbool.h>
> > > >    #include <sys/types.h>  // for size_t
> > > >    #include <linux/bpf.h>
> > > > +#include <linux/pkt_sched.h>
> > > > +#include <linux/tc_act/tc_bpf.h>
> > > >    #include "libbpf_common.h"
> > > > @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> > > >    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> > > >    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> > > > +/* Convenience macros for the clsact attach hooks */
> > > > +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> > > > +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
> > >
> > > I would abstract those away into an enum, plus avoid having to pull in
> > > linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
> > >
> > > Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
> > > concrete tc bits (TC_H_MAKE()) can be translated internally.
> >
> > Ok, will do.
> >
> > > > +struct bpf_tc_opts {
> > > > +	size_t sz;
> > >
> > > Is this set anywhere?
> >
> > This is needed by the OPTS_* infrastructure.
> >
> > > > +	__u32 handle;
> > > > +	__u32 class_id;
> > >
> > > I'd remove class_id from here as well given in direct-action a BPF prog can
> > > set it if needed.
> >
> > Ok, makes sense.
> >
> > > > +	__u16 priority;
> > > > +	bool replace;
> > > > +	size_t :0;
> > >
> > > What's the rationale for this padding?
> >
> > dde7b3f5f2f4 ("libbpf: Add explicit padding to bpf_xdp_set_link_opts")
>
> Hm, fair enough.
>
> > > > +};
> > > > +
> > > > +#define bpf_tc_opts__last_field replace
> > > > +
> > > > +/* Acts as a handle for an attached filter */
> > > > +struct bpf_tc_attach_id {
> > >
> > > nit: maybe bpf_tc_ctx
> > >
> >
> > Noted.
> >
> > > > +	__u32 handle;
> > > > +	__u16 priority;
> > > > +};
> > > > +
> > > > +struct bpf_tc_info {
> > > > +	struct bpf_tc_attach_id id;
> > > > +	__u16 protocol;
> > > > +	__u32 chain_index;
> > > > +	__u32 prog_id;
> > > > +	__u8 tag[BPF_TAG_SIZE];
> > > > +	__u32 class_id;
> > > > +	__u32 bpf_flags;
> > > > +	__u32 bpf_flags_gen;
> > >
> > > Given we do not yet have any setters e.g. for offload, etc, the one thing
> > > I'd see useful and crucial initially is prog_id.
> > >
> > > The protocol, chain_index, and I would also include tag should be dropped.
> >
> > A future user of this API needs to know the tag, so I would like to keep that.
> > The rest we can drop, and probably document the default values explicitly.
>
> Couldn't this be added along with the future patch for the [future] user?
>

True.

> The tag should be the tag of the prog itself, so if you have prog_id, you
> could also retrieve the same tag from the prog. The tag was basically from
> the early days where we didn't have bpf_prog_get_info_by_fd().
>
> What does that future user need to do different here?
>

From Shaun Crampton:
"My particular use case is to load a program, link it with its maps and then
check if its tag matches the existing program on the interface (and if so, abort
the update)"

Also CC'd, they would be able to elaborate better, and whether or not dropping
it is ok.

> Thanks,
> Daniel

--
Kartikeya
