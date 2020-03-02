Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF417580C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 11:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBKNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 05:13:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgCBKNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 05:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583144001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xQwikwBMpya7Rap+jv/wKDfrlOydC/+igk3h4TDDp3w=;
        b=Gnjs+Hs55NUX9EJcaTw4ak+C+A/9pDHWsQ9AWb/d9uk/WoFsa2jwTH5YD7B7FdaKlOl7do
        oqowuDUch+FlxQTd6qW8pq/Xmz0giJ8UAEVPEtQqqpX/1s9Wx0op7Z7pHHbdjKl57PJW0N
        81X+UuP4NWYUfwf5Dfrdsv2g5Z1j9V0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-gWQvIDmpPnC3g5WpFEhBgw-1; Mon, 02 Mar 2020 05:13:20 -0500
X-MC-Unique: gWQvIDmpPnC3g5WpFEhBgw-1
Received: by mail-wr1-f69.google.com with SMTP id p5so5541364wrj.17
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 02:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xQwikwBMpya7Rap+jv/wKDfrlOydC/+igk3h4TDDp3w=;
        b=JLxLYps7cEx9nrFwgjmAcsxKjtClFZzwWorwvtf7nAOQnQ4Tf6SE44adFZDX3zSQO1
         CAxfZtknX7s412Php2+4b+7fuxqO1OrCTYIPwmalbIIhZTP8FsBIb0DIyYWoHR/ETV+C
         iAhkhO/2jJjZmb/PTzMkueM8v8CcTUpXqb1+wfPWjNt9ydj5B7++fpmjKny5qsHkB+FA
         grsh3SWSRKegG/4GvHls6aAqRGi1184mjL8o4yjNQpEP0g0VMo16zZ+KMfY8IsYNZGrR
         iVJAhtvjjpMs8PZhFlgcSbbSG1RYZzg8/dvg92alT2wVMETaQSDNqVB6k5+5yhjmH4nJ
         jiiw==
X-Gm-Message-State: ANhLgQ2HS9oxeD7b3L+kEjXwjrG1Grso5jIglQhYsniKpkbrc6kdGQSg
        ZL9890+xH+/KMhTCcpJaLP8MWklYNNcYdkhitab+WU3/Ex1EdIbNXUpUMMiOPDRD9vKM3IoxqsO
        eIqMoMidRHt29trz3
X-Received: by 2002:a7b:c081:: with SMTP id r1mr3164491wmh.12.1583143998947;
        Mon, 02 Mar 2020 02:13:18 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtuL5bb+cbqUVwT7v2TIB5Jmy0VpbwNI/Rg6JIrPj1Pff4dq4R4L93v0D0x4d+PuNzT4rDCNw==
X-Received: by 2002:a7b:c081:: with SMTP id r1mr3164467wmh.12.1583143998701;
        Mon, 02 Mar 2020 02:13:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u17sm1599162wrq.74.2020.03.02.02.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:13:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C3A8180362; Mon,  2 Mar 2020 11:13:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
