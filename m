Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13893364D43
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhDSVpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSVpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 17:45:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF284C06174A;
        Mon, 19 Apr 2021 14:45:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14465493pja.5;
        Mon, 19 Apr 2021 14:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LzxQK/CU4ynjI/E7pRzvISVtXqdE8G14j2LtNlutIas=;
        b=MlanFccCsIRVX95txZVLCXtshbIxONx6gywsnRWGPOMupSJXFZfFLL3LbTXm9Lsuoq
         ke8OEd5bAm3f5e5mfye0nOFeShP1GYkRgFDFKiBmbxY4RM2Nue36ZS9+Z/B44fLz4zHt
         t3qVvZVCtat5HZtkqVZX9A+efezGTmpZF0uOjLBh7Mm2nU1cBMrBGKkT09eACFevUyBo
         RVifCHlaFxfcNhVcv1wgoAnOgEpyPvANOUDAPrFurto3LzkYP+X8XdxTWcQFFQV61ouv
         ZFx/L4LvWPpxerbGZBjs7P23JEIXOEmHQF1jHSBLJxkjbaawLWZLj5pF23lpKwuQ4+nE
         QcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LzxQK/CU4ynjI/E7pRzvISVtXqdE8G14j2LtNlutIas=;
        b=NF7hykblShYGPuRqPILbISzX/VAvB7xstM8OsmdUhhNt8ppV11/iilZ+lEoEaBdQLt
         9PIz8DLr7qQ/GpIWuBeIz+QMQrfD1/aU77mxcLWWZsAH5RmfOJcjcASjMMdqHh2a+1/v
         0iCmLobvyrRJ/TjpCj775fun9RwnprOvzvkE+cyEX7i0E/GILI/FrK0mLsPhS6fuWQoo
         TjkUhJtvzViBIteWMo4CWZu/2mqoPSgDiroDyaFJUGprs5O2U3RsFEeE60hy9IBpIDek
         cIYBfV8+pNw+PL1UXfd7G+Va74/ltizT+02PRMWsWOlv+/mEgqU8+VYIrDpDUQJb2vBK
         AoPw==
X-Gm-Message-State: AOAM532bQ1l6DjS4Q+sSg9/RYrbgZlWcnGIZ9cqZrUa31MUjlBP45rM8
        izKMICfef0O299ej0VX/t0L3W0PWRnuEwQ==
X-Google-Smtp-Source: ABdhPJxHlu8y84mVAO/23U5UXKLvF22TGu2zwelpSNcbOkE2siqEEaJYq8pQ8Gm+fAgJzSCpoHaPhA==
X-Received: by 2002:a17:902:ed52:b029:ea:aaaf:60d6 with SMTP id y18-20020a170902ed52b02900eaaaaf60d6mr25508856plb.55.1618868722347;
        Mon, 19 Apr 2021 14:45:22 -0700 (PDT)
Received: from localhost ([47.9.175.189])
        by smtp.gmail.com with ESMTPSA id gc15sm370473pjb.2.2021.04.19.14.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 14:45:22 -0700 (PDT)
Date:   Tue, 20 Apr 2021 03:15:17 +0530
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: add low level TC-BPF API
Message-ID: <20210419214517.bqur27tytx4onfnn@apollo>
References: <20210419121811.117400-1-memxor@gmail.com>
 <20210419121811.117400-4-memxor@gmail.com>
 <6e8b744c-e012-c76b-b55f-7ddc8b7483db@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e8b744c-e012-c76b-b55f-7ddc8b7483db@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:30:44AM IST, Daniel Borkmann wrote:
> On 4/19/21 2:18 PM, Kumar Kartikeya Dwivedi wrote:
> > This adds functions that wrap the netlink API used for adding,
> > manipulating, and removing traffic control filters. These functions
> > operate directly on the loaded prog's fd, and return a handle to the
> > filter using an out parameter named id.
> >
> > The basic featureset is covered to allow for attaching, manipulation of
> > properties, and removal of filters. Some additional features like
> > TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
> > added on top later by extending the bpf_tc_cls_opts struct.
> >
> > Support for binding actions directly to a classifier by passing them in
> > during filter creation has also been omitted for now. These actions have
> > an auto clean up property because their lifetime is bound to the filter
> > they are attached to. This can be added later, but was omitted for now
> > as direct action mode is a better alternative to it, which is enabled by
> > default.
> >
> > An API summary:
> >
> > bpf_tc_act_{attach, change, replace} may be used to attach, change, and
>
> typo on bpf_tc_act_{...} ?
>

Oops, yes. Should be bpf_tc_cls_...

> > replace SCHED_CLS bpf classifier. The protocol field can be set as 0, in
> > which case it is subsitituted as ETH_P_ALL by default.
>
> Do you have an actual user that needs anything other than ETH_P_ALL? Why is it
> even needed? Why not stick to just ETH_P_ALL?
>

Mostly because it was little to no effort to expose this. Though if you feel
strongly about it I can drop the protocol option, and just bake in ETH_P_ALL. It
can always be added later ofcourse, if the need arises in the future.

