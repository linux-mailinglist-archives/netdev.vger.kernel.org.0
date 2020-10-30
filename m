Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB92A0F64
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgJ3UXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3UXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:23:54 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C5C0613CF;
        Fri, 30 Oct 2020 13:23:54 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id k3so6733320otp.1;
        Fri, 30 Oct 2020 13:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zWhMcc8AJN0bQ0CAzjwU0l7vFsIcNIW6oc/DOaNrVJI=;
        b=oX8lmJ8Q8Hk2k0+p/2tj2xUqz8jm2UYx0uh5uJippy/qRv39kvhr4PfgTYTN8vfd+R
         7vfpREUcyL7rKIVwUwxdaVBd9JHY7Mz4iXu0iIjwtUfRUTQZXPSTkeRb56/xtY++0bsz
         A6kUpPRjQBESzaNZwq0SWHxODzJReORx3QlyW5tVI38b8GgGTkq590lvne9olILJAvV6
         TrqT+vEo5bVt/Z6lKpL33o03Bf8tTLn50dQ8UN3t/dXD9SqXI7IEwDaXSHqlNibfpmPF
         07pGSMxMVCd3bhKHMcN7V+VU/IrQTSoh2CQg7CgQmk/J83jnOGqzre2rmfASC7Xqxhjo
         HUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zWhMcc8AJN0bQ0CAzjwU0l7vFsIcNIW6oc/DOaNrVJI=;
        b=mtcdl4rC94JyfpNly3K/y3feO5lc7G7pNHe1xafpTQAg/TlFvSv0+aSt0auUyZzDQc
         wB1TpiUOPVMdbD/RVfiH82bvfHU9+ucCeHKKtUv7qb81M3CYEfjPuePB07r5Bci2PlEi
         G1gMcHwaNftGmoVzN1QwaANeobjKLXvsZTLmq8Rw8mR+eH6wpf+pkaAA7TCeVSFPwnkp
         gS62iYyfE1b5hAGyzlckNKu/LVF9j4iCzpvSDrReWtkoVeQKll9gr0qAu3Td3XRF39rw
         /Bw/nmdL7YvG6KhYu2xwNrQp0+q+vmg1/fM2ipDg4yI7d+IijNg7Vl7DoeskyfoQ8Ysh
         4dWA==
X-Gm-Message-State: AOAM533PP2Wm6LlRvP6WHUP5CfnSrr7EKbhHzq3uTrKPTFS0u1jiqCev
        pxC9Cuy0dN8570o3iH8f5hQ=
X-Google-Smtp-Source: ABdhPJx/UgpwUDDinheU7nEjcRqiYAWILvgT4PMm6zEkwls8n+8KUHMFk68apQxkME5mlnsocla6Og==
X-Received: by 2002:a9d:7f90:: with SMTP id t16mr3168735otp.231.1604089433619;
        Fri, 30 Oct 2020 13:23:53 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h28sm1710053ooc.42.2020.10.30.13.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 13:23:52 -0700 (PDT)
Date:   Fri, 30 Oct 2020 13:23:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5f9c764fc98c6_16d4208d5@john-XPS-13-9370.notmuch>
In-Reply-To: <160407666238.1525159.9197344855524540198.stgit@firesoul>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407666238.1525159.9197344855524540198.stgit@firesoul>
Subject: RE: [PATCH bpf-next V5 3/5] bpf: add BPF-helper for MTU checking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> 
> The API is designed to help the BPF-programmer, that want to do packet
> context size changes, which involves other helpers. These other helpers
> usually does a delta size adjustment. This helper also support a delta
> size (len_diff), which allow BPF-programmer to reuse arguments needed by
> these other helpers, and perform the MTU check prior to doing any actual
> size adjustment of the packet context.
> 
> It is on purpose, that we allow the len adjustment to become a negative
> result, that will pass the MTU check. This might seem weird, but it's not
> this helpers responsibility to "catch" wrong len_diff adjustments. Other
> helpers will take care of these checks, if BPF-programmer chooses to do
> actual size adjustment.
> 
> V4: Lot of changes
>  - ifindex 0 now use current netdev for MTU lookup
>  - rename helper from bpf_mtu_check to bpf_check_mtu
>  - fix bug for GSO pkt length (as skb->len is total len)
>  - remove __bpf_len_adj_positive, simply allow negative len adj
> 
> V3: Take L2/ETH_HLEN header size into account and document it.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Sorry for the late feedback here.

This seems like a lot of baked in functionality into the helper? Can you
say something about why the simpler and, at least to me, more intuitive
helper to simply return the ifindex mtu is not ideal?

Rough pseudo code being,

 my_sender(struct __sk_buff *skb, int fwd_ifindex)
 {
   mtu = bpf_get_ifindex_mtu(fwd_ifindex, 0);
   if (skb->len + HDR_SIZE < mtu)
       return send_with_hdrs(skb);
   return -EMSGSIZE
 }


>  include/uapi/linux/bpf.h       |   70 +++++++++++++++++++++++
>  net/core/filter.c              |  120 ++++++++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |   70 +++++++++++++++++++++++
>  3 files changed, 260 insertions(+)
> 

[...]

> + *              **BPF_MTU_CHK_RELAX**
> + *			This flag relax or increase the MTU with room for one
> + *			VLAN header (4 bytes). This relaxation is also used by
> + *			the kernels own forwarding MTU checks.

I noted below as well, but not sure why this is needed. Seems if user
knows to add a flag because they want a vlan header we can just as
easily expect BPF program to do it. Also it only works for VLAN headers
any other header data wont be accounted for so it seems only useful
in one specific case.

> + *
> + *		**BPF_MTU_CHK_SEGS**
> + *			This flag will only works for *ctx* **struct sk_buff**.
> + *			If packet context contains extra packet segment buffers
> + *			(often knows as GSO skb), then MTU check is partly
> + *			skipped, because in transmit path it is possible for the
> + *			skb packet to get re-segmented (depending on net device
> + *			features).  This could still be a MTU violation, so this
> + *			flag enables performing MTU check against segments, with
> + *			a different violation return code to tell it apart.
> + *
> + *		The *mtu_result* pointer contains the MTU value of the net
> + *		device including the L2 header size (usually 14 bytes Ethernet
> + *		header). The net device configured MTU is the L3 size, but as
> + *		XDP and TX length operate at L2 this helper include L2 header
> + *		size in reported MTU.
> + *
> + *	Return
> + *		* 0 on success, and populate MTU value in *mtu_result* pointer.
> + *
> + *		* < 0 if any input argument is invalid (*mtu_result* not updated)
> + *
> + *		MTU violations return positive values, but also populate MTU
> + *		value in *mtu_result* pointer, as this can be needed for
> + *		implementing PMTU handing:
> + *
> + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> + *
>   */

[...]

> +static int __bpf_lookup_mtu(struct net_device *dev_curr, u32 ifindex, u64 flags)
> +{
> +	struct net *netns = dev_net(dev_curr);
> +	struct net_device *dev;
> +	int mtu;
> +
> +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> +	if (ifindex == 0)
> +		dev = dev_curr;
> +	else
> +		dev = dev_get_by_index_rcu(netns, ifindex);
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	/* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
> +	mtu = dev->mtu + dev->hard_header_len;

READ_ONCE() on dev->mtu and hard_header_len as well? We don't have
any locks.

> +
> +	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> +	if (flags & BPF_MTU_CHK_RELAX)
> +		mtu += VLAN_HLEN;

I'm trying to think about the use case where this might be used?
Compared to just adjusting MTU in BPF program side as needed for
packet encapsulation/headers/etc.

> +
> +	return mtu;
> +}
> +
