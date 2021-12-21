Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF58E47C7BC
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhLUTqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbhLUTqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:46:54 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C62C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 11:46:54 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id b192so8867688vkf.3
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 11:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5h28uHVvMYOAuBkc/XUZtW1x7GoAPa2Y5e8SO6rR6Ck=;
        b=UYI8dT/zDmxFYE/XowbtT7edMB0VTXMhUmsNxUCippGtQPqLtnYcU0FLgrBBAz2Xyh
         +dqtljqKiRDZrrvb39sl+fZ4TtjeKcnJPJl9F/twVHxEDvphBgCEZeLRnnIKvkgqR1yz
         bXmduNqVzbk5N5wgzzILSS589R7JMSG41K59ZNSuY5dnjSyf6mLQP74FSbCZjLWXNYAY
         SwaN/agI7ZsaoeLVqKHUdWjeb2/j8I64X4KOrzGwTeqY97YDyMbowdp3zIH+QUrFWmSX
         PpRDsuJ8BSoLkgTKhvr0pbKM2duh54Em808Xp3KPR4G00XM+nSsy9GfPKo9Pp0e+iAsW
         yl+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5h28uHVvMYOAuBkc/XUZtW1x7GoAPa2Y5e8SO6rR6Ck=;
        b=3LoPsPeJHDDMO8j3h1pY0pLEoeaaVfXQIizSA+A4ORijdl5WRSKIGUcYhECwt9+EaS
         1pzMHY6GA3RfOE1YECrzwaMnzm7ex5vXh/7ZMyrfwf4JShR2y2PBLcJRWJ5vb+IVe0WQ
         D4L7TMldbtXAKUelzpvpmqJiXAOuKGVkaHMHijhBvMiroV+nlDF1BgK4HGfKZQJin0HV
         SRZYeP3WDMcesb9pIAlZv1u2WzsQbLHKUfK9Q9/gpBfg9fiQHYTdA0AcVvg8GDi0dAN4
         NuvrIOV6Vg1cW+GSNzkgqCwJEaNkaq6DczwkA8jLLx1mHZ5qcjxR3vf4UvHe2NgR7+k+
         4fCg==
X-Gm-Message-State: AOAM530le1EkBV0nJc9wV7Lk6orScOht6hhYVQRxL9uCvpqAMrVY6b2T
        Qzo2T1wJBkhaS7M/uqqp/0IbFAEGnH3SkpoVyNF2ZA==
X-Google-Smtp-Source: ABdhPJxIVdUizt3tL95M+zmHh9jhDevAsi26uwK+MgTB+1bOhqp6W6Qb8/VNiIZ+shrxsVPawiMnTIIYGjhLmJzw/jg=
X-Received: by 2002:a05:6122:2210:: with SMTP id bb16mr2204790vkb.28.1640116013361;
 Tue, 21 Dec 2021 11:46:53 -0800 (PST)
MIME-Version: 1.0
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com> <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
In-Reply-To: <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 21 Dec 2021 11:46:40 -0800
Message-ID: <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com>
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
To:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 11:16 AM Tyler Wear (QUIC)
<quic_twear@quicinc.com> wrote:
> > On Mon, Dec 20, 2021 at 07:18:42PM -0800, Yonghong Song wrote:
> > > On 12/20/21 12:40 PM, Tyler Wear wrote:
> > > > New bpf helper function BPF_FUNC_skb_change_dsfield "int
> > > > bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
> > > > BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can be
> > > > attached to the ingress and egress path. The helper is needed
> > > > because this type of bpf_prog cannot modify the skb directly.
> > > >
> > > > Used by a bpf_prog to specify DS field values on egress or ingress.
> > >
> > > Maybe you can expand a little bit here for your use case?
> > > I know DS field might help but a description of your actual use case
> > > will make adding this helper more compelling.
> > +1.  More details on the use case is needed.
> > Also, having an individual helper for each particular header field is too specific.
> >
> > For egress, there is bpf_setsockopt() for IP_TOS and IPV6_TCLASS and it can be called in other cgroup hooks. e.g.
> > BPF_PROG_TYPE_SOCK_OPS during tcp ESTABLISHED event.
> > There is an example in tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c.
> > Is it enough for egress?
>
> Using bpf_setsockopt() has 2 issues: 1) it changes the userspace visible state 2) won't work with udp sendmsg cmsg

Right, so to clarify since I've been working with Tyler on a project
of which this patch is a small component.
Note, I may be wrong here, I don't fully understand how all of this
works... but:

ad 1) AFAIK if bpf calls bpf_setsockopt on the socket in question,
then userspace's view of the socket settings via
getsockopt(IP_TOS/IPV6_TCLASS) will also be affected - this may be
undesirable (it's technically userspace visible change in behaviour
and could, as unlikely as it is, lead to application misbehaviour).
This can be worked around via also overriding getsockopt/setsockopt
with bpf, but then you need to store the value to return to userspace
somewhere... AFAICT it all ends up being pretty ugly and very complex.

I wouldn't be worried about needing to override each individual field,
as the only other field that looks likely to be potentially beneficial
to override would be the ipv6 flowlabel.

ad 2) I don't think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) approach
works for packets generated via udp sendmsg where cmsg is being used
to set tos.

3) I also think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) might be too
late, since it would be in response to an already built packet, and
would thus presumably only take effect on the next packet, and not for
this one, no?

Technically this could be done by attaching the programs to tc egress
instead of the cgroup hook, but then it's per interface, which is
potentially the wrong granularity...

As for what is driving this?  Upcoming wifi standard to allow access
points to inform client devices how to dscp mark individual flows.

As for the patch itself, I wonder if the return value shouldn't be
reversed, currently '1 if the DS field is set, 0 if it is not set.'
But I think returning 0 on success and an error on failure is more in
line with what other bpf helpers do?
OTOH, it does match bpf_skb_ecn_set_ce() returning 0 on failure...

- Maciej