> > The behavior of the three functions is as follows:
> >
> > attach = create filter if it does not exist, fail otherwise
> > change = change properties of the classifier of existing filter
> > replace = create filter, and replace any existing filter
>
> This touches on tc oddities quite a bit. Why do we need to expose them? Can't we
> simplify/abstract this e.g. i) create or update instance, ii) delete instance,
> iii) get instance ? What concrete use case do you have that you need those three
> above?
>

'change' is relevant for modifying classifier specific options, and given it's
a lot less useful now as per the current state of this patch, I am fine with
removing it. This is also where the distinction becomes visible to the user, so
removing it should hide the filter/classifier separation.

> > bpf_tc_cls_detach may be used to detach existing SCHED_CLS
> > filter. The bpf_tc_cls_attach_id object filled in during attach,
> > change, or replace must be passed in to the detach functions for them to
> > remove the filter and its attached classififer correctly.
> >
> > bpf_tc_cls_get_info is a helper that can be used to obtain attributes
> > for the filter and classififer. The opts structure may be used to
> > choose the granularity of search, such that info for a specific filter
> > corresponding to the same loaded bpf program can be obtained. By
> > default, the first match is returned to the user.
> >
> > Examples:
> >
> > 	struct bpf_tc_cls_attach_id id = {};
> > 	struct bpf_object *obj;
> > 	struct bpf_program *p;
> > 	int fd, r;
> >
> > 	obj = bpf_object_open("foo.o");
> > 	if (IS_ERR_OR_NULL(obj))
> > 		return PTR_ERR(obj);
> >
> > 	p = bpf_object__find_program_by_title(obj, "classifier");
> > 	if (IS_ERR_OR_NULL(p))
> > 		return PTR_ERR(p);
> >
> > 	if (bpf_object__load(obj) < 0)
> > 		return -1;
> >
> > 	fd = bpf_program__fd(p);
> >
> > 	r = bpf_tc_cls_attach(fd, if_nametoindex("lo"),
> > 			      BPF_TC_CLSACT_INGRESS,
> > 			      NULL, &id);
> > 	if (r < 0)
> > 		return r;
> >
> > ... which is roughly equivalent to (after clsact qdisc setup):
> >    # tc filter add dev lo ingress bpf obj foo.o sec classifier da
> >
> > ... as direct action mode is always enabled.
> >
> > If a user wishes to modify existing options on an attached classifier,
> > bpf_tc_cls_change API may be used.
> >
> > Only parameters class_id can be modified, the rest are filled in to
> > identify the correct filter. protocol can be left out if it was not
> > chosen explicitly (defaulting to ETH_P_ALL).
> >
> > Example:
> >
> > 	/* Optional parameters necessary to select the right filter */
> > 	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
> > 			    .handle = id.handle,
> > 			    .priority = id.priority,
> > 			    .chain_index = id.chain_index)
>
> Why do we need chain_index as part of the basic API?
>

It would be relevant when TC_ACT_GOTO_CHAIN is used. Other than that, I guess
it's not very useful.

> > 	opts.class_id = TC_H_MAKE(1UL << 16, 12);
> > 	r = bpf_tc_cls_change(fd, if_nametoindex("lo"),
> > 			      BPF_TC_CLSACT_INGRESS,
> > 			      &opts, &id);
>
> Also, I'm not sure whether the prefix should even be named  bpf_tc_cls_*() tbh,
> yes, despite being "low level" api. I think in the context of bpf we should stop
> regarding this as 'classifier' and 'action' objects since it's really just a
> single entity and not separate ones. It's weird enough to explain this concept
> to new users and if a libbpf based api could cleanly abstract it, I would be all
> for it. I don't think we need to map 1:1 the old tc legacy even in the low level
> api, tbh, as it feels backwards. I think the 'handle' & 'priority' bits are okay,
> but I would remove the others.
>

Ok, would dropping _cls from the name be better?
bpf_tc_attach
bpf_tc_replace
bpf_tc_get_info
bpf_tc_detach

As for options, I'll drop protocol, if you feel strongly about chain_index I can
drop that one too.

> > 	if (r < 0)
> > 		return r;
> >
> > 	struct bpf_tc_cls_info info = {};
> > 	r = bpf_tc_cls_get_info(fd, if_nametoindex("lo"),
> > 			        BPF_TC_CLSACT_INGRESS,
> > 				&opts, &info);
> > 	if (r < 0)
> > 		return r;
> >
> > 	assert(info.class_id == TC_H_MAKE(1UL << 16, 12));
> >
> > This would be roughly equivalent to doing:
> >    # tc filter change dev lo egress prio <p> handle <h> bpf obj foo.o sec \
> >      classifier classid 1:12
>
> Why even bother to support !da mode, what are you trying to solve with it? I
> don't think official libbpf api should support something that doesn't scale.
>

da is default now, this is yet another typo/oversight...

--
Kartikeya
