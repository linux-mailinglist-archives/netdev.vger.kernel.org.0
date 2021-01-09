Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FBE2F03E9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhAIVwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbhAIVwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:52:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCFE23AA8;
        Sat,  9 Jan 2021 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610229080;
        bh=LBZq9Yx4eHCvMOC11KXcVtvRsAKMhqSzj6gIcOHt2Gc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hPft5sD983glw98y1heCz/DyEzMgSaUovuPSxxrVyh35ATT9PTzyczTZZEvipqZyG
         jTxN4wrEKOCH+GHWHaOBgXMPzwYKXbJrS28Q8mbrHVu5xAv7GhphtsSgjtcyROPvdx
         ng66zQkmpdJ6qJgHJLUfpr17R2cPnYeL3DRgD6tMvCH+ANTQ+8P0Hw4b98rXa1gEaK
         nQpfEW4AwcpCgMIOou1MD+Yz6hlgVIqveXXW+4KcK4ihTv1nxgPS8HlkFgsQHb0X5e
         XU88ACjsy3YNhkz2nhsSQvfPNzmDPvlbaFtpmSUoU5mTSThAd2kqJ6SpitQdJ6Zl0P
         H0Y5W11FUCozg==
Date:   Sat, 9 Jan 2021 13:51:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <irusskikh@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>
Subject: Re: [PATCH net 1/1] netxen_nic: fix MSI/MSI-x interrupts
Message-ID: <20210109135119.0ca043f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107101520.6735-1-manishc@marvell.com>
References: <20210107101520.6735-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 02:15:20 -0800 Manish Chopra wrote:
> For all PCI functions on the netxen_nic adapter, interrupt
> mode (INTx or MSI) configuration is dependent on what has
> been configured by the PCI function zero in the shared
> interrupt register, as these adapters do not support mixed
> mode interrupts among the functions of a given adapter.
> 
> Logic for setting MSI/MSI-x interrupt mode in the shared interrupt
> register based on PCI function id zero check is not appropriate for
> all family of netxen adapters, as for some of the netxen family
> adapters PCI function zero is not really meant to be probed/loaded
> in the host but rather just act as a management function on the device,
> which caused all the other PCI functions on the adapter to always use
> legacy interrupt (INTx) mode instead of choosing MSI/MSI-x interrupt mode.
> 
> This patch replaces that check with port number so that for all
> type of adapters driver attempts for MSI/MSI-x interrupt modes.
> 
> Fixes: b37eb210c076 ("netxen_nic: Avoid mixed mode interrupts")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Interesting that nobody noticed this for 7 years.

Applied, thanks.
