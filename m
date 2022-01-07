Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F0248730F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiAGG1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiAGG06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:26:58 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8046C061245;
        Thu,  6 Jan 2022 22:26:58 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id m13so4401807pji.3;
        Thu, 06 Jan 2022 22:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gPtCYtDNKh7VvsIap26OOmHVz9QTUZhglH+C/8cTVx8=;
        b=MuxJwq57lZaQovLI/veUgOdI+6eYDBCgoICXxDyBxAkzkAhIbtubxvnhlmxXVMYn+2
         gIw571Tc+agUWfjcsVvAVi+IkMEshfhdN8qgY5wPjK/bYz2y8+9ugQFCGVdaqCpltzsp
         29VH+sbxgRMBON6ifXJx0k8KFMEFlFy8DPUnB6q19qym+hM8AyQI4dNzW6sviNPFpB9s
         zgcq5GYdYGm517yuXA0U5Wny9GCa6NsII6qM4y6IufnSvPo1xCMgmokI5ktk4NZSiRir
         f/aGw9EYf873aiPT9A8Wma6r6BU5KOQb58AdiyCITd0uBjrNsXd4AvACa2o5unbJNP7e
         Jv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gPtCYtDNKh7VvsIap26OOmHVz9QTUZhglH+C/8cTVx8=;
        b=ulLNKXhA7LN97uqFwdy0uE/HYcsZeegQQ+3l/Y4+jXHgn4cS9QnQVDNoLA9Ilag1ik
         b3hQsXmq4r7Vf49WOHF9/cYZ3rXuYb+DzM2Eq224MPaA9iYsaIAGSaXIuVeIpMSPPyBX
         +tr3YZwKUVHi/rUkidMbF+DbE2LM5FAnbuzldF4tMvNW48siGYCSRcP/pwHTGJXxXgue
         5NXP0LZYed/npD2zdqeWiEj/zqWq9zFXzW4/4GFN1GvhHQ0aqnAUv2yHTOSfMlmg4+lw
         Q3nfdL5BZJUTFZ1ssN+NbeDls4aS27NGom8J2HY4Y0aW77NeXlmdUopo2hw9Cgc/1r0E
         wVbQ==
X-Gm-Message-State: AOAM530qkn+XrFpGxsbkJJlqs6oBdMkcKk74c1RmmLWhVm2Onua+0oIm
        jp3w2qSImQTWYevDlnrGuy4=
X-Google-Smtp-Source: ABdhPJwfd4RF4+BlYGdl1UAM1ihyoT93eN3d5oDX3ptvoZeNmRYm49nyzli+OEkoIOBaY2PEQhPlmw==
X-Received: by 2002:a17:903:110d:b0:149:a908:16a2 with SMTP id n13-20020a170903110d00b00149a90816a2mr31811946plh.77.1641536818128;
        Thu, 06 Jan 2022 22:26:58 -0800 (PST)
Received: from localhost ([14.96.13.220])
        by smtp.gmail.com with ESMTPSA id ko19sm6635563pjb.16.2022.01.06.22.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 22:26:57 -0800 (PST)
Date:   Fri, 7 Jan 2022 11:56:45 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 03/11] bpf: Populate kfunc BTF ID sets in
 struct btf
Message-ID: <20220107062645.d5hdazzkvl4d2fhq@apollo.legion>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-4-memxor@gmail.com>
 <20220105061911.nzgzzvt2rpftcavi@ast-mbp.dhcp.thefacebook.com>
 <20220106085906.3zeugweq3twnkwzh@apollo.legion>
 <CAADnVQ+J+733_LU0QchkmpZz511_sCTeOAYi5MQ4YFMZQMygTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+J+733_LU0QchkmpZz511_sCTeOAYi5MQ4YFMZQMygTA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 05:10:56AM IST, Alexei Starovoitov wrote:
> On Thu, Jan 6, 2022 at 12:59 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > I'm not insisting, but for vmlinux we will have multiple
> > register_btf_kfunc_id_set calls for same hook, so we have to concat multiple
> > sets into one, which may result in an unsorted set. It's ok to not sort for
> > modules where only one register call per hook is allowed.
> >
> > Unless we switch to linear search for now (which is ok by me), we have to
> > re-sort for vmlinux BTF, to make btf_id_set_contains (in
> > btf_kfunc_id_set_contains) work.
>
> Could you give an example when it happens in vmlinux?
> Is it when modules are built-in (like tcp_bbr.c, tcp_cubic.c) ?
> But then they should go into struct btf of the module?
> Or THIS_MODULE becomes vmlinux and everything goes there?
> If that's the case then yeah, sorting is needed.

Yep, THIS_MODULE would be NULL, and it would pick vmlinux BTF for storing the
set.

Your suggestion to do direct assignment for module case is also good, since we
always ensure module refcount is held when looking into set, access to it should
be safe.

> Please make it clear in the comment and the commit log.
> It should be clear to reviewers without having to grill the author
> with questions.
> Would certainly save time for both author and reviewer. Agree?

Agreed, I'll add the comments and respin.

Thanks for your review.

--
Kartikeya
