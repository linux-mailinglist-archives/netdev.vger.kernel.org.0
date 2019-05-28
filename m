Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77812D027
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfE1UQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:16:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34313 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfE1UQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:16:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id h2so8583604pgg.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RNQhxNd+JROXqrODcuLDxysNcH9HqprmNQdZcO4o1NA=;
        b=wjx/J+qQgUbekMBlDjua6slv8T/9Tap3q3hSAIm/TOpMIHaf9ataIWiL4jF5JbU57q
         KvkfpKcXAmOvY6jiDMK7gmLgQDFwtBbw7qx/a1PvCy+qcnbmNHHvv0jeccuzvVo2aXGM
         sJFthIClO1Y+5h1HoFqMpu8/rY/ADmIyhsyfpxIG/mkJmdakpwrEvq1iK4Cc6gMGOqDp
         FpSZw04wCDWXyMrdxPpitnpaWdU6KEHd0NkKPDXQwT0f3u4SG3T49/EqOiTsTs8ARCvT
         BXEWURrbgASWnbudPNZ4xYJxRCSifaR0tCGHfGnajAR60EdJ0ptAH+uVvzk1QjqJ5g+1
         ollg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RNQhxNd+JROXqrODcuLDxysNcH9HqprmNQdZcO4o1NA=;
        b=AuRrohNuUEiVuxXfUYfjwWvaw1CItmpbjrJ2uoTrkIb93NCeW1w+6rR9aDV030wzBO
         i8va/TTdsRZn7h2IVwEWeaxQrjRqO/yTtV2qdQmWbS0cEwOBi1P8xMGhuzbD8/dwDwC6
         BkcU4b5TtxmK/tMEtw9DGbEWcbNWs3ITk7Rzcvqdp9l4R7Ay1MA/f+WfF1s85FC4ytEn
         v7wc7pR7ohTeX8ekBJMzgynFZrIYyepQwZIywAPM3wZ4dnh0rT5Y6Ac8c1o3dFGrZlyh
         4Hb4I5lA48tqsmBhiKyTw2bEDEl5xVhCw7iuAeOPvUfmLonEmS0diF6zIGRbZ1FRpZ/n
         TKjw==
X-Gm-Message-State: APjAAAVWYiuWXZWpGfrfDIzailYMbM/ohttnem2bPjIc28dG+oPVHcp/
        Leo4OYc08QAb0iO7EqmjnFKjrw==
X-Google-Smtp-Source: APXvYqzjlP4Ch8Xpbp+7iEhIv9VBjMyntOpLn5/pHv4O2SX44nECftrB2AdEjLwyFwqf4nhd9mZDzg==
X-Received: by 2002:a62:386:: with SMTP id 128mr121373658pfd.10.1559074608423;
        Tue, 28 May 2019 13:16:48 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id k3sm3231587pju.27.2019.05.28.13.16.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 13:16:47 -0700 (PDT)
Date:   Tue, 28 May 2019 13:16:46 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Roman Gushchin <guro@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Message-ID: <20190528201646.GE3032@mini-arch>
References: <20190528182946.3633-1-sdf@google.com>
 <20190528182946.3633-3-sdf@google.com>
 <20190528194342.GC20578@tower.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528194342.GC20578@tower.DHCP.thefacebook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/28, Roman Gushchin wrote:
> On Tue, May 28, 2019 at 11:29:45AM -0700, Stanislav Fomichev wrote:
> > Now that we don't have __rcu markers on the bpf_prog_array helpers,
> > let's use proper rcu_dereference_protected to obtain array pointer
> > under mutex.
> > 
> > We also don't need __rcu annotations on cgroup_bpf.inactive since
> > it's not read/updated concurrently.
> > 
> > v3:
> > * amend cgroup_rcu_dereference to include percpu_ref_is_dying;
> >   cgroup_bpf is now reference counted and we don't hold cgroup_mutex
> >   anymore in cgroup_bpf_release
> > 
> > v2:
> > * replace xchg with rcu_swap_protected
> > 
> > Cc: Roman Gushchin <guro@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup.h |  2 +-
> >  kernel/bpf/cgroup.c        | 32 +++++++++++++++++++++-----------
> >  2 files changed, 22 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index 9f100fc422c3..b631ee75762d 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -72,7 +72,7 @@ struct cgroup_bpf {
> >  	u32 flags[MAX_BPF_ATTACH_TYPE];
> >  
> >  	/* temp storage for effective prog array used by prog_attach/detach */
> > -	struct bpf_prog_array __rcu *inactive;
> > +	struct bpf_prog_array *inactive;
> >  
> >  	/* reference counter used to detach bpf programs after cgroup removal */
> >  	struct percpu_ref refcnt;
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index d995edbe816d..118b70175dd9 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -22,6 +22,13 @@
> >  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
> >  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> >  
> > +#define cgroup_rcu_dereference(cgrp, p)					\
> > +	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex) ||	\
> > +				  percpu_ref_is_dying(&cgrp->bpf.refcnt))
> 
> Some comments why percpu_ref_is_dying(&cgrp->bpf.refcnt) is enough here will
> be appreciated.
I was actually debating whether to just use raw
rcu_dereference_protected(p, lockdep_is_held()) in __cgroup_bpf_query and
rcu_dereference_protected(p, percpu_ref_is_dying()) in cgroup_bpf_release
instead of having a cgroup_rcu_dereference which covers both cases.

Maybe that should make it more clear (and doesn't require any comment)?
