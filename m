Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E38470C2
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfFOPTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 11:19:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42200 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 11:19:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id l19so3257104pgh.9
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 08:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rj5thdQHso4WkcZJ5rv88vw6SlcMQ1DZZi7hsWXkILc=;
        b=Fb9x9pJdQ9j01cbaQOhMqM8TEIu6Zndl7l/OzHHIvsyf0EpmThB4V2/14dhBD2+vcW
         9weLbRWo351gGbYThrrtLV0M08rBaHgBvY5wddB/zLWigEkaYIxOmZMIjEH2Qw6tK49u
         pRV3YGCkvZ0DBVllD2XxCBXXNf/pNJggZ130IYlfMdN5Dm4Y/wLklgm2clVRm5xsUqli
         6iDLc1qb3FDh8XhSn1VRFmBbFODSFALC5MZm1pp9p6ANF4G0sACZrOBV/CSCnSpqZ0h1
         OaserkEYmKi2Xh/lo77gebWav3AbpeiuvrQE8+WxHrQxqgh+hIghWixq7feMUZ8Ha5wA
         vYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rj5thdQHso4WkcZJ5rv88vw6SlcMQ1DZZi7hsWXkILc=;
        b=uTAmsYPZBfmbhRha6tzw1M6l06iWGzDn3RrRssuzob36CvrF/3ZR/zEtHq/dmXtviq
         T72aPcS6X7lznzttWD/iCkNhGipMHSRtrB1tR9fyJnGP1YzYNptY7s9z2sSIV4Nfm+Li
         6PJsbgU/lhdajcP50K3c+ITP5BRpp+plcB5ISlZZRVxLSnabsJlxjFxRcPZe+kx6L6lQ
         QENzuZCKbUkFf4LH6q+/rk16v3W9EhcPERhZXLg7rHTCCB0kZrZiMUN1I10zdxctX4JG
         /nwdT3TubOJpV2kZbK1i/0kO6VPkOp79l5lMq2uLjDjKYvqkrN0LuedjM+ZoJD1dL9K2
         WSMA==
X-Gm-Message-State: APjAAAURg2wcMwsPEiPTskEV28h5Pi99PNt/2rYjVjBKzWvB8uk5AvFw
        5MkGKkZqlzGKnmrmqUPG07uF4C7s
X-Google-Smtp-Source: APXvYqx6AnpzSJpv0reunPAniN4BLynh56HoZIVtHHyKXA2uphCYg9fT3MyfcoBZSHJgsbHsuD5Nig==
X-Received: by 2002:a63:f817:: with SMTP id n23mr33694237pgh.35.1560611957574;
        Sat, 15 Jun 2019 08:19:17 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1:ed9e])
        by smtp.gmail.com with ESMTPSA id 137sm6806654pfz.116.2019.06.15.08.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:19:16 -0700 (PDT)
Date:   Sat, 15 Jun 2019 08:19:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        jhs@mojatatu.com, David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: VLAN tags in mac_len
Message-ID: <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:18:41PM +0200, Johannes Berg wrote:
> 
> Possible solutions?
> 
> So far, Zahari tried three different ways of fixing this:
> 
>  1) Make the bridge code use skb->mac_len instead of ETH_HLEN. This
>     works for this particular case, but breaks some other cases;
>     evidently some places exist where skb->mac_len isn't even set to
>     ETH_HLEN when a packet gets to the bridge. I don't know right now
>     what that was, I think probably somebody who's CC'ed reported that.
> 
>  2) Let tc_act_vlan() just pull ETH_HLEN instead of skb->mac_len, but
>     this is rather asymmetric and strange, and while it works for this
>     case it may cause confusion elsewhere.
> 
>  2b) Toshiaki said it might be better to make that code *remember*
>      mac_len and then use it to push and pull (so not caring about the
>      change made by skb_vlan_push()), but that ultimately leads to
>      confusion and if you have TC push/pop combinations things just get
>      completely out of sync and die
> 
>  3) Make skb_vlan_push()/_pop() just not change mac_len at all. So far
>     this also addresses the issue, but it's likely that this will break
>     OVS, and I don't know how it'd affect BPF. Quite possibly like TC
>     does and is broken, but perhaps not.
> 
> 
> But now we're stuck. Depending on how you look at it, all of these seem
> sort of reasonable, or not.
> 
> Ultimately, the issue seems to be that we couldn't really decide whether
> VLAN tags (and probably MPLS tags, for that matter) are covered by
> mac_len or not. At least not consistently on ingress and egress.
> eth_type_trans() doesn't take them into account, so of course on simple
> ingress mac_len will only cover the ETH_HLEN.
> 
> If you have an accelerated tag and then push it into the SKB, it will
> *not* be taken into account in mac_len. OTOH, if you have a new tag and
> use skb_vlan_push() then it *will* be taken into account.
> 
> 
> I'm trending towards solution (3), because if we consider other
> combinations of VLAN push/pop in TC, I think we can end up in a very
> messy situation today. For example, POP/PUSH seems like it should be a
> no-op, but it isn't due to the mac_len, *unless* it can use the HW accel
> only (i.e. only a single tag).
> 
> I think then to propose such a patch though we'd have to figure out
> where the BPF case is, and to keep OVS working probably either add an
> argument ("bool adjust_mac_len") to the function signatures, or just do
> the adjustments in OVS code after calling them?
> 
> 
> Any other thoughts?

imo skb_vlan_push() should still change mac_len.
tc, ovs, bpf use it and expect vlan to be part of L2.
There is nothing between L2 and L3 :)
Hence we cannot say that vlan is not part of L2.
Hence push/pop vlan must change mac_len, since skb->mac_len
is kernel's definition of the length of L2 header.

Now as far as bridge... I think it's unfortunate that linux
adopted 'vlan' as a netdevice model and that's where I think
the problem is.
Typical bridge in the networking industry is a device that
does forwarding based on L2. Which includes vlans.
And imo that's the most appropriate way of configuring and thinking
about bridge functionality.
Whereas in the kernel there is a 'vlan' netdevice that 'eats'
vlan tag and pretends that the rest is the same.
So linux bridge kinda doesn't need to be vlan aware.
CONFIG_BRIDGE_VLAN_FILTERING was the right step, but I haven't
seen it being used and I'm not sure about state of things there.

So your option 1 above is imo the best. The bridge needs to deal
with skb->mac_len and full L2 header.

