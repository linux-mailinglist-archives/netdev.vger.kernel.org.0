Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5DB2A6E4E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgKDTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:46:48 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:60412 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKDTqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 14:46:48 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id D857982D09;
        Wed,  4 Nov 2020 22:46:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blackbox.su;
        s=201811; t=1604519208;
        bh=Wl6jFLMihoNHO2Bwe8IWK0SHn3NOrqmaBZlfC3hUrls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRQ2JmzXv52J8V1gZdmJ+zv9EMM0n+6F5VPaaffvldcIxmW9bqmWAY1uRCP6IHv81
         XLId0TauVuWi8SGtZKcqaiZMnT7ycs7Huo7wyndMibbp84dkA6YZdt+6jch8kQvQME
         zdyqgKtRubPcIfZwBdO8JitPbY6kVdY81IJkZUXAygrfR3ARt5J77XEH/eskZIrS9p
         qgD7sEuiXPdg/pDeofWlagQJm9UKltD2HeZ1sOCoVqe8xT1XlgbWykqGOPOPsY4OdC
         PIio3wWUATRr3j6VPrvnz/Hh5ZvM9+8E+QmKakAV/fJhrEYgQ4Ygd5dVNeFsl0vOYw
         BflKPcu84PDOw==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew@lunn.ch, Markus.Elfring@web.de,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Wed, 04 Nov 2020 22:46:35 +0300
Message-ID: <2039725.TBXjNvtEQf@metabook>
In-Reply-To: <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <220201101203820.GD1109407@lunn.ch> <20201101223556.16116-1-sbauer@blackbox.su> <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 4, 2020 4:38:33 AM MSK Jakub Kicinski wrote:
> On Mon,  2 Nov 2020 01:35:55 +0300 Sergej Bauer wrote:
> > This is the 3rd revision of the patch fix for potential null pointer
> > dereference with lan743x card.
> > 
> > The simpliest way to reproduce: boot with bare lan743x and issue "ethtool
> > ethN" commant where ethN is the interface with lan743x card. Example:
> > 
> > $ sudo ethtool eth7
> > dmesg:
> > [  103.510336] BUG: kernel NULL pointer dereference, address:
> > 0000000000000340 ...
> > [  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
> > ...
> > [  103.511629] Call Trace:
> > [  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
> > [  103.511724]  dev_ethtool+0x1507/0x29d0
> > [  103.511769]  ? avc_has_extended_perms+0x17f/0x440
> > [  103.511820]  ? tomoyo_init_request_info+0x84/0x90
> > [  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
> > [  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
> > [  103.511973]  ? inet_ioctl+0x187/0x1d0
> > [  103.512016]  dev_ioctl+0xb5/0x560
> > [  103.512055]  sock_do_ioctl+0xa0/0x140
> > [  103.512098]  sock_ioctl+0x2cb/0x3c0
> > [  103.512139]  __x64_sys_ioctl+0x84/0xc0
> > [  103.512183]  do_syscall_64+0x33/0x80
> > [  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [  103.512274] RIP: 0033:0x7f54a9cba427
> 
> Applied, thanks!

Hi, Jakub!
Thank you for taking the time to review my patch

                Regards,
                        Sergej.



