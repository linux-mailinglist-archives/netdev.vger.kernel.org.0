Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE73480E02
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 00:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhL1X6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 18:58:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34138 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhL1X6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 18:58:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54CB16134B
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 23:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FA3C36AE9;
        Tue, 28 Dec 2021 23:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640735926;
        bh=8gcRmI45+9uXEVIHM0n1M0YbG4yKXvMe/t7pJAf97aE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cui4ha2GrK5NzS04TsAch0aP/8GimI/k2AaZ9I7xFCzCsgSLrr6fcqQ4pmg1dfUEz
         Y/y2ho6fRqO4uArCXjzT7ONMPcGdb/WfDNSd8f0NWFjuNc81j5yVYuUWWG2Q+KuIkU
         SCuv29bIAG//rdWvHi1Tc7XZ8KCkJ/6I1Wi3/9/JXx6ceMIvl0RSrR1BRW2LpSqkJH
         hoth2QRpznXuJhVNPEq7pB9l1MhsniHX32Fv6a4RbGdBnJfsMeb6mMJcLqsRCt1twl
         9IXPFgJ0ct7KRd0uiD26EPo0eDq7GL15NbbPK4S6c7y9EvYavBVY4oRgmt2CMTohDn
         Jb/O54Ah3sbHA==
Date:   Tue, 28 Dec 2021 15:58:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] r8169: don't use pci_irq_vector() in atomic
 context
Message-ID: <20211228155845.2609de2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <70cd60cd-5472-25b6-91f5-a2d313dc6294@gmail.com>
References: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
        <70cd60cd-5472-25b6-91f5-a2d313dc6294@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 23:11:47 +0100 Heiner Kallweit wrote:
> On 28.12.2021 22:02, Heiner Kallweit wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Since referenced change pci_irq_vector() can't be used in atomic
> > context any longer. This conflicts with our usage of this function
> > in rtl8169_netpoll(). Therefore store the interrupt number in
> > struct rtl8169_private.
> > 
> > Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")  
> 
> Seeing the "fail" in patchwork: The referenced commit just recently
> showed up in linux-next and isn't in net-next yet.

Thanks for the heads up, looks safe to apply.
