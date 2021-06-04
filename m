Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2B539BF26
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 19:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFDR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDR4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 13:56:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E603FC061767;
        Fri,  4 Jun 2021 10:54:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l23-20020a17090a0717b029016ae774f973so5669939pjl.1;
        Fri, 04 Jun 2021 10:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=01y5NneuXQw40lmFbAzFmDqnYxSeLx36MZRmrGk1JLI=;
        b=cxt2Dks5H/GR9EVFvdhJx2a6Ft/DwAb6bkMdUXu4qPaZUKOi/9+PSwG6VmT1JLP9gS
         PWplWjjX7gkOJLoCXdpVZ3GzKp3RpWKksDodwJTH//7rnqwXC+M3md6jXof46Ad1KPN0
         lljPi/lN3UpmdaCvRkQsu9YgvOaH+fAmWU/NhfnQRgFH8LK73y1I5etjGZAG6tPt/wmY
         jdG23fL+t9S5dFmHY3b578L3wS+cxN4FkF4KmEFEnIZWsOjyQwFJvGOQHXCLdRJk1yJE
         ZeGhJHONGmhNhqLRKDwH5Rgo7U2Oi+9CaQRyk2ob+D5srCA+P2ZJ3f5KQGoq2zGWQCa7
         zu4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=01y5NneuXQw40lmFbAzFmDqnYxSeLx36MZRmrGk1JLI=;
        b=j8rQf150a2MJeT09MvmQKe+1mLhDY2J1nWVeyDqSniTs9iZHet1o37lg2s1LQyyEkB
         J51jta+BZp8f/rvNtx5BwxCshKPafFviptzeXsslVjLC6Y8cFKe3OMBHAdFmHUTO8g6f
         8oVtaiawxv3PVhY7frkid5bw4C5zQZaP4GUEZZjJ7COqaFe0KLaUn4k8T78hL0SawNxx
         4cy/z+2th7GHQuu0bB4EXuydkTUeJEfRUgpFyljmOyDTW3GW+yWgtf3aNZZeOadZs2AM
         2zjmeocPWIPCeuEXKBspVuCNPM5nSoukCBKP3D2wpuRqliR4TBhbJQJ0YiUUquv31+VI
         L+jg==
X-Gm-Message-State: AOAM532SpUYwvEHYn1Qht37Dd/p0MayTSX+/TJrMeFV4G6AzQ3PhsQO/
        Oq6rXH83VtAFHQ2OLcFlnT0U7s/gzSI=
X-Google-Smtp-Source: ABdhPJwaPCpcYRfMqrFvQQcEcoDHBujHWQs1Tk96C6pX5anR3fM3wbWGCz9yWfnzfRptw0yW8HxeKQ==
X-Received: by 2002:a17:902:b58a:b029:fe:735f:ddbf with SMTP id a10-20020a170902b58ab02900fe735fddbfmr5319876pls.68.1622829272301;
        Fri, 04 Jun 2021 10:54:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:862d])
        by smtp.gmail.com with ESMTPSA id u7sm2691656pgl.39.2021.06.04.10.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 10:54:31 -0700 (PDT)
Date:   Fri, 4 Jun 2021 10:54:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 4/7] net: sched: add lightweight update path
 for cls_bpf
Message-ID: <20210604175428.f77zeagqavjvdndn@ast-mbp.dhcp.thefacebook.com>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-5-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604063116.234316-5-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 12:01:13PM +0530, Kumar Kartikeya Dwivedi wrote:
> This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
> effectively changing the classifier implementation for a given filter
> owned by a bpf_link.
> 
> Note that READ_ONCE suffices in this case as the ordering for loads from
> the filter are implicitly provided by the data dependency on BPF prog
> pointer.
> 
> On the writer side we can just use a relaxed WRITE_ONCE store to make
> sure one or the other value is visible to a reader in cls_bpf_classify.
> Lifetime is managed using RCU so bpf_prog_put path should wait until
> readers are done for old_prog.

Should those be rcu_deref and rcu_assign_pointer ?
Typically the pointer would be __rcu annotated which would be
another small change in struct cls_bpf_prog.
That would make the life time easier to follow?

> All other parties accessing the BPF prog are under RTNL protection, so
> need no changes.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index bf61ffbb7fd0..f23304685c48 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -9,6 +9,7 @@
>   * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
>   */
>  
> +#include <linux/atomic.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/skbuff.h>
> @@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>  			/* It is safe to push/pull even if skb_shared() */
>  			__skb_push(skb, skb->mac_len);
>  			bpf_compute_data_pointers(skb);
> -			filter_res = BPF_PROG_RUN(prog->filter, skb);
> +			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
>  			__skb_pull(skb, skb->mac_len);
>  		} else {
>  			bpf_compute_data_pointers(skb);
> -			filter_res = BPF_PROG_RUN(prog->filter, skb);
> +			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
>  		}
>  
>  		if (prog->exts_integrated) {
> @@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link)
>  	return 0;
>  }
>  
> +static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
> +			       struct bpf_prog *old_prog)
> +{
> +	struct cls_bpf_link *cls_link;
> +	struct cls_bpf_prog cls_prog;
> +	struct cls_bpf_prog *prog;
> +	int ret;
> +
> +	rtnl_lock();
> +
> +	cls_link = container_of(link, struct cls_bpf_link, link);
> +	if (!cls_link->prog) {
> +		ret = -ENOLINK;
> +		goto out;
> +	}
> +
> +	prog = cls_link->prog;
> +
> +	/* BPF_F_REPLACEing? */
> +	if (old_prog && prog->filter != old_prog) {
> +		ret = -EINVAL;

Other places like cgroup_bpf_replace and bpf_iter_link_replace
return -EPERM in such case.

> +		goto out;
> +	}
> +
> +	old_prog = prog->filter;
> +
> +	if (new_prog == old_prog) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	cls_prog = *prog;
> +	cls_prog.filter = new_prog;
> +
> +	ret = cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
> +	if (ret < 0)
> +		goto out;
> +
> +	WRITE_ONCE(prog->filter, new_prog);
> +
> +	bpf_prog_inc(new_prog);
> +	/* release our reference */
> +	bpf_prog_put(old_prog);
> +
> +out:
> +	rtnl_unlock();
> +	return ret;
> +}
> +
>  static void __bpf_fill_link_info(struct cls_bpf_link *link,
>  				 struct bpf_link_info *info)
>  {
> @@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops = {
>  	.show_fdinfo = cls_bpf_link_show_fdinfo,
>  #endif
>  	.fill_link_info = cls_bpf_link_fill_link_info,
> +	.update_prog = cls_bpf_link_update,
>  };
>  
>  static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
> -- 
> 2.31.1
> 

-- 
