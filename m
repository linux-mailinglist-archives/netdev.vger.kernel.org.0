Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248C1375EBD
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 04:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhEGCNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 22:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhEGCNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 22:13:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81038C061574;
        Thu,  6 May 2021 19:12:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id i190so6495642pfc.12;
        Thu, 06 May 2021 19:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=woV0wfis6Vgu/oe2Wn7/IaCbTJSmSO5eOeZoubzs3Z0=;
        b=sAuu+8O4+6LTbW60qp+nv5TMbRD1Qd8N/3wL4UVKl4Vdkf03y1xAtcdVDp7sKSreQn
         Ds+V+hOKLAjazSfS+/JksfS7idhnxTfRBn/D+EOw5jmqqbqGKXqkxBN/++zFisY593yy
         Udm3Ed8TJDtSMiU5zNTYPeI6uzcKYF9hmceSq4z7YpfwyYst6hijBwAHt6NAhMJLUJyL
         xIHxGDrieVb0u/vxF3TEhoyHEdxZL9nGdQCSNPI/OUrIgg9wQsf1G4cfzxhS7/+rQmtz
         1GP9K1PMn8BHHlXsXKBwc/DGmWOWGx2TrQgxEaM0/w4MEsLI86rINm45BlrJ6MNDZbxv
         DJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=woV0wfis6Vgu/oe2Wn7/IaCbTJSmSO5eOeZoubzs3Z0=;
        b=Nw1fkSSPd0V/RRTzxLAkdXVJhCpbWABN1wikvMlBPNEWnJE32OOt16O3ZM9Xq5hUrt
         3Xi0D/V7+q59Ee4n446rpEGanaWLL9deBKbF4GATPQ0JhMC8GoEIHDjALwFpZK24uP39
         DAlRT+1Ji3zsUDNrRNwwDQrZNU+yCTqrw+3i6BBKsy0G0M0bMY2UlBZd2PFtnj6Pyxnl
         o0n+QoKxKQZX/ZHkPSmDWTXsYr6JQQLHyaUvclsjQGXsg2otE8OH42O/a5pFAXh+DJ7v
         JZ155RL+SOkmBh/IwakV6UGnOcnZemC9QM3W41gEuD9jqfAOgI+srZEGt6fszDF6dobY
         ZHdA==
X-Gm-Message-State: AOAM531UQinYrilrgYxIgCMGQCF2WlVGENoy7mAox/WokaPP90K3fypo
        XqpzyO4bPcpp5kRXiPPeJZw=
X-Google-Smtp-Source: ABdhPJxbGIpJcDOePaM5Gfd1kkCmWXyafldXjALuO3QnZ/q2rVXtIncIvo8kCW5sylrwDKP7EZ2yHQ==
X-Received: by 2002:a63:490:: with SMTP id 138mr7223630pge.99.1620353526869;
        Thu, 06 May 2021 19:12:06 -0700 (PDT)
Received: from localhost ([2409:4063:4307:f74c:aad7:c605:3fd2:aff3])
        by smtp.gmail.com with ESMTPSA id o127sm3389359pfd.147.2021.05.06.19.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 19:12:06 -0700 (PDT)
Date:   Fri, 7 May 2021 07:41:55 +0530
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210507021155.ma2ogd25so5rgobg@apollo>
References: <20210504005023.1240974-1-memxor@gmail.com>
 <20210504005023.1240974-3-memxor@gmail.com>
 <eb6aada2-0de8-3adf-4b69-898a1c31c4e6@iogearbox.net>
 <20210506023753.7hkzo3xxrqighcm2@apollo>
 <70213fce-858e-5384-1614-919c4eced8ba@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70213fce-858e-5384-1614-919c4eced8ba@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 03:27:10AM IST, Daniel Borkmann wrote:
