Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0770F2BB64A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgKTULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgKTULw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 15:11:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5962245F;
        Fri, 20 Nov 2020 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605903111;
        bh=kCZ23Bf8TNqwuPBL3goFd1fhfRWl9LKTORwLmhSuaDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zc7tcebxyPeE5EX9jVTfnL8dH10kjF17q+a5P5AkodysIb1skznNyybvGoFEp6td5
         EdwVJGwrF+ytWwyB86pwtiZR6tBEtVubnKYFoX5/IHlI+NFq72ZSiv1SIRXS/qfxig
         KjTRE/ulciKYiC+addawXvx6DkiSsZSTrLjok5Fs=
Date:   Fri, 20 Nov 2020 12:11:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>, <ymarkman@marvell.com>
Subject: Re: [PATCH] net: mvpp2: divide fifo for dts-active ports only
Message-ID: <20201120121150.4347bb76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605723656-1276-1-git-send-email-stefanc@marvell.com>
References: <1605723656-1276-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 20:20:56 +0200 stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Tx/Rx FIFO is a HW resource limited by total size, but shared
> by all ports of same CP110 and impacting port-performance.
> Do not divide the FIFO for ports which are not enabled in DTS,
> so active ports could have more FIFO.
> 
> The active port mapping should be done in probe before FIFO-init.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

Looks good to me, but it seems you're missing more people from the CC
list.

Could you please repost and CC at least Russell?

Russell King <rmk+kernel@armlinux.org.uk>

scripts/get_maintainer.pl is your friend.

> +static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
> +{
> +	int port, size;
> +	unsigned long port_map;
> +	int remaining_ports_count;
> +	int size_remainder;

>  static void mvpp22_tx_fifo_init(struct mvpp2 *priv)
>  {
> +	int port, size;
> +	unsigned long port_map;
> +	int remaining_ports_count;
> +	int size_remainder;

Since you're reposting please reorder the variable declaration lines
longest to shortest (reverse xmas tree).
