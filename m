Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05639C5E8
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 06:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhFEEpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 00:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFEEpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 00:45:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F6CC061766;
        Fri,  4 Jun 2021 21:43:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x73so8907125pfc.8;
        Fri, 04 Jun 2021 21:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2qg5afdx9qgBvuogmdH1ggvFD09I666BgcRW8giyByo=;
        b=COrGCB3ZNEHgqmZPTtcU5G0r4SdnVImzqGAMDlJOO+KSKMf1Z5G2YDsY1R2lpQQaM4
         g5L37k46Q0oktcSn8GgNbqGa8dQlM71/jDApAGsDHQatgdd+79FkBEmonsTmdd2eK5WW
         7T5BMO1LamI2whUQg1vrX9Qr6gOf2NNUWl56lhJ/HU7EuCA5Ln7hJfL3Vm6uNfc/qTt3
         igXhY0RDO4oPDzth5TeI8loMtnzheLGC7cbjckfmljpOdAPgohotwhppb0SmjLkZQk6h
         8swYckfuNgfsx6COV74jC0dESvbmZNzuIX/6EJCn8ywLLPs+isSCF1Ne7be/k6adpBBK
         +8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2qg5afdx9qgBvuogmdH1ggvFD09I666BgcRW8giyByo=;
        b=o5nmxiyvdMapQhsMJRxtuN47x6K5Erw1ioBdQCA7gPgW9cYsnuBOE6lw6eoHLhQeGw
         ZFiQy2SZOCWjYibweqCYSrAJCz5V+qejsEMlmW6NEOBbPQsNljMq7X+mikY/3SluEEfc
         vb/onEF/b1S94x4PoMFn/95nk6xa817YpfNQ7abPISgPsY56Wx3AbdtIJWTa1MXvY49D
         SJln69gxhoUDRj03PZcT2ePhyxgImnEPS8H+bCLZ7eGkGYP0DM1jhz7f89OMPZLqspOz
         5If6Jik1eiZEY8JHofEcBDINjqBzchBmjyWkhoajSHHXB9CvGVPXLq+LorHiR3EECX9q
         oQbA==
X-Gm-Message-State: AOAM530htSu8yxwC/xPZl2PftMk+OJfRUmO1LjrX+UqcPQW1d3+kgo64
        vCRH6qT4qhaRX9NgflDgIGE=
X-Google-Smtp-Source: ABdhPJxpYdEqeSYNb7PG+Cy41HDMCKdR5XTDebeU2+G0u+8Q1a9IXmZMUtC4Nif6MOrnYDMHfdyFnQ==
X-Received: by 2002:a62:5e04:0:b029:2ea:a8dc:25d3 with SMTP id s4-20020a625e040000b02902eaa8dc25d3mr7794286pfb.6.1622868189239;
        Fri, 04 Jun 2021 21:43:09 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3c31:71d1:71f6:fb2:d008])
        by smtp.gmail.com with ESMTPSA id w125sm2893336pfw.214.2021.06.04.21.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 21:43:08 -0700 (PDT)
Date:   Sat, 5 Jun 2021 10:12:04 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Message-ID: <20210605044204.j3zbrxhdtlf7lziz@apollo>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-5-memxor@gmail.com>
 <20210604175428.f77zeagqavjvdndn@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604175428.f77zeagqavjvdndn@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 11:24:28PM IST, Alexei Starovoitov wrote:
> On Fri, Jun 04, 2021 at 12:01:13PM +0530, Kumar Kartikeya Dwivedi wrote:
> > This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
> > effectively changing the classifier implementation for a given filter
> > owned by a bpf_link.
> >
> > Note that READ_ONCE suffices in this case as the ordering for loads from
> > the filter are implicitly provided by the data dependency on BPF prog
> > pointer.
> >
> > On the writer side we can just use a relaxed WRITE_ONCE store to make
> > sure one or the other value is visible to a reader in cls_bpf_classify.
> > Lifetime is managed using RCU so bpf_prog_put path should wait until
> > readers are done for old_prog.
>
> Should those be rcu_deref and rcu_assign_pointer ?
> Typically the pointer would be __rcu annotated which would be
> another small change in struct cls_bpf_prog.
> That would make the life time easier to follow?
>

True, I'll make that change.

> > All other parties accessing the BPF prog are under RTNL protection, so
> > need no changes.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> > index bf61ffbb7fd0..f23304685c48 100644
> > --- a/net/sched/cls_bpf.c
> > +++ b/net/sched/cls_bpf.c
> > @@ -9,6 +9,7 @@
> >   * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
> >   */
> >
> > +#include <linux/atomic.h>
> >  #include <linux/module.h>
> >  #include <linux/types.h>
> >  #include <linux/skbuff.h>
> > @@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> >  			/* It is safe to push/pull even if skb_shared() */
> >  			__skb_push(skb, skb->mac_len);
> >  			bpf_compute_data_pointers(skb);
> > -			filter_res = BPF_PROG_RUN(prog->filter, skb);
> > +			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
> >  			__skb_pull(skb, skb->mac_len);
> >  		} else {
> >  			bpf_compute_data_pointers(skb);
> > -			filter_res = BPF_PROG_RUN(prog->filter, skb);
> > +			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
> >  		}
> >
> >  		if (prog->exts_integrated) {
> > @@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link)
> >  	return 0;
> >  }
> >
> > +static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
> > +			       struct bpf_prog *old_prog)
> > +{
> > +	struct cls_bpf_link *cls_link;
> > +	struct cls_bpf_prog cls_prog;
> > +	struct cls_bpf_prog *prog;
> > +	int ret;
> > +
> > +	rtnl_lock();
> > +
> > +	cls_link = container_of(link, struct cls_bpf_link, link);
> > +	if (!cls_link->prog) {
> > +		ret = -ENOLINK;
> > +		goto out;
> > +	}
> > +
> > +	prog = cls_link->prog;
> > +
> > +	/* BPF_F_REPLACEing? */
> > +	if (old_prog && prog->filter != old_prog) {
> > +		ret = -EINVAL;
>
> Other places like cgroup_bpf_replace and bpf_iter_link_replace
> return -EPERM in such case.
>

Ok, will change.

> > +		goto out;
> > +	}
> > +
> > +	old_prog = prog->filter;
> > +
> > +	if (new_prog == old_prog) {
> > +		ret = 0;
> > +		goto out;
> > +	}
> > +
> > +	cls_prog = *prog;
> > +	cls_prog.filter = new_prog;
> > +
> > +	ret = cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	WRITE_ONCE(prog->filter, new_prog);
> > +
> > +	bpf_prog_inc(new_prog);
> > +	/* release our reference */
> > +	bpf_prog_put(old_prog);
> > +
> > +out:
> > +	rtnl_unlock();
> > +	return ret;
> > +}
> > +
> >  static void __bpf_fill_link_info(struct cls_bpf_link *link,
> >  				 struct bpf_link_info *info)
> >  {
> > @@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops = {
> >  	.show_fdinfo = cls_bpf_link_show_fdinfo,
> >  #endif
> >  	.fill_link_info = cls_bpf_link_fill_link_info,
> > +	.update_prog = cls_bpf_link_update,
> >  };
> >
> >  static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
> > --
> > 2.31.1
> >
>
> --

--
Kartikeya
