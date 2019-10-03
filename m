Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7104ECAF0D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfJCTTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:19:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55289 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729174AbfJCTTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:19:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so3159655wmp.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ynCa6qmQ3diS/7pRuwbuIWzt6XPp80RSzhVVv/XY2io=;
        b=mjD73+LwPSfwt7gTdRXDipHdBDg4/zP5K4zEGBBRhPn5XgPGy93F8RKGqIL4hlteUk
         WB0rHHUxh6HIW258oTfNQDKtqKnoX96UjgzrQmLpnEcVyzDZ4pOnCF31YZ0dA82Ahi5A
         3CbA5xCIpKwD66JYQNVQfVVG3cscFkmfPrklI2kpkv0wl3wwK+Mo/ihmoQApuUNEUppx
         F53UlcoyNIfpHKzHtNQVLdzKJ1VfirD+QmSfWlOxjY55XOl0eGYL+L3FeNIeTxpbrhlC
         CNI3TY3eXhftp2V7t/ciX17zITquHduHdAIQtdIdxXEC7kHRwxN9digC1wjpsP8TLR5o
         I5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ynCa6qmQ3diS/7pRuwbuIWzt6XPp80RSzhVVv/XY2io=;
        b=m+etRKjp9XSO0ptYNFD+ZpAGUQjShOxIGn2J6HBifZpwfeC8Gmzjzbe+LyEaD5aiRN
         zxav6CZvybXfbn+0TzpcH41BHORXoe6K2VvhQly6SCEyMFzSYI2mLs8nG0Lx9krqcxpd
         sTyHF5LWKIJUuFhXSxbM/OcD94LpYyXoSUj6Uxb7cRm/iTGq49y15SFUpSWQ6m+1S0Ov
         nEZltiairO8uNIOnzNW7J0pcorlDAatGVjs4wVvMs0FInl2Fim0s91Ns0n+Y4yLoluGE
         2+GvDUVtOpvcct6Y1KNsWUe20+catWAhJ0fFyp++fdE1t9dOyVoMRxcR8VrzUsQ2DyLb
         cpfw==
X-Gm-Message-State: APjAAAXFAJXJcnk0mg6zOuFzifPeWIYNO1z9lGExc0ifsDb/GaNaCUvl
        3f5p0q9sfF6fePQ/xqFfoxENtQ==
X-Google-Smtp-Source: APXvYqyH1keHhJMitfJIleXjwG3s4yvzX+3T6jTj8dH7hG8dBqeYWmZOmWwqH9ugCEDO/G9ucMvhwA==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr7803487wmc.167.1570130340312;
        Thu, 03 Oct 2019 12:19:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 3sm2779663wmo.22.2019.10.03.12.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 12:18:59 -0700 (PDT)
Date:   Thu, 3 Oct 2019 21:18:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] net: propagate errors correctly in
 register_netdevice()
Message-ID: <20191003191858.GA2369@nanopsycho>
References: <20191003155924.71666-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003155924.71666-1-edumazet@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 03, 2019 at 05:59:24PM CEST, edumazet@google.com wrote:
>If netdev_name_node_head_alloc() fails to allocate
>memory, we absolutely want register_netdevice() to return
>-ENOMEM instead of zero :/

oops.


>
>One of the syzbot report looked like :
>
>general protection fault: 0000 [#1] PREEMPT SMP KASAN
>CPU: 1 PID: 8760 Comm: syz-executor839 Not tainted 5.3.0+ #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>RIP: 0010:ovs_vport_add+0x185/0x500 net/openvswitch/vport.c:205
>Code: 89 c6 e8 3e b6 3a fa 49 81 fc 00 f0 ff ff 0f 87 6d 02 00 00 e8 8c b4 3a fa 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 02 00 00 49 8d 7c 24 08 49 8b 34 24 48 b8 00
>RSP: 0018:ffff88808fe5f4e0 EFLAGS: 00010247
>RAX: dffffc0000000000 RBX: ffffffff89be8820 RCX: ffffffff87385162
>RDX: 0000000000000000 RSI: ffffffff87385174 RDI: 0000000000000007
>RBP: ffff88808fe5f510 R08: ffff8880933c6600 R09: fffffbfff14ee13c
>R10: fffffbfff14ee13b R11: ffffffff8a7709df R12: 0000000000000004
>R13: ffffffff89be8850 R14: ffff88808fe5f5e0 R15: 0000000000000002
>FS:  0000000001d71880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 0000000020000280 CR3: 0000000096e4c000 CR4: 00000000001406e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>Call Trace:
> new_vport+0x1b/0x1d0 net/openvswitch/datapath.c:194
> ovs_dp_cmd_new+0x5e5/0xe30 net/openvswitch/datapath.c:1644
> genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
> genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
> netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
> genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
> netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
> netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
> sock_sendmsg_nosec net/socket.c:637 [inline]
> sock_sendmsg+0xd7/0x130 net/socket.c:657
> ___sys_sendmsg+0x803/0x920 net/socket.c:2311
> __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
> __do_sys_sendmsg net/socket.c:2365 [inline]
> __se_sys_sendmsg net/socket.c:2363 [inline]
> __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
>
>Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Reported-by: syzbot <syzkaller@googlegroups.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
