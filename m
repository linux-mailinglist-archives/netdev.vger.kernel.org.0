Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DC3F3857
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 05:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhHUDpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 23:45:02 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55370 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229610AbhHUDpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 23:45:00 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17L3hoN2017864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 23:43:51 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6D62315C3DBB; Fri, 20 Aug 2021 23:43:50 -0400 (EDT)
Date:   Fri, 20 Aug 2021 23:43:50 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+13146364637c7363a7de@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, adilger.kernel@dilger.ca, arnd@arndb.de,
        b.a.t.m.a.n@lists.open-mesh.org, christian@brauner.io,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in
 ext4_write_inline_data_end
Message-ID: <YSB2dsveNTr9G3Mq@mit.edu>
References: <000000000000e5080305c9e51453@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e5080305c9e51453@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 01:10:18AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    614cb2751d31 Merge tag 'trace-v5.14-rc6' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=130112c5300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f61012d0b1cd846f
> dashboard link: https://syzkaller.appspot.com/bug?extid=13146364637c7363a7de
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104d7cc5300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1333ce0e300000
> 
> The issue was bisected to:
> 
> commit a154d5d83d21af6b9ee32adc5dbcea5ac1fb534c
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Mon Mar 4 20:38:03 2019 +0000
> 
>     net: ignore sysctl_devconf_inherit_init_net without SYSCTL
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f970b6300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=100570b6300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17f970b6300000

In case it wasn't obvious, this is a bogus bisection.  It's a bug
ext4's inline_data support where there is a race between writing to an
inline_data file against setting extended attributes on that same
inline_data file.

Fix is coming up....

					- Ted
