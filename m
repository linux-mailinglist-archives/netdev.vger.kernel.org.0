Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C43083BD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhA2CVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2CVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D84EF64DF1;
        Fri, 29 Jan 2021 02:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886851;
        bh=gr5pyKDiwCQAiOj4B3ExUDtmL0vdJyClcFIVkgI1rDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s9KacoRhHSBvoBgJvjSb5Ef05QLfLpcWQJe0Z+da3/hnRzxrLJMyPtcSDYq2VYulW
         fBunyXc07kJKomsI5mIsfbOurnA0e83KtzJcwPrdvBHFjBFRW2u0qesH+myGWRCN0c
         KJBuJiFl1llqogrmPW2Y+rwsTz4OJ59gnAXJbhZIRhjmkelpXsYMYbSwbV55dw3ENa
         W8mtSuwqI++OB+bpxoSZFNyMeESbKj6Naf3pNB3uhaT1tQVXdnCq0pSVEQ5zu0LOB9
         KhjFOukWWEiMnTX8ZQPgo/poTaCC7A/C3tgWNrHAtztqpDs9wlzYV294Qt6Ik78MGr
         ALHYtfp7uM6zQ==
Date:   Thu, 28 Jan 2021 18:20:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>
Subject: Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow Control
 support
Message-ID: <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 20:31:04 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send pause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause is asserted.
> 
> Problem is that Packet Processor that actually can drop packets due to lack of resources not connected to the GOP flow control generation mechanism.
> To solve this issue Armada has firmware running on CM3 CPU dedicated for Flow Control support.
> Firmware monitors Packet Processor resources and asserts XON/XOFF by writing to Ports Control 0 Register.
> 
> MSS shared SRAM memory used to communicate between CM3 firmware and PP2 driver.
> During init PP2 driver informs firmware about used BM pools, RXQs, congestion and depletion thresholds.
> 
> The pause frames are generated whenever congestion or depletion in resources is detected.
> The back pressure is stopped when the resource reaches a sufficient level.
> So the congestion/depletion and sufficient level implement a hysteresis that reduces the XON/XOFF toggle frequency.
> 
> Packet Processor v23 hardware introduces support for RX FIFO fill level monitor.
> Patch "add PPv23 version definition" to differ between v23 and v22 hardware.
> Patch "add TX FC firmware check" verifies that CM3 firmware supports Flow Control monitoring.

Hi Stefan, looks like patchwork and lore didn't get all the emails:

https://lore.kernel.org/r/1611858682-9845-1-git-send-email-stefanc@marvell.com
https://patchwork.kernel.org/project/netdevbpf/list/?series=423983

Unless it fixes itself soon - please repost.
