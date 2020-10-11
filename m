Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB4D28AB04
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387790AbgJKWzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgJKWzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:55:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899B32076E;
        Sun, 11 Oct 2020 22:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602456941;
        bh=KvDRy898tZkJV1H44iDrW5fdptEiyvUv8AeifK7jE9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q0mFFIyvRoV278p7Jk5P76lPAglEnFI38QGRWSs8ljqd2iW/PFeTBxkEaljMTDFJX
         1aIXMTh3LDQ3nPAcR5Pq9zsxaGbgo2Cv3Vto0pus0aVfdohHh10BlqyAG/nwsPbQoR
         HCF8yIh0NI4rovD880UL20ZS/djeYJjlQlDErT/c=
Date:   Sun, 11 Oct 2020 15:55:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ondrej Zary <linux@zary.sk>
Cc:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cx82310_eth: re-enable ethernet mode after router
 reboot
Message-ID: <20201011155539.315bf5aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010140048.12067-1-linux@zary.sk>
References: <20201010140048.12067-1-linux@zary.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 16:00:46 +0200 Ondrej Zary wrote:
> When the router is rebooted without a power cycle, the USB device
> remains connected but its configuration is reset. This results in
> a non-working ethernet connection with messages like this in syslog:
> 	usb 2-2: RX packet too long: 65535 B
> 
> Re-enable ethernet mode when receiving a packet with invalid size of
> 0xffff.

Patch looks good, but could you explain what's a reboot without a power
cycle in this case? The modem gets reset but USB subsystem doesn't know
it and doesn't go though a unbind() + bind() cycle?
