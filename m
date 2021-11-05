Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B28446A15
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 21:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhKEUvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 16:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbhKEUvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 16:51:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F06C061714;
        Fri,  5 Nov 2021 13:48:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j9so9317404pgh.1;
        Fri, 05 Nov 2021 13:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iSsAsex9Qxf45MGUKoDkmbYaYqPdOA6HoAlu6dhpjH8=;
        b=jakEfGvgls1jMLVAmauhS/b4rUqhKPjOCKW514sAyxhBXwPV2hKGU5KRpAM6iVHKE7
         LWTeBQEN/GSJTtopLHMysedEQvudIi1w8mnv3rBRdMrVmmV6FGXf4Pa2thRl5YYCZ5SR
         Z+Wlf3d2CrlzMI2oAawmXrJRgYiQ2WS/ooNG6VWw5Zn6Ieb/VtHnO8gknOzcOJTcGLjb
         D8cG8MckWdajaldB+t9XV1bexpIfQv9V035pQLJEPffw/OIVcbC9MfbGy89EPc61I/XV
         ll6Z6+2cwKy4OaqEj/fWpBwBXITGv5uYn9Rop0Lofz5Xy/rJw3ZkW5WyzQwuyFZsLMNk
         kLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iSsAsex9Qxf45MGUKoDkmbYaYqPdOA6HoAlu6dhpjH8=;
        b=G+bVsi+Pgh2HHa1TdcyVdC7Bm4fQPTRlzMlPt7GjspNu5HHn2ldhpXdan3RzlvCQZ2
         +fHb9o4O9KfII+E/73l8+HXdnQn5/Imgtz63eWS724h6959Mg6f+NcZ4RQXRjOOluNue
         1rBpep+XpnMGBHAyMntCSEK/W7I7eid4myrbxTu6RuiV5M/U0gFSYp+3jIL59y3Mnb3/
         9lx1s1oCixsfArRs1e2avFWyHvcJ8WB1KrCsozJlazd/ddA4zCPEx6KF4lSlEbE045Bh
         Kuq75mVz5pmcYACllrVNas9yyS5KqEJm7krFiuYbhkuyVUuTfhFdUwnabyvV4RDd62xq
         z0TA==
X-Gm-Message-State: AOAM533CYoWl38eHvBtx5FV5N058LPHS8tpeSOSA6pjBSm/QPwF5fapM
        ql+DXjSFJdUVu2SrFfeMVh4=
X-Google-Smtp-Source: ABdhPJyL3SFYyP5FlyOwMwU/8+m/arwSKg2ldioZ+Jt/LgWLYrY+YNtvvJE+I8S9ODbk3cimylFA4A==
X-Received: by 2002:a05:6a00:1310:b0:494:672b:1e97 with SMTP id j16-20020a056a00131000b00494672b1e97mr13240235pfu.77.1636145313181;
        Fri, 05 Nov 2021 13:48:33 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id co4sm10546680pjb.2.2021.11.05.13.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 13:48:32 -0700 (PDT)
Date:   Sat, 6 Nov 2021 02:18:29 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT
 lookup helper for XDP and TC-BPF
Message-ID: <20211105204829.3qt6hkxk4vh6csfn@apollo.localdomain>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211030144609.263572-6-memxor@gmail.com>
 <20211031191045.GA19266@breakpoint.cc>
 <87y2677j19.fsf@toke.dk>
 <20211102204358.GC11415@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211102204358.GC11415@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 02:13:58AM IST, Florian Westphal wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > > I tried to find a use case but I could not.
> > > Entry will time out soon once packets stop appearing, so it can't be
> > > used for stack bypass.  Is it for something else?  If so, what?
> >
> > I think Maxim's use case was to implement a SYN proxy in XDP, where the
> > XDP program just needs to answer the question "do I have state for this
> > flow already". For TCP flows terminating on the local box this can be
> > done via a socket lookup, but for a middlebox, a conntrack lookup is
> > useful. Maxim, please correct me if I got your use case wrong.
>
> Looked at
> https://netdevconf.info/0x15/slides/30/Netdev%200x15%20Accelerating%20synproxy%20with%20XDP.pdf
>
> seems thats right, its only a "does it exist".
>

FYI, there's also an example in the original series (grep for bpf_ct_lookup_tcp):
https://lore.kernel.org/bpf/20211019144655.3483197-11-maximmi@nvidia.com

> > > For UDP it will work to let a packet pass through classic forward
> > > path once in a while, but this will not work for tcp, depending
> > > on conntrack settings (lose mode, liberal pickup etc. pp).
> >
> > The idea is certainly to follow up with some kind of 'update' helper. At
> > a minimum a "keep this entry alive" update, but potentially more
> > complicated stuff as well. Details TBD, input welcome :)
>
> Depends on use case.  For bypass infra I'd target the flowtable
> infra rather than conntrack because it gets rid of the "early time out"
> problem, plus you get the output interface/dst entry.
>
> Not trivial for xdp because existing code assumes sk_buff.
> But I think it can be refactored to allow raw buffers, similar
> to flow dissector.
>
> > >> +	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
> > >
> > > Ok, so default zone. Depending on meaning of "unstable helper" this
> > > is ok and can be changed in incompatible way later.
> >
> > I'm not sure about the meaning of "unstable" either, TBH, but in either
> > case I'd rather avoid changing things if we don't have to, so I think
> > adding the zone as an argument from the get-go may be better...
>
> Another thing I just noted:
> The above gives a nf_conn with incremented reference count.
>
> For Maxims use case, thats unnecessary overhead. Existence can be
> determined without reference increment.  The caveat is that the pointer
> cannot be used after last rcu_read_unlock().

From my reading, it was safe but not correct to use (as in dereference) without
using nf_conntrack_find_get, since even though freeing of underlying memory is
done using SLAB_DESTROY_BY_RCU, but the nf_conn itself may not correspond to the
same tuple in the rcu read section without taking a reference. So doing what the
example currently does (checking ct->status & IPS_CONFIRMED_BIT) is not safe
without raising the reference, even though the XDP program invocation is under
RCU protection. Returning a PTR_TO_BTF_ID for the nf_conn wouldn't really work
without getting a reference on it, since the object can be recycled.

--
Kartikeya
