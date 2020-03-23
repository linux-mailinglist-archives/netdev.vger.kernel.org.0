Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE9718F33A
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgCWK6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:58:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34973 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727949AbgCWK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584961089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYX0qxq13HUZ4IuB5wsyhYr6h8o8qNgAnKt1PqEKQuM=;
        b=K62vs7YoDjY3TvqpZzKlrGAEtG28Guh7xf/f3sWMoxYuBRRBl4pjF+iA52U70fKsV2meZn
        HRgsmO8RmftgOt3G61h471sJoYkVY1jP2J1sYV4MCHekuz8VwgjQhFXZo+0/bilvXnp1tO
        aVjr6eBTV+dfdIQaK3yh+34NOqIpknA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-Fm8hXubYMN-t9XZ337EpEQ-1; Mon, 23 Mar 2020 06:58:07 -0400
X-MC-Unique: Fm8hXubYMN-t9XZ337EpEQ-1
Received: by mail-wr1-f70.google.com with SMTP id o18so3784497wrx.9
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KYX0qxq13HUZ4IuB5wsyhYr6h8o8qNgAnKt1PqEKQuM=;
        b=eS68za5E/dNW6B1dtg2eeQjnqXklPEg1Hmq2knHEZW+Sp++mVTKDDrWIpciVsAspbZ
         ulTdpWBYB9329k+Qqx+8Czlr9+fgVa1xP6NISeC9CHTmdHTkuAVgwHmJiRmCpkp3pJke
         lkIMxgx1LQ0iimoCobTD8yJWDfzjX5S9pz1bzkMxyoIGYCPOmA5oWGeM7rpfBAOVVkLa
         IDSINQCd3eMl3Wz0MboEY8ICn5j7uAKGLRCTFnQ1oNwkA/+i5vmwElw68bSa4LHi/owW
         4EkHKDTmQRrh0KeibWBFy2KxynHDU6VaZM4GDt0vmmoCvvoQ8u0U7DWeBtmfolMSd41z
         K5cQ==
X-Gm-Message-State: ANhLgQ2//TqAiEHaTu3Jd05HgvCVULP1SxCPmc4R0KTOI5V7tz1xfsEm
        m7+e7DH+NFJIAAy0wwxvUj2kUZeTWvn/ZrcIS6mXoShWqTk27oLSKn4RLdy2JRLN3DMSgWTf3XS
        T1LLsqYgqSzdGCUA/
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr26305735wmk.48.1584961086761;
        Mon, 23 Mar 2020 03:58:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtPZOuKyxDgupl/k3sDuMgs7OH4AAg2MxKq0Ggs5vPxYs4dliIgB9Wv1w7LVlkZehVrSjESCw==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr26305702wmk.48.1584961086461;
        Mon, 23 Mar 2020 03:58:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f9sm23227499wrc.71.2020.03.23.03.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:58:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D4D2180371; Mon, 23 Mar 2020 11:58:05 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an active bpf_cgroup_link
In-Reply-To: <20200320203615.1519013-5-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-5-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 11:58:05 +0100
Message-ID: <87zhc749tu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add new operation (LINK_UPDATE), which allows to replace active bpf_prog from
> under given bpf_link. Currently this is only supported for bpf_cgroup_link,
> but will be extended to other kinds of bpf_links in follow-up patches.
>
> For bpf_cgroup_link, implemented functionality matches existing semantics for
> direct bpf_prog attachment (including BPF_F_REPLACE flag). User can either
> unconditionally set new bpf_prog regardless of which bpf_prog is currently
> active under given bpf_link, or, optionally, can specify expected active
> bpf_prog. If active bpf_prog doesn't match expected one, operation is a noop
> and returns a failure.

Nit: I'd consider a 'noop' to be something that succeeds, so that last
sentence is a contradiction. Maybe "If active bpf_prog doesn't match
expected one, the kernel will abort the operation and return a failure."?