> On 5/6/21 4:37 AM, Kumar Kartikeya Dwivedi wrote:
> > On Thu, May 06, 2021 at 03:12:01AM IST, Daniel Borkmann wrote:
> > > On 5/4/21 2:50 AM, Kumar Kartikeya Dwivedi wrote:
> > > > This adds functions that wrap the netlink API used for adding,
> > > > manipulating, and removing traffic control filters.
> > > >
> > > > An API summary:
> > >
> > > Looks better, few minor comments below:
> > >
> > > > A bpf_tc_hook represents a location where a TC-BPF filter can be
> > > > attached. This means that creating a hook leads to creation of the
> > > > backing qdisc, while destruction either removes all filters attached to
> > > > a hook, or destroys qdisc if requested explicitly (as discussed below).
> > > >
> > > > The TC-BPF API functions operate on this bpf_tc_hook to attach, replace,
> > > > query, and detach tc filters.
> > > >
> > > > All functions return 0 on success, and a negative error code on failure.
> > > >
> > > > bpf_tc_hook_create - Create a hook
> > > > Parameters:
> > > > 	@hook - Cannot be NULL, ifindex > 0, attach_point must be set to
> > > > 		proper enum constant. Note that parent must be unset when
> > > > 		attach_point is one of BPF_TC_INGRESS or BPF_TC_EGRESS. Note
> > > > 		that as an exception BPF_TC_INGRESS|BPF_TC_EGRESS is also a
> > > > 		valid value for attach_point.
> > > >
> > > > 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> > > >
> > > > 		hook's flags member can be BPF_TC_F_REPLACE, which
> > > > 		creates qdisc in non-exclusive mode (i.e. an existing
> > > > 		qdisc will be replaced instead of this function failing
> > > > 		with -EEXIST).
> > >
> > > Why supporting BPF_TC_F_REPLACE here? It's not changing any qdisc parameters
> > > given clsact doesn't have any, no? Iow, what effect are you expecting on this
> > > with BPF_TC_F_REPLACE & why supporting it? I'd probably just require flags to
> > > be 0 here, and if hook exists return sth like -EEXIST.
> >
> > Ok, will change.
> >
> > > > bpf_tc_hook_destroy - Destroy the hook
> > > > Parameters:
> > > >           @hook - Cannot be NULL. The behaviour depends on value of
> > > > 		attach_point.
> > > >
> > > > 		If BPF_TC_INGRESS, all filters attached to the ingress
> > > > 		hook will be detached.
> > > > 		If BPF_TC_EGRESS, all filters attached to the egress hook
> > > > 		will be detached.
> > > > 		If BPF_TC_INGRESS|BPF_TC_EGRESS, the clsact qdisc will be
> > > > 		deleted, also detaching all filters.
> > > >
> > > > 		As before, parent must be unset for these attach_points,
> > > > 		and set for BPF_TC_CUSTOM. flags must also be unset.
> > > >
> > > > 		It is advised that if the qdisc is operated on by many programs,
> > > > 		then the program at least check that there are no other existing
> > > > 		filters before deleting the clsact qdisc. An example is shown
> > > > 		below:
> > > >
> > > > 		DECLARE_LIBBPF_OPTS(bpf_tc_hook, .ifindex = if_nametoindex("lo"),
> > > > 				    .attach_point = BPF_TC_INGRESS);
> > > > 		/* set opts as NULL, as we're not really interested in
> > > > 		 * getting any info for a particular filter, but just
> > > > 	 	 * detecting its presence.
> > > > 		 */
> > > > 		r = bpf_tc_query(&hook, NULL);
> > > > 		if (r == -ENOENT) {
> > > > 			/* no filters */
> > > > 			hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGREESS;
> > > > 			return bpf_tc_hook_destroy(&hook);
> > > > 		} else {
> > > > 			/* failed or r == 0, the latter means filters do exist */
> > > > 			return r;
> > > > 		}
> > > >
> > > > 		Note that there is a small race between checking for no
> > > > 		filters and deleting the qdisc. This is currently unavoidable.
> > > >
> > > > 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> > > >
> > > > bpf_tc_attach - Attach a filter to a hook
> > > > Parameters:
> > > > 	@hook - Cannot be NULL. Represents the hook the filter will be
> > > > 		attached to. Requirements for ifindex and attach_point are
> > > > 		same as described in bpf_tc_hook_create, but BPF_TC_CUSTOM
> > > > 		is also supported.  In that case, parent must be set to the
> > > > 		handle where the filter will be attached (using TC_H_MAKE).
> > > > 		flags member must be unset.
> > > >
> > > > 		E.g. To set parent to 1:16 like in tc command line,
> > > > 		     the equivalent would be TC_H_MAKE(1 << 16, 16)
> > >
> > > Small nit: I wonder whether from libbpf side we should just support a more
> > > user friendly TC_H_MAKE, so you'd have: BPF_TC_CUSTOM + BPF_TC_PARENT(1, 16).
> >
> > Something like this was there in v1. I'll add this macro again (I guess the most surprising part of
> > TC_H_MAKE is that it won't shift the major number).
>
> Agree, weird one. :)
>
> [...]
> > > > bpf_tc_detach
> > > > Parameters:
> > > > 	@hook: Cannot be NULL. Represents the hook the filter will be
> > > > 		detached from. Requirements are same as described above
> > > > 		in bpf_tc_attach.
> > > >
> > > > 	@opts:	Cannot be NULL.
> > > >
> > > > 		The following opts must be set:
> > > > 			handle
> > > > 			priority
> > > > 		The following opts must be unset:
> > > > 			prog_fd
> > > > 			prog_id
> > > > 			flags
> > > >
> > > > bpf_tc_query
> > > > Parameters:
> > > > 	@hook: Cannot be NULL. Represents the hook where the filter
> > > > 	       lookup will be performed. Requires are same as described
> > > > 	       above in bpf_tc_attach.
> > > >
> > > > 	@opts: Can be NULL.
> > >
> > > Shouldn't it be: Cannot be NULL?
> >
> > This allows you to check the existence of a filter. If set to NULL we skip writing anything to opts,
>
> You mean in this case s/filter/hook/, right?
>

