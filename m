Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBFD1E5DC9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 13:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbgE1LEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388322AbgE1LED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 07:04:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCDDC08C5C5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 04:04:03 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o15so10237673ejm.12
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 04:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=U5/ZVQD/gomPS6/QOL+Kh5/GopUQRPaFfd+gJ4AwcHs=;
        b=iOVacB1pmlHV7sAC07ZVMyUtuLT9ouYr1w4ZEZW9xYDJFg03khuIo364rcsZwelDtD
         fGK/+GPN6lz2MW1TPCVUkdt7K7GDVZNPUcYmSs+DiYnROLDqe0iV17WAGMnT4Q2z2007
         kb056wLg9mQmY9cIBD7BYtbURWn2Ppgx98DCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=U5/ZVQD/gomPS6/QOL+Kh5/GopUQRPaFfd+gJ4AwcHs=;
        b=RsLWsk8Py28vNuObOLlSshpGnjEc45QNS33HNNFTbSD8JTeOgxaf4A22aT1fNR1/R2
         z419aTf/yudJgm7Msfw1sOS/wqf/x3bf9XqVTlvG7nnbpH3EpifS3NNaK+AdoUOWjbB3
         6PzMbjL75EpFyZvvkHCZa7rLa9E/h5YfGeq3JtmbGb+AHbV0K8PDa8b8JoSkx6Et+RLl
         COYBcNQ03fnHH4hfanqSADcfFuTjmzhFfQiRElrOWRPiA+VFPMc1pdFpbvaqKTR+IDlf
         CKOArYFS/hMoeqqyurIjtANwvDVpkQVf2L/bwgwjd+dq+y+vLd1Amw5Qr3Tf5C1pgzSh
         /6Dg==
X-Gm-Message-State: AOAM533ur3utPgT88zIEYhojvB9nVk5XPxFRe9w3kuRypCOF9cboOpc9
        5QH1yzCvnNf8kQgGnOsxYG4kUA==
X-Google-Smtp-Source: ABdhPJzXYS8UjkCmYYpQeq7QgNp5vOi67PIgNADnN+B4pOiGXKBZX18oxge21LLY6fQXPxWzrL0+lQ==
X-Received: by 2002:a17:906:1f09:: with SMTP id w9mr2413964ejj.486.1590663841844;
        Thu, 28 May 2020 04:04:01 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id ce16sm5070977ejb.76.2020.05.28.04.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:04:00 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-6-jakub@cloudflare.com> <20200527205300.GC57268@google.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment to network namespace
