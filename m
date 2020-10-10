Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3D28A3C2
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389986AbgJJW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732255AbgJJTyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082792242F;
        Sat, 10 Oct 2020 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602349173;
        bh=zdnFps3CzCUlnTgfjVcd7CjD9ds3BSlytH52crD8Aa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VhD7iw2pL3eWIbAuUi4Q+/Bz8VIxfgPZqMk4f68r5HNAL7VdOoLfiP+OEe4p6KFFZ
         O/kbQyaPj6QGBJBTktsu9nPYPZup87CdfK5mWzexa4gtdjUVJi3p06r3mfUEHdGp9o
         yIkoxThpm9buzGfsaOY7ygGCcNB3d/VX9pFe5Alc=
Date:   Sat, 10 Oct 2020 09:59:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC
 addresses
Message-ID: <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 12:14:59 +0530 Anant Thazhemadam wrote:
> get_registers() directly returns the return value of
> usb_control_msg_recv() - 0 if successful, and negative error number 
> otherwise.

Are you expecting Greg to take this as a part of some USB subsystem
changes? I don't see usb_control_msg_recv() in my tree, and the
semantics of usb_control_msg() are not what you described.

> However, in set_ethernet_addr(), this return value is incorrectly 
> checked.
> 
> Since this return value will never be equal to sizeof(node_id), a 
> random MAC address will always be generated and assigned to the 
> device; even in cases when get_registers() is successful.
> 
> Correctly modifying the condition that checks if get_registers() was 
> successful or not fixes this problem, and copies the ethernet address
> appropriately.
> 
> Fixes: f45a4248ea4c ("set random MAC address when set_ethernet_addr() fails")
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

The fixes tag does not follow the standard format:

Fixes tag: Fixes: f45a4248ea4c ("set random MAC address when set_ethernet_addr() fails")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'


Please put the relevant maintainer in the To: field of the email, and
even better - also mark the patch as [PATCH net], since it's a
networking fix.
