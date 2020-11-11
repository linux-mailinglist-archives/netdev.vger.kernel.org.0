Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86F2AE4E3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgKKA0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKA0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:26:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E905C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:26:35 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id 2so241398ybc.12
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2N/6o0jzfm/tkHzuBi40wrgkwIvt3GRMnbzsWP+4128=;
        b=IRkA6WMFAaQD9/MecD6Jgc3z2wV/jAAK8RbZUTqWuPdw4Bl1zj0Dpxh92mUBBq8PT3
         EXZBLlz2eWVyMA60J4VRoegsU5Z/q0ApCR+beELNdC5YzVyzoIU+CGUFpLn0Mvoc6oaX
         FJ9y/VKsRmZPVeQDpUkbPsl5oh9hTiCo3P2vYSvWxXqTcH2mSkKtNcUStbC8lJRu5q5h
         Qn2VV1UngHJO27UVoSYsqbv6rHHMM0CZPu3UmNcYgRmqgXlX7fMDcu51Vq5JJW2fNd7y
         70ii7KzrfDSoWTeiAgA5Dpiapl5PoJqkZbSPEnfsX4LImybSI+H51saLqt79iGRQoH69
         +G0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2N/6o0jzfm/tkHzuBi40wrgkwIvt3GRMnbzsWP+4128=;
        b=fCi1fEeWE3yGCUjpBKwBaXnK4q7apM02dwZ0lvisqS2pSI+DHzjGycwm8tKjMSWA7l
         wRgHWzPX639zdLKch64xbHgQsxNchFHCBm6e6c6cYVyKzZ1Ac/q05o/6KdmBD+/mwSeN
         0XfUBLb1qnYQvaN7rRbNoX61H9JgKxh7yewAMxfKcZzPQ34OEBCRfDcRcAJBx1APLwtW
         xWBseFLz6dANo5w8kIsGokBdu451K8Szx/EjWyBQNtA7yvS6Ex7mn/cMAizKYOW1Bahb
         HbUTtyxT6ghHoQmcRvEaCrjgWN4S1e41pz8b59V0UUGndVMDowKMvV7RBPDOTnH/oO8I
         CEeg==
X-Gm-Message-State: AOAM531r0cDYI0/9JsS3Dlt2iR3mf0xMeOdlxZaR2W1DtRCAu1+mqrUf
        ylzpqQhLwvMJ0FzIDhHm3D638j1pwfesOLh6zri6/O9Ylcc=
X-Google-Smtp-Source: ABdhPJwmCtd5kuBDpDAIXD+XiBHRfxWo0h1IDbAmxvWubhX0beFd9aDADbmmuRi2EpdIFJXaSJ/emgZMVXZr32FirWI=
X-Received: by 2002:a25:37cc:: with SMTP id e195mr22377075yba.441.1605054394658;
 Tue, 10 Nov 2020 16:26:34 -0800 (PST)
MIME-Version: 1.0
References: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com> <20201107114653.5cec9929@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107114653.5cec9929@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Tue, 10 Nov 2020 16:26:23 -0800
Message-ID: <CAG1aQhJds1-2Sgm23GXUjaRO2R+poOuKLLqp_AS2H3qEm09f_A@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: Fix upcall OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 11:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  3 Nov 2020 16:11:34 -0800 Yi-Hung Wei wrote:
> > TUNNEL_GENEVE_OPT is set on tun_flags in struct sw_flow_key when
> > a packet is coming from a geneve tunnel no matter the size of geneve
> > option is zero or not.  On the other hand, TUNNEL_VXLAN_OPT or
> > TUNNEL_ERSPAN_OPT is set when the VXLAN or ERSPAN option is available.
> > Currently, ovs kernel module only generates
> > OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS when the tun_opts_len is non-zero.
> > As a result, for a geneve packet without tun_metadata, when the packet
> > is reinserted from userspace after upcall, we miss the TUNNEL_GENEVE_OPT
> > in the tun_flags on struct sw_flow_key, and that will further cause
> > megaflow matching issue.
> >
> > This patch changes the way that we deal with the upcall netlink message
> > generation to make sure the geneve tun_flags is set consistently
> > as the packet is firstly received from the geneve tunnel in order to
> > avoid megaflow matching issue demonstrated by the following flows.
> > This issue is only observed on ovs kernel datapath.
> >
> > Consider the following two flows, and the two cases.
> > * flow1: icmp traffic from gnv0 to gnv1, without any tun_metadata
> > * flow2: icmp traffic form gnv0 to gnv1 with tun_metadata0
> >
> > Case 1)
> > Send flow2 first, and then send flow1.  When both flows are running,
> > both the following two flows are hit, which is expected.
> >
> > table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> > table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> >
> > Case 2)
> > Send flow1 first, then send flow2.  When both flows are running,
> > only the following flow is hit.
> > table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> >
> > Example flows)
> >
> > table=0, arp, actions=NORMAL
> > table=0, in_port=gnv1, icmp, action=ct(table=1)
> > table=0, in_port=gnv0, icmp  action=move:NXM_NX_TUN_METADATA0[0..7]->NXM_NX_REG9[0..7], resubmit(,1)
> > table=1, in_port=gnv1, icmp, action=output:gnv0
> > table=1, in_port=gnv0, icmp  action=ct(table=2)
> > table=2, priority=300, in_port=gnv0, icmp, ct_state=+trk+new, action=ct(commit),output:gnv1
> > table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> > table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> >
> > Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
> > Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
>
> Wouldn't it make more sense to make GENEVE behave like the other
> tunnels rather than hack this logic into consumer of the flag?

Thanks Jakub for the review.  Yes, it makes sense to fix on the tunnel
side. I submit another patch to fix it:

https://lore.kernel.org/netdev/1605053800-74072-1-git-send-email-yihung.wei@gmail.com/T/#u

> Please make sure that you CC authors of the patch you're fixing
> and the maintainers of the code you're changing.
>
> ./scripts/get_maintainer.pl is your friend.

Thanks for reminding me.  Will do that from now on.


-Yi-Hung
