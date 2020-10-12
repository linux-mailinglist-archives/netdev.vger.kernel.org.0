Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4B328BEAE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404023AbgJLRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403845AbgJLRHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 13:07:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA9620735;
        Mon, 12 Oct 2020 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602522472;
        bh=1qZ/2HeKImHa8M4Zw9hd9GhiiOJB0JQGkiplbKu7jW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V92LgSkrwZuFJUsD7b6r1WxpcD6BCSDF5mMo8T7YWmbEI7E5VrpZjEKYHPCqvxbtH
         2Pjpx8FnsbXfoBIdnNoXj1zidzCbyARxVT+YnL/qbZovy/8YNHcz+J6Zjwp1KE+Y3V
         HLzDetRy2LdqVK0smab/F6grotH4HXFJa3gn3Vm8=
Date:   Mon, 12 Oct 2020 10:07:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: korina: fix kfree of rx/tx descriptor array
Message-ID: <20201012100750.125a55ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSfFcyVPd3Tr=wFSfSFBojpXPMZGmPvS0m+iM4TiRpsM5w@mail.gmail.com>
References: <20201011212135.GD8773@valentin-vidic.from.hr>
        <20201011220329.13038-1-vvidic@valentin-vidic.from.hr>
        <CA+FuTSfFcyVPd3Tr=wFSfSFBojpXPMZGmPvS0m+iM4TiRpsM5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 18:53:31 -0400 Willem de Bruijn wrote:
> On Sun, Oct 11, 2020 at 6:04 PM Valentin Vidic wrote:
> > kmalloc returns KSEG0 addresses so convert back from KSEG1
> > in kfree. Also make sure array is freed when the driver is
> > unloaded from the kernel.
> >
> > Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
> > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>  
> 
> Ah, this a MIPS architecture feature, both KSEGs mapping the same
> region, just cachable vs non-cachable.
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thank you!