In-reply-to: <20200527205300.GC57268@google.com>
Date:   Thu, 28 May 2020 13:03:59 +0200
Message-ID: <87r1v42ue8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 10:53 PM CEST, sdf@google.com wrote:
> On 05/27, Jakub Sitnicki wrote:
>> Add support for bpf() syscall subcommands that operate on
>> bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points tied to
>> network namespaces (that is flow dissector at the moment).
>
>> Link-based and prog-based attachment can be used interchangeably, but only
>> one can be in use at a time. Attempts to attach a link when a prog is
>> already attached directly, and the other way around, will be met with
>> -EBUSY.
>
>> Attachment of multiple links of same attach type to one netns is not
>> supported, with the intention to lift it when a use-case presents
>> itself. Because of that attempts to create a netns link, when one already
>> exists result in -E2BIG error, signifying that there is no space left for
>> another attachment.
>
>> Link-based attachments to netns don't keep a netns alive by holding a ref
>> to it. Instead links get auto-detached from netns when the latter is being
>> destroyed by a pernet pre_exit callback.
>
>> When auto-detached, link lives in defunct state as long there are open FDs
>> for it. -ENOLINK is returned if a user tries to update a defunct link.
>
>> Because bpf_link to netns doesn't hold a ref to struct net, special care is
>> taken when releasing the link. The netns might be getting torn down when
>> the release function tries to access it to detach the link.
>
>> To ensure the struct net object is alive when release function accesses it
>> we rely on the fact that cleanup_net(), struct net destructor, calls
>> synchronize_rcu() after invoking pre_exit callbacks. If auto-detach from
>> pre_exit happens first, link release will not attempt to access struct net.
>
>> Same applies the other way around, network namespace doesn't keep an
>> attached link alive because by not holding a ref to it. Instead bpf_links
>> to netns are RCU-freed, so that pernet pre_exit callback can safely access
>> and auto-detach the link when racing with link release/free.
>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>   include/linux/bpf-netns.h      |   8 +
>>   include/net/netns/bpf.h        |   1 +
>>   include/uapi/linux/bpf.h       |   5 +
>>   kernel/bpf/net_namespace.c     | 257 ++++++++++++++++++++++++++++++++-
>>   kernel/bpf/syscall.c           |   3 +
>>   net/core/filter.c              |   1 +
>>   tools/include/uapi/linux/bpf.h |   5 +
>>   7 files changed, 278 insertions(+), 2 deletions(-)
>
>> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
>> index f3aec3d79824..4052d649f36d 100644
>> --- a/include/linux/bpf-netns.h
>> +++ b/include/linux/bpf-netns.h
>> @@ -34,6 +34,8 @@ int netns_bpf_prog_query(const union bpf_attr *attr,
>>   int netns_bpf_prog_attach(const union bpf_attr *attr,
>>   			  struct bpf_prog *prog);
>>   int netns_bpf_prog_detach(const union bpf_attr *attr);
>> +int netns_bpf_link_create(const union bpf_attr *attr,
>> +			  struct bpf_prog *prog);
>>   #else
>>   static inline int netns_bpf_prog_query(const union bpf_attr *attr,
>>   				       union bpf_attr __user *uattr)
>> @@ -51,6 +53,12 @@ static inline int netns_bpf_prog_detach(const union
>> bpf_attr *attr)
>>   {
>>   	return -EOPNOTSUPP;
>>   }
>> +
>> +static inline int netns_bpf_link_create(const union bpf_attr *attr,
>> +					struct bpf_prog *prog)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>>   #endif
>
>>   #endif /* _BPF_NETNS_H */
>> diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
>> index a858d1c5b166..baabefdeb10c 100644
>> --- a/include/net/netns/bpf.h
>> +++ b/include/net/netns/bpf.h
>> @@ -12,6 +12,7 @@ struct bpf_prog;
>
>>   struct netns_bpf {
>>   	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
>> +	struct bpf_link __rcu *links[MAX_NETNS_BPF_ATTACH_TYPE];
>>   };
>
>>   #endif /* __NETNS_BPF_H__ */
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 54b93f8b49b8..05469d3c5c82 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -235,6 +235,7 @@ enum bpf_link_type {
>>   	BPF_LINK_TYPE_TRACING = 2,
>>   	BPF_LINK_TYPE_CGROUP = 3,
>>   	BPF_LINK_TYPE_ITER = 4,
>> +	BPF_LINK_TYPE_NETNS = 5,
>
>>   	MAX_BPF_LINK_TYPE,
>>   };
>> @@ -3753,6 +3754,10 @@ struct bpf_link_info {
>>   			__u64 cgroup_id;
>>   			__u32 attach_type;
>>   		} cgroup;
>> +		struct  {
>> +			__u32 netns_ino;
>> +			__u32 attach_type;
>> +		} netns;
>>   	};
>>   } __attribute__((aligned(8)));
>
>> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
>> index fc89154aed27..1c6009ab93c5 100644
>> --- a/kernel/bpf/net_namespace.c
>> +++ b/kernel/bpf/net_namespace.c
>> @@ -8,9 +8,155 @@
>>    * Functions to manage BPF programs attached to netns
>>    */
>
>> -/* Protects updates to netns_bpf */
>> +struct bpf_netns_link {
>> +	struct bpf_link	link;
>> +	enum bpf_attach_type type;
>> +	enum netns_bpf_attach_type netns_type;
>> +
>> +	/* struct net is not RCU-freed but we treat it as such because
>> +	 * our pre_exit callback will NULL this pointer before
>> +	 * cleanup_net() calls synchronize_rcu().
>> +	 */
>> +	struct net __rcu *net;
>> +
>> +	/* bpf_netns_link is RCU-freed for pre_exit callback invoked
>> +	 * by cleanup_net() to safely access the link.
>> +	 */
>> +	struct rcu_head	rcu;
>> +};
>> +
>> +/* Protects updates to netns_bpf. */
>>   DEFINE_MUTEX(netns_bpf_mutex);
>
>> +static inline struct bpf_netns_link *to_bpf_netns_link(struct bpf_link *link)
>> +{
>> +	return container_of(link, struct bpf_netns_link, link);
>> +}
>> +
>> +/* Called with RCU read lock. */
> As mentioned earlier, ^^^ probably doesn't make sense. Try to avoid
> RCU_INIT_POINTER under read lock.

Agree. As mentione in my earlier response, I will rework it so the only
thing that happens inside RCU read-side critical section is an attempt
to bump a ref count on the object.

Pointer flipping will be done outside of RCU read locks, with mutex held
when there are multiple writers.

