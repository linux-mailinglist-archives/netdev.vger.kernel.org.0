Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF393D153A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhGUQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:59:52 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53004 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhGUQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:59:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A87E122520;
        Wed, 21 Jul 2021 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1626889226;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85BHpZLL0H83v1eMB3xzdgdujQpVmYPD1024DoXuByc=;
        b=INWkqiMddTno7dIIbcXXtGqsKVeaFHSxpU5m7x3mrE+0TViYlEYm7jMTZauKEgm26BwQDe
        VXCrr18KejaCncjQmZa4PIQmQijXUZrH8HH0yTmfJt2M3xEt/KDWxt73hWVp2ZeA8CPUXj
        3Cu7YfntsZOserwgDXfiKznSEoUqyVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1626889226;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85BHpZLL0H83v1eMB3xzdgdujQpVmYPD1024DoXuByc=;
        b=Dm71XMgmde2ilmAULuuuu6JqReMaz91Rr6w1tuRwqo9cfXndn8idy1AxbSQMiQJ91TLz/W
        eebsPjMx3ic1i5Bw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 298D1A3B83;
        Wed, 21 Jul 2021 17:40:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2F9EDA704; Wed, 21 Jul 2021 19:37:44 +0200 (CEST)
Date:   Wed, 21 Jul 2021 19:37:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     syzbot <syzbot+45d7c243c006f39dc55a@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, anand.jain@oracle.com,
        b.a.t.m.a.n@lists.open-mesh.org, catalin.marinas@arm.com,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com,
        johannes@sipsolutions.net, josef@toxicpanda.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        will.deacon@arm.com, will@kernel.org, zlim.lnx@gmail.com
Subject: Re: [syzbot] WARNING in sta_info_alloc
Message-ID: <20210721173744.GN19710@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        syzbot <syzbot+45d7c243c006f39dc55a@syzkaller.appspotmail.com>,
        a@unstable.cc, anand.jain@oracle.com,
        b.a.t.m.a.n@lists.open-mesh.org, catalin.marinas@arm.com,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com,
        johannes@sipsolutions.net, josef@toxicpanda.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        will.deacon@arm.com, will@kernel.org, zlim.lnx@gmail.com
References: <00000000000055e16405b0fc1a90@google.com>
 <0000000000007cbbcd05c745a560@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007cbbcd05c745a560@google.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 04:07:06PM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 282ab3ff16120ec670fe3330e85f8ebf13092f21
> Author: David Sterba <dsterba@suse.com>
> Date:   Mon Oct 14 12:38:33 2019 +0000
> 
>     btrfs: reduce compressed_bio members' types
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d5f6f2300000
> start commit:   7f75285ca572 Merge tag 'for-5.12/dm-fixes-3' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
> dashboard link: https://syzkaller.appspot.com/bug?extid=45d7c243c006f39dc55a
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164f385ad00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1427af9ad00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: btrfs: reduce compressed_bio members' types
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That's completely unrelated and probably result of unreliable
biscection. There's a different patch referenced in the dashboard

https://groups.google.com/g/syzkaller-lts-bugs/c/ntHpclbYBMM/m/WG3hW1DvAgAJ

  commit 25487a5ff100398cb214ae854358609e4bbd4e7d
  Author: Johannes Berg <johann...@intel.com>
  Date: Mon May 17 14:47:17 2021 +0000

  mac80211: remove warning in ieee80211_get_sband()

that looks more relevant but I don't know if it's the real fix.
