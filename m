Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3BA39C5EF
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 06:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFEEzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 00:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFEEzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 00:55:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1EFC061766;
        Fri,  4 Jun 2021 21:53:19 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v13so5679613ple.9;
        Fri, 04 Jun 2021 21:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=l+lXlvrsv83VF0gxX53slvH7CUd5rQmw/jVrSjJzDD0=;
        b=aotu0vPjcEw+9KTTksA+JquKDdJlAP1vGFX8qcLOC03dYZ/kxE5VmiQJmOiHrvzfma
         Od1xb790ljDRW1YZKwRcAgnLScLjNK+nQy7V6s9PMqSZDCPAQszqIvV+AhtCgv1I9C40
         VkZZZkJPUsH0AHzbo2xiwUL109oQl+RlDKzOWApoKDAJqQyVSfV7iO/PymZeknYdZK8F
         MFD/pIO3pi4G4qIMxzmDP3x5XQOWU84k7eM3CvVjan4IHJ4PJiQDwtHg2AJ+5CaxyFOP
         j28MdJi9HiyKGy6Uw6Nmd8PESXoiPZDDe2Tq1Qhmm1RMYKXNnO99FzfmCe0UYgXq8x6n
         nugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=l+lXlvrsv83VF0gxX53slvH7CUd5rQmw/jVrSjJzDD0=;
        b=Rs9uzi/7wTJnHx35ekwMlt8sD1yJUAWRmRaNR4iBQtlKFXjx0IlyClscUuOL2TzNEO
         Xp0th+XmzgaORSd6iRfYohuQfyo7la1Y2FLAjI+Qbi3auPCs7QaCKeupHUHcaQl0sXcY
         A6vRVsghLXUdLwHxmCeUlja5FAhA7uzXywnHmnvUTsif5+kzE0+Yz3CE349dhYRjPua5
         RkOEq3aRJ4LMvt5txJGARWGXfL+jY0J1G9AZg4c40ScZJTTMDYVzsk1XNvdQrFQSnb3b
         eI0m6XihqxZhCVxhLDgMzse6oHTYPIdqJtR0BqsPAS6X0dKjhKaW5Ik0rvrCGPQ0Tgh5
         QF3Q==
X-Gm-Message-State: AOAM530uCfjrBSX2pDNFluehDjwr0+30Idns/INYfACTrFcgMCwPyYMJ
        B5dqURLWqPJCK6Ht/xs0PtY=
X-Google-Smtp-Source: ABdhPJzedfeenmDkGe+9sWcFJWrayIt7vhLxld8tLBp9fWovDpv1ML50FqRCIrSI5o1LAZlkih/tJA==
X-Received: by 2002:a17:90a:b007:: with SMTP id x7mr20041879pjq.202.1622868799486;
        Fri, 04 Jun 2021 21:53:19 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3c31:71d1:71f6:fb2:d008])
        by smtp.gmail.com with ESMTPSA id a65sm3041429pfb.177.2021.06.04.21.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 21:53:19 -0700 (PDT)
Date:   Sat, 5 Jun 2021 10:22:18 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
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
Subject: Re: [PATCH bpf-next v2 3/7] net: sched: add bpf_link API for bpf
 classifier
Message-ID: <20210605045218.jnkfhu7iys7zbt64@apollo>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-4-memxor@gmail.com>
 <3fca958b-dcf3-6363-5f23-a2e7c4d16f87@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3fca958b-dcf3-6363-5f23-a2e7c4d16f87@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 08:38:17AM IST, Yonghong Song wrote:
>
>
> On 6/3/21 11:31 PM, Kumar Kartikeya Dwivedi wrote:
> > This commit introduces a bpf_link based kernel API for creating tc
> > filters and using the cls_bpf classifier. Only a subset of what netlink
> > API offers is supported, things like TCA_BPF_POLICE, TCA_RATE and
> > embedded actions are unsupported.
> >
> > The kernel API and the libbpf wrapper added in a subsequent patch are
> > more opinionated and mirror the semantics of low level netlink based
> > TC-BPF API, i.e. always setting direct action mode, always setting
> > protocol to ETH_P_ALL, and only exposing handle and priority as the
> > variables the user can control. We add an additional gen_flags parameter
> > though to allow for offloading use cases. It would be trivial to extend
> > the current API to support specifying other attributes in the future,
> > but for now I'm sticking how we want to push usage.
> >
> > The semantics around bpf_link support are as follows:
> >
> > A user can create a classifier attached to a filter using the bpf_link
> > API, after which changing it and deleting it only happens through the
> > bpf_link API. It is not possible to bind the bpf_link to existing
> > filter, and any such attempt will fail with EEXIST. Hence EEXIST can be
> > returned in two cases, when existing bpf_link owned filter exists, or
> > existing netlink owned filter exists.
> >
> > Removing bpf_link owned filter from netlink returns EPERM, denoting that
> > netlink is locked out from filter manipulation when bpf_link is
> > involved.
> >
> > Whenever a filter is detached due to chain removal, or qdisc tear down,
> > or net_device shutdown, the bpf_link becomes automatically detached.
> >
> > In this way, the netlink API and bpf_link creation path are exclusive
> > and don't stomp over one another. Filters created using bpf_link API
> > cannot be replaced by netlink API, and filters created by netlink API are
> > never replaced by bpf_link. Netfilter also cannot detach bpf_link filters.
> >
> > We serialize all changes dover rtnl_lock as cls_bpf API doesn't support the
>
> dover => over?
>

Thanks, will fix.

> > unlocked classifier API.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   include/linux/bpf_types.h |   3 +
> >   include/net/pkt_cls.h     |  13 ++
> >   include/net/sch_generic.h |   6 +-
> >   include/uapi/linux/bpf.h  |  15 +++
> >   kernel/bpf/syscall.c      |  10 +-
> >   net/sched/cls_api.c       | 139 ++++++++++++++++++++-
> >   net/sched/cls_bpf.c       | 250 +++++++++++++++++++++++++++++++++++++-
> >   7 files changed, 430 insertions(+), 6 deletions(-)
> >
> [...]
> >   subsys_initcall(tc_filter_init);
> > +
> > +#if IS_ENABLED(CONFIG_NET_CLS_BPF)
> > +
> > +int bpf_tc_link_attach(union bpf_attr *attr, struct bpf_prog *prog)
> > +{
> > +	struct net *net = current->nsproxy->net_ns;
> > +	struct tcf_chain_info chain_info;
> > +	u32 chain_index, prio, parent;
> > +	struct tcf_block *block;
> > +	struct tcf_chain *chain;
> > +	struct tcf_proto *tp;
> > +	int err, tp_created;
> > +	unsigned long cl;
> > +	struct Qdisc *q;
> > +	__be16 protocol;
> > +	void *fh;
> > +
> > +	/* Caller already checks bpf_capable */
> > +	if (!ns_capable(current->nsproxy->net_ns->user_ns, CAP_NET_ADMIN))
>
> net->user_ns?
>

True, will fix.

> > +		return -EPERM;
> > +
> > +	if (attr->link_create.flags ||
> > +	    !attr->link_create.target_ifindex ||
> > +	    !tc_flags_valid(attr->link_create.tc.gen_flags))
> > +		return -EINVAL;
> > +
> [...]

--
Kartikeya