In-Reply-To: <20200228223948.360936-2-andriin@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-2-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 11:13:17 +0100
Message-ID: <87k143t682.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Introduce bpf_link abstraction, representing an attachment of BPF program to
> a BPF hook point (e.g., tracepoint, perf event, etc). bpf_link encapsulates
> ownership of attached BPF program, reference counting of a link itself, when
> reference from multiple anonymous inodes, as well as ensures that release
> callback will be called from a process context, so that users can safely take
> mutex locks and sleep.
>
> Additionally, with a new abstraction it's now possible to generalize pinning
> of a link object in BPF FS, allowing to explicitly prevent BPF program
> detachment on process exit by pinning it in a BPF FS and let it open from
> independent other process to keep working with it.
>
> Convert two existing bpf_link-like objects (raw tracepoint and tracing BPF
> program attachments) into utilizing bpf_link framework, making them pinnable
> in BPF FS. More FD-based bpf_links will be added in follow up patches.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h  |  13 +++
>  kernel/bpf/inode.c   |  42 ++++++++-
>  kernel/bpf/syscall.c | 209 ++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 226 insertions(+), 38 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6015a4daf118..f13c78c6f29d 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1056,6 +1056,19 @@ extern int sysctl_unprivileged_bpf_disabled;
>  int bpf_map_new_fd(struct bpf_map *map, int flags);
>  int bpf_prog_new_fd(struct bpf_prog *prog);
>  
> +struct bpf_link;
> +
> +struct bpf_link_ops {
> +	void (*release)(struct bpf_link *link);
> +};
> +
> +void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
> +		   struct bpf_prog *prog);
> +void bpf_link_inc(struct bpf_link *link);
> +void bpf_link_put(struct bpf_link *link);
> +int bpf_link_new_fd(struct bpf_link *link);
> +struct bpf_link *bpf_link_get_from_fd(u32 ufd);
> +
>  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>  int bpf_obj_get_user(const char __user *pathname, int flags);
>  
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 5e40e7fccc21..95087d9f4ed3 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -25,6 +25,7 @@ enum bpf_type {
>  	BPF_TYPE_UNSPEC	= 0,
>  	BPF_TYPE_PROG,
>  	BPF_TYPE_MAP,
> +	BPF_TYPE_LINK,
>  };
>  
>  static void *bpf_any_get(void *raw, enum bpf_type type)
> @@ -36,6 +37,9 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
>  	case BPF_TYPE_MAP:
>  		bpf_map_inc_with_uref(raw);
>  		break;
> +	case BPF_TYPE_LINK:
> +		bpf_link_inc(raw);
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		break;
> @@ -53,6 +57,9 @@ static void bpf_any_put(void *raw, enum bpf_type type)
>  	case BPF_TYPE_MAP:
>  		bpf_map_put_with_uref(raw);
>  		break;
> +	case BPF_TYPE_LINK:
> +		bpf_link_put(raw);
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		break;
> @@ -63,20 +70,32 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
>  {
>  	void *raw;
>  
> -	*type = BPF_TYPE_MAP;
>  	raw = bpf_map_get_with_uref(ufd);
> -	if (IS_ERR(raw)) {
> +	if (!IS_ERR(raw)) {
> +		*type = BPF_TYPE_MAP;
> +		return raw;
> +	}
> +
> +	raw = bpf_prog_get(ufd);
> +	if (!IS_ERR(raw)) {
>  		*type = BPF_TYPE_PROG;
> -		raw = bpf_prog_get(ufd);
> +		return raw;
>  	}
>  
> -	return raw;
> +	raw = bpf_link_get_from_fd(ufd);
> +	if (!IS_ERR(raw)) {
> +		*type = BPF_TYPE_LINK;
> +		return raw;
> +	}
> +
> +	return ERR_PTR(-EINVAL);
>  }
>  
>  static const struct inode_operations bpf_dir_iops;
>  
>  static const struct inode_operations bpf_prog_iops = { };
>  static const struct inode_operations bpf_map_iops  = { };
> +static const struct inode_operations bpf_link_iops  = { };
>  
>  static struct inode *bpf_get_inode(struct super_block *sb,
>  				   const struct inode *dir,
> @@ -114,6 +133,8 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
>  		*type = BPF_TYPE_PROG;
>  	else if (inode->i_op == &bpf_map_iops)
>  		*type = BPF_TYPE_MAP;
> +	else if (inode->i_op == &bpf_link_iops)
> +		*type = BPF_TYPE_LINK;
>  	else
>  		return -EACCES;
>  
> @@ -335,6 +356,12 @@ static int bpf_mkmap(struct dentry *dentry, umode_t mode, void *arg)
>  			     &bpffs_map_fops : &bpffs_obj_fops);
>  }
>  
> +static int bpf_mklink(struct dentry *dentry, umode_t mode, void *arg)
> +{
> +	return bpf_mkobj_ops(dentry, mode, arg, &bpf_link_iops,
> +			     &bpffs_obj_fops);
> +}
> +
>  static struct dentry *
>  bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
>  {
> @@ -411,6 +438,9 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>  	case BPF_TYPE_MAP:
>  		ret = vfs_mkobj(dentry, mode, bpf_mkmap, raw);
>  		break;
> +	case BPF_TYPE_LINK:
> +		ret = vfs_mkobj(dentry, mode, bpf_mklink, raw);
> +		break;
>  	default:
>  		ret = -EPERM;
>  	}
> @@ -487,6 +517,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
>  		ret = bpf_prog_new_fd(raw);
>  	else if (type == BPF_TYPE_MAP)
>  		ret = bpf_map_new_fd(raw, f_flags);
> +	else if (type == BPF_TYPE_LINK)
> +		ret = bpf_link_new_fd(raw);
>  	else
>  		return -ENOENT;
>  
> @@ -504,6 +536,8 @@ static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type
>  
>  	if (inode->i_op == &bpf_map_iops)
>  		return ERR_PTR(-EINVAL);
> +	if (inode->i_op == &bpf_link_iops)
> +		return ERR_PTR(-EINVAL);
>  	if (inode->i_op != &bpf_prog_iops)
>  		return ERR_PTR(-EACCES);
>  
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index c536c65256ad..fca8de7e7872 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2173,23 +2173,153 @@ static int bpf_obj_get(const union bpf_attr *attr)
>  				attr->file_flags);
>  }
>  
> -static int bpf_tracing_prog_release(struct inode *inode, struct file *filp)
> +struct bpf_link {
> +	atomic64_t refcnt;

refcount_t ?

-Toke