Hm? I do mean filter. Since there is nothing to fill, we just cut short reading any more and return
early (but set info->processed) indicating there is (atleast) a filter attached.

It also allows you to implement the if (zero_filters()) del_qdisc(); logic on your own.

> > but we still return -ENOENT or 0 depending on whether atleast one filter exists (based on the
> > default attributes that we choose). This is used in multiple places in the test, to determine
> > whether no filters exists.
>
> In other words, it's same as bpf_tc_hook_create() which would return -EEXIST just that
> we do /not/ create the hook if it does not exist, right?
>

It really has nothing to do with bpf_tc_hook, that is only for obtaining ifindex/parent. With opts
as NULL you can just determine if there is any filter that is attached to the hook or not. In case
you do pass in opts but leave everything unset, we then return the first match.

> > > > 	       The following opts are optional:
> > > > 			handle
> > > > 			priority
> > > > 			prog_fd
> > > > 			prog_id
> > >
> > > What is the use case to set prog_fd here?
> >
> > It allows you to search with the prog_id of the program represented by fd. It's just a convenience
> > thing, we end up doing a call to get the prog_id for you, and since the parameter is already there,
> > it seemed ok to support this.
>
> I would drop that part and have prog_fd forced to 0, given libbpf already has other means to
> retrieve it from fd, and if non-convenient, then lets add a simple/generic libbpf API.
>

Ok, will drop.

> > > > 	       The following opts must be unset:
> > > > 			flags
> > > >
> > > > 	       However, only one of prog_fd and prog_id must be
> > > > 	       set. Setting both leads to an error. Setting none is
> > > > 	       allowed.
> > > >
> > > > 	       The following fields will be filled by bpf_tc_query on a
> > > > 	       successful lookup if they are unset:
> > > > 			handle
> > > > 			priority
> > > > 			prog_id
> > > >
> > > > 	       Based on the specified optional parameters, the matching
> > > > 	       data for the first matching filter is filled in and 0 is
> > > > 	       returned. When setting prog_fd, the prog_id will be
> > > > 	       matched against prog_id of the loaded SCHED_CLS prog
> > > > 	       represented by prog_fd.
> > > >
> > > > 	       To uniquely identify a filter, e.g. to detect its presence,
> > > > 	       it is recommended to set both handle and priority fields.
> > >
> > > What if prog_id is not unique, but part of multiple instances? Do we need
> > > to support this case?
> >
> > We return the first filter that matches on the prog_id. I think it is worthwhile to support this, as
> > long as the kernel's sequence of returning filters is stable (which it is), we keep returning the
> > same filter's handle/priority, so you can essentially pop filters attached to a hook one by one by
> > passing in unset opts and getting its details (or setting one of the parameters and making the
> > lookup domain smaller).
> >
> > In simple words, setting one of the parameters that will be filled leads to only returning an entry
> > that matches them. This is similar to what tc filter show's dump allows you to do.
>
> I think this is rather a bit weird/hacky/unintuitive. If we need such API, then lets add a
> proper one which returns all handle/priority combinations that match for a given prog_id
> for the provided hook, but I don't think this needs to be in the initial set; could be done
> as follow-up. (*)
>

Initially when adding this me and Toke did discuss the possibility of a query API that returns all
matches instead of the first one, but there were a few questions around how this would be returned.

One of the ways would be to require the caller to provide a buffer, and then provide some way to
iterate over this. The latter part is easy, but it is hard to predict how big the buffer should be
from the calling end. If it is smaller than needed, we will have to leave out entries and indicate
that in some way, and we also cannot return them in a subsequent call as that would break atomicity
(and we would have to know where to seek forward to in the netlink reply the next time).

The other way is making bpf_tc_query return an allocated buffer. This is better, as we can keep
doing realloc to grow it as needed, but again it seems like there must be a cap on the maximum size
to avoid unbounded growth (as there can be potentially many, many matching filters, especially on
use of NLM_F_DUMP).

A completely different idea would be to take a callback pointer from the user and invoke it for each
matching entry, allowing the user to do whatever they want with it (and have a void *userdata
parameter which we pass in). This sounds nice and has many benefits, but is potentially slower as
far as iteration is concerned (which might be a valid concern depending on how this interface is
used in the future).

It would be nice to have some more input on how this should be done before I get to writing the
code.

> [...]

--
Kartikeya
