Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A874C324807
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhBYAsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:48:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236366AbhBYAsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:48:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B22DA6146B;
        Thu, 25 Feb 2021 00:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614214044;
        bh=v9Cemz6+5QAlytl+WWIeYFPOPcg34dVPzVpn7Ai5Kbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MbLCz8HFy4albGGaAxeg4DicoNj4dZI5iynJgXU/NsF8WsILKvj+eqHB9Vphr5thB
         a+v8u35WFikt58r/new7tuteQEpeXz0BPZda2yKfwfAXywmHnlGc8GdcXjW/DHn4f8
         9S/m2GeerM10HksfNa/H89VAgmt8HzUYiUrjVK13ZRxb+QA6lCQKqbeZPTjwdBDVlb
         MaVHRzW29g0Q/aD6awdU3cHJniScZwcYcR1Opfy/gYImRqa4Wp+qM3NWbSaCDYrdmA
         h4+gY6mCiZcqGJrFctn8iIDBaQStqYzHlDaLRoNhnUfadNgwTrmxX83v4Tafma2exe
         6ZCL5ZFfEF05A==
Date:   Wed, 24 Feb 2021 16:47:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     netdev@vger.kernel.org, kexec@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] i40e: don't open i40iw client for kdump
Message-ID: <20210224164720.2228c580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225002101.hvbpq7f6zbvylqy4@Rk>
References: <20210222070701.16416-1-coxu@redhat.com>
        <20210222070701.16416-5-coxu@redhat.com>
        <20210223122207.08835e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210224114141.ziywca4dvn5fs6js@Rk>
        <20210224084841.50620776@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210225002101.hvbpq7f6zbvylqy4@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 08:21:01 +0800 Coiby Xu wrote:
> On Wed, Feb 24, 2021 at 08:48:41AM -0800, Jakub Kicinski wrote:
> >On Wed, 24 Feb 2021 19:41:41 +0800 Coiby Xu wrote:  
> >> I'm not sure if I understand you correctly. Do you mean we shouldn't
> >> disable i40iw for kdump?  
> >
> >Forgive my ignorance - are the kdump kernels separate builds?
> 
> AFAIK we don't build a kernel exclusively for kdump. 
> 
> >If they are it'd be better to leave the choice of enabling RDMA
> >to the user - through appropriate Kconfig options.
> 
> i40iw is usually built as a loadable module. So if we want to leave the
> choce of enabling RDMA to the user, we could exclude this driver when
> building the initramfs for kdump, for example, dracut provides the 
> omit_drivers option for this purpose. 
> 
> On the other hand, the users expect "crashkernel=auto" to work out of
> the box. So i40iw defeats this purpose. 
> 
> I'll discuss with my Red Hat team and the Intel team about whether RDMA
> is needed for kdump. Thanks for bringing up this issue!

Great, talking to experts here at FB it seems that building a cut-down
kernel for kdump is easier than chasing all the drivers to react to
is_kdump_kernel(). But if you guys need it and Intel is fine with 
the change I won't complain.
