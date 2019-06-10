Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A193B90D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404101AbfFJQKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:10:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37589 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404097AbfFJQKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:10:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so4743252pfa.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f7/rbL3Dk/NEUx3FX6rUib9IDqvOsMsi8C0Ft4QcvEo=;
        b=MwRC702lxTRBbj1UWnhFJIoldchFVYWRo3POpzh9O2sOlaQSzpC2Pd37raaD9WU2HR
         ilsjvGCrKEiFk9+ylj7IsdWjV7fFCiTXP6b/9fnGuojP0WuzPfgTke6+B8zSRLQ/VQoj
         e4wk4/CKne5syWQu3e5a79t+z+1Gy3LyRoM2VDrxQNGs1u5kk8+y0NmSUYb7tCdTrCyi
         hmxTPe8WM8TLEs13gn5+VBnYVDWysCtlku9lwukym9FEhYzXtQH7LK0bsYTvHQIv0TbF
         FJcPVzM6jdSEh3rvCMR3FX4EqOyk/XsCur01acv29QaM8lUofWV+irnNCcvyjGXeaoKR
         pxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f7/rbL3Dk/NEUx3FX6rUib9IDqvOsMsi8C0Ft4QcvEo=;
        b=E8ZSa1lqyWN4zLvSWFI2+E1EYI80Oh8dPxaak+bMIkTMkJGjZBQ3w5p/EHvWzmO6Op
         j+yng7rMtyzPacQwiRJtOuKSLB41ODTxXIZW7V7hk2HdZ3rg4hQ+rUKrCf/4aYFkH+6+
         GMjqv/05Hiy9lwMNxii6u1JmQQFZ8dIQg6KQgozCrU9Q6Oj+tRpr0ioZsnnJOHG4nUbh
         qv5NLE5hSFECZw5oU26Akie+ctk/AixXSFfvJr5GxaH8gdshM5jAgVp5Vwl2d7bHBD21
         GsV0rLK9sBJzLNhV3roX7eBoo5xOHkj7vl+PHn8QAHhP8bxGeC/OZDUdOi7MfAKTuHFr
         a2yA==
X-Gm-Message-State: APjAAAXFXZJ5dzD8R3tjWjpWytNW4wCmU7cNh65p8ii4LpvM3UbOYlm5
        tm/Z1E4HlhTvJsjwTN45EMXbVw==
X-Google-Smtp-Source: APXvYqz3lip0epi7tuFzRlTAVZMHxbp8l5QHIMTOHuWXUDy7ka7QHI57pNzqsBrOrdnK6/1ZNbTRVw==
X-Received: by 2002:a62:5387:: with SMTP id h129mr77219193pfb.6.1560183016833;
        Mon, 10 Jun 2019 09:10:16 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u23sm5810634pfn.140.2019.06.10.09.10.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:10:15 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:10:15 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 1/8] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190610161015.GF9660@mini-arch>
References: <20190607162920.24546-1-sdf@google.com>
 <20190607162920.24546-2-sdf@google.com>
 <20190608070838.4vhwss4anyibju53@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608070838.4vhwss4anyibju53@kafai-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08, Martin Lau wrote:
