Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEAF2A3283
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgKBSEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgKBSEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 13:04:54 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B386C0617A6;
        Mon,  2 Nov 2020 10:04:54 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n15so13431334otl.8;
        Mon, 02 Nov 2020 10:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=oYjbib//4OMOd2feerHxeK2v6gODdU5Sfo96oCfjNbA=;
        b=mCIeyCAIwsbyXbmT/XucjF9jUgWCqDO+LHyQAfiFx6Sq1PDCaXqxkYyEcGPG8YhE4O
         9+3nCwX7kmth7LC5oW4exgeYQHGB3A3c+p77SjtKLLC8pUuqV3R0gzik3/IWmGb3cvHB
         IMlgqhEAGPISqfmhiBFy4IaUjlETQ5cR/CVOhyit0z3ozU9JNLLLNJamBy+JDWmMNGqX
         tpm3WoMhAk4JhgyuZsKiJ6L+ASmyppV+pqMN0RzkAIeqs0PH5IIHlJdvVhAtgibIWhtr
         YBU3BmquBB/7XZwXqlHN4loH+9FJZoK7GjlE6op+oCKIEuDIrX5RHGdodBg3hIP7W/0W
         hK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=oYjbib//4OMOd2feerHxeK2v6gODdU5Sfo96oCfjNbA=;
        b=hx7KE1ePw3FAQkcE3v5NUiDYSJK5dj220LGfq2BoLXSvL9LSYKRiCtTozo9sESDEt6
         VLtnYpnmcb1MX76mSWwC4QY99iUI3wBU9FhwdRQZV5KeddDpCGxHETuyxkEwb4vP1SOG
         j3zPbx1TQuFeHxjc9Snf0jsZ9w8LnA8nSsVa9fC7ofFxDig1i8CP2MCo9PtY5Tduvgt6
         GbdFLdoTYsOnoZoNi0oXx7qCFWoy4mADiGiZJ+rEzKdveBDTWPEBjmM+3CDZA0PsnJg8
         tqex+6PK+PEMQdDcxmW3y8FREGdG2019jlXberNCET8KCDspbFO4wuFJZOP3xYvbnKeW
         Sklg==
X-Gm-Message-State: AOAM530ZOyXGVZwdmHfuCd65/BujardqaNwDr8u3JM91+SOVI+LnrTG+
        YctuLnxYeVzftySq2KacX6Ovt8Zcgznl8A==
X-Google-Smtp-Source: ABdhPJxlL4rLv7TutC1kfqcilonIx4kDwFuUHOLAw0+swULHeyPQWkUUscmIGOkJ1GF+UL7s3bSUZA==
X-Received: by 2002:a9d:7507:: with SMTP id r7mr12635048otk.336.1604340293581;
        Mon, 02 Nov 2020 10:04:53 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j108sm2615977otc.8.2020.11.02.10.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 10:04:52 -0800 (PST)
Date:   Mon, 02 Nov 2020 10:04:44 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Message-ID: <5fa04a3c7c173_1ecdb20821@john-XPS-13-9370.notmuch>
In-Reply-To: <20201102121548.5e2c36b1@carbon>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407666238.1525159.9197344855524540198.stgit@firesoul>
 <5f9c764fc98c6_16d4208d5@john-XPS-13-9370.notmuch>
 <20201102121548.5e2c36b1@carbon>