> cgroup_bpf_replace() operation is resolving race between auto-detachment and
> bpf_prog update in the same fashion as it's done for bpf_link detachment,
> except in this case update has no way of succeeding because of target cgroup
> marked as dying. So in this case error is returned.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf-cgroup.h |  4 ++
>  include/uapi/linux/bpf.h   | 12 ++++++
>  kernel/bpf/cgroup.c        | 77 ++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c       | 60 +++++++++++++++++++++++++++++
>  kernel/cgroup/cgroup.c     | 21 +++++++++++
>  5 files changed, 174 insertions(+)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index ab95824a1d99..5735d8bfd69e 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -98,6 +98,8 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
>  int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  			struct bpf_cgroup_link *link,
>  			enum bpf_attach_type type);
> +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> +			 struct bpf_prog *new_prog);
>  int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  		       union bpf_attr __user *uattr);
>  
> @@ -108,6 +110,8 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
>  		      u32 flags);
>  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  		      enum bpf_attach_type type);
> +int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> +		       struct bpf_prog *old_prog, struct bpf_prog *new_prog);
>  int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  		     union bpf_attr __user *uattr);
>  
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fad9f79bb8f1..fa944093f9fc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -112,6 +112,7 @@ enum bpf_cmd {
>  	BPF_MAP_UPDATE_BATCH,
>  	BPF_MAP_DELETE_BATCH,
>  	BPF_LINK_CREATE,
> +	BPF_LINK_UPDATE,
>  };

I feel like there's a BPF_LINK_QUERY operation missing here? Otherwise,
how is userspace supposed to discover which program is currently
attached to a link?

