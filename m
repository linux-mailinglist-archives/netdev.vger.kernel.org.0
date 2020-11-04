Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DE02A5C0B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgKDBif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:38:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:38:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C245223C7;
        Wed,  4 Nov 2020 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453914;
        bh=jQgE/0pucSK3LjEq/yuZZ4XSP3lXt1KAarBQYP4Mnik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gy2U9jwsZvAofnWPSB0U9KmT+hyhssTCdqVaJ99WWd3oKLH+YKSVKmNJ6wgAC5lYG
         9JZJXomS6E1OPsKbH8Uisc3/DBdJzZl2P9uCXEtMMRflOIDv2hkMeLJwRH8Y7FJ/5b
         nYxcu5RT/CJUJe/nr39+w6CqwZt/O0olp66DfFVU=
Date:   Tue, 3 Nov 2020 17:38:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     andrew@lunn.ch, Markus.Elfring@web.de,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lan743x: fix for potential NULL pointer dereference
 with bare card
Message-ID: <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201101223556.16116-1-sbauer@blackbox.su>
References: <220201101203820.GD1109407@lunn.ch>
        <20201101223556.16116-1-sbauer@blackbox.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 01:35:55 +0300 Sergej Bauer wrote:
> This is the 3rd revision of the patch fix for potential null pointer dereference
> with lan743x card.
> 
> The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
> commant where ethN is the interface with lan743x card. Example:
> 
> $ sudo ethtool eth7
> dmesg:
> [  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
> ...
> [  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
> ...
> [  103.511629] Call Trace:
> [  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
> [  103.511724]  dev_ethtool+0x1507/0x29d0
> [  103.511769]  ? avc_has_extended_perms+0x17f/0x440
> [  103.511820]  ? tomoyo_init_request_info+0x84/0x90
> [  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
> [  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
> [  103.511973]  ? inet_ioctl+0x187/0x1d0
> [  103.512016]  dev_ioctl+0xb5/0x560
> [  103.512055]  sock_do_ioctl+0xa0/0x140
> [  103.512098]  sock_ioctl+0x2cb/0x3c0
> [  103.512139]  __x64_sys_ioctl+0x84/0xc0
> [  103.512183]  do_syscall_64+0x33/0x80
> [  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  103.512274] RIP: 0033:0x7f54a9cba427

Applied, thanks!