Subject: Re: [PATCH bpf-next V5 3/5] bpf: add BPF-helper for MTU checking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 30 Oct 2020 13:23:43 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Jesper Dangaard Brouer wrote:
> > > This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> > > 
> > > The API is designed to help the BPF-programmer, that want to do packet
> > > context size changes, which involves other helpers. These other helpers
> > > usually does a delta size adjustment. This helper also support a delta
> > > size (len_diff), which allow BPF-programmer to reuse arguments needed by
> > > these other helpers, and perform the MTU check prior to doing any actual
> > > size adjustment of the packet context.
> > > 
> > > It is on purpose, that we allow the len adjustment to become a negative
> > > result, that will pass the MTU check. This might seem weird, but it's not
> > > this helpers responsibility to "catch" wrong len_diff adjustments. Other
> > > helpers will take care of these checks, if BPF-programmer chooses to do
> > > actual size adjustment.
> > > 
> > > V4: Lot of changes
> > >  - ifindex 0 now use current netdev for MTU lookup
> > >  - rename helper from bpf_mtu_check to bpf_check_mtu
> > >  - fix bug for GSO pkt length (as skb->len is total len)
> > >  - remove __bpf_len_adj_positive, simply allow negative len adj
> > > 
> > > V3: Take L2/ETH_HLEN header size into account and document it.
> > > 
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > ---  
> > 
> > Sorry for the late feedback here.
> > 
> > This seems like a lot of baked in functionality into the helper? Can you
> > say something about why the simpler and, at least to me, more intuitive
> > helper to simply return the ifindex mtu is not ideal?
> 
> I tried to explain this in the patch description.  This is for easier
> collaboration with other helpers, that also have the len_diff parameter.
> This API allow to check the MTU *prior* to doing the size adjustment.
> 
> Let me explain what is not in the patch desc:

OK extra details helps.

> 
> In the first patchset, I started with the simply implementation of
> returning the MTU.  Then I realized that this puts more work into the
> BPF program (thus increasing BPF code instructions).  As we in BPF-prog
> need to extract the packet length to compare against the returned MTU
> size. Looking at other programs that does the ctx/packet size adjust, we
> don't extract the packet length as ctx is about to change, and we don't
> need the MTU variable in the BPF prog (unless it fails).

On recent kernels instruction counts should not be a problem. So, looks
like the argument is to push the skb->len lookup from BPF program into
helper. I'm not sure it matters much if the insn is run in helper or
in the BPF program. I have a preference for the simpler "give me
the MTU and I'll figure out what to do with it". Real programs
will have to handle the failing case and will need to deal with MTU
anyways. We could do it as a BPF implemented helper in one of the
BPF headers so users could just call the BPF "helper" and not know parts of
it are implemented in BPF.

> 
> 
> > Rough pseudo code being,
> > 
> >  my_sender(struct __sk_buff *skb, int fwd_ifindex)
> >  {
> >    mtu = bpf_get_ifindex_mtu(fwd_ifindex, 0);
> >    if (skb->len + HDR_SIZE < mtu)
> >        return send_with_hdrs(skb);
> >    return -EMSGSIZE
> >  }
> > 
> > 
> > >  include/uapi/linux/bpf.h       |   70 +++++++++++++++++++++++
> > >  net/core/filter.c              |  120 ++++++++++++++++++++++++++++++++++++++++
> > >  tools/include/uapi/linux/bpf.h |   70 +++++++++++++++++++++++
> > >  3 files changed, 260 insertions(+)
> > >   
> > 
> > [...]
> > 
> > > + *              **BPF_MTU_CHK_RELAX**
> > > + *			This flag relax or increase the MTU with room for one
> > > + *			VLAN header (4 bytes). This relaxation is also used by
> > > + *			the kernels own forwarding MTU checks.  
> > 
> > I noted below as well, but not sure why this is needed. Seems if user
> > knows to add a flag because they want a vlan header we can just as
> > easily expect BPF program to do it. Alsoer it only works for VLAN headers
> > any other header data wont be accounted for so it seems only useful
> > in one specific case.
> 
> This was added because the kernels own forwarding have this relaxation
> build in.  Thus, I though that I should add flag to compatible with the
> kernels forwarding checks.

OK, I guess it doesn't hurt.

