Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC922A05B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbgGVT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbgGVT4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 15:56:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195A220771;
        Wed, 22 Jul 2020 19:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595447811;
        bh=Z/AHMii5bCGoWN348c+nulGHYrPJSQQPsAhIr4x9AN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zZB4xflL8algsyiFsw3DbFhFiWkJlHsTjXXZrequeGCSEIdjOT4EGCWeS7koYSqWt
         SWfRxquzbV5Np6JPYP6oDjjD6V144RBDhbd6s+Gknnxlx/YS+aen/O/bTh2Jt+F+8M
         u7YM42sJsAJxbmZMsjYJtfgOaOtrAXMHw3mv7e5I=
Date:   Wed, 22 Jul 2020 12:56:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+a41f2e0a3a2dad7febb0@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: general protection fault in udp_tunnel_notify_del_rx_port
Message-ID: <20200722125649.57ae6342@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000da8ee505ab07b2e0@google.com>
References: <000000000000da8ee505ab07b2e0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 06:27:17 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    88825726 Merge tag 'drm-fixes-2020-07-17-1' of git://anong..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=143518bb100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
> dashboard link: https://syzkaller.appspot.com/bug?extid=a41f2e0a3a2dad7febb0
> compiler:       gcc (GCC) 10.1.0-syz 20200507

FWIW I had a look and it appears that this is not really related to
udp_tunnel_notify_del_rx_port() in any way. Seems a netdev or its
ops get corrupted and udp_tunnel_notify_del_rx_port() just runs into
that.