>  enum bpf_map_type {
> @@ -574,6 +575,17 @@ union bpf_attr {
>  		__u32		target_fd;	/* object to attach to */
>  		__u32		attach_type;	/* attach type */
>  	} link_create;
> +
> +	struct { /* struct used by BPF_LINK_UPDATE command */
> +		__u32		link_fd;	/* link fd */
> +		/* new program fd to update link with */
> +		__u32		new_prog_fd;
> +		__u32		flags;		/* extra flags */
> +		/* expected link's program fd; is specified only if
> +		 * BPF_F_REPLACE flag is set in flags */
> +		__u32		old_prog_fd;
> +	} link_update;
> +
>  } __attribute__((aligned(8)));
>  
>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index b960e8633f23..b9f4971336f3 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -501,6 +501,83 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	return err;
>  }
>  
> +/* Swap updated BPF program for given link in effective program arrays across
> + * all descendant cgroups. This function is guaranteed to succeed.
> + */
> +static void replace_effective_prog(struct cgroup *cgrp,
> +				   enum bpf_attach_type type,
> +				   struct bpf_cgroup_link *link)
> +{
> +	struct bpf_prog_array_item *item;
> +	struct cgroup_subsys_state *css;
> +	struct bpf_prog_array *progs;
> +	struct bpf_prog_list *pl;
> +	struct list_head *head;
> +	struct cgroup *cg;
> +	int pos;
> +
> +	css_for_each_descendant_pre(css, &cgrp->self) {
> +		struct cgroup *desc = container_of(css, struct cgroup, self);
> +
> +		if (percpu_ref_is_zero(&desc->bpf.refcnt))
> +			continue;
> +
> +		/* found position of link in effective progs array */
> +		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> +			if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
> +				continue;
> +
> +			head = &cg->bpf.progs[type];
> +			list_for_each_entry(pl, head, node) {
> +				if (!prog_list_prog(pl))
> +					continue;
> +				if (pl->link == link)
> +					goto found;
> +				pos++;
> +			}
> +		}
> +found:
> +		BUG_ON(!cg);
> +		progs = rcu_dereference_protected(
> +				desc->bpf.effective[type],
> +				lockdep_is_held(&cgroup_mutex));
> +		item = &progs->items[pos];
> +		WRITE_ONCE(item->prog, link->link.prog);
> +	}
> +}
> +
> +/**
> + * __cgroup_bpf_replace() - Replace link's program and propagate the change
> + *                          to descendants
> + * @cgrp: The cgroup which descendants to traverse
> + * @link: A link for which to replace BPF program
> + * @type: Type of attach operation
> + *
> + * Must be called with cgroup_mutex held.
> + */
> +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> +			 struct bpf_prog *new_prog)
> +{
> +	struct list_head *progs = &cgrp->bpf.progs[link->type];
> +	struct bpf_prog *old_prog;
> +	struct bpf_prog_list *pl;
> +	bool found = false;
> +
> +	list_for_each_entry(pl, progs, node) {
> +		if (pl->link == link) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		return -ENOENT;
> +
> +	old_prog = xchg(&link->link.prog, new_prog);
> +	replace_effective_prog(cgrp, link->type, link);
> +	bpf_prog_put(old_prog);
> +	return 0;
> +}
> +
>  static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
>  					       struct bpf_prog *prog,
>  					       struct bpf_cgroup_link *link,
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index f6e7d32a2632..1ff7aaa2c727 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3572,6 +3572,63 @@ static int link_create(union bpf_attr *attr)
>  	return ret;
>  }
>  
> +#define BPF_LINK_UPDATE_LAST_FIELD link_update.old_prog_fd
> +
> +static int link_update(union bpf_attr *attr)
> +{
> +	struct bpf_prog *old_prog = NULL, *new_prog;
> +	enum bpf_prog_type ptype;
> +	struct bpf_link *link;
> +	u32 flags;
> +	int ret;
> +
> +	if (CHECK_ATTR(BPF_LINK_UPDATE))
> +		return -EINVAL;
> +
> +	flags = attr->link_update.flags;
> +	if (flags & ~BPF_F_REPLACE)
> +		return -EINVAL;
> +
> +	link = bpf_link_get_from_fd(attr->link_update.link_fd);
> +	if (IS_ERR(link))
> +		return PTR_ERR(link);
> +
> +	new_prog = bpf_prog_get(attr->link_update.new_prog_fd);
> +	if (IS_ERR(new_prog))
> +		return PTR_ERR(new_prog);
> +
> +	if (flags & BPF_F_REPLACE) {
> +		old_prog = bpf_prog_get(attr->link_update.old_prog_fd);
> +		if (IS_ERR(old_prog)) {
> +			ret = PTR_ERR(old_prog);
> +			old_prog = NULL;
> +			goto out_put_progs;
> +		}
> +	}

Shouldn't the default be to require an old FD and do atomic update, but
provide a flag (BPF_F_CLOBBER?) to opt-in to unconditional replace
behaviour? Since the unconditional replace is inherently racy I don't
think it should be the default; in fact, I'm not sure if it should be
allowed at all?

> +	if (link->ops == &bpf_cgroup_link_lops) {
> +		struct bpf_cgroup_link *cg_link;
> +
> +		cg_link = container_of(link, struct bpf_cgroup_link, link);
> +		ptype = attach_type_to_prog_type(cg_link->type);
> +		if (ptype != new_prog->type) {
> +			ret = -EINVAL;
> +			goto out_put_progs;
> +		}
> +		ret = cgroup_bpf_replace(cg_link->cgroup, cg_link,
> +					 old_prog, new_prog);
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +out_put_progs:
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +	if (ret)
> +		bpf_prog_put(new_prog);
> +	return ret;
> +}
> +
>  SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>  {
>  	union bpf_attr attr = {};
> @@ -3685,6 +3742,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>  	case BPF_LINK_CREATE:
>  		err = link_create(&attr);
>  		break;
> +	case BPF_LINK_UPDATE:
> +		err = link_update(&attr);
> +		break;
>  	default:
>  		err = -EINVAL;
>  		break;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 219624fba9ba..d4787fccf183 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6317,6 +6317,27 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
>  	return ret;
>  }
>  
> +int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> +		       struct bpf_prog *old_prog, struct bpf_prog *new_prog)
> +{
> +	int ret;
> +
> +	mutex_lock(&cgroup_mutex);
> +	/* link might have been auto-released by dying cgroup, so fail */
> +	if (!link->cgroup) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	if (old_prog && link->link.prog != old_prog) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +	ret = __cgroup_bpf_replace(cgrp, link, new_prog);
> +out_unlock:
> +	mutex_unlock(&cgroup_mutex);
> +	return ret;
> +}
> +
>  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  		      enum bpf_attach_type type)
>  {
> -- 
> 2.17.1