> 
> > > + *
> > > + *		**BPF_MTU_CHK_SEGS**
> > > + *			This flag will only works for *ctx* **struct sk_buff**.
> > > + *			If packet context contains extra packet segment buffers
> > > + *			(often knows as GSO skb), then MTU check is partly
> > > + *			skipped, because in transmit path it is possible for the
> > > + *			skb packet to get re-segmented (depending on net device
> > > + *			features).  This could still be a MTU violation, so this
> > > + *			flag enables performing MTU check against segments, with
> > > + *			a different violation return code to tell it apart.
> > > + *
> > > + *		The *mtu_result* pointer contains the MTU value of the net
> > > + *		device including the L2 header size (usually 14 bytes Ethernet
> > > + *		header). The net device configured MTU is the L3 size, but as
> > > + *		XDP and TX length operate at L2 this helper include L2 header
> > > + *		size in reported MTU.
> > > + *
> > > + *	Return
> > > + *		* 0 on success, and populate MTU value in *mtu_result* pointer.
> > > + *
> > > + *		* < 0 if any input argument is invalid (*mtu_result* not updated)
> > > + *
> > > + *		MTU violations return positive values, but also populate MTU
> > > + *		value in *mtu_result* pointer, as this can be needed for
> > > + *		implementing PMTU handing:
> > > + *
> > > + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> > > + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> > > + *
> > >   */  
> > 
> > [...]
> > 
> > > +static int __bpf_lookup_mtu(struct net_device *dev_curr, u32 ifindex, u64 flags)
> > > +{
> > > +	struct net *netns = dev_net(dev_curr);
> > > +	struct net_device *dev;
> > > +	int mtu;
> > > +
> > > +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> > > +	if (ifindex == 0)
> > > +		dev = dev_curr;
> > > +	else
> > > +		dev = dev_get_by_index_rcu(netns, ifindex);
> > > +
> > > +	if (!dev)
> > > +		return -ENODEV;
> > > +
> > > +	/* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
> > > +	mtu = dev->mtu + dev->hard_header_len;  
> > 
> > READ_ONCE() on dev->mtu and hard_header_len as well? We don't have
> > any locks.
> 
> This is based on similar checks done in the same execution context,
> which don't have these READ_ONCE() macros.  I'm not introducing reading
> these, I'm simply moving when they are read.  If this is really needed,
> then I think we need separate fixes patches, for stable backporting.
> 
> While doing this work, I've realized that mtu + hard_header_len is
> located on two different cache-lines, which is unfortunate, but I will
> look at fixing this in followup patches.

Looks like a follow up then. But, would be best to add the READ_ONCE
here. The netdevice.h header has this comment,

	/* Note : dev->mtu is often read without holding a lock.
	 * Writers usually hold RTNL.
	 * It is recommended to use READ_ONCE() to annotate the reads,
	 * and to use WRITE_ONCE() to annotate the writes.
	 */

> 
> 
> > > +
> > > +	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> > > +	if (flags & BPF_MTU_CHK_RELAX)
> > > +		mtu += VLAN_HLEN;  
> > 
> > I'm trying to think about the use case where this might be used?
> > Compared to just adjusting MTU in BPF program side as needed for
> > packet encapsulation/headers/etc.
> 
> As I wrote above, this were added because the kernels own forwarding
> have this relaxation in it's checks (in is_skb_forwardable()).  I even
> tried to dig through the history, introduced in [1] and copy-pasted
> in[2].  And this seems to be a workaround, that have become standard,
> that still have practical implications.
> 
> My practical experiments showed, that e.g. ixgbe driver with MTU=1500
> (L3-size) will allow and fully send packets with 1504 (L3-size). But
> i40e will not, and drops the packet in hardware/firmware step.  So,
> what is the correct action, strict or relaxed?
> 
> My own conclusion is that we should inverse the flag.  Meaning to
> default add this VLAN_HLEN (4 bytes) relaxation, and have a flag to do
> more strict check,  e.g. BPF_MTU_CHK_STRICT. As for historical reasons
> we must act like kernels version of MTU check. Unless you object, I will
> do this in V6.

I'm fine with it either way as long as its documented in the helper
description so I have a chance of remembering this discussion in 6 months.
But, if you make it default won't this break for XDP cases? I assume the
XDP use case doesn't include the VLAN 4-bytes. Would you need to prevent
the flag from being used from XDP?

Thanks,
John
