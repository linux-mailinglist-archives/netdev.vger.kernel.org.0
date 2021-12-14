Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA4474A1A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbhLNRyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbhLNRyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:54:20 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85838C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:54:20 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id o12-20020a05622a008c00b002aff5552c89so27344161qtw.23
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x26zWPfrBQRxXuE5L7i13nFPpUxZ5JNoyR4YdrElef8=;
        b=PDg+Mj8uBRzsS1XuMf6momFlNy4lNesGjwwCopXnBfIc3l4uoD3ZCDQpNPZ7glR949
         fLcDzkwVYeDTl801lA002WrLVWNdg0NFttc8GPDGIeaxZ/OEU73XIQxX7gNXpkT7vNye
         7pB7nqsJ2JRLIHCvK8FW384mKPUKvP6c11hMNuDgX6CBhhkkah8vOmiQ0mL4NYpC9Tbu
         cmuRZTFSxHeJtl5nobY6Psiq3MLaH7llD/kEosxjOWSIYIdtWhIBhNA+hFd4loOde6mX
         UCel3M48xQQQDyODI4ZqAHkcxkbFP1lDzcPiE8+oifSVnwccciK0ck94YNUUasumAUn/
         Lo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x26zWPfrBQRxXuE5L7i13nFPpUxZ5JNoyR4YdrElef8=;
        b=o8eDfkGlVEcujdY8GW40po/WW2FhDyx2lWTBpBbcUvKaS4RdWyx17XpIrvtU7h9koA
         ySKEJKbi/s2+Y0RCAhGk9vPuBV9A4+DmDLAc9vOtJZnJ0SAe2GwIvGqvholtb9bNqGww
         /ejB9Wdny+Hhr+++b+yBl1rRecIJZ7Zw3/dpwFcWO27XDwpXoNF8u16o+/aiL7EO+ZJo
         CFh1ywl1Y9dAgaaVqQNpwO+lle3BheSIvfNLJpRwC5yiASo0nr0HsYaDXcDcA22USG1x
         1Hsw2E7zpvxqN358EpUzz/w3vRcODs70n6pkcY+TyQmX+l/nFZa57t+y9zYwOagD2SJB
         okUg==
X-Gm-Message-State: AOAM532FpXfwr4f1IPi6qFKQdjRHaO1TbNvoR3IfWV2ZQo824G5HKgYF
        Q0B76fGLr4Zl2V+3yzYnkkg5fR4=
X-Google-Smtp-Source: ABdhPJxVUcQ+ZyXGp8x5drls3THNIAsUk+DiJ8nq5JpQIwuxFCwoK+V4rs4p1rkSdyrVwpGCm9Rx2ak=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:358b:a5f0:b6ba:1a07])
 (user=sdf job=sendgmr) by 2002:a05:622a:f:: with SMTP id x15mr7532957qtw.481.1639504459617;
 Tue, 14 Dec 2021 09:54:19 -0800 (PST)
Date:   Tue, 14 Dec 2021 09:54:16 -0800
In-Reply-To: <fa707ef9-d612-a3a4-1b2a-fc2b28a3ec5f@gmail.com>
Message-Id: <YbjaSNBlW03rX6c7@google.com>
Mime-Version: 1.0
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
 <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
 <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com> <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
 <fa707ef9-d612-a3a4-1b2a-fc2b28a3ec5f@gmail.com>
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb BPF filtering
From:   sdf@google.com
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11, Pavel Begunkov wrote:
> On 12/11/21 01:56, Martin KaFai Lau wrote:
> > On Sat, Dec 11, 2021 at 01:15:05AM +0000, Pavel Begunkov wrote:
> > > On 12/11/21 00:38, Martin KaFai Lau wrote:
> > > > On Fri, Dec 10, 2021 at 02:23:34AM +0000, Pavel Begunkov wrote:
> > > > > cgroup_bpf_enabled_key static key guards from overhead in cases  
> where
> > > > > no cgroup bpf program of a specific type is loaded in any cgroup.  
> Turn
> > > > > out that's not always good enough, e.g. when there are many  
> cgroups but
> > > > > ones that we're interesting in are without bpf. It's seen in  
> server
> > > > > environments, but the problem seems to be even wider as apparently
> > > > > systemd loads some BPF affecting my laptop.
> > > > >
> > > > > Profiles for small packet or zerocopy transmissions over fast  
> network
> > > > > show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is  
> from
> > > > > migrate_disable/enable(), and similarly on the receiving side.  
> Also
> > > > > got +4-5% of t-put for local testing.
> > > > >
> > > > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > > > ---
> > > > >    include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
> > > > >    kernel/bpf/cgroup.c        | 23 +++++++----------------
> > > > >    2 files changed, 28 insertions(+), 19 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/bpf-cgroup.h  
> b/include/linux/bpf-cgroup.h
> > > > > index 11820a430d6c..99b01201d7db 100644
> > > > > --- a/include/linux/bpf-cgroup.h
> > > > > +++ b/include/linux/bpf-cgroup.h
> > > > > @@ -141,6 +141,9 @@ struct cgroup_bpf {
> > > > >    	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
> > > > >    	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
> > > > > +	/* for each type tracks whether effective prog array is not  
> empty */
> > > > > +	unsigned long enabled_mask;
> > > > > +
> > > > >    	/* list of cgroup shared storages */
> > > > >    	struct list_head storages;
> > > > > @@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct  
> bpf_map *map, void *key, void *value);
> > > > >    int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void  
> *key,
> > > > >    				     void *value, u64 flags);
> > > > > +static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf  
> *cgrp_bpf,
> > > > > +					     enum cgroup_bpf_attach_type atype)
> > > > > +{
> > > > > +	return test_bit(atype, &cgrp_bpf->enabled_mask);
> > > > > +}
> > > > > +
> > > > > +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> > > > > +({									       \
> > > > > +	struct cgroup *__cgrp =  
> sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
> > > > > +									       \
> > > > > +	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
> > > > > +})
> > > > I think it should directly test if the array is empty or not  
> instead of
> > > > adding another bit.
> > > >
> > > > Can the existing __cgroup_bpf_prog_array_is_empty(cgrp, ...) test  
> be used instead?
> > >
> > > That was the first idea, but it's still heavier than I'd wish.  
> 0.3%-0.7%
> > > in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair  
> is
> > > cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
> > > the check.
> > It sounds like there is opportunity to optimize
> > __cgroup_bpf_prog_array_is_empty().
> >
> > How about using rcu_access_pointer(), testing with  
> &empty_prog_array.hdr,
> > and then inline it?  The cgroup prog array cannot be all
> > dummy_bpf_prog.prog.  If that could be the case, it should be replaced
> > with &empty_prog_array.hdr earlier, so please check.

> I'd need to expose and export empty_prog_array, but that should do.
> Will try it out, thanks

Note that we already use __cgroup_bpf_prog_array_is_empty in
__cgroup_bpf_run_filter_setsockopt/__cgroup_bpf_run_filter_getsockopt
for exactly the same purpose. If you happen to optimize it, pls
update these places as well.