>
>> +static void __net_exit
>> +bpf_netns_link_auto_detach(struct net *net, enum netns_bpf_attach_type type)
>> +{
>> +	struct bpf_netns_link *net_link;
>> +	struct bpf_link *link;
>> +
>> +	link = rcu_dereference(net->bpf.links[type]);
> Btw, maybe use rcu_deref_protected with !check_net here and drop
> rcu read lock requirement?

In the current synchronization design !check_net wouldn't hold.

bpf_netns_link_{release,update_prog} need to update nete->bpf.links,
while not holding a ref count on struct net.

>
>> +	if (!link)
>> +		return;
>> +	net_link = to_bpf_netns_link(link);
>> +	RCU_INIT_POINTER(net_link->net, NULL);
>> +}
>> +
>> +static void bpf_netns_link_release(struct bpf_link *link)
>> +{
>> +	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
>> +	enum netns_bpf_attach_type type = net_link->netns_type;
>> +	struct net *net;
>> +
>> +	/* Link auto-detached by dying netns. */
>> +	if (!rcu_access_pointer(net_link->net))
>> +		return;
>> +
>> +	mutex_lock(&netns_bpf_mutex);
>> +
>> +	/* Recheck after potential sleep. We can race with cleanup_net
>> +	 * here, but if we see a non-NULL struct net pointer pre_exit
>> +	 * and following synchronize_rcu() has not happened yet, and
>> +	 * we have until the end of grace period to access net.
>> +	 */
>> +	rcu_read_lock();
>> +	net = rcu_dereference(net_link->net);
> Use rcu_dereferece_protected with netns_bpf_mutex here instead of
> grabbing rcu read lock? Or are you guarding here against 'net'
> going away? In that case, moving unlock higher can make it more
> visually clear.

RCU read lock is to guard against 'net' going away.

While netns_bpf_mutex serializes access to net->bpf.progs. Concurrent
updates are possible from bpf_netns_link_release and
netns_bpf_prog_{attach,detach}.

I agree that having an RCU read-side critical section embedded in
another critical section protected by a mutex is not visually clear.

>
>> +	if (net) {
>> +		RCU_INIT_POINTER(net->bpf.links[type], NULL);
>> +		RCU_INIT_POINTER(net->bpf.progs[type], NULL);
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	mutex_unlock(&netns_bpf_mutex);
>> +}
>> +
>> +static void bpf_netns_link_dealloc(struct bpf_link *link)
>> +{
>> +	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
>> +
>> +	/* Delay kfree in case we're racing with cleanup_net. */
>> +	kfree_rcu(net_link, rcu);
>> +}
>> +
>> +static int bpf_netns_link_update_prog(struct bpf_link *link,
>> +				      struct bpf_prog *new_prog,
>> +				      struct bpf_prog *old_prog)
>> +{
>> +	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
>> +	struct net *net;
>> +	int ret = 0;
>> +
>> +	if (old_prog && old_prog != link->prog)
>> +		return -EPERM;
>> +	if (new_prog->type != link->prog->type)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&netns_bpf_mutex);
>> +	rcu_read_lock();
> Again, what are you protecting here? 'net' disappearing? Then maybe do:
>
> 	rcu_read_lock
> 	net = rcu_deref
> 	valid = net && check_net(net)
> 	rcu_read_unlock
>
> 	if (!valid)
> 		bail out.
>
> Otherwise, those mutex_lock+rcu_read_lock are a bit confusing.

Great idea, thanks. This is almost the same as what I was thinking
about. The only difference being that I want to also get ref to net, so
it doesn't go away while we continue outside of RCU read-side critical
section.

>
>> +
>> +	net = rcu_dereference(net_link->net);
>> +	if (!net || !check_net(net)) {
>> +		/* Link auto-detached or netns dying */
>> +		ret = -ENOLINK;
>> +		goto out_unlock;
>> +	}
>> +
>> +	old_prog = xchg(&link->prog, new_prog);
>> +	bpf_prog_put(old_prog);
>> +
>> +out_unlock:
>> +	rcu_read_unlock();
>> +	mutex_unlock(&netns_bpf_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static int bpf_netns_link_fill_info(const struct bpf_link *link,
>> +				    struct bpf_link_info *info)
>> +{
>> +	const struct bpf_netns_link *net_link;
>> +	unsigned int inum;
>> +	struct net *net;
>> +
>> +	net_link = container_of(link, struct bpf_netns_link, link);
>> +
>> +	rcu_read_lock();
>> +	net = rcu_dereference(net_link->net);
>> +	if (net)
>> +		inum = net->ns.inum;
>> +	rcu_read_unlock();
>> +
>> +	info->netns.netns_ino = inum;
>> +	info->netns.attach_type = net_link->type;
>> +	return 0;
>> +}
>> +
>> +static void bpf_netns_link_show_fdinfo(const struct bpf_link *link,
>> +				       struct seq_file *seq)
>> +{
>> +	struct bpf_link_info info = {};
>> +
>> +	bpf_netns_link_fill_info(link, &info);
>> +	seq_printf(seq,
>> +		   "netns_ino:\t%u\n"
>> +		   "attach_type:\t%u\n",
>> +		   info.netns.netns_ino,
>> +		   info.netns.attach_type);
>> +}
>> +
>> +static const struct bpf_link_ops bpf_netns_link_ops = {
>> +	.release = bpf_netns_link_release,
>> +	.dealloc = bpf_netns_link_dealloc,
>> +	.update_prog = bpf_netns_link_update_prog,
>> +	.fill_link_info = bpf_netns_link_fill_info,
>> +	.show_fdinfo = bpf_netns_link_show_fdinfo,
>> +};
>> +
>>   int netns_bpf_prog_query(const union bpf_attr *attr,
>>   			 union bpf_attr __user *uattr)
>>   {
>> @@ -67,6 +213,13 @@ int netns_bpf_prog_attach(const union bpf_attr *attr,
>> struct bpf_prog *prog)
>
>>   	net = current->nsproxy->net_ns;
>>   	mutex_lock(&netns_bpf_mutex);
>> +
>> +	/* Attaching prog directly is not compatible with links */
>> +	if (rcu_access_pointer(net->bpf.links[type])) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>>   	switch (type) {
>>   	case NETNS_BPF_FLOW_DISSECTOR:
>>   		ret = flow_dissector_bpf_prog_attach(net, prog);
>> @@ -75,6 +228,7 @@ int netns_bpf_prog_attach(const union bpf_attr *attr,
>> struct bpf_prog *prog)
>>   		ret = -EINVAL;
>>   		break;
>>   	}
>> +unlock:
>>   	mutex_unlock(&netns_bpf_mutex);
>
>>   	return ret;
>> @@ -85,6 +239,10 @@ static int __netns_bpf_prog_detach(struct net *net,
>>   {
>>   	struct bpf_prog *attached;
>
>> +	/* Progs attached via links cannot be detached */
>> +	if (rcu_access_pointer(net->bpf.links[type]))
>> +		return -EBUSY;
>> +
>>   	/* No need for update-side lock when net is going away. */
>>   	attached = rcu_dereference_protected(net->bpf.progs[type],
>>   					     !check_net(net) ||
>> @@ -112,14 +270,109 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
>>   	return ret;
>>   }
>
>> +static int __netns_bpf_link_attach(struct net *net, struct bpf_link *link,
>> +				   enum netns_bpf_attach_type type)
>> +{
>> +	int err;
>> +
>> +	/* Allow attaching only one prog or link for now */
>> +	if (rcu_access_pointer(net->bpf.links[type]))
>> +		return -E2BIG;
>> +	/* Links are not compatible with attaching prog directly */
>> +	if (rcu_access_pointer(net->bpf.progs[type]))
>> +		return -EBUSY;
>> +
>> +	switch (type) {
>> +	case NETNS_BPF_FLOW_DISSECTOR:
>> +		err = flow_dissector_bpf_prog_attach(net, link->prog);
>> +		break;
>> +	default:
>> +		err = -EINVAL;
>> +		break;
>> +	}
>> +	if (!err)
>> +		rcu_assign_pointer(net->bpf.links[type], link);
>> +	return err;
>> +}
>> +
>> +static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
>> +				 enum netns_bpf_attach_type type)
>> +{
>> +	int ret;
>> +
>> +	mutex_lock(&netns_bpf_mutex);
>> +	ret = __netns_bpf_link_attach(net, link, type);
> What's the point of separating __netns_bpf_link_attach out?
> Does it make sense to replace those rcu_access_pointer's in
> __netns_bpf_link_attach with rcu_deref_protected and put everything here?
> This makes it a bit easier to reason about.

I've structured it like that just to avoid goto jumps to mutex_unlock on
error. No strong feelings that it must be like that.

You're right about rcu_deref_protected(), rcu_access_pointer() docs are
explicit about it:

/**
 * rcu_access_pointer() - fetch RCU pointer with no dereferencing
 * @p: The pointer to read
...

 * Return the value of the specified RCU-protected pointer, but omit the
 * lockdep checks for being in an RCU read-side critical section.  This is
 * useful when the value of this pointer is accessed, but the pointer is
 * not dereferenced, for example, when testing an RCU-protected pointer
 * against NULL.  Although rcu_access_pointer() may also be used in cases
 * where update-side locks prevent the value of the pointer from changing,
 * you should instead use rcu_dereference_protected() for this use case.
...
 */

My mistake. Will switch to rcu_deref_protected in v2.


Thanks again for feedback.

-jkbs

[...]
