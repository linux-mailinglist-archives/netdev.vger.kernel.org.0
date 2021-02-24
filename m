Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3932427C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhBXQtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231274AbhBXQt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 11:49:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B8AC64F04;
        Wed, 24 Feb 2021 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614185325;
        bh=bkI+7jdAkAKPzrBha5mtz/S+U24xvZbTS+QNnlrcp/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lESkDNtgLdaUKCI1sXJmDOGuVp2xbhwwB/d7p4bdpkvP5uERgvycaRqgkTCwlotqH
         w2yfc0m+U+oOCfKy4pYo0jP7V/HmR0F8+LI0rNvjxtlspJmS8LCh6f75l7CtXJDyZ2
         ZDVfJmhEKGE321/Og9QfA+TRaFwcqB+tTc/LVIMp6DHaeReNHK3KQyuC4smx9tpbvg
         f56F73rDhI9D5AEPC8DlrzThsG4TVlXP2gNT2X7ysQFmxaTiP7XJvp1m+/tduKSe0D
         YXR9Y16Yv83MjDRBwTPfc5sd/EQ1mroaNFU4S2s/4DhEM4iMrsdBRvdxUe4bOnUhxD
         9rq8E/6U830tQ==
Date:   Wed, 24 Feb 2021 08:48:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     netdev@vger.kernel.org, kexec@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] i40e: don't open i40iw client for kdump
Message-ID: <20210224084841.50620776@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224114141.ziywca4dvn5fs6js@Rk>
References: <20210222070701.16416-1-coxu@redhat.com>
        <20210222070701.16416-5-coxu@redhat.com>
        <20210223122207.08835e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210224114141.ziywca4dvn5fs6js@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 19:41:41 +0800 Coiby Xu wrote:
> On Tue, Feb 23, 2021 at 12:22:07PM -0800, Jakub Kicinski wrote:
> >On Mon, 22 Feb 2021 15:07:01 +0800 Coiby Xu wrote:  
> >> i40iw consumes huge amounts of memory. For example, on a x86_64 machine,
> >> i40iw consumed 1.5GB for Intel Corporation Ethernet Connection X722 for
> >> for 1GbE while "craskernel=auto" only reserved 160M. With the module
> >> parameter "resource_profile=2", we can reduce the memory usage of i40iw
> >> to ~300M which is still too much for kdump.
> >>
> >> Disabling the client registration would spare us the client interface
> >> operation open , i.e., i40iw_open for iwarp/uda device. Thus memory is
> >> saved for kdump.
> >>
> >> Signed-off-by: Coiby Xu <coxu@redhat.com>  
> >
> >Is i40iw or whatever the client is not itself under a CONFIG which
> >kdump() kernels could be reasonably expected to disable?
> >  
> 
> I'm not sure if I understand you correctly. Do you mean we shouldn't
> disable i40iw for kdump?

Forgive my ignorance - are the kdump kernels separate builds?

If they are it'd be better to leave the choice of enabling RDMA 
to the user - through appropriate Kconfig options.