> On Fri, Jun 07, 2019 at 09:29:13AM -0700, Stanislav Fomichev wrote:
> > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > 
> > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > 
> > The buffer memory is pre-allocated (because I don't think there is
> > a precedent for working with __user memory from bpf). This might be
> > slow to do for each {s,g}etsockopt call, that's why I've added
> > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > attached to a cgroup. Note, however, that there is a race between
> > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > program layout might have changed; this should not be a problem
> > because in general there is a race between multiple calls to
> > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > 
> > The return code of the BPF program is handled as follows:
> > * 0: EPERM
> > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> >      prog exits
> > 
> > v3:
> > * typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
> > * reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
> >   Nakryiko)
> > * use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
> > * use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
> > * new CG_SOCKOPT_ACCESS macro to wrap repeated parts
> > 
> > v2:
> > * moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
> > * aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
> > * bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
> > * added [0,2] return code check to verifier (Martin Lau)
> > * dropped unused buf[64] from the stack (Martin Lau)
> > * use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
> > * dropped bpf_target_off from ctx rewrites (Martin Lau)
> > * use return code for kernel bypass (Martin Lau & Andrii Nakryiko)
> > 
> 
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 1b65ab0df457..4fc8429af6fc 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> 
> [ ... ]
> 
> > +static const struct bpf_func_proto *
> > +cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > +{
> > +	switch (func_id) {
> > +	case BPF_FUNC_sk_fullsock:
> > +		return &bpf_sk_fullsock_proto;
> May be my v2 comment has been missed.
> 
> sk here (i.e. PTR_TO_SOCKET) must be a fullsock.
> bpf_sk_fullsock() will be a no-op.  Hence, there is
> no need to expose bpf_sk_fullsock_proto.
I think I missed that fact that PTR_TO_SOCKET implies fullsock.
Will remove, thanks!

> > +	case BPF_FUNC_sk_storage_get:
> > +		return &bpf_sk_storage_get_proto;
> > +	case BPF_FUNC_sk_storage_delete:
> > +		return &bpf_sk_storage_delete_proto;
> > +#ifdef CONFIG_INET
> > +	case BPF_FUNC_tcp_sock:
> > +		return &bpf_tcp_sock_proto;
> > +#endif
> > +	default:
> > +		return cgroup_base_func_proto(func_id, prog);
> > +	}
> > +}
> > +
> > +static bool cg_sockopt_is_valid_access(int off, int size,
> > +				       enum bpf_access_type type,
> > +				       const struct bpf_prog *prog,
> > +				       struct bpf_insn_access_aux *info)
> > +{
> > +	const int size_default = sizeof(__u32);
> > +
> > +	if (off < 0 || off >= sizeof(struct bpf_sockopt))
> > +		return false;
> > +
> > +	if (off % size != 0)
> > +		return false;
> > +
> > +	if (type == BPF_WRITE) {
> > +		switch (off) {
> > +		case offsetof(struct bpf_sockopt, optlen):
> > +			if (size != size_default)
> > +				return false;
> > +			return prog->expected_attach_type ==
> > +				BPF_CGROUP_GETSOCKOPT;
> > +		default:
> > +			return false;
> > +		}
> > +	}
> > +
> > +	switch (off) {
> > +	case offsetof(struct bpf_sockopt, sk):
> > +		if (size != sizeof(struct bpf_sock *))
> Based on my understanding in commit b7df9ada9a77 ("bpf: fix pointer offsets in context for 32 bit"),
> I think it should be 'size != sizeof(__u64)'
> 
> Same for the optval and optval_end below.
Good point. I was actually wondering when converting BPF_W to BPF_DW in
the tests whether that would work correctly on 32 bits. Thanks for
commit pointer, that should, indeed, always be all sizeof(__u64).

> > +			return false;
> > +		info->reg_type = PTR_TO_SOCKET;
> > +		break;
> > +	case bpf_ctx_range(struct bpf_sockopt, optval):
> offsetof(struct bpf_sockopt, optval)
Ack. No narrow loads for the pointers.

> > +		if (size != sizeof(void *))
> > +			return false;
> > +		info->reg_type = PTR_TO_PACKET;
> > +		break;
> > +	case bpf_ctx_range(struct bpf_sockopt, optval_end):
> offsetof(struct bpf_sockopt, optval_end)
> 
> > +		if (size != sizeof(void *))
> > +			return false;
> > +		info->reg_type = PTR_TO_PACKET_END;
> > +		break;
> > +	default:
> > +		if (size != size_default)
> > +			return false;
> > +		break;
> > +	}
> > +	return true;
> > +}
> > +
> 
> [ ... ]
> 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 55bfc941d17a..4652c0a005ca 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -1835,7 +1835,7 @@ BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
> >  	return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
> >  }
> >  
> > -static const struct bpf_func_proto bpf_sk_fullsock_proto = {
> > +const struct bpf_func_proto bpf_sk_fullsock_proto = {
> As mentioned above, this change is also not needed.
> 
> Others LGTM.
Agreed, will not export.

> >  	.func		= bpf_sk_fullsock,
> >  	.gpl_only	= false,
> >  	.ret_type	= RET_PTR_TO_SOCKET_OR_NULL,
> > @@ -5636,7 +5636,7 @@ BPF_CALL_1(bpf_tcp_sock, struct sock *, sk)
> >  	return (unsigned long)NULL;
> >  }
> >  
