Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBA32DB84C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgLPBNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgLPBNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:13:23 -0500
Date:   Tue, 15 Dec 2020 17:12:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608081163;
        bh=PNXJnCiJbDnff7lia+DRPKNBg3Kqv5ZuJwUxkXEkup4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdaDQBja4CP2DgQPFyJB8GuaXfxgUszMZDVvPx3+pBx3jb3tBIzzzhz6U+1X7FJUV
         jiVuoyRAmCaKjCoYnxrZcJUeDzJTbxL52ojVEfBqn8SH92hNNqqniQX6xog+oxOUgx
         YKxmbU7/6Up8vSG3sSfrYikPfinT98941W0Ncxg/dm/EDLkZW/brOCLDyfcGZJ38la
         E5MRONu2NHWG9rVXpxqSP17MwhBSFO+fWt+go/VTQf8bpRZvHizlQ6GigeNy41l6He
         PlXCD6UjPXzaketvvvki9lA25AO197BIxh4JnGEJFh8d/5H5G4ZRnLJDYdfxBdyUuF
         YEWIoZWM2+g1w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Sergej Bauer <sbauer@blackbox.su>, andrew@lunn.ch,
        Markus.Elfring@web.de, thesven73@gmail.com,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] lan743x: fix for potential NULL pointer dereference
 with bare card
Message-ID: <20201215171242.622435e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160807555409.8012.8873780215201516945.git-patchwork-notify@kernel.org>
References: <20201215161252.8448-1-sbauer@blackbox.su>
        <160807555409.8012.8873780215201516945.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 23:39:14 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to bpf/bpf.git (refs/heads/master):
> 
> On Tue, 15 Dec 2020 19:12:45 +0300 you wrote:
> > This is the 4th revision of the patch fix for potential null pointer dereference
> > with lan743x card.
> > 
> > The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
> > command where ethN is the interface with lan743x card. Example:
> > 
> > $ sudo ethtool eth7
> > dmesg:
> > [  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
> > ...
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
> > ...
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [v4] lan743x: fix for potential NULL pointer dereference with bare card
>     https://git.kernel.org/bpf/bpf/c/e9e13b6adc33
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 

Heh the bot got confused, I think.

What I meant when I said "let's wait for the merge window" was that
the patch will not hit upstream until the merge window. It's now in
Linus's tree. I'll make a submission of stable patches to Greg at the
end of the week and I'll include this patch.

Thanks!
