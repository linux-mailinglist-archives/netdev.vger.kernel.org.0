Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAFF4861A3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiAFIrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiAFIrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:47:46 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5168AC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 00:47:45 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id p13so3492499lfh.13
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 00:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7n2eemXtq8ujYgQD3jlljljhcZpN4mKArMfua7O29w=;
        b=hpRNe3RMy7A1C+QeiTa1QqYujMSXENVJgZztHXKp9H+Rk6a+UiG9gK9dl1V163f0uu
         zytO87Mxz4OLkJQizcqZ0+e/UoEWO33Hzha5m4Uh6URJTMjwkDh0mI6dRmkmwYehx7+n
         muKSuXRHSYKO5F/cLvyNMOkp4SN9FAVSWpUJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7n2eemXtq8ujYgQD3jlljljhcZpN4mKArMfua7O29w=;
        b=jnCBBkAy4JccvB7a/u82NRZZhs/qq+W3jRnliZToKBzhwsCdIZvlp/QNFDiOSV1wTZ
         HUBUkiZ8o+WlDAS3tGwrsmzXdfIIsBx5rx2Rrk1nb6Sc0muJMeMtgk7Hy5f8MVO+zsLR
         EKvQGf+2A1FUBMndt90Hwsyk7zN0+OVybTt+emA8EU0c/4O3HmcYoYU7LOIaCXUJ6m7x
         37LbRjFifGol6QlXsTw9Kl8h+Izno2Ww6EOf1cdmAn2qTeHLRvR1SjwIWcd72/hH/trY
         KyDScg2Y7LRel9lHDWJggVrzy6H1fxvaoyel+UiWrluXFhZ4hs/Y94LZvPOjGkEb7nS6
         e1yA==
X-Gm-Message-State: AOAM530DhtRn/eBdTrlz7D3YwMFqSCHu2mELIDBpbjlx38iba+gRzykU
        nrpNZN2B5v8jfKkfNx/Kp0Kv6JgDG/xAO4CnjQRAUCOLU14=
X-Google-Smtp-Source: ABdhPJzY7JFjjhvkSWt+wDmD08Yeg/2Uz2cQ9qNyz+dcvacJvCJD9oXjI3BNBqZwEkKrxo69j54E2EJGHfvVBOwZHRc=
X-Received: by 2002:a05:6512:2292:: with SMTP id f18mr48391316lfu.51.1641458863560;
 Thu, 06 Jan 2022 00:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-4-dmichail@fungible.com> <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com> <20220105094648.4ff74c9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220105094648.4ff74c9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 6 Jan 2022 00:47:29 -0800
Message-ID: <CAOkoqZmSKHD97dbyVhKw3pPNJqKS2x8PXhsPJb9dRTjoGNn31g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 9:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 5 Jan 2022 07:52:21 -0800 Dimitris Michailidis wrote:
> > On Tue, Jan 4, 2022 at 6:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon,  3 Jan 2022 22:46:52 -0800 Dimitris Michailidis wrote:
> > > > This is the first part of the Fungible ethernet driver. It deals with
> > > > device probing, net_device creation, and netdev ops.
> > >
> > > > +static int fun_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> > > > +{
> > > > +     struct bpf_prog *old_prog, *prog = xdp->prog;
> > > > +     struct funeth_priv *fp = netdev_priv(dev);
> > > > +     bool reconfig;
> > > > +     int rc, i;
> > > > +
> > > > +     /* XDP uses at most one buffer */
> > > > +     if (prog && dev->mtu > XDP_MAX_MTU) {
> > > > +             netdev_err(dev, "device MTU %u too large for XDP\n", dev->mtu);
> > > > +             NL_SET_ERR_MSG_MOD(xdp->extack,
> > > > +                                "Device MTU too large for XDP");
> > > > +             return -EINVAL;
> > > > +     }
> > > > +
> > > > +     reconfig = netif_running(dev) && (!!fp->xdp_prog ^ !!prog);
> > > > +     if (reconfig) {
> > > > +             rc = funeth_close(dev);
> > >
> > > Please rework runtime reconfig to not do the close and then open thing.
> > > This will prevent users from reconfiguring their NICs at runtime.
> > > You should allocate the resources first, then take the datapath down,
> > > reconfigure, swap and free the old resources.
> >
> > I imagine you have in mind something like nfp_net_ring_reconfig() but that
> > doesn't work as well here. We have the linux part of the data path (ring memory,
> > interrupts, etc) and the device part, handled by FW. I can't clone the device
> > portion for a quick swap during downtime. Since it involves messages to FW
> > updating the device portion is by far the bulk of the work and it needs to be
> > during the downtime. Doing Linux allocations before downtime offers little
> > improvement I think.
>
> It does - real machines running real workloads will often be under
> memory pressure. I've even seen XDP enable / disable fail just due
> to memory fragmentation, with plenty free memory when device rings
> are large.

I am in the process of changing this code.

> > There is ongoing work for FW to be able to modify live queues. When that
> > is available I expect this function will be able to move in and out of XDP with
> > no downtime.
>
> > > > +static void fun_destroy_netdev(struct net_device *netdev)
> > > > +{
> > > > +     if (likely(netdev)) {
> > >
> > > defensive programming?
> >
> > Looks that way but I'd rather have this function work with any input.
>
> There's way too much defensive programming in this driver. Unless there
> is a legit code path which can pass netdev == NULL you should remove
> the check.

OK
