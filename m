Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F951E4F62
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgE0UgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgE0UgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:36:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3607C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:36:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k186so25682306ybc.19
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EfHclXenZ/21aYnUW6IuRxH/Q4eYl3HezzB4IqPMdTQ=;
        b=IE125gGfLV3foCyLAxKW8a9FJgHV/0eFC1VEnTtIQZ/qyv6HF0U5UlfIhsgcWee/ko
         K3fzYuKPioJy8DpVmFoj6p1M7sNHYsNTZ6GXWw6f5UYdEdbAECNxGrivHZPjwzi7SVx4
         SwUioZxS8AOk2DSnNogLBOPu0O9UoL5iaNVX0vNvefT/2YYquAmAYUuuYAWMHM8ZfwyK
         nPSxKtSMbBR+WPTLPn6ZC/1fH1vmHEXunK9jx3elcGHgBHr4VnOhrvDP582hn+95M4z6
         cJVaRTLKgd4lELqYqprWXSd3shC9NSbVx+ELgFpQjjj4JR/wGVBxWSulYvm3nRYgQ5D1
         Jy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EfHclXenZ/21aYnUW6IuRxH/Q4eYl3HezzB4IqPMdTQ=;
        b=pdjn53yN+U2403Fc7ME+MWfrvhSqCpwcA3N/SSdMm8rw/L7eqpuufnneh3m7ExwnVs
         8MpgDX9lJtuN0ctYEQEf8QFu3ooX0Y/VsH2W/6nKm1rV9ajSBIIyFzkJllAkjLlNJt+s
         Y8nLmetkXcDYu8pxxo+tWXATGfq8Fh0Mwkwdtt9DUVkvHayYfovPNhmi3KIfSLUgfnAx
         nuzxL4B+r46wt5heCDI0yM4x1y/Gwfruel8mhxd1bMugIhqs1OLa05D5wTKaPDGHyklh
         1ypWxbTG3JGakJYbqzjPraeOtvQci4tEcaA249VjWLFiNRjkGs/dUmmWgKYczYFKNIlU
         Suqw==
X-Gm-Message-State: AOAM532fPiD3IcD6f6VOB3FPfLlIy21m/2DvNdAEE5wpNWl+AWGcInQM
        xAJMOzSv6hktEuBt8vAG0cd/9fQ=
X-Google-Smtp-Source: ABdhPJztnfkVo1dCE6M0kPVAdMSshdL0A4FZgGWqvacF0vK/e4ivC2+NpxpFb9LqaAXc4I0LR/pUU9U=
X-Received: by 2002:a25:d6c3:: with SMTP id n186mr12507146ybg.375.1590611769049;
 Wed, 27 May 2020 13:36:09 -0700 (PDT)
Date:   Wed, 27 May 2020 13:36:07 -0700
In-Reply-To: <87v9kh2mzg.fsf@cloudflare.com>
Message-Id: <20200527203607.GA57268@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com>
 <20200527170840.1768178-4-jakub@cloudflare.com> <20200527174036.GF49942@google.com>
 <87v9kh2mzg.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/8] net: Introduce netns_bpf for BPF programs
 attached to netns
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27, Jakub Sitnicki wrote:
> On Wed, May 27, 2020 at 07:40 PM CEST, sdf@google.com wrote:
> > On 05/27, Jakub Sitnicki wrote:
> >> In order to:
> >
> >>   (1) attach more than one BPF program type to netns, or
> >>   (2) support attaching BPF programs to netns with bpf_link, or
> >>   (3) support multi-prog attach points for netns
> >
> >> we will need to keep more state per netns than a single pointer like we
> >> have now for BPF flow dissector program.
> >
> >> Prepare for the above by extracting netns_bpf that is part of struct  
> net,
> >> for storing all state related to BPF programs attached to netns.
> >
> >> Turn flow dissector callbacks for querying/attaching/detaching a  
> program
> >> into generic ones that operate on netns_bpf. Next patch will move the
> >> generic callbacks into their own module.
> >
> >> This is similar to how it is organized for cgroup with cgroup_bpf.
> >
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>   include/linux/bpf-netns.h   | 56 ++++++++++++++++++++++
> >>   include/linux/skbuff.h      | 26 ----------
> >>   include/net/net_namespace.h |  4 +-
> >>   include/net/netns/bpf.h     | 17 +++++++
> >>   kernel/bpf/syscall.c        |  7 +--
> >>   net/core/flow_dissector.c   | 96  
> ++++++++++++++++++++++++-------------
> >>   6 files changed, 143 insertions(+), 63 deletions(-)
> >>   create mode 100644 include/linux/bpf-netns.h
> >>   create mode 100644 include/net/netns/bpf.h
> >
> >> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
> >> new file mode 100644
> >> index 000000000000..f3aec3d79824
> >> --- /dev/null
> >> +++ b/include/linux/bpf-netns.h
> >> @@ -0,0 +1,56 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef _BPF_NETNS_H
> >> +#define _BPF_NETNS_H
> >> +
> >> +#include <linux/mutex.h>
> >> +#include <uapi/linux/bpf.h>
> >> +
> >> +enum netns_bpf_attach_type {
> >> +	NETNS_BPF_INVALID = -1,
> >> +	NETNS_BPF_FLOW_DISSECTOR = 0,
> >> +	MAX_NETNS_BPF_ATTACH_TYPE
> >> +};
> >> +
> >> +static inline enum netns_bpf_attach_type
> >> +to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
> >> +{
> >> +	switch (attach_type) {
> >> +	case BPF_FLOW_DISSECTOR:
> >> +		return NETNS_BPF_FLOW_DISSECTOR;
> >> +	default:
> >> +		return NETNS_BPF_INVALID;
> >> +	}
> >> +}
> >> +
> >> +/* Protects updates to netns_bpf */
> >> +extern struct mutex netns_bpf_mutex;
> > I wonder whether it's a good time to make this mutex per-netns, WDYT?
> >
> > The only problem I see is that it might complicate the global
> > mode of flow dissector where we go over every ns to make sure no
> > progs are attached. That will be racy with per-ns mutex unless
> > we do something about it...

> It crossed my mind. I stuck with a global mutex for a couple of
> reasons. Different that one you bring up, which I forgot about.

> 1. Don't know if it has potential to be a bottleneck.

> cgroup BPF uses a global mutex too. Even one that serializes access to
> more data than just BPF programs attached to a cgroup.

> Also, we grab the netns_bpf_mutex only on prog attach/detach, and link
> create/update/release. Netns teardown is not grabbing it. So if you're
> not using netns BPF you're not going to "feel" contention.

> 2. Makes locking on nets bpf_link release trickier

> In bpf_netns_link_release (patch 5), we deref pointer from link to
> struct net under RCU read lock, in case the net is being destroyed
> simulatneously.

> However, we're also grabbing the netns_bpf_mutex, in case of another
> possible scenario, when struct net is alive and well (refcnt > 0), but
> we're racing with a prog attach/detach to access net->bpf.{links,progs}.

> Making the mutex part of net->bpf means I first need to somehow ensure
> netns stays alive if I go to sleep waiting for the lock. Or it would
> have to be a spinlock, or some better (simpler?) locking scheme.


> The above two convinced me that I should start with a global mutex, and
> go for more pain if there's contention.

> Thanks for giving the series a review.
Yeah, everything makes sense, agreed, feel free to slap:
Reviewed-by: Stanislav Fomichev <sdf@google.com>
